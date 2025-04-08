Return-Path: <kvm+bounces-42942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EA78A80D01
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 15:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5750189D0BB
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 13:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84F9D1B4243;
	Tue,  8 Apr 2025 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ho/6hiNZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14BC1DFFD
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744120249; cv=none; b=FeSXwTLZ+FYdHGJKl6DpKnvST5FHci2ds9aB37lswhnScdPXg1oQ/lY/gqltKQPzVUecXTqo8u+cLFZvfy7nfCHvAiDg1MgkeRwar7dJ6gcncQdUldv2Aeluy2MuIEAXE86zKQbdBzkz6aDTO19Yrxyl3oYaYxKT4SvMQ/8HdfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744120249; c=relaxed/simple;
	bh=NCsWfL0MybYgp+JwS252qiXik2UmAOGQz50Z5XeC1Ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dCPReRrTq26h//tj0ot6b+eu8ghj8l4Gn+QOMVR/Q+yefjf8xWZblj7cKrOzwxQM/iHGlCDWoVF8kAoX2PrJZh3MCq+bMFf51RbEC6Kij8CSYAwX06pDcdhUpNeHfHTaIgFA5tUr2G5ebtv28lh+p93BVAZzeDZWTG+jiWyWUPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ho/6hiNZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5edc07c777eso7245288a12.3
        for <kvm@vger.kernel.org>; Tue, 08 Apr 2025 06:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1744120245; x=1744725045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5fM3gX3mnntU8mKyK8O/mS1b9O+ReWBswTOnb6yk+1U=;
        b=Ho/6hiNZYSIwTz22vtvQ7tLPj2UbDBPGZCDSMiERo0Rw26WheIMT2kEii46gp4jLHX
         l18y5R7bltZcf5tC1VPGZuSSEtjKZEj+i1JvVmvEVJa4tgzvSIwLpiWgmdsyTsTvgQvm
         khCkt/elQYulfa8saQ537QLrWfUzxrPUCCiSk5Ca9/Uj6SVBs5zqcVFVD/f1R/Cfetha
         HY94Pyd3PuK74cdUah/rwZAaPHNcfVIQQV4q+MpTlk65JUq/kLaPRuCdvTV51PyS6LOe
         o0OaxXksHTjR0yKXayZ7Z8y49xumz11iBJmaRy6qykWaFMjxL4ugLfdFSxzk64BCtwVS
         wYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744120245; x=1744725045;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5fM3gX3mnntU8mKyK8O/mS1b9O+ReWBswTOnb6yk+1U=;
        b=TzFdPUBpEuH6k150drbfvj9Zr1v+02rKH9jggSIhVfmQI9b7SRlVfLcCCMT0Y+t+UL
         A1FEFRCEbsJp9hCKnuYjko2wqQZjo6qCz8KHgtUWdjtRvhbmvO8MjG/SQKtrz0UQQIR/
         370AkADOzwHpeoe1bAz4oTLrLVd7SOg5S9FET1JIcKAQnvCkGYC9dx3iy0T5B0JBTFl7
         o1zEIdkbwjaqpIT0hWdYbb4dY00piXdn/8ObxivfbzkJ52tTlVDzwP8xf/cfPU/DIvIM
         SVWmNGgM4N8c32KQb0i0skIlUO6EdCkQTmGvsS9uJRxZ22nTeyba+lWjw7cV/TLTfmZN
         GCsw==
X-Forwarded-Encrypted: i=1; AJvYcCXLSR0EkSkswRl8Sg3RZPVi1lJegCWmVmAKGFtdSsNAYXl4MWoBGUVN0ii0CMiIYgwp38Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YykvgaoKoZ9JoJeGLrYVGU3myXrsZwojkPASgVraXWmEoA2QG5x
	sQ9tDnoRkC2EzzkiN+Wp5rU3k6BNVdawBEK0NuBnyTB+B69VrieRNjNFkJo2t8w=
X-Gm-Gg: ASbGncvj/jvwsA1aA6PY74lt65orCIQ5KoSlzylxvUnjYTU2EkHxOfVj0X6wo/eY+vv
	sA0qYgccA9rNDxtS39PBkJMvSzPlyUyZ2skYTm6syczyZIdEkM1MTVByfp2ldd2Ew7EriQJXgIn
	ADStHRmmieKT06yrDDv3rafW6JYgUVZcnokLyOi437h9F4SkSyUpeNMRRCK/urq6p+nJJVZG8Wu
	PZxhwWwt8LlJ4thiYfFEraK0XFzCpqYcaIBUvHLl+uEgfjEU9aeT7ZWriFSv3Ieg+PFv9rMznQR
	eklzeWN4SZl2LIQ20qtxRtrMxe2O7wmrBmV4PZb6lD5KzQAwgw==
X-Google-Smtp-Source: AGHT+IHAZbCBMTkJULUxkZ8VSTmMiMLSnh65yKkazUvPoIlJAUQd1W73SQfkwomVlw3lt2/E+H3YSw==
X-Received: by 2002:a17:907:9605:b0:ac3:8993:3c6d with SMTP id a640c23a62f3a-ac7e72b6218mr1158874466b.26.1744120245067;
        Tue, 08 Apr 2025 06:50:45 -0700 (PDT)
Received: from [192.168.0.20] ([212.21.133.214])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe99c7dsm925314966b.57.2025.04.08.06.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 06:50:44 -0700 (PDT)
Message-ID: <b9c081b6-3a92-4c46-be04-19abdb1ca429@suse.com>
Date: Tue, 8 Apr 2025 16:50:42 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
 amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
 corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a305206cd08cde28c46a1ef19f5668a3fff9b013.1743617897.git.jpoimboe@kernel.org>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <a305206cd08cde28c46a1ef19f5668a3fff9b013.1743617897.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2.04.25 г. 21:19 ч., Josh Poimboeuf wrote:
> eIBRS protects against guest->host RSB underflow/poisoning attacks.
> Adding retpoline to the mix doesn't change that.  Retpoline has a
> balanced CALL/RET anyway.
> 
> So the current full RSB filling on VMEXIT with eIBRS+retpoline is
> overkill.  Disable it or do the VMEXIT_LITE mitigation if needed.
> 
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Amit Shah <amit.shah@amd.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

