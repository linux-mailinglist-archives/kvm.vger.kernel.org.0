Return-Path: <kvm+bounces-51360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8195AF68E3
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 05:54:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4354E2A79
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 03:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD73B23ED5A;
	Thu,  3 Jul 2025 03:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GP8I1bfb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70029233D9C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 03:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751514875; cv=none; b=cflcedPj3JE6F1Wl6b2jQhDnZCpVdPoO0Bxlt/vZupqCK80c/7/F9sUOgMG4RqCV9v2Rtb4x12nklYGVpTdi+F8zlK8/WuLKoUnHiwc+LwC+f9w7uh6jfN+Uwgcdf+bwtHulSj8FIAo3i7GjmXqaF9RdiKySUINEraN4EzxJXdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751514875; c=relaxed/simple;
	bh=HHfHW5GhdKi77KdDlkccgY6Pi8ovtd+IN5UHjbuu1Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdEdgOGMx65QQZ37MG2K4MFDlXYh8ngCe71h/uWwuTbA3NoUfvjWwTRg8a7zpHRolu8/yW/7aZ02FJcHbSpJ4qEVjA8z04u2lOog4mB/SCzFJ8aQUJPOOaRh09n+oggwP0PNiafzeDpDLwz/K8tFZbFuIkSpDBeMtvLWMnlbFPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GP8I1bfb; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-313a188174fso455994a91.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 20:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751514873; x=1752119673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I2iq5gFZkiJ1lOjd6+JzlpZeux9dqvre0Y7nukAvnik=;
        b=GP8I1bfbuwfQpX7tvplZH/w4HLYufvZvgcV4Gs4CRA4Xq2Yb4OY+TpNTEgx1dyIrnN
         2T10H0JHOwl+t2tURJhAf4ZD28KjdDn+xQ6aJmui9WwrdFjv1jjn6MO0M+yhbyZDyJfR
         090yEwgzW7qfr97I3oyXP2RB9sYe6DODdW8y3zjZt9mAVN8My+iYC+DNBLFgcuxE+d/e
         FcjUikG52GrjLlH9Bh6MaIEw0f/k9YC6SBxxlrKzoLByo/9QqWlMnZ0rq4fMcZrMdQpa
         Zf2TVMmDqLmq9fwin8o1AUx8COuHdElulXgrJaAiSCfiM9V1+jupdiMGGCiz22v0FPoA
         H6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751514873; x=1752119673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I2iq5gFZkiJ1lOjd6+JzlpZeux9dqvre0Y7nukAvnik=;
        b=gt+rGTGo43YKWtHeVAB6BDi4lwyDppYiT+Q72Dn8hl96xAe8xf3v4VCOX7Mmvpt0ju
         p2g78d61f+BkZVsm74pHOMwYI3s5ioZaBMDeCCNFaifTKIZbymSi3PyBnYofon7dedUQ
         Nuh2tpTFdNnZuSsClEcQRgWA363wEDsnTPlhACVhKFu6lGdIEDPvApKVoczQWwla0l/X
         x4dgxxtu+RkvuySXXdCyu72TqaA0Jzvihk2Y3XwbTAeQ1vGq/s9OEHVEGrkyyklg4uhc
         nUMIcKN2UdKtKuSAnI91NDXsg9RgSmhVF3kcJCkE12QXvEe46kwaXRE81trhgx0mbxcb
         6wcw==
X-Forwarded-Encrypted: i=1; AJvYcCV7rDEatXOFP2Vc0P7LHY7GU1309pkUTeyZNHZj+C9myrSEYhB+hYpOEgJ1oJ2XwwauP9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4xAx2mFfRWaYlasIaGVRUtJ20fzfpePFzutoxgLL03A/6cgPJ
	DHnMlhf/FOtBIbMCnOL1wbLS7rvq6PWS+ERd+wfwPguuW9q7/tdroPMSCry8CG7O5/I=
X-Gm-Gg: ASbGnctXdwNFfaMp2tHf1/Ac6iN1ObfDhx+mFu8pLywNY2ouLepgAjShCF5Imh59/Yq
	1A0VXV5iIrPHWxzOWNKj+JOaTpOuxFrGsE5Spvq1F7d1ZKD2dFlmhyZFDLJhioWIIuuA2AsjC11
	0+8AKzdCN9IFffLpHUZwRIDUJDRSOfGZWlRBXSqOMza4seU/uRFVz/s5+X65UvlhHWQvaOnsYa9
	Div3m6IpTx2akm2/hR2Nn8s2H9tT0ZPHPj4GIXvSMRqwoLx+oe2GnPZ2rdDqn47XGh9ICiFUbXe
	hFcuK+P+pgR3942oCsHb/7JlV30rvrMMrUNAG/yIipNPr+Gzq0ERpbj4g5sTDQkwD6oDcoMj5iX
	M14/NfBbTqKuR
