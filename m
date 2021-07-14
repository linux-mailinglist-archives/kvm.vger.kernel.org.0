Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E4E3C8539
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 15:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhGNNZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 09:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239423AbhGNNZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 09:25:40 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B91C061762
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 06:22:47 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id x24so1784306qts.11
        for <kvm@vger.kernel.org>; Wed, 14 Jul 2021 06:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8WaQzYZeQ7Li+6RRsoQKD67iI4SEvRFGh30cooQVpZw=;
        b=ALZqB1qoxrXn+jAy7RQaf+A7TkxQvjq4ulZG5YO0uUIcybxnZKm0rpHD53EIfe8Jk/
         YpGITna9ARYShBitncZbkmgkFksLsZIy/+ZdAoeYLBTDx8C1DKoohAJPaBYnRKyySVGc
         ITV+cFCVYK57U2R6VkGW5CEThNcTLrXhcqZ3U/43GLOYRV5ZCgoQENAK9PMCgKrnE4Bx
         RHXyl1CDuy68G1JGKqXbsBkwwZFSyQIkgTYpbX3O1ZpSJIeE/kExE2YJ4ajcd9qm2a80
         xOkPSt+FopxTdx7Z1GVBLUUUa3y0DyeLiL1Gd0HkNb5dMY0ayoba9xVy0Kz+ZAL5/J4w
         3PIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8WaQzYZeQ7Li+6RRsoQKD67iI4SEvRFGh30cooQVpZw=;
        b=G56bs+FLXPOHzZZ9DcP+h8bK6r9pn5SexiKLImb08Avjv89dGu6KSMNYwtUacLEfAP
         j+PFuSRLPuX7d5m8RUV5qOmtBkUkSfMAOw/FmsUgt7FOJulV7z9u6mhmjRPud1R2HNYq
         4VNOCzEOgiNKtSjg1qtkvjFQhCPTDWE4i+6Y+VJZtf59z0RuqBj3f512iAjJUqjeSWjy
         PVSgHpGAVKJRBKwqK1ZzNuLVmno+5lpW9c/F7RodEtgyJdIRb43lfAF0CQ8AY6PI7NT9
         BV9wEyolTr/m9kiplAuHlWm7p8sJ2m9Yy8dqxI2JmeOrdIjdnColSKQWEYIxPerIfrbM
         Bk5A==
X-Gm-Message-State: AOAM532yLdtvwOxijH0UKvP5nOaRGTs3un7pKgNGsI/5C2LK79zuRjFC
        VBxl3HBOC/gTdJJvYK7D9axaRBuKGgG8rwXrlXnTu7XWFcUAzG8M
X-Google-Smtp-Source: ABdhPJzUq99VHUKVJMfZn1C5QDzWePBXid78b3kd93+UIASO5flvGLThImwDSEJuQzURM3cOVvnjCPX/f4O4MxrE6VA=
X-Received: by 2002:a05:622a:409:: with SMTP id n9mr9315541qtx.261.1626268966412;
 Wed, 14 Jul 2021 06:22:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210707183616.5620-1-brijesh.singh@amd.com> <20210707183616.5620-16-brijesh.singh@amd.com>
In-Reply-To: <20210707183616.5620-16-brijesh.singh@amd.com>
From:   Marc Orr <marcorr@google.com>
Date:   Wed, 14 Jul 2021 06:22:35 -0700
Message-ID: <CAA03e5HA_vjhOtTPL-vKFJvPxseLRMs5=s90ffUwDWQxtG7aCQ@mail.gmail.com>
Subject: Re: [PATCH Part2 RFC v4 15/40] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        kvm list <kvm@vger.kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>, tony.luck@intel.com,
        npmccallum@redhat.com, brijesh.ksingh@gmail.com,
        Alper Gun <alpergun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 7, 2021 at 11:37 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
