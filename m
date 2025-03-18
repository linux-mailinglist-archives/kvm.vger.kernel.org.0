Return-Path: <kvm+bounces-41373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99730A66BF3
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 08:38:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 528FB3BBEDD
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861FF1F8726;
	Tue, 18 Mar 2025 07:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9EQUDDJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12C91DE3A5
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 07:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742283338; cv=none; b=phXxJ7wpIYubWZral8OpGKWN6PZ/WnNxVS5R40AC3oKuMoXIS1ju+pANqdHijO4gJAz8/YzT1Xoj9v5kKXzLnUeFSrCgktDnffMUgK/pXhrsgj+WjIi3SKjvMocwigKEcjN+E4RkyPSCGpxSML/oNvHdp0pOhl/kbn+KqPSLyC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742283338; c=relaxed/simple;
	bh=0qhGQ+HQ7zNnhH9ynNxTdqGRv2YLBNszkQmYn8f0aXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KwD+vswTlkYOUknZv6JM/uTPAqzQ+p+pnKY77z35qeu9HNJXj9rLJFdze6KM/d0OSpytlq5ivhI2eKOHy6N+2NPZf1fM5o3jJjvevF5HmpzOX5o0mGZ0BCxSc3rOMve7FobJo3OA9b3YXQ3qoDHG+YMyThdX/6KBy7xVafDLFmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O9EQUDDJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742283335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0i8L8ErIHIcKjhHNLC1JQVz75Bq37QLmHg8dkfMBKIw=;
	b=O9EQUDDJnloLxARvYmo6vQwkca4P8MoJHVvZpWE/Gaqq4Zsu3VomicKuhBKAq1C6/r00WH
	lYvqrzN9oSvn3cMm+bWCAg151cL6JXMjbYLbOGzZMNmuJs1UJOVvM5EfJ0QK93PQGNUEHY
	eOkKYlQTxG87TuUlJdkg6K2AQykn6jI=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-ctBV5eW6OUuvwHk3eoEnQQ-1; Tue, 18 Mar 2025 03:35:34 -0400
X-MC-Unique: ctBV5eW6OUuvwHk3eoEnQQ-1
X-Mimecast-MFC-AGG-ID: ctBV5eW6OUuvwHk3eoEnQQ_1742283333
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2242ca2a4a5so72842655ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 00:35:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742283333; x=1742888133;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0i8L8ErIHIcKjhHNLC1JQVz75Bq37QLmHg8dkfMBKIw=;
        b=QWYmaIdjLd8HVAa4e9esSIA9Pa0HMXfCnb8ADYW2kpcfHEuBch9BR3dDpJ439NgVJE
         D8SzSXGYuHBdIgJ/KjBlZ9K7u+7FvNi/VYCJzp8tkq0g5fHOCVEaoJcS1I+w1cbQclsd
         KjXZR5ZaY+6lH9I45GJHCcV2QnjjE8zIMm2x1TJ4ECdUvNNaPzLN41mPtEs1+WBiGFcH
         qgszbrM+kVaE+8NMmYQ/P4CtcFXKC0pBvHM91IMOW/bNAoIBZlBdq+KT/vlszwv8dhvD
         LMdZyXRIcrCG3nSNM89g1fuLTfvmuzBAt7TkwDqTlBSetg2S2gSBwy87FJSi2Zwxx2BO
         AU6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNxqVB8F8TZGbOtU0mJgK0vrhhKlnu59XwRl+zWhisfW0/668cTLFO5pvI6qTPNO6sHG8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJx4FbJ0Qf3E7eAEm9ydaRi6hrPN45kXlMTPbiaUACLqRRio+e
	PNRBSsBR0OCitisWFgbKJcT1DYQ1jL1Q4Fbe+HmVe3dt33VJ0F+tySJ53CcyoFy0o7xu74Oqjsm
	V9kzksXqaQMOd503E19mXtNt89kQhOEDbLOmSN4ECCOhmfgQNCQ==
