Return-Path: <kvm+bounces-16358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CD4A8B8DD4
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:13:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B000E1F2222F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1D31304B7;
	Wed,  1 May 2024 16:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlgVTqgA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FC12FF76
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714579978; cv=none; b=ZJbGVYYt53m1o2Iu7VjEphdwuO4k52HU0jghRVdeOHLyX7JPZbx+y/01TTTkLKF+S/8e8yFCMdKSPtLoZdoLMzX6XQ8lY2Zcnb+24WJydawl5yb43MvztYXBAJ3gMuuziDjVXuqtvogO5Ve4z8a1tiFcXRaZ6O9FJL0UWdCQPsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714579978; c=relaxed/simple;
	bh=hrRDPH5KmWRr+9x1RV6ps3o4KFAfIeKcj/QXwk73n2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IGG+vW4XYv1il8ZcF0ZakbiYqI8i9twnt3f0Zm/vvB4OysJum1TGXT38V5fGkAYARZDf1OzGkzOrsVDschRx53ZdnpMeyJu46vtQv/WIU+gMKTQtTf8TpMFckeBrAX4fHv25qgjEfa2iGrWtUphd2t5QMkZDfPOUT7dwDy8fQrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlgVTqgA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714579975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hrRDPH5KmWRr+9x1RV6ps3o4KFAfIeKcj/QXwk73n2Y=;
	b=YlgVTqgAsfsalY/s5N01BofuEkinquxeGyCsRykx/HuFxMG3iyFuKUG4xuJ2nWUQFIX/Yq
	prnFnh6GtR5m3aESpFdZfPX6xZbwXbeNOq0Jd47yjEv6F9aY4KcOnSMm7sTimQp3sXtZYD
	baNp1rKK0hHXqh2bsOEWZXwoZpl6quY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-PstTvD9ZP3ObY4puX2h-8g-1; Wed, 01 May 2024 12:12:54 -0400
X-MC-Unique: PstTvD9ZP3ObY4puX2h-8g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-419ec098d81so29760405e9.2
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 09:12:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714579973; x=1715184773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrRDPH5KmWRr+9x1RV6ps3o4KFAfIeKcj/QXwk73n2Y=;
        b=qW6XlNzrM9tfnpylmkOirvqgkAsXUZve6QX6aJruTuFaxKACyisyhl4lhCT+LUlRwS
         /752MTnW2uWZKF/ALlEwaBCWA/lN+ESxusU9r1ig9StSkjPJgUh4x7X2bHnhbCYiEw7J
         3eGndsjvJdSsZFT7ULLKGt8J4QmEkVrzWtL6M+CRUnNMASPjd0E4KOMtQQDO0cF9ektq
         tQ1Rbu9Vx0G4IsyXsCOSHavxa7p6+13uE+Yvx7+UxpnOXlqB2Bm6BmOoCDTWz9/XYXjJ
         ixgAnZvd+McFud6jTFW5TC0ldI/a5Un/9YjsqYBXyIQgSkrgyNYju8X+5gwUbTrBX2pC
         xLBg==
X-Forwarded-Encrypted: i=1; AJvYcCWzUPvJsFW894xMa6t5ZuiI6bOKrh9NqCuAFR2pjNHIxpddf1wl4XymbFjrm8ht55OMSZr1WYHq3LAGiARq/Jsa0lsx
X-Gm-Message-State: AOJu0Yxmd8relRDvMmlski5L3VyWMcMmdHNyrzUTrB8ikYfbQ3wXHbE3
	lSghzFQ2N5OOv43eJuKi1Z+c6SN0IGM22WwpmojFc3eZgc6gFBBuCoiSADhI1NeZRiU1ac1bT06
	EdtEqOueD7XItVw/C/En1lwXdo805reX5rkJrAoDhQuMvXQMfZA==
X-Received: by 2002:a05:600c:3552:b0:41a:be63:afbc with SMTP id i18-20020a05600c355200b0041abe63afbcmr1920323wmq.28.1714579973254;
        Wed, 01 May 2024 09:12:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFM9eMgnWpKr6MeblXMaPo1/itIFX2oETmSIeau52sprOYTLIeHS2zSDJpwo+oNvlucm1N6qQ==
X-Received: by 2002:a05:600c:3552:b0:41a:be63:afbc with SMTP id i18-20020a05600c355200b0041abe63afbcmr1920294wmq.28.1714579972623;
        Wed, 01 May 2024 09:12:52 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc7:346:6a42:bb79:449b:3f0b:a228])
        by smtp.gmail.com with ESMTPSA id l27-20020a05600c1d1b00b0041c5151dc1csm2639208wms.29.2024.05.01.09.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 09:12:52 -0700 (PDT)
Date: Wed, 1 May 2024 12:12:48 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: syzbot <syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	michael.christie@oracle.com, netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, virtualization@lists.linux.dev
Subject: Re: [syzbot] [net?] [virt?] [kvm?] KASAN: slab-use-after-free Read
 in vhost_task_fn
Message-ID: <20240501121200-mutt-send-email-mst@kernel.org>
References: <000000000000a9613006174c1c4c@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000a9613006174c1c4c@google.com>

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git f138e94c1f0dbeae721917694fb2203446a68ea9


