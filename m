Return-Path: <kvm+bounces-36016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4CAA16DF2
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:00:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8EA27A0641
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAFB1E32B7;
	Mon, 20 Jan 2025 13:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="U9HvL4uf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8034E1E32B3
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737381577; cv=none; b=Ab09uo2F3fxmIXnmCkmr79jJ1wK96BNRCLca/QF5WA4wfFAt68uVyzzCYRgn6dbNiWeMHFuUjtpR85G8rLghvrPboovjrYHxq0EHfsWnwoLx96EtZPt+ikOrkKCSOAK5z9tBG7JvRR3mEJv1SsUs8EA0CW5i/k5+1jRaw5udDtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737381577; c=relaxed/simple;
	bh=R9UuZ10091tIn/30XWCOiokJdfB+dwU6cOauDpgnyh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u/eon2qgaFXg3uZfMF5Tly9UgmvN7X++aHqk3ZFhva+3/2tpcIfAGUazyf3JyZ57T+4/N92PQXT5RFLIZ5ufkMySPCqRLYvIpMiQgB9MREIuCRftfTtFkKFIqUttVPiZ5jGBBbSlSaPgtzBmbj/lqhDxyCpTPRvcdqx3t/reRzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=U9HvL4uf; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7b6e8fe401eso422623785a.2
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 05:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737381574; x=1737986374; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9UuZ10091tIn/30XWCOiokJdfB+dwU6cOauDpgnyh8=;
        b=U9HvL4ufaziM4xBx9X6TtqaEa54oXNBS7Ns8+Oi9BBc3Q0MESOn+3/rsSo3lq0ObtI
         +BKth8MThNEZYPdBzopGZaIbAka8qgFOhLBEXjGg+Kg98F+sCIT10Y1tqGWTXFszWijM
         95W224szQL6yRN3mcO2yVtcY+vbA0d/SzCjPF1FBh6qRS/FdX8yBnODV19uC9dA1ZOfT
         ECF4ztg4+pc/fGEJ7oNvVBlZg8hHyRIAFbplGcu8pO/AX1EI7TQt7ynCNUkFV1IgLEqu
         TmaZg0BDqY07W8IOQ1kYV3wsxGOx/WuIMV9ebS+ZVQ13u+sz3f3MmxLkBK9Q9OIfwpJJ
         pykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737381574; x=1737986374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R9UuZ10091tIn/30XWCOiokJdfB+dwU6cOauDpgnyh8=;
        b=HS8rkuTRvK408Kzhe4D0xSkMz2xTsRIoKbYtiPPYmZK7zAW+ptV5kTSB8i7ljW2gHZ
         W3EreYHipjt8I3aVF+jhJpwkSnrIFMLj8IoCr8X1p1kSiIGQ7+DpWsbUNveddzoeSC/h
         fpNoT3B5UtrXwqjrs/RRGxG8F43vM6ygcrnKxpzHKXo/duWNhv/Dr2NlpjiL620NigU9
         yk86dSw73/Gcuw/MG7ToqIiDOFiNbE/3gWtTmnKIEqqaCGRzrJjVsxaKKKA0oKVc9M/u
         O6zFfBM1BlAZS1Ylb+qlKTP3NFCQoTPSP6fdUqzc95azHpq3aWNwzczvuwJvS7hB74EQ
         EiYg==
X-Forwarded-Encrypted: i=1; AJvYcCURm2otkzdz67XJztbpWemuC6mdEHqjvrr9G/I/EvGJNYle+G3mguvPEkmSTK6eMCAil6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnNPGkyaagnS7lrEk3SrZClcpKu1gtPxJKJm5EDPaMs5sNtLSz
	0g0T+wWIEb97s3iN59lyT6cRX1l269mL5MYJIXXR7va/awot3+iFJ9+PndzBFA8=
X-Gm-Gg: ASbGncsh5o6LpyLU6uNBJedLsuAZ2YYYNhPUQsQLOZCEqyPLthUEEo7JaQUeJN6WsJy
	jitBuJes7XLtp/eNrghPECDHUwo62X/OGCUp6yhOQQjDw2U6W/Uo8hzmYKb0wgkX+hP+ssgWMKb
	P2MQBCKfvmmd+2TMDJlEaHe7XHDRdA9EQFe3mbtLhsWZSEqc2fZm+HHW//IcN6uH8gtg3U7i4df
	/EiIlqfQkMLPf6m4S5MKokZYfw7nCfqhSiOimjP0HHHblAQtSyhFxIrfpylFU7ioau/jP3XErOj
	C0wzuBdm7j6T0ywqczZ9f8yNWOTBJ6iacGkEqwLAeOI=
X-Google-Smtp-Source: AGHT+IHXw5XwlAOVQM5DmvsT9Jphrpd/TgpL5J7UWvahF7YSM4NY2jfkZTX/ettpphOLDZrPgY8dFw==
X-Received: by 2002:a05:620a:2849:b0:7b6:c2bf:3eeb with SMTP id af79cd13be357-7be6318021bmr2068444285a.0.1737381574398;
        Mon, 20 Jan 2025 05:59:34 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e102fc99asm43201701cf.29.2025.01.20.05.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 05:59:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tZsJR-00000003PaH-1oaY;
	Mon, 20 Jan 2025 09:59:33 -0400
Date: Mon, 20 Jan 2025 09:59:33 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wencheng Yang <east.moutain.yang@gmail.com>
Cc: Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex.williamson@redhat.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] drviers/iommu/amd: support P2P access through IOMMU
 when SME is enabled
Message-ID: <20250120135933.GJ674319@ziepe.ca>
References: <20250117071423.469880-1-east.moutain.yang@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117071423.469880-1-east.moutain.yang@gmail.com>

On Fri, Jan 17, 2025 at 03:14:18PM +0800, Wencheng Yang wrote:
> When SME is enabled, memory encryption bit is set in IOMMU page table
> pte entry, it works fine if the pfn of the pte entry is memory.
> However, if the pfn is MMIO address, for example, map other device's mmio
> space to its io page table, in such situation, setting memory encryption
> bit in pte would cause P2P failure.

This doesn't seem entirely right to me, the encrypted bit should flow
in from the entity doing the map and be based on more detailed
knowledge about what is happening.

Not be guessed at inside the iommu.

We have non-encrpyted CPU memory, and (someday) encrypted MMIO.

Jason

