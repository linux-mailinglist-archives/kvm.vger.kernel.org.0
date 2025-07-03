Return-Path: <kvm+bounces-51387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F22DAAF6C12
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 09:54:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBC1B1C47932
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 07:54:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92BD29B783;
	Thu,  3 Jul 2025 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mf01XLBc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF08299A85;
	Thu,  3 Jul 2025 07:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751529227; cv=none; b=Ugu0o4NUfb47HGFjjjcu3J8inUmTTVlDX1kdnjWBH2DM9ulluXqyMAo5P7nGLAfGW4HomixGrZR4f3ax1bUUxFUh8f7OKrtvSwg5vR9GepBa7qmiaXu+MuKC49IEFGJaCNuPB2r83UNfwhG4+YKe1XjUCcFkiPMCkrTKlxhocX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751529227; c=relaxed/simple;
	bh=EAO/alnjYPf1u5+DtQLR/0pbf21VfVmpJZWS6+1VGvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=knaBHDuAbduU4efoUZFWGKTQ65IciP+xyPYvsO9OD60XBPqHwhgmOc/QVla6KfIwGPcbBhnhl1RQnhK26pC7lG+LZ5q1dytb8aoxD4UVV03GCNV5sTyDzOWE37iZphRXL2f8cnGwrZ48urTZC1ZHJ7A0DXnfM2ZF9Y89ZOXhF2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mf01XLBc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31223a4cddeso3445235a91.1;
        Thu, 03 Jul 2025 00:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751529225; x=1752134025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5Z3Ibg5dI0YI2U0Q0aEUI660v44K9U+DyvKSIB5G4w=;
        b=mf01XLBc5PMojHYNULfLOA2L6G9YKwG7pzSZDrTKOBhGSkg1fUb8E7j8MyqCrYXodL
         ZIAWCn+/Teqt8qs6lA9UDsV1GfdWIotqzOUnp9hZ0HKyJ94x1rSy+DKzT0qNYOdX3IBZ
         W/Wv2WjyGmDhWqw+ln3UvUDbM+L3Z9Z1E9U3eXRPKsGDCSYmM4FV0jG4xfs5M5sfFPdJ
         WUoX8g8VeZ4rtcrRZAbS0Dt61DjjTvYOUZmkkTsJA0N8+XKZ7WtUj6jQia8njlmSMCSQ
         YyRRUk1TvGXOqVvOBR5v5N+/nhejnk9hBLwfwK1WNWuChSg37Yb/Xc1hApVc1hSu8Qnf
         nFxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751529225; x=1752134025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o5Z3Ibg5dI0YI2U0Q0aEUI660v44K9U+DyvKSIB5G4w=;
        b=FkjugsMktYQw+K9qB6iYYxQ9esj7HxK9BU2zg+rkb71J8R8PTXDhr/Ovkdnh4v9MLT
         /Rker0hAGuP/DGNMpLAu81Wy7592fxgEF5Fy9asV65kNgSN+ZV4HHfD6+USkRtRQa88d
         vh8SmnDDhB1a5cDN2z43+/4mZMs9B7WVB/CgOpPscHCRhSzUsp99nApbBziiPG+FbLcz
         ++ZH2Byvk6Dtj8qqGOXhjWNA+UpC08KBavZ/GtCzhOzqKRi9a3geKCFq05GyVl6mJnTr
         +F8y4A+Np4vrc9GXlch3eeHtrXPn7w2tAumsXeRHUkXuT6upapiqbpy1d2bAqh3ocYo7
         DX6w==
X-Forwarded-Encrypted: i=1; AJvYcCUOt41p7ig/CboFg58xTapoafQ0lYVCmrmhHj8tWLEIfwwdB2DuPVZAR9vLG/8DqElwl8G51nDsBtqLdCy8@vger.kernel.org, AJvYcCUWrVp3EnwMgd9Nkf8ne38UUXPVUAn9wHFJCvNfh/gGCPnpA5Rmdg14c2bhlxbesa3+x30nmiil@vger.kernel.org, AJvYcCVLhhTMD5cj1EzMY38LO3tUR6OsRv7en2gIsVPcutk/9DLDqv9SeaZUonbepGLvxNU/C+s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjvdCBKUNV5029yTi0z6dZ3cGHlsi68PNpDnBXIKcu8dDmFGvg
	U6Toq/ZfB1gWsX6ChTlGLNJDdfC67zThonEYtbt8Q2K9dqBNLwfZqTOeJhsXwdxgDulHGH6W
X-Gm-Gg: ASbGncuRCQgb2q8h5X8Xy4yHRDrUD99JAbNIWsnBpB89womxCaddg5jwdEI35vsdi4q
	aPBvjYDWIQWj/TEwEwRcb/o/QP76Zlx0kq4AwQQT9yiSNShTd7cA3KcR2iv1cIx+gpU/QZYW2l7
	QSbM1LsqnPV2+G564BzLPYQxoMnc+W7XX2IzofIzrcwnjcvmVlBLL/zHlIXaI6mODQ27GbFxzNV
	L3/5zyby95kIoUfuO5x6YcWikAu+13D7BM9yeJLyMmBXSvcQ2n2Het1ecZlTYgoh6QSMkviHKW4
	zEdoV0xeO2xigqaz9YRsi+Yt9I/pQjulfH7FtQcix5JSi5uNXDfnk6vIzKW4jK28vxMKC9+/CSe
	C0sbvHRmJV/u/Qd+v+Ws=
