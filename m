Return-Path: <kvm+bounces-64869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 925CEC8E2D5
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 13:04:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 418073AA6EA
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 12:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8574C32B987;
	Thu, 27 Nov 2025 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UcmqPjw7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7D5302158
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 12:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764245061; cv=none; b=KSEFcN/4dg8TvhaGhb9jSPofKE845P0Hn1W2dgVCBZZ4BbKzVBVrS8zoQFtL11CKueHig/J2bRUCFJMnpmtRD0RyKbSVpx/iNFv7U5xy/vphZuitPbTLdZEMnE+CBtSYFSJqkFsB/+eUI0/sT5ohGp+Rdo+xtFsEVkDzBwJnsW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764245061; c=relaxed/simple;
	bh=vcSXBRpRjVeGJFE9km19JH+aMnIZwPimIcdlAG4Ob/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ell7QJGVSnG64VnxxtNCFt/6lyjkMcBPiJOOXmyFA1Wjzj6uZDjNvx4hlGPTupySEMNA7EKUR4tVUGE0LHHlNm0zbjDucjPTUPNYhHu3Un8sYBpGCsu3UiSYD5fowf6B+WlHZMEablAYJ+Pq/BZy+yjSM+vJYWS6X2swfuVge/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UcmqPjw7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764245059;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TUjVZ+gcdBFdHXG7icB0DaRoz7GxwtKyjiMLmgn2VbY=;
	b=UcmqPjw7E6JI7RDEWIiLsnh3JPOP0DV+ntIpoh+7tzsHO3a0dPUc7tbfmJSXY4QcVdkH4M
	0J8zRDDpK1VMpZLa/mjVCuDtjf8zBaUW5vb4HYWjJclhBf5nbfuKh8Kd/X376R25blE3I8
	vwi6raWvf/odiyj0E9mXNLxxGy9pQhE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-nL7TDFYKP5yGRZsgnb95gg-1; Thu, 27 Nov 2025 07:04:12 -0500
X-MC-Unique: nL7TDFYKP5yGRZsgnb95gg-1
X-Mimecast-MFC-AGG-ID: nL7TDFYKP5yGRZsgnb95gg_1764245052
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b233e206ddso144002185a.3
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 04:04:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764245052; x=1764849852;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUjVZ+gcdBFdHXG7icB0DaRoz7GxwtKyjiMLmgn2VbY=;
        b=Nq6v/YQHTfSZhaqgVMf5J02yznPZX9Z2efgG4cdCN+ys3un4gOVz7EEhetQKFhLsfp
         Lzbv2mdMc3wOMFlNIlHLzKqxxtCZMkDGU5Mun2naHcqzGexDYKRi69JiLK7trIc8juYQ
         7VAOGjsVG17z4KE40PJaNEqZ5Fj5oFHmPCaVR+2NWbLrPDLPW2sJub8XFMoTgs1s/ZTH
         +wHFsY77VnoFKYcuEy1UT0pgho6VfaWxkMdjiADYn3WV5rZUbB5NP86gVxLN/4j6URwV
         RTx2rx4w25Dmn9/sf8DL3Yj0IFy7vf4OI/Fqym+ztKX+Zzf7faIxwTDWN86kyphMlZPF
         N66A==
X-Gm-Message-State: AOJu0YyJcbnTMru1pApvGJfS1CzIbkC+XZFzy5Hb3xZm7owWiX2OWr8M
	o3NEj22j+OrB+RX6Yi74uoE51P6CpG/uuw7njt1YpH0NxtHg7fStYrgIQCxEoRB2VQXLq7ip91x
	V3wRK5rtyJB+z6L5A5krovuYfdrmwPefKdt1/WMdaJ6EJB7+aRqssFg==
X-Gm-Gg: ASbGnctVCJj0e8FFRiY+Hj/q/866qx9Ojx+4cddaLGy81Db5vIt98W0cFw6BsHgNgYP
	ZEkox7iOAFMGM3pxCHnMMTH2LDKDrq5yDDyfnRxpMQ4R+RlyxYh/+62KHzgIbbelRo6R3LJMIlD
	mzcgs2w4OsCNraMrdQULc+/jQC0f6Mczky+ZMECq/2xaORJ0qJhGIDeswGXoSdGyV3z5Nthp66R
	+u5/PGnz90wZHQkqh/+wbbnk7IjlmsH8SRW+Ca2D+w0p/llPXjwLm3CL+VJAa/j+eG7xz5NwEag
	pEYTYoadXbjyLSVfwfUy2JiJXiV1mylHO20GUeX/BLCQNDjF+8PaOmP1Y+3xXGhoYEkPYzA5KfI
	/movqXTBcmM/4dGIWGZwC0/m2pF52aBef/pO82su9fEzfD10m/yaTU3pt6Q==
