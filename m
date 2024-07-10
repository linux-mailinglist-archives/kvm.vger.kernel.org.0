Return-Path: <kvm+bounces-21347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE2692DABA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0C2B283839
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56FF1494C4;
	Wed, 10 Jul 2024 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOa1JYOf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A5284A36;
	Wed, 10 Jul 2024 21:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646760; cv=none; b=Q/x3ljVNmxqtDf0F2VlqtN01XgmyJxussvx0l6+USF4b9FIztGhFOZQcM1Pfu04DliNvxU0OnFnl3KhNXr3iheIIVeOldHj/Wa3GDeR4I5eiwbvHpt1G04TFMfeGDyAUTYYRTR6ETRIuNqOYEdUCUTGzryS5cmB2i+Usj9wC6a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646760; c=relaxed/simple;
	bh=4OTZt5riyKFHkA+zfse2GDqT3SsWJIfaNWPsNxmi0Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WgN4Zzqx/Cbpsen1d7Q5njqNL4Bu9QgTovfOPe+KoLKnhe5QFcyLrrUX/XmgZ0O1hcWd1NshdChDaRkRRRbfDElFEqVjFvQcx66me+lrQ0I1UFsyOYEyuqjKaC/8aQjTBCutQMHr7rA84UHaopEKKSBympbgWFYKwd2eBmLleoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOa1JYOf; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-64b9f11b92aso2047597b3.1;
        Wed, 10 Jul 2024 14:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646757; x=1721251557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHc1ID0rf+ZeWARkVYcA3IYS3VCCqmuUAjyfz62UlIY=;
        b=eOa1JYOfJinPIvZlnfvzG6kJkSuSEB378N1cxEpphYwKHZnEwvNs+ATu+YoN1Duzd9
         TNlM8UVt1rikvT9nZ1ZQRsRBCM+NQhfU02FgRsyxNwYDORx2Qri86wgpsc4caVX88dFv
         MGSgMaOpjp/6BNNDDnnxLCDfiWuvejidwornql4tYL/ooSknnmRyc3EQwG+ad9eYzSEp
         us1zP87xibi4U1D6KE3h8cfphMBwk0uAhVcZwohJJZbkLLKVvkqBr9KYocoYqFahjhGt
         lLriA4y6UV2WwipJbG9mcsQUnarKjlthZ2f9dYg9fLmkoie1+oXJyB1Z6x+eeAeoUtS9
         XSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646757; x=1721251557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qHc1ID0rf+ZeWARkVYcA3IYS3VCCqmuUAjyfz62UlIY=;
        b=uH7apLdmBgIwWXudb7CaF0j1bGdZSwJesclp6FJWlQ3cVsfWrZCJQb7TDIfYn6e7XG
         djtccWxdPcafL0lmB2Aal2gCacGvHdVYjrQiFphtGJCwav/fmRLPKx8TPpnRaOAkm8Lz
         ba2myFVPLRNsP78Bgb6bOfASeIIFzgAeI4nMEpEDyTka3pKalZG0GkNzERqGpB7RGP7Q
         wW1058QCunzx4ptBFzA52UQ4LtUMH46sjyt5eX/Oda8hKY3B488qwJuGFXDddaVzU3vC
         o3fy/y88N2w+b3EPYLspDliJtIgiwiYcfeaAV4zrfRhRvjk0+VdBXg91i+ezmcmPOB7Z
         K+tw==
X-Forwarded-Encrypted: i=1; AJvYcCUWWQnCQrKTwConvYGOiqiNnvPz5G2Z3vy6PUw6tXAgUqm8JAyu/KCCvhzCdTHOrGAL6RFY/NxFkEh+6Al1DR58n2h2VqDyPMAXVvVzNzqV6NzVi6oogQOCCwDanvu4305I74xH5vcPibhZp+eLfUHw8tOWDKfD35HzIdGVOTvCU2b5G/O27dv7VS6SDQP/y4vX9OaptXUu1WjXAH4fv4vIDwdkXbEjtlf8Fnkp
X-Gm-Message-State: AOJu0YxWOAEEu/fsaq8zfr7YAq0X1FhbQImt4K2FAXk5KgMyne+Du18n
	9kxX+McjVLXx9Q15ZniabGR+K+LDzSryxYfWxbC5mjD+NE9QTQE7
X-Google-Smtp-Source: AGHT+IEjPkFnHsMfkPchn9B+Jdi+q1cCzl1WkWEy9p/OPucpa9Wk0d3OtoJt4Ti9KZQE0OkyHGT/ig==
X-Received: by 2002:a81:6982:0:b0:627:a917:bae7 with SMTP id 00721157ae682-658ef43fb82mr66490157b3.30.1720646757528;
        Wed, 10 Jul 2024 14:25:57 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:25:57 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 02/14] af_vsock: refactor transport lookup code
Date: Wed, 10 Jul 2024 21:25:43 +0000
Message-Id: <20240710212555.1617795-3-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

Introduce new reusable function vsock_connectible_lookup_transport()
that performs the transport lookup logic.

No functional change intended.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 net/vmw_vsock/af_vsock.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 5e7d4d99ea2c..98d10cd30483 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -424,6 +424,22 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
 	vsk->transport = NULL;
 }
 
+static const struct vsock_transport *
+vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
+{
+	const struct vsock_transport *transport;
+
+	if (vsock_use_local_transport(cid))
+		transport = transport_local;
+	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
+		 (flags & VMADDR_FLAG_TO_HOST))
+		transport = transport_g2h;
+	else
+		transport = transport_h2g;
+
+	return transport;
+}
+
 /* Assign a transport to a socket and call the .init transport callback.
  *
  * Note: for connection oriented socket this must be called when vsk->remote_addr
@@ -464,13 +480,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		break;
 	case SOCK_STREAM:
 	case SOCK_SEQPACKET:
-		if (vsock_use_local_transport(remote_cid))
-			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
-			 (remote_flags & VMADDR_FLAG_TO_HOST))
-			new_transport = transport_g2h;
-		else
-			new_transport = transport_h2g;
+		new_transport = vsock_connectible_lookup_transport(remote_cid,
+								   remote_flags);
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
-- 
2.20.1


