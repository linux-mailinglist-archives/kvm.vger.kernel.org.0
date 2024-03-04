Return-Path: <kvm+bounces-10802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC468701D9
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 13:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A401C1C221B7
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 12:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313F33D3B7;
	Mon,  4 Mar 2024 12:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LyiGJEre"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD7B3D39F
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 12:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709556824; cv=none; b=p+OBmSuu+ALYCDPXPs5KVE0Oq07TztGboFcA4M8x/Cb+irXZUcv0XQSv4SZW/caQ35yN1vI0CD6Xb66yYRv3FhksDdBjEsS1H8m50QYyl+9r06AkxLpYplb2PnHBogP+FBp5EKz1AY6xFPLTAtSzldZC9lBfOW1lu9qjCv9qHd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709556824; c=relaxed/simple;
	bh=vVz6xIL9tHiA2o75AS9tAoF1SmfRuNfI8s8famUamnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTRSiUWMglscZdl0ML0p4ckegDuFL6jXTM570EcM2DSWDXDpFrLs1jXRlsT3fu3i+EF5JSKEZ2SFkJU1ua127YlPv+2cOA7PmcsbkizYU9ThtiXP5B4ieiLQTL2th0hI9Gdt/9oGnrzLUyi8x6qI/tKEKTri49ZXJ5WhlU0xaDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LyiGJEre; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51344bebe2fso812079e87.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 04:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709556821; x=1710161621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyJk6hu3JJWbvReoDubwdKriDejEDiVT4W+9pXCxJ+E=;
        b=LyiGJEresGdDZ+YIIvyf+VXsYkGc/OljpySgitgfpNswnO3Cw/WGNkv4yzBn/C+Ca8
         XL6XzT0V8qBGreWh9fKs6qLBAELWyDIH4lTP8rQ7Tv+u9tHkjbaF0FCanEhuAnJh09KX
         WxSt6rnab3jdP2R+BRBbsKz+f2EVedyOHwn5Ae1akvCMhEQXAJ6/0rNGXpZgi9h02gNM
         /HS3PVUpNGXdV6mRGhlvH7EU3j+OW4Qd0J9KImJIVyfgRM1wSmn83nMe2yNCAZxLPlFG
         cCA3sVJNY5/XGXtRFxvenzBR65XRmfA/R1vHST8JUHVyBQKhkvbWUc8aEFVKp++yBxrz
         kZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709556821; x=1710161621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyJk6hu3JJWbvReoDubwdKriDejEDiVT4W+9pXCxJ+E=;
        b=sFqe4WwVXbHI2riDcYjG4Pe1KOPg1KSWiWSlx7ouMNlvh14Glixh87KNoep+stJbzU
         IwclmgqW9pWXxPJQR/4DkV0lYl9HQKSMno/J6lX7TcF1eauNHOsqfKwU5Anqm8KYeEdi
         y3TjlVm3MYV/AZ8nBWqNaz7bro+Fqz7L+H1mb8xnate4uwxoYFs3xELKrV29wj1lYG2o
         FEywLSaCARSn1JsWE9rZPd7yFJnEqF5YBKm7PhA/jo7+Yc2DomYPPlNgfBLu83l8IbUQ
         Y0Q9+THorheuPXZ4GdsYMrKdglzweHYurVAhWn2h8D/zdekLOUSMmC+SPJIm6GAmAMsx
         ujjw==
X-Forwarded-Encrypted: i=1; AJvYcCV3o8/8BXYL1cyEMQyqNELCBXU5P6CRhFZzvgzpyLCkENusWGMcJ7ePa/BmNyKWsgK6RhLzQrV1WhLto2KSfqImR+ID
X-Gm-Message-State: AOJu0YwqSkSvvdbEVYx5xm/XRk6bW0Mh/iNkzXI2k5SY191va2YXGUX8
	f5fT4ydH0x3AsX7iXYhnEi0PbHkwsyrZZ13HCQt7pmDDRduf5SAz20d2IHPAHQ==
