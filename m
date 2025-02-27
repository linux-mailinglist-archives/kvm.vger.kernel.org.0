Return-Path: <kvm+bounces-39427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0178A4709E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5FE1D188D682
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E80BB535D8;
	Thu, 27 Feb 2025 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EYZ06Edg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93BE27005D
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740618076; cv=none; b=Xac80PaqW96L1FtgSJjj8HdmjUtttVsJUBX6UzvTQzHFlVpCiSi7vrN1O9uFVaU0xU4F4S7GZMZcvbcMVNhNvNM1NvGkDnlUnQ9nNfkfDOz9x3skTblBJX4LW1PpJnS0we74Khec8u6FhtxHgwVl5wRIoR4zCRk+XtP0N3wjWM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740618076; c=relaxed/simple;
	bh=MJkxaDKjp4xLw2qAO/PVE8kYrbfA1Tvd5U0UZQv8DxU=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=H+mnVSEyWaL9/gTJJ/GNunT1W8/SJ7RMNA9mNoWmKEKhUIzpXowkVy4faQGkmWoliEsglrmiugTk89dR1JoSObWVEArBgH5k6jMy0yCh51C4c36/Ev5IaD25SF7WfbCZMKuMdgyeS4+jTMwAEUYqWcnhNpWtKtttCsoNG+JNGL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EYZ06Edg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe98fad333so915616a91.2
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740618074; x=1741222874; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7FGSvZnsTup4FbvQYUEbSwqPM6j8STYAb7LEU04cNgQ=;
        b=EYZ06EdgXIZASadq/PZA19WE3+T01lDv1qivriUD4MBsZ4l9DvPWnNXc/3L/UHttt0
         oVMygi4imIdNjDIzJaId9+InIj86Xw5fS1tmUlhCTNmk/a052WYxLRWnUk61h89EiKnD
         i2fGlXk8XBSaQCHRayqrnBd3Qta+KxaprpU8T0r2a/ISaKOhBcJUodjba8RmCKm59LPj
         ajxvjo7I3WTCoxIGmZSWBNnxXHRKo+t+FafqnCIBXfYbxadFKazxxmHZb92jyhQzPwsS
         gSL4efRxBUcxNxccm5Xlx5rDH0rf1Dm2L7g9Obq8IhRF5zfxInNPSuG7wkULJotm8wD+
         p5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740618074; x=1741222874;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FGSvZnsTup4FbvQYUEbSwqPM6j8STYAb7LEU04cNgQ=;
        b=iDAaowRfAOCJoHwEFtG0EHH/vSpyLmWYMUV7+zCPFb1ulAI2aqo4JOYnls0HliE2X2
         aQfgWQzq0lHniL7zoczmjZBqP7hlsz4NR70ylC/0dpOldY4QIbtYNr42d/o6cxDP8nkt
         +HmahxUmw2P0BrD3ERIO6TLY2KTd5i7RE4lXb1lDQ8Kk1FFvCmhjCAiyAvzPAbRnXfkF
         WCQBTHAB+JrXKAcCZl840818iwBOZ34fIz7yC8gbr9ExmrIOxbkup+KE5pL19V4d4pvK
         SGl8c7KurcySQKKpmsF4fXgEjhkaDnBlCJbmh/I067tVQTDxp2t1unYtkz32dvYZn1gn
         5uvg==
X-Gm-Message-State: AOJu0YyT3JRyj5FmhSEQvu0zL82K57WYCz7CP598agwmUlv8V2ebUEOH
	u8IofwUo8XtJ4sl2WCQ+nTGZzV8K/sUfO5vMzPKVpP2IfL6Qy8Cf+OPFNr9eIttPZmqFD3DeePd
	OfQ==
X-Google-Smtp-Source: AGHT+IEpwphmkDcWYyRaf/JaCL+77vUw2LSwzN385jLypriLNDJlK7izhiOdGrcQMdreqPyQe3yEl56oAEc=
X-Received: from pjbpa16.prod.google.com ([2002:a17:90b:2650:b0:2fa:1b0c:4150])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fcf:b0:2f8:34df:5652
 with SMTP id 98e67ed59e1d1-2fce78beb41mr33084170a91.21.1740618074186; Wed, 26
 Feb 2025 17:01:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Feb 2025 17:01:09 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250227010111.3222742-1-seanjc@google.com>
Subject: [PATCH 0/2] KVM: x86: Advertise support for WRMSRNS
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Advertise support for WRMSRNS, which should be trivial, but is mildly
annoying due to a token pasting collision between the instruction macro
and KVM's CPUID feature bit shenanigans.

Sean Christopherson (2):
  x86/msr: Rename the WRMSRNS opcode macro to ASM_WRMSRNS (for KVM)
  KVM: x86: Advertise support for WRMSRNS

 arch/x86/include/asm/msr.h | 4 ++--
 arch/x86/kvm/cpuid.c       | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.711.g2feabab25a-goog


