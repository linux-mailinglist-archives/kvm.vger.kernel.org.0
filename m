Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2AB7826B2
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 11:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbjHUJ7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 05:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjHUJ7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 05:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEFEDC
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 02:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692611918;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=MouTdXYvd8EMbVAJZG4yva2UaPiccDDkjRW/8Gte4a8=;
        b=KWIlnpoYnr/VmOx16h5py4JiGH1OF0L1dcJ3VGtIS9Yy0HcoGD9ugZ/UpgRandCgUqoAbQ
        Zr8LSpxsJrPO8kUVRNzFKWaCKRL5ags4X24RsLn2+EmXlVujJfkYrNg16G01g+F82jbmjh
        +6vJAXZW/SVRakraERBqSOVL+vuCSbA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-nrWzbycdPR-JNkhvZRDMGA-1; Mon, 21 Aug 2023 05:58:32 -0400
X-MC-Unique: nrWzbycdPR-JNkhvZRDMGA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D566D38210AC;
        Mon, 21 Aug 2023 09:58:31 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.139])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 28E5D492C13;
        Mon, 21 Aug 2023 09:58:28 +0000 (UTC)
Date:   Mon, 21 Aug 2023 10:58:26 +0100
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
Subject: Re: [PATCH v2 47/58] i386/tdx: Wire REPORT_FATAL_ERROR with
 GuestPanic facility
Message-ID: <ZOM1Qk4wjNczWEf2@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-48-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-48-xiaoyao.li@intel.com>
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

On Fri, Aug 18, 2023 at 05:50:30AM -0400, Xiaoyao Li wrote:
> Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  qapi/run-state.json   | 17 +++++++++++++--
>  softmmu/runstate.c    | 49 +++++++++++++++++++++++++++++++++++++++++++
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++++-
>  3 files changed, 87 insertions(+), 3 deletions(-)
> 
> diff --git a/qapi/run-state.json b/qapi/run-state.json
> index f216ba54ec4c..506bbe31541f 100644
> --- a/qapi/run-state.json
> +++ b/qapi/run-state.json
> @@ -499,7 +499,7 @@
>  # Since: 2.9
>  ##
>  { 'enum': 'GuestPanicInformationType',
> -  'data': [ 'hyper-v', 's390' ] }
> +  'data': [ 'hyper-v', 's390', 'tdx' ] }

Missing documentation for the 'tdx' value

>  
>  ##
>  # @GuestPanicInformation:
> @@ -514,7 +514,8 @@
>   'base': {'type': 'GuestPanicInformationType'},
>   'discriminator': 'type',
>   'data': {'hyper-v': 'GuestPanicInformationHyperV',
> -          's390': 'GuestPanicInformationS390'}}
> +          's390': 'GuestPanicInformationS390',
> +          'tdx' : 'GuestPanicInformationTdx'}}
>  
>  ##
>  # @GuestPanicInformationHyperV:
> @@ -577,6 +578,18 @@
>            'psw-addr': 'uint64',
>            'reason': 'S390CrashReason'}}
>  
> +##
> +# @GuestPanicInformationTdx:
> +#
> +# TDX GHCI TDG.VP.VMCALL<ReportFatalError> specific guest panic information

Not documented any of the struct members. Especially please include
the warning that 'message' comes from the guest and so must not be
trusted, not assumed to be well formed.