>
> When SNP is INIT state, all the SEV-legacy commands that cause the
> firmware to write memory must be in the firmware state. The TMR memory
> is allocated by the host but updated by the firmware, so, it must be
> in the firmware state.  Additionally, the TMR memory must be a 2MB aligned
> instead of the 1MB, and the TMR length need to be 2MB instead of 1MB.
> The helper __snp_{alloc,free}_firmware_pages() can be used for allocating
> and freeing the memory used by the firmware.
>
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 144 +++++++++++++++++++++++++++++++----
>  include/linux/psp-sev.h      |  11 +++
>  2 files changed, 142 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ad9a0c8111e0..bb07c68834a6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -54,6 +54,14 @@ static int psp_timeout;
>  #define SEV_ES_TMR_SIZE                (1024 * 1024)
>  static void *sev_es_tmr;
>
> +/* When SEV-SNP is enabled the TMR need to be 2MB aligned and 2MB size. */

nit: "the TMR need" -> "the TMR needs"

> +#define SEV_SNP_ES_TMR_SIZE    (2 * 1024 * 1024)
> +
> +static size_t sev_es_tmr_size = SEV_ES_TMR_SIZE;
> +
> +static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret);
> +static int sev_do_cmd(int cmd, void *data, int *psp_ret);
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>         struct sev_device *sev = psp_master->sev_data;
> @@ -151,6 +159,112 @@ static int sev_cmd_buffer_len(int cmd)
>         return 0;
>  }
>
> +static int snp_reclaim_page(struct page *page, bool locked)
> +{
> +       struct sev_data_snp_page_reclaim data = {};

Hmmm.. according to some things I read online, an empty initializer
list is not legal in C. For example:
https://stackoverflow.com/questions/17589533/is-an-empty-initializer-list-valid-c-code
I'm sure this is compiling. Should we change this to `{0}`, which I
believe will initialize all fields in this struct to zero, according
to: https://stackoverflow.com/questions/11152160/initializing-a-struct-to-0?

> +       int ret, err;
> +
> +       data.paddr = page_to_pfn(page) << PAGE_SHIFT;
> +
> +       if (locked)
> +               ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +       else
> +               ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +
> +       return ret;
> +}
> +
> +static int snp_set_rmptable_state(unsigned long paddr, int npages,
> +                                 struct rmpupdate *val, bool locked, bool need_reclaim)
> +{
> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT;
> +       unsigned long pfn_end = pfn + npages;
> +       struct psp_device *psp = psp_master;
> +       struct sev_device *sev;
> +       int rc;
> +
> +       if (!psp || !psp->sev_data)
> +               return 0;

Should this return a non-zero value -- maybe `-ENODEV`? Otherwise, the
`snp_alloc_firmware_page()` API will return a page that the caller
believes is suitable to use with FW. My concern is that someone
decides to use this API to stash a page very early on during kernel
boot and that page becomes a time bomb.

If we initialize `rc` to `-ENODEV` (or something similar), then every
return in this function can be `return rc`.

> +
> +       /* If SEV-SNP is initialized then add the page in RMP table. */
> +       sev = psp->sev_data;
> +       if (!sev->snp_inited)
> +               return 0;

Ditto. Should this turn a non-zero value?

> +
> +       while (pfn < pfn_end) {
> +               if (need_reclaim)
> +                       if (snp_reclaim_page(pfn_to_page(pfn), locked))
> +                               return -EFAULT;
> +
> +               rc = rmpupdate(pfn_to_page(pfn), val);
> +               if (rc)
> +                       return rc;
> +
> +               pfn++;
> +       }
> +
> +       return 0;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
> +{
> +       struct rmpupdate val = {};

`{}` -> `{0}`? (Not sure, see my previous comment.)

> +       unsigned long paddr;
> +       struct page *page;
> +
> +       page = alloc_pages(gfp_mask, order);
> +       if (!page)
> +               return NULL;
> +
> +       val.assigned = 1;
> +       val.immutable = 1;
> +       paddr = __pa((unsigned long)page_address(page));
> +
> +       if (snp_set_rmptable_state(paddr, 1 << order, &val, locked, false)) {
> +               pr_warn("Failed to set page state (leaking it)\n");

Maybe `WARN_ONCE` instead of `pr_warn`? It's both a big attention
grabber and also rate limited.

> +               return NULL;
> +       }
> +
> +       return page;
> +}
> +
> +void *snp_alloc_firmware_page(gfp_t gfp_mask)
> +{
> +       struct page *page;
> +
> +       page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
> +
> +       return page ? page_address(page) : NULL;
> +}
> +EXPORT_SYMBOL_GPL(snp_alloc_firmware_page);
>
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +       struct rmpupdate val = {};

`{}` -> `{0}`? (Not sure, see my previous comment.)

> +       unsigned long paddr;
> +
> +       if (!page)
> +               return;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +
> +       if (snp_set_rmptable_state(paddr, 1 << order, &val, locked, true)) {
> +               pr_warn("Failed to set page state (leaking it)\n");

WARN_ONCE?

> +               return;
> +       }
> +
> +       __free_pages(page, order);
> +}
> +
> +void snp_free_firmware_page(void *addr)
> +{
> +       if (!addr)
> +               return;
> +
> +       __snp_free_firmware_pages(virt_to_page(addr), 0, false);
> +}
> +EXPORT_SYMBOL(snp_free_firmware_page);
> +
>  static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  {
>         struct psp_device *psp = psp_master;
> @@ -273,7 +387,7 @@ static int __sev_platform_init_locked(int *error)
>
>                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
>                 data.tmr_address = tmr_pa;
> -               data.tmr_len = SEV_ES_TMR_SIZE;
> +               data.tmr_len = sev_es_tmr_size;
>         }
>
>         rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -630,6 +744,8 @@ static int __sev_snp_init_locked(int *error)
>         sev->snp_inited = true;
>         dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>
> +       sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>         return rc;
>  }
>
> @@ -1153,8 +1269,10 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>                 /* The TMR area was encrypted, flush it from the cache */
>                 wbinvd_on_all_cpus();
>
> -               free_pages((unsigned long)sev_es_tmr,
> -                          get_order(SEV_ES_TMR_SIZE));
> +
> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +                                         get_order(sev_es_tmr_size),
> +                                         false);
>                 sev_es_tmr = NULL;
>         }
>
> @@ -1204,16 +1322,6 @@ void sev_pci_init(void)
>             sev_update_firmware(sev->dev) == 0)
>                 sev_get_api_version();
>
> -       /* Obtain the TMR memory area for SEV-ES use */
> -       tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> -       if (tmr_page) {
> -               sev_es_tmr = page_address(tmr_page);
> -       } else {
> -               sev_es_tmr = NULL;
> -               dev_warn(sev->dev,
> -                        "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> -       }
> -
>         /*
>          * If boot CPU supports the SNP, then first attempt to initialize
>          * the SNP firmware.
> @@ -1229,6 +1337,16 @@ void sev_pci_init(void)
>                 }
>         }
>
> +       /* Obtain the TMR memory area for SEV-ES use */
> +       tmr_page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(sev_es_tmr_size), false);
> +       if (tmr_page) {
> +               sev_es_tmr = page_address(tmr_page);
> +       } else {
> +               sev_es_tmr = NULL;
> +               dev_warn(sev->dev,
> +                        "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +       }
> +
>         /* Initialize the platform */
>         rc = sev_platform_init(&error);
>         if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 63ef766cbd7a..b72a74f6a4e9 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -12,6 +12,8 @@
>  #ifndef __PSP_SEV_H__
>  #define __PSP_SEV_H__
>
> +#include <linux/sev.h>
> +
>  #include <uapi/linux/psp-sev.h>
>
>  #ifdef CONFIG_X86
> @@ -920,6 +922,8 @@ int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
>
>
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
> @@ -961,6 +965,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
>         return -ENODEV;
>  }
>
> +static inline void *snp_alloc_firmware_page(gfp_t mask)
> +{
> +       return NULL;
> +}
> +
> +static inline void snp_free_firmware_page(void *addr) { }
> +
>  #endif /* CONFIG_CRYPTO_DEV_SP_PSP */
>
>  #endif /* __PSP_SEV_H__ */
> --
> 2.17.1
>
>
