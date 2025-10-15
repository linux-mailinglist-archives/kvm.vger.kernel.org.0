Return-Path: <kvm+bounces-60075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1D6BDEDE0
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 15:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 712DB4FDFDC
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:56:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB10023F405;
	Wed, 15 Oct 2025 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PY8q/l2h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B11F237A4F
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760536613; cv=none; b=MSf/KuH/fKzeStI+kyVXx/xYw9mVdOUiE3gm4u/mt3hLpUewan0+SoLstl4w4Xn8+ziJiyaBl6iQ90/OPfn8ErXNg3lTib/aybqoABxn8msgbv9gAU1Mi5y+ObqWOfpP0o/o69pQdvcCTp5uJEQ6DojMEWb/PP68Km+EMAK0dwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760536613; c=relaxed/simple;
	bh=m+G0nBe9aA0EmzaSVsynqwbW9yMQCHvS5kK3vf4vtKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HO1Pp9zisjE3yKADJkF25PKncPnVLb4CvOML+wcg/kYbJsx1sShZi9Z566XLT7zHGh+JqNcCoh/qZqzo260MprajSKZwVbQHgKnD2WBlweUk2qRWhNb8sJ9TALeM+/YeecJHqKbCLEfezzBc795GivSS3OOtZnXdvyJ+yFLSajU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PY8q/l2h; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eb864fe90so17677971a91.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 06:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760536611; x=1761141411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W2aj6drJZA1MGp73i2ggdW6v3XVyKQ9+mWA2y/lZA50=;
        b=PY8q/l2h9J27Mf1NOIdEuBbU/H2R42mS1edd457Q7JwrETxj8exru3nE08z3E8mSdz
         WAzeXLY9rLbR89sjuANU+IoGhUP7CUWv0laAvo4kzyecmO5fv1ys2yBV3b4a1JvdSnwB
         dM6EUooghVb2ovte/2OauAjCHnyDeoUNMVBR2p5h1Acb8Hm+EgqsqY4vQEQ+07iWT9ck
         uX7cK/j6se2B5UpwxIY6yoeabHQonAQJyvsgURLL6UA/HNfnb1MrgBKQyjnOL/zrdlaK
         1nsoQf7fzCbI/pjdpuW42Pbz47aLwbwxXyVBMFFtNoQbliQMKzUVtV+0lp+rUwmvRQUo
         uGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760536611; x=1761141411;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=W2aj6drJZA1MGp73i2ggdW6v3XVyKQ9+mWA2y/lZA50=;
        b=H6lbdcC19Ah13oef1zL7Li0SW/1i+9s11zwBHzCbjtnuDhAlSiVaKZrI/bANcRq44V
         K9Api9Lb5LBvogBnJoc/eojh2cKavNcwFKrUX/Z5oM1rJNpeW1hfwt4wNBbU5H9skkBJ
         NfXqE9yaRQJUrqRCI77lbrdmF9HqejWIZ6f9azTw7AWywzy1hYiPffM5drS7fr/wPTYn
         PkhG/CcbxZU75RKtsYPLrmozufrnDrUnaNV9nLDzhncQ4nJY4rUwRoLPI9ENAj3spkZ7
         RJCN561btObeVNTtEwfN1t8afxu+xorS8wjmCpWHHznmAdPN+XtLjS6IgyteJLMivpMk
         XcGw==
X-Forwarded-Encrypted: i=1; AJvYcCW4Gx2cN45c5OO/F4r5pCetkMNA7g7ZESWpMcNU1VMKVskfcliW0MFQnKhyhpRImqYfjoM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRAauY4Rlw6xs/mtPTXs+SDF0l6fr/3amB5lznKecXYCMi/52i
	Vfd69R723aluiLLZvaPfU+3zq7PM08BmqAfSAOeBM4jea2w+4vurpbayNeww1njv93ZRjPpoA1M
	IdxnQVQ==
X-Google-Smtp-Source: AGHT+IFtwZ17xGbDbugz292/xL80DKNAZVcvSHiUAweJr8G4oy3wo8jT+7RGSw/1ALbZuSbxum0z/uWCHZM=
X-Received: from pjlm22.prod.google.com ([2002:a17:90a:7f96:b0:33b:9959:6452])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a87:b0:335:2d4:8b3d
 with SMTP id 98e67ed59e1d1-33b5138625emr37790699a91.31.1760536610726; Wed, 15
 Oct 2025 06:56:50 -0700 (PDT)
Date: Wed, 15 Oct 2025 06:56:49 -0700
In-Reply-To: <68eee932c6ef_2f89910045@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251014231042.1399849-1-seanjc@google.com> <68eee932c6ef_2f89910045@dwillia2-mobl4.notmuch>
Message-ID: <aO-oIRBhSIZo9mef@google.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > Note #3!  The aforementioned Trust Domain spec uses confusing pseudocde
> > that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
> > specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long=
-
> > form description explicitly states that SEAMCALL generates an exit when
> > executed in "SEAM VMX non-root operation".
>=20
> This one I am not following. Is this mixing the #UD and exit cases? The
> long form says inSEAM generates #UD and that is consistent with the
> "64-Bit Mode Exceptions" table.

I'm calling out that "inSEAM" is confusing.  It really should be "in SEAM r=
oot
operation" to eliminate ambiguity and to be consistent with how the SDM doc=
uments
VMX.  For VMX, the SDM describes three states:

  1. VMX operation
  2. VMX root operation
  3. VMX non-root operation

Where #1 is a superset that covers both #2 and #3.  The SEAMCALL pseudocode=
 is a
perfect example as it references all three in quick succession:

  IF not in VMX operation or inSMM or inSEAM or ((IA32_EFER.LMA & CS.L) =3D=
=3D 0)
            ^^^^^^^^^^^^^
    THEN #UD;
  ELSIF in VMX non-root operation
           ^^^^^^^^^^^^^^^^^^^^^^
    THEN VMexit(=E2=80=9Cbasic reason=E2=80=9D =3D SEAMCALL,
                =E2=80=9CVM exit from VMX root operation=E2=80=9D (bit 29) =
=3D 0);
                              ^^^^^^^^^^^^^^^^^^
  ELSIF CPL > 0 or IA32_SEAMRR_MASK.VALID =3D=3D 0 or =E2=80=9Cevents block=
ing by MOV-SS=E2=80=9D
    THEN #GP(0);

The same should hold true for SEAM.  E.g. earlier on, the spec explicitly s=
tates:

  The TD VMs execute in SEAM VMX non-root operation.

as well as:

  The physical address bits reserved for encoding TDX private KeyID are mea=
nt to
  be treated as reserved bits when not in SEAM operation.

Since the TD guest obviously needs to consume its private KeyID, that means=
 that
SEAM also has three states:

  1. SEAM operation
  2. SEAM VMX root operation
  3. SEAM VMX non-root operation

Where #1 is again a superset that covers both #2 and #3.

IMO, any reasonable reading of "inSEAM" is that it is talking about #1, in =
which
case the pseudocode effectively says that SEAMCALL should #UD if executed i=
n
"SEAM VMX non-root operation", but that's obviously not the case based on t=
he
statement below as well as the TDX-Module code.

Furthermore, the only transitions for"inSEAM" are that it's set to '1' by S=
EAMCALL,
and cleared to '0' by SEAMRET.  That implies that it's _not_ cleared by VM-=
Enter
from SEAM VMX root operation to SEAM VMX non-root operation, which reinforc=
es my
reading of "inSEAM =3D=3D SEAM operation".

> For exit it says: "When invoked in SEAM VMX non-root operation or legacy
> VMX non-root operation, this instruction can cause a VM exit".

