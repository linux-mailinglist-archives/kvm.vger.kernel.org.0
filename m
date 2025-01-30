Return-Path: <kvm+bounces-36926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E80A23097
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 15:48:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6FA2167FB3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 14:48:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 867EB1E9906;
	Thu, 30 Jan 2025 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0C5OWVu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CD71B21A9
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 14:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738248510; cv=none; b=An71aiOIpg3HuPToJkKuB90whosbhmT9lbN4nyBGWXe/m8/i5kBVUxcprZ806By6FbfgKYYU173z7nIq4dCXKR5bT1VasMKIc3vHP9ujBo1hRVxaQxl/esGoxiCdbkMdQxDFNnF8LkPkxdh7EKl7o0bHWC5VqPk1wfZSq8iPsbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738248510; c=relaxed/simple;
	bh=Gzu+MFDGmreqkWt/dYXMSo0z96X+sMrdrdHNO2H/fCI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ex1u8QXEDMXfyoe77ON2liut/zDh63rI4U7oNXbMD+pqslH1u27gsWWMeddpnJovkW40prwDaWmKmdPCTtWM394uoJDpqDKuTsIJrnm1Rl+r0WiHUXAa7wsvwceExIxCcha5cm/uGqPx712t3zegafXp4+z7daqpXgXhDhJ1OYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0C5OWVu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738248507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n5Lr94Uxd/PDC2RAizW0iDAJ1NFS67yfy8K1jTnJ41I=;
	b=P0C5OWVuL81RPn/Q10PMrTFUBld+8kQcm1DFgJ+1t6migmYMH8xqWlpGqQXWa33J6rrNBo
	ZNfemL0W+f/Gb06nUHcM5WE/cSlG/srXYQt+Pbwv7PZQtPq5MRKGwsaTIpB3MP55DHYwZ7
	Ll5Y3nr5YknNDusktQEHW788rLYF+JY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-WNabZO6eMkunIlNRttNynQ-1; Thu, 30 Jan 2025 09:48:25 -0500
X-MC-Unique: WNabZO6eMkunIlNRttNynQ-1
X-Mimecast-MFC-AGG-ID: WNabZO6eMkunIlNRttNynQ
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-436379713baso4096425e9.2
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 06:48:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738248504; x=1738853304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5Lr94Uxd/PDC2RAizW0iDAJ1NFS67yfy8K1jTnJ41I=;
        b=K3ND6SYDLzKWcSjsM+TZEMI0HIA4PZoDRPwpZhFVHM4Q4w+msf272ZtvSWgojiecFJ
         684x7eeZvfFlBLqTnK22BCH3XI6bnfUGODDHGftaH9yYJ5Wiyw8ze4Qo5EsDSWc9PpXq
         lGlIPsCn34LUH3fcW5QpDCFFkn+wIXWZFkaljPQ+e3VVcUg9EWtAqW6oDL1xan2P3VnD
         wXhXRP21zXpeVl2RWDwixhDY9efmWyouXiKu49eaZV1+uxGJ7uLTrAfoZLeY6KrDtP69
         0YFE4af7hko4P9SDPiKoGzcDnZ5GvfPHxvWT8TOVCxVgDmdVdn0e0qkPTO1+iXEvZbqB
         L8fQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI4EWxfR0XyBSJLdkssrXvm/OKmbCHLlPlWyRyHmo54XPpdgwC7nPf1xzT2fl9linq5j8=@vger.kernel.org
X-Gm-Message-State: AOJu0YznhRW8E2aEwBUfh2piRRXQZNvknztEgEb2GkZ3VlH3Hi1wrT2a
	nK31yH0qYbAPsd98r5nd87EtjZz2UQAa7YfkbjvOPg9WDj5mYfjS2VnPFcIBN1sqSY9PZOXawFM
	NY7aEm1w0Q1H+KseuL2XCreKglCEzahma3Mijl10eH7G6bHInOw==
