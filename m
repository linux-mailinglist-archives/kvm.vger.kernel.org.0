Return-Path: <kvm+bounces-8355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0222484E665
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0761F21343
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7183182D61;
	Thu,  8 Feb 2024 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PmNsQZhF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F75D823B9
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707412250; cv=none; b=dXrQk3MUwukUWzEcH+Bh9mga64zpIPx4ndD+rSTIZLZiOnUiV3Yim4yk2cXkrjBjDOgBN3xvUMTsrTy+MThNLfw8wgCz5Po6NldFxp5c5JG/7XGCtatJKshpA90dobiLLMprX6S2DtbyVo6A7zH+fMyasgpSW7dbeJ9+ekO79Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707412250; c=relaxed/simple;
	bh=c6aoqYCFsOMLBLY9EBuC5B9D7Nr7C63yDuPhmtea65c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NSk3gm2eZctNhZSaTarq09x3C4DtcBrlFpC3hXxm11pZ4pPLtRXmtloohX+7FttTIS7OFxB4kKuBJD4pnfYqoOH7vwV3u1xzPIoQn9/0iPtZe0lKog2iuan08T8ZpvIdNYDtOZMrBP+jwaF5uH8IxsBHrzIEk1qKUrGhCjdF1Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PmNsQZhF; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so24713276.0
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 09:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707412248; x=1708017048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vnxwzxdW0vghKBRnmbklz++wrlXlANkBJAW5w2M9vxo=;
        b=PmNsQZhF7+0ERvFEW2qdpkoyAncwejcrlRZ8ddTMwjDkgROTTELqxE8FVhHishbeX0
         qgZlvM8H9e+QKfPKnz4A20BAEwEErqqSjFgxnI933UEK1fvWjtsLCEXRfeijfeIM/4on
         sG/DIs3dTWtPybDFMxcTe/R29LHPDLeKHkER7EWG/deIGlWyxTHQWCfi3o7lgmL+2iHR
         d4g/LqqYckSZykYVIhVYPvbNqHwXeP4F8TQVbe9TV/Wg4miy3UDRzxPFwJIanBbJ3s6/
         oM8D3Omxp3Mj5/S0PP5wvcf7fS1lPNCK0jy3O9OD8FH55wgcjj61JefvtgISN124dGJs
         4Fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707412248; x=1708017048;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vnxwzxdW0vghKBRnmbklz++wrlXlANkBJAW5w2M9vxo=;
        b=C3p4IAEA4P7zlfwFvoasIULDypWuCk6TLsXQg2DSC/uyD/mgq2QxlmGyfW0Tp/xvRn
         W+M0K9pxYqBF8S3GgZrAXID2QZ9wfjxdqzKhWGA9ac5/iC2A/n88US5bK+gbU8/wLUUD
         xnMSl98dlU3iQJcy2dW+6GNzrdZyXvKt4uSlz3R7sykwKPVt6Mlf38MNFrl6uHvn+a3d
         PG5WLoAKI+tYdgcLWf5LNw795skRG2BsBODv+ft/ZXeaPkZIaMLcieTJ2BJehWsMALKT
         gQYgOMbOlGz7UwgJBbUawp20AMmHiZQtxvxKJWDl20T6WFfG5usAQvdqgebJ2+ugV7tf
         fUMQ==
X-Gm-Message-State: AOJu0Yz2E5w8o4JRtoho4PqdCcaU6ZL7nGyhkgHm2xxtPSk58ltfHpO6
	DoNXd94bLtPxJAInPGb5f7eCSdIafFgmKB0mWlxilyhUz/ed3ilZQUIMqkzGQlMydK4+KuSoV5O
	FTA==
X-Google-Smtp-Source: AGHT+IGE+uyLDnSGqnJBTxYKk6eQHCo5tcRVdsHMeE9afZZkqMeb6Tzpg0wA6eSn8JiOjBcbTP6LAgJhrVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:4f05:0:b0:dc6:c623:ce6f with SMTP id
 d5-20020a254f05000000b00dc6c623ce6fmr186ybb.13.1707412248073; Thu, 08 Feb
 2024 09:10:48 -0800 (PST)
Date: Thu, 8 Feb 2024 09:10:46 -0800
In-Reply-To: <CABgObfa1SmH0HDq5B5OQxpueej=bdivMTkVrO=cXNfOi09HhUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131233056.10845-1-pbonzini@redhat.com> <ZcOWwYRUxZmpH304@google.com>
 <CABgObfa1SmH0HDq5B5OQxpueej=bdivMTkVrO=cXNfOi09HhUw@mail.gmail.com>
Message-ID: <ZcULFqXM_sA3dSY7@google.com>
Subject: Re: [PATCH 0/8] KVM: cleanup linux/kvm.h
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 08, 2024, Paolo Bonzini wrote:
> On Wed, Feb 7, 2024 at 3:43=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Jan 31, 2024, Paolo Bonzini wrote:
> > > More cleanups of KVM's main header:
> > >
> > > * remove thoroughly obsolete APIs
> > >
> > > * move architecture-dependent stuff to uapi/asm/kvm.h
> > >
> > > * small cleanups to __KVM_HAVE_* symbols
> >
> > Do you have any thoughts on how/when you're going to apply this?  The k=
vm.h code
> > movement is likely going to generate conflicts for any new uAPI, e.g. I=
 know Paul's
> > Xen series at least conflicts.
>=20
> It also conflicts (and was partly motivated by) the SEV API cleanups
> that I am going to post soon.
>=20
> > A topic branch is probably overkill.  Maybe getting this into kvm/next =
sooner
> > than later so that kvm/next can be used as a base will suffice?
>=20
> I can do both, a topic branch is free. But if you think this is in the
> "if it compiles, apply it", then I can take that as Acked-by and apply
> it today or tomorrow.

Looks like you already created and merged a topic branch, but for giggles:

Acked-by: Sean Christopherson <seanjc@google.com>

