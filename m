Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCEB10AE06
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 11:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfK0Kn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 05:43:56 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59453 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726219AbfK0Kn4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Nov 2019 05:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574851433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZF/u3hVs7wraUn7x0bJAvpg16AxlB/qZ++diT+HblM=;
        b=IRFzLGcXUVVBF8DhkoiKCbDJ+OSekvxg5M0iiV3d5fkG9Ej9CsunTyyIpE/3hTAt6MESwu
        dXwbWgyXuEskQDzAqUwGrQu4vhBq2vx576XnmLqdKkQK23Mw3Xbyldq1D7Jbvgi+1FNnkG
        FBeHdSeyYZyV7sol/RZM6Zn6yDQVmak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-HNBqpgj2P5yhF6YUC7H-Fw-1; Wed, 27 Nov 2019 05:43:50 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D827093F70;
        Wed, 27 Nov 2019 10:43:47 +0000 (UTC)
Received: from localhost (ovpn-204-134.brq.redhat.com [10.40.204.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 329F619C6A;
        Wed, 27 Nov 2019 10:43:40 +0000 (UTC)
Date:   Wed, 27 Nov 2019 11:43:38 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: Re: [RESEND PATCH v21 5/6] target-arm: kvm64: handle SIGBUS signal
 from kernel or KVM
Message-ID: <20191127114338.3e71d1e4@redhat.com>
In-Reply-To: <c4374e05-acb2-0c53-b853-32cac61973d6@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
        <20191111014048.21296-6-zhengxiang9@huawei.com>
        <20191115173713.795e5f63@redhat.com>
        <c4374e05-acb2-0c53-b853-32cac61973d6@huawei.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: HNBqpgj2P5yhF6YUC7H-Fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Nov 2019 09:40:14 +0800
Xiang Zheng <zhengxiang9@huawei.com> wrote:

> Hi,
> 
> On 2019/11/16 0:37, Igor Mammedov wrote:
> > On Mon, 11 Nov 2019 09:40:47 +0800
> > Xiang Zheng <zhengxiang9@huawei.com> wrote:
> >   
> >> From: Dongjiu Geng <gengdongjiu@huawei.com>
> >>
> >> Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> >> translates the host VA delivered by host to guest PA, then fills this PA
> >> to guest APEI GHES memory, then notifies guest according to the SIGBUS
> >> type.
> >>
> >> When guest accesses the poisoned memory, it will generate a Synchronous
> >> External Abort(SEA). Then host kernel gets an APEI notification and calls
> >> memory_failure() to unmapped the affected page in stage 2, finally
> >> returns to guest.
> >>
> >> Guest continues to access the PG_hwpoison page, it will trap to KVM as
> >> stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
> >> Qemu, Qemu records this error address into guest APEI GHES memory and
> >> notifes guest using Synchronous-External-Abort(SEA).
> >>
> >> In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
> >> in which we can setup the type of exception and the syndrome information.
> >> When switching to guest, the target vcpu will jump to the synchronous
> >> external abort vector table entry.
> >>
> >> The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
> >> ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
> >> not valid and hold an UNKNOWN value. These values will be set to KVM
> >> register structures through KVM_SET_ONE_REG IOCTL.
> >>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> >> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
> >> ---
> >>  hw/acpi/acpi_ghes.c         | 297 ++++++++++++++++++++++++++++++++++++
> >>  include/hw/acpi/acpi_ghes.h |   4 +
> >>  include/sysemu/kvm.h        |   3 +-
> >>  target/arm/cpu.h            |   4 +
> >>  target/arm/helper.c         |   2 +-
> >>  target/arm/internals.h      |   5 +-
> >>  target/arm/kvm64.c          |  64 ++++++++
> >>  target/arm/tlb_helper.c     |   2 +-
> >>  target/i386/cpu.h           |   2 +
> >>  9 files changed, 377 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> >> index 42c00ff3d3..f5b54990c0 100644
> >> --- a/hw/acpi/acpi_ghes.c
> >> +++ b/hw/acpi/acpi_ghes.c
> >> @@ -39,6 +39,34 @@
> >>  /* The max size in bytes for one error block */
> >>  #define ACPI_GHES_MAX_RAW_DATA_LENGTH       0x1000
> >>  
> >> +/*
> >> + * The total size of Generic Error Data Entry
> >> + * ACPI 6.1/6.2: 18.3.2.7.1 Generic Error Data,
> >> + * Table 18-343 Generic Error Data Entry
> >> + */
> >> +#define ACPI_GHES_DATA_LENGTH               72
> >> +
> >> +/*
> >> + * The memory section CPER size,
> >> + * UEFI 2.6: N.2.5 Memory Error Section
> >> + */  
> > maybe use one line comment
> >   
> >> +#define ACPI_GHES_MEM_CPER_LENGTH           80
> >> +
> >> +/*
> >> + * Masks for block_status flags
> >> + */  
> > ditto
> >   
> >> +#define ACPI_GEBS_UNCORRECTABLE         1
> >> +
> >> +/*
> >> + * Values for error_severity field
> >> + */  
> > ditto
> >   
> 
> OK, I will use one line comment.
> 
> >> +enum AcpiGenericErrorSeverity {
> >> +    ACPI_CPER_SEV_RECOVERABLE,
> >> +    ACPI_CPER_SEV_FATAL,
> >> +    ACPI_CPER_SEV_CORRECTED,
> >> +    ACPI_CPER_SEV_NONE,  
> > I'd assign values explicitly here
> >   foo = x,
> >   ...  
> 
> OK.
> 
> >   
> >> +};
> >> +
> >>  /*
> >>   * Now only support ARMv8 SEA notification type error source
> >>   */
> >> @@ -49,6 +77,16 @@
> >>   */
> >>  #define ACPI_GHES_SOURCE_GENERIC_ERROR_V2   10
> >>  
> >> +#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)        \
> >> +    {{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
> >> +    ((b) >> 8) & 0xff, (b) & 0xff,                   \
> >> +    ((c) >> 8) & 0xff, (c) & 0xff,                    \
> >> +    (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) } } }
> >> +
> >> +#define UEFI_CPER_SEC_PLATFORM_MEM                   \
> >> +    UUID_BE(0xA5BC1114, 0x6F64, 0x4EDE, 0xB8, 0x63, 0x3E, 0x83, \
> >> +    0xED, 0x7C, 0x83, 0xB1)
> >> +
> >>  /*
> >>   * | +--------------------------+ 0
> >>   * | |        Header            |
> >> @@ -77,6 +115,174 @@ typedef struct AcpiGhesState {
> >>      uint64_t ghes_addr_le;
> >>  } AcpiGhesState;
> >>  
> >> +/*
> >> + * Total size for Generic Error Status Block
> >> + * ACPI 6.2: 18.3.2.7.1 Generic Error Data,
> >> + * Table 18-380 Generic Error Status Block
> >> + */
> >> +#define ACPI_GHES_GESB_SIZE                 20  
> >   
> >> +/* The offset of Data Length in Generic Error Status Block */
> >> +#define ACPI_GHES_GESB_DATA_LENGTH_OFFSET   12  
> > 
> > unused, drop it
> >   
> 
> OK.
> 
> >> +
> >> +/*
> >> + * Record the value of data length for each error status block to avoid getting
> >> + * this value from guest.
> >> + */
> >> +static uint32_t acpi_ghes_data_length[ACPI_GHES_ERROR_SOURCE_COUNT];
> >> +
> >> +/*
> >> + * Generic Error Data Entry
> >> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> >> + */
> >> +static void acpi_ghes_generic_error_data(GArray *table, QemuUUID section_type,
> >> +                uint32_t error_severity, uint16_t revision,
> >> +                uint8_t validation_bits, uint8_t flags,
> >> +                uint32_t error_data_length, QemuUUID fru_id,
> >> +                uint8_t *fru_text, uint64_t time_stamp)
> >> +{
> >> +    QemuUUID uuid_le;
> >> +
> >> +    /* Section Type */
> >> +    uuid_le = qemu_uuid_bswap(section_type);
> >> +    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
> >> +
> >> +    /* Error Severity */
> >> +    build_append_int_noprefix(table, error_severity, 4);
> >> +    /* Revision */
> >> +    build_append_int_noprefix(table, revision, 2);
> >> +    /* Validation Bits */
> >> +    build_append_int_noprefix(table, validation_bits, 1);
> >> +    /* Flags */
> >> +    build_append_int_noprefix(table, flags, 1);
> >> +    /* Error Data Length */
> >> +    build_append_int_noprefix(table, error_data_length, 4);
> >> +
> >> +    /* FRU Id */
> >> +    uuid_le = qemu_uuid_bswap(fru_id);
> >> +    g_array_append_vals(table, uuid_le.data, ARRAY_SIZE(uuid_le.data));
> >> +
> >> +    /* FRU Text */
> >> +    g_array_append_vals(table, fru_text, 20);  
> > what if fru_text were shorter than 20 bytes?
> > 
> > Suggest to pass length along or
> > drop all fru handling in the caller and just hardcode here invalid fru with empty text,
> > as function could be extended later, once there is something meaningful to put in fru.
> >   
> 
> "FRU Text" and "FRU Id" are only used in acpi_ghes_generic_error_data(), so I'd move the
> definition into acpi_ghes_generic_error_data() and just hardcode here.
> 
> >   
> >> +    /* Timestamp */
> >> +    build_append_int_noprefix(table, time_stamp, 8);
> >> +}
> >> +
> >> +/*
> >> + * Generic Error Status Block
> >> + * ACPI 6.1: 18.3.2.7.1 Generic Error Data
> >> + */
> >> +static void acpi_ghes_generic_error_status(GArray *table, uint32_t block_status,
> >> +                uint32_t raw_data_offset, uint32_t raw_data_length,
> >> +                uint32_t data_length, uint32_t error_severity)
> >> +{
> >> +    /* Block Status */
> >> +    build_append_int_noprefix(table, block_status, 4);
> >> +    /* Raw Data Offset */
> >> +    build_append_int_noprefix(table, raw_data_offset, 4);
> >> +    /* Raw Data Length */
> >> +    build_append_int_noprefix(table, raw_data_length, 4);
> >> +    /* Data Length */
> >> +    build_append_int_noprefix(table, data_length, 4);
> >> +    /* Error Severity */
> >> +    build_append_int_noprefix(table, error_severity, 4);
> >> +}
> >> +
> >> +/* UEFI 2.6: N.2.5 Memory Error Section */
> >> +static void acpi_ghes_build_append_mem_cper(GArray *table,
> >> +                                            uint64_t error_physical_addr)  
> > I'd split out this and acpi_ghes_generic_error_status() and
> > acpi_ghes_generic_error_data()  functions into a separate patch.
> >   
> 
> OK.
> 
> >> +{
> >> +    /*
> >> +     * Memory Error Record
> >> +     */
> >> +
> >> +    /* Validation Bits */
> >> +    build_append_int_noprefix(table,  
> >   
> >> +                              (1UL << 14) | /* Type Valid */
> >> +                              (1UL << 1) /* Physical Address Valid */,  
> > shouldn't it use ULL suffixes?
> >   
> 
> Yes, we should use ULL. The field "Validation Bits" in Memory Error Section is
> in 8-bytes size.
> 
> >> +                              8);
> >> +    /* Error Status */
> >> +    build_append_int_noprefix(table, 0, 8);
> >> +    /* Physical Address */
> >> +    build_append_int_noprefix(table, error_physical_addr, 8);
> >> +    /* Skip all the detailed information normally found in such a record */
> >> +    build_append_int_noprefix(table, 0, 48);
> >> +    /* Memory Error Type */
> >> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
> >> +    /* Skip all the detailed information normally found in such a record */
> >> +    build_append_int_noprefix(table, 0, 7);
> >> +}
> >> +
> >> +static int acpi_ghes_record_mem_error(uint64_t error_block_address,
> >> +                                      uint64_t error_physical_addr,
> >> +                                      uint32_t data_length)
> >> +{
> >> +    GArray *block;
> >> +    uint64_t current_block_length;
> >> +    /* Memory Error Section Type */
> >> +    QemuUUID mem_section_id_le = UEFI_CPER_SEC_PLATFORM_MEM;  
> >                                ^^
> > UEFI_CPER_SEC_PLATFORM_MEM is defined as BE, so _le here is wrong
> > and then later you use qemu_uuid_bswap() to make it LE.
> > 
> > Why not define it as LE to begin with, like it's been done for NVDIMM_UUID_LE?
> >   
> 
> OK.
> 
> >   
> >> +    QemuUUID fru_id = {};
> >> +    uint8_t fru_text[20] = {};
> >> +
> >> +    /*
> >> +     * Generic Error Status Block
> >> +     * | +---------------------+
> >> +     * | |     block_status    |
> >> +     * | +---------------------+
> >> +     * | |    raw_data_offset  |
> >> +     * | +---------------------+
> >> +     * | |    raw_data_length  |
> >> +     * | +---------------------+
> >> +     * | |     data_length     |
> >> +     * | +---------------------+
> >> +     * | |   error_severity    |
> >> +     * | +---------------------+
> >> +     */  
> > not necessary, just point to concrete part of ACPI spec if needed.
> >   
> 
> OK.
> 
> >> +    block = g_array_new(false, true /* clear */, 1);
> >> +
> >> +    /* The current whole length of the generic error status block */
> >> +    current_block_length = ACPI_GHES_GESB_SIZE + data_length;
> >> +
> >> +    /* This is the length if adding a new generic error data entry*/
> >> +    data_length += ACPI_GHES_DATA_LENGTH;
> >> +    data_length += ACPI_GHES_MEM_CPER_LENGTH;
> >> +
> >> +    /*
> >> +     * Check whether it will run out of the preallocated memory if adding a new
> >> +     * generic error data entry
> >> +     */
> >> +    if ((data_length + ACPI_GHES_GESB_SIZE) > ACPI_GHES_MAX_RAW_DATA_LENGTH) {
> >> +        error_report("Record CPER out of boundary!!!");
> >> +        return ACPI_GHES_CPER_FAIL;
> >> +    }
> >> +
> >> +    /* Build the new generic error status block header */
> >> +    acpi_ghes_generic_error_status(block, cpu_to_le32(ACPI_GEBS_UNCORRECTABLE),
> >> +        0, 0, cpu_to_le32(data_length), cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE));  
> > Down the road, the arguments are passed to build_append_int_noprefix() which takes
> > numbers in host byte order, so manually calling cpu_to_le32() is wrong.
> > just drop cpu_to_le32() here.
> > 
> >   
> >> +
> >> +    /* Write back above generic error status block header to guest memory */
> >> +    cpu_physical_memory_write(error_block_address, block->data,
> >> +                              block->len);
> >> +
> >> +    /* Add a new generic error data entry */
> >> +
> >> +    data_length = block->len;
> >> +    /* Build this new generic error data entry header */
> >> +    acpi_ghes_generic_error_data(block, mem_section_id_le,
> >> +        cpu_to_le32(ACPI_CPER_SEV_RECOVERABLE), cpu_to_le32(0x300), 0, 0,
> >> +        cpu_to_le32(ACPI_GHES_MEM_CPER_LENGTH), fru_id, fru_text, 0);  
> > ditto
> >  
> 
> Yes, this would be wrong when running with big-endian QEMU. I will drop "cpu_to_le32()".
> 
> >> +
> >> +    /* Build the memory section CPER for above new generic error data entry */
> >> +    acpi_ghes_build_append_mem_cper(block, error_physical_addr);
> >> +
> >> +    /* Write back above this new generic error data entry to guest memory */
> >> +    cpu_physical_memory_write(error_block_address + current_block_length,
> >> +        block->data + data_length, block->len - data_length);  
> > 
> > If I read it right you are in the first write build an updated "Error Status Block"
> > header where you update "Data Length" to account for an additional
> > "Error Data Entry" and then this second write appends a new "Error Data Entry"
> > after the previous one (if any existed).
> > 
> > Now for GHESv2, OSPM is supposed to copy existing "Error Status Block" and Ack
> > that fact via "Read Ack Register" and QEMU must not overwrite old data until
> > they are acked by OSPM.
> > 
> > With that in mind appending a new error seems a pointless since guest
> > already consumed any pre-existing error before we are able to write.
> > So we can drop "Error Status Block" tracking and just
> >  1. compose whole "Error Status Block" with 1 new "Error Data Entry"
> >  2. check that it fits into start, start+ACPI_GHES_MAX_RAW_DATA_LENGTH range
> >  3. push it into guest RAM with 1 only write
> > 
> > and drop all data_length tracking related code.
> >   
> 
> Yes, you're right. After OSPM acks the "Error Status Block", it can be reused. Maybe one
> "Error Data Entry" is enough for each "Error Status Block" in current implementation.
> 
> In the ACPI spec, it says that "One or more Generic Error Data Entry structures may be
> recorded in the Generic Error Data Entries field of the Generic Error Status Block
> structure". I'm not sure whether a single "Error Data Entry" is sufficient.
Several data entries could be used if system detects several errors at the same time,
so it could create single status block with all error it knows about.


> >> +    g_array_free(block, true);
> >> +
> >> +    return ACPI_GHES_CPER_OK;
> >> +}
> >> +
> >>  /*
> >>   * Hardware Error Notification
> >>   * ACPI 4.0: 17.3.2.7 Hardware Error Notification
> >> @@ -265,3 +471,94 @@ void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_error)
> >>      fw_cfg_add_file_callback(s, ACPI_GHES_DATA_ADDR_FW_CFG_FILE, NULL, NULL,
> >>          NULL, &ges.ghes_addr_le, sizeof(ges.ghes_addr_le), false);
> >>  }
> >> +
> >> +bool acpi_ghes_record_errors(uint32_t notify, uint64_t physical_address)
> >> +{
> >> +    uint64_t error_block_addr, read_ack_register_addr, read_ack_register = 0;
> >> +    int loop = 0;
> >> +    uint64_t start_addr = le64_to_cpu(ges.ghes_addr_le);  
> >                                          ^^^^^^^^^^^^^^^
> > Forgot to mention in patch [3/6],
> > 
> > Migration is definitively broken here, since ges.ghes_addr_le is
> > not migrated to target QEMU. For example how it should be done see:
> >   vmgenid_addr_le and vmstate_vmgenid
> > 
> > for that you'd need to make ghes_addr_le a part of some device
> > (recently added hw/acpi/generic_event_device.c looks like suitable victim)
> >   
> 
> Yes, this is a serious problem! Is there any better way to migrate ges.ghes_addr_le?
> It looks weird that making ghes_addr_le a part of GED. How about registering a single
> "ACPI GHES Device" which inherits from "TYPE_DEVICE"?
we already have acpi specific device (GED), so I suggest to reuse it.


> >> +    bool ret = ACPI_GHES_CPER_FAIL;
> >> +    uint8_t source_id;  
> >   
> >> +    const uint8_t error_source_id[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
> >> +                                        0xff, 0xff,    0, 0xff, 0xff, 0xff};  
> > put map at the beginning of this file 
> > 
> > s/const/static const/
> > s/error_source_id/ghes_notify2source_id_map/
> >  = { ...,
> >      ACPI_HEST_SCR_ID_SEA,
> >      ...,
> >      ACPI_HEST_SRC_ID_RESERVED
> >    }
> >   
> 
> OK.
> 
> >   
> >> +
> >> +    /*
> >> +     * | +---------------------+ ges.ghes_addr_le
> >> +     * | |error_block_address0 |
> >> +     * | +---------------------+ --+--
> >> +     * | |    .............    | ACPI_GHES_ADDRESS_SIZE
> >> +     * | +---------------------+ --+--
> >> +     * | |error_block_addressN |
> >> +     * | +---------------------+
> >> +     * | | read_ack_register0  |
> >> +     * | +---------------------+ --+--
> >> +     * | |   .............     | ACPI_GHES_ADDRESS_SIZE
> >> +     * | +---------------------+ --+--
> >> +     * | | read_ack_registerN  |  
> > 
> > above part is not necessary
> >   
> 
> OK
> 
> >> +     * | +---------------------+ --+--
> >> +     * | |      CPER           |   |
> >> +     * | |      ....           | ACPI_GHES_MAX_RAW_DATA_LENGT
> >> +     * | |      CPER           |   |
> >> +     * | +---------------------+ --+--  
> > and this one is not precise as it holds not only CPER record
> > Generic Error Status Block + Generic Error Data (with CPER inside)
> >   
> 
> Even in the spec, it only shows the CPER in Error Data Entry. But I
> also think using "Error Data Entry" is more precise.
> 
> > and looking at code here and spec I'm not sure we can actually do
> > several Error Data Entries as implemented here, more on that later
> >   
> 
> 
> >> +     * | |    ..........       |
> >> +     * | +---------------------+
> >> +     * | |      CPER           |
> >> +     * | |      ....           |
> >> +     * | |      CPER           |
> >> +     * | +---------------------+
> >> +     */
> >> +    if (physical_address && notify < ACPI_GHES_NOTIFY_RESERVED) {
> >> +        /* Find and check the source id for this new CPER */
> >> +        source_id = error_source_id[notify];
> >> +        if (source_id != 0xff) {
> >> +            start_addr += source_id * ACPI_GHES_ADDRESS_SIZE;
> >> +        } else {
> >> +            goto out;  
> > assert() ???
> >   
> 
> >   
> >> +        }
> >> +
> >> +        cpu_physical_memory_read(start_addr, &error_block_addr,
> >> +                                 ACPI_GHES_ADDRESS_SIZE);
> >> +
> >> +        read_ack_register_addr = start_addr +
> >> +            ACPI_GHES_ERROR_SOURCE_COUNT * ACPI_GHES_ADDRESS_SIZE;
> >> +retry:
> >> +        cpu_physical_memory_read(read_ack_register_addr,
> >> +                                 &read_ack_register, ACPI_GHES_ADDRESS_SIZE);  
> > it's safer to use
> >    sizeof(read_ack_register)
> > instead of ACPI_GHES_ADDRESS_SIZE to make sure that stack won't be corrupted
> > by accident later, the same applies to other reads.
> >   
> 
> OK, I will droy the ACPI_GHES_ADDRESS_SIZE and replace it with "sizeof()".
> 
> >> +
> >> +        /* zero means OSPM does not acknowledge the error */
> >> +        if (!read_ack_register) {
> >> +            if (loop < 3) {
> >> +                usleep(100 * 1000);
> >> +                loop++;
> >> +                goto retry;  
> > as minimum this loop can stall guest repeatedly for 0.3s if guest triggers BQL,
> > until it handles error.
> > 
> > (not sure what to suggest here though)
> >   
> 
> >> +            } else {
> >> +                error_report("OSPM does not acknowledge previous error,"
> >> +                    " so can not record CPER for current error, forcibly"
> >> +                    " acknowledge previous error to avoid blocking next time"
> >> +                    " CPER record! Exit");  
> > 
> > Also error overwrite goes against the spec, which says
> > "
> > Platforms with RAS
> > controllers must prevent concurrent accesses to the Error Status Block (i.e., the RAS controller
> > must not overwrite the Error Status Block before the OS has completed reading it).
> > ******************
> > "
> > we probably shouldn't override not acked block.
> > Question is what bare metal machines do in this case?
> >   
> 
> Hmm... Yes, you're right. For example, on bare metal machines there are 3 pre-allocated GHESv2(s)
> for SEA. If none of them is acked, it will do nothing for the incoming SEA.
> 
> On Qemu there is one pre-allocated GHESv2 for SEA, so we think should do nothing if the block is
> not acked.
ok if bare-metal behave like this, lets go with it for now.


> >> +                read_ack_register = 1;
> >> +                cpu_physical_memory_write(read_ack_register_addr,
> >> +                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);  
> > Function writes data as is, so one has to ensure that endianness of
> > read_ack_register matches that of the spec/guest.
> > The same applies to the code below marked with "^^^".
> >   
> Yes, for the codes here and below marked with "^^^", we need to add cpu_to_leXX() to
> match the spec.
> 
> >> +            }
> >> +        } else {
> >> +            if (error_block_addr) {  
> > 
> > } else if () {
> >   
> 
> OK.
> 
> >> +                read_ack_register = 0;
> >> +                /*
> >> +                 * Clear the Read Ack Register, OSPM will write it to 1 when
> >> +                 * acknowledge this error.
> >> +                 */
> >> +                cpu_physical_memory_write(read_ack_register_addr,
> >> +                    &read_ack_register, ACPI_GHES_ADDRESS_SIZE);  
> >                          ^^^ - for 0 it doesn't really matter but conversion should be done
> >                                 even if it's just for the sake of documenting interface
> >   
> 
> >> +                ret = acpi_ghes_record_mem_error(error_block_addr,  
> >                                                     ^^^^
> >   
> >> +                          physical_address, acpi_ghes_data_length[source_id]);  
> >                              ^^^
> >   
> >> +                if (ret == ACPI_GHES_CPER_OK) {
> >> +                    acpi_ghes_data_length[source_id] +=
> >> +                        (ACPI_GHES_DATA_LENGTH + ACPI_GHES_MEM_CPER_LENGTH);  
> > eventually we will run out of space and nothing short of QEMU restart will
> > help to reclaim that.
> > 
> > Also if you keep track of available space in QEMU,
> > you'd also have to migrate it otherwise it's lost after migration.
> > But maybe we don't need to keep a track of free space,
> > see my another comment in acpi_ghes_record_mem_error()
> >  
> >> +                }
> >> +            }
> >> +        }
> >> +    }
> >> +
> >> +out:
> >> +    return ret;
> >> +}
> >> diff --git a/include/hw/acpi/acpi_ghes.h b/include/hw/acpi/acpi_ghes.h
> >> index cb62ec9c7b..8e3c5b879e 100644
> >> --- a/include/hw/acpi/acpi_ghes.h
> >> +++ b/include/hw/acpi/acpi_ghes.h
> >> @@ -24,6 +24,9 @@
> >>  
> >>  #include "hw/acpi/bios-linker-loader.h"
> >>  
> >> +#define ACPI_GHES_CPER_OK                   1
> >> +#define ACPI_GHES_CPER_FAIL                 0
> >> +
> >>  /*
> >>   * Values for Hardware Error Notification Type field
> >>   */
> >> @@ -53,4 +56,5 @@ void acpi_ghes_build_hest(GArray *table_data, GArray *hardware_error,
> >>  
> >>  void acpi_ghes_build_error_table(GArray *hardware_errors, BIOSLinker *linker);
> >>  void acpi_ghes_add_fw_cfg(FWCfgState *s, GArray *hardware_errors);
> >> +bool acpi_ghes_record_errors(uint32_t notify, uint64_t error_physical_addr);
> >>  #endif
> >> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> >> index 9d143282bc..321ead8115 100644
> >> --- a/include/sysemu/kvm.h
> >> +++ b/include/sysemu/kvm.h
> >> @@ -378,8 +378,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
> >>  /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
> >>  unsigned long kvm_arch_vcpu_id(CPUState *cpu);
> >>  
> >> -#ifdef TARGET_I386
> >> -#define KVM_HAVE_MCE_INJECTION 1
> >> +#ifdef KVM_HAVE_MCE_INJECTION
> >>  void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
> >>  #endif
> >>  
> >> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> >> index d844ea21d8..c4fe6ccc63 100644
> >> --- a/target/arm/cpu.h
> >> +++ b/target/arm/cpu.h
> >> @@ -28,6 +28,10 @@
> >>  /* ARM processors have a weak memory model */
> >>  #define TCG_GUEST_DEFAULT_MO      (0)
> >>  
> >> +#ifdef TARGET_AARCH64
> >> +#define KVM_HAVE_MCE_INJECTION 1
> >> +#endif
> >> +
> >>  #define EXCP_UDEF            1   /* undefined instruction */
> >>  #define EXCP_SWI             2   /* software interrupt */
> >>  #define EXCP_PREFETCH_ABORT  3
> >> diff --git a/target/arm/helper.c b/target/arm/helper.c
> >> index 63815fc4cf..a9ce97efb1 100644
> >> --- a/target/arm/helper.c
> >> +++ b/target/arm/helper.c
> >> @@ -3005,7 +3005,7 @@ static uint64_t do_ats_write(CPUARMState *env, uint64_t value,
> >>               * Report exception with ESR indicating a fault due to a
> >>               * translation table walk for a cache maintenance instruction.
> >>               */
> >> -            syn = syn_data_abort_no_iss(current_el == target_el,
> >> +            syn = syn_data_abort_no_iss(current_el == target_el, 0,
> >>                                          fi.ea, 1, fi.s1ptw, 1, fsc);
> >>              env->exception.vaddress = value;
> >>              env->exception.fsr = fsr;
> >> diff --git a/target/arm/internals.h b/target/arm/internals.h
> >> index f5313dd3d4..28b8451d6d 100644
> >> --- a/target/arm/internals.h
> >> +++ b/target/arm/internals.h
> >> @@ -451,13 +451,14 @@ static inline uint32_t syn_insn_abort(int same_el, int ea, int s1ptw, int fsc)
> >>          | ARM_EL_IL | (ea << 9) | (s1ptw << 7) | fsc;
> >>  }
> >>  
> >> -static inline uint32_t syn_data_abort_no_iss(int same_el,
> >> +static inline uint32_t syn_data_abort_no_iss(int same_el, int fnv,
> >>                                               int ea, int cm, int s1ptw,
> >>                                               int wnr, int fsc)
> >>  {
> >>      return (EC_DATAABORT << ARM_EL_EC_SHIFT) | (same_el << ARM_EL_EC_SHIFT)
> >>             | ARM_EL_IL
> >> -           | (ea << 9) | (cm << 8) | (s1ptw << 7) | (wnr << 6) | fsc;
> >> +           | (fnv << 10) | (ea << 9) | (cm << 8) | (s1ptw << 7)
> >> +           | (wnr << 6) | fsc;
> >>  }
> >>  
> >>  static inline uint32_t syn_data_abort_with_iss(int same_el,
> >> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> >> index 28f6db57d5..c7b7653d3f 100644
> >> --- a/target/arm/kvm64.c
> >> +++ b/target/arm/kvm64.c
> >> @@ -28,6 +28,8 @@
> >>  #include "kvm_arm.h"
> >>  #include "hw/boards.h"
> >>  #include "internals.h"
> >> +#include "hw/acpi/acpi.h"
> >> +#include "hw/acpi/acpi_ghes.h"
> >>  
> >>  static bool have_guest_debug;
> >>  
> >> @@ -710,6 +712,30 @@ int kvm_arm_cpreg_level(uint64_t regidx)
> >>      return KVM_PUT_RUNTIME_STATE;
> >>  }
> >>  
> >> +/* Callers must hold the iothread mutex lock */
> >> +static void kvm_inject_arm_sea(CPUState *c)
> >> +{
> >> +    ARMCPU *cpu = ARM_CPU(c);
> >> +    CPUARMState *env = &cpu->env;
> >> +    CPUClass *cc = CPU_GET_CLASS(c);
> >> +    uint32_t esr;
> >> +    bool same_el;
> >> +
> >> +    c->exception_index = EXCP_DATA_ABORT;
> >> +    env->exception.target_el = 1;
> >> +
> >> +    /*
> >> +     * Set the DFSC to synchronous external abort and set FnV to not valid,
> >> +     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
> >> +     */
> >> +    same_el = arm_current_el(env) == env->exception.target_el;
> >> +    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
> >> +
> >> +    env->exception.syndrome = esr;
> >> +
> >> +    cc->do_interrupt(c);
> >> +}
> >> +
> >>  #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> >>                   KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
> >>  
> >> @@ -1036,6 +1062,44 @@ int kvm_arch_get_registers(CPUState *cs)
> >>      return ret;
> >>  }
> >>  
> >> +void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
> >> +{
> >> +    ram_addr_t ram_addr;
> >> +    hwaddr paddr;
> >> +
> >> +    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);  
> > you let BUS_MCEERR_AO in but then it's unused, so what's the purpose of allowing it?
> >   
> 
> Yes, the assertion "code == BUS_MCEERR_AO" is useless at least for now.
> 
> >> +
> >> +    if (acpi_enabled && addr &&
> >> +            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
> >> +        ram_addr = qemu_ram_addr_from_host(addr);
> >> +        if (ram_addr != RAM_ADDR_INVALID &&
> >> +            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
> >> +            kvm_hwpoison_page_add(ram_addr);
> >> +            /*
> >> +             * Asynchronous signal will be masked by main thread, so
> >> +             * only handle synchronous signal.
> >> +             */
> >> +            if (code == BUS_MCEERR_AR) {
> >> +                kvm_cpu_synchronize_state(c);
> >> +                if (ACPI_GHES_CPER_FAIL !=
> >> +                    acpi_ghes_record_errors(ACPI_GHES_NOTIFY_SEA, paddr)) {
> >> +                    kvm_inject_arm_sea(c);
> >> +                } else {
> >> +                    fprintf(stderr, "failed to record the error\n");  
> > 
> > fprintf() shouldn't be used in new code
> > and another question is is it's fine to ignore error ?
> > maybe we should use error_fatal in such cases?
> >   
> 
> I'd use error_fatal in this case.
> 
> >> +                }
> >> +            }
> >> +            return;
> >> +        }
> >> +        fprintf(stderr, "Hardware memory error for memory used by "
> >> +                "QEMU itself instead of guest system!\n");  
> >   
> >> +    }
> >> +
> >> +    if (code == BUS_MCEERR_AR) {
> >> +        fprintf(stderr, "Hardware memory error!\n");
> >> +        exit(1);
> >> +    }
> >> +}
> >> +
> >>  /* C6.6.29 BRK instruction */
> >>  static const uint32_t brk_insn = 0xd4200000;
> >>  
> >> diff --git a/target/arm/tlb_helper.c b/target/arm/tlb_helper.c
> >> index 5feb312941..499672ebbc 100644
> >> --- a/target/arm/tlb_helper.c
> >> +++ b/target/arm/tlb_helper.c
> >> @@ -33,7 +33,7 @@ static inline uint32_t merge_syn_data_abort(uint32_t template_syn,
> >>       * ISV field.
> >>       */
> >>      if (!(template_syn & ARM_EL_ISV) || target_el != 2 || s1ptw) {
> >> -        syn = syn_data_abort_no_iss(same_el,
> >> +        syn = syn_data_abort_no_iss(same_el, 0,
> >>                                      ea, 0, s1ptw, is_write, fsc);
> >>      } else {
> >>          /*
> >> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> >> index 5352c9ff55..f75a210f96 100644
> >> --- a/target/i386/cpu.h
> >> +++ b/target/i386/cpu.h
> >> @@ -29,6 +29,8 @@
> >>  /* The x86 has a strong memory model with some store-after-load re-ordering */
> >>  #define TCG_GUEST_DEFAULT_MO      (TCG_MO_ALL & ~TCG_MO_ST_LD)
> >>  
> >> +#define KVM_HAVE_MCE_INJECTION 1
> >> +
> >>  /* Maximum instruction code size */
> >>  #define TARGET_MAX_INSN_SIZE 16
> >>    
> > 
> > 
> > .
> >   
> 

