Return-Path: <kvm+bounces-65659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C593BCB3582
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 16:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4522F315F170
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 15:42:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38F6324B0C;
	Wed, 10 Dec 2025 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RskMUuF1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1214225A39
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 15:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381330; cv=none; b=JLpYJ4Aeog84DXY8hOKsNc+svo9rdjbhUSOC9pSe2llCvsWRpLmEGfXm1sylQRUyM39w1M0c4ZG/aMPOMRTGPrflUkcodUtqM0MabjfzsFc49Td1g/nV0CqR1NG9GXYdUYCjM7cazEmTRE6SSvx7at7AHv386U8p+HwaiEvKyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381330; c=relaxed/simple;
	bh=9govaUj8SzA35rf8NY0yqITZlG8G3R9NKJYZYbIgCjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwbf09jakmA/SYoyt86GUiaz3/N+SeelkdGCn2WMMBysSqpMvdJO6xLFAQDu1978T+QXFANXC1Bak66MH++lndDtHJcxwu/XfD6S6F4Iuquy0qmnBXai3PlTLNEPUvAhYEfUONHZlHM3Doxu6BXTywb9774JJL9zO+F8jjxhlIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RskMUuF1; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b73545723ebso102625766b.1
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 07:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765381327; x=1765986127; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lbXTteelmt1EHb1MSeuyn9tRgvMtj8IJEFaCHVXQDBw=;
        b=RskMUuF1zhr5YfvZTZJsmFyY6D+DbWcP2MCIq55DlGIPMLz3Ic/Gfc8dRjXnXr6FpJ
         Xs5ZzmBB+e5GgU0gdaN0He/vrNZvpn6y5zQAHuet/twaMH1Q9lXdVTrm+rIQ4Sqwacs1
         M9lFmMHMOStAsVaH6h/MQgORPFIoMsMtvqij+96lq4THfZKOqMls7p1ioQ4Ru7pr0hTp
         APzHtCs/jvvF/YjlYniBMi307ZfwAPdav1p64HV7UOrECAVaevdqFOXP/5R3nidnS6Qv
         2eAwbSlK9pqwKDb//aq+uurQd/l0UuqNGKjcwObGC0u75ueLYIddGBsEvdaTg+c2cnaF
         h0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765381327; x=1765986127;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbXTteelmt1EHb1MSeuyn9tRgvMtj8IJEFaCHVXQDBw=;
        b=Pilmo7m8rFScHjNui8Kpw7pj5zTBnwe/rrPHAtHe7FkNbYnTh/j+kZ0SVEiM4rug2c
         MufYZG5z+opZp//Ojsae7hx3DhCYcmfUQgdxOmWRhGfBpi8j/aadkhin9JBWU66Agysi
         0bt6vYNxz0d9BXSUDlqMB+HKna3eSu1bbFG4UFjN/R4NH9FEz5QM3FKVxaSlfpJ2tfG4
         GJdkLNx4KHTkIvBL47hIUvcdld765IkbTxAt6pIDq44PpdbG2dCYMozz28EwfSl3wOJd
         sjIchbtMMCFzOwZHO2Ubicuxh7HwNyibwTR3XGXnDPA+LXSRGx2hYfTBmFvcqxUC+rmH
         fkDg==
X-Forwarded-Encrypted: i=1; AJvYcCU0qgJmIGVIe+q1QuxztuyaM8ZFQ5+CA/DEb9lRGkGpZHLeuMpAaYGFxhiUZwFh8Tro+7A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1mCq+rN/Tn7ZtudD5DgT0DUgiWOf97oxcEdJ0zY3WOfEA8490
	DcbmshQewvyGrPb7fpOwEJDW6SMntGN2dC5ZitReUE0U/mtRG8P0dDlPAcKucy0MEjU=
