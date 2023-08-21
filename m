Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C002878255B
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 10:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbjHUI2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 04:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjHUI2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 04:28:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2AD99
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 01:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692606473;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=dDjls7+ILiWbqhXYks55zfDhfY7DM1MGCD/3Cd5UPU8=;
        b=B4gj1GvvsjbSj6Crq+L/c2vm198i2TbhdCSLWhRq+kPfPuRqbLfRuZqPsVtTNrnoNtWjFs
        lYsOqItPA4k2yS6qiGVN7H34zEjhdCtEodCFspYlCtUye0Axk9313tShDTk1JJHxRkhrq1
        nvYgyZVxvNzcYH6zSkYLOdST38K23D4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-vR_qHInePkKdzT03Xem86g-1; Mon, 21 Aug 2023 04:27:49 -0400
X-MC-Unique: vR_qHInePkKdzT03Xem86g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE0BF3C02B66;
        Mon, 21 Aug 2023 08:27:48 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E4DF63F6C;
        Mon, 21 Aug 2023 08:27:45 +0000 (UTC)
Date:   Mon, 21 Aug 2023 09:27:43 +0100
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
Subject: Re: [PATCH v2 03/58] target/i386: Parse TDX vm type
Message-ID: <ZOMf6AMe1ShL3rjC@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-4-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-4-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:49:46AM -0400, Xiaoyao Li wrote:
> TDX VM requires VM type KVM_X86_TDX_VM to be passed to
> kvm_ioctl(KVM_CREATE_VM).
> 
> If tdx-guest object is specified to confidential-guest-support, like,
> 
>   qemu -machine ...,confidential-guest-support=tdx0 \
>        -object tdx-guest,id=tdx0,...
> 
> it parses VM type as KVM_X86_TDX_VM.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/kvm.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 62f237068a3a..77f4772afe6c 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -32,6 +32,7 @@
>  #include "sysemu/runstate.h"
>  #include "kvm_i386.h"
>  #include "sev.h"
> +#include "tdx.h"
>  #include "xen-emu.h"
>  #include "hyperv.h"
>  #include "hyperv-proto.h"
> @@ -158,6 +159,7 @@ static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
>  static const char* vm_type_name[] = {
>      [KVM_X86_DEFAULT_VM] = "default",
>      [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
> +    [KVM_X86_TDX_VM] = "tdx",
>  };
>  
>  int kvm_get_vm_type(MachineState *ms, const char *vm_type)
> @@ -170,12 +172,18 @@ int kvm_get_vm_type(MachineState *ms, const char *vm_type)
>              kvm_type = KVM_X86_DEFAULT_VM;
>          } else if (!g_ascii_strcasecmp(vm_type, "sw-protected-vm")) {
>              kvm_type = KVM_X86_SW_PROTECTED_VM;
> -        } else {
> +        } else if (!g_ascii_strcasecmp(vm_type, "tdx")) {
> +            kvm_type = KVM_X86_TDX_VM;
> +        }else {
>              error_report("Unknown kvm-type specified '%s'", vm_type);
>              exit(1);
>          }
>      }

This whole block of code should go away - as this should not exist
as a user visible property. It should be sufficient to use the
tdx-guest object type to identify use of TDX.

>  
> +    if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
> +        kvm_type = KVM_X86_TDX_VM;
> +    }
> +
>      /*
>       * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
>       * is always supported
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

