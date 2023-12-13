Return-Path: <kvm+bounces-4377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 320D5811B5E
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDF931C20BF8
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BBE257893;
	Wed, 13 Dec 2023 17:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TqDpgPEm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBEF99
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702489178;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wMIRpMzvlSiW4Uq3ildO6AijIYP6wLHY65QDVFZkhBA=;
	b=TqDpgPEmhuc0amw6sptNjHGCFgTtaFRAnOlcZFc92X6oRrOQja+8uRyhY75EQb3CWzb1ry
	Tp3vLC/JPSHsNlXp8itmLNON4PaBPitvNuoV6aJU+9S++1TrR4T1kIcOOdpGwBD/t62Zng
	LU28Dg1sat7YK5HmAZzPMJEXrYALALE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-70-VpeCafkAPK6X-SIjZREAHg-1; Wed, 13 Dec 2023 12:39:37 -0500
X-MC-Unique: VpeCafkAPK6X-SIjZREAHg-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-54caf6220c2so4378660a12.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 09:39:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702489176; x=1703093976;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMIRpMzvlSiW4Uq3ildO6AijIYP6wLHY65QDVFZkhBA=;
        b=LxEZWP+T2Y2YcJEheeq7CUkOjM0ffFXePlIZt/wPZxdlGQipiEk+/4vwgyQRT+l/mV
         HtmTxr/4WzM08yqIGLbF2ubzooKm+0clmilRu5TMFlzCf1F9RrTYXN3rMEyhWoF+kYJf
         BOB/MIne+q4VAFGS6z1ZCyoTGKYyeyfuPo511WsDHhhHmaiXMHJ+luF7XawuQSAs9Cqj
         Y42ec2Z9uN3noU6NeN6E//tEaoSsxnjFR9N5zxA/UXeq3IVuQwfR92MWJDahI+iKTY0M
         zYyT9oHXHf+Qdn9Ag31SlMGRQeLPjxNfPCjgPKbIfRCHc2cXxNY/Dl1I+Obcb84EaXL/
         +aqQ==
X-Gm-Message-State: AOJu0YyiAY/AJrVVSHhpzuALp3XRlfDYPHMYeUXs4K4itCmoxH7ETMFB
	PD+2IhZ5rkkfsm8aAa7UR6efBCLR0AztmFLPX9323G4ft7qggezrY+XlP8KLL6yY5Ygen6JN7+A
	kMCbn6/5xqLT6
X-Received: by 2002:a50:aa81:0:b0:54f:64f4:c2da with SMTP id q1-20020a50aa81000000b0054f64f4c2damr5011983edc.11.1702489175929;
        Wed, 13 Dec 2023 09:39:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGu6ssPvrQwbmBqBdkria3LO2iu4eH+D3bNohApbXQ+P+kueeoHLhMBh/6iNtBbxAhA1JkmLA==
X-Received: by 2002:a50:aa81:0:b0:54f:64f4:c2da with SMTP id q1-20020a50aa81000000b0054f64f4c2damr5011977edc.11.1702489175593;
        Wed, 13 Dec 2023 09:39:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id dc23-20020a056402311700b005525a9abf73sm171094edb.11.2023.12.13.09.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 09:39:34 -0800 (PST)
Message-ID: <84ad3082-794b-443f-874a-d304934a395b@redhat.com>
Date: Wed, 13 Dec 2023 18:39:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: fix supported_flags for aarch64
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Shaoqin Huang <shahuang@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20231208184628.2297994-1-pbonzini@redhat.com>
 <ZXPRGzgWFqFdI_ep@google.com>
 <184e253d-06c4-419e-b2b4-7cce1f875ba5@redhat.com>
 <ZXnoCadq2J3cPz2r@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZXnoCadq2J3cPz2r@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/23 18:21, Sean Christopherson wrote:
> On Tue, Dec 12, 2023, Paolo Bonzini wrote:
>> On 12/9/23 03:29, Sean Christopherson wrote:
>>> On Fri, Dec 08, 2023, Paolo Bonzini wrote:
>>>> KVM/Arm supports readonly memslots; fix the calculation of
>>>> supported_flags in set_memory_region_test.c, otherwise the
>>>> test fails.
>>>
>>> You got beat by a few hours, and by a better solution ;-)
>>>
>>> https://lore.kernel.org/all/20231208033505.2930064-1-shahuang@redhat.com
>>
>> Better but also wrong---and my patch has the debatable merit of more
>> clearly exposing the wrongness.  Testing individual architectures is bad,
>> but testing __KVM_HAVE_READONLY_MEM makes the test fail when running a new
>> test on an old kernel.
> 
> But we already crossed that bridge and burned it for good measure by switching
> to KVM_SET_USER_MEMORY_REGION2, i.e. as of commit
> 
>    8d99e347c097 ("KVM: selftests: Convert lib's mem regions to KVM_SET_USER_MEMORY_REGION2")
> 
> selftests built against a new kernel can't run on an old kernel.  Building KVM
> selftests requires kernel headers, so while not having a hard requirement that
> the uapi headers are fresh would be nice, I don't think it buys all that much.
> 
> If we wanted to assert that x86, arm64, etc. enumerate __KVM_HAVE_READONLY_MEM,
> i.e. ensure that read-only memory is supported as expected, then that can be done
> as a completely unrelated test.

selftests have the luxury of having sync-ed kernel headers, but in 
general userspace won't, and that means __KVM_HAVE_READONLY_MEM would be 
a very poor userspace API.  Fortunately it has "__" so it is not 
userspace API at all, and I don't want selftests to treat it as one.

> IMO, one of the big selling points of selftests over KUT is that we can punt on
> supporting old kernels since selftests are in-tree.  I don't think it's at all
> unreasonable to require that selftests be built against the target kernel, and
> by doing so we can signficantly reduce the maintenance burden.  The kernel needs
> to be backwards compatibile, but I don't see why selftests need to be backwards
> compatible.

It does help sometimes to be able to run old tests on new kernel or vice 
versa.  So even without making that a requirement, it is a nice thing to 
have whenever possible.

Paolo


