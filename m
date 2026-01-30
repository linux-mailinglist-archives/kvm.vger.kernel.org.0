Return-Path: <kvm+bounces-69754-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iOJEI7hBfWnIRAIAu9opvQ
	(envelope-from <kvm+bounces-69754-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:41:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06615BF6A4
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 00:41:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF7583044A6C
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 23:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC4C38B7CC;
	Fri, 30 Jan 2026 23:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bdhKGfMb"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC338B7AF
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 23:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769816475; cv=none; b=Q2CyT5vcorzd9UkQUS6mLVWsi+ZqmQz1+QjR375IgxoN8E9pFGUauK2nypWkZ0trrfGkngFa9rLvWgdlz5OUnukUw6gON1STVgtlnDpQpwpBYaVSlnWDmNTSXM622qQWvmBVMLoz3BK0wnAFcdXDasSBoRiXTxhmEHU8qfNwlmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769816475; c=relaxed/simple;
	bh=sjEk3TNeLajzzMu2roobSM1Lysd4xZm84U7ALS4yEYo=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=EhjLTtEgfciU/J1AU75U3Pczj6ItCR1dsY0rEufm+iIQI7Cy5dChqzE9fTCHNQMNiXj35HQm7l+qZVGO71X+qb3zcIi5dE5Nep3Q+OTTWTjK8wP61cXbko6OUee5pX0WYU1HWbYDZwFDNnCo8QZ7WRN6P/JBw+CnV4IzLAYQJ1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bdhKGfMb; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769816461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rdV3c1Fyzq4IlYNKQBXCQedx51D+jPJbav/kuos7rKg=;
	b=bdhKGfMbLEAp141OqyQbTTjCDrK5xlEum6gt+A3cEpBK7fa1aWl20fPp8gK8WZmU+rWVUm
	95GXDzGf9Po58HwDtkmUn26A7A+D5AK3fLzMIZ+aKNgyL1NQ7512oQsWEe/MhfklOnIHHH
	//NVon3hdD9EO9BCh90/NTo4dzeNcZQ=
Date: Fri, 30 Jan 2026 23:40:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yosry Ahmed" <yosry.ahmed@linux.dev>
Message-ID: <626dbe6541266f61e8b505202cf49c94c4fee12e@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only
 eventsel at nested transitions
To: "Jim Mattson" <jmattson@google.com>
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar"
 <mingo@redhat.com>, "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Alexander Shishkin"
 <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>,
 "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter
 Anvin" <hpa@zytor.com>, "Sean Christopherson" <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Shuah Khan" <shuah@kernel.org>,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, mizhang@google.com,
 sandipan.das@amd.com
In-Reply-To: <CALMp9eS7Za_vFdh8YBzycV2g87gZ9uj_S1MOYrgJ1+ShwVVWZw@mail.gmail.com>
References: <20260129232835.3710773-1-jmattson@google.com>
 <20260129232835.3710773-4-jmattson@google.com>
 <zzgnirkreq5r57favstiuxuc66ep3npassqgcymntrttgttt3c@g4pi4l2bvi6q>
 <CALMp9eS7Za_vFdh8YBzycV2g87gZ9uj_S1MOYrgJ1+ShwVVWZw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69754-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Queue-Id: 06615BF6A4
X-Rspamd-Action: no action

January 30, 2026 at 3:30 PM, "Jim Mattson" <jmattson@google.com> wrote:


>=20
>=20On Fri, Jan 30, 2026 at 7:26 AM Yosry Ahmed <yosry.ahmed@linux.dev> w=
rote:
>=20
>=20>=20
>=20> On Thu, Jan 29, 2026 at 03:28:08PM -0800, Jim Mattson wrote:
> >  Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel=
_hw for
> >  all PMCs based on the current vCPU state. This is needed because Hos=
t-Only
> >  and Guest-Only counters must be enabled/disabled at:
> >=20
>=20>  - SVME changes: When EFER.SVME is modified, counters with Guest-On=
ly bits
> >  need their hardware enable state updated.
> >=20
>=20>  - Nested transitions: When entering or leaving guest mode, Host-On=
ly
> >  counters should be disabled/enabled and Guest-Only counters should b=
e
> >  enabled/disabled accordingly.
> >=20
>=20>  Introduce svm_enter_guest_mode() and svm_leave_guest_mode() wrappe=
rs that
> >  call enter_guest_mode()/leave_guest_mode() followed by the PMU refre=
sh,
> >  ensuring the PMU state stays synchronized with guest mode transition=
s.
> >=20
>=20>  Signed-off-by: Jim Mattson <jmattson@google.com>
> >  ---
> >  arch/x86/kvm/svm/nested.c | 6 +++---
> >  arch/x86/kvm/svm/pmu.c | 12 ++++++++++++
> >  arch/x86/kvm/svm/svm.c | 2 ++
> >  arch/x86/kvm/svm/svm.h | 17 +++++++++++++++++
> >  4 files changed, 34 insertions(+), 3 deletions(-)
> >=20
>=20>  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> >  index de90b104a0dd..a7d1901f256b 100644
> >  --- a/arch/x86/kvm/svm/nested.c
> >  +++ b/arch/x86/kvm/svm/nested.c
> >  @@ -757,7 +757,7 @@ static void nested_vmcb02_prepare_control(struct=
 vcpu_svm *svm,
> >  nested_svm_transition_tlb_flush(vcpu);
> >=20
>=20>  /* Enter Guest-Mode */
> >  - enter_guest_mode(vcpu);
> >  + svm_enter_guest_mode(vcpu);
> >=20
>=20>  FWIW, I think this name is a bit confusing because we also have
> >  enter_svm_guest_mode(). So we end up with:
> >=20
>=20>  enter_svm_guest_mode() -> nested_vmcb02_prepare_control() ->
> >  svm_enter_guest_mode() -> enter_guest_mode()
> >=20
>=20>  I actually have another proposed change [1] that moves
> >  enter_guest_mode() directly into enter_svm_guest_mode(), so the sequ=
ence
> >  would end up being:
> >=20
>=20>  enter_svm_guest_mode() -> svm_enter_guest_mode() -> enter_guest_mo=
de()
> >=20
>=20Yes, that is confusing. What if I renamed the existing function to
> something like svm_nested_switch_to_vmcb02()?
>=20
>=20Alternatively, I could go back to introducing a new PMU_OP, call it
> from {enter,leave}_guest_mode(), and drop the wrappers.

We could just call amd_pmu_refresh_host_guest_eventsel_hw() every time we=
 call enter_guest_mode() and leave_guest_mode(), which is more error-pron=
e but there's already other things in that category.

We could also call it from svm_switch_vmcb(), which will add some calls t=
o extra places but I assume that would be fine?

I personally prefer the former tbh, as it's otherwise easy to miss.

>=20
>=20>=20
>=20> [1] https://lore.kernel.org/kvm/20260115011312.3675857-9-yosry.ahme=
d@linux.dev/
> >
>

