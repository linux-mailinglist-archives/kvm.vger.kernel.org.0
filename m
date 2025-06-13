Return-Path: <kvm+bounces-49477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00C98AD94D4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B85A81E4ABC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA62233715;
	Fri, 13 Jun 2025 18:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCLiuXrz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DCC231837
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749840808; cv=none; b=eZ/n8mCvAC4A5BPPhlmfi9u2n/YfWnl1T9q9BEDVq6+YRWN1OQMkAVJ0oWr3WeH9ucwhUPF7R/EnecxSFkVL3CTsOsZ9TcHdVOfRr1cAmRX9pPeuAXol8McFLHW2j3s2OGcRHkVEoOOcKIIJN243Ycs+KirjW75rJoxMSW2IA5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749840808; c=relaxed/simple;
	bh=Cjzm5zcRZnsOAuwyO76t9n9NJxkUtHR+IqjmAsTAsmA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3uDJpDsf/f9myFVSIKtbGU6HULM4dJo6m00fr1pcU1qKFkuNHxGXqbNrl6v7Ah5iPDqAMR4McOAjY2S9KgxvO0b2j5X5B989riCIpX4IUALudsSFtFxN7LawAVtYFTeyVoxJNkEQCTuhdR5pschepctdoOWVs1YFNlNHvTheWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCLiuXrz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749840805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gftgj3F7KbsxQl1OCCcu039clX1oCiOXcGuSy3kjDUU=;
	b=VCLiuXrz2X5CHwLcfw9ItQMRLJhj2LeFgHYjkpnheXLcQEYX0tHRRX2a3PXB0uooSCBJB6
	3OOd7i7ckoPq/dQeJbBGzVb4N9S7wAh8CW33ZkHuVLhPtmgU0lbQ6cLDgBjtLdg+PtAqXV
	fXuaTPyO96aLmSF+4Bgu8SLDItbBIqo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-mPgz8S8yPk2FELDM-PfRDA-1; Fri, 13 Jun 2025 14:53:23 -0400
X-MC-Unique: mPgz8S8yPk2FELDM-PfRDA-1
X-Mimecast-MFC-AGG-ID: mPgz8S8yPk2FELDM-PfRDA_1749840803
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5750ca8b2so341453185a.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 11:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749840803; x=1750445603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gftgj3F7KbsxQl1OCCcu039clX1oCiOXcGuSy3kjDUU=;
        b=NH2rbab+0F5Vrclg/1RaKjVkz13sOQ/SxfQzz3KRmlY5BKz9YAgegXsMUpi+ZNCkVM
         Xa/y6WLVoODUY4fnbsv7Hfh6lXPLagrxde6FfTMoXq0gP71Gf7U+uwqalvtZHzYXE+AG
         CHUJUyryaanBt996LOgR+l8+FeKL+4XyZH3i/CpuILVbuCLRyoJUWfOf2X59unN1Pprv
         n0fVwjJkgLiqTR1KebcNmoxewmPfKsjj6ldqm8EKhVoudhBi4a42092x0wuZ8wQwkWa9
         sw/KGQGYFoNpnOSeO+FYNm/CWlMek+7wBloqS04d7fU3mb63XUyRhCsCZeEkKvDSgyuY
         /KtA==
X-Forwarded-Encrypted: i=1; AJvYcCUifwPu4gAUPyFb1C4kA1d5TW5ZknuDE3LpK/efZ6na+RjkW3nIaCoFJZRb83uRxXVHJu8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDqX5qcsCnid8EQ0SYa48QarZwd0wBlTPtZqMXuwdPrECFHNPd
	E97iZ+meYwu0sNrg80v+uQdQ0mLw3e6sWnLzl7C4hSJaf817eFyn58iZcHvTPJrXBIsuCiX0YYC
	lRbSYyc0oW0hD8n+Zq/ai2OOHeWTPFKIkYOuXpW/fCTv1Ts3ZbpznOg==
X-Gm-Gg: ASbGnctw4j1HIoVCmMbnc2W98elxyve68gsl23FbvH9WgfSuHTYiFPiY8O3U4lEiw/q
	GasOaqcqylZtSkLWpdbJSNZ+fIGx8wD0fW1ErZGLs3tEwCoZb68ik4lbGhvtJTF7+nD7KEqPeZC
	QkiU/DPkLlqWogC2HMB0PIDGmYQNjmmuWCbLVccqRh/yZpivYxVqD6RJ/3we3TYAF51gVYKsrxb
	+5ME9uKx4yg0uw3SecrGzDYqryRzUxfhkIjifbMfNjCbvt7amEmbxZ8zshCkTwAcwiWIeVWxaqx
	U40JEvamT39+fw==
X-Received: by 2002:a05:620a:29d0:b0:7d3:a6f2:74f2 with SMTP id af79cd13be357-7d3c6cff068mr94635785a.55.1749840802678;
        Fri, 13 Jun 2025 11:53:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXcJDc+6SfZZjG6WukyvvwVpmRG1A1uzOdQlYb7eX3XEFjC1NczC7Ki5Dki/oYEcd/wf85cQ==
X-Received: by 2002:a05:620a:29d0:b0:7d3:a6f2:74f2 with SMTP id af79cd13be357-7d3c6cff068mr94631685a.55.1749840802254;
        Fri, 13 Jun 2025 11:53:22 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8dce692sm207001285a.14.2025.06.13.11.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 11:53:21 -0700 (PDT)
Date: Fri, 13 Jun 2025 14:53:19 -0400
From: Peter Xu <peterx@redhat.com>
To: Alex Mastro <amastro@fb.com>
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com, david@redhat.com,
	jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, npache@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aExzn1CFGpA9szrq@x1.local>
References: <20250613134111.469884-6-peterx@redhat.com>
 <20250613174442.1589882-1-amastro@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613174442.1589882-1-amastro@fb.com>

On Fri, Jun 13, 2025 at 10:44:42AM -0700, Alex Mastro wrote:
> Thank you Peter!
> 
> I packported this series to our 6.13.2 tree and validated that it does indeed
> provide equivalent, optimal faulting to our manual alignment approach when we
> mmap with !MAP_FIXED. This addresses the issue we discovered in [1].
> 
> The test case is performing mmap with offset=0x40006000000, size=0xdf9e00000,
> and we see that the head and tail (975) are faulted at 2M, and middle (54) at
> 1G. The vma returned by mmap looks nice: 0x7f8646000000.
> 
> $ sudo bpftrace -q -e 'fexit:vfio_pci_mmap_huge_fault { printf("order=%d, ret=0x%x\n", args.order, retval); }' 2>&1 > ~/dump
> $ cat ~/dump | sort | uniq -c | sort -nr
>     975 order=9, ret=0x100
>      54 order=18, ret=0x100
>       2 order=18, ret=0x800
> 
> [1] https://lore.kernel.org/linux-pci/20250529214414.1508155-1-amastro@fb.com/
> 
> Tested-by: Alex Mastro <amastro@fb.com>

Great to know it works as expected, thanks for the quick feedback!

-- 
Peter Xu


