Return-Path: <kvm+bounces-8059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF8284AAB1
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 00:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D44D1F2334E
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 23:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6687748CCF;
	Mon,  5 Feb 2024 23:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="twsh112c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C94A99A
	for <kvm@vger.kernel.org>; Mon,  5 Feb 2024 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707176091; cv=none; b=SQn54dZe9y68n8sMAeNhLrvEJtt9lbQ8Q5/c7Bw8xi3p2I3NzGPZEQTYrVdXzrkJtFmGK0sokCl+UZvcXR3VxBTG+unzu9RqNdNnDA/aey07XHwV4Ad7nSB9CzwIB0agbu4NDjVdKrS5Q3W8k5Hbiux0M2jKkGyXzc8OoP/IJBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707176091; c=relaxed/simple;
	bh=ldhxU/uh8jcnenclWs1IUZtu/99DL4r26fBNY3JoSIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KVAtbjJzijQEokgaByVQmy1DAkOEw9PFd9Zfz45Qq18/2AtUWSlxFFF1Ocol/tossrlFFgJ+/KwWEECa0UYpd/zotTlHPYLlqxpnRYJ3n9XZo39axmgbBFCTBkay+hCxQnK4XNV8+gr2eQktq07MAP6OAs05kBm79PY4+402/Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=twsh112c; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5ce942efda5so4365822a12.2
        for <kvm@vger.kernel.org>; Mon, 05 Feb 2024 15:34:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1707176089; x=1707780889; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtL3jvJTvpjem+XLSIljDmdaRNW3JxGajKR4+xmGq/g=;
        b=twsh112cxZ6tGm9NJIJXjjMfSrgSntwk7HW2VF7WtGsTm1E1pv+a7O+2Dw6DA0L/Rf
         TlUsUNFO+g+YVkfORlSH03dNpOOZZYRJMu0Hg96q/JU4qH0JF+vW7macCgsndF4WcJ8/
         Y8+CwxIRzFuK7cHDdGgmJKoOYEIxkK1mlp2vkcb5y5uXyEHHCeOJLGWzwlAXfookLryw
         fNJoCpMOL8lUAmvV2vMGTxG9nFUlN9sKle3qCIlXb9a5u/bal9VdZ2OD4G+C5dcT2Rl0
         BGE2YKYGVzX0pRAjiJoinYFuQgOLIKN0+NxzLCCg6rUUndVBr6neTo6y5/68T+gNBwhr
         UR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707176089; x=1707780889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtL3jvJTvpjem+XLSIljDmdaRNW3JxGajKR4+xmGq/g=;
        b=YKxoXwFVZlYqFc1GG/JtKJZ7RGmJ+JLuqFV9jTFkNgAuKEr9OzAi5Q/dtE5yuLvYjX
         B9wkfoKt2CTjkKKXnSy9BBolls+qIg2/v04G24+hAJTmv1Tyz3Oi0cOL4zfU5C65jSdx
         HLk/sgOwxSSAbo0ttw8hq5gk8TphmyzSkhNUdWR1SXYaeoGkNm1d1H5ADmqgzDKrql10
         YFQdhdNAKng1/2KeUxD6dy4bMP4e0+GcGj/jjlgLveJLn5Npwt/a7HyOd04PRANRP54K
         NHMQ+aQpV5ClT6Ggs5xnXjyela9jBsS+PeW9SfAwFOc0II5Pw70vUIS6DDRViZ2AYkeA
         clzg==
X-Gm-Message-State: AOJu0YxEkfOnjsWvMFMMpTqguPEMJEHinEPc9mFM1he/VjnftZ7HRVII
	XF6llKzTyxJnKOtBG8e3COm3ymBH32/lD1zxQ5ha6cF5KoKjkw/IGmeM7s9Sq48=
