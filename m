Return-Path: <kvm+bounces-15413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D54918ABA6A
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 10:58:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91EBA281041
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 08:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9462315AE0;
	Sat, 20 Apr 2024 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mW3Y+hQl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4D0205E31;
	Sat, 20 Apr 2024 08:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713603479; cv=none; b=ajcaOlC1huemL99A/4h3MaW4SiPO2BTx/lYlnnuG6WjOOtO8bSuB/fDcJpacm3450MeYph1EW1cHPFeETwW+ILsddCjeLHpo9yAi+5burLqwZnFe0ib2nz+nTvjPJo5rhbENpUYhYXNGsc46QhQKVzEFeQa/8XN0b4O3GInDt3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713603479; c=relaxed/simple;
	bh=9SRG5NGgAQWbJ7b1PO89EyFuba/zQaF5gPA0aAKRqE8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fIpHTkuyXmnniU7Eplz6hst4HJoCihmLUKjbikA/o0zT5gSBbdBd9n8maNqtwWyuqUvWSqdeJoqeWy46u5agdAI9Gro4mIBFA4TVx2osW+7TXf7qwZzlvDyXCp2nI5qdl5LiZrii7kqt2JFzSEG33ccwdsOpSLAegUPERT3fwo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mW3Y+hQl; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a5ef566c7aso2187549a91.1;
        Sat, 20 Apr 2024 01:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713603477; x=1714208277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48Iq+30cR26jwufNHZ2YfXYM/ol31EjO7UuID9EN8+c=;
        b=mW3Y+hQlOJLtGQYMmwgwZK7x5xro9cefM3KFNwcPq5zTGwmXrsuPlJOcKx+r61ERpo
         gvN30git/K2O+YWkuKYmLfkHeXWIWu97G2aDRyPRBFPhlaLgetMNxyxl1Vhz2234792v
         YD1g3hTrwpy2k0p08eejPPAHnYxfnZb8JwkA5JRaQZTkt3vXoeRc2huS2CdX31uxh9gJ
         UbEHAU6IJpGT4yRsZJjQY2ksn+uLqDmJxF1LrYdlChKgw5UwdQCw+ym0gfmScWuqYFrp
         PReQtoIm/8iDovbQpfXtJuc8wTGmUNrb+0dX9CHpMgXqTnilLBgd9eWEoLbh3ta2vJRK
         M3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713603477; x=1714208277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48Iq+30cR26jwufNHZ2YfXYM/ol31EjO7UuID9EN8+c=;
        b=kixk73HE0VUNlbusAVUufFZlaFpqf3BjBaIaOFw+eK9cHAJ7/STEIFInd7vdEn2RA3
         hQ0+qTqGPmebygkg+v+ZRw4xDd8wMvlgiJi0LW/xSmqdyahuWASz9NpFXU6u+dDFM2YR
         5OzEvlgRxrHQ5SylIWg3afiZFtzJJaiHT5uhHdUnzPwUdYvJZoq/odRnKRcPYiTPr/Fj
         eFPOJPHtrhSZDp0QwMyS08JykShaIWrMmrmKecrlStyLNVlG9dD50WdzYpmO/3eh25Z0
         OobjnZpOswuitUF2PAns8EEiwajEQwv8fCPiFe108j+j0S81SJw791+5syvkgz1aEj1u
         36KA==
X-Forwarded-Encrypted: i=1; AJvYcCX1FrA7GykciXcuEGzUHsb8lr7JXCkm2RiU+EpKWo2PI4mFAFbwxNqEQSRh/oh9EelLxuoVRgtdaKO+HS8DuWTYKCJI+iXzFPWvPMg3iL/74qY3+fOvOudk+AcqC4KyO39o
X-Gm-Message-State: AOJu0YzsgxxrtSExTOPlV9d4Np1N+AyN3ekkl9uNtWu5/Ol00mU6Onnk
	SSJq+vIWpyNtWm7bwDyHnmBVaL02zR840hzACQMegyC4C4+ujtOX
X-Google-Smtp-Source: AGHT+IG8EU9aw+RsorFWmCwNnDqhjyjrO+DrkR5PkJw3blIHTNDCMPTP7m8lFUkodGAIDAyljL2Ckw==
X-Received: by 2002:a17:903:191:b0:1e4:4125:806f with SMTP id z17-20020a170903019100b001e44125806fmr5617293plg.11.1713603477162;
        Sat, 20 Apr 2024 01:57:57 -0700 (PDT)
Received: from kernelexploit-virtual-machine.localdomain ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id mp6-20020a170902fd0600b001e256cb48f7sm4653132plb.197.2024.04.20.01.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 01:57:56 -0700 (PDT)
From: Jeongjun Park <aha310510@gmail.com>
To: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Cc: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Date: Sat, 20 Apr 2024 17:57:50 +0900
Message-Id: <20240420085750.64274-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <000000000000be4e1c06166fdc85@google.com>
References: <000000000000be4e1c06166fdc85@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change vhost_vsock_dev_open() to use kvzalloc() instead of kvmalloc()
to avoid uninit state.

Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
Fixes: dcda9b04713c ("mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
---
 drivers/vhost/vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index ec20ecff85c7..652ef97a444b 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -656,7 +656,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
 	/* This struct is large and allocation could fail, fall back to vmalloc
 	 * if there is no other way.
 	 */
-	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	vsock = kvzalloc(sizeof(*vsock), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!vsock)
 		return -ENOMEM;
 
-- 
2.34.1

