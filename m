Return-Path: <kvm+bounces-18855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07BCC8FC56C
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE53E1F21DB8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 08:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 795D318F2ED;
	Wed,  5 Jun 2024 08:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HU9rAovr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C09B18C356
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 08:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574992; cv=none; b=C1tVdjIQNTAMKWwg0yqkcBVYsp9dooeF7M3/msf02cMTwch3N2iduoUyGon+/2+HMuIeIf98RH2Z53GJCZb3D8NotQ6/xa4CVs16EhmOJPXFcPzMRh1UbcH87WvqBHsB8OQVy+1w/AA/uEDtH0alV3wHB/h69Jlzqz5awkmZRLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574992; c=relaxed/simple;
	bh=6IZSWLRExzpUDZCnplTV9JMrme9RrcUrr9lpjU+n6hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l419moaqFedGUFgb9fYCMTgSOlG033kmIRe2Awu9hcm4HEDaRpsqQ6ojtdvTXExHrixJtR55fYVc8Pem0ChLTTHEKXZAmm/bkXOFMldhCkjnmKtGw28KsOjn7f23j4wwTwIn5Yyd4MEbi9msaVjldUFSL6fQbwkoGhAHRxT/MAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HU9rAovr; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c2865e2a68so198072a91.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 01:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717574990; x=1718179790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=esoydbraUIIASGXmogMd2xzko2goc41OAG4B60BRKao=;
        b=HU9rAovr7oTMmL7vcUBDvb2Ax9KZI3ES7yaL56NjuKFbsV6lb7fVKUI1rdp8Yw15o/
         p/1q3m7MioPJkS3ufgdZ5mCjjQ2IUN3NrecHGjFQj7NJR5nWUV9TbskVVhG1O2z4wqNb
         FMyD7oOi5pxQLVFkLiEVCgIUnQxa6m1d9UhqmdcOjCo77CVF0fVTiI3/ND98o9fETTZl
         oAk6DaDpC8jFH5gBBPYl0qkPaDmRrqtk7T7BcR+mSYKhDjSzve3mDxrrVo3hT5dgwhUO
         roldMxhvvL7FggZvmga3sw2WWNt6Vud98cR4Tm/z8xFOEqxz1yEnUbUDJvKX5Uo/9mhm
         CdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717574990; x=1718179790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=esoydbraUIIASGXmogMd2xzko2goc41OAG4B60BRKao=;
        b=b5TOQqyw5eeKWWdraUrWiL1fL9exhbO12X5s9KG0w83R2w5q0oUantFLT0Vxxhg313
         5+eHIbWfBL5cZARyTd+3oB4suJtjTYJkDf6xs1/JGgsCFZ+F9tiePbcnh50pBzD9Q6f0
         Mocsz6PsXbfPptcHOZ2itPnEmnYG80c076a5pdZFst9qyaGdJ2laNODroRQW6XLN8IJG
         /eFv5RMR+X3gAWOktNeSbRtp0d/xOuQgcgoAv3Z+q6MDL3kEW89zhEmaxIwpV889Znq3
         gmkV6839xTd4Y61dpjs0efkBqRktKbXbkj+rBPZlIY/jWCf9ZTN3ICJi3U6ZVFMu3mZ1
         xL9w==
X-Forwarded-Encrypted: i=1; AJvYcCUN13AHwEnaA0VOep/f/vv56wGytTkjrHqA6YXAIxJdxKKZF7ufLhuTfJg7ZhmDyVMsZMYI7ZgdFO8eL+CSFpZ9AucT
X-Gm-Message-State: AOJu0YwNQLzHuZD9J8j2i/9UAh3mfu3R5MTtXXyYOKuTtt5Q1BXSrJiS
	Sa2nr11Jz6nMr20tYkPlvtNMo7+BQbYhFhhQxHJkU4qjERNKezWR
X-Google-Smtp-Source: AGHT+IHHP6En64moLWP+9VMwxfwMpuecw2TmZp70mum1MrXH6AUFfgYf80GMzbYyN//aBWJorZThFQ==
X-Received: by 2002:a17:90b:4394:b0:2c2:27a8:9a6d with SMTP id 98e67ed59e1d1-2c27db0cc3fmr1965644a91.14.1717574990605;
        Wed, 05 Jun 2024 01:09:50 -0700 (PDT)
Received: from wheely.local0.net ([1.146.96.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f64cff7166sm78662035ad.160.2024.06.05.01.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 01:09:50 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 0/2] misc docs/build/CI improvements
Date: Wed,  5 Jun 2024 18:09:39 +1000
Message-ID: <20240605080942.7675-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This just tidies up the two outstanding patches from this series
(fix the wording of the migration group documetation, and make the
artifact when: always comment a bit more understandable).

Thanks,
Nick

Nicholas Piggin (2):
  doc: update unittests doc
  gitlab-ci: Always save artifacts

 .gitlab-ci.yml     |  4 ++++
 docs/unittests.txt | 11 ++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
2.43.0


