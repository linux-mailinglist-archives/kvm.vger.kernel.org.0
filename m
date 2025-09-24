Return-Path: <kvm+bounces-58616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DCD3FB987C8
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 09:18:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6BA8C7A2565
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 07:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC65270545;
	Wed, 24 Sep 2025 07:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BpvRQHn7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B832BCF5
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 07:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758698327; cv=none; b=tw/BkmSIIjmdljV/3nC50DJxlOhwstWYmIf8ExMHg4EbARKcpnBNCdCFjv0AgnqBJHHwOkSkC+7IyMGh63zBDIOj+R9yCknKc1aHN5xLxrvndEWdnJd+avBNOdTkWR+4IPBhXSF2WoA+Orn/lLKu3gBsNVR+DHcvUNdHxtgTG6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758698327; c=relaxed/simple;
	bh=vFGV/5SdrXTqAjDg1Z+qtUf7lXuT4QgHCPVLjdBhXkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jqTszl5V0TIXHbPbrX3uYDB0+bL9ZjKobFfZ9uHmgxyhBq82XURawflJzkOQDZqUzZDtdiC4DaOyEhKgBruXMxmIqymUFh7dHLbvNiGlDVD8FGBXO8mSVkMI1Kj53aAVodXQIuClnt/dfroC5pB6/go26oy1mD/jNhojKkCZ2c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BpvRQHn7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758698325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x4iJVB6lD2fruztfkG80c2BDXVSi3uw6WFakzazt5Zo=;
	b=BpvRQHn7cNZq5pWuP49RkKnIJZSwSvxbcsKmuYQldlXbAvde6XqEptmVyzmZH/r09K5D6H
	+7sgFaxferELr0RINM2gvyMLzHBOnWvWwHhcEwdmK8ResiqFRH9VTfBpPHIKlCUJ1AdI+E
	UZBC0o+0lzXyX8gB/7//m/MCdrOGCes=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-IgPb_yIYOauevgVn0kj9rA-1; Wed, 24 Sep 2025 03:18:43 -0400
X-MC-Unique: IgPb_yIYOauevgVn0kj9rA-1
X-Mimecast-MFC-AGG-ID: IgPb_yIYOauevgVn0kj9rA_1758698323
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45f28552927so52638315e9.2
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 00:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758698322; x=1759303122;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4iJVB6lD2fruztfkG80c2BDXVSi3uw6WFakzazt5Zo=;
        b=pWJ5dExK6KbLBJmt4qss+evZY+ChpHR9IoGK1kfxOTCOaimNgyhqE8rtaFxmdGIX62
         e36XNx5CJSmKhLVLg0bfhREJUbhz/c3t2PD7gUqgN/4hpsoLjHHanCoSx94+1sDrzJyH
         Uq0TGMYPWVB7oH2hke5JK+Qpy9Ima5PfUP52DpVh3+c/VT6Dy8N0brIvXiuptvt7agXJ
         /5XDLUfHxpjJ1bXtwAsrLkB9uAX7KH8toexV1j1aiT5gP314Tnxa0/drZtrwa3xaK+jh
         cuajtkIf9obLWuLtuJyjWQZHyXw8J3QNd93cTjVuAfD9kFv3XCAseGl5nhabx5m226EB
         cHhw==
X-Forwarded-Encrypted: i=1; AJvYcCWCqllGlVZz81efCzcW4A2g86vESNVQ9lYa6wF/dHh/wFdsBKbfkww/k3gwi2JuO2ALkCs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWcGpy32LFfvxZnmXIJoK2Vfki/rjvJi+TvatcEzqXRhYA1loA
	6wGCCQjM4vaixJNBIDdNVKXv8UqP9aS0QrGVTlp8m0+s53Jtv3BCZXs+4xGSw4994ciHByPg4Iw
	oDUyhiPa/taqmXlpf4a2PzZJxffDumsLmHGjOxDIjsBWO/4FIn1S0/Q==
X-Gm-Gg: ASbGncvNusP1BRbnWKpoACyqDuzQM//yiWB3NGzAjaHR5kKWXXQp9Mo9+Nsz7hUjmG/
	sUZAHVO1KB0o6jlalTycuiqJn5dfaN52t11Ig86ZopqDT94XxCmCS9H2aLlMRC0BH0e9LWwsiOg
	D8WAoNTp9TT8zK+9r9OP2ZBegoUfCOv4RrKn/9MJtVUOT7ACzGn9ZsJ5oaMzTo9lz3BpkGXGkud
	+/oT5kZiPCqbAziToqIYsNqtHhSSF0/ZdcpMvRcOACWBQSUUzSVLaFE/mCWWZRwA6vk9DUZuSXT
	grCKz9Qi+/waTgmAoZMV1pg3WLO9p9MUSVI=
X-Received: by 2002:a05:600c:4f16:b0:45f:28ed:6e22 with SMTP id 5b1f17b1804b1-46e1d9789cdmr54641395e9.3.1758698322519;
        Wed, 24 Sep 2025 00:18:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbSI2vy3Xtfu4Q9BvlHbV7J5LuaePh9VoqJOvv5JsIaLhsTV8uduTMFmV9uZ4PhlaEw7WBrw==
X-Received: by 2002:a05:600c:4f16:b0:45f:28ed:6e22 with SMTP id 5b1f17b1804b1-46e1d9789cdmr54641135e9.3.1758698321969;
        Wed, 24 Sep 2025 00:18:41 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a9b1dd4sm18905645e9.8.2025.09.24.00.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 00:18:41 -0700 (PDT)
Date: Wed, 24 Sep 2025 03:18:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	eperezma@redhat.com, stephen@networkplumber.org, leiyang@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/8] TUN/TAP & vhost_net: netdev queue flow
 control to avoid ptr_ring tail drop
Message-ID: <20250924031105-mutt-send-email-mst@kernel.org>
References: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922221553.47802-1-simon.schippers@tu-dortmund.de>

On Tue, Sep 23, 2025 at 12:15:45AM +0200, Simon Schippers wrote:
> This patch series deals with TUN, TAP and vhost_net which drop incoming 
> SKBs whenever their internal ptr_ring buffer is full. Instead, with this 
> patch series, the associated netdev queue is stopped before this happens. 
> This allows the connected qdisc to function correctly as reported by [1] 
> and improves application-layer performance, see our paper [2]. Meanwhile 
> the theoretical performance differs only slightly:


About this whole approach.
What if userspace is not consuming packets?
Won't the watchdog warnings appear?
Is it safe to allow userspace to block a tx queue
indefinitely?

-- 
MST


