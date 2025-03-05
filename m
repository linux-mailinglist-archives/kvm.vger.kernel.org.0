Return-Path: <kvm+bounces-40182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2339BA50C8B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 21:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C15E3A9324
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E95825742B;
	Wed,  5 Mar 2025 20:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVMpXpZ/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3D1256C96
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206566; cv=none; b=mU5NNgbJAoJFcMXu7snvg5W6qmIpAGIah0vcug/5iG+hAWNOQaCojRyry6X4C8PKyZ2Wo494LbXMchJd6+dH/yHITB7WPAWtMzY5qrwj08MY0Q5xRTq3yMFfuwMl/uKcbGamDbb3JvSA4QqBeaKaxh6ugcz8kyF+f/ibWs1zdP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206566; c=relaxed/simple;
	bh=2YVWFyfkS3CQD7maRiKkuIwzWsd29P7CBa7g4mJPku4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HhUNUWfLFOp32kBQ86QxsUJ7nHRMcrikMUNFhSa6xL+aFHeGanN0BmBrmRlkS7KxJkphWkAbZIEeiZzQckx+qJ82/+L4rgb1PG+0rTcee1OnJsJIb/HIRkBCa6Bx28zA45LvvdqZfJ0jeQb7NcIamIUFNBjjFpR12J3+YlV43/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JVMpXpZ/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741206563;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oalwxEzZmbkO3BEyiEOSG53V47EPWxAbwPV2MRYZBwA=;
	b=JVMpXpZ/DndCfCWriD2L12bVh2sJwWa0L7oO8mrn5t51PUbpABztdelvpHF73I3ZrYbTFM
	KIz8fs6Q+pTY7dzBrJMhZcPHZG0NwEDupAPUgSF6c+iRQbnyADgQg3C0q6HpPybcy+lHBA
	8uLtB7iTnTxFpJlyEXFPmxzAvzuv1+0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-BgHXWxQ2O6-9ipULTcZC2A-1; Wed, 05 Mar 2025 15:29:22 -0500
X-MC-Unique: BgHXWxQ2O6-9ipULTcZC2A-1
X-Mimecast-MFC-AGG-ID: BgHXWxQ2O6-9ipULTcZC2A_1741206562
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6e88964702cso25181746d6.0
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 12:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741206561; x=1741811361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oalwxEzZmbkO3BEyiEOSG53V47EPWxAbwPV2MRYZBwA=;
        b=quxNyrieZCl0dA3nJSLaPrFl6vhBhfuys+zQzQ9O3yiIGxDc0d4oZEx6/ZklEIoHZ+
         q/z3rKiJgebfpMhWp3XXliW42vEIaOjBoqLKfv8cM12zn2uyn/55UicIiHFIblaYiTs6
         UJr6L2CeolTCW/trTrriddU6UhsKWE+RHm3LfSq7hxJ+wYDx6+Tq2Zpr0g5geJiUgXJm
         Sn+LSJs7l5W/PVdrFq2qptZs2J61o/pSQIZ1HMrKLLeZRu7yjOTNGfRD86dEeJXoIet/
         cIEIw5SgtD9pg600Fr8neOqtitBHvF2+SWd5XqUjVHoxxvej9zTOccY4nHgoUnIl7mZo
         atWw==
X-Forwarded-Encrypted: i=1; AJvYcCUXhEMqXMPVdtcxBP5ZUaJH8I+0rq8GXilnS/6c0JiZUOjKV8359XWGL5Q6w4JV4wnqt3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzH90r9G45bV01zFpo7TnjzN+0+ZX4NO0TcEoG7rMv3xLLLg27+
	uXi7ftHK+OhGJi000lSkimEi0LaQUcNCgCXLQ4wRS0pOHn184RJ9uyuilq4MdBayFQ9PXNntJ0b
	9sNcQClwGpWLTDbJejxmLbkgl7NuTY+9gXyEMbAxPVAGyvAe0J6mw0FwF9w==
