Return-Path: <kvm+bounces-13004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD6C588FE41
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 12:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BDFD1C24270
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8DF7EEED;
	Thu, 28 Mar 2024 11:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gAaE8s4z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5010B7EF0D
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 11:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711626103; cv=none; b=AsG2+r51lQE+M4lIcK8zd4pt6CbJy+yCJcYPQ/kIsokw3Xd9iU94tfJycowliW0yxiH2LmgnFbwGTO64U2IefMlzOt1/pfITmfc/66DmXVg5HIuk0GouCC3dfUUYCuRY3F1fTd9FgrUMvkCFjsne+kK7OgkTXEX3ua5czg3pao0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711626103; c=relaxed/simple;
	bh=Yq/O+N+yqa18I/lF8R0JGR8+jWFJ6Ru38fREZO5/Fm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qwkooREFoNyeBWCD+XGPpLlrEddRBTLoVtfs2eficmdBSJzQLvxJe8cesRBKXHxaiTTMaIIWpAbtY2cT/1S9rv28sQFQIinKj/7UMgS7NJE+ehxZr1YORUrNJXw7GDXGZHQuwRS/Yhc2Jv140arWo1qdTX3Cne6H1r/+S3xkYQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gAaE8s4z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711626101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qOxltAGzL5YHNCBV4L/K4cCMJLqQbuY/mLAFgQC3J9k=;
	b=gAaE8s4zcJD9SGYi0MlAAy4FCL9bUzPPftSFzJWe1eiUsx1XssipJfp0rowDAUJhzNiCd8
	H0dWbaeXVdqNCQeausZZEkoaXA9gLlgYnfcUTWDzpS7R5SRR3QL4zqlhmQ/8nSF/s/ej6r
	BenKCM7wZ8k/gtWTL/Y/C4ZTpSkFR00=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-0tlwCzi3OJy1E37SeO5zCQ-1; Thu, 28 Mar 2024 07:41:39 -0400
X-MC-Unique: 0tlwCzi3OJy1E37SeO5zCQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-513e45ab9a8so650134e87.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 04:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711626098; x=1712230898;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOxltAGzL5YHNCBV4L/K4cCMJLqQbuY/mLAFgQC3J9k=;
        b=IM+akDEHu7rBs9Qxw+ZXUjKwa/GxTh4GnIcjdvyttxpcdr5UJe2HHx9p3dGF+eb+Up
         8Og/qUbuhj7oIOAJnSaOfJzm8BDREvydLiUd55sMo12imoM3FwnNVXDcU0ASkgFcPsnQ
         iIcu2bn90AKzZW/s6Fsh/2HakWgthEUFQ2X/5D3cV2p3+n3L2CF2kC1m/9pja+nso8om
         rGvboJVRI91O54wFE7RdtQZ+zm5z/UavvR6IvK2wogsp1/wsRiGEYhMgxK2y0zwItTLh
         PdX15ymc2fthH+tDomunyekFo33BkN5jlvq3C0eBfVaUT2WeXEVJYsvKoQgDbgb8Kucg
         uuug==
X-Forwarded-Encrypted: i=1; AJvYcCXQMjSJcL33HfzQO7FVs0DjGlL7nSbjbNDM03qffmCX3NNnBN8uxR9uu6CUEKpuNSIYUx/XYIca9ew3YNrMiTe9G1yA
X-Gm-Message-State: AOJu0Yy6TkLaVHOIScJMfqq3iIpG9hDYllfIV5g1UFfIDULg1vzgNFrQ
	QNGx18OSldDIZVvUDvEMMMMwWLezjdtK1ZKUEpteaVXhvwOLXKOK+zElKE3lSNkE4KtIbZ8panX
	uGnTe6oC2a8Wgai4R1MeALNIeYQadwQsiqq60/961WVB04UWPbw==
X-Received: by 2002:a05:6512:23a4:b0:515:c8da:c96d with SMTP id c36-20020a05651223a400b00515c8dac96dmr1443907lfv.19.1711626098440;
        Thu, 28 Mar 2024 04:41:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfFw/vYg0daTYcF9BK9aOAj78HRdidQpeANNUyp5rCWphcmB9hySzVeR81YP0LYioPyPCFEQ==
