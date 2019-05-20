Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869DE232D2
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 13:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730632AbfETLm2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 20 May 2019 07:42:28 -0400
Received: from 2.mo7.mail-out.ovh.net ([87.98.143.68]:53003 "EHLO
        2.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfETLm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 07:42:27 -0400
X-Greylist: delayed 10798 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 07:42:26 EDT
Received: from player687.ha.ovh.net (unknown [10.108.57.53])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 8B90E11D237
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 10:07:01 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player687.ha.ovh.net (Postfix) with ESMTPSA id A90C15E5B499;
        Mon, 20 May 2019 08:06:55 +0000 (UTC)
Date:   Mon, 20 May 2019 10:06:54 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     kvm-ppc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] KVM: PPC: Book3S HV: XIVE: do not test the EQ flag
 validity when resetting
Message-ID: <20190520100654.4da6574a@bahia.lan>
In-Reply-To: <20190520071514.9308-3-clg@kaod.org>
References: <20190520071514.9308-1-clg@kaod.org>
        <20190520071514.9308-3-clg@kaod.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 6927943605061785995
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtkecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 09:15:13 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> When a CPU is hot-unplugged, the EQ is deconfigured using a zero size
> and a zero address. In this case, there is no need to check the flag
> and queue size validity. Move the checks after the queue reset code
> section to fix CPU hot-unplug.
> 
> Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Tested-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  arch/powerpc/kvm/book3s_xive_native.c | 36 +++++++++++++--------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 796d86549cfe..3fdea6bf4e97 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -565,24 +565,6 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
>  		 __func__, server, priority, kvm_eq.flags,
>  		 kvm_eq.qshift, kvm_eq.qaddr, kvm_eq.qtoggle, kvm_eq.qindex);
>  
> -	/*
> -	 * sPAPR specifies a "Unconditional Notify (n) flag" for the
> -	 * H_INT_SET_QUEUE_CONFIG hcall which forces notification
> -	 * without using the coalescing mechanisms provided by the
> -	 * XIVE END ESBs. This is required on KVM as notification
> -	 * using the END ESBs is not supported.
> -	 */
> -	if (kvm_eq.flags != KVM_XIVE_EQ_ALWAYS_NOTIFY) {
> -		pr_err("invalid flags %d\n", kvm_eq.flags);
> -		return -EINVAL;
> -	}
> -
> -	rc = xive_native_validate_queue_size(kvm_eq.qshift);
> -	if (rc) {
> -		pr_err("invalid queue size %d\n", kvm_eq.qshift);
> -		return rc;
> -	}
> -
>  	/* reset queue and disable queueing */
>  	if (!kvm_eq.qshift) {
>  		q->guest_qaddr  = 0;
> @@ -604,6 +586,24 @@ static int kvmppc_xive_native_set_queue_config(struct kvmppc_xive *xive,
>  		return 0;
>  	}
>  
> +	/*
> +	 * sPAPR specifies a "Unconditional Notify (n) flag" for the
> +	 * H_INT_SET_QUEUE_CONFIG hcall which forces notification
> +	 * without using the coalescing mechanisms provided by the
> +	 * XIVE END ESBs. This is required on KVM as notification
> +	 * using the END ESBs is not supported.
> +	 */
> +	if (kvm_eq.flags != KVM_XIVE_EQ_ALWAYS_NOTIFY) {
> +		pr_err("invalid flags %d\n", kvm_eq.flags);
> +		return -EINVAL;
> +	}
> +
> +	rc = xive_native_validate_queue_size(kvm_eq.qshift);
> +	if (rc) {
> +		pr_err("invalid queue size %d\n", kvm_eq.qshift);
> +		return rc;
> +	}
> +
>  	if (kvm_eq.qaddr & ((1ull << kvm_eq.qshift) - 1)) {
>  		pr_err("queue page is not aligned %llx/%llx\n", kvm_eq.qaddr,
>  		       1ull << kvm_eq.qshift);

