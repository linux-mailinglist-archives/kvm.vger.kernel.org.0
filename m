Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91EAA553611
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351788AbiFUP3X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352866AbiFUP2X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 11:28:23 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE7D6324
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:28:18 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id d19so15866197lji.10
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 08:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PPDc7qXBrAf8hM+ois/4M7n9y0Ctx2nTK0cCddntA00=;
        b=Fi5EjLIzvDAJUiiuADLK7DwH7YYV7f0bHceXlX43VOliKsB9BBv4L4DTZlFmLFmkLk
         POofabhBgj7RE3usD0FttRM8D8eDilGLOLPHqgnO8YDVQiE1OoG9dKOP/Dt3N9HP2E97
         pFaXlwW+xYC2rWvtNgYANRwcpOUunAVpIJRCpoGyJRPa7VTijqJgFrS7RPtiWetYUA/S
         nI082qoNoGUD37fI/pZXTw5gtv676RW9g4oemXpkcgvuAWhRvJ3ckQa3MARMB7BRSwwp
         c9I9EW0jqRTQRaIdnXBNrGAivBi4QpIXdTKVVrEiFHYLvbScsPkiQHkbzokqo2gVc8J3
         Pkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PPDc7qXBrAf8hM+ois/4M7n9y0Ctx2nTK0cCddntA00=;
        b=L7WnFrlre8wR+93tsUlkzxBm+r4h2bhJMOqYHnWAXjY8UDII6roM0QxKmZaWWoRq2D
         LVb0TKf44jfY0cB83DTBFlnJojjsfv5s3aIOblxEkTHkKhZbdOCCnr6TQuIGlwR0e8bu
         AyKUdUtd4I0WhG/FW7sKVspniYQKdmeN+/0906oOOEhUWhCNcufDG7sDr0zIUNaXxv72
         ZS3wRuCNA3nD3ITYlpX5OrJK83YzHPfJppw74eZe64N82loj4T+TiG1jYhPaBQ6vo/Ss
         s9nu1PjKfrp2YsZ8IWgfkIyw4EaBnl1ypzZdpC5FliAgZAkDFSd4vglaji6t61+uZ6it
         Xz2Q==
X-Gm-Message-State: AJIora+5m18QyVP/Tb8rvFOrvkIR1iLVDW19xyTduS40AZzhBAw+QCyq
        yXp82I/i7SK4XkaZJ8kaVDj04H2FVCtjGuftTI/6uA==
X-Google-Smtp-Source: AGRyM1tCe4/jK6PDAE71M19F4NM9E58kJKDMKB8cBjF0f/1wes7fLBrrgPNVl2oI3WpdVtZrOfMqeKvvJybe5z/2EzA=
X-Received: by 2002:a2e:8091:0:b0:25a:8496:b255 with SMTP id
 i17-20020a2e8091000000b0025a8496b255mr75993ljg.369.1655825296513; Tue, 21 Jun
 2022 08:28:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1655761627.git.ashish.kalra@amd.com> <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
In-Reply-To: <12df64394b1788156c8a3c2ee8dfd62b51ab3a81.1655761627.git.ashish.kalra@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 21 Jun 2022 09:28:04 -0600
Message-ID: <CAMkAt6r+WSYXLZj-Bs5jpo4CR3+H5cpND0GHjsmgPacBK1GH_Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v6 02/49] iommu/amd: Introduce function to check
 SEV-SNP support
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Marc Orr <marcorr@google.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Alper Gun <alpergun@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>, jarkko@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 20, 2022 at 4:59 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Brijesh Singh <brijesh.singh@amd.com>
>
> The SEV-SNP support requires that IOMMU must to enabled, see the IOMMU
> spec section 2.12 for further details. If IOMMU is not enabled or the
> SNPSup extended feature register is not set then the SNP_INIT command
> (used for initializing firmware) will fail.
>
> The iommu_sev_snp_supported() can be used to check if IOMMU supports the
> SEV-SNP feature.
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/iommu/amd/init.c | 30 ++++++++++++++++++++++++++++++
>  include/linux/iommu.h    |  9 +++++++++
>  2 files changed, 39 insertions(+)
>
> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
> index 1a3ad58ba846..82be8067ddf5 100644
> --- a/drivers/iommu/amd/init.c
> +++ b/drivers/iommu/amd/init.c
> @@ -3361,3 +3361,33 @@ int amd_iommu_pc_set_reg(struct amd_iommu *iommu, u8 bank, u8 cntr, u8 fxn, u64
>
>         return iommu_pc_get_set_reg(iommu, bank, cntr, fxn, value, true);
>  }
> +
> +bool iommu_sev_snp_supported(void)
> +{
> +       struct amd_iommu *iommu;
> +
> +       /*
> +        * The SEV-SNP support requires that IOMMU must be enabled, and is
> +        * not configured in the passthrough mode.
> +        */
> +       if (no_iommu || iommu_default_passthrough()) {
> +               pr_err("SEV-SNP: IOMMU is either disabled or configured in passthrough mode.\n");

Like below could this say something like snp support is disabled
because of iommu settings.

> +               return false;
> +       }
> +
> +       /*
> +        * Iterate through all the IOMMUs and verify the SNPSup feature is
> +        * enabled.
> +        */
> +       for_each_iommu(iommu) {
> +               if (!iommu_feature(iommu, FEATURE_SNP)) {
> +                       pr_err("SNPSup is disabled (devid: %02x:%02x.%x)\n",

SNPSup might not be obvious to readers, what about " SNP Support is
disabled ...".

Also should this have the "SEV-SNP:" prefix like the above log?

> +                              PCI_BUS_NUM(iommu->devid), PCI_SLOT(iommu->devid),
> +                              PCI_FUNC(iommu->devid));
> +                       return false;
> +               }
> +       }
> +
> +       return true;
> +}
> +EXPORT_SYMBOL_GPL(iommu_sev_snp_supported);
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 9208eca4b0d1..fecb72e1b11b 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -675,6 +675,12 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev,
>  void iommu_sva_unbind_device(struct iommu_sva *handle);
>  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
>
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +bool iommu_sev_snp_supported(void);
> +#else
> +static inline bool iommu_sev_snp_supported(void) { return false; }
> +#endif
> +
>  #else /* CONFIG_IOMMU_API */
>
>  struct iommu_ops {};
> @@ -1031,6 +1037,9 @@ static inline struct iommu_fwspec *dev_iommu_fwspec_get(struct device *dev)
>  {
>         return NULL;
>  }
> +
> +static inline bool iommu_sev_snp_supported(void) { return false; }
> +
>  #endif /* CONFIG_IOMMU_API */
>
>  /**
> --
> 2.25.1
>
