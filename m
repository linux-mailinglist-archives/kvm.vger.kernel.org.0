Return-Path: <kvm+bounces-32399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 045B39D794D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 01:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E56FB22E03
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 00:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2357E63C;
	Mon, 25 Nov 2024 00:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXthyxvC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3B536D
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 00:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732493489; cv=none; b=C29ywr/grX4XXGgupqjnD7DF71yua/RTOs3LNlExqK64ysAE24fnh8OUtgMbBbM6x7jnzMZCBTAtt7DNht9M23Dz4ZqX05j8Zp7z+VvJ/uvapOzC576t7/CvOi4VjjB3RDfu2qHVDTWzypLB3rpsPP636sC0bf/8MZSLaFBZC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732493489; c=relaxed/simple;
	bh=ad6f9CwVWflFTWSWFu9D0x+z6Mr+mnycrcXtlHZDzfA=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=J/kqyDh5HmZKUTezTnaMMi5eaLtxT3W+mDhqlstDhIOGQnoPYs34WT/QGR58v6ZYREhUzVMkeL2bEVHjb1027U5lfazkp7ImPrNRN2VdbMp4UyF7cIjzPvRP2Kko1+6Tiz0d3o26Zk3p2GzFNM1uW1fpl9Z22QI4zWbdgouXiMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXthyxvC; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7f43259d220so2780205a12.3
        for <kvm@vger.kernel.org>; Sun, 24 Nov 2024 16:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732493486; x=1733098286; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ad6f9CwVWflFTWSWFu9D0x+z6Mr+mnycrcXtlHZDzfA=;
        b=JXthyxvCBXdJTH84PAQacC0aAxuZSBLeZvpSE9LczwHpEQdk9YCwzLUyC7EL0GdyRx
         vp5J7LhdxfefOwR9CCwwgTwMpz9lS5KJQ5E18RJcdGcx+V/ccdrStT+0gWK2bBbg/B+y
         BFH5QGvjiTBjI5iS/K10AhKFstAVMAyjBmCsCkyJuOdEoM6f7X0h3e9C8GOADb3C7XDl
         SLC7TCtNZK3scHZ23Zaf0OnqSv1FbtEvlw3bvQ+yFSgZbTDfNesUCCPkYMn064k26Km3
         hlMn7BNkpOQXSotjqAKNguHfHB0KbsvXjB7eJTDzy+92MxxbRNTcfFzHJifJNim6+iM1
         GrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732493486; x=1733098286;
        h=mime-version:content-transfer-encoding:msip_labels:content-language
         :accept-language:message-id:date:thread-index:thread-topic:subject
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ad6f9CwVWflFTWSWFu9D0x+z6Mr+mnycrcXtlHZDzfA=;
        b=u+g8RTw9xYCumNHAl1HTQGGYmKatuMbfPXI98ISL48K2P8CFRrM+J9jq6CBX3riVCk
         T9rV93cxwxLo47+vJg3V+34OjtgzoXLEoTXBjlHxL99j2fIfdtfnrLc/Hi305Q3F1kv2
         C6M36smYPIYuXL8Xu0JlZ+295/kZtwiJVtYCbzUGfyJguEJfvAXCN2mGJtN2MNN5fQDr
         Gr7dvC4N9n7ksKt2QdIrlCIpN/dEsxcgj1MqE4Cd3No8k2cP0FRR3CpKkpdZ8NJvhx/Z
         j3AAtytkGW8XPHd0D/8OVjIiquPLnSKrVHQAWhExeW14zfLgXoIqOCHC2DL9oivwNDF1
         NnoQ==
X-Gm-Message-State: AOJu0YzqCpVtqqx2Z5ohsB+cRGoc19SOUxkKvISGxUwVvQ10YBeckZts
	OKzUuUUOB6lPJkU111Q2kDEAtwQzF62ePORachZrbg2x1VLXnwVCHy/dA9Qg
