Return-Path: <kvm+bounces-7585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 005A0843EF0
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 12:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 762D41F2E2B8
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FC678689;
	Wed, 31 Jan 2024 11:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RHOFVXOz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56997690E
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 11:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706702300; cv=none; b=gbRNo5xZIBCTKv79urj3wwx/F5fki8SgYqyyZbsCacNu9pOKR22i2UnCpUlvPQ2nWcq2MzcwLmIyLHz9FR3bjqghkAiG3aQEZ9WnhyTuo0gw0m8m4jqwgyg4invvE/sGcgSlFiwpwLVLh3XJKJGNxK/xdgzeBi811fkcrqg3mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706702300; c=relaxed/simple;
	bh=hI6pIxWYZn6JeCEExsEXYy9voSGnFqpL/k6e0jjFvJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E/FywBjhL26yPrM7Igdv2znnnsFyNhFosavPkoPIeKbwg1FaIyepsAMwF0oXnhn92H50syBJci4vFHnnU6y10L5EPOwvoAtWBsLAisYaAbGDmQCgcxgtKtHdOrX6xEpaoq6BYThsFu8F4zDlQzQ19AoM7QSZTVMYczIv2omemV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RHOFVXOz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706702297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Um39ebN5ZMur/OwoYxUGFeLAS+a+2jb5T67VWPDiRzw=;
	b=RHOFVXOzCT5/Zk9M2Uektkko+jUDBoLnz9tUSe81LhO2riiVuzyKxgCXrbmU2zC0xUMmOm
	1uFiCoT262iXokHuf0WbQydviyE1sjECfYFOo0/D1G32V41pU2ruqIdiCF7QzwyzfI3Ohd
	GcVualvompvAvbIFRC9l3N34LcJWJWw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-XIYp0df2MR6hkgyqKpyRMw-1; Wed, 31 Jan 2024 06:58:16 -0500
X-MC-Unique: XIYp0df2MR6hkgyqKpyRMw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-40ef75adf5fso17247335e9.0
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 03:58:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706702294; x=1707307094;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Um39ebN5ZMur/OwoYxUGFeLAS+a+2jb5T67VWPDiRzw=;
        b=DHpu1ufDQy1blMlf6J6HmBjOa9rsHykVjzB62V5s/PbyDZxH7/435bYChqQH5a4rof
         FzjmjvPi0U8ubsa91XVzFpkGKO1d/GK2/Qt4PyDNIbhyJGe1KjCINdwcSarWia/7U/8J
         SGEm7C9CPTMGFejAssHni67v141I70rHHp+KDI8UDfROU0X85rjTWQirSnvMmz1OUEls
         UsAtNxeP6KK0pDxokfapHS77E1tWlI2FUUMXfJur/5w6s/djCw4zmUoIV20d/TEN36ha
         9d5T6osaDs01Y5U6xhfmOj4rLwTKU8/DumfhH72mJHKhkOQTtG95bUcCj/wQvuMWY8B3
         LC0g==
X-Gm-Message-State: AOJu0YyuccDBoI6QoTPPGT3Brvgw9Hx7PTH1m1AOccXI4ZgEkz2mj/cP
	247ZeUB5xRWV1nJgPG4ElPamcEEc19VVVXFOoodB5PaR2YE/Hlxs/e62lQBetTz0J6Pj/D54sey
	YYVfy8s1+DLHHoYOzq05BSmQdEmwKoYAJFl0Ct/CHKdtAhJhLGOoHPODhCw==
X-Received: by 2002:a05:600c:4e14:b0:40e:d3db:ff71 with SMTP id b20-20020a05600c4e1400b0040ed3dbff71mr1080251wmq.2.1706702293915;
        Wed, 31 Jan 2024 03:58:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFzOsNQ060KjCmFNJyVcxAX4cTTtvYMAQ7U1f5me3Rqe8XCqs5OGgYqtttJEGFB8uE1qXD1UA==
X-Received: by 2002:a05:600c:4e14:b0:40e:d3db:ff71 with SMTP id b20-20020a05600c4e1400b0040ed3dbff71mr1080232wmq.2.1706702293586;
        Wed, 31 Jan 2024 03:58:13 -0800 (PST)
