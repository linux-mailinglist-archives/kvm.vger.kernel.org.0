Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95263B9427
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 17:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhGAPnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 11:43:41 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:51776 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbhGAPnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 11:43:40 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0F96E22909;
        Thu,  1 Jul 2021 15:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sg/MPDdfzyZdMo3ZbTgqHmi406FJ3IChSrw83ciO1XY=;
        b=EWYiu5lw7FznMp2Emrpoz+a1vQ3oTdcS+r1oFSCU6vYEaTrZiXj+aiT3STmPX1p3WZl7PK
        Q5LsvCG4bEObk3ktYdE4nwvJpz+5S5gnMdyqiFeOICUw+F4OpCW7iIdQkDrDuGzczWko3v
        QRNx6UIlow+x0tIbYZiWlBH58pZPgvI=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A900D11CD6;
        Thu,  1 Jul 2021 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625154069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sg/MPDdfzyZdMo3ZbTgqHmi406FJ3IChSrw83ciO1XY=;
        b=EWYiu5lw7FznMp2Emrpoz+a1vQ3oTdcS+r1oFSCU6vYEaTrZiXj+aiT3STmPX1p3WZl7PK
        Q5LsvCG4bEObk3ktYdE4nwvJpz+5S5gnMdyqiFeOICUw+F4OpCW7iIdQkDrDuGzczWko3v
        QRNx6UIlow+x0tIbYZiWlBH58pZPgvI=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id mC4MKBTi3WAOFwAALh3uQQ
        (envelope-from <jgross@suse.com>); Thu, 01 Jul 2021 15:41:08 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/6] x86/kvm: fix vcpu-id indexed array sizes
Date:   Thu,  1 Jul 2021 17:41:00 +0200
Message-Id: <20210701154105.23215-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701154105.23215-1-jgross@suse.com>
References: <20210701154105.23215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_MAX_VCPU_ID is the maximum vcpu-id of a guest, and not the number
of vcpu-ids. Fix array indexed by vcpu-id to have KVM_MAX_VCPU_ID+1
elements.

Note that this is currently no real problem, as KVM_MAX_VCPU_ID is
an odd number, resulting in always enough padding being available at
the end of those arrays.

Nevertheless this should be fixed in order to avoid rare problems in
case someone is using an even number for KVM_MAX_VCPU_ID.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/kvm/ioapic.c | 2 +-
 arch/x86/kvm/ioapic.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 698969e18fe3..ff005fe738a4 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 660401700075..11e4065e1617 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -43,13 +43,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID];
+	u8 vectors[KVM_MAX_VCPU_ID + 1];
 };
 
 
-- 
2.26.2

