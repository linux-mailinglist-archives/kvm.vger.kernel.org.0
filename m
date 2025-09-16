Return-Path: <kvm+bounces-57788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24027B5A36E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:48:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53A4E32064A
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFB7F273810;
	Tue, 16 Sep 2025 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qYy8jNN2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9164031BC87
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 20:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758055679; cv=none; b=mjWxHE5ejw3suCZRbHF/1qFATVTDd+s26npWn+xjYNoA9Zzm+ca+7DcZYQ2xIrf/RcxfK/jNsn+Gy+WxxqsPFbhiJzL3UMjeL18BJrvv2XTPyi7W9w75LdPbTbGPxKSlOd607iorq8uHIxApGcTkxhJPPB4+J9iqr6sUxag/KP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758055679; c=relaxed/simple;
	bh=5LOtOvG0uZRYTUfXZNxjgKsrj0X+tLZMaTz9hrmMXWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bJKW7hqpmmWGwL8WhNw4pDDY7CXAp38TK/8k9E0PUn1yi1dHsMNzIJ/+pr1JR2z20h+V1ZTD6soRvgLgDeBnVKR14crDh2Bcpuj0lbDBQtQqsmq7I5uKV02ZLI7UnJcXlh+Q6JOZtuRNqOqsyrH46GgAB30bIw/J3w4KGR+gTE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qYy8jNN2; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32d4e8fe166so8362257a91.2
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758055677; x=1758660477; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2sEpQLjl2WNs8/HYK8bftPiYxpo6l5tl0uB8hRIbdiM=;
        b=qYy8jNN2dPyFBlIyBgRiAOpZAv6qUkNGjpp26GOPCh9NrP1N+OlwzTchmQ/n7KxY8w
         7NyXpRX0zZUApMdV852/gShPBTcXaI6piVXb5m40Z417XdcSaw6If9vUVF2BYYoClDMm
         EbTOGldvAMm0982UbU+I0lOTbC0RY094brO5v1AL6L94R/ssY1zUPnJJyby4UzS/6tGl
         omQ5T859FoQW3Z5WBJb3itrRpyzqvXoAIB2MP+VppWcH/KIGjzBr7C7P5IthVXo40bzv
         S/AQAkbqYYFnw8WKUWbim8GGj5qm+ZkFDPBrnXijHpOkL2cS2uRik1wc+sI+GcUYX6tv
         Z50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758055677; x=1758660477;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2sEpQLjl2WNs8/HYK8bftPiYxpo6l5tl0uB8hRIbdiM=;
        b=NdmPihfsOJ6dukeO0+Vg+VsZIzi4iICC+6LnFej4SDGNdfjiuu8QZhg/ROI2Qv0k9K
         DJ/ngTwkPTvmXha6rPejju7mYYlpFfbCV2nbFaAAqfe7+SyhVQiVYRd9bzt7fPhoDx/+
         Pwg++lXzzgDSiCVXkyHGsANxA4YYA1rzZbCwtowWoUdtNwClBZM9UWRbEJY2E2qZtpjX
         cXSzuo/R+XI7FlfIRdz1Qf0z3W+5ESF6cYBBWWw8Oc6SAUuB8FzGfh/++ET4n/Gt4DCY
         JKqqob2feef6yQlMasGLuNycW0z/oukeS+wVFsJ3Sw6Kuq/5UzNy5U9UjrczPIvb7g9a
         9rFw==
X-Forwarded-Encrypted: i=1; AJvYcCUz8Z4372ji9gN1fbhziuo6SyRjt5fETvsoXaAr3IAUWloWFsaEcjKP4gaLVPdhiqNKwnA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl78/7Sws7wCad58vnUFp2g2PXn0z+WfL/EvLRzQB36t6+mhjx
	9is0W4Drk2UHa5tHiBMwbx+6lmU8wM79ePhh7RxJ1MuC4RYeMyqWKxHzwUzIdAD4OXLq91s6q19
	6B8ltrg==
X-Google-Smtp-Source: AGHT+IGieBabQ84lUpv4CHkgWxfWTDjuzczfFf6L8mojgHp4lRCUjtkkivIdK4cMJ5pijh0pKkQiWAHwm6A=
X-Received: from pjbsn7.prod.google.com ([2002:a17:90b:2e87:b0:325:220a:dd41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:582f:b0:32b:c5a9:7be9
 with SMTP id 98e67ed59e1d1-32de4fa1e11mr18480542a91.25.1758055676784; Tue, 16
 Sep 2025 13:47:56 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:47:55 -0700
In-Reply-To: <CALMp9eR91k0t9kSzpvM=-=yePGYmLHggjfvvhmD-qaxBCnRn+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240815123349.729017-1-mlevitsk@redhat.com> <20240815123349.729017-2-mlevitsk@redhat.com>
 <Zr_JX1z8xWNAxHmz@google.com> <fa69866979cdb8ad445d0dffe98d6158288af339.camel@redhat.com>
 <0d41afa70bd97d399f71cf8be80854f13fe7286c.camel@redhat.com>
 <ZsYQE3GsvcvoeJ0B@google.com> <8a88f4e6208803c52eba946313804f682dadc5ee.camel@redhat.com>
 <ZsiVy5Z3q-7NmNab@google.com> <CALMp9eR91k0t9kSzpvM=-=yePGYmLHggjfvvhmD-qaxBCnRn+Q@mail.gmail.com>
Message-ID: <aMnM-_tg0fl4903y@google.com>
Subject: Re: [PATCH v3 1/4] KVM: x86: relax canonical check for some x86
 architectural msrs
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, 
	x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025, Jim Mattson wrote:
> On Fri, Aug 23, 2024 at 6:59=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Heh, and for MPX, the SDM kinda sorta confirms that LA57 is ignored, th=
ough I
> > doubt the author of this section intended their words to be taken this =
way :-)
> >
> >   WRMSR to BNDCFGS will #GP if any of the reserved bits of BNDCFGS is n=
ot zero or
> >   if the base address of the bound directory is not canonical. XRSTOR o=
f BNDCFGU
> >   ignores the reserved bits and does not fault if any is non-zero; simi=
larly, it
> >   ignores the upper bits of the base address of the bound directory and=
 sign-extends
> >   the highest implemented bit of the linear address to guarantee the ca=
nonicality
> >   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^
> >   of this address.
>=20
> I don't believe there was ever a CPU that supported both MPX and LA57. :)
>=20
> Late to the party, as usual, but my interest was piqued by the failure
> of KVM_SET_NESTED_STATE prior to v6.13 if L1 had CR4.LA57 set, L2 did
> not, and the VMCS12.HOST_GSBASE had a kernel address > 48 bits wide.
> The canonicalization checks for the *host* state in the VMCS were done
> using the guest's CR4.LA57.
>=20
> Shouldn't this series have been cc'd to stable?

Yes :-(

That's my fault.  I balked at the size/scope of the changes, but in hindsig=
ht
that was a mistake.

