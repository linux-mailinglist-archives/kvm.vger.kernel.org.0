Return-Path: <kvm+bounces-54974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A752BB2BEF5
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 12:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D1783B886B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 10:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21967322A32;
	Tue, 19 Aug 2025 10:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FLg7bhsc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F301A3A80
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 10:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755599497; cv=none; b=tNKWLuMQAgZ5SlMa9aF5himVwG9eMQhIplT4o2bGmaNZOvm/PiOGR4xRaFQtFBf6ntJp7+sg9hxFKvrkdzhdkdkvaqovD5m5fNFssGcV+gsOWi7cv1kN/cJY4qW2BYJxJAPHScYFLTmUhgVhp4Ome2dZ38I0jyvAIabT2+uZPO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755599497; c=relaxed/simple;
	bh=Z1FQJRvXK+5ciatpWqG0q2N0NV4FoJzB7WXRXsmnMNs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m2aMSktzmIViPT745+cDpwm7Tc0uKgaPwfaYQ911gWuj0SfxRputEAI+NUOPhXtC3dlG/37IuMy4Uq8Mr8HFcpVx2ZCZfJPgBRlBzu46e2bDWrVBV4uu5jHXgolP+UNSYoB3Fn4v+Y4gupgCkfzgU6BZX4XUeQXChy6/7Qr6t20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FLg7bhsc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755599494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6SIOd8ObRpdoaKuoMI2GLwSCZR2syervmBJmw//7VoI=;
	b=FLg7bhscWKpvu/DyDTlxHJMDFhx2Qvt4vrMfuASMSnBhhGduoSw2+mq30Ri6kGpOsxgtzz
	gZWBmcVqkQLjz/jp8Z9zdkfsGBTur8QzAfakR53/7yTg+dZu27hpv1ZWWtKcKzoHUvKHOa
	kv3rXTigeZBbErMdnAYCglXv7bVWcZc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-aV9XcfkaPauTV974Lq9uOw-1; Tue, 19 Aug 2025 06:31:33 -0400
X-MC-Unique: aV9XcfkaPauTV974Lq9uOw-1
X-Mimecast-MFC-AGG-ID: aV9XcfkaPauTV974Lq9uOw_1755599492
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso32178535e9.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 03:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599492; x=1756204292;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6SIOd8ObRpdoaKuoMI2GLwSCZR2syervmBJmw//7VoI=;
        b=kpOhUYnX38behaloWbiHn04i5XGDGbmjqhkYjnEjBnpqjMbLZ0I+BwYsN56FRMii/f
         T7wv7Hi44IAS8ldEDRjLYtrrXVyXMyXOV+GfbDk3L3H0mxBKO1cgLVQrSWd8bAGnanRl
         xMFwg+LLVmmzxN4HZ5Mu5Bq5v/Ta9x+KFPR3UVP5Tr+peFOrmknYkXEhLl1eibx0pLwh
         G07/RdTb/2pIn10HI4shNtlCZ6nJFGcHKSe/56kGvhI0cONUCw64bX+TwPuu1WqdRAq1
         41u7EaZaT5utgpn6FXYESFfGBMm5cxq2ncEjtpDUmwTTuOZS4YhkuSxGOpv03n003pFP
         1MyQ==
X-Gm-Message-State: AOJu0Ywcg8jACoKXL2o4BGpquIU+sWgPF48wOVcKJb9dpg/VfQ1gmaRP
	QUqAuVYwdIT1Y5ipTdnIctkT4p6FD2ukIp5vNZV3gWv5mUUMdLSWbCHMlgk/bPF9c1RT+pbnFHC
	WPA2wxJk7BV+bpLPVbTNusKnU2G1+DN7wAqrqe25Iu7PYxt09QBGUPQ==
