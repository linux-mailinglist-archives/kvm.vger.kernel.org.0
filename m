Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801F17825CC
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 10:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjHUIt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 04:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234168AbjHUItz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 04:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B86E8F
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 01:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692607746;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=dmyDG4iJYYAx+AQ3QidNKVuxAstbv5AT9k9zWWqn+/I=;
        b=b7nNae1v2uqdh2ddjxp1tn87tP9TzDJcRl14PZhnQVGxzNDeD4ykB/Le0jVMd04DoVm5AQ
        TZI6eP4DXVqEkAIeZpXRiqvuOQyi3uktuXTm0xS56Z73NQCkCzjT0MAPAB/dkWGf0KRv/b
        HDSdDyJpVccuvXdpRvj9p63OXGER2FM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-_ILulIkLNLeMUmPVJkC-Nw-1; Mon, 21 Aug 2023 04:49:03 -0400
X-MC-Unique: _ILulIkLNLeMUmPVJkC-Nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE05F185A792;
        Mon, 21 Aug 2023 08:49:02 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1B67D2166B25;
        Mon, 21 Aug 2023 08:49:00 +0000 (UTC)
Date:   Mon, 21 Aug 2023 09:48:58 +0100
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
Subject: Re: [PATCH v2 07/58] i386/tdx: Introduce is_tdx_vm() helper and
 cache tdx_guest object
Message-ID: <ZOMk+kaAtgBh3Qgk@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-8-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-8-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:49:50AM -0400, Xiaoyao Li wrote:
> It will need special handling for TDX VMs all around the QEMU.
> Introduce is_tdx_vm() helper to query if it's a TDX VM.
> 
> Cache tdx_guest object thus no need to cast from ms->cgs every time.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  target/i386/kvm/tdx.c | 13 +++++++++++++
>  target/i386/kvm/tdx.h | 10 ++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 255c47a2a553..56cb826f6125 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -21,8 +21,16 @@
>  #include "kvm_i386.h"
>  #include "tdx.h"
>  
> +static TdxGuest *tdx_guest;
> +
>  static struct kvm_tdx_capabilities *tdx_caps;
>  
> +/* It's valid after kvm_confidential_guest_init()->kvm_tdx_init() */
> +bool is_tdx_vm(void)
> +{
> +    return !!tdx_guest;
> +}
> +
>  enum tdx_ioctl_level{
>      TDX_PLATFORM_IOCTL,
>      TDX_VM_IOCTL,
> @@ -109,10 +117,15 @@ static void get_tdx_capabilities(void)
>  
>  int tdx_kvm_init(MachineState *ms, Error **errp)
>  {
> +    TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
> +                                                    TYPE_TDX_GUEST);

This method can return NULL.  Presumably tdx_kvm_init() should only
be called if we already checked  ms->cgs == TYPE_TDX_GUEST. If so
then use object_dynamic_cast_assert() instead.

> +
>      if (!tdx_caps) {
>          get_tdx_capabilities();
>      }
>  
> +    tdx_guest = tdx;
> +
>      return 0;
>  }
>  
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index c8a23d95258d..4036ca2f3f99 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -1,6 +1,10 @@
>  #ifndef QEMU_I386_TDX_H
>  #define QEMU_I386_TDX_H
>  
> +#ifndef CONFIG_USER_ONLY
> +#include CONFIG_DEVICES /* CONFIG_TDX */
> +#endif
> +
>  #include "exec/confidential-guest-support.h"
>  
>  #define TYPE_TDX_GUEST "tdx-guest"
> @@ -16,6 +20,12 @@ typedef struct TdxGuest {
>      uint64_t attributes;    /* TD attributes */
>  } TdxGuest;
>  
> +#ifdef CONFIG_TDX
> +bool is_tdx_vm(void);
> +#else
> +#define is_tdx_vm() 0
> +#endif /* CONFIG_TDX */
> +
>  int tdx_kvm_init(MachineState *ms, Error **errp);
>  
>  #endif /* QEMU_I386_TDX_H */
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

