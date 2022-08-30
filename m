Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDDF5A71F1
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiH3XjG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiH3XjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:39:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6EB117
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:39:03 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fa2so4886314pjb.2
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jV+TJTznHVc9eXF49TFmoCezKm/gvS3NXfE7LqS48eA=;
        b=SD5HkEsbFOgrLQoUbLpEQLLNthNpDPBPrFlbszyD5h61nDl11EuIcf0fLwK/KHStsL
         +DxR72frBUm207L43KgeEKcLyOj/39SETvqqn4vYNyoWEl2qMT0NeK8GqDo27vdTs/2i
         UBxP7GgCa5j4LrWBFixVLUyG/7lEB4+Jzw3c6HqMB4iqWrNElpbiFqiRmGnAj02UMggZ
         4gW5vSUKvSmBnSFVoUWvX0nt9na6fJlnx9vv+4D+8VfTZzq39UaGKR2d18CI+ike/0UW
         roCoy/iXlgMp2K/RHXtbhCvZ92IhrYhJzBC8txeMr62+xuU1YeF01UvX2la10jpwY+i5
         H7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jV+TJTznHVc9eXF49TFmoCezKm/gvS3NXfE7LqS48eA=;
        b=Z9tdzopZjHAbisb9u0JGdPNYRkuMK9OnC/+2r0wSZLWfHYuDHiugX+wfVtUR7FTWBR
         pHQSPol2yN8Sbe8mZM0h+SrY/qkjmLvMFuyUd3Cv5NRVHJ7v75AOADeppqk74kRRPtpH
         JIZxVbx1z2LhsA7Ta6/Kr/zYB2lT/mV1PU+vd4oPgcCgVU17s2vMb3A2xK9RaC9CL30g
         hglccA8duPiqSg1DjQrjTBIDXZ4+D2WNLH61C+bERgGnciy9kvuime3ua4f3rz8NgHqk
         gs70K6In1OfYNhuFXAEhLr7zmZsDs8EOrZsuVnWLQoiqNyuCxE1jgHGU/fPCx4m4kWt/
         +ZYg==
X-Gm-Message-State: ACgBeo2oY4FHA6CGG7bqCBbsRZJ+2UV5eTNNJiSVoWdPR7lA1E/8CsXN
        wEHpjeYI/GVofLdoHq5RLx9etA==
X-Google-Smtp-Source: AA6agR5SY20p6CFS+Y3GegFNkuwSJDjP3H19PvzkvO+MX9gajHk1Cs7Y/q0gd6Jha5B1AGQgKIWpXA==
X-Received: by 2002:a17:902:d50b:b0:172:a41f:b204 with SMTP id b11-20020a170902d50b00b00172a41fb204mr22948509plg.70.1661902743060;
        Tue, 30 Aug 2022 16:39:03 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b001751d0ac555sm2239942plx.148.2022.08.30.16.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 16:39:02 -0700 (PDT)
Date:   Tue, 30 Aug 2022 23:38:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH v2 2/2] KVM: x86: Expose Predictive Store Forwarding
 Disable on Intel parts
Message-ID: <Yw6fkyJrsu/i+Byy@google.com>
References: <20220830225210.2381310-1-jmattson@google.com>
 <20220830225210.2381310-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830225210.2381310-2-jmattson@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Jim Mattson wrote:
> Intel enumerates support for PSFD in CPUID.(EAX=7,ECX=2):EDX.PSFD[bit
> 0]. Report support for this feature in KVM if it is available on the
> host.
> 
> Presumably, this feature bit, like its AMD counterpart, is not welcome
> in cpufeatures.h, so add a local definition of this feature in KVM.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 07be45c5bb93..b5af9e451bef 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -62,6 +62,7 @@ u32 xstate_required_size(u64 xstate_bv, bool compacted)
>   * This one is tied to SSB in the user API, and not
>   * visible in /proc/cpuinfo.
>   */
> +#define KVM_X86_FEATURE_PSFD		0          /* Predictive Store Forwarding Disable */

I believe we can use "enum kvm_only_cpuid_leafs" to handle this.  E.g. 

	enum kvm_only_cpuid_leafs {
		CPUID_12_EAX	 = NCAPINTS,
		CPUID_7_2_EDX,
		NR_KVM_CPU_CAPS,

		NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
	};

then the intended use of KVM_X86_FEATURE_*

	#define KVM_X86_FEATURE_PSFD	KVM_X86_FEATURE(CPUID_7_2_EDX, 0)

I _think_ we can then define an arbitrary word for X86_FEATURE_PSFD, e.g.

	#define X86_FEATURE_PSFD	(NKVMCAPINTS*32+0)

and then wire up the translation:

	static __always_inline u32 __feature_translate(int x86_feature)
	{
		if (x86_feature == X86_FEATURE_SGX1)
			return KVM_X86_FEATURE_SGX1;
		else if (x86_feature == X86_FEATURE_SGX2)
			return KVM_X86_FEATURE_SGX2;
		else if (x86_feature == X86_FEATURE_PSFD)
			return KVM_X86_FEATURE_PSFD;
	
		return x86_feature;
	}

I believe/hope that allows us to use at least cpuid_entry_override().  Open coding
masking of specific registers was a mess that I don't want to repeat.
