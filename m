Return-Path: <kvm+bounces-67801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C092D146DA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:40:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 896A830066C0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2695D37BE8B;
	Mon, 12 Jan 2026 17:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HUZ87I4V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D70374176
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239620; cv=none; b=bxy7UZ8zitH+XNHrNnct63UnIoGmKSHZFxLwcLsLoJDwCnsnQmjd86SqPmEo7/JwKKFGdPhRhaXWuyaAoexTK0BYp5mgZBxNrzSySmD6oWsrg4DLJfI1Tw/QYEkCzsBSsqkZx6m4TPasm98kMYVt2C7QCw9cjao9LeCoBkywZTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239620; c=relaxed/simple;
	bh=g0rVZPHa3Cv+zMK1dY9bAeK/DHLgiSvDT0Ke2Pc6Mow=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VcOKHU4HOqR2EgJFA4ZEPg/cXAE2jMfftgdde5Kj/2XuzsA0dSCvs1zombqzF2c9Nky3v8fmtl76d13JovnBfLJpSNN+UACJE3qbNhMURzfInNVJVP3DEd592eVbGOpSR+XpdYLDSy/CLgLY3KfHDyIFUFa+h13Hv2nt2qnj0CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HUZ87I4V; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0bb1192cbso62211475ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239617; x=1768844417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xma1JJ36tOas9v7m+y+X519iNPhPGylf+hfn5A3Kz70=;
        b=HUZ87I4V4hyBnTM60YvqgNfcwxtovLJCilE+8xUJjg74nqKY0QxKtrJejgTLoIc6Qb
         b+XD3m6U/W+8SeI5E9kRXIQQnoVVpcRmMY+VNvfCbiHEL4nr0B6yR6UXlkyZ5A4cRvaK
         vYSJYjsLSP3swuTxnWGSPRnjQGkx85ix6rUQJ9WBaRQomPbBsR3fdHz8kS1wmgoxsw4W
         K0g7awKgYENFE7/v1vouk4jXSGcplC9PZPnAU0BxJovn2duBE3sQulTI564oG3N+xcVG
         Gykq4m+xLss1C4gPDn7NFULdjJLTU5i8o+qyf/96LthbOjbfvUaSG02hzSN6NPk0XnO1
         Hp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239617; x=1768844417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xma1JJ36tOas9v7m+y+X519iNPhPGylf+hfn5A3Kz70=;
        b=EAEPAjRXLtaYFhsWA4DWgYFHhMIE/mMLkZQ9zgfXcMt0B0qcgwBU48k87K9IXpUEit
         H7G50zJ9Z1n2T1H6pXTHcHJTvndgX/nylu3AXQ9JIKeIQ2kXZgcLHPy3PXITJwuxjyLy
         he4PCNn/lgyYk86n4LSQQ31lYK3CWzRxLBt4cAeD7o1VaL81YJ1EN0KgPMnCrszxTu5r
         aNpxBdI0CxHBAHM89vFI3/8TEto4uihpOoJbvKcN2OssPVw48NSHed8xPFU2NmFgfO5k
         EVrlgJU7ihWGqiLTzOp2fm0iDdaPzFhC06dYSJv4QSWcunQ1JsImQd3pKDbIKFx+q7gy
         DiUQ==
X-Gm-Message-State: AOJu0YwyntaclNssSNxsx7MtcBzPN+0pYAaTl1J7nEJ70KHfDHzagZj7
	3OCF2SI0stDcU3wrbKgzZCHzYNNFam7rQEsdK2hCX8kNRgvn/OlYJH5FljDxOpWWxnAjJi+IMzw
	HAnjMrg==
X-Google-Smtp-Source: AGHT+IE3K+EBia3NvnE6/5rwf5yo2XVyOvquIvGQVHMVNGv2iBbslq0NWguco/PoHUjSovErbkcIRydlIwU=
X-Received: from plbiy23.prod.google.com ([2002:a17:903:1317:b0:2a0:895f:4fbd])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d511:b0:2a3:e7aa:dd6f
 with SMTP id d9443c01a7336-2a3ee4f339dmr160761305ad.50.1768239617402; Mon, 12
 Jan 2026 09:40:17 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:42 -0800
In-Reply-To: <20251230205948.4094097-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230205948.4094097-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823890112.1370389.10484759715072723882.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Return "unsupported" instead of "invalid" on
 access to unsupported PV MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 30 Dec 2025 12:59:48 -0800, Sean Christopherson wrote:
> Return KVM_MSR_RET_UNSUPPORTED instead of '1' (which for all intents and
> purposes means "invalid") when rejecting accesses to KVM PV MSRs to adhere
> to KVM's ABI of allowing host reads and writes of '0' to MSRs that are
> advertised to userspace via KVM_GET_MSR_INDEX_LIST, even if the vCPU model
> doesn't support the MSR.
> 
> E.g. running a QEMU VM with
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR
      https://github.com/kvm-x86/linux/commit/5bb9ac186512

--
https://github.com/kvm-x86/linux/tree/next

