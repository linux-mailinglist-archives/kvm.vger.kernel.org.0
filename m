Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663DA4E6289
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 12:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349808AbiCXLhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347411AbiCXLht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 07:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79393A66FA
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 04:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648121777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OgS0CoRQX4W3qoOKvr8rsBTjL3Hbns4Zu8C+9fnUPkk=;
        b=DT9JWwdKj6SzpocYEG0MPYx5OLp+QFeQ4oJ0Mn7YyQgstqo39vKoL3ay9DoIqwiDDPuItm
        WvTX6+dUtv2bsET9yhhnpSY9pu/9qxTa/r9cmW3uVoQjRyBbfydSUvSoAdP4eEgoeYFfvI
        jHT9Acz879U9wCCMolVhf0HaTgH04u4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-2UwoFoe2NPOGJa7Mer6T_A-1; Thu, 24 Mar 2022 07:36:14 -0400
X-MC-Unique: 2UwoFoe2NPOGJa7Mer6T_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8B1985A5A8;
        Thu, 24 Mar 2022 11:36:13 +0000 (UTC)
Received: from starship (unknown [10.40.194.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAF792166B2D;
        Thu, 24 Mar 2022 11:36:11 +0000 (UTC)
Message-ID: <0ef090101aefbc3bb05bbfae5e7177c8a4cf5122.camel@redhat.com>
Subject: Re: [RFCv2 PATCH 05/12] KVM: SVM: Update avic_kick_target_vcpus to
 support 32-bit APIC ID
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Thu, 24 Mar 2022 13:36:10 +0200
In-Reply-To: <20220308163926.563994-6-suravee.suthikulpanit@amd.com>
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
         <20220308163926.563994-6-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
> In x2APIC mode, ICRH contains 32-bit destination APIC ID.
> So, update the avic_kick_target_vcpus() accordingly.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index f128b0189d4a..5329b93dc4cd 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -307,9 +307,15 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 * since entered the guest will have processed pending IRQs at VMRUN.
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		u32 dest;
> +
> +		if (apic_x2apic_mode(vcpu->arch.apic))
> +			dest = icrh;
> +		else
> +			dest = GET_XAPIC_DEST_FIELD(icrh);
> +
>  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
> -					GET_XAPIC_DEST_FIELD(icrh),
> -					icrl & APIC_DEST_MASK)) {
> +					dest, icrl & APIC_DEST_MASK)) {
>  			vcpu->arch.apic->irr_pending = true;
>  			svm_complete_interrupt_delivery(vcpu,
>  							icrl & APIC_MODE_MASK,

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

