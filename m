Return-Path: <kvm+bounces-43332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE07A895AC
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A2A91898832
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 07:52:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5732750E7;
	Tue, 15 Apr 2025 07:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="chhWAAAh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EB427A900
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 07:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744703524; cv=none; b=ikj3+yfdM+0Td7WxGZs5HhCA0+KMFS1kMepDQrvpMJt2sQQbSnJX6g5Y10xn6/g8Kq5tktoHcWTYxMBYronS1HokB3tA6Le69UwfC+IysJpTNyOzuAp/HaiapsHTsqMD+A6J7z6aH4EH+vlYErMtup8WhloSqFuaQplN3FgDnec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744703524; c=relaxed/simple;
	bh=UnAJz3/6d0lLY5ST9isP/hITeEJ1pYFXIfKAFwMdL0U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NZcgR3tdODFhZKFG1L+ID7HkhtQ93FuTP1fLdh8jRBd1KTleDSVkDvXIWzj+hxb3oFK2GPUEyl4wf3EUmkLI4bZM9MpT/4Qol799DC1/7bZbejV7fgw3J4JhWj0JZ+mTBWWUc8NGblP1d3mvyn0i9le6y2sjBbuAhH6u8CjClQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=chhWAAAh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744703521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GL8Jiak0PPzAi305o2OIVAtyLPZMn+xMPHksf916Ng=;
	b=chhWAAAhuUf1jtGbpO24wKdwkLnsGOw23SgiiX7UJgT9cOo8XnLv73m6ql/3E3rw0U9Dqq
	Z3BxWYaoF2tBtoxSxIx8LVq6PsQvPPhSIeQQZcgMfCVu0DAzQIdo+pMBq07FSp1SROCRP9
	Gs0W1cC1VmnwL4YwTvb3nYJb0TcpImE=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-WMYoZXWxNuWUymRQtQtq4A-1; Tue, 15 Apr 2025 03:50:10 -0400
X-MC-Unique: WMYoZXWxNuWUymRQtQtq4A-1
X-Mimecast-MFC-AGG-ID: WMYoZXWxNuWUymRQtQtq4A_1744703409
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-739525d4d7bso3755987b3a.2
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 00:50:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744703408; x=1745308208;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9GL8Jiak0PPzAi305o2OIVAtyLPZMn+xMPHksf916Ng=;
        b=ZzAOQYfXQWqJ/jwWZhXXYr8DzWBJ0th99S/1AWLKfMCPGz0H8bpZdcE732cXmNnXho
         XonxZOznyi7Fcq7LCEs7dURZrXEXFn8s+CjrVWr10iYef+wxufH8YqGgT+WE1g+7IRs0
         umacZswJwBKgGZCmjG+sxQXAJepSa80mriE9ek20DaZ+F/nT4JGfnUlRIT27OaN4dwbX
         L1ps3d4LLCBza4nUUs+yGvKQBi0ADyI7lj9NpxBa5eqn/a87/oU4SvbFZs7nRWKruidz
         oB2YkL3TMC2Wu9z2ZIstyz+v5ky8NoHS3VGKCseciPBxzmJxajJiVx5L779TmX63/WZS
         KMPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMvX11gJnOeBslULJAHgRaZFCFUjRJRe1oK3ato0JKvJfPzc7WZg4vFFgTsEuBlH576II=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG3GIaS2G4/vq3XJkHzHKsJqoH+CkTGjij2dR8p1ecygs77le/
	fjY2wwIxVXRhY9pXpI3L5lFR5n/eQ49k5fQu6PzdELRH5Njv3y+g2KnpMQdzgHHm0naS4aSYxE3
	Q677kliPI9P1I6eBQCEuRSCUz2EBL+fnYf9HnuJPwXRiXDIBudS9FiBH+IQ==
