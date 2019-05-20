Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD9F2438D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2019 00:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfETWpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 18:45:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33208 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfETWpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 18:45:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id h17so7491111pgv.0
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 15:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Lriv7+U6WgLVg2Ap25ZmsKmP6G6qWt4u+kPIyLhwrA=;
        b=SOgOXTOhar+mPuEKRbn54BBErO2TGsLgtMWK81YjlKmWU6y7joQzJQxy5MtSGiCtDb
         JqFSNxs+NURyxn5+7mYTLbJ89X/6+X07tJDkaFKDewdDLtzWlv9O+Na5+cJOhSONklwA
         5VqW1O5gTCeOy1JU87pRnjbLgT0VGxXDdpG28NaYeQqkmbpfzt6Y0Bs3oj+NMhxC/ywc
         L4WCL7GBty2jsTNtw7ZYJQkFZP3dKQyQfuVrUw51B4fs1Hb5JHuum5NNheTCfB77eWE7
         t3aVDie8To7qjwjdzPi9sgAZsRdCB1ueeWP/Fnv6KYLExZncAL/5QiqdK6yqpT5FM/s+
         3iFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Lriv7+U6WgLVg2Ap25ZmsKmP6G6qWt4u+kPIyLhwrA=;
        b=PZQ1bOQXvuE/Ig+CkwdFjIfuh2VT3ZHjXAMctg/4TZMe8GL9sVCq35sHtOb3ISjy0v
         gfzq4BnIVf9QT/hEQDnRNE2/NrDey+/Y1gsLib3rKL/6ecoNtTFIfEn1T/3/lpmnowRi
         l5LVVZ4DJHjZdzjbizBBmzgm5eJHagojcV+Pj5Cp/TiJkR9uwApDX1tghWxFs4lRlWft
         NMUj9SR6GjnFH/mxAlM/SVZmnuuHPgihglCk4FG9Pf/4/SGdcTriL6i4NZOQ+SG39iv/
         BzrFCagwwBwWtlfuNiMYDFrX6IL6k+DVBCmjHZhc9l72aN3cdrSahLoYb+cmsgv8nizu
         NO+g==
X-Gm-Message-State: APjAAAV0emyRFXy4Yba/fmqWGOi9HDv7EQL4RZUWb+xavrEZgUFomGsr
        Y1TLKLEc15ZsjbUumaR48Kj0t5BhBaFLQ/qUC+umGA==
X-Google-Smtp-Source: APXvYqxJvnLUlslVYi/Zm30oi4BtCg59ayav/48NRihHpFdqhNt5/Fi04O4HXDvuEDLP7DXOXr0pmxBqbL7AENLKB4M=
X-Received: by 2002:a63:5c1c:: with SMTP id q28mr77304551pgb.45.1558392340903;
 Mon, 20 May 2019 15:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190520164418.06D1CE0184@unicorn.suse.cz>
In-Reply-To: <20190520164418.06D1CE0184@unicorn.suse.cz>
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
Date:   Mon, 20 May 2019 15:45:29 -0700
Message-ID: <CAOCOHw6rm1hvj1MDoMw=GArEafcPr-dnw4D18=baTcSdypbu0w@mail.gmail.com>
Subject: Re: [PATCH RESEND] kvm: make kvm_vcpu_(un)map dependency on
 CONFIG_HAS_IOMEM explicit
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 9:44 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> Recently introduced functions kvm_vcpu_map() and kvm_vcpu_unmap() call
> memremap() and memunmap() which are only available if HAS_IOMEM is enabled
> but this dependency is not explicit, so that the build fails with HAS_IOMEM
> disabled.
>
> As both function are only used on x86 where HAS_IOMEM is always enabled,
> the easiest fix seems to be to only provide them when HAS_IOMEM is enabled.
>
> Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Hi Michal,

I see the same build issue on arm64 and as CONFIG_HAS_IOMEM is set
there this patch has no effect on solving that. Instead I had to
include linux/io.h in kvm_main.c to make it compile.

Regards,
Bjorn

> ---
>  include/linux/kvm_host.h | 6 +++++-
>  virt/kvm/kvm_main.c      | 2 ++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 79fa4426509c..371d68fef5e1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -759,9 +759,13 @@ struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu);
>  struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn);
>  kvm_pfn_t kvm_vcpu_gfn_to_pfn_atomic(struct kvm_vcpu *vcpu, gfn_t gfn);
>  kvm_pfn_t kvm_vcpu_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn);
> +
> +#ifdef CONFIG_HAS_IOMEM
>  int kvm_vcpu_map(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map);
> -struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
>  void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty);
> +#endif
> +
> +struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_vcpu_gfn_to_hva(struct kvm_vcpu *vcpu, gfn_t gfn);
>  unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *writable);
>  int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data, int offset,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f0d13d9d125d..4a2c813e75d6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1743,6 +1743,7 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(gfn_to_page);
>
> +#ifdef CONFIG_HAS_IOMEM
>  static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
>                          struct kvm_host_map *map)
>  {
> @@ -1806,6 +1807,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
>         map->page = NULL;
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
> +#endif /* CONFIG_HAS_IOMEM */
>
>  struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
>  {
> --
> 2.21.0
>
