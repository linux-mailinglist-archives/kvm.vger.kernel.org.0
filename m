Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B77A20D9
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfH2Q0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 12:26:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:51194 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726973AbfH2Q0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 12:26:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C48A8AB9B;
        Thu, 29 Aug 2019 16:26:47 +0000 (UTC)
Date:   Thu, 29 Aug 2019 18:26:41 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/11] KVM: x86: Introduce KVM_GET_PAGE_ENC_BITMAP
 ioctl
Message-ID: <20190829162641.GB2132@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-10-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-10-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:10PM +0000, Singh, Brijesh wrote:
> @@ -7767,7 +7808,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
>  
>  	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
>  
> -	.page_enc_status_hc = svm_page_enc_status_hc
> +	.page_enc_status_hc = svm_page_enc_status_hc,
> +	.get_page_enc_bitmap = svm_get_page_enc_bitmap
>  };
>  
>  static int __init svm_init(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6baf48ec0ed4..59ae49b1b914 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4927,6 +4927,18 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  		r = kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
>  		break;
>  	}
> +	case KVM_GET_PAGE_ENC_BITMAP: {
> +		struct kvm_page_enc_bitmap bitmap;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&bitmap, argp, sizeof(bitmap)))
> +			goto out;
> +
> +		r = -ENOTTY;
> +		if (kvm_x86_ops->get_page_enc_bitmap)
> +			r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);

I don't know what tree you've done those patches against but against -rc6+, the
first argument above needs to be vcpu->kvm:

arch/x86/kvm/x86.c: In function ‘kvm_arch_vcpu_ioctl’:
arch/x86/kvm/x86.c:4343:41: error: ‘kvm’ undeclared (first use in this function)
    r = kvm_x86_ops->get_page_enc_bitmap(kvm, &bitmap);
                                         ^~~
arch/x86/kvm/x86.c:4343:41: note: each undeclared identifier is reported only once for each function it appears in
make[2]: *** [scripts/Makefile.build:280: arch/x86/kvm/x86.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [scripts/Makefile.build:497: arch/x86/kvm] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:1083: arch/x86] Error 2
make: *** Waiting for unfinished jobs....

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
