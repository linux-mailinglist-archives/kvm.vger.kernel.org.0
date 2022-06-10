Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018BA546CBB
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350314AbiFJSuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 14:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346052AbiFJSuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 14:50:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8533821E0D
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654886998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=McN09X0kZnrKky2bSb99+lsxadBPHvLQh0I13pP449s=;
        b=RejczdnD7Ai9fvgj3S0pnUSVTGspxyIhvLNZDvsR6r06ET0TiEzTSwJBxomqMwjTkNvF2M
        YgOyT6DqZccNk2+LC/piFw2HMfjOI6JYJ0Vyv+ub5TESy9uo+V4z0Tz3PzJgwyKJ1F5SJE
        uguR3fX5eBmpbG1nu29ol7xur6U4tgA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-4eekx7HeMjGX7c_OErpDQQ-1; Fri, 10 Jun 2022 14:49:57 -0400
X-MC-Unique: 4eekx7HeMjGX7c_OErpDQQ-1
Received: by mail-wm1-f69.google.com with SMTP id v184-20020a1cacc1000000b0039c7efa3e95so720579wme.3
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 11:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=McN09X0kZnrKky2bSb99+lsxadBPHvLQh0I13pP449s=;
        b=zCegn+OlMuU1qx/GJ1dBrf/Hx3guD5KvdGZe2lrOWOhRak5Z0c2k4U2ySIjxmK75o5
         fHGRKUwC1D+upDzXDnJqmwCe2CBDw4MQSNcpE59INuUkiaKpBSdqpNmc4FcqQRi45zH4
         dwT2e3DJTvH3oiaHQC6wm/pA1ODSZjL72ruYcyY8hrXjjsRRqhdvqYzmdan/3lStRgrI
         RxoKzmKT1WerhexrRYMgg1MGkusUgBIWg8C/1Efbd/G+ypFrvP0OEbDU3ytvd5Zn7cMc
         dGWxshAvIo/WQpJWAm3zhEkH+HIGMl/FYOwxtrzYT3JvUOaPJS/4TOVl/xQjbFKqtsLk
         rhKQ==
X-Gm-Message-State: AOAM531gHDjmQCOsu7VGaKh5UstYs8oDQpW7CEuVMZBoUByYliNSp/Ed
        a9wVNpl1yz0AyKYZFjtOIuiFxIM1h5Nh7MPq09dphN3HNFssCzc97zng6B86/NZduHN2AgxC5Sq
        K43+VSOJGvmJl
X-Received: by 2002:a05:6000:1889:b0:218:4de1:25a3 with SMTP id a9-20020a056000188900b002184de125a3mr22629297wri.622.1654886996295;
        Fri, 10 Jun 2022 11:49:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzws8zoHO4xGTwJMM2hAVJqUWeUoZlbhX323ueGFITxDpVfmDeGhYNvjQdf5iPWCNmtcIielw==
X-Received: by 2002:a05:6000:1889:b0:218:4de1:25a3 with SMTP id a9-20020a056000188900b002184de125a3mr22629279wri.622.1654886996063;
        Fri, 10 Jun 2022 11:49:56 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id f187-20020a1c38c4000000b003973ea7e725sm4702574wma.0.2022.06.10.11.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 11:49:55 -0700 (PDT)
Date:   Fri, 10 Jun 2022 20:49:53 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 144/144] KVM: selftests: Sanity check input to
 ioctls() at build time
Message-ID: <20220610184953.34yn2eq2mmm7cp4n@gator>
References: <20220603004331.1523888-1-seanjc@google.com>
 <20220603004331.1523888-145-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603004331.1523888-145-seanjc@google.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 12:43:31AM +0000, Sean Christopherson wrote:
