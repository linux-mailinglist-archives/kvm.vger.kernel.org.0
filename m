Return-Path: <kvm+bounces-17897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D44198CB882
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 03:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 747F31F21AF4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E0C21C680;
	Wed, 22 May 2024 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Emplf75H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA2018C3D
	for <kvm@vger.kernel.org>; Wed, 22 May 2024 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716341812; cv=none; b=E4HCQ3+7I8qoh5qtGCovUGgYOmgbvN4L7f4WV5U94E8KTbOOQXXfkwa+UHeeJzxsmFmWbZzbxCsGJjlVk47DHG/tWNXaVDXVi6+OS4EUMunCSyBc0eAL/waukcRCJhEYZeoPoM24f4nqXAenwwgne459spdM4K4Xdky4RjVKCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716341812; c=relaxed/simple;
	bh=uOp1wN2DfhSBAyIiZVfxcpEE4nMrRqzLGODorRKlTxw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=G/otVcomTOEmLOctqiy941woOgwmwzruvjZuO5MLQYHtp1OeOlgdjUOcg1IpHoWr6lKWKa2r/3UHErA9bqireFnBYGgzXcU9uCpuJypU0JeJtidMXriD1iGPcJSQQoyaac0j8+Mjh5Nm7UPnR1U/WIN22HhnD41Bpl5Qswy/Wm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Emplf75H; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f449ea6804so14108784b3a.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 18:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716341810; x=1716946610; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E5S3zXzDNy7OaqRCsEecoffZHoJSYB0z+yL5rqDfD/8=;
        b=Emplf75HVOoTBKGz1WFCvLiYJ3vc9U0HDKIMxfvjyH/3Zcg3xdLIE3L3hAhjQfhzDt
         NfzXEqGUOWUz9fd7VfgCWxYCpN/LrGyRtJH8cMRyIWn4m2D/lZfWXPDVVwa4Ji1ADWYT
         B1Z7yBwbI8nWCYftgEh+nPUBwxanzRWC5ZQNYwCXdACor6jAQVQkeeLrXD3WVLgTJmv+
         9fsgVnzVd3FNP0R0QAWARJzdKohfe2roTpMa4qlfQsujhA/T9FeZ8KQfZJi6+bpxSCoq
         FUIujhrE2p0M7g4JKuRA97eK/Ad0fi1x3ub0qvgaUks4idEvxBiHZo7EMUhuHhrHe6m8
         8y3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716341810; x=1716946610;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E5S3zXzDNy7OaqRCsEecoffZHoJSYB0z+yL5rqDfD/8=;
        b=On/59tQ/p8zwkzhPbMGHsnLmNsdznzoINKWh+gQu1fPFX7enMnYzJ4Sdp+coyda8jR
         /6rXeIds842X58qePDA4Nykkc5IxpkDPlK0GrO88KZ9aUBaCQW/WIkRi2VUd36U7EwZm
         fS6uDYXVYqFscggPFJGUXqBS1pj3Kk++XQd5dzGsZbejQmJ6dKkwBcSUKuUjwHfYSgs2
         X0ofALK+MMFRF6VwUl+rw8Xxh6MFnd6IN7LGs0DyPy7B7V/uFzM4g6JyktWv8GYoaNeE
         iu9J3L60dZGWAAnL8v6qddnEmRJif7zzvNJiHVc3wXosbQcVlFW6HxNQn9Z8h6Xl/DuY
         iJMQ==
X-Gm-Message-State: AOJu0YxCUiJXwTzj3OND+uAJL0rrZoap07EebFL3tId7iqnkQqLoBrLM
	nGKVfo16o/S9LtNWoR4FASRR4femUsGQCAMAyQs+UL4K7iXyKiecpINxPHUW2XTr+sEAffXZ+5G
	7iQ==
X-Google-Smtp-Source: AGHT+IHSwJQAi1yjFTuHmA1rC8UBSwdnDUj06ie59IvdpRhZGk46IaXZJ7WlmuD8kWJc3+ceeAiUtVHuyF4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e8f:b0:6f3:f447:57e1 with SMTP id
 d2e1a72fcca58-6f6d6002b65mr9428b3a.1.1716341810176; Tue, 21 May 2024 18:36:50
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 21 May 2024 18:36:46 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240522013647.1671968-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.05.22 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is canceled for tomorrow, as I will be offline (tomorrow until Tuesday,
in case anyone cares).  Though if y'all want to meet without me, definitely
feel free to do so.

Future Schedule:
May  29th - No Topic
June  5th - No Topic
June 12th - PV Scheduling

