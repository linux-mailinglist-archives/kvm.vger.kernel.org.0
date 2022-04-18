Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E1D505604
	for <lists+kvm@lfdr.de>; Mon, 18 Apr 2022 15:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241854AbiDRNbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 09:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244784AbiDRNay (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 09:30:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E3EB1EAE7
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 05:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650286522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ko1k1fU4FuGAEDeyXkrcC555L5G5PS8Gw/yrT6nSdxE=;
        b=KEOFIhjKJNeODe0q/rcRQbsEJvFBZBuWRrF3WQChtxbQQrJLlRnZ/IsM4dfPsd/ZxBJDQo
        w6CuSuTWS1eo9UaGSY+F+v3/mHwGURmH9JfjmWNWENbxBCSKunBR94XhlYNvaG0CmxwqM+
        J879S8hUap685TZahLRPvK0Z+BAWmmU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-yOdWIB2ZPV-E5lEUHxNUVw-1; Mon, 18 Apr 2022 08:55:06 -0400
X-MC-Unique: yOdWIB2ZPV-E5lEUHxNUVw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F0CC802819;
        Mon, 18 Apr 2022 12:55:06 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8FD65E2C39;
        Mon, 18 Apr 2022 12:55:03 +0000 (UTC)
Message-ID: <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 18 Apr 2022 15:55:02 +0300
In-Reply-To: <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
         <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-12 at 06:58 -0500, Suravee Suthikulpanit wrote:
> When APIC mode is updated (e.g. disabled, xAPIC, or x2APIC),
> KVM needs to call kvm_vcpu_update_apicv() to update AVIC settings
> accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 15 +++++++++++++++
>  arch/x86/kvm/svm/svm.c  |  1 +
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 22ee1098e2a5..01392b8364f4 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -616,6 +616,21 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	avic_handle_ldr_update(vcpu);
>  }
>  
> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> +		return;
> +
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> +		return;
> +	}
> +
> +	kvm_vcpu_update_apicv(&svm->vcpu);

I think it makes sense to call avic_refresh_apicv_exec_ctrl directly here.
 
I am not sure that kvm_vcpu_update_apicv will even call it
because it has an optimization of doing nothing when inhibition status
didn't change.
 
 
Another semi-related note:
 
the current way the x2avic msrs are configured creates slight performance 
problem for nesting:
 
The problem is that when entering a nested guest, AVIC on the current vCPU
is inhibited, but this is done only so that this vCPU *peers* don't
try to use AVIC to send IPIs to it, so there is no need to update vmcb01
msr interception bitmap, and vmcb02 should have all these msrs intercepted always.
Same with returning to host.

It also should be checked that during nested entry, at least vmcb01 msr bitmap
is updated - TL;DR - please check that x2avic works when there is a nested guest running.
 

My avic nested coexistence patches are already upstream (kvm/queue) so this is already
relevant.
 
With nested x2avic (which will be very easy to do after my nested AVIC code is
upstream, vmcb02 will need to have x2avic msrs not intercepted as long as L1
doesn't want to intercept them if nested x2avic is enabled).

Best regards,
	Maxim Levitsky


> +}
> +
>  static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>  {
>  	int ret = 0;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c85663b62d4e..b7dbd8bb2c0a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4606,6 +4606,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.enable_nmi_window = svm_enable_nmi_window,
>  	.enable_irq_window = svm_enable_irq_window,
>  	.update_cr8_intercept = svm_update_cr8_intercept,
> +	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>  	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,


