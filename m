Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6634CDB7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbfFTM2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:28:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731682AbfFTM2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:28:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6470301EA90;
        Thu, 20 Jun 2019 12:28:26 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B572F608A7;
        Thu, 20 Jun 2019 12:28:18 +0000 (UTC)
Date:   Thu, 20 Jun 2019 14:28:14 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v17 04/10] acpi: add build_append_ghes_generic_data()
 helper for Generic Error Data Entry
Message-ID: <20190620142814.7caf9c3c@redhat.com>
In-Reply-To: <1557832703-42620-5-git-send-email-gengdongjiu@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-5-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 20 Jun 2019 12:28:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 04:18:17 -0700
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> It will help to add Generic Error Data Entry to ACPI tables
> without using packed C structures and avoid endianness
> issues as API doesn't need explicit conversion.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  hw/acpi/aml-build.c         | 32 ++++++++++++++++++++++++++++++++
>  include/hw/acpi/aml-build.h |  6 ++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index fb53f21..102a288 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -296,6 +296,38 @@ void build_append_ghes_notify(GArray *table, const uint8_t type,
>          build_append_int_noprefix(table, error_threshold_window, 4);
>  }
>  
> +/* Generic Error Data Entry
> + * ACPI 4.0: 17.3.2.6.1 Generic Error Data
> + */
> +void build_append_ghes_generic_data(GArray *table, const char *section_type,
s/build_append_ghes_generic_data/build_append_ghes_generic_error_data/

> +                                    uint32_t error_severity, uint16_t revision,
> +                                    uint8_t validation_bits, uint8_t flags,
> +                                    uint32_t error_data_length, uint8_t *fru_id,
> +                                    uint8_t *fru_text, uint64_t time_stamp)
checkpatch probably will complain due to too long lines
you can use:
void build_append_ghe...
         uint32_t error_severity, uint16_t revision,
         ...

> +{
> +    int i;
> +
> +    for (i = 0; i < 16; i++) {
> +        build_append_int_noprefix(table, section_type[i], 1);
                                            ^^^
use QemuUUID instead, see vmgenid_build_acpi

> +    }
> +
> +    build_append_int_noprefix(table, error_severity, 4);
> +    build_append_int_noprefix(table, revision, 2);
> +    build_append_int_noprefix(table, validation_bits, 1);
> +    build_append_int_noprefix(table, flags, 1);
> +    build_append_int_noprefix(table, error_data_length, 4);
> +
> +    for (i = 0; i < 16; i++) {
> +        build_append_int_noprefix(table, fru_id[i], 1);
same as section_type

> +    }
> +
> +    for (i = 0; i < 20; i++) {
> +        build_append_int_noprefix(table, fru_text[i], 1);
> +    }
instead of loop use g_array_insert_vals()

> +
> +    build_append_int_noprefix(table, time_stamp, 8);
that's not part of 'Table 17-13'
where does it come from?

> +}
> +
>  /*
>   * Build NAME(XXXX, 0x00000000) where 0x00000000 is encoded as a dword,
>   * and return the offset to 0x00000000 for runtime patching.
> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> index 90c8ef8..a71db2f 100644
> --- a/include/hw/acpi/aml-build.h
> +++ b/include/hw/acpi/aml-build.h
> @@ -419,6 +419,12 @@ void build_append_ghes_notify(GArray *table, const uint8_t type,
>                                uint32_t error_threshold_value,
>                                uint32_t error_threshold_window);
>  
> +void build_append_ghes_generic_data(GArray *table, const char *section_type,
> +                                    uint32_t error_severity, uint16_t revision,
> +                                    uint8_t validation_bits, uint8_t flags,
> +                                    uint32_t error_data_length, uint8_t *fru_id,
> +                                    uint8_t *fru_text, uint64_t time_stamp);
> +
>  void build_srat_memory(AcpiSratMemoryAffinity *numamem, uint64_t base,
>                         uint64_t len, int node, MemoryAffinityFlags flags);
>  

