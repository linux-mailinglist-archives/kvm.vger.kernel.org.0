Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AA13C719
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 16:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAOPMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 10:12:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726562AbgAOPMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 10:12:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579101121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2SYNha3X1HhMzztypPP7ZFvfrMyQgCZMN+0y5jbOdVU=;
        b=HOmcBgFuH54zJ+9ay2+quxsRpJlWEkB3yKDFQjk6c7Rw1RimkAU7gSyg0K6vMNtM3WZRk8
        2nbmG/RYSVI7g1HqtPHg0sDR9o9/3+61Mn00qJ2BRc9hnZaBWsJuajepnJlIMKYgSHLZW1
        LxKElmssHhPhH61kDr36JB+i8CNZxYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-gZgL6WPnOWKH43eLdsTxpA-1; Wed, 15 Jan 2020 10:11:57 -0500
X-MC-Unique: gZgL6WPnOWKH43eLdsTxpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70597109E3FA;
        Wed, 15 Jan 2020 15:11:54 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E56CB5D9C9;
        Wed, 15 Jan 2020 15:11:50 +0000 (UTC)
Date:   Wed, 15 Jan 2020 16:11:49 +0100
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v22 2/9] docs: APEI GHES generation and CPER record
 description
Message-ID: <20200115161149.19481a4a@redhat.com>
In-Reply-To: <1578483143-14905-3-git-send-email-gengdongjiu@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
        <1578483143-14905-3-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 8 Jan 2020 19:32:16 +0800
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> Add APEI/GHES detailed design document
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

Reviewed-by: Igor Mammedov <imammedo@redhat.com>

