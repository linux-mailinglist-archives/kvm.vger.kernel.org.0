Return-Path: <kvm+bounces-46117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 04D39AB2718
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 10:03:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BA3E1716F1
	for <lists+kvm@lfdr.de>; Sun, 11 May 2025 08:03:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E63FA1A0BC9;
	Sun, 11 May 2025 08:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQvH1tL+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F924134BD
	for <kvm@vger.kernel.org>; Sun, 11 May 2025 08:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746950591; cv=none; b=fC8J1v7U2R1FSAddQfsd95Rr2uztU7SDFpQTmNmVgFOsWfjYRCYKbFc6hSTVAvTxcCs4QSy1rAJrC1AV68b0urfAdgRm4cRbaj07c+7jE0euv7yvbMRm4i56cD0bmoE1wFr9/uKnh4VeXNq08l9X9dqg4/LCjxz61Er6F8dOVJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746950591; c=relaxed/simple;
	bh=BU/BLUQItkEUhW1JWzI5J1UqLdhUxibtIgoRJvSHpYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n2bCIZC1l8s3bFBNcxSKvODBPiUe91QM0xkrkbdJ8fN8QlFSIjC4RkPlvEnH7OtsmoVQy3NN2d5JDONuJNVu1nJoqMwmEalV+xQm9thyIZCCcL02/EJV6V70fAhRIZCV0XP29ftons7pm8Gh/io//2pW/r3S6e1phL/qIXwfCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UQvH1tL+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746950588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9xZCyoLCpygux++89hw3WadlucwLc86PZFX4lyExTvc=;
	b=UQvH1tL+FIUNDjW3yKg5UB/9NzqRXff1pk361dDgb3SN+gSY3ZPSY3t5DnAmTjePlsWam7
	Ds5t9EeDJRkxPGN30Oc4ySGg8pc2EdVTSb113TMIcfy1X+KkmBq+z/KaR4C3+LdjjvW0sr
	2+PvPOMYrCGxZ+xSyCItaYoe0iPqWXM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-pgCBX2L_MReg-gxxdIXudA-1; Sun, 11 May 2025 04:03:06 -0400
X-MC-Unique: pgCBX2L_MReg-gxxdIXudA-1
X-Mimecast-MFC-AGG-ID: pgCBX2L_MReg-gxxdIXudA_1746950585
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-442cd12d151so21152025e9.1
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 01:03:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746950585; x=1747555385;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9xZCyoLCpygux++89hw3WadlucwLc86PZFX4lyExTvc=;
        b=sSCh1AMAdqJywin+X9UzN/wv5vmbuODza3WAYXIkUYQ0D1f9d30Xy8MytbwSsmn/V1
         FMEc5610naJQunfGyz6ycdirRXHxmBoAi63RKSBtwSFTIOtsdcIbr4JOUndExKP3xagT
         l1RoBd1JasWiJPm8nmLJJFJdwQlB7X85TEea8r+52CnCdi5bN3WXaQCk7qEyNfh/tw8b
         iQbmviGFP8RKCPBS/7Ny0YLbgPJ8WNyA9PRbizxSNTtbPMfkgHhoxD5Q670x0pzRd4dG
         wHDP5T6jH2sOeqzhLnZlsb5tnc/z3gEbVp28EtlDYlYBP1C6tn1EHSzW3yZjbDcHqkMB
         +DPQ==
X-Gm-Message-State: AOJu0YzzZKA6HTBWkDzFWitko8cg8i56JrV3GEh8RAynYRM/HZawpgSE
	4bxBMNBBhwWrcDNg6RlPydAHrLU9c8qoZvKqoC7uWJJlN1pzbvLtL1X55MYZxGWjvbjVyY0tb02
	l7bj/MtWDzRTMNeneVegdumxWxlRnBLNWHzjOaSsuEt+V2bFmoA==
X-Gm-Gg: ASbGnctS8GP+qPgCZmcPRlxQ8Y2fJJVaRXzVbZufFUeap6XNpWbN08UckfUPXIX39vG
	HV6/tMxhP9149dZAp/T2r5WcMdswBDGlqUEu3+oisWcQqQv3WD2PJjcrEeoOu/guOlSDtcjSFKs
	ChuBAvgL3P06iC7P3S0c25uULSnG+zSXI/NIjKgzYdAvzwaXWCwtKlTSJQzpfySbBtdoRykSQC5
	nbnprcOXhjdoZOU7wvN7Bk1ICVOgf1RvGqcnZ2fz1/+EoCD5fcrLA2eqSJmAJWU0JhR/a/cCYoM
	+WhVGSNhD/0Frd5dVcXlmY86W7P71QOTDCN4yxP0tVoiU70yHRNzWvOVacnvpspMVP6a12a5MbV
	az4ExTLzN6fhcWnp1lr/Mi86qg0U2Cjki4+OAYUA=
X-Received: by 2002:a05:600c:1548:b0:43c:ed61:2c26 with SMTP id 5b1f17b1804b1-442d6d5d1dbmr74925825e9.17.1746950584842;
        Sun, 11 May 2025 01:03:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAYnzIGg52iTvL+2EdsUVnf0qVizDis5pYhJjb2TdjrwuOOtZS7Mlgq9sMqik3yE4lDlArvg==
X-Received: by 2002:a05:600c:1548:b0:43c:ed61:2c26 with SMTP id 5b1f17b1804b1-442d6d5d1dbmr74925535e9.17.1746950584391;
        Sun, 11 May 2025 01:03:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1e:c400:a7bb:d0cb:2506:c714? (p200300d82f1ec400a7bbd0cb2506c714.dip0.t-ipconnect.de. [2003:d8:2f1e:c400:a7bb:d0cb:2506:c714])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2fc4sm8649497f8f.56.2025.05.11.01.03.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 May 2025 01:03:03 -0700 (PDT)
Message-ID: <702d9951-ac26-4ee4-8a78-d5104141c2e4@redhat.com>
Date: Sun, 11 May 2025 10:03:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: James Houghton <jthoughton@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 peterx@redhat.com, pankaj.gupta@amd.com
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-9-tabba@google.com>
 <CADrL8HVO6s7V0c0Jv0gJ58Wk4NKr3F+sqS4i2dFw069P6ot7Fg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CADrL8HVO6s7V0c0Jv0gJ58Wk4NKr3F+sqS4i2dFw069P6ot7Fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09.05.25 22:54, James Houghton wrote:
> On Wed, Apr 30, 2025 at 9:57 AM Fuad Tabba <tabba@google.com> wrote:
>> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +       struct kvm_gmem *gmem = file->private_data;
>> +
>> +       if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
>> +               return -ENODEV;
>> +
>> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
>> +           (VM_SHARED | VM_MAYSHARE)) {
>> +               return -EINVAL;
>> +       }
>> +
>> +       vm_flags_set(vma, VM_DONTDUMP);
> 
> Hi Fuad,
> 
> Sorry if I missed this, but why exactly do we set VM_DONTDUMP here?
> Could you leave a small comment? (I see that it seems to have
> originally come from Patrick? [1]) I get that guest memory VMAs
> generally should have VM_DONTDUMP; is there a bigger reason?

(David replying)

I assume because we might have inaccessible parts in there that SIGBUS 
on access.

get_dump_page() does ignore any errors, though (returning NULL), so 
likely we don't need VM_DONTDUMP.

-- 
Cheers,

David / dhildenb


