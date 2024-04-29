Return-Path: <kvm+bounces-16201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E60298B65C6
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 00:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B716B21EE2
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 22:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E26175A4;
	Mon, 29 Apr 2024 22:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cVDSeiIU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B08364
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714430017; cv=none; b=gy33GWwrWzB1QGDwoO3QHd9XiFXJw1ygEnwt+/OtUxCE1mQ124hR1VR9FTnhCuTsQ5wyTvcCMIL9kYOZxaAEpSqwciiOCtMmoj83XBnbmwAdJ1/RBGfognjmWpyeJ4dbJHjMRfEbiVJA+hjjxKcNsJSHvrLqhA8k1BQYoXnwKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714430017; c=relaxed/simple;
	bh=rGUePLwxZnq/3D/u14H3DiEQUVLiciMj2KP0W0iiVNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dvpArevBfx7kQW75NwTLHYWBB2kdFYUPJGMUMsdmVzsjaZWnffLfFda3Ijaz/NQqh3JrTziMk+XBLjE6Xm9DTK7lGL2he7IHMs41kF7uctZZSeziEbbKw2myvxGbL49agIxAUtfKs/8yoqVfQ32oQT96SpLruybcVAgrWR39UXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cVDSeiIU; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-434c3d21450so25801851cf.0
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 15:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1714430014; x=1715034814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i63enZKvq49yBuuGfO7A4K/q4kvBEE7D4Fuwwr20hHY=;
        b=cVDSeiIUuBEcP6weaLNlbhzcSNC/kbV6w1W1f6+D1iAhr9DnMxKProeVtShkHOIMBX
         LjkqVOZIpsN5a068+0vnU3ue4mmLp4QZHF20m2m1/5wiAUeOlKbNnhtiot00rKRmvTsH
         /ucD48nJJsNJ6UQQW17o7mYGgDxb6jnBccw2DHEJSGb0XoYbPYI6HN2HYb/wM8iciNEI
         r+Zc7Bc034VH9z9sM8A9GkbFQYNx8y0SmzAp7yrXEAF3jNYrF+4UZd+Sqg5GXpTJZN6F
         U5SeKgAJSeiFeY+OJTwtPrvDFnV76tvZwOFsT3YhHCvYqdj3Bl2gwKjSby7kohU1BWDL
         COIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714430014; x=1715034814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i63enZKvq49yBuuGfO7A4K/q4kvBEE7D4Fuwwr20hHY=;
        b=iuB+rAvIM3JvIF7u0PQKwpK9FEq+SgriDaZg7uAKzWyLlM5/lJ2g5iAdkAaU0W7GBU
         GOZw0lCpGTOJ4I37ekX5UhZ20MmT9JOxMQOenuYxaB3BhHl9PrBaq8yeA+nqDf6hxjdn
         omYT8dMCj0bjSMXHf7mv0nt0dqjlTQNnLNny2QEVUFYpfhsYfU49nDK5x2ZaxLNwdqK/
         mB0YKSZpMsxE4iX1ItqB1JRtWX9OerXBFR3fth21iOMhMlxtqaG+ptar40x+SRxUcTmP
         75pjC/InSkCKxKTeBQT+t3S77Aed60ICS+0qJ52XHkFX0Ff4imJxnzK18Cb2FnJI+cPR
         t3Gw==
X-Forwarded-Encrypted: i=1; AJvYcCWb9PFuJMEMxeeJWgapgK21gXs61GWqL3P552feoy1gjpycnAISeCVxwMf4YUOZWzQ0zU0m3dIjJR4xZdrSK303SvEQ
X-Gm-Message-State: AOJu0Yw3/LFfkdLk4twOmNqhhfMRueGEgmXXoY8TdjeGb70WmXpjtqW+
	57d3DMc+n5vtVv/zU5wG4mbO57pO+DPmdf0y9Fn/LLg3MI05B09JH9BIzp3Cj9FW0dMlbfYMHAh
	M
X-Google-Smtp-Source: AGHT+IFbWPXi6Dp2uoYHr59JYATCzulrcKkzpQ5PDWB5JKsjtvjWnuYd390Ec3xwyOHs1mCH+idmbg==
X-Received: by 2002:a05:622a:311:b0:43a:abcd:c9bd with SMTP id q17-20020a05622a031100b0043aabcdc9bdmr9388548qtw.45.1714430014608;
        Mon, 29 Apr 2024 15:33:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id t25-20020ac87619000000b00437a6e5b3fdsm10521530qtq.66.2024.04.29.15.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 15:33:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s1ZYz-003OoB-AX;
	Mon, 29 Apr 2024 19:33:33 -0300
Date: Mon, 29 Apr 2024 19:33:33 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] vfio/pci: Extract duplicated code into macro
Message-ID: <20240429223333.GS231144@ziepe.ca>
References: <20240425165604.899447-1-gbayer@linux.ibm.com>
 <20240425165604.899447-2-gbayer@linux.ibm.com>
 <20240429200910.GQ231144@ziepe.ca>
 <20240429161103.655b4010.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429161103.655b4010.alex.williamson@redhat.com>

On Mon, Apr 29, 2024 at 04:11:03PM -0600, Alex Williamson wrote:
> > This isn't very performance optimal already, we take a lock on every
> > iteration, so there isn't much point in inlining multiple copies of
> > everything to save an branch.
> 
> These macros are to reduce duplicate code blocks and the errors that
> typically come from such duplication, 

But there is still quite a bit of repetition here..

> as well as to provide type safe functions in the spirit of the
> ioread# and iowrite# helpers.

But it never really takes any advantage of type safety? It is making a
memcpy..

Jason

