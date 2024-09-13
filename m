Return-Path: <kvm+bounces-26826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90AD97849E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:21:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A89632837A1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF1B280C13;
	Fri, 13 Sep 2024 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkw+oQ3H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AA580BF8;
	Fri, 13 Sep 2024 15:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726240457; cv=none; b=e+m7lYNWKXXc/TOeY6aJv692dYhzlgcExTIKu5+jWWidEF0ayrjuBmiEL3cvdEdt69RLR5X+c7TmFYDp1xE2qfVjxPPWqy4kLg/FWL4TwG4B3Zz6Y7dFr1TCy66Nd83TwKAZY1wZWeCsLK6SKU+is406Sqw7/XD1iuFNdUpJChs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726240457; c=relaxed/simple;
	bh=wJogLjKRTRK+fhFgpvBnsWTVc3GmDsIavIppBdMXDuU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bKjkK5FGDrTU1+r3Bw4RBZHLfmq8bQDlOGWRPOh99wgXY7u9qTA2+Cpu0NBE9zIgPv7zq0Oomjg7tztWrgNstqQ7TtehzeM3sVEddTidjiYOkVNDll5yYgPOwUX2EojnqHQWAnjrcOjfE4jplpldg3Vtj10Mi/Sn3nH+h2QvArQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkw+oQ3H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D094C4CEC0;
	Fri, 13 Sep 2024 15:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726240457;
	bh=wJogLjKRTRK+fhFgpvBnsWTVc3GmDsIavIppBdMXDuU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hkw+oQ3HBZzrnwBqDDSSXA/BUiveIL1PMM2w7sAtGK2Wqdp2vLng+6h7ecVwkuFlO
	 Nwussye2DTXBqictUJhYPOW4UsMkq+YB6KJYY5HJmXz8UeoHMi26PkOwyShwIwLkdY
	 pRkOBy+Q0Z1BHcH/YfReEzYhu4D2iI9jVp6Oe7j1snh7YLxerg1+PHLeMB5f2B0m3H
	 7G2sbf2ToA3DFCORXYJgxYeSHH+mUYruCv52J4LRmwKOn1yKDU8O3E6aLcOnhHc4zT
	 4yk60iheLwDXrgki6F0LKGDjlWJ3gbjwtLOqt+Xgb4Mmag3ieF33/N2ujxpWND4sKt
	 YjORa+uPhqiag==
Date: Fri, 13 Sep 2024 17:14:12 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, qemu-arm@nongnu.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v9 02/12] acpi/ghes: rework the logic to handle HEST
 source ID
Message-ID: <20240913171412.1a3dc701@foz.lan>
In-Reply-To: <20240911170157.792225ef@imammedo.users.ipa.redhat.com>
References: <cover.1724556967.git.mchehab+huawei@kernel.org>
	<de67e08436e6903579f4fdc6beee7a5bc2696303.1724556967.git.mchehab+huawei@kernel.org>
	<20240911170157.792225ef@imammedo.users.ipa.redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Wed, 11 Sep 2024 17:01:57 +0200
Igor Mammedov <imammedo@redhat.com> escreveu:

