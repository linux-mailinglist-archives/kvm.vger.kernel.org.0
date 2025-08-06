Return-Path: <kvm+bounces-54108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7101EB1C55D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 13:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC75318C2188
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 11:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3584128C011;
	Wed,  6 Aug 2025 11:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwef8aU7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668A628C842;
	Wed,  6 Aug 2025 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480792; cv=none; b=MTeds0zUaHeN8nJbLS9D32zM8VppTGhcgSi1B1OJNPKMf+1V+Nfd0MmmIHn2+fyzwxPdo54BeZU/sJKICPsbTdSpwSLAJQx13NJLVzb/Gy7miO7nA2ve0GaBjPCrIXLrusY1RQZ1W0SchPddAAHPbtLwghsMrOmMCelk7Mj4H2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480792; c=relaxed/simple;
	bh=AeTg3n2+36U1bKKUxTj3cnvi0+ymaUvU/tCDhqRpp98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b71HUZHv2F6dpIiHKk6CxNAgSDvWltYBzkT9QfbdAVAqnHUHd8r03YLgZYSG3b0RYF6vnZddJLoDuT5OFu6ONziruZcqTwwEVOuKwIwaur+2pH61E89OEcYaIA5VQtR5hMMcp/TPMOgW2wqlNjtSJUFG/KvJoCFccmsNPSpmzo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hwef8aU7; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-b3220c39cffso5279053a12.0;
        Wed, 06 Aug 2025 04:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754480789; x=1755085589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QvQ3K/B+PsFDhSqERlrqC+tEsNJAT5qOCzxTgrGl7VU=;
        b=hwef8aU7/Y8SAbd9sEhEbTK0Tx/ladvDEoB4Bqw8PjIFzrb1Ki0MgJmDzuoL7XbJfb
         c/83Poq/QexnE33nslK78Se2dGcVGwtXRaz0iFkHIJ7+df6fjQ+7vajnW4sW6Wh1IjQ4
         RaIQAU5J4WIFS0cFczQNbUOtkZLhm8LISxJytCMHLA94DrlehBnb+dD1drvMKJ6k7SWY
         6AxiUFRYP2wb6XsQQb7M6lr0coiYw0mSEjyeiOZ060jnghf5+KjXyZvZfL5pZobk7+Mj
         wWeNeca+rAoGItvARhsXmVHGBFp5u1gX5CXimnP0bVwfnCsbGTDmkezEYfYmlONqeCXS
         oB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754480789; x=1755085589;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QvQ3K/B+PsFDhSqERlrqC+tEsNJAT5qOCzxTgrGl7VU=;
        b=MnDZSM7rmE8lzOs8l9x+Gz/xJ5z5nuDPaNsyVRTeFUT7xl91ureMT2lOkovPo3YdFI
         XaISEhIQajeWLGd+senFZgbXqfyYBRHzGAnf6OY1Z/To9wXEDQ7bunpzm78xoaFwDlEL
         2Hpb0/mMqg2dsN3cEi5CVSgJWdf9xJQB9wA4PHBJpfbKfGoRF1pE9Ap7rdHwHovIpFm1
         qRvgp229Uv6sjdKJi4fm+o/KBPYlzD4lSlkOuXsWP0B3WC/0ampXm4WehUZqyaIP3ooy
         E49nKHLjwKIxld7qD/SrjxUohZ/yqjj92oiYOsGEN6/X61LyH2dxGh2Xg3TiJr0WGoA7
         GUOA==
