Return-Path: <kvm+bounces-72857-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kC5NDWm6qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72857-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB09216001
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3F9FC304B974
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:12:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3541D3E3DB3;
	Thu,  5 Mar 2026 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QoYtIB6/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB0B3E0C54
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730694; cv=none; b=Bck69GriEKbggrKCdCYUBujJsD/vIe5y+oPAtxRjrRqhHFr1OXLATJeTphz/f67svOW9vHLRi2C1AiFHvtcLoywDWYEZVe+LIpTN0oegrKt8KwrdNhMnTn7hoAVHOK8+1ETmrP4nw7KMyXV2PtENYqMO4uX8UZIhVOcHqSfILb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730694; c=relaxed/simple;
	bh=81QSElhrAuFp0NoTuVYYfD1YTPQ8SQOwtUF5mj3cVKU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=XT2Oj3DrRPNVe4Hw4k2Bocr7t7o/nJPGlOYrkRv0rufk6g/jfRGFK0fYQaiiHI7yOW3VARZ6TbBe1B+a1Xx567Adm8mDbCAIR40V/292Ddp118qRtRBh6Vv9VCi63IDc0pyoT1s1eRv6g7mXPv0CT1F0M4+gEwv4+4PJpL1C0aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QoYtIB6/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-358e95e81aeso37548531a91.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730693; x=1773335493; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ux7LTzpSlpPBEoYOqrXHTB2itHck9XrWWXlzEMKo5oE=;
        b=QoYtIB6/0C99Hdizm7H5dRlr5n+Bl/BWidtwJNEVBgGYIpRfUyg9PwBBfKnyESk9zg
         BW4eB8bffRoRVvnNtZJNUFtCNW1ZXzrSWJtZ8v17tpWMmLdUnJAqSsQOLpiFflbLuw59
         y4nntCsGv7ANr7KQohKZ1PW0J1585PmpdVRdRdporrmvG6FaecEYHNTwfkdaRCJ0LEzs
         2wgx4KHVLSd6IJG7e7j2b8EVV8q5XaDA/qIfN26ulFYir5Vo/BotTo9FdstXkIJKVZ/y
         eqwj6Jcm09Md+PkL1uVlorI//vIi62/EM4NGjffocDvwvMmNjGKvgbqe1OS0eF5snXN5
         d0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730693; x=1773335493;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ux7LTzpSlpPBEoYOqrXHTB2itHck9XrWWXlzEMKo5oE=;
        b=eL97qnpMdFCgYz31XL33Xea6x1I++a6FJE1PBpycs1NmRMvUqrDeflW/fLg0ygSx12
         ZHt9Kky7eWXbChTlc1gbVAZFAuJYL8TyQB1m6KjfevjkXzxD/AzkNjVeBKj6JxC/TOOE
         zFb2whRhpx3GODFae6pnG/oka8uPucXsXv13FjsGJ9oHdsGPH1DAxpXsW3X6In6cGaq5
         C76nWM4hLVSN6lsxQk+cMTrHE38/+9YhS0a/3ZffZ3atyRXLSuqYKZYFvNhEzwhd/BwW
         rw8t5FrtQj7vpAc8IoOoPtmCdlRXfF8DkpjETtZQBR87/ROEfzF4pYcauflhZK4bSMm4
         kygA==
X-Forwarded-Encrypted: i=1; AJvYcCVOR3adWp0JYhNDAdXYWDzBh8c56Lla/I+A1syTxogWmm/wUrj5xdTkctyn9Z4Wz+0ZGqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK8Iqx3yWIZ/WQIdl6B/Gw22t9zzmeOPgjT0vCoe4SetdfbVDh
	0mxrqMUJVF2mesfH3CRn0YEdLI+eTWEBPfZuYD0XKJIOsVYcKkJoZ7zmt5ixW+I8PPURLpJZoQo
	jTXQ75w==
X-Received: from pjbpc11.prod.google.com ([2002:a17:90b:3b8b:b0:359:8098:e757])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5285:b0:359:8190:eede
 with SMTP id 98e67ed59e1d1-359bb39b075mr243561a91.9.1772730692749; Thu, 05
 Mar 2026 09:11:32 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:03 -0800
In-Reply-To: <20260224005500.1471972-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272547433.1535745.5957268261931442496.b4-ty@google.com>
Subject: Re: [PATCH v5 00/10] KVM: x86: nSVM: Improve PAT virtualization
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 4AB09216001
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72857-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 23 Feb 2026 16:54:38 -0800, Jim Mattson wrote:
> Currently, KVM's implementation of nested SVM treats the PAT MSR the same
> way whether or not nested NPT is enabled: L1 and L2 share a single
> PAT. However, the APM specifies that when nested NPT is enabled, the host
> (L1) and the guest (L2) should have independent PATs: hPAT for L1 and gPAT
> for L2. This patch series implements the architectural specification in
> KVM.
> 
> [...]

Applied patch 1 to kvm-x86 nested.  I'll wait for a new version for the gPAT
stuff.

[01/10] KVM: x86: SVM: Remove vmcb_is_dirty()
        https://github.com/kvm-x86/linux/commit/66b207f175f1

--
https://github.com/kvm-x86/linux/tree/next

