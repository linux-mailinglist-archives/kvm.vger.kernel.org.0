Return-Path: <kvm+bounces-22508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B366393F713
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 15:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64870282038
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 13:53:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9669C153835;
	Mon, 29 Jul 2024 13:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYwh23rJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8BC146D54
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722261223; cv=none; b=LYhO9oIxXpKfhujTFXzqcr/39QJWQ3JUZZXU12AeGFsgEdVP2jxUE9uu0urnX15iNr0G7wKr7uQAvsc6nC0qKNkTy+B0s7wal7mI72dsbnXb0TrRnSV2cpOTONo8Xpch18xinBfdqUNboGqpn0I8czCPOgcvfW7SbJG6lpoBVu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722261223; c=relaxed/simple;
	bh=zevFigggh9gav77vOeUqQEZLN00S3klYyCxmhPrpO0k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dSrcVnWrQoVxkqwKJxbHhljYGfwYWhgA6QNTYO9I8KuGD7MS/83LGT9n5VFsWlG/bDqQWDmkbDQCme0LraCkqijYE0EXYUwtpKr82vjj6Hn3nPYnXoodQZ57TJIC7WRWhPdozW4AJ3UbqXHBhcHMOwmfipJ/rWf2o5yVRj2XwjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYwh23rJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722261221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yEq5CChoNdWngYsHC+lDcujFG99veLH/xTIPSOMsNE=;
	b=CYwh23rJ73eOHv8GNIF0LAPHB1VExusYM9H4oGu3NTkM6ll3ToK8rS/OrdksfBzowRLkJK
	BhF+2DFFlvZ9VECF71hauH1BIfdE1OnoHYMtoImUuhBz0i7wRiVCGKqR3QdS8peuRTdq6b
	GWMpwIkrBLDGzWIGXhdHPF/rNMjamq0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-Hy2v_zVPPle7gC-aEUYTrA-1; Mon, 29 Jul 2024 09:53:38 -0400
X-MC-Unique: Hy2v_zVPPle7gC-aEUYTrA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4280e1852f3so19454345e9.3
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 06:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722261217; x=1722866017;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6yEq5CChoNdWngYsHC+lDcujFG99veLH/xTIPSOMsNE=;
        b=h/U0Xf5+6bGxxeBZMbXrQd693Wa8j6RLIrrXwxdV9HFYJW6Ww4A7oXhWf+cuu8pU/d
         h2CA5e5Ibs8sm6A8AnMIMr2rK3ANi4v93wrJIKxb2RnFLHVeGwKFI9eeqadjGTS2+V7C
         r7yAQspTlmQ0LvJbqu4hR/tN/4aDo+l6FFy57AR8iudMDS6FwPyw5u8hK/MKJLS5EEpo
         E7nt0EQH4ogBrRqjCpMl4uhKJ6rP4xZfFqqLHQoY9/FHUSP3vOSZUcG9IcIOccnYMiIw
         Nil5VgNThqKzIaphUakSbIQJNI/U5ct1zu0hTyVYuanRHAOotYOBcMfWalopYDCP6Mkn
         fGjg==
X-Forwarded-Encrypted: i=1; AJvYcCXaZ7UyVM2V4KJptrDqvd+zDn23PKP4NhVFrs+NY8p3oaCPi1LR7bwZ3CW+Bwz23j6zAwJFTMHgKApT9r3xr8Lnl5LI
X-Gm-Message-State: AOJu0YzOprI6siCiklrKn0w9HDL7sUQzw+vU97se4B8mjAa/cb8ksyGj
	Mu0KRDXyMEl05cuwnuAh5YddTlio8FnYqLt6CplscJryjo69HH0R2BdUsWBm8NAtmh9MCXrrEmP
	5VSFc5Mti1TYWpraD7NoeNajx+eM97lLkR6vnSS+eGyIRZZnOfQ==
X-Received: by 2002:a05:600c:444d:b0:426:65bf:5cc2 with SMTP id 5b1f17b1804b1-42811d83c38mr50666365e9.1.1722261216882;
        Mon, 29 Jul 2024 06:53:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEQ34nlwG6HFfNMqNvetJJ+pbG8/TxeOUBuPfISPhjduWTs2MRaELaUuF0Pc7fNro9Ocof+NQ==
