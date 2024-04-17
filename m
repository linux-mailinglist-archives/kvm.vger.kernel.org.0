Return-Path: <kvm+bounces-14914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C878A79D1
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 02:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B0C61C224AC
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42F3917F7;
	Wed, 17 Apr 2024 00:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="cM+T9akk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF4FA40
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 00:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713313511; cv=none; b=qaUg6P8fT7SUanqURDwQU4Du5G+dO0nCo7PL4bXvs5qdux7JQhk1WySEfzgJfJ6rJId+upZIUb/TlaJ3k9i8rPCuviB5cs8YwZx5Wx2NsCF/izDt8xvgQnhOlEAkz2lxyHfjjxCkMzFn9yT+c34fFv9WuY05KrXLFjlIjLfXJ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713313511; c=relaxed/simple;
	bh=Rh0Xk5SOWgUhEYkDCx1Ih3fJwkSpqZ2vOp0lA0MHWwE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jdsVdnRhsY0zdldcFmfYblDIvIkML2S7yD1GldYjlQtTmsmOLBPPOY3aLEVDL0UhjwocDrTubZgQy10SCdNOnyfJq22IXg3PkC3VLZe/rBueEnVGPa9wPsTVrQo6XdyPnIAD51x64S6a8JR5HNcWPuquZcv7xt5I0BP6LS+Hg3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=cM+T9akk; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5ce07cf1e5dso3043971a12.2
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713313508; x=1713918308; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yUu9r75IkkkPMJX8JtgPk9s/mlLbxcj8MCkbLeGGpmg=;
        b=cM+T9akkTLdGr6P4CwMEaI3wC+DwudHkkTorB3cYyEiDSFhKdzlvEssT0MKCFKICwP
         9x9zDEvZI3Ev6H7LuMrjUWy1hDPvy23g5At85VPXB0POcWsIcEFI8tryJk9XBmPj79+M
         XeasO3QSNwGz6YJ8F1Dgso6oNugWGBJcSmEWbgt4cX/GaakCDiGQBkmtMe12QifUo+9h
         JKCQxEIVZ4KHlfktVHpNx/i8etcZQfrkCbhhaFZEfdGJf218/usTZ1p+oxtupw9dUvpv
         fs3GO4JdnRxSTXnL/aK+0b/6IyQowCMTlHTPp9wyOOsU+GAu+lGR2fCml5IAnCy9yIpx
         VXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713313508; x=1713918308;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yUu9r75IkkkPMJX8JtgPk9s/mlLbxcj8MCkbLeGGpmg=;
        b=uiIFVir1lYA7SCugdkdowdK/WlMC1AwnI+48cdCIMsMwvF1Eo+GS+043X/mLCdIwKS
         EFDIWmWodDHk2AtBg1ydPw9h4tqdYSf+pxBrO/PwZ3bvk3BNmdNZQt6Cong6VHVCZfui
         vqIoeesqvDIoiIvVuiT4GdtidS9HyfQ/3z4nXzb/81mzOQTfixhjJI1/46YGyOu0erhW
         BZdolH6epT4xZGK16Q3yGKVEasU7ZD1RZWB7yOedNjbtgGgxiPtqsoyYFOEWTX/V8kV2
         UUEPq13LFCuGhd09ba0EpNzCuU+h0BPVxckJRw66EYcSddaRk135Xl+emJ69X7chZ0+p
         zORA==
X-Forwarded-Encrypted: i=1; AJvYcCVVt6PncGs5M2sJ/3CXqUx0FIc0LUDBXyGpZnH5IyULnV/JqQN94haeWKFa9XCOC29NjqdOhZJE9t/UBN15LrkqRk0m
X-Gm-Message-State: AOJu0YyqSds6KkjXDgVTF2oReVLIPlm81U9DlAFcDLJRMK0KFvEQH0dO
	B8EI5p+ChTegBVZqNwxZcPt4/vlbm2XgEZRThliKSzken+e2guWgxgarFPdrugg=
X-Google-Smtp-Source: AGHT+IEjAhZVEZYdLBhENvub7H3p131EKgJJzeOWPQQXzU8sWnGpkTKyBYXR/NYgQcPVm7q8baUaNA==
X-Received: by 2002:a05:6a20:d492:b0:1a9:cd84:2f31 with SMTP id im18-20020a056a20d49200b001a9cd842f31mr13414753pzb.58.1713313508368;
        Tue, 16 Apr 2024 17:25:08 -0700 (PDT)