X-Gm-Gg: ASbGnctFqP4qSB2tVHRMGyFvGHdFt/ucbXdzhSZeGAcAADwxycEXwoFVURMmyzd+v5i
	es8GRkM2QzO8qPWReWfOVIrLiEjNsoqdyM7srVveBVNv6H227to0ZDBjtsfQ2X/awfsVIjgyn0t
	fW0JJpbzZp3KEZD7JY6uP6XdW+trwwv8DxBIy8TxZhKdAOcPC5+3K+ZI1lyWibHTKNhj0KbyMGo
	P+Da7jyxEZXHHDbaGuWsY8PsQG2gPYnqSlzLKNtzyb++VLOPcC8OgKfZB385Vs62hAcoxRxBJH5
	FQR1299Kz1y2Zl2tKQNjPRlQw+ukoi35LyDcfSp08Ug=
X-Received: by 2002:a05:6000:2209:b0:3b7:b3f2:f8b3 with SMTP id ffacd0b85a97d-3c0ebfa8d26mr1658578f8f.38.1755599492072;
        Tue, 19 Aug 2025 03:31:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP3uAZKVa8e/b2gW5qxnSGJayD/soFphN0JIUb2y2cryIHlMhP7tnkHIEtYTpfkqV9qx0Zsw==
X-Received: by 2002:a05:6000:2209:b0:3b7:b3f2:f8b3 with SMTP id ffacd0b85a97d-3c0ebfa8d26mr1658529f8f.38.1755599491517;
        Tue, 19 Aug 2025 03:31:31 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.56.250])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3c074d4393csm3165234f8f.17.2025.08.19.03.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Aug 2025 03:31:30 -0700 (PDT)
Message-ID: <acbcfc16-6ccc-4aa8-8975-b33caf36b65f@redhat.com>
Date: Tue, 19 Aug 2025 12:31:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] KVM: TDX: Explicitly do WBINVD when no more TDX
 SEAMCALLs
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
 "Hansen, Dave" <dave.hansen@intel.com>,
 "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
 "kas@kernel.org" <kas@kernel.org>,
 "Chatre, Reinette" <reinette.chatre@intel.com>,
 "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "mingo@redhat.com"
 <mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
 <farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
 "Gao, Chao" <chao.gao@intel.com>, "Williams, Dan J"
 <dan.j.williams@intel.com>, "x86@kernel.org" <x86@kernel.org>
References: <cover.1755126788.git.kai.huang@intel.com>
 <d8993692714829a2b1671412cdd684781c43d54a.1755126788.git.kai.huang@intel.com>
 <aJ3qhtzwHIRPrLK7@google.com>
 <ebd8132d5c0d4b1994802028a2bef01bd45e62a2.camel@intel.com>
 <aJ4kWcuyNIpCnaXE@google.com>
 <d2e33db367b503dde2f342de3cedb3b8fa29cc42.camel@intel.com>
 <aJ5vz33PCCqtScJa@google.com>
 <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <f5101cfa773a5dd89dd40ff9023024f4782b8123.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/25 02:00, Huang, Kai wrote:
> On Thu, 2025-08-14 at 16:22 -0700, Sean Christopherson wrote:
>> On Thu, Aug 14, 2025, Kai Huang wrote:
>>> On Thu, 2025-08-14 at 11:00 -0700, Sean Christopherson wrote:
>>>> Reducing the number of lines of code is not always a simplification.  IMO, not
>>>> checking CONFIG_KEXEC adds "complexity" because anyone that reads the comment
>>>> (and/or the massive changelog) will be left wondering why there's a bunch of
>>>> documentation that talks about kexec, but no hint of kexec considerations in the
>>>> code.
> 
> One minor thing is I think we should use IS_ENABLED(CONFIG_KEXEC_CORE)
> instead.  Besides the CONFIG_KEXEC, there is another CONFIG_KEXEC_FILE,
> and both of them select CONFIG_KEXEC_CORE.

Agreed on needing CONFIG_KEXEC_CORE if you did test it, however:

1) The big comment, explaining how this is done for kexec, makes it 
clear that this is what the WBINVD is needed for.  I don't think you'd 
be left wondering why there's no hint of kexec in the comment.

2) ... but anyway, KVM is the wrong place to do the test.  If anything, 
since we need a v7 to change the unnecessary stub, you could move that 
stub under #ifndef CONFIG_KEXEC_CORE and rename the function to 
tdx_cpu_flush_cache_for_kexec().

Paolo


