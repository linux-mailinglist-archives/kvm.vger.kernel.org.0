Return-Path: <kvm+bounces-9557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 912D386193B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 18:19:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D491C23B68
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE54313B2A6;
	Fri, 23 Feb 2024 17:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FzWAhhgV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2D12D217
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 17:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708689; cv=none; b=BTWyulvLB1KHUgFA+GoUeKh1DHc+Q11R1G6lKXyi9X5NUQGMF5aSExNL4wTX++lDTgflijtfuIPSS14mC7dDOqJo0kJi+Cs4hSw3fNDYjIDTeWhZt2mDt/OfLyHq51QXGIPTm4xO0nvrFhtlSYR+Kf8mjbcSyK3ZQvoJdgKVS3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708689; c=relaxed/simple;
	bh=CY9qeG0+lVmMTzKeKYVGe+O1t9fhbi4eVVNiq6C+Z3c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rxmnlj55XY0+wb+zFK1o0BzgEW8evI23z/MViSiBgoAfysYH3FTAEL03trXAErX80lP/WefTlG7nh43QXSUwmvoDAubEJPr0769OGaOYtxkH4mRP5tWOOimBNIWLFF23Zry0n8V+aMuE4LIhwZ3fz22hRHzHE26vsSIp8wRxI9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FzWAhhgV; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60802b0afd2so8745217b3.1
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 09:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708708686; x=1709313486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pq531MjX6X7iIF0qhVxKv9aZBiATonj65HEeNAjH0dk=;
        b=FzWAhhgVtNTGJ/SLxV7evRlhMJn45t62DkEf29QTiUL3wmpT0ra0NfHSgrhWhppAJl
         f+Qi7zcTFH7C3fQ3koFQSL8/RaoPUtYr8md6x/YtqkqLFbQBG22wauNU6n43EZKcazX/
         oGKldMMYlA2IChTMV3lnNEatSRt0H75Rw74x8nK7da7xcTTNVN96QcEIfkHup/KGGu7M
         FN90mOEfQdnACA5M92AeavWz9Lc4xDz5y+F12CW2GqF54aq1W7RMrEQw+frYi4muMSqb
         JNwMsHTkSYm9V1haxop3oEbEn8xtqkNbucZZVO8HClZ3YdNUd2b7dpMGwEgEEgu6S+g0
         3nmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708708686; x=1709313486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pq531MjX6X7iIF0qhVxKv9aZBiATonj65HEeNAjH0dk=;
        b=n1/STLVHMkUz/K4Z8tjU8tYeG6Vx/GDL/uvWjh60PUx4BWWPypa5vv99vMcgnP+MJ3
         27R9Gb9oYWdlBxmOgNPeV6vHPEqDmP5QzMpu0ETZRMxcJbCP9w4hPsIYRSveXfpzSEba
         PdYvr6ItGoSPGNqpJVStkG3wncVxjncHXSw8mxApEgYpkN5zWWItvN78Sl9ysKcqZai7
         9BHJ3MM6+rLPZoWbga6BVBMoV6W00m2diSav97SEGuwfAA/6Xz2BX0ve8yo5f1S7gVPh
         39Lxx3TD36+i3Bz30Zg9kmh+bDmiDco9cT5m8a/7IY25gpuMMnAh+EeWC3WMbljzzM7J
         qOHg==
X-Forwarded-Encrypted: i=1; AJvYcCXJkhzra5iB6SyM+4QGzBqXtmji0+5z6TlE32zYpWMcbPVq/C0YJDFIlT6F/OjSIf6FLxRVmT5OHWDtYeMxCHhonUFj
X-Gm-Message-State: AOJu0YzQs+Rvujm2tIc4O0+5gS556ns6CpWVtersourVYemRKUFUsvxG
	2RCTWKf2mOtPY3j8f6eL9v0ULfdf40+/XZNhxJudVkA5vf2npsNI1no/kH1VEhd8vETgUsLmzfh
	mPA==
X-Google-Smtp-Source: AGHT+IGfWwUVVFdmUC9MwyBU6usmO1Q2+XCL8PJlmOqwVxetwZYNWAffF5GH0+/QeKHCDzF/aojCk1Louyw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad24:0:b0:607:f42f:70e1 with SMTP id
 l36-20020a81ad24000000b00607f42f70e1mr81708ywh.4.1708708686305; Fri, 23 Feb
 2024 09:18:06 -0800 (PST)
