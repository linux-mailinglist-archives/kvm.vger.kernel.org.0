Return-Path: <kvm+bounces-72842-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKLdHLG4qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72842-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE75215E15
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 43166300F172
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59ADC3DFC91;
	Thu,  5 Mar 2026 17:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n0dfjCkC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6AE3DBD6F
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730530; cv=none; b=VjndsAgmVRMyhvxKhs88wRvd00QgU2tKc1cNxeF9phGOF7OsKrhXYidX/kjJjLhDHxeNC4dgU7EkZ3zz1/vPWDB6Hn9lRPUDplKX3SRB0WqNJ6a85tLGq/DjfTUcZ1LVc9if7en/F3FlzPEuOBtQ+cR2P6RVjX6XjeATJiavwB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730530; c=relaxed/simple;
	bh=ivmZQIHu56Glzm1NDIdMtgKwedz772DUWTdxon9hrS8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=X+w0keoi7NJww46F3MDupCPFG+KGXZNMSCg7yCkkBf5/Z1LO04OtMkew54nW+F1NeU8cD78ReBs7WVqkLldObjRzpLT+ed1rE/gLrCGceiuMEaVYQGzmksNXO0ntptzkNcfYsJc81lLammODc7PA7sX5lDISyLzn/SkwDIllLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n0dfjCkC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c73939e0314so366265a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730528; x=1773335328; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xKG/KXPa09bekNEkh0pKa7vuiFECdsb0ygf7X1Epav0=;
        b=n0dfjCkChiEI0mQlV0Xyqy5dAO011X3NB1aIC1KFQp4F/3HC5hCpRgufuDqCTMVYSY
         aFLuvknPQW4ef7siw1y8yceEeHwnYgxVct5Bcjet3UV9h0t1sPa/OVsout8Hpb9ginq5
         oX1JLGW9g5DzUolwyrTk1c2rovcXyHizUpw0w2PfDsfa5KbNH+J64YqTsU1mPGpyM6mt
         lsU+Kl7bV+jaEkFo+IDYq54KOnDbdjnDMNNvDuxqc4KhAQAMqEyNG2v9Bz3JoBEcQxDf
         +xAgeiPP0sDqPiMcjvEjDHodUGyvJW9vHnHYx2Dv9xuKRyvD62uCY6ZXhVv5001x+bZO
         Of3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730528; x=1773335328;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKG/KXPa09bekNEkh0pKa7vuiFECdsb0ygf7X1Epav0=;
        b=jbKz7c5egHs6qpMn/AhNeIMte0vcjSEIPtHf4Ywscnn57Rvf6nJ86oSSJWMJUCxSkA
         UPZFciHiCO3GcFRBPleRFOOhmsUSVkle5WhM2KoIh17l0ykznM1fDMlrAZM5ynx8+FdA
         WTqzLi/fL9SM7wa7SSWCvmCNcT9UOS2Zk9tTRh0TlD2bfIo6Mw+r9V2UtCeb76+vSQ9R
         /VQtLktymhiyTKom9tIQH2aLM15ekHJRapBtIuKy8GbM10b/AOzQl0qKKf40+L0U8ecf
         ZtLMW88LNGpGZzWgEZPITKRfOM5LlJ7SHE0/B0g3X2461VfGsCYIdikdqhXNs5sTkuGx
         lqYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYh8Xwi+JZT2OjwBKO7uD1Dy+LrL8AEp+hfraD6siU9jBQjJuWcjEninpW54Xsh+tDbkE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqSlQn0Q/bmBSuRznpD7zTE1bKIoql4/FO7r1AeF130CJUlklI
	OGOGACPZ0W3lRxJ2zMK3oMv4Ja++nWiXuv1omfs1V78j9H2q/giDnZSKxEr84Tyv/z2bm7FIzQG
	p5rjZHw==
X-Received: from pgc12.prod.google.com ([2002:a05:6a02:2f8c:b0:c70:ab5b:1dbf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1591:b0:394:5878:e1fa
 with SMTP id adf61e73a8af0-398549310cfmr272958637.6.1772730528181; Thu, 05
 Mar 2026 09:08:48 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:35 -0800
In-Reply-To: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273038139.1572110.3041089548814384743.b4-ty@google.com>
Subject: Re: [PATCH] x86/hyper-v: Validate entire GVA range for non-canonical
 addresses during PV TLB flush
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Manuel Andreas <manuel.andreas@tum.de>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 2AE75215E15
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72842-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, 19 Feb 2026 21:05:49 +0100, Manuel Andreas wrote:
> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
> allow a guest to request invalidation of portions of a virtual TLB.
> For this, the hypercall parameter includes a list of GVAs that are supposed
> to be invalidated.
> 
> Currently, only the base GVA is checked to be canonical. In reality,
> this check needs to be performed for the entire range of GVAs.
> This still enables guests running on Intel hardware to trigger a
> WARN_ONCE in the host (see prior commit below).
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] x86/hyper-v: Validate entire GVA range for non-canonical addresses during PV TLB flush
      https://github.com/kvm-x86/linux/commit/45692aa4a7ce

--
https://github.com/kvm-x86/linux/tree/next

