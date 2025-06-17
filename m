Return-Path: <kvm+bounces-49671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2D48ADC119
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 06:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 076A03B38E9
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 04:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E61223E33D;
	Tue, 17 Jun 2025 04:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clDsEYf7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB11923B63B;
	Tue, 17 Jun 2025 04:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136047; cv=none; b=iC5OX/0tucOi0D+TA9yPbw+v+6uHzp1/jBVvXtlk/zxbluV6nJZBOWpGflu6OnjLDnS0gAyzeudTjK/K1yJfCKDGzppudRT2glLtIBGJT2+5SxlXBpTsHhFpB/9G+ePyPYdcB1GpFVfST42Jp84UiJFQSumCnQQTuEbvyLpmw7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136047; c=relaxed/simple;
	bh=yYhC1SvTr4r/q4aKyafrkgVQ1b+GHoCyO4kJ6c3v10c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ixSTZgr6TV/rID65h1fsGnioTurwcQqbj5zvvtvNlL8O/VzEIfp3kTyVrL/UBj9Y8r9Tdv1R3+sjN+5IKI74FdslWtmwJHsz83RZUEfIp6SG0EYkQRhBP3Vp/G4vE9FBd38Ep0bsnH8u+wjVZAX4pzBKtv6fpUiEFbGwDgAu6E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clDsEYf7; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-879d2e419b9so5104793a12.2;
        Mon, 16 Jun 2025 21:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750136045; x=1750740845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Te1ubGn4t4pkro6tbCWw9qlZ7DcNvsq3ids6nDR7Ezw=;
        b=clDsEYf7kG4oxWg3neixkhvTD4lVK7qEtnVpV9vX4ulkOUQFy6VH0bDYqzq0XoQVWe
         imnQmkQBcCEe3J/gWd0Cj90eiIFHbim9x8+V008G3/sLQJNt79tSdSCtPlyd3igRa9ob
         bk+P6v9e68+V+iVPg/P99Yzm4HZimdRHK23pO7Yxn926BNSBWn4qW4fPYKJ6bcMkg1BP
         mJooKpj+FLzih8hJqdMYAvyR+Bqp2wOAFJMCQGkbj5KBwb7J4sx3Vy648ttovVXfSzc0
         mi59CAHl/q//TjqyAXBUvkGRrZoR0dBRMr/nLAcDMM4UNY3scmS3gIjWMx9PBvwy7YJ3
         11Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750136045; x=1750740845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Te1ubGn4t4pkro6tbCWw9qlZ7DcNvsq3ids6nDR7Ezw=;
        b=LQE5imTSStT0cNs9vWtE4tGgKhddwIy6WoJE2T5csw4NJmHATWbs2qnTeWXT3m/H7e
         BCQqIiJBDt9icyuJ6JjHRaPzqQm0KEjyoa1bs2QcN9P7tnjrs0BZiui7lL6LhO5t2Jp6
         m6kxW/S7kfVcyDLsNPrhJT4rlgOnInOKpdOZcs65o7iCCdOk2CXDfzLLggJvxLPDifdI
         vU6RsIs4w5DghepITYM4QkKqB44xrW1Jnkf67qZ27mRCRrAT1u29jPt0xVXG3NUBKWWP
         SK7GBGFsDFBIfpRTFEnS0p4WCh9dXzgEcLiok+SOC77FO170tglmkfDpH9BCzDUnA8rw
         dWRA==
X-Forwarded-Encrypted: i=1; AJvYcCURqAsvv1GwIyLq4KYP4rEf+Ur6kwq2O4Hs0F6dM1GCcHBkAyyOKhIX2+BXe7H6radMLkW2DUjT@vger.kernel.org, AJvYcCWRAArT1jgmSt0hAz9gnRhtvuOtkj9CxMP9pxjkZFM9XU+bkuxalDNekxzIZPBR1ymOEr+lLQZ2y8Gy/aT0@vger.kernel.org, AJvYcCXzX4ayfX371TmAQzX5VHrRObN7HUPICdzSMHMeonB4TYy+tg3bvhHzzVG95O4wQ5Wrj7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHz1gYePG0Nlwv7ld5kQnIWkIEnvD+XXNfw6inUegRnIiYJAXE
	I5aG2QYWINCcX6IgiSZZn2Sj/U6BKjr8244x2bB5tEHgZZJkMXSG01M6
X-Gm-Gg: ASbGncsPpktfGAPksQkHBi0WWZYRpR/stwLp5R3HkVjXLNqYOTF3q5Ib6e9fNqm8D4t
	JL2+obWw9F/0QV+HyAlG4A0tXcjeuxZ7HFJWNqByXu0vgw9yOei7WC306W6gr/qPK43dEMEEVyB
	nIjfDdNBxd7G33OvZjoJxIZUXb+EU6Vns+/BfglgZXf9CScAgJN/2HGhEWT7z7q0JTi/w1WN6p+
	766Ecx376XqgR5q/2ABid3ZUsYXfLUMTzZRHKT0xjwrH5tEEjFG0muA4nfzwOPFlz3HwK+wwoIi
	R4qnkpoalpt/4wfE+6IdeDLqQ+or98kBJk67WjOcKIOkSPoN+FMsOHvysvrlEOoYUKsR0q8fZbS
	avjSOcySZqcn4GnSfRx0=
X-Google-Smtp-Source: AGHT+IFWLomMyMMiootDI6sNH+M2APnpL0s4349WJSyZsCDj3PUu6b9MZuRQQzq74o3s8FUXyYRzBA==
X-Received: by 2002:a05:6a00:1787:b0:748:1bac:aff9 with SMTP id d2e1a72fcca58-7489cfc7ed0mr16816419b3a.18.1750136044879;
        Mon, 16 Jun 2025 21:54:04 -0700 (PDT)
Received: from devant.antgroup-inc.local ([47.89.83.0])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890005f47sm8132852b3a.51.2025.06.16.21.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 21:54:04 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: sgarzare@redhat.com,
	mst@redhat.com,
	pabeni@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	leonardi@redhat.com
Cc: virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	fupan.lfp@antgroup.com,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [PATCH net-next v3 1/3] vsock: Add support for SIOCINQ ioctl
Date: Tue, 17 Jun 2025 12:53:44 +0800
Message-Id: <20250617045347.1233128-2-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
References: <20250617045347.1233128-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for SIOCINQ ioctl, indicating the length of bytes unread in the
socket. The value is obtained from `vsock_stream_has_data()`.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 net/vmw_vsock/af_vsock.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2e7a3034e965..bae6b89bb5fb 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1389,6 +1389,28 @@ static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
 	vsk = vsock_sk(sk);
 
 	switch (cmd) {
+	case SIOCINQ: {
+		ssize_t n_bytes;
+
+		if (!vsk->transport) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
+		if (sock_type_connectible(sk->sk_type) &&
+		    sk->sk_state == TCP_LISTEN) {
+			ret = -EINVAL;
+			break;
+		}
+
+		n_bytes = vsock_stream_has_data(vsk);
+		if (n_bytes < 0) {
+			ret = n_bytes;
+			break;
+		}
+		ret = put_user(n_bytes, arg);
+		break;
+	}
 	case SIOCOUTQ: {
 		ssize_t n_bytes;
 
-- 
2.34.1


