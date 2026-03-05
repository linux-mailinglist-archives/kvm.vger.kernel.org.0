Return-Path: <kvm+bounces-72838-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0MboFsC4qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72838-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B12B0215E24
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F7AE3112B24
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D473DFC91;
	Thu,  5 Mar 2026 17:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iMsJLNr7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ACA366835
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772730495; cv=none; b=bWNhM/Tq4czztZWtd+OKibKgiT/YlIHvbuAubuPWU+kBcWoFGTE9kCh3H9F4N4E6tWnPSPbUaxeSlG5StII64joLBTIqs7U4mxyuLvZkMyzl6XcLwlXjhmJkOA3820vOzVteRT1HEdVYxIXh8++r/WeAd7GfJDP/wOtfh+6VJxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772730495; c=relaxed/simple;
	bh=44Wf9yR+9fDTpGBd7gaALr0VRFJXcbdH1Kh7ijRReg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V9gPIKu41tFTVFiIypL3VvI+9aHnO4Ke2DogKWriAZ50rRsanYRsxHKOTGCNU2NPEXJ01URAu4Bxm3suxe9Yn5r64NNGtgPzjY8owdnDANJangD8iM1UzzvVNdZ06lHJsOc2w1uHfGWEtcuvo9jHf0GpRkQ9AEHX66xJhYwaG5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iMsJLNr7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso6573569a12.1
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 09:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772730493; x=1773335293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1AxBmwvv5FcFM26s9KrWq4WE50z12Fbkxw/Cz6Wssdg=;
        b=iMsJLNr7+3jUV4wRnDStGhYM7Y/lIVq8paBzeUQpzQV0B9vhHtRmrtAH2q0d9NMWX9
         OqwxTrciSG1zX/lqOTjfQxQ9HwfF7IPZSgKHyZa0SNwzEJGbWmCPiPk+FKjjpAKhRUi8
         vK0jqxzOa6KNdr9OF4JatsFyRwf0cjg5oN4y7FGnni/n0SfLanWRwxsXSQnaCm4KfSsQ
         Tj47thEsl1XbE67j9E8XydWMq1fIrqbIJknzPJWUlRjbyXBuXhTIGZbLvgHVuevVOQVY
         GaeCrxBgLCUjWgNuemDIf528zOb2osCwas13NUuGgpsV1cSk3nHPTqvod1w9B1NTiNF+
         q2QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772730493; x=1773335293;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1AxBmwvv5FcFM26s9KrWq4WE50z12Fbkxw/Cz6Wssdg=;
        b=RAwZsjf0vd4k6hZo/VwPkB+Cba5hAhg3alCSthUaVBTfaKjsh4P93hKaGHmpHQGTfP
         DraxGBDPWPftOxkwEz2B0wW7MlMcoqn25PcBAOHCloKHOhY0QHEUVvXJ9RbXqdx7Eaq8
         2yz6wzlC63ra5HLSZYRuW6sD502bBGSfE9Z3/GEHj04zAS4sKP/zLmnzIhw8/Iif6h60
         bhEnO9C2wB7hDW6cpFwfXKEFmMcKM47vuM+9qweMqSiQwMnPjL845Qjro0ifO/uPvVqg
         +ai5xD5w85/0B7ISq4ZODOW/ynrdJOp+MW5LkHis7pG7g29pdZVl3Nd0LfkPyiZMi0zJ
         gLuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWApBrg6khU2SET5Luwkx+xG2hEBM/ygD6Cs5Amesy3Vdko2pvItowmaw3QlZue8RIkQG8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/Qg7h7Z50Q1PaQbDjNgwiFU2mZnBtlz12+mXe36eWxNdZ6SyQ
	av0TzG+fz9hzZHk6OIuI3V6X4jXd/ZNn7AcXXgA45b9BLGi1FL3ROKMvG9wprM/4BKCJ0/B089e
	veAxhsQ==
X-Received: from pgq25.prod.google.com ([2002:a63:1059:0:b0:c73:7970:8223])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3a42:b0:395:151c:4eda
 with SMTP id adf61e73a8af0-3982e19b424mr6273616637.45.1772730492955; Thu, 05
 Mar 2026 09:08:12 -0800 (PST)
Date: Thu,  5 Mar 2026 09:07:27 -0800
In-Reply-To: <20260209153108.70667-2-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209153108.70667-2-clopez@suse.de>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <177273040463.1572329.15040370332161552034.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: synthesize CPUID bits only if CPU capability
 is set
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, bp@alien8.de, kvm@vger.kernel.org, 
	"=?UTF-8?q?Carlos=20L=C3=B3pez?=" <clopez@suse.de>
Cc: linux-coco@lists.linux.dev, jmattson@google.com, binbin.wu@linux.intel.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B12B0215E24
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
	TAGGED_FROM(0.00)[bounces-72838-lists,kvm=lfdr.de];
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

On Mon, 09 Feb 2026 16:31:09 +0100, Carlos L=C3=B3pez wrote:
> KVM incorrectly synthesizes CPUID bits for KVM-only leaves, as the
> following branch in kvm_cpu_cap_init() is never taken:
>=20
>     if (leaf < NCAPINTS)
>         kvm_cpu_caps[leaf] &=3D kernel_cpu_caps[leaf];
>=20
> This means that bits set via SYNTHESIZED_F() for KVM-only leaves are
> unconditionally set. This for example can cause issues for SEV-SNP
> guests running on Family 19h CPUs, as TSA_SQ_NO and TSA_L1_NO are
> always enabled by KVM in 80000021[ECX]. When userspace issues a
> SNP_LAUNCH_UPDATE command to update the CPUID page for the guest, SNP
> firmware will explicitly reject the command if the page sets sets these
> bits on vulnerable CPUs.
>=20
> [...]

Applied to kvm-x86 fixes, thanks!

[1/1] KVM: x86: synthesize CPUID bits only if CPU capability is set
      https://github.com/kvm-x86/linux/commit/6a5028d8f9f4

--
https://github.com/kvm-x86/linux/tree/next

