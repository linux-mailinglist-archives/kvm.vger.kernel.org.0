Return-Path: <kvm+bounces-17643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF4A8C8A29
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:35:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 513B31C20BC6
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A6713D88B;
	Fri, 17 May 2024 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="enKxB7t3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9157C13D625
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 16:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715963709; cv=none; b=lWCbPZ8+mYJPhH1QG2sANQBQruIUhIsyTNwo6W3hwzwbCd3wj0F+vPMp1mvEIBYwYrFPqmXjqhJdDp0vjBBhH6WpiLYQR4dIVF6Jfmoz9e8Coyfi9JTWRtlZx45EAq4IoHh88fX1zqaf4uUOKq+TCbLsxiN7G1SaOnpUinAHRRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715963709; c=relaxed/simple;
	bh=CK3agC6rs1w1n4s2ZLnkcwXvTNbsYeUjeOXNrgffLqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K1yFXQK8J0t2l9VG4iTXWWz1wm3ojMvHT0M05QzRmNdLAASb/j0d1ycLVa/U3EKR/U4+/T351cvZlkJUq6Zib0ryf8k8qAM7t+Ksti/zt/nf1b4eI4Z+oxWopjJH3EgZTCLmGHkmrDn94YK0ArRcxArh2SG5kwP+wTwCy2ZyLwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=enKxB7t3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715963706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QGr87EvmQ2eY+XvddpcpgzToCcCzn2nyVCX2F0KXF14=;
	b=enKxB7t3d11FK/qQziXtkNudSylrw7XMXyb1JP6iF8ODC0bob5m487mzVPhrJgWSllbx2L
	j3J4axKjNS9gCRU27uzeS6uky4n2iu6GmEp1ML23EcJA1kJ8kXI98f8rH6yPyNoxQWGsU0
	spNQihjpJVCNhLPBWUclavKMqTcEnQY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-8EJ4EvLuMfW3srJIgqCd9g-1; Fri, 17 May 2024 12:35:04 -0400
X-MC-Unique: 8EJ4EvLuMfW3srJIgqCd9g-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a599dbd2b6aso554493666b.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 09:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715963703; x=1716568503;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QGr87EvmQ2eY+XvddpcpgzToCcCzn2nyVCX2F0KXF14=;
        b=KRmmZ2qIFyU04/v54HeTBT2J23lVvjbI718LN94oEScnAepTItvi6fOpkWG1vCww5v
         Vo+ws/heRuKScHVxcjBOfeVUptg6N2kpfcXeeob5LtCAH5lAPz2tezUhgFLSLljGLhi1
         MVH/2OlcTX8Zp+Viwy0hXAuOHyLeAs9GXBUgvUhE5idMqrw8V2fQNz78EKN+lJilJ0PT
         95o640vvjRTGdrSZhHIaeqco0NK/fpG17w9ZiTv1doRIgCquFf4mRN50rM+dRDxTU23p
         k4Ru68wkWUyuU9lS1f8nQIp46d6boQwc+6kFoDYpah8boGEcu1j/+1nK2K4AxkFAAKj2
         zz5w==
X-Forwarded-Encrypted: i=1; AJvYcCV0RuGC+Nee0ZJT83YBmcpNNNpnwvW+Gcm/gB9W6q1nuRpb5ucZLXM1GJFb8zO3sqQl8dSKLs7V0QkbvEx7CcBGqgEQ
X-Gm-Message-State: AOJu0YzlOcmpj6uE4RaJICNPEByYk1pZ52NijJlw7TyWW1dhbAPOOQNb
	u5wAN1wO8VZlwszGTyQXikMz+0YhpUY0hHj0kIv+G8SV2qpVofrAwKrRpIolGrQaecwV/0MhRBU
	LgmiCitark+694y4aBXZdOQniajga3RyDkfFcgZWoGxkqAJxHoqzHdXfljQ==
X-Received: by 2002:a17:907:980d:b0:a5a:5496:3c76 with SMTP id a640c23a62f3a-a5a54963cdfmr1603515866b.6.1715963703318;
        Fri, 17 May 2024 09:35:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9fQoyN0idlh9uq3pfbOZ9nmynTDs7dwbBmWRUMQwcC4oM5DuTa2SzGGKVAGbmlO4chOSG3w==
X-Received: by 2002:a17:907:980d:b0:a5a:5496:3c76 with SMTP id a640c23a62f3a-a5a54963cdfmr1603514366b.6.1715963702934;
        Fri, 17 May 2024 09:35:02 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.155.52])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a5a1781ce5dsm1123813666b.42.2024.05.17.09.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 09:35:02 -0700 (PDT)
Message-ID: <7c0bbec7-fa5c-4f55-9c08-ca0e94e68f7c@redhat.com>
Date: Fri, 17 May 2024 18:35:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] KVM: VMX: Introduce test mode related to EPT
 violation VE
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240507154459.3950778-1-pbonzini@redhat.com>
 <20240507154459.3950778-8-pbonzini@redhat.com> <ZkVHh49Hn8gB3_9o@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZkVHh49Hn8gB3_9o@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/24 01:38, Sean Christopherson wrote:
> On Tue, May 07, 2024, Paolo Bonzini wrote:
>> @@ -5200,6 +5215,9 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>   	if (is_invalid_opcode(intr_info))
>>   		return handle_ud(vcpu);
>>   
>> +	if (KVM_BUG_ON(is_ve_fault(intr_info), vcpu->kvm))
>> +		return -EIO;
> 
> I've hit this three times now when running KVM-Unit-Tests (I'm pretty sure it's
> the EPT test, unsurprisingly).  And unless I screwed up my testing, I verified it
> still fires with Isaku's fix[*], though I'm suddenly having problems repro'ing.
> 
> I'll update tomorrow as to whether I botched my testing of Isaku's fix, or if
> there's another bug lurking.
> 
> https://lore.kernel.org/all/20240515173209.GD168153@ls.amr.corp.intel.com

I cannot reproduce it on a Skylake (Xeon Gold 5120), with or without 
Isaku's fix, with either ./runtests.sh or your reproducer line.

However I can reproduce it only if eptad=0 and with the following line:

./x86/run x86/vmx.flat -smp 1 -cpu max,host-phys-bits,+vmx -m 2560 \
   -append 'ept_access_test_not_present ept_access_test_read_only'



Paolo


