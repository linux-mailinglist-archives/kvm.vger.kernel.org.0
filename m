Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7960619005
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 06:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiKDFh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 01:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKDFh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 01:37:56 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C5827FD5;
        Thu,  3 Nov 2022 22:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667540274; x=1699076274;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EgmtsBqJVK3JbLONjG56zRgFCzcOwywt2/xTnCkOP1Y=;
  b=RRsqVmeFV1jdWym2d/I+Kc9LjXpsQQlKhLAOZVCDQxfjGNhGTwTvv5Dq
   oENIPmIdC9RWNBMANhk8/4BkB7cx/usEvNcjvXEHJiN49nMgBKdvTnq/M
   8x1ht8HlyB+DYQ0xJg36bhoKX8fkXHvlmPpt7zqpYJw/InLqK+3BffjM/
   vlV1bvNUgnH5n6eE2Z2byVu7fWSmbq2hw776McV4ezWkYYr3v3jrYqsL8
   qSsUTpFiD0KpRUGMHF4By711gZcuO/mS+XYbduSeo43EtIsuNSER2sxiW
   Dt9aEsSQ4YhqwToPklubLr8rGdZacR3iz38o+yHQJMjAmSmwg1fU8MloG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="336584917"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="336584917"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 22:37:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="666249074"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="666249074"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga008.jf.intel.com with ESMTP; 03 Nov 2022 22:37:46 -0700
Date:   Fri, 4 Nov 2022 13:37:45 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 03/44] KVM: Allocate cpus_hardware_enabled after arch
 hardware setup
Message-ID: <20221104053745.qvi35kflf2i2ifgs@yy-desk-7060>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102231911.3107438-4-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02, 2022 at 11:18:30PM +0000, Sean Christopherson wrote:
> Allocate cpus_hardware_enabled after arch hardware setup so that arch
> "init" and "hardware setup" are called back-to-back and thus can be
> combined in a future patch.  cpus_hardware_enabled is never used before
> kvm_create_vm(), i.e. doesn't have a dependency with hardware setup and
> only needs to be allocated before /dev/kvm is exposed to userspace.
>
> Free the object before the arch hooks are invoked to maintain symmetry,
> and so that arch code can move away from the hooks without having to
> worry about ordering changes.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e0424af52acc..8b7534cc953b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -5843,15 +5843,15 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	if (r)
>  		return r;
>
> +	r = kvm_arch_hardware_setup(opaque);
> +	if (r < 0)
> +		goto err_hw_setup;
> +
>  	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>  		r = -ENOMEM;
>  		goto err_hw_enabled;
>  	}
>
> -	r = kvm_arch_hardware_setup(opaque);
> -	if (r < 0)
> -		goto out_free_1;
> -
>  	c.ret = &r;
>  	c.opaque = opaque;
>  	for_each_online_cpu(cpu) {
> @@ -5937,10 +5937,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  out_free_2:
> -	kvm_arch_hardware_unsetup();
> -out_free_1:
>  	free_cpumask_var(cpus_hardware_enabled);
>  err_hw_enabled:
> +	kvm_arch_hardware_unsetup();
> +err_hw_setup:
>  	kvm_arch_exit();
>  	return r;
>  }
> @@ -5967,9 +5967,9 @@ void kvm_exit(void)
>  	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
>  	on_each_cpu(hardware_disable_nolock, NULL, 1);
>  	kvm_irqfd_exit();
> +	free_cpumask_var(cpus_hardware_enabled);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
> -	free_cpumask_var(cpus_hardware_enabled);
>  	kvm_vfio_ops_exit();

Looks good to me.

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

>  }
>  EXPORT_SYMBOL_GPL(kvm_exit);
> --
> 2.38.1.431.g37b22c650d-goog
>
