Return-Path: <kvm+bounces-7494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95569842CF3
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 20:36:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C79F6283762
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 19:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1F671B29;
	Tue, 30 Jan 2024 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cppJWuVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FB57B3ED
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 19:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706643328; cv=none; b=JfAvhKWsOcF9v/Dt3oZJ2NtBXoOC5etSTC1iWkYIktPzYbD4CXtB8Gyx22eCpwNEomTmdVsP+bGrMZ/7HcKmLMpf/ZlY2qSQikIxnGtaoVb+VNiF2bu6YXtKjeL/vhasUQucTZNsZFw7917M7YUT5MfKPjbgIFpgdH2m0QYqr+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706643328; c=relaxed/simple;
	bh=bQvVYhFt/Jt/s7foZVL6QcC4lHc7r3dTKIDwEVIkPzI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FQ9bWr4cFUmSCW7biTtcOGE5zRzq4f0LTVAfzYX5TNBbkCKAfZGwVmKpVPSlvL6AAqfSVsFMllHhw7M8QU8WE+h4E1D/Cx3HekSH02frPffnTC0kJISVsObyOL0s+DU07FYrl9sgKo+CEkIR9q2zmRxg9lnEMERXX/sYrDHlvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cppJWuVK; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d63c7c4248so108009a12.0
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 11:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706643326; x=1707248126; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=azEJUVIM4PtVN4M+9RuESsPThUNakWkRuFFbw54aKJs=;
        b=cppJWuVKxF05yIi0b+V3aQIcOUKEguqOV/kh6U1THpeWer+1UafVXx7u/1jVkbN+cj
         2uU3otJv9eDyfYsqDVdr6eCOfMfmIirY7LSMuf5uC584OPP75YGGdVNi5D3ssUXswKD5
         WETMg9wHZzRcdvDzqORIQjHSNtDQCzsCxuUowojkrJ6vTcTMdY2z2I4KIMn0Vvr+gITt
         LIFjcn92VFs+RaEw6HShnzBWO2eImouWIn7FAzM72IJSqJSmmrMxhsWup3KjriAK4skW
         cvcHpid82PH/1Nk4Y/emRABKaB3p+PCF2UuzzQsMQlDzDsnQ8zuByYe3uC/M2bvV/t3G
         9LVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706643326; x=1707248126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=azEJUVIM4PtVN4M+9RuESsPThUNakWkRuFFbw54aKJs=;
        b=HxcsU3jwHOiDvdda0G54lHrkFUDDvj5Yg76SQSp/7qi59PVi3tWk31TiNxOWvlRrYf
         d7XRMzCEXodJpf9eEUIAtpSRuAR/v7r+oincBgtAcDAn3VWIJsGsI2FSv6cROeBfVVBQ
         EwOGaEoQNKv0P7Uw2i3UVx2RBkS0kWUqmrp6p3tlz8qdUik2fdAK0jwhLdZYD3TOyIFG
         w0eK3PK5Y+9ugKm8jmE3M5aluOMCZl1vAAOt9WkJZkKPQoufVLPWt0Dl71JbSeSjX8kN
         7JutGSN7oKgG4c4GfhnbGd/ElqriDMrJz/U7OsduiVFAX+Q+hiWEHqEIdgyABN32p4Fn
         f41A==
X-Gm-Message-State: AOJu0Yz4RudLX++LauzxZaIHm53qC8yEMeO7aglDs3hKx681PFAN3eia
	DoW125DqE0FG6t9pf5PfuWDYOmX4Lnlfl/OEoiTYHlXFMT20lT9jFFZt56P4jI++RfhARXsQRdd
	GcA==
X-Google-Smtp-Source: AGHT+IGaTHCNHoEXTQsZYarO8p/KGi1BPVYe6bm23ozPQhFL7wWPGjCv5Kq4XLYSKqFEKVBWmaCnRJrjkR0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:6fc5:b0:290:2fa6:65ff with SMTP id
 e63-20020a17090a6fc500b002902fa665ffmr19315pjk.4.1706643326063; Tue, 30 Jan
 2024 11:35:26 -0800 (PST)
Date: Tue, 30 Jan 2024 11:35:24 -0800
In-Reply-To: <20231218161146.3554657-7-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com> <20231218161146.3554657-7-pgonda@google.com>
Message-ID: <ZblPfEi_t3BsRdN_@google.com>
Subject: Re: [PATCH V7 6/8] KVM: selftests: add library for
 creating/interacting with SEV guests
From: Sean Christopherson <seanjc@google.com>
To: Peter Gonda <pgonda@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Ryan Afranji <afranji@google.com>, 
	Erdem Aktas <erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

+TDX folks