X-Gm-Gg: ASbGncuNOsKlbLu7WM6Az7cHToquvyF6mN8ieOUQ9mrSL/cI9P8II1wHieknoYOhor/
	nfCE27oNl2LFx8pxWbv9JGpCUQ4FAmwmVi5ebCmULGeutF0YyL2bTQ3wN3qQv/6CuMGHNzs9QBK
	sM69igvjuTDVl/POK5/Uf/fWXptl9kO83HG+B6A5U0Ykh3Bgps+1aOwMooQx1x2cw5KXPVHWWUS
	V2xYKG49zuomkMbfShZEnpwUpDva+Smj+8YBAglZ6wDst4syoNcJ0y+UshcCKQIxDNNN2XSEM6w
	Oft6jS0=
X-Received: by 2002:a05:6214:21e3:b0:6e6:9b86:85d0 with SMTP id 6a1803df08f44-6e8f46d5cd1mr8080006d6.8.1741206561648;
        Wed, 05 Mar 2025 12:29:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzj3VnzDaaIbvAFjVufn5nGxmexz91QgKSdKtxQ40yVUP2gqR5kYn2qDKbFG2xC9ZTZ7Hnpw==
X-Received: by 2002:a05:6214:21e3:b0:6e6:9b86:85d0 with SMTP id 6a1803df08f44-6e8f46d5cd1mr8079756d6.8.1741206561335;
        Wed, 05 Mar 2025 12:29:21 -0800 (PST)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e8976cc9cdsm82983196d6.88.2025.03.05.12.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 12:29:20 -0800 (PST)
Date: Wed, 5 Mar 2025 15:29:17 -0500
From: Peter Xu <peterx@redhat.com>
To: James Houghton <jthoughton@google.com>
Cc: Nikita Kalyazin <kalyazin@amazon.com>, akpm@linux-foundation.org,
	pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, david@redhat.com,
	ryan.roberts@arm.com, quic_eberman@quicinc.com, graf@amazon.de,
	jgowans@amazon.com, roypat@amazon.co.uk, derekmn@amazon.com,
	nsaenz@amazon.es, xmarcalx@amazon.com
Subject: Re: [RFC PATCH 0/5] KVM: guest_memfd: support for uffd missing
Message-ID: <Z8i0HXen8gzVdgnh@x1.local>
References: <20250303133011.44095-1-kalyazin@amazon.com>
 <Z8YfOVYvbwlZST0J@x1.local>
 <CADrL8HXOQ=RuhjTEmMBJrWYkcBaGrqtXmhzPDAo1BE3EWaBk4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADrL8HXOQ=RuhjTEmMBJrWYkcBaGrqtXmhzPDAo1BE3EWaBk4g@mail.gmail.com>

On Wed, Mar 05, 2025 at 11:35:27AM -0800, James Houghton wrote:
> I think it might be useful to implement an fs-generic MINOR mode. The
> fault handler is already easy enough to do generically (though it
> would become more difficult to determine if the "MINOR" fault is
> actually a MISSING fault, but at least for my userspace, the
> distinction isn't important. :)) So the question becomes: what should
> UFFDIO_CONTINUE look like?
> 
> And I think it would be nice if UFFDIO_CONTINUE just called
> vm_ops->fault() to get the page we want to map and then mapped it,
> instead of having shmem-specific and hugetlb-specific versions (though
> maybe we need to keep the hugetlb specialization...). That would avoid
> putting kvm/gmem/etc. symbols in mm/userfaultfd code.
> 
> I've actually wanted to do this for a while but haven't had a good
> reason to pursue it. I wonder if it can be done in a
> backwards-compatible fashion...

Yes I also thought about that. :)

When Axel added minor fault, it's not a major concern as it's the only fs
that will consume the feature anyway in the do_fault() path - hugetlbfs has
its own path to take care of.. even until now.

And there's some valid points too if someone would argue to put it there
especially on folio lock - do that in shmem.c can avoid taking folio lock
when generating minor fault message.  It might make some difference when
the faults are heavy and when folio lock is frequently taken elsewhere too.

It might boil down to how many more FSes would support minor fault, and
whether we would care about such difference at last to shmem users. If gmem
is the only one after existing ones, IIUC there's still option we implement
it in gmem code.  After all, I expect the change should be very under
control (<20 LOCs?)..

-- 
Peter Xu


