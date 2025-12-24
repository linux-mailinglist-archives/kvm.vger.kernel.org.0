Return-Path: <kvm+bounces-66648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A21E8CDAF16
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 01:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0DB293008061
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 00:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0782A26FDBF;
	Wed, 24 Dec 2025 00:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H51LNra/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945531F1518
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 00:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766536143; cv=none; b=ie3rPZ4Hseu+TJqBSXnEHLKHfcUkqB+e3dzYdE2EY5mvWcMEmNGrQ1nWrUzFJ5jTu3t6LujXAzvfTBXqx3lOrGDgXGlDuSZHZNy8QU5MpfP5zJ7Vf1mYQVD2urb2mVot7fUR7sOa5eIzzVxS9/ngtE8tGUoURWvWLy5Tc4Jng/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766536143; c=relaxed/simple;
	bh=8kT9Sce1CZrAgVQ7vnNZA70o4fM254DKC0wfkmWzB90=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MaoaE5owQpRTCUUD0npHhYJrnHsLffENebHZAnJkfHV6L63yXPSHc5NMlFtrSGDkvGh/P5dpFhHb4Eeo7H9i9Qr79IiIHi0QqWSI7oyS9WEOlHR3XXm3y0PI+8cO0VW7CguPdugtzKrIZWIK1bd194abtjXrdXh7R9eDH00+t+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H51LNra/; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c21417781so5426769a91.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 16:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766536141; x=1767140941; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uP5dCmGJx/cfUOeiPby/DoTXnEYYyl2lr0FiheN3O+M=;
        b=H51LNra/E20XnIqPm6Sc47fNArqriNF6rwLiVuX6PRYhE7mgrUSuy1LUHsGMB9vQ46
         RDhz6J9PQDuzmBA0VfceITP/Dtm6w4GD/253tIkzLjpbDF9/cq7Qm5aEjAjWE3MSqsM2
         H38EsDR6mpny8TpchTiuwUXqu/Yz5RPviKEy767b9ddkQqPpu846VWIJYT8Acqg/sJ90
         zVLiTkn68wqwdFeeZSI8MB+cdSbf0VIGTjFSyDC/CFThpzIZW10B+GuUokCBmfUWZRAm
         qr1lz9m99CxsYQ6Xy/UoI+MUdalzQR5t/WVPSWVFpBDPll6NT7DEK/FcfzW7fIOhomUk
         4hHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766536141; x=1767140941;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uP5dCmGJx/cfUOeiPby/DoTXnEYYyl2lr0FiheN3O+M=;
        b=glBKFrC7RNctT29qI0PQOocJsiXsV6GdBIFA6aiDHfKuBvFxTqV2Vj0eSmSO7Tr6I5
         t79W0ZeiWO+kCraSXo8tFGJ3/5pvlcRcy1Y4HkCaSJ5PVPb/V8EGjKTU1JwS0y+5ptUc
         DbHpVd2uYucIKvBO5Dupzy7nVXPeg+CsvBvDgWAS/XFUhm324yJe1a0zliklCJn7qiXF
         jFNcUJRcRMRImCuqbwl4wmI6L5LQxqCLw1ZcVHpU9UGQm+Tpw0F/9pj2vau1MaIa2min
         LPqr8hQr4UCRT0WAKSZ3x0/fmqeULKLzZZP2mQlhYGBOow/GlrxuoDEqnRnzBxJk8CZw
         d3YA==
X-Forwarded-Encrypted: i=1; AJvYcCUSALJiTXuurvKq8vlypMq8NLDyBFVt6EVvSsIA7VYEXeHk4Gz9V0Cu0fwKV/be+469L20=@vger.kernel.org
X-Gm-Message-State: AOJu0YyExbhfs4gI9rRksH9bcFRLBWj5snUH+xDLn6aVspLNzSaK1M8G
	SRTFotlbb6Bwg451DqkP6RJvj9XYwLyi2xieiOyIA0AVSw4l1opOZGA1
X-Gm-Gg: AY/fxX4Ky61oGg6PcAfMnSAZv1x2QK8/Eh+FDbinT4XmYMISZOgA9pYJsEiCvWWiy2s
	Y1/XsPtmjTFuduN4mQ2cPBN5SWZaPc9ylz2thtE09Nd635SNwt83Ervdd0d9bLY98rGHfibLbZ+
	lEVBgF0WvOtf7RfDylnERcSnTe3EV6XSIB1X0Q0no8uK8cKQ9yX0LOVXLDQxM4ntUtdk11dJ9gh
	/DsejDEd1NbKYPlysFMwRFwHbEONL7s+BmJp0LZfaPFrrGsmoIJUp20eqnbkhDCtSzMd+4yDAvg
	YkfZrWfekfxV5Vsg3CGxHAReW741gV4a40bvrzcVViSCih9gsDDMxj+8TUUisfUDBj7bpeQB7E/
	bZkHjcqI47+HR4mmpvfgHluoPKQxZ/m+8Ht8uuttJSMtzO/22tZp3HRADBiLt5djKRwBtlLA7/z
	eUZ7nCS5HbMivZnCvueig=
X-Google-Smtp-Source: AGHT+IHYttjQEhb9KjxqMyLHj/1hdXCnFP9vzlZa8bawr+JTs4i5zRKkDDsgduCmLxwKQO9RWMQpbg==
X-Received: by 2002:a17:90b:2688:b0:34a:a1c1:90a0 with SMTP id 98e67ed59e1d1-34e921be0e1mr12335108a91.28.1766536140885;
        Tue, 23 Dec 2025 16:29:00 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34ed530475bsm2112700a91.8.2025.12.23.16.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:29:00 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 23 Dec 2025 16:28:39 -0800
Subject: [PATCH RFC net-next v13 05/13] selftests/vsock: increase timeout
 to 1200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251223-vsock-vmtest-v13-5-9d6db8e7c80b@meta.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
In-Reply-To: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
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
 Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, berrange@redhat.com, 
 Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@gmail.com>, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Increase the timeout from 300s to 1200s. On a modern bare metal server
my last run showed the new set of tests taking ~400s. Multiply by an
(arbitrary) factor of three to account for slower/nested runners.

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


