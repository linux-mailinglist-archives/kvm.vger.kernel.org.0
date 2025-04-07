Return-Path: <kvm+bounces-42873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87105A7EFB9
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 23:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFE811895778
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 21:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E0862236FC;
	Mon,  7 Apr 2025 21:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DR52gbD3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CF91CB337
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 21:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744060815; cv=none; b=ngi06ggP7JVRjlhI9ALAZdzutnv0A4JWkOiqWibGfMSS97YcY5K0B21LYwfrl3wRD+sSPZjNqq4QVEcQs3NyEgFxClAxcFquu6NbFVqFUmheNvTSRzVK5pLB91aT7g0VnrHLhTV3bNDf1MtUVaAuFFb/Mp2SRN6cy4ovBOhQeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744060815; c=relaxed/simple;
	bh=D44uPz9eheA7kkPhO8XxXusezFNcHg7xlYRPONW/cJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FHEe2lfYI5yBqfpF4nhj9X5ee1uun96LqvPkUut1R/jlJWiyNEl5LfgTYLBBbXfOMrOzYsLXa/eIjClDjLML9B3w5n3irvWhhepwnPhJg/eKTl0BuuMcYgHsIax+2afJ3M5KmWHnKEHJK3n7cYawkzNV0ziXPnxdg4LjNRsa5x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DR52gbD3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744060812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SSsX1dq63c6Sd4M1C8Om043J0hULe8kAcy41TIjjkwo=;
	b=DR52gbD3uWPuuTq/FQPXEAJrvvm2kzdnYAO2m/cz14QEXJl5UAiCiWG2V6Bum6F0wBplkK
	LDUj0nC5U3u7AioYjRpsvandjGi9L7aAlK5MHN3JYEq53C5NdZM1H+zWQQY9dq9BPZzHSD
	1z6ow+BpAj1B5J1CXDl2bz5j6wJSI30=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-82-gFi-UVAZPJqq9qbRwov6dg-1; Mon, 07 Apr 2025 17:20:11 -0400
X-MC-Unique: gFi-UVAZPJqq9qbRwov6dg-1
X-Mimecast-MFC-AGG-ID: gFi-UVAZPJqq9qbRwov6dg_1744060810
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-391459c0395so2020005f8f.2
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 14:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744060810; x=1744665610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSsX1dq63c6Sd4M1C8Om043J0hULe8kAcy41TIjjkwo=;
        b=SbwA+rDJZOvvw/lRgg/bllmupe2Fo6CeC47wJRhVqvyuw20UiBY13ku5VyzHtpFIPr
         ph4AR9m6fS48mW+kDmAHxZ6L8U1dBtcJLf9AqpgL37/PhZbuO5wLPixLdvY1/qLRO7yG
         /z0cJsJ122I6Sfb7Bw8I5MaPUJfPHWj8p+vtYRVyE9gKdAfoJu+60L4smAKpyVsmSCHv
         ql7BOu6KDhsHoGUPoor7IzyQlz0AQ5a8Trq1/rBfSjfgz5YRB2Rdkwcy2Cdc8Ap+9KDu
         tepHvBxauiVIMOIWYAcucak2Yzbt+iaEGDOcgU/QHg/AaYl23VCv9h0wG5AGIvE8ZIDx
         JDbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4ZHPOJpZh3GjltdoKxrtRRjAwcUxoJqPx/u7I/ZPWaVw922+wF2f9P4RyQbOLReJ0pXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJV2ML8IRNYdnkeAHEi5Wd7Hx77lHOflK9JJ3tpcWGhxIPK3h8
	H9bN8qiA4jlbZGClOpN8syYyoZ2Tb4Gm4911duS0unOuHCNaNzbpCjYtQyOCRZ0qmZRf/IQyIq4
	8u0PEncVpow9tko1sB0CLNxSmfvyTs0I7XdiDlgiBWozQPf5TvA==
X-Gm-Gg: ASbGncux+bsZ3KJtlHrl7BCZpCsiZplqSbKbXVbsls3CoDbM5tWz8bTIseg+W3MLQli
	VkaSmGtaWy3ypdn1Vmn0nWt484QrDHLy7fb1GHqzQOAn+7aZRKa/ItJUOg60T3+rz5T6NixNfkk
	hrU+J1oXKUYESBEBDDyGJ7G/2hBifqsX2khcms48bUtmxdv/pBc83zSLNuS9rJMAmB2w1tmm22v
	tlQ+r3+5gRMLk1YvSn4+v97RT130ahAts0xnAGUeUx/i+63296LOU93LIR6cjy6K8G/MV1piKMM
	b0hT8j8B+g==
X-Received: by 2002:a05:6000:1847:b0:39a:ca05:5232 with SMTP id ffacd0b85a97d-39cb3575befmr12282699f8f.5.1744060810328;
        Mon, 07 Apr 2025 14:20:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7YJ3OkxxdjofaKEYzWTRjjkkLHkcDI8DZkVD+3A0SRfbIhe0O3F820zBX+uC97qfAn2pPXw==
X-Received: by 2002:a05:6000:1847:b0:39a:ca05:5232 with SMTP id ffacd0b85a97d-39cb3575befmr12282687f8f.5.1744060809960;
        Mon, 07 Apr 2025 14:20:09 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec34a7615sm140530535e9.9.2025.04.07.14.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 14:20:09 -0700 (PDT)
Date: Mon, 7 Apr 2025 17:20:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>,
	Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407170239-mutt-send-email-mst@kernel.org>
References: <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
 <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
 <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>

On Mon, Apr 07, 2025 at 08:47:05PM +0200, David Hildenbrand wrote:
> > In my opinion, it makes the most sense to keep the spec as it is and
> > change QEMU and the kernel to match, but obviously that's not trivial
> > to do in a way that doesn't break existing devices and drivers.
> 
> If only it would be limited to QEMU and Linux ... :)
> 
> Out of curiosity, assuming we'd make the spec match the current QEMU/Linux
> implementation at least for the 3 involved features only, would there be a
> way to adjust crossvm without any disruption?
> 
> I still have the feeling that it will be rather hard to get that all
> implementations match the spec ... For new features+queues it will be easy
> to force the usage of fixed virtqueue numbers, but for free-page-hinting and
> reporting, it's a mess :(


Still thinking about a way to fix drivers... We can discuss this
theoretically, maybe?


-- 
MST


