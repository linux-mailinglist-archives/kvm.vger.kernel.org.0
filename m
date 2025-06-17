Return-Path: <kvm+bounces-49721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1CADADD144
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E78A179BC7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDCF2EBDCA;
	Tue, 17 Jun 2025 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPNd/Fwj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818EE217F34;
	Tue, 17 Jun 2025 15:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750173861; cv=none; b=BfnEQtXtdUf33hh7X3HabWI/PbCtjHPxqEI0qXJR5lKopUs7CkF8MRRX780GV/hh68GPrheqOdY2B//CqpfzbJcfCOFGZ044E4g0e9FuPymo6uDa8V2TxQZ3K9FhVudtyBDSTfMwDrU3DFx1SyMNBHlese8b68q1T1mPqBk1jnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750173861; c=relaxed/simple;
	bh=Ff9lS1Yd/+nqGtnrmnMrj8V8fDZxSoDHmktWe2ibSwA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QEXGzuajy8+3KRd/yG+fY2f9fMml1G1sWM+5vh+5me5jZWPTJa1+TY+Pjqw+Yi2OngKceoWpQ/PHeCwwBMfQs78HnaJmzUzJNXB5RfN/+BaHgF3xQ99jdOfUGjgNB0jCKNhW9lSoKL1atbVSs3B6EOwMH/deYYK4dKQk5KlAmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPNd/Fwj; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-313910f392dso5298561a91.2;
        Tue, 17 Jun 2025 08:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750173858; x=1750778658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jbR+py3WXxAosAVt09Fd+QIJmRYUlK/h5DTO/DPsSM=;
        b=CPNd/FwjpbJ47HpCukq7VPM+rSS92NU8KLvbKcz6/Nzb/3vYn53XN6MzThWM5KR6G4
         s7Hjmxoxfp/WBS+bCYw0g7Y6wCeFiCdwNjhpBoBLycuXyIhnDrEYkfwxzxky5N2C+ps+
         cEBbAbJMvislNaOm5ny3VxlGu12wbtcTSWKQzc8N1GH0ekdy9TR8Oh9iLuToTjId6lO7
         YqRhDVw9Ovrfr0gsJl1XF6y0/Kzw36TM/J+krlb7FkZGW8q4/6r5EPFiExwALHcMgV0U
         Py/4xOxqSfG9fTQ9wtp/dsjA6vIYtCCsGX7IfbejbnTFdXUeDkRYqBhy5brx2fx1VyGq
         en0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750173858; x=1750778658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+jbR+py3WXxAosAVt09Fd+QIJmRYUlK/h5DTO/DPsSM=;
        b=GpnSnrf7uy4Gk5sikw6q0HNLfUfI91/mIIIdVlRPsKsyjO25SCMdbAFu+zd4ZxBQJ0
         fx212wDvuAJnpXvyCveWNZByfCnk57RmMLqW5XB2ynJPppaYwMwN5vtjyodglAtlp6bO
         E4+L97NRc26QdQCXR421VVXv0KOvmLe5Kb/Uy3aqyj08HLx682O0LjwyCABhbTa3nuU6
         wI/QBULo+xdNOcvSbfdrLw9POUduLZm/n9TTid5mU1vw4LF6rp8y6+kwChYkPmdtZynN
         DmZa3WH8+c9frgNHahozyeKJU51cHom2Iep9rbKDbaXuNobi4wkSbrPWOSvstr8DBH9Z
         5fRw==
X-Forwarded-Encrypted: i=1; AJvYcCWBPImt+obI+xBaOS5Z7P2uTVroSx4kGAfocDPtzCfiP20KN9QnMFg6EPsi1cz9XNmFNeNjxK+L@vger.kernel.org, AJvYcCWK9ckO1r0lGDcZvRDxQLk6g6TxmjdPxzg4ki6yrNTeO6edkEEfMkXs9k3HX4qpxCbDnio=@vger.kernel.org, AJvYcCXVB0y7VDmho4zqX6ildu4ie4OQNkQiyTLUHfqAwV8bCDgLmZWd6C2ibRvSqVzoPkeFsGK0KSfkZp4VeMIx@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1mkDpTSFu+PnNKZE2upLdn2Z0ojDmtYHfTnhFHh7ItLmE96lk
	xz9lmsnOnABDacivIj3DmZREJPGkgX+g+NAxh8yWn5RCYos759e3RBNG
X-Gm-Gg: ASbGncswl4btAWWwTXSVM3JFNjZ6+GDMSGMXfpRKyZoTjB8d/V/6ZgDj/lf0GPqqUvp
	DzQdWequJ6pPDtDuUaBafbRqmQ6+07lmFDLGZogTH3b+3kMqkkDOyBL4xK9Lo60czxGcdeM2MoQ
	ylX+em7/7UQ/OCyvi/zPZsamfBFKVU8qxGQgUbUkTtCF6ZzVQYRrREyuXbPXP90fVYkITpndojy
	bRxn0gZPnyCmA9gwXNX1QGAnpcQL+ouoxOfpbRbjV6bkk+7478aZnkl09eDZsXVfs4M9F1YxrE3
	RMT2rxIMdfPKy6S85FGofz53D3SnEC67MaPAEADjZtgyAk7Bx8npHUW0KioIeGkoKPcQRfohCp4
	3bcqA1m9b
