Return-Path: <kvm+bounces-52346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE5DB04518
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 18:10:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CD633A24F3
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7440125EF9C;
	Mon, 14 Jul 2025 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dtDmUiJn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62693244664
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752509228; cv=none; b=ASPto3VP5oCIFfES4cxw4/D7dcdXgCa8sK74yautZXvxfTw2A/LDa6RC0Xm/ria7Bk6HXZdXp+ZxnhjabvEBaZcc8KAucNDidffQqg9p22AXYE6S+EABUp/PUM0OqHr4lPj7fCyNz1gsVWCPFwlHZgK+TUAkJyPrJdTVyOM+81E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752509228; c=relaxed/simple;
	bh=1f5iDYyg7pFvvJ/f+ZcV3C9Q8NHQkvJ8PD/thQfBxmI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CwdLMvhABqAEVm/1yewCa511hkAtbThZmVqOiJY6NKUlJSIG02hbCBg3GNcqDq92xEkcR+y1AL99FFkE3sRjrLUdpOXbbSpYf+LuWRvo3oFvwN8Bnv0E5hxHG9P0LK1XbmcxmewPn5YKvkQXqwag4/Ca7ngY7MKSGXaPKlw9rJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dtDmUiJn; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31ff607527so3675911a12.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752509226; x=1753114026; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rFzCpjpnT5pu45+vfCTcQUDn2FG9971MD381M8S0XxI=;
        b=dtDmUiJnJqEvj+lm4CVz8ZsfWFgTxNJh7bGAYw5WhvcXg3vxd9Hn2tfVvSofQTMy1m
         YAVjRWQGTFlOZrQvX2nH8mR7nDFnYF6ulCxlW2feXoTih4jbuEEYGvDyKyMQsNJ3V6TH
         9nU7r4EDJTgRYmL46AAh5DFBZkt4yAH6ayyCHkh9ayKm7riA8wicVCU7kQIKw02tME7A
         Vudh2p1v6Vo/M4jOF5FECBGl87qQsH+o7oQL4aOMHCWa0PMebDz92PXa4XmquWNWFIR+
         BI2wAO5aG6MfJDbeA4ZVPSYL9i3Yxy/SQsVUrX8v7FRvn8vModxvfm9qrNsFEIyEFYC7
         8hjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752509226; x=1753114026;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rFzCpjpnT5pu45+vfCTcQUDn2FG9971MD381M8S0XxI=;
        b=QWGdvFPwa/cZJErp+FF+TJdPBXNhA9caxAPgCLLafhUpfa0zqTwUAsMg0E8u3Ms6oL
         ykXBo+bDunJfl+6se6hdMveh/I6KZdpe1zpVcRPH90OEwCfYsioT4YabMje/okBUErdx
         DLLdW60j7BL3+jGqbv9qJYse/D+g07C51TlqSx9Wtd/hqJjYdhUxRnFlAi13QuiOGVj2
         EmegNnDBABhgM1To7Uq5Uev387BtDiu5U3SClZAI1VQb6GNnCyJz05Mm7pk+XBztdZDv
         QuBOSCU99cCdAPEWQGK6ByZRUq81tb9/sZdLqpxwYwe9X0UJEr+JWQbiTYxQ+PBpFb0u
         oGtg==
X-Forwarded-Encrypted: i=1; AJvYcCUTAOZO849DtwAqD6Fu9oJcIVKmxqDQS6GWTPATkSOa+B9nfV3dR97Mj4rjW7xEWjHC6uo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzsm4xxGr2QzNvdldKGYP6eB2ii6sYvFKLF5eFSQZ+po3fjfisZ
	kelh79tyt12wt4wUwQe7BatDj8kWKSuEd4gbq/WqAT0qMCRQPapqX+ZEEBtlaWmz125J3BYk5Sc
	Tb604sA==
X-Google-Smtp-Source: AGHT+IHCYeit5S+pWxOmcaU6ohQE+H1ByFTKj1agLfLUmaNctvSV0h1usGNpUPqkAAVw0zRAi41zSasIzbc=
X-Received: from pjq11.prod.google.com ([2002:a17:90b:560b:b0:2ff:84e6:b2bd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4acf:b0:314:2a2e:9da9
 with SMTP id 98e67ed59e1d1-31c4f5922b7mr18899944a91.25.1752509226579; Mon, 14
 Jul 2025 09:07:06 -0700 (PDT)
Date: Mon, 14 Jul 2025 09:07:05 -0700
In-Reply-To: <c5c964cd-947e-43ff-9c79-18c1555aea8e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com> <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com> <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk> <aHUmcxuh0a6WfiVr@google.com> <c5c964cd-947e-43ff-9c79-18c1555aea8e@redhat.com>
Message-ID: <aHUrKWaixqJyhsUU@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, Michael Roth <michael.roth@amd.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, reinette.chatre@intel.com, 
	xiaoyao.li@intel.com, tony.lindgren@intel.com, binbin.wu@linux.intel.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, ira.weiny@intel.com, 
	vannapurve@google.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 14, 2025, David Hildenbrand wrote:
> On 14.07.25 17:46, Sean Christopherson wrote:
> > On Mon, Jul 14, 2025, Yan Zhao wrote:
> > > On Fri, Jul 11, 2025 at 08:39:59AM -0700, Sean Christopherson wrote:
> > > > The below could be tweaked to batch get_user_pages() into an array of pointers,
> > > > but given that both SNP and TDX can only operate on one 4KiB page at a time, and
> > > > that hugepage support doesn't yet exist, trying to super optimize the hugepage
> > > > case straightaway doesn't seem like a pressing concern.
> > > 
> > > > static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > > 				struct file *file, gfn_t gfn, void __user *src,
> > > > 				kvm_gmem_populate_cb post_populate, void *opaque)
> > > > {
> > > > 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > > 	struct page *src_page = NULL;
> > > > 	bool is_prepared = false;
> > > > 	struct folio *folio;
> > > > 	int ret, max_order;
> > > > 	kvm_pfn_t pfn;
> > > > 
> > > > 	if (src) {
> > > > 		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
> > > get_user_pages_fast()?
> > > 
> > > get_user_pages() can't pass the assertion of mmap_assert_locked().
> > 
> > Oh, I forgot get_user_pages() requires mmap_lock to already be held.  I would
> > prefer to not use a fast variant, so that userspace isn't required to prefault
> > (and pin?) the source.
> > 
> > So get_user_pages_unlocked()?
> 
> Yes, but likely we really want get_user_pages_fast(), which will fallback to
> GUP-slow (+take the lock) in case it doesn't find what it needs in the page
> tables.
> 
> get_user_pages_fast_only() would be the variant that doesn't fallback to
> GUP-slow.

Doh, right, that's indeed what I want.

