Return-Path: <kvm+bounces-33332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 467BC9E9DF4
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 19:20:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D5B6282E54
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 18:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F55915854F;
	Mon,  9 Dec 2024 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="k0RHbcEr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483591537C3
	for <kvm@vger.kernel.org>; Mon,  9 Dec 2024 18:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733768398; cv=none; b=l2MCQDBjdO66FZf6dbEauZXzSNQpUj1IK8FVevpN9oJIPupiR5gfsvMvoOGLKkSG9QVtiOJf7PNCLuZBLn08BlpWRJeIi/RiKbXYRnQvghpIu/tIoy3d/x/OvMv5NafjmDEMPwaJ7+2j3W27k9qrKSKHFyPy45fpbl10VNDyJTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733768398; c=relaxed/simple;
	bh=qcBUYF+09hJCYkGs4wxsTdoZ8xqLA7ePhPeZolaV/1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5/eknL2OuPKsjXwtcV4+yRnyWzVXzpScQY5Mu0YR8ZfntuMVkydArn8ybNSskRkk6uyCtjXLPR0D86yJL5MzOr7jMzAXnxGYwy4e57ROOSPxQ8JIP2Ai2XthBjoPjXHOBbem1nBkoVHlODRd1jMO+1iV/RbW1Jb5U5apaEFDns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=k0RHbcEr; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-466879f84ccso36546501cf.1
        for <kvm@vger.kernel.org>; Mon, 09 Dec 2024 10:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1733768395; x=1734373195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qcBUYF+09hJCYkGs4wxsTdoZ8xqLA7ePhPeZolaV/1I=;
        b=k0RHbcErLYhCUYXHcJEfpTL3NsGKBDug4LNYnuCG1GDng+1wWG3Qjwh04yLni7nSpL
         4rMQF/FAbFpgpiOMXTMpLtceGLLvRRobu0G1cxB83mmkve3WC5Nrv0vv/KohnzTCxSAl
         X+0N4JE1mjmrojJDBZKeCcRN/9qgGSqCBnWl1wKAvPRXc9S5jRpIyMg9d5NqOwi63hcC
         KJSS6qZoVEjnY6+vmmEwsOJDLNaCXFhn5TWdo9hzCFINpj+JP9Swf2PxqRLebqMeDtk8
         3pxCTgwva939zd9S0nVNOv3rxAjsX76hUq8hW48KZBsFGA12WLIQ/MwHorsiyuR6NMRf
         ywNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733768395; x=1734373195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcBUYF+09hJCYkGs4wxsTdoZ8xqLA7ePhPeZolaV/1I=;
        b=dt7gDM62PYEjylC0hMFIE9vbNrDna+iubmo0TLtbEkxa1YMgYGHWbmiKxhPi5OMJyQ
         xHj4+NahwvPZMptCjS8nUsNaf5iYR16gcax/cyzFmW3XHktdoFCyeMp67XigDDi0aXwN
         Erpd4wrckdZaWVfeYT08dtT2c6AEW7A7/NZxSaovZkpV+8HeTx4avSDTl/1AV1azZWlO
         dsHW2Zh4vMDra4G7diijnHdPZPOKArzQai0WwkcAfRYsR4g4d5mS4FdVotxStwd5QJBP
         N1gKaYfiRGYjWi37E56wmFbXsH0BWmi8rEtgqvpD8dgEui7WRUYGgkXSTEd9WYZymVLn
         Mm2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXM53yYMSrJemL4HWdecGgLw6yihT2oHtVPSOMc3ZdbN0q7huvA6u6hpe3efWVOJPJu2cI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9kahk7shZ5i4s5QIR2S7MuZM8P/t3PR96W43FzF1o+PhDDzWQ
	IMm+Wg1xs+bdmeS+V2uKF2ViBokGYRyKwaTAgaTnlabb6Bk7C9eblDzb3xDwkxE=
X-Gm-Gg: ASbGncuvBBM0b+fYOnhhDFTMLu+m7Qgl6uRfrhD9CsgIVqp7b4fm7y4hgCEmMkOZf0u
	uwF0+Ppsv9GDvPJoapcXm1P+NOE3+ZN9gpBNVdo8qnB523LQPYRNLwpRLG5gchAWktrM7/VzS8O
	nHuZ9fIY4fTTMZHzoh5hX4NgoJE8LE+KgZ28kxhd8mzdfBqRtUjOodnKKhuWp2BMCYchHu/shxS
	wFSb/5ibXiOM/roirTrSoRp57YV7cicZRMawyuQcr+IWjR1Cmi0V/Jt1cuGFP2OOsZc7hzWbP3R
	KmatrZxwQ3lWY0TvSHhr/h0=
X-Google-Smtp-Source: AGHT+IGv6sgkZ0/PiNXaWy/sLDGes2SiMQVxjAwfcdBV2f2Sx38nvJy0Az9I4u+WVdfALJz6yHegbw==
X-Received: by 2002:a05:622a:6f07:b0:467:613d:9b0 with SMTP id d75a77b69052e-467613d1304mr83471271cf.50.1733768395116;
        Mon, 09 Dec 2024 10:19:55 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4674d343428sm27693891cf.76.2024.12.09.10.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2024 10:19:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tKiML-00000009u4t-2IFD;
	Mon, 09 Dec 2024 14:19:53 -0400
Date: Mon, 9 Dec 2024 14:19:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ramesh Thomas <ramesh.thomas@intel.com>
Cc: alex.williamson@redhat.com, schnelle@linux.ibm.com,
	gbayer@linux.ibm.com, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, ankita@nvidia.com, yishaih@nvidia.com,
	pasic@linux.ibm.com, julianr@linux.ibm.com, bpsegal@us.ibm.com,
	kevin.tian@intel.com, cho@microsoft.com
Subject: Re: [PATCH v2 2/2] vfio/pci: Remove #ifdef iowrite64 and #ifdef
 ioread64
Message-ID: <20241209181953.GD1888283@ziepe.ca>
References: <20241203184158.172492-1-ramesh.thomas@intel.com>
 <20241203184158.172492-3-ramesh.thomas@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241203184158.172492-3-ramesh.thomas@intel.com>

On Tue, Dec 03, 2024 at 10:41:58AM -0800, Ramesh Thomas wrote:
> Remove the #ifdef iowrite64 and #ifdef ioread64 checks around calls to
> 64 bit IO access. Since default implementations have been enabled, the
> checks are not required. Such checks can hide potential bugs as well.
> Instead check for CONFIG_64BIT to make the 64 bit IO calls only when 64
> bit support is enabled.

Why?

The whole point of the emulation header to to avoid this?

I think you would just include the header and then remove the ifdef
entirely. Instead of vfio doing memcpy with 32 bit it will do memcpy
internally to the io accessors?

There is nothing about this that has to be atomic or something.

Jason

