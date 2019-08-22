Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBC79990E2
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732245AbfHVK3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:29:55 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5192 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730309AbfHVK3z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:29:55 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B334BCD1D3E5D29EB50F;
        Thu, 22 Aug 2019 18:29:50 +0800 (CST)
Received: from localhost (10.202.226.61) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 18:29:44 +0800
Date:   Thu, 22 Aug 2019 11:29:30 +0100
From:   Jonathan Cameron <jonathan.cameron@huawei.com>
To:     Steven Price <steven.price@arm.com>
CC:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>,
        "Mark Rutland" <mark.rutland@arm.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Suzuki K Pouloze" <suzuki.poulose@arm.com>,
        <linux-doc@vger.kernel.org>,
        "Russell King" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v3 04/10] KVM: Implement kvm_put_guest()
Message-ID: <20190822112930.000052db@huawei.com>
In-Reply-To: <20190821153656.33429-5-steven.price@arm.com>
References: <20190821153656.33429-1-steven.price@arm.com>
        <20190821153656.33429-5-steven.price@arm.com>
Organization: Huawei
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.61]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 16:36:50 +0100
Steven Price <steven.price@arm.com> wrote:

> kvm_put_guest() is analogous to put_user() - it writes a single value to
> the guest physical address. The implementation is built upon put_user()
> and so it has the same single copy atomic properties.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  include/linux/kvm_host.h | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fcb46b3374c6..e154a1897e20 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -746,6 +746,30 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  				  unsigned long len);
>  int kvm_gfn_to_hva_cache_init(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  			      gpa_t gpa, unsigned long len);
> +
> +#define __kvm_put_guest(kvm, gfn, offset, value, type)			\
> +({									\
> +	unsigned long __addr = gfn_to_hva(kvm, gfn);			\
> +	type __user *__uaddr = (type __user *)(__addr + offset);	\
> +	int __ret = 0;							\

Why initialize __ret?

> +									\
> +	if (kvm_is_error_hva(__addr))					\
> +		__ret = -EFAULT;					\
> +	else								\
> +		__ret = put_user(value, __uaddr);			\
> +	if (!__ret)							\
> +		mark_page_dirty(kvm, gfn);				\
> +	__ret;								\
> +})
> +
> +#define kvm_put_guest(kvm, gpa, value, type)				\
> +({									\
> +	gpa_t __gpa = gpa;						\
> +	struct kvm *__kvm = kvm;					\
> +	__kvm_put_guest(__kvm, __gpa >> PAGE_SHIFT,			\
> +			offset_in_page(__gpa), (value), type);		\
> +})
> +
>  int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len);
>  int kvm_clear_guest(struct kvm *kvm, gpa_t gpa, unsigned long len);
>  struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);


