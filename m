Return-Path: <kvm+bounces-49912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60CDADF907
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54EBC4A2546
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC0C27E05E;
	Wed, 18 Jun 2025 21:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CvKb8rLA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A349627A10A
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 21:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283921; cv=none; b=EYSR1Gq+OG7Arw+viCyM4OrePwY0jKqnOpJZ1Gxpfoc8FindaHkxQjllHh4XsL+Q7U1fdaeaGZ+G2zG3Zvokc5qcvM1T/Y6kgs66iSP8UL5PbUtdSi2acJFJ+OoCasj00GMon9PX6ITP0qaVtcM05vBfNhBU7R143WrNgiPlFnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283921; c=relaxed/simple;
	bh=nvNUehmGsO5tw+lIcXPFTGg6dwqcpKM25XIsx8qQqWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJXdydauPlEphChWdsF8yDgMZumtprZ8ZKfOL9rIFAbVAjrYsm1La3MLeEr5yC0JbrJhCHRimTfhYd7uFf85q3gSp8SbKSaf2NuWqy6CEOceKMrc1ot9yuG/NcFFVrEhhWuag2Ylj1wZfERRtnrJ2QSRSlwVPA4ofMaSk/MmVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CvKb8rLA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750283918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1GX3VR3zwwzoNvJnv6ba5Oys9yAv3Y+PfHmnkUbPaN8=;
	b=CvKb8rLAyou0RetMKejeakHosxAxcPBacGvDP7xJ/CeOcsg1KcaLP95v9WtK3XpBPoSDvh
	z0LG+9jqmO4p8cxGGTFSCF2EMMeFml95fKu5Oi/IczDrh3978/KniyLjF582cdu0c4q7w+
	DHII3flgoV7MfpPIPa6iHHM7SCWB1no=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-JJi2qb2RPAS5EiFu6ehk5A-1; Wed, 18 Jun 2025 17:58:37 -0400
X-MC-Unique: JJi2qb2RPAS5EiFu6ehk5A-1
X-Mimecast-MFC-AGG-ID: JJi2qb2RPAS5EiFu6ehk5A_1750283916
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-748f13ef248so88472b3a.3
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 14:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750283916; x=1750888716;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GX3VR3zwwzoNvJnv6ba5Oys9yAv3Y+PfHmnkUbPaN8=;
        b=jbUJA1UsbLgEqFrXWSkvJIlPYccq3Aal1H+0kd6qN9PAfr5t+P0qsdCK393vz/+xJa
         ztNVCdN+jcBUU68H6kHOItGuIcrsv282kiXp6A9AiMVSu1yDidwSlFXY78TnlMyA1mAL
         JoxVaiS7IPElPJugi2OsMHOAYm6KTkG1xffz0p/f5zAc9nRzGKl+hovfpWYLrx/4hup+
         Tjb4waJ2N8acJ2r9Nug71LkRQfzqXbhEuMO64zcHGhixi+FNyFjz2rXfFPMR91R/nvEi
         QxXxHuIitXp6cjc/4HUqHu8lzdciDoeCeXJ1Hqgz2vVNmVsOo1m6Cn6Rx1BXwmKC/8GY
         OuUA==
X-Forwarded-Encrypted: i=1; AJvYcCX3ovTsUiBT3RxlgGkDDRrVLLPM1wFiuCmbDGEg24H2McD9+gapyWinK+yE0/aa+leC9mE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzREj34b3rN7lCuYoZIxDNafzgZK85W+y/KzWmwgD7pMZBPnaa9
	m3LVvmmQJj01GhLKzermKFuaIUt9SN8GgZPURSwQ/Zt7iQ6vBXuF1n5KO2smYkfuDmps8i9OqlU
	6GCLHgS0pMvsEsGJL1GeP00M91BaNaw8Jaq4LKCbVLN1vnx8Mfy10cw==
X-Gm-Gg: ASbGnctbAls7/tL0g40KiUSR518IHThl4MCxpICERJeyaKQREXbcFS9jirDjEFIjQ8Y
	OOFqw8CowOnHcTI982fAcUX8AdZaeyXBrJ42G2Zg4DCfRo1F/GQ+g4QkH9KWMC5uTvsWTQeWV+o
	+SB+HVk6FhjNdfUQcqY2xZ5vAxPPHevF23drg7VyvIAM2LKCFtVybxyxxsIdkaIZ+k7Zq6GHe7m
	4P2f5ipUVpivHPUBvNf00pZkNNsZPz/yzYxEYngxRYFHoy0AWv4uigHFZ+SUbuHVh+JIm8yjFVz
	7Hz04c/z0Qi8mg==
X-Received: by 2002:a05:6a00:cc8:b0:73e:10ea:b1e9 with SMTP id d2e1a72fcca58-7489ce45c6amr24603954b3a.6.1750283916095;
        Wed, 18 Jun 2025 14:58:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrGuvcRJ9h3sdim+cF5rfkGm/rfr7TlO54C2ki4yjnMzdbBlFJZcbtUwlDFQVM32x8tAx0IQ==
X-Received: by 2002:a05:6a00:cc8:b0:73e:10ea:b1e9 with SMTP id d2e1a72fcca58-7489ce45c6amr24603925b3a.6.1750283915692;
        Wed, 18 Jun 2025 14:58:35 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7489000749csm12088504b3a.68.2025.06.18.14.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 14:58:34 -0700 (PDT)
Date: Wed, 18 Jun 2025 17:58:28 -0400
From: Peter Xu <peterx@redhat.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Gupta Pankaj <pankaj.gupta@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Zhao Liu <zhao1.liu@intel.com>, Baolu Lu <baolu.lu@linux.intel.com>,
	Gao Chao <chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>,
	=?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v7 0/5] Enable shared device assignment
Message-ID: <aFM2hFgjiBm3nML6@x1.local>
References: <20250612082747.51539-1-chenyi.qiang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612082747.51539-1-chenyi.qiang@intel.com>

Hi, Chenyi,

On Thu, Jun 12, 2025 at 04:27:41PM +0800, Chenyi Qiang wrote:
> Relationship with in-place conversion
> -------------------------------------
> In-place page conversion is the ongoing work to allow mmap() of
> guest_memfd to userspace so that both private and shared memory can use
> the same physical memory as the backend. This new design eliminates the
> need to discard pages during shared/private conversions. When it is
> ready, shared device assignment needs be adjusted to achieve an
> unmap-before-conversion-to-private and map-after-conversion-to-shared
> sequence to be compatible with the change.

Is it intentional to be prepared for this?

The question more or less come from the read of patch 5, where I see a
bunch of very similar code versus virtio-mem, like:

        ram_block_attributes_for_each_populated_section
        ram_block_attributes_for_each_discarded_section
        ram_block_attributes_rdm_register_listener
        ram_block_attributes_rdm_unregister_listener

Fundamentally, IIUC it's because of the similar structure of bitmap used,
and the listeners.  IOW, I wonder if it's possible to move the shared
elements into RamDisgardManager for:

    unsigned bitmap_size;
    unsigned long *bitmap;
    QLIST_HEAD(, RamDiscardListener) rdl_list;

But if we know it'll be a tri-state some day, maybe that means it won't
apply anymore.  However the rdl_list is still applicable to be merged if we
want, it's just that it'll be a smaller portion to be shared.

Other than that, even if I don't know how to test this.. I read the patches
today and they look all good.  The duplication is a pure question I have
above, but even if so it can also be done on top.

I do plan to pick this up. Paolo/David, any comments before I do?

Thanks,

-- 
Peter Xu


