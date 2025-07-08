Return-Path: <kvm+bounces-51804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6352AFD66F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:26:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E4BD7A9DC3
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 18:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B70C21CA02;
	Tue,  8 Jul 2025 18:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YpfAMTli"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBC61CD1E4
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 18:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751999005; cv=none; b=fs1DWErjxD/Qzf4PSZjNYnKCVYYuCkw7snLYp89bQzRutSqNmwMUQXWkbSQ2eyUH5UsjOv5kzEiVGVVw2fcALFg8ENwqrAst4HOW1Y2HRHDy848CP3K96W91IfPxsfjpHiHL8TlQDdQqgradsOt0JPKXc5N9l4DxxwkvOWra56s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751999005; c=relaxed/simple;
	bh=6D4k5enuBtf5mq7C/EEEecxyB7anJEyKceYtHVTwMho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m65aJmcCxBZ3R5+YuM2HGHLLWEQsJOkzcwXHvdLGqCmqB1munbZRIYfvQhQjEmxdk3B6y+cdlLUy/M9GgYcJ9KYQcAk+2EEXrQkE623/ophKGNquC0a6p11yt56Qkja1g58JixiA9cP7ZsrYrykpGhDQZSxjj4W5QJsp7NiKO6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YpfAMTli; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751999001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5S0edA8YlfYIhnN0SMQ3uKgY85pVF0l9tf9Kb7Nabws=;
	b=YpfAMTliyPlWq1oi55MyI1m+IFAVIRcv4jZdf6GTI/wI8+3VNjVaGCkfZYIyIO1VLcDN6w
	PSZfkWvNpSQoq5QEJGsc5HpGC7fzC3YuTfFJFhNpzVG22o5cJS9n739CHrHrPsWAgRsUEm
	yBqn8X1Hna0hAt37ZvwfYH2rObdCZqg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-Mid0dxiUPViVcl7tmd1dGA-1; Tue, 08 Jul 2025 14:23:20 -0400
X-MC-Unique: Mid0dxiUPViVcl7tmd1dGA-1
X-Mimecast-MFC-AGG-ID: Mid0dxiUPViVcl7tmd1dGA_1751998999
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450d64026baso23310225e9.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 11:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751998999; x=1752603799;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5S0edA8YlfYIhnN0SMQ3uKgY85pVF0l9tf9Kb7Nabws=;
        b=R6nkJ3G1Y/TrPorFp3bjaF2EYyyP3F9whUprPqiS/REq0lH7Nb180LGfJgWfGmOk9Y
         8ibbskM9CyDaWW9DgX0LejjnoArBX9/UGWupCwTMZ9GYzlnDgzp/UHsdX+4ynH8N0oGZ
         EcNfT2mb8Zkzq/eJNLPB2lG3GOB/udDwi/hOgmaUxoA6LFW247b8v1gi8pJDoTkLxli0
         wJWWvcaTY5vCReljgCEe27WbZrjPVRy9ZD8hsm5dnYzKbTBjYyFcH4caZUUWNUwT/Cjx
         ePkG5YcDCg+anJx0CjMSwCQ8R58kdHbNFAY2f7LSCNCrZsxnOxD3GAxZ7oIwy2nRg5+1
         s9MA==
X-Forwarded-Encrypted: i=1; AJvYcCWLmqWKUESvdJQ9orwDqzk9fUEja6r3etvEpaeLy9okT2GvkM1DKmPDl5xuTH8bJp7DkyE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzugj52RtdWGepAn6ZMU6Gi89pYh8G6k1Hde8AYZQ9+nbYMYQLM
	dVN1OmAfU8Dk78eDjyrD+0HhbYLYSkQPkZikyhhGsyKvJZt2mq7JkA7IMSfDZt3TXTUEA/1jzAT
	oQD0sBHqTbyizJKsDoYhmNeElPAQrvUSt9prI7sWMs9sHjqxTUxqWLw==
X-Gm-Gg: ASbGncuEIuXLGry3u0Y/tC8oiRkudMNgjjx1EVoxFOUnCWoEe7/j/3zF6nLYvbUC0P8
	QuyJF/JdvFK3emsB3g9JOsPc2gfJ3hoRn8n/Jb1eMs40iMWdbfNJuA7qFJgGSBr2xqeQOkHzi6T
	11nuH8eBJY6m3En/q/myhRScbxcKL0xySHwab7Nmg+Wp6U4qlUZf6E6yd2r2+rhjSB0u9CzC3LQ
	kU5TUXwDsVbjn/uQaSM9UXXKdSrUPur3prkYUCY0A70vJpAQi5X7as+ynjgd8LrRC65W7T9P65S
	av6RJJEoFL6rito=
X-Received: by 2002:a5d:526a:0:b0:3a4:e8c4:7a78 with SMTP id ffacd0b85a97d-3b5e321cdd8mr321522f8f.52.1751998998718;
        Tue, 08 Jul 2025 11:23:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgvwVefNfgyKFgRcfoH7Pj+/c+/lJ+0aJ6H+ylUKueYM0evW6M90xHn5AQ4O5gJ9Pj8RG9wQ==
X-Received: by 2002:a5d:526a:0:b0:3a4:e8c4:7a78 with SMTP id ffacd0b85a97d-3b5e321cdd8mr321507f8f.52.1751998998323;
        Tue, 08 Jul 2025 11:23:18 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b472259842sm13692785f8f.72.2025.07.08.11.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 11:23:17 -0700 (PDT)
Date: Tue, 8 Jul 2025 14:23:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Yuri Benditovich <yuri.benditovich@daynix.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
Message-ID: <20250708142248-mutt-send-email-mst@kernel.org>
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
 <20250708120014-mutt-send-email-mst@kernel.org>
 <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>

On Tue, Jul 08, 2025 at 06:43:17PM +0200, Paolo Abeni wrote:
> On 7/8/25 6:00 PM, Michael S. Tsirkin wrote:
> > On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
> >> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
> >>>> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
> >>>>
> >>>> The first 5 patches in this series, that is, the virtio features
> >>>> extension bits are also available at [2]:
> >>>>
> >>>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> >>>>
> >>>> Ideally the virtio features extension bit should go via the virtio tree
> >>>> and the virtio_net/tun patches via the net-next tree. The latter have
> >>>> a dependency in the first and will cause conflicts if merged via the
> >>>> virtio tree, both when applied and at merge window time - inside Linus
> >>>> tree.
> >>>>
> >>>> To avoid such conflicts and duplicate commits I think the net-next
> >>>> could pull from [1], while the virtio tree could pull from [2].  
> >>>
> >>> Or I could just merge all of this in my tree, if that's ok
> >>> with others?
> >>
> >> No strong preference here. My first choice would be a branch based
> >> on v6.16-rc5 so we can all pull in and resolve the conflicts that
> >> already exist. But I haven't looked how bad the conflicts would 
> >> be for virtio if we did that. On net-next side they look manageable.
> > 
> > OK, let's do it the way Paolo wants then.
> 
> I actually messed a bit with my proposal, as I forgot I need to use a
> common ancestor for the branches I shared.
> 
> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> 
> is based on current net-next and pulling from such tag will take a lot
> of unwanted stuff into the vhost tree.
> 
> @Michael: AFAICS the current vhost devel tree is based on top of
> v6.15-rc7, am I correct?
> 
> /P


Yes I'll rebase it soon.


