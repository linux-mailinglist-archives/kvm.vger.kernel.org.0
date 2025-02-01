Return-Path: <kvm+bounces-37036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C1FA2465C
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAA7E167A80
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BBB8615A;
	Sat,  1 Feb 2025 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2hbg7+8i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A94638FA3
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374925; cv=none; b=ToxRV5DgTmEatn3cAlo50aTgfz6erlMMFlUQuBjUQHBRUVPRoARp3ik671z7fgjee/EcPuaraqOBFIhgDE51FISJTVLwXPUEXvf7t9SwVuTPU0xZgysHDNiINsFQ4pXtSaC+5bECiivtrf60peio/oCKjN0ujTGnNnZ5fjx0K0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374925; c=relaxed/simple;
	bh=2nRKDkSWDDf8jzC//34iIp61t0/QFHqNiM2wu/iV0a0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MnPH/VrkV3enJGay0X75jM3dmB4NcFtREukoe4vAkzjkIA33LL7hHH+aPnxrdTCKiJHv2H8BZDqIxDj8z93/cNl1fn3MRMSOsM+Y+YWbZaMLwY41h7ALdtGsDtCbcwZ0mjtOcMAwNQJ49IMHsW+XHtqFQYgFtpPQj4T0HrlXI+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2hbg7+8i; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f550d28f7dso4949823a91.3
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374923; x=1738979723; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hIrDaupeXQ8y0x86Zzi3JQgYPukIHboTrBwjEiiwuw4=;
        b=2hbg7+8ikYMk2wIJazfc04kvyiiaxdRdbmdhJnjgsgjvTYgqmqnzEnd7wBlWn5W+LP
         xgctsMkQS0QUGWNMuWeI5LfRnaYJNyB+6CqEqAuVla3EG253GePIUK+qe5e6N3Jf32k3
         04fgHo0qEMr6OJ+NSUBvJal16/dFl1fkpL+nKceaZHf1nleDH9HLstqA0eH499yNlolU
         gFPTa/HfCAHpmQxp25ZM1wQLzVeGD3B5uMZAsOqPjY7GOWLwH6eeLgkWWg6y7rkxmlBF
         DfrSAGG3sF8stO6CzWp6OzliQ2Xze10hFLY4oro2EXfOSbGz2xXjN96q3pOzT7iu8DiW
         Y8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374923; x=1738979723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hIrDaupeXQ8y0x86Zzi3JQgYPukIHboTrBwjEiiwuw4=;
        b=b11gjeOT8sG5xo+yA3RI/uuwL+KmdWNzf9QFZWjCaTBWahVonjmzsW0u9KR1Kmuue8
         UHHe8kCACs+GfUv6Cr20qBWkh5RWXirSjete4EzDIUd3RUodumvbZdWfdCL5XJxSe5Dt
         i0gbRxKaD1W+JMwUAtEV7PnrGcj+9wYRAjOLliooVTHOrD6lH5fxwM2wrLFVdCwfVfi0
         Sj1ZYf6x1nzOXfrx5CkMrFOIulfnwTpjqluCnZnXOynnJqv4mKidmgX2i206Nv9TvVHf
         aoTlTkAzc4RKnNK0NRcdETZAlR3ttBlQSU1UAAGqYtThWof8Ms+oWm0lq2hlfhTi6o2J
         2n0w==
X-Gm-Message-State: AOJu0YyZbyZY3PbX2KmcWS0X4z8eIDs3vfvr53QzW8KwTD40AibgnI27
	9nBFFJhutTojUdjsk8Lv47vy5Z6yFxioOXvul5MSpalYwcgpZ+uy5z+2976Z9ZEDgS569+urHXG
	ccA==
X-Google-Smtp-Source: AGHT+IHT7N7Q088xoXBNld7OpzfjuKQVGlZu3JPwD40gzpt9LBs7F2KvjEbfG5sWR9bPdoFOLRy/GEsuv5U=
X-Received: from pjtu5.prod.google.com ([2002:a17:90a:c885:b0:2ee:3128:390f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:538e:b0:2ea:7fd8:9dc1
 with SMTP id 98e67ed59e1d1-2f83abfedfemr22296630a91.18.1738374923421; Fri, 31
 Jan 2025 17:55:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:09 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-3-seanjc@google.com>
Subject: [PATCH v2 02/11] KVM: nSVM: Pass next RIP, not current RIP, for
 nested VM-Exit on emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Set "next_rip" in the emulation interception info passed to vendor code
using the emulator context's "_eip", not "eip".  "eip" holds RIP from the
start of emulation, i.e. the RIP of the instruction that's being emulated,
whereas _eip tracks the context's current position in decoding the code
stream, which at the time of the intercept checks is effectively the RIP
of the next instruction.

Passing the current RIP as next_rip causes SVM to stuff the wrong value
value into vmcb12->control.next_rip if a nested VM-Exit is generated, i.e.
if L1 wants to intercept the instruction, and could result in L1 putting
L2 into an infinite loop due to restarting L2 with the same RIP over and
over.

Fixes: 8a76d7f25f8f ("KVM: x86: Add x86 callback for intercept check")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 60986f67c35a..0915b5e8aa71 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -478,7 +478,7 @@ static int emulator_check_intercept(struct x86_emulate_ctxt *ctxt,
 		.src_bytes  = ctxt->src.bytes,
 		.dst_bytes  = ctxt->dst.bytes,
 		.ad_bytes   = ctxt->ad_bytes,
-		.next_rip   = ctxt->eip,
+		.next_rip   = ctxt->_eip,
 	};
 
 	return ctxt->ops->intercept(ctxt, &info, stage);
-- 
2.48.1.362.g079036d154-goog