On Mon, Dec 18, 2023, Peter Gonda wrote:
> Add interfaces to allow tests to create SEV guests. The additional
> requirements for SEV guests PTs and other state is encapsulated by the
> new vm_sev_create_with_one_vcpu() function. This can future be
> generalized for more vCPUs but the first set of SEV selftests in this
> series only uses a single vCPU.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Vishal Annapurve <vannapurve@google.com>
> Cc: Ackerly Tng <ackerleytng@google.com>
> cc: Andrew Jones <andrew.jones@linux.dev>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Originally-by: Michael Roth <michael.roth@amd.com>
> Co-developed-by: Ackerly Tng <ackerleytng@google.com>

Needs Ackerly's SoB.

> Signed-off-by: Peter Gonda <pgonda@google.com>
> ---
>  include/uapi/linux/kvm.h                      |   2 +-
>  tools/arch/x86/include/asm/kvm_host.h         |   2 +
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../testing/selftests/kvm/include/sparsebit.h |  22 ++
>  .../selftests/kvm/include/x86_64/processor.h  |   2 +
>  .../selftests/kvm/include/x86_64/sev.h        |  27 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   1 +
>  .../selftests/kvm/lib/x86_64/processor.c      |  16 ++
>  tools/testing/selftests/kvm/lib/x86_64/sev.c  | 202 ++++++++++++++++++
>  9 files changed, 274 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
>  create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 13065dd96132..251f422bcaa7 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1660,7 +1660,7 @@ struct kvm_s390_ucas_mapping {
>  #define KVM_S390_GET_CMMA_BITS      _IOWR(KVMIO, 0xb8, struct kvm_s390_cmma_log)
>  #define KVM_S390_SET_CMMA_BITS      _IOW(KVMIO, 0xb9, struct kvm_s390_cmma_log)
>  /* Memory Encryption Commands */
> -#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, unsigned long)
> +#define KVM_MEMORY_ENCRYPT_OP      _IOWR(KVMIO, 0xba, struct kvm_sev_cmd)

*sigh*

This cost me an hour of debug, partly because I was looking at tools/'s "good"
version, but mostly because I didn't expect a selftests patch to clobber KVM's uapi.

<rant>
This is an incredibly frustrating violating of basic patch principles.  Don't
include unrelated/unnecessary changes without good cause, especially not for uapi
headers.  If you do include unrelated changes, _document_ it in the changelog.
And if you don't understand _why_ something is weird, ask!

Even worse is that this series has sat on the lists for over a month, and NO ONE
tested it.  I can kinda sorta see how Peter missed this, e.g. if the host kernel
was build from the same source as the selftests.  But I have a very, very hard time
believing that every other person that peeked at a _selftests_ series rebuilt and
rebooted their hosts using that series.

If this were some obscure series that was touching an area of KVM that few devs
care about, I wouldn't react so strongly.  But there are how many developers working
on SNP and TDX?  10?  15?  20?

I have made it _abundantly_ clear, over, and over, that tests are a hard requirement
for new features.  Yet I see *zero* review/testing activity on this series or Sagi's
TDX selftests series.  Some of the flaws in this series are design-ish problems,
i.e. not things I would expect everyone to be able to independently identify and/or
address, but there are also a number of glaring flaws that anyone giving this more
than a cursory glance would pick out.  E.g. this patch adds an SEV library, but then
the series doesn't bother to use it to dedup the existing code in sev_migrate_test.c.

If y'all want SNP or TDX support to go anywhere but the backburner, cycles need
to be redirected to getting selftests written, healthy, and *maintainable*.  I have
*very* limited cycles for SNP/TDX for the foreseeable future, and I care a hell of a
lot more about having healthy, robust selftests than I do about getting SNP or TDX
merged by some arbitrary deadline.
</rant>

> @@ -66,6 +66,28 @@ void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
>  		    unsigned int indent);
>  void sparsebit_validate_internal(const struct sparsebit *sbit);
>  
> +/*
> + * Iterate over set ranges within sparsebit @s. In each iteration,
> + * @range_begin and @range_end will take the beginning and end of the set
> + * range, which are of type sparsebit_idx_t.
> + *
> + * For example, if the range [3, 7] (inclusive) is set, within the
> + * iteration,@range_begin will take the value 3 and @range_end will take
> + * the value 7.
> + *
> + * Ensure that there is at least one bit set before using this macro with
> + * sparsebit_any_set(), because sparsebit_first_set() will abort if none
> + * are set.
> + */
> +#define sparsebit_for_each_set_range(s, range_begin, range_end)         \
> +	for (range_begin = sparsebit_first_set(s),                      \
> +	     range_end =						\

Unnecessary newline.

> +	     sparsebit_next_clear(s, range_begin) - 1;		\
> +	     range_begin && range_end;                                  \
> +	     range_begin = sparsebit_next_set(s, range_end),            \
> +	     range_end =						\
> +	     sparsebit_next_clear(s, range_begin) - 1)
> +

