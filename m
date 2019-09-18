Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 891F7B6426
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbfIRNPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 09:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfIRNPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 09:15:51 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFF972067B;
        Wed, 18 Sep 2019 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568812551;
        bh=wdv0YRFrnwocEp/J8v75uH7+80bZiAugwxHW/XSKkOQ=;
        h=From:To:Cc:Subject:Date:From;
        b=WG8IjvxASneWPVKCuK2j4lojJ8lyWBz8byWFLNq4gLQ7fbZmRtmpSudO7gBlXgeCl
         +FG7r+4UAC6/V1tGIvd4fodNE4EpwKRiKUdjUyo+UxcZnR86f34igN5JchBAfAA2ZN
         Y8C20v+JzeegvOFcLwOEjuHHQLzTQ2ehwDhqXHOo=
From:   Will Deacon <will@kernel.org>
To:     kvm@vger.kernel.org
Cc:     kernellwp@gmail.com, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "# 5 . 2 . y" <stable@kernel.org>
Subject: [PATCH] kvm: Ensure writes to the coalesced MMIO ring are within bounds
Date:   Wed, 18 Sep 2019 14:15:45 +0100
Message-Id: <20190918131545.6405-1-will@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When records are written to the coalesced MMIO ring in response to a
vCPU MMIO exit, the 'ring->last' field is used to index the ring buffer
page. Although we hold the 'kvm->ring_lock' at this point, the ring
structure is mapped directly into the host userspace and can therefore
be modified to point at arbitrary pages within the kernel.

Since this shouldn't happen in normal operation, simply bound the index
by KVM_COALESCED_MMIO_MAX to contain the accesses within the ring buffer
page.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <stable@kernel.org> # 5.2.y
Fixes: 5f94c1741bdc ("KVM: Add coalesced MMIO support (common part)")
Reported-by: Bill Creasey <bcreasey@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

I think there are some other fixes kicking around for this, but they
still rely on 'ring->last' being stable, which isn't necessarily the
case. I'll send the -stable backport for kernels prior to 5.2 once this
hits mainline.

 virt/kvm/coalesced_mmio.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5294abb3f178..09b3e4421550 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -67,6 +67,7 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+	u32 last;
 
 	if (!coalesced_mmio_in_range(dev, addr, len))
 		return -EOPNOTSUPP;
@@ -79,13 +80,13 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 	}
 
 	/* copy data in first free entry of the ring */
-
-	ring->coalesced_mmio[ring->last].phys_addr = addr;
-	ring->coalesced_mmio[ring->last].len = len;
-	memcpy(ring->coalesced_mmio[ring->last].data, val, len);
-	ring->coalesced_mmio[ring->last].pio = dev->zone.pio;
+	last = ring->last % KVM_COALESCED_MMIO_MAX;
+	ring->coalesced_mmio[last].phys_addr = addr;
+	ring->coalesced_mmio[last].len = len;
+	memcpy(ring->coalesced_mmio[last].data, val, len);
+	ring->coalesced_mmio[last].pio = dev->zone.pio;
 	smp_wmb();
-	ring->last = (ring->last + 1) % KVM_COALESCED_MMIO_MAX;
+	ring->last = (last + 1) % KVM_COALESCED_MMIO_MAX;
 	spin_unlock(&dev->kvm->ring_lock);
 	return 0;
 }
-- 
2.23.0.351.gc4317032e6-goog

