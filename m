Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7C542D8B3
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhJNMEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 08:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhJNMEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 08:04:10 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B076C061570;
        Thu, 14 Oct 2021 05:02:05 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id n8so25757889lfk.6;
        Thu, 14 Oct 2021 05:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Z0I5fwLWQQixLqfMvt3p7vWiHJ7Yer9lKzGyPaCwCc=;
        b=YwXq1cXVscJLweixps53yV0+9kCWbSdnW+ZKAbG0sZ5g2CXIuu0DIvTh1NIt72Cra+
         oePml/4tl3+gVlA++XQYCwHdQnd7aP51x38x4e8oGpHVo7AuBULbRZROiuAGpzvodI9Z
         NQRjlO1FijguoAa86wZI/9K79UFrMSCWqDzMKI59ECkO38IEEo/QIZwwOx61qmZPFqTI
         9lnHE5sYyUYkaZNbO8QwBlXMdTkeFdIWxD5YLh3u0qbE94CRUgoiSdqFb2WblTbp6MTJ
         205/UrwML1FeNha26SDeC2Ro5I5KsAy5KT2Vs5rkEDQ8+tNJ1UgcghYvquJBeDIW4UEO
         Z13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8Z0I5fwLWQQixLqfMvt3p7vWiHJ7Yer9lKzGyPaCwCc=;
        b=1CWUsA0i48xEf9zihkoH0C3agWmO6Xja1IqW4ANgU50oVycvDDcS0ynUyWkysHUWdD
         Gcb1grHP81Ni905sjqfyYGkqUCUNpRtbPS86/NJjGSY6D+Yi+j68hlZcI0C+M9ru00N7
         hLf/9ejpI6A/bJ1NbggTWVPJ8foryOydN6clFY7dBLBIPbiRSipJR8nfsoqrRo9/OmSj
         DxYCgixaykP3kdyuZsGNx9dGgu4jnFkLyMPXoSs7FEDLSE4PoP1pbh3IKG/4rS12L4xW
         h+EfoZdViD8XfQiv6y1a/aEmMCxtMcFQ6OgaLZEQnwVGqz7J/Agkhg0zuIQMsKFl5CA2
         Fb+g==
X-Gm-Message-State: AOAM533AOJr2VWgtY9h0xAnDMt6L5ceYthRR4QtiZqu6Bid5s7kcYIG/
        zOTynheTZSyesJSFRiE+roQ=
X-Google-Smtp-Source: ABdhPJy+WEVXmSbP7Gfnkp0MDtnWO9A5Y8119qsXGocDMQQUhicncmFDKAm//oxL+CoIPlLG9YDJ1g==
X-Received: by 2002:a2e:81c6:: with SMTP id s6mr5551136ljg.469.1634212922801;
        Thu, 14 Oct 2021 05:02:02 -0700 (PDT)
Received: from fuzzer1.spectre.kz ([91.201.214.75])
        by smtp.googlemail.com with ESMTPSA id o5sm209321lft.278.2021.10.14.05.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 05:02:02 -0700 (PDT)
From:   Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, hpa@zytor.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sabyrzhan Tasbolatov <snovitoll@gmail.com>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Subject: [PATCH] x86/kvm: restrict kvm user region memory size
Date:   Thu, 14 Oct 2021 12:01:51 +0000
Message-Id: <20211014120151.1437018-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot found WARNING in memslot_rmap_alloc[1] when
struct kvm_userspace_memory_region .memory_size is bigger than
0x40000000000, which is 4GB, e.g. KMALLOC_MAX_SIZE * 100 * PAGE_SIZE.

Here is the PoC to trigger the warning:

    struct kvm_userspace_memory_region mem = {
        .slot = 0,
        .guest_phys_addr = 0,
        /* + 0x100 extra to trigger kmalloc WARNING */
        .memory_size = 0x40000000000 + 0x100,
        .userspace_addr = 0,
    };

    ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION, &mem);

I couldn't find any relevant max constant to restrict unsigned long npages.
There might be another solution with chunking big portions of pages, but
there is already KVM_MAX_HUGEPAGE_LEVEL, though warning happens in
memslot_rmap_alloc() when level = 1, base_gfn = 0, e.g.
on the very first KVM_NR_PAGE_SIZES iteration.

This is, seems, valid for early Linux versions as well. Can't tell which is
exactly can be considered for git bisect.
Here is Commit d89cc617b954af ("KVM: Push rmap into kvm_arch_memory_slot")
for example, Linux 3.7.

[1]
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 memslot_rmap_alloc+0xf6/0x310 arch/x86/kvm/x86.c:11320
 kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11388 [inline]
 kvm_arch_prepare_memory_region+0x48d/0x610 arch/x86/kvm/x86.c:11462
 kvm_set_memslot+0xfe/0x1700 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1505
 ...
 kvm_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1689
 kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c

Reported-by: syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
---
 arch/x86/kvm/mmu/page_track.c | 3 +++
 arch/x86/kvm/x86.c            | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 21427e84a82e..e790bb341680 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -35,6 +35,9 @@ int kvm_page_track_create_memslot(struct kvm_memory_slot *slot,
 	int  i;
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
+		if (npages > KMALLOC_MAX_SIZE)
+			return -ENOMEM;
+
 		slot->arch.gfn_track[i] =
 			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
 				 GFP_KERNEL_ACCOUNT);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aabd3a2ec1bc..2bad607976a9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11394,6 +11394,9 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 
 		WARN_ON(slot->arch.rmap[i]);
 
+		if (lpages > KMALLOC_MAX_SIZE)
+			return -ENOMEM;
+
 		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
-- 
2.25.1