> +#
> +# Since: 8.2
> +##
> +{'struct': 'GuestPanicInformationTdx',
> + 'data': {'error-code': 'uint64',
> +          'gpa': 'uint64',
> +          'message': 'str'}}
> +
>  ##
>  # @MEMORY_FAILURE:
>  #
> diff --git a/softmmu/runstate.c b/softmmu/runstate.c
> index f3bd86281813..cab11484ed7e 100644
> --- a/softmmu/runstate.c
> +++ b/softmmu/runstate.c
> @@ -518,7 +518,56 @@ void qemu_system_guest_panicked(GuestPanicInformation *info)
>                            S390CrashReason_str(info->u.s390.reason),
>                            info->u.s390.psw_mask,
>                            info->u.s390.psw_addr);
> +        } else if (info->type == GUEST_PANIC_INFORMATION_TYPE_TDX) {
> +            char *buf = NULL;
> +            bool printable = false;
> +
> +            /*
> +             * Although message is defined as a json string, we shouldn't
> +             * unconditionally treat it as is because the guest generated it and
> +             * it's not necessarily trustable.
> +             */
> +            if (info->u.tdx.message) {
> +                /* The caller guarantees the NUL-terminated string. */
> +                int len = strlen(info->u.tdx.message);
> +                int i;
> +
> +                printable = len > 0;
> +                for (i = 0; i < len; i++) {
> +                    if (!(0x20 <= info->u.tdx.message[i] &&
> +                          info->u.tdx.message[i] <= 0x7e)) {
> +                        printable = false;
> +                        break;
> +                    }
> +                }
> +
> +                /* 3 = length of "%02x " */
> +                buf = g_malloc(len * 3);
> +                for (i = 0; i < len; i++) {
> +                    if (info->u.tdx.message[i] == '\0') {
> +                        break;
> +                    } else {
> +                        sprintf(buf + 3 * i, "%02x ", info->u.tdx.message[i]);
> +                    }
> +                }
> +                if (i > 0)
> +                    /* replace the last ' '(space) to NUL */
> +                    buf[i * 3 - 1] = '\0';
> +                else
> +                    buf[0] = '\0';

You're building this escaped buffer but...

> +            }
> +
> +            qemu_log_mask(LOG_GUEST_ERROR,
> +                          //" TDX report fatal error:\"%s\" %s",
> +                          " TDX report fatal error:\"%s\""
> +                          "error: 0x%016" PRIx64 " gpa page: 0x%016" PRIx64 "\n",
> +                          printable ? info->u.tdx.message : "",
> +                          //buf ? buf : "",

...then not actually using it

Either delete the 'buf' code, or use it.

> +                          info->u.tdx.error_code,
> +                          info->u.tdx.gpa);
> +            g_free(buf);
>          }
> +
>          qapi_free_GuestPanicInformation(info);
>      }
>  }
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index f111b46dac92..7efaa13f59e2 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -18,6 +18,7 @@
>  #include "qom/object_interfaces.h"
>  #include "standard-headers/asm-x86/kvm_para.h"
>  #include "sysemu/kvm.h"
> +#include "sysemu/runstate.h"
>  #include "sysemu/sysemu.h"
>  #include "exec/address-spaces.h"
>  #include "exec/ramblock.h"
> @@ -1408,11 +1409,26 @@ static void tdx_handle_get_quote(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
>      vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
>  }
>  
> +static void tdx_panicked_on_fatal_error(X86CPU *cpu, uint64_t error_code,
> +                                        uint64_t gpa, char *message)
> +{
> +    GuestPanicInformation *panic_info;
> +
> +    panic_info = g_new0(GuestPanicInformation, 1);
> +    panic_info->type = GUEST_PANIC_INFORMATION_TYPE_TDX;
> +    panic_info->u.tdx.error_code = error_code;
> +    panic_info->u.tdx.gpa = gpa;
> +    panic_info->u.tdx.message = (char *)message;
> +
> +    qemu_system_guest_panicked(panic_info);
> +}
> +
>  static void tdx_handle_report_fatal_error(X86CPU *cpu,
>                                            struct kvm_tdx_vmcall *vmcall)
>  {
>      uint64_t error_code = vmcall->in_r12;
>      char *message = NULL;
> +    uint64_t gpa = -1ull;
>  
>      if (error_code & 0xffff) {
>          error_report("invalid error code of TDG.VP.VMCALL<REPORT_FATAL_ERROR>\n");
> @@ -1441,7 +1457,13 @@ static void tdx_handle_report_fatal_error(X86CPU *cpu,
>      }
>  
>      error_report("TD guest reports fatal error. %s\n", message ? : "");

In tdx_panicked_on_fatal_error you're avoiding printing 'message' if it
contains non-printable characters, but here you're printing it regardless.

Do we still need this error_report call at all ?

> -    exit(1);
> +
> +#define TDX_REPORT_FATAL_ERROR_GPA_VALID    BIT_ULL(63)
> +    if (error_code & TDX_REPORT_FATAL_ERROR_GPA_VALID) {
> +	gpa = vmcall->in_r13;

Bad indent

> +    }
> +
> +    tdx_panicked_on_fatal_error(cpu, error_code, gpa, message);
>  }
>  
>  static void tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