X-Received: by 2002:a05:6512:23a4:b0:515:c8da:c96d with SMTP id c36-20020a05651223a400b00515c8dac96dmr1443888lfv.19.1711626098033;
        Thu, 28 Mar 2024 04:41:38 -0700 (PDT)
Received: from ?IPV6:2003:cb:c714:3600:8033:4189:6bd4:ea29? (p200300cbc7143600803341896bd4ea29.dip0.t-ipconnect.de. [2003:cb:c714:3600:8033:4189:6bd4:ea29])
        by smtp.gmail.com with ESMTPSA id bx6-20020a5d5b06000000b00341e67a7a90sm1581093wrb.19.2024.03.28.04.41.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 04:41:37 -0700 (PDT)
Message-ID: <3448a9d6-58a8-475f-aff6-a39a62eee8c1@redhat.com>
Date: Thu, 28 Mar 2024 12:41:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: folio_mmapped
Content-Language: en-US
To: Quentin Perret <qperret@google.com>
Cc: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 viro@zeniv.linux.org.uk, brauner@kernel.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net,
 vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 keirf@google.com, linux-mm@kvack.org
References: <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com>
 <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com>
 <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
 <20240319143119.GA2736@willie-the-truck>
 <2d6fc3c0-a55b-4316-90b8-deabb065d007@redhat.com>
 <20240327193454.GB11880@willie-the-truck>
 <d0500f89-df3b-42cd-aa5a-5b3005f67638@redhat.com>
 <ZgVCDPoQbbXjTBQp@google.com>
 <5cec1f98-17a5-4120-bbf4-b487c2caf92c@redhat.com>
 <ZgVNXpUS8Ku37BLp@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZgVNXpUS8Ku37BLp@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.03.24 11:58, Quentin Perret wrote:
> On Thursday 28 Mar 2024 at 11:32:21 (+0100), David Hildenbrand wrote:
>> ... does that mean that for pKVM with protected VMs, "shared" pages are also
>> never migratable/swappable?
> 
> In our current implementation, yes, KVM keeps its longterm GUP pin on
> pages that are shared back. And we might want to retain this behaviour
> in the short term, even with guest_memfd or using the hybrid approach
> you suggested. But that could totally be relaxed in the future, it's
> "just" a matter of adding extra support to the hypervisor for that. That
> has not been prioritized yet since the number of shared pages in
> practice is relatively small for current use-cases, so ballooning was a
> better option (and in the case of ballooning, we do drop the GUP pin).
> But that's clearly on the TODO list!

Okay, so nothing "fundamental", good!

> 
>> The whole reason I brought up the guest_memfd+memfd pair idea is that you
>> would similarly be able to do the conversion in the kernel, BUT, you'd never
>> be able to mmap+GUP encrypted pages.
>>
>> Essentially you're using guest_memfd for what it was designed for: private
>> memory that is inaccessible.
> 
> Ack, that sounds pretty reasonable to me. But I think we'd still want to
> make sure the other users of guest_memfd have the _desire_ to support
> huge pages,  migration, swap (probably longer term), and related
> features, otherwise I don't think a guest_memfd-based option will
> really work for us :-)

*Probably* some easy way to get hugetlb pages into a guest_memfd would 
be by allocating them for an memfd and then converting/moving them into 
the guest_memfd part of the "fd pair" on conversion to private :)

(but the "partial shared, partial private" case is and remains the ugly 
thing that is hard and I still don't think it makes sense. Maybe it 
could be handles somehow in such a dual approach with some enlightment 
in the fds ... hard to find solutions for things that don't make any 
sense :P )

I also do strongly believe that we want to see some HW-assisted 
migration support for guest_memfd pages. Swap, as you say, maybe in the 
long-term. After all, we're not interested in having MM features for 
backing memory that you could similarly find under Windows 95. Wait, 
that one did support swapping! :P

But unfortunately, that's what the shiny new CoCo world currently 
offers. Well, excluding s390x secure execution, as discussed.

-- 
Cheers,

David / dhildenb