Received: from [10.254.108.137] ([151.14.9.35])
        by smtp.googlemail.com with ESMTPSA id c20-20020a7bc014000000b0040e813f1f31sm1379119wmb.25.2024.01.31.03.58.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 03:58:13 -0800 (PST)
Message-ID: <96dd3b45-90c1-4454-abe3-61987defd03b@redhat.com>
Date: Wed, 31 Jan 2024 12:58:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpu/intel: Detect TME keyid bits before setting MTRR
 mask registers
Content-Language: en-US
To: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Zixi Chen <zixchen@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Kai Huang <kai.huang@linux.intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
 x86@kernel.org, stable@vger.kernel.org
References: <20240130180400.1698136-1-pbonzini@redhat.com>
 <bf3ptwhblztmal3c5b7jhjpohizw7q64th76pzit6rpgnewmo5@atq3oy6sp5vn>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <bf3ptwhblztmal3c5b7jhjpohizw7q64th76pzit6rpgnewmo5@atq3oy6sp5vn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/31/24 09:39, Kirill A . Shutemov wrote:
> On Tue, Jan 30, 2024 at 07:04:00PM +0100, Paolo Bonzini wrote:
>> MKTME repurposes the high bit of physical address to key id for encryption
>> key and, even though MAXPHYADDR in CPUID[0x80000008] remains the same,
>> the valid bits in the MTRR mask register are based on the reduced number
>> of physical address bits.
>>
>> detect_tme() in arch/x86/kernel/cpu/intel.c detects TME and subtracts
>> it from the total usable physical bits, but it is called too late.
>> Move the call to early_init_intel() so that it is called in setup_arch(),
>> before MTRRs are setup.
>>
>> This fixes boot on some TDX-enabled systems which until now only worked
>> with "disable_mtrr_cleanup".  Without the patch, the values written to
>> the MTRRs mask registers were 52-bit wide (e.g. 0x000fffff_80000800)
>> and the writes failed; with the patch, the values are 46-bit wide,
>> which matches the reduced MAXPHYADDR that is shown in /proc/cpuinfo.
>>
>> Fixes: cb06d8e3d020 ("x86/tme: Detect if TME and MKTME is activated by BIOS", 2018-03-12)
>> Reported-by: Zixi Chen <zixchen@redhat.com>
>> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
>> Cc: Kai Huang <kai.huang@linux.intel.com>
>> Cc: Dave Hansen <dave.hansen@linux.intel.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: x86@kernel.org
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> I've seen the patch before, although by different author and with
> different commit message, not sure what is going on.
> 
> I had concern about that patch and I don't think it was addressed.

Wow, slightly crazy that two people came up with exactly the same patch,
including adding the comment before the moved call.  And yes, this patch
only works until 6.6. :/

The commit that moved get_cpu_address_size(), which has sha id
fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value
straight away, instead of a two-phase approach"), was buggy for AMD
processors; and it was noticed in the thread you linked, but never
addressed.  It works more or less by chance because early_init_amd()
calls init_amd(), but the x86_phys_bits value remains wrong for most of
the boot process.  The MTRRs are also initialized wrongly, but that at
least doesn't cause a #GP on AMD SME.

I think the correct fix is something like

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0b97bcde70c6..fbc4e60d027c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1589,6 +1589,7 @@ static void __init early_identify_cpu(
  		get_cpu_vendor(c);
  		get_cpu_cap(c);
  		setup_force_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
  		cpu_parse_early_param();
  
  		if (this_cpu->c_early_init)
@@ -1601,10 +1602,9 @@ static void __init early_identify_cpu(
  			this_cpu->c_bsp_init(c);
  	} else {
  		setup_clear_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
  	}
  
-	get_cpu_address_sizes(c);
-
  	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
  
  	cpu_set_bug_bits(c);

on top of which my (or Jeremy's) patch can be applied.  I'll test it and
send a v2 of this patch.

Paolo

> See the thread:
> 
> https://lore.kernel.org/all/20231002224752.33qa2lq7q2w4nqws@box
> 


