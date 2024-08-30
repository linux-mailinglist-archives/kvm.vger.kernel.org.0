Return-Path: <kvm+bounces-25481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA727965C7C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 685C12894CF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 09:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4720616F8F5;
	Fri, 30 Aug 2024 09:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QqYfZ5hL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A306D165F05
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 09:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725009284; cv=none; b=XUalc/q3usN1+Ol4D5xRq9lqsZB5jDKDCwAfZVUsm8iOVYTeDnJl+iH4E3eMpzZ1bzEcfh67uWTGbLsfvIveI2NeDmmJA8OHMpo/Xum5Bix98C4iaCmZlazYIteD4G8Q1NC9lyF+TonqHo2wMOw7I9ExhzEZB6HUl13svsVYT8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725009284; c=relaxed/simple;
	bh=MunnVq1WWPfhulh5ublCo8ivCjgw6ojCfob+0vtSfi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkGqI7UJcq7xiGcQ5kTVY0cK1NEDkYGEQBIhGMfqzPdYMOOjXmySVMcp7+aY/ox0vVZAidkK/p9c9fM7ShFsPTINfNwhPKCiC7sbx72DFzdFRtaC97U7B6Tpzj+xj1hGhAlH9yJGUIpAdD+ynXT+iy75w+A+FXo9rB8vih/JT8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QqYfZ5hL; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7aa086b077so155271566b.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 02:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725009281; x=1725614081; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dCpWiuYzwJ/FauLPmsqDAK2T4ZYA4VoIq/mWU+rdRSc=;
        b=QqYfZ5hLq0ypboJ6yPa6PI/cwgQJ8qWKLrViJ1uBcDTorND0H/kXZOCaEfCO6VRbEE
         Gs7a/1cCe1nZgVL+GqOhHUmdp2J3aR31/+n+PK/AxdhSv2pDoibZOaOXtacqA3KlZfFe
         DlL8oZWEvdc8depAixo4EhEEieui7bv46/P5/lLDRYHdPGEtNjreyJvX5lA1oTrsw3nz
         IsKcIAF19mE/LW1ndoio8tOfSiD4gPt6t1wEz96OoGPTkXfa4T+crybDgtRrdoaOIhdy
         WpdWp8uzlA8sSb7JtNViBWf3SSjVNqn/bWyJ/NaHihgf5i3ccGt6kO+FctxQZMAC0HQI
         IPeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725009281; x=1725614081;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dCpWiuYzwJ/FauLPmsqDAK2T4ZYA4VoIq/mWU+rdRSc=;
        b=NEEFrRgIM+x4Cb6pRxcI61sGLVHEFzpPVTp5VluE7aqU6qfFxpTqv3H7fJsW3H5p1O
         5MPsIS2Xx8ZO2kaStRj1FmQYr2j+NwzugzYQlhAVpWqRUTqBhYdXbPdNVlyR3zaHs+ke
         gFWlc8MBBb9T0kzoS+QsdiysUvNHh6Ynwuj5slmmPae3k8eRG4DVuEDfmGEumEs2BCNU
         7Nvuakt83nCyu7jv1w/f+o/Gnqa5mkrXsQCEAfaI0+Df2vKmiYI1Fpb12gvJ+4ZwwPPV
         3nuc5XjHGB8opbwO0wzCKFBKWlVvcphS72ZWyS+jXPnzf4twcMlwfc1krze+EVDi6Q25
         81FQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPbS4DOFGYs4orulH1kn+UMHEHqdxxkafVhnIaEQcE3M8upvcdOMB9Rd7VECOfsRcNgwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPPcT1V8VnCNKhLQxhdGc0FS63ZUivv8w45YB/pfBFJYSVLclS
	K4NZcLCgPTTtNK5CyQTaQnor8ICM6PEjxHXsit/ZXMrfPtaHi4uMVSLZ50J0W4k=
X-Google-Smtp-Source: AGHT+IFAr1LxcA7An7pzAxQ81bnftOoBZ24oOM6gpjEcc9xyIM4qbjIqXwvlNIMbdUQuIuTDlnqWQA==
X-Received: by 2002:a17:907:7d93:b0:a86:746a:dced with SMTP id a640c23a62f3a-a897f822f9bmr481910566b.19.1725009280520;
        Fri, 30 Aug 2024 02:14:40 -0700 (PDT)
Received: from [10.20.4.146] (212-5-158-102.ip.btc-net.bg. [212.5.158.102])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a89891a3ceasm190249166b.115.2024.08.30.02.14.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 02:14:40 -0700 (PDT)
Message-ID: <8c651be6-aa5a-4ae6-b58e-aac2efa31de0@suse.com>
Date: Fri, 30 Aug 2024 12:14:37 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com, adrian.hunter@intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <88b2198138d89a9d5dc89b42efaed9ae669ae1c0.1724741926.git.kai.huang@intel.com>
From: Nikolay Borisov <nik.borisov@suse.com>
Content-Language: en-US
In-Reply-To: <88b2198138d89a9d5dc89b42efaed9ae669ae1c0.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 27.08.24 г. 10:14 ч., Kai Huang wrote:
> The old versions of "Intel TDX Module v1.5 ABI Specification" contain
> the definitions of all global metadata field IDs directly in a table.
> 
> However, the latest spec moves those definitions to a dedicated
> 'global_metadata.json' file as part of a new (separate) "Intel TDX
> Module v1.5 ABI definitions" [1].
> 
> Update the comment to reflect this.
> 
> [1]: https://cdrdv2.intel.com/v1/dl/getContent/795381
> 
> Reported-by: Nikolay Borisov <nik.borisov@suse.com>
> Signed-off-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