X-Google-Smtp-Source: AGHT+IGfcRtMRByBzZxTaFRUHxC3xpANXdzXNyeVyJ8yNcQnBA/HItQ1vM7lHolX3Koa2U1xbxfF/g==
X-Received: by 2002:a17:90a:d44f:b0:313:d342:448c with SMTP id 98e67ed59e1d1-31a9f81fad5mr831350a91.17.1751514872547;
        Wed, 02 Jul 2025 20:54:32 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a4904c9d3sm3382238a91.0.2025.07.02.20.54.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 20:54:32 -0700 (PDT)
From: lizhe.67@bytedance.com
To: david@redhat.com
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	jgg@ziepe.ca,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	peterx@redhat.com
Subject: Re: [PATCH 0/4] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote() for large folio
Date: Thu,  3 Jul 2025 11:54:25 +0800
Message-ID: <20250703035425.36124-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
References: <c1144447-6b67-48d3-b37c-5f1ca6a9b4a7@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2 Jul 2025 11:57:08 +0200, david@redhat.com wrote:

> On 02.07.25 11:38, lizhe.67@bytedance.com wrote:
> > On Wed, 2 Jul 2025 10:15:29 +0200, david@redhat.com wrote:
> > 
> >> Jason mentioned in reply to the other series that, ideally, vfio
> >> shouldn't be messing with folios at all.
> >>
> >> While we now do that on the unpin side, we still do it at the pin side.
> > 
> > Yes.
> > 
> >> Which makes me wonder if we can avoid folios in patch #1 in
> >> contig_pages(), and simply collect pages that correspond to consecutive
> >> PFNs.
> > 
> > In my opinion, comparing whether the pfns of two pages are contiguous
> > is relatively inefficient. Using folios might be a more efficient
> > solution.
> 
> 	buffer[i + 1] == nth_page(buffer[i], 1)
> 
> Is extremely efficient, except on
> 
> 	#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> 
> Because it's essentially
> 
> 	buffer[i + 1] == buffer[i] + 1
> 
> But with that config it's less efficient
> 
> 	buffer[i + 1] == pfn_to_page(page_to_pfn(buffer[i]) + 1)
> 
> That could be optimized (if we care about the config), assuming that we don't cross
> memory sections (e.g., 128 MiB on x86).
> 
> See page_ext_iter_next_fast_possible(), that optimized for something similar.
> 
> So based on the first page, one could easily determine how far to batch
> using the simple
> 
> 	buffer[i + 1] == buffer[i] + 1
> 
> comparison.
> 
> That would mean that one could exceed a folio, in theory.

Thank you very much for your suggestion. I think we can focus on
optimizing the case where

!(defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP))

I believe that in most scenarios where vfio is used,
CONFIG_SPARSEMEM_VMEMMAP is enabled. Excessive CONFIG
may make the patch appear overly complicated.

> > Given that 'page' is already in use within vfio, it seems that adopting
> > 'folio' wouldn't be particularly troublesome? If you have any better
> > suggestions, I sincerely hope you would share them with me.
> 
> One challenge in the future will likely be that not all pages that we can
> GUP will belong to folios. We would possibly be able to handle that by
> checking if the page actually belongs to a folio.
> 
> Not dealing with folios where avoidable would be easier.
> 
> > 
> >> What was the reason again, that contig_pages() would not exceed a single
> >> folio?
> > 
> > Regarding this issue, I think Alex and I are on the same page[1]. For a
> > folio, all of its pages have the same invalid or reserved state. In
> > the function vfio_pin_pages_remote(), we need to ensure that the state
> > is the same as the previous pfn (through variable 'rsvd' and function
> > is_invalid_reserved_pfn()). Therefore, we do not want the return value
> > of contig_pages() to exceed a single folio.
> 
> If we obtained a page from GUP, is_invalid_reserved_pfn() would only trigger
> for the shared zeropage. but that one can no longer be returned from FOLL_LONGTERM.
> 
> So if you know the pages came from GUP, I would assume they are never invalid_reserved?

Yes, we use function vaddr_get_pfns(), which ultimately invokes GUP
with the FOLL_LONGTERM flag.

> Again, just a thought on how to apply something similar as done for the unpin case, avoiding
> messing with folios.

Taking into account the previous discussion, it seems that we might
simply replace the contig_pages() in patch #1 with the following one.
Also, function contig_pages() could also be extracted into mm.h as a
helper function. It seems that Jason would like to utilize it in other
contexts. Moreover, the subject of this patchset should be changed to
"Optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()". Do
you think this would work?

+static inline unsigned long contig_pages(struct page **pages,
+					 unsigned long size)
+{
+	struct page *first_page = pages[0];
+	unsigned long i;
+
+	for (i = 1; i < size; i++)
+		if (pages[i] != nth_page(first_page, i))
+			break;
+	return i;
+}

I have conducted a preliminary performance test, and the results are
similar to those obtained previously.

Thanks,
Zhe