X-Google-Smtp-Source: AGHT+IERWsgnVzcArUkK0ONx3MiZk4r16tHisF/C0B+IjOUSmMRlRCaxDntU0A4X2gmwb0jbKeI/4g==
X-Received: by 2002:a05:6a20:5a23:b0:19c:6994:8913 with SMTP id jz35-20020a056a205a2300b0019c69948913mr18604pzb.7.1707176089472;
        Mon, 05 Feb 2024 15:34:49 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV0CEkV2IfB4OmDyzaC+v8m2BH8FR7RhAj08DN4ZCHOpokDj9NS3wCXNVRfk7DG1CgufYqK8wHCWHs/PTSMiUjOuQSYNN6ZB+aTscx7+cznoZDT8F2Z+x8Fq3mxFfB9Q2jg/LH2Xu5A+NenLIQoUHD99PduRSLqa/iSmtJqGUFocP6eazRhZvFPA9oDPPOrGfymNqdHw0h/nxszHDIMLLBz29NGLa3hIDKXa0S4z53eR2lqqcuHECKUht7VhUHfbFimSw7QRk7cn4BKB3os4xsrqwiVMkY7NRCwcGUSArF2DNAxABXpngViCgO/vzS6NOCH8aVzjxa+p7AcjKWz6oTuWjyOTrBZ8G63OPDI6g9B3Y9ih4iHTfBED1X+kcrAoyJpINXQ5q4bBt5dYYppH+8WNNuWMz2CNZCklGzQk9dJuoE2ItM4zSqmfovYw3ID101Lnd3kUjofr8ibkxgD8K3q6WDRUDbueTuqDCvzRQDSW98rcWllaXDIoFd2YDIC4WD/pL8BWmhBnN8pJ6k6aTgCMvz90BDChV469mYLup57WhnQyVmsE3Qc8hAeKEEGLeNjV2ax1UH2rK7sI8BbI4uqpLjJUj6kEP6G3Awmmm0ngNCcknaIUFOysIxxB9aT2a3JhYMHnRxYt1Ck/1I805Fl85lKwmRr4/1P9deiddme4xe2eCvJLYL3JVcbTYiI3Vs+wFW6KG3VQaHK+PxspiH1JWWW2QHFdaRaiqgAgi3xQs8I
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id k18-20020a170902c41200b001d8f12b0009sm423859plk.293.2024.02.05.15.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Feb 2024 15:34:48 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rX8UA-002agH-2H;
	Tue, 06 Feb 2024 10:34:46 +1100
Date: Tue, 6 Feb 2024 10:34:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: James Gowans <jgowans@amazon.com>
Cc: linux-kernel@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
	kexec@lists.infradead.org, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	"Jan H . Schoenherr" <jschoenh@amazon.de>,
	Usama Arif <usama.arif@bytedance.com>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	madvenka@linux.microsoft.com, steven.sistare@oracle.com,
	yuleixzhang@tencent.com
Subject: Re: [RFC 05/18] pkernfs: add file mmap callback
Message-ID: <ZcFwlu9+LQQWWOz4@dread.disaster.area>
References: <20240205120203.60312-1-jgowans@amazon.com>
 <20240205120203.60312-6-jgowans@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205120203.60312-6-jgowans@amazon.com>

On Mon, Feb 05, 2024 at 12:01:50PM +0000, James Gowans wrote:
> Make the file data useable to userspace by adding mmap. That's all that
> QEMU needs for guest RAM, so that's all be bother implementing for now.
> 
> When mmaping the file the VMA is marked as PFNMAP to indicate that there
> are no struct pages for the memory in this VMA. Remap_pfn_range() is
> used to actually populate the page tables. All PTEs are pre-faulted into
> the pgtables at mmap time so that the pgtables are useable when this
> virtual address range is given to VFIO's MAP_DMA.

And so what happens when this file is truncated whilst it is mmap()d
by an application? Ain't that just a great big UAF waiting to be
exploited?

-Dave.
-- 
Dave Chinner
david@fromorbit.com

