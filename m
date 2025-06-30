Return-Path: <kvm+bounces-51070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E7CAED63B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 09:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D6B316E1B9
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 07:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 155BA23ABA3;
	Mon, 30 Jun 2025 07:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrrhH6Im"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBDC223338;
	Mon, 30 Jun 2025 07:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270071; cv=none; b=Hr93khtI3XNhdscve+AaWiV11047MTWORn2hArS4SVyUSizF8H+/hWnBulifIfqvAyov3xrF3M+TZzDJLVsXFUGVbJxkYHfsSR2nNTTg1NdaRMUFMt+R/DGjorVK1tc7znn46bT/UgsCnanzELrXUbRiIeomMdGeb+dkHG9ZGF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270071; c=relaxed/simple;
	bh=Qu4BKUUZZQUC3bM147FV56y9K9VT5HonDkFSvdwo1nU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y5Z5enk0LLcIMCAhFIoMjmV32A8vVkuwh6nYEJnWjI6RKWF9sp/FInwL2xhku43tX1D8w2SB/q0xfhra+IqK/I8QGJG4/nywYUF/wnE2kYvtL8xExBZ4TPIgdr8KUDmnWXgqUkfUaGIbZFihHJ08w8oc5xRYxObGEG3XyGXS5Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrrhH6Im; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-235ef62066eso48502855ad.3;
        Mon, 30 Jun 2025 00:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751270069; x=1751874869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2husDRPyYglRpELzS6mWxDDH6zO8JWO9HlqXQ8aytvQ=;
        b=VrrhH6ImqmZKP7pSRzPDeOJNIqsCqix/iPzVVPDtCXKQETLMp9VhxDuZjWZV4LD6Hw
         F5UPMwq1BYm3kf3RSRFiepqo36HF7KNcicE9SVw4gRJTcC0SSlX6gRsxZHw+7jLy98jS
         hc/jtB4D2yZMYDlPmtMEN1b98oY3CtpkHMZNX5gmYowmV3VGjYfnYl75dPEUu0nasBgF
         IuHMLpn8xFmjTwFeCY4UCvNqh846w1p3pVEw3sw9HisDN2Lty2AmfV8ATF8gr9wCqk/a
         Onmsu9iKr7T1QJkl6DS5dj1W+99ijYcdT868kPZgdTkCMeJ6ii5VF/Gpfi0Jg2zcpKyA
         WZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270069; x=1751874869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2husDRPyYglRpELzS6mWxDDH6zO8JWO9HlqXQ8aytvQ=;
        b=TNnEjj9nxDibkbtO/6fKDunOPULHFbonEnDhgyIX/TthPnILqFO066YYZTI9aMFio/
         bAQl43I0RLZDFY3v/vC2OKqDNxL5Hp+FBn91Iven6yLJ8scgzeGvnWhPwDd0RUJezVyk
         JxKvs/vL6gbt+weI7KEGIM60S12Li6/rznNVvNvKwsFvwVYFM/NDvEgoTP9e3Dp3YbHI
         if687fcDShwX1XlZ5fvzV7TqsfywB8bqlSX3jHzms6X+KnJhwpRP3aqrAswKw9waFZrp
         FZDrVLxI/SCJvLqwH/1mMxZR1jb3c9aE2mljIbLKaET5U6jE0WklAD5MNcn5GfjhRj6o
         Gq3w==
X-Forwarded-Encrypted: i=1; AJvYcCUJWzRlqLQtDQRA9RJLoDJiUcKxbXrCWBAMvoaSqT4cwoCyoJ91mvgEYe6kIBgPrFWbZ6I=@vger.kernel.org, AJvYcCWf+5uU5128P4yzE7JTcCLA7VgFMa6JnWxdSmHVSnvFft64XcbaXkiXO0znyPwX2uYr8NiWyjl7UGHO2u6e@vger.kernel.org, AJvYcCXApddKkju3JrQ3mhuMbTjvuwtksrPKpw87MioDbdr4s4E2ulUs3UqjgKaUs+QkRWgoIYftlio8@vger.kernel.org
X-Gm-Message-State: AOJu0Yygv19yRnHtjfHF63ILU1leaOnqqE8bm8Cji9I1dbCHS4RCGErH
	7171bTSPL5z7IfpLhEKBy4x7/5vqEPwQc2BoUxLCK7TLqtEtYOGmecIs
X-Gm-Gg: ASbGncv4/L6mOyEZX0AbjqsOMxJCy4A3UgK5LNbSnjWfR7Aphl+db1hzE37S+a+ibg0
	oKBKZxYe4/W1EdXSD0adRUr9uiGamTTfrMJ0Zs0+ttW5H9J0L2VXAtzt6sK9VO79kQlUWtnLvea
	MjlRwyB6YBVwVujB4HogGC6SQEnrCuKwrEMX50+Ns5ta4DTBG64gQsdgAeztVnQAHbWVFGvMWoz
	B0qb46Qx+/dkhnIIVzhGVk1qF+ZrUvD9at+NYaDkp8TTn3VRIWndn7BbptuJBuZvbhLsZl0mNym
	/KudONCBXqYbZgPY1CBk1px20Vufm6l686eR120v+M1OXKEdk3vKIggWChFKKF1jh3AKiccwb16
	hC6mUT/Yh
