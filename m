Return-Path: <kvm+bounces-68803-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPBrBe1PcWkvCAAAu9opvQ
	(envelope-from <kvm+bounces-68803-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:15:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F8A5E9E0
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:15:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5FE4D5E8710
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DB8441029;
	Wed, 21 Jan 2026 22:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTE3V2XF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C208542B759
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769033529; cv=none; b=lV3zL8qAURVfYA0+om1ytTCOmvqB5IydruRqRsV5CEIM3jUFeNKl7ZRytZpLCAV2+kqBkeHr6XbJD+LN/sWFemZd9lgBl7ik25ntcj3ndMMhJNK8akLaAwDRqf9bnzwjdJHV7a/wYkKHorlAfkfLb9UAyUE6v/LY05Xadl+jDkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769033529; c=relaxed/simple;
	bh=QFGTndIZnCvd5tocHyARHg0OdzlZifxdeujSy28wwJs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fu1X+J0lOk8HBNi8oVUOUi2h08uJ5gkddNqZwXQiO++gZ7IMAHo4V+QyO3gqDNv96xMQzvECcSpMxAvxtzrqL5XrLPFh6GVYwhuHCoaylEyqXgS/FwGovexS3Aec7/1Ab6F9kgh0gphK65opnSt1hpCz2dCaH8GRndvPzyGrIw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTE3V2XF; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-79273a294edso3143107b3.3
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:12:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769033522; x=1769638322; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqm0dBa6mjJHml1X9kPKSm15M0oyticD3F9JJwXOMvg=;
        b=fTE3V2XF/rfgkDTJ2zPRvnIk73uupZBp4RuazKysKvb/4LQVJODMvJkjGSAFTgyhQE
         +o4Qr3mXdbLpTlH+cjE+RCIw6jGSqjzYyQJNmdno12VNY3OE/UDwZaOggZ0ZEyqIisMz
         57jizkfkmwQtZ9i2EvNW7PKAmumXp7Bsmxefgyfeg7/Dej/5XyZ0goj9FM9vtQY12cRQ
         bqFM/uSnnryGbWTz0Efz+zSzJ+piIfIU5/hWZH/iFts4L1iGVi9n4tMbvoZMpCUPe6mn
         HPbSPhT7ca8U+rEb5pPitYGPLMg/duUXNWJG/gBMfocQRwE5t3Wt1idyalsbddxilldm
         dgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769033522; x=1769638322;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mqm0dBa6mjJHml1X9kPKSm15M0oyticD3F9JJwXOMvg=;
        b=bJcxaBIxdrY/2VHHhg/RCqosHcacrOgEI/XKjvcSBL01U3nN0SkU9ublchlSPMHa2e
         Z0JJ1iZZZ8clVCFEG2dkPXFcpmfmvpgsZRLaOfScsr9Q0/oLSLG1KxpFxG+L83h4vOdb
         dwAwrL52BiXHiFisUm5y4h4PzuBFQW02xl3UYXbA9fSiPfXuPYOGeg4lW84GyRcAAFE8
         7LkfmMFOGss5LC8ch6bGXhdpBjJ0xwokRefvBL3OmfElHEvN2X9zCSpyqfZB2kBs/Hj/
         8E82ziMLpw37fv7esaerQWoY1gaLTIVyZn5+zEe128DUF9Pqd7QP+1L7igogDGpacxS6
         lf0g==
X-Forwarded-Encrypted: i=1; AJvYcCXm5XDxz96WQBjPo517LyXb5JVTfLFqQQI6P6SzC1nhoQaARwc6mL+BjEjtr7Jgv8BA/V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYfZ+HH+pM8gMCN/RqhlHyNuWY4aFiBp5FH+wSJ22IG6b3HyJR
	Jce4POVwsTI8VsoBa307/WwidkEBYI3z8+dUPTP3Kqy03VgnAAb3V0TV
X-Gm-Gg: AZuq6aJvOiIEGHQxaG+17PKdcQPGVMRHX8zIBBkwOZtyHrWqjBBR2meRrjjVzD4uhjb
	z9QvDRKqntxfUQXeIrGg859fzUy9FcfJ6Iv9OIe3R95GamTQQnUdgNAbtAKlpIlX13GAwCW/zA1
	N06G1FjtdWZnhylqN/UXpXRBXGXZFMhzPGwjYzN91HENBhhJHDpplMHK0K/VErjL1tc1h3BzBoI
	q5d+Mo5Efcc+B9tIFfHKle2ebpdwt+2kPLiRCsdLhwdShcjF4L7YFGnUxFDNx0MFzbInG9PXX4r
	+2q0h7zcBPKMUD38gqpcB3/Br5by8zepDhzQXYwlEKYFdShlGZ3dQketPa7ffstB4MQrVRwNXuU
	wwD4cjIpmSsCDRdFBPBnzCOEmjBZAMUXGFWVfNm3u5i1BK45MHnl8blaKQu8jFq25NfINNwibaM
	u5nUU44LsR
X-Received: by 2002:a05:690c:7204:b0:786:a0fb:fa8e with SMTP id 00721157ae682-7940a11e123mr58055607b3.15.1769033522528;
        Wed, 21 Jan 2026 14:12:02 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79415015f4esm20243667b3.22.2026.01.21.14.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 14:12:02 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Wed, 21 Jan 2026 14:11:44 -0800
Subject: [PATCH net-next v16 04/12] selftests/vsock: increase timeout to
 1200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260121-vsock-vmtest-v16-4-2859a7512097@meta.com>
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
In-Reply-To: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
 Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,redhat.com,sargun.me,gmail.com,meta.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68803-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[32];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: B7F8A5E9E0
X-Rspamd-Action: no action

From: Bobby Eshleman <bobbyeshleman@meta.com>

Increase the timeout from 300s to 1200s. On a modern bare metal server
my last run showed the new set of tests taking ~400s. Multiply by an
(arbitrary) factor of three to account for slower/nested runners.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 tools/testing/selftests/vsock/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vsock/settings b/tools/testing/selftests/vsock/settings
index 694d70710ff0..79b65bdf05db 100644
--- a/tools/testing/selftests/vsock/settings
+++ b/tools/testing/selftests/vsock/settings
@@ -1 +1 @@
-timeout=300
+timeout=1200

-- 
2.47.3