X-Google-Smtp-Source: AGHT+IHtjqEhfl4jblKM5MgIY40eq1zkabY+65oqUKrKFxAD8VaMIS1dfXXB8O4itgb1+Pj3fW84dA==
X-Received: by 2002:a05:6512:b8e:b0:513:1f3f:3fef with SMTP id b14-20020a0565120b8e00b005131f3f3fefmr8263628lfv.1.1709556820493;
        Mon, 04 Mar 2024 04:53:40 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id d17-20020a056402517100b005671100145dsm2378285ede.55.2024.03.04.04.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 04:53:39 -0800 (PST)
Date: Mon, 4 Mar 2024 12:53:36 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Fuad Tabba <tabba@google.com>, Matthew Wilcox <willy@infradead.org>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, brauner@kernel.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org,
	keirf@google.com, linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZeXEUMPn27J5je8T@google.com>
References: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <CA+EHjTzHtsbhzrb-TWft1q3Ree3kgzZbsir+R9L0tDgSX-d-0g@mail.gmail.com>
 <20240229114526893-0800.eberman@hu-eberman-lv.qualcomm.com>
 <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8e6c848-e26a-4014-b0c2-f3a21fb4e636@redhat.com>

On Friday 01 Mar 2024 at 12:16:54 (+0100), David Hildenbrand wrote:
> > > I don't think that we can assume that only a single VMA covers a page.
> > > 
> > > > But of course, no rmap walk is always better.
> > > 
> > > We've been thinking some more about how to handle the case where the
> > > host userspace has a mapping of a page that later becomes private.
> > > 
> > > One idea is to refuse to run the guest (i.e., exit vcpu_run() to back
> > > to the host with a meaningful exit reason) until the host unmaps that
> > > page, and check for the refcount to the page as you mentioned earlier.
> > > This is essentially what the RFC I sent does (minus the bugs :) ) .
> > > 
> > > The other idea is to use the rmap walk as you suggested to zap that
> > > page. If the host tries to access that page again, it would get a
> > > SIGBUS on the fault. This has the advantage that, as you'd mentioned,
> > > the host doesn't need to constantly mmap() and munmap() pages. It
> > > could potentially be optimised further as suggested if we have a
> > > cooperating VMM that would issue a MADV_DONTNEED or something like
> > > that, but that's just an optimisation and we would still need to have
> > > the option of the rmap walk. However, I was wondering how practical
> > > this idea would be if more than a single VMA covers a page?
> > > 
> > 
> > Agree with all your points here. I changed Gunyah's implementation to do
> > the unmap instead of erroring out. I didn't observe a significant
> > performance difference. However, doing unmap might be a little faster
> > because we can check folio_mapped() before doing the rmap walk. When
> > erroring out at mmap() level, we always have to do the walk.
> 
> Right. On the mmap() level you won't really have to walk page tables, as the
> the munmap() already zapped the page and removed the "problematic" VMA.
> 
> Likely, you really want to avoid repeatedly calling mmap()+munmap() just to
> access shared memory; but that's just my best guess about your user space
> app :)

Ack, and expecting userspace to munmap the pages whenever we hit a valid
mapping in userspace page-tables in the KVM faults path makes for a
somewhat unusual interface IMO. Userspace can munmap, mmap again, and if
it doesn't touch the pages, it can proceed to run the guest just fine,
is that the expectation? If so, it feels like we're 'leaking' internal
kernel state somehow. The kernel is normally well within its rights to
zap userspace mappings if it wants to e.g. swap. (Obviously mlock is a
weird case, but even in that case, IIRC the kernel still has a certain
amount of flexibility and can use compaction and friends). Similarly,
it should be well within its right to proactively create them. How
would this scheme work if, 10 years from now, something like
Speculative Page Faults makes it into the kernel in a different form?

Not requiring to userspace to unmap makes the userspace interface a lot
simpler I think -- once a protected guest starts, you better not touch
its memory if it's not been shared back or you'll get slapped on the
wrist. Whether or not those pages have been accessed beforehand for
example is irrelevant.

