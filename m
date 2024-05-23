Return-Path: <kvm+bounces-18072-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F48F8CD983
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C6AB8B21E24
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 17:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 395708003F;
	Thu, 23 May 2024 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="GFokNs26"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31287D086
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716486821; cv=none; b=idlKA2C5xib4HZRhbUhpMhxVg0xQ3kmNizYgtybrgrixIn9Xy/YV0BDqBKSdmdGGKKl9loXX6eC8Y5TNHDqZi8wc4Z71ImvTc1gZB5cW4w44hELnzSeWVt1r6/Q0N/JClBaoVimnMoZhvF8FFP0vYfS0x6NqoiS8IlHKfCI6rSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716486821; c=relaxed/simple;
	bh=1vlJyEbwuX0ZoN749JOIjA4u6/xlKVfxbDsvgdeX7zI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TeVeaEZr0foPkEEVVrl4DQyxLPcd1R9vWtegnXiUAvJsyd4wdwFa7BwRJNWUFxzmDpEWL4Vho7wRyHjxuLptpWb5AUSFVXmaKcw1gd1Boehv64eyQECgjPDitw+40Fv39gKRoiXfKSX1qlFmmtd7hgcUI0E0U0phrs7jPD6vzeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=GFokNs26; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-792ce7a2025so114416585a.0
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1716486819; x=1717091619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1vlJyEbwuX0ZoN749JOIjA4u6/xlKVfxbDsvgdeX7zI=;
        b=GFokNs2639blQKjNSCx44Qm73y5ZcwUf2/YV/8LmDzfVxmDxE98ehiRerYGcEYRSgV
         vwiSD3+fvCwF25ibN74KRFZbXpAbPAkoOD83IFhXKriDQS+OKjfStj2xwsLMl4wYKfxc
         F0k0YBn5V3+KDEDxm8shoIHJtcT4fa1IXDx/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716486819; x=1717091619;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1vlJyEbwuX0ZoN749JOIjA4u6/xlKVfxbDsvgdeX7zI=;
        b=sMhOtcD9X3BobbMQyd9plIUmpzNKuWyJsxErG2y0f//humjaI/gPr6Y3fBRkZMynzs
         nX0zB9nX0VThyTyL8MsPDkTlx3KLowgjjbmbyg4R20MSu61K1OwI4wBlmzTxVctFdVoe
         NRCgs5+eVtmykLzWUTSlvoGflCnQywY0LI88iso61qezJdlnuptRmm8sOxFTB8yfnMbH
         rboIDWzBGLSckEWEHlYEDpKZWt+NrKX0piyfs3XESEkkpITUkAmccfIoE3LWrEUfnTpL
         5hLFijXC6O6UnYJwdC629witZnDxQ7+dgWQ6kqbtu9vFOJR68z1NqRzAmVbojq+hcr87
         uNuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpQHINq4G0adNXGcqjfHmiNJrYh3j02HDeaSG0yFA0AF1vwpfNGEgG+vtMjKroTZCuGsG3sHpLpqlIwrhhUNGsxS6N
X-Gm-Message-State: AOJu0YxOOPpZ0ixUkHyfqHS2l3IeMIojgTMI8oShDSNsDswVrJZ4ipV0
	/a59OfmrbPIfXfeiAgDxXWjylH55oX63UrzpcR8G5wMX5yV7E8VZhwN1ufWJggQ=
X-Google-Smtp-Source: AGHT+IEyrXjRVTMHXi2p1He6w4MOb64tPMvvceUjvt4BggM/FGRRB/9P/aYFoq9Qo2ZNpSp/rwdk2g==
X-Received: by 2002:ae9:e009:0:b0:792:bb55:906d with SMTP id af79cd13be357-79499455581mr571133085a.39.1716486818588;
        Thu, 23 May 2024 10:53:38 -0700 (PDT)
Received: from [10.125.231.30] ([217.156.233.157])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-792bf2a11e8sm1497940085a.58.2024.05.23.10.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 10:53:37 -0700 (PDT)
Message-ID: <0fcbfcba-9fe2-414c-8424-347364fcbf35@citrix.com>
Date: Thu, 23 May 2024 18:53:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
To: Alexandre Chartre <alexandre.chartre@oracle.com>,
 Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, gregkh@linuxfoundation.org,
 seanjc@google.com, dave.hansen@linux.intel.com, nik.borisov@suse.com,
 kpsingh@kernel.org, longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
 <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
 <93510641-9032-4612-9424-c048145e883e@intel.com>
 <5ed7d3c8-63c3-48f3-aaeb-a19514f4ef5e@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <5ed7d3c8-63c3-48f3-aaeb-a19514f4ef5e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 23/05/2024 6:03 pm, Alexandre Chartre wrote:
>
> On 5/23/24 17:36, Dave Hansen wrote:
>> On 5/23/24 07:52, Alexandre Chartre wrote:
>>>> Should we wrap up this gem and put it with the other entry selftests?
>>>
>>> It looks like tools/testing/selftests/x86/single_step_syscall.c tests
>>> sysenter with TF set but it doesn't check if the kernel issues any
>>> warning.
>>
>> Does it actually trip the warning though? I'm a bit surprised that
>> nobody reported it if so.
>
> single_step_syscall does trigger the warning:
>
> $ ./single_step_syscall
> [RUN]    Set TF and check nop
> [OK]    Survived with TF set and 26 traps
> [RUN]    Set TF and check syscall-less opportunistic sysret
> [OK]    Survived with TF set and 30 traps
> [RUN]    Set TF and check a fast syscall
> [OK]    Survived with TF set and 40 traps
> [RUN]    Fast syscall with TF cleared
> [OK]    Nothing unexpected happened
> [RUN]    Set TF and check SYSENTER
>     Got SIGSEGV with RIP=ed7fe579, TF=256
> [RUN]    Fast syscall with TF cleared
> [OK]    Nothing unexpected happened

:-/

What about the exit code?

I find the absence of a [FAIL] concerning...

~Andrew

