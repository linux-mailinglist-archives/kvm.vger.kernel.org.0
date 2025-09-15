Return-Path: <kvm+bounces-57637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9FDB58733
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:12:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792654C0D58
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 22:12:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68B72C08B2;
	Mon, 15 Sep 2025 22:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="NYTx1QMS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63516298CC4
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 22:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974372; cv=none; b=tQK249ZwN9BN9ei7Iu8od3aK5NV+XxDe3ZpfcoL+0BjEI5gGdUHSQbZ7DA/wOACiVWfKmZpdaJ0OXhOjcM7QksGVQEGzc6WwZE3NCuq7C6U+9d1Sj7WCuvk4MzkSKTZ9/piG20WEUHLAWFXIT1rHTUXZ3SFUMauv0b2RtpnfYdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974372; c=relaxed/simple;
	bh=/C05Dz8CvCd47qVsLG0DV8Pd2esx5GaFIo68IV8cxMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pzOZsSgOqdT+7iaNJcIL/USygnc/V6tKqYpDwqS3ru8vxoqt62ZIDJAh3NZfVViUWOjEdhddT4yZALShNk3MZZEC+4HmqAfOP/UErAdqMkgMQDBAwrdyYkNWTqEUi60+P5dL5ywUZvOJ+zJkRdRV1nHvgGXpjixgUJHRywGHTAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=NYTx1QMS; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-826fe3b3e2bso263694785a.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 15:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1757974369; x=1758579169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gXBHWgp9kRn5Fgoqskj1RRTPYtPKKhSojJsMEkYFUT4=;
        b=NYTx1QMSh2oz2gMjxTOHcmkKTONfA0zxFKgJN/2iW53631WN3+JOAosFSeFqRr4g9E
         lIaLpFOVe0GEmPZdTxOgYKggX2TiC2isvQPZd3PVtCoxgt71iWMRHTZISMlcN+XkZOHf
         ruPJBOjEetO2H6PALzJQmyuVdzA/uYSjWhRG62TXGwkIVz7JnFAqxkrHKqA293BpHpD6
         fVkU6ppqfG75lJdPFftmlMcrtyfPOM5qdSmJvMxBRHR/bovKFPvHqrKxQAFSPRD55rh3
         Od1nAM3zmY0O4tx7GoUhwn97eXL8DjVQwOf29qCazDwTn9VUMs9WZwwlGFTPOhghlDAA
         ppyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757974369; x=1758579169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXBHWgp9kRn5Fgoqskj1RRTPYtPKKhSojJsMEkYFUT4=;
        b=fE9+ipIBAS9jOXeGcA+UEqII5iAcwTSGmka4iY2oc20HjsokPxioMS4NeORG3ypccK
         eWWTuXGgdN51hUaCXNmRXlTTGnstpxxv7jDoKHh1GbHPAAigAbH7aKuXyecAsf7o66tP
         IWtaq8c+VNv8TIf/hbPkcqa5ADiApA6bVMqfCuSfRGGIS281mDAzjJUDPZWQLRa445lu
         Md2exDO2QJAei7P6zZgWx9eVKaLae9AG0HFdqIvzSEcJT/29JU7wMYTEtQ4CfTsf4/lN
         C6qBh4mGq91KyYEEqppnyt+awpzZflXbu2s0z72fvxRS4l1Fe2m4Skb6UbUWvgIVTYjj
         gxtQ==
X-Gm-Message-State: AOJu0Yw1UZS6RBkOwVD1cXX9/GOyYmVEkHpOkz1dDeSmqes4G3902DRI
	xp/vJbZ8OIuj+nidWImC7GJN0eSwAAcpJC/m/fKHAuNzLPe3yox8ds0x82c9WzPMX/E=
