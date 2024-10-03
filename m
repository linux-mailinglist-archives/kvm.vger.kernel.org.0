Return-Path: <kvm+bounces-27847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4312498F09B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 15:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74B741C21487
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2024 13:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6331019CC3C;
	Thu,  3 Oct 2024 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IWyIHgdE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1228C19C57F
	for <kvm@vger.kernel.org>; Thu,  3 Oct 2024 13:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727962733; cv=none; b=sznJNhj72kHjRerOtJKekP4yImfimbdPIhAoD09imkqa3Ar9udaANo/rsuvXeHNKwNEzYW7/HqtckbnS5EKpk3nWVDWFH1Pxnfb4WVQuFwfeaNhVgXrVxYqM2weD7bR3aTIpyEnW7ZgLkGRT3PZrlxFLIyEoaDpQrly5kvhrWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727962733; c=relaxed/simple;
	bh=2yRHoyoZovFhtKX/Tu0sqMjpkMS+w41Nsd0gnTQ9W0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INi6y0taxBv9wqDg+ZQAc2J1ngvKH58iRUeQAq0MI9pjXfRnuIXxcKgvzKn+haZzMDAA4YFEmCwXBKjHgssKqC1dgyZykZM3+jhM5ZHoqbhHQP92bzYQE5HahuFy6i4hXY8gObK/rnmuWc21JCg5wk2iPpWNP+R8K/KjiZQh77I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IWyIHgdE; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4581ee65b46so8462151cf.3
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2024 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1727962731; x=1728567531; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7cYlQ8sS3dSodfjWbJOUDRW+BCri6YPN6Z8wFgeEOOM=;
        b=IWyIHgdEIAYIvvo8M/x0YnNA0KN7yB9ejBqtkur3ScdlZQyxNduRq0jYw7SNbMxyF4
         7MGCrkKW4sJr1OOhW7zuqVovOJxjWTWuq3B9eij1y1HByuiI+V8DcDB5ZXkmji8Ec4qK
         sBZADW8Le7x21pEq8TtXoMIhGmWA2aETfCfZxbbknI+y7c8N+qBt/uETaRG8pU0oSq65
         ufC7HKUP9oPCI6J9g9LQJU8859pcCgWJWrXvmY1uK6IWaEjjdInV2B8yqvpSuuI/WY+r
         TLv0NwkHxX9bWB959A/pEaivLiBtoNTj34wXMxIumHMSNPviZIGa2uhfhOisOFjn0tHY
         B7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727962731; x=1728567531;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7cYlQ8sS3dSodfjWbJOUDRW+BCri6YPN6Z8wFgeEOOM=;
        b=N7PeFLcy7q/8NKZ95JYfqFRIYG+on7Z59I9/9KV0Q/3nOZ5N319rdte86hlYUknw/q
         A9k1C/Cqt1gO0lQw2ZZYDKc2rpWwtzmFmFkISM8qxvmQd2aq/Wuz2wf4CCNG1rQUbe51
         KJsH58/DnaJBcS5mQW/Z/bgZ4vg0HLd9a1V8JkS423c1PsTgiPh05Cgei2Sw3clkB5a3
         qBchMCv75Uc+NxWhJoTXiWDEqDQSA27LdFpXG9eNuhd+63U6+GiL/imPsvHjsuABfNXg
         1L2R8PlJEMdDbYFoO/vlsNx7sk1aiSnYoG2Y4zwj84DUvXpmHPuU1xf8us+VRV0DM/0A
         6r3w==
X-Forwarded-Encrypted: i=1; AJvYcCXH2+QmJbVqIn//kAgVyioVgvsIZoWnAZJtdvDC6USGL4EdIujLYB3zoEXBFDFbcRuIiHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ09AhTVQTmuWu6vjIsNKwlaoKt6QHHlqTdnwuC52nqXPoR8x6
	PeLH494Ze2dd2qAao0ZOactBW1eXU232lcOukC2RVzWuleKeulvkDKpGpCnnycG4iQ7kHzmVNvW
	Y
X-Google-Smtp-Source: AGHT+IEeXln8uxBBs7r0qbtw2wolKdiK0oe/fV/z2xXXfZUZhaM6OzDUMtsWVXSO1oxDdjO6OayXDA==
X-Received: by 2002:ac8:58c4:0:b0:458:2795:4853 with SMTP id d75a77b69052e-45d804d3296mr96964851cf.32.1727962730877;
        Thu, 03 Oct 2024 06:38:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45d92ed4dcesm5550881cf.69.2024.10.03.06.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 06:38:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1swM2b-00ASZK-KP;
	Thu, 03 Oct 2024 10:38:49 -0300
Date: Thu, 3 Oct 2024 10:38:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Michael Ellerman <mpe@ellerman.id.au>, npiggin <npiggin@gmail.com>,
	christophe leroy <christophe.leroy@csgroup.eu>,
	aneesh kumar <aneesh.kumar@kernel.org>,
	naveen n rao <naveen.n.rao@linux.ibm.com>,
	gbatra <gbatra@linux.vnet.ibm.com>, brking@linux.vnet.ibm.com,
	Alexey Kardashevskiy <aik@ozlabs.ru>, robh@kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	kvm <kvm@vger.kernel.org>, aik <aik@amd.com>, msuchanek@suse.de,
	jroedel <jroedel@suse.de>, vaibhav <vaibhav@linux.ibm.com>,
	svaidy@linux.ibm.com
Subject: Re: [RFC PATCH 1/3] powerpc/pseries/iommu: Bring back userspace view
 for single level TCE tables
Message-ID: <20241003133849.GD2456194@ziepe.ca>
References: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
 <171026725393.8367.17497620074051138306.stgit@linux.ibm.com>
 <20240319143202.GA66976@ziepe.ca>
 <1386271253.24278379.1710873411133.JavaMail.zimbra@raptorengineeringinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386271253.24278379.1710873411133.JavaMail.zimbra@raptorengineeringinc.com>

On Tue, Mar 19, 2024 at 01:36:51PM -0500, Timothy Pearson wrote:
> > On Tue, Mar 12, 2024 at 01:14:20PM -0500, Shivaprasad G Bhat wrote:
> >> The commit 090bad39b237a ("powerpc/powernv: Add indirect levels to
> >> it_userspace") which implemented the tce indirect levels
> >> support for PowerNV ended up removing the single level support
> >> which existed by default(generic tce_iommu_userspace_view_alloc/free()
> >> calls). On pSeries the TCEs are single level, and the allocation
> >> of userspace view is lost with the removal of generic code.
> > 
> > :( :(
> > 
> > If this has been broken since 2018 and nobody cared till now can we
> > please go in a direction of moving this code to the new iommu APIs
> > instead of doubling down on more of this old stuff that apparently
> > almost nobody cares about ??
> 
> Just FYI Raptor is working on porting things over to the new APIs.
> RFC patches should be posted in the next week or two.

There was a discussion about this at LPC a few weeks ago, did any
patches get prepared?

Jason

