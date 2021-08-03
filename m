Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA933DF32F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbhHCQvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Aug 2021 12:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhHCQu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Aug 2021 12:50:57 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF708C061757
        for <kvm@vger.kernel.org>; Tue,  3 Aug 2021 09:50:46 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d1so24477083pll.1
        for <kvm@vger.kernel.org>; Tue, 03 Aug 2021 09:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iqc5j4y63ceZj/9amRDa8SAqtdQrRV532yAoOjCbGJ0=;
        b=UCCx6wetZlH2P5F0XTnB5ifaSVUINJ0jxO5NBKItpkhx9/a4x3//vx2ys6flv2Fv+/
         hCcZhkMA7LP9ekE6mHaLUzkBQjZB8NLSoB7Z1fpi0NQ7gWUf1356A8ah4rrReFsj6O3E
         iDCn4GQIT/2CNdbHlheIA76CPIPd0A6MVBWlYDs+jIGbKPN12cMr2rMpq8k5DEFMlV/H
         l+5kVX1fDOg2DGtoDAY/xIR86WC2AlEPzeQPz1NtPn6x+6UqqWHd2P1JDCscw1GPJFsj
         pdZ72F4UbIXtlFsG3sJbVJZB4Eg3eOYwXNCRpj/rSOIcjekDJKLHuQdW4iM2ezXHzeUO
         Vcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iqc5j4y63ceZj/9amRDa8SAqtdQrRV532yAoOjCbGJ0=;
        b=BFUB5a2Mig0P/oy05IQ+Z/c574xVy+3J9WndXQHKlPiqBCwNy5UY86551sw4/H8xK7
         XDIau3Dy9SgWfiThmh2oYdoOLyBP8VmnzhTcluZzI03yLzMH8wnl+0atjPAIu5IdIBy/
         KnSDGzEHN4/v9CHiQaGXF5KqzQDbpYzKYBizlDxmSCt1+T1PpQ/IGJwv6Nq/letSutkb
         xJmT4WSAjSCiMXq9Zleo6+RkTbhOn6+LdQw/SlhrOwJKrqZxdfllJCAvP/Upcay94Wuk
         bJBU7apZrQZGduAcxZPNWXTrGkBoE6zohW/jx/LACVVEi6XAj1H05ITKzddQhn9i/hSb
         kMfA==
X-Gm-Message-State: AOAM530+PJkZ13aLwsqudBdMRzUqkKCCmEWTrufrdpO35703quga9NhK
        J/hmk9GLG+zUGrEm7fuD0mK+dg==
X-Google-Smtp-Source: ABdhPJw8iQ11fvYVuOgf2IP7iRVkV6c4R80x9lXlBQ6Gxn5cDdDBq4q9gfbAANsRw2Bpdxco+vvnhg==
X-Received: by 2002:a17:90a:4fa3:: with SMTP id q32mr5445650pjh.123.1628009446069;
        Tue, 03 Aug 2021 09:50:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l11sm17179890pfd.187.2021.08.03.09.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:50:45 -0700 (PDT)
Date:   Tue, 3 Aug 2021 16:50:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Alper Gun <alpergun@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: improve the code readability for ASID
 management
Message-ID: <YQlz4YDu/W8+YsZl@google.com>
References: <20210802180903.159381-1-mizhang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210802180903.159381-1-mizhang@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Tom and Brijesh

On Mon, Aug 02, 2021, Mingwei Zhang wrote:
> KVM SEV code uses bitmaps to manage ASID states. ASID 0 was always skipped
> because it is never used by VM. Thus, in existing code, ASID value and its
> bitmap postion always has an 'offset-by-1' relationship.
> 
> Both SEV and SEV-ES shares the ASID space, thus KVM uses a dynamic range
> [min_asid, max_asid] to handle SEV and SEV-ES ASIDs separately.
> 
> Existing code mixes the usage of ASID value and its bitmap position by
> using the same variable called 'min_asid'.
> 
> Fix the min_asid usage: ensure that its usage is consistent with its name;
> allocate extra size for ASID 0 to ensure that each ASID has the same value
> with its bitmap position. Add comments on ASID bitmap allocation to clarify
> the size change.
> 
> v1 -> v2:
>  - change ASID bitmap size to incorporate ASID 0 [sean]
>  - remove the 'fixes' line in commit message. [sean/joerg]
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Alper Gun <alpergun@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vipin Sharma <vipinsh@google.com>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> ---

