Return-Path: <kvm+bounces-68399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 227C9D388A6
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 22:41:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6787030CFECA
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 21:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 794EE3090DD;
	Fri, 16 Jan 2026 21:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6ZuMxt9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FCF2FE060
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 21:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768598952; cv=none; b=pCyoYveR2ABrrPNdVrw/snqFhqKxVlOE37QUnIYEvXGvz9fdHjhsja3kFJZ/4eTDsVGnPXxLU101ytlUrlbkgz4IIiOpAvIeqQgovn7ZDuwf1XWRJO7Lh+rRXeZdGswMizVJiv8lunWB9U9r8JLczOOBS/syK4oRZtuFTkIfOeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768598952; c=relaxed/simple;
	bh=QFGTndIZnCvd5tocHyARHg0OdzlZifxdeujSy28wwJs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cpAAOszMIfT6KmbC1rSOuJQtWWGYpt0MPh91zxJXbWQ4TdUSkEhMYWMIlFXhIAcW4BRC2Mpgev/hEdFubkl3GeLP/Pg+3zIqKOsuKJRi7GB+Q957gRnRr2FOxkFgfzecHIoAJdBWXst4xf5tn5B+4LrhYocIYTf4CuthvhwSY/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6ZuMxt9; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-790948758c1so23986517b3.1
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 13:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768598946; x=1769203746; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqm0dBa6mjJHml1X9kPKSm15M0oyticD3F9JJwXOMvg=;
        b=N6ZuMxt97tRHsctEEofq6oCk4HrU+Bc4QwXdsJmotoTXAOmHwj31WOS8aazpc/8MmR
         ie6rVcjI4jO5c2YBazRZC6Jysgi1HYSF+nKRUQ+ANXgmo3xmlJgIsIx3xI7ssB9UTNGG
         An9nQhkeL9c7ftpUxYfA7cyz4PG8msfg75fyWelol/Iir3k/WYNZHKz2VWbyBrUPlOWI
         G0EBl9XgKRIDxsTIMA83B6PcMvJNvpKBlIWZJ32KYNtmZRkSb4XpB/3gBj4WP2QpxMh8
         R2z9Qgi3gU+Ns+2ZE2+9DxM6wvJfOtdSjDLIGM55lfKLwxqlN97GHOSRt+QSzNSNYxDK
         C+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768598946; x=1769203746;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mqm0dBa6mjJHml1X9kPKSm15M0oyticD3F9JJwXOMvg=;
        b=dMxsazWOeXWT+x5CgRbjVgoW41+NdYcpBd6ulqWZUkNUHTTwMlLYmLGebTbuHAy3pH
         TmLF2xWV79N8w2W44wuZIRTVAtEYfsxq1be5fpo9iCSea6IlsDzmuPObRGu7Sa6Ceo7P
         U0hEnHhzhhOpuYE9ZzkvwI1sPaz9af8qpLGKxyCvugY1WCrJDsZLK3T7BB/OKY9iot88
         44i9Qw2nS9AfRVgRM8bb5rYa6kbc22AYaNKX2m3PXfHq1dEem0n2PX4BT8x3ByrlCcSe
         hv6uGAqDMEjzP+XBb6/VcYeOac+eRLiVv5G8BR9fEjHEhMX8oG+Tfwoy5LWGsRk40bHA
         0aQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFcrgTQXPbTV0Sb/dUePURdo/mzzwVmyORsJfe0/VOme5PeDnvocn7ZrvWCGUg+B++g2A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrcD8jmqu+YGJhlfOO/lTqS6x8fI0OOxAD+U1mHMtKpX9kQ6x7
	hgIEamQnkFu+tkEMkqZoQ+shsyLHRRxr/IMeiTHnCQSo2oVq8KxCCLdRKuwelQ==
X-Gm-Gg: AY/fxX5mUGSu0TODjVDpCVX5pYjrFc7MKEYe+FaetTz0eRWMqaSh8wztLL7NQ2k1uRw
	vn0s9EUJDkRRHJc624uQcsf9MqbPL1RYn6oM3CyEsovvANOgubY02cfWk7dJKM8o6nFds9wJabM
	Q342jPzfTwf1kp/SPV2m+p0oLx/w14cNtLEX/oxC6+7oe90M29Ozr3fCqz2vjUg5IPmO7Mtu+p6
	XI0lZP8b+EasOLac+6hcg6wcnX787g8IG6JphxE4xKZm2AUkWBCZQBoUUuG8YAGWhPJ8fUamBwo
	ydz6BOXn2RvT6N685OJaOzBBLq3OFp8c0vIL5UbgspN51kvduIz5xUP2dTxNzm35TLmTXxIfjs1
	9TcOEoV0+fbN526P1HAV130JV/VQJw/zUh/xbZ2nSUpf8OZ+Zt52zQHJmyM7Q2Dn5KhckV/axy6
	NA8IiAkikE
X-Received: by 2002:a05:690c:e3ea:b0:793:ad61:b5d3 with SMTP id 00721157ae682-793c52e44e4mr31233967b3.31.1768598946238;
        Fri, 16 Jan 2026 13:29:06 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:a::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-793c6882ea7sm13097717b3.44.2026.01.16.13.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 13:29:05 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Fri, 16 Jan 2026 13:28:44 -0800
Subject: [PATCH net-next v15 04/12] selftests/vsock: increase timeout to
 1200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-vsock-vmtest-v15-4-bbfd1a668548@meta.com>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
In-Reply-To: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
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


