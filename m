Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E69724DFF
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 22:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbjFFU0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 16:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238484AbjFFU0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 16:26:15 -0400
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46532E5B;
        Tue,  6 Jun 2023 13:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686083174; x=1717619174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v1GnwDotzgDvCEpzlZKh4p4TBu2ATvhr3nGE68dLeoo=;
  b=paFie8CHAlrxv3FQ5M+vHccY6qYPMv/s9UuFUhl5EBr5hCga5zGJbKyb
   xFxC0oOLD3UwxldolqgxbxFqrAUlY1OvpJk0jYn+Uu4Ii4FAy81p6yKDE
   Z6rPnKaZ8YsnJt4jQr48ozEL7geojwCja0o85lohaPT0ljs76+0WSj6UA
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,221,1681171200"; 
   d="scan'208";a="585996238"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 20:26:11 +0000
Received: from EX19MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-153b24bc.us-east-1.amazon.com (Postfix) with ESMTPS id DA565C3B8B;
        Tue,  6 Jun 2023 20:26:08 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com (10.250.64.204) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 6 Jun 2023 20:26:08 +0000
Received: from dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com (10.39.210.33)
 by mail-relay.amazon.com (10.250.64.204) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 6 Jun 2023 20:26:08 +0000
Received: by dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com (Postfix, from userid 23276196)
        id E63A223; Tue,  6 Jun 2023 20:26:07 +0000 (UTC)
Date:   Tue, 6 Jun 2023 20:26:07 +0000
From:   Luiz Capitulino <luizcap@amazon.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Li RongQing <lirongqing@baidu.com>,
        Yong He <zhuangel570@gmail.com>,
        Robert Hoo <robert.hoo.linux@gmail.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Add "never" option to allow sticky
 disabling of nx_huge_pages
Message-ID: <20230606202557.GA71782@dev-dsk-luizcap-1d-37beaf15.us-east-1.amazon.com>
References: <20230602005859.784190-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230602005859.784190-1-seanjc@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 05:58:59PM -0700, Sean Christopherson wrote:
> Add a "never" option to the nx_huge_pages module param to allow userspace
> to do a one-way hard disabling of the mitigation, and don't create the
> per-VM recovery threads when the mitigation is hard disabled.  Letting
> userspace pinky swear that userspace doesn't want to enable NX mitigation
> (without reloading KVM) allows certain use cases to avoid the latency
> problems associated with spawning a kthread for each VM.
> 
> E.g. in FaaS use cases, the guest kernel is trusted and the host may
> create 100+ VMs per logical CPU, which can result in 100ms+ latencies when
> a burst of VMs is created.

Tested-by: Luiz Capitulino <luizcap@amazon.com>

Without this patch I can see the 100ms+ latencies on KVM_CREATE_VM even
with a single VM.

Just run a VM with with strace -T and grep for KVM_CREATE_VM. When using
kvmtool I get (latency in seconds - kernel HEAD is a4d7d70112):

  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.023567>
  
  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.076709>
  
  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.109109>

With this patch and nx_huge_page=never:

  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.000518>
  
  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.000495>
  
  ioctl(3, KVM_CREATE_VM, 0)              = 4 <0.000513>

Now, I debugged down the single VM case before seeing this patch and it
can be avoided by building the kernel with CONFIG_CGROUP_FAVOR_DYNMODS=y
or mounting the cgroup v2 mount point with the favordynmods mount option.

This is because the high latency is coming from a call to
cgroup_attach_task_all() in:

kvm_vm_worker_thread()
  cgroup_attach_task_all()
    percpu_down_write(&cgroup_threadgroup_rwsem)
      /* calls synchronize_rcu() */

This happens while kvm_vm_create_worker_thread() is waiting on a completion.
See commit 6a010a49b63a for more information.

This patch is preferable because the favordynmods solution has a trade-off.
However, why don't we make nx_huge_pages=never the default behavior if the
CPU is not vulnerable? If there are concerns about not being able to restart
the worker thread, then maybe we could make this a .config option?

- Luiz