X-Forwarded-Encrypted: i=1; AJvYcCU2TsvvtxDlS3RgOMovTLqbQn0gRYnp8FgfA95fNmTteEzihmI4PF9qG7zjGz0sq/5hy0o=@vger.kernel.org, AJvYcCVRzEl1jWOcKQ1eXTEmO2LLEjkgY0hKSoCzYNshRE/P2wN+f+ukF9VOEOyYnoGNDh11GkkkaCy9@vger.kernel.org, AJvYcCW0zYLoXkLG9TMl7oPI7NJljJ1VUbR5TSe/veKygzEDa1eWCY/RMev1u+4Q6xjgIO9mejQFECTZIQsUKE6U@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7+lJ478rJpPpHXhoem0z3Udk9BAMAWumZxbLgSOW7XyFcMZ25
	IjPl0EfkqghXJ+fm5lsDLy4TsF04FWeS4xeU7vb6f8/kDrrCsYWwg1uKqxB0cpzK9txm3w==
X-Gm-Gg: ASbGnctC+bDdKCjuJIneNxf5HgNUJSPAMXYJ3BxtQbR7Z35qck2ZoF5YOJf6SjUpsYo
	Xf6bDnIOx66/X7Rxq2c+WfHhsNOgXwnV66qGhPvxsM1IdjQ/Qbquu5/95saky2GhCV7eeVXHeXr
	IGsL3rJvrYupT8mLndVm+b5Gz25QbrSFzwggCoCy6uZPFo4dydlxb/Z9iXVCgXuqIORqKM4Mpdz
	06kZLZossPLUpr27ULWfVkZ4bP6UnlgHz2g5pBSay30sbzE9jBqZ8wJiQa/CSCfnEV8AlsPW/gj
	NAGy2T1u6u78o7mDe4keXkLFL8jV+vhD4uoAb/PL728nB5rXoMmBHd/B55nq+EqMvUx8GmkTqSy
	ca37Kx8yCeY8Yoh63tPAXwrEHYsxzvh1UO8f/qIRHtXr9b0Lfq2cuae1tg7RpnKso/FSQf4g=
X-Google-Smtp-Source: AGHT+IGYnNnkqbBejCEa738PL68HMyteeGMcVERAvjm5Y65paJqZqI9HTxHastRunZ+7mQnAMKeaEQ==
X-Received: by 2002:a17:902:f687:b0:240:aa0:1584 with SMTP id d9443c01a7336-242a0b8bc9fmr32866005ad.38.1754480789428;
        Wed, 06 Aug 2025 04:46:29 -0700 (PDT)
Received: from localhost.localdomain ([14.116.239.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce6f6fesm15190656b3a.26.2025.08.06.04.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 04:46:28 -0700 (PDT)
From: bsdhenrymartin@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To: huntazhang@tencent.com,
	jitxie@tencent.com,
	landonsun@tencent.com,
	mst@redhat.com,
	jasowang@redhat.com
Cc: eperezma@redhat.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bsdhenrymartin@gmail.com,
	Henry Martin <bsdhenryma@tencent.com>,
	TCS Robot <tcs_robot@tencent.com>
Subject: [PATCH v1] vhost: fix missing descriptor reclaim on copy_to_iter failure
Date: Wed,  6 Aug 2025 19:46:20 +0800
Message-ID: <20250806114620.2696386-1-tcs_kernel@tencent.com>
X-Mailer: git-send-email 2.41.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Henry Martin <bsdhenryma@tencent.com>

If copy_to_iter(&hdr, sizeof(hdr), &fixup) fails, the descriptor is not
reclaimed via vhost_discard_vq_desc(), leading to potential resource
leaks.

Fix it by explicitly calling vhost_discard_vq_desc() on failure.

Fixes: 4c5a84421c7d ("vhost: cleanup iterator update logic")
Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Henry Martin <bsdhenryma@tencent.com>
---
 drivers/vhost/net.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6edac0c1ba9b..7b4be344b8af 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1238,6 +1238,7 @@ static void handle_rx(struct vhost_net *net)
 					 &fixup) != sizeof(hdr)) {
 				vq_err(vq, "Unable to write vnet_hdr "
 				       "at addr %p\n", vq->iov->iov_base);
+				vhost_discard_vq_desc(vq, headcount);
 				goto out;
 			}
 		} else {
-- 
2.41.3