X-Gm-Gg: ASbGncuTu5jYMt2YV+NJCbEBM7zOHg3gHMGhf/P5TJa8cHzxOdRG3YJakvc7kuOTWHr
	VovZDG5XSPxBEh1s3dcuDnbixx2LzVpFT5uwOQTL1NP8res3bXRUOQ1kaZguuvews6CQuJZW3ie
	ayfDagsaKIvKYjDUIRaaHNf/NyIOCw7eEuJstyiF8xzhQNeSsGSP/aImawowG7p4z70YZjnt+vK
	0iW5421GbFxnhn+jXAph45tERqToq3tRaqPKjkCArneRzyxyZ5yi0Yo3EgV1jjSssblkYpt2PUO
	OE5tuvqQVQfPONij
X-Received: by 2002:a05:6a21:32a3:b0:1f5:9208:3ac7 with SMTP id adf61e73a8af0-20179995dcbmr27309135637.41.1744703408501;
        Tue, 15 Apr 2025 00:50:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGu9EMf6d9BVqtrpts6HlArjZAaV7yFs26wRb9URmr1lUu62FiTMck++WIHCgXLXvf0aHaKtA==
X-Received: by 2002:a05:6a21:32a3:b0:1f5:9208:3ac7 with SMTP id adf61e73a8af0-20179995dcbmr27309086637.41.1744703407997;
        Tue, 15 Apr 2025 00:50:07 -0700 (PDT)
Received: from [10.72.116.169] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73bd1fe6b4esm7881572b3a.0.2025.04.15.00.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 00:50:07 -0700 (PDT)
Message-ID: <21f3fedd-274e-4e81-87f8-369deefa8c1a@redhat.com>
Date: Tue, 15 Apr 2025 15:49:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] accel/kvm: Support KVM PMU filter
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
References: <20250409082649.14733-1-zhao1.liu@intel.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250409082649.14733-1-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zhao,

I've added some code and test it on ARM64, it works very well.

And after reviewing the code, it looks good to me.

Reviewed-by: Shaoqin Huang <shahuang@redhat.com>

On 4/9/25 4:26 PM, Zhao Liu wrote:
> Hi all,
> 
> Now I've converted the previous RFC (v2) to PATCH.
> 
> Compared with RFC v2 [1], this version mianly have the following
> changes:
>   * Make PMU related QAPIs accept decimal value instead of string.
>   * Introduce a three-level QAPI section to organize KVM PMU stuff.
>   * Fix QAPI related style issues.
>   * Rename "x86-default" format to "x86-select-umask".
> 
> Current pmu-filter QOM design could meet the requirements of both x86
> and ARM sides.
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
> -object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":196}]}'
> 
> For x86, this object is inserted into kvm accelerator and is extended
> to support fixed-counter and more formats ("x86-default" and
> "x86-masked-entry"):
> 
> -accel kvm,pmu-filter=f0 \
> -object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","x86-fixed-counter":0,"events":[{"format":"x86-masked-entry","select":196,"mask":255,"match":0,"exclude":true},{"format":"x86-masked-entry","select":197,"mask":255,"match":0,"exclude":true}]}'
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
> * x86-select-umask format (i386 specific)
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
> [1]: https://lore.kernel.org/qemu-devel/20250122090517.294083-1-zhao1.liu@intel.com/
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
>   MAINTAINERS              |   2 +
>   accel/kvm/kvm-pmu.c      | 177 +++++++++++++++++++++++++++++++++++++++
>   accel/kvm/meson.build    |   1 +
>   include/system/kvm-pmu.h |  51 +++++++++++
>   include/system/kvm_int.h |   2 +
>   qapi/accelerator.json    |  14 ++++
>   qapi/kvm.json            | 130 ++++++++++++++++++++++++++++
>   qapi/meson.build         |   1 +
>   qapi/qapi-schema.json    |   1 +
>   qapi/qom.json            |   3 +
>   qemu-options.hx          |  67 ++++++++++++++-
>   target/i386/kvm/kvm.c    | 176 ++++++++++++++++++++++++++++++++++++++
>   12 files changed, 624 insertions(+), 1 deletion(-)
>   create mode 100644 accel/kvm/kvm-pmu.c
>   create mode 100644 include/system/kvm-pmu.h
>   create mode 100644 qapi/accelerator.json
>   create mode 100644 qapi/kvm.json
> 

-- 
Shaoqin


