Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188F749BDA6
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 22:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiAYVFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 16:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiAYVEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 16:04:48 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AB7C06173B
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 13:04:48 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a10-20020a17090abe0a00b001b4df1f5a6eso2427213pjs.6
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 13:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=OPCoGzOgO3ePiF7uGLaiEYM7q9Cq2U4uPfjhX9T1kkU=;
        b=bgCpuBAbwdQaQh/ZWceNlXvKc0Lk5Ij8uGqBjZPtciLo1YlD1yG7fHOgV1I/0sxFM+
         7r388I76i5vKAQbA5iDX7zfUxGxOq1iUGIS6hEnnOsEmG73ZogeH/t8c8q6I8lrTl9Xn
         zdRR7NtkD+yqzAbMBwCMpEgvtaItocwB/1iCQh/Wb+Qj92zPAjPzuCt8PzK/NCQrsu1x
         42CsfxpZEhl3Tl5aqxmvWYjQh8YaVAGtpNtzRWVEP/A07yFVE2ZLI9GCBqSuMBS140HP
         ybnwl2FcAw3GsUe+pnEOdTrAG7i2iOMg6MbvkaK5FYtefIlbI4McanjqVykhqT6WqEVQ
         MFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=OPCoGzOgO3ePiF7uGLaiEYM7q9Cq2U4uPfjhX9T1kkU=;
        b=hDIsXKyXqo1mC1L/Bt6Gjvnegdlv5SwIqbHd3c1otzarTRlkGHf0lf0R5HYpXV1czL
         LuWL2YPdNw7sGSJUVCKME8FzDDCLDAMRLY/ZVpllR7THoWEn+AsfJorF0aOsodBecGPy
         J+vAavc3vdsrh33MIdGUmrqv6W3aiU6Jxi7t7uwdFvfSUN59bAONdPa3+xwYCiK3pTpn
         vYM0XSWUAqmgKH8dECwDTQQBY9M68i2JzVeT+ivjIfO3N1PLNz+QG4/l/JIaOZ2vZ87y
         R/+gOQqCVVFkd79A3pCcYY1alpPF2Yl4Rgf7lQKKzLm5Yuju/vLFsRJO2h1K1IU6wdYl
         WQfQ==
X-Gm-Message-State: AOAM530OIBehKLdtRfQUUnfrekF9AEenbp6yEJXvAW71NsdD0/aSLidv
        aoCuIhEZPOfTPtNdnYY9QpunpdKSD54=
X-Google-Smtp-Source: ABdhPJxCujVCkIiS06I2fY8jBRNhq60lLvXIX+1EzZgcz/FMYKDgZImDN7UY3AuHOZJR5R8sY5R81mrKqSI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:4c8e:: with SMTP id
 my14mr639444pjb.0.1643144687569; Tue, 25 Jan 2022 13:04:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 25 Jan 2022 21:04:45 +0000
Message-Id: <20220125210445.2053429-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH] KVM: x86: Free kvm_cpuid_entry2 array on post-KVM_RUN KVM_SET_CPUID{,2}
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+be576ad7655690586eec@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Free the "struct kvm_cpuid_entry2" array on successful post-KVM_RUN
KVM_SET_CPUID{,2} to fix a memory leak, the callers of kvm_set_cpuid()
free the array only on failure.

 BUG: memory leak
 unreferenced object 0xffff88810963a800 (size 2048):
  comm "syz-executor025", pid 3610, jiffies 4294944928 (age 8.080s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 0d 00 00 00  ................
    47 65 6e 75 6e 74 65 6c 69 6e 65 49 00 00 00 00  GenuntelineI....
  backtrace:
    [<ffffffff814948ee>] kmalloc_node include/linux/slab.h:604 [inline]
    [<ffffffff814948ee>] kvmalloc_node+0x3e/0x100 mm/util.c:580
    [<ffffffff814950f2>] kvmalloc include/linux/slab.h:732 [inline]
    [<ffffffff814950f2>] vmemdup_user+0x22/0x100 mm/util.c:199
    [<ffffffff8109f5ff>] kvm_vcpu_ioctl_set_cpuid2+0x8f/0xf0 arch/x86/kvm/cpuid.c:423
    [<ffffffff810711b9>] kvm_arch_vcpu_ioctl+0xb99/0x1e60 arch/x86/kvm/x86.c:5251
    [<ffffffff8103e92d>] kvm_vcpu_ioctl+0x4ad/0x950 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4066
    [<ffffffff815afacc>] vfs_ioctl fs/ioctl.c:51 [inline]
    [<ffffffff815afacc>] __do_sys_ioctl fs/ioctl.c:874 [inline]
    [<ffffffff815afacc>] __se_sys_ioctl fs/ioctl.c:860 [inline]
    [<ffffffff815afacc>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
    [<ffffffff844a3335>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff844a3335>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: c6617c61e8fe ("KVM: x86: Partially allow KVM_SET_CPUID{,2} after KVM_RUN")
Cc: stable@vger.kernel.org
Reported-by: syzbot+be576ad7655690586eec@syzkaller.appspotmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 3902c28fb6cb..0a08db384fb9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -346,8 +346,14 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	 * KVM_SET_CPUID{,2} again. To support this legacy behavior, check
 	 * whether the supplied CPUID data is equal to what's already set.
 	 */
-	if (vcpu->arch.last_vmentry_cpu != -1)
-		return kvm_cpuid_check_equal(vcpu, e2, nent);
+	if (vcpu->arch.last_vmentry_cpu != -1) {
+		r = kvm_cpuid_check_equal(vcpu, e2, nent);
+		if (r)
+			return r;
+
+		kvfree(e2);
+		return 0;
+	}
 
 	r = kvm_check_cpuid(vcpu, e2, nent);
 	if (r)

base-commit: e2e83a73d7ce66f62c7830a85619542ef59c90e4
-- 
2.35.0.rc0.227.g00780c9af4-goog

