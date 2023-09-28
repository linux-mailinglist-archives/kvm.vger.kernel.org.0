Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9644E7B21A2
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjI1Pqg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjI1Pqe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:46:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD34DD
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:46:31 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7fd4c23315so20546177276.2
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695915991; x=1696520791; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkV6DJLEp14NQoEGpYmTcHsFBbLNhclSblSFOKPN4t4=;
        b=bcCmjl+EprAvjn1eZIfev+s5ctSXE3a39Ncr6++juAnghiOXv2Qlact2Hyll1lFRRS
         Kmj/SzC8F9qnZJoJMlpP9/Oo1grFz3Pxpys6yxsh0MaWGe3UUpzHN+Sf7iV9AhDKjoxE
         INpSsKiyyyVMY0iSZyFkrSA764NGY/lXnlBsUOiCfmA4DFisVv3nMg8jeY0xP4QisesH
         JTnBLXZgDKJCU17I4l+eZ6ELoHj5yZZLk0i4Y0IOa1ycwWUJzw9Ulo5syLYveXlDCPFG
         U0MeOAsaZmoXPPokgmVIRF9TmFDc5nt2NFR8lEWfr7ZunFn1C9zzY2HHPji43YrNdmJG
         ttrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695915991; x=1696520791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkV6DJLEp14NQoEGpYmTcHsFBbLNhclSblSFOKPN4t4=;
        b=dx2bX7yAt234y+pmIkvA0ewkrLdDI783BXVq481jNDCmvWZlvqSBC/d62D9TG5AKiv
         b+WS4zcWNE+BIeLtjtwuD2JBoAQUa+qJVp6TNjTh3OMeZ0prf6uOHsJ4rs3ufZbfKyvd
         CYHj7JjLTa88tmUUIw/E++zkfZtNhDh7kN1BcjKTReIUUJQ5FoCldT+umwC2rXuRa7uL
         rBNU2DLVLuX0d6PM8xh5RT27I1K2MSXDsKykNOuhCvx0NwKw7wDdWgTnd5JvQ/g7lU1P
         xmTwIA9mc8/U7CsiOA4V4CvO5snZuQrXYXWE7+7lnfknROrevn/rLRcnuMxn4kBg/ck6
         nDJg==
X-Gm-Message-State: AOJu0Yxak4EtvmckblTg1InIq4aoCgwVXOmgmFI3YWGWGba/8bpHCTRN
        A1iSshcJmZETFL6KZfNX/+QdTAIg8xg=
X-Google-Smtp-Source: AGHT+IEWX4T56HPfxAmtAicLu3EcKVpChcE7iMMF3BlcUKBkp8bJf66fPphCxJhGyetbdNcj2NdIprAzUe8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f4d:0:b0:d7b:8acc:beb8 with SMTP id
 h13-20020a255f4d000000b00d7b8accbeb8mr24990ybm.2.1695915990966; Thu, 28 Sep
 2023 08:46:30 -0700 (PDT)
Date:   Thu, 28 Sep 2023 08:46:29 -0700
In-Reply-To: <20230928150428.199929-3-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928150428.199929-1-mlevitsk@redhat.com> <20230928150428.199929-3-mlevitsk@redhat.com>
Message-ID: <ZRWf1Z7JCMUT92zt@google.com>
Subject: Re: [PATCH 2/5] x86: KVM: SVM: add support for Invalid IPI Vector interception
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> In later revisions of AMD's APM, there is a new 'incomplete IPI' exit code:
> 
> "Invalid IPI Vector - The vector for the specified IPI was set to an
> illegal value (VEC < 16)"
> 
> Note that tests on Zen2 machine show that this VM exit doesn't happen and
> instead AVIC just does nothing.
> 
> Add support for this exit code by doing nothing, instead of filling
> the kernel log with errors.
> 
> Also replace an unthrottled 'pr_err()' if another unknown incomplete
> IPI exit happens with WARN_ON_ONCE()
> 
> (e.g in case AMD adds yet another 'Invalid IPI' exit reason)
> 
> Cc: <stable@vger.kernel.org>
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/svm.h | 1 +
>  arch/x86/kvm/svm/avic.c    | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 19bf955b67e0da0..3ac0ffc4f3e202b 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -268,6 +268,7 @@ enum avic_ipi_failure_cause {
>  	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
>  	AVIC_IPI_FAILURE_INVALID_TARGET,
>  	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
> +	AVIC_IPI_FAILURE_INVALID_IPI_VECTOR,
>  };
>  
>  #define AVIC_PHYSICAL_MAX_INDEX_MASK	GENMASK_ULL(8, 0)
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 2092db892d7d052..c44b65af494e3ff 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -529,8 +529,11 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>  	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>  		WARN_ONCE(1, "Invalid backing page\n");
>  		break;
> +	case AVIC_IPI_FAILURE_INVALID_IPI_VECTOR:
> +		/* Invalid IPI with vector < 16 */
> +		break;
>  	default:
> -		pr_err("Unknown IPI interception\n");
> +		WARN_ONCE(1, "Unknown avic incomplete IPI interception\n");

Hrm, I'm not sure KVM should WARN here.  E.g. if someone runs with panic_on_warn=1,
running on new hardware might crash the host.  I hope that AMD is smart enough to
make any future failure types "optional" in the sense that they're either opt-in,
or are largely informational-only (like AVIC_IPI_FAILURE_INVALID_IPI_VECTOR).

I think switching to vcpu_unimpl(), or maybe even pr_err_once(), is more appropriate.
