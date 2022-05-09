Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B5651F9D9
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiEIK1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 06:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiEIK1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 06:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 527961B1876
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 03:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652091749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PsTBPUPQ0O3bhvSB3QVk8Bq0LJrPpwn+o+Q6zeFi2gM=;
        b=B3UPtulVY5J8zpdSr1Hn0aSyALcpIgPJTFStQQJI3VJWWoSCVArx3sTBmgLYe1hXDB66L7
        oKiQNkCWxaBAqUyONxUM6+TCyY/+rdtwRS6wsckskKajMDvSkeBSNt5i2tingUSk3yMPcl
        zduuqQ/gV6hwegXXJ8uWeNmjZ8Ab3qQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-J8BWomqPO9KX5EAituMuWw-1; Mon, 09 May 2022 06:22:26 -0400
X-MC-Unique: J8BWomqPO9KX5EAituMuWw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D568803D7B;
        Mon,  9 May 2022 10:22:25 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD8542166B4A;
        Mon,  9 May 2022 10:22:19 +0000 (UTC)
Message-ID: <916f8d9c18d264d120d4ed7101583f4f22f66622.camel@redhat.com>
Subject: Re: [PATCH v4 09/15] KVM: SVM: Refresh AVIC configuration when
 changing APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Mon, 09 May 2022 13:22:17 +0300
In-Reply-To: <20220508023930.12881-10-suravee.suthikulpanit@amd.com>
References: <20220508023930.12881-1-suravee.suthikulpanit@amd.com>
         <20220508023930.12881-10-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 2022-05-07 at 21:39 -0500, Suravee Suthikulpanit wrote:
> AMD AVIC can support xAPIC and x2APIC virtualization,
> which requires changing x2APIC bit VMCB and MSR intercepton
> for x2APIC MSRs. Therefore, call avic_refresh_apicv_exec_ctrl()
> to refresh configuration accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 12 ++++++++++++
>  arch/x86/kvm/svm/svm.c  |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 16ce2d50efac..a82981722018 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -691,6 +691,18 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  	avic_handle_ldr_update(vcpu);
>  }
>  
> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
> +{
> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> +		return;
> +
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
> +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
> +		return;
> +	}
> +	avic_refresh_apicv_exec_ctrl(vcpu);
> +}
> +
>  static int avic_set_pi_irte_mode(struct kvm_vcpu *vcpu, bool activate)
>  {
>  	int ret = 0;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 314628b6bff4..9066568fd19d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4692,6 +4692,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.enable_nmi_window = svm_enable_nmi_window,
>  	.enable_irq_window = svm_enable_irq_window,
>  	.update_cr8_intercept = svm_update_cr8_intercept,
> +	.set_virtual_apic_mode = avic_set_virtual_apic_mode,
>  	.refresh_apicv_exec_ctrl = avic_refresh_apicv_exec_ctrl,
>  	.check_apicv_inhibit_reasons = avic_check_apicv_inhibit_reasons,
>  	.apicv_post_state_restore = avic_apicv_post_state_restore,

Looks good as well!

This code can also be removed in the future as optimization,a
and do everything in avic_refresh_apicv_exec_ctrl instead.
No need to do this now though.

I need to understand the APICv KVM's code better to understand if
this is worth it.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

