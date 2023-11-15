Return-Path: <kvm+bounces-1816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E5C7EC0F2
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:50:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1CCE2B20B9B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684AA154BB;
	Wed, 15 Nov 2023 10:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JgYJXRME"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C111429F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:50:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8FC9F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 02:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700045398;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=EckYgwkwwSkSYPagT6/9kFGRleQBjP+7eIXf7tbFoMc=;
	b=JgYJXRME4VEkDalkm0/492UInWoDqNmUol4JpYgv5MS542/LdgwHI0nde9lFxwoFuNnedq
	V0xYn4c24Xs6tYwUVB28cIYzcfWTsL3ncM6f/2D1Bl2DTqeHJ1X3EsnsOjnavy5RG2NHut
	n6plf6r+BI0SijtWbanVCqTWdAdKnko=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-53-miCb_rIOOE-9AhmiMytD5g-1; Wed,
 15 Nov 2023 05:49:55 -0500
X-MC-Unique: miCb_rIOOE-9AhmiMytD5g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05A2028040B7;
	Wed, 15 Nov 2023 10:49:55 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.144])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 700252026D4C;
	Wed, 15 Nov 2023 10:49:50 +0000 (UTC)
Date: Wed, 15 Nov 2023 10:49:47 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v3 14/70] target/i386: Implement mc->kvm_type() to get VM
 type
Message-ID: <ZVSiSygaFI41vze9@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-15-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115071519.2864957-15-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Wed, Nov 15, 2023 at 02:14:23AM -0500, Xiaoyao Li wrote:
> Implement mc->kvm_type() for i386 machines. It provides a way for user
> to create SW_PROTECTE_VM.

Small typo there missing final 'D' in 'PROTECTED'

> 
> Also store the vm_type in machinestate to other code to query what the
> VM type is.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  hw/i386/x86.c              | 12 ++++++++++++
>  include/hw/i386/x86.h      |  1 +
>  target/i386/kvm/kvm.c      | 25 +++++++++++++++++++++++++
>  target/i386/kvm/kvm_i386.h |  1 +
>  4 files changed, 39 insertions(+)
> 
> diff --git a/hw/i386/x86.c b/hw/i386/x86.c
> index b3d054889bba..55678279bf3b 100644
> --- a/hw/i386/x86.c
> +++ b/hw/i386/x86.c
> @@ -1377,6 +1377,17 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
>      qapi_free_SgxEPCList(list);
>  }
>  
> +static int x86_kvm_type(MachineState *ms, const char *vm_type)
> +{
> +    X86MachineState *x86ms = X86_MACHINE(ms);
> +    int kvm_type;
> +
> +    kvm_type = kvm_get_vm_type(ms, vm_type);
> +    x86ms->vm_type = kvm_type;
> +
> +    return kvm_type;
> +}
> +
>  static void x86_machine_initfn(Object *obj)
>  {
>      X86MachineState *x86ms = X86_MACHINE(obj);
> @@ -1401,6 +1412,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
>      mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
>      mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
>      mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
> +    mc->kvm_type = x86_kvm_type;
>      x86mc->save_tsc_khz = true;
>      x86mc->fwcfg_dma_enabled = true;
>      nc->nmi_monitor_handler = x86_nmi;
> diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
> index da19ae15463a..ab1d38569019 100644
> --- a/include/hw/i386/x86.h
> +++ b/include/hw/i386/x86.h
> @@ -41,6 +41,7 @@ struct X86MachineState {
>      MachineState parent;
>  
>      /*< public >*/
> +    unsigned int vm_type;
>  
>      /* Pointers to devices and objects: */
>      ISADevice *rtc;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index b4b9ce89842f..2e47fda25f95 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -161,6 +161,31 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
>  static RateLimit bus_lock_ratelimit_ctrl;
>  static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
>  
> +static const char* vm_type_name[] = {

nitpick   'char *vm_type_name[]', is normal style

> +    [KVM_X86_DEFAULT_VM] = "default",
> +    [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
> +};
> +
> +int kvm_get_vm_type(MachineState *ms, const char *vm_type)
> +{
> +    int kvm_type = KVM_X86_DEFAULT_VM;
> +
> +    /*
> +     * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
> +     * is always supported
> +     */
> +    if (kvm_type == KVM_X86_DEFAULT_VM) {
> +        return kvm_type;
> +    }
> +
> +    if (!(kvm_check_extension(KVM_STATE(ms->accelerator), KVM_CAP_VM_TYPES) & BIT(kvm_type))) {
> +        error_report("vm-type %s not supported by KVM", vm_type_name[kvm_type]);
> +        exit(1);
> +    }
> +
> +    return kvm_type;
> +}
> +
>  bool kvm_has_smm(void)
>  {
>      return kvm_vm_check_extension(kvm_state, KVM_CAP_X86_SMM);
> diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
> index 30fedcffea3e..55fb25fa8e2e 100644
> --- a/target/i386/kvm/kvm_i386.h
> +++ b/target/i386/kvm/kvm_i386.h
> @@ -37,6 +37,7 @@ bool kvm_hv_vpindex_settable(void);
>  bool kvm_enable_sgx_provisioning(KVMState *s);
>  bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp);
>  
> +int kvm_get_vm_type(MachineState *ms, const char *vm_type);
>  void kvm_arch_reset_vcpu(X86CPU *cs);
>  void kvm_arch_after_reset_vcpu(X86CPU *cpu);
>  void kvm_arch_do_init_vcpu(X86CPU *cs);
> -- 
> 2.34.1
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


