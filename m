Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3772EA2226
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfH2RYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:24:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfH2RYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 13:24:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 233791801586;
        Thu, 29 Aug 2019 17:24:15 +0000 (UTC)
Received: from amt.cnet (ovpn-112-12.gru2.redhat.com [10.97.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 622F5614DB;
        Thu, 29 Aug 2019 17:24:14 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id B4DF810514D;
        Thu, 29 Aug 2019 14:23:47 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x7THNhOf018913;
        Thu, 29 Aug 2019 14:23:43 -0300
Date:   Thu, 29 Aug 2019 14:23:43 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: Is: Default governor regardless of cpuidle driver Was: [PATCH
 v2] cpuidle-haltpoll: vcpu hotplug support
Message-ID: <20190829172343.GA18825@amt.cnet>
References: <20190829151027.9930-1-joao.m.martins@oracle.com>
 <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8cf8dcc-76a3-3e15-f514-2cb9df1bbbdc@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Thu, 29 Aug 2019 17:24:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 29, 2019 at 06:16:05PM +0100, Joao Martins wrote:
> On 8/29/19 4:10 PM, Joao Martins wrote:
> > When cpus != maxcpus cpuidle-haltpoll will fail to register all vcpus
> > past the online ones and thus fail to register the idle driver.
> > This is because cpuidle_add_sysfs() will return with -ENODEV as a
> > consequence from get_cpu_device() return no device for a non-existing
> > CPU.
> > 
> > Instead switch to cpuidle_register_driver() and manually register each
> > of the present cpus through cpuhp_setup_state() callback and future
> > ones that get onlined. This mimmics similar logic that intel_idle does.
> > 
> > Fixes: fa86ee90eb11 ("add cpuidle-haltpoll driver")
> > Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> > Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> > ---
> 
> While testing the above, I found out another issue on the haltpoll series.
> But I am not sure what is best suited to cpuidle framework, hence requesting
> some advise if below is a reasonable solution or something else is preferred.
> 
> Essentially after haltpoll governor got introduced and regardless of the cpuidle
> driver the default governor is gonna be haltpoll for a guest (given haltpoll
> governor doesn't get registered for baremetal).

Right.

> Right now, for a KVM guest, the
> idle governors have these ratings:
> 
>  * ladder            -> 10
>  * teo               -> 19
>  * menu              -> 20
>  * haltpoll          -> 21
>  * ladder + nohz=off -> 25

Yes. PowerPC KVM guests crash currently due to the use of the haltpoll
governor (have a patch in my queue to fix this, but your solution
embraces more cases).

> When a guest is booted with MWAIT and intel_idle is probed and sucessfully
> registered, we will end up with a haltpoll governor being used as opposed to
> 'menu' (which used to be the default case). This would prevent IIUC that other
> C-states get used other than poll_state (state 0) and state 1.
> 
> Given that haltpoll governor is largely only useful with a cpuidle-haltpoll
> it doesn't look reasonable to be the default? What about using haltpoll governor
> as default when haltpoll idle driver registers or modloads.
> 
> My idea to achieve the above would be to decrease the rating to 9 (before the
> lowest rated governor) and retain old defaults before haltpoll. Then we would
> allow a cpuidle driver to define a preferred governor to switch on idle driver
> registration. Naturally all of would be ignored if overidden by
> cpuidle.governor=.
> 
> The diff below the scissors line is an example of that.
> 
> Thoughts?

Works for me. Rafael?

> 
> ---------------------------------- >8 --------------------------------
> 
> From: Joao Martins <joao.m.martins@oracle.com>
> Subject: [PATCH] cpuidle: switch to prefered governor on registration
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/cpuidle/cpuidle-haltpoll.c   |  1 +
>  drivers/cpuidle/cpuidle.h            |  1 +
>  drivers/cpuidle/driver.c             | 26 ++++++++++++++++++++++++++
>  drivers/cpuidle/governor.c           |  6 +++---
>  drivers/cpuidle/governors/haltpoll.c |  2 +-
>  include/linux/cpuidle.h              |  3 +++
>  6 files changed, 35 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index 8baade23f8d0..88a38c3c35e4 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -33,6 +33,7 @@ static int default_enter_idle(struct cpuidle_device *dev,
> 
>  static struct cpuidle_driver haltpoll_driver = {
>  	.name = "haltpoll",
> +	.governor = "haltpoll",
>  	.owner = THIS_MODULE,
>  	.states = {
>  		{ /* entry 0 is for polling */ },
> diff --git a/drivers/cpuidle/cpuidle.h b/drivers/cpuidle/cpuidle.h
> index d6613101af92..c046f49c1920 100644
> --- a/drivers/cpuidle/cpuidle.h
> +++ b/drivers/cpuidle/cpuidle.h
> @@ -22,6 +22,7 @@ extern void cpuidle_install_idle_handler(void);
>  extern void cpuidle_uninstall_idle_handler(void);
> 
>  /* governors */
> +extern struct cpuidle_governor *cpuidle_find_governor(const char *str);
>  extern int cpuidle_switch_governor(struct cpuidle_governor *gov);
> 
>  /* sysfs */
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index dc32f34e68d9..8b8b9d89ce58 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -87,6 +87,7 @@ static inline int __cpuidle_set_driver(struct cpuidle_driver *drv)
>  #else
> 
>  static struct cpuidle_driver *cpuidle_curr_driver;
> +static struct cpuidle_governor *cpuidle_default_governor = NULL;
> 
>  /**
>   * __cpuidle_get_cpu_driver - return the global cpuidle driver pointer.
> @@ -254,12 +255,25 @@ static void __cpuidle_unregister_driver(struct
> cpuidle_driver *drv)
>   */
>  int cpuidle_register_driver(struct cpuidle_driver *drv)
>  {
> +	struct cpuidle_governor *gov;
>  	int ret;
> 
>  	spin_lock(&cpuidle_driver_lock);
>  	ret = __cpuidle_register_driver(drv);
>  	spin_unlock(&cpuidle_driver_lock);
> 
> +	if (!ret && !strlen(param_governor) && drv->governor &&
> +	    (cpuidle_get_driver() == drv)) {
> +		mutex_lock(&cpuidle_lock);
> +		gov = cpuidle_find_governor(drv->governor);
> +		if (gov) {
> +			cpuidle_default_governor = cpuidle_curr_governor;
> +			if (cpuidle_switch_governor(gov) < 0)
> +				cpuidle_default_governor = NULL;
> +		}
> +		mutex_unlock(&cpuidle_lock);
> +	}
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(cpuidle_register_driver);
> @@ -274,9 +288,21 @@ EXPORT_SYMBOL_GPL(cpuidle_register_driver);
>   */
>  void cpuidle_unregister_driver(struct cpuidle_driver *drv)
>  {
> +	bool enabled = (cpuidle_get_driver() == drv);
> +
>  	spin_lock(&cpuidle_driver_lock);
>  	__cpuidle_unregister_driver(drv);
>  	spin_unlock(&cpuidle_driver_lock);
> +
> +	if (!enabled)
> +		return;
> +
> +	mutex_lock(&cpuidle_lock);
> +	if (cpuidle_default_governor) {
> +		if (!cpuidle_switch_governor(cpuidle_default_governor))
> +			cpuidle_default_governor = NULL;
> +	}
> +	mutex_unlock(&cpuidle_lock);
>  }
>  EXPORT_SYMBOL_GPL(cpuidle_unregister_driver);
> 
> diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
> index 2e3e14192bee..e93c11dc8304 100644
> --- a/drivers/cpuidle/governor.c
> +++ b/drivers/cpuidle/governor.c
> @@ -22,12 +22,12 @@ LIST_HEAD(cpuidle_governors);
>  struct cpuidle_governor *cpuidle_curr_governor;
> 
>  /**
> - * __cpuidle_find_governor - finds a governor of the specified name
> + * cpuidle_find_governor - finds a governor of the specified name
>   * @str: the name
>   *
>   * Must be called with cpuidle_lock acquired.
>   */
> -static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
> +struct cpuidle_governor * cpuidle_find_governor(const char *str)
>  {
>  	struct cpuidle_governor *gov;
> 
> @@ -87,7 +87,7 @@ int cpuidle_register_governor(struct cpuidle_governor *gov)
>  		return -ENODEV;
> 
>  	mutex_lock(&cpuidle_lock);
> -	if (__cpuidle_find_governor(gov->name) == NULL) {
> +	if (cpuidle_find_governor(gov->name) == NULL) {
>  		ret = 0;
>  		list_add_tail(&gov->governor_list, &cpuidle_governors);
>  		if (!cpuidle_curr_governor ||
> diff --git a/drivers/cpuidle/governors/haltpoll.c
> b/drivers/cpuidle/governors/haltpoll.c
> index 797477bda486..7a703d2e0064 100644
> --- a/drivers/cpuidle/governors/haltpoll.c
> +++ b/drivers/cpuidle/governors/haltpoll.c
> @@ -133,7 +133,7 @@ static int haltpoll_enable_device(struct cpuidle_driver *drv,
> 
>  static struct cpuidle_governor haltpoll_governor = {
>  	.name =			"haltpoll",
> -	.rating =		21,
> +	.rating =		9,
>  	.enable =		haltpoll_enable_device,
>  	.select =		haltpoll_select,
>  	.reflect =		haltpoll_reflect,
> diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> index 1a9f54eb3aa1..2dc4c6b19c25 100644
> --- a/include/linux/cpuidle.h
> +++ b/include/linux/cpuidle.h
> @@ -121,6 +121,9 @@ struct cpuidle_driver {
> 
>  	/* the driver handles the cpus in cpumask */
>  	struct cpumask		*cpumask;
> +
> +	/* preferred governor to switch at register time */
> +	const char		*governor;
>  };
> 
>  #ifdef CONFIG_CPU_IDLE
> -- 
> 2.17.1