...

> @@ -156,11 +157,11 @@ static int sev_asid_new(struct kvm_sev_info *sev)
>  		goto e_uncharge;
>  	}
>  
> -	__set_bit(pos, sev_asid_bitmap);
> +	__set_bit(asid, sev_asid_bitmap);


This patch missed sev_asid_free(). 

And on a very related topic, I'm pretty sure the VMCB+ASID invalidation logic
indexes sev_vmcbs incorrectly.  pre_sev_run() indexes sev_vmcbs by the ASID,
whereas sev_asid_free() indexes by ASID-1, i.e. on free KVM nullifies the wrong
sev_vmcb entry.  sev_cpu_init() allocates for max_sev_asid+1, so indexing by
ASID appears to be the intended behavior.  That code is also a good candidate for
conversion to nr_asids in this patch.

For the sev_vmcbs bug:

From 78c334121adaa51a2a84942ec65dceefd3752590 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 3 Aug 2021 09:27:46 -0700
Subject: [PATCH] KVM: SVM: Fix off-by-one indexing when nullifying last used
 SEV VMCB

Use the raw ASID, not ASID-1, when nullifying the last used VMCB when
freeing an SEV ASID.  The consumer, pre_sev_run(), indexes the array by
the raw ASID, thus KVM could get a false negative when checking for a
different VMCB if KVM manages to reallocate the same ASID+VMCB combo for
a new VM.

Note, this cannot cause a functional issue _in the current code_, as
pre_sev_run() also checks which pCPU last did VMRUN for the vCPU, and
last_vmentry_cpu is initialized to -1 during vCPU creation, i.e. is
guaranteed to mismatch on the first VMRUN.  However, prior to commit
8a14fe4f0c54 ("kvm: x86: Move last_cpu into kvm_vcpu_arch as
last_vmentry_cpu"), SVM tracked pCPU on its own and zero-initialized the
last_cpu variable.  Thus it's theoretically possible that older versions
of KVM could miss a TLB flush if the first VMRUN is on pCPU0 and the ASID
and VMCB exactly match those of a prior VM.

Fixes: 70cd94e60c73 ("KVM: SVM: VMRUN should use associated ASID when SEV is enabled")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9f1585f40c85..f4f5d554eaaa 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -189,7 +189,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)

 	for_each_possible_cpu(cpu) {
 		sd = per_cpu(svm_data, cpu);
-		sd->sev_vmcbs[pos] = NULL;
+		sd->sev_vmcbs[sev->asid] = NULL;
 	}

 	mutex_unlock(&sev_bitmap_lock);
--
2.32.0.554.ge1b32706d8-goog

And fixup for this patch:


diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f3df1eba0c72..416ae0b687fc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -180,13 +180,12 @@ static int sev_get_asid(struct kvm *kvm)
 static void sev_asid_free(struct kvm_sev_info *sev)
 {
 	struct svm_cpu_data *sd;
-	int cpu, pos;
+	int cpu;
 	enum misc_res_type type;
 
 	mutex_lock(&sev_bitmap_lock);
 
-	pos = sev->asid - 1;
-	__set_bit(pos, sev_reclaim_asid_bitmap);
+	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
 		sd = per_cpu(svm_data, cpu);
@@ -1928,7 +1927,7 @@ int sev_cpu_init(struct svm_cpu_data *sd)
 	if (!sev_enabled)
 		return 0;
 
-	sd->sev_vmcbs = kcalloc(max_sev_asid + 1, sizeof(void *), GFP_KERNEL);
+	sd->sev_vmcbs = kcalloc(nr_asids, sizeof(void *), GFP_KERNEL);
 	if (!sd->sev_vmcbs)
 		return -ENOMEM;
 
--
