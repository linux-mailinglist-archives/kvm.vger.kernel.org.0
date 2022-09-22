Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745EF5E5E0B
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 10:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbiIVIzs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 04:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiIVIz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 04:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4E34CA1A
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 01:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663836924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQUZH0l2McBt181klcXtt0pGPwD2K1dPTxk16J/dKt0=;
        b=cZ9h1baWr+xp+8PnOhJx6kinyjg5UmtcokS8Jh3RKN/6GR5fr1B4hJDhQPV5GD9Rvt+qau
        5zmVBK4kj2eoUIARx8/93/iW6OGUXGyAUt/Igr+1k7b9vm7LKF6ICvOP9JzWibety7j5Ch
        Ef3aOvUUn1/wR/ggjqXhelQdoxAExcE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-HiQkfU9lM5m-gn2dO-JW3Q-1; Thu, 22 Sep 2022 04:55:23 -0400
X-MC-Unique: HiQkfU9lM5m-gn2dO-JW3Q-1
Received: by mail-wm1-f72.google.com with SMTP id d5-20020a05600c34c500b003b4fb42ccdeso761797wmq.8
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 01:55:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=BQUZH0l2McBt181klcXtt0pGPwD2K1dPTxk16J/dKt0=;
        b=Sj0Rkrri4bYUtJ3KaSjgyOQFVYgw0/Y/ohqkta9Hqx9yr/bWziOZ5HM3fKEi2VVmxU
         qKqpl/4neb3rooKux9c5sSvV6TBmr7RZMePNJRfMiTJJAJCVL1sJ6M+V0hCsz3u6hfez
         g2RfGzu6Sd7tbXBTo/QCcwCeTTlfb4pgBqnp0H7s4YCSL5QVtLUdDRZyPKdiad97P1sH
         yQK6h7XomSQryE/Ppj3aXBE2nCwOt9y9GQAoYncoWglPQLyosXj3z7ZeSe98Ww+YAWW5
         RsxwWONwDPqxp606SY7tmSNlSw18w3SbJN34ghZX+6SSw4gVW5znVa1plbh5F7sVLJzo
         +NWA==
X-Gm-Message-State: ACrzQf2oplowfDqqmEFfCMF6NKcuLszNfUP83prThO6wJmzSXu5BeaTI
        HdJjQZcG6HJRq2MyigyHvZbboxVGmAZWUHq7jvVNla5R7I3CEXYpg7VMJPZxoGRpMnKD7hZnZnM
        kj3iUlzTLAgl8
X-Received: by 2002:a05:600c:2050:b0:3b4:a51a:a1f5 with SMTP id p16-20020a05600c205000b003b4a51aa1f5mr1463330wmg.177.1663836920805;
        Thu, 22 Sep 2022 01:55:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5xvz/kDCcXO3k/Qqm9fQ74sw9y3TIylqcmtcYP4XUWuSa2S1vrfGP3+Py49BTcJljmOZX+2g==
X-Received: by 2002:a05:600c:2050:b0:3b4:a51a:a1f5 with SMTP id p16-20020a05600c205000b003b4a51aa1f5mr1463312wmg.177.1663836920533;
        Thu, 22 Sep 2022 01:55:20 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id x12-20020a5d650c000000b00228cbac7a25sm4555579wru.64.2022.09.22.01.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 01:55:20 -0700 (PDT)
Date:   Thu, 22 Sep 2022 04:55:16 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3] x86: add etc/phys-bits fw_cfg file
Message-ID: <20220922044906-mutt-send-email-mst@kernel.org>
References: <20220922084356.878907-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922084356.878907-1-kraxel@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 10:43:56AM +0200, Gerd Hoffmann wrote:
> In case phys bits are functional and can be used by the guest (aka
> host-phys-bits=on) add a fw_cfg file carrying the value.  This can
> be used by the guest firmware for address space configuration.
> 
> This is only enabled for 7.2+ machine types for live migration
> compatibility reasons.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

I'm curious why you decided to switch from a cpuid flag to fw cfg.  I
guess firmware reads fw cfg anyway. But would the guest kernel then need
to load a fw cfg driver very early to detect this, too?

