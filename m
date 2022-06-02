Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE6ED53BEF7
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238855AbiFBTkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiFBTka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A59FD313A8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 12:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654198771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P7DY6xYYaortLAkVD1OrkZ8mE7+5GrGuaQeLtKFchRk=;
        b=X/FaMVhk+BIXIKzhguEIm7cC9T4v6Ox8Q5jij3jZKWJIkfhiScQJHeg5KVuPbMhHy4qqL3
        mJPNourxv0tC4n9oqZEe2qZ6R7O/GMS2rqRnR6BdagmPR1PyjXm9bz+6OePIX9jehQo3xJ
        nUPMvcNNGbcM7htNFWXtZtMPsrisD7g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-65Kqnl1WMna-t7WvI335AA-1; Thu, 02 Jun 2022 15:39:30 -0400
X-MC-Unique: 65Kqnl1WMna-t7WvI335AA-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so2868335wmr.0
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 12:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P7DY6xYYaortLAkVD1OrkZ8mE7+5GrGuaQeLtKFchRk=;
        b=bhl9t9hVTXbJHfJcHmdSJedbgX35apoHdM9GrYuPWt6DBKHzqYtE4/MYcq0djxOXdI
         6NLU8gc9XV1ukZe2SOyFKq1kMi5e+zY8UYNpyn9tJ6xW4gWjNKLwidSpQ4867SnecJAS
         ep3HlpWGt2HoZUP1ZTD9VRbWtKNpwIBOivkTcEjjdmx/Qo/j8RrImwhOncJJLRHDVFFK
         FRnmYHpvagUN91Ita6cb4UX3cmWrXhLp7Qm4CSK/9k8TQyPYsPBsH6Q/mCCoq6WmH3W4
         nYbd2jYitZKBQvMHa6HOmg2MHhF6yKDMEK79nSK4jVpRLWHQj2BGTHit99sU2VSsl4ef
         3eHA==
X-Gm-Message-State: AOAM531kr7j8ka5cmMA4Yuf4fFHKv6jV+i9oWSOGRiTTEYfSlXzkmGZT
        bSYbb6cErWDq3dGPagg1TVNGeCSdFk/KBxtnQkc//NfV67+Q9amMNa8w+EpWJvdXvWOs7nlVDn3
        Tgu8Klec+RoYO
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id v16-20020a1cf710000000b003941960e8a1mr5369346wmh.154.1654198769408;
        Thu, 02 Jun 2022 12:39:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyb5NUdRMKDEDqs3OehCuJ3A72dORJRZuj3TUcjk/IR3G+DoIyfVTVdoXGCVMUP1AOlTOWvvg==
X-Received: by 2002:a1c:f710:0:b0:394:1960:e8a1 with SMTP id v16-20020a1cf710000000b003941960e8a1mr5369332wmh.154.1654198769164;
        Thu, 02 Jun 2022 12:39:29 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm6442171wrq.9.2022.06.02.12.39.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 12:39:28 -0700 (PDT)
Message-ID: <b0c08d90-1bf0-6996-379e-61f0d5724fc0@redhat.com>
Date:   Thu, 2 Jun 2022 21:39:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/3] KVM: arm64: Warn if accessing timer pending state
 outside of vcpu context
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>, kernel-team@android.com
References: <20220602083025.1110433-1-maz@kernel.org>
 <20220602083025.1110433-4-maz@kernel.org>
From:   Eric Auger <eauger@redhat.com>
In-Reply-To: <20220602083025.1110433-4-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/2/22 10:30, Marc Zyngier wrote:
> A recurrent bug in the KVM/arm64 code base consists in trying to
> access the timer pending state outside of the vcpu context, which
> makes zero sense (the pending state only exists when the vcpu
> is loaded).
> 
> In order to avoid more embarassing crashes and catch the offenders
> red-handed, add a warning to kvm_arch_timer_get_input_level() and
> return the state as non-pending. This avoids taking the system down,
> and still helps tracking down silly bugs.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arch/arm64/kvm/arch_timer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index 5290ca5db663..bb24a76b4224 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
> @@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
>  	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>  	struct arch_timer_context *timer;
>  
> +	if (WARN(!vcpu, "No vcpu context!\n"))
> +		return false;
> +
>  	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
>  		timer = vcpu_vtimer(vcpu);
>  	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)

