Return-Path: <kvm+bounces-47114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30E19ABD665
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 13:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAB0C3BD052
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98D0280014;
	Tue, 20 May 2025 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ci9lI90Q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4888525CC6C
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739377; cv=none; b=Js9i82c6kWBEGKtHXV57fkmcmtUNA88Wb19KiGdDNl86K277YmI5IuWW5E1zJu8F9gO7GFRlCrC3OAcSxHGNokBkzwA4nmnMxs5QEgh3tr/QHr8mmPpPCeY0ZTX62jZAOPT7NyvcL5hNX6Sny/QE9R0fHy49eFNF0UWBwfFJl6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739377; c=relaxed/simple;
	bh=DyjGjmIKPnH7C36i8ffActQ/GQ9mwbRyIId9YRlceUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A87kpkqSy3UHy0ESAILfhoWUffJaUeVxh4SYwSB8p3i34NiLkE39jRL39pAOMXojZNLGbE+jwX1P7mY9PlnjcjR3YHpPS8K32bwb3IwDaVDfP/4Jon80AycIKVDqUfrocr3uGQVeqMYd0/+sptz/YMh5E7sSLqQN1NSSbvYRtd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ci9lI90Q; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747739375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DARJsHp4jsWx/AeNTG3Ix546yRHwSXlPjjzPU2VmlJs=;
	b=Ci9lI90Q/Ipw+QV5q/UHNUjUdyZ63h9d4OTetPze+pGp8Q9DG02o9T5PxI0CMxjING73kU
	SJcks9931b+MY5aGx+ykw0hCIV0/+19lF6o0l6JgYVBSr6dhKzMufG9LJr5EzcpWY5Zoik
	Q9RrMRTGE2Z1WCZExzx2hkXnq1iIY+o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-GH38zINCMRGo7GzrhJh2YA-1; Tue, 20 May 2025 07:09:32 -0400
X-MC-Unique: GH38zINCMRGo7GzrhJh2YA-1
X-Mimecast-MFC-AGG-ID: GH38zINCMRGo7GzrhJh2YA_1747739371
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ac6ef2d1b7dso429268566b.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 04:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747739371; x=1748344171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DARJsHp4jsWx/AeNTG3Ix546yRHwSXlPjjzPU2VmlJs=;
        b=WgM4ZEIiLLvCO8aX3jygEZKFx9zTFg1z5g4+6B3jtQkVQP51FEHDNC6Qh6VB4v1dQz
         XpXml/j+UzhiuDNy359jCN617mRU3ATSQCC6GFj3XVks0/NGiHsdl+9ht9lLGFKHTilB
         qVkrPS2ryZ2XplnBDXt/CmTF/OAKn0WS2zsURm2ozkLZwhcrm6QRQAHvrbNzr2AE+rjW
         M10kMpQIRHG/Hddosb82gw31pESw/o+vWsQg9kzfgv5gqtF5AmXjdl/otCPRLYyNYclU
         v0WZJWd2kNgRyIa1ZCKbHmKmHONtgktyrYI3E+P5MFQylu+oZEpjI1mcYuskzZ1UcK27
         +eaA==
X-Forwarded-Encrypted: i=1; AJvYcCUZmEmz5AglZa7Rg6Q+dv/GC2fhb9rSsRfNN6xgsWMRLnQzgz7++DscCAxshnPOFyIJUsM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6Fr6Ld86x8Ttbd/5VEZ28Q6FdYaZyS446u/+o8tmTGdvjNpAA
	amZ6GqP1fZHsHpXh2ck6fKN/KkAi78ovvdsDliVsSrSVlp+CHU+DP9l4P9gH5sFDnfFeAbSRCk9
	TsoFeOdhJGa+WiPOxHH6OPE67lYxq8mjv7iyBatQbjLpuOyKttLfoow==
