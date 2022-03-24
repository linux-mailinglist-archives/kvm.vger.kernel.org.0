Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58DB4E661F
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 16:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351237AbiCXPhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 11:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347796AbiCXPhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 11:37:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5EBCF4833C
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 08:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648136149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5w7kSkFlck7a7bG/2DVHNDf7u0xicIB6ZKaJ9gY3ATY=;
        b=harmjBJrMNxLG0No7B35BY4+V9IB8B5sJF5h93K0qYB8SFne7dRFo8GgGxRRTcxY8iiHL/
        XTKjXfFzYK+subVHloXYIbj1OMjOPt+x5hvdCPrCf4lB/uxkvdqxgr4mAs6uREauqG5LsR
        E44SYEA8Z8P+eOlpQBvV8L0WMXMEImg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-XqGGEjCyPcyl_IkcahlaPA-1; Thu, 24 Mar 2022 11:35:48 -0400
X-MC-Unique: XqGGEjCyPcyl_IkcahlaPA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE0503804512;
        Thu, 24 Mar 2022 15:35:46 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3CEA401475;
        Thu, 24 Mar 2022 15:35:44 +0000 (UTC)
Message-ID: <91692f799dfa1d064b8f2839789869aebcaa6c5f.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 09/12] KVM: SVM: Refresh AVIC settings when
 changing APIC mode
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 17:35:43 +0200
In-Reply-To: <20220308163926.563994-10-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-10-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> When APIC mode is updated (e.g. from xAPIC to x2APIC),
> KVM needs to update AVIC settings accordingly, whic is
> handled by svm_refresh_apicv_exec_ctrl().
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 7e5a39a8e698..53559b8dfa52 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -625,7 +625,24 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
>  
>  void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>  {
> -	return;
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
> +		return;
> +
> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID)
> +		WARN_ONCE(true, "Invalid local APIC state");
> +
> +	svm->vmcb->control.avic_vapic_bar = svm->vcpu.arch.apic_base &
> +					    VMCB_AVIC_APIC_BAR_MASK;

No need for that - APIC base relocation doesn't work when AVIC is enabled,
since the page which contains it has to be marked R/W in NPT, which we
only do for the default APIC base.

I recently removed the code from AVIC which still tried to set the
'avic_vapic_bar' like this.



> +	kvm_vcpu_update_apicv(&svm->vcpu);
> +
> +	/*
> +	 * The VM could be running w/ AVIC activated switching from APIC
> +	 * to x2APIC mode. We need to all refresh to make sure that all
> +	 * x2AVIC configuration are being done.

Why? When AVIC is un-inhibited later then the svm_refresh_apicv_exec_ctrl will be called
again and switch to x2avic mode I think.

When AVIC is inhibited, then regardless of x2apic mode, VMCB must not have
any avic bits set, and all x2apic msrs should be read/write intercepted.,
thus I don't think that svm_refresh_apicv_exec_ctrl should be force called.


> +	 */
> +	svm_refresh_apicv_exec_ctrl(&svm->vcpu);
>  }
>  
>  void svm_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr)

Best regards,
	Maxim Levitsky

