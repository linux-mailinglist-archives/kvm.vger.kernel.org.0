Return-Path: <kvm+bounces-33209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05C989E6D5C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 12:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F7942824A7
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 11:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF4E1FF7D4;
	Fri,  6 Dec 2024 11:25:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mailfilter02-out21.webhostingserver.nl (mailfilter02-out21.webhostingserver.nl [141.138.168.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE1D1FA25E
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 11:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=141.138.168.70
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733484300; cv=pass; b=fA4qNNaJxyM0eKcpqHXkYhwL+4pyM1zoCRsm0Rt+0n5KAz5Pe/xmsb9jhFJM4WXj+dXooJkbsWQJfyJPoHaDFQ16YcM08GCzxPx090gDq6nDUKZZqGcLOL8wO0YTUQBG0UFD4igH2FYQFMOw/AtfhDmd/QqoC0Hs4YvUuDcL1NA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733484300; c=relaxed/simple;
	bh=MET7W4WnLCq6005qUbj5NtKGeohPo7kN/cQMFHdSAO0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rxT3UeDjfWZApoc8Bc1nmelD+0P0fZYLqYVhdg02yAZ5zqzc67k6MRGKVPiaBXfhmJoR0/44fBwyd9HKDbZtLQLKzPLAqDVUaYANp4Pu2BIPg4fLfmXjMfC2NAMvtH5Ee9vX5xQRjRTtfY4pTAAhbPJn7LdW9hMkdOxfaajrUow=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=pass smtp.client-ip=141.138.168.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
ARC-Seal: i=2; a=rsa-sha256; t=1733484229; cv=pass;
	d=webhostingserver.nl; s=whs1;
	b=HQuGC/6Igw9VWqt++HV/KbXcWkPA9OPDpHAwnCD5s5iHn2HTtI65UcoB2cQGMKm1+9odkcSPqJGxd
	 0bqBqRJDKu//a7GHLbCFGTgkQ3KwmeHOMitA4rB3E1HuPb8gzAX4qKednv37tsicChl9/ZDKpHsnxq
	 DI8PHCp3VZCWM8TKBF/vAhG2Vf72OUowmWOisKOsor1ULKxpTbV3b3RuqA/Aps7ZO3zR6YbuNf7mu2
	 /Bqn3YXf+ktpN16NafQtXbUvF2eroFdWi7+JvfJtjCN6LCa4PP1IAEWQNvD7KO+xMZBT3YUFbyZGyH
	 Qjctt4PcFl4p0HYrCj7xSBYO1goPyqw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed;
	d=webhostingserver.nl; s=whs1;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=YtSPVooxyun9+mTGfKS72AWGootShF+nag7v1xcX57s=;
	b=US60wxwiFvtUpqmlUFZfpH8gn+2bEW6u4BrfO3ytxOo3iHKL8hdrK+soCOCtCialhFBdJYTx9W6ui
	 7C46xiPWmyKbw3dufd9nfXsQS+i48Qqem4pjRF/Kc3prEskhVLUw9N4FPn+QcDWTmoL+43fOa/8tzH
	 Q6Cei4apCmUDCRW2qfE6eZjWbixaY1VoWO3m2+eJQk1vP2aKdiFFq2xnEVRXlO879xZr3680YOJ+bN
	 qmrDemiW/dLX6ME+H7GovnBqk6DtkjKOnLxE2R7qn36qV6VGbHjxjor2xIo3V8oD0af9vV08xtpKNO
	 hclj6bHb30s+cRv0UGHVRGdL6XL1aYQ==
ARC-Authentication-Results: i=2; mailfilter02.webhostingserver.nl;
	spf=softfail smtp.mailfrom=gmail.com smtp.remote-ip=141.138.168.154;
	dmarc=fail header.from=gmail.com;
	arc=pass header.oldest-pass=0;
X-Halon-ID: 8fcc9952-b3c4-11ef-b67a-001a4a4cb922
Received: from s198.webhostingserver.nl (s198.webhostingserver.nl [141.138.168.154])
	by mailfilter02.webhostingserver.nl (Halon) with ESMTPSA
	id 8fcc9952-b3c4-11ef-b67a-001a4a4cb922;
	Fri, 06 Dec 2024 12:23:47 +0100 (CET)
ARC-Seal: i=1; cv=none; a=rsa-sha256; d=webhostingserver.nl; s=whs1; t=1733484227;
	 b=DoyINm4EL+srynz+UTxWDO4LNzIuaAfuA+Agfj9ABM/FETq/F3jMS+0at6Pzm36cyGNHTaoC1j
	  KDTaDoAydnlgXaFNcI73iYLYdDSJ4hqod9wj6qLwK5C1wZcHqLyW2ItqEdAzt3Xgo0ofolk4Y/
	  ejNhLVvjPlH19/80avJW2n6WiP/tX3OJWGE88tpUOFBj27y5EPiqHb+NcHL9mzSycdQHrT1NYi
	  SZzTSX9Y9xknNgo92iYkzXUgqrdqfSO0ceKzlIdKfmW/D0CILh8EZFvOjLmNo0h98Fy95nim6r
	  rsxExbow2BeRwkrYr9aRRkBEYDbTguxFkluzZCrqGkjB0Q==;
ARC-Authentication-Results: i=1; webhostingserver.nl; smtp.remote-ip=178.250.146.69;
	iprev=pass (cust-178-250-146-69.breedbanddelft.nl) smtp.remote-ip=178.250.146.69;
	auth=pass (PLAIN) smtp.auth=ferry.toth@elsinga.info;
	spf=softfail smtp.mailfrom=gmail.com;
	dmarc=skipped header.from=gmail.com;
	arc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed; d=webhostingserver.nl; s=whs1; t=1733484227;
	bh=MET7W4WnLCq6005qUbj5NtKGeohPo7kN/cQMFHdSAO0=;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc:To:
	  Subject:MIME-Version:Date:Message-ID;
	b=JaRXj+MbQoiXpHrTJu1magZxh5aGkMFbf7bo4of+DJJvOWGg1/kUj/EQMFiCzzpbh2+6PxpHEH
	  nMYLrrg61GRBTugC2i2FQuf1EhGmhx1uk6J/sKSxoout+zD23Qt6e7H1PcUezlD9Zxc7qhQrWe
	  JWFP2/ybJPgx5zA7XSYEE+N+JuYDA4tFSP6o9l6P3vb5y468XWnJk1+X9ERgg6BzxUTsDNexW/
	  w0hj+McIjniXqawi1At/D/H8ulsVHnQsCSopFRbDOm+R5OSYeebKYQVTjkMra5Xh4wmdulnP/j
	  K1DofIMeZuiyRQjTFPMxWxQLcbd05c8SpIyBrTvTkiknJA==;
Authentication-Results: webhostingserver.nl;
	iprev=pass (cust-178-250-146-69.breedbanddelft.nl) smtp.remote-ip=178.250.146.69;
	auth=pass (PLAIN) smtp.auth=ferry.toth@elsinga.info;
	spf=softfail smtp.mailfrom=gmail.com;
	dmarc=skipped header.from=gmail.com;
	arc=none
Received: from cust-178-250-146-69.breedbanddelft.nl ([178.250.146.69] helo=smtp)
	by s198.webhostingserver.nl with esmtpa (Exim 4.98)
	(envelope-from <fntoth@gmail.com>)
	id 1tJWR1-00000007jgu-16gg;
	Fri, 06 Dec 2024 12:23:47 +0100
Message-ID: <d890eecc-97de-4abf-8e0e-b881d5db5c1d@gmail.com>
Date: Fri, 6 Dec 2024 12:23:38 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] x86: document X86_INTEL_MID as 64-bit-only
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
 Arnd Bergmann <arnd@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Davide Ciminaghi <ciminaghi@gnudd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org
References: <20241204103042.1904639-1-arnd@kernel.org>
 <20241204103042.1904639-9-arnd@kernel.org>
 <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
Content-Language: en-US, nl
From: Ferry Toth <fntoth@gmail.com>
In-Reply-To: <CAHp75VfzHmV2anw6C8iSCiwnJc2YNa+1aLDj6Frf9OZyGjD0MQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ACL-Warn: Sender domain ( gmail.com ) must match your domain name used in authenticated email user ( ferry.toth@elsinga.info ).
X-ACL-Warn: From-header domain ( gmail.com} ) must match your domain name used in authenticated email user ( ferry.toth@elsinga.info )
X-Antivirus-Scanner: Clean mail though you should still use an Antivirus

