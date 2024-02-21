Return-Path: <kvm+bounces-9236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 898FE85CDB6
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 03:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C24E91C229CA
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 02:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49BD79C6;
	Wed, 21 Feb 2024 02:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iW7PQA7D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568B26FBF
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 02:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481211; cv=none; b=dki6Txu03W5XFZmwyr43lypm/w3jZ9OZEAFjjmAYXFJvhEcnCbXUghOZQUSz3XIovp/CYzDadwjr/U7irtxF6AZu03gewijIU83E+QIeMCTNxsnVpD8QPCCngtIlCKbB+tzIO2bStoml9JtRtuHG1rBxTcF5aYNZl9n81PTQwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481211; c=relaxed/simple;
	bh=nQQwbZd7w+TdXbxPmBTMKI41ZFTqLXxkk1KsZxJEf3w=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TJgvRe82CNIoBiA34s2+tyPis7zN6QkhaQlvv/FV8Ooskv0+V2aHRWOgObQCqNnu0HgyDSeO46pze9+GMaVyqh3Qo74x2fukb5uYObOiVynPOq9dl+fyK9a+5Ny+n6gI91KoWrcTdDBEVSqj7E9sghNICrZmVLN94cSJqne5zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iW7PQA7D; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e45a0b788bso2475095b3a.3
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 18:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708481209; x=1709086009; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wgstNCUbrnmqEZYy0cHgu3Xis6IzzivxnlRx+bQ7zy4=;
        b=iW7PQA7DUP9hcOvkKwD5IM17ojRKXhaMDxDp6/AulZQWXP2aYlYbESamXqRumbPzmK
         fMarYsVzzRA9QSpjD/6Z44goZul2i2Mb4gQ52DpF2txhWQ23zMWoYjK480ssCxEOg7rG
         xp7z6KJQB7m0jYtNdGF5+Yi5bVZTjGEuAtHAUkOhcbJMsEeJeHhXdbCnG7gciy0chuLo
         0ZSzaBAPlqisURFPBjeQ2qYc5u4z189qaC3zQdfIfUbBEQxI1VwRebdEP2vc5GxKEHn/
         dsQt5lTfiDpTGTQdeXtxbRXgG+6Ie3sIlU/+pj/Coj2bnjMdJS7rusmQdaZCN7cAihyC
         /uDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708481209; x=1709086009;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wgstNCUbrnmqEZYy0cHgu3Xis6IzzivxnlRx+bQ7zy4=;
        b=peiX+AOTgDo7TuCwfcDx5L/z/rATnKs4u2DBq8HXlRgg1b8CLVnRNkdqTpc3Yzya+A
         I8Q7u+r621+EHGx9Qze/+r4TwjfVTvcNTR9HOYAopKzyGWSwGG8Jh/M3OvaXcZ4NjBRP
         /znxB5kkBkJpYiqtrhXnquEc/Hs23U9E1oUpMOhLQiqE3RCgQzonf8KadzSGTAHVe4mT
         SwFncCS3fA2PVyhXzMOKxY56MnNFUscT7YMU5RpFORRiDcqducJhc+2vu82y82iPHknX
         OAjDXpGRq3iL0p4/i2XW847v0NoAGdlGAgLUd3DwU1NEHyNOlRCKFAKaNg+Y523zkT8T
         KqRg==
X-Gm-Message-State: AOJu0YzkBVCmdxE+LTe4xr8PZHDtAqlOGFRiiQqvl6iTV27CeNp5NoSN
	bofsEyNHuCpbsVLb4SQiubxvo43xvnh+41/prPje2QNZyjLZ+8HtrCXbntnrXodlhMjXmtADugx
	7Jw==
X-Google-Smtp-Source: AGHT+IEtEI8jkWe5k2HTwu30Yt6febdEU1pRxRzkRV3CgSwMjJNDBDv4dG/0i9O7XC/gur74m3DcbtKKxxM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1248:b0:6e1:142b:6d49 with SMTP id
 u8-20020a056a00124800b006e1142b6d49mr250313pfi.2.1708481209568; Tue, 20 Feb
 2024 18:06:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 20 Feb 2024 18:06:46 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240221020646.2540408-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.02.21 - No topic
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

No topic for tomorrow, but I'll be online.

Early warning, PUCK is canceled for _next_ week as I'll be unavailable, and for
the last two weeks of March.

Future Schedule:
February 28th - CANCELED
March     6th - Available
March    13th - Available
March    20th - CANCELED
March    27th - CANCELED

