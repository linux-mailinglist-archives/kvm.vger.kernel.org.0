Return-Path: <kvm+bounces-65249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C35FECA1BD6
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 22:55:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4954307DC5B
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 21:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD432DC788;
	Wed,  3 Dec 2025 21:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="a2+R7bKC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA89C2D8762
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 21:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798658; cv=none; b=YqyJbrEZbTOy3lU/DTiUjfLcHUgdIyjOXN+O02cRktiKXZGLGhIhb4eH44ceorfv/Nq4lfBiYEXD/MXP/HdSrZ3+NvRdYkOYZrHXpJBT2ZuvUbRmNpLMDXGGDidri1gp3BhYSrDvff8JVe/jtsfG6k1KMbz8kww7tVJRTx7NbFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798658; c=relaxed/simple;
	bh=JHGfDUlew2CsaKlG5OfBOmRmtuZxeRpVwjd7Xi1XEPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnMLny6ERNOFCpoXJfVdyFjGvH2IrvulrUj90Sw1ho4tEgzopf8vKiPYpepId1MzXkyKnnjFFnmqOprVzb2inkGfjIORsUjo7WCNk9bDajr/brQjjsA/qyprOm6UuOVg6rbzVSakEdu0Z/mSq6xxA58cBiODR/aLWhTTGSFHtkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=a2+R7bKC; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88059c28da1so1703676d6.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 13:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764798656; x=1765403456; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u1L7bCsctlFH/rlCsw/yhcu41+Ux43nXuWYzbJSS1oM=;
        b=a2+R7bKCE2nkA0crp7a03nbUvz5d3llE3TTDCihjXmuS61A5e7v7n5UNdxjRpJpAXt
         8b4DYiHNkteYuPQFi21IQXV/LtwfRt9GjP4pAyziFNJ4CyneBdidNhwlwHWXK3I50efF
         dW+eyibzpUBjKs7jPAycoFXgSbYFGGuyxrHdi56IagSmIkho6Fa5TQhXA579ztB1lvk4
         L3u4rRwLbyy9qUUCy6J9vQUGFfecLnTTaHln/6kuJcCeaoFcuNTNjj+e4NNX3BtI9iRc
         x5vgZSQ/UVaCd19kv44jPMdkMMb93mVx1dJsI6HSy41WsGVnNNMf1YguOlyN67jFRvLB
         Cx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764798656; x=1765403456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u1L7bCsctlFH/rlCsw/yhcu41+Ux43nXuWYzbJSS1oM=;
        b=KB2LyEj6XmMb8ciG+WSlB9DkgPADGJqse8ZxyNnMespYkYfiEk2EdtZmjvDN38uHd7
         tWB0mmG+qlYzBT6z8ubics4fA3u3XEEnkUmgVwd9vArxg3Foc3akS9+1Y9II/EtNULUY
         JmXj5sDmAc7iYDJqix4pm9dw9SV+HFzfWzT74/MqU/gA7CB9CCSqSMhaJQnq1rBinBm/
         9d2ELTSsueAaGbrVI69lA6yv+vVbaCU1cxYPJjWEKyzR5z/zsT3d7Cb/0vLxLCk5bAeQ
         ZbM5fbIIqDtU9pvZtEweW0i6o8Vsj+EMuBeu8Kpsd2+fqtavmTxv/swEjsxa55y7Xp6t
         bsBg==
X-Forwarded-Encrypted: i=1; AJvYcCV5osy5D8obQJq58TJWm2LC/g5ZK3NdplsNk+WCR+ecpfhwIscI1tPgntUCkzQ60GjAXPE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI0ajxpOzxKEgHWET8xekXMo/Zc+r4kUT1xTs4TFcKL/wmceXQ
	JMMskQ+cQFReSrigErHJJ8DOR9snlTatOnJLXkHmc0bkDSS1WOU8DlC0oICWS6ucDuw=
X-Gm-Gg: ASbGncswmb4BfZ/HWR+/76ZE4JMPlhSFH7HzlcZ236HyDmsxAY+T4TCwti0JNxLqVxL
	D/dSChzJWBo6tTrQmoFSFReBbM3GtzRqHAo74S4/1Lf+vo3f2LWJUIi283BI93JxS+7cTpJpoYy
	KTdVLFEM5YOD+maIwT9aP712vBIxAbdo60BljGnR6FqCMNSa1VuXlnb4l6QBowKfJGr5M4OROkn
	oMBodAIbysFznkCDQpS/qHtrDXuZUbqhOWNCR1Rvf4qGj26JAavAtKotoe0Cg2ogeB7BmCl+rC8
	42WmqNoTr/UlNLZfK2YbDnkjt7/v4k7wD1Lbwget7zCqd46ai+ptCSb4A1v06fc4g1hiDC3MvFp
	fkrZGQZlkqDOJWKyPM05ucDBZeomhK8A7gJBpomIz6ZXdk7/BI4pjtDqBJgHs3qxw0kTN2TTVX4
	NOqX66WG/C5bEhDmTUMSp8Zf7T7g0=
X-Google-Smtp-Source: AGHT+IEwceVsLeU5TI95jujZXB37aK5lP0n1gzmGLbDcAQSJh4iH2YFhpUVYfybMssUZm1JTFXzafQ==
X-Received: by 2002:a05:6214:500d:b0:880:5389:a77a with SMTP id 6a1803df08f44-888195726c6mr64755976d6.63.1764798655692;
        Wed, 03 Dec 2025 13:50:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524fd33fsm134692766d6.24.2025.12.03.13.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 13:50:53 -0800 (PST)
Date: Wed, 3 Dec 2025 16:50:52 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, x86@kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTCwvKRoVGs89BVX@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
 <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
 <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b159c1-e07c-489e-ab9b-4d77551877f0@kernel.org>

On Wed, Dec 03, 2025 at 09:14:44PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 21:09, Gregory Price wrote:
> > On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 12/3/25 19:01, Frank van der Linden wrote:
> > 
> > Worth noting that because this check really only applies to gigantic
> > page *reservation* (not faulting), this isn't necessarily incurred in a
> > time critical path.  So, maybe i'm biased here, the reliability increase
> > feels like a win even if the operation can take a very long time under
> > memory pressure scenarios (which seems like an outliar anyway).
> 
> Not sure I understand correctly. I think the fix from Mel was the right
> thing to do.
> 
> It does not make sense to try migrating a 1GB page when allocating a 1GB
> page. Ever.
> 

Oh yeah I agree, this patch doesn't allow that either.

I was just saying his patch's restriction of omitting all HugeTLB
(including 2MB) was more aggressive than needed.

I.e. allowing movement of 2MB pages to increase reliability is (arguably)
worth the potential long-runtime that doing so may produce (because we no
longer filter out regions with 2MB pages).

tl;dr: just re-iterating the theory of this patch.

~Gregory