Hi,

Op 04-12-2024 om 19:55 schreef Andy Shevchenko:
> +Cc: Ferry
>
> On Wed, Dec 4, 2024 at 12:31 PM Arnd Bergmann <arnd@kernel.org> wrote:
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> The X86_INTEL_MID code was originally introduced for the
>> 32-bit Moorestown/Medfield/Clovertrail platform, later the 64-bit
>> Merrifield/Moorefield variant got added, but the final
> variant got --> variants were
>
>> Morganfield/Broxton 14nm chips were canceled before they hit
>> the market.
> Inaccurate. "Broxton for Mobile", and not "Broxton" in general.
>
>
>> To help users understand what the option actually refers to,
>> update the help text, and make it a hard dependency on 64-bit
>> kernels. While they could theoretically run a 32-bit kernel,
>> the devices originally shipped with 64-bit one in 2015, so that
>> was proabably never tested.
> probably
>
> It's all other way around (from SW point of view). For unknown reasons
> Intel decided to release only 32-bit SW and it became the only thing
> that was heavily tested (despite misunderstanding by some developers
> that pointed finger to the HW without researching the issue that
> appears to be purely software in a few cases) _that_ time.  Starting
> ca. 2017 I enabled 64-bit for Merrifield and from then it's being used
> by both 32- and 64-bit builds.
>
> I'm totally fine to drop 32-bit defaults for Merrifield/Moorefield,
> but let's hear Ferry who might/may still have a use case for that.

