Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798856F3142
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjEAMz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjEAMz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:55:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC3810D3
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xgdmqBY0YjJMLmIVk6Rr3PdJT6nU128ngcp31lhBDX4=;
        b=ITPOAtNnpVNwNYr9ddPdxZD1NrpaKinEkaXqHPdsglvz/4PhFqGBxGem8FJJnk4q/unas5
        nN52H864GrUzAAHC98livPjh5HZq4ti78dzg8iQdg8otQ0N8Srva0+8AjdxcHSSCZh2YGV
        CWs9eCyK/r+bnOp51QyLUK4BaWG3yPY=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-H_SXIar4OkmObFsLcGfgEQ-1; Mon, 01 May 2023 08:54:36 -0400
X-MC-Unique: H_SXIar4OkmObFsLcGfgEQ-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-517f0c08dfaso388866a12.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945676; x=1685537676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgdmqBY0YjJMLmIVk6Rr3PdJT6nU128ngcp31lhBDX4=;
        b=W/CPmC2nJ/NHRxKgGcUSSmKFkZfixzrOI8shA/fFxYCuP1Ba8HclZjKvUDNcL2AEqF
         iNMzfk4bHu+oG8VHmWozBPi8I0iNPtI2l35kEVAkrB21EDKiu7XnLMucn8BHrUMIuNat
         7J9peZKMNu7fqMOTqcQ3yYcQbFGRsAobxCT+3z2LthvywATflxnax9kO0/kwApGXKrQS
         a+XQWtCC5ruhaHYRUXM3M/ZBe0DuP4pQ0uwKnZv/zuXbEUq1AfvB9o9Wjs0k9aqjwZvE
         JXCtpYkv98Jy/0cjgf2W41TT5BjtfLXNoezn7ikwPHTyS6ZmcTwh94QkTQv31Tq7TZxR
         v1qA==
X-Gm-Message-State: AC+VfDxvavNi4W4c+jazdrMvc3bu4ekLhAeyj5lRqw7TbV5NUo0CGqFE
        HGlFwvzzYNzW9zorHqQWZKKUTanV0hYoZMZBKbnzblQ96Rs8uQowq9gLVDI38CE8hkBt8RR/lob
        z11p/s85P18b0vKNL5Pd2ZUU7+A==
X-Received: by 2002:a17:902:d481:b0:1a0:53ba:ff1f with SMTP id c1-20020a170902d48100b001a053baff1fmr16476722plg.0.1682945675717;
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4J+QM0YnCda+sWscx2w8AQROtBQpbpmp8HjRM9lsCt7CrVjf5kKI/bjaojW6SytadGqh2NNw==
X-Received: by 2002:a17:902:d481:b0:1a0:53ba:ff1f with SMTP id c1-20020a170902d48100b001a053baff1fmr16476709plg.0.1682945675446;
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902dac500b00199203a4fa3sm6381858plx.203.2023.05.01.05.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:54:35 -0700 (PDT)
Message-ID: <70a380b5-b97c-2e39-d91f-c1bfa76e1521@redhat.com>
Date:   Mon, 1 May 2023 20:54:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 11/29] arm64: Add support for setting up
 the PSCI conduit through ACPI
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-12-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-12-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/23 20:03, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the FADT to discover whether PSCI calls need to use smc or hvc
> calls. This change implements this but retains the default behavior;
> we check if a valid DT is provided, if not, we try to setup the PSCI
> conduit using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arm/Makefile.arm64 |  4 ++++
>   lib/acpi.h         |  5 +++++
>   lib/arm/psci.c     | 37 ++++++++++++++++++++++++++++++++++++-
>   3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 42e18e77..6dff6cad 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -25,6 +25,10 @@ cflatobjs += lib/arm64/processor.o
>   cflatobjs += lib/arm64/spinlock.o
>   cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>   
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs += lib/acpi.o
> +endif
> +
>   OBJDIRS += lib/arm64
>   
>   # arm64 specific tests
> diff --git a/lib/acpi.h b/lib/acpi.h
> index b714677e..ef4a8e1d 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -129,6 +129,11 @@ struct acpi_table_fadt {
>   	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
>   };
>   
> +/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) ACPI 5.1 */
> +
> +#define ACPI_FADT_PSCI_COMPLIANT    (1)	/* 00: [V5+] PSCI 0.2+ is implemented */
> +#define ACPI_FADT_PSCI_USE_HVC      (1<<1)	/* 01: [V5+] HVC must be used instead of SMC as the PSCI conduit */
> +
>   struct acpi_table_facs_rev1 {
>   	u32 signature;		/* ACPI Signature */
>   	u32 length;		/* Length of structure, in bytes */
> diff --git a/lib/arm/psci.c b/lib/arm/psci.c
> index 9c031a12..bddb0787 100644
> --- a/lib/arm/psci.c
> +++ b/lib/arm/psci.c
> @@ -56,7 +56,7 @@ void psci_system_off(void)
>   	printf("CPU%d unable to do system off (error = %d)\n", smp_processor_id(), err);
>   }
>   
> -void psci_set_conduit(void)
> +static void psci_set_conduit_fdt(void)
>   {
>   	const void *fdt = dt_fdt();
>   	const struct fdt_property *method;
> @@ -75,3 +75,38 @@ void psci_set_conduit(void)
>   	else
>   		assert_msg(false, "Unknown PSCI conduit: %s", method->data);
>   }
> +
> +#ifdef CONFIG_EFI
> +
> +#include <acpi.h>
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +
> +	assert_msg(fadt, "Unable to find ACPI FADT");
> +	assert_msg(fadt->arm_boot_flags & ACPI_FADT_PSCI_COMPLIANT,
> +		   "PSCI is not supported in this platform");
> +
> +	if (fadt->arm_boot_flags & ACPI_FADT_PSCI_USE_HVC)
> +		psci_invoke = psci_invoke_hvc;
> +	else
> +		psci_invoke = psci_invoke_smc;
> +}
> +
> +#else
> +
> +static void psci_set_conduit_acpi(void)
> +{
> +	assert_msg(false, "ACPI not available");
> +}
> +
> +#endif
> +
> +void psci_set_conduit(void)
> +{
> +	if (dt_available())
> +		psci_set_conduit_fdt();
> +	else
> +		psci_set_conduit_acpi();
> +}

-- 
Shaoqin

