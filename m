Return-Path: <kvm+bounces-72839-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMAHJfe4qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72839-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F268E215E7D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC815314C603
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48B383DEAD2;
	Thu,  5 Mar 2026 17:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3v3YskBs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814BD366835
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730500; cv=none; b=FsnVMZ58QcrrnIpThKEWaeHsHYsYfdoiSST71nvrPlJetPWZ3olRCPIqKNEaDFoeOiTFw24TGkgZpqshBQLZx7t5eZPiN/iWfvkV8iUcEEJzJa0Z1DsS1hAAcIU8ojsbCBclh/5HZ3Ufs47usrv0gwc2FKqGn72UrjOmyKFvAIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730500; c=relaxed/simple;
	bh=dteI1SJNmPAO77bYzItgRmQJ7d6v+OBdOPlxPAFgTGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=Z1CUiGfmXTcNY6S0FnFr6kPETe2yBYQXDlpgyhjKNs2g+OIZMWSBkYnDI0a3RJZgmGVkYeDASRKJaDOrFk7d7VF32SQv9pv6TJd1747TW3//8UJKLJfYYquWpEe0JhNoMakI7NXsdy88Dnx6fdkXanuKMleiAlihNCc/WUSDJIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3v3YskBs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35641c14663so8677042a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730499; x=1773335299; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HhPw/roeho+7lvMc3SsaU8TxBW1aXYa0qtaNcvm0G9A=;
        b=3v3YskBsqYugbHYIppt4H93BmeUnYSeYOzykoFNOe5fSIeYl5FJyawdXMlIoPa3Be9
         MI6/cZn2H5U3/NGH3/2AKP2E6tYFvZsvXemtusGFTBNgy3qKbkrKhCRxfejT3kpVa0UT
         Q1SVNNyOVB8DiojfcP+Q+mQ0/Y/6QQnckxvUYwhq9+xU0+M2qBduWz3EG7nSgCA99uC8
         Aev0C7NmDEsJ3Egx6k5Zx1Huul7FpGGkwkNocajKs0Y1XKN8kHL59mMxjI4cQ94H+a35
         ldrXil8tZqyHYd9Vuvaf7cnrIf0+K3XQpNeVI7qcq0XsdZwjPnH0/ChnQW0YJ9xplF5+
         WscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730499; x=1773335299;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HhPw/roeho+7lvMc3SsaU8TxBW1aXYa0qtaNcvm0G9A=;
        b=eCX79caf3t40r9jbkdpOd9rRCPu4ikTi2SbQEbZCzkZKYvBoQxIcHJqJxnyK7yvnPx
         5XWLR8XI0SNlivb7BRyFElDVSbVoGYJdcdZvKxiIK9bY7LAD5Lity4LX+vZ53lxDZ8MU
         yvIK8mdSaLZB6PsiVsSOVNNws2IpIuBlXMQUMSpqzTJB7FIg6sVcdDJMmmBfPeFUXNEo
         KI+yZEq7Z7t6FX8Vzsjl+mpLRES3QhXJgN9X4TUz0GiZyvRHJtO/UreL1U+ISrDVwGFk
         aCYDhwVQyDlkR62BpSrEPYgv+kUuWhm8/VyhdjAS96+LEYG3CecYfjmz8K8r5gJLKF5x
         gG4g==
X-Forwarded-Encrypted: i=1; AJvYcCX/QK/jhQZRWsbkb0N9DUOIshBPxg/yCRtEyYL6EyXxyPVxRr2Ikm4k0FJnh47LlstgNsM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBJFKD1TL3wW1MBBygWbK4cWmfC21oQApzqtyXksDirIB1psLQ
	0q4D9xIS7g3TxhrL/3jzzO7+b0+OiSb/ndQ3pVYCOA2qLRihHHmSqAGA8ExjzGpdchVXdyI14Aj
	HSGfeXg==
X-Received: from pjqc15.prod.google.com ([2002:a17:90a:a60f:b0:358:f40b:c72b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2888:b0:359:7906:d996
 with SMTP id 98e67ed59e1d1-359a6a66a94mr5691416a91.23.1772730498600; Thu, 05
 Mar 2026 09:08:18 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:29 -0800
In-Reply-To: <20260205231537.1278753-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205231537.1278753-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273037616.1571959.14923742089939841879.b4-ty@google.com>
Subject: Re: [PATCH v2] Introduce KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Josh Hilke <jrhilke@google.com>, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: F268E215E7D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72839-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 05 Feb 2026 15:15:26 -0800, Jim Mattson wrote:
> Add KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC to allow L1 to set FREEZE_IN_SMM
> in vmcs12's GUEST_IA32_DEBUGCTL field, as permitted prior to
> commit 6b1dd26544d0 ("KVM: VMX: Preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
> while running the guest").  The quirk is enabled by default for backwards
> compatibility; userspace can disable it via KVM_CAP_DISABLE_QUIRKS2 for
> consistency with the constraints on WRMSR(IA32_DEBUGCTL).
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] Introduce KVM_X86_QUIRK_VMCS12_FREEZE_IN_SMM_CC
      https://github.com/kvm-x86/linux/commit/0f70db0758be

--
https://github.com/kvm-x86/linux/tree/next