> On Sun, 25 Aug 2024 05:45:57 +0200
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > The current logic is based on a lot of duct tape, with
> > offsets calculated based on one define with the number of
> > source IDs and an enum.
> > 
> > Rewrite the logic in a way that it would be more resilient
> > of code changes, by moving the source ID count to an enum
> > and make the offset calculus more explicit.
> > 
> > Such change was inspired on a patch from Jonathan Cameron
> > splitting the logic to get the CPER address on a separate
> > function, as this will be needed to support generic error
> > injection.  
> 
> patch is too large and does too many things at once,
> see inline suggestions on how to split it in more
> manageable chunks.
> (I'll mark preferred patch order with numbers)

I ended adding more patches to make changes more logic.

> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > 
> > ---
> > 
> > Changes from v8:
> > - Non-rename/cleanup changes merged altogether;
> > - source ID is now more generic, defined per guest target.
> >   That should make easier to add support for 86.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  hw/acpi/ghes.c           | 275 ++++++++++++++++++++++++---------------
> >  hw/arm/virt-acpi-build.c |  10 +-
> >  include/hw/acpi/ghes.h   |  18 +--
> >  include/hw/arm/virt.h    |   7 +
> >  target/arm/kvm.c         |   3 +-
> >  5 files changed, 198 insertions(+), 115 deletions(-)
> > 
> > diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
> > index 529c14e3289f..965fb1b36587 100644
> > --- a/hw/acpi/ghes.c
> > +++ b/hw/acpi/ghes.c
> > @@ -35,9 +35,6 @@
> >  /* The max size in bytes for one error block */
> >  #define ACPI_GHES_MAX_RAW_DATA_LENGTH   (1 * KiB)
> >  
> > -/* Now only support ARMv8 SEA notification type error source */
> > -#define ACPI_GHES_ERROR_SOURCE_COUNT        1  
> 
>  [patch 4] getting rid of this and introducing num_sources
>      (aka variable size HEST) 

ok.

> 
> >  /* Generic Hardware Error Source version 2 */
> >  #define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
> >  
> > @@ -64,6 +61,19 @@
> >   */
> >  #define ACPI_GHES_GESB_SIZE                 20
> >  
> > +/*
> > + * Offsets with regards to the start of the HEST table stored at
> > + * ags->hest_addr_le, according with the memory layout map at
> > + * docs/specs/acpi_hest_ghes.rst.
> > + */  
> perhaps  mention in comment/commit message, that hest lookup
> is implemented only GHESv2 error sources.

Ok, will add a comment, but IMO, it fits better at the routine which
handles HEST error sources, so I added this there:

    /*
     * Currently, HEST Error source navigates only for GHESv2 tables
     */
    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
        uint64_t addr = err_source_struct;
        uint16_t type, src_id;
   ... 

> 
> That will work as far we do forward migration only
> (i.e. old qemu -> new qemu), which is what upstream supports.
> 
> However it won't work for backward migration (new qemu -> old qemu)
> since old one doesn't know about new non-GHESv2 sources.
> And that means we would need to introduce compat knobs for every
> new non-GHESv2 source is added. Which is easy to overlook and
> it adds up to maintenance.
> (You've already described zoo of types ACPI spec has in v8 review,
> but I don't thing it's too complex to implement lookup of all
> known types. compared to headache we would have with compat
> settings if anyone remembers)
> 
> I won't insist on adding all known sources lookup in this series,
> if you agree to do it as a patch on top of this series within this
> dev cycle (~2 months time-frame).

Seems fine to me to place it at the dev cycle.

> > +/* ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2 */  
> 
>  +  ,Table 18-383
> 
> > +#define HEST_GHES_V2_TABLE_SIZE  92
> > +#define GHES_ACK_OFFSET          (64 + GAS_ADDR_OFFSET)
> > +
> > +/* ACPI 6.2: 18.3.2.7: Generic Hardware Error Source */  
>      
>    Table 18-380 'Error Status Address' field 

Actually on ACPI 6.2, those tables are 18-382 and 18-379.

I'll change the above to reflect that:

/* ACPI 6.2: 18.3.2.8 Generic Hardware Error Source version 2
 * Table 18-382 Generic Hardware Error Source version 2 (GHESv2) Structure
 */
#define HEST_GHES_V2_TABLE_SIZE  92
#define GHES_ACK_OFFSET          (64 + GAS_ADDR_OFFSET)

/* ACPI 6.2: 18.3.2.7: Generic Hardware Error Source
 * Table 18-379: 'Error Status Address' field

> 
> > +#define GHES_ERR_ST_ADDR_OFFSET  (20 + GAS_ADDR_OFFSET)
> > +
> >  /*
> >   * Values for error_severity field
> >   */
> > @@ -185,51 +195,30 @@ static void acpi_ghes_build_append_mem_cper(GArray *table,
> >      build_append_int_noprefix(table, 0, 7);
> >  }
> >  
> > -static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> > -                                      uint64_t error_physical_addr)
> > +static void
> > +ghes_gen_err_data_uncorrectable_recoverable(GArray *block,
> > +                                            const uint8_t *section_type,
> > +                                            int data_length)  
>   [patch 2] splitting acpi_ghes_record_mem_error() on reusable and mem specific
>            code

