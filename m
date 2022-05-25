Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07675335E4
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 05:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243279AbiEYDnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 23:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235282AbiEYDnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 23:43:41 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D8578930
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 20:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653450220; x=1684986220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qGWM+9u8b/eYtYT82OQNHEmZEQNTwLIWRX65oI1GBMk=;
  b=DMf6Tneq+dvhrC8FtRC0J2Wux9R0/j2j3iHoKE3jxAeFCCKM4J+sNndu
   9nXNCIv76bbuhdgD4KuN3VwqV18EH51FFPxTCB0OmtE9qY+qVCwYSnXHc
   OCovUgV3+U5cbR93r6WvhCxTofoIrNnt867ysB0ASpcVZaRY2KVWG5GvW
   wfOgpP6LbM/rWtHlixGuv/vnj8W6KQ/LYKKZtbqPHmVoFiSm7RA6apwNt
   +knrdfIFn9zlPa3kWfGUVzBl4wS6ImzZEADQqjn7V7NWJpEcf3/wblsW3
   O3qaHMjlXWui68PABvbfBbSHORJe/+9r0a0ChIa045nudBrQYeXcmqpAD
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="255769462"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="255769462"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 20:43:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="559392462"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga002.jf.intel.com with ESMTP; 24 May 2022 20:43:36 -0700
Date:   Wed, 25 May 2022 11:43:36 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 3/3] i386: Add notify VM exit support
Message-ID: <20220525034336.2oxscnus7arrorvy@yy-desk-7060>
References: <20220524140302.23272-1-chenyi.qiang@intel.com>
 <20220524140302.23272-4-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524140302.23272-4-chenyi.qiang@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 24, 2022 at 10:03:02PM +0800, Chenyi Qiang wrote:
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
> A new KVM exit reason KVM_EXIT_NOTIFY is defined for notify VM exit. If
> it happens with VM_INVALID_CONTEXT, hypervisor exits to user space to
> inform the fatal case. Then user space can inject a SHUTDOWN event to
> the target vcpu. This is implemented by injecting a sythesized triple
> fault event.
>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  hw/i386/x86.c         | 45 +++++++++++++++++++++++++++++
>  include/hw/i386/x86.h |  5 ++++
>  target/i386/kvm/kvm.c | 66 ++++++++++++++++++++++++++++++-------------
>  3 files changed, 96 insertions(+), 20 deletions(-)
>
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index 4cf107baea..a82f959cb9 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -1296,6 +1296,37 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
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
> @@ -1306,6 +1337,8 @@ static void x86_machine_initfn(Object *obj)
>      x86ms->oem_id = g_strndup(ACPI_BUILD_APPNAME6, 6);
>      x86ms->oem_table_id = g_strndup(ACPI_BUILD_APPNAME8, 8);
>      x86ms->bus_lock_ratelimit = 0;
> +    x86ms->notify_vmexit = false;
> +    x86ms->notify_window = 0;
>  }
>
>  static void x86_machine_class_init(ObjectClass *oc, void *data)
> @@ -1361,6 +1394,18 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
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
> index 916cc325ee..571ee8b667 100644
> --- a/include/hw/i386/x86.h
> +++ b/include/hw/i386/x86.h
> @@ -80,6 +80,9 @@ struct X86MachineState {
>       * which means no limitation on the guest's bus locks.
>       */
>      uint64_t bus_lock_ratelimit;
> +
> +    bool notify_vmexit;
> +    uint32_t notify_window;
>  };
>
>  #define X86_MACHINE_SMM              "smm"
> @@ -87,6 +90,8 @@ struct X86MachineState {
>  #define X86_MACHINE_OEM_ID           "x-oem-id"
>  #define X86_MACHINE_OEM_TABLE_ID     "x-oem-table-id"
>  #define X86_MACHINE_BUS_LOCK_RATELIMIT  "bus-lock-ratelimit"
> +#define X86_MACHINE_NOTIFY_VMEXIT     "notify-vmexit"
> +#define X86_MACHINE_NOTIFY_WINDOW     "notify-window"
>
>  #define TYPE_X86_MACHINE   MACHINE_TYPE_NAME("x86")
>  OBJECT_DECLARE_TYPE(X86MachineState, X86MachineClass, X86_MACHINE)
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 2f2fc18b4f..6aaedf3412 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2345,6 +2345,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      int ret;
>      struct utsname utsname;
>      Error *local_err = NULL;
> +    X86MachineState *x86ms;
> +
> +    assert(object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE));
> +    x86ms = X86_MACHINE(ms);
>
>      /*
>       * Initialize SEV context, if required
> @@ -2450,8 +2454,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      }
>
>      if (kvm_check_extension(s, KVM_CAP_X86_SMM) &&
> -        object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE) &&
> -        x86_machine_is_smm_enabled(X86_MACHINE(ms))) {
> +        x86_machine_is_smm_enabled(x86ms)) {
>          smram_machine_done.notify = register_smram_listener;
>          qemu_add_machine_init_done_notifier(&smram_machine_done);
>      }
> @@ -2479,25 +2482,34 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>
> -    if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {

The original behavior:

if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
... do some thing }
return 0;

Note that it won't throw any exceptions if ms is not
instance of TYPE_X86_MACHINE, but now the assert() throws
exceptions in this case. In another hand, assert() may
become nothing in NDEBUG case.

May move the whole BUS LOCK part and new NOTIFY_VMEXIT part
to 2 separate functions and call them from kvm_arch_init()
makes the readability better.

> -        X86MachineState *x86ms = X86_MACHINE(ms);
> +    if (x86ms->bus_lock_ratelimit > 0) {
> +        ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
> +        if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
> +            error_report("kvm: bus lock detection unsupported");
> +            return -ENOTSUP;
> +        }
> +        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
> +                                KVM_BUS_LOCK_DETECTION_EXIT);
> +        if (ret < 0) {
> +            error_report("kvm: Failed to enable bus lock detection cap: %s",
> +                         strerror(-ret));
> +            return ret;
> +        }
> +        ratelimit_init(&bus_lock_ratelimit_ctrl);
> +        ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
> +                            x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
> +    }
>
> -        if (x86ms->bus_lock_ratelimit > 0) {
> -            ret = kvm_check_extension(s, KVM_CAP_X86_BUS_LOCK_EXIT);
> -            if (!(ret & KVM_BUS_LOCK_DETECTION_EXIT)) {
> -                error_report("kvm: bus lock detection unsupported");
> -                return -ENOTSUP;
> -            }
> -            ret = kvm_vm_enable_cap(s, KVM_CAP_X86_BUS_LOCK_EXIT, 0,
> -                                    KVM_BUS_LOCK_DETECTION_EXIT);
> -            if (ret < 0) {
> -                error_report("kvm: Failed to enable bus lock detection cap: %s",
> -                             strerror(-ret));
> -                return ret;
> -            }
> -            ratelimit_init(&bus_lock_ratelimit_ctrl);
> -            ratelimit_set_speed(&bus_lock_ratelimit_ctrl,
> -                                x86ms->bus_lock_ratelimit, BUS_LOCK_SLICE_TIME);
> +    if (x86ms->notify_vmexit && kvm_check_extension(s, KVM_CAP_X86_NOTIFY_VMEXIT)) {
> +        uint64_t notify_window_flags = ((uint64_t)x86ms->notify_window << 32) |
> +                                        KVM_X86_NOTIFY_VMEXIT_ENABLED |
> +                                        KVM_X86_NOTIFY_VMEXIT_USER;
> +        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_NOTIFY_VMEXIT, 0,
> +                                notify_window_flags);
> +        if (ret < 0) {
> +            error_report("kvm: Failed to enable notify vmexit cap: %s",
> +                         strerror(-ret));
> +            return ret;
>          }
>      }
>
> @@ -4940,6 +4952,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>      X86CPU *cpu = X86_CPU(cs);
>      uint64_t code;
>      int ret;
> +    struct kvm_vcpu_events events = {};
>
>      switch (run->exit_reason) {
>      case KVM_EXIT_HLT:
> @@ -4995,6 +5008,19 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
> +        break;
>      default:
>          fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
>          ret = -1;
> --
> 2.17.1
>
