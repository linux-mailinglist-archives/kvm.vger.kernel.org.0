Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EE74838B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 15:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfFQNIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 09:08:31 -0400
Received: from mout.web.de ([212.227.15.4]:45461 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbfFQNIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 09:08:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1560776879;
        bh=vfn58es81n7XGZrHY0+hUK8izBvcfr24PCk69RLrm7s=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EhqtsOKWbe7oeeJ3A0ua20KEJVi2v9mkZd1hapYJf5gbBfS3YjZJhaS81ub2A0u2H
         ipyGUitdP6of/iuTXMX+WnNnkp+pAepFPk/bn1uVVutLcU4s08x5EzAq0szQn0Udh+
         QfOX2k8CbKtFzbdeatTfNvLPaXre1Pw0ZB+r11ls=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.33] ([85.71.157.74]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LocJe-1iHxkD1L5O-00gXSR; Mon, 17
 Jun 2019 15:07:59 +0200
Subject: Re: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's
 32-bit NPT
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190613172223.17119-1-sean.j.christopherson@intel.com>
From:   Jiri Palecek <jpalecek@web.de>
Message-ID: <69c08ce8-06c9-fd06-6fb7-aa254ece8ddc@web.de>
Date:   Mon, 17 Jun 2019 15:07:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190613172223.17119-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:QqXn9IGKAX+Unl9lGzZJE7vBXyWn9QbPrWeUGi6lCtBqvM/G0wi
 wXMogqVdi9yGpG2yikjNFGfYlbWsFXgSVpehXdnbzJKr0jp2EhIuDv5RqGaWA1XFFEUolkq
 aXE8Du04SnjAFikVLHIu7t7rp1JDJfDiFpbeO6eYfgJHdYstEO3t8I80v4wlylgNwFI26ZU
 1H37QwrinUwVMOzRr4p1w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:w009yvFDHnU=:l3owdwhS/bW+U600IBzlUd
 KACBZUSjCMcJgh4bLb5cOuISW6awn8XttBwdkWf7fWvS9+yaz46VcuHVQ7yCOWwTU038AJBWu
 JH8/IO1bUhVh68L2G8dSLbrCifZsleO7bG8Jx+Vcl5ji6zyzkCzPrQ62YNL5QkSd5PU0SLdlP
 OblWFATm/4syrCDzQVrXY7ZnyhZYEyG/ehG6sLnZ5GTc4IKejtZNYVo7U4eCApSDC/wdp6C7W
 d2fqPwzwDGlX/YPxRkMTzltW//8Up+QOHJGCpIFfDBV5mD/tp9Ligb7+kkdVwAQif3MlYIY2P
 NffaMUjg6xczvYMh09vmh9l35x2mQdLn/lRX54t4WLhyVux8cGREFERpGXIPAmdFcfNiLSWaj
 ahwAYSqMDUG50ob7X22b37/pGQf7TchEvMxGDNTNAqrlrcrI0ux8MEk7agWGfGSaGQQ3oSrQX
 oA1Ks/2lOa/Sl9wFiqlurABBw9Auimi2b1clrf+oVPoYRpTVZPEHiXUGcSGbpS7ZViYBEuMze
 8bpo04L0fZeV2j+eswd1i2Fr+fIg9Vh5k8S2i+SFTJU3DFqznHOWILRcNQMVArf80fzujryJm
 7eeOSdodxzV0KKa6aoejD0vQPzz7RlxZZ+J5EhTfq34ND0Kk3jiR0h+anevGpyp1NgzCs//v/
 reL+9Z/UzczH6BawFCaHliZzM2A+N5cKG7StA2Qe3lZm2UADk9iiSFyPSltfujcGyRWShRsRu
 aD6jhwpZ+r8m0AVLxyMhYhsgAhBtoY2LEOJLxi1scIETEhVt+MBPv1Ppo28L1YQ8cXoQDa0jr
 UVTk92ozuNlxol0nnBswXyNR8mIW1qXvxuoRkYgc0aAfpF0DqIZkBUfnYfMyq8zrvgEKWk4gO
 o4C8iZrEQKoSMhUNKbmjzD87Vfa/960AP0g0LbQsWvQJ1cMElvMkd3G4UlY/30iX2fJin0Fgt
 +rYVEE/EvvltdmVtkSoyZN5v7bURR+fZOcgvgmjUhqQFhCcaE7Bhd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 13. 06. 19 19:22, Sean Christopherson wrote:
> SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
> page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
> is enabled, i.e. the PAE root array needs to be allocated.
>
> Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp e=
nabled")
> Cc: stable@vger.kernel.org
> Reported-by: Jiri Palecek <jpalecek@web.de>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>
> Jiri, can you please test this patch?  I haven't actually verified this
> fixes the bug due to lack of SVM hardware.

Yes, it makes KVM work again on i686 pae and nopae with kernel 5.2-rc4.
However, I also tried, just out of curiosity, a nested kvm setup and got
a kvm_spurious_fault in L1 every time. I'll probably file another bug
for that.

Thanks for your involvement

 =C2=A0=C2=A0=C2=A0 Jiri Palecek


>
>   arch/x86/kvm/mmu.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 1e9ba81accba..d3c3d5e5ffd4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -5602,14 +5602,18 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu=
)
>   	struct page *page;
>   	int i;
>
> -	if (tdp_enabled)
> -		return 0;
> -
>   	/*
> -	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
> -	 * Therefore we need to allocate shadow page tables in the first
> -	 * 4GB of memory, which happens to fit the DMA32 zone.
> +	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
> +	 * while the PDP table is a per-vCPU construct that's allocated at MMU
> +	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
> +	 * x86_64.  Therefore we need to allocate the PDP table in the first
> +	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
> +	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
> +	 * skip allocating the PDP table.
>   	 */
> +	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL=
)
> +		return 0;
> +
>   	page =3D alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
>   	if (!page)
>   		return -ENOMEM;
