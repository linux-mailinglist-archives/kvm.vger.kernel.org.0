Return-Path: <kvm+bounces-58364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26612B8F59B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:55:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A78DE420961
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8D32F9982;
	Mon, 22 Sep 2025 07:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B53g+eii"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54DF2F7AAD
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 07:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758527681; cv=none; b=DdWrMeOPAf4aQtN+uEaJ/LH6RyIudN2YZk7l4iQIQzbOWhcK/KD+48+EacOUsNGLlulmo+hQSuPjw/bMLNZ9Ic5y9gXdSZmE0vRzW0CeJjeotzcPhu7TU+eQDkXz1/10211B6RQZR5+JRCvjZz7qd5G0mkTs/CNHC8Gxemh59gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758527681; c=relaxed/simple;
	bh=wHhXbBUv8sLtLk6ZtdozUkZSGPHqvYUTRhRTVOMPPw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liN/ePV5wjrvCHzCzD1ukmEKCsy7K8UYBxD4Wr0e8HrQ26y1nSZLARgAThVoIP6HzfBGyPnSxkP2goeCLnZH/Lv9zCG3uKw47Fiv7wC35bNZii93EVRacPn5WTgFsaMdmyzWre08TQ4vHylgxwlmaaJ9gfWBu/L72hge8U1dNes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B53g+eii; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2698384978dso34075805ad.0
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 00:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758527679; x=1759132479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wHhXbBUv8sLtLk6ZtdozUkZSGPHqvYUTRhRTVOMPPw4=;
        b=B53g+eiiTb5GDiKWZd/72tvC2vLjAUOqGrQYYHn2hP6zqCOPWTErNP9eJU1q4+a/Qt
         nL2Vs9X5i9mVdn1Pyxy8caliAFbGYzbaF7JFqNAg1lNiOr3b5sq3uBRtzxY4DtbA2Nge
         lZPVjDf9YW9iKP6TBSRl3pKL4xYTUIju3wH9Pb7IAagjLzpGzB9R/deQZsblrDLnw4tZ
         48iOLBZlT6ZK+DwHPH8ZRpmUFCzPRzbAqu5ux2Cn6gw6LAUdDKHFSXtE/h3lkJosoJwr
         LkRD09lFr9kXwu453ADEQaTiKiuozO6aJpudEqSfRiUnSk1qUAxKi8t2ptYTix8/TUBx
         bpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758527679; x=1759132479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wHhXbBUv8sLtLk6ZtdozUkZSGPHqvYUTRhRTVOMPPw4=;
        b=qN3mJZpMozUP315dzCZ4Z7mGjCx3xo2lCF9qETXrpG4RDn0WvEL9QXWacm3NxhLOGd
         jsRwzQPO28E5QvvssINX5AYxJtovS4Q57743B11lstgV72GePR0DT8Vq7V+rpL94lHVH
         9QPzsKO1vr63PrFuQBOmmUvyhtSUVe/0V/2KlvEGDegO54YrzEuJL+GEGB0Kvp2eq7fg
         2y9UeE08hfVXqVhGPdZGPbk/UeocXJjLCoK4orQIgkxhtt2X3dRt1kTZlBvnTMX802L5
         q85y10U3IjFPR5i84rnswIQeCYawc0WCuCp3wBbkhkiHq5QgK1jiOvHJC2FxmqNehe3I
         eBuQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNLJPonH3GVAP+0tkrAToxzg07gMdnkGrNiKrby0ZGQkqsywiSbpJVzpNxwT/JAxUfXC0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGih/UwSkZzH4OIb7Zd1f7ZHVmAr7pNzT50YQoLiL3ZJRGHo+A
	+D2Dy6ryBWi3s8jQ/hURoW1J0o+2ZFvQt1o3No18/tXvg+omtcjyVaBC
X-Gm-Gg: ASbGnctDTbOPqeeav8+3oEwcaC/ABg5NRPgluk0ufFLoJnFDjitONnNqOd27vxFl25H
	HPU2zzGuawX66fcbwtqA08q0zHm3zWN0TAnbU+DnfyPzmUp6kOsRwmMKwMxLPA5owPcdOz1eRZH
	Y+ouXscSfg1gSN0I8fOzwcMpye4O5t7dDxBw9PyOfCWZYvvMaqkS/ynjY16udSMk6jlrdSPR/1i
	az4Jy65qwSjfcadat8Fd5NiCG+FiAVrdCrzb3ENx6Lh41ZjvpHz6phJyfphAKvImi2/npxoM+kC
	vEnUOj7jichhUlfI3B+6zq/wl2rEG1crQmF7h4lJT4jeAm/BRex7T55e+Oggfm8VkaKObdTCkn/
	bS8PEyfEizi3rfyRIo1yuew==
X-Google-Smtp-Source: AGHT+IHz3wNSWldGNXV3xlynWhX7Cr9eYZtSb12u2x27WnJQYglboQKton+MwFy1y4rS6oR/rbqndg==
X-Received: by 2002:a17:903:3846:b0:267:c984:8d9f with SMTP id d9443c01a7336-269ba45919fmr182012075ad.24.1758527678869;
        Mon, 22 Sep 2025 00:54:38 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26e2046788dsm71684115ad.72.2025.09.22.00.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 00:54:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id D26144220596; Mon, 22 Sep 2025 14:54:30 +0700 (WIB)
Date: Mon, 22 Sep 2025 14:54:30 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux KVM <kvm@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH] KVM: x86: Fix hypercalls docs section number order
Message-ID: <aNEAtqQXyrXUPPLc@archie.me>
References: <20250909003952.10314-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6Hw9PxwxK+FTyenQ"
Content-Disposition: inline
In-Reply-To: <20250909003952.10314-1-bagasdotme@gmail.com>


--6Hw9PxwxK+FTyenQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2025 at 07:39:52AM +0700, Bagas Sanjaya wrote:
> Commit 4180bf1b655a79 ("KVM: X86: Implement "send IPI" hypercall")
> documents KVM_HC_SEND_IPI hypercall, yet its section number duplicates
> KVM_HC_CLOCK_PAIRING one (which both are 6th). Fix the numbering order
> so that the former should be 7th.

Paolo, Sean, would you like to apply this patch on KVM tree or let Jon
handle it through docs-next?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--6Hw9PxwxK+FTyenQ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaNEAtgAKCRD2uYlJVVFO
o3wKAQCS3n6Xj/tW8RTpqqfFhRw/RaeX1a+0H1vnroXuIBgyAgD/d3RMhZPFm9JN
FhRV0MeuKVEwYkg2livKKUt+Jgs+lgY=
=b9qT
-----END PGP SIGNATURE-----

--6Hw9PxwxK+FTyenQ--

