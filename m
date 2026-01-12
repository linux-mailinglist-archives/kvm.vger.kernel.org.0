Return-Path: <kvm+bounces-67852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91C7BD15E47
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 81A4A300C62D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 053F52D5C97;
	Mon, 12 Jan 2026 23:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="HAWkep//"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7192D3EF2
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768262058; cv=none; b=t7Y+1H3o951fpA8e5YACRzskNsc8KSx2grnvkhTp/QEGGS3n5+bRWZyuF7kCbI/I2sMK8z7Ot5xyFYREmy87GAAsQ3qe01o3YZbIJ5P1hEJdFkEeI+l02Qcfuq7vgrunSeS5fVB94eSlDETBZO414/cw1kechUDG6oJA6Wl3xgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768262058; c=relaxed/simple;
	bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqbGLVugJbKqORILpa7G3pVbWtRTetBGx6gndnnPwPim2Vywkp7hB4YVHPc2NTsTedHDhyaLYPHo1Sas1udJYkHD9akSzWX02MEM+pmSUTtYEKBhajuRRK9fU0D6g+1j4xwQ2qvJtCGi1jfTJ0y2/fBCRMX+eA8qGCqToyKWb7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=HAWkep//; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5013d163e2fso401641cf.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768262056; x=1768866856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
        b=HAWkep//EFhJW9wywQFy2dMaCD6x0rWanih6xdYl+a8hTir2qjOknoBiE1lYRxRgVM
         /whsUs9cl+Ycb2AwF8z46BlbbZhWzq2Pmk/lSOqE5IkoroReJFVjrZ+U+1szEvSK6pmk
         QuYiSTtT7Z/pq6rwN+f6YxFrG2KQnyFXY5sMHbedmi3Q642Ov5MBM/fOix+b27wozxUV
         VDzacX25oMKjSSCEjRbKUnkEQ0yhlLisnQCaTAysRvJTC6r6HiOKf1jTMCBX8OsO+m5/
         RvXYkVstXSGVKRf9ehh9ysEdilZPK5RHl2PY19gQMPVMg125ANzOIdNrBAYetGIAzsNU
         sMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768262056; x=1768866856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vbQpTPqvkNza84fX2uyalXQvb9OzER6/e1aJC0fiWDY=;
        b=sezW57qZukYoi3lwtYhpXi2w1Ca5daByD2cb1oWZ/kUPdgoxypvzKAf2gP4+DRUDC8
         kRVV4UexXp2tkMhrp0vLjD7vxTlqFPwREGOJUNCxWeumfVKlCmMonF9PPzTHDPOx/Nl7
         ZMdtJEpdD+RUb950uacg9x8oef9RhwLwLTC0Agvfx7UoYE3/Ur4QilPKvLPLH/8eVsbv
         nOGmh08xeO0lmRvl96Owsy+DRtwtLy6NgvsYATnyeHvgYmPlVVtJ+ARn0FHybOnV0Clz
         v7j0cQfkW54B6p91BoXSict5a7yZN1cL4yHeSQ5Y6Gxz2aMZ5ztl68p+zoMljxR+zAYO
         zWjw==
X-Forwarded-Encrypted: i=1; AJvYcCVjRqh06CGlri2LMRt6UgBrrwcwt+3SYe8Rtt69qr/wHDQiU4Eae8XniyNejXG4oIN71pI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxemBGC1X8LnOQVY7z3xBmGBfvYjhYWIkBaw+HBDYkskueefn+0
	zp0PCFLAahkkSa0skNtBV5Ix9D5PYJ39FSmGA2xvMAorHxYEJaULVp3SxA3oaKh9n7U=
X-Gm-Gg: AY/fxX4U4/J6Vb0C7qL807v7wo1/6g3EaHXb2ZJ29/yEQqfIzc6ELlMVXmjMXXohcyH
	2X12Ur3jA/uqDH3bZOXgXvKs5JysOx5LV0hyWS/RiQQ3dLox9UNxi77CQ832Ppjoy06SQZ1Jb1h
	qzDCDPfxo7z4izPoHLuAYEi3rVBZE0NDkEw7BfYYFHaYxRs4c5VzSRbW0fw4CkbaRJ6gzeazvAo
	4ZZXMqbiwKf4t884sdKXb+55Jj1j1m45cpEZo89ohL+cfaPQUC/kD3ikDCaqcKyFAE5nzO2YiVc
	aAIz9CubUyDJw0r/+D3Y2iU1pQ24rPmI97OBblP9B1f9+Egx+DrJCMEFT6kjzq5Lo0HDAz2A1rO
	HYUgOFvnzWIVQXOUaqWC5JimT43yHDem73I1DI22TFJAokdxrAAZe0lfw+lVexSqVMAWC6WbPIB
	7y7uMtdVNDiHp0OKmSgZ/fsiOa4sKsORUVUTFrOtYPnNqwyu1rdznUHIqhcKJTUNMLpvI=
X-Google-Smtp-Source: AGHT+IFqShnh4nFq4FI+txOqV94h9FNeJmPa4/JUWRJXzRBu2Yp6JXhvTMJ52+U7dVhw4CMApET5TA==
X-Received: by 2002:a05:622a:8d1b:b0:501:3b8c:7d63 with SMTP id d75a77b69052e-5013b8c8686mr4698571cf.26.1768262055766;
        Mon, 12 Jan 2026 15:54:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8e35dbfsm129011631cf.19.2026.01.12.15.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:54:15 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfRji-00000003fUm-0uFg;
	Mon, 12 Jan 2026 19:54:14 -0400
Date: Mon, 12 Jan 2026 19:54:14 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112235414.GO745888@ziepe.ca>
References: <20260111205820.830410-1-francois.dugast@intel.com>
 <20260111205820.830410-2-francois.dugast@intel.com>
 <aWQlsyIVVGpCvB3y@casper.infradead.org>
 <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <aWVsUu1RBKgn0VFH@lstrano-desk.jf.intel.com>
 <45A4E73B-F6C2-44B7-8C81-13E24ED12127@nvidia.com>
 <aWWCK0C23CUl9zEq@lstrano-desk.jf.intel.com>
 <fzpd6caij2l73jkdvvmlk4jxlrdbt5ozu4yladpsbdc4c4jvag@d72h42nfolgh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fzpd6caij2l73jkdvvmlk4jxlrdbt5ozu4yladpsbdc4c4jvag@d72h42nfolgh>

On Tue, Jan 13, 2026 at 10:44:27AM +1100, Alistair Popple wrote:

> Also drivers may have different strategies than just resetting everything back
> to small pages. For example the may choose to only ever allocate large folios
> making the whole clearing/resetting of folio fields superfluous.

+1

Jason