X-Gm-Gg: ASbGncsiS5LhCW4Tvc2227UojGCraF6uv5F1c+Xh/wpP39DOH0bfDnGAl+Xl0chrDrC
	4+BALXPaoGsdyUYWgIPRqSglP6RF5qXOiWesRWz71UqUIjrL/JLKZzDF6YKvQuEQC29iN0XOy/V
	wRKggLegxPz9QADi6ltmjkBSfzjBkEvFyag1U7SrJ/4DKwpCwftihjTzuC0bXa9gVP4fe7DRpyH
	OPXmR2jhc//k8KjkyseGtVqTHHRfdsy92upqNJK4iwe/FrqZ/n1s3VBLM5crdAVG2r4tlVGTnZR
	XvTiFNPYg995fc1l+brNl10273m5kJbOgeI1Tl1/K6205LO/Y/AYXXpVL/np
X-Received: by 2002:a17:907:d26:b0:ad5:715b:d1d4 with SMTP id a640c23a62f3a-ad5715bd3b3mr675885166b.32.1747739371267;
        Tue, 20 May 2025 04:09:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVmZPA0gP+lVwuu4tl/IU00u142/ZIBl7HKt5LlJNVBoXEwIpfvNF2MTZxVOWT8Ao84FYsRQ==
X-Received: by 2002:a17:907:d26:b0:ad5:715b:d1d4 with SMTP id a640c23a62f3a-ad5715bd3b3mr675881166b.32.1747739370698;
        Tue, 20 May 2025 04:09:30 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d271916sm722395766b.69.2025.05.20.04.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 04:09:30 -0700 (PDT)
Date: Tue, 20 May 2025 13:09:25 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v7] selftests/vsock: add initial vmtest.sh for
 vsock
Message-ID: <w6aizeb2i5m52e2ifqcikgwdbrkkbc46sf4hx5b6jsm7o4drio@n3dzlatb426s>
References: <20250515-vsock-vmtest-v7-1-ba6fa86d6c2c@gmail.com>
 <f7dpfvsdupcf4iucmmit2xzgwk53ial6mcl445uxocizw6iow5@rhmh6m2qd3zu>
 <73a4740e-755e-4ba8-8130-df09bd25197a@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <73a4740e-755e-4ba8-8130-df09bd25197a@redhat.com>

On Tue, May 20, 2025 at 12:58:18PM +0200, Paolo Abeni wrote:
>On 5/20/25 10:24 AM, Stefano Garzarella wrote:
>> On Thu, May 15, 2025 at 03:00:48PM -0700, Bobby Eshleman wrote:
>>> This commit introduces a new vmtest.sh runner for vsock.
>>>
>>> It uses virtme-ng/qemu to run tests in a VM. The tests validate G2H,
>>> H2G, and loopback. The testing tools from tools/testing/vsock/ are
>>> reused. Currently, only vsock_test is used.
>>>
>>> VMCI and hyperv support is automatically built, though not used.
>>>
>>> Only tested on x86.
>>>
>>> To run:
>>>
>>>  $ make -C tools/testing/selftests TARGETS=vsock
>>>  $ tools/testing/selftests/vsock/vmtest.sh
>>
>> I am a little confused, now we have removed the kernel build step, so
>> how should I test this? (It's running my fedora kernel, but then ssh
>> fails to connect)
>>
>> Would it be better to re-introduce the build phase at least in the
>> script as optional (not used by selftest, but usable if you want to use
>> the script directly)?
>>
>> Or at least I think we should explain that the script launches the
>> running kernel, because the config file introduced by this patch
>> confused me. How it's supposed to be used?
>
>This is the usual selftests schema. The user has to build and install
>the kernel including the specified config before running the tests, see
>
>make help |grep kselftest
>
>Also this is what we do for our CI:
>
>https://github.com/linux-netdev/nipa/wiki/How-to-run-netdev-selftests-CI-style

Thanks for the link!

>
>@Bobby: AFAICS this now has all the ingredients to fit NIPA integration
>am I correct? the last commit message sentence could possibly be dropped.
>
>Still it could be worthy to re-introduce (behind a command line option)
>the ability to build the kernel as per Stefano request, to fit his
>existing workflow (sorry for the partial back and forth).

If that's possible, I'd appreciate it (not a strong opinion). Otherwise 
if we don't, I'd say take the use of the direct script out of the commit 
messaging, because to me it's confusing if we don't plan to use it 
without the selftest infrastructure.

Thanks,
Stefano


