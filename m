Return-Path: <kvm+bounces-70871-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MNKBHOytjGl/sAAAu9opvQ
	(envelope-from <kvm+bounces-70871-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:27:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0735912617F
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:27:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9D628302F3BD
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666AA33F8C2;
	Wed, 11 Feb 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uuRlaxl5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C70133A9DF
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770827188; cv=none; b=s27bcqZDPV0ptlllWk1o/S39v77eFxbmUfTBAb/ikoeNW1GHhG9qIKJFh1KiJvOTUTTzWchjI1DlWUKOAiws6rI3Ccie3D/XHzoWhe1vxZS2pnuUK1jHeTQ6ugXb0PDhKpm5q+MvIFenz31KKyXumx5nm/eyfD5cMUGJYUmx5fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770827188; c=relaxed/simple;
	bh=QIUgdplTX9FeLykL3XX+1apXjFaIxvWy6awsPERQYeU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oy6zt5YAt9BYg8/6b5HQ8mhgZlZXPFtCFASUFIm0XWiojhCYNzOOh88KLKIwn2TGN6Hx743D5omlUVxFFkwMbqOBy8QE4dP9b9kCldV8pKj75oZUfbuDMtHBkNzIuQD6YpgSdN3lBUvuj7t2tHzXP9d6tz+3IL+9KKCNpRuhn0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uuRlaxl5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a8c273332cso172637955ad.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 08:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770827187; x=1771431987; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jZ/jbuv2cJCfGshCIenTd+0KJACRJkkS3H39sEGYyCo=;
        b=uuRlaxl5Yo8W4Q5AOvc7XPcmMDCtTPsKyNRSuAjNs+SYbbSrJ1fy6W4HWc0OmXivSf
         Fe75UB5WMyETaCRnUHbvfy93kRs98M+R4Z21jYWXz9xsSyW9tx3TMM+jIH0sHPbFagoR
         bqY4p2Pz0AWCWBlrc0g+khMQ63zBDn5CkcU2KuJ7BTV7WIc3SVyKs8BjmlSyCrrSoN66
         /epnJbg2KG5CopbpITGfMF8SDgz2KQC8aPcNN3F7TQU0pHuzrFYhJJM7uez+93lO1R8n
         P0pngxIC0PKshWHJADqntkGxvP8bAz3tfsNts/8MV/0cefkJBgTm/QNESdT42vkzGLVJ
         NKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770827187; x=1771431987;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jZ/jbuv2cJCfGshCIenTd+0KJACRJkkS3H39sEGYyCo=;
        b=mL1eTKMKPlO1moqBIvqsEjrs6wb2WuLm7vf+GWXDFtSoDSsVZwTN0Tv5qJOSYdUtWH
         exdbhgMvX6gWZtozo/UPYH+Wv4JEgJl6Zj5ehz84VaasvW0b3KrR7VbLm0VtRPQDSwb9
         KE3O5Dtf2/NjZ2kPuujYbs+v5HBC7oiN7dvvl3RRkg6kXeCl+8kaJUS1wCxFIkc8GVT4
         FSZEGPWWK5/Jlf8qJUlFftRd6SxelaPAPeKDIzH8Flf202VqRuysrC9e1hTNjE6aDuEs
         GeuRj3e8IRFmCtRZtByd6TyJoQMtgxTyHjN3Cmir7bHOeKLB3MFw8iv/cxgZBfWq8rx2
         dLMA==
X-Forwarded-Encrypted: i=1; AJvYcCWuyYN/VTBSJUzjnzE0KaCzManqsPBL1uW72GjRf60wSXGp1Jh9rcP1D0avILp216Kq560=@vger.kernel.org
X-Gm-Message-State: AOJu0YxS46i3I9EOR+iT9yKh2XfEvQGpmynBEUy4SlMPByWOqvuxqTY+
	sUy2hoZ0QpKRtwu0hcRMqWdIAk8RH04Z11fha5oigfM1ZOCdJ47LRqcwjQ0xjC2UWXlAzBYUuFW
	14tUIJQ==
X-Received: from plrq7.prod.google.com ([2002:a17:902:b107:b0:2a8:2677:6e7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b46:b0:2aa:f43d:7c42
 with SMTP id d9443c01a7336-2ab27d13dd8mr27085085ad.24.1770827186712; Wed, 11
 Feb 2026 08:26:26 -0800 (PST)
Date: Wed, 11 Feb 2026 08:26:25 -0800
In-Reply-To: <3088af31-7ef8-45f3-9e0c-c51274ab9ca0@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209041305.64906-1-zhiquan_li@163.com> <20260209041305.64906-6-zhiquan_li@163.com>
 <aYoOHzwgxvpZ5Iso@google.com> <65765e72-fce0-48ed-ab95-af2736a562cd@163.com>
 <aYuO673vMcZ-DJ7m@google.com> <3088af31-7ef8-45f3-9e0c-c51274ab9ca0@163.com>
Message-ID: <aYytsW06SZ6d2Iqu@google.com>
Subject: Re: [PATCH RESEND 5/5] KVM: x86: selftests: Fix write MSR_TSC_AUX
 reserved bits test failure on Hygon
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70871-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0735912617F
X-Rspamd-Action: no action

On Wed, Feb 11, 2026, Zhiquan Li wrote:
>=20
> On 2/11/26 04:02, Sean Christopherson wrote:
> > Gah, I think I tested -rdpid and -rdtscp in a VM on Intel, but not AMD.=
  I think
> > the fix is just this:
> >=20
> > diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testin=
g/
> > selftests/kvm/x86/msrs_test.c
> > index 40d918aedce6..ebd900e713c1 100644
> > --- a/tools/testing/selftests/kvm/x86/msrs_test.c
> > +++ b/tools/testing/selftests/kvm/x86/msrs_test.c
> > @@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *=
msr)
> >          * If the CPU will truncate the written value (e.g. SYSENTER on=
 AMD),
> >          * expect success and a truncated value, not #GP.
> >          */
> > - if (!this_cpu_has(msr->feature) ||
> > + if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
> >             msr->rsvd_val =3D=3D fixup_rdmsr_val(msr->index, msr->rsvd_=
val)) {
> >                 u8 vec =3D wrmsr_safe(msr->index, msr->rsvd_val);
>=20
> Perfect!  You found the root cause and fixed it.
> I=E2=80=99ve verified the fix on Hygon platform, I will test it on Intel =
and AMD
> platforms as well to make sure there is no regression.
> I=E2=80=99m going to include the you fix in the V2 series.  Since my modi=
fications are
> totally miss the point, I will remove my SoB and only add my =E2=80=9CRep=
orted-by:=E2=80=9D tag,
> I suppose the SoB position would be wait for you, Sean :-)

Nice!  Here's a full patch for v2.

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Feb 2026 08:18:47 -0800
Subject: [PATCH] KVM: selftests: Fix reserved value WRMSR testcase for
 multi-feature MSRs

When determining whether or not a WRMSR with reserved bits will #GP or
succeed due to the WRMSR not existing per the guest virtual CPU model,
expect failure if and only if _all_ features associated with the MSR are
unsupported.  Checking only the primary feature results in false failures
when running on AMD and Hygon CPUs with only one of RDPID or RDTSCP, as
AMD/Hygon CPUs ignore MSR_TSC_AUX[63:32], i.e. don't treat the bits as
reserved, and so #GP only if the MSR is unsupported.

Fixes: 9c38ddb3df94 ("KVM: selftests: Add an MSR test to exercise guest/hos=
t and read/write")
Reported-by: Zhiquan Li <zhiquan_li@163.com>
Closes: https://lore.kernel.org/all/20260209041305.64906-6-zhiquan_li@163.c=
om
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86/msrs_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/se=
lftests/kvm/x86/msrs_test.c
index 40d918aedce6..ebd900e713c1 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
 	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
 	 * expect success and a truncated value, not #GP.
 	 */
-	if (!this_cpu_has(msr->feature) ||
+	if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) ||
 	    msr->rsvd_val =3D=3D fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
 		u8 vec =3D wrmsr_safe(msr->index, msr->rsvd_val);
=20

base-commit: e944fe2c09f405a2e2d147145c9b470084bc4c9a
--

