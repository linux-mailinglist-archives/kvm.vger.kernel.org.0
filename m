Return-Path: <kvm+bounces-39185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0130CA44ED4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E184172293
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05AA520E6FB;
	Tue, 25 Feb 2025 21:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xKi0RuZ9"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCD918DB2E
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 21:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740518843; cv=none; b=i+Itt4T/s8uYgiEXCTpNczcIZeXYV1W3yphqjIZPaQuteVpEsm79Xgx7o7uQVW4LxJjzfZkSxp+162JkEmZ6QbxYpv9AvmeY3pl3ZhOzpvZlbv4h4sPI35qxVyapIuUBXnBY9cCxsczxNvWq+LdHfDC4bUpyaZv/M/LlzT9yxzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740518843; c=relaxed/simple;
	bh=4gQN0VLbJRdDl/d/jrbSsx/7k2nPEha8NL3NlC2iSMw=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=bCjhhE4NLENRnjN0jyamL3YGuFLDyPUDNnOJ+Axw1STQJ4PGgm9bqSWXs8SXaAjYlfPgi3BlKDLPe7vWobIaJGvITdFKLNHgVCe2mP/RPpdaUK39BSHu4L8g4qY1W6UEO9SNwMjvg4gZQ5B3vFBJuRS1F+gE+E74DTKRBVt1YHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xKi0RuZ9; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740518829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dhI76UpWhlnE7Yqu8JZTWQLbNYq/H0XlJSdmyeQOIak=;
	b=xKi0RuZ9ssMF9Wh1/muPoKNY22TXoTfptgS/FXcU/YvYoyVpCewsL2NZ0CQgxrk0KQ4aG7
	dWd13p8GuEBnNPCUv3c7++fd/cImesHVww0KW5+L7uC+xB4D/PSZzV5oOl2KldJpVpOpa7
	/Ndcdg+N9RfOCmBp26Y1sJr25M5wvHQ=
Date: Tue, 25 Feb 2025 21:27:06 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <59ea1984b2893be8a3a72855b022d16c67b857e9@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 4/6] x86/bugs: Use a static branch to guard IBPB on vCPU
 load
To: "Sean Christopherson" <seanjc@google.com>
Cc: x86@kernel.org, "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar"
 <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Pawan Gupta" <pawan.kumar.gupta@linux.intel.com>, "Andy Lutomirski"
 <luto@kernel.org>, "Paolo Bonzini" <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Z74exImxJpQI9iyA@google.com>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
 <20250219220826.2453186-5-yosry.ahmed@linux.dev>
 <Z74exImxJpQI9iyA@google.com>
X-Migadu-Flow: FLOW_OUT

February 25, 2025 at 11:49 AM, "Sean Christopherson" <seanjc@google.com> =
wrote:
>
> On Wed, Feb 19, 2025, Yosry Ahmed wrote:
> >=20
>=20> Instead of using X86_FEATURE_USE_IBPB to guard the IBPB execution i=
n the
> >  vCPU load path, introduce a static branch, similar to switch_mm_*_ib=
pb.=20
>=20>=20
>=20>  This makes it obvious in spectre_v2_user_select_mitigation() what
> >  exactly is being toggled, instead of the unclear X86_FEATURE_USE_IBP=
B
> >  (which will be shortly removed). It also provides more fine-grained
> >  control, making it simpler to change/add paths that control the IBPB=
 in
> >  the vCPU load path without affecting other IBPBs.
> >=20
>=20>  Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> >=20
>=20>  ---
> >=20
>=20>  arch/x86/include/asm/nospec-branch.h | 2 ++
> >  arch/x86/kernel/cpu/bugs.c | 5 +++++
> >  arch/x86/kvm/svm/svm.c | 2 +-
> >  arch/x86/kvm/vmx/vmx.c | 2 +-
> >  4 files changed, 9 insertions(+), 2 deletions(-)
> >=20
>=20>  diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/inclu=
de/asm/nospec-branch.h
> >  index 7cbb76a2434b9..a22836c5fb338 100644
> >  --- a/arch/x86/include/asm/nospec-branch.h
> >  +++ b/arch/x86/include/asm/nospec-branch.h
> >  @@ -552,6 +552,8 @@ DECLARE_STATIC_KEY_FALSE(switch_to_cond_stibp);
> >  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_ibpb);
> >=20
DECLARE_STATIC_KEY_FALSE(switch_mm_always_ibpb);
>=20>=20=20
+DECLARE_STATIC_KEY_FALSE(vcpu_load_ibpb);
>=20>=20
>=20
> How about ibpb_on_vcpu_load? To make it easy for readers to understand =
exactly
> what the knob controls.

I was trying to remain consistent with the existing static branches' name=
s, but I am fine with ibpb_on_vcpu_load if others don't object.

