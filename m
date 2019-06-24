Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1FC509A6
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2019 13:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbfFXLWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jun 2019 07:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727722AbfFXLWB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jun 2019 07:22:01 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B8A61368FF;
        Mon, 24 Jun 2019 11:21:59 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CD8B608D0;
        Mon, 24 Jun 2019 11:21:53 +0000 (UTC)
Date:   Mon, 24 Jun 2019 13:21:49 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v17 03/10] acpi: add build_append_ghes_notify() helper
 for Hardware Error Notification
Message-ID: <20190624132149.3c79fadc@redhat.com>
In-Reply-To: <1557832703-42620-4-git-send-email-gengdongjiu@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-4-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 24 Jun 2019 11:22:01 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 04:18:16 -0700
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> It will help to add Hardware Error Notification to ACPI tables
> without using packed C structures and avoid endianness
> issues as API doesn't need explicit conversion.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  hw/acpi/aml-build.c         | 22 ++++++++++++++++++++++
>  include/hw/acpi/aml-build.h |  8 ++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
> index 555c24f..fb53f21 100644
> --- a/hw/acpi/aml-build.c
> +++ b/hw/acpi/aml-build.c
> @@ -274,6 +274,28 @@ void build_append_gas(GArray *table, AmlAddressSpace as,
>      build_append_int_noprefix(table, address, 8);
>  }
>  
> +/* Hardware Error Notification
> + * ACPI 4.0: 17.3.2.7 Hardware Error Notification
> + */
> +void build_append_ghes_notify(GArray *table, const uint8_t type,
> +                              uint8_t length, uint16_t config_write_enable,
> +                              uint32_t poll_interval, uint32_t vector,
> +                              uint32_t polling_threshold_value,
> +                              uint32_t polling_threshold_window,
> +                              uint32_t error_threshold_value,
> +                              uint32_t error_threshold_window)
> +{
> +        build_append_int_noprefix(table, type, 1); /* type */
comment should be verbatim copy from spec, in this case /* Type */
also do the same for other fields below

other than that patch looks good to me

> +        build_append_int_noprefix(table, length, 1);
> +        build_append_int_noprefix(table, config_write_enable, 2);
> +        build_append_int_noprefix(table, poll_interval, 4);
> +        build_append_int_noprefix(table, vector, 4);
> +        build_append_int_noprefix(table, polling_threshold_value, 4);
> +        build_append_int_noprefix(table, polling_threshold_window, 4);
> +        build_append_int_noprefix(table, error_threshold_value, 4);
> +        build_append_int_noprefix(table, error_threshold_window, 4);
> +}
> +
>  /*
>   * Build NAME(XXXX, 0x00000000) where 0x00000000 is encoded as a dword,
>   * and return the offset to 0x00000000 for runtime patching.
> diff --git a/include/hw/acpi/aml-build.h b/include/hw/acpi/aml-build.h
> index 1a563ad..90c8ef8 100644
> --- a/include/hw/acpi/aml-build.h
> +++ b/include/hw/acpi/aml-build.h
> @@ -411,6 +411,14 @@ build_append_gas_from_struct(GArray *table, const struct AcpiGenericAddress *s)
>                       s->access_width, s->address);
>  }
>  
> +void build_append_ghes_notify(GArray *table, const uint8_t type,
> +                              uint8_t length, uint16_t config_write_enable,
> +                              uint32_t poll_interval, uint32_t vector,
> +                              uint32_t polling_threshold_value,
> +                              uint32_t polling_threshold_window,
> +                              uint32_t error_threshold_value,
> +                              uint32_t error_threshold_window);
> +
>  void build_srat_memory(AcpiSratMemoryAffinity *numamem, uint64_t base,
>                         uint64_t len, int node, MemoryAffinityFlags flags);
>  

