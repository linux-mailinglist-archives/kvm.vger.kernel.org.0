Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA33A782646
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjHUJay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbjHUJaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7112091
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692610207;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=4TLTFC4X1BaALVGXBpCe1Lrd+0Q2ev3VUQOJTssT89Q=;
        b=DwMja8arJFNo9UttWUBe4cdW/LXH+aR1B7b+ZYqwTdjFPz9j/WvupuA0hzLORsMH9VjIHm
        0tGtHJhH3CduDDnkLrUq8N7UDm6JWo6eFe0CGgfe30GLm9QAvxg70LfloCtNEn8Rsh40gV
        6GexRL72ZWsF0zV4hjA/3JfFlGkWNdc=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-V5F0DPpzOReCZ1U8h5eYsQ-1; Mon, 21 Aug 2023 05:30:03 -0400
X-MC-Unique: V5F0DPpzOReCZ1U8h5eYsQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8241B38008B0;
        Mon, 21 Aug 2023 09:30:02 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 077081121314;
        Mon, 21 Aug 2023 09:29:58 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:29:57 +0100
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
Subject: Re: [PATCH v2 20/58] i386/tdx: Allows
 mrconfigid/mrowner/mrownerconfig for TDX_INIT_VM
Message-ID: <ZOMulbt2Z9+9EEkv@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-21-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-21-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:03AM -0400, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> When creating TDX vm, three sha384 hash values can be provided for
> TDX attestation.
> 
> So far they were hard coded as 0. Now allow user to specify those values
> via property mrconfigid, mrowner and mrownerconfig. Choose hex-encoded
> string as format since it's friendly for user to input.
> 
> example
> -object tdx-guest, \
>   mrconfigid=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef, \
>   mrowner=fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210, \
>   mrownerconfig=0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> TODO:
>  - community requests to use base64 encoding if no special reason
> ---
>  qapi/qom.json         | 11 ++++++++++-
>  target/i386/kvm/tdx.c | 13 +++++++++++++
>  target/i386/kvm/tdx.h |  3 +++
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/qapi/qom.json b/qapi/qom.json
> index cc08b9a98df9..87c1d440f331 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -873,10 +873,19 @@
>  #
>  # @sept-ve-disable: bit 28 of TD attributes (default: 0)
>  #
> +# @mrconfigid: MRCONFIGID SHA384 hex string of 48 * 2 length (default: 0)
> +#
> +# @mrowner: MROWNER SHA384 hex string of 48 * 2 length (default: 0)
> +#
> +# @mrownerconfig: MROWNERCONFIG SHA384 hex string of 48 * 2 length (default: 0)

Per previous patch, I suggest these should all be passed in base64
instead of hex. Also 'default: 0' makes no sense for a string,
which would be 'default: nil', and no need to document that as
the default is implicit from the fact that its an optional string
field. So eg

  @mrconfigid: base64 encoded MRCONFIGID SHA384 digest

> +#
>  # Since: 8.2
>  ##
>  { 'struct': 'TdxGuestProperties',
> -  'data': { '*sept-ve-disable': 'bool' } }
> +  'data': { '*sept-ve-disable': 'bool',
> +            '*mrconfigid': 'str',
> +            '*mrowner': 'str',
> +            '*mrownerconfig': 'str' } }
>  
>  ##
>  # @ThreadContextProperties:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 73da15377ec3..33d015a08c34 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -521,6 +521,13 @@ int tdx_pre_create_vcpu(CPUState *cpu)
>      init_vm->cpuid.nent = kvm_x86_arch_cpuid(env, init_vm->cpuid.entries, 0);
>      init_vm->attributes = tdx_guest->attributes;
>  
> +    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrconfigid) != sizeof(tdx_guest->mrconfigid));
> +    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrowner) != sizeof(tdx_guest->mrowner));
> +    QEMU_BUILD_BUG_ON(sizeof(init_vm->mrownerconfig) != sizeof(tdx_guest->mrownerconfig));
> +    memcpy(init_vm->mrconfigid, tdx_guest->mrconfigid, sizeof(tdx_guest->mrconfigid));
> +    memcpy(init_vm->mrowner, tdx_guest->mrowner, sizeof(tdx_guest->mrowner));
> +    memcpy(init_vm->mrownerconfig, tdx_guest->mrownerconfig, sizeof(tdx_guest->mrownerconfig));
> +
>      do {
>          r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, init_vm);
>      } while (r == -EAGAIN);
> @@ -575,6 +582,12 @@ static void tdx_guest_init(Object *obj)
>      object_property_add_bool(obj, "sept-ve-disable",
>                               tdx_guest_get_sept_ve_disable,
>                               tdx_guest_set_sept_ve_disable);
> +    object_property_add_sha384(obj, "mrconfigid", tdx->mrconfigid,
> +                               OBJ_PROP_FLAG_READWRITE);
> +    object_property_add_sha384(obj, "mrowner", tdx->mrowner,
> +                               OBJ_PROP_FLAG_READWRITE);
> +    object_property_add_sha384(obj, "mrownerconfig", tdx->mrownerconfig,
> +                               OBJ_PROP_FLAG_READWRITE);
>  }
>  
>  static void tdx_guest_finalize(Object *obj)
> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index 46a24ee8c7cc..68f8327f2231 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -21,6 +21,9 @@ typedef struct TdxGuest {
>  
>      bool initialized;
>      uint64_t attributes;    /* TD attributes */
> +    uint8_t mrconfigid[48];     /* sha348 digest */
> +    uint8_t mrowner[48];        /* sha348 digest */
> +    uint8_t mrownerconfig[48];  /* sha348 digest */
>  } TdxGuest;
>  
>  #ifdef CONFIG_TDX
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