X-Gm-Gg: ASbGncufQwiYWzIIHIrP7aUDo8LqVw3+fFK0EfZI7sdXfZhYMFEryDjcKJumENS2vt9
	XKyFKmDO+RQZ3QG+9Pc2Iy+HqR5QHH0FBz49apkHykgQJu1MIDQ1+jbndLKi1Xa/elNxQgqhwNE
	Df0K+gO2yKubAU6ttHoRh9JvbuEEtgoDEXv40ax3jGM36SQZTUGbgA0LQnmlVSP2nOZtVEMPuel
	o9JlBbtbap6G+NAuvOsqMUJUA5p0SFiGSTo6et7KoUz7QREkLjtwEtsnBapZXsn9E3fxFkCyKkP
	3eEgh6q8msnPlMABRbwT
X-Received: by 2002:a05:6a00:b95:b0:736:3d7c:2368 with SMTP id d2e1a72fcca58-73722353269mr18334327b3a.7.1742283332989;
        Tue, 18 Mar 2025 00:35:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMBK6qKus8FijqhGiMuo2MbhTRc59Wm2bEqfErgelC1XdI0dRfHYg9Umo5MnegCAbEJXhSgg==
X-Received: by 2002:a05:6a00:b95:b0:736:3d7c:2368 with SMTP id d2e1a72fcca58-73722353269mr18334273b3a.7.1742283332537;
        Tue, 18 Mar 2025 00:35:32 -0700 (PDT)
Received: from [10.72.116.163] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371152958csm8856772b3a.26.2025.03.18.00.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 00:35:31 -0700 (PDT)
Message-ID: <2fe2a98d-f70f-4996-b04e-d81f66d5863f@redhat.com>
Date: Tue, 18 Mar 2025 15:35:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 0/5] accel/kvm: Support KVM PMU filter
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Marcelo Tosatti
 <mtosatti@redhat.com>, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Laurent Vivier
 <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250122090517.294083-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

Thanks for your effort to respin the PMU Filter series.

I tried your series on ARM64, but it reports error at compile time, here 
is the error output:

qapi/kvm.json:59:Unexpected indentation.

While I compiled it on x86, everything is ok. Could you please check why 
it failed on ARM64?

By the mean time, I will review and test this series.

Thanks,
Shaoqin

