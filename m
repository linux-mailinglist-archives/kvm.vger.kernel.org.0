Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC447B2174
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjI1PhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 11:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjI1PhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 11:37:22 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546D7DD
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:37:20 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f8040b2ffso170511577b3.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 08:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695915439; x=1696520239; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESjv6/OZiwDAaibxySOEd24QWBP6h1ze9OpmoOfalec=;
        b=EUd4pQ9Gws5Pq+aJ4/g113XjGsFTlDnHRJ1q8qlwdDWUfYq5Yh3rHSvMU9TNP3LrDl
         KzXDEP9hYyzKGl88G7nF9Bg6tQj9HQRDollBxtI8sGEqlRQsgvTQy70SJvn+mYz/ziic
         AtgSy0/ApcpFfxnQ15VEpUOM3ini/LLR6Msa4lEwe6fmeLf0PwOOZdZ0t5P1rzWlT79o
         FIuBFf2IDZm4f5DMMDDFsSb3dDlQp++LZC491cnF+8WQ0BkoVJL32Do7zfSGGk6vt64t
         W6csKWGaRyJkS96zQe6kRYPb/RiXj/jxSFYEnEfAtWPstV9Hgt+pv+HEBO8LhcIOxejw
         7FiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695915439; x=1696520239;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESjv6/OZiwDAaibxySOEd24QWBP6h1ze9OpmoOfalec=;
        b=VTGW+g9EKirpU9vrsvj3GFh1vCsa6bM2XMNFsl4ArLTU84xQhrIUTpn2Ntz1KPClAM
         HyAZuvyNq9NGFdJqan7N2IRqSiwVPaRBGtWvm8KPFCDIs7m71LMnDqnj9lPGk48PQkYY
         meTK7KCCuf6HMR0TU2sVHLcw83tvfC5lM16GcIZgyhFkUSdLvZQMxSnHchpHk6jEN4N0
         n8rqGEyZ6iRmF46ml0FWrHEUWlbbmbW7TFfsJW397NaO7pQL1+6rMZ97uMdXLeA+4+VT
         DX0/y9IM7JC/yplmaAJ3HVMWFneuwggPt5ivS2bl43KdcLwj7wWVQHDLr1jTEfEshCSH
         e8sQ==
X-Gm-Message-State: AOJu0YzjZA75jTr+4VXFA/UzML4dQhCWOJ9bcLe4GvlxH5z9JLYaGyKR
        X3DJwZhB4JC4Asy4eKntfOYa2VZw6Bo=
X-Google-Smtp-Source: AGHT+IEGP17fNTPrQ4AyY729ngrGoUL/gl5UpyjrVFFDHHoJHMKzXnWTPF8kdaQC3pFKL2kLKxYzCqKL1hQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b709:0:b0:5a1:d329:829c with SMTP id
 v9-20020a81b709000000b005a1d329829cmr24447ywh.0.1695915439513; Thu, 28 Sep
 2023 08:37:19 -0700 (PDT)
Date:   Thu, 28 Sep 2023 08:37:18 -0700
In-Reply-To: <20230928150428.199929-6-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928150428.199929-1-mlevitsk@redhat.com> <20230928150428.199929-6-mlevitsk@redhat.com>
Message-ID: <ZRWdrtHynEbtQnpZ@google.com>
Subject: Re: [PATCH 5/5] x86: KVM: SVM: workaround for AVIC's errata #1235
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
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: SVM: for the shortlog scope (applies to all relevant patches in this series)

On Thu, Sep 28, 2023, Maxim Levitsky wrote:
> On Zen2 (and likely on Zen1 as well), AVIC doesn't reliably detect a change
> in the 'is_running' bit during ICR write emulation and might skip a
> VM exit, if that bit was recently cleared.
> 
> The absence of the VM exit, leads to the KVM not waking up / triggering
> nested vm exit on the target(s) of the IPI which can, in some cases,
> lead to an unbounded delays in the guest execution.
> 
> As I recently discovered, a reasonable workaround exists: make the KVM

Nit, please just write "KVM", not "the KVM".  KVM is a proper noun when used in
this way, e.g. saying "the KVM" is like saying "the Sean" or "the Maxim".

> never set the is_running bit.
> 
> This workaround ensures that (*) all ICR writes always cause a VM exit
> and therefore correctly emulated, in expense of never enjoying VM exit-less
> ICR emulation.

This breaks svm_ir_list_add(), which relies on the vCPU's entry being up-to-date
and marked running to detect that IOMMU needs to be immediately pointed at the
current pCPU.

	/*
	 * Update the target pCPU for IOMMU doorbells if the vCPU is running.
	 * If the vCPU is NOT running, i.e. is blocking or scheduled out, KVM
	 * will update the pCPU info when the vCPU awkened and/or scheduled in.
	 * See also avic_vcpu_load().
	 */
	entry = READ_ONCE(*(svm->avic_physical_id_cache));
	if (entry & AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK)
		amd_iommu_update_ga(entry & AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK,
				    true, pi->ir_data);

> This workaround does carry a performance penalty but according to my
> benchmarks is still much better than not using AVIC at all,
> because AVIC is still used for the receiving end of the IPIs, and for the
> posted interrupts.

I really, really don't like the idea of carrying a workaround like this in
perpetuity.  If there is a customer that is determined to enable AVIC on Zen1/Zen2,
then *maybe* it's something to consider, but I don't think we should carry this
if the only anticipated beneficiary is one-off users and KVM developers.  IMO, the
AVIC code is complex enough as it is.
