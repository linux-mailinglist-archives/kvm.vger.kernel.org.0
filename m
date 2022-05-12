Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A015254EA
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357705AbiELSe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357681AbiELSe0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:34:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADBA66C9E
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:34:25 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq10so6030149pjb.0
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BUcwfda8/NN2DT0blrNG+sqcRTMirbYkw3Wm3k5URm0=;
        b=Q6/f5WOYKWwEL6cs7cDcBAHrNIeTRYQ7qV7MCDi/RQVJpIiZvIvr7erb7Bm9JcIP5E
         2SSIrkD/WbxBMUAvcZlHa5ooyVt9hjlYmmR7xmqQKwfvPG/DWJ8elh23nyG9/qbBsHwG
         OaL0KRfPFSLjCN4VvF8f0xszrKT5+r/gyZzPoLc4tRh2pU9fIKj7F7eLwpC2UY3I0QNX
         KWZgmCm4ZFDyUZQ0RfPhQjxVgMSKCvbRQ6MpAglTm1wNxh4m2RPi/bC75Mn4cBVDBsXB
         tM5pb71VxnJssBH//gIDO0JCqYZQXhmC/eq3hx3utULUdJ3R5IzcWhx9HHKQ4tMk9Wo5
         9UkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BUcwfda8/NN2DT0blrNG+sqcRTMirbYkw3Wm3k5URm0=;
        b=D6iRVJkIuecR2GyoUXxai3g+xeTwubxCdaD33Y7yPQ1ud8HOXvgHQerzd9eLkiZlT6
         g5XxN3hwnWBSDFDlETVDi3jhgGyX6mO36KSy9F2qHDVcFeI8jSNdG2Ho3LltdMJFIQ86
         KqenDrm8uZ0js25ZqQfZ18Ip05uOi7G+zlaEigM8ulf3VJeoJ0TUMKTlIkZ1t86o/tKY
         jghPi+WkIG2RTkQlNLp0OA7cxIoZkZ6YY3TmECS40qUfSFe9J1heYpabJWGgiJseH36R
         6lsaQgQjoVsxm2QCR2O48K9EbEWE5bsUbHpBm3aKPN4kLf31NBYpHlLZXJg4xNHD0Smx
         y9nQ==
X-Gm-Message-State: AOAM5312i1H7FZ/TvZUy0uU2ALI2QEbkFjeOMVV0NULlAvE8YpOjAqJP
        ZQ2VQylyBh7qep+beG2woZg=
X-Google-Smtp-Source: ABdhPJw1R1ibRkcltlohms3DOMAhrRgBYz5yllUvkivQK+M/jfahmJAFriIVG0ehe2vFlAHDci+84A==
X-Received: by 2002:a17:90b:4f45:b0:1dc:4f85:6ad4 with SMTP id pj5-20020a17090b4f4500b001dc4f856ad4mr893520pjb.40.1652380464851;
        Thu, 12 May 2022 11:34:24 -0700 (PDT)
Received: from localhost ([192.55.54.48])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b0015e8d4eb20fsm241986pln.89.2022.05.12.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:34:24 -0700 (PDT)
Date:   Thu, 12 May 2022 11:34:23 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
        Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [RFC PATCH v4 24/36] i386/tdx: Add TDVF memory via
 KVM_TDX_INIT_MEM_REGION
Message-ID: <20220512183423.GI2789321@ls.amr.corp.intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
 <20220512031803.3315890-25-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220512031803.3315890-25-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 11:17:51AM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> TDVF firmware (CODE and VARS) needs to be added/copied to TD's private
> memory via KVM_TDX_INIT_MEM_REGION, as well as TD HOB and TEMP memory.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  target/i386/kvm/tdx.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 3e18ace90bf7..567ee12e88f0 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -240,6 +240,7 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
>  {
>      TdxFirmware *tdvf = &tdx_guest->tdvf;
>      TdxFirmwareEntry *entry;
> +    int r;
>  
>      tdx_init_ram_entries();
>  
> @@ -265,6 +266,29 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
>            sizeof(TdxRamEntry), &tdx_ram_entry_compare);
>  
>      tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
> +
> +    for_each_tdx_fw_entry(tdvf, entry) {
> +        struct kvm_tdx_init_mem_region mem_region = {
> +            .source_addr = (__u64)entry->mem_ptr,
> +            .gpa = entry->address,
> +            .nr_pages = entry->size / 4096,
> +        };
> +
> +        __u32 metadata = entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND ?
> +                         KVM_TDX_MEASURE_MEMORY_REGION : 0;

Please use flags instead of metadata.


> +        r = tdx_vm_ioctl(KVM_TDX_INIT_MEM_REGION, metadata, &mem_region);
> +        if (r < 0) {
> +             error_report("KVM_TDX_INIT_MEM_REGION failed %s", strerror(-r));
> +             exit(1);
> +        }
> +
> +        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
> +            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
> +            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
> +            entry->mem_ptr = NULL;
> +        }
> +    }
>  }
>  
>  static Notifier tdx_machine_done_notify = {
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
