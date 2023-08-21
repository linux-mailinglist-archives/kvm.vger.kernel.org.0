Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED3F78266D
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbjHUJlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjHUJlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:41:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9179D
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692610822;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=RsDe2yoAX8jvqHcrEjQ1brMmtnocoQMptpe4iQxCeu0=;
        b=d7WRd5zELdQzRlS3stjTX+DDFXPm5HywjL+O+2/eOBOlasA7L8ctQ080V5heKMPUNkxD2U
        br31ocpgMOmDUQSjT0CYYqeWOodfrCvVUXH9zb1kSQLvbNlCYQCqOaBkfWU2ckF4a+cobm
        NNkDchC+ovryX0eMZyzFLtp7qd+PLmc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-_7fBnyyNOJiUC5U7lomUMg-1; Mon, 21 Aug 2023 05:40:20 -0400
X-MC-Unique: _7fBnyyNOJiUC5U7lomUMg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41078DC666;
        Mon, 21 Aug 2023 09:40:19 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 236F8492C13;
        Mon, 21 Aug 2023 09:40:17 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:40:15 +0100
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
Subject: Re: [PATCH v2 36/58] memory: Introduce memory_region_init_ram_gmem()
Message-ID: <ZOMw/7lz9cAgx5tO@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-37-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-37-xiaoyao.li@intel.com>
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

On Fri, Aug 18, 2023 at 05:50:19AM -0400, Xiaoyao Li wrote:
> Introduce memory_region_init_ram_gmem() to allocate private gmem on the
> MemoryRegion initialization. It's for the usercase of TDVF, which must
> be private on TDX case.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  include/exec/memory.h |  6 +++++
>  softmmu/memory.c      | 52 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+)

> diff --git a/softmmu/memory.c b/softmmu/memory.c
> index af6aa3c1e3c9..ded44dcef1aa 100644
> --- a/softmmu/memory.c
> +++ b/softmmu/memory.c
> @@ -25,6 +25,7 @@
>  #include "qom/object.h"
>  #include "trace.h"
>  
> +#include <linux/kvm.h>
>  #include "exec/memory-internal.h"
>  #include "exec/ram_addr.h"
>  #include "sysemu/kvm.h"
> @@ -3602,6 +3603,57 @@ void memory_region_init_ram(MemoryRegion *mr,
>      vmstate_register_ram(mr, owner_dev);
>  }
>  
> +#ifdef CONFIG_KVM
> +void memory_region_init_ram_gmem(MemoryRegion *mr,
> +                                 Object *owner,
> +                                 const char *name,
> +                                 uint64_t size,
> +                                 Error **errp)

Since you have an 'errp' parameter here....

> +{
> +    DeviceState *owner_dev;
> +    Error *err = NULL;
> +    int priv_fd;
> +
> +    memory_region_init_ram_nomigrate(mr, owner, name, size, &err);
> +    if (err) {
> +        error_propagate(errp, err);
> +        return;
> +    }
> +
> +    if (object_dynamic_cast(OBJECT(current_accel()), TYPE_KVM_ACCEL)) {
> +        KVMState *s = KVM_STATE(current_accel());
> +        struct kvm_create_guest_memfd gmem = {
> +            .size = size,
> +            /* TODO: add property to hostmem backend for huge pmd */
> +            .flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE,
> +        };
> +
> +        priv_fd = kvm_vm_ioctl(s, KVM_CREATE_GUEST_MEMFD, &gmem);
> +        if (priv_fd < 0) {
> +            fprintf(stderr, "%s: error creating gmem: %s\n", __func__,
> +                    strerror(-priv_fd));
> +            abort();

It should be using error_setg_errno() here and return not abort

> +        }
> +    } else {
> +        fprintf(stderr, "%s: gmem unsupported accel: %s\n", __func__,
> +                current_accel_name());

and error_setg() here and return.

> +        abort();
> +    }
> +
> +    memory_region_set_gmem_fd(mr, priv_fd);
> +    memory_region_set_default_private(mr);
> +
> +    /* This will assert if owner is neither NULL nor a DeviceState.
> +     * We only want the owner here for the purposes of defining a
> +     * unique name for migration. TODO: Ideally we should implement
> +     * a naming scheme for Objects which are not DeviceStates, in
> +     * which case we can relax this restriction.
> +     */
> +    owner_dev = DEVICE(owner);
> +    vmstate_register_ram(mr, owner_dev);
> +}
> +#endif
> +
>  void memory_region_init_rom(MemoryRegion *mr,
>                              Object *owner,
>                              const char *name,
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

