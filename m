Return-Path: <kvm+bounces-18572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A84F88D6E00
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 07:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E9B21F229CD
	for <lists+kvm@lfdr.de>; Sat,  1 Jun 2024 05:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84127BE78;
	Sat,  1 Jun 2024 05:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkbDjkMP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321E91FA1
	for <kvm@vger.kernel.org>; Sat,  1 Jun 2024 05:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219103; cv=none; b=FLQ1VlQKVs19i6NQrjrJte62Q95q/WSDFSMEbjtB467x9CEBXsdtrUmeon2++sOMbvz5+VOpy/q4NPrWPztPEEVZW/oNTd4g/1/pWx/5p26yYMYd6Qhw7WN2VlrlbsjPPRRoWqHxc8ZdjPnUV6cckmUsQoghsNQqkgo3If1WBx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219103; c=relaxed/simple;
	bh=0kHr9aThd0MTDmhKYlvXiMU4cPaUFyOFUgQLXAeH5yI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qCPsDO/qeDkyDDKGauURryQ9zw4/hnnfcUQMeyHUh7In8C5LnUBxCBAGashWJWNdiDjgkRJ3dHSWtzoj6yWSWhgY30tOKdThCMd5ElytzJ7egaEBFIrGWtIdyHh2d3YtB6ZYgh6JMZOFqB9qhjhcurGRwuAtz4As3YrQCfrjSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JkbDjkMP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717219101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bv8aR/J5h5qbZV/3DPgOI7hLYt0Y0SySq28fCihRSNw=;
	b=JkbDjkMPAYljVDe/uRubvmwRBM7LXmx7YgkVk0+Tj4DdrrIi5whoJJXuXxWAzFrkOhZqgB
	aukX4y4ui8mbpN3361Bt7a5V4hxSdsbzrC+LTrkQDMgQ8Kj5rp3C7RRU/0Fxun5r6kk+Me
	+k0Tx39eVyKROLbYnSNeCdnx9Vr6Z9U=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-mNcXUqOGPn6pgdvr_kfT7Q-1; Sat, 01 Jun 2024 01:18:20 -0400
X-MC-Unique: mNcXUqOGPn6pgdvr_kfT7Q-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7eac412397cso297725039f.0
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 22:18:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717219099; x=1717823899;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bv8aR/J5h5qbZV/3DPgOI7hLYt0Y0SySq28fCihRSNw=;
        b=Aa4sIEQLka4sgKVb2qVGQHes7VUihuaoQJAtf3Q+vFKlmbP9KHH99aAZsJ8lC86KAT
         V99F+3QXEcJz4CWNsI7/6Svz85T3nYcoKdW8hXn3dFcV+jZA1QTsrwcz5rUHtmynN00i
         fgf6f6NOpe8YF/U/l2JZ/ipWw9xQUspVKXFpyy5ujPZN38Dsdkq/cG0OZpVUqwQZn1kq
         SVoGZuXLCdq2zoT0QqxIikxVOwARJdY2/OMAOVXDtEbpreLu2j/oANqddhUPrqRkzmj6
         FnkArquvIlWpAwTMiFVoH3WX59omOQKO3G6G4lceDuOo1zCWpc0Cyz8dMjgMx5QSOBJO
         +baQ==
X-Gm-Message-State: AOJu0YwkxbjCEfrinR8fE9rZeNINaydQNl4iU+vXZmXJv68mboS5BY+g
	ybr4stI3axqbb+iYi4nfkRRZJ7WNis7lObCMPFlwFywWBjOpa1HqMcCaRcxIs1gqS5ZCeFDc8n4
	lW04SjrJiWWQx5HQ+qyM8ktfhIlmXT+5QJRCNrXmIrXFQZNEUhL9bq1aPEQ==
X-Received: by 2002:a05:6602:2d88:b0:7ea:fadb:1cd5 with SMTP id ca18e2360f4ac-7eafff2b8e1mr519857639f.18.1717219099015;
        Fri, 31 May 2024 22:18:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNtyU5+S2DeL02WOxWjFJyd07EtK3twlIvqFWbJR/pMiMiqYQZeT0KV0QV5WcJH9sTZuAzqA==
X-Received: by 2002:a05:6602:2d88:b0:7ea:fadb:1cd5 with SMTP id ca18e2360f4ac-7eafff2b8e1mr519855839f.18.1717219098663;
        Fri, 31 May 2024 22:18:18 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b48764e0e4sm836012173.30.2024.05.31.22.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 May 2024 22:18:18 -0700 (PDT)
Date: Fri, 31 May 2024 23:18:15 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>,
 <kevin.tian@intel.com>, <jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] vfio/pci: Use unmap_mapping_range()
Message-ID: <20240531231815.60f243fd.alex.williamson@redhat.com>
In-Reply-To: <ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
	<20240530045236.1005864-3-alex.williamson@redhat.com>
	<ZlpgJ6aO+4xCF1+b@yzhao56-desk.sh.intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 1 Jun 2024 07:41:27 +0800
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Wed, May 29, 2024 at 10:52:31PM -0600, Alex Williamson wrote:
> > With the vfio device fd tied to the address space of the pseudo fs
> > inode, we can use the mm to track all vmas that might be mmap'ing
> > device BARs, which removes our vma_list and all the complicated lock
> > ordering necessary to manually zap each related vma.
> > 
> > Note that we can no longer store the pfn in vm_pgoff if we want to use
> > unmap_mapping_range() to zap a selective portion of the device fd
> > corresponding to BAR mappings.
> > 
> > This also converts our mmap fault handler to use vmf_insert_pfn()
> > because we no longer have a vma_list to avoid the concurrency problem
> > with io_remap_pfn_range().  The goal is to eventually use the vm_ops
> > huge_fault handler to avoid the additional faulting overhead, but
> > vmf_insert_pfn_{pmd,pud}() need to learn about pfnmaps first.
> >  
> Do we also consider looped vmf_insert_pfn() in mmap fault handler? e.g.
> for (i = vma->vm_start; i < vma->vm_end; i += PAGE_SIZE) {
> 	offset = (i - vma->vm_start) >> PAGE_SHIFT;
> 	ret = vmf_insert_pfn(vma, i, base_pfn + offset);
> 	if (ret != VM_FAULT_NOPAGE) {
> 		zap_vma_ptes(vma, vma->vm_start, vma->vm_end - vma->vm_start);
> 		goto up_out;
> 	}
> }

We can have concurrent faults, so doing this means that we need to
continue to maintain a locked list of vmas that have faulted to avoid
duplicate insertions and all the nasty lock gymnastics that go along
with it.  I'd rather we just support huge_fault.  Thanks,

Alex


