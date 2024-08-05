Return-Path: <kvm+bounces-23277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9B999485EC
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:29:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A484F283BA8
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:29:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBBFE16EC02;
	Mon,  5 Aug 2024 23:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MUjxSBCC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3C816CD12
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900552; cv=none; b=eTXJxnRDGP94h+4PgKDwt9i6a8TZvkjGuhcBFKTNl+OOaQ/n8KXDEfIp/MH0CWMWPvbPXHMvxaBDsaoknfgBh/p+3700QdtntISMtL9ItCafWQqXeYPst8Zs0Axweb56xs8laDyJpIr0a8Rb8GAU8kd/zi8lE/hH3aqOb+Q78IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900552; c=relaxed/simple;
	bh=Ud+vs2yn6sXlpWsYL0inF2KS4QwbN9S8Dxwgfx2J134=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msk9apIPp9QNpM7MFhwnR9NVEH4+jTW2otVOtcGkz9PFeo2bJQt1Yhm0uD5e8unicOQR5Le+BQD4pIE9IqSdu7um68DrjxbJIa5KM1S/2UHyhNyXqqHpJbOpF3mt3nnfuHxJ88DqmS9CXeKxw/5RkCG/LIaZ0L/prU3JcpzQerY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=MUjxSBCC; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6b7a0ef0dfcso483906d6.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722900549; x=1723505349; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ud+vs2yn6sXlpWsYL0inF2KS4QwbN9S8Dxwgfx2J134=;
        b=MUjxSBCCZ4a/cVUr5whOihgnOhTIYXF0aEXKzqmkYPINjr2E2onX+wwDkAu+tt2jae
         vSjt3pDf+aBqVfC6dxFEHZ4svDH4LrmEjCYAZQmduXCp8vXix+jxlUBHhKYHgGaW1/yW
         l1qN0qq+usNSXvQSyq+Tp+0B7x0NEuXEqscpTUhcgY78HAWu031Us+eLGQZeS/W1bgpN
         XrGWKsKl/uBIBeA52qi4Oe88x5h/I0Kru6lucgexVGr11pbUeyTKRCcPPxk3rluDsfcY
         cnpLlQy/ciP3+sS+qh9bugNx+UutmpyKVOmDR10/tFV4LnHprPI+JcbOi1lfrY9xRfAU
         pKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900549; x=1723505349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ud+vs2yn6sXlpWsYL0inF2KS4QwbN9S8Dxwgfx2J134=;
        b=M6n4g17CTzZUVjPtprsaKYaHLJDbRf1G0UqfYAA7Xm8FkWfX9B+4PB31+cTpx7NrrC
         tOw/IuzBNbzjZ84qZuEzoWPZRYUJ+RJCSaH6ABPQRvamK8G29ERbbKdC+vi2h/G+g34E
         wv+7TcwNn2o4btPC1uzMIK7jVzhHvCDdNFZSitW6w4SjiMc3OgcECVOf17QG1rH8eELz
         nVJYUctIetpooqfwuzK6EIYSEKJoa94syOBEgaSPzzijLVW0BU/j0Tdv8fk7o4KbNT6L
         QW/95WU50kdllv7SPUyb5BQ1/jZkEEw+2Zt/GLwxHwtxb9CqPN0t/Q4UEgLvaRcUOltO
         OsDA==
X-Forwarded-Encrypted: i=1; AJvYcCXyvN9xk+2qPn9vAc7eMCrea0aNbeZvBif1AE1KMxC5Ch1xxqk4NNkR73uEYkseqDPhtKs8sSFe+yopsUgHOXKMeZD9
X-Gm-Message-State: AOJu0YxYilVf26K2dhqTWbHefa8hJcYLbfIgGXvT0s14aDc/hHMGdkoF
	saKt8OVl+tTRvGPG+vjn463psUewZhVTw33Kf91MIQFAfj4OtO6xKOP9TypWHng=
X-Google-Smtp-Source: AGHT+IEUqd6hIg9HDyEzlke8VzqWmU4TFD6nLDglYJ354O5s+08g370xcdmQz9qNHG00XmeufXnXGg==
X-Received: by 2002:a0c:f209:0:b0:6bb:b478:52fd with SMTP id 6a1803df08f44-6bbb4785327mr1712666d6.31.1722900549464;
        Mon, 05 Aug 2024 16:29:09 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c83cc30sm39451646d6.101.2024.08.05.16.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Aug 2024 16:29:08 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sb78W-00BvtY-0n;
	Mon, 05 Aug 2024 20:29:08 -0300
Date: Mon, 5 Aug 2024 20:29:08 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jan Kara <jack@suse.cz>
Cc: James Gowans <jgowans@amazon.com>, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Steve Sistare <steven.sistare@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Anthony Yznaga <anthony.yznaga@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Usama Arif <usama.arif@bytedance.com>, kvm@vger.kernel.org,
	Alexander Graf <graf@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <pdurrant@amazon.co.uk>,
	Nicolas Saenz Julienne <nsaenz@amazon.es>,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH 00/10] Introduce guestmemfs: persistent in-memory
 filesystem
Message-ID: <20240805232908.GD676757@ziepe.ca>
References: <20240805093245.889357-1-jgowans@amazon.com>
 <20240805200151.oja474ju4i32y5bj@quack3>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805200151.oja474ju4i32y5bj@quack3>

On Mon, Aug 05, 2024 at 10:01:51PM +0200, Jan Kara wrote:

> > 4. Device assignment: being able to use guestmemfs memory for
> > VFIO/iommufd mappings, and allow those mappings to survive and continue
> > to be used across kexec.

That's a fun one. Proposals for that will be very interesting!

> To me the basic functionality resembles a lot hugetlbfs. Now I know very
> little details about hugetlbfs so I've added relevant folks to CC. Have you
> considered to extend hugetlbfs with the functionality you need (such as
> preservation across kexec) instead of implementing completely new filesystem?

In mm circles we've broadly been talking about splitting the "memory
provider" part out of hugetlbfs into its own layer. This would include
the carving out of kernel memory at boot and organizing it by page
size to allow huge ptes.

It would make alot of sense to have only one carve out mechanism, and
several consumers - hugetlbfs, the new private guestmemfd, this thing,
for example.

Jason

