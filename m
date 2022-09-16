Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751AB5BB42A
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiIPV5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 17:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiIPV5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 17:57:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E9DBB6BF
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 14:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663365427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0c2Cr0S5MYztIvO89adaR4kv6d1+I/uFnDVXBZ7KGAc=;
        b=cmsEPWTrY2gNAK7e9nVrTqewqeepZ5VrB8HPq22lMms2ICKafWXBuwKeW33CsiOLsft91r
        2pDXMoz1+ARVHVXvHV6DOAV8o7b8AAUSWQeWxmNDSTN2A6O8EkH/JcR25lXFKByFX4GX/h
        T2IWVDVYP9o7jEUb5U3nntmA+j23uZc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-4FFr4v1hPwOvCoCZV_e1PQ-1; Fri, 16 Sep 2022 17:57:06 -0400
X-MC-Unique: 4FFr4v1hPwOvCoCZV_e1PQ-1
Received: by mail-qk1-f200.google.com with SMTP id d18-20020a05620a241200b006ce80a4d74aso8184234qkn.6
        for <kvm@vger.kernel.org>; Fri, 16 Sep 2022 14:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=0c2Cr0S5MYztIvO89adaR4kv6d1+I/uFnDVXBZ7KGAc=;
        b=KUi+f7DOWqZ+5Ioimzbw/SdJJLODnVUKqSIbsOJGmKWy8pIpr4r4ROTT9LVPlnF1dF
         ASKdR1flfs99hm0fMb9wjaRsBcKZlPi0oNbW20HGUkJ0bVqf3iJEjmGLPrSCdFDl1YwA
         Id9pN/RszTCWOO0pfJDkSyJEr3WvEvYGwWxTuSfD3b0yPBMCnCSSiEx9VHphNA/Kigjy
         f/POKiU+ZgYnksOqljQINzXT2gOZuQJctOLpqTm7tzcl/Go+FB8hWuaCNXVGL4X5q4SN
         M7Y0cykAQXDsrH6qYHCjUiBmP4W1cMIWJtlXiX3o0QuVvNx/x05CGZ+PYRpwyEWpoxOj
         FC+A==
X-Gm-Message-State: ACrzQf2hCdOjSYjHuhm1Xc/S23oreV1rJTiAuerDj2HPPN4G/+mNCWlV
        id6qUsfV+Y/OGsEoqNb0eN/+8+joSDAiPfS1GpWih2ezeugeY9GU1KLvc+cpwsKoFg4T74FVK79
        96dcJlUETazs7
X-Received: by 2002:a05:6214:21e6:b0:4ac:776e:ad68 with SMTP id p6-20020a05621421e600b004ac776ead68mr5570801qvj.129.1663365425566;
        Fri, 16 Sep 2022 14:57:05 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4PWBi5b9GppLC0X/lrD7DR6mfdUJUU7Pe7XEI7LsNledT7NgUI9L/x6Irs1jHBvJ4aZnBd6w==
X-Received: by 2002:a05:6214:21e6:b0:4ac:776e:ad68 with SMTP id p6-20020a05621421e600b004ac776ead68mr5570781qvj.129.1663365425261;
        Fri, 16 Sep 2022 14:57:05 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id c8-20020ac84e08000000b0035ba366cc90sm5622231qtw.15.2022.09.16.14.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 14:57:04 -0700 (PDT)
Date:   Fri, 16 Sep 2022 17:57:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 2/2] i386: Add notify VM exit support
Message-ID: <YyTxL7kstA20tB5a@xz-m1.local>
References: <20220915092839.5518-1-chenyi.qiang@intel.com>
 <20220915092839.5518-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220915092839.5518-3-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 15, 2022 at 05:28:39PM +0800, Chenyi Qiang wrote:
