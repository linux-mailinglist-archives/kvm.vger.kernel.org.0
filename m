Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42195A7A56
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 11:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiHaJiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 05:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHaJiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 05:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91977DF6D
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 02:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661938694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6LGROry2wbR18o4LFq1Gym+CBvbwHqiSfGZ5L3Yxgg=;
        b=Pa5gk3jykk2R72TyfK3H4cOATNhM0efOCNOu1+SnuzWOu1EbF5refJFRYpDzMX4/SvhEY4
        rtNIdgWTCedQOKNPPMizidsu7zQ6yBLpmzm3CALrqcx3mMBNS2f/HicXkpUqfQw+mIc8aH
        eJxt/+0qriSo1vhaLC8qbSPj2KcQJsg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-H-jyHDGsMO2P6yOH6s-wjQ-1; Wed, 31 Aug 2022 05:38:10 -0400
X-MC-Unique: H-jyHDGsMO2P6yOH6s-wjQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6992C85A58D;
        Wed, 31 Aug 2022 09:38:10 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C89C0403D0CC;
        Wed, 31 Aug 2022 09:38:08 +0000 (UTC)
Message-ID: <6c0e65417ad0f38ed4207fa38331556cea2aac9f.camel@redhat.com>
Subject: Re: [PATCH 05/19] KVM: SVM: Compute dest based on sender's x2APIC
 status for AVIC kick
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 12:38:07 +0300
In-Reply-To: <20220831003506.4117148-6-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-6-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Compute the destination from ICRH using the sender's x2APIC status, not
> each (potential) target's x2APIC status.
> 
> Fixes: c514d3a348ac ("KVM: SVM: Update avic_kick_target_vcpus to support 32-bit APIC ID")
> Cc: Li RongQing <lirongqing@baidu.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index b59f8ee2671f..3ace0f2f52f0 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -441,6 +441,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  				   u32 icrl, u32 icrh, u32 index)
>  {
> +	u32 dest = apic_x2apic_mode(source) ? icrh : GET_XAPIC_DEST_FIELD(icrh);
>  	unsigned long i;
>  	struct kvm_vcpu *vcpu;
>  
> @@ -456,13 +457,6 @@ static void avic_kick_target_vcpus(struct kvm *kvm, struct kvm_lapic *source,
>  	 * since entered the guest will have processed pending IRQs at VMRUN.
>  	 */
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		u32 dest;
> -
> -		if (apic_x2apic_mode(vcpu->arch.apic))
> -			dest = icrh;
> -		else
> -			dest = GET_XAPIC_DEST_FIELD(icrh);
> -
>  		if (kvm_apic_match_dest(vcpu, source, icrl & APIC_SHORT_MASK,
>  					dest, icrl & APIC_DEST_MASK)) {
>  			vcpu->arch.apic->irr_pending = true;

I didn't notice this in a review, makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

