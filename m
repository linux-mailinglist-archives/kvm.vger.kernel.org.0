Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF72464BA6
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 11:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348679AbhLAKeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 05:34:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:39768 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242645AbhLAKeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 05:34:19 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1638354658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnXHfeRjYzgiU31SDjl1jzVKkbGQLh9nARnHcLVI+rI=;
        b=CnRmguo0gGy7pOJjYxajl1AxOvJHtI6Q4IhGR0fZ2/Gayg+wWKf7CAdfX6U0hRjbGgGV0k
        elMLYJGVX6mwK442xHTg/WtlLNJYj0I/p0sJcz/qwMHzoH2cQmuM/9CM0dXb4DvDuzRfML
        YGrovZ+JftlpMhFDTbPF0RqoRDBEb23sW1YGmYPT5oe2riDXaFpiwbaG7bsUMeofg1L5cV
        pPJxACH+zl23lHOUXsDYCtWcEp6E6+eyP7Th+fzF0rZM7XVjR7Bh2SBIR8UukCegrh5ZEC
        aWEVSmTQOset3GpVz4wnOebEmiZt7a1JrsSQ+EdINl4foEyC6kWwRveO8NPPAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1638354658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EnXHfeRjYzgiU31SDjl1jzVKkbGQLh9nARnHcLVI+rI=;
        b=j+9FDO+7WkftcDSiv+jKQXuxp5+K/8i5Jr1bDpaUlQ7cYJ20qKd2fxiLBLWukiRSZcmbs5
        pg6Mjr62QGOdyBCw==
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>
Subject: RE: Q. about KVM and CPU hotplug
In-Reply-To: <BN9PR11MB54333C976289C4AA42D7B1AA8C689@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BL1PR11MB54295ADE4D7A81523EA50B2D8C679@BL1PR11MB5429.namprd11.prod.outlook.com>
 <3d3296f0-9245-40f9-1b5a-efffdb082de9@redhat.com>
 <BN9PR11MB54333C976289C4AA42D7B1AA8C689@BN9PR11MB5433.namprd11.prod.outlook.com>
Date:   Wed, 01 Dec 2021 11:30:57 +0100
Message-ID: <87bl20aa72.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 01 2021 at 06:59, Kevin Tian wrote:
>> From: Paolo Bonzini <paolo.bonzini@gmail.com>
>> It should fail the first vmptrld instruction.  It will result in a few
>> WARN_ONCE and pr_warn_ratelimited (see vmx_insn_failed).  For VMX this
>> should be a pretty bad firmware bug, and it has never been reported.
>> KVM did find some undocumented errata but not this one!
>> 
>
> or it may be caused by incompatible CPU capabilities, which is currently
> missing a check in kvm_starting_cpu(). So far the compatibility check is
> done only once before registering cpu hotplug state machine:
>
>         for_each_online_cpu(cpu) {
>                 smp_call_function_single(cpu, check_processor_compat, &c, 1);
>                 if (r < 0)
>                         goto out_free_2;
>         }
>
>         r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
>                                       kvm_starting_cpu, kvm_dying_cpu);

Duh. This is silly _and_ broken.

Using for_each_inline_cpu() without holding cpus_read_lock() is racy
against concurrent hotplug. But even if the locking is added then
nothing prevents a CPU from being plugged _after_ the lock is dropped.

The right solution is to move the hotplug state into the threaded
section as I pointed out and do:

         r = cpuhp_setup_state(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
                               kvm_starting_cpu, kvm_dying_cpu);

which will do the right thing automatically. Checking for compatibility
would just be part of the kvm_starting_cpu() callback.

Thanks,

        tglx
