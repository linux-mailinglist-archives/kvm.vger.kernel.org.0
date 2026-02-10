Return-Path: <kvm+bounces-70781-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COteNf2Oi2mhWAAAu9opvQ
	(envelope-from <kvm+bounces-70781-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:03:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A0B811EDBC
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:03:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E3CAB30417B4
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F42A331226;
	Tue, 10 Feb 2026 20:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iChO9uWa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415BD239562
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770753774; cv=none; b=DyH3uq5A7dr6qEH6so3IN57vIuRuGUCPB57cN10qM4gegCB+hcM+634Kr0ZgG+2t1mAz3XgOpCKb+CciT/PahQCECfRUIbaa9dno9wlRu4nrq1+bBSRmC2HhkN8dEltN3o6pCRlr0HPihVi1aR4Ax1FqiVJXjVj0+p8I3Kr4G5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770753774; c=relaxed/simple;
	bh=1SYXPdM3M3vfEgCTCDusnEPl7C4uxKeZQM4ZhwqUDoo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TPHDu22flz1ezB+J/X1AB9XAQtqJbfXyFB3cPNrwdzMYHfhu6iAEi+xhEG4LU05bS9qYWQec/xXjqrP0SDwv/AGbcvOB1y2OZw4SheCxiiqtfeKkQn4o35dtrP/ewbGK2s50iSQudqfcSLtN+yhfKDbh3YqlMVZN7S/Kx+ROynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iChO9uWa; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c61dee98720so2897980a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770753773; x=1771358573; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AMxnwFoC86g7Xm0uspYe7BKHCLo0vPLy6IdXieZNUcM=;
        b=iChO9uWa5GoSdLcSwnVdiqXRHhqv3MDMRr3MaKBqhworME+Hf8ROjB8sbs3ZrIutiw
         zgvJtr2dRXRYprU9pc75gknOdql1Yb46wnjhyF+n4aGOqJ51/9lC8Y3NajuNwZVTGwDo
         xDeZvf3zTQQZgUkNIGjxlvHSeUaoJxPEBlHj+E2m4QbZsPDrkwma2bN1tseAQ3aYdRHb
         OLxf7w13okj5q6+hHQeRiVXJfBY1Mz/qzideFU/bCWnTKUS2boMUOUKrwtgcBMoDLYFI
         6BJKxRMDl5KQKq/R84XfB/DX/nMjx1jA5D9tpqcu8CKoh8o8IAt0YRsaxAFyZURpVOEj
         F1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770753773; x=1771358573;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AMxnwFoC86g7Xm0uspYe7BKHCLo0vPLy6IdXieZNUcM=;
        b=Pk+gytGbreLbIIhOuYdwgI0w3C4/D4CPn317je6Ire3RW/df6cK2mu8RcdtS+3Yy00
         y2HgGM80fItuflXOquMnSzmJP/t8M/BF1ayS2bxUMOsP0QJqIclMtuFmeE+PTMaU8J1d
         IeIBrgqOaOIn+vdWprL0IoXpglT/jOvj8eCshiOKFkjgmkjORgwo/XxXn45lbbbc2TGO
         wfFPzPUfYufmL0NM59z6rh7XRdOlto0V2zle0RklVWsJf6tsS4Is/xmjN7SblBDLI1By
         TDCqACWp6YGYVc0lGGR7oL2atcaX6oiHJ6QUes/brBcb2XYvziv+PfBaKpPvop2hUx5V
         BU3g==
X-Forwarded-Encrypted: i=1; AJvYcCXGBkZb8i1iBjW3JV1K3AzJ+DFPRDU2IPh+AclVI82Qk6lWp1+7nHQZjtwMQWtbu7nq/xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJzxHP4OS684AqwXyl2QO6JY/iKihDLSNaYozNJDhcN1mGR/Dp
	hV3TK7aYkW0TeipFjO2ICFIUpatf6g+tmgBnHY102uAIHQY6DKbXxxwrmH1hxEqMFFuOHLoBPyn
	JQA55Gg==
X-Received: from pghg12.prod.google.com ([2002:a63:e60c:0:b0:c6d:ce5b:b37f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a42:b0:38f:86c0:44c
 with SMTP id adf61e73a8af0-3942e6d5ab5mr282050637.73.1770753772651; Tue, 10
 Feb 2026 12:02:52 -0800 (PST)
Date: Tue, 10 Feb 2026 12:02:51 -0800
In-Reply-To: <65765e72-fce0-48ed-ab95-af2736a562cd@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260209041305.64906-1-zhiquan_li@163.com> <20260209041305.64906-6-zhiquan_li@163.com>
 <aYoOHzwgxvpZ5Iso@google.com> <65765e72-fce0-48ed-ab95-af2736a562cd@163.com>
Message-ID: <aYuO673vMcZ-DJ7m@google.com>
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
	TAGGED_FROM(0.00)[bounces-70781-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 7A0B811EDBC
X-Rspamd-Action: no action

On Tue, Feb 10, 2026, Zhiquan Li wrote:
>=20
> On 2/10/26 00:41, Sean Christopherson wrote:
> > On Mon, Feb 09, 2026, Zhiquan Li wrote:
> >> Therefore, the expectation of writing MSR_TSC_AUX reserved bits on Hyg=
on
> >> CPUs should be:
> >> 1) either RDTSCP or RDPID is supported case, and both are supported
> >>    case, expect success and a truncated value, not #GP.
> >> 2) neither RDTSCP nor RDPID is supported, expect #GP.
> >=20
> > That's how Intel and AMD behave as well.  I don't understand why there =
needs to
> > be a big pile of special case code for Hygon.  Presumably just fixup_rd=
msr_val()
> > needs to be changed?
> >=20
>=20
> Currently the conditions cannot cover the case that the host *only* suppo=
rts
> RDTSCP but not support RDPID, like Hygon CPU.  Let me give more details f=
or this
> test failure.
>=20
> When testing the case MSR_TEST2(MSR_TSC_AUX, 0x12345678, u64_val, RDPID,
> RDTSCP), the cupid bit for RDPID (as feature) of vCPU 0 and vCPU1 will be
> removed because host is not supported it, but please note RDTSCP (as feat=
ure2)
> is supported.  Therefore, the preceding condition =E2=80=9C!this_cpu_has(=
msr->feature)=E2=80=9D
> here is true and then the test run into the first branch.  Because the fe=
ature2
> RDTSCP is supported, writing reserved bits (that is, guest_test_reserved_=
val())
> will succeed, unfortunately, the expectation for the first branch is #GP.
>=20
> The check to fixup_rdmsr_val() is too late, since the preceding condition
> already leads to the test run into the wrong branch.
>=20
> The test can be passed on AMD CPU is because RDPID is usually supported b=
y host,
> the cupid bit for RDPID of vCPU 0 and vCPU1 can be kept, then fixup_rdmsr=
_val()
> can drive it to the second branch.  Theoretically, the failure also can b=
e
> reproduced on some old AMD CPUs which only support RDTSCP, it=E2=80=99s h=
ard to find
> such an old machine to confirm it, but I suppose this case can be covered=
 by
> slight changes based on this patch.
>=20
> Intel CPU no such failure, because writing MSR_TSC_AUX reserved bits resu=
lts in
> #GP is expected behavior.

Gah, I think I tested -rdpid and -rdtscp in a VM on Intel, but not AMD.  I =
think
the fix is just this:

diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/se=
lftests/kvm/x86/msrs_test.c
index 40d918aedce6..ebd900e713c1 100644
--- a/tools/testing/selftests/kvm/x86/msrs_test.c
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -175,7 +175,7 @@ void guest_test_reserved_val(const struct kvm_msr *msr)
         * If the CPU will truncate the written value (e.g. SYSENTER on AMD=
),
         * expect success and a truncated value, not #GP.
         */
-       if (!this_cpu_has(msr->feature) ||
+       if ((!this_cpu_has(msr->feature) && !this_cpu_has(msr->feature2)) |=
|
            msr->rsvd_val =3D=3D fixup_rdmsr_val(msr->index, msr->rsvd_val)=
) {
                u8 vec =3D wrmsr_safe(msr->index, msr->rsvd_val);

