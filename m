Return-Path: <kvm+bounces-26219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A77559730D7
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D584E1C243CF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023A719259E;
	Tue, 10 Sep 2024 10:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EL6LuTtp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DFC18C039
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962561; cv=none; b=Q2qpib55562kYQI08FHx6xZtfTDO3Um9cpfjV5iEm9QO/2SiWW+FBDq3upZcU30PDaQCL2AldORcYjL4No5nKZM+MMVdNazFVxumdmwGmUa6vMBFiUTX1i+GwtvPHvHyWiwIAPFAS1UinYbCaZS+zhQ+rf6juY0lbZ9q9yHD/c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962561; c=relaxed/simple;
	bh=doj1p/tghLbwexq1ea6LnyQFPNXLGlk3z9W7gDs1ylA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+d7OWZgozklnDCet6tpNSSDtcPhLDh1pKhIb2jOb28BQCHWGA0pfDTsLgDUO2tw2VhLBIszL0bDASTnq2cvybdR1Mg44stqKJ5pGos45ctj5zqwLL1e9g6M7VsWYNiPoxcVA7KA4HTgVXtpSvX5fTvrS3VTVVTouRQlcTn6K0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EL6LuTtp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725962558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PNfpEt6KnVBwNQm3M1C9GzjGk+0WLePFqbzXbBy1GT4=;
	b=EL6LuTtp0Qu+X8IzyaR+Nn3LfiDZkOqBpyKcqZOjgpVJguLZYHE1XolQ1hUiQ/KZAW2cnB
	vM8xbbNHxfe39kVAwZ5yGjFgQaIF+Mi679VyzcCEUodYqmzjXJFPqWnoGxXzRLVg/GRIGd
	ojMcZopQAwXhPVj+LbUgA266DEXwO1k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-y7i5KMpMO1qrkuuTHcoGaQ-1; Tue, 10 Sep 2024 06:02:35 -0400
X-MC-Unique: y7i5KMpMO1qrkuuTHcoGaQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cbcf60722so8422095e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:02:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725962554; x=1726567354;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PNfpEt6KnVBwNQm3M1C9GzjGk+0WLePFqbzXbBy1GT4=;
        b=OiGDwIiwiTMyhOUE5fJbhumdOYRIt/uEsHQNDHCHsybNG7NfQ558EkhA5cG7j7DtYS
         peMi+12mssdIz37LhX02BRgulg3rl17gziUjIYTDlU0+oSIHerIK/Fa6ZOWE7Wf6NjOH
         utcMyx/KPIkm+sx+/bGt2ht/e9jsaed+1i3/rmkD0pOYWxs8KN8H41g5E74lofhd1PVV
         tr805cQPqSgho9bjcH2XhuGDejLqTN1KLeUHuLwlaTqm4psOy5lu6zup2k/BsmaKa/F3
         xb/oNeDSi9MdZ4PqbBaFMm/j1T+nbvXspbd+Cd2I2nIk5MjWmgdGRsWChTrlubfmU/Mz
         i4SQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAUVJKmMxDz/qxnCrF6fS+5lLTgBz3OvDGNwCLKPNeErxQkOXc/+io+y5qVvieUciBa68=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb9e9mh4Rx1JCSlKmENKU9Xxjb0zqniHfDfq6VYuK7WrmvCkDY
	dBTKAGgyQrAx7TZR33RfmgCFC4luZD/4QuWvNln62GSQCfKcxG1KZPduIHblKJxycnAOesC/lN3
	mWWZJw2kDk6zoYaS2tWdwBMXhjxo535YfoLFsC4/Tu4Qp22r+Ow==
X-Received: by 2002:adf:f6c1:0:b0:368:71bc:2b0c with SMTP id ffacd0b85a97d-378895c27a0mr8191870f8f.10.1725962553927;
        Tue, 10 Sep 2024 03:02:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgTK7nvRrUqbaD17hZpyrRXvwhUMGqSDL+EvmvKNDNa0xf9X4RSSObFH8AcmvlnfXdbRAG4w==
X-Received: by 2002:adf:f6c1:0:b0:368:71bc:2b0c with SMTP id ffacd0b85a97d-378895c27a0mr8191848f8f.10.1725962553373;
        Tue, 10 Sep 2024 03:02:33 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956652e8sm8556288f8f.30.2024.09.10.03.02.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:02:32 -0700 (PDT)
Message-ID: <e625ce93-4bb9-4771-817b-b95973003895@redhat.com>
Date: Tue, 10 Sep 2024 12:02:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/21] KVM: x86/mmu: Export kvm_tdp_map_page()
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-19-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-19-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> In future changes coco specific code will need to call kvm_tdp_map_page()
> from within their respective gmem_post_populate() callbacks. Export it
> so this can be done from vendor specific code. Since kvm_mmu_reload()
> will be needed for this operation, export it as well.

You can just squash this into patch 19; if you don't, s/it/its callee 
kvm_mmu_load()/ in the last line.

Paolo


