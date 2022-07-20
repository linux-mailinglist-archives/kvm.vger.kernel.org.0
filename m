Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C182457BFD4
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 23:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiGTVyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 17:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiGTVyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 17:54:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F1D4B0D1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:54:19 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id bk6-20020a17090b080600b001f2138a2a7bso3073825pjb.1
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jK6tZAVLlpKQaYUdrFhp6jMza1P7Y68lK+h4BL/v32U=;
        b=bb98mV59J227Gzh/7pVgul7s8I0m8osIYW3lUlal2sBMW6xjav+1p6xkJtJazn3Mok
         J//BBdPQpXecD7+EhWvOvCltmXpnI/a/ICbDRKTuq61zuiZvri80vPGiEUUmaJqFF3Mi
         Zi2WDSRXPk/Soa8PjpvEWT8m2FCXt05Ib1eBWCA8ivsbdCpnTy4ghKR1pDhsVln29nQk
         tcO+yHWxsR5A34ZKgL0lPbUsfqQU08E1MULduTTsedAm7FJMOeoGj53+SQafmoeDD3r9
         rrcdvQzIls9I15ogFqdOjwcAwOHhfa9z1J/ncy147O1ttAStxNqJUzKgiwV3icnRz0mX
         A7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jK6tZAVLlpKQaYUdrFhp6jMza1P7Y68lK+h4BL/v32U=;
        b=J+xVXWVq230PfvgT0Y3WeWBN1kSJ7JMR7HvtpkLeex7C0VIrYisttmjqqtC9ILUUyn
         YYmVwbCJphHCs6RGHKgaZXgZiTOUxGOReZKCUxaSp5Ba1p69HLLJd3I9Jvxs7cRYYYJh
         HyGHhFStvDZ+i7EGiaWCNE3FM02Ml2QrElEAb5Uti29njQDJaG1Lc8iRzc77QSE6j9SC
         pWnyVXZ+LCyQNKEzMGE19GpWOIkVCdaDnUPcwzr/HhIP4xqa7hkkzV1LwLKh4naKeLI3
         rZ+kqnlj/LFdDVwHJBB0ouT+GkLoUqRePKMyUChcsDepKISd+YEIDQ4BXcbgVZt8f8xi
         58xA==
X-Gm-Message-State: AJIora/Odrd7vbWVGRo7Jg6HrpUHtvl8kaKXJ/KQJ4BMPuphql406491
        elE759XP6IBR92faiHu2jsJajw==
X-Google-Smtp-Source: AGRyM1vStDlNny4fDdiDFJ8dmGdUdCUD+1Ycb4i6vQYzM6OiOymkMtuHm6tYxo3g2qaD1skEB041+Q==
X-Received: by 2002:a17:902:e886:b0:16b:faee:ccfc with SMTP id w6-20020a170902e88600b0016bfaeeccfcmr41017840plg.114.1658354059054;
        Wed, 20 Jul 2022 14:54:19 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u22-20020a17090adb5600b001f1a8c24b5esm2167407pjx.6.2022.07.20.14.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:54:18 -0700 (PDT)
Date:   Wed, 20 Jul 2022 21:54:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/7] KVM: SVM: Report NMI not allowed when Guest busy
 handling VNMI
Message-ID: <Yth5hl+RlTaa5ybj@google.com>
References: <20220709134230.2397-1-santosh.shukla@amd.com>
 <20220709134230.2397-5-santosh.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709134230.2397-5-santosh.shukla@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 09, 2022, Santosh Shukla wrote:
> In the VNMI case, Report NMI is not allowed when the processor set the
> V_NMI_MASK to 1 which means the Guest is busy handling VNMI.
> 
> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
> ---
> v2:
> - Moved vnmi check after is_guest_mode() in func _nmi_blocked().
> - Removed is_vnmi_mask_set check from _enable_nmi_window().
> as it was a redundent check.
> 
>  arch/x86/kvm/svm/svm.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3574e804d757..44c1f2317b45 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3480,6 +3480,9 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>  	if (is_guest_mode(vcpu) && nested_exit_on_nmi(svm))
>  		return false;
>  
> +	if (is_vnmi_enabled(svm) && is_vnmi_mask_set(svm))
> +		return true;
> +
>  	ret = (vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) ||
>  	      (vcpu->arch.hflags & HF_NMI_MASK);
>  
> @@ -3609,6 +3612,9 @@ static void svm_enable_nmi_window(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  
> +	if (is_vnmi_enabled(svm))
> +		return;

Ugh, is there really no way to trigger an exit when NMIs become unmasked?  Because
if there isn't, this is broken for KVM.

On bare metal, if two NMIs arrive "simultaneously", so long as NMIs aren't blocked,
the first NMI will be delivered and the second will be pended, i.e. software will
see both NMIs.  And if that doesn't hold true, the window for a true collision is
really, really tiny.

But in KVM, because a vCPU may not be run a long duration, that window becomes
very large.  To not drop NMIs and more faithfully emulate hardware, KVM allows two
NMIs to be _pending_.  And when that happens, KVM needs to trigger an exit when
NMIs become unmasked _after_ the first NMI is injected.

> +
>  	if ((vcpu->arch.hflags & (HF_NMI_MASK | HF_IRET_MASK)) == HF_NMI_MASK)
>  		return; /* IRET will cause a vm exit */
>  
> -- 
> 2.25.1
> 
