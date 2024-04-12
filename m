Return-Path: <kvm+bounces-14384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 597608A2566
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2490B238D3
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 04:56:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F5C17BA9;
	Fri, 12 Apr 2024 04:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HzZEmtbc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EDF1B974
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 04:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712897804; cv=none; b=iUpmzggCRkaM21U+GU8Xwn8XzniyXtgOK1s9aDVEMo7ys+W/jJ8gyIjMOoUyUYtfVclmpNtSOOOseDa9j0Q4yagTzRnjj82JDoPHpMC/yUIyy/86g9RNU0NxS3zq36C/1K19MIoFGCTsC2Wq3y4g8BqHuMUi8JAArss0lpWjRyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712897804; c=relaxed/simple;
	bh=3BVECkjKWPbyqchU1j/oKY0/VzfucM7JP8zNKfPqr64=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=prNVaL8Bnv62QzCZJdKPo6GvkdlnBz6JTO78s98w9pRET4MFUOa0lJNmZI35xB+SWt/Tguz4zQI1xKchokuzZmmCH8VAl0bvWvsfHOywfX+mzFXhHUXgApVQokd2DDD0r9wEaIV9o8y2ncF+U8aF0O71WF+YSwNRdBj01opG/1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HzZEmtbc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso841325276.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 21:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712897801; x=1713502601; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cqWwq/YjmJyQ4CvXHHLBMD+DqXASBJiMvQ6ZfNbBSk8=;
        b=HzZEmtbcqm1oka6OUPSmcQSMMsGYdK6fRKMHQBoIrJfJiGaTpqxILgZ1nGwGT+QgrT
         6Wl68yKtzZRRi0JASQDooMl525+30GOZmtckRGKqwfNHoI/X0hw0vQzTilaPdgA8dVOb
         Akzeqjy8xWPyp0v4hQSpH+Kh1r8K1fqnvNZgZOoUIno6/jjkutEqYYt4B7NrofRfKRia
         mf+DWFAZ/EDO71tw8W4T1Msw6Gk7pnq373g1NY2yFUR08pm8s1Nu7IxobOALa5IYg9en
         Fq5GxMVvMy+5MG8UANtdUNJfbMOCTZM7DAGFfdveIGpj/EjIgaEGaonDnJuTJwRSIHy1
         iLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712897801; x=1713502601;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cqWwq/YjmJyQ4CvXHHLBMD+DqXASBJiMvQ6ZfNbBSk8=;
        b=TXgK/Dhoeu3jKNeDcZ1zUJ8/eKviq5C+T6Q2yUtlpZeI8RQmotaTEChbDLzlQy7bek
         AvUKqBCe5nvSuhCQ/d062k8BO6euqi+/0q7v9KwzERqWqBZmnFGBfpFqvbCJlfK81Do9
         rpl+z0KzOLnyF3DaEMzPemL3A5det45cHv6mGCL5XpNSW1f9gRye49Z4JDZSem5mIP9g
         1ocKDlz8ozVvnGbr3+cV6Hs/qXKYDCPCFqKV9k74BGyOD/mesp6IWCZQ20hjs5y+NOIE
         cH5ydrFDHGufDZYNIMsSzC4vMYX178Ez7SDULV/X7I54AB3CyhVHHyessZx7Ae4miX+A
         Hi4g==
X-Forwarded-Encrypted: i=1; AJvYcCWNPwO9fXgauflks+HpDgUqo1OhGw0cQ/loU9vXMexEmvx99eivhbiG9QbQStejUo6qWEip0/QfkDSpU5LsukRTgLsT
X-Gm-Message-State: AOJu0Yxm2KytIgCSA/cR/fMOwAlEyHi4ei+RLGhtHbu1m10bOf4qMRz1
	RDMgrFOmLyDqczVI0mFHBf9njxTlamR44JrnKFxQXCVae157UGVoa3etQmj2kwiCwN1JM9wDat6
	bgFrOzcGAs87q7uhw9nt8YQ==
X-Google-Smtp-Source: AGHT+IHogRXL4LbEeXZgb/SXhHT8euqOuh88Q0krefn7tSKN+a+HFavAX4VGgrluxxBH6lf3KC3qAeiPCLP4+nYV7A==
X-Received: from ctop-sg.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:1223])
 (user=ackerleytng job=sendgmr) by 2002:a5b:c49:0:b0:dcd:3a37:65 with SMTP id
 d9-20020a5b0c49000000b00dcd3a370065mr159815ybr.7.1712897801099; Thu, 11 Apr
 2024 21:56:41 -0700 (PDT)
Date: Fri, 12 Apr 2024 04:56:36 +0000
In-Reply-To: <ZeHFlsrBKWR6bfRZ@yzhao56-desk.sh.intel.com> (message from Yan
 Zhao on Fri, 1 Mar 2024 20:09:58 +0800)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzwmp3ji0r.fsf@ctop-sg.c.googlers.com>