Do to the design of SLM if found (and it is also documented in Intel's 
HW documentation)

that there is a penalty introduced when executing certain instructions 
in 64b mode. The one I found

is crc32di, running slower than 2 crc32si in series. Then there are 
other instructions seem to runs faster in 64b mode.

And there is of course the usual limited memory space than could benefit 
for 32b mode. I never tried the mixed (x86_32?)

mode. But I am building and testing both i686 and x86_64 for each Edison 
image.

I think that should at minimum be useful to catch 32b errors in the 
kernel in certain areas (shared with other 32b

archs. So, I would prefer 32b support for this platform to continue.


> ...
>
>> -               Moorestown MID devices
> FTR, a year or so ago it was a (weak) interest to revive Medfield, but
> I think it would require too much work even for the person who is
> quite familiar with HW, U-Boot, and Linux kernel, so it is most
> unlikely to happen.
>
> ...
>
>>            Select to build a kernel capable of supporting Intel MID (Mobile
>>            Internet Device) platform systems which do not have the PCI legacy
>> -         interfaces. If you are building for a PC class system say N here.
>> +         interfaces.
>> +
>> +         The only supported devices are the 22nm Merrified (Z34xx) and
>> +         Moorefield (Z35xx) SoC used in Android devices such as the
>> +         Asus Zenfone 2, Asus FonePad 8 and Dell Venue 7.
> The list is missing the Intel Edison DIY platform which is probably
> the main user of Intel MID kernels nowadays.
Despite the Dell Venue 7 originally running a 32b Android kernel (I 
think), I got it run linux/Yocto in 64 bits.
> ...
>
>> -         Intel MID platforms are based on an Intel processor and chipset which
>> -         consume less power than most of the x86 derivatives.
> Why remove this? AFAIK it states the truth.
>
>

