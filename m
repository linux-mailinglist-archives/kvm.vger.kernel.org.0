Return-Path: <kvm+bounces-60443-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF584BED4E1
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 19:21:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E0F7189CCE3
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 17:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA738259CAB;
	Sat, 18 Oct 2025 17:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Aau/TK8n"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846A8252904
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760808094; cv=none; b=bseysgYXtyx9mseVD1mHQIxrDG9m3rikLfXmcIyN4IJqG/cdAHfR3guHlmsUE2QlGqp8apHZsJZmRsTHWaKTUJ+dwNh9inNLa1bg8nhJDp07/Be7dPEwOZ/dgRmjlq8b16kvUoA7Igz530o9XC/ovGlvC5rPYiJkx33GOH2ub/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760808094; c=relaxed/simple;
	bh=hZrk3e0opmcmsfCNG/ct5rR35QVye1I3kOj+BonLMs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGFHryN2KpDUT0E1lnW0FoC1jS6+aK+YWDIAMGkpu1r+r1rhPIG2FSYStNHa6Murx6GQE010TrzbmMyfHiuVUKyIbbiuCSBcqtJbrH3iGlJsZefvepoK52LFjFR6IZSSUIw12TxrbbhN33k6j55i3Hr9q/n4tDE+Lx7+SUHvih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Aau/TK8n; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-88f2aebce7fso448591485a.3
        for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 10:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760808091; x=1761412891; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KtwlgrrpxMnfWC2+fWrpswQ73U5MXdKBv2JvDR0km/8=;
        b=Aau/TK8nGWOeUX+MxJFZw9gtVtiHPNFci3SjM8Dik/35zy/eDhFQj+15OzrR2mIhN8
         dMMCgaJ0GBVcYe4ImLhqfFHtHXdnWxHnkNNTUtbeuBd8tITFsABVrHAS2AwrbcdDhNqq
         nAMK2J2R2FILaeH24kLsfd7zgSh1Bwv/lDAI7g254NB5oLKX6As7IIx9jlRS/6BobzMt
         AKnwnj3TSQg6ZeGcqtANqXos1GAkuLwbG9mFt++pKblTFWIlF4OierPVgcFqLhtpsbNo
         A0KOZYWvdg3Y5HORB5cdmLv6g9HL8nzLUBeO2P7+gr9Vg4sN7+bWVbQvwHTJIW1Pd3jc
         haXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760808091; x=1761412891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtwlgrrpxMnfWC2+fWrpswQ73U5MXdKBv2JvDR0km/8=;
        b=jlH7H1PsIXgcH3Sk+VgYqFGWw4eEocol7WEd5X80g5ok3gftzqJUMmXx/z1a+BFtNd
         1BOYS0YQ1uXbM6ZnvxlAeQ9QKEzwFekUI1Wb4+ZTnK7TQMeRWRKB5GAa7h5JB1ryeldg
         vOl17/NzmOgKKJ9CZnMYBO+7bliGtViJRQmTaPsaPoyVRNNkJUIZY2QzAWTp6tFtPuLo
         5fm2X55053l/EqXfrRv7OLiqje2DKCEI7VHW6UwjF+B2YRmoSOanBWq52yPi87zAbbHV
         bbIZHhykrbM37LJNf27se8sgEAPLF6R2qsF0+OiwGVRJzc7MqV3Veijj0JeJdZ+ELTeE
         K+Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWotVJsslGokTeUBB7SXm4nKXgoNvTImZHx2wt2nbjozWqAjEHQpovXEKysHm2NJf1YGOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw77Amu8GcgfPkABA2gGHXY3/LpIRIDsz5ih/rorOe+wwIk3EZA
	gNoYFkVmL+vouFgV0UXNUiv4bm/kCeZueklPmI570LnL8IgA9jHXQ3LkXlQRMBbwD4E=
X-Gm-Gg: ASbGncvCmx6IHb2fdk2YC745lx/oTK5NXDa3gVMDSPLwG/8dsJEq8KhXnuwQReZDXA7
	CfxUw0pkc0I4Pn1dfNSAVP6Fpp5FNQk+5NvlkCJh/A3vT9EUYrU80GnWBl0VK4HFRYqeUnsb7RR
	4ytf3hO5FeTX5A++Az1kdpnzLyu1AtIlvF4rxRsM363RS3wZVSMCOiCsxgylQ3qYJ4Td5hTc1ek
	gbSz6hcxyV3VCNr9jvB6OrM+qsAjyvwPRvonJGdRpiho2UocHr/P2fbXn4tEe9BZDhlVYWlGRZh
	pxE0o69ywwLIv6luFbcoXCJYWA6ONFifYuhflRfAfEGsUkPvRtcLC2PDRnKxV+V9bb2wMTj5HRO
	YVpvZeuP1aSbA/M1YuUiaLTa/8/k5039HD18p2pj4zseLzQzIyA==
X-Google-Smtp-Source: AGHT+IFQ4YhonL1Z5Tyw8LFX7yPB+Yhbxw1duCMQ0dgn9fIzCTYhm3XLOpH05ZT1col0ISYsgvgJDg==
X-Received: by 2002:a05:620a:2952:b0:851:cb50:c5d0 with SMTP id af79cd13be357-8906e2ce114mr1080860285a.12.1760808091392;
        Sat, 18 Oct 2025 10:21:31 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cc9cacd0sm201601485a.3.2025.10.18.10.21.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:21:30 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vAAcU-00000001Z3Y-0F1E;
	Sat, 18 Oct 2025 14:21:30 -0300
Date: Sat, 18 Oct 2025 14:21:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Vipin Sharma <vipinsh@google.com>
Cc: bhelgaas@google.com, alex.williamson@redhat.com,
	pasha.tatashin@soleen.com, dmatlack@google.com, graf@amazon.com,
	pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org,
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com,
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com,
	david@redhat.com, jgowans@amazon.com, dwmw2@infradead.org,
	epetron@amazon.de, junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 00/21] VFIO live update support
Message-ID: <20251018172130.GQ3938986@ziepe.ca>
References: <20251018000713.677779-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018000713.677779-1-vipinsh@google.com>

On Fri, Oct 17, 2025 at 05:06:52PM -0700, Vipin Sharma wrote:
> 2. Integration with IOMMUFD and PCI series for complete workflow where a
>    device continues a DMA while undergoing through live update.

It is a bit confusing, this series has PCI components so how does it
relate the PCI series? Is this self contained for at least limited PCI
topologies?

Jason