X-Google-Smtp-Source: AGHT+IH5MD2+jZvIUtC67uk+pIfR42yS9eI+xyYHXF0u5t7e1n8p6rWyAE/h3yACBAbGGBO+BxREIQ==
X-Received: by 2002:a17:90b:1807:b0:312:e9d:4002 with SMTP id 98e67ed59e1d1-313f1d9bd7cmr21120975a91.28.1750173857515;
        Tue, 17 Jun 2025 08:24:17 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c19d0e36sm10806236a91.15.2025.06.17.08.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 08:24:17 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com
Cc: davem@davemloft.net,
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
Subject: Re: [PATCH net-next v3 2/3] test/vsock: Add retry mechanism to ioctl wrapper
Date: Tue, 17 Jun 2025 23:23:48 +0800
Message-Id: <20250617152348.1346298-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <uqpldq5hhpmmgayozfh62wiloggk7rsih6n5lzby75cgxvhbiq@fspi6ik7lbp6>
References: <uqpldq5hhpmmgayozfh62wiloggk7rsih6n5lzby75cgxvhbiq@fspi6ik7lbp6>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Tue, Jun 17, 2025 at 12:53:45PM +0800, Xuewei Niu wrote:
> >Wrap the ioctl in `ioctl_int()`, which takes a pointer to the actual
> >int value and an expected int value. The function will not return until
> >either the ioctl returns the expected value or a timeout occurs, thus
> >avoiding immediate failure.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > tools/testing/vsock/util.c | 37 ++++++++++++++++++++++++++++---------
> > tools/testing/vsock/util.h |  1 +
> > 2 files changed, 29 insertions(+), 9 deletions(-)
> >
> >diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
> >index 0c7e9cbcbc85..ecfbe52efca2 100644
> >--- a/tools/testing/vsock/util.c
> >+++ b/tools/testing/vsock/util.c
> >@@ -16,6 +16,7 @@
> > #include <unistd.h>
> > #include <assert.h>
> > #include <sys/epoll.h>
> >+#include <sys/ioctl.h>
> > #include <sys/mman.h>
> > #include <linux/sockios.h>
> >
> >@@ -97,28 +98,46 @@ void vsock_wait_remote_close(int fd)
> > 	close(epollfd);
> > }
> >
> >-/* Wait until transport reports no data left to be sent.
> >- * Return false if transport does not implement the unsent_bytes() callback.
> >+/* Wait until ioctl gives an expected int value.
> >+ * Return a negative value if the op is not supported.
> >  */
> >-bool vsock_wait_sent(int fd)
> >+int ioctl_int(int fd, unsigned long op, int *actual, int expected)
> > {
> >-	int ret, sock_bytes_unsent;
> >+	int ret;
> >+	char name[32];
> >+
> >+	if (!actual) {
> >+		fprintf(stderr, "%s requires a non-null pointer\n", __func__);
> >+		exit(EXIT_FAILURE);
> >+	}
> 
> I think we can skip this kind of validation in a test, it will crash 
> anyway and we don't have in other places.

Will do.

> >+	snprintf(name, sizeof(name), "ioctl(%lu)", op);
> >
> > 	timeout_begin(TIMEOUT);
> > 	do {
> >-		ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
> >+		ret = ioctl(fd, op, actual);
> > 		if (ret < 0) {
> > 			if (errno == EOPNOTSUPP)
> > 				break;
> >
> >-			perror("ioctl(SIOCOUTQ)");
> >+			perror(name);
> > 			exit(EXIT_FAILURE);
> > 		}
> >-		timeout_check("SIOCOUTQ");
> >-	} while (sock_bytes_unsent != 0);
> >+		timeout_check(name);
> >+	} while (*actual != expected);
> > 	timeout_end();
> >
> >-	return !ret;
> >+	return ret;
> >+}
> >+
> >+/* Wait until transport reports no data left to be sent.
> >+ * Return false if transport does not implement the unsent_bytes() callback.
> >+ */
> >+bool vsock_wait_sent(int fd)
> >+{
> >+	int sock_bytes_unsent;
> >+
> >+	return !(ioctl_int(fd, SIOCOUTQ, &sock_bytes_unsent, 0));
> > }
> >
> > /* Create socket <type>, bind to <cid, port> and return the file descriptor. */
> >diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
> >index 5e2db67072d5..f3fe725cdeab 100644
> >--- a/tools/testing/vsock/util.h
> >+++ b/tools/testing/vsock/util.h
> >@@ -54,6 +54,7 @@ int vsock_stream_listen(unsigned int cid, unsigned int port);
> > int vsock_seqpacket_accept(unsigned int cid, unsigned int port,
> > 			   struct sockaddr_vm *clientaddrp);
> > void vsock_wait_remote_close(int fd);
> >+int ioctl_int(int fd, unsigned long op, int *actual, int expected);
> 
> what about using vsock_* prefix?
> nit: if not, please move after the vsock_* functions.

My first thought was that `ioctl_int()` doesn't take any arguments related
to vsock (e.g. cid).

I am fine with the prefix, and will add it back.

Thanks,
Xuewei

> The rest LGTM!
> 
> Thanks,
> Stefano
> 
> > bool vsock_wait_sent(int fd);
> > void send_buf(int fd, const void *buf, size_t len, int flags,
> > 	      ssize_t expected_ret);
> >-- 
> >2.34.1
> >

