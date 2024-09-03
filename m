Return-Path: <kvm+bounces-25733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75827969DF1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A825D1C22F84
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 12:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484511D86F3;
	Tue,  3 Sep 2024 12:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JD23d3U3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE66A1CE6F5
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 12:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725367332; cv=none; b=Uq4vIdJvC2qerUM/3uhcLHxs0s9gyofZP8CW+WEsFs5dcCeUHyRzNTRFYrFG0ZiWojG4x//m4hgdR2eTeNXiT+eSlW22qP4/pPdf7pZoCHgG8ZRYBDTsIWfqInQApQtI04laWhFAD8x4piB1jvTMApcjq34TwE6GYXmN1mFOgxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725367332; c=relaxed/simple;
	bh=aDj/HJd3ALYdWkPfrYF/aZrKeMKdtrt6l1Q8m1OHRI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gLomVvABdpAafFBcUJe1A1InaZrLX2MqgxrUvc0UjujDhii6JdatuIvuETWpBzVThcUCU2Uyl4RsW3lCkloN4fMIAMdTX8DDOpQdNbbe4t8ZnWQtvEWd9oFZT6b1jpxFkd17D4zpbMHaP+aI8/SWvzcDS6d86QSSrsm4zzl+W04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JD23d3U3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725367329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w1GemxTFsONEv2KjJqE+TTM5MVbTvqBJMVyVZjkkY+I=;
	b=JD23d3U34bvAtiVsH6hhAKiSOJOasNrs4qLYXGE2dmdf+UTomeh/B1lSzF1kB+j6B1lyIK
	ltbNM+mkKiteBJw6ZKBmQ8TAut3vflqv7RmqTefXA9Xgi0OHe+ZVphby6LnqYIrZDoRyfS
	1CLVhKQXH44/yd6YISM/whvdDkK5Viw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-r7T7QIk2PHi-e32o7ZNZIg-1; Tue, 03 Sep 2024 08:42:08 -0400
X-MC-Unique: r7T7QIk2PHi-e32o7ZNZIg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-204de0159edso46496545ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 05:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725367327; x=1725972127;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1GemxTFsONEv2KjJqE+TTM5MVbTvqBJMVyVZjkkY+I=;
        b=fJ6hYMpgRPBUrPbbF8k/Ny5CP79PAjklikKMREc2m6Yzqozmg+Vfy/T+m60Qsr2xQ2
         ufaf4VbEKG/a6giIgs4bB6JYdr6defJoHY/LQYaCIQjFDv01UHffvPe5d5D5TLdzkOEE
         7BdRp7RAjLT7lKcooFKDY/mnRPYpW6JlH84EzfNIGoOdGI0Pj2R7QJP0FiDhPc9rQ0vA
         TR3KxGsdYpU35HedwK+YFVPA9n/iswgoWYee6bVHt6heZ38/1ZXDINkJjBlCqqrFwPxT
         PZzq10snhoIY1nVW5YES0Aa7sRFItD1o+yVkjLK4QUm2AR6ut+97QS/8OOXNi4Q7tjP7
         8w3w==
X-Forwarded-Encrypted: i=1; AJvYcCWe4FbYLLxqWbBO5EeHHcT18mwc9ndRlk5y5YoaIqkydF0DdNu8oz2QYGh8T73ouBZiqbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlnO7KV1wnKEJrjIU3kODkp3BbayzZz79rVcVR7fyhu8UFD+LS
	a8QkaY0tIYGxXGROMXTow2N0V5V/EQ3fmxUf2isetp48XRM6haKZNk9fc91ycs9DhgIVCC2uyod
	po+rFXVaIo/TAmzH9/0LY4kSi1WnAyT3zFO+8S90eRpQ1nqd5FQ==
X-Received: by 2002:a17:902:c40a:b0:205:63c5:74be with SMTP id d9443c01a7336-20563c57554mr62196425ad.49.1725367327626;
        Tue, 03 Sep 2024 05:42:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDVJd/djxcrdfjh3cgK32uLwt43rMXO02RJFmG7Ytq7U9kEcnE5saN7Wt4NsiBzfaCahodZQ==
X-Received: by 2002:a17:902:c40a:b0:205:63c5:74be with SMTP id d9443c01a7336-20563c57554mr62196245ad.49.1725367327229;
        Tue, 03 Sep 2024 05:42:07 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20515542350sm80222025ad.213.2024.09.03.05.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 05:42:06 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: 
Cc: Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH 0/2] kvm/i386: Some code refactoring and cleanups for kvm_arch_init 
Date: Tue,  3 Sep 2024 18:11:41 +0530
Message-ID: <20240903124143.39345-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some cleanups. Should be no functional impact.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org
CC: qemu-devel@nongnu.org

Ani Sinha (2):
  kvm/i386: refactor kvm_arch_init and split it into smaller functions
  kvm/i386: do not initialize identity_base variable

 target/i386/kvm/kvm.c | 339 ++++++++++++++++++++++++++----------------
 1 file changed, 212 insertions(+), 127 deletions(-)

-- 
2.42.0


