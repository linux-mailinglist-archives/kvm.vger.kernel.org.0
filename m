Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582E36E9C97
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 21:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbjDTTmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 15:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTTmr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 15:42:47 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E9244BA;
        Thu, 20 Apr 2023 12:42:45 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f17fdb520dso9511895e9.3;
        Thu, 20 Apr 2023 12:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682019764; x=1684611764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfv2B7nnglGPY5lKeYYJGgG41JxY4YTi9gYldIZZ2FA=;
        b=MYgjyypqswmQG6YtHr/gj3invlgUzYkrg/aPTuFdvQHZPL/YO5i4PF32XnyH1ZTGQz
         b734vWMYMbVsbbO/M9Wal3nSfPgVsr/VlA1Dm+srAgGFmF6Lp0bnhVphG5TcywnqlxEN
         otaG9qzSCRigVoIglNcR4SbSXcfghPUb5gc1+7NJi53TmMDnoeaSS5N3K/ZZKyvKhMOv
         my1Eafov4Ugs+psmIfSzuTUTr7xCxd+xW3qLejMV+2Hr7Qjwm/CzXTt6GkSmEByoLwgT
         dJD5ky+Ow1cBOXG8ZlV7MdBSFET0Faa917sHxhy0dYFJroREl5QPGJjugg/sG4kskK5K
         ewTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682019764; x=1684611764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pfv2B7nnglGPY5lKeYYJGgG41JxY4YTi9gYldIZZ2FA=;
        b=Npo0KEOQCoEnwE3SDwCBtmG5piRswqWvgtMhOPpm7euyhVQC4LhklMB1yUaApUVwjJ
         2BtZierjRNqrojUguWyVSXvXfIqYEtoYauLQl+JFnLJDqNzvd6J7YTAoIIQ/1s0XACOa
         FgyPz/T+8E5l/L0jD4Z1j/gQJCltG0PMkdV0qNdFnYn53BB82r76u2e875eOeGG5iY4E
         uWZJDtRdUyt7riZnEahN1ORokgufXojDZ/pDy3Io4gyDHr+9yST9yRCHXpii9lY4kJpp
         wUbizt1u+xyKLtcMTjIZ+MviPu9Ehznd/ww1wC3CXYSlKJLTjd0UBMbc/zSE2aNswIwv
         BIrw==
X-Gm-Message-State: AAQBX9d73hK/sxvXns9RAutivFvvQNQc70hzbe6KazddYqiY2nEUFvhX
        /bDV+5rJyBmNzDgJw0E7YKU=
X-Google-Smtp-Source: AKy350avq0CExGtf4fiebF3FQzRiPIJEHCbJzrk50zC+WfWDQsglBM9pgQzdlXh/LaLmbuvNYNl/2A==
X-Received: by 2002:a7b:ca43:0:b0:3eb:3945:d405 with SMTP id m3-20020a7bca43000000b003eb3945d405mr34247wml.38.1682019764130;
        Thu, 20 Apr 2023 12:42:44 -0700 (PDT)
Received: from localhost (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm6257438wms.22.2023.04.20.12.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 12:42:43 -0700 (PDT)
Date:   Thu, 20 Apr 2023 20:42:42 +0100
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     linux-kernel@vger.kernel.org,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [RFC 01/48] mm/vmalloc: Introduce arch hooks to notify
 ioremap/unmap changes
Message-ID: <b58eadb7-c80c-42fe-b803-09f2f466c0bd@lucifer.local>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
 <20230419221716.3603068-2-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419221716.3603068-2-atishp@rivosinc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I'm a vmalloc reviewer too now -next/mm-unstable get_maintainer.pl should say
so, but forgivable because perhaps you ran against another tree but FYI for
future I'd appreciate a cc- :)

On Wed, Apr 19, 2023 at 03:16:29PM -0700, Atish Patra wrote:
> From: Rajnesh Kanwal <rkanwal@rivosinc.com>
>
> In virtualization, the guest may need notify the host about the ioremap
> regions. This is a common usecase in confidential computing where the
> host only provides MMIO emulation for the regions specified by the guest.
>
> Add a pair if arch specific callbacks to track the ioremapped regions.

Nit: typo if -> of.

>
> This patch is based on pkvm patches. A generic arch config can be added
> similar to pkvm if this is going to be the final solution. The device
> authorization/filtering approach is very different from this and we
> may prefer that one as it provides more flexibility in terms of which
> devices are allowed for the confidential guests.

So it's an RFC that assumes existing patches are already applied or do you mean
something else here? What do I need to do to get to a vmalloc.c with your patch
applied?

I guess this is pretty nitty since your changes are small here but be good to
know!

>
> Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
> Signed-off-by: Atish Patra <atishp@rivosinc.com>
> ---
>  mm/vmalloc.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bef6cf2..023630e 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -304,6 +304,14 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	return err;
>  }
>
> +__weak void ioremap_phys_range_hook(phys_addr_t phys_addr, size_t size, pgprot_t prot)
> +{
> +}
> +
> +__weak void iounmap_phys_range_hook(phys_addr_t phys_addr, size_t size)
> +{
> +}
> +

I'm not sure if this is for efficiency by using a weak reference, however, and
perhaps a nit, but I'd prefer an arch_*() that's defined in a header somewhere,
as it does hide the call paths quite effectively.

>  int ioremap_page_range(unsigned long addr, unsigned long end,
>  		phys_addr_t phys_addr, pgprot_t prot)
>  {
> @@ -315,6 +323,10 @@ int ioremap_page_range(unsigned long addr, unsigned long end,
>  	if (!err)
>  		kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					 ioremap_max_page_shift);
> +
> +	if (!err)
> +		ioremap_phys_range_hook(phys_addr, end - addr, prot);
> +
>  	return err;
>  }
>
> @@ -2772,6 +2784,10 @@ void vunmap(const void *addr)
>  				addr);
>  		return;
>  	}
> +
> +	if (vm->flags & VM_IOREMAP)
> +		iounmap_phys_range_hook(vm->phys_addr, get_vm_area_size(vm));
> +

There are places other than ioremap_page_range() that can set VM_IOREMAP,
e.g. vmap_pfn(), so this may trigger with addresses other than those specified
in the original hook. Is this intended?

>  	kfree(vm);
>  }
>  EXPORT_SYMBOL(vunmap);
> --
> 2.25.1
>
