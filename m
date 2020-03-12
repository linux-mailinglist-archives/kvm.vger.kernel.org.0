Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09F5183640
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 17:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCLQgM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 12:36:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49230 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726099AbgCLQgL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 12:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584030970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y+zp8ckYFu/JE3Ap00+bCw6jAqD/T1e+8NMqLw5Uqes=;
        b=Hgih+I1unlcJAEbFwEkIu3/2X0d7meGLWWODaoM1Ih6dlmKB2yMY2QUQrHgZggK3O7aPEZ
        BxtMwzxoQtzw346ou6bCc3QrxWmcNncEJ8mcU+gAoQvqhonnhJM/3+L1oLzsxF3cHP7HAH
        sEJAMeaRWXPKOxOCWl/ct3w1TyRHFr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-UwYhNdmiPAqUzi-XPWcEPg-1; Thu, 12 Mar 2020 12:36:06 -0400
X-MC-Unique: UwYhNdmiPAqUzi-XPWcEPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90D63DBA3;
        Thu, 12 Mar 2020 16:36:04 +0000 (UTC)
Received: from fuller.cnet (ovpn-116-59.gru2.redhat.com [10.97.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38D6D19C6A;
        Thu, 12 Mar 2020 16:36:04 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id CEDAF418CC02; Thu, 12 Mar 2020 13:17:51 -0300 (-03)
Date:   Thu, 12 Mar 2020 13:17:51 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] cpuidle-haltpoll: allow force loading on hosts
 without the REALTIME hint
Message-ID: <20200312161751.GA5245@fuller.cnet>
References: <20200304113248.1143057-1-mail@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304113248.1143057-1-mail@maciej.szmigiero.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 04, 2020 at 12:32:48PM +0100, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
> when dedicated physical CPUs are available") the cpuidle-haltpoll driver
> could also be used in scenarios when the host does not advertise the
> KVM_HINTS_REALTIME hint.
> 
> While the behavior introduced by the aforementioned commit makes sense as
> the default there are cases where the old behavior is desired, for example,
> when other kernel changes triggered by presence by this hint are unwanted,
> for some workloads where the latency benefit from polling overweights the
> loss from idle CPU capacity that otherwise would be available, or just when
> running under older Qemu versions that lack this hint.
> 
> Let's provide a typical "force" module parameter that allows restoring the
> old behavior.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---
>  drivers/cpuidle/cpuidle-haltpoll.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> Changes from v1:
> Make the module parameter description more general, don't unnecessarily
> break a line in haltpoll_init().
> 
> diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
> index b0ce9bc78113..db124bc1ca2c 100644
> --- a/drivers/cpuidle/cpuidle-haltpoll.c
> +++ b/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -18,6 +18,10 @@
>  #include <linux/kvm_para.h>
>  #include <linux/cpuidle_haltpoll.h>
>  
> +static bool force __read_mostly;
> +module_param(force, bool, 0444);
> +MODULE_PARM_DESC(force, "Load unconditionally");
> +
>  static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
>  static enum cpuhp_state haltpoll_hp_state;
>  
> @@ -90,6 +94,11 @@ static void haltpoll_uninit(void)
>  	haltpoll_cpuidle_devices = NULL;
>  }
>  
> +static bool haltpool_want(void)
> +{
> +	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
> +}
> +
>  static int __init haltpoll_init(void)
>  {
>  	int ret;
> @@ -101,8 +110,7 @@ static int __init haltpoll_init(void)
>  
>  	cpuidle_poll_state_init(drv);
>  
> -	if (!kvm_para_available() ||
> -		!kvm_para_has_hint(KVM_HINTS_REALTIME))
> +	if (!kvm_para_available() || !haltpool_want())
>  		return -ENODEV;
>  
>  	ret = cpuidle_register_driver(drv);

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

