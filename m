Return-Path: <kvm+bounces-59955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA99BD6C44
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 01:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 52A8D4ECCDD
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 23:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89952FABFF;
	Mon, 13 Oct 2025 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b4b59Poe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4B82EBB9A
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760399091; cv=none; b=QTNaDCYXzwfjTJ1hHRR1DEJK+OMWC90B380N7Vu6eGOYcRdZxUcJ6xNOnZ8q/VEdeSnHucbghLFj7i38Pozeb+cE7o1HG57va7axhfKcbYcD10xjrA7FIAGcV6aGwDyySmiSEx0cCmG7AvNBaq573hsRUr6g6b06gH/GqEHwz2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760399091; c=relaxed/simple;
	bh=kHu0Kn16r31jtUagcmghV7eGBPOLCLPLIuETVS1RlcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bzEDX5t4er36pRRteNP10kPlaEf9guI+PGmBGSIq9A47kIcABhELGmL+DeztR6/aA7vi3mHCBe8KH1hV0yMEYfZzD5qUcQ2ge2a9St0EF6F2GX8GBNyqi4WYkRfEnvcc5PTIxuCQGQRIjkXF2mdUMFfWyxBE4R++WAT8N3zbZf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b4b59Poe; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b55283ff3fcso6946832a12.3
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 16:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399089; x=1761003889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UqoD/18rU9gn5PYrwD45cJOp3CHgTWgbZLlXTeR72/I=;
        b=b4b59Poe8wY7YlE8JUcjSFYH2ftXH/jUTne4WrUNVE4WY/WBEfQGDEZVyCcSBrvfgt
         ZEKj5wK5jRpIOobRHIzkLNS3W9BT3O1LnjAbwJG+/Xih5mnxEFANJ8ND0KqMJrOZnVfO
         xJd6eEhx9GaugjlqWPa+izACoU3aRsC/wL8FePX3G9EWuq9BPe5iKxaxgCiYdnzCSXpb
         IWhTldJkwITFHjwosfpLAV6O0YEJl5ctL9gHfluWpe6Q4Xb22+ML0mKdG8zDJUUmbdBN
         2kZavTEIt34ZsaaxCLAH+tJsywF084TVOxRzIo6y6kByOHY2cxqK+aduyr6sjFJFkoLC
         dCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399089; x=1761003889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UqoD/18rU9gn5PYrwD45cJOp3CHgTWgbZLlXTeR72/I=;
        b=m4hFbM1RwucXtCEbPSyXjlBtXa0R2Tk9kgboksef9PL1a+GJb1N+ZgRz8OT/9YwESp
         f9smfq9YGh+Vwziz+X7CI8gULexp5AV1NTkaQHqnCNMxtsmbMSCtmMaAW9X7fpTxUFt7
         ivDESOdgeAubwq3aZWz91PO00qFuJgPfH+IaPeaac+7CCmaIpUvxjF2rj+tI9yrJwm+N
         ex9K0TaYwlJdvfT366WPmbya3CnFHXop0IjrL/sAqOdlIx6o3iZEVXBvxjrEOUbmdiki
         H1Vt1Mm10E0XA7eL7a30fQjg6PhaPzbIUYM1wgidwlCT3iBHeZ90YDTwVArXPqQaRHdx
         CjMg==
X-Gm-Message-State: AOJu0YzC5lPy45NF/i/9awWd6Y/gY9FCUo3pQPb1Ac0Q7UGsYpHo5X1O
	8VuqvNmMu1fd6cS3QLgB1YJf05AZUpmEv5npuHLp3AGMeD+exi6rGo+gPyPA2A4hYN52ME1ZWoF
	QRkwmYfQ6Hhng1B2OQPznL8tpVw==
X-Google-Smtp-Source: AGHT+IH/1nj52Fh0IrgP4QxEUCOki6zHvjOxQrybJcic9nHILXzx8auRksGN8mxo4OcjN+2fec/1VwAL6ig+b8nupQ==
X-Received: from pjbmt1.prod.google.com ([2002:a17:90b:2301:b0:33b:51fe:1a89])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4ac9:b0:32b:9774:d340 with SMTP id 98e67ed59e1d1-33b513ea07emr33330333a91.33.1760399088861;
 Mon, 13 Oct 2025 16:44:48 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:44:47 -0700
