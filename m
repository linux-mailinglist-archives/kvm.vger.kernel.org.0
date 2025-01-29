Return-Path: <kvm+bounces-36862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1268A21FCB
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 15:55:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE6EA3A54F3
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:55:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528BC1C5F2E;
	Wed, 29 Jan 2025 14:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O0xsJd4l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4331B422F
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 14:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738162537; cv=none; b=TXcs8cbmfbsxCrEi7zNlbvQVoDgzJVe/ynaHcym0Gpqd94/ySZMINoEONivQYyWqjdrYOrrIU6/PuGjkG0HZ07+Ah3yf1qYbhDCEq9pTcSIZP3Tb1AXleVwfI4XMbseekd9w1moFZzOB8my41Dln23lpCG8ojp+Iqy2j44srsYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738162537; c=relaxed/simple;
	bh=OpvV2FRBoOXqoYVkx9trWaePyZ9bhhy3z7ClzhbzshA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rTdeVTOvUOuz2XxhTG61r9nxJz/dYZOusgdAOeygb8UF7dSJrvcfujhQ7OXEPWrPkEGaxzO2/nxZ0CnLmoWTdWa4vLGEKV00DUNaQlQate9nf7W4Hf5HMTLffasIJHxBmWlmc2Hy58XjjF6+u3q07BQH7Xl8orDwkJCJo9LwXmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O0xsJd4l; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738162534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gmrRKA0ChyO0vLu9JTiC5ZPpN5pGEUANDOxIesc4B2Q=;
	b=O0xsJd4lt5H2Gy23b53vPImfXomm/B4tyBd+XMVnOIUP1FW+mTfG7hvr6mx3YOXmic2oSU
	EuZ5TJGEHw6OSZAgRCZOsWQe/58Bpk1Xy9IlZQNmwOxp5NV1AqwXJ+Ud16ynuB0v77RY4H
	6yRz/wD7RTjCv2da3xzfbAdvtA3De7A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-LKn2lv1dNeWyXJhRoiEbzA-1; Wed, 29 Jan 2025 09:55:33 -0500
X-MC-Unique: LKn2lv1dNeWyXJhRoiEbzA-1
X-Mimecast-MFC-AGG-ID: LKn2lv1dNeWyXJhRoiEbzA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38a684a0971so3162765f8f.2
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 06:55:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738162532; x=1738767332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmrRKA0ChyO0vLu9JTiC5ZPpN5pGEUANDOxIesc4B2Q=;
        b=PG30Wc/tiUFpsZ0sn6YwnAIV1NXqaV2cndoNmGgERjTtETN0o0xYBzVJbc1Bf5VryF
         mRoBanRaisenczLFLf9xVyT8LwQmj65ThNBigZ927BVSKqeePXP7Ul1BPbnN0js6HIqx
         mIX1hU1OuSS06NXv+3J3KMXjRhoa0gSmaiWcKc8UL6E9eKcQt7Y5EYJnDiBersy/0Uwp
         1qLmW0h0QhaxFtukCeZS4X7ZCfWJHvdPCwrFTS8/AmwWGMNtry4HvpBZnUP0z3ltooZi
         S44aLA/T8Uc7H6bC3LtpdMY8ybqORow6fIgJWT7nALGEJU7igGMGpih3n8V3h9oz0K0q
         Avsw==
X-Forwarded-Encrypted: i=1; AJvYcCWIbW3rBZQIpq3BPZgFgzFjjG1v/0knPfSnR19IR7BjrHpNhDuMveFqS3jgbyQAOigT1uM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxzUkqGv8xNkDAxXL7vbZUMkRfWZBWO+Zk+aXWUQOWFeW5j9tw
	hfV9e3LAqw2HGoqsvZvtujih8E/ltR3coHLRDIYS0ZU/obzDAQWRgAq0ZKhQin5WyEa0gygwbBO
	5lQwZn1wf4rF0h/rZlwltm/MbuScZXIlE16/Ewa8DZ0zTY2XDmw==
X-Gm-Gg: ASbGncsxKhUMsxZ5HlDqAEh/Y8y3ePiUzrW0lj/Cr0i64+rJxBoztkid3MgNT+b6PLu
	PyPCLT2at8bHxMSOqTKgnlk2Hehq2ICWLMmX8mhxk1seg+1Svh8Iu0A+n7Yq5zbUWwUugqg6vYK
	E53ytBe0fhTC38W2JPMiBYDFMmEsdJJm68FhhvzoiM7EtNY4Nww81IX3XRw5lfx5NQHNP3p6SGv
	1xGnrwUI0hclhFchVfyE8r+IpUciC/2MfBad5c/07cy5bfdB+q1kE4GIpWkd1gLuoc9i63T4j8c
	KQPOp8j9ZdH+VJkPc7Cm09BeQEUqs04dbHFmOScM220rBVcfV/c3
