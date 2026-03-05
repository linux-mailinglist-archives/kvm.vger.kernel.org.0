Return-Path: <kvm+bounces-72849-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJVgBli6qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72849-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72038215FF3
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:16:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9B7A3175AF3
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:10:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B36D3E1222;
	Thu,  5 Mar 2026 17:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="auVOJC8b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF093E3D9E
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730620; cv=none; b=nXxD/AkCQtNNVBgGaQliHTYPkzWEC5hbbtd0iX1E57gFknJfDGsymZ3gEeNrf05O9O6kLovgr0Frj2SiizjzIZ0q4qxzs4r/2HPK2D13bHNXfTPqnm/979GUg9fFbHhMywcRvctc3VVdMDHBCoYSjdZgVoYzc9LA3FSJpNA0z3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730620; c=relaxed/simple;
	bh=1dRtbSL0z2ytbckj6wSLUUOGGrIOP3G0d+3V5VkDtc8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PotqONTd89nR+ChEIXGhZjl1IHzB9OTos8tHNSjumDX/a35P0sBzPhW93gGyR/DLJoIZHKrjZtngc+dbQbmM0EVOzZT6/6Cxmo8FJHcuZzFz4h40joIb/juCU3GvGMtpG2/PxYpSFN1Zjt+usX7YsVASvzeD+0eEAq9/zxtURFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=auVOJC8b; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae3badc00dso60552705ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730619; x=1773335419; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eRREj8B726P8wv+ghDGF6Dj3pEBAyYOHAidGVCV8Tg=;
        b=auVOJC8bHck87F4HM5e5x+TetsKim1cdkekP0YETd7F27R0c6M083u01Ai2XRYT4+d
         9ZoWZpQpjElS959Suf0p0jI0D4nr+Jjxw1uSKFJJLd5v0Qe9DP6bWdaTm8fwaU/fZDgz
         Bl5sdMyeIl7UEdMU2EEAbohnNHQz0ifeIqT3oPQ3keHGLpN1qJMH4jazTB9jqMtHofhY
         G+8aYz0RIVftVvyot68kFaNeMMKtop2AHsnir5+W31i9F8DwZdCqun6IKie1H+fYLKyU
         hWiiuSdAxjP/FcRSxlafvtMrhsKLWw9R00ThpQBBmVg3CmZ3m9ldDNyItLeydbX/AXBs
         y6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730619; x=1773335419;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5eRREj8B726P8wv+ghDGF6Dj3pEBAyYOHAidGVCV8Tg=;
        b=Emv+C6To34rlZsYkDd6P4EDpP1lrRWBbh/vs08qvKy6BMjfhl6vqI3ggN1v/zgAAPP
         8aR5H+B0RKQ0bpLygqrJAkDcAqPh7w0FV7EpdkuXDhJm2csx2zLO7+23DbCOLwtw7v9Y
         vmKllNZ/XEW1jS/n6PLwr2zVR8ZT3Ev+hApqMn5oh4QF6jG3pOKRLYYMU7X9K+v3RSI7
         SuNHpF46C2ooGoD5+pjAow8407ih90lnqKNqDktAu57iAfl1GFmnpbu4GQsJHaN6yByr
         TKufUux9jza8AVUBjbjHojI8DSmBRQZzWTtACnY2oSBJ4bojsOwzV9DbHMsPIgz7a30o
         LyTA==
X-Forwarded-Encrypted: i=1; AJvYcCU18B2LJfZWRg6t78SKdcqwXsioqIMZ8UB3JbHQbeWSAou/yMSxHzTxC5n238H/P47q7Pk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx06i4MVYSjWlBatxSeYX6Qoz9kwKzmamrNSe1DoHKYRFZJvcAS
	3jvLHXLoMwxYpTiIj6zwzKpiP5+XlMfwfZIMyrYCyQRK0YhkmIUQjpJs4QBTQYoCLioan19j/2D
	QWRV4yg==
X-Received: from pllg11.prod.google.com ([2002:a17:902:740b:b0:2ae:3fb2:f203])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e947:b0:2aa:e3c2:f920
 with SMTP id d9443c01a7336-2ae6ab0f5a7mr70937115ad.36.1772730618593; Thu, 05
 Mar 2026 09:10:18 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:47 -0800
In-Reply-To: <20260212140556.3883030-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260212140556.3883030-2-clopez@suse.de>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177272956967.1565536.690492075978150495.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: annotate struct kvm_x86_pmu_event_filter
 with __counted_by()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, pbonzini@redhat.com, 
	"=?UTF-8?q?Carlos=20L=C3=B3pez?=" <clopez@suse.de>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72038215FF3
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
	TAGGED_FROM(0.00)[bounces-72849-lists,kvm=lfdr.de];
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

On Thu, 12 Feb 2026 15:05:56 +0100, Carlos L=C3=B3pez wrote:
> struct kvm_x86_pmu_event_filter has a flexible array member, so annotate
> it with the field that describes the amount of entries in such array.
> Opportunistically replace the open-coded array size calculation with
> flex_array_size() when copying the array portion of the struct from
> userspace.
>=20
>=20
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86/pmu: annotate struct kvm_x86_pmu_event_filter with __counted=
_by()
      https://github.com/kvm-x86/linux/commit/c522ac04ba9d

--
https://github.com/kvm-x86/linux/tree/next

