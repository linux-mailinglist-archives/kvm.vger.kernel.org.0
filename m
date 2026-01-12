Return-Path: <kvm+bounces-67693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 36318D1094E
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 05:33:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C5884303E29D
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 04:33:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 297E830F7E3;
	Mon, 12 Jan 2026 04:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VmH9pYUG";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YFHfq020"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0872230C343
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 04:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192415; cv=none; b=E5q6zwBQdSJEZyaWRHcj4lJ0WowV2W6vBokEhL1KzRU1RVJ9BimB0miV0KZZnVo409izeKAvT7WVol9HrmOP2InNYPJ6j6Pd+k9gVq+vMTNEAesEy+V6WccjsB/r9tnWBMRjclrm91OSXlvNIuk4BseW1pwIK2kcNL6J9vPTDYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192415; c=relaxed/simple;
	bh=JsECp4e88xlO5Vo5MlkaWcurekx6DybzbgYXNqaqYFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gcbJldc/Ey+IiirV5vBCxEaorvFtOwGfgr2/x+upr4zCRFaDugNTxTKWHwwzelrVFeIw5VFHV9R2evKgwzSnL7Cwb7aw/ayDaw76ivjTIKoS3FGAxz1q1APfULCW6GXTsw+PRWld5hgV7x8jEcomGCXB3x6ErwPwe8QZpNC3DKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VmH9pYUG; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YFHfq020; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768192398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=APuQMk+mj1Ir7IfbwA6rsBMcZIxIkKakSr4yNu5ZY2w=;
	b=VmH9pYUG/mLi9V1uEPPH2TR8PlbX3ABMRcRmmyeVtmLP2JCOHrvlgG4DFdgrlEPwW6JsOa
	/KnwTPsC2Cgtzv9R/Tar7AlvCi9VxVL8OKXrpuvHcqzt0jxoH/zqNnRyMH8uvGyLt/SVKF
	SSzfO8UiW/eoApudi0+JCfyEYNPMj+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-g7rj7hPCM42uVEm4L5T0CQ-1; Sun, 11 Jan 2026 23:33:16 -0500
X-MC-Unique: g7rj7hPCM42uVEm4L5T0CQ-1
X-Mimecast-MFC-AGG-ID: g7rj7hPCM42uVEm4L5T0CQ_1768192396
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-432c05971c6so2928758f8f.1
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 20:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768192395; x=1768797195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=APuQMk+mj1Ir7IfbwA6rsBMcZIxIkKakSr4yNu5ZY2w=;
        b=YFHfq020Vt3bDyZRQW4KC3y5reYzFzeObefGorrgPwesZ5/BaDvKBK0oi0YtVRVgdW
         TNIE806/WoNrYxhwjBiEVJ2VMH8+UJwosB9Bf4fRjXw4LesWgJBYxC48FbC8cNg/92I0
         LCq1NOfpyrCKV3ENRj3t3EI6aZz1ZueFGQFszHfs+RJAz7XFAXet7joTmMrk2Kkya3sj
         gl/WmDnm87twqD4gYOZegRr0gXniuhdAIMMyk3Ofz23Pz041SCT/CdCq3K3SxVw41EmL
         VI/c2sJMIbUvJ1l2JzrHfgzMRrDOvykrYh+4aAs+OBMmxG21p15IhrZA30oaqbLGtL6S
         qSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768192395; x=1768797195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=APuQMk+mj1Ir7IfbwA6rsBMcZIxIkKakSr4yNu5ZY2w=;
        b=BpM3kEEDZ41y+qQ4k98toWxe/MsLN6LUY0FCcj59UPDBA55rMplFzWR52XWPVR6agP
         JHZ6G6IugnFjUq2kGtLbCyYk5wi7EtSOxwJ0c+S9p8BnBYuTSEybJ+N2THYwt8TNzFu7
         r8e1Vti0inzDI5I6rC++ZgJc9w/YwRua0ZsCxTCCRwqhZNmm9hfb5dVZOqU9d8v2Hm9l
         JfpptDbJKUCeW9pSIfykZmj50728hgAl5Qx2NKLaMshBEUN73rAuvYA82bs32x5CaDX1
         WyqSscRZOq7sT9nz2R9+TkUTiSZZQkm9B6ha/+O70Jxjeiuwcj6T/6tJHEwCPPZAXc2O
         +KDQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8oMDwb70T58TU2d49jI12nWDZL+L8U5pHvsEVk0p0G1hTYxl6NlWzx3SXMSUJUxbaxGw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNhHPCMYHZ6HJ0Z8IysScNp5PVy94ZJMjtROqfzdGqVnuiqJIb
	AYKjjHwlSWMUcA5gErn1DnUbmKyze5ylA/VMf1c7U+45Sz7cBys5RCPhF6qyc3JwX1wu8zHn2PH
	lc1HUsddV0B6Cp2KxvXuqsJcXMvjDmpU5cqjKiP6nF7cIWxwtnktPBw==