X-Received: by 2002:a05:6000:1788:b0:38b:e32a:10aa with SMTP id ffacd0b85a97d-38c51949fbamr3141506f8f.5.1738162532009;
        Wed, 29 Jan 2025 06:55:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYY802k1TNGiUZEBvWD3euMsSo6t1SQYXX3//x/iaE/8GbMeWVCUlbIuRNN6C4/ug0ihsZow==
X-Received: by 2002:a05:6000:1788:b0:38b:e32a:10aa with SMTP id ffacd0b85a97d-38c51949fbamr3141484f8f.5.1738162531533;
        Wed, 29 Jan 2025 06:55:31 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bad16sm17727837f8f.68.2025.01.29.06.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 06:55:31 -0800 (PST)
Date: Wed, 29 Jan 2025 15:55:30 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Ani Sinha
 <anisinha@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/13] acpi/ghes: Cleanup the code which gets ghes
 ged state
Message-ID: <20250129155530.29455d45@imammedo.users.ipa.redhat.com>
In-Reply-To: <f40cacd977b9eae69a5b0091d3e7a2746b2892be.1738137123.git.mchehab+huawei@kernel.org>
References: <cover.1738137123.git.mchehab+huawei@kernel.org>
	<f40cacd977b9eae69a5b0091d3e7a2746b2892be.1738137123.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jan 2025 09:04:14 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Move the check logic into a common function and simplify the
> code which checks if GHES is enabled and was properly setup.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

with nits fixed:
Reviewed-by:  Igor Mammedov <imammedo@redhat.com>

