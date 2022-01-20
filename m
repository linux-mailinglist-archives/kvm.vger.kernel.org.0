Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3F0494561
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 02:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358214AbiATBHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 20:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358054AbiATBHg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 20:07:36 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B07C061401
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:35 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090ab00100b001b380b8ed35so2922054pjq.7
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 17:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SPmcB01Jw1VeFGKhxeTbS/wTzutTVSBvaADi6jp2W34=;
        b=Bf6iFLmM0Eql/U38xrScPLNbMLbjXLYmQELg5ayX41BI4Km4eyFs4TB/Rsw2gkiqRI
         y97hQ2UJ/PZIa3tEWd3IL//sqfXfYIzOmAw/0ibi05slPvOGFHvT9r3hpqCu+AwvNzN8
         RZBeeIAvE7Z+qJI1GXD8MkHuUo6cyFBK9kmLgEybj2zdReYvrHUEAYgYqkVKpgHt/NuA
         VHGCB3s7zv+zvQsqYzJPM/HoXCXKpZKehuedJ2x00uo29ZHA/ZRxxOhxPt5Fe3cwjHWs
         C35WKWS6Xh3/FOddroYlUxkhOlTFPRTCwvr9oBgmU5VGY7CY7b4zSKMtcPoyovU88X3U
         lCJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SPmcB01Jw1VeFGKhxeTbS/wTzutTVSBvaADi6jp2W34=;
        b=G3otFswNqxyq7vWgp7ERo7IpqUcYiiAK+14urvnOxBdyHRvVkAe5RudcOwpgMFjALa
         pmuxeY2E4zx6/V1i7I9d3b1A6ppVQl+aEa7z5819N1c7VVvRMprjPO5WJvn2AM9Y59O1
         hypM47Anz6VeWBBb+vNnaQN3EFiXCu6hdjvon3H6EVFpI2UM5L9Zik3HZiUbY2//l+LU
         22AVqNKeBFcaj+WEjsChz32Qtgpf944uRzOxIMXXGLxwwGQUbzGOT7L5vlRgHSp6kXnE
         ez9drI/cz6ZYTO4yAoG8Q0ky1OtPyIhutjm4p8Z3SF4ifNz3/+mEmfCHAZh6XGZhRrlt
         1f+A==
X-Gm-Message-State: AOAM5320IQw9xPvKT42xDu2AwaIeR/573bCNLfMfsrN89zUfxVryFyy6
        A/9CAnL/hprU/1Dd7UGT9p0aVuRVOsE=
X-Google-Smtp-Source: ABdhPJyhY4bNVRbfnz7JFjEiDTcXsIaFT/6w/ZpYFKxowHUV8yuURC0l5klp0iRUd1vZU9vPmah6Vonz+AQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1651:: with SMTP id
 il17mr7717476pjb.151.1642640855071; Wed, 19 Jan 2022 17:07:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 20 Jan 2022 01:07:17 +0000
In-Reply-To: <20220120010719.711476-1-seanjc@google.com>
Message-Id: <20220120010719.711476-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220120010719.711476-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 7/9] KVM: SVM: Inject #UD on attempted emulation for SEV guest
 w/o insn buffer
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Liam Merwick <liam.merwick@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject #UD if KVM attempts emulation for an SEV guests without an insn
buffer and instruction decoding is required.  The previous behavior of
allowing emulation if there is no insn buffer is undesirable as doing so
means KVM is reading guest private memory and thus decoding cyphertext,
i.e. is emulating garbage.  The check was previously necessary as the
emulation type was not provided, i.e. SVM needed to allow emulation to
handle completion of emulation after exiting to userspace to handle I/O.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 89 ++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ed2ca875b84b..d324183fc596 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4277,49 +4277,70 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	if (sev_es_guest(vcpu->kvm))
 		return false;
 
