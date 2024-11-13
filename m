Return-Path: <kvm+bounces-31767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D93B59C74C3
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 15:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 912201F25F95
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 14:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5EDF148FED;
	Wed, 13 Nov 2024 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZrmdHTvr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED581C695
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 14:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731509407; cv=none; b=MymO1OnZlSKTBRyVrjdiAHR5fkppTFBwm+CvmW5YouVqKuyU3u/fi2uLvDkxUIT5iOoKmWoXzBiKtbDTfq1xJRLA61+nCyFjXKgNRicVr3DIIp+7AGhMgg8n12nUowAOIAgJEeYep3GEvWRX1oNs0eC9tcR0vdJAAw9tl0/4g/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731509407; c=relaxed/simple;
	bh=F2V5lIDP4k54VyPQnx3tm95pRjfvhQH0+t+YIFhROXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bIPG1FqLmT714noyolgaQOFRl9Ij+RegNtYy7gZ2oMAdSy6ZTe3PDtEuSkVpL+KI/19kjD5MshJcaX0mQ3V4wmPgYx8gTRK5mE0ad77NJtvhjvG4/mgPQnqNbEiCmMiVRUvramzXpiGNsoiiximElKMT6nvaiBzCIg6ZP0JGTuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZrmdHTvr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731509404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qpxWVmY9AA9sdaBT+FLe6ZwkY7JoCZPnsSDxJdlaOIA=;
	b=ZrmdHTvrg5hcohsxIDu0O1w0zhuowxohobfUtK/zYvipcbOlAfu1fXEJlwbFT4GwsMhSuq
	NMj/SbOOVgnWlGXkm9bwQBTxENR526e2az4ot1C/l+SpiQg5C0y7gAdOnLy7GRbMVqgCaI
	mpJQZ27jl/HRv4Fvz9C+Wj040cHY+b4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-Uk1suAZKOxSgjH_Aet0aCg-1; Wed, 13 Nov 2024 09:50:03 -0500
X-MC-Unique: Uk1suAZKOxSgjH_Aet0aCg-1
X-Mimecast-MFC-AGG-ID: Uk1suAZKOxSgjH_Aet0aCg
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d609ef9f7so4000279f8f.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731509401; x=1732114201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpxWVmY9AA9sdaBT+FLe6ZwkY7JoCZPnsSDxJdlaOIA=;
        b=fA2+lUO/v6mSCpPInbwivfv8wiQ01NLl1AvfXntkYIIWOGEaefKrA2wog2fPr1uTr6
         l/UzUp/R8dMVaF4pGijz659h/+9kr1eGmObGr7qnYYz7U3But3MrwJ7MU04e0tlugYPi
         tfXj3uOHS6WmPdYMSWeZ8VFLxJSa2+Rhm9lAI6cn9EW6WojsQWKsA9nsNzI7hlJIxtA7
         LNXNy/OS+pN4mnUJ/6Tpn83QsF3wkvsOEGK6nWG5H0FJeUc84TIdRq2ELfLB/s01hl2C
         d5eqBrt52vtCwQ6FPPTORXcSV2aYasbKz082uT6dmE6ypzmobuOIrof4Kys25giZ6pLh
         0Opg==
X-Forwarded-Encrypted: i=1; AJvYcCUhtqQE9rRhD8roaUUACy6/CZVb9zKPsd6yLIspsxTDLq7UpuPpprZQw8kyiJP+0CLmx9k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhUMKBXvqVeLY3kQ4GMlgEYNq0mQMkR/kJmDCpxVS7tYHTv6L4
	tqKqfqtN5kEYUj2fnAXq6dD81Gu8XQHOzjge2vQaveMdR43/7di5l4DKbQbJT9OtjGQVMyTKfcL
	m5Cih5/50VaL6r/lQhYkYGvvsuGGLUeQQ0mIkQ7+F5QqEGlzf+kAEvM7LWA==
X-Received: by 2002:a05:6000:1ac6:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-3820df610a7mr2091459f8f.17.1731509401489;
        Wed, 13 Nov 2024 06:50:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG/XkX2Eyjenwpa71zbx3wPsBlk1LKkpMGBXi84BvxwbrswsvZkqwBZ4ckZuWMD7vSuPV2lwA==
X-Received: by 2002:a05:6000:1ac6:b0:37c:d11f:c591 with SMTP id ffacd0b85a97d-3820df610a7mr2091441f8f.17.1731509401092;
        Wed, 13 Nov 2024 06:50:01 -0800 (PST)
Received: from redhat.com ([2.55.171.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed9ea647sm18300658f8f.68.2024.11.13.06.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 06:50:00 -0800 (PST)
Date: Wed, 13 Nov 2024 09:49:56 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: virtualization@lists.linux.dev, Si-Wei Liu <si-wei.liu@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb
 iteration
Message-ID: <20241113094920-mutt-send-email-mst@kernel.org>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <20241021134040.975221-3-dtatulea@nvidia.com>
 <20241113013149-mutt-send-email-mst@kernel.org>
 <195f8d81-36d8-4730-9911-5797f41c58ad@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <195f8d81-36d8-4730-9911-5797f41c58ad@nvidia.com>

On Wed, Nov 13, 2024 at 03:33:35PM +0100, Dragos Tatulea wrote:
> 
> 
> On 13.11.24 07:32, Michael S. Tsirkin wrote:
> > On Mon, Oct 21, 2024 at 04:40:40PM +0300, Dragos Tatulea wrote:
> >> From: Si-Wei Liu <si-wei.liu@oracle.com>
> >>
> >> The starting iova address to iterate iotlb map entry within a range
> >> was set to an irrelevant value when passing to the itree_next()
> >> iterator, although luckily it doesn't affect the outcome of finding
> >> out the granule of the smallest iotlb map size. Fix the code to make
> >> it consistent with the following for-loop.
> >>
> >> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")
> > 
> > 
> > But the cover letter says "that's why it does not have a fixes tag".
> > Confused.
> Sorry about that. Patch is fine with fixes tag, I forgot to drop that
> part of the sentence from the cover letter.
> 
> Let me know if I need to resend something.
> 
> Thanks,
> Dragos

But why does it need the fixes tag? That one means "if you have
that hash, you need this patch". Pls do not abuse it for
optimizations.