> ---
>  hw/i386/fw_cfg.h     |  1 +
>  include/hw/i386/pc.h |  1 +
>  hw/i386/fw_cfg.c     | 12 ++++++++++++
>  hw/i386/pc.c         |  5 +++++
>  hw/i386/pc_piix.c    |  2 ++
>  hw/i386/pc_q35.c     |  2 ++
>  6 files changed, 23 insertions(+)
> 
> diff --git a/hw/i386/fw_cfg.h b/hw/i386/fw_cfg.h
> index 275f15c1c5e8..6ff198a6cb85 100644
> --- a/hw/i386/fw_cfg.h
> +++ b/hw/i386/fw_cfg.h
> @@ -26,5 +26,6 @@ FWCfgState *fw_cfg_arch_create(MachineState *ms,
>  void fw_cfg_build_smbios(MachineState *ms, FWCfgState *fw_cfg);
>  void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg);
>  void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg);
> +void fw_cfg_phys_bits(FWCfgState *fw_cfg);
>  
>  #endif
> diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
> index c95333514ed3..bedef1ee13c1 100644
> --- a/include/hw/i386/pc.h
> +++ b/include/hw/i386/pc.h
> @@ -119,6 +119,7 @@ struct PCMachineClass {
>      bool enforce_aligned_dimm;
>      bool broken_reserved_end;
>      bool enforce_amd_1tb_hole;
> +    bool phys_bits_in_fw_cfg;
>  
>      /* generate legacy CPU hotplug AML */
>      bool legacy_cpu_hotplug;
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index a283785a8de4..6a1f18925725 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -219,3 +219,15 @@ void fw_cfg_add_acpi_dsdt(Aml *scope, FWCfgState *fw_cfg)
>      aml_append(dev, aml_name_decl("_CRS", crs));
>      aml_append(scope, dev);
>  }
> +
> +void fw_cfg_phys_bits(FWCfgState *fw_cfg)
> +{
> +    X86CPU *cpu = X86_CPU(first_cpu);
> +    uint64_t phys_bits = cpu->phys_bits;
> +
> +    if (cpu->host_phys_bits) {
> +        fw_cfg_add_file(fw_cfg, "etc/phys-bits",
> +                        g_memdup2(&phys_bits, sizeof(phys_bits)),
> +                        sizeof(phys_bits));
> +    }
> +}

So, this allows a lot of flexibility, any phys_bits value at all can now
be used. Do you expect a use-case for such a flexible mechanism?  If
this ends up merely repeating CPUID at all times then we are just
creating confusion.
Could you add the motivation to the commit log pls?


> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 566accf7e60a..17ecc7fe4331 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -744,6 +744,7 @@ void pc_machine_done(Notifier *notifier, void *data)
>  {
>      PCMachineState *pcms = container_of(notifier,
>                                          PCMachineState, machine_done);
> +    PCMachineClass *pcmc = PC_MACHINE_GET_CLASS(pcms);
>      X86MachineState *x86ms = X86_MACHINE(pcms);
>  
>      cxl_hook_up_pxb_registers(pcms->bus, &pcms->cxl_devices_state,
> @@ -764,6 +765,9 @@ void pc_machine_done(Notifier *notifier, void *data)
>          fw_cfg_build_feature_control(MACHINE(pcms), x86ms->fw_cfg);
>          /* update FW_CFG_NB_CPUS to account for -device added CPUs */
>          fw_cfg_modify_i16(x86ms->fw_cfg, FW_CFG_NB_CPUS, x86ms->boot_cpus);
> +        if (pcmc->phys_bits_in_fw_cfg) {
> +            fw_cfg_phys_bits(x86ms->fw_cfg);
> +        }
>      }
>  }
>  
> @@ -1907,6 +1911,7 @@ static void pc_machine_class_init(ObjectClass *oc, void *data)
>      pcmc->kvmclock_enabled = true;
>      pcmc->enforce_aligned_dimm = true;
>      pcmc->enforce_amd_1tb_hole = true;
> +    pcmc->phys_bits_in_fw_cfg = true;
>      /* BIOS ACPI tables: 128K. Other BIOS datastructures: less than 4K reported
>       * to be used at the moment, 32K should be enough for a while.  */
>      pcmc->acpi_data_size = 0x20000 + 0x8000;
> diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
> index 8043a250adf3..c6a4dbd5c0b0 100644
> --- a/hw/i386/pc_piix.c
> +++ b/hw/i386/pc_piix.c
> @@ -447,9 +447,11 @@ DEFINE_I440FX_MACHINE(v7_2, "pc-i440fx-7.2", NULL,
>  
>  static void pc_i440fx_7_1_machine_options(MachineClass *m)
>  {
> +    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
>      pc_i440fx_7_2_machine_options(m);
>      m->alias = NULL;
>      m->is_default = false;
> +    pcmc->phys_bits_in_fw_cfg = false;
>      compat_props_add(m->compat_props, hw_compat_7_1, hw_compat_7_1_len);
>      compat_props_add(m->compat_props, pc_compat_7_1, pc_compat_7_1_len);
>  }
> diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
> index 53eda50e818c..c2b56daa1550 100644
> --- a/hw/i386/pc_q35.c
> +++ b/hw/i386/pc_q35.c
> @@ -384,8 +384,10 @@ DEFINE_Q35_MACHINE(v7_2, "pc-q35-7.2", NULL,
>  
>  static void pc_q35_7_1_machine_options(MachineClass *m)
>  {
> +    PCMachineClass *pcmc = PC_MACHINE_CLASS(m);
>      pc_q35_7_2_machine_options(m);
>      m->alias = NULL;
> +    pcmc->phys_bits_in_fw_cfg = false;
>      compat_props_add(m->compat_props, hw_compat_7_1, hw_compat_7_1_len);
>      compat_props_add(m->compat_props, pc_compat_7_1, pc_compat_7_1_len);
>  }
> -- 
> 2.37.3

