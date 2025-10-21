Return-Path: <kvm+bounces-60664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C99BBF679F
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0453E4EFAB3
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 12:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540D132C31A;
	Tue, 21 Oct 2025 12:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="VoL5Saxv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408491E8320
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 12:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761050182; cv=none; b=DzmspED9ODhzHhHlDE8IU2Ax7syqDJ9idE8Jw9fQJHGSvZB3B6Zpl9g+RQNO+kRly/OpEq7e1up3cZx7p4GRqmFERjXU2+oX/BFd3wB2PLx7RSvmf7LbTvwfOl9sfbBX4xDN69jSSDh85q4fQdrfTmiK+6CdSbNHM3IjEZePKcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761050182; c=relaxed/simple;
	bh=IuvVYLP4TD5FVjAFF7R1GuTDvgwa7BCbt7d39eu17rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W86qOjfBZ0HjB2Ca19xZIdyLbfJVulY9jW7MoRFPxiqfHPFFwjCXvzFTPTNpf4bDdDEsVtyAFAZVw3hLsUsHohf8deXne2gEy7rp1j/XuDVeIF/AcQx5kIvhN/wHnJ944Vowag4AlQoTt7Ij9PvPOTcyE68cAg5nwkFcwd8BvP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=VoL5Saxv; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7b4f7a855baso3937101a34.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 05:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761050179; x=1761654979; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BscMy2QJPNp/+d50tHKif/o+NtFK8tk0LmkoZ49Inww=;
        b=VoL5SaxvXL/a4r+2CKPBWnk7l57IaPRhdBrkyy2OJwKbTzKSlYbjEsTLOLPvwQ6zku
         q/c9aN2Mx1TIKN99CN/le44y5iussV6GNx27KwO0YifMB87g4CKB5UWwdzHBLSg0lg3B
         go00prnFgNsKS8iUhHbaYJL6vEHGaj/Cpfp6bgccWEn9/lQwwEB2p+kod2vx28fRe368
         MbFZrSXL+BUsEMTp8+3mKpmlriCmha1q3C1rBK+/5Q2Fx2OnVUUYZJhdTuDzxbtiGGGn
         26yxPegL8L7LgVZ8WqSad7Je+9grP1mBaA/NmuvZ85WxdmUZyR1ycSGX1vhuJ0wQSxrO
         Da7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761050179; x=1761654979;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BscMy2QJPNp/+d50tHKif/o+NtFK8tk0LmkoZ49Inww=;
        b=oxu1Y50NqF6rYlzMINYaI1epUz3IlQ3g7wwWHlCAuvq75tdslAHnR0+/fy0JfZYEW2
         4JPfQz8H6/8YDVzSZHOQ6bY5ZxnynN8K9YSGhx+feqkIN0+OWu1USmsr4m5IwXYK2Phn
         EzuYfYFnHSQRLqctUiNETOOQBiDzYqTy+ihG5oiWNCHCLWKF0GVvUjR/ijuhVEYHh2eR
         UchmIXdT1t5LS7EK26VdRxLGaY2/LClNqqVEtsXwowcNaoW8f8IbjznYQNOjmIhCFlJh
         2DXUVfcEGp6gmtc1+05gSp12AX3KPBXa/J9jvpTNGrcAeWQLp2ipoMK0nYmNJQFWBdwn
         z47w==
X-Forwarded-Encrypted: i=1; AJvYcCW5FWIA1SWngEgAkCH1j+TqazaotUIiElpwDWeULjfygKSdfnvB8/4+HxbEkMtdcsO9FDY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6J1bRSffU73GxMHWEcMgu8K6ixv3gjsV79jfu9bhXJKx2PEfv
	smjIOV/mAeThDVNnl+7ZFa1zTuvxYwo1Am/d1MpitXxG/CPzsHZt/uK0E78DN0q56b5B6NYGndC
	p59xp
X-Gm-Gg: ASbGncvYN1DvWfr5ZPwHBFT1U7DQp0H8F4ykdbeFQ/nPPuDT44TA16wRo7cSA6w71P9
	tzfwb28zO+NGxJKKwkn25Gqk5WTzp/YrGuBhC+fnCJ9giqwsgRT3Z+BLwhnBWep+kmemTWaUtIl
	LJkvhtHjVA6S+SCOVuNx5fcJqD6YwT0fxdEuJxefGPHs0flCsVunIg3uR+mDRgC2OaqqxzVO3Ph
	szSqpDVqa+TWHHPHL8kTvp6Ro3vnerpIaLLoZoKUZ09j+8HelzFwKjJ8Bwtuqz8SGgAOs2iLyWM
	9S8Q0CEn+IrPbugBUj5lbFAb6CzQj/QFQ/ntaioFhod7WEx0mpgttK+lJOGNUk+RUjYhGCHDhU/
	SAtipe9WxMs01gmTYpvIP1EzW4qNg8q9BXdQLmZX8ffalrcqlb62+ZvspgO0S
X-Google-Smtp-Source: AGHT+IE4uTkSED8b/A/idZtW99ihUnHUqwxK7WWbd6AGSBlCRqAodEvAD8ghVSbFuqK4NuJu0j2F+Q==
X-Received: by 2002:a05:6830:6585:b0:7ad:a421:c655 with SMTP id 46e09a7af769-7c27cb45e2emr7263619a34.19.1761050179263;
        Tue, 21 Oct 2025 05:36:19 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c288935ed5sm3631744a34.32.2025.10.21.05.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 05:36:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vBBb7-00000002w2p-0naJ;
	Tue, 21 Oct 2025 09:36:17 -0300
Date: Tue, 21 Oct 2025 09:36:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <20251021123617.GT3938986@ziepe.ca>
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>

On Sun, Oct 12, 2025 at 10:32:23PM -0700, Alex Mastro wrote:
> This patch series aims to fix vfio_iommu_type.c to support 
> VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
> ranges which lie against the addressable limit. i.e. ranges where
> iova_start + iova_size would overflow to exactly zero.

I didn't try to look through all the math changes but it looks like
the right thing to do to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

