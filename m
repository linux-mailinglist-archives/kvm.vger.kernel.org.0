Return-Path: <kvm+bounces-11214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5453787435E
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 00:02:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 127CD1F24F8C
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 23:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E601C686;
	Wed,  6 Mar 2024 23:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MXuQJHog"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3913F1C298
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 23:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766118; cv=none; b=cw52nWOQt9sf6wN5Z4kpwJ8SUouqzxPwZ5wGnf7PuzZdnGEkbtv9c9BT0MyqEM0wxpjW473gy6QfJI9JuIGSexFJBbXw7x2A3ZgnpelHthUbrR784VwFUcHUL/UT3WybSJz1+XBWshMb0FkRS6fO4ocFV28+sCtWM36oK21cxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766118; c=relaxed/simple;
	bh=YsKdl+0Wym4Yame2iWLM3lHzd55UEFZzczecWjIIht4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aTKzjF5V5zv7pMofwHXl+jmX1nBgEHm6Lq4JSO4bz8rrsU3TqNuuwD4a6qScioFdEjLE+f/QCJkq/nK3W3Rg8dswvAMqPHdlUzof7TgdupNq1olf1uiEoCIfyVibgSG5cqbzuMl3ZZddFD0EIsAg+Kqe7+0jBfqaoBrXQi5Ckas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MXuQJHog; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dcbfe1a42a4so374663276.2
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 15:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709766116; x=1710370916; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q8mMaKcx9TxDjR6z7vIM+dI2D9/0+rDx06ATc2YLk10=;
        b=MXuQJHog72s7bi+K4b301aAw10QhL/obRygdid5tItzN0Fu8+NCVA+fT5Ov8CBzlEw
         93p/zbkBX7jys8LZw9cymT0ziF2++j1jjYMR3GOLbS9xboup8wgFT3ZDGer33s26E212
         18HDdkwsN2YO7olkeEjunuaG4TKUIZiSQ6Aov85o3WYAQKKl1NLw4v5jLVgq16kQNUoH
         aRIm6YZtUIJTserKiJeFgEqr0muDNFoGhauoasQSjWDIeXeZ8LkLeSH1PgrWflZ9bmzI
         7FW6Hx0LJc923O92QqSEcyYa9/xtE0eyp/yCr582PTUiGToBoAE4w6/BAXKhVS2rAGVe
         IFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709766116; x=1710370916;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q8mMaKcx9TxDjR6z7vIM+dI2D9/0+rDx06ATc2YLk10=;
        b=akDogE9urTEI/GdkIm+vxyhvVYrmPmONL55aoIc0qN7HRL+sOx37y7Fwut1Lb9LYdm
         zH1dcfnLLymZIw4sl+tu9QWZlXjklTi4A3W+vsTqNgeCXd41EDJgD34mS69TPlwBQUGe
         I9CKXeUEHsWpXknwvYy8ZLUEH5i9ul1lIIBScXaV93swqjkDiK63ZdEKdFWhVeOdAPWc
         dTjZXIvf9KpQUEO9uZWkO5rzyd7PnsEnSV/rSVmoFTxADZg820eWXhAaKEpPu6ebPon4
         vrynuND1SfzX4efHArwH4ErxudzGz1sB4w/iIpHFPh7YxNYIJPPX3U/HpnsO5LUwgg1w
         2i4A==
X-Gm-Message-State: AOJu0YzmDSM89ucIL1uh5I+edTrtoBIucNX3vAWc1gbgrSTh0I66U1dx
	+K9GKKEKFuZW0+yiACkUj+XUOxZrgG3RSjKbLWchun89lC02pgHa/c1lyT7fn+G4wf/DoabrCgn
	P/g==
X-Google-Smtp-Source: AGHT+IFPs+jIIDzBe8STRFvo6i+99iEndCxxFA6ThNv+M0c0Ih9ZOU/Cm/gKJgtI4WmStxQeQwtYYd4/lpI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc2:3441:897f with SMTP id
 w4-20020a056902100400b00dc23441897fmr3989460ybt.6.1709766116259; Wed, 06 Mar
 2024 15:01:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Mar 2024 15:01:49 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240306230153.786365-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/4] x86/pmu: PEBS fixes and new testcases
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, 
	Zhenyu Wang <zhenyuw@linux.intel.com>, Zhang Xiong <xiong.y.zhang@intel.com>, 
	Lv Zhiyuan <zhiyuan.lv@intel.com>, Dapeng Mi <dapeng1.mi@intel.com>
Content-Type: text/plain; charset="UTF-8"

One bug fix where pmu_pebs attempts to enable PEBS for fixed counter on
CPUs without Extended PEBS, and two new testcases to verify adaptive
PEBS functionality.

The new testcases are intended both to demonstrate that adaptive PEBS
virtualization is currently broken, and to serve as a gatekeeper for
re-enabling adapative PEBS in the future.

https://lore.kernel.org/all/ZeepGjHCeSfadANM@google.com

Sean Christopherson (4):
  x86/pmu: Enable PEBS on fixed counters iff baseline PEBS is support
  x86/pmu: Iterate over adaptive PEBS flag combinations
  x86/pmu: Test adaptive PEBS without any adaptive counters
  x86/pmu: Add a PEBS test to verify the host LBRs aren't leaked to the
    guest

 lib/x86/pmu.h  |   6 ++-
 x86/pmu_pebs.c | 109 +++++++++++++++++++++++++++----------------------
 2 files changed, 66 insertions(+), 49 deletions(-)


base-commit: 55dd01b4f066577b49f03fb7146723c4a65822c4
-- 
2.44.0.278.ge034bb2e1d-goog


