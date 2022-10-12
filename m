Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F7C5FCC43
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJLUoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiJLUnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:43:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6565108DE4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:43:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i6so12271811pli.12
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U6r/BPuFlFmFKd44EKySSOKaSq/489LAsa5byNyptW8=;
        b=RnEe0ZX+RHvVag17aEkAUEXw3yPvtk0wrRCTtThUqRZUYQJxmmTC0nhCKDdOMBwVhp
         k224QpffiM/1rSCpcSmJxrDqW2zPD9Bb7kYnRg03JTHiRHx+WV5fIQpg/XBOirrKwl2+
         R325Yugy7Jv1PZVc5vKN7pfiRDTrnU7hOm9fBYuWVWriWsYyE9fpRnW1/IKA+gf7i+Ez
         ED5QLEgks5D+jr56BGxICRUEyKzQdXB/9YVNsH8oFOPIsXe2RSsILF1rqwcnSDA0+EHv
         /NGOGQ9hjaiIW0e+0IXFR3PU8/kXkWuPjMFKa70m4/wKOW9EUdRT1lDvZA2m6U2pDWtT
         J2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6r/BPuFlFmFKd44EKySSOKaSq/489LAsa5byNyptW8=;
        b=6OCkk3bMIt0wXPxkCJKeUSo5PqMb1+ppIMbh8hwM/FxzFTCxwlDbJMTAOi1X+caEJg
         tNZn95AhO5vNr4dSFsjcZ9hNlWCcV6Y4zDr6ldUjMNLW38Ox6eO8fmBDlSUsFbAcQQXj
         GjCN2sCA1ZKAIiFBX3BwJ0euGek4zkg4Xux0OmcgNKliUQTNwALCPHFuscJhWGGzDIvU
         RyEwlKnT7SBNpPOtGnZddw63cSeAo1mwznW0amOg287pG53ALo5Xd0D2FeYFtb6pVtk3
         5S/pZTc/NROdmy6ZNoypv4rozKth58g8WT4I/Gx6hzXKP6Hh/OkQw8QxbAjayvde+iGQ
         mDwQ==
X-Gm-Message-State: ACrzQf0dpILMtIxIbemmzm+9L3UgLicr9qwhikf6GjND+vFg9qXU/OlS
        6go/Z5XMWA5HG9XWvRCfMgxykg==
X-Google-Smtp-Source: AMsMyM7izQqjj1waykTDHWBlkRoyvjYygmLJQciJ4HBHmj/OkRkXvuQE4xmk6WpnEXGpBUCQp+2gNA==
X-Received: by 2002:a17:90b:1e0b:b0:20d:85ca:b50e with SMTP id pg11-20020a17090b1e0b00b0020d85cab50emr6766634pjb.82.1665607394482;
        Wed, 12 Oct 2022 13:43:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m14-20020a17090a668e00b0020aedddd3cesm1842187pjj.5.2022.10.12.13.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 13:43:13 -0700 (PDT)
Date:   Wed, 12 Oct 2022 20:43:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v5 10/30] KVM: Add arch hooks when VM is added/deleted
Message-ID: <Y0cm3dJmgnpLgswQ@google.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
 <aab342d576fe22b8f5b27e61d4fc635d45a4f866.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab342d576fe22b8f5b27e61d4fc635d45a4f866.1663869838.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> and pass kvm_usage_count with kvm_lock.  Move kvm_arch_post_init_vm() under
> kvm_arch_add_vm().  Replace enable/disable_hardware_all() with the default
> implementation of kvm_arch_add/del_vm().  Later kvm_arch_post_init_vm() is
> deleted once x86 overrides kvm_arch_add_vm().

