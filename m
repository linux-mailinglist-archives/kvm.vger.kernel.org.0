Return-Path: <kvm+bounces-29870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3AAD9B3721
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 17:54:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A7841F22549
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 16:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294731DEFFE;
	Mon, 28 Oct 2024 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fpfpRXM+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D1C185B54
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 16:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730134451; cv=none; b=o5Y2C9SkGW6c6iUU6sWOtea4JQr65MdjUQmsk/I0oE686sl4XjORct2479uRBq/judt3Hu6RZ3hwytQJt1RMQlKfrKfzSlqpKhTlp6RuYB+f+DVyEbZuMLIrsYRvCVYWdjSR/bWxI5kO1L2/U/bqd+E07NqZqui0F06V89vUsMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730134451; c=relaxed/simple;
	bh=045AGb8JuNqOjsQOzN8aZyC+lESpHF0mytQYlaut7Lo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOu3MrsnOJM9/MwzsW1epHoODzJrpc3k9kot4h28NHvcJlAGhspkGB/N9yNqfKdHw8qC7VNS2xdZYrvgCNo6wvagHSE0yKimFmAswyxgp72yqbVn2N3YYkuif3Tt01OfqOSqCYjTDTr8NHClI0ru9LcVVU04KExCCG/p0J5WK0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fpfpRXM+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730134448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ccBdl674U7Jv+vtXlnAHZ7z0c85T85M1xUuXFrqnPmQ=;
	b=fpfpRXM+L3em8RweMRy1xrv0ejMc3qb8qK8bL5ecXSLckx+PNNPVYnH4jDKkWOuLmmpuFf
	40Slrr/nZSlc7gyif/pTw+csFm22OpPy8aXUwGxt2CMoGXKGEAF3HVFgKV3b2gXlz6jRA1
	Guhq461V0REjllSI4TqR1iFbONYfJFE=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-SupbjMlcMcundQV5Gpz1Hw-1; Mon, 28 Oct 2024 12:54:07 -0400
X-MC-Unique: SupbjMlcMcundQV5Gpz1Hw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3b8a34c06so7133625ab.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 09:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730134446; x=1730739246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ccBdl674U7Jv+vtXlnAHZ7z0c85T85M1xUuXFrqnPmQ=;
        b=uCvU/Ic0lZ5cJDC5GGkQS5sUrK5MEWcX39lV3MHzsRRGA9yg1ljWWYD/lJYrkxrbJ2
         sQ7ZHXht6uWz1V5qFQQMmpPuy7sSRao7ruO+Fveot+bU4hFam0+7SKD+5FJrvhcnraUw
         e1WXFOhA33Csw713kAhcp8GrpGKhzNTZoa7iWtBHdaGkg2HuhS7dfOPyhlicoRPF6GHS
         BA9c9iFnudQbgWX4Hoxo5jdblBNPY5tEeuFB0FWCR/t1Zk5JbjZSxS4Lyg1IJGI4UunB
         xx9h2hLUX4VWMjb1v+diwYFDrOHSWW6LUCSXWyXS3DPBBd4QEK0ecdDDg8SKxAJgdj5P
         eQ9w==
X-Forwarded-Encrypted: i=1; AJvYcCVwZFBAI00kaPNLOT/2C+kAYW9f8fSZ720CutMg7U81YUohoUfCVJascmDRWKuvRLed80g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2x7wGW7kIdLCFHoP9tY/fTKFGVP/EfmbIDdPS7VI5C8S5jvBx
	WqUymGMW57qe6LzEuDHd8UWtdDmK1YrRP67O7twMOqbbUHKbqFUr1HSXlGIrV0bK5b5BcK/jar5
	NEHEIkQkWckV5czaNjTn9fYIsLw08NQoht8/3O6qaC0AahaLAPQ==
X-Received: by 2002:a05:6e02:1caf:b0:3a0:4bd3:6cd with SMTP id e9e14a558f8ab-3a4ed1ba8e2mr23283675ab.0.1730134446400;
        Mon, 28 Oct 2024 09:54:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFGZCi7fJ/OejaB2WuuWKlBM5pd//oi671GvJLr0HBWjjOLQbzaoYpAgGbyvQmX+EVgQIK5/Q==
X-Received: by 2002:a05:6e02:1caf:b0:3a0:4bd3:6cd with SMTP id e9e14a558f8ab-3a4ed1ba8e2mr23283495ab.0.1730134446003;
        Mon, 28 Oct 2024 09:54:06 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc72751e90sm1783197173.96.2024.10.28.09.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 09:54:05 -0700 (PDT)
Date: Mon, 28 Oct 2024 10:54:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com, jasowang@redhat.com,
 kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
 parav@nvidia.com, feliu@nvidia.com, kevin.tian@intel.com,
 joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support
 live migration
Message-ID: <20241028105404.4858dcc2.alex.williamson@redhat.com>
In-Reply-To: <20241028162354.GS6956@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
	<20241028101348.37727579.alex.williamson@redhat.com>
	<20241028162354.GS6956@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 28 Oct 2024 13:23:54 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Oct 28, 2024 at 10:13:48AM -0600, Alex Williamson wrote:
> 
> > If the virtio spec doesn't support partial contexts, what makes it
> > beneficial here?    
> 
> It stil lets the receiver 'warm up', like allocating memory and
> approximately sizing things.
> 
> > If it is beneficial, why is it beneficial to send initial data more than
> > once?    
> 
> I guess because it is allowed to change and the benefit is highest
> when the pre copy data closely matches the final data..

It would be useful to see actual data here.  For instance, what is the
latency advantage to allocating anything in the warm-up and what's the
probability that allocation is simply refreshed versus starting over?

Re-sending the initial data up to some arbitrary cap sounds more like
we're making a policy decision in the driver to consume more migration
bandwidth for some unknown latency trade-off at stop-copy.  I wonder if
that advantage disappears if the pre-copy data is at all stale relative
to the current device state.  Thanks,

Alex


