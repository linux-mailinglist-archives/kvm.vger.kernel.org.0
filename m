Return-Path: <kvm+bounces-36114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BF13A17F64
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E7A23AA6B9
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 14:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1373A1F37CC;
	Tue, 21 Jan 2025 14:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="g1iiHAw1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356D1F192A
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737468358; cv=none; b=QzH0viJpUdGmvnOrf6iZQyrTUVSCgjdRea/yi2zVZYsrTWwcaVl0x1Xt+xihvPOvplefx85samwZoELLP/4exygW8THVRQYX2ijnfDI6qxgUuzQVt1b0W+4fkLetye71nAjjHdpOXX3mjVNVjTqSTVISxku6lMMovT/RZTrhLW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737468358; c=relaxed/simple;
	bh=Dkwx9tgiYKi66sIwegQ0qrKst+TwdTwAexE5ayIcojk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkWq7B+PJ9vCQeeaVjFsIRoX6JgDKYjDJR2LE91XYxripPtqXnaavBM4tK1JDQFkQlF+nHR/ShFLOncnh6PmC7JlC+piUvkOB0nRumhNZs4YJXyJTsBaTAdITL8yUh3A4bAEbVrg0VWx8v8fjF7RrqPNEs+B1kTVKTgk/g1SJtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=g1iiHAw1; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7b6ed0de64aso511063185a.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 06:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737468355; x=1738073155; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dkwx9tgiYKi66sIwegQ0qrKst+TwdTwAexE5ayIcojk=;
        b=g1iiHAw1tWeWa+p8pglUP4KarwT79h2TgYvKdFq1JsBesqxT2yfxDq6RNTFRmokqCh
         co44jL+NChhO7z+XB4u1tQjl+jcn7uZ8f1a9KnM0WNr69Uv40/AoHofxtuk4r3f5vyL7
         curo6jZLw9EyAMenbpbi7AP7osO4tZvcNAfgi9V7j4nioNrJYTupugQicGKwnNmpP0Qf
         P+wdx9YJHM1pkx35TMV8BlEoBQCv50Oh062al/PA6L7Y6op1OHdLDQobclPhmR5IYar3
         Vhh3T2Pzpp7ZICUxee+oCjpJ7CIRRcw1I+9N/Rm5W7uqUmGqtC2/Z6BrUBZS6YiirN6p
         AQ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737468355; x=1738073155;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dkwx9tgiYKi66sIwegQ0qrKst+TwdTwAexE5ayIcojk=;
        b=ATsoe52CJ2oMhhKvgY+nAN+lTrABdKD6rnCyHorEOPlaIkeHSM0vptNWlyAHtfZwlA
         BctpkkxHxEuNVcUCDV28y+xrP0VFEaVo244s7T/wXwi5PrGuvC3E1WOqri8drQ4F/A3s
         r2bCILGV6llMW/4yijmCr3bZXdKnYduTlDlba56FLgRn4tWkfK5GWgJe9KOYBUi22dL1
         pToCU8gz2ZHutQ/3DFjXuwaeuRnsXoBmu0HAMrBGvmPMDyA6aYiTeoKPminvyFopCj+J
         znz0ICBPVqDARqNAIBrQFA6N/4VRCgUPyV0YK8hqeN8IXKhwJwHlJpHvEYC8tiRI8OQG
         PfHw==
X-Forwarded-Encrypted: i=1; AJvYcCUKh1dt+zozFmYgwWORoz4Ny75j2N5qrt/Oq3R16HnfEIQtxOyqOWuZSBuYrJq0m6m6EhI=@vger.kernel.org
X-Gm-Message-State: AOJu0YycYI+B6VQ1nQVIzKs/1oGqPUpJ+WonucjHKDRO79+zEzHsrUWS
	g10UUyV/TUzvzFtHEN2E7hm0evLTbxgAM0UXOYD6FgeqGhJ9EApxa/OTV+8qRfIcVSz+JVoZK8q
	Z
X-Gm-Gg: ASbGnctGhHghiENCxnSknSpGxxdrDyyYi9MVP4zde0TFO3LYE5rASsjy5FdD/w7MnHv
	yy0PaCpBCha85h0Gvw0ODE389cWKerD42FOqudQAfoH19WQU2gqf13apZkNbduuA3YIA9mnIKW6
	DCjeOI/M8uFCbPkSWV8VMNlQCod+qxExgkaUTpa/sRvNGoPqqtHlT8xaMdDeQeKLu3KA33vcijo
	HyBHj8hQBdp8SO4XJBBWt7Mfcxl9W+civwFn2R4enQD+/MxY+xWUEZfwmuFOVRAFbTMYtVUwrTf
	5qIGwocf4Ko40CknH35RwmYFh6x/8AlI3qkXb9GJlTQ=
X-Google-Smtp-Source: AGHT+IE++V3SWyktrc2J5Kp/jb4mq59Zv75AygSHVmfiYTqXVgZXaSVeUCP5iLae79m0enPmM5f/VQ==
X-Received: by 2002:a05:620a:15b:b0:7be:7fda:69d2 with SMTP id af79cd13be357-7be7fda6a8dmr587627785a.15.1737468355227;
        Tue, 21 Jan 2025 06:05:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be614d9af2sm559168685a.77.2025.01.21.06.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 06:05:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1taEt7-00000003fgW-39nj;
	Tue, 21 Jan 2025 10:05:53 -0400
Date: Tue, 21 Jan 2025 10:05:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Wencheng Yang <east.moutain.yang@gmail.com>
Cc: alex.williamson@redhat.com, iommu@lists.linux.dev, joro@8bytes.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	robin.murphy@arm.com, suravee.suthikulpanit@amd.com,
	will@kernel.org
Subject: Re: [PATCH v3 1/3] uapi/linux/vfio:Add VFIO_DMA_MAP_FLAG_MMIO flag
Message-ID: <20250121140553.GP674319@ziepe.ca>
References: <CALrP2iW11zHNVWCz3JXjPHxyJ=j3FsVdTGetMoxQvmNZo2X_yQ@mail.gmail.com>
 <20250121112836.525046-1-east.moutain.yang@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250121112836.525046-1-east.moutain.yang@gmail.com>

On Tue, Jan 21, 2025 at 07:28:34PM +0800, Wencheng Yang wrote:
> The flag will be used by VFIO to map DMA for device MMIO on IOMMU page table.

Definitely not, the kernel needs to know and protect the memory type
itself. Userspace cannot be allowed to override things

Jason