X-Gm-Gg: ASbGnctBlgukDitf1S+UCjzUeZgkfC/p4Ise3lA4DRL2SvdAjfAXhna62GOMFSSN8+R
	Yqtw97A9CcYPStZ8dn5jsjOHYT6WAmjmpXcM6rMz2fian7n8wZQZZz2CyqpygF88ucRLok55Am/
	3MJGD5ziy0/aenxXaNso0rWvLxXPRoCXJr50iXoppP31ytlinDrpqWJ6LwVZnNf+03zGav9NjrB
	R0wEuhGjfRN7VA0iMe7H7J0vPFnXdjhY9Vpu8itFrtn0WANFJXnzf7COL0Gs+PBY7ziDNMNzS1O
	ZQiaTpi7EQtsbQLyu06fu/ka4NFKOOKYxNqMBiHzyo5e7Y+u9UXX
X-Received: by 2002:a05:600c:1c97:b0:434:9c1b:b36a with SMTP id 5b1f17b1804b1-438dc3caac1mr65403095e9.13.1738248504369;
        Thu, 30 Jan 2025 06:48:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4njYyqyDqDIXY8zdW0HIBuLJ8AWYXvGyRMhPinnT21Z8TkOvxI+2kgq3eiuuz1RBhE76vUw==
X-Received: by 2002:a05:600c:1c97:b0:434:9c1b:b36a with SMTP id 5b1f17b1804b1-438dc3caac1mr65402865e9.13.1738248503909;
        Thu, 30 Jan 2025 06:48:23 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e245f492sm25295425e9.38.2025.01.30.06.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2025 06:48:23 -0800 (PST)
Date: Thu, 30 Jan 2025 15:48:22 +0100
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
Message-ID: <20250130154822.585486e2@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250130144439.161165d4@foz.lan>
References: <cover.1738137123.git.mchehab+huawei@kernel.org>
	<f40cacd977b9eae69a5b0091d3e7a2746b2892be.1738137123.git.mchehab+huawei@kernel.org>
	<20250129155530.29455d45@imammedo.users.ipa.redhat.com>
	<20250130144439.161165d4@foz.lan>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jan 2025 14:44:39 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Em Wed, 29 Jan 2025 15:55:30 +0100
