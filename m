Return-Path: <kvm+bounces-4080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E4E80D2E5
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:54:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108F9281ADD
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FA664CDFE;
	Mon, 11 Dec 2023 16:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SB6X5S1s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EA9BF
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702313642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0TaQIjCMRtqoHv9s+WpKU6yUC9m6qOxRLwTnSkQyVwE=;
	b=SB6X5S1skqHpMNLMJ2h3ZlCJvj6aYXWrCinhkYPfPoAod+dTkigTREAQwGL7ASo8ypRfrU
	azqK4/fM3KC3Rj5SLqFSXcfzI0T9eGjU35rhymupnPZJXpzJVig7JpAkYdI4djTEAifHCq
	g5eMAXvWmIvmQ57Xn4jP2Xgib/DG3Jo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-QhuxgtR1Pf6FQG5X5iqKfA-1; Mon, 11 Dec 2023 11:54:01 -0500
X-MC-Unique: QhuxgtR1Pf6FQG5X5iqKfA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332ee20a3f0so4162194f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 08:54:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702313640; x=1702918440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0TaQIjCMRtqoHv9s+WpKU6yUC9m6qOxRLwTnSkQyVwE=;
        b=syU8685vJ917tvJw9xkgudcaaR/3ukc9yHxgCbNrGH/bJsdW5jhkBNTkqQSA0xh7Hp
         5DqoLUq3d7iiczcYeetT4LsDR5V1yCDpgW8u3svBTVax97Nq0DmO0pjhc+dGYilmdKs/
         zIDerw/0/eb7WWNRSRTiU+6+zTRRhwCOLLeKST4vZzQ3ttKQKNbsX+yCmCf6t7h1XJ5h
         RyU8lCTThu/jyRJO+FnXvNdD50NS0ck9r0YZU+CFz7abDtFwFXazhvBlPNoxRPyfdQgp
         lPDkeWNvCYPQ9J8b4vQuGQUIo35OZy1JuYvxBffFEL73KLyGaPfc6saCBvwmQlU9e2jD
         j1PA==
X-Gm-Message-State: AOJu0Yz4BX3Byyultt+EkQyaoDVDd4O+0zZvpHntVHWNhgMITQR8/uuJ
	AeLHNl8GWY+2x2TdD5B8s9I06KODB/m+cs2yZ/Vzt46YxtRRJT//vGujPOz1FDjXKiT2hw4IsWp
	OB7TrFX07a76+
X-Received: by 2002:a05:600c:450e:b0:40b:5f03:b3c8 with SMTP id t14-20020a05600c450e00b0040b5f03b3c8mr1125892wmo.234.1702313640114;
        Mon, 11 Dec 2023 08:54:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFtiBxrV84vG/3P94lY/VLzXMvM+oAghyKtAHVVBITjmPRXIgn0MXg5y1PSG2jZcwLid9jfxg==
X-Received: by 2002:a05:600c:450e:b0:40b:5f03:b3c8 with SMTP id t14-20020a05600c450e00b0040b5f03b3c8mr1125883wmo.234.1702313639719;
        Mon, 11 Dec 2023 08:53:59 -0800 (PST)
Received: from redhat.com ([2a06:c701:73ff:4f00:b091:120e:5537:ac67])
        by smtp.gmail.com with ESMTPSA id k17-20020adfe8d1000000b00332fa6cc8acsm8943445wrn.87.2023.12.11.08.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 08:53:58 -0800 (PST)
Date: Mon, 11 Dec 2023 11:53:56 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Tobias Huschle <huschle@linux.ibm.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20231211115329-mutt-send-email-mst@kernel.org>
References: <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
 <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
 <56082.123120804242300177@us-mta-137.us.mimecast.lan>
 <20231208052150-mutt-send-email-mst@kernel.org>
 <53044.123120806415900549@us-mta-342.us.mimecast.lan>
 <20231209053443-mutt-send-email-mst@kernel.org>
 <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>

On Mon, Dec 11, 2023 at 03:26:46PM +0800, Jason Wang wrote:
> > Try reducing the VHOST_NET_WEIGHT limit and see if that improves things any?
> 
> Or a dirty hack like cond_resched() in translate_desc().

what do you mean, exactly?

-- 
MST


