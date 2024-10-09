Return-Path: <kvm+bounces-28170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D98996015
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 08:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0955286B22
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 06:48:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D35B173326;
	Wed,  9 Oct 2024 06:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HNk70dvF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C15154C05
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 06:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728456515; cv=none; b=Yj3T+yFOrjS/gWby83TMB6uwMVpFkVg8Cg7OYl8PDuicAXBD/+dfzy8sMDbxS5Ulq50dviFGGXCi00OaQ6GwOoXQgCMv1QBWzOdcIsbcqzc3ZMhqUYcNmyRd6Huhc+xwQIN1jfaUp7EQIm7r4QGA4zblRb0FAv8qdqoGNxpjj2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728456515; c=relaxed/simple;
	bh=5Zpkqj1YYQWDi/YDZE65uSYTNtgPePZdHnri8jNGY30=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=pzWQIonyDMZ1e8D5bIVx/Dc47k5mFLaM4o8b2KTdgU+2nDrx8ULZLVI+mlf3MfUhg0DmISHpOJKCjRne/d852hbYJ4AJMvzTuLErOBWtLnJpX9YEps+EKiRKHjsFPcMYqt9K1+ywNjrquzPm+J9YsAehZueJchK6GU7e4052eu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HNk70dvF; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-710f0415ac8so2963002a34.1
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2024 23:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728456513; x=1729061313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wZhJciWAlAtmNslUY0hPiALf9HSRzOVanFBIYjkUrgQ=;
        b=HNk70dvF8rZ9Ndz06eXGCOJbUPataWkPrAIINl/RVat1PE49mZHowR1lfDBBTESLI4
         G6jv8EsL+mQrHCvCBhHN+B2uggm3LpRYXLyPJMmXEltipr5H9xirlJcH2tXxjhuVYwVW
         iyf2m/kFWoQtOcJxr98osMzs2Lh5ejkxkVdtZggzZwB+5dPIUlkQIopkMEz5NOlyljpd
         whStUZP1YJtgj5gI9MPl6dCwJc2uLPrYEeJXHRwRDZ8/RmdK50mgj+303fKoJbIZyY+L
         Xb8o7oG7yQegCrDgeXNT6+RqUBPIa4B1eOnJQj2MsjVqb7srQuwqID56wV3mIjsVhPUY
         /MmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728456513; x=1729061313;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZhJciWAlAtmNslUY0hPiALf9HSRzOVanFBIYjkUrgQ=;
        b=lCeULWqEpybllUXckShSur7x9+symyul30b1f1FgNVn5gox4eC760I9iv0MZSQayja
         SQL9QZbb/BHmYvWC2Jin7lJrZcWI3TGubAfRR6OS+RueVEriebX1yZ4M9ALXlXGHB4vA
         aeHTqmRdlP76lH35ypFLHZNeO7SXu/m7ABtDAk4JDrUJUEfDgcAK12lLZE0qB631h+Vf
         twmPIMWywtQgVRi62/x918sEcX6UAbdo8JPFRbIUYLcjHSvSZKPt6mSn3F63oIU1dJEQ
         ZYoku0xfRoTEav3R5E7N5P+IrQkUozNinQpbi3wnAvTaGyWAFrgISqEUXr/16L8FErkd
         fJYQ==
X-Gm-Message-State: AOJu0Yy1+HzxIrKUigYhKppnWONmSZ2TdZ5f5XOgUgM6oCj/15LYfzbd
	o0z2WdSNm6GCHHjK0k2tJ9lvpNZlCpja3Ighl9WpOqwogd76G9kCi1h8fyvxIoo=
X-Google-Smtp-Source: AGHT+IEtzcR1Q9ZQub2qrYyCFsk1Kku6ypavzUWmtpra7Wp8XdfHSh3ri8QCd4JQZqlCjHd7zL/89Q==
X-Received: by 2002:a05:6830:8009:b0:716:a571:dff0 with SMTP id 46e09a7af769-716a571e012mr645460a34.13.1728456512934;
        Tue, 08 Oct 2024 23:48:32 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d47858sm7152746b3a.107.2024.10.08.23.48.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:48:32 -0700 (PDT)
Message-ID: <7fe8970c-ecb7-4e46-be76-488d7697d8db@gmail.com>
Date: Wed, 9 Oct 2024 14:48:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 0/5] nVMX: Simple posted interrupts test
To: kvm@vger.kernel.org
References: <20231211185552.3856862-1-jmattson@google.com>
Content-Language: en-US
Cc: Jim Mattson <jmattson@google.com>, seanjc@google.com, pbonzini@redhat.com
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20231211185552.3856862-1-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/23 2:55 AM, Jim Mattson wrote:
> I reported recently that commit 26844fee6ade ("KVM: x86: never write to
> memory from kvm_vcpu_check_block()") broke delivery of a virtualized posted
> interrupt from an L1 vCPU to a halted L2 vCPU (see
> https://lore.kernel.org/all/20231207010302.2240506-1-jmattson@google.com/).
> The test that exposed the regression is the final patch of this series. The
> others are prerequisites.
> 
> It would make sense to add "vmx_posted_interrupts_test" to the set of tests
> to be run under the unit test name, "vmx_apicv_test," but that is
> non-trivial. The vmx_posted_interrupts_test requires "smp = 2," but I find
> that adding that to the vmx_apicv_tests causes virt_x2apic_mode_test to
> fail with:
> 
> FAIL: x2apic - reading 0x310: x86/vmx_tests.c:2151: Assertion failed: (expected) == (actual)
> 	LHS: 0x0000000000000012 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'0010 - 18
> 	RHS: 0x0000000000000001 - 0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001 - 1
> Expected VMX_VMCALL, got VMX_EXTINT.
> 	STACK: 406ef8 40725a 41299f 402036 403f59 4001bd
> 
> I haven't investigated.

This vmx_apicv_test test still fails when 'ept=N' (SPR + v6.12-rc2):

--- Virtualize APIC accesses + Use TPR shadow test ---
FAIL: xapic - reading 0x080: read 0x0, expected 0x70.
FAIL: xapic - writing 0x12345678 to 0x080: exitless write; val is 0x0, 
want 0x70

--- APIC-register virtualization test ---
FAIL: xapic - reading 0x020: read 0x0, expected 0x12345678.
FAIL: xapic - writing 0x12345678 to 0x020: x86/vmx_tests.c:2164: 
Assertion failed: (expected) == (actual)
	LHS: 0x0000000000000038 - 
0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0011'1000 
- 56
	RHS: 0x0000000000000012 - 
0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0000'0001'0010 
- 18
Expected VMX_APIC_WRITE, got VMX_VMCALL.
	STACK: 406f7f 40d178 40202f 403f54 4001bd

> 
> 
> Jim Mattson (1):
>    nVMX: Enable x2APIC mode for virtual-interrupt delivery tests
> 
> Marc Orr (Google) (3):
>    nVMX: test nested "virtual-interrupt delivery"
>    nVMX: test nested EOI virtualization
>    nVMX: add self-IPI tests to vmx_basic_vid_test
> 
> Oliver Upton (1):
>    nVMX: add test for posted interrupts
> 
>   lib/x86/apic.h       |   5 +
>   lib/x86/asm/bitops.h |   8 +
>   x86/unittests.cfg    |  10 +-
>   x86/vmx_tests.c      | 423 +++++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 445 insertions(+), 1 deletion(-)
> 

