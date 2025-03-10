Return-Path: <kvm+bounces-40686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2EEA59AFB
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:28:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9AB47A6C25
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF0B22FE19;
	Mon, 10 Mar 2025 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sFGUSiGT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E730022FE03
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741624090; cv=none; b=sCfpc1cuQRXSwdiEmUMB4T8f8WxLexsYDk+jjL48knlsc3qdxC+C5gtc7F8sF8FTLeg+g6BP4wDsDm8hapNt0ZvFwgVZF8SYXg3x89dvy+AviGSd4dQabmSL5VegKthqI4H4HSxTdmbSyAXmGbT8c2dklVLRX0tZFoJFxl+LJgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741624090; c=relaxed/simple;
	bh=/XhQmGpzx+CO0FnqvEpxifIIGOLRoQVm+HZy/K1HP14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sg0dDU46m0IEtxGoP8s/hA7libWn/vfhrEyxVCU3c6uIf/PRvSLNATBnZj8VKKrM/y3dCA5+71woB2fNfrDmdydLz+6E3oEicmABnYceHXDE9SGClGtbm+xKmfEdx5MFzOuoarQBIBi14qCh45rgj05TebT3R2jhdp4QjQdlBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sFGUSiGT; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-300fefb8e06so409360a91.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 09:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741624088; x=1742228888; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MB2fJsQ4IboLQPMn+u5sD/iZ5CoCsD5DvTx+in/FBzM=;
        b=sFGUSiGTD/OssEVfoHA6e4qQcfR1qWDHKFc9nQuKL3OXV5inpjvJbF+kgNXGyWbxHm
         zju2pOXWILPplXun0rd2TXAx5YTVH7F+RBD1kMsf59sssR/uwSeU/7HU0I4BrBoq/PzG
         u6QlMxbkeXDU7h2RbjShXwc1sjrC3DJ5FwGQx/7WrJckkKEW7ESLRUddXCfKULPxImlP
         FhtA6hka4rywa9pw8dfmPhHcV6xory0ry1V1oOAjBESylsf0zQMWdX41Neq2C8hCRPpb
         rjLWNFiP4uuHpw4OE1NtYKMWoBIZvDW/bLtDu2WGLz0u9e8qs8v0p5SR17rX77aXLXig
         kcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741624088; x=1742228888;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MB2fJsQ4IboLQPMn+u5sD/iZ5CoCsD5DvTx+in/FBzM=;
        b=aKpBhsOOCbV3mMuzsu2sXBxeFsiRWZyyTxEovQYQVvIrksZSde1wfF8AMfXoiQRwpN
         X8qLRbp5aXg4wa9qmRVZQVA75ZP8gi+/iQ7vZ1hIc51Oi7J0c03JGsrjOsGCjlnw7t+P
         xyjMFb8jvkIkv1pvwEV/e3ATv0AwcMxeifTi1I1gQVpo1Rosrj61CStfdniE3jZAjlcp
         SAWqRDYwf39Z4G3cQOQO+OmIgDdW5ZTZy1MUgquWmXACm/fu9A36CfEGdikCFB67jcPQ
         On12QayglR24cQHTPsh/I3X6stBuegeuAIXtbfVpc6/fHMyaDC6cKvDWNaoPg5K6bAB6
         qlWA==
X-Forwarded-Encrypted: i=1; AJvYcCWKCifJe1TdUHkg/8rRdXNbtCx/OPx6YHq2CgoWaBNZUD1mqPJaSbEAQUndevQ1mLny+Eg=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu0iRdd26Ut9duxaPq0omcGWX3Ivt6Sxf6b3Sa8Qw4UwKihb+l
	KkUyLROx1AKeLz2mKFbvPnF0vQBjG8V1FjqnuqfD258amqQ0o6yAvm0U+JIXZvM=
