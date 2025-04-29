Return-Path: <kvm+bounces-44818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6316EAA183E
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 19:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA3D0189420F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:57:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23F7425485A;
	Tue, 29 Apr 2025 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vxjWBXUF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1797252284
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 17:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949378; cv=none; b=guuwglYjGN858P5eSbapxTFFxkvltxqG1WpTmJ/cprH8XoOg3RS4evPcdSRccMSmjA0EayAtPSgzgNq+uoZ2RH3utiP+VzlEfQlPs6wcqK87dPweqjEwiRluiQpCJS59F8WoPhDKTlJ7anwNElOIuLTqmZNrqRL0V1Ignii/4/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949378; c=relaxed/simple;
	bh=ph+g2Jh/sq1TGFV/Nx1F+Xyzn4ZsoCmnSsJ+oPMv5Bc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HkXgLS3H84/vEOVzebgEmtQOHxvZDh7qoErAMn03eSCiZE2k5sdeK4F3a6ALOd2LFrpD+mqR/jhvXPNPRtBu9iSNZsyB/loMgn1Ux6JrC0LmpAfgCxq5cCURc6Jg7FWTLOmJYuOqQ0e2IfpvWMLuBzOfkQoP63RXCzj/bdmYO88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vxjWBXUF; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b1415cba951so3753473a12.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 10:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745949376; x=1746554176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xyFfFtiA1BeLFtm4CsqWApY7h/Z3g9TMtoFu5940vNU=;
        b=vxjWBXUFSHnCESSJG+LyrlsYgWnpKTelEYph7ANtL0k1CbOhIb2ABee2na+3GARJyG
         eLmyB2AmYs+H2hCGxwTETBSjPa0pjUnUywmBxVHKKGKBNEVGiHhbwLfK2crA36R10gdK
         kSzjQqo21cjLZ3xyHBZZNB5qqQYqdkNm/BWuNtxacJGVFKKZ78WRSH7kyBJhcAq2b0VG
         7Szq4W8h1doNk8+qMyOGMhlMeDPzhozR6GPlPkKorG9ucAEUM86asXAKQ52HUl46d9+B
         fCFCg4V709r3RekGsKWZhpfa8VCiaUcQ4o2gqma5dKMtU6oPMe9+LtypdW96c8VITVHn
         JazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745949376; x=1746554176;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xyFfFtiA1BeLFtm4CsqWApY7h/Z3g9TMtoFu5940vNU=;
        b=X8HdHfzOw1oRWMishuaxGEotV5+Ll9sA+NsiJ6g4HLL7SxiN5CpAfJesx67jDFeyWK
         7Z5U/5A4VDm+DGT2tcHZKhzq9WVks1U6mBgYaUck3y05uK21e1+sF2TcCogxCI4/RX4w
         ShStGze2uBACFyfkd+6UnZ6mVWfai44SOH7nW3dKM+sDUwWm52N7+CqKnZ3TJndzhvWe
         xkdE6WQLUDsM90C2ENtn5PhBlYbOsiSKPfgeqA+VVCCQ0Wd1hlvsw+g+Xq81WVRTAUWq
         QOc4zIEq0sIdYGvwK0V0ioX3tcNq9AfKgpigPdYGLUsnvZbkU5vzettk8MyPrfIY1mKs
         b8Dw==
X-Forwarded-Encrypted: i=1; AJvYcCUbTT72UjNsZGCdAjKRy2x6DuhT9UE3JsHldLDqWu4du0CFyWDARxnEu59/YHdXHi56pHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxD4k4hUxujjK2Nzph5PkcQaVkI+NPFrYOF1G9DRND/zL+Ajzf7
	J95V1tCka5X4IcRkQSOCTwi1zfHtZa+h5s0aY1FGb1rP9kgxCoumD3FF/mc6S5ILwLHwbJRcqu9
	Dlw==
X-Google-Smtp-Source: AGHT+IG7NdYNlJNG8mcIdj3QypCXKP9cdI9GdOCwptPwZSGqNmvYFRPYVWtRwguCO11JWojVTG5Jt542KZI=
X-Received: from plog16.prod.google.com ([2002:a17:902:8690:b0:22c:31a0:b350])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a2c:b0:223:47d9:1964
 with SMTP id d9443c01a7336-22df35879f8mr4176195ad.34.1745949376119; Tue, 29
 Apr 2025 10:56:16 -0700 (PDT)
Date: Tue, 29 Apr 2025 10:56:14 -0700
In-Reply-To: <926cde15-b1e2-1324-99e8-f5f07fc71ffa@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
 <aBDumDW9kWEotu0A@google.com> <db704530-e4ae-43af-8de4-bcc431f325a2@oracle.com>
 <926cde15-b1e2-1324-99e8-f5f07fc71ffa@amd.com>
Message-ID: <aBESvsREQ51B8AzJ@google.com>
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Liam Merwick <liam.merwick@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2025, Tom Lendacky wrote:
> On 4/29/25 11:31, Liam Merwick wrote:
> > On 29/04/2025 16:22, Sean Christopherson wrote:
> >> On Mon, Apr 28, 2025, Tom Lendacky wrote:
> >>> @@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
> >>> =C2=A0 -=C2=A0=C2=A0=C2=A0 nbits =3D sizeof(ghcb->save.valid_bitmap) =
* 8;
> >>> +=C2=A0=C2=A0=C2=A0 nbits =3D sizeof(svm->sev_es.valid_bitmap) * 8;
> >>
> >> I'm planning on adding this comment to explain the use of KVM's
> >> snapshot.=C2=A0 Please
> >> holler if it's wrong/misleading in any way.
> >>
> >> =C2=A0=C2=A0=C2=A0=C2=A0/*
> >> =C2=A0=C2=A0=C2=A0=C2=A0 * Print KVM's snapshot of the GHCB that was (=
unsuccessfully) used to
> >> =C2=A0=C2=A0=C2=A0=C2=A0 * handle the exit.=C2=A0 If the guest has sin=
ce modified the GHCB itself,
> >> =C2=A0=C2=A0=C2=A0=C2=A0 * dumping the raw GHCB won't help debug why K=
VM was unable to handle
> >> =C2=A0=C2=A0=C2=A0=C2=A0 * the VMGEXIT that KVM observed.
> >> =C2=A0=C2=A0=C2=A0=C2=A0 */
> >>
> >>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pr_err("GHCB (GPA=3D%016llx):\n", svm-=
>vmcb->control.ghcb_gpa);
> >=20
> > Would printing "GHCB snapshot (GPA=3D ...." here instead of just "GHCB =
(GPA=3D
> > ..."
> > help gently remind people just looking at the debug output of this too?
>=20
> Except the GPA is that of the actual GHCB. And the values being printed
> are the actual values sent by the guest and being used by KVM at the time
> the GHCB was read. So I'm not sure if that would clear things up at all.

I personally like the "snapshot" addendum.  Yes, the GPA is the GPA of the =
GHCB,
but it also the GPA from which the snapshot was obtained.  Ditto for the va=
lues.

For folks that aren't aware that KVM operates on a snapshot of the GHCB, th=
ey
could end up really confused if they somehow have access to the raw GHCB, e=
.g.
from the guest side or something.

