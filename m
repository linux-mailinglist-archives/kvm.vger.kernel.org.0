Return-Path: <kvm+bounces-10801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C82EB8701A3
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 13:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 780B5289C87
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 12:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16DA3D0A9;
	Mon,  4 Mar 2024 12:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CaMmA8rO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7A722606
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 12:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709555778; cv=none; b=Wx4kVdu+SUpvnY9854fs39F4LHglzoNawteYSkgvOfXNnlySavXtiGhfsi8H2ZGpqr7cDgahhG1/1A66MLTcTrL0H46XWTm/aT+ZYheA+FfMyMHPeifFHXqBR8qeWjkToknz0OFu6ssnhJdJJKLfdshjB44iGiKjCjOK6f91bJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709555778; c=relaxed/simple;
	bh=S+1AVOp60oQk0gYTiEn6/ihIAv3TjnXIhW8RcnH2AVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YBIdG1mnW80RAvAc3GSmp0rfqgL8cM0Iw4afkZu84l05b4k5yY/IfR43tl3G2oqcOoBUUioAbVhd0/SwW+OVPYNCPNZIXcXbO4224JVDmg4Uc+V6I8Fs84CMWw1nGsMR+C7CYkyJTq8uQagnUwLM1wTT3Don4/u9wKvApaiTJVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CaMmA8rO; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a28a6cef709so720196066b.1
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 04:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709555775; x=1710160575; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2tCjt8GyebtBYI2Xvz8sUiEyWim1o0bzRB2XeH8koPM=;
        b=CaMmA8rO6PaPGqjiUqPGhF8Sj4smGJcFj2MaAjS5MSLnGxuo4dADhzb0oX79dY3+6/
         GFWQZGPT+vucBjyA6mBseK/Dn2BtY7pDOttE4OxjNiHr9ADMNuSjqPlFSzfZQkIxOsk3
         XKAbkWUhRgOtW03i6Ne5lWsKIz+HHibz+dhhzeIe+xSeESN3oUBa0Jfk9GeW+uRwI5TJ
         yxRolo1PBRelWhIwfyOo5fcWAXvlO0whx3eH74DFLEAJawlkOs268rlQorO2YCo6oYnz
         WKoU9w3EcOiM3REVHrF46z6hY00rWmCp7VdIIZTRComiB1DnB1TefER0+GJX/Hpv9HR8
         XpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709555775; x=1710160575;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2tCjt8GyebtBYI2Xvz8sUiEyWim1o0bzRB2XeH8koPM=;
        b=PQFwgLL7tmzMuTmd/S8ZHrSqfa7VuoLsl38xEdrlSbiG4kXvfA5co4gkNF42d/j8WS
         9SZEku9oRv2Pq5HnacL94E0nBqEhxXP9N75Sd7vQddxnCx98g1azAggBNB9j+jjNPeSn
         aD2R4CCQsniqXoogblbFEJofpVsu0+720pFtgddQ7cV4RQ//S+a7zzz24VCaTuf+TnHQ
         bAqDsklawV2CFZ02/QDI7yRzsZnsR4FmcCvsC2AiCyW9g/hcDkiEK3RmS6HVbcZeMSzA
         +i/9DycoBhZYo2g475NEFhi8hXhMzuYtNTPhrBmza8Xbg6Rimj+0k/2RwiqFet2MIwB3
         oYqQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+sf5sLPUG/wzlhe6iRiHJRCFmjyZZXfMeVprrGP/AlZi8ga738CRUVEfVhnVMLKLZ7DuK1HkmINEqf4+nkl/w+F2r
X-Gm-Message-State: AOJu0YzqfknhwW/FXUVM+reoPN1huJNTehv8Y1Jtsw0U+y79M77+YiIC
	1reJT0db2eFdU/Ul9hWZvAcSGRB9GWR73jbVFfhev2EDuQccSjxHUGBycB0UFw==
X-Google-Smtp-Source: AGHT+IF1Zf9BQZ8KhCs5HjLIj2UtmVes7lW/uaj/8C5cnvF9YC3mnsB1KcFgOCmmOgM4AgU2QoLqYg==
X-Received: by 2002:a17:906:a2cf:b0:a3f:33b2:5ce2 with SMTP id by15-20020a170906a2cf00b00a3f33b25ce2mr6696648ejb.35.1709555774688;
        Mon, 04 Mar 2024 04:36:14 -0800 (PST)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id j11-20020a170906830b00b00a44c723472bsm2910061ejx.57.2024.03.04.04.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 04:36:14 -0800 (PST)
Date: Mon, 4 Mar 2024 12:36:10 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
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
Message-ID: <ZeXAOit6O0stdxw3@google.com>
References: <ZdfoR3nCEP3HTtm1@casper.infradead.org>
 <40a8fb34-868f-4e19-9f98-7516948fc740@redhat.com>
 <20240226105258596-0800.eberman@hu-eberman-lv.qualcomm.com>
 <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>

On Thursday 29 Feb 2024 at 11:04:09 (+0100), David Hildenbrand wrote:
> An alternative would be to remember in pKVM that a page needs a wipe before
> reaccess. Once re-accessed by anybody (hypervisor or new guest), it first
> has to be wiped by pKVM.
> 
> ... but that also sounds complicated and similar requires the linear
> map+unmap in pKVM page-by-page as they are reused. But at least a guest
> shutdown would be faster.

Yep, FWIW we did try that, but ended up having issues with Linux trying
to DMA to these pages before 'touching' them from the CPU side. pKVM can
keep the pages unmapped from the CPU and IOMMU stage-2 page-tables, and
we can easily handle the CPU faults lazily, but not faults from other
masters, our hardware generally doesn't support that.

<snip>
> As discussed in the sub-thread, that might still be required.
> 
> One could think about completely forbidding GUP on these mmap'ed
> guest-memfds. But likely, there might be use cases in the future where you
> want to use GUP on shared memory inside a guest_memfd.
> 
> (the iouring example I gave might currently not work because
> FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> details)

Perhaps it would be wise to start with GUP being forbidden if the
current users do not need it (not sure if that is the case in Android,
I'll check) ? We can always relax this constraint later when/if the
use-cases arise, which is obviously much harder to do the other way
around.

Thanks,
Quentin

