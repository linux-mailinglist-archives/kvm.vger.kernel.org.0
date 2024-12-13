Return-Path: <kvm+bounces-33787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 620BE9F1B36
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 01:10:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3EC0188EDF0
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 00:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF0A41F4273;
	Fri, 13 Dec 2024 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kfhldL39"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EEF1F2C48
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734134305; cv=none; b=nIbN4yHqhzpX2LTpL1PdqOa0S4hM9naUIiY/28McWixGmD1x0Bb5296zzTHF6AQVxLXJrdOkbjtwvaKmz9GZuegFTU8SFA0vdyH/yUVgG2Xc1SJKZ+iFFra+sNn7ALBM9K3iK8ASl+/83s83trsmiAr1UtgKvu+vwmeOTu52hHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734134305; c=relaxed/simple;
	bh=OGq5+hgs9dJ1yb7kwu/w29GCqzBZmKeO5Y+Ru+siBvE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CpBgW3AC8u1oR4iBPYqKrLRIuI3Rc2BT4GgEwKGMHM44vwbKrl8p3b8gb9/noIdqSV4TvxnEg2x22ldA3RdIjKpXTl2Bab+jCqNFjemWkE3HAkKfycaeZiiwDUn3dib4AXyZ+jJzPTa+/RJ6Eu0/VDHumP3p3gbHphwNiLgJ7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kfhldL39; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-211c1c131c4so28409335ad.1
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 15:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734134304; x=1734739104; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUgYlM58E1ID1zBsFizknmN76M0X0I58a2gj7PTiNA8=;
        b=kfhldL39TBzg9mfNZ38MUKouWW9n3KF8rCW8KQmRe1H0hGO3EhPDeZXjXTlhoquyrR
         1CLApWPe8V31MNazpfb28xvW+4gfohLNIfOLrlVr482N2e/jfUbauX7klRetYEEht73L
         gsZnytOQRypwAUUOoDHoiJ6qgRHFavAGtEBu9Bc1zrQ2Myg55pMRCiyhcLxQPAJeDyDI
         3vCh5/hwZ6bZ7Oh/3S4u20eKFDUlPzDMTQCmD0b3FBFrEgDrJmh5liv6r9qb7o0mFqH5
         2xqUzIYFRK0unNWhPBqWsHEzecJ3EWI/lM2KQXPhNUyt6doxo6BZKmXkvUDO0cCRq4Lg
         eyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734134304; x=1734739104;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pUgYlM58E1ID1zBsFizknmN76M0X0I58a2gj7PTiNA8=;
        b=oBJVgSSQJtN67lBOz9jhba5jLn/kHyX+OPvrbW7rrZL2yR7fzvsgCjSu0m5Qe7pOCG
         aj9JZzg52n+r9QinTahbYWxk7r2oSyWXNZEchh1K3gwIkD595fUwHB4NZhAYR09Xil94
         OhUgHI8/eWPAwrQCEqE82rKCozlb99c23AAnwC0un79niEKmI9BlsVpephfLm1CcVwYq
         +zdifadnbM0HufSy8Brq81s5QqFsJxE4GAzs3B+m0sbiwfq8OZ51OspWwkQSyMNJRTO1
         7izpPE6P+ITkJirDhKXtxw/qJolOikntkMZ9zM2rayCWrJ7DIL0KdI1XC42BxrrXVFPU
         Dqhw==
X-Gm-Message-State: AOJu0YyzPd5BAeBYKNywNeUVWQy/6O9f0KKnI0BQ8n5qcghkyMbKt+FT
	PWzAJsPqtC5MoqprVxF8rxBMB0SSiuRjFrKAeNyl46zdBiLTpWJFScin1xBS8jAsyUssOjq73iv
	k2A==
X-Google-Smtp-Source: AGHT+IEx2eqGQFBGQTUi/pn7XgE3bLWI9EM+6VGiZXjWJeNOX1FQChOgohoyAT6tKICqO9oQPQKyJbJfX0k=
X-Received: from pjyd4.prod.google.com ([2002:a17:90a:dfc4:b0:2ef:973a:3caf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c02:b0:2ee:7e53:bfae
 with SMTP id 98e67ed59e1d1-2f29166c324mr6176343a91.10.1734134303859; Fri, 13
 Dec 2024 15:58:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Dec 2024 15:58:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213235821.2270353-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.12.17 *** On Tuesday the 17th!!! ***
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

*** LOOK HERE ***

Due to holiday schedules, next week's PUCK will be on Tuesday the 17th (regular
time), not on Wednesday.

There is no scheduled topic (which is code for "SNP, TDX, and guest_memfd").

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
Dec 17th - No topic
Dec 25th - Canceled
Jan 1sth - Canceled