X-Gm-Gg: ASbGncvx8M6ZdIcTb69tgDRi4PF/aCbehWWe6XGMkxqojDgc23uspDpBwPFhktdPk5k
	nLoTYI4PCVapj0F9nDvDx5e7LdYBvARAZNWP/EYma1SgCDuKDmJMwHoBpq0k0PMS3feb/Qg3m+M
	RQz6fm7agyvmYSSzLWcw0RVgWRqSp86jK4ZNYp92PJN3bSVQHfcAs1WqmTt6z2e4ZcTMIOEMJ5C
	+9VOYEvdc5vHFlo0EUMcDTIE4yoH0++7TBQxStNqw0fmWUmPK2HDvBt7XHr5H71nYTslbSIfXVj
	KGjrwHloQQhyGs0IYAk5jzKEkCLD9CbhXBzA3Rxi2ELC4ijuJEIKtgQeX2tIzn6nt5mFVmo+rrz
	t0IwYLRiFwUlF6pTBl/3oOVQ3PUh24C4Y/GOX4gAQ3oDyZZeBt0msNxAmTvq11T81clYV66oqIS
	tQsIeXL8Rrmt1VnLngTw==
X-Google-Smtp-Source: AGHT+IEDWA5q82L958u55I2l8XIdLyioaaTJQKQ5WXiI+MnAAGekhtuhSXFqSmAUlS0g26T7SSr1CA==
X-Received: by 2002:a05:620a:288b:b0:829:fd97:e783 with SMTP id af79cd13be357-829fd97f3ddmr497902185a.19.1757974369129;
        Mon, 15 Sep 2025 15:12:49 -0700 (PDT)
Received: from bell.fritz.box (p200300faaf00da008e63e663d61a1504.dip0.t-ipconnect.de. [2003:fa:af00:da00:8e63:e663:d61a:1504])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820c9845c47sm866190085a.28.2025.09.15.15.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 15:12:48 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>,
	Thomas Huth <thuth@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH] lib: make limits.h more Clang friendly
Date: Tue, 16 Sep 2025 00:12:41 +0200
Message-ID: <20250915221241.372800-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang doesn't define the __${FOO}_WIDTH__ preprocessor defines, breaking
the build for, at least, the ARM target.

Switch over to use __SIZEOF_${FOO}__ instead which both, gcc and Clang
do define accordingly.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 lib/limits.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/limits.h b/lib/limits.h
index 650085c68e5d..5106e73dd5a2 100644
--- a/lib/limits.h
+++ b/lib/limits.h
@@ -12,29 +12,29 @@
 # endif
 #endif
 
-#if __SHRT_WIDTH__ == 16
+#if __SIZEOF_SHORT__ == 2
 # define SHRT_MAX	__INT16_MAX__
 # define SHRT_MIN	(-SHRT_MAX - 1)
 # define USHRT_MAX	__UINT16_MAX__
 #endif
 
-#if __INT_WIDTH__ == 32
+#if __SIZEOF_INT__ == 4
 # define INT_MAX	__INT32_MAX__
 # define INT_MIN	(-INT_MAX - 1)
 # define UINT_MAX	__UINT32_MAX__
 #endif
 
-#if __LONG_WIDTH__ == 64
+#if __SIZEOF_LONG__ == 8
 # define LONG_MAX	__INT64_MAX__
 # define LONG_MIN	(-LONG_MAX - 1)
 # define ULONG_MAX	__UINT64_MAX__
-#elif __LONG_WIDTH__ == 32
+#elif __SIZEOF_LONG__ == 4
 # define LONG_MAX	__INT32_MAX__
 # define LONG_MIN	(-LONG_MAX - 1)
 # define ULONG_MAX	__UINT32_MAX__
 #endif
 
-#if __LONG_LONG_WIDTH__ == 64
+#if __SIZEOF_LONG_LONG__ == 8
 # define LLONG_MAX	__INT64_MAX__
 # define LLONG_MIN	(-LLONG_MAX - 1)
 # define ULLONG_MAX	__UINT64_MAX__
-- 
2.47.3


