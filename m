Return-Path: <kvm+bounces-29561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B540F9ACEB3
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:26:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A731F210D5
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24861C3045;
	Wed, 23 Oct 2024 15:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rcs0hzTw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774B61C1746
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729697203; cv=none; b=uoAv1PFGFnnXjZLsRrM7zC+hIk1jUnViTZMuD1zYPt8ePodP498YOFRCuWB1g3l/g4g1j1A2ruiFXUtS3c10V8L2AtN3kCBWNpr/zfvfEXnZStymtPPDnGLUpWP2cRqdB1FCv2qXvziVlPIklY2q+OvZAPIoAnENVYNyYJLr+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729697203; c=relaxed/simple;
	bh=hHfBZftXhNOJ3HtBKDzEps5lRrh8yzrWQIEEayw2NdQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZpQbgMqVJBxxzq3FZ4EsZSrF3i/j7KsVLg6D/KnAlXnuExeRlt7Fj5/7L/+sN5X70uzNKQI+LIwW+9KJZhpCXK5TezkWoMNnSHWIBxJdAibByZy/fd91xgoa6CQLhOYAOcfjb6i2izFvbF4BVSCGI6elxr+V7Jc3IqWeZINZ+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rcs0hzTw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e29205f6063so11045014276.1
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729697201; x=1730302001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LgyTGB3pqM8nd2tlaCQUWlInWbsb/ECPLI+TMKap3wE=;
        b=Rcs0hzTwmnwyurDbCMDaG1zK45Qrok/2MqdspTEH6c14pTDapHLfeUwqiWeCqKhE6D
         ijwNiKDGSAEYCZctaB2CaCEcJKZV5pYlk9ny77YXyi7SzKEhBkG9IApsoPtCf9cR1+vp
         VkGA9NtTsNgxziexKU0Wxm66Nuy4xvNdrR2Jr1NmYKjUWXXW21/bGrg5mfZ9lTVevmMs
         bfMhYSkL+nHmD103koZa0n+G0LbJQQSq9dP7VWmlCa6ZtOwpvH8sfcIO8IVmVTztbevz
         NUKA5XfJDa3ltfhr50dC93sGSYI9k4+K5mFRDIoIp+bGSHEnMHaj2HIENqYZZzxLlzhc
         jnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729697201; x=1730302001;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgyTGB3pqM8nd2tlaCQUWlInWbsb/ECPLI+TMKap3wE=;
        b=h/EOMgXJC7WS75pDOTz0b6NhtdnIKeuFmRD6HqQd28LzBt5NXuh7/oePsViXjt5VLQ
         qrpZyk/uAYI9L6ocGztf8sv0kjXlNidyvvLVjK8me84pfQ8QYf1WPxKj3tC/eQlTGhPe
         +dYsOgSDavkHyafwJP6CWHrOXNDjrNBoj6vEJTFszLv0FcsXSvV0iJEtHRxv7CQgp54B
         vHckRCBiiDKh+5jRTo0JEts52NCLRJYa0osYh/cIjtgBJ0gtv7gMtAWx4wEkKhzCgVLm
         ZA8KKQVHNcVN5rol2lHV61aprpFNOz2U1FaJTn0JGt9emXz05jV9JidJTZ1LRsK7+nQL
         dBxg==
X-Forwarded-Encrypted: i=1; AJvYcCXrdUO4MRoDa3QyjMK7pvDedud4d5lrwOaDT6/LXe7jkCPYfKuqAmD0q4jVubiR0hDFoUU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqWib1jGaD18zoMpxvingj0AC0vojUhP+GScntS2AZfBwK577b
	6TyrDtqMzPh7QcE9giuN9hqFZ3iwP4o3QdXnbcweP57eL+BF3PjNOPuVTVjCHbZwvg0Heuh9KEF
	qFNEQng==
X-Google-Smtp-Source: AGHT+IGZLylUFfRaeoUChkh5zta51HqScos57+PeLEawa/Zj6Vb0Z2er1q5qfJlHjZXBZG3OR/irola46j3M
X-Received: from rananta-linux.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fac1])
 (user=rananta job=sendgmr) by 2002:a25:b21f:0:b0:e2b:d28f:bf28 with SMTP id
 3f1490d57ef6-e2e3a5fa7a4mr5506276.2.1729697201237; Wed, 23 Oct 2024 08:26:41
 -0700 (PDT)
Date: Wed, 23 Oct 2024 15:26:34 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.105.g07ac214952-goog
Message-ID: <20241023152638.3317648-1-rananta@google.com>
Subject: [kvm-unit-tests PATCH v2 0/4] Fix arm64 clang errors on fpu tests
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

The series tries to address these issues.

v2:
 - Fix build errors for newer clang versions that push 'q' registers out
   of scope under '-mgeneral-regs-only'. (Andrew)

v1:
https://lore.kernel.org/all/20241022004710.1888067-1-rananta@google.com/

- Raghavendra

Raghavendra Rao Ananta (4):
  arm: Fix clang error in sve_vl()
  arm: fpu: Convert 'q' registers to 'v' to satisfy clang
  arm: fpu: Add '.arch_extension fp' to fpu macros
  arm: fpu: Fix the input/output args for inline asm in fpu.c

 arm/fpu.c                 | 52 ++++++++++++++++++++-------------------
 lib/arm64/asm/processor.h |  2 +-
 2 files changed, 28 insertions(+), 26 deletions(-)


base-commit: f246b16099478a916eab37b9bd1eb07c743a67d5
-- 
2.47.0.105.g07ac214952-goog


