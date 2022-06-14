Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0CB54A314
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 02:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbiFNALP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 20:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiFNALN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 20:11:13 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94E8413D74
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 17:11:12 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id z11so5479179ilq.6
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 17:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnMbZcTpvqgPLdBSjHRJuKCSk759c13xui6B7R1t1uQ=;
        b=UWHIwl07hGDvI0wfcK3zDLePqB084XvOAEXZtG9YLs7Qamrq8qBh/97Rs7I8Cpc6Ky
         vQgi1KwGM1tjod5so3pAToAuYd5zAYthYQXWsok7uctu87wFLHq13M7UvoL5nShoA9Bm
         bUbNKL0dnUsLf2GOoerH9ILMtqhbH0CsPPJwK5xrk3EJO5EFoDQiIxEK4nucWJkXnZQg
         inUnSfdvuk0EYJ+0dUgFndr1/5B2aMu8LQIwGRFKLF5ZmkAI14sj8bF+hPUlDoU44DMJ
         gve7YjirSW6+HkmN7TJQ4guEwIYIa2uwuzDe5Us9Ymi41zRtq/9G5/8yEFC1+zaEdAOS
         rdfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnMbZcTpvqgPLdBSjHRJuKCSk759c13xui6B7R1t1uQ=;
        b=uXvJ5lsIqtD4ysr3BR/+/OtKzXWJsIHiuDotcfbzZBiEnfI1nSZEYfK3h892pyfLTM
         xGGNE7WkX9AeK8g6Ehk/IjQw66/XaIisFNm9+DIn1XDJZzv4puhBD5CTGecS9XgY0tPu
         O5v4Ms9ZOD+ETYLvJW3k26VLspNYpU8wGeCuWNyRuh5+xuGyHk1wgDpbkVR5F0MSsDwk
         4YL72w5CV4B642PcsIq73Yo3C/l7JHNx7wUHXTWiKKVC2SdAl5lfKCjKwqNKl20hFFQp
         Em+TszW2pbA8XR6xjHQaXhk2HVPOi3J4gmmYcn7rMZ9thPwZ8+UDJnbTOU/eqvkKEU0K
         M5Rw==
X-Gm-Message-State: AJIora+oy6cxks8kIt/otldbYorNneD0tkpxiGN6Ulor8krLu6BSksIj
        GYsT8X1jj523anpR3Ep1tVZcO+i9JmaCC4Gl6ohsOA==
X-Google-Smtp-Source: AGRyM1vvmWcS6Uk3XLwlWmm2TBNmlDnvXez0ftCObxk7xELuMfQjgAyThxD2SMRX8sV2ytdMhECXy+3RnrepRJd58Ec=
X-Received: by 2002:a05:6e02:1a23:b0:2d3:82bb:4dae with SMTP id
 g3-20020a056e021a2300b002d382bb4daemr1432588ile.62.1655165471758; Mon, 13 Jun
 2022 17:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <20210820155918.7518-15-brijesh.singh@amd.com>
In-Reply-To: <20210820155918.7518-15-brijesh.singh@amd.com>
From:   Alper Gun <alpergun@google.com>
Date:   Mon, 13 Jun 2022 17:10:58 -0700
Message-ID: <CABpDEumcC9dx-5i-1UN=Umg1WU-8=HoTWLBLd-VbKjXCrKd6oA@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 14/45] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
To:     Ashish.Kalra@amd.com
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to the TMR page, sev_init_ex_buffer should be owned by
firmware. Otherwise INIT_EX won't work with the SNP.  Since v5 patches
are prepared before INIT_EX work, I wanted to bring this to your
attention.
One difference from the TMR page, sev_init_ex_buffer has to be in the
direct map. Firmware pages are removed from directmap in v5 patches.
But the kernel reads sev_init_ex_buffer later to write into a
persistent file. I have a version to make it work, if you're
interested I can share.

