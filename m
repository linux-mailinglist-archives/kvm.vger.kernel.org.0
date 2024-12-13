Return-Path: <kvm+bounces-33705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 460CF9F0639
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 09:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02A49285BDD
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A9CD1A8F83;
	Fri, 13 Dec 2024 08:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GXvilEp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF9A1A8F76
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734078014; cv=none; b=PP7zUw48txW5o5tAImF73rINZdVg1kUhk+fyJ5jmKL8Tg1PLZi89q9M1LZB6Y1uEzed1tVq/8bfiMEJMozLscW50yVXOCUatMNJORnP2qeh29Tp6OFp6TEDpoYSFvajMC64qgRxeakBx3Ou2WGojjntCq4gU9QJC2YzhiQ9qDdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734078014; c=relaxed/simple;
	bh=ijr3IzqSxPiN+NYmYp1CosWmmhI03eZXSqAuemj7w1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHn2i/7aKzbGDF5FtCCpvnm0yMxnpb1I1CCoCATzHIoVpWfw2KzTmD9kplqOxH9/Q8B9H/IoU3Dr/svfNjSysUCtErPKFXZTDDV3L5tIHXSdKK1REvOu9F+P1Bpv03e2t6/ZeAw1Fd+m1JP1pYYNC+umVAcoesNWE+eLSFqgsYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GXvilEp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734078011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UV1wwUvDbgVjftsKa9dU87wk1sPiYCmEM4UeAtv1RqI=;
	b=GXvilEp7JoxI9OBm9dTTOnRQEWeFGOwr5iv8dPr0Fsxf4GcvdPnzlGzKAWJ0WFOjtpJIC5
	p1+J3nVyp9n0QCT8mESe9Y4j3hkxNKJQe1pBtOAFbNBbwkMj8lBgPNgYV7pyHY3hNOXWlU
	xAtCeX/aNwmbtpvRDkHDq/wO/p//hRw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-rxZc2CaCN6q8Smqj_Uv-fQ-1; Fri, 13 Dec 2024 03:20:10 -0500
X-MC-Unique: rxZc2CaCN6q8Smqj_Uv-fQ-1
X-Mimecast-MFC-AGG-ID: rxZc2CaCN6q8Smqj_Uv-fQ
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3862be3bfc9so754909f8f.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 00:20:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734078009; x=1734682809;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UV1wwUvDbgVjftsKa9dU87wk1sPiYCmEM4UeAtv1RqI=;
        b=P4Ot50MRQCmqHTPbL0nMuHBZJ+yhaka4A+366wZlLsx+iGdOy/6DkHicdaKpfYfbh1
         llN7CSYiY5Mr0YMpgIrIgYiIUxj5o10bp7BWRurrJ/qESo+0IBdoumkRUInFRbl/nxbz
         ktAKz9tW+dxlMfOOPIrEpuphqo/5egK5SgF/NFT7Z7njP7Syv7cP3z47Nj3Chfgk9f6d
         8n6vDgNfVQNDOfh6bR22G2gdTyR49h6a4/87rE6V73P5+TVzzbuS0hAykBAP8G7kl3Oe
         KztRVScpvd1yhhFtAZGaqTF4vNvo5Vo8wYysTd85qVfvrp8VacL4wcaaoLmiGp50Wdi0
         lXdQ==
X-Gm-Message-State: AOJu0YxxzJqK5QIySwHKQn0e81dXBwV1M17zSW23a4JLQPR8ZR2Qcbx2
	KXlT2EImSvqp0Y4h15vAzZR8XwpGjg7LJG9iEOcb+RWooPHfBOkkHI5cjSuuskS/Qyi+nfEPnOh
	irS2F8QgGoGw+ea9r26djasapCaLIcbH+xGTTltA83tNI3/Z/fA==