+	/*
+	 * Emulation is possible if the instruction is already decoded, e.g.
+	 * when completing I/O after returning from userspace.
+	 */
+	if (emul_type & EMULTYPE_NO_DECODE)
+		return true;
+
+	/*
+	 * Emulation is possible for SEV guests if and only if a prefilled
+	 * buffer containing the bytes of the intercepted instruction is
+	 * available. SEV guest memory is encrypted with a guest specific key
+	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
+	 * decode garbage.
+	 *
+	 * Inject #UD if KVM reached this point without an instruction buffer.
+	 * In practice, this path should never be hit by a well-behaved guest,
+	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
+	 * is still theoretically reachable, e.g. via unaccelerated fault-like
+	 * AVIC access, and needs to be handled by KVM to avoid putting the
+	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
+	 * but its the least awful option given lack of insight into the guest.
+	 */
+	if (unlikely(!insn)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return false;
+	}
+
+	/*
+	 * Emulate for SEV guests if the insn buffer is not empty.  The buffer
+	 * will be empty if the DecodeAssist microcode cannot fetch bytes for
+	 * the faulting instruction because the code fetch itself faulted, e.g.
+	 * the guest attempted to fetch from emulated MMIO or a guest page
+	 * table used to translate CS:RIP resides in emulated MMIO.
+	 */
+	if (likely(insn_len))
+		return true;
+
 	/*
 	 * Detect and workaround Errata 1096 Fam_17h_00_0Fh.
 	 *
 	 * Errata:
-	 * When CPU raise #NPF on guest data access and vCPU CR4.SMAP=1, it is
-	 * possible that CPU microcode implementing DecodeAssist will fail
-	 * to read bytes of instruction which caused #NPF. In this case,
-	 * GuestIntrBytes field of the VMCB on a VMEXIT will incorrectly
-	 * return 0 instead of the correct guest instruction bytes.
-	 *
-	 * This happens because CPU microcode reading instruction bytes
-	 * uses a special opcode which attempts to read data using CPL=0
-	 * privileges. The microcode reads CS:RIP and if it hits a SMAP
-	 * fault, it gives up and returns no instruction bytes.
+	 * When CPU raises #NPF on guest data access and vCPU CR4.SMAP=1, it is
+	 * possible that CPU microcode implementing DecodeAssist will fail to
+	 * read guest memory at CS:RIP and vmcb.GuestIntrBytes will incorrectly
+	 * be '0'.  This happens because microcode reads CS:RIP using a _data_
+	 * loap uop with CPL=0 privileges.  If the load hits a SMAP #PF, ucode
+	 * gives up and does not fill the instruction bytes buffer.
 	 *
 	 * Detection:
-	 * We reach here in case CPU supports DecodeAssist, raised #NPF and
-	 * returned 0 in GuestIntrBytes field of the VMCB.
-	 * First, errata can only be triggered in case vCPU CR4.SMAP=1.
-	 * Second, if vCPU CR4.SMEP=1, errata could only be triggered
-	 * in case vCPU CPL==3 (Because otherwise guest would have triggered
-	 * a SMEP fault instead of #NPF).
-	 * Otherwise, vCPU CR4.SMEP=0, errata could be triggered by any vCPU CPL.
-	 * As most guests enable SMAP if they have also enabled SMEP, use above
-	 * logic in order to attempt minimize false-positive of detecting errata
-	 * while still preserving all cases semantic correctness.
+	 * KVM reaches this point if the VM is an SEV guest, the CPU supports
+	 * DecodeAssist, a #NPF was raised, KVM's page fault handler triggered
+	 * emulation (e.g. for MMIO), and the CPU returned 0 in GuestIntrBytes
+	 * field of the VMCB.
 	 *
-	 * Workaround:
-	 * To determine what instruction the guest was executing, the hypervisor
-	 * will have to decode the instruction at the instruction pointer.
+	 * This does _not_ mean that the erratum has been encountered, as the
+	 * DecodeAssist will also fail if the load for CS:RIP hits a legitimate
+	 * #PF, e.g. if the guest attempt to execute from emulated MMIO and
+	 * encountered a reserved/not-present #PF.
 	 *
-	 * In non SEV guest, hypervisor will be able to read the guest
-	 * memory to decode the instruction pointer when insn_len is zero
-	 * so we return true to indicate that decoding is possible.
-	 *
-	 * But in the SEV guest, the guest memory is encrypted with the
-	 * guest specific key and hypervisor will not be able to decode the
-	 * instruction pointer so we will not able to workaround it. Lets
-	 * print the error and request to kill the guest.
+	 * To reduce the likelihood of false positives, take action if and only
+	 * if CR4.SMAP=1 (obviously required to hit the erratum) and CR4.SMEP=0
+	 * or CPL=3.  If SMEP=1 and CPL!=3, the erratum cannot have been hit as
+	 * the guest would have encountered a SMEP violation #PF, not a #NPF.
 	 */
-	if (likely(!insn || insn_len))
-		return true;
-
 	cr4 = kvm_read_cr4(vcpu);
 	smep = cr4 & X86_CR4_SMEP;
 	smap = cr4 & X86_CR4_SMAP;
-- 
2.34.1.703.g22d0c6ccf7-goog

