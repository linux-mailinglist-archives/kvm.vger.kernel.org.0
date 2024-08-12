Return-Path: <kvm+bounces-23879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F11B94F710
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 20:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE0281F21B28
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 18:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0607818E05B;
	Mon, 12 Aug 2024 18:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SA/QspGr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1F318B486
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 18:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723489095; cv=none; b=P/RtAZzFSjKKaYXafqlcgUb0Yn5yLwYk5/5SAbT06P39COCyQF8cQ9dsDpO+HuzfSzLtAVYlddLuFaQ9AWT3GfpRXPz4P/fkT48rkNRR5I+5GMqskew/y/wTgaQJEOjErVMhltItJdEP9uc08i6qZ3aU0bD4kPtHqL8sE81jDEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723489095; c=relaxed/simple;
	bh=LfPOpidqehegUt+tof4iurxTgEAidoDbHKOZE2NlWB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mb6peutcXwnRVujSfhqCx2Y5DxnDxAc1gMtlshvYBY/NfJTsQ6oRulCYVJ2Z8P/+RKrbeLo/i1vTHbSqiK3P86L9N9kxcXlPskrBn65lxcWwud7dJRWth1llm+tAvOGtKgcGccJ4Gjtem5VUU34ituW2w+bc5g1olAVNlZKKl2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SA/QspGr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723489092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CS/foRtcZMYFWa8Ji2iV8cMwHHCfkc9T1S0QgRlZmIU=;
	b=SA/QspGrAn+5OeRX3LupCnXgZF37EB/xbzo+WF0BhiWbvxbpbBkW/DLTqcxPBYrkGSUS/O
	cGMUBeG3Esg1LMWRzwcaQitvdWTO8sFV21PZQUKz3uFwHa0AsfSffdvwuHS46W/Xg5KrOW
	T3MaUD2S5KPqZ1ec7a7+fek0gY01Jyw=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-sFqYjx5-N1efxbvdCBcsVg-1; Mon, 12 Aug 2024 14:58:11 -0400
X-MC-Unique: sFqYjx5-N1efxbvdCBcsVg-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4f51ae60628so190344e0c.3
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 11:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723489091; x=1724093891;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CS/foRtcZMYFWa8Ji2iV8cMwHHCfkc9T1S0QgRlZmIU=;
        b=KggBzVfpT8Wwfge2SfT3zTrUHoDZQ5pDt9MYfTo1MYVcd8HqeVigfnjGEU1mOFWzEe
         BKMxTwHgE3vZ80wa5pDSyM0g3ZHXuIk2B3862qq8t2VOnKjer0cAaAQavmJks4ocv05K
         s2+Ye87vsWu719MaERFEHnIEmuJ1lDNzzT1uX3lGI43/7KohmFUmUagWqWKK9lMOJiUw
         MfWhb/xvuztMI9IpEFjYwtqg9NbF9ACApgcKba+F9TjYGfMDiMNAswORuMhsYb2r9A1G
         HTJHhYFYREP72ftJNFaZxH2I+9d2bA2gD95IvXSVdNlPAutKXVsSLkZlVKhufleGUMfd
         9Q1w==
X-Forwarded-Encrypted: i=1; AJvYcCV5diRrNCywPfR5ZoyIb7F/n+BlzTFv9mc4IqlCxWGxjIQSdJC2VpggkKUYVM9Qe3cCe18=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQYhpU4+mEMvQ348gkxSqWO/cCXLFYyBbE/4HC5QPmJaSicrKL
	SdJXLJSCvcPUqu3PAPC75AvwB2qu358x9pGgdp+gr7L8hpBQOcRq1nyrYRY1cRKWsMm++73m1qD
	hejH+xXQs5yhnRMMqTj1ZXcb6Syk6cy6ABQyCIr7yIzm90RvQ6Q==
X-Received: by 2002:a05:6102:509f:b0:48d:aced:abff with SMTP id ada2fe7eead31-49743942d92mr923679137.1.1723489090931;
        Mon, 12 Aug 2024 11:58:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEepDCRiassfXhH0DrId4yrgbBwPcT6rwZlyon1JDzVmoNGkXNaVZAYMSjbHfXIwNLjo/ZC3Q==
X-Received: by 2002:a05:6102:509f:b0:48d:aced:abff with SMTP id ada2fe7eead31-49743942d92mr923659137.1.1723489090577;
        Mon, 12 Aug 2024 11:58:10 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-841367f32besm801295241.40.2024.08.12.11.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 11:58:10 -0700 (PDT)
Date: Mon, 12 Aug 2024 14:58:07 -0400
From: Peter Xu <peterx@redhat.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: Re: [PATCH 10/19] KVM: Use follow_pfnmap API
Message-ID: <ZrpbP9Ow9EcpQtCF@x1n>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-11-peterx@redhat.com>
 <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com>

On Fri, Aug 09, 2024 at 10:23:20AM -0700, Axel Rasmussen wrote:
> On Fri, Aug 9, 2024 at 9:09 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > Use the new pfnmap API to allow huge MMIO mappings for VMs.  The rest work
> > is done perfectly on the other side (host_pfn_mapping_level()).
> 
> I don't think it has to be done in this series, but a future
> optimization to consider is having follow_pfnmap just tell the caller
> about the mapping level directly. It already found this information as
> part of its walk. I think there's a possibility to simplify KVM /
> avoid it having to do its own walk again later.

AFAIU pfnmap isn't special in this case, as we do the "walk pgtable twice"
idea also to a generic page here, so probably not directly relevant to this
patch alone.

But I agree with you, sounds like something we can consider trying.  I
would be curious on whether the perf difference would be measurable in this
specific case, though.  I mean, this first walk will heat up all the
things, so I'd expect the 2nd walk (which is lockless) later be pretty fast
normally.

Thanks,

-- 
Peter Xu


