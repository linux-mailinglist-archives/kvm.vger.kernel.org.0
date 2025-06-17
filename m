Return-Path: <kvm+bounces-49765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10AC3ADDD8A
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:01:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 491FB3A4B4B
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5CA2EF9A7;
	Tue, 17 Jun 2025 21:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePieN2wh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE01F1E8335
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750194072; cv=none; b=h7hKk1Tpe7xGgajbap8/X7rkEW3TbzYvvsyqbbx3Kdg2LECyB9+q6uttlA84YkA/KBl0WnFT3cSjt+chDi8UREzdfQz3t+7fAVg9izRsLJaBeppN9Ga8s2cAKi2YCNPoM0nc6U/zU5+MkvvuTRU03PMAQ3wq8m7nEVCiQdBn+rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750194072; c=relaxed/simple;
	bh=avEJxZ+89MufZP0SLyU7euqYnGXLsVOUMkRS8Ko+SH8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XguAgVVhtcMteV6tHPhAeARR+pe/iswGuENDwYT0L9WXooQxWVosMJ85ggpTb9Z/johWrU1rOFURauzoCgZx8mdDOp+LC0LwHDSqTpo5IAa705K6Zqw9rdW1exT0R3bZc1WOG1Ve17w47YXMWp1sZyNmtlimIBvqX3FGVpWhDdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePieN2wh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312df02acf5so62543a91.1
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750194070; x=1750798870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWy9lkoAMNiIrASQ8hATfQAjClcrpl+Y1yZ0Ab8XMS4=;
        b=ePieN2wh8gC7ItDJ2jPbSEuFL2D21fJ+9UErWN9MqgNRdGnn/oxqNHXViCItI6mxi5
         1oRAGtxEJKC/UdG6vbtom++QL1fWNQuRTKfj2ZLCLq3q7Tk33Cs4qtQWTBfGzSdO+4CJ
         msOQgmwoAyoXPfB2e0HROo73O6EH2PYxeAQd0m2TohKRTGE/+MjKDDYzi9GoY3L08EAy
         rsyCx5Oz8wtJLKbv3hrG+bNOhADFR3+qni8u+0BDnyzGAdkDMDENFCUb5CkDTqgTJN+A
         91JmWSzaiVwL14hxkUatbviXDy4OkQILdFG/lU+s9BUFiT/3AxKfGrwKiMkK56j9zf7Z
         4rVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750194070; x=1750798870;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWy9lkoAMNiIrASQ8hATfQAjClcrpl+Y1yZ0Ab8XMS4=;
        b=nc7iqPc9QpKFd1eNP9zQgEpcQysv5iE6Dso0/FsD7nUr22C1rRivaNsZhGRjnB+SDe
         bz7XDPfdX6vp48LwBJcwCmc9YYYzhN+IrODACl0OnFxTDQW2sxKerAqkEoKdmZRllzie
         zVHRD6Ebs1lH4UKahgGxb8bFbtxXJaqn6lo2/TklrxaSsfb3MZIdt/ZDwb7MjCCnUTKY
         wPtUg0EMyVeacY9uahlImCcbW4MBKT6bnhlGUEPUUcxnZDWs3S9OVljNJ0b5DskYSOjF
         eByA9I5PIjmm0gGD2iRxWGS1BoxLfuoaWj3mBSWtQdINmQBzGVhw1OOiq4/FI4OYIXN8
         DCNQ==
X-Gm-Message-State: AOJu0YxU1qFmdiaTZIyt0Z9FLUsd/+43NFsDRYwDrOtuLzhUjgFpkjhH
	kQ2KdDr4L5cD0D5ebmU9hFw7uJA1hK89Dh/pEYuXvneJsIm7oYHRLaRPYEIFlHA/hd2qYNVTntc
	I+tkSkg==
X-Google-Smtp-Source: AGHT+IEE4tk5CdXgmXoq0+BZG4nzsKOX62wsnsfVghGqvjHwEY84uaPun9CQUeH3vVGqWrPA6SHXwsPuLAc=
X-Received: from pjbqa3.prod.google.com ([2002:a17:90b:4fc3:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8d:b0:311:83d3:fd9c
 with SMTP id 98e67ed59e1d1-3157bee54a1mr113685a91.0.1750194070127; Tue, 17
 Jun 2025 14:01:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 17 Jun 2025 14:01:00 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250617210100.514888-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2025.06.18 - Any topics?
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Michael Roth <michael.roth@amd.com>, Jon Kohler <jon@nutanix.com>, 
	Amit Shah <Amit.Shah@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"

I won't be able to make PUCK tomorrow, but that doesn't mean y'all can't meet
without me.  I _think_ if someone hits "Record", it will show up in my Google
Drive (because I'm the meeting owner), and then I can get it uploaded to the
shared drive.  So, someone just needs to take charge tomorrow :-)

Alternatively, if no one has anything to discuss, we can just cancel outright.
But IIRC, Paolo is out the next two weeks, so this may be your last chance to
pester him for a while.

Sorry for the late notice, this week has been a bit hectic.

