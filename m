Return-Path: <kvm+bounces-29318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A649A9518
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 02:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CF29B20D31
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 00:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98FB84D34;
	Tue, 22 Oct 2024 00:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQpz3Jqs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340961CFB6
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729558038; cv=none; b=GbAunZwB9vB1dA0oTV/pg9xENriMt+XiqPldlAESFkZw6cUG8s8sA1mJUAFkqT3M26btmtfYUp/rNZIFHDjExtVNcKQG1rg5TqgmV4cdehCJtwldkaBp01mJhINSK38rqPJwpe0S5zD/Go6cC7KXU+beSMXTKbHx1J+ZUJ5ACA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729558038; c=relaxed/simple;
	bh=oddlXzPrbA0KUDkQ/VqCUaaziMk5kQcLpmj6TYb3IOE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XYLkPax4iz2RCf2rNa1lpRVuHopQQKFsRrIhaWHCTb3HfKDvwf5Pvzq3gULwi3FIiHJ3tjvl+HojpCutztouTMNnKdxNcEJqljSwB0UzqWa3ZIdkLNMk8cZRTuRMjInJFy+O5mCxSSBaWphbsKnAXsPw95BowapTw2R/0iYd840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQpz3Jqs; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d9e31e66eeso102072887b3.1
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 17:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729558036; x=1730162836; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eKlqNI7codORggOmuakZnfoKtsVxCBFbd76VCr1Cfs4=;
        b=iQpz3Jqs8psMw8tQ7/0RsHrYD8xoOnJKu46atMh7muMcmYU2Wqgh8bByzG8/fk3n+M
         bXLhbzZc0fPBYZPNxeZwHxaFwHD3LiESzu+MUxXJIWwgi8VQMvo4fvRRJw6uP1foB9zZ
         Xe6DI9OmDujubgy4/JQ4GFnUiRVjnqnPBJd9KD2xLvWkEfjVy6q6a+kjyN/5T4Je1ysO
         LOyZVpwdy/mB+veyeqZ1Y2agDMgmGYdpRMA5vyi4WR1mBt90H2INpcfbBt1DbJmfVvvP
         9nYWK1mZjtZLcYWbKXA6pkzxr1scB7WyavXhsddoxcOQoKdhUNBZWVxsALjMg52OBGVX
         OXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729558036; x=1730162836;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eKlqNI7codORggOmuakZnfoKtsVxCBFbd76VCr1Cfs4=;
        b=FSVL0TsH/tNKQyTcwcJE15QogBhae3ewIsXqR6lZWT6UbmlAH1AnJgw7+kBLPlTSv3
         BblEhaT9d6BiZCLrASTz16Nb3QUsHn5ATyHqQcVE146PRbwoM7F4hpWqZPH8MpYRScqE
         PPhBmYnm77i710zTI3F8LfR0Gs7and+C/4Tpnrtd72fVnG6vZggGH+V9q/blBvE88PEs
         PYK+YPu1f9IHdWOYx2cB6pk+g3fBOqN2OI0exASkgUVK3g0NtCjjthS31DwDBCIRJVB3
         iFUAjUZ6hQ15xq2Mqvg3ylCv+DxhIEBOqy3ytaoZhteyD/oVPHmvfL221Ag82XY4xhcN
         Ey1A==
X-Forwarded-Encrypted: i=1; AJvYcCVeLMOh0GUCi5YdoVFr2KJUuwU3bSw1SuBgQ6enZsYrr5Jrn0G3kZLTpVqBjYwj3auWRec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx00MFoWuw8Bm0l6pTSLXdgCgUCaVswzXs2X9iqo7vXkMGS3VRs
	hjn1oAnkF56E1WKVv8Bv8MQTWIAslbytk5XAxqwdcZd0cgEPMwchLTAp0BuAARmaclx0o4K+6nw
	HzGg9EA==
X-Google-Smtp-Source: AGHT+IHOQrd1jIWY9X7tdhL/R0YUgEB2OIskxOwSIWT5phgxs/Ny0301xMZAECFC/6CJbI+nE0pfGWzv7OGK
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a05:690c:25c7:b0:6e3:eab:18b1 with SMTP id
 00721157ae682-6e5bf622fdfmr2750087b3.1.1729558036138; Mon, 21 Oct 2024
 17:47:16 -0700 (PDT)
Date: Tue, 22 Oct 2024 00:47:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241022004710.1888067-1-rananta@google.com>
Subject: [kvm-unit-tests PATCH 0/3] Fix arm64 clang errors on fpu tests
From: Raghavendra Rao Ananta <rananta@google.com>
To: Subhasish Ghosh <subhasish.ghosh@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Anata <rananta@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When compiled with clang for arm64, some build errors were observed
along the fpu code. Moreover, data aborts were seen while running
the arm/fpu test due to misconfigured input/output args in the inline
assembly.

The series tries to addresses these issues.

- Raghavendra

Raghavendra Rao Ananta (3):
  arm: Fix clang error in sve_vl()
  arm: fpu: Convert 'q' registers to 'v' to satisfy clang
  arm: fpu: Fix the input/output args for inline asm in fpu.c

 arm/fpu.c                 | 46 +++++++++++++++++++--------------------
 lib/arm64/asm/processor.h |  2 +-
 2 files changed, 24 insertions(+), 24 deletions(-)


base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
-- 
2.47.0.105.g07ac214952-goog