> Igor Mammedov <imammedo@redhat.com> escreveu:
> 
> > On Wed, 29 Jan 2025 09:04:14 +0100
> > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> >   
> > > Move the check logic into a common function and simplify the
> > > code which checks if GHES is enabled and was properly setup.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>    
> > 
> > with nits fixed:
> > Reviewed-by:  Igor Mammedov <imammedo@redhat.com>
> >   
> > > ---
> > >  hw/acpi/ghes-stub.c    |  7 ++++---
> > >  hw/acpi/ghes.c         | 43 ++++++++++++------------------------------
> > >  include/hw/acpi/ghes.h | 15 ++++++++-------
> > >  target/arm/kvm.c       |  8 ++++++--
> > >  4 files changed, 30 insertions(+), 43 deletions(-)
> > > 
> > > diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
> > > index 7cec1812dad9..40f660c246fe 100644
> > > --- a/hw/acpi/ghes-stub.c
> > > +++ b/hw/acpi/ghes-stub.c
> > > @@ -11,12 +11,13 @@
> > >  #include "qemu/osdep.h"
> > >  #include "hw/acpi/ghes.h"
> > >  
> > > -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> > > +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> > > +                            uint64_t physical_address)
> > >  {
> > >      return -1;
> > >  }
> > >  
> > > -bool acpi_ghes_present(void)
> > > +AcpiGhesState *acpi_ghes_get_state(void)
> > >  {
> > > -    return false;
> > > +    return NULL;
> > >  }
> > > diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> > > index 38ff95273706..849abfa12187 100644
> > > --- a/hw/acpi/ghes.c
> > > +++ b/hw/acpi/ghes.c
> > > @@ -407,18 +407,12 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
> > >          fw_cfg_add_file_callback(s, ACPI_HEST_ADDR_FW_CFG_FILE, NULL, NULL,
> > >              NULL, &(ags->hest_addr_le), sizeof(ags->hest_addr_le), false);
> > >      }
> > > -
> > > -    ags->present = true;
> > >  }
> > >  
> > >  static void get_hw_error_offsets(uint64_t ghes_addr,
> > >                                   uint64_t *cper_addr,
> > >                                   uint64_t *read_ack_register_addr)
> > >  {
> > > -    if (!ghes_addr) {
> > > -        return;
> > > -    }
> > > -
> > >      /*
> > >       * non-HEST version supports only one source, so no need to change
> > >       * the start offset based on the source ID. Also, we can't validate
> > > @@ -447,9 +441,6 @@ static void get_ghes_source_offsets(uint16_t source_id,
> > >      uint64_t err_source_entry, error_block_addr;
> > >      uint32_t num_sources, i;
> > >  
> > > -    if (!hest_entry_addr) {
> > > -        return;
> > > -    }
> > >  
> > >      cpu_physical_memory_read(hest_entry_addr, &num_sources,
> > >                               sizeof(num_sources));
> > > @@ -515,27 +506,17 @@ static void get_ghes_source_offsets(uint16_t source_id,
> > >  NotifierList acpi_generic_error_notifiers =
> > >      NOTIFIER_LIST_INITIALIZER(error_device_notifiers);
> > >  
> > > -void ghes_record_cper_errors(const void *cper, size_t len,
> > > +void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
> > >                               uint16_t source_id, Error **errp)
> > >  {
> > >      uint64_t cper_addr = 0, read_ack_register_addr = 0, read_ack_register;
> > > -    AcpiGedState *acpi_ged_state;
> > > -    AcpiGhesState *ags;
> > >  
> > >      if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> > >          error_setg(errp, "GHES CPER record is too big: %zd", len);
> > >          return;
> > >      }
> > >  
> > > -    acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> > > -                                                       NULL));
> > > -    if (!acpi_ged_state) {
> > > -        error_setg(errp, "Can't find ACPI_GED object");
> > > -        return;
> > > -    }
> > > -    ags = &acpi_ged_state->ghes_state;
> > > -
> > > -    if (!ags->hest_addr_le) {
> > > +    if (!ags->use_hest_addr) {
> > >          get_hw_error_offsets(le64_to_cpu(ags->hw_error_le),
> > >                               &cper_addr, &read_ack_register_addr);
> > >      } else {
> > > @@ -543,11 +524,6 @@ void ghes_record_cper_errors(const void *cper, size_t len,
> > >                                  &cper_addr, &read_ack_register_addr, errp);
> > >      }
> > >  
> > > -    if (!cper_addr) {
> > > -        error_setg(errp, "can not find Generic Error Status Block");
> > > -        return;
> > > -    }
> > > -
> > >      cpu_physical_memory_read(read_ack_register_addr,
> > >                               &read_ack_register, sizeof(read_ack_register));
> > >  
> > > @@ -573,7 +549,8 @@ void ghes_record_cper_errors(const void *cper, size_t len,
> > >      notifier_list_notify(&acpi_generic_error_notifiers, NULL);
> > >  }
> > >  
> > > -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> > > +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> > > +                            uint64_t physical_address)
> > >  {
> > >      /* Memory Error Section Type */
> > >      const uint8_t guid[] =
> > > @@ -599,7 +576,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> > >      acpi_ghes_build_append_mem_cper(block, physical_address);
> > >  
> > >      /* Report the error */
> > > -    ghes_record_cper_errors(block->data, block->len, source_id, &errp);
> > > +    ghes_record_cper_errors(ags, block->data, block->len, source_id, &errp);
> > >  
> > >      g_array_free(block, true);
> > >  
> > > @@ -611,7 +588,7 @@ int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
> > >      return 0;
> > >  }
> > >  
> > > -bool acpi_ghes_present(void)
> > > +AcpiGhesState *acpi_ghes_get_state(void)
> > >  {
> > >      AcpiGedState *acpi_ged_state;
> > >      AcpiGhesState *ags;
> > > @@ -620,8 +597,12 @@ bool acpi_ghes_present(void)
> > >                                                         NULL));
> > >  
> > >      if (!acpi_ged_state) {
> > > -        return false;
> > > +        return NULL;
> > >      }
> > >      ags = &acpi_ged_state->ghes_state;
> > > -    return ags->present;
> > > +
> > > +    if (!ags->hw_error_le && !ags->hest_addr_le) {    
> > 
> > should we add a warning here?
> > (consider case where firmware hasn't managed to update pointers for some reason)  
> 
> I don't think so, as this will also return NULL if ras=off. See, the
> original goal of acpi_ghes_present(void) were to avoid needing to check
> if ras is enabled outside GHES code, like here at target/arm/kvm.c:
> 
> 	void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> 	{
> 	    ram_addr_t ram_addr;
> 	    hwaddr paddr;
> 	    AcpiGhesState *ags;
> 	
> 	    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> 	
> 	    ags = acpi_ghes_get_state();
> 	    if (ags && addr) {
> ...
> 
> This new logic repurposed acpi_ghes_present() as acpi_ghes_get_state(),
> using it to full two situations:
> 
> 1) ras=on;
> 2) either hw_err_addr_le or hest_addr_le exists.
> 	  
> Except if some serious issue takes place, (2) is actually equivalent
> to check if ras is on or off.

I was thinking about hypothetical case of firmware failure to updating
fwcfg files.
But yep, it's hardly possible (unless dst target on migration is misconfigured),
just ignore this comment.


> Besides that, Error **errp is not defined yet, so we can't do this:

warn_report_once() would've done the job here.

> 
> 	error_setg(errp, "HEST/GHES pointer is not available")
> 
> > > +        return NULL;
> > > +    }
> > > +    return ags;
> > >  }
> > > diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> > > index 80a0c3fcfaca..e1b66141d01c 100644
> > > --- a/include/hw/acpi/ghes.h
> > > +++ b/include/hw/acpi/ghes.h
> > > @@ -63,7 +63,6 @@ enum AcpiGhesNotifyType {
> > >  typedef struct AcpiGhesState {
> > >      uint64_t hest_addr_le;
> > >      uint64_t hw_error_le;
> > > -    bool present; /* True if GHES is present at all on this board */
> > >      bool use_hest_addr; /* True if HEST address is present */
> > >  } AcpiGhesState;
> > >  
> > > @@ -87,15 +86,17 @@ void acpi_build_hest(AcpiGhesState *ags, GArray *table_data,
> > >                       const char *oem_id, const char *oem_table_id);
> > >  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> > >                            GArray *hardware_errors);
> > > -int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
> > > -void ghes_record_cper_errors(const void *cper, size_t len,
> > > +int acpi_ghes_memory_errors(AcpiGhesState *ags, uint16_t source_id,
> > > +                            uint64_t error_physical_addr);
> > > +void ghes_record_cper_errors(AcpiGhesState *ags, const void *cper, size_t len,
> > >                               uint16_t source_id, Error **errp);
> > >  
> > >  /**
> > > - * acpi_ghes_present: Report whether ACPI GHES table is present
> > > + * acpi_ghes_get_state: Get a pointer for ACPI ghes state
> > >   *
> > > - * Returns: true if the system has an ACPI GHES table and it is
> > > - * safe to call acpi_ghes_memory_errors() to record a memory error.
> > > + * Returns: a pointer to ghes state if the system has an ACPI GHES table,
> > > + * it is enabled and it is safe to call acpi_ghes_memory_errors() to record
> > > + * a memory error. Returns false, otherwise.
> > >   */
> > > -bool acpi_ghes_present(void);
> > > +AcpiGhesState *acpi_ghes_get_state(void);
> > >  #endif
> > > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > > index da30bdbb2349..544ff174784d 100644
> > > --- a/target/arm/kvm.c
> > > +++ b/target/arm/kvm.c
> > > @@ -2366,10 +2366,13 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> > >  {
> > >      ram_addr_t ram_addr;
> > >      hwaddr paddr;
> > > +    AcpiGhesState *ags;
> > >  
> > >      assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
> > >  
> > > -    if (acpi_ghes_present() && addr) {
> > > +    ags = acpi_ghes_get_state();    
> >   
> > > +    
> > I'd drop this newline
> >   
> > > +    if (ags && addr) {
> > >          ram_addr = qemu_ram_addr_from_host(addr);
> > >          if (ram_addr != RAM_ADDR_INVALID &&
> > >              kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> > > @@ -2387,7 +2390,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> > >               */
> > >              if (code == BUS_MCEERR_AR) {
> > >                  kvm_cpu_synchronize_state(c);
> > > -                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
> > > +                if (!acpi_ghes_memory_errors(ags, ACPI_HEST_SRC_ID_SEA,
> > > +                                             paddr)) {
> > >                      kvm_inject_arm_sea(c);
> > >                  } else {
> > >                      error_report("failed to record the error");    
> >   
> 
> 
> 
> Thanks,
> Mauro
> 