Ok, will move to a separate patch after this one.

> 
> >  {
> > -    GArray *block;
> > -
> > -    /* Memory Error Section Type */
> > -    const uint8_t uefi_cper_mem_sec[] =
> > -          UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
> > -                  0xED, 0x7C, 0x83, 0xB1);
> > -
> >      /* invalid fru id: ACPI 4.0: 17.3.2.6.1 Generic Error Data,
> >       * Table 17-13 Generic Error Data Entry
> >       */
> >      QemuUUID fru_id = {};
> > -    uint32_t data_length;
> >  
> > -    block = g_array_new(false, true /* clear */, 1);
> > -
> > -    /* This is the length if adding a new generic error data entry*/
> > -    data_length = ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH;
> >      /*
> > -     * It should not run out of the preallocated memory if adding a new generic
> > -     * error data entry
> > +     * Calculate the size with this block. No need to check for
> > +     * too big CPER, as CPER size is checked at ghes_record_cper_errors()
> >       */
> > -    assert((data_length + ACPI_GHES_GESB_SIZE) <=
> > -            ACPI_GHES_MAX_RAW_DATA_LENGTH);
> > +    data_length += ACPI_GHES_GESB_SIZE;
> >  
> >      /* Build the new generic error status block header */
> >      acpi_ghes_generic_error_status(block, ACPI_GEBS_UNCORRECTABLE,
> >          0, 0, data_length, ACPI_CPER_SEV_RECOVERABLE);
> >  
> >      /* Build this new generic error data entry header */
> > -    acpi_ghes_generic_error_data(block, uefi_cper_mem_sec,
> > +    acpi_ghes_generic_error_data(block, section_type,
> >          ACPI_CPER_SEV_RECOVERABLE, 0, 0,
> >          ACPI_GHES_MEM_CPER_LENGTH, fru_id, 0);
> > -
> > -    /* Build the memory section CPER for above new generic error data entry */
> > -    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
> > -
> > -    /* Write the generic error data entry into guest memory */
> > -    cpu_physical_memory_write(error_block_address, block->data, block->len);
> > -
> > -    g_array_free(block, true);
> > -
> > -    return 0;
> >  }
> >  
> >  /*
> > @@ -237,17 +226,18 @@ static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> >   * Initialize "etc/hardware_errors" and "etc/hardware_errors_addr" fw_cfg blobs.
> >   * See docs/specs/acpi_hest_ghes.rst for blobs format.
> >   */
> > -void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
> > +static void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker,
> > +                                   int num_sources)
> >  {
> >      int i, error_status_block_offset;
> >  
> >      /* Build error_block_address */
> > -    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +    for (i = 0; i < num_sources; i++) {
> >          build_append_int_noprefix(hardware_errors, 0, sizeof(uint64_t));
> >      }
> >  
> >      /* Build read_ack_register */
> > -    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +    for (i = 0; i < num_sources; i++) {
> >          /*
> >           * Initialize the value of read_ack_register to 1, so GHES can be
> >           * writable after (re)boot.
> > @@ -262,13 +252,13 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
> >  
> >      /* Reserve space for Error Status Data Block */
> >      acpi_data_push(hardware_errors,
> > -        ACPI_GHES_MAX_RAW_DATA_LENGTH * ACPI_GHES_ERROR_SOURCE_COUNT);
> > +        ACPI_GHES_MAX_RAW_DATA_LENGTH * num_sources);
> >  
> >      /* Tell guest firmware to place hardware_errors blob into RAM */
> >      bios_linker_loader_alloc(linker, ACPI_GHES_ERRORS_FW_CFG_FILE,
> >                               hardware_errors, sizeof(uint64_t), false);
> >  
> > -    for (i = 0; i < ACPI_GHES_ERROR_SOURCE_COUNT; i++) {
> > +    for (i = 0; i < num_sources; i++) {
> >          /*
> >           * Tell firmware to patch error_block_address entries to point to
> >           * corresponding "Generic Error Status Block"  
> 
> > @@ -283,14 +273,20 @@ void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker)
> >       * tell firmware to write hardware_errors GPA into
> >       * hardware_errors_addr fw_cfg, once the former has been initialized.
> >       */
> > -    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE,
> > -        0, sizeof(uint64_t), ACPI_GHES_ERRORS_FW_CFG_FILE, 0);
> > +    bios_linker_loader_write_pointer(linker, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, 0,
> > +                                     sizeof(uint64_t),
> > +                                     ACPI_GHES_ERRORS_FW_CFG_FILE, 0);  
> 
>  [patch 1] all indent changes in its own patch, or just drop them altogether 

I'll drop the pure reformat changes from this patch. They'll
be placed at the patches that rename ACPI_GHES_*_FW_CFG_*.

Same for other occurrences.

> >
...
> >      /*
> >       * Read Ack Preserve field
> > @@ -360,19 +350,28 @@ static void build_ghes_v2(GArray *table_data, int source_id, BIOSLinker *linker)
> >  }
> >  
> >  /* Build Hardware Error Source Table */
> > -void acpi_build_hest(GArray *table_data, BIOSLinker *linker,
> > +void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
> > +                     BIOSLinker *linker,
> > +                     const uint16_t * const notify,
> > +                     int num_sources,
> >                       const char *oem_id, const char *oem_table_id)
> >  {
> >      AcpiTable table = { .sig = "HEST", .rev = 1,
> >                          .oem_id = oem_id, .oem_table_id = oem_table_id };
> > +    int i;
> > +
> > +    build_ghes_error_table(hardware_errors, linker, num_sources);
> >  
> >      acpi_table_begin(&table, table_data);
> >  
> > +    /* Beginning at the HEST Error Source struct count and data */
> >      int hest_offset = table_data->len;
> >  
> >      /* Error Source Count */
> > -    build_append_int_noprefix(table_data, ACPI_GHES_ERROR_SOURCE_COUNT, 4);
> > -    build_ghes_v2(table_data, ACPI_HEST_SRC_ID_SEA, linker);
> > +    build_append_int_noprefix(table_data, num_sources, 4);
> > +    for (i = 0; i < num_sources; i++) {
> > +        build_ghes_v2(table_data, linker, notify[i], i, num_sources);
> > +    }
> >  
> >      acpi_table_end(linker, &table);
> >  
> > @@ -403,60 +402,132 @@ void acpi_ghes_add_fw_cfg(AcpiGhesState *ags, FWCfgState *s,
> >      ags->present = true;
> >  }
> >  
> > -int acpi_ghes_record_errors(uint8_t source_id, uint64_t physical_address)
> > +void ghes_record_cper_errors(const void *cper, size_t len,
> > +                             uint16_t source_id, Error **errp)  
> 
>  [patch 3] switching to hest source id lookup method

Ok.

> >  {
> > -    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
> > -    uint64_t start_addr;
> > -    bool ret = -1;
> > +    uint64_t hest_read_ack_start_addr, read_ack_start_addr;
> > +    uint64_t hest_addr, cper_addr, err_source_struct;
> > +    uint64_t hest_err_block_addr, error_block_addr;
> > +    uint32_t num_sources, i;
> >      AcpiGedState *acpi_ged_state;
> >      AcpiGhesState *ags;
> > +    uint64_t read_ack;
> >  
> > -    assert(source_id < ACPI_HEST_SRC_ID_RESERVED);
> > +    if (len > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> > +        error_setg(errp, "GHES CPER record is too big: %ld", len);
> > +    }
> >  
> >      acpi_ged_state = ACPI_GED(object_resolve_path_type("", TYPE_ACPI_GED,
> >                                                         NULL));
> >      g_assert(acpi_ged_state);
> >      ags = &acpi_ged_state->ghes_state;
> >  
> > -    start_addr = le64_to_cpu(ags->ghes_addr_le);
> > -
> > -    if (physical_address) {
> > -
> > -        if (source_id < ACPI_HEST_SRC_ID_RESERVED) {
> > -            start_addr += source_id * sizeof(uint64_t);
> > -        }
> > -
> > -        cpu_physical_memory_read(start_addr, &error_block_addr,
> > -                                 sizeof(error_block_addr));
> > -
> > -        error_block_addr = le64_to_cpu(error_block_addr);
> > -
> > -        read_ack_register_addr = start_addr +
> > -            ACPI_GHES_ERROR_SOURCE_COUNT * sizeof(uint64_t);
> > -
> > -        cpu_physical_memory_read(read_ack_register_addr,
> > -                                 &read_ack_register, sizeof(read_ack_register));
> > -
> > -        /* zero means OSPM does not acknowledge the error */
> > -        if (!read_ack_register) {
> > -            error_report("OSPM does not acknowledge previous error,"
> > -                " so can not record CPER for current error anymore");
> > -        } else if (error_block_addr) {
> > -            read_ack_register = cpu_to_le64(0);
> > -            /*
> > -             * Clear the Read Ack Register, OSPM will write it to 1 when
> > -             * it acknowledges this error.
> > -             */
> > -            cpu_physical_memory_write(read_ack_register_addr,
> > -                &read_ack_register, sizeof(uint64_t));
> > -
> > -            ret = acpi_ghes_record_mem_error(error_block_addr,
> > -                                             physical_address);
> > -        } else
> > -            error_report("can not find Generic Error Status Block");
> > +    hest_addr = le64_to_cpu(ags->hest_addr_le);
> > +
> > +    cpu_physical_memory_read(hest_addr, &num_sources, sizeof(num_sources));
> > +
> > +    if (source_id >= num_sources) {
> > +        error_setg(errp,
> > +                   "GHES: Source %d not found. Only %d sources are defined",
> > +                   source_id, num_sources);
> > +        return;
> > +    }
> > +    err_source_struct = hest_addr + sizeof(num_sources);
> > +
> > +    for (i = 0; i < num_sources; i++) {
> > +        uint64_t addr = err_source_struct;
> > +        uint16_t type, src_id;
> > +
> > +        cpu_physical_memory_read(addr, &type, sizeof(type));
> > +
> > +        /* For now, we only know the size of GHESv2 table */
> > +        assert(type == ACPI_GHES_SOURCE_GENERIC_ERROR_V2);
> > +
> > +        /* It is GHES. Compare CPER source address */
> > +        addr += sizeof(type);
> > +        cpu_physical_memory_read(addr, &src_id, sizeof(src_id));
> > +
> > +        if (src_id == source_id)
> > +            break;
> > +
> > +        err_source_struct += HEST_GHES_V2_TABLE_SIZE;
> > +    }
> > +    if (i == num_sources) {
> > +        error_setg(errp, "HEST: Source %d not found.", source_id);
> > +        return;
> > +    }
> > +
> > +    /* Check if BIOS addr pointers were properly generated */
> > +
> > +    hest_err_block_addr = err_source_struct + GHES_ERR_ST_ADDR_OFFSET;
> > +    hest_read_ack_start_addr = err_source_struct + GHES_ACK_OFFSET;
> > +
> > +    cpu_physical_memory_read(hest_err_block_addr, &error_block_addr,
> > +                             sizeof(error_block_addr));
> > +
> > +    cpu_physical_memory_read(error_block_addr, &cper_addr,
> > +                             sizeof(error_block_addr));
> > +
> > +    cpu_physical_memory_read(hest_read_ack_start_addr, &read_ack_start_addr,
> > +			     sizeof(read_ack_start_addr));
> > +
> > +    /* Update ACK offset to notify about a new error */
> > +
> > +    cpu_physical_memory_read(read_ack_start_addr,
> > +                             &read_ack, sizeof(read_ack));
> > +
> > +    /* zero means OSPM does not acknowledge the error */
> > +    if (!read_ack) {
> > +        error_setg(errp,
> > +                   "Last CPER record was not acknowledged yet");
> > +        read_ack = 1;
> > +        cpu_physical_memory_write(read_ack_start_addr,
> > +                                  &read_ack, sizeof(read_ack));
> > +        return;
> > +    }
> > +
> > +    read_ack = cpu_to_le64(0);
> > +    cpu_physical_memory_write(read_ack_start_addr,
> > +                              &read_ack, sizeof(read_ack));
> > +
> > +    /* Write the generic error data entry into guest memory */
> > +    cpu_physical_memory_write(cper_addr, cper, len);
> > +}
> > +
> > +int acpi_ghes_record_errors(int source_id, uint64_t physical_address)
> > +{
> > +    /* Memory Error Section Type */
> > +    const uint8_t guid[] =
> > +          UUID_LE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
> > +                  0xED, 0x7C, 0x83, 0xB1);
> > +    Error *errp = NULL;
> > +    GArray *block;
> > +
> > +    if (!physical_address) {
> > +        error_report("can not find Generic Error Status Block for source id %d",
> > +                     source_id);
> > +        return -1;
> > +    }
> > +
> > +    block = g_array_new(false, true /* clear */, 1);
> > +
> > +    ghes_gen_err_data_uncorrectable_recoverable(block, guid,
> > +                                                ACPI_GHES_MAX_RAW_DATA_LENGTH);
> > +
> > +    /* Build the memory section CPER for above new generic error data entry */
> > +    acpi_ghes_build_append_mem_cper(block, physical_address);
> > +
> > +    /* Report the error */
> > +    ghes_record_cper_errors(block->data, block->len, source_id, &errp);
> > +
> > +    g_array_free(block, true);
> > +
> > +    if (errp) {
> > +        error_report_err(errp);
> > +        return -1;
> >      }
> >  
> > -    return ret;
> > +    return 0;
> >  }
> >  
> >  bool acpi_ghes_present(void)
> > diff --git a/hw/arm/virt-acpi-build.c b/hw/arm/virt-acpi-build.c
> > index f76fb117adff..39100c2822c2 100644
> > --- a/hw/arm/virt-acpi-build.c
> > +++ b/hw/arm/virt-acpi-build.c
> > @@ -890,6 +890,10 @@ static void acpi_align_size(GArray *blob, unsigned align)
> >      g_array_set_size(blob, ROUND_UP(acpi_data_len(blob), align));
> >  }
> >  
> > +static const uint16_t hest_ghes_notify[] = {
> > +    [ARM_ACPI_HEST_SRC_ID_SEA] = ACPI_GHES_NOTIFY_SEA,
> > +};  
> 
> I agree that machine/platform shall opt in for a specific source id,
> but I'm not sure about whether we need platform specific source ids,
> it seems to complicate things needlessly.
>
> For example if one would define different src_id for error injection
> for ARM and X86, then we would somehow need to take that in account
> when QMP command X called so it would use correct ID
>
> Maybe this needs it's own patch with a commit message that
> would explain need for this approach (but so far I'm not seeing the point).
> 
> PS:
> I'd prefer common/shared SRC_ID registry, from which boards would pick
> applicable ones.

I'll use a different approach, adding this to ghes.h:

	/*
	 * ID numbers used to fill HEST source ID field
	 */
	enum AcpiGhesSourceID {
	    ACPI_HEST_SRC_ID_SYNC,
	    ACPI_HEST_SRC_ID_QMP,       /* Use it only for QMP injected errors */
	};

	typedef struct AcpiNotificationSourceId {
	    enum AcpiGhesSourceID source_id;
	    enum AcpiGhesNotifyType notify;
	} AcpiNotificationSourceId;

And, at the binding logic (at arm/virt-acpi-build):

	static const AcpiNotificationSourceId hest_ghes_notify[] = {
	    {ACPI_HEST_SRC_ID_SYNC, ACPI_GHES_NOTIFY_SEA},
	    {ACPI_HEST_SRC_ID_QMP, ACPI_GHES_NOTIFY_GPIO},
	};
	...
	acpi_build_hest(tables_blob, tables->hardware_errors, tables->linker,
                        hest_ghes_notify, sizeof(hest_ghes_notify),
                        vms->oem_id, vms->oem_table_id);

For x86, with just QMP implemented, this will be:

	static const AcpiNotificationSourceId hest_ghes_notify[] = {
	    {ACPI_HEST_SRC_ID_QMP, ACPI_GHES_NOTIFY_SCI},
	};
	...
	acpi_build_hest(tables_blob, tables->hardware_errors, tables->linker,
                        hest_ghes_notify, sizeof(hest_ghes_notify),
                        vms->oem_id, vms->oem_table_id);

As the current logic doesn't assume anymore that source_id is an
index, but instead searches for it along the error structures,
such logic works fine and allows each arch to define what IDs
they'll use and what notification is associated to each one of
them.

> > +
> >  static
> >  void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
> >  {
> > @@ -943,10 +947,10 @@ void virt_acpi_build(VirtMachineState *vms, AcpiBuildTables *tables)
> >      build_dbg2(tables_blob, tables->linker, vms);
> >  
> >      if (vms->ras) {
> > -        build_ghes_error_table(tables->hardware_errors, tables->linker);
> >          acpi_add_table(table_offsets, tables_blob);
> > -        acpi_build_hest(tables_blob, tables->linker, vms->oem_id,
> > -                        vms->oem_table_id);
> > +        acpi_build_hest(tables_blob, tables->hardware_errors, tables->linker,
> > +                        hest_ghes_notify, sizeof(hest_ghes_notify),
> > +                        vms->oem_id, vms->oem_table_id);
> >      }
> >  
> >      if (ms->numa_state->num_nodes > 0) {
> > diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
> > index 28b956acb19a..4b5af86ec077 100644
> > --- a/include/hw/acpi/ghes.h
> > +++ b/include/hw/acpi/ghes.h
> > @@ -23,6 +23,7 @@
> >  #define ACPI_GHES_H
> >  
> >  #include "hw/acpi/bios-linker-loader.h"
> > +#include "qapi/error.h"
> >  
> >  /*
> >   * Values for Hardware Error Notification Type field
> > @@ -56,24 +57,23 @@ enum AcpiGhesNotifyType {
> >      ACPI_GHES_NOTIFY_RESERVED = 12
> >  };
> >  
> > -enum {
> > -    ACPI_HEST_SRC_ID_SEA = 0,
> > -    /* future ids go here */
> > -    ACPI_HEST_SRC_ID_RESERVED,
> > -};
> > -
> >  typedef struct AcpiGhesState {
> >      uint64_t hest_addr_le;
> >      uint64_t ghes_addr_le;
> >      bool present; /* True if GHES is present at all on this board */
> >  } AcpiGhesState;
> >  
> > -void build_ghes_error_table(GArray *hardware_errors, BIOSLinker *linker);
> > -void acpi_build_hest(GArray *table_data, BIOSLinker *linker,
> > +void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
> > +                     BIOSLinker *linker,
> > +                     const uint16_t * const notify,
> > +                     int num_sources,
> >                       const char *oem_id, const char *oem_table_id);
> >  void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
> >                            GArray *hardware_errors);
> > -int acpi_ghes_record_errors(uint8_t notify, uint64_t error_physical_addr);
> > +int acpi_ghes_record_errors(int source_id,
> > +                            uint64_t error_physical_addr);
> > +void ghes_record_cper_errors(const void *cper, size_t len,  
> 
> use GArray for cper so you won't have to pass down len

Here, it would work fine, but when adding hw/acpi/ghes_cper.c,
the logic there is:

    cper = qbase64_decode(qmp_cper, -1, &len, errp);
    if (!cper) {
        error_setg(errp, "missing GHES CPER payload");
        return;
    }

    ghes_record_cper_errors(cper, len, ACPI_HEST_SRC_ID_QMP, errp);

If I use a GArray, it would mean an extra memory allocation
for no good reason.

So, IMO, better to keep passing buffer and length.

Regards,
Mauro

