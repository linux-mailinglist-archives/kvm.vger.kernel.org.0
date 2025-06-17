Return-Path: <kvm+bounces-49723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B6A8ADD182
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 02B2517C36F
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 15:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC9F2ECD30;
	Tue, 17 Jun 2025 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmkrqHCs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691EB1E8332;
	Tue, 17 Jun 2025 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174293; cv=none; b=kXjzo3J2zZeJEI4TDe5V2TgX72Zr6LF7HKvEBW2WmPFTLZeBZSuU9WVdDks7Lb3YQNeM7pr1jkY9m/TgoQDMiyCIfVg343jaYQfJbLDM/5yA5BbaLcuJ1roMkdFlER0ci6fhP+2YJjaAcrSXJMrEX1hoOtjyrbAdJACCyybObUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174293; c=relaxed/simple;
	bh=rqsoueWdM1nAxX6i3TdFvPfMOP8bCIS3N3NGt3+7CO4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PXEhFyUeOc/LRr7vkZutx+Xg7nGNYtTCmpBBjBcS4alwLx3K3T2iPP/lBg4fWTBt91aeDEsNkjdNmMx9PZkxjThQWHPeVTjIM1W0n0FSkRMo0ON9J9OqxwA3XN4Ma9AJwUfrnOKgPMeC16PeSKFBDdM32GGrhYMiqAlYjCxg4iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VmkrqHCs; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-236192f8770so41404835ad.0;
        Tue, 17 Jun 2025 08:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750174291; x=1750779091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vONKiPDQFvOV04sWTQ5N/d0Nqz6jFzaBcRhqCM37kEI=;
        b=VmkrqHCsYn2fcTK7aYzdHSBxb8fbolgMIe41ZDcwF/tJQ3gl+8mA5l7B8W3K7mrwwL
         u9gFVCbUbIIph2dR+SpVxej76tYrptfjvXGNRtcEk4Jl5aRwge0r0QicA8Ia6sBzGULE
         HPq0O5cEGeT7EiIVO000CH6yU8Z2TNQBTDsIDPWpV0JYvOIyFueRVwoEVw4+guDCOu97
         HLC4W1pHJ2RH+nLrEkt4IJUr/CtBkNBAuGbuH6P7sRr7EsYmApm9f3x0iJydU2OvCHli
         Y4XCT45nSoQRvqHxQvz8UootX0tt4iRs7NFC04/Phn/VyBjtaZP75xOTyuGAbN8t8nyO
         kGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750174291; x=1750779091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vONKiPDQFvOV04sWTQ5N/d0Nqz6jFzaBcRhqCM37kEI=;
        b=RBINeGF2SPSvirpS1Tzab4k1ENcw96h/HhqtXq5ywL8kS19N8tVYGXANOxzw1Po0Ft
         2gWxnMc5K+b7AGfO5lP6w8EpaPt0EJ4ay3dsmcDRy4Zttu2GKE4oEaZrj8WG+0zGOWVD
         fqVEtpStiTHB4IEgkDABVT0FpsKN2wBXP0Zf0mGm/uNid67sjAEA04OgJvPZhHffh3mX
         snkNaG9NRj+iWqbvtyVxnQgkE/kD6tBSZe3GtBoKHTQPXSYKfy+JXZ99aVWZJ/vUFV5H
         7yQIlT1wp3k/PaK69ik5VlY7UGequiDWuEEqpBdx4b+6JFED9nF079Ap48gBHCxsF5jN
         iAsg==
X-Forwarded-Encrypted: i=1; AJvYcCWDVz1AQ+QXoHfLlmT79cKfiCyAq9nZ/pYtKkE45m0oTuMX1f3DfCZmkvfId8DHXSDe2FA=@vger.kernel.org, AJvYcCX8MuQC9l/fQQ5TIz4zzkxIOurCFK+5tfnxjm31n5CObYHc4ogYYj6pwfBWIA8hBxpKckUgeb6X@vger.kernel.org, AJvYcCX9G6okYyvV7slndFpgVimyvFXbHMqIJnewEWV5WmKfZUyNnckgt1VduopkVHP/UggLYRfn8jMEO37SUPBL@vger.kernel.org
X-Gm-Message-State: AOJu0YxhJ/Rc2EcnJsU7BxJhoIshD7n56PZeWz6FEkjEhCDjlPw8xaTW
	QPTQciBWB6dVsrPcdhzXO6gBM+/3Me9sJCA2WUuQCy+kTwerOLJuUs9B
X-Gm-Gg: ASbGncubfmHeLfLr3tOFaFh2ry158f2khWQnUZFiVLjR1oQ8RfSx1dqfzqgUsEm92rj
	XnzfOtlLvW4Mx0/G1dIUhR75eysiJQn94plzCmrzR3sjPuvJqj6Qn+ROdrunmhl0nUfqqJZG/9/
	4CM+XN11gbfjLvn+eKfWNFVgs+IEPYkG9AKsWRaNi80yH3XjWReaYEsrTB+Rp6jygi+449xlWwo
	Gdw1jmnlw91hDzxwS4FtGi0QDhFqKsKixaIYGul+yXA2vYvAnbuN3QF8tay37pBZkCJtjBSR2uj
	sOj9x4KZUogf2MKLL3Ow0UDd+Q2DrGjhNnlmIWDbupqWhet0gJjbPtv2cjjAee6A9NVHP7pUYbp
	S+UzGSZV5
