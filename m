Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17C9782621
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbjHUJRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbjHUJRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7705BBA
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692609407;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=b1lHD21s+MBJiO7a88Vxmxpex8d+pS/CCRJDDNtoVec=;
        b=ZaG2SqDi0XOvJIR9U35kZT9KrMbHkQOGiqAOYesBwDeXb0lxNz691a8bYHHOk8faaUo8uA
        xygK7uJCOBRPvC01xHOgvPWUYxqwzdLN2vSb6eDWXgUkk6vbae3mqDiJLYf4Ixl/nGRxpa
        ChTOgF9GnJ0fau6GApFKmvvu+Ogy36w=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-Xx3PqylANxiSWwzqWSbbHw-1; Mon, 21 Aug 2023 05:16:44 -0400
X-MC-Unique: Xx3PqylANxiSWwzqWSbbHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C422338210A0;
        Mon, 21 Aug 2023 09:16:43 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25CA240C2063;
        Mon, 21 Aug 2023 09:16:41 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:16:39 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 18/58] i386/tdx: Validate TD attributes
Message-ID: <ZOMrd6f0URDYp/0r@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-19-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-19-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:01AM -0400, Xiaoyao Li wrote:
> Validate TD attributes with tdx_caps that fixed-0 bits must be zero and
> fixed-1 bits must be set.
> 
> Besides, sanity check the attribute bits that have not been supported by
> QEMU yet. e.g., debug bit, it will be allowed in the future when debug
> TD support lands in QEMU.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 629abd267da8..73da15377ec3 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -32,6 +32,7 @@
>                                       (1U << KVM_FEATURE_PV_SCHED_YIELD) | \
>                                       (1U << KVM_FEATURE_MSI_EXT_DEST_ID))
>  
> +#define TDX_TD_ATTRIBUTES_DEBUG             BIT_ULL(0)
>  #define TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE   BIT_ULL(28)
>  #define TDX_TD_ATTRIBUTES_PKS               BIT_ULL(30)
>  #define TDX_TD_ATTRIBUTES_PERFMON           BIT_ULL(63)
> @@ -462,13 +463,32 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>      return 0;
>  }
>  
> -static void setup_td_guest_attributes(X86CPU *x86cpu)
> +static int tdx_validate_attributes(TdxGuest *tdx)
> +{
> +    if (((tdx->attributes & tdx_caps->attrs_fixed0) | tdx_caps->attrs_fixed1) !=
> +        tdx->attributes) {
> +            error_report("Invalid attributes 0x%lx for TDX VM (fixed0 0x%llx, fixed1 0x%llx)",
> +                          tdx->attributes, tdx_caps->attrs_fixed0, tdx_caps->attrs_fixed1);
> +            return -EINVAL;
> +    }
> +
> +    if (tdx->attributes & TDX_TD_ATTRIBUTES_DEBUG) {
> +        error_report("Current QEMU doesn't support attributes.debug[bit 0] for TDX VM");
> +        return -EINVAL;
> +    }

Use error_setg() in both cases, passing in a 'Error **errp' object,
and 'return -1' instead of returning an errno value.

> +
> +    return 0;
> +}
> +
> +static int setup_td_guest_attributes(X86CPU *x86cpu)
>  {
>      CPUX86State *env = &x86cpu->env;
>  
>      tdx_guest->attributes |= (env->features[FEAT_7_0_ECX] & CPUID_7_0_ECX_PKS) ?
>                               TDX_TD_ATTRIBUTES_PKS : 0;
>      tdx_guest->attributes |= x86cpu->enable_pmu ? TDX_TD_ATTRIBUTES_PERFMON : 0;
> +
> +    return tdx_validate_attributes(tdx_guest);

Pass along "errp" into this

>  }
>  
>  int tdx_pre_create_vcpu(CPUState *cpu)
> @@ -493,7 +513,10 @@ int tdx_pre_create_vcpu(CPUState *cpu)

In an earlier patch I suggested adding 'Error **errp' to this method...

>          goto out_free;
>      }
>  
> -    setup_td_guest_attributes(x86cpu);
> +    r = setup_td_guest_attributes(x86cpu);

...it can also be passed into this method

> +    if (r) {
> +        goto out;
> +    }
>  
>      init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
>      init_vm->attributes = tdx_guest->attributes;
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

