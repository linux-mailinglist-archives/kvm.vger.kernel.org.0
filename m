Return-Path: <kvm+bounces-34148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66DBE9F7BE3
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:55:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DACE1885800
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA3E224AF9;
	Thu, 19 Dec 2024 12:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYn2d2Hx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EAD22489E
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734612943; cv=none; b=V86oGXdGubkUQnWV+SCt4gcjuthkUMcZZmHx6ll3N6DVtABmZuCEABRDPnFpE5bUk+SzoQRN2WE9ZiFPOh3Pq9DXFfVVSpjvbu683N4j2WeeWnjy5RMIic3Nfa6mnmotUuBjSNnJAkIVGaP6OIooJucgRMNgqCcRg4PQ5IO9ILs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734612943; c=relaxed/simple;
	bh=QhCHpPyb3uhnTDm/WChIo33wsmigwgbGffkBhpgmq0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hgLyYY4nz87I7Gn1u7dVQlr91JBraaqGBEv84Yf06lL8oBJQqv3BgdEyAUMn9jgLT265c1dviPUXJ1A0rviLuRvoQUK9HpsEsfDHiqBpXXw5J4x2ZwUxz9A+zxWi3mRfLqiaVY8rFYW10scKZ0Dcqvb8YbIW6xSQlv0IJPn81EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYn2d2Hx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734612940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LGXcfJEjO2CoXYzs4sq8iUfZat5O4l5AD0nF/8ET8rs=;
	b=FYn2d2HxYWeTW6Mk26d8RYElP6N6+rrinMd/t8ITIXTsfTOyGpXHpixDTPFbFHMdDFptNd
	OaepxgSW7XG8iUN8eYHWSRuY+bBrVCm3b+0RH9x1X9wKsa972XlhSCaOBFD1mvN+8MxpQY
	nIRP0mVg+TvvrJs9A8Ium5o3sVUmKVo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-63-pho0-V1TO3iHkaDG6zv4vw-1; Thu, 19 Dec 2024 07:55:39 -0500
X-MC-Unique: pho0-V1TO3iHkaDG6zv4vw-1
X-Mimecast-MFC-AGG-ID: pho0-V1TO3iHkaDG6zv4vw
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so4661385e9.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 04:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734612938; x=1735217738;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LGXcfJEjO2CoXYzs4sq8iUfZat5O4l5AD0nF/8ET8rs=;
        b=ChMtNdN3aXusXnERjE/zSNm3RuOB+CSx2W33KTkBiFAY+s1COTKfq6fBSxq60jlfWs
         j8KeyMJLJ3+ZZIrmnfZv9eFuKp/u0vs5SdJ/JFUAOi4rY9UsJaX+kcNJGQqNG3st4yhz
         MnYkDu69m8tdOlgfcGhOXShvmmkgY3DZ/yftlCH7FfvoMdjallK98TxGY5IM+QkcXNtX
         MLGhuo1TM4XJZNglKJrGg3F0ycIzIECMevkkW7nqv6GKPH0xpmEti/8qJzKew27doRuB
         IcAV0aDRruliti2Io0A3xn0ELyT2CabbPuT1OscU7N7SihF777rl5FSZ+8fwgnGtL7Id
         aHAA==
X-Gm-Message-State: AOJu0YwFAPB8mebWLNfBcdpaMfqlmiJ7BYq4GdrvvPlnbmi2ST+cpweA
	JtV4aai5HGTxLTqWs9ikYntW3JkA/vf0QeOqo/t2Z9CPabUc+bGPYxmAMXCrEJANSE3Pn7gmi/q
	InW7kpF+6ss9T2ChsAs1IGuiNo5RquvA0p8HD0QF3RHXHWzOKrg==
X-Gm-Gg: ASbGncuHn7qaSQO/KLNOCQNrsgkdq29FGIKXRIh7fSnGj9tRW0jwIbVdXoXsAN6g4tO
	O+UveZsmFXOQnZIJb3p/6jvl/YZxr38O0HU232agHloRrVt4JBPlptV1uvME7P0DOd0ZDol4r6u
	GW8zSTuFHEKp4QNzSZ02XRxnY9mqMWuFGL5HrPjHVNm7G5MqYEghTrJGEGeoxKM00qC4fUleaW7
	akF7DZPr4IxWJqDSj9n65ANKjILU5NwXmdZLdEamuKnZyPnq6+HH1izErGY
X-Received: by 2002:a5d:5c0c:0:b0:385:f38e:c0d3 with SMTP id ffacd0b85a97d-38a19b56d13mr2413804f8f.58.1734612937919;
        Thu, 19 Dec 2024 04:55:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE9Y+Dnk96cdAXS6U3t+zS4nLJrTpLDOlkmJpVPR5zTQ6oQ9kPmfgUFcE20hOS9eBN0E+banw==
X-Received: by 2002:a5d:5c0c:0:b0:385:f38e:c0d3 with SMTP id ffacd0b85a97d-38a19b56d13mr2413788f8f.58.1734612937543;
        Thu, 19 Dec 2024 04:55:37 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c829015sm1511678f8f.13.2024.12.19.04.55.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 04:55:36 -0800 (PST)
Message-ID: <93e571e9-5539-454f-9335-6de8339ffd8b@redhat.com>
Date: Thu, 19 Dec 2024 13:55:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/20] KVM: selftests: Collect *all* dirty entries in each
 dirty_log_test iteration
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Xu <peterx@redhat.com>
References: <20241214010721.2356923-1-seanjc@google.com>
 <20241214010721.2356923-15-seanjc@google.com>
 <fb179759bdc224431f6b031eaa9747c1897d296b.camel@redhat.com>
 <Z2OBYYQq6cwptSws@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z2OBYYQq6cwptSws@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 03:13, Sean Christopherson wrote:
> On Tue, Dec 17, 2024, Maxim Levitsky wrote:
>> While this patch might improve coverage for this particular case,
>> I think that this patch will make the test to be much more deterministic,
> 
> The verification will be more deterministic, but the actual testcase itself is
> just as random as it was before.

Based on my recollection of designing this thing with Peter, I can 
"confirm" that there was no particular intention of making the 
verification more random.

>> and thus have less chance of catching various races in the kernel that can happen.
>>
>> In fact in my option I prefer moving this test in other direction by
>> verifying dirty ring while the *vCPU runs* as well, in other words, not
>> stopping the vCPU at all unless its dirty ring is full.
> 
> But letting the vCPU-under-test keep changing the memory while it's being validated
> would add significant complexity, without any benefit insofar as I can see.  As
> evidenced by the bug the current approach can't detect, heavily stressing the
> system is meaningless if it's impossible to separate the signal from the noise.

Yes, I agree.

Paolo


