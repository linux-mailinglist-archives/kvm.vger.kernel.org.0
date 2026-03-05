Return-Path: <kvm+bounces-72872-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yP8KCui7qWlzDgEAu9opvQ
	(envelope-from <kvm+bounces-72872-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 24622216180
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A99FF3078BFD
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D4803E3DB6;
	Thu,  5 Mar 2026 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NorUlszs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69E23E120B
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730802; cv=none; b=dbUGqJiCU4vGkh2cirsoZV9TzZeTcMxGdFFRwYeUU2Y+ZVUDDM/i6eNbiWqIp9zgEjUzeB5G5G+xlumpnSQBdgnfHeL3nFHAPaqi1dwZvY6qieHqoIVRnB1KtquoPVM14qxl3r7iMSnqYxFfiU0P2f4f13BwMj6CmSG1zxnXiSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730802; c=relaxed/simple;
	bh=fMg0n0yfbUcjCq2WXJ12VLxC4xVgCD0dXmuCJg5xsmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=CL/OY10l1j5TwgVWpO8+vRv7ev6LPcpSTC3+eEXr154PsH1gCwzwlRTuSU1SVG8HEYtYi0iJ08duQ8fUQGwvAOs7yQPN+QzznQvZM0ITDs8NxSJ2hSn6GkSqsxbudOkYtEfyXdtnSFMtT8tBX6oMEiFOAj4RnLo/yU/ToxLzNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NorUlszs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae50463ba8so216240815ad.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730801; x=1773335601; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mFF3CQC2zt79rAdSdARW6+6MFl6Yyi4CBTT5nYj4UHI=;
        b=NorUlszsCC4iuvR36S3dKWoH5bfOCGt8XolDxpO6l8V5K7jbniiF6Rm+2Q4IJZrwiR
         H2ya27B6gcsGohBoT+DiNW2+wWGrOvclaPJ3tX/h8fWa7mm1coklDgw+deRb7pX1Rgou
         TgZBZYSEO11BJeaIdZ6yeY1/K799g+yZKbwmWs0kFRZaqEoIG+mJkzgg6Y8s1+5xQWsk
         HaiA+iRlnA8W0MyivvhPZaA7hRc/VQy04o46+ypunRTzcacL0Tr54ausBu4PTy7acD6d
         l5zBesudQv5SZ5uhrowFEFsDc9BV2Rk2ccXoylQeYjL3VnpElIzxWslcO1xXAC8LYtwO
         vPIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730801; x=1773335601;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mFF3CQC2zt79rAdSdARW6+6MFl6Yyi4CBTT5nYj4UHI=;
        b=cHoUWuHDemu0AwGC4OILOFF4RnXocdEG502fpfFGJHRimEIvIHkYBW+e78jlqy3LYt
         TCEAQ8gKeVGdslYAPPxBQwSduSjZymvUrigrAZpe0zsuJ1CViLt29VgVKENIsuelOo2C
         LseMnfXrKskG/y5ZbjGoyWZ1UrGwAUEbqMunPk4bnC687T+0TvSI+3Ebe8TXjeq3pzyt
         HyGKlROGFmCH92rtJNFK2tRAEJsfkTjEzn6Bl7wT2pwazGk/0+VcwtvwYaIFxZrx8HFz
         XZ3cOqSte0LT06n5bFU5WOpcZhwykm99KRah6IAo0AHzPNvzm7R8WE7Shi5yytRMN7gP
         O7YQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBb3nZdiCMJfrjOF0RjbJ2XgIAOMkXu1if21k87mjYSTv8esIrO6IP5jVvemyX5khOnvY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya1DZSEG2+MDbhsE4J18PfgQEHr9MKkxA8HCkumDB6bzMKds8U
	XIvnMRLjFJbeeg6O+3LOxmXB0P9ZAPOlnwLfiBo1XogwWoOhN1UQlX1OfQvB7hCNLRGZm7TpXt9
	GjWvoTQ==
X-Received: from plgs12.prod.google.com ([2002:a17:902:ea0c:b0:2ae:4a18:9c83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3850:b0:2a3:e7fe:646e
 with SMTP id d9443c01a7336-2ae8012d812mr3680185ad.5.1772730801139; Thu, 05
 Mar 2026 09:13:21 -0800 (PST)
Date: Thu,  5 Mar 2026 09:08:33 -0800
In-Reply-To: <20260202095004.1765-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260202095004.1765-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272881008.1560149.14845997844906932058.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: SVM: Mark module parameters as __ro_after_init
 for security and performance
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, lirongqing <lirongqing@baidu.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 24622216180
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72872-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On Mon, 02 Feb 2026 04:50:04 -0500, lirongqing wrote:
> SVM module parameters such as avic, sev_enabled, npt_enabled, and
> pause_filter_thresh are configured exclusively during initialization
> (via kernel command line) and remain constant throughout runtime.
> Additionally, sev_supported_vmsa_features and svm_gp_erratum_intercept,
> while not exposed as module parameters, share the same initialization
> pattern and runtime constancy.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Mark module parameters as __ro_after_init for security and performance
      https://github.com/kvm-x86/linux/commit/52de184badc4

--
https://github.com/kvm-x86/linux/tree/next

