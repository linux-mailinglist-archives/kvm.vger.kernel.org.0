Return-Path: <kvm+bounces-72266-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPxPAEliommN2gQAu9opvQ
	(envelope-from <kvm+bounces-72266-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:34:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B2FA01C0223
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 04:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2D28C30C98BC
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 03:33:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A715A2DC79A;
	Sat, 28 Feb 2026 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="byvqLijD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3E52D94A2
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 03:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772249616; cv=none; b=XsuPntdqsFDTJNP8mBwWJiiPG9+NAyBKieIvx2vF8fuGue3qXehVZ6sE99izG6uOMx+4cJjwT4+EoBpQzVmjMo69oE2slQBaXk0CUzXqPU/IZMzgaQWdY7Irj6XbArV/bxuzgBU8FEtgvCTkFyl2rqUyY+1IweVPFkMqC4FI+Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772249616; c=relaxed/simple;
	bh=REyT1G9FpNn5qNarjefpEbiAs8imk6e7vxUrBsAhh6k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YE9CzDujy0ejqyPkifcbVWSCwSTN3rNxC4NCX/7DULjEq2wPP5uPIcL9CQzU1CG01ip6HnCqTyslEKffWSZtE+dNFMzCoumO7Uy42303tOQ3JRNiCMJODnfcEIX8JSbl1sPM297r+6FVVEmJI0NSNkIbNbl8NeyEDnYNiRsvPbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=byvqLijD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3594bf70b25so1779426a91.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 19:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772249615; x=1772854415; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p2bfImGdIG+xeppbQBLGWsINeVh1ZuCF8UpEceLrB0k=;
        b=byvqLijDYS1ARZHOss4Te1V/eNiXHMYsYfxilzSmquoyyJdnTZSIuVfO+HUBEV/j0J
         Z9jagL3st+5haVfcSQrNylaQffoJo4xTOJiNCakNfxJ2o+VYnxqyBaP+iNrwTsBooxGk
         MJLtJ+ZGCWR2ZntPQKVy0OT/xX8Vp81dbu758in8FhBr/dW5fWDouJnP6ai15tAXc3vj
         uaxNPrbB7/VJ8ma6AJbkiXaLeMtjEE/ttdbbeUfv0PQxj43Jh39XUxwNsmBvdV1ttnKC
         IufmxX/4FGexN6BjyPi2mIn827EeIHLoYI4UOlwRMHHMfsDQeK9v9Pb+TxlKUljSdsrm
         RGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772249615; x=1772854415;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2bfImGdIG+xeppbQBLGWsINeVh1ZuCF8UpEceLrB0k=;
        b=U07W8RtRUAHXquy0IYacriQ1T/lWN8t14MieS0h0JxPKEoV3/1rnMYavfjZ8uV5qYh
         fb4xHzST7+lXDcH2SpQZwLDCCudKumNkpLZQoEF9BJ9190SEAvKkqAJC1XIVFJL28ZyW
         8LGXw9//HQ7a1pOC7o1dzn/5QEEnSqoJo/AtHzNGuqngVl+cToVCtSBxd9q5QCXxsK5I
         4rFydkQr10Mr/AGPdGudUuTzLro65poNr6hUhestzurKPl+CDwkKhVzWKIr1qjCjLHWm
         92Fn1dySFu9vEXPW2sgAUFVk0xTRqpU0vyLiN8YFcYNcSUBM6XtzTnGPhx7WCRbMZ4N8
         VDLQ==
X-Gm-Message-State: AOJu0Yw0NgtCErffT0YCsEjMbmE+s3d2IuAukjx6XEB4t4UOZ1kd88+S
	BzOCjxIpwDRoCmjb9AfE22h5yi+evy5o9xLUVCT7pmrZEHyKDzNRUgOnjm8VQcSb22srMfjorfm
	cEtLWDUKouWcyqg==
X-Received: from pjtu4.prod.google.com ([2002:a17:90a:c884:b0:352:d931:fa5b])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5747:b0:340:25f0:a9b with SMTP id 98e67ed59e1d1-35965ce437amr4747029a91.33.1772249615193;
 Fri, 27 Feb 2026 19:33:35 -0800 (PST)
Date: Sat, 28 Feb 2026 03:33:26 +0000
In-Reply-To: <20260228033328.2285047-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260228033328.2285047-3-chengkev@google.com>
Subject: [PATCH V4 2/4] KVM: SVM: Inject #UD for INVLPGA if EFER.SVME=0
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry@kernel.org, 
	Kevin Cheng <chengkev@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72266-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: B2FA01C0223
X-Rspamd-Action: no action

INVLPGA should cause a #UD when EFER.SVME is not set. Add a check to
properly inject #UD when EFER.SVME=0.

Signed-off-by: Kevin Cheng <chengkev@google.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/svm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 25b15934330bb..249bc3efe993a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2386,6 +2386,9 @@ static int invlpga_interception(struct kvm_vcpu *vcpu)
 	gva_t gva = kvm_rax_read(vcpu);
 	u32 asid = kvm_rcx_read(vcpu);

+	if (nested_svm_check_permissions(vcpu))
+		return 1;
+
 	/* FIXME: Handle an address size prefix. */
 	if (!is_long_mode(vcpu))
 		gva = (u32)gva;
--
2.53.0.473.g4a7958ca14-goog


