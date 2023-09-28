Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7D857B21EC
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjI1QDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbjI1QDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:03:34 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89881A8
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:03:32 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c61aafab45so98558285ad.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695917012; x=1696521812; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFUmYNpX6rTwdApxep2QFE0XCc25ZJa3cg6mPE92sAo=;
        b=ne5ac2d9XhOSetla4lMicK663QBj/eBPFpXZbXBBfyMNcYrDIecMO8r/a/YApklWWE
         eAkYaCLCYIFsvGrUEdIZQpdFvARP/jEPpEMttsI4dptKzj0A4l9HjC6696ifIqkpK/U+
         /QzEZTH1DddU6gOQZ2/4o2G6dBdF8Y//lbDM8qK6hZWy+J9ZgVCC7+r97pijyBBqjZxh
         sRQLWgLFWppabJA/2+ly7rmSVhyosWk+baUmMfNS8V2rBSsdnBMiULwBwbj0nANdTuGY
         oyvLDfsKpd3JmnY+j3DSRfanqbjj4H3MXmQwogpdo5g18KskYDgUhqB0UgObqnRMOexZ
         TfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695917012; x=1696521812;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFUmYNpX6rTwdApxep2QFE0XCc25ZJa3cg6mPE92sAo=;
        b=DXfa575ABjwQBeoPrqkdHOT+z6DJh+ah34m8g2wIS54tKNXNT7XLSG+MYlQDGlf5KC
         5X0YcWBtR2HoKuRUcVj5Y7j+SRVw1uZCmFW1fMnRaLTnznLhrxyl4fuAroKIEU2yGYDx
         rwhZ1RaykwMX71mGasnxu+YGUEz7Z3kQtYaD4DseYlYuCqf9OXIfp5UELRu3BDXyUo90
         m9tN2JsCUih8YkEXy+l8hHcF/dC0w3I4bEnK1ue62YqXMV5v7k5tMHFKFwGa22SeXJjc
         8qmsoAGe2kBvzljZwMkX7jHPy48Tvc/1aPU072iTthuVeRRgP/poHnth/wd386BdJOZ1
         fqjw==
X-Gm-Message-State: AOJu0Yx5ObGv81oBeDOW5QZ4sHcD25keTOof6agKcTdcTEF44RJPXUCb
        WjHLZRHVgrZArtLlsvdFBSa7q3FD/fM=
X-Google-Smtp-Source: AGHT+IFNYZN6ptDJkMmwLSNuZPQjEWOAcWQREE8N0qlp/jqzMy/uAdJQYt5rwc8mhcDZlWu1erWrGHWMPok=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5c7:b0:1bb:c7c6:3462 with SMTP id
 u7-20020a170902e5c700b001bbc7c63462mr21438plf.8.1695917012352; Thu, 28 Sep
 2023 09:03:32 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:03:31 -0700
In-Reply-To: <20230928150428.199929-4-mlevitsk@redhat.com>
Mime-Version: 1.0
References: <20230928150428.199929-1-mlevitsk@redhat.com> <20230928150428.199929-4-mlevitsk@redhat.com>
Message-ID: <ZRWj0_VGvrg148He@google.com>
Subject: Re: [PATCH 3/5] x86: KVM: SVM: refresh AVIC inhibition in svm_leave_nested()
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
> svm_leave_nested() similar to a nested VM exit, get the vCPU out of nested
> mode and thus should end the local inhibition of AVIC on this vCPU.
> 
> Failure to do so, can lead to hangs on guest reboot.
> 
> Raise the KVM_REQ_APICV_UPDATE request to refresh the AVIC state of the
> current vCPU in this case.
> 
> Cc: stable@vger.kernel.org

Unnecessary newline.

Fixes: f44509f849fe ("KVM: x86: SVM: allow AVIC to co-exist with a nested guest running")

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index dd496c9e5f91f28..3fea8c47679e689 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1253,6 +1253,9 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
>  
>  		nested_svm_uninit_mmu_context(vcpu);
>  		vmcb_mark_all_dirty(svm->vmcb);
> +
> +		if (kvm_apicv_activated(vcpu->kvm))
> +			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>  	}
>  
>  	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> -- 
> 2.26.3
> 
