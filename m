Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461B8589D4D
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 16:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240032AbiHDOPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 10:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiHDOPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 10:15:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3B1145F40
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 07:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659622503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uKa0k1pu8bSknr94zUVvK1qOtcTwaJejfGYE5WdbSpk=;
        b=RNvaXXEupdk1uQeNu2WC3oGYDJGVqGMLxi4pvHFKu7DFI3iRLamNyv7Lx66Yd0xFfQPolu
        kFiOcdhk7Eka3/IkaUdb+CsBSBObZ8XZmRJ81gFf3yTbwhFTg96uRn7FowwHEfJHsK9xJq
        C1+Wv57DITYCSy+Zn5nxUtJCM1HWRqU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-LjY530ABPFWltb23n5lecw-1; Thu, 04 Aug 2022 10:14:59 -0400
X-MC-Unique: LjY530ABPFWltb23n5lecw-1
Received: by mail-ed1-f69.google.com with SMTP id q18-20020a056402519200b0043dd2ff50feso6625618edd.9
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 07:14:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=uKa0k1pu8bSknr94zUVvK1qOtcTwaJejfGYE5WdbSpk=;
        b=NLHrGmGibO473YUz1itxz28HHbP8fmXffdPL+dJ+8dNP81CScJ1cxmCW/hGlj9jrxY
         24tdOJu+ZgFp8M63Zf1siWQoETHy3cgAo8dmGjh39g3JrVyBiqCjnIliCcbTsPGDWElw
         m1wYNCpszxMAk+4a/TVZjYd3xUrkWeqrJNzwQPSal9ZtvFgDgsQkbjYSKQjYOOVz4LFh
         W1KOKw8ZVRHS9jrbSyEIXu9Es11eXOF/q0gvhtkwgl6ubB2vITFHigq7ltMa0k9WhfYW
         01ommj7EsBEIlbbinVo3TAuF+9a0SkMLUDGgi0bhq/DHASA9SjizngAoANLGqRWjp46o
         d/Sw==
X-Gm-Message-State: ACgBeo3IcK4dvUzJhRKQ6qFWHo7kPU4yLg8xqy+Wa54gc5bzGIfDg+2V
        I/Wvq2cNd16gHnrLoQbFcmgnDOj3cP/7lFAKO+8MY2h8HY3r0LDgP9nGST2655e/FIPC8/4JFPL
        dsnhj/RkjAKCd
X-Received: by 2002:a05:6402:194d:b0:43d:8001:984b with SMTP id f13-20020a056402194d00b0043d8001984bmr2219033edz.327.1659622497867;
        Thu, 04 Aug 2022 07:14:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4DAfrIrLDdirj9qVvkYfz4MEN/Yj/dOocisAMkW2NI4/B73cfFiqA0kXnCUrMQSun8V3VYKg==
X-Received: by 2002:a05:6402:194d:b0:43d:8001:984b with SMTP id f13-20020a056402194d00b0043d8001984bmr2219010edz.327.1659622497649;
        Thu, 04 Aug 2022 07:14:57 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q17-20020aa7d451000000b0043d7ff1e3bcsm728723edr.72.2022.08.04.07.14.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:14:56 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     dgilbert@redhat.com, David Woodhouse <dwmw@amazon.co.uk>,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: do not report preemption if the steal time
 cache is stale
In-Reply-To: <20220804140406.1335587-1-pbonzini@redhat.com>
References: <20220804140406.1335587-1-pbonzini@redhat.com>
Date:   Thu, 04 Aug 2022 16:14:55 +0200
Message-ID: <87sfmcyu1s.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Commit 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time
> / preempted status", 2021-11-11) open coded the previous call to
> kvm_map_gfn, but in doing so it dropped the comparison between the cached
> guest physical address and the one in the MSR.  This cause an incorrect
> cache hit if the guest modifies the steal time address while the memslots
> remain the same.  This can happen with kexec, in which case the preempted
> bit is written at the address used by the old kernel instead of
> the old one.
>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@vger.kernel.org
> Fixes: 7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

No need to S-o-b twice)

> ---
>  arch/x86/kvm/x86.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0f3c2e034740..8ee4698cb90a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4715,6 +4715,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	struct kvm_steal_time __user *st;
>  	struct kvm_memslots *slots;
>  	static const u8 preempted = KVM_VCPU_PREEMPTED;
> +	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
>  
>  	/*
>  	 * The vCPU can be marked preempted if and only if the VM-Exit was on
> @@ -4742,6 +4743,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
>  	slots = kvm_memslots(vcpu->kvm);
>  
>  	if (unlikely(slots->generation != ghc->generation ||
> +		     gpa != ghc->gpa ||
>  		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))

(We could probably have a common helper for both these places.)

>  		return;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

