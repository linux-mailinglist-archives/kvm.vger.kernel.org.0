Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B26F2C6956
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731190AbgK0QXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:23:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28029 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbgK0QXC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 11:23:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606494181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dR9WJK9rPxylT1P40JIE20iFJRnlYCDgm5ITAIvzhTM=;
        b=X7L3KArZO1Zqd2WglUu96RhPDZCoDi+SWHoWE8OJ0qzy6FECkbFNB3V6Tegn3ylVQBclUq
        BX/Ov/zP2oN+x1C2F1YWZCa1WA0BHuRt2Hkvt11DxnFKNS5vc3MvWTj9caA6BrDn+XbNhl
        00nkFDWY6ME20gVU+GVKHJJl+0xW1ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-0S2L1TucPVi9ZLkAMcbxAw-1; Fri, 27 Nov 2020 11:22:57 -0500
X-MC-Unique: 0S2L1TucPVi9ZLkAMcbxAw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6910E7161;
        Fri, 27 Nov 2020 16:22:55 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-70.ams2.redhat.com [10.36.113.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6438A6085D;
        Fri, 27 Nov 2020 16:22:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 5/7] s390x: sie: Add first SIE test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6490b11c-23e3-5b20-c7e8-ac7fed489ad5@redhat.com>
Date:   Fri, 27 Nov 2020 17:22:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201127130629.120469-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 14.06, Janosch Frank wrote:
> Let's check if we get the correct interception data on a few
> diags. This commit is more of an addition of boilerplate code than a
> real test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sie.c         | 125 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 ++
>  3 files changed, 129 insertions(+)
>  create mode 100644 s390x/sie.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index b079a26..7a95092 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -19,6 +19,7 @@ tests += $(TEST_DIR)/smp.elf
>  tests += $(TEST_DIR)/sclp.elf
>  tests += $(TEST_DIR)/css.elf
>  tests += $(TEST_DIR)/uv-guest.elf
> +tests += $(TEST_DIR)/sie.elf
>  
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
> diff --git a/s390x/sie.c b/s390x/sie.c
> new file mode 100644
> index 0000000..41b429a
> --- /dev/null
> +++ b/s390x/sie.c
> @@ -0,0 +1,125 @@
> +#include <libcflat.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/arch_def.h>
> +#include <asm/interrupt.h>
> +#include <asm/page.h>
> +#include <alloc_page.h>
> +#include <vmalloc.h>
> +#include <asm/facility.h>
> +#include <mmu.h>
> +#include <sclp.h>
> +#include <sie.h>
> +
> +static u8 *guest;
> +static u8 *guest_instr;
> +static struct vm vm;
> +
> +static void handle_validity(struct vm *vm)
> +{
> +	report(0, "VALIDITY: %x", vm->sblk->ipb >> 16);
> +}
> +
> +static void sie(struct vm *vm)
> +{
> +	while (vm->sblk->icptcode == 0) {
> +		sie64a(vm->sblk, &vm->save_area);
> +		if (vm->sblk->icptcode == 32)
> +		    handle_validity(vm);

Indent with TABs, not spaces, please.

> +	}
> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> +}
> +
> +static void sblk_cleanup(struct vm *vm)
> +{
> +	vm->sblk->icptcode = 0;
> +}
> +
> +static void intercept_diag_10(void)
> +{
> +	u32 instr = 0x83020010;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x100000,
> +	       "Diag 10 intercept");
> +	sblk_cleanup(&vm);
> +}
> +
> +static void intercept_diag_44(void)
> +{
> +	u32 instr = 0x83020044;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x440000,
> +	       "Diag 44 intercept");
> +	sblk_cleanup(&vm);
> +}
> +
> +static void intercept_diag_9c(void)
> +{
> +	u32 instr = 0x8302009c;
> +
> +	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> +	vm.sblk->gpsw.mask = 0x0000000180000000ULL;
> +
> +	memset(guest_instr, 0, PAGE_SIZE);
> +	memcpy(guest_instr, &instr, 4);
> +	sie(&vm);
> +	report(vm.sblk->icptcode == 4 && vm.sblk->ipa == 0x8302 && vm.sblk->ipb == 0x9c0000,
> +	       "Diag 9c intercept");
> +	sblk_cleanup(&vm);
> +}

All three functions are pretty much the same code, except for the diag
number. I think you could use a unified function for this and then just call
it three times with the wanted diagnose code? Or do you plan to extend these
functions later in different ways?

 Thomas

