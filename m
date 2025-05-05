Return-Path: <kvm+bounces-45484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEE6AAACE6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BE081A835AF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1A483002B9;
	Mon,  5 May 2025 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSbfkM6J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CBC22F663E
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487082; cv=none; b=tpXbkCLFtubaHGqvQSG7CXx6/wI4FKw9QmOaI71VUsd9rwH47CL9hpjwwoJOH9491h7ry9l++YklcYsTdRG2aVT2wB5dXQW2WnMczTrrB3xdGB8K/Dt6EV4sztc46xxoFsh4bb4gVSDGxmMJGcI0mUnUEOqX8rT+5lziCgTFTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487082; c=relaxed/simple;
	bh=8ZrLOI3/k1STjvSE8FjnfiooIAW0suwqXfzGYLc3uAw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jK5eiD8LPdDPGefAxtucieJqaQN4POd2WMCH7NZ8qPEmsvL6x/1bGDVA51WNf2MYO6jveX6thKcM20RwhyyG7ciNEBpS23r4wnp6It7g8YD9FPvip8d0eQNmTbWYzYQr58x7X5x4SwXRr2dnHu2VzRXviyUs5TWmcoHgQQdteTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSbfkM6J; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-225505d1ca5so45674755ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746487079; x=1747091879; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp3hEaccs5KLjus+u7lZyGvplQzD1hJyVDYNNOcIobc=;
        b=nSbfkM6JLSISQKjDshCg9pN8pIzihq0mRaYyGffl36JcLy8OXR/MdPoCxr9yUQUVFG
         wppT7mBxe5o6cetBcYxvQ8S7XkXQ1qsHNwbWAi0M5WZK210SVqMdpa75IK58bbCMDJ9B
         50UkSHCmt1k3HrGxWzgdozyMwZGxDwnbfhwihvpE5ylzicGebvK0PBmrFit+HUzTLU/8
         UwwGhIqtNTDXaxkpVbKQTImpRO1B0CdwA0fYB1hTRLkGXgUFSsKzMdLVL3dXAVibp4qH
         rtGZmJ5s1qBk2ryGo6/K58np5H+gQD7rUvVq4YD76gPru4FZvfpnq63gvn0P+iaKOmkw
         xUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487079; x=1747091879;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tp3hEaccs5KLjus+u7lZyGvplQzD1hJyVDYNNOcIobc=;
        b=K0T/aZD+JIHf9J9FkrrzwVEBAK4b6iITvJyDAhsL1sBP7mbcsrsXCKCE0c1vYIES1n
         8Z2nMuJTDa23pN5s6kzX0N50RcGiD1OnDjwTjoUqajItl3AD6pS+v2O1On3BVyztMJlj
         QnvykRFs4ujGyMsZvsC3H8iuhRIcnR5wt74+yDMPrEeV8YVIC/7Ht3+tG9Ahw8pvDUC1
         +BHRoYUEHWXykj1fJnnKg5bsQZIuY+Lw7hQP2J5KcqjJSlbhf8yLTpd94tZYG/Sy3AFx
         IgyVby2wcx4dRXoTB4zgMeYxaHGDYM3fPVrMCuCCWlK0iqouk0k20VtlSHo8l0o0a3GD
         Ik9w==
X-Forwarded-Encrypted: i=1; AJvYcCVCMsfGR+5faqJaxkqDty1QPBBLjsXzxb/uytJWJWb93VbHzQhc4yXdQBY5gCIfzq/5jF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYiqnqrEOJ09PJeAfMGJSv1ZmTfkOr74TaN1xxgCoyL6miBoPF
	+gCq2WXeXtpPsNGzIO6cOBfPBCv4Hais5ZnBwRS5svaX/UlKCaRD8nl6SmxM+ArrTIhJYqPyEFF
	9Pg==
X-Google-Smtp-Source: AGHT+IGhrX1MtCaIusgQgNQRAcx+0E6rNYmRwUcmQ9PrQBY1+RE7Ktib/G6MWTeo5oHjCygbMWb2/Z516S8=
X-Received: from plv19.prod.google.com ([2002:a17:903:bd3:b0:220:cd24:457])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e18b:b0:22e:39f8:61fa
 with SMTP id d9443c01a7336-22e39f864c8mr6120915ad.34.1746487079377; Mon, 05
 May 2025 16:17:59 -0700 (PDT)
Date: Mon, 5 May 2025 16:17:58 -0700
In-Reply-To: <diqzfrhik62h.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <diqzfrhik62h.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <aBlHJvfnV1VPKQzW@google.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 05, 2025, Ackerley Tng wrote:
> > On 03.05.25 00:00, Ackerley Tng wrote:
> > We want to disable large pages if (using 2M region as example)
> >
> > (a) Mixed memory attributes. If a PFN falls into a 2M region, and parts
> >      of that region are shared vs. private (mixed memory attributes ->
> >      KVM_LPAGE_MIXED_FLAG)
> >
> >   -> With gmem-shared we could have mixed memory attributes, not a PFN
> >      fracturing. (PFNs don't depend on memory attributes)
> >
> > (b) page track: intercepting (mostly write) access to GFNs
> >
> 
> Could you explain more about page track case? 

KVM disallows hugepages when shadowing a gfn, because write-protecting a 2MiB
(let alone a 1GiB) page would be insanely expensive, as KVM would need to intercept
and emulate an absurd number of instructions that have nothing to do with the
guest's page tables.