> ---
>  hw/acpi/ghes-stub.c    |  7 ++++---
>  hw/acpi/ghes.c         | 43 ++++++++++++------------------------------
>  include/hw/acpi/ghes.h | 15 ++++++++-------
>  target/arm/kvm.c       |  8 ++++++--
>  4 files changed, 30 insertions(+), 43 deletions(-)
> 
> diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> index 7cec1812dad9..40f660c246fe 100644
> --- a/hw/acpi/ghes-stub.c
> +++ b/hw/acpi/ghes-stub.c
> @@ -11,12 +11,13 @@
>  #include "qemu/osdep.h"
>  #include "hw/acpi/ghes.h"
>  
> -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> +                            uint64_t physical_address)
>  {
>      return -1;
>  }
>  
> -bool acpi_ghes_present(void)
> +AcpiGhesState *acpi_ghes_get_state(void)
>  {
> -    return false;
> +    return NULL;
>  }
> diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> index 38ff95273706..849abfa12187 100644
> --- a/hw/acpi/ghes.c
> +++ b/hw/acpi/ghes.c
> @@ -407,18 +407,12 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
>          fw_cfg_add_file_callback(s, ACPI_HEST_ADDR_FW_CFG_FILE, NULL, NULL,
>              NULL, &(ags->hest_addr_le), sizeof(ags->hest_addr_le), false);
>      }
> -
> -    ags->present = true;
>  }
>  
>  static void get_hw_error_offsets(uint64_t ghes_addr,
>                                   uint64_t *cper_addr,
>                                   uint64_t *read_ack_register_addr)
>  {
> -    if (!ghes_addr) {
> -        return;
> -    }
> -
>      /*
>       * non-HEST version supports only one source, so no need to change
>       * the start offset based on the source ID. Also, we can't validate
> @@ -447,9 +441,6 @@ static void get_ghes_source_offsets(uint16_t source_id,
>      uint64_t err_source_entry, error_block_addr;
>      uint32_t num_sources, i;
>  
> -    if (!hest_entry_addr) {
> -        return;
> -    }
>  
>      cpu_physical_memory_read(hest_entry_addr, &num_sources,
>                               sizeof(num_sources));
> @@ -515,27 +506,17 @@ static void get_ghes_source_offsets(uint16_t source_id,
>  NotifierList acpi_generic_error_notifiers =
>      NOTIFIER_LIST_INITIALIZER(error_device_notifiers);
>  
> -void ghes_record_cper_errors(const void *cper, size_t len,
> +void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
>                               uint16_t source_id, Error **errp)
>  {
>      uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
> -    AcpiGedState *acpi_ged_state;
> -    AcpiGhesState *ags;
>  
>      if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
>          error_setg(errp, "GHES CPER record is too big: %zd", len);
>          return;
>      }
>  
> -    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> -                                                       NULL));
> -    if (!acpi_ged_state) {
> -        error_setg(errp, "Can't find ACPI_GED object");
> -        return;
> -    }
> -    ags = &acpi_ged_state->ghes_state;
> -
> -    if (!ags->hest_addr_le) {
> +    if (!ags->use_hest_addr) {
>          get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
>                               &cper_addr, &read_ack_register_addr);
>      } else {
> @@ -543,11 +524,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>                                  &cper_addr, &read_ack_register_addr, errp);
>      }
>  
> -    if (!cper_addr) {
> -        error_setg(errp, "can not find Generic Error Status Block");
> -        return;
> -    }
> -
>      cpu_physical_memory_read(read_ack_register_addr,
>                               &read_ack_register, sizeof(read_ack_register));
>  
> @@ -573,7 +549,8 @@ void ghes_record_cper_errors(const void *cper, size_t len,
>      notifier_list_notify(&acpi_generic_error_notifiers, NULL);
>  }
>  
> -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> +                            uint64_t physical_address)
>  {
>      /* Memory Error Section Type */
>      const uint8_t guid[] =
> @@ -599,7 +576,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>      acpi_ghes_build_append_mem_cper(block, physical_address);
>  
>      /* Report the error */
> -    ghes_record_cper_errors(block->data, block->len, source_id, &errp);
> +    ghes_record_cper_errors(ags, block->data, block->len, source_id, &errp);
>  
>      g_array_free(block, true);
>  
> @@ -611,7 +588,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
>      return 0;
>  }
>  
> -bool acpi_ghes_present(void)
> +AcpiGhesState *acpi_ghes_get_state(void)
>  {
>      AcpiGedState *acpi_ged_state;
>      AcpiGhesState *ags;
> @@ -620,8 +597,12 @@ bool acpi_ghes_present(void)
>                                                         NULL));
>  
>      if (!acpi_ged_state) {
> -        return false;
> +        return NULL;
>      }
>      ags = &acpi_ged_state->ghes_state;
> -    return ags->present;
> +
> +    if (!ags->hw_error_le && !ags->hest_addr_le) {

should we add a warning here?
(consider case where firmware hasn't managed to update pointers for some reason)

> +        return NULL;
> +    }
> +    return ags;
>  }
> diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> index 80a0c3fcfaca..e1b66141d01c 100644
> --- a/include/hw/acpi/ghes.h
> +++ b/include/hw/acpi/ghes.h
> @@ -63,7 +63,6 @@ enum AcpiGhesNotifyType {
>  typedef struct AcpiGhesState {
>      uint64_t hest_addr_le;
>      uint64_t hw_error_le;
> -    bool present; /* True if GHES is present at all on this board */
>      bool use_hest_addr; /* True if HEST address is present */
>  } AcpiGhesState;
>  
> @@ -87,15 +86,17 @@ void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
>                       const char *oem_id, const char *oem_table_id);
>  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
>                            GArray *hardware_errors);
> -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
> -void ghes_record_cper_errors(const void *cper, size_t len,
> +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> +                            uint64_t error_physical_addr);
> +void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
>                               uint16_t source_id, Error **errp);
>  
>  /**
> - * acpi_ghes_present: Report whether ACPI GHES table is present
> + * acpi_ghes_get_state: Get a pointer for ACPI ghes state
>   *
> - * Returns: true if the system has an ACPI GHES table and it is
> - * safe to call acpi_ghes_memory_errors() to record a memory error.
> + * Returns: a pointer to ghes state if the system has an ACPI GHES table,
> + * it is enabled and it is safe to call acpi_ghes_memory_errors() to record
> + * a memory error. Returns false, otherwise.
>   */
> -bool acpi_ghes_present(void);
> +AcpiGhesState *acpi_ghes_get_state(void);
>  #endif
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index da30bdbb2349..544ff174784d 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -2366,10 +2366,13 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>  {
>      ram_addr_t ram_addr;
>      hwaddr paddr;
> +    AcpiGhesState *ags;
>  
>      assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
>  
> -    if (acpi_ghes_present() && addr) {
> +    ags = acpi_ghes_get_state();

> +
I'd drop this newline

> +    if (ags && addr) {
>          ram_addr = qemu_ram_addr_from_host(addr);
>          if (ram_addr != RAM_ADDR_INVALID &&
>              kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> @@ -2387,7 +2390,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
>               */
>              if (code == BUS_MCEERR_AR) {
>                  kvm_cpu_synchronize_state(c);
> -                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> +                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
> +                                             paddr)) {
>                      kvm_inject_arm_sea(c);
>                  } else {
>                      error_report("failed to record the error");