X-Gm-Gg: ASbGncvmhrsKIVzT/+3tnm/H+yfI6up+uXjtsiW5atdRTIMRhALaeI3D2CLf7Mk6H6L
	jyq509p9GWv4i3u7Wa4dFn4cdnH/270RtrNUc0uE4v9rfKSW9s0KV/HHdcSasjmhdT7TH/xRpC6
	fH8sEZf/a4C3Khd/6fA3Yw6P10G2GtbAlY4vShR55aWrAPzrxbXXHEaqxyeZxd9Lz8q12EPJSe/
	y7wctQaPDoUZf8hup2hifMKLzhBImiDqH+hmwD5dXBUfHFgXSrbANC3Gahe8Iu0yAdgotXWOgbs
	ROwbpB12Gw8YyYzyCtgk2J3xs0VjLya6G8lAcA==
X-Google-Smtp-Source: AGHT+IEAiDjPep8gUgdaI30G7MKRU5mTk+P2c+WwYgpFjfWtBPIQKntCK1uf+ektP/flnDpJTVmB6g==
X-Received: by 2002:a17:90b:4a09:b0:2ea:61ac:a51b with SMTP id 98e67ed59e1d1-2eb0e887f32mr12122533a91.34.1732493485732;
        Sun, 24 Nov 2024 16:11:25 -0800 (PST)
Received: from SEZPR01MB4825.apcprd01.prod.exchangelabs.com ([2603:1046:101:65::5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2eb0d060bcdsm5374209a91.45.2024.11.24.16.11.24
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 16:11:25 -0800 (PST)
From: =?gb2312?B?wLXW6rfm?= <csumushu@gmail.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Using the ldp instruction to access the I/O address space in KVM mode
 causes an exception
Thread-Topic: Using the ldp instruction to access the I/O address space in KVM
 mode causes an exception
Thread-Index: AQHbPs59bej3itDjoEm02FTI/QBOow==
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Mon, 25 Nov 2024 00:11:22 +0000
Message-ID:
	<SEZPR01MB4825C8FFB2994CC67225DB74A32E2@SEZPR01MB4825.apcprd01.prod.exchangelabs.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SSBhbSBydW5uaW5nIEFSTTY0IGVtdWxhdGlvbiB1c2luZyBRRU1Voa9zIEtWTSBtb2RlIG9uIGFu
IEFSTTY0IGRldmljZSwgYnV0IEkgZW5jb3VudGVyZWQgdGhlIGZvbGxvd2luZyBleGNlcHRpb24g
d2hlbiBib290aW5nIHRoZSBndWVzdCBMaW51eCBrZXJuZWwuCmVycm9yOiBrdm0gcnVuIGZhaWxl
ZCBGdW5jdGlvbiBub3QgaW1wbGVtZW50ZWQKUEM9ZmZmZjgwMDAwOGUyMDFlMCBYMDA9ZmZmZjAw
MjA4YTYzYjAwMCBYMDE9MDAwMDAwMDAwMDAwMDAwMApBbmQgdGhlIGluc3RydWN0aW9uIHBvaW50
ZWQgdG8gYnkgdGhlIFBDIHJlZ2lzdGVyIGlzIDB4ZmZmZjgwMDAwOGUyMDFlMDogbGRwIHExMSwg
cTEyLCBbeDIyXSwgd2hlcmUgdGhlIGFkZHJlc3MgaGVsZCBieSB0aGUgeDIyIHJlZ2lzdGVyIGJl
bG9uZ3MgdG8gdGhlIGFkZHJlc3Mgc3BhY2Ugb2YgdGhlIG5pYy4KQWZ0ZXIgdGVzdGluZywgaXQg
d2FzIGZvdW5kIHRoYXQgdXNpbmcgdGhlIGxkcCBpbnN0cnVjdGlvbiB0byBhY2Nlc3MgcGVyaXBo
ZXJhbCBhZGRyZXNzIHNwYWNlcyBjYXVzZXMgaXNzdWVzLCBidXQgYWNjZXNzaW5nIFJBTSB3b3Jr
cyBub3JtYWxseS4gV2hhdCBjb3VsZCBiZSB0aGUgY2F1c2Ugb2YgdGhpcyBpc3N1ZSwgYW5kIGFy
ZSB0aGVyZSBhbnkgc29sdXRpb25zIHRvIHJlc29sdmUgdGhpcyBwcm9ibGVtPw==

