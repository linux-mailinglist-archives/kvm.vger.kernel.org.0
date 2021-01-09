Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67572EFC56
	for <lists+kvm@lfdr.de>; Sat,  9 Jan 2021 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAIAsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 19:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbhAIAsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 19:48:21 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17CBC0613CF
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 16:47:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w8so17175796ybj.14
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 16:47:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+lfNaOH1CNuPDcxuYVHAHObVf+9wEEDIr0zVJxlAHxg=;
        b=h3Wt3u4muRLH+lXrqIZcA9i7ZR1kMlwr2sNCooqL0o/afHVcCmVMDixQVZykwIWhpI
         SoT2dXW9hyUw53ILva1+YJ42KLVyJYVy3GM/QjrTtyASQvEWFA/xUuugwWbpff/eVEJd
         T4VumfbyKVrsR/X1mFgTZM1ydMNF9ezzzo9dzZukgfmTuv/xe6HH4b70qLDXBljGYyv7
         FmnSa9rrQhBj6Z1f+pKCsuQEQ3B/deoEMiUianx9eqhWpXZU4nziesX8PI1BsRG+Rlvk
         dk3YYdyqqFmwuURNNwnItdQNKb1s+Dg5XpcUkd2dytMLvhXIO7gfwG9SJThcSOxEkVkE
         RSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+lfNaOH1CNuPDcxuYVHAHObVf+9wEEDIr0zVJxlAHxg=;
        b=duZWxBsR8gVoJkcLftdn/PD9gE2j68Q/9lHgM73+w9lRHc0HaaPcKOB747ARbiqs6d
         4zpT33/QYB5tbQf32y9u+4UqiAHsWZIJql01UEx6aNGce4CzVmiJj0kXHuwaA6MrSwcI
         Nf1bI4EH6HMZKKcCsA5iUmzpELoGjYRKS2cKnjUPTt2n6uDdENsOFlhOP2R8UJfcqQNX
         p2LC6tac1DE9VxfuhJ32S0A6LjuhrHYMGuR7Ab0dV+ygjugY++sjtNN1gDIanPUdTiOv
         69qPTarWQgDOVX5uVRHJ6V1f5hRp2XO9x4mFP1L1TsoF+LbiXAVwww2RiFEzMVLyMILr
         MIBA==
X-Gm-Message-State: AOAM530iUBg/BHKEd5WSCXWuf/gkLnZQYijFEYqqV98I+vIKkxXlPFkA
        Qhke0YDhbFkcJjxegc4r6TGr1ERsHa4=
X-Google-Smtp-Source: ABdhPJyO0MPUQEJQ3LhSD+DP0vmLd5WqMFpk4pKCmPq1ODSkbFW504+bpfkEV752j5im3qoBWc8I5tMSC+E=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:11c2:: with SMTP id 185mr3181184ybr.74.1610153259966;
 Fri, 08 Jan 2021 16:47:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Jan 2021 16:47:03 -0800
In-Reply-To: <20210109004714.1341275-1-seanjc@google.com>
Message-Id: <20210109004714.1341275-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210109004714.1341275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 02/13] KVM: SVM: Zero out the VMCB array used to track SEV
 ASID association
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zero out the array of VMCB pointers so that pre_sev_run() won't see
garbage when querying the array to detect when an SEV ASID is being
associated with a new VMCB.  In practice, reading random values is all
but guaranteed to be benign as a false negative (which is extremely
unlikely on its own) can only happen on CPU0 on the first VMRUN and would
only cause KVM to skip the ASID flush.  For anything bad to happen, a
previous instance of KVM would have to exit without flushing the ASID,
_and_ KVM would have to not flush the ASID at any time while building the
new SEV guest.

Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7ef171790d02..ccf52c5531fb 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -573,7 +573,7 @@ static int svm_cpu_init(int cpu)
 	if (svm_sev_enabled()) {
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
 					      sizeof(void *),
-					      GFP_KERNEL);
+					      GFP_KERNEL | __GFP_ZERO);
 		if (!sd->sev_vmcbs)
 			goto free_save_area;
 	}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

