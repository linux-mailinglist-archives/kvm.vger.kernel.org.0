Return-Path: <kvm+bounces-52788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C06B094EE
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 21:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665AF1C235FA
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 19:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69842FCE01;
	Thu, 17 Jul 2025 19:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNc9ho1o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A8288CAC;
	Thu, 17 Jul 2025 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752780267; cv=none; b=q6jjdp2rA5g1y2JbGX/NdetEzeVm7HPn/VUnwRrX6x4IJjmOQGwLVQsMjGOXGkro/SQ7mDSRzte/PfE43SxQHTcdypdCkc470s4gBOQBhHJUIV7tfSPbyckhlBV2v0dmnwlvldro4w11FHHk81TOQhj3Y62x5AK85zgfqB6TpBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752780267; c=relaxed/simple;
	bh=s3Flhr0BuBcpKLDgy6zu1V7gr70BSx3MXuiKIGmB/wI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X6seYAHBbl9FRBWkqdxuw3DBrJhIonbgoGLPAkTzFV4CLqgJ0JiPIh/ry48iCMFEL2JYbDhUX547/4DLgcwSBbKOZUCPjhRCRbkIQCn0i2LqpcfGPhla3uglArBJkzFKsNCQbR5b0fF1Q2+UCDZia4euetrXyJDUMmeKLOuRbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNc9ho1o; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-234d3261631so11270055ad.1;
        Thu, 17 Jul 2025 12:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752780265; x=1753385065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jAB/ZCf98iFHgBEwtq74/4Ip0sOWZnnRFUZVjHATtFg=;
        b=XNc9ho1oFYvndqnjsxjdm0D5W6LLvnVdA5hhPA83T37Jucrav7B3tL+jPFGZuRLjwq
         gAVAvnN594OjeZOcHqWT9l8u4S9lLcEAZsjBUunmU6muto9BWWHf7Lnpl/fdqYP+VpmQ
         J8MC15AmAxUcDUIYyfd45m3cHFZeJyyd67bM3xH9+4aJoctPyjAQTouYDqrzrIFLCUPi
         qIcxfsWGhVkZUfs4SN60JNQz8k1q8q6qjlwzoAiwDcYhUw5pSrLXhmwB1Wu5Cxw4czrh
         T0IlDC+iDOYKKkFQhZBz87nZoZ4UAhZ7ogefRK4JWacOXvEtj2asbebilixLdHAUbwzk
         zhtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752780265; x=1753385065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jAB/ZCf98iFHgBEwtq74/4Ip0sOWZnnRFUZVjHATtFg=;
        b=PoXXRL91wRgGzQahhbdw8yZIvTW0aArjOJbo8xent1B8kFg4No4GTHA8uyOaACAsEN
         zhpKrTSFY3b0B2umJu0tOwh3LcnAcwALCFV6zq3p5UaWiCQ1MprX0l1os5J8tQW1wmIv
         uWK1hmIf/uPGS1K7+gKbwCocK+xMWRrVvpwqErghnYwOhejJyhoYYYwUqdK/CKlWXk6x
         bBAR9jHFcRjxVhoMGLtS8pDIJii3yE1hIiG9SUFViszEO/6DhuNVMYY/SxpKDhNmCBDi
         shqGjJYQ+vPUEZTk0rk0vXdojpuEU/4nnH9JXSF7Vju4IqmVcmZkeAbEhud10avXHfFS
         +ZQA==
X-Forwarded-Encrypted: i=1; AJvYcCXmTm35lSa06fovuuNc4bPp7s13Di2YQTarut42sXDtTHuU1lkWE8HCUAFOt7E4Js0SJuc=@vger.kernel.org, AJvYcCXotlQ3tykV24z7UcSdg2aH93RhCpDpJDfblpWFaNhaG9G5XDmWJNAAkx4th2KfxYoyYCnpH/MtiEEFRmIh@vger.kernel.org
X-Gm-Message-State: AOJu0YyXRTU7/kXNdT2LRBhy09M028WCamYePexVdKDQTf9Rv+aGTRT+
	yVketoJ4HMyZ9FcCD+Exgxe8aKMQ7MmH3RmjQ/cML3fSwP06P7gmS8uTyxC/Ww==
X-Gm-Gg: ASbGncuH3d0Kcmb7ssXU4w2QSaPmF7HzgUHRECSN8uOxmlW2fwMm1AjNgoN+J2tgN8Y
	RRgt+6B3dkkkqFxJhdtNtrFBuFLvyv9+IQp02kYo1XZEMKv//zBKIPLDZHLCFwVEprzJVhG6/p/
	Qej6nV7V+iFvg1kAdgH6jI6Yk+uLBfFjxUCwCTzLzY6ao2iDa4RCsbzwr21mO18/qz+bBfn0Yhu
	3bnKmoSA2392IZju74ISYEFuwuiJASBCSw7XiGXPHngo7cwpT6aJ9bGBwWyOmloEfd1wAMNC2MQ
	ILEux3A2VeKTrKC/qszibkMJoEk9Fg8OjdPowXrRPqI32zKp9ROrutqIjGgW3184gvwfuC4eOqA
	gXvnxNR88AscEeOYklKTzybYHEOUwCbJF
X-Google-Smtp-Source: AGHT+IHjRDSkiEXcZxyWOE/t7bSn1e79AjDDJOkyYX3/PD4OOgosOOm19EJo/4h+wmqgl1Q9bJ6HtA==
X-Received: by 2002:a17:903:11c4:b0:234:f6ba:e68a with SMTP id d9443c01a7336-23e3b86d31emr176095ad.45.1752780264933;
        Thu, 17 Jul 2025 12:24:24 -0700 (PDT)
Received: from localhost ([216.228.127.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6d23aasm157635ad.167.2025.07.17.12.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jul 2025 12:24:24 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH 0/3] KVM: PPC: use for_each_set_bit() macro where appropriate
Date: Thu, 17 Jul 2025 15:24:13 -0400
Message-ID: <20250717192418.207114-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov (NVIDIA) <yury.norov@gmail.com>

Some functions in KVM/PPC layer opencode for_each_set_bit() macro. Fix
it and simplify the logic. 

Yury Norov (NVIDIA) (3):
  KVM: PPC: simplify kvmppc_core_prepare_to_enter()
  KVM: PPC: simplify kvmppc_core_check_exceptions()
  KVM: PPC: use for_each_set_bit() in IRQ_check()

 arch/powerpc/kvm/book3s.c | 7 +------
 arch/powerpc/kvm/booke.c  | 8 +-------
 arch/powerpc/kvm/mpic.c   | 8 ++------
 3 files changed, 4 insertions(+), 19 deletions(-)

-- 
2.43.0


