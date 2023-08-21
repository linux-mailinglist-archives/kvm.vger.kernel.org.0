Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F49782633
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234325AbjHUJ03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjHUJ02 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A19FDB
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692609942;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=c6r0VM+Il1rtDu5YFeTzXX2bOaetAg3O6QucdtEN6Qs=;
        b=Etnf0J5MbCSlnNMzp2CcY0Dcex2hx6Fo8QXqk3n80ANuvSu+BKCoRyAesbYEl1+xqA9wOz
        zTrfgsQ8VUv7RszjpUacxMdUxfac/5R4XgFczIUfAuGvCbJh+gtkKx5EbUGVFcUwgcime4
        5s8hY94LUJs2FvZjFvL/6MDmDikURBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-7w7zhsm8OsOCDR6NXxJdWw-1; Mon, 21 Aug 2023 05:25:40 -0400
X-MC-Unique: 7w7zhsm8OsOCDR6NXxJdWw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B2D3B85CBE5;
        Mon, 21 Aug 2023 09:25:39 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C53E4021B9;
        Mon, 21 Aug 2023 09:25:36 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:25:35 +0100
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
Subject: Re: [PATCH v2 19/58] qom: implement property helper for sha384
Message-ID: <ZOMtj0La71zf/uGd@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-20-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-20-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:02AM -0400, Xiaoyao Li wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Implement property_add_sha384() which converts hex string <-> uint8_t[48]
> It will be used for TDX which uses sha384 for measurement.

I think it is likely a better idea to use base64 for the encoding
the binary hash - we use base64 for all the sev-guest properties
that were binary data.

At which points the property set/get logic is much simpler as it
is just needing a call to  g_base64_encode / g_base64_decode and
length validation for the decode case.

> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  include/qom/object.h | 17 ++++++++++
>  qom/object.c         | 76 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> diff --git a/include/qom/object.h b/include/qom/object.h
> index ef7258a5e149..70399a5b1940 100644
> --- a/include/qom/object.h
> +++ b/include/qom/object.h
> @@ -1887,6 +1887,23 @@ ObjectProperty *object_property_add_alias(Object *obj, const char *name,
>  ObjectProperty *object_property_add_const_link(Object *obj, const char *name,
>                                                 Object *target);
>  
> +
> +/**
> + * object_property_add_sha384:
> + * @obj: the object to add a property to
> + * @name: the name of the property
> + * @v: pointer to value
> + * @flags: bitwise-or'd ObjectPropertyFlags
> + *
> + * Add an sha384 property in memory.  This function will add a
> + * property of type 'sha384'.
> + *
> + * Returns: The newly added property on success, or %NULL on failure.
> + */
> +ObjectProperty * object_property_add_sha384(Object *obj, const char *name,
> +                                            const uint8_t *v,
> +                                            ObjectPropertyFlags flags);
> +
>  /**
>   * object_property_set_description:
>   * @obj: the object owning the property
> diff --git a/qom/object.c b/qom/object.c
> index e25f1e96db1e..e71ce46ed576 100644
> --- a/qom/object.c
> +++ b/qom/object.c
> @@ -15,6 +15,7 @@
>  #include "qapi/error.h"
>  #include "qom/object.h"
>  #include "qom/object_interfaces.h"
> +#include "qemu/ctype.h"
>  #include "qemu/cutils.h"
>  #include "qemu/memalign.h"
>  #include "qapi/visitor.h"
> @@ -2781,6 +2782,81 @@ object_property_add_alias(Object *obj, const char *name,
>      return op;
>  }
>  
> +#define SHA384_DIGEST_SIZE      48
> +static void property_get_sha384(Object *obj, Visitor *v, const char *name,
> +                                void *opaque, Error **errp)
> +{
> +    uint8_t *value = (uint8_t *)opaque;
> +    char str[SHA384_DIGEST_SIZE * 2 + 1];
> +    char *str_ = (char*)str;
> +    size_t i;
> +
> +    for (i = 0; i < SHA384_DIGEST_SIZE; i++) {
> +        char *buf;
> +        buf = &str[i * 2];
> +
> +        sprintf(buf, "%02hhx", value[i]);
> +    }
> +    str[SHA384_DIGEST_SIZE * 2] = '\0';
> +
> +    visit_type_str(v, name, &str_, errp);
> +}
> +
> +static void property_set_sha384(Object *obj, Visitor *v, const char *name,
> +                                    void *opaque, Error **errp)
> +{
> +    uint8_t *value = (uint8_t *)opaque;
> +    char* str;
> +    size_t len;
> +    size_t i;
> +
> +    if (!visit_type_str(v, name, &str, errp)) {
> +        goto err;
> +    }
> +
> +    len = strlen(str);
> +    if (len != SHA384_DIGEST_SIZE * 2) {
> +        error_setg(errp, "invalid length for sha348 hex string %s. "
> +                   "it must be 48 * 2 hex", name);
> +        goto err;
> +    }
> +
> +    for (i = 0; i < SHA384_DIGEST_SIZE; i++) {
> +        if (!qemu_isxdigit(str[i * 2]) || !qemu_isxdigit(str[i * 2 + 1])) {
> +            error_setg(errp, "invalid char for sha318 hex string %s at %c%c",
> +                       name, str[i * 2], str[i * 2 + 1]);
> +            goto err;
> +        }
> +
> +        if (sscanf(str + i * 2, "%02hhx", &value[i]) != 1) {
> +            error_setg(errp, "invalid format for sha318 hex string %s", name);
> +            goto err;
> +        }
> +    }
> +
> +err:
> +    g_free(str);
> +}
> +
> +ObjectProperty *
> +object_property_add_sha384(Object *obj, const char *name,
> +                           const uint8_t *v, ObjectPropertyFlags flags)
> +{
> +    ObjectPropertyAccessor *getter = NULL;
> +    ObjectPropertyAccessor *setter = NULL;
> +
> +    if ((flags & OBJ_PROP_FLAG_READ) == OBJ_PROP_FLAG_READ) {
> +        getter = property_get_sha384;
> +    }
> +
> +    if ((flags & OBJ_PROP_FLAG_WRITE) == OBJ_PROP_FLAG_WRITE) {
> +        setter = property_set_sha384;
> +    }
> +
> +    return object_property_add(obj, name, "sha384",
> +                               getter, setter, NULL, (void *)v);
> +}
> +
>  void object_property_set_description(Object *obj, const char *name,
>                                       const char *description)
>  {
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