> Add a static assert to the KVM/VM/vCPU ioctl() helpers to verify that the
> size of the argument provided matches the expected size of the IOCTL.
> Because ioctl() ultimately takes a "void *", it's all too easy to pass in
> garbage and not detect the error until runtime.  E.g. while working on a
> CPUID rework, selftests happily compiled when vcpu_set_cpuid()
> unintentionally passed the cpuid() function as the parameter to ioctl()
> (a local "cpuid" parameter was removed, but its use was not replaced with
> "vcpu->cpuid" as intended).
> 
> Tweak a variety of benign issues that aren't compatible with the sanity
> check, e.g. passing a non-pointer for ioctls().
> 
> Note, static_assert() requires a string on older versions of GCC.  Feed
> it an empty string to make the compiler happy.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../selftests/kvm/include/kvm_util_base.h     | 61 +++++++++++++------
>  .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
>  tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +--------
>  tools/testing/selftests/kvm/s390x/resets.c    |  6 +-
>  .../selftests/kvm/x86_64/mmio_warning_test.c  |  2 +-
>  .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
>  .../selftests/kvm/x86_64/xen_shinfo_test.c    |  6 +-
>  8 files changed, 56 insertions(+), 54 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 04ddab322b6b..0eaf0c9b7612 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -180,29 +180,56 @@ static inline bool kvm_has_cap(long cap)
>  #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
>  #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
>  
> -#define __kvm_ioctl(kvm_fd, cmd, arg) \
> -	ioctl(kvm_fd, cmd, arg)
> +#define kvm_do_ioctl(fd, cmd, arg)						\
> +({										\
> +	static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd), "");	\
> +	ioctl(fd, cmd, arg);							\
> +})
>  
> -static inline void _kvm_ioctl(int kvm_fd, unsigned long cmd, const char *name,
> -			      void *arg)
> -{
> -	int ret = __kvm_ioctl(kvm_fd, cmd, arg);
> +#define __kvm_ioctl(kvm_fd, cmd, arg)						\
> +	kvm_do_ioctl(kvm_fd, cmd, arg)
>  
> -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
> -}
> +

While we've gained the static asserts we've also lost the type checking
that the inline functions provided. Is there anyway we can bring them back
with more macro tricks?