Subject: Re: [RFC PATCH v5 09/29] KVM: selftests: TDX: Add report_fatal_error test
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: sagis@google.com, linux-kselftest@vger.kernel.org, afranji@google.com, 
	erdemaktas@google.com, isaku.yamahata@intel.com, seanjc@google.com, 
	pbonzini@redhat.com, shuah@kernel.org, pgonda@google.com, haibo1.xu@intel.com, 
	chao.p.peng@linux.intel.com, vannapurve@google.com, runanwang@google.com, 
	vipinsh@google.com, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Yan Zhao <yan.y.zhao@intel.com> writes:

> ...
>> diff --git a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
>> index b570b6d978ff..6d69921136bd 100644
>> --- a/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
>> +++ b/tools/testing/selftests/kvm/include/x86_64/tdx/test_util.h
>> @@ -49,4 +49,23 @@ bool is_tdx_enabled(void);
>>   */
>>  void tdx_test_success(void);
>>  
>> +/**
>> + * Report an error with @error_code to userspace.
>> + *
>> + * Return value from tdg_vp_vmcall_report_fatal_error is ignored since execution
>> + * is not expected to continue beyond this point.
>> + */
>> +void tdx_test_fatal(uint64_t error_code);
>> +
>> +/**
>> + * Report an error with @error_code to userspace.
>> + *
>> + * @data_gpa may point to an optional shared guest memory holding the error
>> + * string.
>> + *
>> + * Return value from tdg_vp_vmcall_report_fatal_error is ignored since execution
>> + * is not expected to continue beyond this point.
>> + */
>> +void tdx_test_fatal_with_data(uint64_t error_code, uint64_t data_gpa);
> I found nowhere is using "data_gpa" as a gpa, even in patch 23, it's
> usage is to pass a line number ("tdx_test_fatal_with_data(ret, __LINE__)").
>
>

This function tdx_test_fatal_with_data() is meant to provide a generic
interface for TDX tests to use TDG.VP.VMCALL<ReportFatalError>, and so
the parameters of tdx_test_fatal_with_data() generically allow error_code and
data_gpa to be specified.

The tests just happen to use the data_gpa parameter to pass __LINE__ to
the host VMM, but other tests in future that use the
tdx_test_fatal_with_data() function in the TDX testing library could
actually pass a GPA through using data_gpa.

>>  #endif // SELFTEST_TDX_TEST_UTIL_H
>> diff --git a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
>> index c2414523487a..b854c3aa34ff 100644
>> --- a/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
>> +++ b/tools/testing/selftests/kvm/lib/x86_64/tdx/tdx.c
>> @@ -1,8 +1,31 @@
>>  // SPDX-License-Identifier: GPL-2.0-only
>>  
>> +#include <string.h>
>> +
>>  #include "tdx/tdcall.h"
>>  #include "tdx/tdx.h"
>>  
>> +void handle_userspace_tdg_vp_vmcall_exit(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_tdx_vmcall *vmcall_info = &vcpu->run->tdx.u.vmcall;
>> +	uint64_t vmcall_subfunction = vmcall_info->subfunction;
>> +
>> +	switch (vmcall_subfunction) {
>> +	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
>> +		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
>> +		vcpu->run->system_event.ndata = 3;
>> +		vcpu->run->system_event.data[0] =
>> +			TDG_VP_VMCALL_REPORT_FATAL_ERROR;
>> +		vcpu->run->system_event.data[1] = vmcall_info->in_r12;
>> +		vcpu->run->system_event.data[2] = vmcall_info->in_r13;
>> +		vmcall_info->status_code = 0;
>> +		break;
>> +	default:
>> +		TEST_FAIL("TD VMCALL subfunction %lu is unsupported.\n",
>> +			  vmcall_subfunction);
>> +	}
>> +}
>> +
>>  uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size,
>>  				      uint64_t write, uint64_t *data)
>>  {
>> @@ -25,3 +48,19 @@ uint64_t tdg_vp_vmcall_instruction_io(uint64_t port, uint64_t size,
>>  
>>  	return ret;
>>  }
>> +
>> +void tdg_vp_vmcall_report_fatal_error(uint64_t error_code, uint64_t data_gpa)
>> +{
>> +	struct tdx_hypercall_args args;
>> +
>> +	memset(&args, 0, sizeof(struct tdx_hypercall_args));
>> +
>> +	if (data_gpa)
>> +		error_code |= 0x8000000000000000;
>> 
> So, why this error_code needs to set bit 63?
>
>

The Intel GHCI Spec says in R12, bit 63 is set if the GPA is valid. As a
generic TDX testing library function, this check allows the user to use
tdg_vp_vmcall_report_fatal_error() with error_code and data_gpa and not
worry about setting bit 63 before calling
tdg_vp_vmcall_report_fatal_error(), though if the user set bit 63 before
that, there is no issue.

>> +	args.r11 = TDG_VP_VMCALL_REPORT_FATAL_ERROR;
>> +	args.r12 = error_code;
>> +	args.r13 = data_gpa;
>> +
>> +	__tdx_hypercall(&args, 0);
>> +}

>> <snip>