X-Gm-Gg: ASbGncvCo6ktwpz4aq8QTbRfg80Gbbie2YDVmcbk5QFIAXaHJUA8WR89T3mU877Q8q8
	JmFMfr1xneTCnIyp/JN1UVQKGkte2tugsrB2Oll84yI/+9OZ16XrCSKPAv7PKj2IyACmcu/WEMO
	AAe9eblYpXbZ3iFVdCncmTzzbIYnsdiNKh8CEOzT8Kds3NOi9U7tDnWKHGwN+8yH4f22ekZur9y
	xWtOmgZZbJL3sah71gEB8VfDa8ZJgmKHfLfDzpMqiCcqrjszCPTb2Q+7tw=
X-Received: by 2002:a05:6000:1a8e:b0:386:32ea:e70d with SMTP id ffacd0b85a97d-3888e0ba2f4mr910632f8f.50.1734078009113;
        Fri, 13 Dec 2024 00:20:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrCHiXBGnM5x0F9+IJDtAVhPlkiWHtx4O9ovcSIL7K/Npye3omEspq5dEzagyGc9xjVrwPFg==
X-Received: by 2002:a05:6000:1a8e:b0:386:32ea:e70d with SMTP id ffacd0b85a97d-3888e0ba2f4mr910591f8f.50.1734078008749;
        Fri, 13 Dec 2024 00:20:08 -0800 (PST)
Received: from [192.168.10.3] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4362559ed8dsm42786805e9.23.2024.12.13.00.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 00:20:08 -0800 (PST)
Message-ID: <79b9abfe-cfb8-4ef0-8a4b-7b87787e6549@redhat.com>
Date: Fri, 13 Dec 2024 09:20:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/5] KVM: drop 32-bit host support on all architectures
To: Arnd Bergmann <arnd@arndb.de>, "A. Wilcox" <AWilcox@wilcox-tech.com>,
 Arnd Bergmann <arnd@kernel.org>
Cc: kvm@vger.kernel.org, Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Huacai Chen <chenhuacai@kernel.org>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Alexander Graf <graf@amazon.com>, Crystal Wood <crwood@redhat.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
 Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
References: <20241212125516.467123-1-arnd@kernel.org>
 <35E5C2A3-94AC-446B-A0A1-84B043DBC890@Wilcox-Tech.com>
 <6e971322-8b21-4d73-922c-a6032c6fe9bd@app.fastmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <6e971322-8b21-4d73-922c-a6032c6fe9bd@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/13/24 09:03, Arnd Bergmann wrote:
> On Fri, Dec 13, 2024, at 04:51, A. Wilcox wrote:
>> On Dec 12, 2024, at 6:55 AM, Arnd Bergmann <arnd@kernel.org> wrote:
>>> From: Arnd Bergmann <arnd@arndb.de>
>>>
>>> I submitted a patch to remove KVM support for x86-32 hosts earlier
>>> this month, but there were still concerns that this might be useful for
>>> testing 32-bit host in general, as that remains supported on three other
>>> architectures. I have gone through those three now and prepared similar
>>> patches, as all of them seem to be equally obsolete.
>>>
>>> Support for 32-bit KVM host on Arm hardware was dropped back in 2020
>>> because of lack of users, despite Cortex-A7/A15/A17 based SoCs being
>>> much more widely deployed than the other virtualization capable 32-bit
>>> CPUs (Intel Core Duo/Silverthorne, PowerPC e300/e500/e600, MIPS P5600)
>>> combined.
>>
>>
>> I do use 32-bit KVM on a Core Duo “Yonah” and a Power Mac G4 (MDD), for
>> purposes of bisecting kernel issues without having to reboot the host
>> machine (when it can be duplicated in a KVM environment).
>>
>> I suppose it would still be possible to run the hosts on 6.12 LTS for
>> some time with newer guests, but it would be unfortunate.
> 
> Would it be an option for you to just test those kernels on 64-bit
> machines? I assume you prefer to do native builds on 32-bit hardware
> because that fits your workflow, but once you get into debugging
> in a virtual machine, the results should generally be the same when
> building and running on a 64-bit host for both x86-32 and ppc32-classic,
> right?

Certainly for x86-32; ppc32 should be able to use PR-state (aka trap and 
emulate) KVM on a 64-bit host but it's a bit more picky.  Another 
possibility for ppc32 is just emulation with QEMU.

Paolo


