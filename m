Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AA971306D
	for <lists+kvm@lfdr.de>; Sat, 27 May 2023 01:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231341AbjEZXki (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 19:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjEZXkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 19:40:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80859E
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:40:35 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-babb51cb4d4so2726992276.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 16:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685144435; x=1687736435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qv9ISfcY41LsCwFhEwPuPEO0ZWL9q149vyTAiR7wdcA=;
        b=a2/HQ5o1JBHfDZn7qjEcYSZV+751iZLmguAJfDxVxD2bA/jEPWQ5NJmZcaL5wu2piR
         hbl0Zxdy1u+U2SkTtktsuTjLF+wCJ/h68PlqpV0spKVOalBIY7GbpX6daA/sK/vObOyh
         tYYr+VkKFSnVvIq1tA1Er5N0QIsTr1bxanZipYpKMrsjK19tGMg4fLXYOTJNBWQt30Pr
         IpSTMU+pNj2rLnXmKI+BAcd4FtUs/56RAuJfTtX33gvRUZvTdSfFYHX+i5yb8OObvA4i
         2+Wt7Ewd5FK3UZP0VaxYnIr/zT9//Pi+AfwxQjRMFe2mWzGyDujKn6nNPJq0YrHhgSJo
         l5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685144435; x=1687736435;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qv9ISfcY41LsCwFhEwPuPEO0ZWL9q149vyTAiR7wdcA=;
        b=gbmwf4IaTeatSodw+8lSbI+ZEHfNO2H21u/wRgS7r/kb9nLQqB5bSrGTCJb8ciU7l2
         UWeKiHAjFR3YPtSc0VLtFNsV6TPOrYYJ9Pve0cHRayhIUU//WjR526sppDcdNrRTiBiK
         YIb0SPqqhLj919MZk3mim2pYS5fSe+fxv29evb3yRj4UXiih3IrMaNGAvbOgyicic427
         aX2f6gep+uhOwg0HeMBgpuHMFE1F/awIQxc838x/5dgVANil7WYmO8LvNtugge3QCxx2
         Uo4Zh2n3vRdV3r1KryKlsheeo720fCpNQka4WJUdajcQ5FBYPz+PDgLgdSouF0k94UA8
         DiTg==
X-Gm-Message-State: AC+VfDxjHau8dHtmv3L8+G3C8VwYOKVlEw2Z5urTd451hL4xcDfeSkow
        KpHsGlb+WZZegPTc33x1X0y4eFnXBkM=
X-Google-Smtp-Source: ACHHUZ78PtH+viUBbI/NrYjorkwHGRg+ua0YN+q4s5vXPguXtO8CoISVLPMzv/AJSGQcDS8imOftCmPStBU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aaef:0:b0:bad:e8b:17d4 with SMTP id
 t102-20020a25aaef000000b00bad0e8b17d4mr1286566ybi.7.1685144434993; Fri, 26
 May 2023 16:40:34 -0700 (PDT)
Date:   Fri, 26 May 2023 16:40:33 -0700
In-Reply-To: <20230525183347.2562472-4-mhal@rbox.co>
Mime-Version: 1.0
References: <20230525183347.2562472-1-mhal@rbox.co> <20230525183347.2562472-4-mhal@rbox.co>
Message-ID: <ZHFDcUcgvRXB/w/g@google.com>
Subject: Re: [PATCH 3/3] KVM: selftests: Add test for race in kvm_recalculate_apic_map()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023, Michal Luczaj wrote:
> Keep switching between LAPIC_MODE_X2APIC and LAPIC_MODE_DISABLED during
> APIC map construction.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../kvm/x86_64/recalc_apic_map_race.c         | 110 ++++++++++++++++++
>  2 files changed, 111 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 7a5ff646e7e7..c9b8f16fb23f 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -116,6 +116,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
>  TEST_GEN_PROGS_x86_64 += x86_64/amx_test
>  TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
>  TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
> +TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_race
>  TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>  TEST_GEN_PROGS_x86_64 += demand_paging_test
>  TEST_GEN_PROGS_x86_64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
> new file mode 100644
> index 000000000000..1122df858623
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/recalc_apic_map_race.c
> @@ -0,0 +1,110 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * recalc_apic_map_race
> + *
> + * Test for a race condition in kvm_recalculate_apic_map().
> + */
> +
> +#include <sys/ioctl.h>
> +#include <pthread.h>
> +#include <time.h>
> +
> +#include "processor.h"
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "apic.h"
> +
> +#define TIMEOUT			5	/* seconds */
> +#define STUFFING		100
> +
> +#define LAPIC_MODE_DISABLED	0
> +#define LAPIC_MODE_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
> +#define MAX_XAPIC_ID		0xff
> +
> +static int add_vcpu(struct kvm_vm *vm, long id)
> +{
> +	int vcpu = __vm_ioctl(vm, KVM_CREATE_VCPU, (void *)id);
> +
> +	static struct {
> +		struct kvm_cpuid2 head;
> +		struct kvm_cpuid_entry2 entry;
> +	} cpuid = {
> +		.head.nent = 1,
> +		/* X86_FEATURE_X2APIC */
> +		.entry = {
> +			.function = 0x1,
> +			.index = 0,
> +			.ecx = 1UL << 21
> +		}
> +	};
> +
> +	ASSERT_EQ(ioctl(vcpu, KVM_SET_CPUID2, &cpuid.head), 0);
> +
> +	return vcpu;
> +}
> +
> +static void set_apicbase(int vcpu, u64 mode)
> +{
> +	struct {
> +		struct kvm_msrs head;
> +		struct kvm_msr_entry entry;
> +	} msr = {
> +		.head.nmsrs = 1,
> +		.entry = {
> +			.index = MSR_IA32_APICBASE,
> +			.data = mode
> +		}
> +	};
> +
> +	ASSERT_EQ(ioctl(vcpu, KVM_SET_MSRS, &msr.head), msr.head.nmsrs);
> +}
> +
> +static void *race(void *arg)
> +{
> +	struct kvm_lapic_state state = {};
> +	int vcpu = *(int *)arg;
> +
> +	while (1) {
> +		/* Trigger kvm_recalculate_apic_map(). */
> +		ioctl(vcpu, KVM_SET_LAPIC, &state);
> +		pthread_testcancel();
> +	}
> +
> +	return NULL;
> +}
> +
> +int main(void)
> +{
> +	int vcpu0, vcpuN, i;
> +	struct kvm_vm *vm;
> +	pthread_t thread;
> +	time_t t;
> +
> +	vm = vm_create_barebones();
> +	vm_create_irqchip(vm);

All of these open coded ioctl() calls is unnecessary.  Ditto for the fancy
stuffing, which through trial and error I discovered is done to avoid having
vCPUs with aliased xAPIC IDs, which would cause KVM to bail before triggering
the bug.  It's much easier to just create the max number of vCPUs and enable
x2APIC on all of them.

This can all be distilled down to:

// SPDX-License-Identifier: GPL-2.0-only
/*
 * recalc_apic_map_race
 *
 * Test for a race condition in kvm_recalculate_apic_map().
 */

#include <sys/ioctl.h>
#include <pthread.h>
#include <time.h>

#include "processor.h"
#include "test_util.h"
#include "kvm_util.h"
#include "apic.h"

#define TIMEOUT		5	/* seconds */

#define LAPIC_DISABLED	0
#define LAPIC_X2APIC	(MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)
#define MAX_XAPIC_ID	0xff

static void *race(void *arg)
{
	struct kvm_lapic_state lapic = {};
	struct kvm_vcpu *vcpu = arg;

	while (1) {
		/* Trigger kvm_recalculate_apic_map(). */
		vcpu_ioctl(vcpu, KVM_SET_LAPIC, &lapic);
		pthread_testcancel();
	}

	return NULL;
}

int main(void)
{
	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
	struct kvm_vcpu *vcpuN;
	struct kvm_vm *vm;
	pthread_t thread;
	time_t t;
	int i;

	kvm_static_assert(KVM_MAX_VCPUS > MAX_XAPIC_ID);

	/*
	 * Creating the max number of vCPUs supported by selftests so that KVM
	 * has decent amount of work to do when recalculating the map, i.e. to
	 * make the problematic window large enough to hit.
	 */
	vm = vm_create_with_vcpus(KVM_MAX_VCPUS, NULL, vcpus);

	/*
	 * Enable x2APIC on all vCPUs so that KVM doesn't bail from the recalc
	 * due to vCPUs having aliased xAPIC IDs (truncated to 8 bits).
	 */
	for (i = 0; i < KVM_MAX_VCPUS; i++)
		vcpu_set_msr(vcpus[i], MSR_IA32_APICBASE, LAPIC_X2APIC);

	ASSERT_EQ(pthread_create(&thread, NULL, race, vcpus[0]), 0);

	vcpuN = vcpus[KVM_MAX_VCPUS - 1];
	for (t = time(NULL) + TIMEOUT; time(NULL) < t;) {
		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_X2APIC);
		vcpu_set_msr(vcpuN, MSR_IA32_APICBASE, LAPIC_DISABLED);
	}

	ASSERT_EQ(pthread_cancel(thread), 0);
	ASSERT_EQ(pthread_join(thread, NULL), 0);

	kvm_vm_release(vm);

	return 0;
}
