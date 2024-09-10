Return-Path: <kvm+bounces-26301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5E4973D2E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82A9BB21ADE
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1DF21A071C;
	Tue, 10 Sep 2024 16:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cv8rYeaJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809F039FC6
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 16:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985608; cv=none; b=U4tikU0Iy9CcelEwJr/3EScAPGzoQ+kaX57dbBGNG32wvJQnIAL5cGCyyyI6G+i5h9YvClCysTAAKqK8tyQPlF8O7Rk3vJAvl1m4nODmz4rAc53X7dd725aBFTvDbBoGMW5yd4rn14+6UyC4FDaow00GHZgc9i/JMV+S4UpQVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985608; c=relaxed/simple;
	bh=Bd+nPoOOsqIzbjtguHQ5NA/oRUkaas6XJ6adN9E5WPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mWozkDzvpGYkXE//EYd8gwfW9vh8yx79W34+qMYkaxtklmfoCeBY/ItTK+gojnLG8IrBjLivMmAz3CckfNeoMfxnDWoVhYWpuAgcTozIArFPvditqMMqp25BYMhVA9EW1LUqzthdcYWsuoOT4fNNYR2WhmUM9HxL5JXPn+Kk5kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cv8rYeaJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725985605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+3vDHkX/sVjyVou1kS3mnypR93MRrjCrAqYlqG36lmA=;
	b=cv8rYeaJJdnL5s/ARY7ncwNQJppBUTlfCnyPTaWPTpx8p2M+dDRV173lMzvjwjDhZVX4yv
	2NTtyJj+EzQyR2ZnvHD725yJ0rWNkxy09AgyWO3mXFXgP3BEOhYgYne+rNdGvLJGgLgFup
	JhUxPuqXCrw0eqhdJ1fctbUdLFvk6tw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-7gLKDSLDOO-We6Dy_UUE7w-1; Tue, 10 Sep 2024 12:26:42 -0400
X-MC-Unique: 7gLKDSLDOO-We6Dy_UUE7w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb857fc7dso17903475e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 09:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725985601; x=1726590401;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3vDHkX/sVjyVou1kS3mnypR93MRrjCrAqYlqG36lmA=;
        b=FwUxAJHG36DTCbo58HtkFcaxr2vN/tN5pB7t2SyaW1H9Ts/UrS63AJdjsTMppbcyEM
         lML4kv4DBhbgLc+x5cmrDQTDk1PfPc6s0d8Jo3F4dgr5Pya+OA8MyDfQSe70acAT/HX9
         mjH7XQsAqr2yeYoBSQrNdstu6emE9bS7NztXBLE1kqeNjtj+j0rA8nCWLNaoBbu3pKyM
         ezNcg8AAh0uUUxWr1WMsth7D1vririzwovKREW/o/oiSfl9rCf0Ygyqx0/G4PW8T3IRx
         uWsyEg7IXykSohPGOYkSQ7k9iiUNInEzwdO19mfkLZLW642g5CU9GsiBFB9DwUAWyAdS
         0iOA==
X-Forwarded-Encrypted: i=1; AJvYcCW4zqodu9v8flc0Oqzt9OFfawe2lYS9ps8PwmbNnjPbTD63hFyw5rpx7590ZRvBn+BkemQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqoCLpSF70SkcSZblOFAtSJ7KQSr+xcHRvWnuXsR141+nipuDN
	9VvTC0VKykro/xu/Vu5bl3GKY3gkM9vzUwi8tv4EVisi5bf0oPcXxRc6+bPrpfoOd2z3cGyD6gG
	wCxkS4vWgwPfuBcvXERHaDEzo1Oa87gFxaw+ZNQ7tqfNpxM6SmQ==
X-Received: by 2002:a05:600c:4f82:b0:42c:b9c8:2bb0 with SMTP id 5b1f17b1804b1-42cb9c82edfmr48482585e9.4.1725985600804;
        Tue, 10 Sep 2024 09:26:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRIdHS34LOLVoIcSdeqq+gAkzswdc8AycnJEkouTBLz/WgNFr64LzOntpc6K81gMduOaOXGQ==
X-Received: by 2002:a05:600c:4f82:b0:42c:b9c8:2bb0 with SMTP id 5b1f17b1804b1-42cb9c82edfmr48482415e9.4.1725985600340;
        Tue, 10 Sep 2024 09:26:40 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564aea0sm9341799f8f.20.2024.09.10.09.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 09:26:39 -0700 (PDT)
Message-ID: <2300466e-f1b6-44eb-8196-d13285b55662@redhat.com>
Date: Tue, 10 Sep 2024 18:26:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/25] x86/virt/tdx: Export TDX KeyID information
To: Dave Hansen <dave.hansen@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>,
 "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
 "Huang, Kai" <kai.huang@intel.com>,
 "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-7-rick.p.edgecombe@intel.com>
 <614ab01d-eb99-48b8-8517-7438ca6cfef2@intel.com>
 <43af672ad0dbdeefaa45f72fa7a4ae68bc5d0fb6.camel@intel.com>
 <19dcfa1b-08fa-4a0b-9a9d-5df80fa94a41@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <19dcfa1b-08fa-4a0b-9a9d-5df80fa94a41@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/30/24 23:18, Dave Hansen wrote:
> I do like the idea of exporting a couple of helpers that are quite hard
> to misuse instead of exporting the variable.

Yeah, that's nicer.

Paolo

>> Separate from Dave's question, I wonder if we should open code set_hkid_to_hpa()
>> inside tdh_phymem_page_wbinvd(). The signature could change to
>> tdh_phymem_page_wbinvd(hpa_t pa, u16 hkid). set_hkid_to_hpa() is very
>> lightweight, so I don't think doing it outside the loop is much gain. It makes
>> the code cleaner.
> Yeah, do what's cleanest.  This is all super cold code.


