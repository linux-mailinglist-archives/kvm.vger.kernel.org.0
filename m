Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7A4DDFA4
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbiCRRMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239524AbiCRRMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:12:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177D730DC73
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:11:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so1444643pjf.1
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xQt4nxSGPU+SWrpDFe8+9LX68lS5/Y6gNspZauNXIUs=;
        b=BKv5w7ZzqV0yDs+BE/tWbCStm2nbClE4dNAmmog6pNIHmhQHYkEHaGPQmvOsC/DM3h
         yQyTpWAenK+bIxdypy0Ts1T6q1ycOqsgLIyBjgV6FrZq1ulyk22tddpXPKL+6zB811W1
         ghsIadLd5dl4NFydecq4R84Ss5zL0X+wtdRaAkHbjn3fZwEiHkVEztUPNjoGdCLShjcL
         GveFESbkIlDUeFGv9OhzADtw1mLjPAyW4opukXBVzPapn3AN+ZAfS7q5Rw+aNea5GKvO
         oOEVzS+kNL4IkPR2KhZVpDi2WHzRQLYRYb5PLFYECFn+W4wtQhm7qFxdPZ5qak/AtFEb
         GRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xQt4nxSGPU+SWrpDFe8+9LX68lS5/Y6gNspZauNXIUs=;
        b=CS570OL5mQ3cJZHeMDOiF+1e407Q9rJRsY+HmZ34A2BBuwJAZGwhpumGUpNMyzq2Qc
         2d08EhWQPplzbewAUWiPBgf7EiXoB1d0zFabUjKyjUZMlwA4jJaz15MWLQH5C/xgmzQv
         yEsHj9dzPX3dLsMvaSqr1ckDnrXvSn+kfO7QRllS5ex9Q1Vw0JsLbA0O4NGA9hDNuS+3
         CEXGEB6EMHXDfGlblLb5EfscFnxqiViEnfm8UcUGG+xYdMKqf1qRlbFNhtcj90L+o9PP
         Wu3p3yTwev/ebsH4/xyhHnLWPF49L/SnRTKW/GKoZIQ8ip5nxBh/DJlZCV1PxucdQoRA
         hkiQ==
X-Gm-Message-State: AOAM532oQpxXFLN/9wv6pj+AqB5pZcxAhw5JC745jmxDa0/FbiQKuUZE
        KSSOLkTR8X3rD8RMQ8HPO8w=
X-Google-Smtp-Source: ABdhPJyplph433Axs2Y4KyJvIqtdkGuf8AiLcHRl8fn6QSf5SJN+27zsxGmljbNKoHQMLr8iJnrjbQ==
X-Received: by 2002:a17:90b:4a11:b0:1bf:7fbe:258d with SMTP id kk17-20020a17090b4a1100b001bf7fbe258dmr23163463pjb.79.1647623479565;
        Fri, 18 Mar 2022 10:11:19 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id b2-20020a639302000000b003808dc4e133sm8157561pge.81.2022.03.18.10.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 10:11:19 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:11:17 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, Connor Kuehl <ckuehl@redhat.com>,
        seanjc@google.com, qemu-devel@nongnu.org, erdemaktas@google.com,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 16/36] i386/tdx: Set kvm_readonly_mem_enabled to
 false for TDX VM
Message-ID: <20220318171117.GC4049379@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-17-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317135913.2166202-17-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 09:58:53PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> TDX only supports readonly for shared memory but not for private memory.
> 
> In the view of QEMU, it has no idea whether a memslot is used by shared
> memory of private. Thus just mark kvm_readonly_mem_enabled to false to
> TDX VM for simplicity.
> 
> Note, pflash has dependency on readonly capability from KVM while TDX
> wants to reuse pflash interface to load TDVF (as OVMF). Excuse TDX VM
> for readonly check in pflash.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  hw/i386/pc_sysfw.c    | 2 +-
>  target/i386/kvm/tdx.c | 9 +++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/i386/pc_sysfw.c b/hw/i386/pc_sysfw.c
> index c8b17af95353..75b34d02cb4f 100644
> --- a/hw/i386/pc_sysfw.c
> +++ b/hw/i386/pc_sysfw.c
> @@ -245,7 +245,7 @@ void pc_system_firmware_init(PCMachineState *pcms,
>          /* Machine property pflash0 not set, use ROM mode */
>          x86_bios_rom_init(MACHINE(pcms), "bios.bin", rom_memory, false);
>      } else {
> -        if (kvm_enabled() && !kvm_readonly_mem_enabled()) {
> +        if (kvm_enabled() && (!kvm_readonly_mem_enabled() && !is_tdx_vm())) {

Is this called before tdx_kvm_init()?

Thanks,


>              /*
>               * Older KVM cannot execute from device memory. So, flash
>               * memory cannot be used unless the readonly memory kvm
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 94a9c1ea7e9c..1bb8211e74e6 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -115,6 +115,15 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
>          get_tdx_capabilities();
>      }
>  
> +    /*
> +     * Set kvm_readonly_mem_allowed to false, because TDX only supports readonly
> +     * memory for shared memory but not for private memory. Besides, whether a
> +     * memslot is private or shared is not determined by QEMU.
> +     *
> +     * Thus, just mark readonly memory not supported for simplicity.
> +     */
> +    kvm_readonly_mem_allowed = false;
> +
>      tdx_guest = tdx;
>  
>      return 0;
> -- 
> 2.27.0
> 
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