> 
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Closes: https://lore.kernel.org/all/1679555884-32544-1-git-send-email-lirongqing@baidu.com
> Cc: Yong He <zhuangel570@gmail.com>
> Cc: Robert Hoo <robert.hoo.linux@gmail.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 41 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c8961f45e3b1..2ed38916b904 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -58,6 +58,8 @@
>  
>  extern bool itlb_multihit_kvm_mitigation;
>  
> +static bool nx_hugepage_mitigation_hard_disabled;
> +
>  int __read_mostly nx_huge_pages = -1;
>  static uint __read_mostly nx_huge_pages_recovery_period_ms;
>  #ifdef CONFIG_PREEMPT_RT
> @@ -67,12 +69,13 @@ static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
>  static uint __read_mostly nx_huge_pages_recovery_ratio = 60;
>  #endif
>  
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp);
>  static int set_nx_huge_pages(const char *val, const struct kernel_param *kp);
>  static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel_param *kp);
>  
>  static const struct kernel_param_ops nx_huge_pages_ops = {
>  	.set = set_nx_huge_pages,
> -	.get = param_get_bool,
> +	.get = get_nx_huge_pages,
>  };
>  
>  static const struct kernel_param_ops nx_huge_pages_recovery_param_ops = {
> @@ -6844,6 +6847,14 @@ static void mmu_destroy_caches(void)
>  	kmem_cache_destroy(mmu_page_header_cache);
>  }
>  
> +static int get_nx_huge_pages(char *buffer, const struct kernel_param *kp)
> +{
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return sprintf(buffer, "never\n");
> +
> +	return param_get_bool(buffer, kp);
> +}
> +
>  static bool get_nx_auto_mode(void)
>  {
>  	/* Return true when CPU has the bug, and mitigations are ON */
> @@ -6860,15 +6871,29 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
>  	bool old_val = nx_huge_pages;
>  	bool new_val;
>  
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return -EPERM;
> +
>  	/* In "auto" mode deploy workaround only if CPU has the bug. */
> -	if (sysfs_streq(val, "off"))
> +	if (sysfs_streq(val, "off")) {
>  		new_val = 0;
> -	else if (sysfs_streq(val, "force"))
> +	} else if (sysfs_streq(val, "force")) {
>  		new_val = 1;
> -	else if (sysfs_streq(val, "auto"))
> +	} else if (sysfs_streq(val, "auto")) {
>  		new_val = get_nx_auto_mode();
> -	else if (kstrtobool(val, &new_val) < 0)
> +	} else if (sysfs_streq(val, "never")) {
> +		new_val = 0;
> +
> +		mutex_lock(&kvm_lock);
> +		if (!list_empty(&vm_list)) {
> +			mutex_unlock(&kvm_lock);
> +			return -EBUSY;
> +		}
> +		nx_hugepage_mitigation_hard_disabled = true;
> +		mutex_unlock(&kvm_lock);
> +	} else if (kstrtobool(val, &new_val) < 0) {
>  		return -EINVAL;
> +	}
>  
>  	__set_nx_huge_pages(new_val);
>  
> @@ -7006,6 +7031,9 @@ static int set_nx_huge_pages_recovery_param(const char *val, const struct kernel
>  	uint old_period, new_period;
>  	int err;
>  
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return -EPERM;
> +
>  	was_recovery_enabled = calc_nx_huge_pages_recovery_period(&old_period);
>  
>  	err = param_set_uint(val, kp);
> @@ -7161,6 +7189,9 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
>  {
>  	int err;
>  
> +	if (nx_hugepage_mitigation_hard_disabled)
> +		return 0;
> +
>  	err = kvm_vm_create_worker_thread(kvm, kvm_nx_huge_page_recovery_worker, 0,
>  					  "kvm-nx-lpage-recovery",
>  					  &kvm->arch.nx_huge_page_recovery_thread);
> 
> base-commit: 39428f6ea9eace95011681628717062ff7f5eb5f
> -- 
> 2.41.0.rc2.161.g9c6817b8e7-goog
> 
