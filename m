Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85512E20D
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 18:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfE2QMT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 29 May 2019 12:12:19 -0400
Received: from 14.mo7.mail-out.ovh.net ([178.33.251.19]:41831 "EHLO
        14.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfE2QMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 12:12:19 -0400
Received: from player787.ha.ovh.net (unknown [10.109.160.232])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id A1C9311F4B9
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 11:07:05 +0200 (CEST)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player787.ha.ovh.net (Postfix) with ESMTPSA id C360F663451E;
        Wed, 29 May 2019 09:06:58 +0000 (UTC)
Date:   Wed, 29 May 2019 11:06:57 +0200
From:   Greg Kurz <groug@kaod.org>
To:     =?UTF-8?B?Q8OpZHJpYw==?= Le Goater <clg@kaod.org>
Cc:     Paul Mackerras <paulus@samba.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: XIVE: fix page offset when
 clearing ESB pages
Message-ID: <20190529110657.2dbd1d72@bahia.lab.toulouse-stg.fr.ibm.com>
In-Reply-To: <20190528211324.18656-1-clg@kaod.org>
References: <20190528211324.18656-1-clg@kaod.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 5456392424164596107
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgudefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 May 2019 23:13:24 +0200
Cédric Le Goater <clg@kaod.org> wrote:

> Under XIVE, the ESB pages of an interrupt are used for interrupt
> management (EOI) and triggering. They are made available to guests
> through a mapping of the XIVE KVM device.
> 
> When a device is passed-through, the passthru_irq helpers,
> kvmppc_xive_set_mapped() and kvmppc_xive_clr_mapped(), clear the ESB
> pages of the guest IRQ number being mapped and let the VM fault
> handler repopulate with the correct page.
> 
> The ESB pages are mapped at offset 4 (KVM_XIVE_ESB_PAGE_OFFSET) in the
> KVM device mapping. Unfortunately, this offset was not taken into
> account when clearing the pages. This lead to issues with the

Good catch ! :)

Reviwed-by: Greg Kurz <groug@kaod.org>

> passthrough devices for which the interrupts were not functional under
> some guest configuration (tg3 and single CPU) or in any configuration

And this patch fixes my tg3 use case.

Tested-by: Greg Kurz <groug@kaod.org>

> (e1000e adapter).
> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
> 
>  if unmap_mapping_pages() could be called from a module, we would
>  simplify a bit this code.
> 
>  arch/powerpc/kvm/book3s_xive_native.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index 8b762e3ebbc5..5596c8ec221a 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -172,6 +172,7 @@ int kvmppc_xive_native_connect_vcpu(struct kvm_device *dev,
>  static int kvmppc_xive_native_reset_mapped(struct kvm *kvm, unsigned long irq)
>  {
>  	struct kvmppc_xive *xive = kvm->arch.xive;
> +	pgoff_t esb_pgoff = KVM_XIVE_ESB_PAGE_OFFSET + irq * 2;
>  
>  	if (irq >= KVMPPC_XIVE_NR_IRQS)
>  		return -EINVAL;
> @@ -185,7 +186,7 @@ static int kvmppc_xive_native_reset_mapped(struct kvm *kvm, unsigned long irq)
>  	mutex_lock(&xive->mapping_lock);
>  	if (xive->mapping)
>  		unmap_mapping_range(xive->mapping,
> -				    irq * (2ull << PAGE_SHIFT),
> +				    esb_pgoff << PAGE_SHIFT,
>  				    2ull << PAGE_SHIFT, 1);
>  	mutex_unlock(&xive->mapping_lock);
>  	return 0;

