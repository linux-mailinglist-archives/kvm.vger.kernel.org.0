Return-Path: <kvm+bounces-61708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C664C2647B
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:08:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE8221A641F4
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 17:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137F9305967;
	Fri, 31 Oct 2025 17:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EEhHOHlF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9252FF659
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 17:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761930370; cv=none; b=jCd342R4eay/hsV0nXGFMkOa1DYX2yb+FjHSali2Ft2yGFc3nZg/vwdvrqkFiMye8XMFuYq5eXJ9rpnVCo97pdFN8fahrvFYOLdl3ttwZMO/cnkAg7vuUxJqRrRmu3RP+gk2PZlJ6J/eEvNQpjVglLUGh1LOJjXQT6VusJsFJL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761930370; c=relaxed/simple;
	bh=51HoynwOXBBYpmRQlOlZjPk3WwgqcaDPqx5ZdB388U4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mK1BkkI3lHhyT+IR9lf4zcQxDjQbT+dWr3h0dkgGn6zoH1laNM/uYz+prK4YLcPrIvO/hYDoLU8uZoBQFA0/f/1r8z1h9+O8+DyIjTwIQ5K+WpsWam5IGvdacuM/5xFoJOE6QylGhEcQfqrNB/hLCimXeKZsnxoivrhSfcHctGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EEhHOHlF; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-940e4cf730aso642683139f.1
        for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 10:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761930367; x=1762535167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESK5VZc3vh1v+zY2F8OUAm49V9ykNX+vVejA0Uaau+g=;
        b=EEhHOHlFoK8+f5QyodcEejOWF9NHTz8GF8TlT81bD9LgXer/sYSYtrIqotp8968gu/
         Vr2zyOeGfCV8XUZqpl8kxujf4cBo0dQxqGJiMXLdfrEce2J+dvsGlNp5s4ZNpOtorKvB
         PID+OsnWbrfJzcaRtGja/o61M3yXnTpGltTh4KYhiHj3skAVW+FiFMEp6OGhOIW7fKIr
         vj2r5dBMsaAGoCR7SrGUQXwnf/jZcWOzoWC7u+a2ynh3rxB2HepvmlzJeEWYqhdIyrJX
         Ll02J+CrQUkMArgEz9/gI6Tszu5FJ/vpAad4FO7oG4sei7itVOa6hE3YBLFtcbbqfyvB
         ncjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761930367; x=1762535167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESK5VZc3vh1v+zY2F8OUAm49V9ykNX+vVejA0Uaau+g=;
        b=F8k/4jtu5vCRRDII5qth7+zZW95OhwpyT8Lio+e7+5RwnESbtF+KhgzmOsCv6xGnjn
         5CF0s+5n8T5srTa8evQ3TApS+WybDrNzng+xggUmQ/cfzN4pyUIm1eemv+FfYnIY/nuV
         IL8Jr2vIrxuxsX7Yn3uAj4SeIdM3G7vqM4cd28qlDGb1kG8iU4Q2O/nEd7tjPMh4t9sA
         a2YkzVv8/mOFQwmcpmn4VQlMIxisdI2fyLc9oKfrf0yNEHtTxXIJqjhXW8y8L1eSdKxm
         5FNGETaZO3KKvHWTZjnLWyXOD2+NIjkD4tZyvNhmQr13/xkSY9RQ6luc/Yk6dLd/IXYz
         9dUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl1NilaCL3ifgnGbREHhYgbMF6nhUKPWSRoziDKHb7H095Lp6+82wVVkbDFejHLVQKD8I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvZB2wg5sEHNeZ1ZJilJlKk84TBVtLBeadrmx6ZG8qStZkhsUp
	SkLiL6hwh8VMNYfHHeOeV+xJh8aYMJ5aSSrf5Tczz3ZeKyafko5AuTIY49beCwnwAWKe8wiFUxm
	5VU1s7cKM0g==
X-Google-Smtp-Source: AGHT+IHDw1+d8/l+qhwB+hEV3+qa8J59RyQJZwYBwBtApzCiM87vIs6ZU3Urpv3R+3PkP8aNHR918I5o62+g
X-Received: from iobfp5.prod.google.com ([2002:a05:6602:c85:b0:945:abfb:6eb0])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:6c0d:b0:943:5917:b6fb
 with SMTP id ca18e2360f4ac-9482274fc8amr725849839f.0.1761930367031; Fri, 31
 Oct 2025 10:06:07 -0700 (PDT)
Date: Fri, 31 Oct 2025 17:06:02 +0000
In-Reply-To: <20251031170603.2260022-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031170603.2260022-1-rananta@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031170603.2260022-2-rananta@google.com>
Subject: [PATCH v2 1/2] vfio: Fix ksize arg while copying user struct in vfio_df_ioctl_bind_iommufd()
From: Raghavendra Rao Ananta <rananta@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, 
	Alex Williamson <alex.williamson@redhat.com>, Longfang Liu <liulongfang@huawei.com>, 
	David Matlack <dmatlack@google.com>
Cc: Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, stable@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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
 
-- 
2.51.1.930.gacf6e81ea2-goog


