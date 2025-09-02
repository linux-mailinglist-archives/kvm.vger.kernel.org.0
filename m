Return-Path: <kvm+bounces-56597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 42147B4032E
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 15:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2939B4E2461
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 13:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B915A31CA78;
	Tue,  2 Sep 2025 13:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TZ3y6HcD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B6730C340
	for <kvm@vger.kernel.org>; Tue,  2 Sep 2025 13:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819507; cv=none; b=TCWfhyL75f9lw7ePsBXifo8OqKa2sdod40p+C1EEKPJ6okflvc4+YCqSyiGzuAyR/E1RyEv+yatSV464EBPgR/9Q8Pt9Q/genaichJcuIAB1mmz/7Bx1ZgV2RBR+llZjDrF6bt/+HNT0lCpChES0BwUqmqFTf1fUYiEq2FfuBtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819507; c=relaxed/simple;
	bh=XMFyFDijcDr/fe1dGSY8r8uFNeV6APyHh4DIt71qW9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SZ6KGH1Sp2gROhPAdCHiImHIqtAUTRa3Bm14g6tNHTglLOrHmvrAPgcG5KPvy9IkkYD3IC3JVi2t0+NvZhsZguAydI0sftfCQpI1sJb5yEACkoqq6J0FuajgFkqNaol42tGLycQMKoUhAm1VmMLofIFKXG7vBCNTGbiWBSuni4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TZ3y6HcD; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45b9814efbcso5581625e9.0
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756819504; x=1757424304; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rz/p6M0rklQHwfyQ6YvhjhFju5Y1e2Dz66wkkh69jUI=;
        b=TZ3y6HcDLBQDTjLDcRTrkkJadG5sQC4i4C9zFp/d9MFZAl1e/28EES2/LLUtmzfC0P
         eG5XMSc/Flcbifv8vhhhZQlOzi60ENtUhlr3Ir5hnWmB4kQvzJxz6vG8y//RRcHlB/CO
         sei/Ind996YEo2NqbIG1Mi+qLDPErjZP3hEuXQ3GmR7hJnScgtvPlnET0lQfYBjwSOY6
         FC5OCvyAev4Gan22/28mE15mmCT1hEsl5oGZgseAeI7mJuNdUogLr+RXsxaUC5qanHbS
         5Cxmc+hV3oDe0m8UF9RFWiZrPfcmHV3wETMzMDaHbOrvuYNlxtqCHE6GD3WurFOYpUZG
         A+qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819504; x=1757424304;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rz/p6M0rklQHwfyQ6YvhjhFju5Y1e2Dz66wkkh69jUI=;
        b=u94PuLLJZCoxrpaDBfEnhefLb9cgaXBGC53/CxtmQ7Ba3/uV+JUB2byjpJZGDnAR8d
         FsGjjEEXsVHXyN5LnzsfoIaFBJXa/+/JT8kLqjwRFMQPUuIVxxri1qquyFa90OHKqyne
         ViHx0IZPDGP/Tu7Yq0yCR7kjHfHVtHfUYM5qQJFrI30qhC4OvfMtgfSaKdRnnGmWjEwE
         ezVNCLX007gp9hO4oi6PUZkxw04upMXZzKy5eLSDiOsSLW7KdAQZ4AH4ZG0g+PHYAEJB
         G8sD5o1zU1/qdXtAV8Vmx75SDIlPWzx3N30b54n/+5okH8e3Q2GV7TgH1nXVMuezyREq
         YhZw==
X-Forwarded-Encrypted: i=1; AJvYcCWqKz1+mJbab6jPb49BQDXIvGFfAxsjXdZ+Dkh52nK+gObqDGEEGsgjVZoJsCrOlyb/zE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8f1/d18gq9Qd6dehQDmxTZGsynwJ+MSgmUWhtOtT6PfzlUOjf
	EZ9GImO4RAr3eBco8aETGGBptlbBxNy/HcgJquEunz4uf+ZzuJ15O6ROnko0EoDfVnA=
X-Gm-Gg: ASbGncu6dN7PRUHNRt6Im1bfkYIeVEtThcnpBWLkjw6rT/Qu25zpe+UU1msMYUvadcu
	sPou38IONzjkVnd2SAU6WfheW6TEgaP3OQ/0gwb1XyHoxiPLH56lWfMVXyDg+Th0+gUQ7x6J9dy
	UF/H1ddrkzQJB/Y2bGYss6pAY11TJbfkysc8pCnIcFRpJXK6GjkzBvFqaidmucj/G/hYc7pzykm
	lhYPEYO07eF9MyjRo4jAOLqSUPajhLJWXtLEVZtyEq/ubXQ4eo/qc4YhQyjCEKl6hOefteMKa2y
	fo4+GS7eXv/lGRhOh9d5GGkKsbSCR4zJv8f68SRMxrNuwnTxzLeaYn9y+QNGdjs1fk1/NCPGiV8
	s8mWImGAN9k+2vZiT8I3B8CCz5821BVM+exjhnjilfzqTjEFCAvUNEBxt6qUXLp7tBOv1YP/X+B
	gQ
