Return-Path: <kvm+bounces-10738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E255E86F691
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 19:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 757041F21675
	for <lists+kvm@lfdr.de>; Sun,  3 Mar 2024 18:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA5A5FEE3;
	Sun,  3 Mar 2024 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="epgHTI0t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D639F1E885
	for <kvm@vger.kernel.org>; Sun,  3 Mar 2024 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709491027; cv=none; b=EvPmKscT0qZykjNzEllGa7kP9d9fXRcLPZxHATMsz4FcqnpPUXlQiAnQvdfq4EbHpteqHVYqEtob0SbwSxLADElybpdikzvwTD6oULSEG7SdvgXW00nOPo12PfXHUWCfa1yr9G2aQT9T4aw+Hebt26Wqtjd7XsWi47ksodWAPXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709491027; c=relaxed/simple;
	bh=YDhz1XYtvXwsiCTSGppZugWIf7jCvtlASk6dWiZRAp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=qqMR7Ye5dyJ4s72574K7NQI52W96slE6cBa/Lvp3x7LNEEeMEXLSmm8XBSRC88s1e3Bs9+ri8uiglLXH9sRAUGfQAJjJvR4yEAF5RHMWJpSi+00NGYBARDrAsn5Ue/VCktcFBNw8tZN9QW0gnx6pFvf0uAYiG6UVdjOrrPlqrF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=epgHTI0t; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6e4e78f9272so49203a34.2
        for <kvm@vger.kernel.org>; Sun, 03 Mar 2024 10:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709491024; x=1710095824; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1a/D7O7/Jb1iV5gTtK2SQzPlpkJjC7JrAEg9nvr7T6Y=;
        b=epgHTI0tZT+qBAoBAejyPgFXTKqbiLUoiSpzWoKXGw8jnRwdZVVXG4a+4CuomAF70W
         w6AOTWIRyI9bcK8NoTFC3vv81jGTp0G7W7AhussvklqE09YWiPlFaxH3mIcI/GVS30Pn
         KXYTvAkDUQheWHeq+E7X/cjS5iSUOxX0h9HEWa9492J53bq5QSFS/h8m+4TS+je3QIzo
         zJcLAol6m2/k5B+yYuo7dWvzaqZ0A8u+EBDnjsFCVdYurXok7JXdfmO3hTNUgSXu1UA8
         WNIHvW+xbDEI9YCWOkvlFty8xrqapvOoLAZAb4fnxhX4nHZTNk+tiaWYDTCS+0Imw5HS
         pbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709491024; x=1710095824;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1a/D7O7/Jb1iV5gTtK2SQzPlpkJjC7JrAEg9nvr7T6Y=;
        b=jIvPepMXF/NwlNto/nGJ0bPkPgsI5gQSLiX+JWnuBkEfnRJqQOOZBkawZOe5BvKBkW
         Y1xY6Wu29Y+a/QKZks5+yyZBsjTwkjeS/KFKiTXSQoTUCDdTyEH4XsAtuDufNHrPpKrn
         vA+WX5vvRKgJDV6Ppk7CPLO0G+2tO/4fDLqzbR0+U1s7jBCPRI5O/bHZppYOzWJBOyBn
         9CihSOE/SQ+G1XfbkCZRdSO7bKQIgz8tO7rmRjPHY3paFuv5jig/yaVcpsH+zcYUw/EN
         4g1ej65ZhLDlOTESux8tU4htssYTQBtj7vvaH1fg6sfqtRbkbsxgB5KVbL7STNDjv+J2
         euLg==
X-Gm-Message-State: AOJu0YyiWw4Ory3YV0xa9a4chWbOjHreFJ19DP22RMqHEF3gguPZxm+3
	NgxHVY1tlP4ikpE/BWDbou4ZwM8zRFuThWGDtYR+Ea1pYuh9I3aK6xVmHK/74bKeuQ==
X-Google-Smtp-Source: AGHT+IHOdzII5HDcBOUpCKdNm+FXLh9OA73MrE5dsIhtlhfavCXoB6UURf5TAYgUwJNG9AnKkZ22EA==
X-Received: by 2002:a9d:6656:0:b0:6e2:d93f:376 with SMTP id q22-20020a9d6656000000b006e2d93f0376mr7199316otm.8.1709491024390;
        Sun, 03 Mar 2024 10:37:04 -0800 (PST)
Received: from localhost.localdomain ([113.200.44.57])
        by smtp.gmail.com with ESMTPSA id 11-20020a63104b000000b005d8e30897e4sm5943449pgq.69.2024.03.03.10.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 10:37:03 -0800 (PST)
From: Yanwu Shen <ywsplz@gmail.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org
Subject: [PATCH kvmtool] Fix 9pfs open device file security flaw
Date: Mon,  4 Mar 2024 02:36:59 +0800
Message-Id: <20240303183659.20656-1-ywsplz@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

---

module name: fix 9pfs open device file security flaw

Our team found that a public QEMU's 9pfs security issue[1] also exists in upstream kvmtool's 9pfs device. A privileged guest user can create and access the special device file(e.g., block files) in the shared folder, allowing the malicious user to access the host device and acheive privileged escalation. And I have sent the reproduction steps to Will.
[1] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-2861

Root cause && fix suggestions：
The virtio_p9_open function code on the 9p.c only checks file directory attributes, but does not check special files. Special device files can be filtered on the device through the S_IFREG and S_IFDIR flag bits. A possible patch is as follows, and I have verified that it does make a difference.

Signed-off-by: Yanwu Shen <ywsPlz@gmail.com>


 virtio/9p.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/virtio/9p.c b/virtio/9p.c
index 2fa6f28..e6f669c 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -221,6 +221,15 @@ static bool is_dir(struct p9_fid *fid)
 	return S_ISDIR(st.st_mode);
 }
 
+static bool is_reg(struct p9_fid *fid)
+{
+	struct stat st;
+
+	stat(fid->abs_path, &st);
+
+	return S_ISREG(st.st_mode);
+}
+
 /* path is always absolute */
 static bool path_is_illegal(const char *path)
 {
@@ -295,11 +304,13 @@ static void virtio_p9_open(struct p9_dev *p9dev,
 		new_fid->dir = opendir(new_fid->abs_path);
 		if (!new_fid->dir)
 			goto err_out;
-	} else {
+	} else if (is_reg(new_fid)) {
 		new_fid->fd  = open(new_fid->abs_path,
 				    virtio_p9_openflags(flags));
 		if (new_fid->fd < 0)
 			goto err_out;
+	} else {
+		goto err_out;
 	}
 	/* FIXME!! need ot send proper iounit  */
 	virtio_p9_pdu_writef(pdu, "Qd", &qid, 0);
-- 
2.25.1