X-Google-Smtp-Source: AGHT+IG5wCaASyniAIni8ifVqNeDb2b7kJdZU/BUNxpaGI75twsZCp3n4qDX+fcy/2jRkP4DZDxYgw==
X-Received: by 2002:a17:90b:4c84:b0:312:1ae9:153a with SMTP id 98e67ed59e1d1-31a90bef1a8mr8956064a91.25.1751529224280;
        Thu, 03 Jul 2025 00:53:44 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31a9cc5a266sm1788596a91.12.2025.07.03.00.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 00:53:43 -0700 (PDT)
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
Subject: Re: [RESEND PATCH net-next v4 3/4] test/vsock: Add retry mechanism to ioctl wrapper
Date: Thu,  3 Jul 2025 15:53:28 +0800
Message-Id: <20250703075328.1004942-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <ceulzs7srd77t57ozaauveim4dlp6stqmbvvjh5dketapmjzhv@nu6gruoyidze>
References: <ceulzs7srd77t57ozaauveim4dlp6stqmbvvjh5dketapmjzhv@nu6gruoyidze>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Thu, Jul 03, 2025 at 11:05:14AM +0800, Xuewei Niu wrote:
> >Resend: the previous message was rejected due to HTML
> >Resend: forgot to reply all...
> >
> >> On Mon, Jun 30, 2025 at 03:57:26PM +0800, Xuewei Niu wrote:
> >> >Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
> >> >int value and an expected int value. The function will not return until
> >> >either the ioctl returns the expected value or a timeout occurs, thus
> >> >avoiding immediate failure.
> >> >
> >> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >> >---
> >> > tools/testing/vsock/util.c | 32 +++++++++++++++++++++++---------
> >> > tools/testing/vsock/util.h |  1 +
> >> > 2 files changed, 24 insertions(+), 9 deletions(-)
> >> >
> >> >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> >> >index 0c7e9cbcbc85..481c395227e4 100644
> >> >--- a/tools/testing/vsock/util.c
> >> >+++ b/tools/testing/vsock/util.c
> >> >@@ -16,6 +16,7 @@
> >> > #include <unistd.h>
> >> > #include <assert.h>
> >> > #include <sys/epoll.h>
> >> >+#include <sys/ioctl.h>
> >> > #include <sys/mman.h>
> >> > #include <linux/sockios.h>
> >> >
> >> >@@ -97,28 +98,41 @@ void vsock_wait_remote_close(int fd)
> >> > 	close(epollfd);
> >> > }
> >> >
> >> >-/* Wait until transport reports no data left to be sent.
> >> >- * Return false if transport does not implement the unsent_bytes()
> >> >callback.
> >> >+/* Wait until ioctl gives an expected int value.
> >> >+ * Return false if the op is not supported.
> >> >  */
> >> >-bool vsock_wait_sent(int fd)
> >> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected)
> >>
> >> Why we need the `actual` parameter?
> >
> >We can exit early `if (*actual == expected)`, and the `expected` can be any integer.
> >I also make it to be a pointer, because the caller might need to have the actual value.
> 
> IIUC this function return true if `*actual == expected` or false if 
> there was an error, so I don't see the point of aving `actual`, since it 
> can only be equal to `expected` if it returns true, or invalid if it 
> returs false.

Nice catch! I'll remove it in v5.

Thanks,
Xuewei

> Thanks,
> Stefano
> 
> >
> >Thanks,
> >Xuewei
> >
> >> > {
> >> >-	int ret, sock_bytes_unsent;
> >> >+	int ret;
> >> >+	char name[32];
> >> >+
> >> >+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
> >> >
> >> > 	timeout_begin(TIMEOUT);
> >> > 	do {
> >> >-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
> >> >+		ret = ioctl(fd, op, actual);
> >> > 		if (ret < 0) {
> >> > 			if (errno == EOPNOTSUPP)
> >> > 				break;
> >> >
> >> >-			perror("ioctl(SIOCOUTQ)");
> >> >+			perror(name);
> >> > 			exit(EXIT_FAILURE);
> >> > 		}
> >> >-		timeout_check("SIOCOUTQ");
> >> >-	} while (sock_bytes_unsent != 0);
> >> >+		timeout_check(name);
> >> >+	} while (*actual != expected);
> >> > 	timeout_end();
> >> >
> >> >-	return !ret;
> >> >+	return ret >= 0;
> >> >+}
> >> >+
> >> >+/* Wait until transport reports no data left to be sent.
> >> >+ * Return false if transport does not implement the unsent_bytes() callback.
> >> >+ */
> >> >+bool vsock_wait_sent(int fd)
> >> >+{
> >> >+	int sock_bytes_unsent;
> >> >+
> >> >+	return vsock_ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0);
> >> > }
> >> >
> >> > /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> >> >diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> >> >index 5e2db67072d5..d59581f68d61 100644
> >> >--- a/tools/testing/vsock/util.h
> >> >+++ b/tools/testing/vsock/util.h
> >> >@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> >> > int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> >> > 			   struct sockaddr_vm *clientaddrp);
> >> > void vsock_wait_remote_close(int fd);
> >> >+bool vsock_ioctl_int(int fd, unsigned long op, int *actual, int expected);
> >> > bool vsock_wait_sent(int fd);
> >> > void send_buf(int fd, const void *buf, size_t len, int flags,
> >> > 	      ssize_t expected_ret);
> >> >--
> >> >2.34.1
> >> >
> >

