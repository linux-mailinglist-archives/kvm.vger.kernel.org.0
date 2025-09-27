Return-Path: <kvm+bounces-58925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 611EBBA5EED
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 14:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98FF31B20895
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 12:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE2C2E0B79;
	Sat, 27 Sep 2025 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="to8Drjo/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED9253F14
	for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 12:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758975941; cv=none; b=iLa5sUVVQnX60xn+bT6TsHjONuG/Fi9SWEb7LmroRj5nILMpuuKURGt2869DtrVvjOFnLSdm23INEWE4Wa0kjjhZqmn1JievNQGhnlFC85aF1PNj3ne1fVStsIDdvtlNS9ibxMulZLsDNdy82ns/S8y+82DHYAsTC3VKxHzAcAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758975941; c=relaxed/simple;
	bh=Cz0upPHZk9fGBVcjG//ILHjl/qglp8+Tm6tLew6P7q4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=E/52Q82GN5sNmhSOXl/gMBWFwijbkD9ewZzBFwllZMaaPJMzN8xPo6jt83vwTvJM5cbjvdX6F3NFAvXgC7Drn2kjKBan398amrBJrsuXSilgfUUewq71+ojnTN3KjE8lyckBvljCUDoQYEml4IpXBIE0Yu/qHCrIyV9kMNXha3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=to8Drjo/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f7469so20576815e9.1
        for <kvm@vger.kernel.org>; Sat, 27 Sep 2025 05:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758975938; x=1759580738; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LVhumFC8qskWIHg2JamV1kuMQedk4HSzKMYaXz2FDxs=;
        b=to8Drjo/JhFxv+tld4alYbgBdCEEm7/fkjY7h9bW15GsawpgkvDMn5lj+kutvhqqxO
         dCer/i9CHp6V9Kmb59WuPjeMAn9ufcZeJ0cd57Bl1e7JsefhPyMx7266kprebbY+Bg0o
         f0258PZ6Qi3mVOviarG4UrEY0RvX+8i0Oi/4KlEhNiTbx/0UL3Nx7OBAdUl2eWOTu2p8
         JdLG8L7GylbtAMxrzPTtLioHxDDnJcEdmYGoqwzoUspFvyEiZKQ1tyjDg9bTJDX6Empf
         yLm+d/RC/L7JgNON7B93IRCL+k6EmlUZgmNwgPy+gvOD0XJ0A6uKbju5HdqtdlbugRVR
         55lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758975938; x=1759580738;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LVhumFC8qskWIHg2JamV1kuMQedk4HSzKMYaXz2FDxs=;
        b=SSuxnA09LWfvRXOFrJkPD01FfU4O4G4QuxUf6g7qqnGJ34JU23kIAAelFt1D2b8VPs
         1dwzMyxgyo7+aturxnXYDK9Y59opO5PTRoCecbuMNoK6zbMOC9Aiw0WRPahgX3GBiCq8
         mnsl8hvSFs1zzs5KRmlV9K2QeHaAaKs7Z/9VFERDfP4rRq0k1z8YYfXhy6dyIbmj/mc7
         AQsHU7MJ61fgWObXdhtGx9Sd+kZibDi9DLMr7KBJOX/DnBaoOj+8TzgUa9+5kN54dx7c
         7oWZhDAZcyHBrwWDjJ7bATz9LnsN52vy310i3JfUsI77c8j/xcoxOmaQWo/+U4SKvWtn
         aW9Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3IRPBzwYR0IfBE+oPxLnLQhZCOIafHHVL8WbDtjrIZsCbid8ztXfBh+sDxZcgdN4KTNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqYeYsttlI3OuU1MLlGOdJYZ7ykupaE1n39m45YpiM95f4s48Y
	XYuPx+jq3wnMjq8tEu0MicA2wo9Shj8IGg9jqcb6LRsCORKNkUSLrZkhxw7issizuywaJY3kDS2
	UEP7P
X-Gm-Gg: ASbGncupbSwa0yL8LKM3063XbX00WD39n2Jx2zjAPkUYGRLAHdRuCfYHvekwyT0eciw
	T3WTPyi8LK5KjmIEdBDaGcmcjIZaYYT/SPU/vyai3Jn+SL85y5JklFao3twC1o6Douh62y/QPou
	AGwA1itgzJxVIgL9xQldy0FdtzWluUREpEfDY2PWgy7WMWaiapMjO0zNoeCsTE/fQPIxRVbsROo
	whU/Pb8jFw1NGdWVcwSDmF/FSJO0IsclzB4UuOWk8x30a6eIF2u/Uwdtn+McbEDFVQ+PbuFlWYI
	SVl7obMA49VgJGK3AZgk7X/ln+GJWWQUzPEmt7pFu0UQzcxZhP9xliU9mbRqBJpMVueWepuWwS5
	epHKWcAwEEfc9mLDi3lm+AxQ7hFJAYicfksgIHCA=
X-Google-Smtp-Source: AGHT+IH/fs4tI3yUr2ZaBw2ReWMi5Di+AwUxDHPsiDLmiEELtqX2JAh0B0XFiB/cSRsTRtqy4tVX2A==
X-Received: by 2002:a05:600c:4694:b0:45d:e5ff:e38c with SMTP id 5b1f17b1804b1-46e32a1393cmr95976155e9.32.1758975937784;
        Sat, 27 Sep 2025 05:25:37 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-40fb72fb017sm10713558f8f.3.2025.09.27.05.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Sep 2025 05:25:37 -0700 (PDT)
Date: Sat, 27 Sep 2025 15:25:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] vhost-vdpa: Set s.num in GET_VRING_GROUP
Message-ID: <aNfXvrK5EWIL3avR@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The group is supposed to be copied to the user, but it wasn't assigned
until after the copy_to_user().  Move the "s.num = group;" earlier.

Fixes: ffc3634b6696 ("vduse: add vq group support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
This goes through the kvm tree I think.

 drivers/vhost/vdpa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 6305382eacbb..25ab4d06e559 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -667,9 +667,9 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		group = ops->get_vq_group(vdpa, idx);
 		if (group >= vdpa->ngroups || group > U32_MAX || group < 0)
 			return -EIO;
-		else if (copy_to_user(argp, &s, sizeof(s)))
-			return -EFAULT;
 		s.num = group;
+		if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
 		return 0;
 	}
 	case VHOST_VDPA_GET_VRING_DESC_GROUP:
-- 
2.51.0


