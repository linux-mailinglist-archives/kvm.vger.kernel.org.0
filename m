Return-Path: <kvm+bounces-52110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EBD3B01769
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 11:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5017D1C23114
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B106263C9B;
	Fri, 11 Jul 2025 09:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="Fkp50+JT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB34E26158B
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752225290; cv=none; b=qILNp7H8C/S+t/Wco+bFvJq29LJQnW0xozaNXcRtwSXawqbmsrkhsJtMP6Ql3DZnlimEb9myePHn6kto1V+rRZ90NLIip+WyvlWZgCO8Hgc6IPJ6gwIEs3SgtZHm7+0/cckhWg67zDTe62b3+/Yemi1OQGGIN+o7oIwSNpvZiOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752225290; c=relaxed/simple;
	bh=bV5Hco4rvAtxraGCq5odPjyhHgHv102WFFQL74h2KQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PODO3ejOdYy1ieOwlxs/KwrsM/jnh6hL4VsJ7ucjG9uDf4YrqvhogMqMAASdQCE9deAf/GPsq6qoSFNIo/9MvEg2ZUrIHEMYXKAXaon2Q9UPeE6lGbsIBUKuvYhi9PuwEp1HrLFyGqgYJy08XSRSj7EQ2SuqiDv1Ubagi5cf5P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=Fkp50+JT; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4537deebb01so10409955e9.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 02:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1752225287; x=1752830087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vhrPNudmrAz+qc2Cg1RF0O2gzQZ55x/pYxH9rFC6gDI=;
        b=Fkp50+JTtISgxGnbjANzHmpGFLziAM9aGYqo/NAFOC5kpooceC75T1bYJWXo7XGzqB
         oYNFckH7LCRAb6CUG8KdkDP/aUljTpFCCYCzJcDGUfsBRZTj5sGuBLqX5JXCHXCV2/rF
         +eZhGdbVQQsYY4QIkrPeBormPaM4K7KYw0a89heyzfJxWhnXskWpUDbjCIXcMqdiAzcN
         thK3CSTQz3rPmyskCUH1wtbHnQOxjZrcVBTXEWLpCdZDwPdag3F3MesYST5khNu8a502
         3fho0ogJReOLDfS57Xy6fi/nwQlhAwAWN/bCAuLHQSp8KP3JW37TdErbAMcfjiFrROs7
         avog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752225287; x=1752830087;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vhrPNudmrAz+qc2Cg1RF0O2gzQZ55x/pYxH9rFC6gDI=;
        b=cmagY7zepdTDTQtkop/PKRVVkusb4RUBDKwvEtxjJHDfM2SJaQp/c1ymh22fMPQi3O
         yiWjpKLc3T8tvzRWdk91IuUfsW9wNKgZg3dD7fVgWe9DhXyEDvVhT5IDmhxhPooEnOJ6
         QzeXUPM8icYljSwHcKxBzIBEsOvICaAayn3tYSwCvAibXiUh6YINPBUbXtW8dUbV58Sn
         3chrWL+9IouSgnU3sHwRgOpQ0iHZud7z3fpuwxVZAwXDBWFoi0KKi3h4b+4LIXDXorvh
         7JD8Wf7w83ggxCHMmygn0nF+kPPqkwBSiLAfJnvcPdv07RcAe4V3r40CQXzlstPH3ww3
         /QFw==
X-Forwarded-Encrypted: i=1; AJvYcCWWlomNoDxnDQjgFcmtB23J4aZ1sQe2s9WuOg90GetyNl6zdyKI/iblFi2SyjecwVXKuyA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzoiG90Kh23EZJ+a2Lxa4wAw4eeChPUnte10qFKTv8azTG1uH1E
	UknsDkeEY2ypqVdr7YcaiA9YSBk7hzQ+FeaibTNO0P7uJz+98oMTiMcUTgKmTd2AeC54apE+h7w
	9yKh6
X-Gm-Gg: ASbGncsNYyF1/TD98fuxv8lkqTs8HjTtsjxDaOwO5k7Ce06DtnVlq4nDSXklMp+oGHS
	0NbSaIIzLPNnLjmlL9yFi3W1gAr1kbRGqXdXgar7cyf8NWEXtJIrxm7tpAk2OW2Ek7p4xgKjqEv
	+L2aLI4Zl/MCbvcqL8Jn28pTvc1ORZzfiKlBoBm6OcVCM4XgUebz8J5bXO4x3kVbaapZVNqcfN5
	JZsVPFqvbXvQMhdHoT3hxXBOCoTzkqLkHQcoc+UfHbp30o80pOFbdh6YVM8xrrMRE1cw/Tmihgj
	3qjKbhcK59YGMudIuBh4L4YIIlpRGraKwdxgujvociDP07hNjNCob6WqfUx3xR1nUpIYyZaG34M
	PkzbZIvqKx+pY0Qw8HUB11h2m7l9b1O/5FolPYUnRzHbOEok0OuazIF171lM63Vu2u2W8LF5Jfe
	pXYzWrvwLdOcb4WzaG
X-Google-Smtp-Source: AGHT+IHDcLUZC7L4xEKaSDzRe01GKSsto1n1JmC+eqvnxglufs8b2ciL+Ml71fZsquuK7Oezq7Qpig==
X-Received: by 2002:a05:600c:c11c:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-454ec146a71mr14531075e9.11.1752225286931;
        Fri, 11 Jul 2025 02:14:46 -0700 (PDT)
Received: from nuc.fritz.box (p200300faaf22cf00fd30bd6f0b166cc4.dip0.t-ipconnect.de. [2003:fa:af22:cf00:fd30:bd6f:b16:6cc4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5061a91sm80965275e9.17.2025.07.11.02.14.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 02:14:46 -0700 (PDT)
From: Mathias Krause <minipli@grsecurity.net>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	kvm@vger.kernel.org,
	Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 0/2] Fixes for recent kvmtool support changes
Date: Fri, 11 Jul 2025 11:14:36 +0200
Message-ID: <20250711091438.17027-1-minipli@grsecurity.net>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

these two patches fix issues with the kvmtool support series[1] recently
merged.

Please apply!

[1] https://lore.kernel.org/kvm/20250625154813.27254-1-alexandru.elisei@arm.com/

Mathias Krause (2):
  scripts: Fix typo for multi-line params match
  scripts: Fix params regex match

 scripts/common.bash | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.47.2


