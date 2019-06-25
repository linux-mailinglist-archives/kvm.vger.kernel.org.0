Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB725506D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 15:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbfFYNca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 09:32:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfFYNca (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 09:32:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D821981DF3;
        Tue, 25 Jun 2019 13:32:22 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D6B5D9C5;
        Tue, 25 Jun 2019 13:32:16 +0000 (UTC)
Date:   Tue, 25 Jun 2019 15:32:12 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     gengdongjiu <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v17 10/10] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
Message-ID: <20190625153212.1fff6b40@redhat.com>
In-Reply-To: <3059ee08-c041-2006-36b5-fd0e53c08e79@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-11-git-send-email-gengdongjiu@huawei.com>
        <20190624150810.1287160e@redhat.com>
        <3059ee08-c041-2006-36b5-fd0e53c08e79@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 25 Jun 2019 13:32:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jun 2019 20:24:32 +0800
gengdongjiu <gengdongjiu@huawei.com> wrote:

> On 2019/6/24 21:08, Igor Mammedov wrote:
> > On Tue, 14 May 2019 04:18:23 -0700
> > Dongjiu Geng <gengdongjiu@huawei.com> wrote:
> >   
> >> Add SIGBUS signal handler. In this handler, it checks the SIGBUS type,
> >> translates the host VA delivered by host to guest PA, then fill this PA
> >> to guest APEI GHES memory, then notify guest according to the SIGBUS type.
> >>
> >> If guest accesses the poisoned memory, it generates Synchronous External
> >> Abort(SEA). Then host kernel gets an APEI notification and call memory_failure()
> >> to unmapped the affected page for the guest's stage 2, finally return
> >> to guest.
> >>
> >> Guest continues to access PG_hwpoison page, it will trap to KVM as stage2 fault,
> >> then a SIGBUS_MCEERR_AR synchronous signal is delivered to Qemu, Qemu record this
> >> error address into guest APEI GHES memory and notify guest using
> >> Synchronous-External-Abort(SEA).
> >>
> >> Suggested-by: James Morse <james.morse@arm.com>
> >> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> >> ---
> >>  hw/acpi/acpi_ghes.c         | 177 ++++++++++++++++++++++++++++++++++++++++++++
> >>  include/hw/acpi/acpi_ghes.h |   6 +-
> >>  include/sysemu/kvm.h        |   2 +-
> >>  target/arm/kvm64.c          |  39 ++++++++++
> >>  4 files changed, 222 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/hw/acpi/acpi_ghes.c b/hw/acpi/acpi_ghes.c
> >> index d03e797..06b7374 100644
> >> --- a/hw/acpi/acpi_ghes.c
> >> +++ b/hw/acpi/acpi_ghes.c
> >> @@ -26,6 +26,101 @@
> >>  #include "sysemu/sysemu.h"
> >>  #include "qemu/error-report.h"
> >>  
> >> +/* UEFI 2.6: N.2.5 Memory Error Section */
> >> +static void build_append_mem_cper(GArray *table, uint64_t error_physical_addr)
> >> +{
> >> +    /*
> >> +     * Memory Error Record
> >> +     */
> >> +    build_append_int_noprefix(table,
> >> +                 (1UL << 14) | /* Type Valid */
> >> +                 (1UL << 1) /* Physical Address Valid */,
> >> +                 8);  
> > bad indent  
> I will update it
> 
> >   
> >> +    /* Memory error status information */
> >> +    build_append_int_noprefix(table, 0, 8);
> >> +    /* The physical address at which the memory error occurred */
> >> +    build_append_int_noprefix(table, error_physical_addr, 8);
> >> +    build_append_int_noprefix(table, 0, 48);
> >> +    build_append_int_noprefix(table, 0 /* Unknown error */, 1);
> >> +    build_append_int_noprefix(table, 0, 7);
> >> +}
> >> +
> >> +static int ghes_record_mem_error(uint64_t error_block_address,
> >> +                                    uint64_t error_physical_addr)  
> > bad indent  
> I will update it
> 
> > 
> >   
> >> +{
> >> +    GArray *block;
> >> +    uint64_t current_block_length;
> >> +    uint32_t data_length;
> >> +    /* Memory section */
> >> +    char mem_section_id_le[] = {0x14, 0x11, 0xBC, 0xA5, 0x64, 0x6F, 0xDE,
> >> +                                0x4E, 0xB8, 0x63, 0x3E, 0x83, 0xED, 0x7C,
> >> +                                0x83, 0xB1};
> >> +    uint8_t fru_id[16] = {0};
> >> +    uint8_t fru_text[20] = {0};
> >> +
> >> +    /* Generic Error Status Block
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
> >> +    block = g_array_new(false, true /* clear */, 1);
> >> +
> >> +    /* Get the length of the Generic Error Data Entries */
> >> +    cpu_physical_memory_read(error_block_address +
> >> +        offsetof(AcpiGenericErrorStatus, data_length), &data_length, 4);
> >> +    /* The current whole length of the generic error status block */
> >> +    current_block_length = sizeof(AcpiGenericErrorStatus) + le32_to_cpu(data_length);  
> > I might be missing something but why do you read length from guest?
> > Isn't it something provided by QEMU/host?  
> The length of the Generic Error Data Entries is not fixed, as the CPER number increases, the length will increase.
> there is already a member to record the length for the CPER in the table, this table is in the guest.
> so it is better directly read the length from the table instead of providing by QEMU/host.
If not careful using guest provided length for reading/writing buffers in QEMU opens road for exploits.

So if CPER is provided and managed by QEMU then it's better to calculate length
without relying on guest state. Or even rewrite whole status block without trying
to calculate delta.

