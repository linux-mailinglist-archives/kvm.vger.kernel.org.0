Return-Path: <kvm+bounces-19924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E2690E362
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 08:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AD8A1C23415
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324016D1B4;
	Wed, 19 Jun 2024 06:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="V0twpEms"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8266BB33
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 06:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718778518; cv=none; b=Ic1YnkmktViXKExrjpION4F9tasA8356wAhd6yvU9bNUIC1uSQkKYMtj5XthwgbNDyaa1omtE0afrUEFVzU0wvhxG3CDHEs5IkOnbpBFcJlbbM4zsAxPb+1/goAXsqL/kQzUJIEbm7X2dAb7q7JDGlS7LmSpX3uRuIpIv7N7wI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718778518; c=relaxed/simple;
	bh=7B/kXtoNela2Io9cwIyvyV6hQdiRl08PQhP5Nb1KpUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQFA6I+dxZxZb/ciNDHtU5IjkeidwVdIKDw6ytMqI61LPm2y+JHIztXkHFHHK9z51qURIbsgc5wYEJbfgPxnazxvCoddKafHc/m9yuNg2mFSG8o+7ua41Chk90B1dw4wlOuv8W9NMlblBdRT+gleFFtYTj/nLsRz71auO7R1Be0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=V0twpEms; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2ebe0a81dc8so66551001fa.2
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 23:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1718778514; x=1719383314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=r4B3sv9t3XzOxxWpo+MGeTh8MGOoofV5d/OJ3PnZP4A=;
        b=V0twpEms6ID0pZAahg5coGOalgqk92oDHi96JijBwTW/kf1UFxMbdkDoPl8h7FzIfn
         6PhPswip614VwP/R8klQ6+CHThHMbH6OEpY15wbLElMPpUOQpIgMCRwhZOEVNDxah/Tb
         TjC8bIMUdWZ9xI+aIuk4aQvDwAG1btg9IXbAfj5DTG5PYqL0c35bYL++6939ExiE0e2F
         TnQIVRDxnVm7LCENX1OvA+6bw9r+Zrid4RfluY599oeg75ma7A6pwTfnMcd2QNHiZr2f
         oPhQsIaMmBR+fxO2CN4Umxj75b9RDRwi5wdEVsP+mc40uLv2uY3TDJGsdVePRBLbP0EP
         Vmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718778514; x=1719383314;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4B3sv9t3XzOxxWpo+MGeTh8MGOoofV5d/OJ3PnZP4A=;
        b=njhIavAVmRMoMk6Q696vf2ELcwH9H+0+tMiKtKSVM/gzsB8ueVtMj7N+NZ0nO2TjKn
         aGmudibq87B0Ss0GssjLQEzVHHCG08/POKQ0kfgQrpmeJF865168a9iHGyG8/brOg1Rv
         49BTBMbD5t1vFGW0oR4NzEfZnwoHeYujapxvbq3L6CP8i16Ws4fmu4uAKPNnLHIh4Yy4
         NZau2A/6nPwsI6gBPtQVn7D5OPZLptR97pJ2rUCjhAdgMhKoLXUjggydpK75gYzGrMAi
         BzZlQeb6w6yL4iwus8+NFQUco7ncT9xdPGSCzHaky4NCRvLgfSiyPnsbk5NlyNz5Jlj9
         pkIQ==
X-Gm-Message-State: AOJu0YwXxm0iRiXexuntcCrA4dkCFxqFiiMW1bQT1J4lwPEplNJEtTdA
	NHUaHVoxHDOD2ubjOGGOvXE/FgjlHKvYOquH4tGtIj2HxoYpTOfYbrXi3O2UIGVTdMAi/iQMHZo
	q
X-Google-Smtp-Source: AGHT+IGy1KWsNYh7LDHfZiibSelfPGx3iZv2trzkDqdetJFLEG4g56xBD9XU/fFJVddanY53SClPAA==
X-Received: by 2002:ac2:5459:0:b0:52c:1d8a:9716 with SMTP id 2adb3069b0e04-52ccaa33d0fmr1005805e87.19.1718778514514;
        Tue, 18 Jun 2024 23:28:34 -0700 (PDT)
Received: from ?IPV6:2003:f6:af24:6f00:6a55:ce52:a405:13f2? (p200300f6af246f006a55ce52a40513f2.dip0.t-ipconnect.de. [2003:f6:af24:6f00:6a55:ce52:a405:13f2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607510340fsm16204298f8f.93.2024.06.18.23.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 23:28:34 -0700 (PDT)
Message-ID: <10b6e1aa-1ded-4447-9c97-2b054d563e48@grsecurity.net>
Date: Wed, 19 Jun 2024 08:28:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] KVM: Reject vCPU IDs above 2^32
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20240614202859.3597745-1-minipli@grsecurity.net>
 <171874680480.1901529.15135385772186699569.b4-ty@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <171874680480.1901529.15135385772186699569.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18.06.24 23:41, Sean Christopherson wrote:
> On Fri, 14 Jun 2024 22:28:54 +0200, Mathias Krause wrote:
>> This small series evolved from a single vCPU ID limit check to
>> multiple ones, including sanity checks among them and enhanced
>> selftests.
> 
> Applied to kvm-x86 generic, with a few tweaks (emails incoming).  Thanks!
> 
> [1/5] KVM: Reject overly excessive IDs in KVM_CREATE_VCPU
>       https://github.com/kvm-x86/linux/commit/8b8e57e5096e
> [2/5] KVM: x86: Limit check IDs for KVM_SET_BOOT_CPU_ID
>       https://github.com/kvm-x86/linux/commit/7c305d5118e6
> [3/5] KVM: x86: Prevent excluding the BSP on setting max_vcpu_ids
>       https://github.com/kvm-x86/linux/commit/d29bf2ca1404
> [4/5] KVM: selftests: Test max vCPU IDs corner cases
>       https://github.com/kvm-x86/linux/commit/4b451a57809c
> [5/5] KVM: selftests: Test vCPU boot IDs above 2^32
>       https://github.com/kvm-x86/linux/commit/438a496b9041

Looking good, thanks Sean!

Mathias