X-Google-Smtp-Source: AGHT+IEYmruxNHSN7LVlQ+61cQOiuO9GUpOJdI4vg0itRWRn52yE5aUCbQ+D5IlmMUWkcOPQ5loTdw==
X-Received: by 2002:a5d:5712:0:b0:3dc:db:89f3 with SMTP id ffacd0b85a97d-3dc00db8a77mr46469f8f.16.1756819504134;
        Tue, 02 Sep 2025 06:25:04 -0700 (PDT)
Received: from [192.168.69.207] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fbd01sm20127940f8f.13.2025.09.02.06.25.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 06:25:03 -0700 (PDT)
Message-ID: <baa2f292-c29c-4045-8470-a9c7387cf98a@linaro.org>
Date: Tue, 2 Sep 2025 15:25:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] accel: Add per-accelerator vCPUs queue
To: qemu-devel@nongnu.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Cameron Esfahani <dirty@apple.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 Alexander Graf <agraf@csgraf.de>, Paul Durrant <paul@xen.org>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 xen-devel@lists.xenproject.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>, Reinoud Zandijk <reinoud@netbsd.org>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-s390x@nongnu.org,
 Riku Voipio <riku.voipio@iki.fi>, Anthony PERARD <anthony@xenproject.org>,
 Alistair Francis <alistair.francis@wdc.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Marcelo Tosatti <mtosatti@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>,
 "Edgar E . Iglesias" <edgar.iglesias@amd.com>, Zhao Liu
 <zhao1.liu@intel.com>, Phil Dennis-Jordan <phil@philjordan.eu>,
 David Woodhouse <dwmw2@infradead.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>,
 Salil Mehta <salil.mehta@huawei.com>
References: <20250106200258.37008-1-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250106200258.37008-1-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Cc'ing Pierrick & Salil.

On 6/1/25 21:02, Philippe Mathieu-Daudé wrote:
> Hi,
> 
> Currently we register all vCPUs to the global 'cpus_queue' queue,
> however we can not discriminate per accelerator or per target
> architecture (which might happen in a soon future).
> 
> This series tries to add an accelerator discriminator, so
> accelerator specific code can iterate on its own vCPUs. This
> is required to run a pair of HW + SW accelerators like the
> (HVF, TCG) or (KVM, TCG) combinations. Otherwise, i.e. the
> HVF core code could iterate on TCG vCPUs...
> To keep it simple and not refactor heavily the code base,
> we introduce the CPU_FOREACH_TCG/HVF/KVM() macros, only
> defined for each accelerator.
> 
> This is just a RFC to get some thoughts whether this is
> heading in the correct direction or not ;)
> 
> Regards,
> 
> Phil.
> 
> Philippe Mathieu-Daudé (7):
>    cpus: Restrict CPU_FOREACH_SAFE() to user emulation
>    cpus: Introduce AccelOpsClass::get_cpus_queue()
>    accel/tcg: Implement tcg_get_cpus_queue()
>    accel/tcg: Use CPU_FOREACH_TCG()
>    accel/hw: Implement hw_accel_get_cpus_queue()
>    accel/hvf: Use CPU_FOREACH_HVF()
>    accel/kvm: Use CPU_FOREACH_KVM()
> 
>   accel/tcg/tcg-accel-ops.h         | 10 ++++++++++
>   include/hw/core/cpu.h             | 11 +++++++++++
>   include/system/accel-ops.h        |  6 ++++++
>   include/system/hvf_int.h          |  4 ++++
>   include/system/hw_accel.h         |  9 +++++++++
>   include/system/kvm_int.h          |  3 +++
>   accel/accel-system.c              |  8 ++++++++
>   accel/hvf/hvf-accel-ops.c         |  9 +++++----
>   accel/kvm/kvm-accel-ops.c         |  1 +
>   accel/kvm/kvm-all.c               | 14 +++++++-------
>   accel/tcg/cputlb.c                |  7 ++++---
>   accel/tcg/monitor.c               |  3 ++-
>   accel/tcg/tb-maint.c              |  7 ++++---
>   accel/tcg/tcg-accel-ops-rr.c      | 10 +++++-----
>   accel/tcg/tcg-accel-ops.c         | 16 ++++++++++++----
>   accel/tcg/user-exec-stub.c        |  5 +++++
>   accel/xen/xen-all.c               |  1 +
>   cpu-common.c                      | 10 ++++++++++
>   hw/i386/kvm/clock.c               |  3 ++-
>   hw/intc/spapr_xive_kvm.c          |  5 +++--
>   hw/intc/xics_kvm.c                |  5 +++--
>   system/cpus.c                     |  5 +++++
>   target/arm/hvf/hvf.c              |  4 ++--
>   target/i386/kvm/kvm.c             |  4 ++--
>   target/i386/kvm/xen-emu.c         |  2 +-
>   target/i386/nvmm/nvmm-accel-ops.c |  1 +
>   target/i386/whpx/whpx-accel-ops.c |  1 +
>   target/s390x/kvm/kvm.c            |  2 +-
>   target/s390x/kvm/stsi-topology.c  |  3 ++-
>   29 files changed, 130 insertions(+), 39 deletions(-)
> 


