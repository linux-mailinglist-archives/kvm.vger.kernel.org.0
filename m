Return-Path: <kvm+bounces-40263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A398AA55255
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 18:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60AE21895449
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 17:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62FE223DE85;
	Thu,  6 Mar 2025 17:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LpnL/EVa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB06214A61
	for <kvm@vger.kernel.org>; Thu,  6 Mar 2025 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280709; cv=none; b=Ptrx1qf9C6KKFT3AoZXRX7rXaWyY0vX7TIJgLEgMmjuVqStanWCOsOeRuUdRj9cPVFF+ERnNQKQ5slt+tbqSLtK+1vOHayK/boyYBhSZMK8+vJ0PBIKhg/XzkRFCXYDqAowD+pMsyM4YjrRxb4z4kbxM4MsOECAceYp80IyLhfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280709; c=relaxed/simple;
	bh=0TbGvAi25znYdsV6DrzBbJgUWZR9FrTaPLtTPs8pfas=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=VwGdzvM3nhOGXC6BRkxkkVL7izSEhSaFnLwmaVe25h+CBMk8fv9xAWyZJAhCI5da6BLR2oxxdYR5JbXKhK5k0akmDPCG39iwA8XvZDA07Jvu5Z2So3vTY6l/D0eJWxySFzf8VIbSLsbmW80ArsQdx4IEz6ekWxUm26SF8MJfOCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LpnL/EVa; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22326da4c8eso14263235ad.3
        for <kvm@vger.kernel.org>; Thu, 06 Mar 2025 09:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741280707; x=1741885507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UBGGuWkfwJDEP8JICjorkuShOBnMiDySj/3tcxlcwyU=;
        b=LpnL/EVaJVEf8QlrtG/yO0K7ZZWPQsS2w39bf48+mQRFbHQ02jzVAf8feAinGB6YzW
         WncierV/EOsmTNOXxzI7Ssr6pkrN8aWDrVuCwgqycF7oyITbxdBml1ZjNfX3IaITO+ci
         C+v/YJNpIt3vd5miQjkomk81zVvza87J8U2gZix+c8Mr43q6hHkQk+YYPvm7nqm4v8Ky
         GOntMdsxdpKzvOHwNr5+WGBEu/x0PGDaLG5Ac3iYCR/Qf8OhzIVoT3l8IlTLFT5E8yfG
         to6DZbtkiA6c2HdyD/f5lx9FGoGxwjq9Xe2LSsG9PhkoZ3m5CrkJQ+VI4pq5mkej8aMH
         1AZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741280707; x=1741885507;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UBGGuWkfwJDEP8JICjorkuShOBnMiDySj/3tcxlcwyU=;
        b=pWOWRs1ZeiqGrMliTbR1R/sD77D1l83DmFWLBAVn8F/FfeS6ftrmroOQKX8eDuHJp7
         O6tPQP4902ATpm2Cet4O15OQeOwGrMJiXRL5iF4z6o0EBt/6orW0XNH/Whb7QgFLqr2L
         BjSiaiDEo93AIn9uqbOxwhZacAR8ZyM237k+bUh54vIIwxufZAtzdQNBTBzlji6S7vI+
         qGAC59yylTbaNs4Efo/2Bbzq+I8IxyKFDGhjIpNI4gzAqIbwkxUK9phhXIkVaVFSmQSX
         Inb/+X9v09lt1xfSgp/y30X33Li7tbDUv6wzTvDo9eu2vUV8Bb7v4nNkg6S/D/iK8LGZ
         G6EQ==
X-Gm-Message-State: AOJu0YzWINNM3g333V8Y1UYliaY1+IJKgQcmsl3zgWbLgGITjm7tvi8I
	W32w8yVxsFuetOKgmQTDmPL60HHe/qol1CdlMeVmYm8w6VwzGdwT/TEKuAdjARgdHEyXQHqGiyv
	b7PpP7T0m3UfYw2YQrEFL7w==
