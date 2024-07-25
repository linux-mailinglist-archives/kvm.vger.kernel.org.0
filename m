Return-Path: <kvm+bounces-22265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6F193C83C
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 20:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AAED283682
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 18:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E842E40D;
	Thu, 25 Jul 2024 18:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4jz3CDYg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8848420DC4
	for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 18:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721931570; cv=none; b=Rtg0L1QomRiKBfpXuELNEHiW6Y8xTVCpaWuVADrMVdfP/p33BDtyrF4kEPmD7Iy0BJmREbLpRFElBsiYv/AdAj4trRPK/UAQaamWFxWyz3UHOX6lVnrhAqTgzFY/cTAe7A9eLWC44q6Byoq2IZJUwYlro46uLgAFLjzYqLiH/Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721931570; c=relaxed/simple;
	bh=Ue5vF5Ixtm0O1c2YnWtk0OGg5UItE1cxouPFbqUWkBs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UrYzTC0zaopRq7zSYb/pWIf9PcK2XY1QYZF0KMyBxYnLQ2kQ6C3fbM1rMYrbB1vQXysuwjHERLpRefopeqxtp+NwOQv9lgz6vCQkXNxbXeV7CJFyCL9sW6J4qrDJaKrscZEaX7ChvvqfX4bk+Bpmz6aUohEndcqr04Xm64+IoVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4jz3CDYg; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc60ef3076so10500805ad.1
        for <kvm@vger.kernel.org>; Thu, 25 Jul 2024 11:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721931569; x=1722536369; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+cWinSd71QUFpeng6pkfteDp9R+YDOSFKPyk/5CKIQ=;
        b=4jz3CDYgnbX66UdDS5vj6bDN9m1+8C6pvFDrGymgpok0XBtnjzpBxKJ1p5706qSGI9
         ZiGnksugtzi5psMDaKn3yQEX4tsMe/c3ganC401oIcJjoMvXvt0LWakHkd9puCGRtI/r
         Mrw4l5fh9BYfW/NopviizdjgFGS2GkG/MbAoRgSUJ7xV/G7mnxsOKWmSEFsaWUm8I+Ao
         A7Y+txGrX4pCdqjXO4JjBXRdDKql786IIH9GZ8eMgxpnA/kkBuCSCj4PhLqUxh7SzxXh
         3HAT3DkjPd3o/pLocircC1SpjoLDTjqCp3juBOEJyq0yV4LnJ4QFqxxc/TdJcUSwm0Gq
         NVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721931569; x=1722536369;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+cWinSd71QUFpeng6pkfteDp9R+YDOSFKPyk/5CKIQ=;
        b=HqZNMWaa19kRVbLxHGJIr4N2OokeL3CyIPxU+1hOyyVi4XG/Gn3kg+CwFz8z5rstto
         HcJ/I+l2FHFQ6a53yLHUFfwgGGfzxLwHu8eX14KnAaUUtN8lDhqIHdM+hfRhfJ+Ry3ZI
         fNuPfA8Jph+qhWUWds4YBYVOVE2RTu9kPt+LfMzgtyb9himuP7RE+jmD+MMT+f2BxDcK
         5NVXN+qcuyN0n5OBA6k/8e8HSHWQOwWhF0IXWzAtXV5ZKRLatdBu9fuxFEt1RZqMcZHL
         J7W+a5lGHjRnqi7CKR8cEiJSjXE0/8s3yPPlc8BbaLnGtNWnAnhovRFhXrzrfjr08aMh
         a0PQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Iuj6zFPwl1bPegTNEZMVTXlFbebbf0ED0rRgMa4JiseRxfdMkPFEP3TQR0KDQntMf7JUSjEImMjfL+8o3v9k2BfV
X-Gm-Message-State: AOJu0YyPbrVXare4jhZ5KgImj4INDiqeHH82ON6s6toF8SocpzsDU5u8
	syZOHQZWxgdugenLi4T+uuQCFQe5R8fDiL4VKrbDtrecwgkJfYd1rinW3AWYkql/JHijIe0NSLm
	peGm+5H3iqVa0yg9Ki8brQQ==
X-Google-Smtp-Source: AGHT+IEq0/Qf2aH7olYk0jZU1lYwwK43xAQuSUsE/EQnG/wMgzk9gQAK1/L4A02IBfsH1aseVKWvPS3Vq/ZyFeT5Zw==
X-Received: from ackerleytng-ctop.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:13f8])
 (user=ackerleytng job=sendgmr) by 2002:a17:903:1ce:b0:1fa:acf0:72d6 with SMTP
 id d9443c01a7336-1fed909f356mr1844455ad.3.1721931568714; Thu, 25 Jul 2024
 11:19:28 -0700 (PDT)
Date: Thu, 25 Jul 2024 18:19:27 +0000
In-Reply-To: <diqzo76myc5x.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqzo76myc5x.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqzzfq55o7k.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [RFC PATCH v5 07/29] KVM: selftests: TDX: Update
 load_td_memory_region for VM memory backed by guest memfd
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: sagis@google.com, linux-kselftest@vger.kernel.org, afranji@google.com, 
	erdemaktas@google.com, isaku.yamahata@intel.com, seanjc@google.com, 
	pbonzini@redhat.com, shuah@kernel.org, pgonda@google.com, haibo1.xu@intel.com, 
	chao.p.peng@linux.intel.com, vannapurve@google.com, runanwang@google.com, 
	vipinsh@google.com, jmattson@google.com, dmatlack@google.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:


> Yan Zhao <yan.y.zhao@intel.com> writes:
>
>> On Tue, Dec 12, 2023 at 12:46:22PM -0800, Sagi Shahar wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>> 
>>> If guest memory is backed by restricted memfd
>>> 
>>> + UPM is being used, hence encrypted memory region has to be
>>>   registered
>>> + Can avoid making a copy of guest memory before getting TDX to
>>>   initialize the memory region
>>> 
>>> <snip>
>>
>> For memslot 0, 1, 2, when guest_memfd != -1,
>> is it possible to also munmap(mmap_start, mmap_size) after finish loading?
>>
>
> Thank you for your review!
>
> Did you mean "possible" as in whether it is "correct" to do munmap() for
> the rest of the earlier memslots containing non-test-code?
>
> It is correct because the munmap() just deallocates memory that was
> recently allocated in mmap() in this same change. The memory set up for
> the VM is not affected.
>
> <snip>
>
> If we are not using guest_memfd (region->region.guest_memfd == -1), then
> we need to make the source and destination address different by copying
> the contents at the source address somewhere else for the call to
> tdx_init_mem_region(). That is what the mmap() is doing. This temporary
> buffer then needs to be freed, hence the munmap(). Without this copying,
> the destination address for the ioctl's copy would be the same as the
> source address, since those very same pages are provided in the memslot
> for this memory region.
>

Update on this:

Since TDX requires the use of guest_memfd, this patch will be simplified
in the next revision.

The checks for region->region.guest_memfd != -1 will be removed, and
there will be no need to do any mmap() or munmap(), so those will be
removed as well.

> If we are using guest_memfd, then the destination address for the
> ioctl's copy will be taken from the guest_memfd, which is already
> different from the source address, hence we can skip the copying.
>

>>>  }
>>>  
>>> -- 
>>> 2.43.0.472.g3155946c3a-goog
>>> 
>>> 

