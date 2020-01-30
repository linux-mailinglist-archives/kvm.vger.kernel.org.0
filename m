Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8FE714DB8D
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgA3N0S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:26:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46371 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727392AbgA3N0R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 08:26:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580390776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=mvsXWMxR0uGpZSEo4k3IQArtwNm2PVuoACFPbWzLcbE=;
        b=Nm/dRhPNZ7LZkYwFzxQ8A0QKSv8xEyEfVw+Vl3/boVeMvJgHPBZ2JpK3/oYVqKv0UsWP9V
        C6GnIZ/dCx2FzkgLZU5f56JxYn2UQz70oq6GhqXqAX5fk3ETkG4UiKqjyhF0iGumhwhYoW
        usggEcYLkG3RTJAaS6ljC+RTZ79sBgo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-2Yv_GyqqMpW91WHnVXtsAQ-1; Thu, 30 Jan 2020 08:26:00 -0500
X-MC-Unique: 2Yv_GyqqMpW91WHnVXtsAQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CD83800D50;
        Thu, 30 Jan 2020 13:25:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-117.ams2.redhat.com [10.36.117.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 04E6160BE0;
        Thu, 30 Jan 2020 13:25:54 +0000 (UTC)
Subject: Re: [PATCH v9 5/6] selftests: KVM: s390x: Add reset tests
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200130123434.68129-1-frankja@linux.ibm.com>
 <20200130123434.68129-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <63873d6e-8c1d-92c3-a683-6dd44ef99dbd@redhat.com>
Date:   Thu, 30 Jan 2020 14:25:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200130123434.68129-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/01/2020 13.34, Janosch Frank wrote:
> Test if the registers end up having the correct values after a normal,
> initial and clear reset.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  tools/testing/selftests/kvm/Makefile       |   1 +
>  tools/testing/selftests/kvm/s390x/resets.c | 157 +++++++++++++++++++++
>  2 files changed, 158 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/s390x/resets.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 3138a916574a..fe1ea294730c 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -36,6 +36,7 @@ TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
>  
>  TEST_GEN_PROGS_s390x = s390x/memop
>  TEST_GEN_PROGS_s390x += s390x/sync_regs_test
> +TEST_GEN_PROGS_s390x += s390x/resets
>  TEST_GEN_PROGS_s390x += dirty_log_test
>  TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
>  
> diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
> new file mode 100644
> index 000000000000..4e173517f909
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/s390x/resets.c
> @@ -0,0 +1,157 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Test for s390x CPU resets
> + *
> + * Copyright (C) 2020, IBM
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +
> +#define VCPU_ID 3
> +
> +struct kvm_vm *vm;
> +struct kvm_run *run;
> +struct kvm_sync_regs *regs;
> +static uint64_t regs_null[16];
> +
> +static uint64_t crs[16] = { 0x40000ULL,
> +			    0x42000ULL,
> +			    0, 0, 0, 0, 0,
> +			    0x43000ULL,
> +			    0, 0, 0, 0, 0,
> +			    0x44000ULL,
> +			    0, 0
> +};
> +
> +static void guest_code_initial(void)
> +{
> +	/* Round toward 0 */
> +	uint32_t fpc = 0x11;
> +
> +	/* Dirty registers */
> +	asm volatile (
> +		"	lctlg	0,15,%0\n"
> +		"	sfpc	%1\n"
> +		: : "Q" (crs), "d" (fpc));
> +	GUEST_SYNC(0);
> +}
> +
> +static void test_one_reg(uint64_t id, uint64_t value)
> +{
> +	struct kvm_one_reg reg;
> +	uint64_t eval_reg;
> +
> +	reg.addr = (uintptr_t)&eval_reg;
> +	reg.id = id;
> +	vcpu_get_reg(vm, VCPU_ID, &reg);
> +	TEST_ASSERT(eval_reg == value, "value == %s", value);
> +}
> +
> +static void assert_clear(void)
> +{
> +	struct kvm_sregs sregs;
> +	struct kvm_regs regs;
> +	struct kvm_fpu fpu;
> +
> +	vcpu_regs_get(vm, VCPU_ID, &regs);
> +	TEST_ASSERT(!memcmp(&regs.gprs, regs_null, sizeof(regs.gprs)), "grs == 0");
> +
> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
> +	TEST_ASSERT(!memcmp(&sregs.acrs, regs_null, sizeof(sregs.acrs)), "acrs == 0");
> +
> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
> +	TEST_ASSERT(!memcmp(&fpu.fprs, regs_null, sizeof(fpu.fprs)), "fprs == 0");
> +}
> +
> +static void assert_initial(void)
> +{
> +	struct kvm_sregs sregs;
> +	struct kvm_fpu fpu;
> +
> +	vcpu_sregs_get(vm, VCPU_ID, &sregs);
> +	TEST_ASSERT(sregs.crs[0] == 0xE0UL, "cr0 == 0xE0");
> +	TEST_ASSERT(sregs.crs[14] == 0xC2000000UL, "cr14 == 0xC2000000");
> +	TEST_ASSERT(!memcmp(&sregs.crs[1], regs_null, sizeof(sregs.crs[1]) * 12),
> +		    "cr1-13 == 0");
> +	TEST_ASSERT(sregs.crs[15] == 0, "cr15 == 0");
> +
> +	vcpu_fpu_get(vm, VCPU_ID, &fpu);
> +	TEST_ASSERT(!fpu.fpc, "fpc == 0");
> +
> +	test_one_reg(KVM_REG_S390_GBEA, 1);
> +	test_one_reg(KVM_REG_S390_PP, 0);
> +	test_one_reg(KVM_REG_S390_TODPR, 0);
> +	test_one_reg(KVM_REG_S390_CPU_TIMER, 0);
> +	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
> +}
> +
> +static void assert_normal(void)
> +{
> +	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
> +}
> +
> +static void test_normal(void)
> +{
> +	printf("Testing notmal reset\n");

s/notmal/normal/

With the typo fixed:

Reviewed-by: Thomas Huth <thuth@redhat.com>

