Return-Path: <kvm+bounces-17152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E4A38C1F6B
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 10:06:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6A7E1F21A36
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 08:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC2515F3FA;
	Fri, 10 May 2024 08:06:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from isrv.corpit.ru (isrv.corpit.ru [86.62.121.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116F615F330
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 08:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=86.62.121.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328380; cv=none; b=hMrZUyq+QWn2mVrDRkN7cdnvmemx9xFfiB3DcIXqQ8k9SHbwHjqmnQmSGagj7jfX81sOlS0bJrPiMQxW0lazFkqfywINWl4I2+5L9vOUPiWA2mGtzILY+HipYz4Bd8mvaVzIgKLSNmQnzXRoXuepsR2D30pUtmlt1cM4nW12UaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328380; c=relaxed/simple;
	bh=5Ztp4ESkKZBT/IKxdY48ZSIxD0yVp5vbz79weNHIq9w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iPJUVOM8UkEg5XXF3o0gkKVhKMLVBLzjaTgUM6r7S8w0I2GW841vQLXTQvlC3F9WMdQHOG9XLjI7Mmz5I5Mg+n6fE+9IV+fH4ILdxhuYtg24i5UsxmBTav1Ug6/jNYTTsTtiihNwneTPRVHfgDywzWV6i5itzPiABPbbyXCr3zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tls.msk.ru; spf=pass smtp.mailfrom=tls.msk.ru; arc=none smtp.client-ip=86.62.121.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tls.msk.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tls.msk.ru
Received: from tsrv.corpit.ru (tsrv.tls.msk.ru [192.168.177.2])
	by isrv.corpit.ru (Postfix) with ESMTP id 2A92365A6A;
	Fri, 10 May 2024 11:05:46 +0300 (MSK)
Received: from [192.168.177.130] (mjt.wg.tls.msk.ru [192.168.177.130])
	by tsrv.corpit.ru (Postfix) with ESMTP id 73568CB7F0;
	Fri, 10 May 2024 11:05:44 +0300 (MSK)
Message-ID: <efb17c5f-11f0-498d-b59d-e0dfab93b56d@tls.msk.ru>
Date: Fri, 10 May 2024 11:05:44 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] target/i386: Fix CPUID encoding of Fn8000001E_ECX
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>, pbonzini@redhat.com,
 richard.henderson@linaro.org, weijiang.yang@intel.com, philmd@linaro.org,
 dwmw@amazon.co.uk, paul@xen.org, joao.m.martins@oracle.com,
 qemu-devel@nongnu.org, mtosatti@redhat.com, kvm@vger.kernel.org,
 mst@redhat.com, marcel.apfelbaum@gmail.com, yang.zhong@intel.com,
 jing2.liu@intel.com, vkuznets@redhat.com, michael.roth@amd.com,
 wei.huang2@amd.com, bdas@redhat.com, eduardo@habkost.net,
 qemu-stable <qemu-stable@nongnu.org>
References: <20240102231738.46553-1-babu.moger@amd.com>
 <0ee4b0a8293188a53970a2b0e4f4ef713425055e.1714757834.git.babu.moger@amd.com>
 <89911cf2-7048-4571-a39a-8fa44d7efcda@tls.msk.ru>
 <ZjzZgmt-UMFsGjvZ@redhat.com>
Content-Language: en-US
From: Michael Tokarev <mjt@tls.msk.ru>
Autocrypt: addr=mjt@tls.msk.ru; keydata=
 xsBLBETIiwkBCADh3cFB56BQYPjtMZCfK6PSLR8lw8EB20rsrPeJtd91IoNZlnCjSoxd9Th1
 bLUR8YlpRJ2rjc6O1Bc04VghqUOHgS/tYt8vLjcGWixzdhSLJgPDK3QQZPAvBjMbCt1B6euC
 WuD87Pv5Udlpnzf4aMwxkgfTusx+ynae/o+T5r7tXD+isccbC3SiGhmAPxFyY3zGcFk4+Rxc
 0tP8YY2FWE/baHu+lBDTUN79efWAkHhex1XzVZsV7ZD16rzDbXFK5m6ApvGJWlr5YDEEydTF
 WwmvwBfr4OINVxzEG/ujNiG4fpMf2NsnFGyB9aSbFjXZevB4qWkduYYW+xpK1EryszHtAAYp
 zSBNaWNoYWVsIFRva2FyZXYgPG1qdEB0bHMubXNrLnJ1PsLAlgQTAQoAQAIbAwYLCQgHAwIE
 FQIIAwQWAgMBAh4BAheAAhkBFiEEbuGV0Yhuj/uBDUMkRXzgoIBEZcUFAmBbcjwFCS5e6jMA
 CgkQRXzgoIBEZcUTIQgA1hPsOF82pXxbcJXBMc4zB9OQu4AlnZvERoGyw7I2222QzaN3RFuj
 Fia//mapXzpIQNF08l/AA6cx+CKPeGnXwyZfF9fLa4RfifmdNKME8C00XlqnoJDZBGzq8yMy
 LAKDxl9OQWFcDwDxV+irg5U3fbtNVhvV0kLbS2TyQ0aU5w60ERS2NcyDWplOo7AOzZWChcA4
 UFf78oVdZdCW8YDtU0uQFhA9moNnrePy1HSFqduxnlFHEI+fDj/TiOm2ci48b8SBBJOIJFjl
 SBgH8+SfT9ZqkzhN9vh3YJ49831NwASVm0x1rDHcIwWD32VFZViZ3NjehogRNH9br0PSUYOC
 3s7ATQRX2BjLAQgAnak3m0imYOkv2tO/olULFa686tlwuvl5kL0NWCdGQeXv2uMxy36szcrh
 K1uYhpiQv4r2qNd8BJtYlnYIK16N8GBdkplaDIHcBMbU4t+6bQzEIJIaWoq1hzakmHHngE2a
 pNMnUf/01GFvCRPlv3imkujE/5ILbagjtdyJaHF0wGOSlTnNT4W8j+zPJ/XK0I5EVQwtbmoc
 GY62LKxxz2pID6sPZV4zQVY4JdUQaFvOz1emnBxakkt0cq3Qnnqso1tjiy7vyH9CAwPR/48W
 fpK6dew4Fk+STYtBeixOTfSUS8qRS/wfpUeNa5RnEdTtFQ9IcjpQ/nPrvJJsu9FqwlpjMwAR
 AQABwsBlBBgBCAAPBQJX2BjLAhsMBQkSzAMAAAoJEEV84KCARGXFUKcH/jqKETECkbyPktdP
 cWVqw2ZIsmGxMkIdnZTbPwhORseGXMHadQODayhU9GWfCDdSPkWDWzMamD+qStfl9MhlVT60
 HTbo6wu1W/ogUS70qQPTY9IfsvAj6f8TlSlK0eLMa3s2UxL2oe5FkNs2CnVeRlr4Yqvp/ZQV
 6LXtew4GPRrmplUT/Cre9QIUqR4pxYCQaMoOXQQw3Y0csBwoDYUQujn3slbDJRIweHoppBzT
 rM6ZG5ldWQN3n3d71pVuv80guylX8+TSB8Mvkqwb5I36/NAFKl0CbGbTuQli7SmNiTAKilXc
 Y5Uh9PIrmixt0JrmGVRzke6+11mTjVlio/J5dCM=
In-Reply-To: <ZjzZgmt-UMFsGjvZ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

09.05.2024 17:11, Daniel P. Berrangé wrote:
> On Thu, May 09, 2024 at 04:54:16PM +0300, Michael Tokarev wrote:
>> 03.05.2024 20:46, Babu Moger wrote:

>>> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>>> index 08c7de416f..46235466d7 100644
>>> --- a/hw/i386/pc.c
>>> +++ b/hw/i386/pc.c
>>> @@ -81,6 +81,7 @@
>>>    GlobalProperty pc_compat_9_0[] = {
>>>        { TYPE_X86_CPU, "guest-phys-bits", "0" },
>>>        { "sev-guest", "legacy-vm-type", "true" },
>>> +    { TYPE_X86_CPU, "legacy-multi-node", "on" },
>>>    };
>>
>> Should this legacy-multi-node property be added to previous
>> machine types when applying to stable?  How about stable-8.2
>> and stable-7.2?
> 
> machine types are considered to express a fixed guest ABI
> once part of a QEMU release. Given that we should not be
> changing existing machine types in stable branches.

Yes, I understand this, and this is exactly why I asked.
The change in question has been Cc'ed to stable.  And I'm
trying to understand what should I do with it :)

> In theory we could create new "bug fix" machine types in stable
> branches. To support live migration, we would then need to also
> add those same stable branch "bug fix" machine type versions in
> all future QEMU versions. This is generally not worth the hassle
> of exploding the number of machine types.
> 
> If you backport the patch, minus the machine type, then users
> can still get the fix but they'll need to manually set the
> property to enable it.

I don't think this makes big sense.  But maybe for someone who
actually hits this issue such backport will let to fix it.
Hence, again, I'm asking if it really a good idea to pick this
up for stable (any version of, - currently there are 2 active
series, 7.2, 8.2 and 9.0).

Also, the parameter has to be compatible with 9.1+ (maybe having
different default).

Thanks,

/mjt

-- 
GPG Key transition (from rsa2048 to rsa4096) since 2024-04-24.
New key: rsa4096/61AD3D98ECDF2C8E  9D8B E14E 3F2A 9DD7 9199  28F1 61AD 3D98 ECDF 2C8E
Old key: rsa2048/457CE0A0804465C5  6EE1 95D1 886E 8FFB 810D  4324 457C E0A0 8044 65C5
Transition statement: http://www.corpit.ru/mjt/gpg-transition-2024.txt