X-Google-Smtp-Source: AGHT+IEZr3xbQKLTkP0IjxZrSMRNxBeFyMR2/3Jbw4FnoAZ37eaI6AARNvB9QQwQ1MQVoMMLZszg1A==
X-Received: by 2002:a17:902:e746:b0:234:d292:be7a with SMTP id d9443c01a7336-23ac3bffdbdmr186477195ad.1.1751270069004;
        Mon, 30 Jun 2025 00:54:29 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f544050csm13450541a91.42.2025.06.30.00.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 00:54:28 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
	decui@microsoft.com,
	fupan.lfp@antgroup.com,
	jasowang@redhat.com,
	kvm@vger.kernel.org,
	leonardi@redhat.com,
	linux-kernel@vger.kernel.org,
	mst@redhat.com,
	netdev@vger.kernel.org,
	niuxuewei.nxw@antgroup.com,
	niuxuewei97@gmail.com,
	pabeni@redhat.com,
	stefanha@redhat.com,
	virtualization@lists.linux.dev,
	xuanzhuo@linux.alibaba.com
Subject: [PATCH net-next v4 0/3] vsock: Introduce SIOCINQ ioctl support
Date: Mon, 30 Jun 2025 15:54:11 +0800
Message-Id: <20250630075411.209928-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <gv5ovr6b4jsesqkrojp7xqd6ihgnxdycmohydbndligdjfrotz@bdauudix7zoq>
References: <gv5ovr6b4jsesqkrojp7xqd6ihgnxdycmohydbndligdjfrotz@bdauudix7zoq>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Mon, Jun 30, 2025 at 03:38:24PM +0800, Xuewei Niu wrote:
> >Introduce SIOCINQ ioctl support for vsock, indicating the length of unread
> >bytes.
> 
> I think something went wrong with this version of the series, because I 
> don't see the patch introducing support for SIOCINQ ioctl in af_vsock.c, 
> or did I miss something?

Oh yes. Since adding a patch for hyper-v, I forgot to update the `git
format-patch` command...

Please ignore this patchset and I'll resend a new one.

Thanks,
Xuewei

> >Similar with SIOCOUTQ ioctl, the information is transport-dependent.
> >
> >The first patch adds SIOCINQ ioctl support in AF_VSOCK.
> >
> >Thanks to @dexuan, the second patch is to fix the issue where hyper-v
> >`hvs_stream_has_data()` doesn't return the readable bytes.
> >
> >The third patch wraps the ioctl into `ioctl_int()`, which implements a
> >retry mechanism to prevent immediate failure.
> >
> >The last one adds two test cases to check the functionality. The changes
> >have been tested, and the results are as expected.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >
> >--
> >
> >v1->v2:
> >https://lore.kernel.org/lkml/20250519070649.3063874-1-niuxuewei.nxw@antgroup.com/
> >- Use net-next tree.
> >- Reuse `rx_bytes` to count unread bytes.
> >- Wrap ioctl syscall with an int pointer argument to implement a retry
> >  mechanism.
> >
> >v2->v3:
> >https://lore.kernel.org/netdev/20250613031152.1076725-1-niuxuewei.nxw@antgroup.com/
> >- Update commit messages following the guidelines
> >- Remove `unread_bytes` callback and reuse `vsock_stream_has_data()`
> >- Move the tests to the end of array
> >- Split the refactoring patch
> >- Include <sys/ioctl.h> in the util.c
> >
> >v3->v4:
> >https://lore.kernel.org/netdev/20250617045347.1233128-1-niuxuewei.nxw@antgroup.com/
> >- Hyper-v `hvs_stream_has_data()` returns the readable bytes
> >- Skip testing the null value for `actual` (int pointer)
> >- Rename `ioctl_int()` to `vsock_ioctl_int()`
> >- Fix a typo and a format issue in comments
> >- Remove the `RECEIVED` barrier.
> >- The return type of `vsock_ioctl_int()` has been changed to bool
> >
> >Xuewei Niu (3):
> >  hv_sock: Return the readable bytes in hvs_stream_has_data()
> >  test/vsock: Add retry mechanism to ioctl wrapper
> >  test/vsock: Add ioctl SIOCINQ tests
> >
> > net/vmw_vsock/hyperv_transport.c | 16 +++++--
> > tools/testing/vsock/util.c       | 32 +++++++++----
> > tools/testing/vsock/util.h       |  1 +
> > tools/testing/vsock/vsock_test.c | 80 ++++++++++++++++++++++++++++++++
> > 4 files changed, 117 insertions(+), 12 deletions(-)
> >
> >-- 
> >2.34.1
> >

