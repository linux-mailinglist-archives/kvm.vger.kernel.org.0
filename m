Return-Path: <kvm+bounces-70121-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kOvWJYSPgmkMWQMAu9opvQ
	(envelope-from <kvm+bounces-70121-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:15:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A36DFF46
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 01:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A92A31716D2
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 00:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD87035975;
	Wed,  4 Feb 2026 00:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5+DzN8z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3E1182D0
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 00:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770163857; cv=none; b=EzRA7qYQs0NRuZxg9Hx/J7MhcGmktUg9JMeUaG0Ww2VzudRKb/ptQlp8hCPBZbzMM/pXzgK3R+l9FD9q0wTmOp0FtMp31rFuOjw1FiFWM2jVw0wa7y+oRxNGx/j+cnQ/W9yofPQnCaBywnOKKTJNiWCIk4MQC6ujF5dRIr41EvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770163857; c=relaxed/simple;
	bh=etezzLrsm51CEQRUCt5JTNPqfFmbifP0NaXnI8JcH20=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cF79MX3X8KxYfwBEKPvHlCMHHdP16IYdkeN3S2m+Ne1TxRxhpkEmedOa5fAbfM/6EVegH8NcrLZzzzEXRLnkOnf/CJZkHRz4MxEqRY+GfAA4+6C/tWmVSKc7VYGrdQOcDFOAaVnW7DPaZzMpVm369N3bJqruCT2J5ccLH16JNP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5+DzN8z; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0d058fc56so45932135ad.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 16:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770163855; x=1770768655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IMcyiK2GvMw8+5G6wgbku2noMEy04O0T6P3oqQF8GH8=;
        b=Z5+DzN8zDiykQIG9D5C1tINGWbbieIGc+ZQCsVNX3wqsZHmTaK6LG7aZnjGmVm1G81
         1spr+eWClx04gGdNyqFeGV1dsgMJb6THssHrvOO6FQK2pbfang/Ik2e7Xfq1WYV3FJZp
         1a+i05o23fJnjdT9mF/8RZORClOa9PGk6tkw260QL9zFCb2R/GbPKiqwWgHDvuFWlruJ
         mYbKtoaUXBfo33vIigyxmhk5YuKzgkBw47AqrLAWk1e3QKLivAzWCopL7GxdIsmtNuht
         W918fHq8rSgLNXcu9PLK9L0RdOm3w4hlBUj2ebsPX1p6+zh9okSv3zaoMQo8dYnjzZDL
         L3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770163855; x=1770768655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IMcyiK2GvMw8+5G6wgbku2noMEy04O0T6P3oqQF8GH8=;
        b=F4Fh1DkLZkONcAfTg5cS2evaQ8AhHIdr0Pc33BrxZVHTzcsda4h76U3wiqJu2LmpEB
         1ZHBq/7ZIWlvJdcR6mRXZ11ktqgLm5DfotcPMl6HeQlr9ONsQpA3AxMYI1T/wsckFmDX
         C7NtguLHqr2G1YvZQziO5aMVeRJr+E+OdCsfUDFw/GM8hcflD0iQ76/yL3iKVz9ZYOV+
         ttdVBb/tHgt94noxytqsDuKPNqoffR92xilmgyz05S/uf74N4lXdhIP0szcxobSLn41F
         kd09jx+D3VsFX1LWXiHpke9jWufvZhGAERmz9n9CBs5rrtDrNYatvshCNIwRYAk8xJmf
         OWew==
X-Forwarded-Encrypted: i=1; AJvYcCVRr2r7tJRrj/5R8cd0RoTO7qgPUC89lPfYjO8XhVjhhrcR4hJ9jIuVlTGAFQdNyAsJA14=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp3//NK8U5OrsY/KkLGBkU6jSVsq37MZKujrSKHaUCqA9ZA02N
	c0mKF8pTyfJhyzmGGYIlhtbbJthwUA4EnzlQ5Kay394bDokr43HF2+GueFz7mjSe7S3DCMhT853
	jXXmdlA==
X-Received: from pjzm13.prod.google.com ([2002:a17:90b:68d:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b8a:b0:34c:60dd:1bdd
 with SMTP id 98e67ed59e1d1-35487190c47mr896568a91.22.1770163855370; Tue, 03
 Feb 2026 16:10:55 -0800 (PST)
Date: Tue,  3 Feb 2026 16:10:23 -0800
In-Reply-To: <20251120050720.931449-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251120050720.931449-1-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <177016340653.572179.1515388736538593852.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Advertise new instruction CPUIDs for Intel
 Diamond Rapids
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70121-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 45A36DFF46
X-Rspamd-Action: no action

On Thu, 20 Nov 2025 13:07:16 +0800, Zhao Liu wrote:
> This series advertises new instruction CPUIDs to userspace, which are
> supported by Intel Diamond Rapids platform.
> 
> I've attached the spec link for each (family of) instruction in each
> patch. Since the instructions included in this series don't require
> additional enabling work, pass them through to guests directly.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/4] KVM: x86: Advertise MOVRS CPUID to userspace
      https://github.com/kvm-x86/linux/commit/f24ef0093dd8
[2/4] KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
      https://github.com/kvm-x86/linux/commit/58cbaf64e653
[3/4] KVM: x86: Advertise AVX10.2 CPUID to userspace
      https://github.com/kvm-x86/linux/commit/2ff8fb1e65e1
[4/4] KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace
      https://github.com/kvm-x86/linux/commit/062768f42689

--
https://github.com/kvm-x86/linux/tree/next

