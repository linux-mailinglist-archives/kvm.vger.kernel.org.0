Return-Path: <kvm+bounces-36127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C59B3A1813D
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:38:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BA0F188B588
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:38:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8097F1F471A;
	Tue, 21 Jan 2025 15:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8yCHvdp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07D31F426C
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737473905; cv=none; b=CJzYOEHt+jKy29/g1lvk4SE26ZZ/WJsbq40fVJcUeTtEQJp+WhOruzL4Z7Rft0xp5OSzPZhz0Ts6RtyU+wzTZA8COKjRjfQjMaZz6RvUbn20fG8ieVkBSh7Iqb9u2NmXJp00gBCHJ1FKzqWMLVYfUC3j8uzU/UEKMrvDQAlFKsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737473905; c=relaxed/simple;
	bh=tKzVu7K8VQrnqwY1dpCXix1mUXtPfLMWbHDXszQyeGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3w4yWI8b2z1eo8oW+QTYSSWi6lae8o6Imccwgy6aMThS5aRu3cIr/YMSyGpZ0pc5f64wM55QIqx+ysLSNqlVlcr3gX6sOxEqoyDDorlIwSNs5Ur1tTEM9UcGYNA8+puU0UFUCtocoLr9joTBAmor/Jk8lkIHZxBbkjxaZ93FuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8yCHvdp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737473902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7vWlp2CUskTYXbSVehnKEKMyRmaqBpVNMhezv4fMKgM=;
	b=S8yCHvdpwWTu6fXVdMRGrKktSrjDDJFOtQ+6kIukbsABgV9KFtUV2GyIz76AsZVf84qXX7
	SGbsVzilXvwNlDPuZOJam6yXIVSGagx1spMb9Pjf1eCh5SDohoviGgTMS8spJKY37akc3Q
	GqTPMqDjhkqa23TjZSs92sqk1b5g7fA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-gT9PfDZWNrqQ-6aLEPPL7w-1; Tue, 21 Jan 2025 10:38:21 -0500
X-MC-Unique: gT9PfDZWNrqQ-6aLEPPL7w-1
X-Mimecast-MFC-AGG-ID: gT9PfDZWNrqQ-6aLEPPL7w
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6dcd1e4a051so107597546d6.2
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 07:38:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737473901; x=1738078701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7vWlp2CUskTYXbSVehnKEKMyRmaqBpVNMhezv4fMKgM=;
        b=JLiMTTblFZD5WMze9fR3evC/5DZPZLOygNU1ufu7sxSZ+2+TGaRMAc+vwLCS7a8/zI
         RMiJ/Tw3BhJq/IVupoDgybhIixZDvU+zddOT+hU8vtlOqpcPik36BdU6L8Wv94dhtXjv
         xT2QmRAMwnf9cB43shhEbCPUcS8PGY3hEwdgDjMtMAUa660YU0txdUFm+Pj0E569aiUL
         Jax5WN8iCg3dbi62wuL3hBTzsKft6yLykIRjSDc+IBkimR1HRwBSKzaleCt0S7n+J+iM
         VIrMKig/GX5Dn7mdJD+bdNxLGqZfnm61tLTqlbEuV6mNVF87D7j8NUIiI5c5b/BpnrX6
         sY1A==
X-Forwarded-Encrypted: i=1; AJvYcCVoUC/SblBL9k4kYR7jkY8DsquwfoD9sic/esmEYv/43pnxrj1Im+yNENpqVGduTD95bmk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjQQJfFq0/7KPkloA4DEwiAMCXDBzOc7613RNHb7Zb2Z/P/2lB
	Ef9h/D1HZB5pLNqzP6PntTt45/yTYnBvjGSfeClJx/+IaNQ8VOmPh2/M8YKuk0hjyMmEmgObtzl
	Rpc9jcc9EXtntmcfqWVvMHc4wHeC7J1yXBthz18D251hy1Cje2w==
X-Gm-Gg: ASbGncvIabyKojuSoirJEjuKd6UCxvicwERfv2heppyFVFrZ19JH09sjh6X2nE9jAYY
	CGS7UustWI/kvJfKnmuVcxrpUXlpleIPp3LuAZrLzIDgQSUio1ywo8dnfc8zpcaI7te8tZoOmy0
	g77jKN4yiy/6B9VOR6LHr5ymgz+Oy9NeBN29kh5jx7ShpWJIGL/C1zQPkZm0/QorSHpZuLLesXu
	PtvuY9ln1hKrd28FojSJKz1BkArgXQmEFoKiqdIZnTefXiUhXW7WAYpN4Uo3pBse91vgB2HfhHY
	Agtzy185aO6Z35k/lB4YWMvIRKnD2yc=
X-Received: by 2002:a05:6214:1305:b0:6d3:fa03:23f1 with SMTP id 6a1803df08f44-6e1b2186a41mr285474096d6.13.1737473901085;
        Tue, 21 Jan 2025 07:38:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHgfx1VJkB5kdl2P+V5WFmu/JkUYutt6JPaRTYfjpiG4rWtIeQDLUTt4TZ3FFWubwJB5OXSGA==
X-Received: by 2002:a05:6214:1305:b0:6d3:fa03:23f1 with SMTP id 6a1803df08f44-6e1b2186a41mr285473756d6.13.1737473900788;
        Tue, 21 Jan 2025 07:38:20 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afbf3783sm51948996d6.7.2025.01.21.07.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2025 07:38:20 -0800 (PST)
Date: Tue, 21 Jan 2025 10:38:11 -0500
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z4-_Y-Yqmz_wBWaU@x1n>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <Z46RT__q02nhz3dc@x1n>
 <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a55048ec-c02d-4845-8595-cc79b7a5e340@intel.com>

On Tue, Jan 21, 2025 at 05:00:45PM +0800, Chenyi Qiang wrote:
> >> +
> >> +    /* block size and alignment */
> >> +    uint64_t block_size;
> > 
> > Can we always fetch it from the MR/ramblock? If this is needed, better add
> > some comment explaining why.
> 
> The block_size is the granularity used to track the private/shared
> attribute in the bitmap. It is currently hardcoded to 4K as guest_memfd
> may manipulate the page conversion in at least 4K size and alignment.
> I think It is somewhat a variable to cache the size and can avoid many
> getpagesize() calls.

Though qemu does it frequently.. e.g. qemu_real_host_page_size() wraps
that.  So IIUC that's not a major concern, and if it's a concern maybe we
can cache it globally instead.

OTOH, this is not a per-ramblock limitation either, IIUC.  So maybe instead
of caching it per manager, we could have memory_attr_manager_get_psize()
helper (or any better name..):

memory_attr_manager_get_psize(MemoryAttrManager *mgr)
{
        /* Due to limitation of ... always notify with host psize */
        return qemu_real_host_page_size();
}

Then in the future if necessary, switch to:

memory_attr_manager_get_psize(MemoryAttrManager *mgr)
{
        return mgr->mr->ramblock->pagesize;
}

Thanks,

-- 
Peter Xu


