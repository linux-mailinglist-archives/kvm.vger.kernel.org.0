Return-Path: <kvm+bounces-68091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10156D21724
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:51:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B3DD4302C730
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4D83A782A;
	Wed, 14 Jan 2026 21:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P6vtWoYC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CBB3A1A2D;
	Wed, 14 Jan 2026 21:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427308; cv=none; b=u3Ht+k1ndcXZqlqdXMF5cv0YdmE0ANtTJmdAt9NmjosOz6mWnhzUElSY3SpJguQELWXQPH+ndVUowAEMU7fpGtJAOLLalOSf5vrlbJOlPCBOi1RlpmE+YNPExTdIk2gs5PsS3KJy2YEDTLHgbPMTj4ydqTxG6eXqiPnomoaul3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427308; c=relaxed/simple;
	bh=sVjE+SfQsdIUMHLLdK2WZZMe9meeOIqp+vLdzF39rao=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=LzxoLsEZ3DVYR6AqSMUSlI3YLt5og3DqD4e1eVbXkAVDhgh+R7k4YcQkFT5sNYKu83kjEEXRdDaukea/TijU4UIWBVxJCc/WCHTsN0SG7uIxvfNOpbUsBM94cxGdvT5ehKxfo8koGaUQA2LHfePCK/PhqW0/Vgq+ePAQqmOv4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P6vtWoYC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94455C4CEF7;
	Wed, 14 Jan 2026 21:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768427306;
	bh=sVjE+SfQsdIUMHLLdK2WZZMe9meeOIqp+vLdzF39rao=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=P6vtWoYCIlr2XYuGHN8Ct1JWv57QVflPPPZ09aqbdSf6sWvv6Psm4BbFl9dEKxvME
	 9IiuEcpRE83qTyXp72NniYCaihdkRtUtnm5MV6es8ZMUNP2zri1F+QO+WeYttAzUaW
	 ul+FCK9Uuub6AWdHHLL0xvAdQEb3R2ZlrFvcN/18=
Date: Wed, 14 Jan 2026 13:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
 <apopple@nvidia.com>, adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Balbir Singh
 <balbirs@nvidia.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260114134825.8bf1cb3e897c8e41c73dc8ae@linux-foundation.org>
In-Reply-To: <20260114192111.1267147-2-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
	<20260114192111.1267147-2-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:

> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device
> private folio. This step is necessary when the folio’s order changes
> dynamically between zone_device_page_init calls to avoid building a
> corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> must be passed in from the caller because the pgmap stored in the folio
> page may have been overwritten with a compound head.

Thanks.  What are the worst-case userspace-visible effects of the bug?

