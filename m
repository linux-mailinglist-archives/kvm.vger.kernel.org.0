Return-Path: <kvm+bounces-13001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD11988FD9B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 11:58:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26AB81F26C46
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 073587D3FB;
	Thu, 28 Mar 2024 10:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ny3t1WEl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1CD52F6D
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 10:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711623526; cv=none; b=kUrwZBv3nXJhJ5VTUalQumi9gWDTXNQVKzNwgDQY2hM4+4ujiwJw6ZeStzY8wY1xEbZHgcmzuMHUC+59TmXc+EwWsP3QK5oyK8k6YFeqt1l7y5GpHRTPYNQRYGH9DXyAIZO3Ruju8jJWDxa81pvXx7+YlJcECmtIEQH9e39RELk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711623526; c=relaxed/simple;
	bh=Hm8+oqaD0aS6PphUmLMmLxgajrQub18PdQJLQkOrJ1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7yAtXSeOHOiOl2Fn4MRFBn54wcXFj2PgkjEgV6kqUv0RYclOqRa/LEVi0hneo6b/s0Dl6efQCfBK36+CFWFECM/j8HPKeTfBtuJx7NrO/UkJ+WBoWOcv9y7Cx3BrvRF2rqyYFsWactKQQDS1lpPeKQA86IQK6j5keiLsLn47zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ny3t1WEl; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-56c36c67deaso936487a12.0
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 03:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711623523; x=1712228323; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8ZQFWzPDIrF3CuMM0f5B0XY6jp3IE2F7J7SSG90F6E=;
        b=Ny3t1WElLOH/XL/dUPtFlLnkab6fBnxrtN2tCww4eEYhC3kuQ/SDu6IjqOy8ZTkqKE
         TGpsUJWYEULAf27NBsXMnH2+qEmmFI++fU6r6UgqT5oVSuhECZ4Jw0XWUKxktYWATf/a
         sg7RiJS/5Zzo6zovK2xJV/VbXhk3NOK6kc8iDV0M7WE0BSiALRoyECU43ueAXoNTJeao
         3MPdqVtOU5Y66LJKb1FIn8TdSnpI0xHAR6yGLcN7VJrFsUG+g/rKclFupthojf5MWgOP
         n46IZpRqvqlBg68THBGLV01BCSVom/vWC2ujNelMAjHVKF0iKHG7esre+9rc8JnTX1di
         KeEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711623523; x=1712228323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8ZQFWzPDIrF3CuMM0f5B0XY6jp3IE2F7J7SSG90F6E=;
        b=wr8qYkVuhQylRstXCRYGeFqYxYcvLVBHlXDVEsIQWu2QHLiDRwKjWq0eaG3OYUBLs7
         WTxWdpaGodfjjdTYEUpAcEejOCqK/8aMBIjOjcrmiSN3q6poVm6NIYGScDnjAR7zv3Zw
         EMSZy+miY+i6IgsZ8QGGYBa9LOssy0CU0rSZRISP0A/VSGSYC/FWmpzQFnDAgWhzfVVi
         X1EdhUqWb074JS3RWWyE3MdBX+/h4qcOpRxYt/vp0Z/8/Ceib8PYJjumLlSdMbmdppG7
         dC+M9W6AjXig6gwj3bd2dtHGVu7Z9447urhPUZDeuhRogpSMkzxsubYomAL24Y891c20
         w1dA==
X-Forwarded-Encrypted: i=1; AJvYcCXoqpATP0YchUqdfIE0Qt0j3tYhVFhNmeCEFTfbu0RxiDXZXGtRv5sdE8sl5ybqSVuAq48+GyQWqzAG/Z4EioqscwMf
X-Gm-Message-State: AOJu0YzNel7yczBfkpFiMD9eu+R4LEY3DkJ373VARL9PsDPp7pbTfxHe
	0N4LWkx501V41Nr9YpiarEboc78Og2AK07Xnb6PdDMzEFvI7bP101aQVldXbuA==
X-Google-Smtp-Source: AGHT+IFz6L7DUIGFP2Hr6sv1erUlly4EFBC5ORIiQg+IMjzxvFI79NB3IXUA7dV5PbKsHLbd6MH8KA==
X-Received: by 2002:a50:d5c8:0:b0:56b:a017:10e with SMTP id g8-20020a50d5c8000000b0056ba017010emr1602749edj.42.1711623522711;
        Thu, 28 Mar 2024 03:58:42 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id h7-20020a0564020e0700b00568e3d3337bsm686755edh.18.2024.03.28.03.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 03:58:42 -0700 (PDT)
Date: Thu, 28 Mar 2024 10:58:38 +0000
From: Quentin Perret <qperret@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Will Deacon <will@kernel.org>, Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	viro@zeniv.linux.org.uk, brauner@kernel.org,
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	ackerleytng@google.com, mail@maciej.szmigiero.name,
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com,
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com,
	oliver.upton@linux.dev, maz@kernel.org, keirf@google.com,
	linux-mm@kvack.org
Subject: Re: folio_mmapped
Message-ID: <ZgVNXpUS8Ku37BLp@google.com>
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
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cec1f98-17a5-4120-bbf4-b487c2caf92c@redhat.com>

On Thursday 28 Mar 2024 at 11:32:21 (+0100), David Hildenbrand wrote:
> ... does that mean that for pKVM with protected VMs, "shared" pages are also
> never migratable/swappable?

In our current implementation, yes, KVM keeps its longterm GUP pin on
pages that are shared back. And we might want to retain this behaviour
in the short term, even with guest_memfd or using the hybrid approach
you suggested. But that could totally be relaxed in the future, it's
"just" a matter of adding extra support to the hypervisor for that. That
has not been prioritized yet since the number of shared pages in
practice is relatively small for current use-cases, so ballooning was a
better option (and in the case of ballooning, we do drop the GUP pin).
But that's clearly on the TODO list!

> The whole reason I brought up the guest_memfd+memfd pair idea is that you
> would similarly be able to do the conversion in the kernel, BUT, you'd never
> be able to mmap+GUP encrypted pages.
> 
> Essentially you're using guest_memfd for what it was designed for: private
> memory that is inaccessible.

Ack, that sounds pretty reasonable to me. But I think we'd still want to
make sure the other users of guest_memfd have the _desire_ to support
huge pages,  migration, swap (probably longer term), and related
features, otherwise I don't think a guest_memfd-based option will
really work for us :-)

Thanks,
Quentin

