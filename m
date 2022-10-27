Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B02660F5F5
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 13:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiJ0LLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 07:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbiJ0LLH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 07:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5132E8C58
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 04:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666869065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6APNafLLA+imf3ZZufYd09e2sEpve5dGjR8p/6jEYek=;
        b=KgGXc8D1o14J9yJmPObpEB/iKT79gq14AuMV/ltrEAUaEWQ7l8Pur475YODn07ibn3rl2c
        Yis/oTjezSqaXJXoUIZiAoVqivcxoUHw35pHBPai3V7aRIBRkwd6ygpK7b5amYejYM/IEh
        gGhU2MVy7eC6Lugc2asxPPZOIVrcZgI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-549-HOalnPz8OKeFIa4N4G5Ypg-1; Thu, 27 Oct 2022 07:11:04 -0400
X-MC-Unique: HOalnPz8OKeFIa4N4G5Ypg-1
Received: by mail-wm1-f71.google.com with SMTP id h204-20020a1c21d5000000b003cf4e055442so569248wmh.1
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 04:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6APNafLLA+imf3ZZufYd09e2sEpve5dGjR8p/6jEYek=;
        b=cjLzKXXBx8bGRONCw2H9c2K8TC9UzuI6/dKDiWFNLwkXnZDmR04Dd0759jAN7H/vmt
         veZbdttB0NpScgia1jsOs0J0kGQ/23A+q2mbX6BBOxxhgupiVwa9OMpsOxIYLLsH6Gi/
         qL3EjLpWb6pt6UFg06i1EGML9XDiV4dMYVhmu+tvugea41PLvGllpNjTzOFXn3WP4Fyn
         YDvg3nB9gPq6BrZz6GVG5Onrshydx3y1XG4sW/fB2WudU7uSOqXuSsRfVhCsI4ibNJS6
         13jqpsCRjOYwb7X43frFpJO9/RYKpHYxENuX9yU7mW3g45Usl4t8aL4cAzKor7UQnnM1
         vtBQ==
X-Gm-Message-State: ACrzQf2cNuU+UVvR36YtTrOo+KNLhMJfnRaqjHLYDUhQWPcGQtmOoFxF
        6P/s6Kg5vWLH1cCwZ1Zh/5xaIV9MkIrDkyOw2STRTY3MJWEIQb7RDX8cs4rMcxIZA6q/1YS6LHR
        43OxtL42sgkPH
X-Received: by 2002:a1c:4c03:0:b0:3c4:c76:9fe3 with SMTP id z3-20020a1c4c03000000b003c40c769fe3mr5395469wmf.13.1666869063038;
        Thu, 27 Oct 2022 04:11:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM73kqNaS7sGCd/YUTv8vTGhDVD6sEdwP2TF/RRFw2YnikAPKqbKY6aKZp9KXqr0ePtDxcimaA==
X-Received: by 2002:a1c:4c03:0:b0:3c4:c76:9fe3 with SMTP id z3-20020a1c4c03000000b003c40c769fe3mr5395457wmf.13.1666869062767;
        Thu, 27 Oct 2022 04:11:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id m8-20020a05600c3b0800b003c6edc05159sm4398554wms.1.2022.10.27.04.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 04:11:02 -0700 (PDT)
Message-ID: <afad5f40-03ef-1380-9bfe-03bbaaed47a9@redhat.com>
Date:   Thu, 27 Oct 2022 13:11:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2 03/16] KVM: x86: Always use non-compat
 vcpu_runstate_info size for gfn=>pfn cache
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
References: <20221013211234.1318131-1-seanjc@google.com>
 <20221013211234.1318131-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20221013211234.1318131-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/13/22 23:12, Sean Christopherson wrote:
> Always use the size of Xen's non-compat vcpu_runstate_info struct when
> checking that the GPA+size doesn't cross a page boundary.  Conceptually,
> using the current mode is more correct, but KVM isn't consistent with
> itself as kvm_xen_vcpu_set_attr() unconditionally uses the "full" size
> when activating the cache.  More importantly, prior to the introduction
> of the gfn_to_pfn_cache, KVM _always_ used the full size, i.e. allowing
> the guest (userspace?) to use a poorly aligned GPA in 32-bit mode but not
> 64-bit mode is more of a bug than a feature, and fixing the bug doesn't
> break KVM's historical ABI.

I'd rather not introduce additional restrictions in KVM, mostly because 
it's actually easy to avoid this patch by instead enforcing that 
attributes are set in a sensible order:

- long mode cannot be changed after the shared info page is enabled 
(which makes sense because the shared info page also has a compat version)

- the caches must be activated after the shared info page (which 
enforces that the vCPU attributes are set after the VM attributes)

This is technically a userspace API break, but nobody is really using 
this API outside Amazon so...  Patches coming after I finish testing.

Paolo


> Always using the non-compat size will allow for future gfn_to_pfn_cache
> clenups as this is (was) the only case where KVM uses a different size at
> check()+refresh() than at activate().  E.g. the length/size of the cache
> can be made immutable and dropped from check()+refresh(), which yields a
> cleaner set of APIs and avoids potential bugs that could occur if check()
> where invoked with a different size than refresh().
> 
> Fixes: a795cd43c5b5 ("KVM: x86/xen: Use gfn_to_pfn_cache for runstate area")
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index b2be60c6efa4..9e79ef2cca99 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -212,10 +212,7 @@ void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, int state)
>   	if (!vx->runstate_cache.active)
>   		return;
>   
> -	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode)
> -		user_len = sizeof(struct vcpu_runstate_info);
> -	else
> -		user_len = sizeof(struct compat_vcpu_runstate_info);
> +	user_len = sizeof(struct vcpu_runstate_info);
>   
>   	read_lock_irqsave(&gpc->lock, flags);
>   	while (!kvm_gfn_to_pfn_cache_check(v->kvm, gpc, gpc->gpa,

