Return-Path: <kvm+bounces-40752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6568BA5BB37
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 09:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A79E3A9E65
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 08:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03A022839A;
	Tue, 11 Mar 2025 08:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NiO14CtH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0F1DED63
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741683291; cv=none; b=SKx3jBI6XUu7aIoAwhzYqxkh6w9cfByd2krTXc7JwmKJ71AOpEMQPd36+NXGt7oJDkoSyZO1cilNqMz7Zz/vYf8v9mwRFOtv4CGbjzNKVq2Oocqy+EK4DVStfTNVi7vAhVNrzVPVqO84wbF4YHjso/Wg03A4sBENv5iWBZShv2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741683291; c=relaxed/simple;
	bh=BusmRBHFPp1Z2gslwi237WLZz+j2bUmB2IS8UYAJF9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krbraQd0QGWrW/ZSig/lrDJOE9Kfv1g9OaPE2uFLSARiJE/13Ikf0MwCrP8TNUkYUgHTdMzH3ikXtb1im0YxTnp+A9VGEbc2cRpo6eW7DUM04J3mds5JI0/nFId6yZKI98md6q3PTwlOl7/7tMsGuJmB0nFssIlUCXoLWQXrjuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NiO14CtH; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfe574976so9048095e9.1
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 01:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741683288; x=1742288088; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+NbdoBDIcR1jHweEXbc4Ma4qdVpd3aU6BwDB7n+N8OM=;
        b=NiO14CtH0Cxey+pk0tdCtO5IxpUpjD9Hw4PlIgdhsAkoWqnZukQ151sjTtsg/je8eS
         eErzdsXqEffsT1rwYBs+mKLjcSykzrfvgOAGhyQpQarKaOK39NgunGaRp238anSszTR9
         H+tHthhmDLLAKsqWjZNx37yxTemjhmXzTdblPN01f+2pxznVP0HOemhCjrAkDOEQbiYo
         rekt8xwP/yS1POxbf+LEj48LhY02XNgUzMlpkpI5RtMt4/1fHiDw9HH04nbIpkixqk+i
         QcpIBHFzMY6Twa9Y5cGTZK5hH3zj6t7NkDiPEcN2I+hHlAnmfeZ8+xQQzcCYudOf5387
         KhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741683288; x=1742288088;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+NbdoBDIcR1jHweEXbc4Ma4qdVpd3aU6BwDB7n+N8OM=;
        b=s0IJ5IdDm/HcRpzWrLu+QVT87M0/80DQIKZsyFEWwG6N87q/RMQwHPx4TDLZoi9W7Q
         d99FmFSw/wtnQgUOd9Uf5V6wUe8Iojcvmf+v36defh0KU0Z27ewCSlqdaQpnVDpI500r
         BFUhEl/zuF9b+FpqosvOYDiaEjMlR9vUa0MUYlZKCmH7D3JZz3eOLIg8OMavok+i8nNo
         lTJPSKFNkitxN3kiDKsihTmJRLGzcR+VLt4AnAlN86XP5lS2yZoBZPjFhWkSBPNLnJZd
         tTIpXOklbSa6+TgTAxTkzZb/wx6pnS6oeyTEAps0DZm0aOcPVI60SmJ4+x1EDGZFseDp
         sPUg==
X-Forwarded-Encrypted: i=1; AJvYcCVqehBu9DsxL3GeFltgaBWR/v31KERv2XC+i/4O2ZVpoos6iAJIE9WrRpQRC1GDH7Z4/nQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbawHI494iIn/ZWWU7BpJD890MYy7jIReZG1HYZ3Lta+oRoo/j
	vWyGXgjOCl3izwpyzSf5nc6yDdiPHVMy34VGLvWKWJLL0SL6vlETw01Lmm7lqlM=
X-Gm-Gg: ASbGncubSYY2/TJXJ6JNB2R3Ym3dHjC8DxqFvCAsbpkWmpa9QfT1QgEiXxBPGCT6+Ut
	CqMZBTXETIbE+W3hyFtjl9ZueZq2bdlzyYjkHHNyIMuVog7FSbTO45h+IUnQsiKAzb0BGfQ/4Xd
	i4xXPV3nkDP6smEDCzXfneQvP35PuAAxMmwU2aOQjEUUDvl3VNSKKjFHYSEoBjcpkh21ZjjTnPp
	xUlXgFe1oIR9C4xOVK2cHf2WlqHcJdZbCbpNzd0GjBJ2NmaDcBl7SXvvaautEBvpPb5tcOiMUl7
	AZXZE2ZjTKrQ5GVSpiyXDfHFQY5obyTjha0lvb8igHoOZ4N67a9CI0lg2uJP6tUlmzGHE6VP+6B
	x68V76EaTTN9H
X-Google-Smtp-Source: AGHT+IGkHbj2ZNr/Mfwfq8mUReR/77d7syd2mBxKtkFlkIbijAo/Dl9pEGPS+M5qN+oRcpz9vIFPoQ==
X-Received: by 2002:a05:600c:1c05:b0:43b:b756:f0a9 with SMTP id 5b1f17b1804b1-43d01bdbea9mr42698915e9.11.1741683286740;
        Tue, 11 Mar 2025 01:54:46 -0700 (PDT)
Received: from [192.168.69.199] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfe61sm17731252f8f.38.2025.03.11.01.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 01:54:46 -0700 (PDT)
Message-ID: <37026d8c-e892-47cc-b2b1-21d36fe856c2@linaro.org>
Date: Tue, 11 Mar 2025 09:54:44 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/21] hw/vfio/pci: Convert CONFIG_KVM check to runtime
 one
To: BALATON Zoltan <balaton@eik.bme.hu>, Eric Auger <eric.auger@redhat.com>
Cc: qemu-devel@nongnu.org, Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-10-philmd@linaro.org>
 <28c102c1-d157-4d22-a351-9fcc8f4260fd@redhat.com>
 <2d44848e-01c1-25c5-dfcb-99f5112fcbd7@eik.bme.hu>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <2d44848e-01c1-25c5-dfcb-99f5112fcbd7@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/3/25 13:54, BALATON Zoltan wrote:
> On Mon, 10 Mar 2025, Eric Auger wrote:
>> Hi Philippe,
>>
>> On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
>>> Use the runtime kvm_enabled() helper to check whether
>>> KVM is available or not.
>>
>> Miss the "why" of this patch.
>>
>> By the way I fail to remember/see where kvm_allowed is set.

In accel/accel-system.c:

     int accel_init_machine(AccelState *accel, MachineState *ms)
     {
         AccelClass *acc = ACCEL_GET_CLASS(accel);
         int ret;
         ms->accelerator = accel;
         *(acc->allowed) = true;
         ret = acc->init_machine(ms);
         if (ret < 0) {
             ms->accelerator = NULL;
             *(acc->allowed) = false;
             object_unref(OBJECT(accel));
         } else {
             object_set_accelerator_compat_props(acc->compat_props);
         }
         return ret;
     }

> 
> It's in include/system/kvm.h
> 
>> I am also confused because we still have some code, like in
>> vfio/common.c which does both checks:
>> #ifdef CONFIG_KVM
>>         if (kvm_enabled()) {
>>             max_memslots = kvm_get_max_memslots();
>>         }
>> #endif

We should prefer kvm_enabled() over CONFIG_KVM, but for kvm_enabled()
we need the prototypes declared, which sometimes aren't.

