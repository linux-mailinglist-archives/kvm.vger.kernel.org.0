Return-Path: <kvm+bounces-44523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF527A9E82F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 08:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 54DEB1898A19
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 06:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293301C2DB2;
	Mon, 28 Apr 2025 06:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GfI4jWwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D1199385
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 06:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745821822; cv=none; b=iBklSzCUArqfb1K+594ytPI/bwVVzByT1+Qq6wIfJPZcyiQb4FYI5ecGtscANkBwuRB4LKMGaJnYawgEtW1zuYc1MCkr2YlxahAgITW1s3rdoqXC4xjlzHgyD54ApXKLNLj9WqYiUb/CzVA35WQBHpXXztqLX7Vr59p8J/dAkQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745821822; c=relaxed/simple;
	bh=LhGun5W9F5abb5w/6CJo1XspQtgUlBFNZj7WkdbalP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pkn7iCwqKjBcjA3/Ko42cSr6LkOTU9ZKbmQaExBwUKMARGPdsm3m8DMLOY1kRLAW0AE4f6AXxNTujale428hqvhQPlOI1gSy/elI4uIDQDXy+kJrtgbn5v+iQu2pW7dl4wy2XnfKAk6gsJTiGTHMpNgybtD9A6s0hD7/V3JYR30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GfI4jWwN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22435603572so48804135ad.1
        for <kvm@vger.kernel.org>; Sun, 27 Apr 2025 23:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745821818; x=1746426618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RgGaIFvsOidA713vCQyhk+aOH8ZJWbtGMYhOa/1kYgk=;
        b=GfI4jWwN0q/upvNW+EAUOOxiKMaVb7j/cLqmtD4RDheLsvr+SBYbAhuh/25w0ItAFk
         3FR6Nc7MbQiepCXyDFSZ8PYbaaAQ4o7zMH57JFn5UXbjZm7AsJ01lz98UoB0KlfTZErx
         sAQty976er9r+Rl2lYiSGJoJbMQ1FED20gmu1dnyFrXgaPbRP1AMEsglRnGP57S7zQ1J
         17kiBQNN2th85QsnVnqevos/iXEUuAKJ5c0d/CQqyaGtKFO/sidsIS1w9ISMsCJCEF+n
         WRAfJPa05+atZBfYXTUHDwq9rC3luJEnhkeSZEtKhSh4BfhSEdw+ahg5NDAuGOc09zHO
         l9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745821818; x=1746426618;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RgGaIFvsOidA713vCQyhk+aOH8ZJWbtGMYhOa/1kYgk=;
        b=Mym57V4crOCUe6c1g4FNO98OGE8sIKaaR3+kkSNl20n+5i+jb4l64P4dSB8toTVP0k
         55kEpZHPPpa1ahnhuVC+1uCYoXFLVydlB0qB9lAjXyTMy68M9OQILna8cZ5n0nEO1u/A
         US4jFnnBBkG505qouZXOcFNfVTEVoiMuCDeVuu+SVo+NwIDONEq+3NU4AHxDRLsTTwLX
         G8owQ2v8kdH3R7WsP9kxTGlqDAVVIqWjVOxWXXXg6WSHGEsehUYdNN4wpy854zqkSXh/
         ZiCiq7a5SIRMqRKx8QEVVEs8pmY/y81G27Q7tQqscXlj42o0z/8/SZGKkBiHp/bGKADZ
         79nw==
X-Gm-Message-State: AOJu0Yxt/cKt+BBE73TUVCAV36Go7/mhO0M4/txId8GtHQzbivOZ4g3G
	o4NWHb2WwpCPSZS9n2iXghOYiaVGY3AUzJKKa54nlb9pMnEZQmtH
X-Gm-Gg: ASbGncvn1UY4SkNOzuZGQ1KWnGC3fM0dLez2QvcgNwT694EekXQlqxyV0+NBSqoZXjY
	HuPSy8217/TrQtlsYymItAKfK5RKofOwO3y6mGvEHGjl+D7K3/ju9YXy7vqQbxSwdYZ359HKfkJ
	36XddV26abLCthilTLsb12KGgf6xAu3DhUXlwQRsj624qqUretXQqPrzDjDJB6GhSE1L4EiJndA
	CTRbS3oCRYi52Yxd81236iXqQQODAWXO0lM8WB1TZD9hUoXJOxZ+XkwhFTFakaj0VcVCSIoHPRO
	BRcjP4OL2YFgpaoIv7WsZlGYtisUk4iXL6afkV86S8/TGmiMEFBuqMYMrqs9EXeR/BDAM+fKPk4
	kSZn5AfOy+hCX7Da8F4c=
X-Google-Smtp-Source: AGHT+IHNDiFYWCQLrTk94meXLSFxjL47LPt35geGpExeZGOTQYI2dG7MKJ9V7vzXYml/VwXtUdyN8w==
X-Received: by 2002:a17:902:cec6:b0:224:1eab:97b5 with SMTP id d9443c01a7336-22dbf5d53d3mr164271585ad.1.1745821817913;
        Sun, 27 Apr 2025 23:30:17 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22db50e7676sm74760815ad.137.2025.04.27.23.30.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 27 Apr 2025 23:30:17 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: kvm@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  x86/sev: Remove unnecessary GFP_KERNEL_ACCOUNT for temporary variables
Date: Mon, 28 Apr 2025 14:30:13 +0800
Message-ID: <20250428063013.62311-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

Some variables allocated in sev_send_update_data are released when
the function exits, so there is no need to set GFP_KERNEL_ACCOUNT.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0dbb25442ec1..365e6057b04c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1608,11 +1608,11 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* allocate memory for header and transport buffer */
 	ret = -ENOMEM;
-	hdr = kzalloc(params.hdr_len, GFP_KERNEL_ACCOUNT);
+	hdr = kzalloc(params.hdr_len, GFP_KERNEL);
 	if (!hdr)
 		goto e_unpin;
 
-	trans_data = kzalloc(params.trans_len, GFP_KERNEL_ACCOUNT);
+	trans_data = kzalloc(params.trans_len, GFP_KERNEL);
 	if (!trans_data)
 		goto e_free_hdr;
 
-- 
2.27.0


