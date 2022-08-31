Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ACF5A7676
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 08:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiHaGTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 02:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiHaGTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 02:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9340755B0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 23:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661926790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0RL9hcvSBeKbl7mI4q8jnXwWqDmenfiCErqBoOJUqQ=;
        b=MXTAd36DCl5hiT3MpyvZq4XFb6aDb6vbMwbAoYUengNPLZqdxJ+qTUwGrXGQ0Jz/t5C+yv
        D7Br2ZWEexuqyQVoEzr9fA6YBCVvIuUDr3XKA9cblSvjTxEtU21kuAXOXS0gh3272YWvT+
        CmArKFdL2IWGMDugwmqS1bd+heAdc8o=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-G3Vfp39vNKOo56wOZsSujQ-1; Wed, 31 Aug 2022 02:19:49 -0400
X-MC-Unique: G3Vfp39vNKOo56wOZsSujQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3E153C0E20E;
        Wed, 31 Aug 2022 06:19:48 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 203662166B26;
        Wed, 31 Aug 2022 06:19:46 +0000 (UTC)
Message-ID: <dd8c92855762258d87486f719bf7e52e36169ef2.camel@redhat.com>
Subject: Re: [PATCH 07/19] KVM: SVM: Drop buggy and redundant AVIC "single
 logical dest" check
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 09:19:45 +0300
In-Reply-To: <20220831003506.4117148-8-seanjc@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> Use the already-calculated-and-sanity-checked destination bitmap when
> processing a fast AVIC kick in logical mode, and drop the logical path's
> flawed logic.  The intent of the check is to ensure the bitmap is a power
> of two, whereas "icrh != (1 << avic)" effectively checks that the bitmap
> is a power of two _and_ the target cluster is '0'.
> 
> Note, the flawed check isn't a functional issue, it simply means that KVM
> will go down the slow path if the target cluster is non-zero.
> 
> Fixes: 8c9e639da435 ("KVM: SVM: Use target APIC ID to complete x2AVIC IRQs when possible")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/avic.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 3c333cd2e752..14f567550a1e 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -411,15 +411,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			 * Instead, calculate physical ID from logical ID in ICRH.
>  			 */
>  			int cluster = (icrh & 0xffff0000) >> 16;
> -			int apic = ffs(icrh & 0xffff) - 1;
> -
> -			/*
> -			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> -			 * contains anything but a single bit, we cannot use the
> -			 * fast path, because it is limited to a single vCPU.
> -			 */
> -			if (apic < 0 || icrh != (1 << apic))
> -				return -EINVAL;
> +			int apic = ffs(bitmap) - 1;
>  
>  			l1_physical_id = (cluster << 4) + apic;
>  		}

Oh, I didn't notice this bug. However isn't removing the check is wrong as well?

What if we do have multiple bits set in the bitmap? After you remove this code,
we will set IPI only to APIC which matches the 1st bit, no?
(The fast code only sends IPI to one vCPU)

Best regards,
	Maxim Levitsky