X-Gm-Gg: AY/fxX5KIxSr0VgjgEDOrtz/aCl/QebIUu+WBkw8R0joQNOr69lFZet4al1UgA9jgef
	z2d0kNMT1AJ3kvMTzTIRUlB/UtvJ46qWvLIVXaVGQKsrHbE1c22rImkN8Y7QnJ/0LgMVAPHUf/7
	KzpDsihFT3pwhaKdAYkOI3y8qnqPKUlbIOXu4sBp7cWoLNTyZs6nByM1kJYlLkNVPWkGtmYPOZ0
	nu9LYLkca7u+A8xGlBolN0aBbDoFtqlA5DpUerdY3zvxLwJDYwcV580xFrtBTB5dQFC5U6hTwsS
	vpBXyy12GlaAIqDqaeTBWMHdF1iQobQOhOp2HbVGn6nlzLD26KNRtrezDhnUCek8xOmfHV2vhtW
	b+Aw6yjJebke7YzbGOVPjIFCETMjiOb4=
X-Received: by 2002:a05:6000:18c5:b0:432:da7c:5750 with SMTP id ffacd0b85a97d-432da7c589cmr7999799f8f.20.1768192395665;
        Sun, 11 Jan 2026 20:33:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/BXpYp147sy8NHGo+1rbRx2BpHOkLFAtFBJEDqcFXZDM5sBWqhXQb6dEWZIhQYfgNrNPMPA==
X-Received: by 2002:a05:6000:18c5:b0:432:da7c:5750 with SMTP id ffacd0b85a97d-432da7c589cmr7999782f8f.20.1768192395211;
        Sun, 11 Jan 2026 20:33:15 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee5e3sm35982021f8f.35.2026.01.11.20.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 20:33:14 -0800 (PST)
Date: Sun, 11 Jan 2026 23:33:10 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 9/9] tun/tap & vhost-net: avoid ptr_ring
 tail-drop when qdisc is present
Message-ID: <20260111233129-mutt-send-email-mst@kernel.org>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-10-simon.schippers@tu-dortmund.de>
 <CACGkMEuQikCsHn9cdhVxxHbjKAyW288SPNxAyXQ7FWNxd7Qenw@mail.gmail.com>
 <bd41afae-cf1e-46ab-8948-4c7fa280b20f@tu-dortmund.de>
 <CACGkMEs8VHGjiLqn=-Gt5=WPMzqAXNM2GcK73dLarP9CQw3+rw@mail.gmail.com>
 <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900c364b-f5ca-4458-a711-bf3e0433b537@tu-dortmund.de>

On Fri, Jan 09, 2026 at 11:14:54AM +0100, Simon Schippers wrote:
> Am I not allowed to stop the queue and then return NETDEV_TX_BUSY?

We jump through a lot of hoops in virtio_net to avoid using
NETDEV_TX_BUSY because that bypasses all the net/ cleverness.
Given your patches aim to improve precisely ring full,
I would say stopping proactively before NETDEV_TX_BUSY
should be a priority.

-- 
MST


