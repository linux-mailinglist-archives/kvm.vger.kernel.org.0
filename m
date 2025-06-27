Return-Path: <kvm+bounces-51008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0E5AEBC06
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F1847A52F8
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468AE2EA735;
	Fri, 27 Jun 2025 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S7wAneB6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E1F12E9739
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751038473; cv=none; b=FEZaacCjUrlUPZPQDgBNIyKXKJNkwKCSfnlNodMLEkFZebhPjEI8yHL4vfy/nbSlzB/A6t/9mEFvUq2u0R2MWCO6CCzuIs5cTklJp0qcR2YnNqTvjSxgXJtXlmyH4dOtCcjJPvGkMUNX5jC01F2iCeUppsjVHM4QusTsGz32UDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751038473; c=relaxed/simple;
	bh=MnFCJYWPiWgm63x8SQPSotO2DIBVDiddlKUWAl9CYJs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=a6bZU9KFalEIhu9lRg3JtGwO6yJmwW44V2K/dZk1Zmj2509GjrTDVgwtXYy+q0hGFyYoz3SP6PkzsIabghLzgePbiKqbvL5EsBJB/nMpSqxOebHUacarinHW8NFDnhTImfdgnUoqwXqNCsfXyaxeHtEVrE9Pk5i4kGTO/3+2Gxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S7wAneB6; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31df10dfadso1495883a12.0
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 08:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751038471; x=1751643271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MnFCJYWPiWgm63x8SQPSotO2DIBVDiddlKUWAl9CYJs=;
        b=S7wAneB67aSiA33vZ/q3+E3kSMUZO5xqtIWfk7XWnViam87VDqd8YSiaDiBt2BFfZM
         nh+UMdbM0FLdjmcfsjrVO7fIoeyf8Z8Nnp/NBaVo5bf29hXM5/vaBlx4Qh3J2z5tO4Lh
         a+AUzLBI26Hzg+G3VC6wqg3CARHA/0IVQAN3YpzDI1XcAmiEahKvFL5F6NI+EktaYJrv
         vQ4sIGvX0N8yXJ6VFEv5i055ewxNkSkv7fpRTbz6Dc3ElWkvPv/XVZu1TgJ/nF2NvQYD
         1B1LIzTLyUF35TB+0efnhqA8EIK9m+n+eFXv6G0O8+wGMx7nxDS7yNs996VxTqDxVYrD
         CtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751038471; x=1751643271;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnFCJYWPiWgm63x8SQPSotO2DIBVDiddlKUWAl9CYJs=;
        b=OINF5XTHoJ9HBhdKxJbdqnzdosSSl5Y1EHEaWwWCsm61gqnoAO0H3GYEY5SMREnaiE
         259gaZ3dejPKNdAmfX3Hs5ILFVao9PnwoEf38SCZP4mSqCuaJa+7VhaiJ+KEgPJ8YDCe
         GKeFfK/z/gwuMm1fnSAAlhGApjoyQkSZctmXmfo6RRUiK/+H1EjnUuPbKLqCldcSKCsq
         4gJW+Hsl5rsY/3xW1jY6+T9zPMxdfVS1KCQuilbN4zaJfnsqS1KiN91KvBuTOz5WgBXr
         5FP8SC0wyHNqCJMRWjZEs6Oljj+hyTAfm/bBuN41lwd/zGiX1CHbug5RBiNXegbuXpx2
         BKQg==
X-Gm-Message-State: AOJu0YwRUiDg21/OA6RXrnb4+FtEa4VBSvtBeDBii/K3oZEHBpRRfe2a
	5PrkwMuiHaAEFTycqMDmru+kuiXPs3Z1pekR0JuFWHJwkdGoeKkzrJ+lzZNztaJzjEqEh8oA8rp
	67pDJzQ==
X-Google-Smtp-Source: AGHT+IE9LzpJAX7fr5BJQi1hbx4HW7dQioDb081J0nFb+NIJ5ioCCEnXj8Ym+GDbAh8T57Lvp6MtBrGL5LQ=
X-Received: from pjbpx4.prod.google.com ([2002:a17:90b:2704:b0:314:3153:5650])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5285:b0:311:e8cc:425e
 with SMTP id 98e67ed59e1d1-318c93054fbmr4721038a91.31.1751038471073; Fri, 27
 Jun 2025 08:34:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 27 Jun 2025 08:34:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250627153427.874470-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.07.02 - CANCELED!
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for July 2nd as I (and Paolo) will be offline.

