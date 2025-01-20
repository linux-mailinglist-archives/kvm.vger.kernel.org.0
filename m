Return-Path: <kvm+bounces-36070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0DB1A1738C
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 21:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F07C73A355A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 20:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BFA1EE7AB;
	Mon, 20 Jan 2025 20:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cCjUP9Pf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9164B155A52
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 20:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737404366; cv=none; b=byV+FD8nEfww8JNMO79/Xx5eJZ/ACP92hixN0IafCTHB699JPgJ7evlMYHqmRCq4ai6Oq5tZSl7y0Iva13YoJ3L77xAEw0RdqJrV5/pkWr6FTyoEgAHN+NlZR1H4escyQSUhQFE1VAHiTTLfG2Pa+Nz1pblQTfEvU1oKGZ9sLJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737404366; c=relaxed/simple;
	bh=dWC1FZVSBtp+YVt1YlOjaCqU/+hTOBjfdOMJu29G2iQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcJg0MF1BCzq9ePmB1OB0xv4bqBZz9JDMANv9S59rtzOaZB8SU5KK+xQa9K1X371giKyQwoJIPnhx5bf9EYTr3ToB2Wxxgb0DuAYS8d25iCE/k1EVeGL86itxc3xk04jaqG7WQvcC1dEepyQ4CJV5B/+T/VbdDW3Idnf8FRYNLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cCjUP9Pf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737404363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUWDGIwO1FbEQxMvPfuVA74bL427fymFcpQS1Zu4RrY=;
	b=cCjUP9PfdCV6ueD8367+EfTfqntzGCaziBh7Tj9CQlpp5GpM+orqAowgyNTTvkTD+thDVC
	MJeIy1gts1PF9NIXk4iaQ/8FNuoTjS88tVMf+8x0i1FMHEaw4eG8O+MOJf7n9OVMYw5aP8
	m9Uhr23k7qHoYav3bkiwoomnV6C+8qE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-kFU-zON9PROoD8EHyt2j_w-1; Mon, 20 Jan 2025 15:19:22 -0500
X-MC-Unique: kFU-zON9PROoD8EHyt2j_w-1
X-Mimecast-MFC-AGG-ID: kFU-zON9PROoD8EHyt2j_w
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6d87d6c09baso73929676d6.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 12:19:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737404362; x=1738009162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jUWDGIwO1FbEQxMvPfuVA74bL427fymFcpQS1Zu4RrY=;
        b=bmPKgqM8+lXCF/pcqUDpuvNFOcLgGY8fX1sQOxq3nmP6qBUnDIXMYSGAh3dFchp+R0
         bti/XTY5VV8CnkTq/UHzQcOYk6grqyTQ0x3rczTJrPppe18VOCpK3+KNMEtiWPjU0CQS
         eA0eydPoT5mkAB9+s7T7jBE7YEz1lFHxYos6SCBfmig/RiKwM3OBrnFF+FJQLKMY5Rgo
         w6/lhH8wwVdYZJWR1Nx0cfOI4HxUbz++txTKEEJaSuVMDKSzGjSYkX+vaOLeQfahFsxP
         g66qW0eMLNlYU0Lmz60WCKYbW8HqqIENp6eSy35Of642cc+2LqZEmbsvQc0JoaRjJuD7
         h8ug==
X-Forwarded-Encrypted: i=1; AJvYcCVjJ//nc5TUGTATNal59EklKVBbCcjkgqcyOmJu7vZuDTQfwxasVTiSrRKo98tcOCxQOOA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy84IN16tuxt8Q6zrQBG5AZh7uFgfcxmrzHyn82ihprWdJR6iZG
	ERJX874HGZrg7DVTZURGQ5eMw+b+RcSc9RfABSJb4Qx8Z3zAHFGnbXoOi/fS2pGU64mg5Z8SctX
	roVDj481tdDqYzXMI/+hNxTNqPE6vRTLMFSe2J0YsgcH0Zg1oCg==
X-Gm-Gg: ASbGncvVDtkm5wjkGWX1RPLjSAa2U1omCs0sVO3zP9XyQ/BauFBRSWm5w85YyqK8ICu
	IQEO+UV998GENZZEpQ0KYHBs0uOcK2ASFxdW/2YAqn6v6Om4lpWJ7idqepZyGXkGgMrsYbWlSXA
	urEoxYwAp6SE0OMjIZkRgr6AvSBpJjzpb5zWr5DyJyvARf/xpCQbmaZbopmhJZ4b6nREipEY4So
	3x9spn/q8EjmO/O/u9cg9Liedf0FJj+8ciW+3+7oa84ltH+19KMYDBjKPMgb91CjvgUsTEKbQC0
	mp2E0lBH0jQx7r1pj901VokDVvwB41U=
X-Received: by 2002:a05:6214:570b:b0:6d4:25c4:e772 with SMTP id 6a1803df08f44-6e1b2251083mr288914406d6.36.1737404361956;
        Mon, 20 Jan 2025 12:19:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEdseRQA0lTqL+ahCpBlb/Tkp1YOBsMwNUZ0Zhdb+QMVK55z+vsjtUKotEmMM7kRLN7wC+2zA==
X-Received: by 2002:a05:6214:570b:b0:6d4:25c4:e772 with SMTP id 6a1803df08f44-6e1b2251083mr288914096d6.36.1737404361716;
        Mon, 20 Jan 2025 12:19:21 -0800 (PST)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afcd5a2dsm44510926d6.72.2025.01.20.12.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2025 12:19:21 -0800 (PST)
Date: Mon, 20 Jan 2025 15:19:18 -0500
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Message-ID: <Z46vxmZF_aGyjkgp@x1n>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com>
 <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com>
 <Z46W7Ltk-CWjmCEj@x1n>
 <ba6ea305-fd04-4e88-8bdc-1d6c5dee95f8@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba6ea305-fd04-4e88-8bdc-1d6c5dee95f8@redhat.com>

On Mon, Jan 20, 2025 at 07:47:18PM +0100, David Hildenbrand wrote:
> "memory_attribute_manager" is weird if it is not memory, but memory-mapped
> I/O ... :)

What you said sounds like a better name already than GuestMemfdManager in
this patch.. :) To me it's ok to call MMIO as part of "memory" too, and
"attribute" can describe the shareable / private (as an attribute).  I'm
guessing Yilun and Chenyi will figure that out..

-- 
Peter Xu