> ---
>  docs/specs/acpi_hest_ghes.rst | 110 ++++++++++++++++++++++++++++++++++++++++++
>  docs/specs/index.rst          |   1 +
>  2 files changed, 111 insertions(+)
>  create mode 100644 docs/specs/acpi_hest_ghes.rst
> 
> diff --git a/docs/specs/acpi_hest_ghes.rst b/docs/specs/acpi_hest_ghes.rst
> new file mode 100644
> index 0000000..7a1aa90
> --- /dev/null
> +++ b/docs/specs/acpi_hest_ghes.rst
> @@ -0,0 +1,110 @@
> +APEI tables generating and CPER record
> +======================================
> +
> +..
> +   Copyright (c) 2019 HUAWEI TECHNOLOGIES CO., LTD.
> +
> +   This work is licensed under the terms of the GNU GPL, version 2 or later.
> +   See the COPYING file in the top-level directory.
> +
> +Design Details
> +--------------
> +
> +::
> +
> +         etc/acpi/tables                           etc/hardware_errors
> +      ====================                   ===============================
> +  + +--------------------------+            +----------------------------+
> +  | | HEST                     | +--------->|    error_block_address1    |------+
> +  | +--------------------------+ |          +----------------------------+      |
> +  | | GHES1                    | | +------->|    error_block_address2    |------+-+
> +  | +--------------------------+ | |        +----------------------------+      | |
> +  | | .................        | | |        |      ..............        |      | |
> +  | | error_status_address-----+-+ |        -----------------------------+      | |
> +  | | .................        |   |   +--->|    error_block_addressN    |------+-+---+
> +  | | read_ack_register--------+-+ |   |    +----------------------------+      | |   |
> +  | | read_ack_preserve        | +-+---+--->|     read_ack_register1     |      | |   |
> +  | | read_ack_write           |   |   |    +----------------------------+      | |   |
> +  + +--------------------------+   | +-+--->|     read_ack_register2     |      | |   |
> +  | | GHES2                    |   | | |    +----------------------------+      | |   |
> +  + +--------------------------+   | | |    |       .............        |      | |   |
> +  | | .................        |   | | |    +----------------------------+      | |   |
> +  | | error_status_address-----+---+ | | +->|     read_ack_registerN     |      | |   |
> +  | | .................        |     | | |  +----------------------------+      | |   |
> +  | | read_ack_register--------+-----+ | |  |Generic Error Status Block 1|<-----+ |   |
> +  | | read_ack_preserve        |       | |  |-+------------------------+-+        |   |
> +  | | read_ack_write           |       | |  | |          CPER          | |        |   |
> +  + +--------------------------|       | |  | |          CPER          | |        |   |
> +  | | ...............          |       | |  | |          ....          | |        |   |
> +  + +--------------------------+       | |  | |          CPER          | |        |   |
> +  | | GHESN                    |       | |  |-+------------------------+-|        |   |
> +  + +--------------------------+       | |  |Generic Error Status Block 2|<-------+   |
> +  | | .................        |       | |  |-+------------------------+-+            |
> +  | | error_status_address-----+-------+ |  | |           CPER         | |            |
> +  | | .................        |         |  | |           CPER         | |            |
> +  | | read_ack_register--------+---------+  | |           ....         | |            |
> +  | | read_ack_preserve        |            | |           CPER         | |            |
> +  | | read_ack_write           |            +-+------------------------+-+            |
> +  + +--------------------------+            |         ..........         |            |
> +                                            |----------------------------+            |
> +                                            |Generic Error Status Block N |<----------+
> +                                            |-+-------------------------+-+
> +                                            | |          CPER           | |
> +                                            | |          CPER           | |
> +                                            | |          ....           | |
> +                                            | |          CPER           | |
> +                                            +-+-------------------------+-+
> +
> +
> +(1) QEMU generates the ACPI HEST table. This table goes in the current
> +    "etc/acpi/tables" fw_cfg blob. Each error source has different
> +    notification types.
> +
> +(2) A new fw_cfg blob called "etc/hardware_errors" is introduced. QEMU
> +    also needs to populate this blob. The "etc/hardware_errors" fw_cfg blob
> +    contains an address registers table and an Error Status Data Block table.
> +
> +(3) The address registers table contains N Error Block Address entries
> +    and N Read Ack Register entries. The size for each entry is 8-byte.
> +    The Error Status Data Block table contains N Error Status Data Block
> +    entries. The size for each entry is 4096(0x1000) bytes. The total size
> +    for the "etc/hardware_errors" fw_cfg blob is (N * 8 * 2 + N * 4096) bytes.
> +    N is the number of the kinds of hardware error sources.
> +
> +(4) QEMU generates the ACPI linker/loader script for the firmware. The
> +    firmware pre-allocates memory for "etc/acpi/tables", "etc/hardware_errors"
> +    and copies blob contents there.
> +
> +(5) QEMU generates N ADD_POINTER commands, which patch addresses in the
> +    "error_status_address" fields of the HEST table with a pointer to the
> +    corresponding "address registers" in the "etc/hardware_errors" blob.
> +
> +(6) QEMU generates N ADD_POINTER commands, which patch addresses in the
> +    "read_ack_register" fields of the HEST table with a pointer to the
> +    corresponding "read_ack_register" within the "etc/hardware_errors" blob.
> +
> +(7) QEMU generates N ADD_POINTER commands for the firmware, which patch
> +    addresses in the "error_block_address" fields with a pointer to the
> +    respective "Error Status Data Block" in the "etc/hardware_errors" blob.
> +
> +(8) QEMU defines a third and write-only fw_cfg blob which is called
> +    "etc/hardware_errors_addr". Through that blob, the firmware can send back
> +    the guest-side allocation addresses to QEMU. The "etc/hardware_errors_addr"
> +    blob contains a 8-byte entry. QEMU generates a single WRITE_POINTER command
> +    for the firmware. The firmware will write back the start address of
> +    "etc/hardware_errors" blob to the fw_cfg file "etc/hardware_errors_addr".
> +
> +(9) When QEMU gets a SIGBUS from the kernel, QEMU writes CPER into corresponding
> +    "Error Status Data Block", guest memory, and then injects platform specific
> +    interrupt (in case of arm/virt machine it's Synchronous External Abort) as a
> +    notification which is necessary for notifying the guest.
> +
> +(10) This notification (in virtual hardware) will be handled by the guest
> +     kernel, on receiving notification, guest APEI driver could read the CPER error
> +     and take appropriate action.
> +
> +(11) kvm_arch_on_sigbus_vcpu() uses source_id as index in "etc/hardware_errors" to
> +     find out "Error Status Data Block" entry corresponding to error source. So supported
> +     source_id values should be assigned here and not be changed afterwards to make sure
> +     that guest will write error into expected "Error Status Data Block" even if guest was
> +     migrated to a newer QEMU.
> diff --git a/docs/specs/index.rst b/docs/specs/index.rst
> index 984ba44..3019b9c 100644
> --- a/docs/specs/index.rst
> +++ b/docs/specs/index.rst
> @@ -13,3 +13,4 @@ Contents:
>     ppc-xive
>     ppc-spapr-xive
>     acpi_hw_reduced_hotplug
> +   acpi_hest_ghes

