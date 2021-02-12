Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98BD319788
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhBLAf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 19:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhBLAfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 19:35:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08CFC06178B
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f127so7871835ybf.12
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 16:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=HiLuaEqgR2Zld6XmaaPoO5KvEAReZ5PkM63iqGTwhYE=;
        b=ZsKNp492o99jcgPOmAK9In2KwTkldmofXtwhobMCDR54LWHgw43V6No73zBR1S5ALi
         fx0ZOcy7c+r+wQrPsBDFdugM41Dh5lpn+VNZBgLOrMleScPRqb/tNiwzoQEGm1TjJOJn
         l6ddgrgyUwK+TTDdcv4E7MbMabLrG7drll821snERsbcjmnYKhU0aUH43h6RtpGdwqnB
         knsdzOM7TU1C3dnTEYqN5h2jgfqnz2XsBEKmg6ilFTnpFXqd3G9rgQgf67CBWpiFuBoi
         j7NOGRDhbQvawgpRsBEZv+khpTk17mhPdzoAxXC/hwRTaRNDZQ5x7qNQfCPvan7I61nq
         TeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=HiLuaEqgR2Zld6XmaaPoO5KvEAReZ5PkM63iqGTwhYE=;
        b=RDO2sfrOVHThQwzpOGt18Qo5i0Xd54s/F0BUr2q8K9apA8kUBXqEiclgEGRBZ59YcV
         qMKvuvXgVVAjiD4kgX9KL5BMyiZm0a4meAGiqk0LVW/kWx8tgx/Uvs/txm44Ox7aOsna
         ruR8fuTv/omw/z0LWovXx2B856DmhZEzlkm3vWq2QuajWIt8ZT4GwMWprOuxZyEOKyE8
         lvf84AuPHDoexGzfQIEx/uIObTcAAdtpdakPvqhPHfQG4a2jjmuI5L0zTo/12cimrV2k
         XGi8xqBBqhHl7MvfuCZzL8pNvkSCiC/1QzFsMaS0nb4Mw+9LlWnbW5GP6tEXVIaFs85L
         yqZw==
X-Gm-Message-State: AOAM530AcXsPoQwJQViL2t2BVKqVXoVhyX/YM88Em5gDiPJxECk59So+
        gCUy3T7qXwTC7BXFqcETXswD+8QszJ4=
X-Google-Smtp-Source: ABdhPJwK5b+suKRPnqy0zqTg7zGY3SLR+Mwuz3838RchlSecSDLe7wNZ+yk5VjjAgFs7GvC5s5tPDbKjUGM=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a25:2b04:: with SMTP id r4mr699264ybr.219.1613090062011;
 Thu, 11 Feb 2021 16:34:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 16:34:11 -0800
In-Reply-To: <20210212003411.1102677-1-seanjc@google.com>
Message-Id: <20210212003411.1102677-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210212003411.1102677-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 3/3] KVM: VMX: Allow INVPCID in guest without PCID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the restriction that prevents VMX from exposing INVPCID to the
guest without PCID also being exposed to the guest.  The justification of
the restriction is that INVPCID will #UD if it's disabled in the VMCS.
While that is a true statement, it's also true that RDTSCP will #UD if
it's disabled in the VMCS.  Neither of those things has any dependency
whatsoever on the guest being able to set CR4.PCIDE=1, which is what is
effectively allowed by exposing PCID to the guest.

Removing the bogus restriction aligns VMX with SVM, and also allows for
an interesting configuration.  INVPCID is that fastest way to do a global
TLB flush, e.g. see native_flush_tlb_global().  Allowing INVPCID without
PCID would let a guest use the expedited flush while also limiting the
number of ASIDs consumed by the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d265b2523f8..e1b84008a05d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4295,18 +4295,8 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 	}
 
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
-
-	/*
-	 * Expose INVPCID if and only if PCID is also exposed to the guest.
-	 * INVPCID takes a #UD when it's disabled in the VMCS, but a #GP or #PF
-	 * if CR4.PCIDE=0.  Enumerating CPUID.INVPCID=1 would lead to incorrect
-	 * behavior from the guest perspective (it would expect #GP or #PF).
-	 */
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
-		guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
-
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdseed, RDSEED);
 
-- 
2.30.0.478.g8a0d178c01-goog