X-Received: by 2002:a05:620a:4709:b0:8b2:5fa9:61 with SMTP id af79cd13be357-8b33d267d7bmr3011830685a.25.1764245052090;
        Thu, 27 Nov 2025 04:04:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7AU1H8HX4rSD8NL5MRN6YXPh1SkI42ZloscGdOxWAXNWPrUmGzHDfCOVRgii92cyc2qmrPQ==
X-Received: by 2002:a05:620a:4709:b0:8b2:5fa9:61 with SMTP id af79cd13be357-8b33d267d7bmr3011826085a.25.1764245051650;
        Thu, 27 Nov 2025 04:04:11 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1df6b9sm92833385a.53.2025.11.27.04.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 04:04:10 -0800 (PST)
Message-ID: <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
Date: Thu, 27 Nov 2025 13:04:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, andrew.jones@linux.dev,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20251127110832.GA3240191@e124191.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 11/27/25 12:08 PM, Joey Gouly wrote:
> On Thu, Nov 27, 2025 at 11:04:43AM +0100, Eric Auger wrote:
>> Hi Joey,
>>
>> On 9/25/25 4:19 PM, Joey Gouly wrote:
>>> Hi all,
>>>
>>> This series is for adding support to running the kvm-unit-tests at EL2. These
>>> have been tested with Linux 6.17-rc6 KVM nested virt.
>>>
>>> This latest round I also tested using the run_tests.sh script with QEMU TCG,
>>> running at EL2.
>>>
>>> The goal is to later extend and add new tests for Nested Virtualisation,
>>> however they should also work with bare metal as well.
>>>
>>> Changes since v2[1]:
>>> 	- Move the sctlr setup in EFI to a function.
>>> 	- Decided to not re-use el2_setup.h from Linux, looked more
>>> 	  complicated to use than needed for KUT.
>>> 	- Add EL2 env variable for testing, open to feedback for that.
>>> 	  This was untested with kvmtool as my testing setup only has
>>> 	  busybox ash currently, and the run_tests.sh script needs bash.
>>>
>>> Issues (that I think are fine to investigate/fix later):
>>> 	- Some of the debug tests fail with QEMU at EL2 and kvmtool.
>>> 	- The gic ipi test times out with QEMU at EL2, but works with kvmtool.
>> Have you noticed any failure with migration tests. On my end, as soon as
>> I set EL2=1 migration tests do fail.
> Yes migration also fails here, forgot to mention that.
>
> Seems like migration completes, but then something bad happens on the first
> interrupt. I will investigate a bit now and see if it's an easy fix.

while you do that I will go through the series. My apologies for the delay

Eric
>
> Thanks,
> Joey
>
>> Eric
>>> Thanks,
>>> Joey
>>>
>>> [1] https://lore.kernel.org/kvmarm/20250529135557.2439500-1-joey.gouly@arm.com/
>>>
>>> Alexandru Elisei (2):
>>>   arm64: micro-bench: use smc when at EL2
>>>   arm64: selftest: update test for running at EL2
>>>
>>> Joey Gouly (8):
>>>   arm64: drop to EL1 if booted at EL2
>>>   arm64: efi: initialise SCTLR_ELx fully
>>>   arm64: efi: initialise the EL
>>>   arm64: timer: use hypervisor timers when at EL2
>>>   arm64: micro-bench: fix timer IRQ
>>>   arm64: pmu: count EL2 cycles
>>>   arm64: run at EL2 if supported
>>>   arm64: add EL2 environment variable
>>>
>>>  arm/cstart64.S             | 56 ++++++++++++++++++++++++++++++++++++--
>>>  arm/efi/crt0-efi-aarch64.S |  5 ++++
>>>  arm/micro-bench.c          | 26 ++++++++++++++++--
>>>  arm/pmu.c                  | 13 ++++++---
>>>  arm/run                    |  7 +++++
>>>  arm/selftest.c             | 18 ++++++++----
>>>  arm/timer.c                | 10 +++++--
>>>  lib/acpi.h                 |  2 ++
>>>  lib/arm/asm/setup.h        |  8 ++++++
>>>  lib/arm/asm/timer.h        | 11 ++++++++
>>>  lib/arm/setup.c            |  4 +++
>>>  lib/arm/timer.c            | 19 +++++++++++--
>>>  lib/arm64/asm/sysreg.h     | 19 +++++++++++++
>>>  lib/arm64/processor.c      | 12 ++++++++
>>>  14 files changed, 191 insertions(+), 19 deletions(-)
>>>


