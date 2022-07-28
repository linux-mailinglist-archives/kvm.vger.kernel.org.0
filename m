Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F99F58399B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 09:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbiG1Hic (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 03:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiG1Hia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 03:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C35A46051F
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 00:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658993908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DzKmVBcMOj8qzEpSvPOSPxK9ws90/nG5O/3/XIYyucI=;
        b=C11o9W6tHyXuBVrkZOY9Xe4VcJMX40XI2P0E2lGsd8AhuvKkJ/ELhVDlWTdnVCXVlj1dE0
        bfW1q70wJFVHADn0JHxUpNpa3tUmXmzFpV2EDI6fsaEeyssg2muz2O5va+ZdrvTkO1zXyi
        Y5X/TH0dkQaM0YJjgWbSZrrQK2qOohk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-_vcwfJwPNr6emxXGad7sow-1; Thu, 28 Jul 2022 03:38:10 -0400
X-MC-Unique: _vcwfJwPNr6emxXGad7sow-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 597E33C01E04;
        Thu, 28 Jul 2022 07:38:09 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6A76492C3B;
        Thu, 28 Jul 2022 07:38:07 +0000 (UTC)
Message-ID: <6c1596d7203b7044a628c10b97eb076ad0ae525f.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Do not virtualize MSR accesses for APIC LVTT
 register
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jon.grimm@amd.com
Date:   Thu, 28 Jul 2022 10:38:06 +0300
In-Reply-To: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
References: <20220725033428.3699-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 2022-07-24 at 22:34 -0500, Suravee Suthikulpanit wrote:
> AMD does not support APIC TSC-deadline timer mode. AVIC hardware
> will generate GP fault when guest kernel writes 1 to bits [18]
> of the APIC LVTT register (offset 0x32) to set the timer mode.
> (Note: bit 18 is reserved on AMD system).
> 
> Therefore, always intercept and let KVM emulate the MSR accesses.
> 
> Fixes: f3d7c8aa6882 ("KVM: SVM: Fix x2APIC MSRs interception")
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index aef63aae922d..3e0639a68385 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -118,7 +118,14 @@ static const struct svm_direct_access_msrs {
>  	{ .index = X2APIC_MSR(APIC_ESR),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_ICR),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_ICR2),		.always = false },
> -	{ .index = X2APIC_MSR(APIC_LVTT),		.always = false },
> +
> +	/*
> +	 * Note:
> +	 * AMD does not virtualize APIC TSC-deadline timer mode, but it is
> +	 * emulated by KVM. When setting APIC LVTT (0x832) register bit 18,
> +	 * the AVIC hardware would generate GP fault. Therefore, always
> +	 * intercept the MSR 0x832, and do not setup direct_access_msr.
> +	 */
>  	{ .index = X2APIC_MSR(APIC_LVTTHMR),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_LVTPC),		.always = false },
>  	{ .index = X2APIC_MSR(APIC_LVT0),		.always = false },


LVT is not something I would expect x2avic to even try to emulate, I would expect
it to dumbly forward the write to apic backing page (garbage in, garbage out) and then
signal trap vmexit?

I also think that regular AVIC works like that (just forwards the write to the page).

I am asking because there is a remote possibliity that due to some bug the guest got
direct access to x2apic registers of the host, and this is how you got that #GP.
Could you double check it?

We really need x2avic (and vNMI) spec to be published to know exactly how all of this
is supposed to work.

Best regards,
	Maxim Levitsky