X-Google-Smtp-Source: AGHT+IGYJo30uXrZf1g+2eeuGKvcXBXQtOlctiDYvFKA0bX2SqJAcMGk1oSS7fnVY2Di05z0qFETSw==
X-Received: by 2002:a17:902:d48d:b0:236:71a5:4416 with SMTP id d9443c01a7336-23691eabe15mr41899625ad.20.1750174290520;
        Tue, 17 Jun 2025 08:31:30 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365de7839dsm81188535ad.127.2025.06.17.08.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 08:31:30 -0700 (PDT)
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
Subject: Re: [PATCH net-next v3 3/3] test/vsock: Add ioctl SIOCINQ tests
Date: Tue, 17 Jun 2025 23:31:20 +0800
Message-Id: <20250617153120.1348774-1-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <fnznqsbg56rfk7szjcprpo4mxy7e4patmj2u5yxbtj33dlj34w@7t5xylskewa5>
References: <fnznqsbg56rfk7szjcprpo4mxy7e4patmj2u5yxbtj33dlj34w@7t5xylskewa5>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> On Tue, Jun 17, 2025 at 12:53:46PM +0800, Xuewei Niu wrote:
> >Add SIOCINQ ioctl tests for both SOCK_STREAM and SOCK_SEQPACKET.
> >
> >The client waits for the server to send data, and checks if the SIOCINQ
> >ioctl value matches the data size. After consuming the data, the client
> >checks if the SIOCINQ value is 0.
> >
> >Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
> >---
> > tools/testing/vsock/vsock_test.c | 82 ++++++++++++++++++++++++++++++++
> > 1 file changed, 82 insertions(+)
> >
> >diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
> >index f669baaa0dca..66bb9fde7eca 100644
> >--- a/tools/testing/vsock/vsock_test.c
> >+++ b/tools/testing/vsock/vsock_test.c
> >@@ -1305,6 +1305,58 @@ static void test_unsent_bytes_client(const struct test_opts *opts, int type)
> > 	close(fd);
> > }
> >
> >+static void test_unread_bytes_server(const struct test_opts *opts, int type)
> >+{
> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
> >+	int client_fd;
> >+
> >+	client_fd = vsock_accept(VMADDR_CID_ANY, opts->peer_port, NULL, type);
> >+	if (client_fd < 0) {
> >+		perror("accept");
> >+		exit(EXIT_FAILURE);
> >+	}
> >+
> >+	for (int i = 0; i < sizeof(buf); i++)
> >+		buf[i] = rand() & 0xFF;
> >+
> >+	send_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
> >+	control_writeln("SENT");
> >+	control_expectln("RECEIVED");
> >+
> >+	close(client_fd);
> >+}
> >+
> >+static void test_unread_bytes_client(const struct test_opts *opts, int type)
> >+{
> >+	unsigned char buf[MSG_BUF_IOCTL_LEN];
> >+	int ret, fd;
> >+	int sock_bytes_unread;
> >+
> >+	fd = vsock_connect(opts->peer_cid, opts->peer_port, type);
> >+	if (fd < 0) {
> >+		perror("connect");
> >+		exit(EXIT_FAILURE);
> >+	}
> >+
> >+	control_expectln("SENT");
> >+	/* The data has arrived but has not been read. The expected is
> >+	 * MSG_BUF_IOCTL_LEN.
> >+	 */
> >+	ret = ioctl_int(fd, TIOCINQ, &sock_bytes_unread, MSG_BUF_IOCTL_LEN);
> >+	if (ret) {
> 
> Since we are returning a value !=0 only if EOPNOTSUPP, I think we can 
> just return a bool when the ioctl is supported or not, like for 
> vsock_wait_sent().

Will do.

> >+		fprintf(stderr, "Test skipped, TIOCINQ not supported.\n");
> >+		goto out;
> >+	}
> >+
> >+	recv_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
> >+	// All date has been consumed, so the expected is 0.
> 
> s/date/data
> 
> Please follow the style of the file (/* */ for comments)

Will do.

> >+	ioctl_int(fd, TIOCINQ, &sock_bytes_unread, 0);
> >+	control_writeln("RECEIVED");
> 
> Why we need this control barrier here?

Nice catch! It is not necessary. Will remote it.

Thanks,
Xuewei

> >+
> >+out:
> >+	close(fd);
> >+}
> >+
> > static void test_stream_unsent_bytes_client(const struct test_opts *opts)
> > {
> > 	test_unsent_bytes_client(opts, SOCK_STREAM);
> >@@ -1325,6 +1377,26 @@ static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
> > 	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
> > }
> >
> >+static void test_stream_unread_bytes_client(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_client(opts, SOCK_STREAM);
> >+}
> >+
> >+static void test_stream_unread_bytes_server(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_server(opts, SOCK_STREAM);
> >+}
> >+
> >+static void test_seqpacket_unread_bytes_client(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_client(opts, SOCK_SEQPACKET);
> >+}
> >+
> >+static void test_seqpacket_unread_bytes_server(const struct test_opts *opts)
> >+{
> >+	test_unread_bytes_server(opts, SOCK_SEQPACKET);
> >+}
> >+
> > #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
> > /* This define is the same as in 'include/linux/virtio_vsock.h':
> >  * it is used to decide when to send credit update message during
> >@@ -2051,6 +2123,16 @@ static struct test_case test_cases[] = {
> > 		.run_client = test_stream_nolinger_client,
> > 		.run_server = test_stream_nolinger_server,
> > 	},
> >+	{
> >+		.name = "SOCK_STREAM ioctl(SIOCINQ) functionality",
> >+		.run_client = test_stream_unread_bytes_client,
> >+		.run_server = test_stream_unread_bytes_server,
> >+	},
> >+	{
> >+		.name = "SOCK_SEQPACKET ioctl(SIOCINQ) functionality",
> >+		.run_client = test_seqpacket_unread_bytes_client,
> >+		.run_server = test_seqpacket_unread_bytes_server,
> >+	},
> > 	{},
> > };
> >
> >-- 
> >2.34.1
> >