It probably makes sense to split this to a separate patch.  Adding APIs without
users is generally frowned upon, but I think in this case it's worth isolating
the SEV changes.

>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 4fd042112526..67cc32b1a29a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -266,6 +266,7 @@ struct kvm_x86_cpu_property {
>  #define X86_PROPERTY_MAX_PHY_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 0, 7)
>  #define X86_PROPERTY_MAX_VIRT_ADDR		KVM_X86_CPU_PROPERTY(0x80000008, 0, EAX, 8, 15)
>  #define X86_PROPERTY_PHYS_ADDR_REDUCTION	KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 6, 11)
> +#define X86_PROPERTY_SEV_C_BIT KVM_X86_CPU_PROPERTY(0x8000001F, 0, EBX, 0, 5)

Put this above X86_PROPERTY_PHYS_ADDR_REDUCTION so that they are sorted in
ascending order.

> diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> new file mode 100644
> index 000000000000..f2bac717cac1
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
> @@ -0,0 +1,202 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <stdint.h>
> +#include <stdbool.h>
> +
> +#include "kvm_util.h"
> +#include "svm_util.h"
> +#include "linux/psp-sev.h"
> +#include "processor.h"
> +#include "sev.h"
> +
> +#define SEV_FW_REQ_VER_MAJOR 0
> +#define SEV_FW_REQ_VER_MINOR 17
> +
> +enum sev_guest_state {
> +	SEV_GSTATE_UNINIT = 0,
> +	SEV_GSTATE_LUPDATE,
> +	SEV_GSTATE_LSECRET,
> +	SEV_GSTATE_RUNNING,

Spell these out, saving a few keystrokes is not worth inscrutable names.  These
enums/define also belong in sev.h

> +};
> +
> +static void sev_ioctl(int cmd, void *data)
> +{
> +	int sev_fd = open_sev_dev_path_or_exit();
> +	struct sev_issue_cmd arg = {
> +		.cmd = cmd,
> +		.data = (unsigned long)data,
> +	};
> +
> +	kvm_ioctl(sev_fd, SEV_ISSUE_CMD, &arg);
> +	close(sev_fd);
> +}
> +
> +static void kvm_sev_ioctl(struct kvm_vm *vm, int cmd, void *data)
> +{
> +	struct kvm_sev_cmd sev_cmd = {
> +		.id = cmd,
> +		.sev_fd = vm->arch.sev_fd,
> +		.data = (unsigned long)data,
> +	};
> +
> +	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_OP, &sev_cmd);
> +}
> +
> +static void sev_register_encrypted_memory(struct kvm_vm *vm,
> +					  struct userspace_mem_region *region)
> +{
> +	struct kvm_enc_region range = {
> +		.addr = region->region.userspace_addr,
> +		.size = region->region.memory_size,
> +	};
> +
> +	vm_ioctl(vm, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
> +}
> +
> +static void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa,
> +				   uint64_t size)
> +{
> +	struct kvm_sev_launch_update_data update_data = {
> +		.uaddr = (unsigned long)addr_gpa2hva(vm, gpa),
> +		.len = size,
> +	};
> +
> +	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &update_data);
> +}
> +

The APIs that are effectively wrappers to KVM ioctls() should be globally visible,
e.g. to allow mixing in match them in negative tests that want to do "dumb" things
on a half-baked VM.

> +static void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
> +{
> +	struct kvm_sev_launch_start launch_start = {
> +		.policy = policy,
> +	};
> +	struct userspace_mem_region *region;
> +	struct kvm_sev_guest_status status;
> +	int ctr;
> +
> +	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &launch_start);
> +	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &status);
> +
> +	TEST_ASSERT(status.policy == policy, "Expected policy %d, got %d",
> +		    policy, status.policy);

	TEST_ASSERT_EQ() will do the heavy lifting for you.

> +static void sev_vm_measure(struct kvm_vm *vm)
> +{
> +	uint8_t measurement[512];
> +	int i;
> +
> +	sev_vm_launch_measure(vm, measurement);
> +
> +	/* TODO: Validate the measurement is as expected. */
> +	pr_debug("guest measurement: ");
> +	for (i = 0; i < 32; ++i)
> +		pr_debug("%02x", measurement[i]);
> +	pr_debug("\n");
> +}

Meh, this isn't helpful for a test, e.g. the average user isn't never going to do
anything useful with the measurement info.