> There are cases that malicious virtual machine can cause CPU stuck (due
> to event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window means no event (NMI, SMI and
> IRQ) can be delivered. It leads the CPU to be unavailable to host or
> other VMs. Notify VM exit is introduced to mitigate such kind of
> attacks, which will generate a VM exit if no event window occurs in VM
> non-root mode for a specified amount of time (notify window).
> 
> A new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT is exposed to user space
> so that the user can query the capability and set the expected notify
> window when creating VMs. The format of the argument when enabling this
> capability is as follows:
>   Bit 63:32 - notify window specified in qemu command
>   Bit 31:0  - some flags (e.g. KVM_X86_NOTIFY_VMEXIT_ENABLED is set to
>               enable the feature.)
> 
> Because there are some concerns, e.g. a notify VM exit may happen with
> VM_CONTEXT_INVALID set in exit qualification (no cases are anticipated
> that would set this bit), which means VM context is corrupted. To avoid
> the false positive and a well-behaved guest gets killed, make this
> feature disabled by default. Users can enable the feature by a new
> machine property:
>     qemu -machine notify_vmexit=on,notify_window=0 ...
> 
> Note that notify_window is only valid when notify_vmexit is on. The valid
> range of notify_window is non-negative. It is even safe to set it to zero
> since there's an internal hardware threshold to be added to ensure no false
> positive.
> 
> A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
> it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
> inform the fatal case. Then user space can inject a SHUTDOWN event to
> the target vcpu. This is implemented by injecting a sythesized triple
> fault event.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  hw/i386/x86.c         | 45 +++++++++++++++++++++++++++++++++++++++++++
>  include/hw/i386/x86.h |  5 +++++
>  qemu-options.hx       | 10 +++++++++-
>  target/i386/kvm/kvm.c | 28 +++++++++++++++++++++++++++
>  4 files changed, 87 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 050eedc0c8..1eccbd3deb 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -1379,6 +1379,37 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
>      qapi_free_SgxEPCList(list);
>  }
>  
> +static bool x86_machine_get_notify_vmexit(Object *obj, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +
> +    return x86ms->notify_vmexit;
> +}
> +
> +static void x86_machine_set_notify_vmexit(Object *obj, bool value, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +
> +    x86ms->notify_vmexit = value;
> +}
> +
> +static void x86_machine_get_notify_window(Object *obj, Visitor *v,
> +                                const char *name, void *opaque, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +    uint32_t notify_window = x86ms->notify_window;
> +
> +    visit_type_uint32(v, name, &notify_window, errp);
> +}
> +
> +static void x86_machine_set_notify_window(Object *obj, Visitor *v,
> +                               const char *name, void *opaque, Error **errp)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(obj);
> +
> +    visit_type_uint32(v, name, &x86ms->notify_window, errp);
> +}
> +
>  static void x86_machine_initfn(Object *obj)
>  {
>      X86MachineState *x86ms = X86_MACHINE(obj);
> @@ -1392,6 +1423,8 @@ static void x86_machine_initfn(Object *obj)
>      x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>      x86ms->bus_lock_ratelimit = 0;
>      x86ms->above_4g_mem_start = 4 * GiB;
> +    x86ms->notify_vmexit = false;
> +    x86ms->notify_window = 0;
>  }
>  
>  static void x86_machine_class_init(ObjectClass *oc, void *data)
> @@ -1461,6 +1494,18 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
>          NULL, NULL);
>      object_class_property_set_description(oc, "sgx-epc",
>          "SGX EPC device");
> +
> +    object_class_property_add(oc, X86_MACHINE_NOTIFY_WINDOW, "uint32_t",
> +                              x86_machine_get_notify_window,
> +                              x86_machine_set_notify_window, NULL, NULL);
> +    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_WINDOW,
> +            "Set the notify window required by notify VM exit");
> +
> +    object_class_property_add_bool(oc, X86_MACHINE_NOTIFY_VMEXIT,
> +                                   x86_machine_get_notify_vmexit,
> +                                   x86_machine_set_notify_vmexit);
> +    object_class_property_set_description(oc, X86_MACHINE_NOTIFY_VMEXIT,
> +            "Enable notify VM exit");
>  }
>  
>  static const TypeInfo x86_machine_info = {
> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> index 62fa5774f8..5707329fa7 100644
> --- a/include/hw/i386/x86.h
> +++ b/include/hw/i386/x86.h
> @@ -85,6 +85,9 @@ struct X86MachineState {
>       * which means no limitation on the guest's bus locks.
>       */
>      uint64_t bus_lock_ratelimit;
> +
> +    bool notify_vmexit;
> +    uint32_t notify_window;
>  };
>  
>  #define X86_MACHINE_SMM              "smm"
> @@ -94,6 +97,8 @@ struct X86MachineState {
>  #define X86_MACHINE_OEM_ID           "x-oem-id"
>  #define X86_MACHINE_OEM_TABLE_ID     "x-oem-table-id"
>  #define X86_MACHINE_BUS_LOCK_RATELIMIT  "bus-lock-ratelimit"
> +#define X86_MACHINE_NOTIFY_VMEXIT     "notify-vmexit"
> +#define X86_MACHINE_NOTIFY_WINDOW     "notify-window"
>  
>  #define TYPE_X86_MACHINE   MACHINE_TYPE_NAME("x86")
>  OBJECT_DECLARE_TYPE(X86MachineState, X86MachineClass, X86_MACHINE)
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 31c04f7eea..3cdeeac8f3 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -37,7 +37,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>      "                memory-encryption=@var{} memory encryption object to use (default=none)\n"
>      "                hmat=on|off controls ACPI HMAT support (default=off)\n"
>      "                memory-backend='backend-id' specifies explicitly provided backend for main RAM (default=none)\n"
> -    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n",
> +    "                cxl-fmw.0.targets.0=firsttarget,cxl-fmw.0.targets.1=secondtarget,cxl-fmw.0.size=size[,cxl-fmw.0.interleave-granularity=granularity]\n"
> +    "                notify_vmexit=on|off,notify_window=n controls notify VM exit support (default=off) and specifies the notify window size (default=0)\n",
>      QEMU_ARCH_ALL)
>  SRST
>  ``-machine [type=]name[,prop=value[,...]]``
> @@ -157,6 +158,13 @@ SRST
>          ::
>  
>              -machine cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.targets.1=cxl.1,cxl-fmw.0.size=128G,cxl-fmw.0.interleave-granularity=512k
> +
> +    ``notify_vmexit=on|off,notify_window=n``
> +        Enables or disables Notify VM exit support on x86 host and specify
> +        the corresponding notify window to trigger the VM exit if enabled.
> +        This feature can mitigate the CPU stuck issue due to event windows
> +        don't open up for a specified of time (notify window).
> +        The default is off.
>  ERST
>  
>  DEF("M", HAS_ARG, QEMU_OPTION_M,
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 3838827134..ae7fb2c495 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2597,6 +2597,20 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>              ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
>                                  x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
>          }
> +
> +        if (x86ms->notify_vmexit &&
> +            kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
> +            uint64_t notify_window_flags = ((uint64_t)x86ms->notify_window << 32) |
> +                                           KVM_X86_NOTIFY_VMEXIT_ENABLED |
> +                                           KVM_X86_NOTIFY_VMEXIT_USER;

It'll always request a user exit here as long as enabled, then...

> +            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
> +                                    notify_window_flags);
> +            if (ret < 0) {
> +                error_report("kvm: Failed to enable notify vmexit cap: %s",
> +                             strerror(-ret));
> +                return ret;
> +            }
> +        }
>      }
>  
>      return 0;
> @@ -5141,6 +5155,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>      X86CPU *cpu = X86_CPU(cs);
>      uint64_t code;
>      int ret;
> +    struct kvm_vcpu_events events = {};
>  
>      switch (run->exit_reason) {
>      case KVM_EXIT_HLT:
> @@ -5196,6 +5211,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>          /* already handled in kvm_arch_post_run */
>          ret = 0;
>          break;
> +    case KVM_EXIT_NOTIFY:
> +        ret = 0;
> +        if (run->notify.flags & KVM_NOTIFY_CONTEXT_INVALID) {
> +            warn_report("KVM: invalid context due to notify vmexit");
> +            if (has_triple_fault_event) {
> +                events.flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
> +                events.triple_fault.pending = true;
> +                ret = kvm_vcpu_ioctl(cs, KVM_SET_VCPU_EVENTS, &events);
> +            } else {
> +                ret = -1;
> +            }
> +        }

... should we do something even if the context is valid?  Or I'm a bit
confused why KVM_X86_NOTIFY_VMEXIT_USER was set (IIUC we can just enable it
without setting VMEXIT_USER then).

Not sure some warning would be also useful here, but I really don't know
the whole context so I can't tell whether there can easily be false
positives to pollute qemu log.

> +        break;
>      default:
>          fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
>          ret = -1;
> -- 
> 2.17.1
> 

-- 
Peter Xu

