Return-Path: <kvm+bounces-61963-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3DDCC308B6
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 11:37:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 296373BBF08
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 10:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 401D62D73A7;
	Tue,  4 Nov 2025 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O+WnJ9Ah"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA291D90AD
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762252648; cv=none; b=hpv+zdZf93aotMCutor9u39+EJCaOJdYhwEJdUB0Xv9uRco9j8D3lWIdFyAaLMwJSVI/Sqm0Zts4sSlDkMxNtbxJ1Ohqi7DxoYq61iXAkxeQX/b1RXwqT9UrS/oTRq+B9DO221chQroHjdnqx/eIYm99ePEai3LDb4HqKA658iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762252648; c=relaxed/simple;
	bh=v8zG2e4TYh8HI28N1gaia3u1IQr0AA8J+GRTSgdfhoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OgvZSA/850Vc02cSX6/N8zXy/IrQnKSDYVW7UCFgS2gig425Vav9piN7cEgpe6CBP1GTDhfNM432NRhT0/oPcusmmPf466mx8eADi8u66iLmZuPTs1/5awqyXl61Zp+hS6PFGw9XEFBLTzXQmJE4N9lTYc96/7kmxRFkrOEp5xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O+WnJ9Ah; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-47758595eecso1859525e9.0
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 02:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762252643; x=1762857443; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ne4ZDSlj913IS0afaCeah9/sHQf3Ytf7YNZFUi1jMY=;
        b=O+WnJ9Ah2VyHBrkKQlkZBmZ1Qre3JWPRNTix2PP2ii8vPWhScYQSmtVfTcLkCQOip2
         PSBRr6b2d997dBR9BswZ9xNtmlWB3ketx8y54bEKb/iu+kCtP1Vd2ta9u52Hq6z6ughD
         1B3yWUMwhbeiV5pA82MhkvOfkDWLKTDcq5GeH7YTJeSSh+v7UC2VDX4PS0DOQ/lc0/8i
         VI3GHV4tfPPSbHQU01cFGypkgSl9UmweoznFO7xnzhKx+SSA3PnnyBqyIh2M1VFB2y4B
         sh7BfPQLX/uy9qtrTpdW7yhRSp2jeQNwTCcmLoxQoihKN9+o3yzrAQpDiLtXgjkcz4md
         t++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762252643; x=1762857443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ne4ZDSlj913IS0afaCeah9/sHQf3Ytf7YNZFUi1jMY=;
        b=qSr7prN55Y4qTLGEWL9yLKTyxgcxOfBzApXmW1ggSk+SQ7HQdnYfg4yAXQtlaXhWCe
         DfFm9711y32+YnTQi2cWqUrgG+ZPS91Ju/HKamlHT3f/fqVWiWKRJOTIvLz49xNU7KQY
         pxwgU/zVhQ8+Z4H4pUVaoIqo2f0w0m+VrmbGAltoe75r7h9SEnPMWVLqbD9XJjmvSaEy
         g7ZR6ls/tnpEh+NDrbpmSsDXT7tXZZQbqAj6in2Kqfuh3lG+7XxAZJcnoqM1eBE7hZz9
         4b01RI/3LKESJjQNiUsgr0ZujVuFyL6fmgZADfdhtKF4WiXpqaArSl3M383yse+L4GGr
         htFg==
X-Forwarded-Encrypted: i=1; AJvYcCW+5XXibz5d4KiKf9f3M1dHiaUwhnK9XI7yhwBTaRrt95apLhFhT4nYSFXDx/GCHQJftRY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY9gLbuem2yxWWh0ngQD0JymxygCLotsOtUSfVtjsA8V48l45B
	17ZLa7/t7nfyF+sMKldmpPVhAbZVeoWME3DUm8bzX/UjHrwVhSheVYTip0eMQREyYEY=
X-Gm-Gg: ASbGncvekeEYgW394qRi8kTN/KX97uDLV2rJiLA1FtFOlGLKCJ8qQtooyrDJPN+4/Sb
	l+9tjcP23tmyMq1DtvJd229rpfyLKCekdfi+NCHj+H7pjnSreyp/QNWSC4lgRKYz9+3o5+CQgRo
	k6xkWm5oPAHd0EozfZjkqL4mV4ratz+o2xrAM5wKlrRqsisVIycZ44pI3ACuDJTHKzohyKbmZFX
	v71gTLdzh/2Xwmc1JPHlEu4EoXp9YWPdMu8PfZgtKm4YFUcxnAfJ1rT3kZCckGlUQdN7pdoydXB
	MQFIcMhkXx2rLLemxuMFVuFSjVmOwQLemNnRS4MjkjNMJflyIG4B22EOMnrRuPPZP1entUa8DUC
	eqcVi2faDIQp4LkpDdH73DzjAVfiapNyE/REzeh8DDfQp2SUoUTrGgKXXOACI1e6gWPwsqW9chU
	VInF/CodVu
X-Google-Smtp-Source: AGHT+IFf1wOTlsdo8GWYHh8jAMEFl3Fd6ZMSKUjEHUzMaQyfhIP4OVI40+a/WDrXsXYVLl3vLVN/Zg==
X-Received: by 2002:a05:600d:4390:b0:477:333a:f71f with SMTP id 5b1f17b1804b1-477333af9f8mr83874795e9.17.1762252643284;
        Tue, 04 Nov 2025 02:37:23 -0800 (PST)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1f5be4sm3680221f8f.31.2025.11.04.02.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 02:37:22 -0800 (PST)
Date: Tue, 4 Nov 2025 11:37:22 +0100
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ankit Agrawal <ankita@nvidia.com>, Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Matt Ochs <mochs@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>,
	Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>,
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Message-ID: <aQnXYsPR7zkV_ram@tiehlicka>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aQjy0ZsVq7vhxtr7@tiehlicka>
 <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>

On Mon 03-11-25 18:52:26, Andrew Morton wrote:
> On Mon, 3 Nov 2025 19:22:09 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Hi Michal, I am trying to replicate what is being done today for non-PFNMAP
> > > memory failure in __add_to_kill
> > > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L376).
> > > For this series, I am inclined to keep it uniform.
> > 
> > Unless there is a very good reason for this code then I would rather not
> > rely on an atomic allocation. This just makes the behavior hard to
> > predict
> 
> I don't think this was addressed in the v5 series.
> 
> Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel
> more reliable.

This could be done on top of the series because as such this is not a
blocker but it would be really great if we can stop copying a bad code
and rather get rid of it also in other poisoning code.

-- 
Michal Hocko
SUSE Labs