In-Reply-To: <68deb76c2dc2a_2957e22943f@iweiny-mobl.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1747264138.git.ackerleytng@google.com> <b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com>
 <aNxqYMqtBKll-TgV@google.com> <diqzbjmrt000.fsf@google.com>
 <68ddb87b16415_28f5c229470@iweiny-mobl.notmuch> <diqzv7kxsobo.fsf@google.com> <68deb76c2dc2a_2957e22943f@iweiny-mobl.notmuch>
Message-ID: <diqzh5w2fjtc.fsf@google.com>
Subject: Re: [RFC PATCH v2 02/51] KVM: guest_memfd: Introduce and use
 shareability to guard faulting
From: Ackerley Tng <ackerleytng@google.com>
To: Ira Weiny <ira.weiny@intel.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Fuad Tabba <tabba@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth <michael.roth@amd.com>, 
	Ira Weiny <ira.weiny@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, David Hildenbrand <david@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Ira Weiny <ira.weiny@intel.com> writes:

> 
> [...snip...]
> 
>> >> 
>> >> Conversions take the filemap_invalidate_lock() too, along with
>> >> allocations, truncations.
>> >> 
>> >> Because the filemap_invalidate_lock() might be reused for other
>> >> fs-specific operations, I didn't do the mt_set_external_lock() thing to
>> >> lock at a low level to avoid nested locking or special maple tree code
>> >> to avoid taking the lock on other paths.
>> >
>> > I don't think using the filemap_invalidate_lock() is going to work well
>> > here.  I've had some hangs on it in my testing and experiments.  I think
>> > it is better to specifically lock the state tracking itself.  I believe
>> > Michael mentioned this as well in a previous thread.
>> 
>> Definitely took the big hammer lock for a start and might be optimizable.
>> 
>> Considerations so far: when a conversion is happening, these have to be
>> locked out:
>> 
>> + Conversions from competing threads
>
> Agreed.  And this needs filemap_invalidate_lock() as well as the maple
> tree lock.
>
> Call this item 1.
>
>> + Allocations in kvm_gmem_fault_user_mapping(), because whether an
>>   offset can be faulted depends on the outcome of conversion
>
> Agreed.  And this needs filemap_invalidate_lock() as well as the maple
> tree lock.
>
> Call this item 2.
>
>> + Allocations (fallocate() or kvm_gmem_get_pfn()) and truncations,
>>   because conversions (for now) involves removing a folio from the
>>   filemap, restructuring, then restoring to the filemap, and
>>     + Allocations should reuse a folio that was already in the filemap
>>     + Truncations remove a folio, and should not skip removal of a folio
>>       because it was taken out just for conversion
>
> I don't think this is required...
>
>> + memory failure handling, where we don't remove folios from the
>>   filemap, but we might restructure, to split huge folios to just unmap
>>   pages with failed memory
>
> ... nor this.  These don't change the sharability maple tree.
>
> These operations don't change or need to know the shareability AFAICT.
>
> Merging a folio would have to check the maple tree to ensure we don't
> merge incompatible folios...  But that is a read check and should be easy
> to add.
>
>> I think essentially because conversion involves restructuring, and
>> restructuring involves filemap operations and other filemap operations
>> have to wait, conversion also takes the filemap_invalidate_lock() that
>> filemap operations use.
>
> I could be convinced otherwise but I'm thinking the overhead of another
> lock for the sake of simplicity is a good trade off.  I don't think any of
> the conversions are a fast path operation are they?

Haha, I think not having another lock is simpler! Looks like it's
starting to get subjective.

For the next RFC, I'll go with re-using the filemap_invalidate_lock(),
and the next RFC will have quite some changes too. Please feel free to
bring this up again. The next RFC is an RFC and won't be committal
anyway :)

>
> Ira
>
> [snip]

