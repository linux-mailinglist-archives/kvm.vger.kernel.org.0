Return-Path: <kvm+bounces-61508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40B64C216C6
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 18:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA85F3C000F
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 17:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AB83678D4;
	Thu, 30 Oct 2025 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mGj65gl4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3404F3678BC
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761844366; cv=none; b=RuOPsrrbB1XNgMGKEGbe3SGRaglB0ty/GiU2agy8L+3wO4mFMqMIXhwq4uOoHB8oTt6kSZv0bPbAoSLniVK6JVQbZKqh2kxJFYF+clDk+lj9uHHumYNXasnWMbffFbxzWU6NGAFlqh7Nx0gyYoBHVy4uCRh6RyONsvA3RodB8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761844366; c=relaxed/simple;
	bh=VtGyAhIE7JuPmMUSsMxjOstRla98JRON8jGOb/XA3oA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sNkIuXWttNPstWzn2liWWUBLBS34KlgP4gYrF5FdyKI7sQacOZIzEWEISDYlpHNcOcZaLoHQwlgg7UEainyZOepJPkpNhXC3TfjGT37p7AylkeYZzbTdpedfENb08AuGM70NQIt2fuO0Qd8pe0uvINm9CQrVUrt64y0PZYff0RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mGj65gl4; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-940f98b0d42so355974739f.3
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 10:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761844364; x=1762449164; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HgdBKDwX+z0Rf8c5J+aAFhQI7fwAbiAzdE0bPHbvd5U=;
        b=mGj65gl4q/s8+0kTLi4gcPnxBbfSl+m4yLgqAd1LcpOO5b4CX8Gxa7UIRme9VxbE7x
         bkJBDpH/FNJHanNCffaaGANOGi71/xH46yiaf1kKZvsc5vJBK4mw0JFVCWL2wuhXu+c+
         J9GD5NEMFutc7aQTn5GDZRx20rsofXSVc7K9p1AJ6kGzVWSYLT8x9azJtKDL/RUMYta7
         m0LJvJcwujEZE6sDTIFcN6RhF/7pI2Fe4PrgrNpINHOakd1LifcA0DkiSrPAK5RlfSix
         wr2vC5G/VkAMSkTeRrz0TwES1MT8vCiWiSgjF1WbWpktP7om1RIKCvqaKeX3Dn0A2GAw
         7fpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761844364; x=1762449164;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HgdBKDwX+z0Rf8c5J+aAFhQI7fwAbiAzdE0bPHbvd5U=;
        b=HpjDwUOkcBXNZFdrlkZtMv99mzxQ8uiH357Lge1DwALX38VE5mWc98j8aTBcrWjmfY
         miB5fTCxofWdWIBQ3++IwqExyTIEK0j0fb7nDfSdsQAOaR7v0WAkKp9ElJQg3WrgGQAJ
         qtB5qJC1QDDaDquTLsmy/GwJWnnsGDachJAS+Ce+lC+iSwKZEGU7pJZzomBYCE1o1c8b
         MnRwFqC5UWZ2prlkQYySTMXBu2iQCJO+GsppjD++Q2VvACxK+PTdI9BWP7BXHYKrZVN1
         trZgtS8eZXz6tJBmkoM8baILTVgzXtjA2eFwdYaAtPTJ4wrBN7NcFMKbfHzTfMeaqvoa
         yI6g==
X-Forwarded-Encrypted: i=1; AJvYcCWsOl5qEMA04Pi/P5LfXPsJSDReQ8MaRn0PjSaOFhXFIeqTqKanns8+ZFBm3BAyro/n73E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQEjyGJokx0SoF1Bakv1DdMkffuWldQt85fDNJDmiquuU7XCls
	mgOLTQ41aeuXBLm28qivN8S5p+fblJgVV186b7bXxy6SLhcxf8CSMRPMcd8FOtVgnFkzsSUyABs
	p+09ulxp/vQ==
X-Google-Smtp-Source: AGHT+IEWEErvPMuXoEG43AQ28uyYLxubN4pX2CuFL+34bvwM2p/60F3Ik3EEXeB0qXsQYhSuRsHZ3iyt0rXw
X-Received: from iobfp5.prod.google.com ([2002:a05:6602:c85:b0:945:af03:ece2])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:2c92:b0:945:a58e:ba03
 with SMTP id ca18e2360f4ac-948229a4807mr92354639f.8.1761844364364; Thu, 30
 Oct 2025 10:12:44 -0700 (PDT)
Date: Thu, 30 Oct 2025 17:12:38 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030171238.1674493-1-rananta@google.com>
Subject: [PATCH] vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex.williamson@redhat.com>, 
	David Matlack <dmatlack@google.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

For the cases where user includes a non-zero value in 'token_uuid_ptr'
field of 'struct vfio_device_bind_iommufd', the copy_struct_from_user()
in vfio_df_ioctl_bind_iommufd() fails with -E2BIG. For the 'minsz' passed,
copy_struct_from_user() expects the newly introduced field to be zero-ed,
which would be incorrect in this case.

Fix this by passing the actual size of the kernel struct. If working
with a newer userspace, copy_struct_from_user() would copy the
'token_uuid_ptr' field, and if working with an old userspace, it would
zero out this field, thus still retaining backward compatibility.

Fixes: 86624ba3b522 ("vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 drivers/vfio/device_cdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 480cac3a0c274..8ceca24ac136c 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -99,7 +99,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 		return ret;
 	if (user_size < minsz)
 		return -EINVAL;
-	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
+	ret = copy_struct_from_user(&bind, sizeof(bind), arg, user_size);
 	if (ret)
 		return ret;
 

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.1.930.gacf6e81ea2-goog


