Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D8D19CFA2
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 07:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgDCFHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 01:07:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56431 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726343AbgDCFHU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Apr 2020 01:07:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585890439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ar69q/Vn4EWZU6G/sHx/rFDNM5LxG2zfTZ7Eo/xK9Gs=;
        b=X9+wpkzUWD/2Ks8BgLUmgH/kWpS5rrsA2+ol8/8M+ZdSwNClNdNMBjF159he8Jz03XipZ1
        XA6ZXZP7sXLHpuWGerpepiLS+RuSdTAuW3YKCnNtevltHpdA6tbfkSUZB7gI9aK2L1uUqj
        t7dZmOwhCnpBr4YwbvvWkD1EVdwC+r4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-T9MNBPQxPVuifpDmWI4fEA-1; Fri, 03 Apr 2020 01:07:17 -0400
X-MC-Unique: T9MNBPQxPVuifpDmWI4fEA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5209C8017F3;
        Fri,  3 Apr 2020 05:07:15 +0000 (UTC)
Received: from [10.36.112.58] (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 359F110016E8;
        Fri,  3 Apr 2020 05:07:11 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] fixup! arm/arm64: ITS: pending table
 migration test
To:     Andrew Jones <drjones@redhat.com>, eric.auger.pro@gmail.com,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     yuzenghui@huawei.com, peter.maydell@linaro.org, thuth@redhat.com,
        alexandru.elisei@arm.com, andre.przywara@arm.com
References: <20200402145227.20109-1-eric.auger@redhat.com>
 <20200402180148.490026-1-drjones@redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a13e00e8-b699-103a-af6c-7807b67f8c70@redhat.com>
Date:   Fri, 3 Apr 2020 07:07:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200402180148.490026-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/2/20 8:01 PM, Andrew Jones wrote:
> [ Without the fix this test would hang, as timeouts don't work with
>   the migration scripts (yet). Use errata to skip instead of hang. ]
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/gic.c  | 18 ++++++++++++++++--
>  errata.txt |  1 +
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ddf0f9d09b14..c0781f8c2c80 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -12,6 +12,7 @@
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
>  #include <libcflat.h>
> +#include <errata.h>
>  #include <asm/setup.h>
>  #include <asm/processor.h>
>  #include <asm/delay.h>
> @@ -812,13 +813,23 @@ static void test_its_migration(void)
>  	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
>  }
>  
> +#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
> +
>  static void test_migrate_unmapped_collection(void)
>  {
> -	struct its_collection *col;
> -	struct its_device *dev2, *dev7;
> +	struct its_collection *col = NULL;
> +	struct its_device *dev2 = NULL, *dev7 = NULL;
> +	bool test_skipped = false;
>  	int pe0 = 0;
>  	u8 config;
>  
> +	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
> +		report_skip("Skipping test, as this test hangs without the fix. "
> +			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
> +		test_skipped = true;
> +		goto do_migrate;
out of curiosity why do you still do the migration and not directly return.

Besides, what caused the migration to fail without 8c58be34494b is
bypassed so:

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>

Thank you for the fixup

Eric

> +	}
> +
>  	if (its_setup1())
>  		return;
>  
> @@ -830,9 +841,12 @@ static void test_migrate_unmapped_collection(void)
>  	its_send_mapti(dev2, 8192, 0, col);
>  	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
>  
> +do_migrate:
>  	puts("Now migrate the VM, then press a key to continue...\n");
>  	(void)getchar();
>  	report_info("Migration complete");
> +	if (test_skipped)
> +		return;
>  
>  	/* on the destination, map the collection */
>  	its_send_mapc(col, true);
> diff --git a/errata.txt b/errata.txt
> index 7d6abc2a7bf6..b66afaa9c079 100644
> --- a/errata.txt
> +++ b/errata.txt
> @@ -5,4 +5,5 @@
>  9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix AArch32 cycle counter access
>  7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulate the EL1 phys timer registers
>  6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
> +8c58be34494b    : 5.6                           : KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
>  #---------------:-------------------------------:---------------------------------------------------
> 