On 1/22/25 5:05 PM, Zhao Liu wrote:
> Hi folks,
> 
> Sorry for the long wait, but RFC v2 is here at last.
> 
> Compared with v1 [1], v2 mianly makes `action` as a global parameter,
> and all events (and fixed counters) are based on a unified action.
> 
> Learned from the discussion with Shaoqin in v1, current pmu-filter QOM
> design could meet the requirements from the ARM KVM side.
> 
> 
> Background
> ==========
> 
> I picked up Shaoqing's previous work [2] on the KVM PMU filter for arm,
> and now is trying to support this feature for x86 with a JSON-compatible
> API.
> 
> While arm and x86 use different KVM ioctls to configure the PMU filter,
> considering they all have similar inputs (PMU event + action), it is
> still possible to abstract a generic, cross-architecture kvm-pmu-filter
> object and provide users with a sufficiently generic or near-consistent
> QAPI interface.
> 
> That's what I did in this series, a new kvm-pmu-filter object, with the
> API like:
> 
> -object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0xc4"}]}'
> 
> For i386, this object is inserted into kvm accelerator and is extended
> to support fixed-counter and more formats ("x86-default" and
> "x86-masked-entry"):
> 
> -accel kvm,pmu-filter=f0 \
> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","x86-fixed-counter":{"bitmap":"0x0"},"events":[{"format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
> 
> This object can still be added as the property to the arch CPU if it is
> desired as a per CPU feature (as Shaoqin did for arm before).
> 
> 
> Introduction
> ============
> 
> 
> Formats supported in kvm-pmu-filter
> -----------------------------------
> 
> This series supports 3 formats:
> 
> * raw format (general format).
> 
>    This format indicates the code that has been encoded to be able to
>    index the PMU events, and which can be delivered directly to the KVM
>    ioctl. For arm, this means the event code, and for i386, this means
>    the raw event with the layout like:
> 
>        select high bit | umask | select low bits
> 
> * x86-default format (i386 specific)
> 
>    x86 commonly uses select&umask to identify PMU events, and this format
>    is used to support the select&umask. Then QEMU will encode select and
>    umask into a raw format code.
> 
> * x86-masked-entry (i386 specific)
> 
>    This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.
> 
> 
> Hexadecimal value string
> ------------------------
> 
> In practice, the values associated with PMU events (code for arm, select&
> umask for x86) are often expressed in hexadecimal. Further, from linux
> perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
> arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
> s390 uses decimal value.
> 
> Therefore, it is necessary to support hexadecimal in order to honor PMU
> conventions.
> 
> However, unfortunately, standard JSON (RFC 8259) does not support
> hexadecimal numbers. So I can only consider using the numeric string in
> the QAPI and then parsing it to a number.
> 
> To achieve this, I defined two versions of PMU-related structures in
> kvm.json:
>   * a native version that accepts numeric values, which is used for
>     QEMU's internal code processing,
> 
>   * and a variant version that accepts numeric string, which is used to
>     receive user input.
> 
> kvm-pmu-filter object will take care of converting the string version
> of the event/counter information into the numeric version.
> 
> The related implementation can be found in patch 1.
> 
> 
> CPU property v.s. KVM property
> ------------------------------
> 
> In Shaoqin's previous implementation [2], KVM PMU filter is made as a
> arm CPU property. This is because arm uses a per CPU ioctl
> (KVM_SET_DEVICE_ATTR) to configure KVM PMU filter.
> 
> However, for x86, the dependent ioctl (KVM_SET_PMU_EVENT_FILTER) is per
> VM. In the meantime, considering that for hybrid architecture, maybe in
> the future there will be a new per vCPU ioctl, or there will be
> practices to support filter fixed counter by configuring CPUIDs.
> 
> Based on the above thoughts, for x86, it is not appropriate to make the
> current per-VM ioctl-based PMU filter a CPU property. Instead, I make it
> a kvm property and configure it via "-accel kvm,pmu-filter=obj_id".
> 
> So in summary, it is feasible to use the KVM PMU filter as either a CPU
> or a KVM property, depending on whether it is used as a CPU feature or a
> VM feature.
> 
> The kvm-pmu-filter object, as an abstraction, is general enough to
> support filter configurations for different scopes (per-CPU or per-VM).
> 
> [1]: https://lore.kernel.org/qemu-devel/20240710045117.3164577-1-zhao1.liu@intel.com/
> [2]: https://lore.kernel.org/qemu-devel/20240409024940.180107-1-shahuang@redhat.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (5):
>    qapi/qom: Introduce kvm-pmu-filter object
>    i386/kvm: Support basic KVM PMU filter
>    i386/kvm: Support event with select & umask format in KVM PMU filter
>    i386/kvm: Support event with masked entry format in KVM PMU filter
>    i386/kvm: Support fixed counter in KVM PMU filter
> 
>   MAINTAINERS              |   1 +
>   accel/kvm/kvm-pmu.c      | 386 +++++++++++++++++++++++++++++++++++++++
>   accel/kvm/meson.build    |   1 +
>   include/system/kvm-pmu.h |  44 +++++
>   include/system/kvm_int.h |   2 +
>   qapi/kvm.json            | 246 +++++++++++++++++++++++++
>   qapi/meson.build         |   1 +
>   qapi/qapi-schema.json    |   1 +
>   qapi/qom.json            |   3 +
>   target/i386/kvm/kvm.c    | 176 ++++++++++++++++++
>   10 files changed, 861 insertions(+)
>   create mode 100644 accel/kvm/kvm-pmu.c
>   create mode 100644 include/system/kvm-pmu.h
>   create mode 100644 qapi/kvm.json
> 

-- 
Shaoqin


