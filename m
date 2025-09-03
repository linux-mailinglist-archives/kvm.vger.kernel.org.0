Return-Path: <kvm+bounces-56659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF45B4135B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41EAF7C0345
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 04:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1010C2D3A86;
	Wed,  3 Sep 2025 04:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rq3YJEix"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3561E573F
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 04:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756872064; cv=none; b=NPwUj1q3cDmRgxGU43g1e9nAbNAkU/Cr9oMF3imz5esg4MT2IE+7Ze9cLZo2GktWGeRsXTy1YT8C0u64rYMvgPQWEJcFegHGI9zYJvcT4pxjsFHenOKHtHYUTL+BcsJ+CaouwevFKgn48olDvKcX03aF6fLL0V2YhXH9Fbyyqaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756872064; c=relaxed/simple;
	bh=U0jjFOIRPE2pVoUMIlyB9h7+kH8XE4j8UQpdjONzyjE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sud1p6wM0WjibeAv4jiWaCcSMMK9Mm2I4xCfY/hQ6s5y9E+5W7K4EeVgOWtsgl04OSTbuiciHrB2vLWPt37WGKlaOgS+vZ6efUEadjoLm62R93vPqLIgNa2t8mJ+DISOUlJZotnyyhQsHmuhf7IIwPir7fKFRmqoVZrtME4k06M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rq3YJEix; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756872061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0jjFOIRPE2pVoUMIlyB9h7+kH8XE4j8UQpdjONzyjE=;
	b=Rq3YJEixY7ohrbxnabbZIPC+t7fhf+tzRbJvufc4ZCh+5OHpmwhPm207ZfE+AO1RK3gmd2
	OTb3doHZqeNSl2ljs653KD1K89GwG9FfbsOl+1fE6ZnYbg/RpW9YeZx/vTIm6bRlkdhCeK
	RrLzxGWDZjcpW2pf3LkUlz0SFQJaTKk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-KB6ibQzOOhCagFZlJty4vg-1; Wed, 03 Sep 2025 00:00:56 -0400
X-MC-Unique: KB6ibQzOOhCagFZlJty4vg-1
X-Mimecast-MFC-AGG-ID: KB6ibQzOOhCagFZlJty4vg_1756872052
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-329ee69e7deso1292953a91.3
        for <kvm@vger.kernel.org>; Tue, 02 Sep 2025 21:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756872052; x=1757476852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U0jjFOIRPE2pVoUMIlyB9h7+kH8XE4j8UQpdjONzyjE=;
        b=ocI1LzZlVQwrIOIzDNg4CAUYt7BGl4yM8gX4hPh8tTt6TmEuTTAuqSJH2X3sNc2A0Y
         /B8DnNewWhZGSTGjjLPLacelWGOtwGin3EiWayL7kNAcEdh10km73McsoWLJ4SkuC2h5
         Ma7aWvxSSMhRkVOmINiRYcoT+69++JmoSS2u/Ok10b/OgYJRjB+IfYEsNHtI40BoAOAY
         sQu6Hw0zdHC/DWCkyoJO1o7FkFfq7b0DhG4l9yKLXktf8v0sIn/4zCLQZgcZ14EsYc0V
         PQjU0FiOfU64TDPZNhUalJ3MYyuxqYq7aEjAeMEkjQvyXYmadXBNWuk+QQA9gYhNOmaB
         EpOg==
X-Forwarded-Encrypted: i=1; AJvYcCUfYKwG4dAgKBZaS9cOWjardhsGENExqyFw0chQPRuUNSWgfVDZTBAfmL+dGAtqsd/0QHs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzioBDuDUW5kxi8iirjBgMwKhmOrmGrTsNI7rzI18OmC4NxqAAh
	StVMPCL9dN98LwkMzi9htmktGNHx0BKwcGzyNW1CIX7ta9Wy3FHIzLmdroOmj0BkotBgWU44sCM
	6bEtPeV851DHrkjCcsFsxoXh+7jCvx0fZJ/cxblfIet6ohsySALP7VdQ4mh3Pj/hRBrM/FW6Uiv
	M9vbDeS+3EDTSpPkqfwbflW0UH+kGv
X-Gm-Gg: ASbGncsjRskh6HqoXCYhZQ+B+0KplAqPbx/sxiKGI75X2IDy7tK9Voy7u9GDZ8EhNb1
	bGX1FdPpLTch9rnx2OrpxOpFBnelGtwRNk5iT+iQZKi329QslU/4kh+kfci3jB/QHf0fBVYqhVo
	fqHajubqQ93yImw0xlJCVz1Q==
X-Received: by 2002:a17:903:1ab0:b0:246:76ed:e25d with SMTP id d9443c01a7336-24944b15b8cmr169377685ad.50.1756872052066;
        Tue, 02 Sep 2025 21:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5aB6Qqxj9qWYTbp0SCLMQoviI6dY5kYYbJnZhA2Hm84dGyl7OdRCsvBI+vTe21NUsYwxF2ONdt98uJqVn0hA=
X-Received: by 2002:a17:903:1ab0:b0:246:76ed:e25d with SMTP id
 d9443c01a7336-24944b15b8cmr169377215ad.50.1756872051574; Tue, 02 Sep 2025
 21:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
In-Reply-To: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 3 Sep 2025 12:00:40 +0800
X-Gm-Features: Ac12FXzvemknOpwKY7V_bPmSMDz5x5JOaUgCJhdjwkkYam90CI_kt2z3omxI2R8
Message-ID: <CACGkMEviyLXU46YE=FmON-VomyWUtmjevE8FOFq=wwvjsmVoQQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 0/4] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, mst@redhat.com, eperezma@redhat.com, 
	stephen@networkplumber.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 2, 2025 at 4:10=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> This patch series deals with TUN/TAP and vhost_net which drop incoming
> SKBs whenever their internal ptr_ring buffer is full. Instead, with this
> patch series, the associated netdev queue is stopped before this happens.
> This allows the connected qdisc to function correctly as reported by [1]
> and improves application-layer performance, see benchmarks.
>
> This patch series includes TUN, TAP, and vhost_net because they share
> logic. Adjusting only one of them would break the others. Therefore, the
> patch series is structured as follows:
> 1. New ptr_ring_spare helper to check if the ptr_ring has spare capacity
> 2. Netdev queue flow control for TUN: Logic for stopping the queue upon
> full ptr_ring and waking the queue if ptr_ring has spare capacity
> 3. Additions for TAP: Similar logic for waking the queue
> 4. Additions for vhost_net: Calling TUN/TAP methods for waking the queue
>
> Benchmarks ([2] & [3]):
> - TUN: TCP throughput over real-world 120ms RTT OpenVPN connection
> improved by 36% (117Mbit/s vs 185 Mbit/s)
> - TAP: TCP throughput to local qemu VM stays the same (2.2Gbit/s), an
> improvement by factor 2 at emulated 120ms RTT (98Mbit/s vs 198Mbit/s)
> - TAP+vhost_net: TCP throughput to local qemu VM approx. the same
> (23.4Gbit/s vs 23.9Gbit/s), same performance at emulated 120ms RTT
> (200Mbit/s)
> - TUN/TAP/TAP+vhost_net: Reduction of ptr_ring size to ~10 packets
> possible without losing performance
>
> Possible future work:
> - Introduction of Byte Queue Limits as suggested by Stephen Hemminger
> - Adaption of the netdev queue flow control for ipvtap & macvtap

Could you please run pktgen on TUN as well to see the difference?

Thanks