Date: Fri, 23 Feb 2024 09:18:04 -0800
In-Reply-To: <20240223104009.632194-12-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223104009.632194-1-pbonzini@redhat.com> <20240223104009.632194-12-pbonzini@redhat.com>
Message-ID: <ZdjTTK1TgN8B64zO@google.com>
Subject: Re: [PATCH v2 11/11] selftests: kvm: add tests for KVM_SEV_INIT2
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 23, 2024, Paolo Bonzini wrote:
> diff --git a/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
> new file mode 100644
> index 000000000000..644fd5757041
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/sev_init2_tests.c
> @@ -0,0 +1,146 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/kvm.h>
> +#include <linux/psp-sev.h>
> +#include <stdio.h>
> +#include <sys/ioctl.h>
> +#include <stdlib.h>
> +#include <errno.h>
> +#include <pthread.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "svm_util.h"
> +#include "kselftest.h"
> +
> +#define SVM_SEV_FEAT_DEBUG_SWAP 32u
> +
> +/*
> + * Some features may have hidden dependencies, or may only work
> + * for certain VM types.  Err on the side of safety and don't
> + * expect that all supported features can be passed one by one
> + * to KVM_SEV_INIT2.
> + *
> + * (Well, right now there's only one...)
> + */
> +#define KNOWN_FEATURES SVM_SEV_FEAT_DEBUG_SWAP
> +
> +int kvm_fd;
> +u64 supported_vmsa_features;
> +bool have_sev_es;
> +
> +static int __sev_ioctl(int vm_fd, int cmd_id, void *data)
> +{
> +	struct kvm_sev_cmd cmd = {
> +		.id = cmd_id,
> +		.data = (uint64_t)data,
> +		.sev_fd = open_sev_dev_path_or_exit(),
> +	};
> +	int ret;
> +
> +	ret = ioctl(vm_fd, KVM_MEMORY_ENCRYPT_OP, &cmd);
> +	TEST_ASSERT(ret < 0 || cmd.error == SEV_RET_SUCCESS,
> +		    "%d failed: fw error: %d\n",
> +		    cmd_id, cmd.error);
> +
> +	return ret;

If you can hold off on v3 until next week, I'll get the SEV+SEV-ES smoke test
series into a branch and thus kvm-x86/next.  Then this can take advantage of the
library files and functions that are added there.  I don't know if it will save
much code, but it'll at least provide a better place to land some of the "library"
#define and helpers.


https://lore.kernel.org/all/20240223004258.3104051-1-seanjc@google.com

> +}
> +
> +static void test_init2(unsigned long vm_type, struct kvm_sev_init *init)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create_barebones_type(vm_type);
> +	ret = __sev_ioctl(vm->fd, KVM_SEV_INIT2, init);

The SEV library provided vm_sev_ioctl() for this.
> +	TEST_ASSERT(ret == 0,
> +		    "KVM_SEV_INIT2 return code is %d (expected 0), errno: %d",
> +		    ret, errno);

	TEST
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_init2_invalid(unsigned long vm_type, struct kvm_sev_init *init)
> +{
> +	struct kvm_vm *vm;
> +	int ret;
> +
> +	vm = vm_create_barebones_type(vm_type);
> +	ret = __sev_ioctl(vm->fd, KVM_SEV_INIT2, init);

__vm_sev_ioctl() in the library.

> +	TEST_ASSERT(ret == -1 && errno == EINVAL,
> +		    "KVM_SEV_INIT2 return code %d, errno: %d (expected EINVAL)",
> +		    ret, errno);

TEST_ASSERT() will spit out the errno and it's user-friendly name.  I would prefer
the assert message to explain why failure was expected.  That way readers of the
code don't need a comment, and runners of failed tests get more info.

Hrm, though that'd require assing in a "const char *msg", which would limit this
to constant strings and no formatting.  I think that's still a net positive though.

	TEST_ASSERT(ret == -1 && errno == EINVAL,
		    "KVM_SET_INIT2 should fail, %s.", msg);

> +	kvm_vm_free(vm);
> +}
> +
> +void test_vm_types(void)
> +{
> +	test_init2(KVM_X86_SEV_VM, &(struct kvm_sev_init){});
> +
> +	if (have_sev_es)
> +		test_init2(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});
> +	else
> +		test_init2_invalid(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){});

E.g. this could be something like

		test_init2_invalid(KVM_X86_SEV_ES_VM, &(struct kvm_sev_init){},
				   "SEV-ES unsupported);

Though shouldn't vm_create_barebones_type() fail on the unsupported VM type, not
KVM_SEV_INIT2?

> +
> +	test_init2_invalid(0, &(struct kvm_sev_init){});
> +	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
> +		test_init2_invalid(KVM_X86_SW_PROTECTED_VM, &(struct kvm_sev_init){});
> +}
> +
> +void test_flags(uint32_t vm_type)
> +{
> +	int i;
> +
> +	for (i = 0; i < 32; i++)
> +		test_init2_invalid(vm_type, &(struct kvm_sev_init){
> +			.flags = 1u << i,

BIT()

> +		});

And I think I'd prefer to have the line run long?  

		test_init2_invalid(vm_type, &(struct kvm_sev_init) { .flags = BIT(i) });
> +}
> +
> +void test_features(uint32_t vm_type, uint64_t supported_features)
> +{
> +	int i;
> +
> +	for (i = 0; i < 64; i++) {
> +		if (!(supported_features & (1u << i)))
> +			test_init2_invalid(vm_type, &(struct kvm_sev_init){
> +				.vmsa_features = 1u << i,
> +			});

Rather than create &(struct kvm_sev_init) for each path, this?

		struct kvm_sev_init init = {
			.vmsa_features = BIT(i);
		};

		if (!(supported_features & BIT(i))
			test_init2_invalid(vm_type, &init);
		else if (KNOWN_FEATURES & (1u << i))
			test_init2(vm_type, &init);

> +		else if (KNOWN_FEATURES & (1u << i))
> +			test_init2(vm_type, &(struct kvm_sev_init){
> +				.vmsa_features = 1u << i,
> +			});
> +	}
> +}

