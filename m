Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEC3367727
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhDVCMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDVCMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:12:06 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AFEC06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:32 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id h14-20020ac846ce0000b02901ba21d99130so6300914qto.13
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=es3BrEt/S0hj0elrM8cYzWujMT4DWRrvIdZx5ttB4mo=;
        b=rlXyrnFK0pqqsvHYF2rEC/rSf0+paRZxvod0CTuMJ5p3boxP32/+3hNxeIdLeJnXUv
         YYvxLUl/mqEKXMf+bs4laYvYIJnoUmTiFYMJvMEl8hZabkLViUmMl5lxaJtaBAb7q/m5
         ali8h8VO0aBEYnZHRlZV2izoqU75j8CBPhre58Ww4rdteSJ8wc/3VBcBwVXcbD1FSoK+
         iHEl5UEae68YZ7wT+hY5fBAg9z7ZnIBYY1MKC++wzvYpexgWV9pIJGAFtnJbdGbJagv4
         6pbOkBKe7Fak61U8K7pKSemcA2JIx4eP9BtLuZ7aBakRNIS3epfHhUhdrvtzMmiz+ijW
         nqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=es3BrEt/S0hj0elrM8cYzWujMT4DWRrvIdZx5ttB4mo=;
        b=T1tusJp78PlnlS2J3/qsr3reH+o21hppOZwKsvVxPcKvZ1tEhWu6ZShYEcG3tUnLUx
         kLqzuXa/RyPTnwqDG1PtCpbFZTDfu8vJgoKJqHJ9YIsWWgh17tpVeFMSYFtYZUtkBLLq
         zl5d/KdIni3DZ2JtZHDaRQVx9uL+P0bxkPwFCep39cMLt+/CkU+67+nLGMIAT4xcSSra
         Q7GQyFi+JxDEk5nfEPE70VYSzejXSNSg3LZGjCWhopBulc1ZRQLsU4R2QQ05ht90kbZf
         fl/RhBpxGS9lwPS+qyHlDOfVDWGboVFzyr//4+JN4o+YKQb/nLALqp9xnZfj+af1RPNC
         heTQ==
X-Gm-Message-State: AOAM532x0lwyI+NMybTxT6pqdcu8j/v+0fM4KYEXTY7Q8ZIoJlTrvvYx
        dRFCKdz5aRhGvx5XRWEc0U07cN2KBGA=
X-Google-Smtp-Source: ABdhPJxiYCrJnCgureQBFXnyTKS0/Re5X2xbdqnEK6YpQ5OLkS7/63Tg/teL/Ifv9gMqblsCqfREmedXFyQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a0c:8521:: with SMTP id n30mr913189qva.53.1619057490787;
 Wed, 21 Apr 2021 19:11:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:11:11 -0700
In-Reply-To: <20210422021125.3417167-1-seanjc@google.com>
Message-Id: <20210422021125.3417167-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210422021125.3417167-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v5 01/15] KVM: SVM: Zero out the VMCB array used to track SEV
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
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd8c333ed2dc..fed153314aef 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -563,9 +563,8 @@ static int svm_cpu_init(int cpu)
 	clear_page(page_address(sd->save_area));
 
 	if (svm_sev_enabled()) {
-		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
-					      sizeof(void *),
-					      GFP_KERNEL);
+		sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *),
+					GFP_KERNEL);
 		if (!sd->sev_vmcbs)
 			goto free_save_area;
 	}
-- 
2.31.1.498.g6c1eba8ee3d-goog