On Fri, Aug 20, 2021 at 9:00 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>
> The behavior and requirement for the SEV-legacy command is altered when
> the SNP firmware is in the INIT state. See SEV-SNP firmware specification
> for more details.
>
> Allocate the Trusted Memory Region (TMR) as a 2mb sized/aligned region
> when SNP is enabled to satify new requirements for the SNP. Continue
> allocating a 1mb region for !SNP configuration.
>
> While at it, provide API that can be used by others to allocate a page
> that can be used by the firmware. The immediate user for this API will
> be the KVM driver. The KVM driver to need to allocate a firmware context
> page during the guest creation. The context page need to be updated
> by the firmware. See the SEV-SNP specification for further details.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 169 ++++++++++++++++++++++++++++++++++-
>  include/linux/psp-sev.h      |  11 +++
>  2 files changed, 176 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 01edad9116f2..34dc358b13b9 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -62,6 +62,14 @@ static int psp_timeout;
>  #define SEV_ES_TMR_SIZE                (1024 * 1024)
>  static void *sev_es_tmr;
>
> +/* When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB size. */
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
> @@ -159,6 +167,156 @@ static int sev_cmd_buffer_len(int cmd)
>         return 0;
>  }
>
> +static void snp_leak_pages(unsigned long pfn, unsigned int npages)
> +{
> +       WARN(1, "psc failed, pfn 0x%lx pages %d (leaking)\n", pfn, npages);
> +       while (npages--) {
> +               memory_failure(pfn, 0);
> +               dump_rmpentry(pfn);
> +               pfn++;
> +       }
> +}
> +
> +static int snp_reclaim_pages(unsigned long pfn, unsigned int npages, bool locked)
> +{
> +       struct sev_data_snp_page_reclaim data;
> +       int ret, err, i, n = 0;
> +
> +       for (i = 0; i < npages; i++) {
> +               memset(&data, 0, sizeof(data));
> +               data.paddr = pfn << PAGE_SHIFT;
> +
> +               if (locked)
> +                       ret = __sev_do_cmd_locked(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +               else
> +                       ret = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
> +               if (ret)
> +                       goto cleanup;
> +
> +               ret = rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (ret)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /*
> +        * If failed to reclaim the page then page is no longer safe to
> +        * be released, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +       return ret;
> +}
> +
> +static inline int rmp_make_firmware(unsigned long pfn, int level)
> +{
> +       return rmp_make_private(pfn, 0, level, 0, true);
> +}
> +
> +static int snp_set_rmp_state(unsigned long paddr, unsigned int npages, bool to_fw, bool locked,
> +                            bool need_reclaim)
> +{
> +       unsigned long pfn = __sme_clr(paddr) >> PAGE_SHIFT; /* Cbit maybe set in the paddr */
> +       int rc, n = 0, i;
> +
> +       for (i = 0; i < npages; i++) {
> +               if (to_fw)
> +                       rc = rmp_make_firmware(pfn, PG_LEVEL_4K);
> +               else
> +                       rc = need_reclaim ? snp_reclaim_pages(pfn, 1, locked) :
> +                                           rmp_make_shared(pfn, PG_LEVEL_4K);
> +               if (rc)
> +                       goto cleanup;
> +
> +               pfn++;
> +               n++;
> +       }
> +
> +       return 0;
> +
> +cleanup:
> +       /* Try unrolling the firmware state changes */
> +       if (to_fw) {
> +               /*
> +                * Reclaim the pages which were already changed to the
> +                * firmware state.
> +                */
> +               snp_reclaim_pages(paddr >> PAGE_SHIFT, n, locked);
> +
> +               return rc;
> +       }
> +
> +       /*
> +        * If failed to change the page state to shared, then its not safe
> +        * to release the page back to the system, leak it.
> +        */
> +       snp_leak_pages(pfn, npages - n);
> +
> +       return rc;
> +}
> +
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
> +{
> +       unsigned long npages = 1ul << order, paddr;
> +       struct sev_device *sev;
> +       struct page *page;
> +
> +       if (!psp_master || !psp_master->sev_data)
> +               return ERR_PTR(-EINVAL);
> +
> +       page = alloc_pages(gfp_mask, order);
> +       if (!page)
> +               return NULL;
> +
> +       /* If SEV-SNP is initialized then add the page in RMP table. */
> +       sev = psp_master->sev_data;
> +       if (!sev->snp_inited)
> +               return page;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, true, locked, false))
> +               return NULL;
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
> +
> +static void __snp_free_firmware_pages(struct page *page, int order, bool locked)
> +{
> +       unsigned long paddr, npages = 1ul << order;
> +
> +       if (!page)
> +               return;
> +
> +       paddr = __pa((unsigned long)page_address(page));
> +       if (snp_set_rmp_state(paddr, npages, false, locked, true))
> +               return;
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
> @@ -281,7 +439,7 @@ static int __sev_platform_init_locked(int *error)
>
>                 data.flags |= SEV_INIT_FLAGS_SEV_ES;
>                 data.tmr_address = tmr_pa;
> -               data.tmr_len = SEV_ES_TMR_SIZE;
> +               data.tmr_len = sev_es_tmr_size;
>         }
>
>         rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
> @@ -638,6 +796,8 @@ static int __sev_snp_init_locked(int *error)
>         sev->snp_inited = true;
>         dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>
> +       sev_es_tmr_size = SEV_SNP_ES_TMR_SIZE;
> +
>         return rc;
>  }
>
> @@ -1161,8 +1321,9 @@ static void sev_firmware_shutdown(struct sev_device *sev)
>                 /* The TMR area was encrypted, flush it from the cache */
>                 wbinvd_on_all_cpus();
>
> -               free_pages((unsigned long)sev_es_tmr,
> -                          get_order(SEV_ES_TMR_SIZE));
> +               __snp_free_firmware_pages(virt_to_page(sev_es_tmr),
> +                                         get_order(sev_es_tmr_size),
> +                                         false);
>                 sev_es_tmr = NULL;
>         }
>
> @@ -1233,7 +1394,7 @@ void sev_pci_init(void)
>         }
>
>         /* Obtain the TMR memory area for SEV-ES use */
> -       tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> +       tmr_page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(sev_es_tmr_size), false);
>         if (tmr_page) {
>                 sev_es_tmr = page_address(tmr_page);
>         } else {
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index f2105a8755f9..00bd684dc094 100644
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
> @@ -919,6 +921,8 @@ int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data, int *error);
>  int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error);
>
>  void *psp_copy_user_blob(u64 uaddr, u32 len);
> +void *snp_alloc_firmware_page(gfp_t mask);
> +void snp_free_firmware_page(void *addr);
>
>  #else  /* !CONFIG_CRYPTO_DEV_SP_PSP */
>
> @@ -960,6 +964,13 @@ static inline int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *erro
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