Received: from [172.16.0.69] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902684c00b001e3d2314f3csm10574125pln.141.2024.04.16.17.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 17:25:08 -0700 (PDT)
Message-ID: <aceaaeba-61cb-44fa-8639-e30a86ef8cd8@rivosinc.com>
Date: Tue, 16 Apr 2024 17:25:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] perf kvm: Add kvm stat support on riscv
Content-Language: en-US
To: Shenlin Liang <liangshenlin@eswincomputing.com>, anup@brainfault.org,
 atishp@atishpatra.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
 namhyung@kernel.org, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, linux-perf-users@vger.kernel.org
References: <20240415031131.23443-1-liangshenlin@eswincomputing.com>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240415031131.23443-1-liangshenlin@eswincomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/14/24 20:11, Shenlin Liang wrote:
> Changes from v1->v2:
> - Rebased on Linux 6.9-rc3.
> 
> 'perf kvm stat report/record' generates a statistical analysis of KVM
> events and can be used to analyze guest exit reasons. This patch tries
> to add stat support on riscv.
> 
> Map the return value of trace_kvm_exit() to the specific cause of the
> exception, and export it to userspace.
> 
> It records on two available KVM tracepoints for riscv: "kvm:kvm_entry"
> and "kvm:kvm_exit", and reports statistical data which includes events
> handles time, samples, and so on.
> 
> Simple tests go below:
> 
> # ./perf kvm record -e "kvm:kvm_entry" -e "kvm:kvm_exit"
> Lowering default frequency rate from 4000 to 2500.
> Please consider tweaking /proc/sys/kernel/perf_event_max_sample_rate.
> [ perf record: Woken up 18 times to write data ]
> [ perf record: Captured and wrote 5.433 MB perf.data.guest (62519 samples)
> 

I want to test these patches but couldn't build a perf for RISC-V with 
libtraceevent enabled. It fails with pkg-config dependencies when I 
tried to build it (both via buildroot and directly from kernel source).

> # ./perf kvm report
> 31K kvm:kvm_entry
> 31K kvm:kvm_exit
> 
> # ./perf kvm stat record -a
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 8.502 MB perf.data.guest (99338 samples) ]
> 
> # ./perf kvm stat report --event=vmexit
> Event name                Samples   Sample%    Time (ns)     Time%   Max Time (ns)   Min Time (ns)  Mean Time (ns)
> STORE_GUEST_PAGE_FAULT     26968     54.00%    2003031800    40.00%     3361400         27600          74274
> LOAD_GUEST_PAGE_FAULT      17645     35.00%    1153338100    23.00%     2513400         30800          65363
> VIRTUAL_INST_FAULT         1247      2.00%     340820800     6.00%      1190800         43300          273312
> INST_GUEST_PAGE_FAULT      1128      2.00%     340645800     6.00%      2123200         30200          301990
> SUPERVISOR_SYSCALL         1019      2.00%     245989900     4.00%      1851500         29300          241403
> LOAD_ACCESS                986       1.00%     671556200     13.00%     4180200         100700         681091
> INST_ACCESS                655       1.00%     170054800     3.00%      1808300         54600          259625
> HYPERVISOR_SYSCALL         21        0.00%     4276400       0.00%      716500          116000         203638
> 
> Shenlin Liang (2):
>    RISCV: KVM: add tracepoints for entry and exit events
>    perf kvm/riscv: Port perf kvm stat to RISC-V
> 
>   arch/riscv/kvm/trace.h                        | 67 ++++++++++++++++
>   arch/riscv/kvm/vcpu.c                         |  7 ++
>   tools/perf/arch/riscv/Makefile                |  1 +
>   tools/perf/arch/riscv/util/Build              |  1 +
>   tools/perf/arch/riscv/util/kvm-stat.c         | 78 +++++++++++++++++++
>   .../arch/riscv/util/riscv_exception_types.h   | 41 ++++++++++
>   6 files changed, 195 insertions(+)
>   create mode 100644 arch/riscv/kvm/trace.h
>   create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
>   create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
> 