X-Gm-Gg: AY/fxX5EE5STngObHS+vtqNgYqPcme2O22B32dF2JL1KunMu52R8ACivRdO9KraU2XI
	pr2CpY5TJIDKdooBimpzBMHmzbvWurOp6QTvi+4HjxIEUfPKvlv6saUqclk9aRcritajxOWVwEo
	VTNuxiOGd97jHmv7cvHJGTRHFTAhEdbzWbyyGM+bAE9cDb2wneiSNsVgKnvhKqoUXd7Lc9MdvqM
	LsTJm/OpGoY31e/nMqnmgxR1eVr4VpKzvD0QGqqA87d91tbBorpmnZXk/ROxf/IFIakFwylz3Ch
	maAFIYt/P3HCMGcly2fV/WiSLQTVcjO2TWJ/c3wCPnDeAQHu7CTGW9/QFhR63Sxs+YBWmT7qYLu
	fHdPur0K3lieJ1l27BXL6XgkG2xJ8R5Ui8jins4ReIxKCrVTNMfOyYup+P7kzNtWn3IvwvN3Clx
	ktOZNHTsI46MMFFQcb6cpusOLv
X-Google-Smtp-Source: AGHT+IG8/on4R4EWpSka6TECdfyeBlLHReCjvbx3/G0nteTt6fDyk1Gq3Bln1cKQ96R4EnzApCpEHQ==
X-Received: by 2002:a17:906:4fcb:b0:b73:5e82:520e with SMTP id a640c23a62f3a-b7ce8321d2cmr241933266b.19.1765381326888;
        Wed, 10 Dec 2025 07:42:06 -0800 (PST)
Received: from [192.168.0.20] ([212.21.133.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7bbad7b57dsm368057966b.23.2025.12.10.07.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 07:42:06 -0800 (PST)
Message-ID: <a90b81cb-b6b5-4071-b5d6-713ce8eff0cf@suse.com>
Date: Wed, 10 Dec 2025 17:42:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/9] x86/bhi: Make clear_bhb_loop() effective on newer
 CPUs
To: David Laight <david.laight.linux@gmail.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
 David Kaplan <david.kaplan@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Asit Mallick <asit.k.mallick@intel.com>, Tao Zhang <tao1.zhang@intel.com>
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
 <20251201-vmscape-bhb-v6-2-d610dd515714@linux.intel.com>
 <fdb0772c-96b8-4772-926d-0d25f7168554@suse.com>
 <20251210133542.3eff9c4a@pumpkin>
Content-Language: en-US
From: Nikolay Borisov <nik.borisov@suse.com>
Autocrypt: addr=nik.borisov@suse.com; keydata=
 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
In-Reply-To: <20251210133542.3eff9c4a@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10.12.25 г. 15:35 ч., David Laight wrote:
> On Wed, 10 Dec 2025 14:31:31 +0200
> Nikolay Borisov <nik.borisov@suse.com> wrote:
> 
>> On 2.12.25 г. 8:19 ч., Pawan Gupta wrote:
>>> As a mitigation for BHI, clear_bhb_loop() executes branches that overwrites
>>> the Branch History Buffer (BHB). On Alder Lake and newer parts this
>>> sequence is not sufficient because it doesn't clear enough entries. This
>>> was not an issue because these CPUs have a hardware control (BHI_DIS_S)
>>> that mitigates BHI in kernel.
>>>
>>> BHI variant of VMSCAPE requires isolating branch history between guests and
>>> userspace. Note that there is no equivalent hardware control for userspace.
>>> To effectively isolate branch history on newer CPUs, clear_bhb_loop()
>>> should execute sufficient number of branches to clear a larger BHB.
>>>
>>> Dynamically set the loop count of clear_bhb_loop() such that it is
>>> effective on newer CPUs too. Use the hardware control enumeration
>>> X86_FEATURE_BHI_CTRL to select the appropriate loop count.
>>>
>>> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>>> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
>>> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>>
>> nit: My RB tag is incorrect, while I did agree with Dave's suggestion to
>> have global variables for the loop counts I haven't' really seen the
>> code so I couldn't have given my RB on something which I haven't seen
>> but did agree with in principle.
> 
> I thought the plan was to use global variables rather than ALTERNATIVE.
> The performance of this code is dominated by the loop.

Generally yes and I was on the verge of calling this out, however what 
stopped me is the fact that the global variables are going to be set 
"somewhere else" whilst with the current approach everything is 
contained within the clear_bhb_loop function. Both ways have their merit 
but I don't want to endlessly bikeshed.

<snip>