X-Google-Smtp-Source: AGHT+IFoOKAm2bACytw9HdRQCiXTJnTeA8yt2RPKHM32xjbYRVD4WpsCIaShzruZ4wuBnCGpIqUkT7Xl3oKqgVJ4eQ==
X-Received: from pjbee4.prod.google.com ([2002:a17:90a:fc44:b0:2fc:2b96:2d4b])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:fa7:b0:223:44dc:3f36 with SMTP id d9443c01a7336-223f1d20e6amr134836815ad.43.1741280707329;
 Thu, 06 Mar 2025 09:05:07 -0800 (PST)
Date: Thu, 06 Mar 2025 17:05:05 +0000
In-Reply-To: <CA+EHjTzOGuCvN91WS76Bx1dBOQNxv+Tqz=gTc85bVvjCrF0hyA@mail.gmail.com>
 (message from Fuad Tabba on Thu, 6 Mar 2025 08:48:41 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzikomt7i6.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd() pages
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"

Fuad Tabba <tabba@google.com> writes:

> Hi Ackerley,
>
> On Thu, 6 Mar 2025 at 00:02, Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> Fuad Tabba <tabba@google.com> writes:
>>
>> > <snip>
>> >
>> > +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
>> > +{
>> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
>> > +     struct folio *folio;
>> > +     vm_fault_t ret = VM_FAULT_LOCKED;
>> > +
>> > +     filemap_invalidate_lock_shared(inode->i_mapping);
>> > +
>> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>> > +     if (IS_ERR(folio)) {
>> > +             switch (PTR_ERR(folio)) {
>> > +             case -EAGAIN:
>> > +                     ret = VM_FAULT_RETRY;
>> > +                     break;
>> > +             case -ENOMEM:
>> > +                     ret = VM_FAULT_OOM;
>> > +                     break;
>> > +             default:
>> > +                     ret = VM_FAULT_SIGBUS;
>> > +                     break;
>> > +             }
>> > +             goto out_filemap;
>> > +     }
>> > +
>> > +     if (folio_test_hwpoison(folio)) {
>> > +             ret = VM_FAULT_HWPOISON;
>> > +             goto out_folio;
>> > +     }
>> > +
>> > +     /* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */
>> > +     if (!kvm_gmem_offset_is_shared(vmf->vma->vm_file, vmf->pgoff)) {
>> > +             ret = VM_FAULT_SIGBUS;
>> > +             goto out_folio;
>> > +     }
>> > +
>> > +     /*
>> > +      * Only private folios are marked as "guestmem" so far, and we never
>> > +      * expect private folios at this point.
>> > +      */
>>
>> I think this is not quite accurate.
>>
>> Based on my understanding and kvm_gmem_handle_folio_put() in this other
>> patch [1], only pages *in transition* from shared to private state are
>> marked "guestmem", although it is true that no private folios or folios
>> marked guestmem are expected here.
>
> Technically, pages in transition are private as far as the host is
> concerned. This doesn't say that _all_ private pages are marked as
> guestmem. It says that only private pages are marked as guestmem. It
> could be private and _not_ be marked as guestmem :)

True, didn't think of it this way!

>
> I probably should rephrase something along the lines of, "no shared
> folios would be marked as guestmem". How does that sound?
>
> Thanks,
> /fuad
>

Works for me, thank you! 

>> > +     if (WARN_ON_ONCE(folio_test_guestmem(folio)))  {
>> > +             ret = VM_FAULT_SIGBUS;
>> > +             goto out_folio;
>> > +     }
>> > +
>> > +     /* No support for huge pages. */
>> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
>> > +             ret = VM_FAULT_SIGBUS;
>> > +             goto out_folio;
>> > +     }
>> > +
>> > +     if (!folio_test_uptodate(folio)) {
>> > +             clear_highpage(folio_page(folio, 0));
>> > +             kvm_gmem_mark_prepared(folio);
>> > +     }
>> > +
>> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
>> > +
>> > +out_folio:
>> > +     if (ret != VM_FAULT_LOCKED) {
>> > +             folio_unlock(folio);
>> > +             folio_put(folio);
>> > +     }
>> > +
>> > +out_filemap:
>> > +     filemap_invalidate_unlock_shared(inode->i_mapping);
>> > +
>> > +     return ret;
>> > +}
>> >
>> > <snip>
>>
>> [1] https://lore.kernel.org/all/20250117163001.2326672-7-tabba@google.com/

