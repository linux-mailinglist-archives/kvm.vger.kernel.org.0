Return-Path: <kvm+bounces-12280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AFA0880F2E
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8AA1D1C20FCB
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 10:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B423D0A4;
	Wed, 20 Mar 2024 09:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8O4uxQO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317EF3C68C
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710928788; cv=none; b=WdtoKg83KBfRgVcwm2L+C6jbUrpw3yU6Mr9GJ+gqJ5H3LVT0xSMri9PsVOpcbiWpQM0jO7OafRBOJUwRpBm9mRXGPtE7fnczTuh0HTvc45IkZZ8HZtiHhGqkCO2UBZQRylOPV7nDmGq6Sb6jJ06WnpkNnrWoJTQjCcXZQUfi9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710928788; c=relaxed/simple;
	bh=7H24NtFTN/VP/m6iz62khnEpeUfFeeaD2wRKEkWdeIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HD49/f6KPLGc6s7aHb5NfXR2Cc6qKbrrU0FNNgCvyoNnwj9cKJ7afrD+TS31PwRkTImhnY9BmhFdOn1lHNF8baLj5PO7iUW/HaRWeBegi1q1IZ5WoMYJUOvOv7uJ0BCrjUfFqhCKc3iwaLV5nzfg9nkgtZjsn7RkRBDJDf1vf2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8O4uxQO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710928785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4E6cV7Z0IXhk3/9ASVcucF4jSLxiWXgVx3agQhS5UWA=;
	b=R8O4uxQOZ6FfHtnuQ425gOL9L0+JtyNW6taZ8ZhC26W3dp7KjyGfp22yUUQ6NvSVPpHPig
	Quy3WuJ4eNVaCqXSAvGY5MEr/HIfIhbI3rW27rJQBE4smxQnY8BN1iNaE7fesAt0W7JMmd
	LuQnpX7T17h0jkaE35tsw3pgXeqIuGk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-442-QdoY0XOwNemUhUs_GFWDlg-1; Wed, 20 Mar 2024 05:59:43 -0400
X-MC-Unique: QdoY0XOwNemUhUs_GFWDlg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a3fb52f121eso305886366b.0
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 02:59:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710928782; x=1711533582;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4E6cV7Z0IXhk3/9ASVcucF4jSLxiWXgVx3agQhS5UWA=;
        b=IO+ZUROen5RzeY8plDaceDtiXexd40ndfnTTrEB/wPo5AxPXc7j5vNlGoMn6RNNWCF
         14vU2yNCc9gDptDlCKpgiIw2WaxOp6XMGwzYPmkQDSnWptI72rxmHdx14VLDs0Ej0P+1
         n+Y+J5uGoXDvnMTU9RuC0t8CqjgOD4I3xn1q4hU2sx/JwX5zhQiPsZocK1+Hcy2/H46N
         KLQAuSvPQvcQtR2cckJGuiyuJUlus+17RMiwJTFvjb6HaKCQ+EvbF4W6dFGZUlIDlWHN
         4esoDCSKjoJSPyIeyVoM+hw+P9D+58TCr8HEl70a5+ccbPZCS9xAHvPMttqdAd/w48LW
         HFnw==
X-Gm-Message-State: AOJu0YyuF01lHede+FboXBg8UUx/URRp2WUbry049q5bWhp+953B4R3K
	tPHlujN5GAbrtAfb0X4GRwwBEkIcarGNN5A8f6aNsH/MPgqv8qnQCv11Xv7dlG/zvzjozB7z6F5
	JJwwxmRHutxLeBWhj3Z0LJUZ0y3WxAcbXIVHeF2UI5k8bxYNbMA==
X-Received: by 2002:a17:906:874d:b0:a46:11a9:430 with SMTP id hj13-20020a170906874d00b00a4611a90430mr10945340ejb.76.1710928782552;
        Wed, 20 Mar 2024 02:59:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJxJ9NP1udzip8cs/ntajoHKAsSNPNLtMjuJRtzEyV7kcMkGCa6+sfp3x2uAcI8kr/s5GSxQ==
X-Received: by 2002:a17:906:874d:b0:a46:11a9:430 with SMTP id hj13-20020a170906874d00b00a4611a90430mr10945331ejb.76.1710928782222;
        Wed, 20 Mar 2024 02:59:42 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id gq5-20020a170906e24500b00a46be5c78f4sm3425428ejb.142.2024.03.20.02.59.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 02:59:41 -0700 (PDT)
Message-ID: <eea690c2-7d2f-4a35-b5c3-078c12ef228b@redhat.com>
Date: Wed, 20 Mar 2024 10:59:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 00/49] Add AMD Secure Nested Paging (SEV-SNP)
 support
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:38, Michael Roth wrote:
> These patches implement SEV-SNP base support along with CPUID enforcement
> support for QEMU, and are also available at:
> 
>    https://github.com/amdese/qemu/commits/snp-v3-rfc
> 
> they are based on top of the following patchset from Paolo:
> 
>    "[PATCH 0/7] target/i386: VM type infrastructure and KVM_SEV_INIT2 support"
>    https://lists.gnu.org/archive/html/qemu-devel/2024-03/msg04663.html
> 
> 
> Patch Layout
> ------------
> 
> 01-05: Various changes needed to handle new header files in kvm-next tree
>         and some hacks to get a functional header sync in place for building
>         this series.
> 06-18: These are patches directly plucked from Xiaoyao's TDX v5 patchset[1]
>         that implement common dependencies between SNP/TDX like base
>         guest_memfd, KVM_EXIT_MEMORY_FAULT handling (with a small FIXUP), and
>         mechanisms to disable SMM. We would've also needed some of the basic
>         infrastructure for handling specifying VM types for KVM_CREATE, but
>         much of that is now part of the sevinit2 series this patchset is based
>         on. Ideally all these patches, once stable, could be maintained in a
>         common tree so that future SNP/TDX patchsets can be more easily
>         iterated on/reviewed.
> 19-20: Patches introduced by this series that are  possible candidate for a
>         common tree.
>         shared/private pages when things like VFIO are in use.
> 21-32: Introduction of sev-snp-guest object and various configuration
>         requirements for SNP.
> 33-36: Handling for various KVM_EXIT_VMGEXIT events that are handled in
>         userspace.
> 37-49: Support for creating a cryptographic "launch" context and populating
>         various OVMF metadata pages, BIOS regions, and vCPU/VMSA pages with
>         the initial encrypted/measured/validated launch data prior to
>         launching the SNP guest.

I reviewed the non-SEV bits of patches 21-46 and it looks nicely 
self-contained.  That's pretty much expected but still good news.

I didn't look closely at the SEV-SNP code for obvious reasons (it's only 
been one hour :)), except for the object-oriented aesthetics which I 
have remarked upon.  However, they seem to be in good shape.

I will now focus on reviewing patches 6-20.  This way we can prepare a 
common tree for SEV_INIT2/SNP/TDX, for both vendors to build upon.

Thanks for posting this, and thanks to the Intel people too for the 
previous work on the guest_memfd parts!

Paolo


