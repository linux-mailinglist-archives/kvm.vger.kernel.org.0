Return-Path: <kvm+bounces-16340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE7B38B8BB5
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6124F283639
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 14:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F4712F36E;
	Wed,  1 May 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="gR4Z9xKb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141432581
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 14:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714572586; cv=none; b=Dh9AVdXPc0e+JWKPEg+Rp64DEytGML17+STiBinchT3Movng9d1cmlyZdBIHuUt6Uwu7w+4m9YH8DB5/19kga0UU1UwQJBxz5OwOTSiLdhZhpRD+26Na/msklySmMknYX6UHhxjaCOYaZVQxBTX/AM0ZlmEE8G0PEH0rb4vAphs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714572586; c=relaxed/simple;
	bh=lWkPcYzM0IS2ZNLUbMpap349Ov8pUe/jEyQ1UbI3Lno=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzxqkFA2xiGBKqpIKw+ZdR5dQTg7JpBcO+T8wE65pjLjGKOSVjnFL4PI0O6UtRy7NTiqPD3eXhZFLWMRdZbeKOMqqzdbm8oq2oQQqQwXeNmn54ivvwN/WFxEy57w/cuV3oNUPdUUKp7cwqM0ZSQWFXfWs+TPJ5dyr2MrkPQgb58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=gR4Z9xKb; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-78efd533a00so486788785a.0
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 07:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1714572584; x=1715177384; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O1qoEIkOLck4Sa8ZT+0G2TYNAGl2HaO45P/SMXLf4vc=;
        b=gR4Z9xKbPjGulU9aDeXTQ1HwF4TAnwkWDu4GMq7PFKMfWkbDbfvBuEb2arghwDki0S
         7e1sZnY1kUoBdHUTe0WsmPC1rc6Sx7VdF1MWMcoyHw0mM89jDielDXvzkNFjrFJ8wFmk
         eNssaHJaqDObF3uLY3UjquJNzXs5SWhD4WcrCsPQe2m7NMQx2+eBMqyhtOZ5eX4k+JqU
         /OgnbZgfsWS9th8xyANwkwj1iFejr+cxFzfcSEOsJPw3PoJ0Skn+3cVuudEA+Kdomqg6
         WxB2SckZB3bvkA0DiE1HEM1Su8RP6O/VbI7Wh7gkEP7Ji/9M2+GxG9TY3LxICxCmXHuW
         teLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714572584; x=1715177384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O1qoEIkOLck4Sa8ZT+0G2TYNAGl2HaO45P/SMXLf4vc=;
        b=uuXt+te5djMzffoGvcuPriXg+UEPDfV+T0M9sY57gTXMA9Z/lh8M9gXrFo7tYU/zfI
         XF7wCmQ2Tpbgz3CL9nWrIVlzEDKsL94hsZDwn/o6AXNArEv9ezGrK2T1HkcViW4ctQKP
         ZLWJ0esuobxSTGFlZxamrFg8kQJqIINNDSAp4Uk8oco+g4peoQGBN8CFg9hpaFqfp5hY
         Pyp3XyPRyGLl8CRist2kn9qJscFJpF7s16F4J8Da2c5X+ZajhARVxowmBGGZilniMDvE
         cJAh8jmXVeyL5Z/5UB7L3ZHSzDe2h0li+OWX9HV5pgCnSi09opOjdymb66iwgjOaR5yQ
         LcNg==
X-Forwarded-Encrypted: i=1; AJvYcCWYQ8RU0WPnLvde54yaK8fEKpkvVbB5x3eMHtN0pLjx/nzTCcxSbe2olYA4igluqbL41EocMAZmj6NemVSUsiW6hhSL
X-Gm-Message-State: AOJu0YzqDtg4WP93WjTETxNwYZ6mBveiCyqgERcdjvdX/QG0EK5GX3Ue
	TpFJOft6M0qY8drtLz3eJ7/S8uxEFViNuD18YGQ2HFCyw8ghFw+wqkON6HxviaQ=
X-Google-Smtp-Source: AGHT+IF213Sn1gI+C+Ltfyt/EaM6iz2FDR/B69onEC5U2qmZQ4cFog5+UAuTjWWtF9BXGrAGR+fPkQ==
X-Received: by 2002:a05:620a:4304:b0:790:944d:65b3 with SMTP id u4-20020a05620a430400b00790944d65b3mr2980242qko.62.1714572583947;
        Wed, 01 May 2024 07:09:43 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id pe16-20020a05620a851000b007883184574esm12405228qkn.98.2024.05.01.07.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 07:09:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1s2AeU-00DPni-Mh;
	Wed, 01 May 2024 11:09:42 -0300
Date: Wed, 1 May 2024 11:09:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: mpe@ellerman.id.au, tpearson@raptorengineering.com,
	alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org,
	aik@amd.com, npiggin@gmail.com, christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com,
	gbatra@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, aik@ozlabs.ru,
	ruscur@russell.cc, robh@kernel.org, linux-kernel@vger.kernel.org,
	joel@jms.id.au, kvm@vger.kernel.org, msuchanek@suse.de,
	oohall@gmail.com, mahesh@linux.ibm.com, jroedel@suse.de,
	vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Subject: Re: [RFC PATCH v2 0/6] powerpc: pSeries: vfio: iommu: Re-enable
 support for SPAPR TCE VFIO
Message-ID: <20240501140942.GA1723318@ziepe.ca>
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>

On Tue, Apr 30, 2024 at 03:05:34PM -0500, Shivaprasad G Bhat wrote:
> RFC v1 was posted here [1]. As I was testing more and fixing the
> issues, I realized its clean to have the table_group_ops implemented
> the way it is done on PowerNV and stop 'borrowing' the DMA windows
> for pSeries.
> 
> This patch-set implements the iommu table_group_ops for pSeries for
> VFIO SPAPR TCE sub-driver thereby enabling the VFIO support on POWER
> pSeries machines.

Wait, did they previously not have any support?

Again, this TCE stuff needs to go away, not grow. I can grudgingly
accept fixing it where it used to work, but not enabling more HW that
never worked before! :(

Jason

