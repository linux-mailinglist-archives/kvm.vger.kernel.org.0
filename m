Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35408DE619
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 10:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfJUIRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 04:17:11 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33647 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727650AbfJUIRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 04:17:11 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iMSrp-0004FX-Ek; Mon, 21 Oct 2019 10:16:41 +0200
Date:   Mon, 21 Oct 2019 10:16:40 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miaohe Lin <linmiaohe@huawei.com>
cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: remove redundant code in kvm_arch_vm_ioctl
In-Reply-To: <1571626376-11357-1-git-send-email-linmiaohe@huawei.com>
Message-ID: <alpine.DEB.2.21.1910211015260.1904@nanos.tec.linutronix.de>
References: <1571626376-11357-1-git-send-email-linmiaohe@huawei.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Oct 2019, Miaohe Lin wrote:
> If we reach here with r = 0, we will reassign r = 0
> unnecesarry, then do the label set_irqchip_out work.
> If we reach here with r != 0, then we will do the label
> work directly. So this if statement and r = 0 assignment
> is redundant.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 661e2bf38526..0b3ebc2afb3d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4916,9 +4916,6 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		if (!irqchip_kernel(kvm))
>  			goto set_irqchip_out;
>  		r = kvm_vm_ioctl_set_irqchip(kvm, chip);
> -		if (r)
> -			goto set_irqchip_out;
> -		r = 0;
>  	set_irqchip_out:
>  		kfree(chip);
>  		break;

Can you please get rid of that odd jump label completely?

  		if (irqchip_kernel(kvm))
			r = kvm_vm_ioctl_set_irqchip(kvm, chip);

Hmm?


Thanks,

	tglx
