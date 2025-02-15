Return-Path: <kvm+bounces-38230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C50A36A93
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 02:07:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FBFE189536C
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 01:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A322181732;
	Sat, 15 Feb 2025 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VlQyySMK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB9638DD1
	for <kvm@vger.kernel.org>; Sat, 15 Feb 2025 01:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739581573; cv=none; b=o16YgGRjuNuKTIEwWaEAn2vb6Kbd9oOYSXmNoHK3bmeg5ja4/t1T40Z6WNWP8xmISQB5Gf/+qIH14FmD0rRvlVj/U/TpkUWUvFCvoBSDH76nqPqvgOrU3/zpKHqlPTH/oFs09z59V89LSudAMDH59FHQJrOfqYy4RAJd+bGW8Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739581573; c=relaxed/simple;
	bh=c5mT1kKJrJbBoF8W9ov5zGDfOIg+OOelnEWtDsywTcU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=EEWSM09WFfeWC+PlSAAt+qAiLkjiAXL5eTU7JVgEGDVOqE2vSTYPU0iOrMqXtquv5UMj1eABvRXlfDlNU9XcywEgkN60F20BKtdAf1PK4YiyV/OFDW/yuTehAztuZ3fc4ByrahpdwpNZIgOaTS3W/48oqiXJ+n3x91Zy67JPSlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VlQyySMK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso6372509a91.0
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 17:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739581572; x=1740186372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2wtXUfCTjgHI7TGu3PXE3lApHG/pri/NcZ6lpL1NqU=;
        b=VlQyySMK4r5dAPIKGl8R5vUrc90l5bo22yAxpy43Qql6rnZXRFtIxroe0hL7YZ0pj0
         14NDOMIGpKjCKtyR5gqvq7UOPzghfOYCngOo38E8YbVqxTG8i8oUKfktR4A7yyg/M3T5
         rsMGLyUR6WjCWPXlZRhgvZ7DGI54C007KevIlGQBcm7Q7kdq9S7kRkT8ESdKehbLzR3B
         OJHCcSvkavVH4A0PKQSbm2epOrWqpXCHOl5GM16kqFSiNe1qTA2Ykgekb63c7+gWvAiq
         Kr+OfHb7YgSdSG+hxA1nRUY0L2AZQTburaTB6vd2KtqiVNOKOuK8fPcLQ80B3Yg+slcI
         bGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739581572; x=1740186372;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R2wtXUfCTjgHI7TGu3PXE3lApHG/pri/NcZ6lpL1NqU=;
        b=E4LBguTjrpQ6KfNvsCRnBJ+fNHDumeCoccT+HYzUBOtIvhJOE+rsS10Dp1zYP9IX1M
         GH1b807tZFjDy2+9yeVxfds9WJPP3e/mRMe+1UP61fiqrW7CWJt4b/60HZMo4v1ui4dL
         0F5BHokM293NbW3glSvDFB89VqXWg9nIR8j9M11x/4XSOJDGkyVE31Ycevtnegn3f+Na
         5WngV4dnoJ4OBm5/AxrHzdtyBiPS5yg1rSqZf+SxWuGKpiJqyPrThfzInMwAh+vuc7GK
         SnAitzpL16zirpt6LKCBNtL26JOYWd/l6FF6zDOfypaWcH9Fe5996aQf2mmFhWn8Tf9L
         DYBg==
X-Gm-Message-State: AOJu0Yz94yeZ5qOHHcflAxHK1o0XDyXD1ANFRBwfSB4W+Eg4YY+MsKaZ
	8iXfXTTkpS592qg5mniNWCa95Kzz23ovwjLHWFSAcJUjZf5KeigT9hYN7+Zn9iuNE1ICUKV4Wkn
	vOA==
X-Google-Smtp-Source: AGHT+IEYCzMbuX7xHl2Nvmsne3PdbtFPA0TlA2NZIveDqibzeV+LpQ2lV6/nn0zdhPIjP5m+GvpznOHJPUU=
X-Received: from pjbtd3.prod.google.com ([2002:a17:90b:5443:b0:2f4:4222:ebba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:39cc:b0:2fa:229f:d03a
 with SMTP id 98e67ed59e1d1-2fc4104056emr1548474a91.26.1739581571648; Fri, 14
 Feb 2025 17:06:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Feb 2025 17:06:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250215010609.1199982-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Fix and a cleanup for async #PFs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix an issue with async #PF and protected guests (which really shouldn't be
using PV asyng #PFs), and clean up naming related to SEND_ALWAYS.

Sean Christopherson (2):
  KVM: x86: Don't inject PV async #PF if SEND_ALWAYS=0 and guest state
    is protected
  KVM: x86: Rename and invert async #PF's send_user_only flag to
    send_always

 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/x86.c              | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.601.g30ceb7b040-goog


