Return-Path: <kvm+bounces-26237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1297D973635
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:28:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 833881F24F7F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC53A18EFD4;
	Tue, 10 Sep 2024 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOW3a0+S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0541552FD
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725967713; cv=none; b=Mgwmfb7Fml+A76ZD21Yiim+Z5gnQQs0bRP+g9EjMpLS1pHmx94LsHu8AZmQpBcDmcYtVShSCvo1JNtvIc/zIQBnpebx1gupZRWMiNTmslKX2bXmDZtVYVCwDSSBUfZNjw+bChkHTudM7wu+LwefW0QzR7WESUhx084ygjkT2log=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725967713; c=relaxed/simple;
	bh=ihzr/dKTEiOvtdAx59gGXhJ6LK4K8/vxDFMP9iJmL7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzBne4iT8zpIGrSsPWyGYk7hugqA8+uE8GDI3nQGccv170z7uJicTldeRTngNj50SAHaXMir2jWdAcY5YZX81kokemSrDPO0sVf+Hp2NsnUUrFZ6CvVDKWWZvdDtB77xhzsTeMHfaXefSAbO7rSwp7S9QyU/K6T0GCB5If8gKsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EOW3a0+S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725967710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LhDj/wdgiKUWj65H3XSt3JjbWG0dFV5DRvQZaBbQCLs=;
	b=EOW3a0+S6UkCBcpUZhLdw/Em//iOI3Xip/DM0EFgQBDYr2CP5ytdexYjvX8PXqZHtBWDoI
	NnT0dIbZxjPCVRn6Hfy93L9oDwjaTcrprLjB6kVIW4FE1en2z4NI+F/D+hQcfoFsMMQ/mf
	kVH36CvO2FnzrEmB47jcEZeyuqPC0mk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-hBtbhcEGOISLr0eScBoGmw-1; Tue, 10 Sep 2024 07:28:29 -0400
X-MC-Unique: hBtbhcEGOISLr0eScBoGmw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374bb2f100fso2425156f8f.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 04:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725967708; x=1726572508;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhDj/wdgiKUWj65H3XSt3JjbWG0dFV5DRvQZaBbQCLs=;
        b=V/NujzydA257+LabW0EPswu9HTAJjciBTwD5PPuxvdfxTybSg9C05ayoTlzi+6pc2S
         nZO5fekruq8HadTEd0EPwI++LB8qOxUiL6KL2J+vxDdrXRia+MzBVbKYQzQemzaFDNOL
         7OTyyUtpw7TmeAxBH0AvL0InvwsdAyfvo/pcEtAcHwe4SHdY6OxlxjCkjlFIOVIzKKR8
         uqTyO1RS8vHec7UOfZar/F/4X7mN+5zA7594XTayc618nFkV66vZfjrvgq9Ue1Tkumig
         tYtIXXc03AFMSbbAvbwbWE75RnRGrhblTc2Hf5W3+VDJtwbdRoslbMFKj7S+VU0MIp3E
         Y9MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFPa40Xmz9DQZe8q5WMNWzyLezEsKxW/eQcPpihSjMbTYT1mQlLd7SNDppcutIl+R9hIo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRi/gYZRH5eNN7xDF+nWS9Z04+GIrnWcjau1FVEzzIybwggFC/
	QJ1P35XI73A2bBYlVdqPKGt/x6PQ4TTq1zJaL+gFw1oyPevS5u4sM69y/46Ow0t/H9aTuSdgyGX
	IY5J8fcUMNUkPBf3qKg5+2fDtsm27/gOs6ZoO2YlsLPArO+IakA==
X-Received: by 2002:adf:fe8e:0:b0:374:c69b:5a21 with SMTP id ffacd0b85a97d-378896740f7mr8495353f8f.36.1725967708201;
        Tue, 10 Sep 2024 04:28:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHg9aCVV6p1CXARyE/cPWyf3M5L43KSho1SDHGBxh/KZUcXjudwEXYRFBahqmbRNO4nwx2qyg==
X-Received: by 2002:adf:fe8e:0:b0:374:c69b:5a21 with SMTP id ffacd0b85a97d-378896740f7mr8495337f8f.36.1725967707684;
        Tue, 10 Sep 2024 04:28:27 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956d374fsm8652380f8f.86.2024.09.10.04.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 04:28:27 -0700 (PDT)
Message-ID: <0c256e7d-e453-44ce-bb78-d1926b98376e@redhat.com>
Date: Tue, 10 Sep 2024 13:28:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Adrian Hunter <adrian.hunter@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
 <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
 <5b2fa2b3-ca77-4d6e-a474-75c196b8fefc@redhat.com>
 <e58349f3-fa36-4635-9b2b-9ff8f2d88038@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <e58349f3-fa36-4635-9b2b-9ff8f2d88038@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 13:15, Adrian Hunter wrote:
>> kvm->slots_lock is better.  In tdx_vcpu_init_mem_region() you can
>> take it before the is_td_finalized() so that there is a lock that
>> is clearly protecting kvm_tdx->finalized between the two.  (I also
>> suggest switching to guard() in tdx_vcpu_init_mem_region()).
>
> Doesn't KVM_PRE_FAULT_MEMORY also need to be protected?

KVM_PRE_FAULT_MEMORY is forbidden until kvm->arch.pre_fault_allowed is set.

Paolo


