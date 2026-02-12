Return-Path: <kvm+bounces-70950-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EAhnCDGxjWmz5wAAu9opvQ
	(envelope-from <kvm+bounces-70950-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:53:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CA74512CB95
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D4A773010243
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:52:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C011531AA9C;
	Thu, 12 Feb 2026 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bmF94Y4T";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jtSDozM4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5D318EC0
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893544; cv=none; b=AHzANniapCX787PBBAhaq9V6v6q/jA/Jg/R9pztqJdlN7P1KkFx1zMl1uPeaylNNjSyAfHQXt6cPS7YUCP/v9n9IgKfoaNArMBsDAVCPrIQizrhUI3PXBi9fm0KH82BOX3pvwoiXFnDeJLs6dUVND03np/x+xN8pKkOcNyNP0Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893544; c=relaxed/simple;
	bh=0VJorrCNLDmll5biT00ss8hT7qU/JEiNG1R8WhBGgbE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHYvWqmFcZok01wNzJh41yoBmrV2rLRV9OmkXCQOBt1H3OpgsDsCRKS3P7Xvm30wywY3VPf0g603aA9ly5uQpHEEtELsG0VT45VIlkMV7MKJaepNKAtzhjiu24O6Hk7t1NW5GVlqAVqrAo6ruFJq10xj/EDaRltTW3sobDh5AvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bmF94Y4T; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jtSDozM4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770893540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
	b=bmF94Y4TBBAgPA8c4b0c0URMMM02Kz+/+6qTh+HUdhubssC9MjaacP9fp2d12y11vSBt0i
	gOEsfqRQDuFTisG/1nKxWkRRV7sCE4Z9+a/lKuVnr0Tv1kOqeaoVFECKH7mt7/vYyRHuWk
	9lw/hI6Xsvl1DcoLb4Bzw30TzzxtwdQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-93F3rSbWNYu5Gu-iCR1JKw-1; Thu, 12 Feb 2026 05:52:19 -0500
X-MC-Unique: 93F3rSbWNYu5Gu-iCR1JKw-1
X-Mimecast-MFC-AGG-ID: 93F3rSbWNYu5Gu-iCR1JKw_1770893538
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48057c39931so76724475e9.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770893537; x=1771498337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
        b=jtSDozM4E2nfjCd13sglzSWSgP/rhrfpzQC4WYga+B7ED++ORRQt+BNKXtlI8KESFy
         rFhBRw+v8ssAZgui3Bvqf8P6vmdB01ZPIUg+MijMbJPaIHgWlRsXpVGE28fnKb5opvgI
         taQgdzWizpmeihCQjWL5shvmx2hALpyK+4t2eWuuR3gHvZzF83M1auuHtTqNkzFlQ+gW
         GWV62HYCc2LJAaT+r0Hbw1HwivHQXQVosR0xN4MYKkmjgC6B+pbaJ2viZUGUw3LPOziG
         lGTsdCOQbpr6S+hdLrwf4XO6Ma7AvM6fYIptGN4ZzJl7KUs7gIA5HQ6cxepO25ut2Gbh
         ERrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893537; x=1771498337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dv/cLXh264i91XUSFDhJ5W6sVIgqSnLYvLU3b6QBq40=;
        b=RANEpNQWWwTyiEFuBRhQKnol8x00vMKGfyd77/QbWTynho/qnYEMjZPFRoX6ze/gEi
         n5vgqKyPcik8AnJ8HJvJPzaSYIMMZFVIbwxhbt0td+qymaz6L+gQAwZnWVtXk9U7bHV3
         i2bntPiFiIeIDsUynkY01daMaB6MBzJPnxN/Mab1QX7UNXdDRfkKVjK+/LyM6WSodXfi
         yN8SueGYopVRQ6Hglwr8p0UiWGEREGCRZAd+xKrhZMXBz4cMBidgv7RanBc5+MDbGiUq
         GzmLfUSaqH4MKTnJkPHuyJikhdeQcHk04mgDBmtm2s2BqlyDOPPkIgbfFvumE0Wnxuqb
         wVrA==
X-Forwarded-Encrypted: i=1; AJvYcCXzQsD/CH4ecZs1MhzJMAli/qNH2zK7/LZ6OyZotOPVNqWxvFx7cSz+JtUZ2+V4viaYYFA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT022CojnJDAY66/TP4UPst01HVmiCFLkKlpXOd7rY9xrSZd80
	p2i5UM+NjqCSOgmOKpBJ8hoItF57TVJS94Ooysk8+ucsbt480c6j4nlr+AV2XfEKjKSJIZ6K/3Y
	CBLCYeP1zNelEgO5SZTsWuFv7vG50H6lbX+ERBiiLAjYVEwCaRTpsla47dSIKaw==
X-Gm-Gg: AZuq6aKrRScEMADeUJD9T/wvmrXaJ116yDZoIKJZap8lZygeg1E+OIQADlru2Kb8ypB
	mAdTurjRmcNHdfPXrnJ6yWde66U0hbccLhihFzKVKtGG/EaGoGHxUz8w3F3fvshPzQohCeQdlZS
	7DGtg36m+W2/l+QkrUtf5OBnsb51XF84GIcHorAUfelxz+53YEpgYWApSx1vQ5PjfEG0hAccg4l
	90ID9dtceJVnYPQTdTC7A9b00BFd5VwlscHnQ9cuV0FFdBzhHsjJiCnKp4Uid3dd8DJmFTloeCo
	/kuPoi4cZZQZgP+DDjvgGv+cu8dMGqPX3d3LcJbO4u84cDmh00UW3OX5atkfn5aN1fQpWwx68RU
	4pjT5wPfzcRcqq4YbjmTOwIWujkLN1BLHn9RISg8grFseUNpbCNnbRX1v3eNQsFAWCFGu9+lvVO
	MUwp27Qb/mM7lOyqZXw7JiY5xPdeL8OgCBrrX30LMGoifeYuVQC6E=
X-Received: by 2002:a05:600c:c494:b0:47e:e5c5:f3a3 with SMTP id 5b1f17b1804b1-4836570edf3mr34175525e9.24.1770893536685;
        Thu, 12 Feb 2026 02:52:16 -0800 (PST)
X-Received: by 2002:a05:600c:c494:b0:47e:e5c5:f3a3 with SMTP id 5b1f17b1804b1-4836570edf3mr34175125e9.24.1770893536224;
        Thu, 12 Feb 2026 02:52:16 -0800 (PST)
Received: from [192.168.122.1] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835a619c7dsm67722695e9.2.2026.02.12.02.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 02:52:15 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: always define KVM_CAP_SYNC_MMU
Date: Thu, 12 Feb 2026 11:52:11 +0100
Message-ID: <20260212105211.1555876-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260212105211.1555876-1-pbonzini@redhat.com>
References: <20260212105211.1555876-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70950-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CA74512CB95
X-Rspamd-Action: no action

KVM_CAP_SYNC_MMU is provided by KVM's MMU notifiers, which are now always
available.  Move the definition from individual architectures to common
code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 10 ++++------
 arch/arm64/kvm/arm.c           |  1 -
 arch/loongarch/kvm/vm.c        |  1 -
 arch/mips/kvm/mips.c           |  1 -
 arch/powerpc/kvm/powerpc.c     |  5 -----
 arch/riscv/kvm/vm.c            |  1 -
 arch/s390/kvm/kvm-s390.c       |  1 -
 arch/x86/kvm/x86.c             |  1 -
 virt/kvm/kvm_main.c            |  1 +
 9 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fc5736839edd..6f85e1b321dd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1396,7 +1396,10 @@ or its flags may be modified, but it may not be resized.
 Memory for the region is taken starting at the address denoted by the
 field userspace_addr, which must point at user addressable memory for
 the entire memory slot size.  Any object may back this memory, including
-anonymous memory, ordinary files, and hugetlbfs.
+anonymous memory, ordinary files, and hugetlbfs.  Changes in the backing
+of the memory region are automatically reflected into the guest.
+For example, an mmap() that affects the region will be made visible
+immediately.  Another example is madvise(MADV_DROP).
 
 On architectures that support a form of address tagging, userspace_addr must
 be an untagged address.
@@ -1412,11 +1415,6 @@ use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
 to make a new slot read-only.  In this case, writes to this memory will be
 posted to userspace as KVM_EXIT_MMIO exits.
 
-When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
-the memory region are automatically reflected into the guest.  For example, an
-mmap() that affects the region will be made visible immediately.  Another
-example is madvise(MADV_DROP).
-
 For TDX guest, deleting/moving memory region loses guest memory contents.
 Read only region isn't supported.  Only as-id 0 is supported.
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d5b0b99fd1..7309f5084388 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -358,7 +358,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_USER_MEMORY:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ARM_PSCI:
diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
index 9681ade890c6..41b58ec45f41 100644
--- a/arch/loongarch/kvm/vm.c
+++ b/arch/loongarch/kvm/vm.c
@@ -117,7 +117,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_IMMEDIATE_EXIT:
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_MP_STATE:
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b0fb92fda4d4..29d9f630edfb 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1035,7 +1035,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_READONLY_MEM:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_IMMEDIATE_EXIT:
 		r = 1;
 		break;
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 3da40ea8c562..00302399fc37 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -623,11 +623,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = !!(hv_enabled && kvmppc_hv_ops->enable_nested &&
 		       !kvmppc_hv_ops->enable_nested(NULL));
 		break;
-#endif
-	case KVM_CAP_SYNC_MMU:
-		r = 1;
-		break;
-#ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	case KVM_CAP_PPC_HTAB_FD:
 		r = hv_enabled;
 		break;
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 66d91ae6e9b2..b4afef7e59fc 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -181,7 +181,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_IOEVENTFD:
 	case KVM_CAP_USER_MEMORY:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
 	case KVM_CAP_ONE_REG:
 	case KVM_CAP_READONLY_MEM:
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index de645025db0f..6591ee56bf5b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -601,7 +601,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	switch (ext) {
 	case KVM_CAP_S390_PSW:
 	case KVM_CAP_S390_GMAP:
-	case KVM_CAP_SYNC_MMU:
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_CAP_S390_UCONTROL:
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 391f4a5ce6dd..ac31b098bfbd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4805,7 +4805,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 #endif
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
-	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_USER_NMI:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_IOEVENTFD:
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bf5606d76f0c..51d1f7d4905e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4870,6 +4870,7 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 {
 	switch (arg) {
+	case KVM_CAP_SYNC_MMU:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_USER_MEMORY2:
 	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
-- 
2.52.0


