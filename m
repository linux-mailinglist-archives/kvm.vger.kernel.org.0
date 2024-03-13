Return-Path: <kvm+bounces-11705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B535787A028
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 01:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F771B21F1D
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 00:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A39A8C1E;
	Wed, 13 Mar 2024 00:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lU9d3vWM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5B24A07
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 00:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710289936; cv=none; b=laMSciwkWeVqvkYIox+HF4E8h2GlrARfjHzB0k4PHxqO7X9DjAPuzCDXfnlxT3dGPwrnXpWP2ATfGh6Dn27NW5exquMo78Hggs9MmclPPimccebDYpO0WZ23ma/A5oL29lmx3Sl0s5QVzWZPV1ytrLRctDNbk8ygaP9G8b7FoXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710289936; c=relaxed/simple;
	bh=u9CTPjsq7/vsKqJoalkpGsFt9WPBscByacnRNmTslSY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=mg1VW9KwPm1u7DTiJkMq6G1g8ABDuKeLKvrDIaxdQsKPJ8koa6n2vnmGDsFeZkywq74k+azRkjIdVaKR5ne9kXEeTCL5A2ImUZ+DRAEmGtEy1IFkkZYSHww9rVMRgl2PF2Ja9+C8aU2Bb9lQZq1uW0dx56cv3xXPE4ez50yhp+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lU9d3vWM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0151f194so93027217b3.1
        for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 17:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710289934; x=1710894734; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uyB5xraDGGpdDaspyqXyiFg7lY29NnMJOMciVJDKLWc=;
        b=lU9d3vWMu30Plx8dvpQf255XkL0VTIzsf+P9fkqveArUPgAndz5CzuZ6/VJO1Ux3N9
         937oYh98dTJ71T6ZV0/o78x5hi9W4eaTVVD//hVdMERPXLCjYOqAMRDbXwFxSKDXBm0U
         2YRK3f6jdULvDmoWCnZaE1p8RmETRxQxGC0NzpcZFdEnj6wtVHrSMIvWDlVdhmCk/KKx
         FVGEu4rDcX8lbPhZOzClG8GQHxe6Ectle7QtdknN0O6q6AmAmSSRRGZSRswTvYJl+xw3
         MEiEUqanlXDO1/x9sdhSTXWWvbC/YI4mDirwMvnda6SnBBGIJ3XG5pz5xrOLmGsheU4B
         I63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710289934; x=1710894734;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyB5xraDGGpdDaspyqXyiFg7lY29NnMJOMciVJDKLWc=;
        b=I+8BD31B1I2KyHA02EuhXq738xkQKJ0f0knBueqSk/wa+vUcRblg3EbEgkggRwYpq4
         AFIwizFdyeHYhRAwCdFO3Q/HAV6kxkeR4+v6MICOE328gCjdiT9u5/Tex7asecQ4ZBt4
         c1f5bTf3VDqDZjm/Ik/9Crue1JGTlO37zpTVfUe1MjLmYlyJnlPTpRBaY7zJjDv2CDdF
         cDuc7dzYA0lGg0uZ4iNhyvM2l8kQ4763qshmYiVNMaIHnBKosN7nXdW33npiQMeFAP9e
         m/VJ441kqbMr+qValnjLkT9GL81xWnyTYV19m2bwx9jWnKAxvB/xC/CcXS/lLpscxRkT
         FB0A==
X-Gm-Message-State: AOJu0YyooE1ELjjG6/B9SbdfU46QyWr7ybi/4YvuxkvXpDCvzVqig37U
	AuBbUgmCIotLOauQ3Flrf3yHzxYjeIexfR1m8ia0J18Oyei9xiw9mqkeIwle6G/NPQQiKo5AYm4
	6Gg==
X-Google-Smtp-Source: AGHT+IGQMrSGFtlzvD+P0ZXR5qZIZHhpPSP27vTvkI04ENQ/BGgj67fnWXFVfmkhrBmlUDMFnBI7Po6e6G0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:24e:b0:60a:16ae:38ee with SMTP id
 ba14-20020a05690c024e00b0060a16ae38eemr294090ywb.3.1710289934449; Tue, 12 Mar
 2024 17:32:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Mar 2024 17:32:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240313003211.1900117-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.

Note, the US just did its Daylight Savings thing, so the local time might be
different for you this week.

Note #2, PUCK is canceled for the next two weeks as I'll be offline.

Future Schedule:
March    20th - CANCELED
March    27th - CANCELED

