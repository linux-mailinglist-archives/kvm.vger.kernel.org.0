Return-Path: <kvm+bounces-52896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B1833B0A5FA
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 16:16:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23F831C805E5
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 14:16:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC96D2DAFD2;
	Fri, 18 Jul 2025 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="mjuTHAEj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700893398B
	for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 14:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752848164; cv=none; b=izZGJYH0B2YhH/RFD7WUGMd0UL/BTWdFnlPDZLvDeILMJaz07r7L03fw8uMuYVmh916tvae5/WBmHcU3mBgOj/TPB+emIT0+hhqHnmMx+CM6FCgdUxdyGiXj5nT5AhAvZJyt/UnbJmbauBvOBZF6/dCtcr51713OphpvULdwpbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752848164; c=relaxed/simple;
	bh=5XaE7447C9RAX+GCeN/Jf+zei+sDppnkuDDAOZmhiks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s7FKayYxzxgdwwYsvgSxihJKVJLwmCA1teZnYDNDOM4k++IM72Jgh0MAg2/ZG5h9Klb2K/cVeH/aK/WOZ+qWTP5/boVVWcQ9YjdMASigzezdkHvcFDr0S/HrNXx1QV3o1DOo+Z9O0bA1oElp3/9XGEGUK3oGqQwPz7KccbvtCOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=mjuTHAEj; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e346ab52e9so265534185a.2
        for <kvm@vger.kernel.org>; Fri, 18 Jul 2025 07:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752848161; x=1753452961; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJjLE0UVkZ2mMP5n5MQpEv3lHcI2vw7mI8TTF/9jzI8=;
        b=mjuTHAEjVq9p5tT8aL15EowHfiE0HRBl1kHUhR4vjvid5WGvdE1A4t0A5Z8qr6I6QW
         /z/f7E3OQ32u+SyRmENMHHZzyOTH7GxekIJw3eirlyDwQEPXOFZ6qJFrSddBUIxLNOyM
         +vZpu1BZ/94olJTltKu1beswOjBohsX3XseZnNgakttKudd1QONXGAwPoc4sVMsh12qy
         lfoQeA67xQlCaOJboBLwqomDfcqvggK31eJGO1RKMlCd5WA0UNbLZ8rcLmVhYXE6ivU1
         bEz518hj1PxuEOCjb9CZe4MvyWIrsNgzCQ6gQPaTrglgCIVPIAAbQQIQaWoAutow7MPV
         hfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752848161; x=1753452961;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJjLE0UVkZ2mMP5n5MQpEv3lHcI2vw7mI8TTF/9jzI8=;
        b=vTr1NvKM0/gdZ7uXQN9qZF6aTErmtj7Y6I2kHUteWSoOV6Y1oRodZQLF/3oDlkwpmM
         mDx3C645HlYI8iFfFSljWar7eAtNnxZaQIzACi/aqQCBIMRAQnttyUVEgCPlgFm2rrzn
         Y5mBYlf2F+FSQ9VKq4vFwtzjUUehx6tTTpEn4dJDUjVzy5RxeVhbw/aX5d6hek5kzU/R
         3fRggdwOxpmt7DWP0u3d1LMRzxz6iOgi28p583XfITXKfm7dM5CiLUrPQJWf8iH1rypl
         QF844dkY6AmX1ndxW/GEgxrjwZNZ9lHBTvfDWIvR3/fQE+OzR5NxTeVPFou1utv0QFF2
         LJUw==
X-Forwarded-Encrypted: i=1; AJvYcCUUxxdmuSHHbMR2DaAJnnpi8/JV1ni14XKnd14Q9fPFWeeqem3MnFKhbXLl5FhrHJ/P+2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVYF4+lNk1/F6EnbBzJbE8N7EvY2OIhk9Scn8Xzss/EuCfQfVJ
	x3hHWdWgqVtWCPNiz6rx8QFbYo1iZFkLinv+vyDiqfAZWagj3aw1a6Y93okQg0gsoz4=
X-Gm-Gg: ASbGnctNEp0lZV2//MBbl86v72/lw09xVoTkgG+zuxOD2qxxfA4tDAqGCbDkBwUjjag
	HNWdUo8RMnuUzEQonjMzSUrz5MDhLgY2LCVaY7GJs5d2HcrLLdgmUEqcfRz4NWEm8CieTGyCTLr
	VeNO3HZElKRzyxjn6J4KGrJqWF/aRYIb6I0aFvRIoKbj0+t34uiUUGGZDP0WlbiNI9VuxiZe4SK
	k5ZlIS2JpUC01PTdwSJTol78sS881ytbWa7pzWlVTnRd2ulrw8cDFJi4rNot+cJbFWeD6j0MTQO
	IYirtCATMWr/1GcT3jVjl9APbq1ihvSFGrcTTteZTO0bSmuVLbh6Ec5lAUWv3CPhhRypfE9sp0S
	ckJlsl1+OPU2UOes/hbKpkhTJd1zPYZdGskUMzWnXIwDSprSFAhd+YYS2ttQ2OKahjLNzuamtfQ
	==