This needs to explain _why_ KVM is pivoting to add/remove hooks.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/linux/kvm_host.h |   2 +
>  virt/kvm/kvm_main.c      | 121 ++++++++++++++++++++-------------------
>  2 files changed, 65 insertions(+), 58 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index eab352902de7..3fbb01bbac98 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1445,6 +1445,8 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
>  bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
>  int kvm_arch_post_init_vm(struct kvm *kvm);
> +int kvm_arch_add_vm(struct kvm *kvm, int usage_count);
> +int kvm_arch_del_vm(int usage_count);
>  void kvm_arch_pre_destroy_vm(struct kvm *kvm);
>  int kvm_arch_create_vm_debugfs(struct kvm *kvm);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index c4b908553726..e2c8823786ff 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -142,8 +142,9 @@ static int kvm_no_compat_open(struct inode *inode, struct file *file)
>  #define KVM_COMPAT(c)	.compat_ioctl	= kvm_no_compat_ioctl,	\
>  			.open		= kvm_no_compat_open
>  #endif
> -static int hardware_enable_all(void);
> -static void hardware_disable_all(void);
> +static void hardware_enable_nolock(void *junk);
> +static void hardware_disable_nolock(void *junk);
> +static void kvm_del_vm(void);

I think kvm_remove_vm() will be less confusing as "remove" is almost never used
to describe freeing something, whereas "delete" is somewhat interchangeable with
"free.  I.e. make it more obvious that the hook isn't intented to actually
delete/free a VM, rather it's there to remove/delete a VM from global tracking.

Ah, and this is especially true since the VM needs to be deleted from vm_list
before the is destroyed, but hardware needs to stay enabled until the VM is fully
destroyed.

Hmm, actually, I think even better would be to have kvm_remove_vm() and kvm_drop_vm()
to make it more obvious that there isn't 100% symmetry between "add" and "remove".

E.g. rename kvm_arch_pre_destroy_vm() => kvm_arch_remove_vm() and then we end up
with (see comments below for more details):

static int kvm_add_vm(struct kvm *kvm)
{
	/*
	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
	 * is called, i.e. on_each_cpu() includes CPUs that have not yet been
	 * onlined by KVM.  Disable CPU hotplug to prevent enabling hardware on
	 * a CPU that hasn't yet done compatibility checks.
	 */
	cpus_read_lock();
	mutex_lock(&kvm_lock);
	r = kvm_arch_add_vm(kvm, ++kvm_usage_count);
	if (r) {
		--kvm_usage_count;
		goto out;
	}
	
	list_add(&kvm->vm_list, &vm_list);

out:
	mutex_unlock(&kvm_lock);
	cpus_read_unlock();
}

static void kvm_remove_vm(struct kvm *kvm)
{
	mutex_lock(&kvm_lock);
	list_del(&kvm->vm_list);
	mutex_unlock(&kvm_lock);
	kvm_arch_remove_vm(kvm);
}

static void kvm_drop_vm(void)
{
	cpus_read_lock();
	mutex_lock(&kvm_lock);
	WARN_ON_ONCE(!kvm_usage_count);
	kvm_usage_count--;
	kvm_arch_drop_vm(kvm_usage_count);
	mutex_unlock(&kvm_lock);
	cpus_read_unlock();
}

> @@ -1223,13 +1255,28 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	if (r)
>  		goto out_err_no_debugfs;
>  
> -	r = kvm_arch_post_init_vm(kvm);
> -	if (r)
> -		goto out_err;
> -
> +	/*
> +	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
> +	 * is called. on_each_cpu() between them includes the CPU. As a result,
> +	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
> +	 * This would enable hardware virtualization on that cpu without
> +	 * compatibility checks, which can potentially crash system or break
> +	 * running VMs.
> +	 *
> +	 * Disable CPU hotplug to prevent this case from happening.
> +	 */
> +	cpus_read_lock();
>  	mutex_lock(&kvm_lock);
> +	kvm_usage_count++;
> +	r = kvm_arch_add_vm(kvm, kvm_usage_count);
> +	if (r) {
> +		/* the following kvm_del_vm() decrements kvm_usage_count. */

This is buggy on two fronts.  kvm_usage_count needs to be protected with kvm_lock,
and AFAICT cpus_read_unlock() isn't called.

Invoking kvm_del_vm() in the error path is the source of both bugs.  Typically,
the paired "undo" of an operation should only be used if the "do" operation was
fully successful.

As above, move this to a helper to make juggling the locks less painful.
