Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1EF64B2AC0
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351665AbiBKQok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:44:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351659AbiBKQoj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:44:39 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31244D6A
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:44:38 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id n23so17299322pfo.1
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r7NCO79fgZUXR96waIBzEeiI4gx4cTiLegBPPI5RNb8=;
        b=Q5OzlsIC4foZeakkGt9H8BjVT2KH/yZ/4TfSdFiUKGp5oU+SorT6vicq3AjtOpNzJw
         v1f2tflNnlumvQ809bGznbktwquG3rlCJtuHZtaExab1SiqFwg7BzV0sDt5B5D9rVOGR
         Aww0R0/rV2U9Qwzt0/QvRu2iCkFGczwxdTRcAWnGHWYpxEmztpcSQQKxlxWWw4uTAbB3
         USv/GEFjMm6BMNaI8Z2m5pVRO9Vut5cW5xnZvEFDthk55ddRSHPiBpDLOU/TYoaI0ImO
         Ru8TByld3V1DF75IIE2D3UIHr23aBRujTS1JZZl4+kVuxKW6uWAuKHuU9Z+T5YuUZPwn
         qPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r7NCO79fgZUXR96waIBzEeiI4gx4cTiLegBPPI5RNb8=;
        b=MTlEyqgdjTTlb4NepNuFLzQjVc+7mxTH6u7uJYhjrhyfyU2N8n2n2W1NR2z5iMVtrx
         P0w8KH6o3glqyFcL8nVfXMJWJ552ERxj7zIDs3YD7a+VaWC4QQGnVb2xa9uEJJggkbQc
         hdVW8+820A0SojhKU7avZ2bzUKsc5WP/v3JGILziMO3xPz0DvkfzKSMVvPpK3SRwXf/o
         mq//4IwP3dS0m7UsB+ITGNlq5WDauId2t94JEdUm3CTyjZR8Dif+zIfpWtRDrKIaxo7P
         x753r5pnNAFb0CTVYpysfIzLhQzHeb2NADO4lr9zinpUKmz2dnvS+tXPfwv9W4ohjj06
         ig1A==
X-Gm-Message-State: AOAM532bQMWjVIWSinEwVuvJQHxefmlde3rH4HDnn5g2F8029lKqosQl
        rj3JM/ZKiHGTUyv7CK7rs2+N5a5Lke1b3A==
X-Google-Smtp-Source: ABdhPJyjAIoZ/R9oEZ8eL+pz+reQ18dctVyR3eFvE//hoFFGEaHJCLU6dR7zg2dzJ1JG4ry0oqA/Tw==
X-Received: by 2002:a63:81c3:: with SMTP id t186mr2011835pgd.460.1644597877458;
        Fri, 11 Feb 2022 08:44:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gk15sm6250388pjb.3.2022.02.11.08.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:44:36 -0800 (PST)
Date:   Fri, 11 Feb 2022 16:44:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH 1/3] KVM: SVM: extract avic_ring_doorbell
Message-ID: <YgaScaJD6fpk2xgJ@google.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
 <20220211110117.2764381-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211110117.2764381-2-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> The check on the current CPU adds an extra level of indentation to
> svm_deliver_avic_intr and conflates documentation on what happens
> if the vCPU exits (of interest to svm_deliver_avic_intr) and migrates
> (only of interest to avic_ring_doorbell, which calls get/put_cpu()).
> Extract the wrmsr to a separate function and rewrite the
> comment in svm_deliver_avic_intr().
> 
> Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Bad SoB chain, should be:

  Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
  Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
  Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Interestingly, git-apply drops the second, redundant SoB and yields

  Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
  Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
  Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>

Which will probably get you yelled at by Stephen's scripts :-)

A few nits below...

Reviewed-by: Sean Christopherson <seanjc@google.com>

> ---
>  arch/x86/kvm/svm/avic.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3f9b48732aea..4d1baf5c8f6a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -269,6 +269,24 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +

Spurious newline.

> +static void avic_ring_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Note, the vCPU could get migrated to a different pCPU at any
> +	 * point, which could result in signalling the wrong/previous
> +	 * pCPU.  But if that happens the vCPU is guaranteed to do a
> +	 * VMRUN (after being migrated) and thus will process pending
> +	 * interrupts, i.e. a doorbell is not needed (and the spurious
> +	 * one is harmless).

Please run these out to 80 chars, it saves a whole line!

	/*
	 * Note, the vCPU could get migrated to a different pCPU at any point,
	 * which could result in signalling the wrong/previous pCPU.  But if
	 * that happens the vCPU is guaranteed to do a VMRUN (after being
	 * migrated) and thus will process pending interrupts, i.e. a doorbell
	 * is not needed (and the spurious one is harmless).
	 */

> +	 */
> +	int cpu = READ_ONCE(vcpu->cpu);
> +
> +	if (cpu != get_cpu())
> +		wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
> +	put_cpu();
> +}
> +
>  static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  				   u32 icrl, u32 icrh)
>  {
