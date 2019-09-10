Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B056FAEF67
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 18:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394173AbfIJQSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 12:18:45 -0400
Received: from 2.mo5.mail-out.ovh.net ([178.33.109.111]:60144 "EHLO
        2.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729971AbfIJQSo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 12:18:44 -0400
X-Greylist: delayed 7799 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2019 12:18:43 EDT
Received: from player789.ha.ovh.net (unknown [10.109.146.1])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 794BF24BDA5
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2019 15:49:31 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: clg@kaod.org)
        by player789.ha.ovh.net (Postfix) with ESMTPSA id AD28C99B6E00;
        Tue, 10 Sep 2019 13:49:24 +0000 (UTC)
Subject: Re: [PATCH 2/2] KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when
 VPs are allocated
To:     Greg Kurz <groug@kaod.org>, Paul Mackerras <paulus@ozlabs.org>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
References: <156812303847.1865227.3495698285729698782.stgit@bahia.tls.ibm.com>
 <156812304395.1865227.18344810689034056117.stgit@bahia.tls.ibm.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <6712150c-5d55-8e36-28ae-bf078a405ea6@kaod.org>
Date:   Tue, 10 Sep 2019 15:49:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156812304395.1865227.18344810689034056117.stgit@bahia.tls.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12243880013991938951
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrtddtgdegiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/09/2019 15:44, Greg Kurz wrote:
> If we cannot allocate the XIVE VPs in OPAL, the creation of a XIVE or
> XICS-on-XIVE device is aborted as expected, but we leave kvm->arch.xive
> set forever since the relase method isn't called in this case. Any
> subsequent tentative to create a XIVE or XICS-on-XIVE for this VM will
> thus always fail. This is a problem for QEMU since it destroys and
> re-creates these devices when the VM is reset: the VM would be
> restricted to using the emulated XIVE or XICS forever.
> 
> As an alternative to adding rollback, do not assign kvm->arch.xive before
> making sure the XIVE VPs are allocated in OPAL.
> 
> Fixes: 5422e95103cf ("KVM: PPC: Book3S HV: XIVE: Replace the 'destroy' method by a 'release' method")
> Signed-off-by: Greg Kurz <groug@kaod.org>


Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>  arch/powerpc/kvm/book3s_xive.c        |   11 +++++------
>  arch/powerpc/kvm/book3s_xive_native.c |    2 +-
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive.c b/arch/powerpc/kvm/book3s_xive.c
> index cd2006bfcd3e..2ef43d037a4f 100644
> --- a/arch/powerpc/kvm/book3s_xive.c
> +++ b/arch/powerpc/kvm/book3s_xive.c
> @@ -2006,6 +2006,10 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>  
>  	pr_devel("Creating xive for partition\n");
>  
> +	/* Already there ? */
> +	if (kvm->arch.xive)
> +		return -EEXIST;
> +
>  	xive = kvmppc_xive_get_device(kvm, type);
>  	if (!xive)
>  		return -ENOMEM;
> @@ -2014,12 +2018,6 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>  	xive->kvm = kvm;
>  	mutex_init(&xive->lock);
>  
> -	/* Already there ? */
> -	if (kvm->arch.xive)
> -		ret = -EEXIST;
> -	else
> -		kvm->arch.xive = xive;
> -
>  	/* We use the default queue size set by the host */
>  	xive->q_order = xive_native_default_eq_shift();
>  	if (xive->q_order < PAGE_SHIFT)
> @@ -2040,6 +2038,7 @@ static int kvmppc_xive_create(struct kvm_device *dev, u32 type)
>  		return ret;
>  
>  	dev->private = xive;
> +	kvm->arch.xive = xive;
>  	return 0;
>  }
>  
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index e9cbb42de424..84a354b90f60 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -1087,7 +1087,6 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
>  
>  	xive->dev = dev;
>  	xive->kvm = kvm;
> -	kvm->arch.xive = xive;
>  	mutex_init(&xive->mapping_lock);
>  	mutex_init(&xive->lock);
>  
> @@ -1109,6 +1108,7 @@ static int kvmppc_xive_native_create(struct kvm_device *dev, u32 type)
>  		return ret;
>  
>  	dev->private = xive;
> +	kvm->arch.xive = xive;
>  	return 0;
>  }
>  
> 