X-Received: by 2002:a05:600c:444d:b0:426:65bf:5cc2 with SMTP id 5b1f17b1804b1-42811d83c38mr50666185e9.1.1722261216359;
        Mon, 29 Jul 2024 06:53:36 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4280d13570bsm123111095e9.7.2024.07.29.06.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jul 2024 06:53:36 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, graf@amazon.de, dwmw2@infradead.org,
 pdurrant@amazon.com, mlevitsk@redhat.com, jgowans@amazon.com,
 corbet@lwn.net, decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 amoorthy@google.com
Subject: Re: [PATCH 01/18] KVM: x86: hyper-v: Introduce XMM output support
In-Reply-To: <D2RVJ6QCVNOU.XC0OC54QHI51@amazon.com>
References: <20240609154945.55332-1-nsaenz@amazon.com>
 <20240609154945.55332-2-nsaenz@amazon.com> <87tth0rku3.fsf@redhat.com>
 <D2RVJ6QCVNOU.XC0OC54QHI51@amazon.com>
Date: Mon, 29 Jul 2024 15:53:34 +0200
Message-ID: <878qxk5mox.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Nicolas Saenz Julienne <nsaenz@amazon.com> writes:

> Hi Vitaly,
> Thanks for having a look at this.
>
> On Mon Jul 8, 2024 at 2:59 PM UTC, Vitaly Kuznetsov wrote:
>> Nicolas Saenz Julienne <nsaenz@amazon.com> writes:
>>
>> > Prepare infrastructure to be able to return data through the XMM
>> > registers when Hyper-V hypercalls are issues in fast mode. The XMM
>> > registers are exposed to user-space through KVM_EXIT_HYPERV_HCALL and
>> > restored on successful hypercall completion.
>> >
>> > Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
>> >
>> > ---
>> >
>> > There was some discussion in the RFC about whether growing 'struct
>> > kvm_hyperv_exit' is ABI breakage. IMO it isn't:
>> > - There is padding in 'struct kvm_run' that ensures that a bigger
>> >   'struct kvm_hyperv_exit' doesn't alter the offsets within that struct.
>> > - Adding a new field at the bottom of the 'hcall' field within the
>> >   'struct kvm_hyperv_exit' should be fine as well, as it doesn't alter
>> >   the offsets within that struct either.
>> > - Ultimately, previous updates to 'struct kvm_hyperv_exit's hint that
>> >   its size isn't part of the uABI. It already grew when syndbg was
>> >   introduced.
>>
>> Yes but SYNDBG exit comes with KVM_EXIT_HYPERV_SYNDBG. While I don't see
>> any immediate issues with the current approach, we may want to introduce
>> something like KVM_EXIT_HYPERV_HCALL_XMM: the userspace must be prepared
>> to handle this new information anyway and it is better to make
>> unprepared userspace fail with 'unknown exit' then to mishandle a
>> hypercall by ignoring XMM portion of the data.
>
> OK, I'll go that way. Just wanted to get a better understanding of why
> you felt it was necessary.
>

(sorry for delayed reply, I was on vacation)

I don't think it's an absolute must but it appears as a cleaner approach
to me. 

Imagine there's some userspace which handles KVM_EXIT_HYPERV_HCALL today
and we want to add XMM handling there. How would we know if xmm portion
of the data is actually filled by KVM or not? With your patch, we can of
course check for HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE in
KVM_GET_SUPPORTED_HV_CPUID but this is not really straightforward, is
it? Checking the size is not good either. E.g. think about downstream
versions of KVM which may or may not have certain backports. In case we
(theoretically) do several additions to 'struct kvm_hyperv_exit', it
will quickly become a nightmare.

On the contrary, KVM_EXIT_HYPERV_HCALL_XMM (or just
KVM_EXIT_HYPERV_HCALL2) approach looks cleaner: once userspace sees it,
it knows that 'xmm' portion of the data can be relied upon.

-- 
Vitaly