X-Google-Smtp-Source: AGHT+IH83itoUa8qKHB+I069li42G5fh0+8tV6hdT0Ya4bqMV1JxQTP8HGjKpE/oLQZTw/kkZxIAXw==
X-Received: by 2002:a05:620a:4410:b0:7e1:9769:97c4 with SMTP id af79cd13be357-7e343613265mr1502291985a.47.1752848160939;
        Fri, 18 Jul 2025 07:16:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e356c649c0sm91045985a.73.2025.07.18.07.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jul 2025 07:16:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uclsV-00000009zBs-2Dun;
	Fri, 18 Jul 2025 11:15:59 -0300
Date: Fri, 18 Jul 2025 11:15:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	linux-fsdevel@vger.kernel.org, ajones@ventanamicro.com,
	akpm@linux-foundation.org, amoorthy@google.com,
	anthony.yznaga@oracle.com, anup@brainfault.org,
	aou@eecs.berkeley.edu, bfoster@redhat.com,
	binbin.wu@linux.intel.com, brauner@kernel.org,
	catalin.marinas@arm.com, chao.p.peng@intel.com,
	chenhuacai@kernel.org, dave.hansen@intel.com, david@redhat.com,
	dmatlack@google.com, dwmw@amazon.co.uk, erdemaktas@google.com,
	fan.du@intel.com, fvdl@google.com, graf@amazon.com,
	haibo1.xu@intel.com, hch@infradead.org, hughd@google.com,
	ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz,
	james.morse@arm.com, jarkko@kernel.org, jgowans@amazon.com,
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com,
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com,
	kent.overstreet@linux.dev, kirill.shutemov@intel.com,
	liam.merwick@oracle.com, maciej.wieczor-retman@intel.com,
	mail@maciej.szmigiero.name, maz@kernel.org, mic@digikod.net,
	michael.roth@amd.com, mpe@ellerman.id.au, muchun.song@linux.dev,
	nikunj@amd.com, nsaenz@amazon.es, oliver.upton@linux.dev,
	palmer@dabbelt.com, pankaj.gupta@amd.com, paul.walmsley@sifive.com,
	pbonzini@redhat.com, pdurrant@amazon.co.uk, peterx@redhat.com,
	pgonda@google.com, pvorel@suse.cz, qperret@google.com,
	quic_cvanscha@quicinc.com, quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, quic_svaddagi@quicinc.com,
	quic_tsoni@quicinc.com, richard.weiyang@gmail.com,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com,
	shuah@kernel.org, steven.price@arm.com, steven.sistare@oracle.com,
	suzuki.poulose@arm.com, thomas.lendacky@amd.com,
	usama.arif@bytedance.com, vbabka@suse.cz, viro@zeniv.linux.org.uk,
	vkuznets@redhat.com, wei.w.wang@intel.com, will@kernel.org,
	willy@infradead.org, xiaoyao.li@intel.com, yilun.xu@intel.com,
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Subject: Re: [RFC PATCH v2 04/51] KVM: guest_memfd: Introduce
 KVM_GMEM_CONVERT_SHARED/PRIVATE ioctls
Message-ID: <20250718141559.GF2206214@ziepe.ca>
References: <CA+EHjTwjKVkw2_AK0Y0-eth1dVW7ZW2Sk=73LL9NeQYAPpxPiw@mail.gmail.com>
 <CAGtprH_Evyc7tLhDB0t0fN+BUx5qeqWq8A2yZ5-ijbJ5UJ5f-g@mail.gmail.com>
 <9502503f-e0c2-489e-99b0-94146f9b6f85@amd.com>
 <20250624130811.GB72557@ziepe.ca>
 <CAGtprH_qh8sEY3s-JucW3n1Wvoq7jdVZDDokvG5HzPf0HV2=pg@mail.gmail.com>
 <aGTvTbPHuXbvj59t@yzhao56-desk.sh.intel.com>
 <diqz8qknhj3l.fsf@ackerleytng-ctop.c.googlers.com>
 <aHjDIxxbv0DnqI6S@yilunxu-OptiPlex-7050>
 <diqzqzyeg3j2.fsf@ackerleytng-ctop.c.googlers.com>
 <aHm2F95XwzdD7nod@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHm2F95XwzdD7nod@yilunxu-OptiPlex-7050>

On Fri, Jul 18, 2025 at 10:48:55AM +0800, Xu Yilun wrote:
> > If by the time KVM gets the conversion request, the page is unpinned,
> > then we're all good, right?
> 
> Yes, unless guest doesn't unpin the page first by mistake. Guest would
> invoke a fw call tdg.mem.page.release to unpin the page before
> KVM_HC_MAP_GPA_RANGE.

What does guest pinning mean?

Jason

