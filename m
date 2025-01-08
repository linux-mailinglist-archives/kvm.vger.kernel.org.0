Return-Path: <kvm+bounces-34765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 851CAA05A1D
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 12:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 223CE165A71
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 11:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3C01632D9;
	Wed,  8 Jan 2025 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="0O8o2Rg3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DED1F76D0
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 11:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736336460; cv=none; b=AWDwiFqMgfcLS3iCeMbv1+wXF0vctkonsskAla2VGi9RgSf41FUOVEZZPY5oQpevA9TfkoEf5A0zquzaXXKIFA26yhtjoJB453M28Nzpda75uV2gocFwT5c0OeKpC2xWtlwE2narKdMH+Vq3B5VAe6hg9lrKgwTbDdwBPcKjvck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736336460; c=relaxed/simple;
	bh=lWV/O/UttiTJkLULUBKYE0bPmgRlaCXXqj66Zi3wY7Q=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To; b=SHPEIjmPs0e2VFr6Y8Z081S1g0RYgk9hJPBEdyjSK1qhf6cyKZMLSVWKTK6IcbhOtD3zN/NBVuCVADNckDfTNm1mxzPHRxbqwGSWZxes+fYTlJ7hK823pPr4tNMw0RVxYMXx82YoKD2aMLViN557jiqpmb/KTs77snPw8jNcYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=0O8o2Rg3; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2161eb95317so252653425ad.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 03:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1736336458; x=1736941258; darn=vger.kernel.org;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDlOhfFjHDP1GFg1z841jK8M5cnJcOZe4IzLR2+JLQ=;
        b=0O8o2Rg3kvaLwTV7ygIfM0gm+EEqBR9VCbQbVmRBWTBvDkUbau3obtsHEq1PZ3l1hp
         kvTaA2nWRnRzyhPXWxj3Awjwv8AWEe4o7WUWbyxFQOmgDgnQJAjVo8MGxYEJfVlX53EO
         spVp8qV768U6zs1ljdYdfNwcDGIVdFXlnm27ZvU4if347G3mFP5Z5vnoc8OAI7xYDEjH
         GbXq6SEzpFnT6XOy7UIHyrLm+CT2StEp+MIZQIIaLESlHA/ZoRIIJ0QuEL88EIEZDTIF
         pY9eMQBFbAh41Heay52j4jueCBlTsvk5XMF0Kwpjccu+xU1uMM4ITsIAi1CYSQOk65Io
         HDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736336458; x=1736941258;
        h=to:content-transfer-encoding:mime-version:message-id:date:subject
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDlOhfFjHDP1GFg1z841jK8M5cnJcOZe4IzLR2+JLQ=;
        b=Gmw5GCblC3ltUhTyqgSHvvm4ji3+7QED23ZSVdmooRoJ3K8DwHRe/tvetPQusRB14K
         EI20bnz+vbfKvd4UcSn/8DLF985GMAr3JT35rwOzm2wMw3FFNluARGOELW3PH8xgHlWc
         AAPFGod/6oYAq9WrG4glHijMScr8KcGAMwQRDoYieEbstDwkGQvrCG3UfMLjGir7qdEb
         lbKTlFfOx+x9ppEJ5YW7K7qispRqZnv8Esk79Aqx7cl+i3vYLGKBEIQQgmnPBmOt5kdG
         Ij7dJUCBwZZBOr3NMX+iN45zAZJoIgi6T6yMX0zId28BQwH6UblzpewzS9ZDC7YJNiT2
         BS8g==
X-Forwarded-Encrypted: i=1; AJvYcCVpGM4OYyXrMCFaku6SFsPPZb90z9NLdYZL2hxryEMSyVKNi7CUZYeuFOgyoxmB6oiQyEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSN2oekXHf42ecnoDgWqfwdhAtqy5AlTn1XS56aNDA9qEx3eTj
	CSyB4WRW4ev7QA+F7rjiC4wPcAY0QvbOvluYY3keDtsUBV0JrkgPzdBM2CD0w1c=
X-Gm-Gg: ASbGncvTuovewD46G0nJpYzhrtY/NtAyVJhDOB5mQm5/UlrDYwwCI4JRb9mzDlUGO7q
	IE7XsJJaj+YmxIeALn4XromMhxyAD9pLyDG3t2Ol7Yydf/DpmxheAIrIrwIG9sD+p3mvwa8OzYQ
	oLLLyC6j3y3ng69D/JFb0MfuyB04k0oFzBUaPUo6InWdiO6hKFcGdePltEIjvwh/LGRrp72YtN3
	H34tD6X2ivmMVfN9ln9AyXxx0BsIb3l9PyvMmpZGUQqyZ2Fnt+YmbPeKAc=
X-Google-Smtp-Source: AGHT+IHFRNXARPASashVpP22bZbsPAi6fmuWW4IEFR4NWYNiuFbqTXoYAUP1T7En6RP96xLPSNA5Pg==
X-Received: by 2002:a17:902:e750:b0:216:5268:9aab with SMTP id d9443c01a7336-21a83fe4ba3mr38646875ad.46.1736336458432;
        Wed, 08 Jan 2025 03:40:58 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-219dc964b84sm325595705ad.50.2025.01.08.03.40.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2025 03:40:57 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH 0/3] tun: Unify vnet implementation and fill full vnet
 header
Date: Wed, 08 Jan 2025 20:40:10 +0900
Message-Id: <20250108-tun-v1-0-67d784b34374@daynix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABpkfmcC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIxNDI2MD3ZLSPF0zs1RDg0QTyySDZHMloMqCotS0zAqwKdGxtbUAGJ7vjVU
 AAAA=
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

When I implemented virtio's hash-related features to tun/tap [1],
I found tun/tap does not fill the entire region reserved for the virtio
header, leaving some uninitialized hole in the middle of the buffer
after read()/recvmesg().

This series fills the uninitialized hole. More concretely, the
num_buffers field will be initialized with 1, and the other fields will
be inialized with 0. Setting the num_buffers field to 1 is mandated by
virtio 1.0 [2].

The change to virtio header is preceded by another change that refactors
tun and tap to unify their virtio-related code.

[1]: https://lore.kernel.org/r/20241008-rss-v5-0-f3cf68df005d@daynix.com
[2]: https://lore.kernel.org/r/20241227084256-mutt-send-email-mst@kernel.org/

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
Akihiko Odaki (3):
      tun: Unify vnet implementation
      tun: Pad virtio header with zero
      tun: Set num_buffers for virtio 1.0

 MAINTAINERS            |   1 +
 drivers/net/Kconfig    |   5 ++
 drivers/net/Makefile   |   1 +
 drivers/net/tap.c      | 174 ++++++----------------------------------
 drivers/net/tun.c      | 212 ++++++++-----------------------------------------
 drivers/net/tun_vnet.c | 191 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/tun_vnet.h |  24 ++++++
 7 files changed, 281 insertions(+), 327 deletions(-)
---
base-commit: a32e14f8aef69b42826cf0998b068a43d486a9e9
change-id: 20241230-tun-66e10a49b0c7

Best regards,
-- 
Akihiko Odaki <akihiko.odaki@daynix.com>


