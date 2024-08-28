Return-Path: <kvm+bounces-25288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EB62962F93
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 20:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0FEFAB21F00
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 18:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FC41AB534;
	Wed, 28 Aug 2024 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v1bOuD6n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3781AB50D
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724868896; cv=none; b=BbeR4GKhq/qLcIwSii6E22LOm4W56KEW6OYiiySojbHkzu05DJnUw9/0Ajast+9aMc9IYsnZrR9GncNbZy9ThGfpI7do4/0TRFfHRgVvpagWVL1RIP99uQIBI5ATwrFJEeToYs8PMeDjvVa7uqy626urprwYE+z80LDHjtiUiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724868896; c=relaxed/simple;
	bh=LnPdXA7Jg8T29YlpMD9bHqpviTaW8w6gYDIQ+3cm8rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UgErZaQ7fjHKeRDv75fzlZ4ODD5AdXkaVZw7eNrG9+78DW5AgwuqgaA98zJITKqDFcWk19xu3qurw4M7xyxq3fzXruHEvzIEoQvd5JySbHlcuzF8lfJeNcgvp1V/aanMNYcjDUKs/jq5Tc/4bSCK4jcDAyTvBQoTK3R09hlw+po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v1bOuD6n; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e17bb508bb9so9342389276.2
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 11:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724868894; x=1725473694; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=g8CEH7SnnSsHaiw39Cx2W/imrlcDKaVqaPZKBSnVoqE=;
        b=v1bOuD6nVgxW03i0FbFjLL49r3B17a9fURUdaJXVd4md5Bw+9swKXZsdU2stECb2L7
         2ztjqihgJk7LYGHFat04MenFBnC6qSW0BeTSlQOX9NfpnQPcnyEilVXtX3JHCpsCfg9U
         5takWcb12GGwsigyQfIMjyMm9tuKY+alReASYkueasAvnc9N7tOdLbj5ukExlKe+Vksz
         O/J+me4tkjR0ovYSbGLColJs3ZCKRCx7aGploTOTWxJpaX9VLHgm1Fyf9Ue+YAHaKtUV
         WnOe8zmQgtHE/oA+7lLv3Z8DmB6DZVFut/AVZqKk6fTCyp6YSzu4GFljkkPmsqUuwr72
         tdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724868894; x=1725473694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g8CEH7SnnSsHaiw39Cx2W/imrlcDKaVqaPZKBSnVoqE=;
        b=H8YC3de4nWraicoVqx6xlpWQnqC9pIoHf+5RE+5qNGs8Td/5XVeYZncA8eDsAI4haK
         7pxWFXoehQq5jOOpAXQvL/Wav2hzt8PzLp5SOdc/N7VDwvj6RrBkoESTElNFIev3lZXj
         g/Xy6MxnpvAcdR6e62rrmbUJIerqszRb3F4gFIAD9dvQFpvLw8EYz8zavEOPx3Rvfggg
         gjaHpV/5/XdgjU9w1pduOfemi+Uo4uwZPECvsxMysSHlou+wq9Z01PY9Urp6L/mcE9RU
         LrIOD8gL2AyXcDfNHoN06vn72r5isktl+BtyK6YcNvM1UQj0wfKnSKz5hS9/kRseDC6g
         GGmw==
X-Gm-Message-State: AOJu0YzEvkpKuj+tsHFKSYXRu+g5CO9tNkAi47ZfZUtqN8w8A9WAiuKF
	YKIE+6TvIJ9PmTGE5wr3v0BvOjHbiFGPB2/k8z4GNY8Mt3D5ZDy5AQcCDuvyTn8otz4BBRgitxq
	CGQ==
X-Google-Smtp-Source: AGHT+IHNeuQKAVCun7jGA+4F4NSXhmCTAL6hk/rIp4B1oyD7UZlqqmU2e4hcnFIXLWY3/GKLuflJ7LotGs0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e304:0:b0:e11:7112:6b9b with SMTP id
 3f1490d57ef6-e1a5ab3d138mr6965276.3.1724868893779; Wed, 28 Aug 2024 11:14:53
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Aug 2024 11:14:46 -0700
In-Reply-To: <20240828181446.652474-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240828181446.652474-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240828181446.652474-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: Clean up coalesced MMIO ring full check
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Ilias Stamatis <ilstam@amazon.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Sean Christopherson <seanjc@google.com>, Paul Durrant <paul@xen.org>
Content-Type: text/plain; charset="UTF-8"

Fold coalesced_mmio_has_room() into its sole caller, coalesced_mmio_write(),
as it's really just a single line of code, has a goofy return value, and
is unnecessarily brittle.

E.g. if coalesced_mmio_has_room() were to check ring->last directly, or
the caller failed to use READ_ONCE(), KVM would be susceptible to TOCTOU
attacks from userspace.

Opportunistically add a comment explaining why on earth KVM leaves one
entry free, which may not be obvious to readers that aren't familiar with
ring buffers.

No functional change intended.

Reviewed-by: Ilias Stamatis <ilstam@amazon.com>
Cc: Paul Durrant <paul@xen.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/coalesced_mmio.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 184c5c40c9c1..375d6285475e 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -40,25 +40,6 @@ static int coalesced_mmio_in_range(struct kvm_coalesced_mmio_dev *dev,
 	return 1;
 }
 
-static int coalesced_mmio_has_room(struct kvm_coalesced_mmio_dev *dev, u32 last)
-{
-	struct kvm_coalesced_mmio_ring *ring;
-
-	/* Are we able to batch it ? */
-
-	/* last is the first free entry
-	 * check if we don't meet the first used entry
-	 * there is always one unused entry in the buffer
-	 */
-	ring = dev->kvm->coalesced_mmio_ring;
-	if ((last + 1) % KVM_COALESCED_MMIO_MAX == READ_ONCE(ring->first)) {
-		/* full */
-		return 0;
-	}
-
-	return 1;
-}
-
 static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 				struct kvm_io_device *this, gpa_t addr,
 				int len, const void *val)
@@ -72,9 +53,15 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 
 	spin_lock(&dev->kvm->ring_lock);
 
+	/*
+	 * last is the index of the entry to fill.  Verify userspace hasn't
+	 * set last to be out of range, and that there is room in the ring.
+	 * Leave one entry free in the ring so that userspace can differentiate
+	 * between an empty ring and a full ring.
+	 */
 	insert = READ_ONCE(ring->last);
-	if (!coalesced_mmio_has_room(dev, insert) ||
-	    insert >= KVM_COALESCED_MMIO_MAX) {
+	if (insert >= KVM_COALESCED_MMIO_MAX ||
+	    (insert + 1) % KVM_COALESCED_MMIO_MAX == READ_ONCE(ring->first)) {
 		spin_unlock(&dev->kvm->ring_lock);
 		return -EOPNOTSUPP;
 	}
-- 
2.46.0.295.g3b9ea8a38a-goog