X-Gm-Gg: ASbGncuNDaVU7dfvQ27zMCCE6INUi1nh7/aSkTXqwvUQblJvt4TrtjjQWoOc5BsFKgA
	8g5INLy7Dlxf8TmpLy+2h+QxHtwgN2cOcjKsTmXesNH+a6A/aJL0jBImzf1pDyV2mPza9/5z4na
	7YCgdO4R2vzxUtVv1jzMeRC49tIUc6WbbGkOeZZ6c7oquEabSgEt6KBKx5h8Ly4eNrDdjX0nnYg
	U0GbBE4Ux0C7+rD1w00zlIE1lnfm4148tU6hwRDia2TvzoUv5uiE314joG1s6bdWl32C9Kd4N8F
	F4O5jkbpjKG4Q+irKec8wRn9fA2AZaDhn+LK1yx8Ok2vdJexZFAMOlRPfg==
X-Google-Smtp-Source: AGHT+IEMClmiHQu47yv2LCemW+QIh5GG4atFR9obpakYwQTFo0T5HFRT/xNIXLHFw49N04gZ3Ngyqw==
X-Received: by 2002:a05:6a21:6e8a:b0:1ee:e2ac:5159 with SMTP id adf61e73a8af0-1f58cb438c6mr642912637.19.1741624088169;
        Mon, 10 Mar 2025 09:28:08 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736ab33e1d3sm7113582b3a.132.2025.03.10.09.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 09:28:07 -0700 (PDT)
Message-ID: <c5b9eea9-c412-461d-b79b-0fa2f72128ee@linaro.org>
Date: Mon, 10 Mar 2025 09:28:06 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] make system memory API available for common code
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, alex.bennee@linaro.org,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, kvm@vger.kernel.org,
 Peter Xu <peterx@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 David Hildenbrand <david@redhat.com>, Weiwei Li <liwei1518@gmail.com>,
 Paul Durrant <paul@xen.org>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Anthony PERARD <anthony@xenproject.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, manos.pitsidianakis@linaro.org,
 qemu-riscv@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
 <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <f231b3be-b308-56cf-53ff-1a6a7fb4da5c@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Zoltan,

On 3/10/25 06:23, BALATON Zoltan wrote:
> On Sun, 9 Mar 2025, Pierrick Bouvier wrote:
>> The main goal of this series is to be able to call any memory ld/st function
>> from code that is *not* target dependent.
> 
> Why is that needed?
> 

this series belongs to the "single binary" topic, where we are trying to 
build a single QEMU binary with all architectures embedded.

To achieve that, we need to have every single compilation unit compiled 
only once, to be able to link a binary without any symbol conflict.

A consequence of that is target specific code (in terms of code relying 
of target specific macros) needs to be converted to common code, 
checking at runtime properties of the target we run. We are tackling 
various places in QEMU codebase at the same time, which can be confusing 
for the community members.

This series take care of system memory related functions and associated 
compilation units in system/.

>> As a positive side effect, we can
>> turn related system compilation units into common code.
> 
> Are there any negative side effects? In particular have you done any
> performance benchmarking to see if this causes a measurable slow down?
> Such as with the STREAM benchmark:
> https://stackoverflow.com/questions/56086993/what-does-stream-memory-bandwidth-benchmark-really-measure
> 
> Maybe it would be good to have some performance tests similiar to
> functional tests that could be run like the CI tests to detect such
> performance changes. People report that QEMU is getting slower and slower
> with each release. Maybe it could be a GSoC project to make such tests but
> maybe we're too late for that.
> 

I agree with you, and it's something we have mentioned during our 
"internal" conversations. Testing performance with existing functional 
tests would already be a first good step. However, given the poor 
reliability we have on our CI runners, I think it's a bit doomed.

Ideally, every QEMU release cycle should have a performance measurement 
window to detect potential sources of regressions.

To answer to your specific question, I am trying first to get a review 
on the approach taken. We can always optimize in next series version, in 
case we identify it's a big deal to introduce a branch for every memory 
related function call.

In all cases, transforming code relying on compile time 
optimization/dead code elimination through defines to runtime checks 
will *always* have an impact, even though it should be minimal in most 
of cases. But the maintenance and compilation time benefits, as well as 
the perspectives it opens (single binary, heterogeneous emulation, use 
QEMU as a library) are worth it IMHO.

> Regards,
> BALATON Zoltan

Regards,
Pierrick


