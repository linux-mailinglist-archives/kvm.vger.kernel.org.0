Return-Path: <kvm+bounces-21122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BDF92A8F7
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 20:31:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C21CD1F2188D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90084149DF7;
	Mon,  8 Jul 2024 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SUlJ9uUi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C0F15A8
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720463480; cv=none; b=SVb21CU5ILe6KDl8BkOvzk50Lf3gk0OWd4arLqhca2wgzSHJn0WMgU/uNIuJvrJCwZ26kFuPBElXIiC3JjNKA49ZNPhFleROjEgk5iKpsfeJwifN5t3SeAYqP/aczntq4mR5QN9bmI+lEqvj6ZtsJJCBRvKEiyklw7MHxmJ1m7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720463480; c=relaxed/simple;
	bh=SxTT+PkShAX+YjFzkWGn+ka0iFCwAlN5snOqK2dNfws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eXV1jSDHkWfMQadNGmRIw/nXM4CUxgqBH0hep/wzvY29KLsLRrAPAcVz6ac3Pg9yQnSOKIkHMPFZOXp8795UqieelJ5trEnHODS8wa6ucqgpvmbqbRRVUdQ6kCPoy22MGGNOAjADG0SHEQwSMRCYm0hS+SVbVGOHX3pdek/8ie8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SUlJ9uUi; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3815ad8adc9so23555ab.0
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 11:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720463478; x=1721068278; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sSRwWyccRMvOk9YUpPQqsmlSez4V4xshL0fxbbrNfYE=;
        b=SUlJ9uUi9F6DQmgsEjVViqyw20QwwsN4bkHat68uInf2vbK/DYSwGPAISRq84SsLHt
         8W2X/r7pYvmmBxNezHEt9ou5ndxyRIEFbUQ2FoRVSCTbFCD8HuAgvifkt3kcKnj0422r
         n9sas3ehdTToKVttddJKSeIyhg7ftFWiwjMt/gE6c3uf4sRmL66+nyCAipHbcu/tvMn6
         KaUYghoRiKCPxep73jw1MROBrRswOkHolu4+gnL/xFjIP6oVyydAJqfqgxZka50CICA9
         HNQCMP/u6Gu0jXuebvSzUYe2VgpxlN+5rsP+eayziN39bS4RoEsON0uA6YL8f5Vq9gtn
         kxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720463478; x=1721068278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sSRwWyccRMvOk9YUpPQqsmlSez4V4xshL0fxbbrNfYE=;
        b=OnNKRi/np1KfJjZSc/YyDEWdbGTXFH/KEcZEQ7qvl/ZCIBGVBfOUULHVK9YSXb8QUl
         ZBSWwfDPm+WHrPlXRW7OMu/2VC0CUN0p7yUleJCGpRM50Z9VH3SdNR3aVjB2KJvSDBvH
         vLQ0SlVbqAXoWQysVoebDT2uUo4OqVLam2CJohlrOCUi8vD0QoDrtKA3UigZzCkNu7hG
         JDSf9q5rEY5/lZwJvh7kpBncn22tMPXBGrJtPmhfn4cFZNknNZWnNeFNbe4c4nDmXrls
         Q+HfrIy3yUcAqJJTvV1n3/oGPgsWW3cMUiJnqVuY6BJ+MHpB8lRiTInM7zGwlJh7gFFe
         HENQ==
X-Gm-Message-State: AOJu0Yygij8evYROCQjoqSfkbPAg6EdiaoJNwic0gSS4AK64IRxvLPC5
	j+M9C/TgDid4oil+vN64lMQk3r7vNPv4dNDF92D2S49ie33db6CprKV2R5ndrzYygQ4uS7bSkez
	X9UMztfcKKbFB+Z3EPhLuWQPKyZmv7KsRjpg3
X-Google-Smtp-Source: AGHT+IFZAKlcSpUQrpigxu4uxuCUaGd67TezuAcvC2uL8vue3EfrLNM7Af4JGypKEGrD87xgWG2GKqbD0v1Ub26/BDI=
X-Received: by 2002:a92:ca4f:0:b0:374:a294:58bf with SMTP id
 e9e14a558f8ab-38a682c8364mr324195ab.10.1720463478450; Mon, 08 Jul 2024
 11:31:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240701211445.2870218-2-aaronlewis@google.com> <ZowZzUTVNhp6gpL5@google.com>
In-Reply-To: <ZowZzUTVNhp6gpL5@google.com>
From: Aaron Lewis <aaronlewis@google.com>
Date: Mon, 8 Jul 2024 11:31:07 -0700
Message-ID: <CAAAPnDHDXTKE7U7hguKUUb08y6QdocmMobPaEmU-hotuACpRwg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for the test "vmx_apicv_test"
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 9:54=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Mon, Jul 01, 2024, Aaron Lewis wrote:
> > This test can take over 10 seconds to run on IvyBridge in debug.
> > Increase the timeout to give this test the time it needs to complete.
>
> Heh, there's a pretty big gap between 10 seconds and 100 seconds.  Can we=
 tighten
> the timeout, e.g. to 30 seconds, without risking false failures on IVB?

Yeah, 30 seconds should work.

>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  x86/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 7c1691a988621..51c063d248e19 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -349,7 +349,7 @@ file =3D vmx.flat
> >  extra_params =3D -cpu max,+vmx -append "apic_reg_virt_test virt_x2apic=
_mode_test vmx_basic_vid_test vmx_eoi_virt_test"
> >  arch =3D x86_64
> >  groups =3D vmx
> > -timeout =3D 10
> > +timeout =3D 100
> >
> >  [vmx_posted_intr_test]
> >  file =3D vmx.flat
> > --
> > 2.45.2.803.g4e1b14247a-goog
> >