> +#define _kvm_ioctl(kvm_fd, cmd, name, arg)					\
> +({										\
> +	int ret = __kvm_ioctl(kvm_fd, cmd, arg);				\
> +										\
> +	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
> +})
>  
>  #define kvm_ioctl(kvm_fd, cmd, arg) \
>  	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
>  
> -int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
> -void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg);
> -#define vm_ioctl(vm, cmd, arg) _vm_ioctl(vm, cmd, #cmd, arg)
> -
> -int __vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd,
> -		 void *arg);
> -void _vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd,
> -		 const char *name, void *arg);
> -#define vcpu_ioctl(vcpu, cmd, arg) \
> +#define __vm_ioctl(vm, cmd, arg)						\
> +({										\
> +	static_assert(sizeof(*(vm)) == sizeof(struct kvm_vm), "");		\
> +	kvm_do_ioctl((vm)->fd, cmd, arg);					\
> +})
> +
> +#define _vm_ioctl(vcpu, cmd, name, arg)						\
> +({										\
> +	int ret = __vm_ioctl(vcpu, cmd, arg);					\
> +										\
> +	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
> +})
> +
> +#define vm_ioctl(vm, cmd, arg)							\
> +	_vm_ioctl(vm, cmd, #cmd, arg)
> +
> +#define __vcpu_ioctl(vcpu, cmd, arg)						\
> +({										\
> +	static_assert(sizeof(*(vcpu)) == sizeof(struct kvm_vcpu), "");		\
> +	kvm_do_ioctl((vcpu)->fd, cmd, arg);					\
> +})
> +
> +#define _vcpu_ioctl(vcpu, cmd, name, arg)					\
> +({										\
> +	int ret = __vcpu_ioctl(vcpu, cmd, arg);					\
> +										\
> +	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
> +})
> +
> +#define vcpu_ioctl(vcpu, cmd, arg)						\
>  	_vcpu_ioctl(vcpu, cmd, #cmd, arg)
>  
>  /*
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> index 6bd27782f00c..6f5551368944 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
> @@ -472,7 +472,7 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
>  	};
>  
>  	kvm_fd = open_kvm_dev_path_or_exit();
> -	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, ipa);
> +	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, (void *)(unsigned long)ipa);
>  	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
>  
>  	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
> diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
> index 0be56c63aed6..99a575bbbc52 100644
> --- a/tools/testing/selftests/kvm/lib/guest_modes.c
> +++ b/tools/testing/selftests/kvm/lib/guest_modes.c
> @@ -65,7 +65,7 @@ void guest_modes_append_default(void)
>  		struct kvm_s390_vm_cpu_processor info;
>  
>  		kvm_fd = open_kvm_dev_path_or_exit();
> -		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, 0);
> +		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
>  		kvm_device_attr_get(vm_fd, KVM_S390_VM_CPU_MODEL,
>  				    KVM_S390_VM_CPU_PROCESSOR, &info);
>  		close(vm_fd);
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 603a6d529357..f0300767df16 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -72,7 +72,7 @@ unsigned int kvm_check_cap(long cap)
>  	int kvm_fd;
>  
>  	kvm_fd = open_kvm_dev_path_or_exit();
> -	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
> +	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, (void *)cap);
>  	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
>  
>  	close(kvm_fd);
> @@ -92,7 +92,7 @@ static void vm_open(struct kvm_vm *vm)
>  
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT));
>  
> -	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
> +	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
>  	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
>  }
>  
> @@ -1449,19 +1449,6 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
>  	return reg_list;
>  }
>  
> -int __vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd, void *arg)
> -{
> -	return ioctl(vcpu->fd, cmd, arg);
> -}
> -
> -void _vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd, const char *name,
> -		 void *arg)
> -{
> -	int ret = __vcpu_ioctl(vcpu, cmd, arg);
> -
> -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
> -}
> -
>  void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
>  {
>  	uint32_t page_size = vcpu->vm->page_size;
> @@ -1491,18 +1478,6 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
>  	return vcpu->dirty_gfns;
>  }
>  
> -int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
> -{
> -	return ioctl(vm->fd, cmd, arg);
> -}
> -
> -void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg)
> -{
> -	int ret = __vm_ioctl(vm, cmd, arg);
> -
> -	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
> -}
> -
>  /*
>   * Device Ioctl
>   */
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> index 4ba866047401..359fd18f473b 100644
> --- a/tools/testing/selftests/kvm/s390x/resets.c
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -224,7 +224,7 @@ static void test_normal(void)
>  
>  	inject_irq(vcpu);
>  
> -	vcpu_ioctl(vcpu, KVM_S390_NORMAL_RESET, 0);
> +	vcpu_ioctl(vcpu, KVM_S390_NORMAL_RESET, NULL);
>  
>  	/* must clears */
>  	assert_normal(vcpu);
> @@ -247,7 +247,7 @@ static void test_initial(void)
>  
>  	inject_irq(vcpu);
>  
> -	vcpu_ioctl(vcpu, KVM_S390_INITIAL_RESET, 0);
> +	vcpu_ioctl(vcpu, KVM_S390_INITIAL_RESET, NULL);
>  
>  	/* must clears */
>  	assert_normal(vcpu);
> @@ -270,7 +270,7 @@ static void test_clear(void)
>  
>  	inject_irq(vcpu);
>  
> -	vcpu_ioctl(vcpu, KVM_S390_CLEAR_RESET, 0);
> +	vcpu_ioctl(vcpu, KVM_S390_CLEAR_RESET, NULL);
>  
>  	/* must clears */
>  	assert_normal(vcpu);
> diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> index 0e4590afd0e1..fb02581953a3 100644
> --- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
> @@ -59,7 +59,7 @@ void test(void)
>  
>  	kvm = open("/dev/kvm", O_RDWR);
>  	TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
> -	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, 0);
> +	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, NULL);
>  	TEST_ASSERT(kvmvm > 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, kvmvm));
>  	kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
>  	TEST_ASSERT(kvmcpu != -1, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, kvmcpu));
> diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> index de9ee00d84cf..66930384ef97 100644
> --- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
> @@ -266,7 +266,7 @@ static void test_without_filter(struct kvm_vcpu *vcpu)
>  static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
>  				 struct kvm_pmu_event_filter *f)
>  {
> -	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
> +	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
>  	return run_vcpu_to_sync(vcpu);
>  }
>  
> diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> index bdcb28186ccc..a4a78637c35a 100644
> --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> @@ -472,7 +472,7 @@ int main(int argc, char *argv[])
>  		irq_routes.entries[1].u.xen_evtchn.vcpu = vcpu->id;
>  		irq_routes.entries[1].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
>  
> -		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes);
> +		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes.info);
>  
>  		struct kvm_irqfd ifd = { };
>  
> @@ -716,7 +716,7 @@ int main(int argc, char *argv[])
>  				if (verbose)
>  					printf("Testing restored oneshot timer\n");
>  
> -				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
> +				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
>  				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
>  				evtchn_irq_expected = true;
>  				alarm(1);
> @@ -743,7 +743,7 @@ int main(int argc, char *argv[])
>  				if (verbose)
>  					printf("Testing SCHEDOP_poll wake on masked event\n");
>  
> -				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
> +				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
>  				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
>  				alarm(1);
>  				break;
> -- 
> 2.36.1.255.ge46751e96f-goog
>

The last two changes don't really belong in this commit, but I won't tell
anyway, if you don't.

Thanks,
drew

