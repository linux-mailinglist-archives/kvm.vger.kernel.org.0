Return-Path: <kvm+bounces-25343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD039643CF
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 14:04:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 772C4B253F4
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 12:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F9E196455;
	Thu, 29 Aug 2024 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ALJOYo/m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C41193083
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 12:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724933016; cv=none; b=kjRVRd6S3zKiCQbMEUG6NqeKp8SP0NBZ3obijZm/1uYQ2UMA1PNSQ0eyuR5bMTuevE//aL0RWgmsmsWYQ9AecHhVg41/1qaN8eJvhkOq8wjKy01hRiSZfWgXofvjiBpitTzJGQuXGrufDo8wgvx+985kyUFjJPcb46ZBVwGXeAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724933016; c=relaxed/simple;
	bh=u8awxGC8APLD2fBPkfXwUnekJ7v92Iejds6q48zmlhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bb52CEK6NrGUzE0cghLfYu317JtKvfT//MvEFagvNskGabHcA2pDjPO3LkkHhqNs4wes8vnHe0cFO3KpYmKVsEGQntWbeouu8UB2LWV2Xd8EZPHqGar6FEcMF7GQP8x7iwMiO7xDuP3P9KAGhYQv2wsHbDv2qErNd4qzb9ziooc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ALJOYo/m; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7a1d984ed52so35660885a.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 05:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1724933014; x=1725537814; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u8awxGC8APLD2fBPkfXwUnekJ7v92Iejds6q48zmlhU=;
        b=ALJOYo/mW/lqIyANInE5p0J2bUO5xIxqPsF2apZdmS2VpxC4ClDZZwvgBwg7qyt+dM
         Med/4UxGg819o85KcEbzotPFCphuVwxOGzcn02vlPQ9HEZTONDC7KN28FTQBhoOYhKKc
         OR5C7UT32swzANyJqwRaOl4iXBpXM2z0VnjlX5dtWCGCogJOPX6ct75erLPkix1YmuYK
         U9Q0r74a6DJvOAHxplsQMyb5J1mK+5JnfNCaQGewbVeBqhI2HNAZ3PM8ZKwkmd4/pYLy
         2m/nK2/AHs6kGWqj7dUVJBb1i7qzyJfwE53VO6V+TgLb3BRjiS9gIUaTah0nsh6WVnTs
         wkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724933014; x=1725537814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8awxGC8APLD2fBPkfXwUnekJ7v92Iejds6q48zmlhU=;
        b=npeFLZ+tbQMXBg+nHltCo5+57y11jf8KmrakrxZfRlhju5Vyv1ePHTyvn8yUtnaah7
         zPLd1dtoklG2Ta1XPFCB/3/ywWGZYsFfrKkxfTZkTYcf7oqXk2HNhNJSOk6u1ynPcwkz
         nfcDhX2YRJBe523XcZCabmQ+JkFJN550gPwWttVlm6dp8FrgfopTEQaW+/793wFj45RB
         7ateiJaE9rdj9WaCcGGW9loraq+n7NHJsxhsenvEAlPn5g/vZ3x24q81MLPhqY4PGfRy
         lQgEwYhgsha3Bsvh31nYHkOq/eAi33YqBaqeLKnjFNlrZ28WV64q54ifSXucOVwgdPUz
         ycDA==
X-Forwarded-Encrypted: i=1; AJvYcCXejpzLBDm4Klc9P+7eak5WQCkhCJcXnQTfytxCByjLRLy7zHVGhzAByTgzGZVifpsBH1U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx07UehtOvh2ntPtL/CMCTOAkw0wwYulUiQN2QNFixuPF8UK4bU
	XgNBovTbHzuaSHHmTVBDdBLUrcIMTgdW9E5nXRqJ2qQO8P3cex0jVuT9ghoMtdk=
X-Google-Smtp-Source: AGHT+IGh1eftOELfePw5LBn8NrYfzH+v7ipL5QEhLmSsHv26fcAASM8yAzTbd5l6W1iebV1DkwTkvg==
X-Received: by 2002:a05:620a:4409:b0:7a1:e41e:4d5c with SMTP id af79cd13be357-7a8042668b8mr337112085a.59.1724933010626;
        Thu, 29 Aug 2024 05:03:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806d3944esm44767985a.80.2024.08.29.05.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:03:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sjds7-007TEL-WF;
	Thu, 29 Aug 2024 09:03:28 -0300
Date: Thu, 29 Aug 2024 09:03:27 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
	iommu@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	pratikrajesh.sampat@amd.com, michael.day@amd.com,
	david.kaplan@amd.com, dhaval.giani@amd.com,
	Santosh Shukla <santosh.shukla@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Michael Roth <michael.roth@amd.com>, Alexander Graf <agraf@suse.de>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: Re: [RFC PATCH 07/21] pci/tdisp: Introduce tsm module
Message-ID: <20240829120327.GT3468552@ziepe.ca>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-8-aik@amd.com>
 <20240827123242.GM3468552@ziepe.ca>
 <6e9e4945-8508-4f48-874e-9150fd2e38f3@amd.com>
 <20240828234240.GR3468552@ziepe.ca>
 <66cfba391a779_31daf294a5@dwillia2-xfh.jf.intel.com.notmuch>
 <20240829000910.GS3468552@ziepe.ca>
 <66cfbec0352ca_47347294af@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66cfbec0352ca_47347294af@dwillia2-xfh.jf.intel.com.notmuch>

On Wed, Aug 28, 2024 at 05:20:16PM -0700, Dan Williams wrote:

> I encourage those folks need to read the actual hardware specs, not just
> the PCI spec. As far as I know there is only one host platform
> implementation that allows IDE establishment and traffic flow for T=0
> cases. So it is not yet trending to be a common thing that the PCI core
> can rely upon.

I think their perspective is this is the only path to do certain
things in PCI land (from a packet on the wire perspective) so they
would expect the platforms to align eventually if the standards go
that way..

Jason

