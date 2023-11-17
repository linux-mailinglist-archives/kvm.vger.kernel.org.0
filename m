Return-Path: <kvm+bounces-1973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F247EF6B9
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 18:05:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EE10B20B96
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 17:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EAC3D3BB;
	Fri, 17 Nov 2023 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wd45v6em"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07242D7A
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 09:05:22 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc3bb4c307so20096175ad.0
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 09:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700240721; x=1700845521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/JzfyqyzP468CHh8HfjW0exEgl3Tez431PBBBpphwTc=;
        b=Wd45v6emmwtuPhTPPtkJcdeI2QM71aNSw0HPQ1I3Z1+h74Lx4K+nB6Jc013R8J6aKD
         k/KlZU45a2x5Kt7+gQtst9Dt9cghxgH5MGLaONZPx3RYh/rz6GGpSEv56rewlHcSDpXv
         hlt/rQE+TjzlftX41AGizmZZIzI2HcGrR4j/B566BZKh9dzyRbQgNOkeDhHCogUxzjPi
         6ToywHoZVaYJiqd+7aPODIYL39WaCrEexR/nF3qQ3un1fzhFXFhM47xMCZ8Cq1Xs1jYW
         HnQ2D6BDvo7Uci0XSNUqQZcXPycTnKvdIkxH9YSLq2VXIOQgQJx7nGX9CKK/JaMfGcBq
         BG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700240721; x=1700845521;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/JzfyqyzP468CHh8HfjW0exEgl3Tez431PBBBpphwTc=;
        b=tQjurea6qdb3RyPlwTwYPxhQ8FtQqwb+VSXKIC8YadLuQyNKiDPvAS1hnTHzI1lXzg
         vei247GNZ6HuOtPJZWrbANrFFOWyM389253rbVoSkznhq9IfkAC4ymKWSJtXuuEu671h
         ADTJ4mGg6pXcjWCKGjRj/6j++l5OVLfhRCOSXe4qdsNxoznakAgKBTg5FQ7WBkKUJOHg
         BVDCTZi5kcJiJas2zGk7LNAtvMPlrk3MO2SRILb7Pjz8796xKZq1MuGUWqMdIRo+XjeR
         hMNKHmjL/wi4QrQR5r6SRDNh2qwim9JZpWJe0QYBjJvUasXWTCFfWKLiJaEl28thPamD
         vBxQ==
X-Gm-Message-State: AOJu0Yx3dfJjpNEITtue7KywIUxs9PmaiwOnYIZxlVoipnE31nV5ZioK
	aviV0Huk5wBaDCHUcujOCOmVbaf1FfxdZ/JL
X-Google-Smtp-Source: AGHT+IGaDbWsra6+kCVhYu4dftVl9Tqbe7zAi1rJLnEd70XmyYxhja6CtwX2Fo8nLQK6tjhGijLTAA==
X-Received: by 2002:a17:902:efd6:b0:1cc:23ea:47b2 with SMTP id ja22-20020a170902efd600b001cc23ea47b2mr162141plb.37.1700240721074;
        Fri, 17 Nov 2023 09:05:21 -0800 (PST)
Received: from archrox.. ([191.177.167.170])
        by smtp.googlemail.com with ESMTPSA id t16-20020a170902e85000b001c46d04d001sm1610376plg.87.2023.11.17.09.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 09:05:20 -0800 (PST)
From: Eduardo Bart <edub4rt@gmail.com>
To: kvm@vger.kernel.org
Cc: Eduardo Bart <edub4rt@gmail.com>,
	jean-philippe@linaro.org,
	will@kernel.org,
	alex@mikhalevich.com
Subject: [PATCH kvmtool v2 0/1] virtio: Cancel and join threads when exiting devices
Date: Fri, 17 Nov 2023 14:04:14 -0300
Message-ID: <20231117170455.80578-1-edub4rt@gmail.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This is v2 of my patch fixing possible crashes in extra threads of kvmtool after powering off guest machines.

I've addressed changes requested by Jean-Philippe Brucker and Will Deacon.


Eduardo Bart (1):
  virtio: Cancel and join threads when exiting devices

 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  1 +
 virtio/9p.c             | 14 ++++++++++++++
 virtio/balloon.c        | 10 ++++++++++
 virtio/blk.c            |  1 +
 virtio/console.c        |  2 ++
 virtio/core.c           |  6 ++++++
 virtio/net.c            |  3 +++
 virtio/rng.c            | 10 +++++++++-
 9 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.42.0


