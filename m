Return-Path: <kvm+bounces-66052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E63CC052A
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 01:14:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D2C623007EDA
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 00:13:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F47D1B6D1A;
	Tue, 16 Dec 2025 00:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zvGZHoiR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185153BB40
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 00:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765844024; cv=pass; b=MVEJkd7hcqztnzfS3DSV8N3FMR7JRNpLvfl11FNmPX0uvpOSPORXl5Rm8oywOiXNlbx1ooTz70qFhj/Ou6tDniS9OVh7kR/Nm9tjz82r8TsBnapfogRSfzKBuE5QOb6UDm0DjfWdvznZ0dQd2LcWvmb5qgbHmpPNoy6kq5G2wRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765844024; c=relaxed/simple;
	bh=HRbRCmq0SM7DaTEQJ8+c85iPZjE4VDGJxFWUVma8wJ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLGBL3CO8qYX1F7uzuhB5BHyLIxIFBoiU7bZTWxg9PuYjaGM+NToqeQnf0Fw8qWo1aSakqR0hYFBgauBT6cscBS8YhzMuNO6hxA27tKM/GvY48dv7bQwG38kUglEidfBrvKSCB3GAZ+DIj1itcAS79zqQ+ZKXspeL5YMdyfNdyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zvGZHoiR; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29e7ec26e3dso46585ad.0
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 16:13:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765844022; cv=none;
        d=google.com; s=arc-20240605;
        b=U1AlCG8Fg61Fu+YtqpxrrjiORWe0kLOpgTrk5REeKQODfDXifpjEvNYH+OhCgBja6A
         3+z+urSddyi414GMkWvboWj3BNEOa33XXpVT5YxsGF+1iMfWvQVmNt7hYcPxxpmVY0nu
         hTzZQweilIputsZ/3Eb1XFyKfWkrovOfygvIhgbbuTw2m2FdtNTZPWeWaGtYnzuM0lvJ
         ZQX1FrI5vGW4YfAXE+g8/39khOEeUBiXCxLucqr6iI02wsGE3aZUyEIx20XNbgoNqe0I
         GmQflM0OFxwEwYjvwMhR45vS8vVZ2CIXtvyxXG0cgfgRr1A9VyxFzNSaNexki/Ez0Zz3
         VIPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        fh=f0Sa/Gk6aV+Q0XgvPyFCasN4iiurT6FrEyCiHiudOJM=;
        b=GGEEzv84W3js2A7EUXvi9SNbhyQhU+e7NACcbqvgCV4vA348z830IPNlIWnbnPk5bs
         TBKyq1ccpATFuaYJ83I/xHcyamh/U+3vFto6Cr58xv5StYuLsYxG5wGcG/XLyE/dhUsu
         SMx0hhHpEBhepMRKJSXOps0z8cs/kG2AQfr0r97UjZ5/agloxv96r2dOJp6c1XmlrgWi
         B3Y2iZo9/CE5OTtaI6y5/ycmdwTIGR7vrcTiHnror9CsQTDkhbkcSNMP7MwloNhVtKiP
         x/7qQcgxz1tFfKxTq7EEG8hEM1156DBwd8zuJBBvx016Tzp3YEtmDNB95qd6zHxp61F8
         xK6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765844022; x=1766448822; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        b=zvGZHoiRW2JIjO5DYG5ndNniQehvasMFMPVdeS+ghYDAUHgsk9UNY9t8YokCKF9Hz3
         rYVV196dUQpqRMLtQYM/PNeuN34nvIsPY/n5Zx/zMwlPHadSQYJm3OOV/JxF1uTf4z/U
         LsMFpdJVrmOeqejpfciTG0hwKiZPdMyLvuzRP+7NOVi5QKkBLDieLGjjSl5Xr+6CXXk3
         cTyU/RwOkcL7sfG9fZVe6DFaf/fx5Ji1QZIAvJ+WcvdLnVwLxWeS0xsGL7Rj+YBwyspQ
         QQzXGBctZqYPAi9Zi2evWQHUgWYVQOgsuU3ect09Rq2mSAoNU6d3GNCyQwhCeqUq8nqv
         DluA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765844022; x=1766448822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dBvvdjAGagUjLVl9YfrF0CaB+uVsXDQGkPun9qqTA8c=;
        b=MR1p+EnznP/6sQXCfDbBZeNO7zl39dzS9IFfGwUSATsbTRM1Tbwv1+WcPQFkoiBAuq
         N6UgCwpxtqfR9TTyoG3xSGsZXpiCRJY1iV7vYCMM5g5PogSyZXwhSjgQ7DOw7YfWkSMl
         igGCaEgIL7DHZcgqOHeElOE1Buu/P7SmXpUf/gM/oxrMVvAdZ5B9tQFsmTTCYsJrrde9
         ypBaTp/I+TZctqYcg/KNGtVLW8UUwmVPpDLxsm0f9wA5Q5Z62pyFmIbEXJfSd4r1yLWr
         KHgCAkYfytzVSZwI4VfNuIfbhveikH4YsfWciyeV7tD0iBpk5R4ys+aPdpEAAqnX13pR
         xt4w==
X-Gm-Message-State: AOJu0YwIWEMWLOems8w5D8Q4+6qAr9e9ys61sWjBS2/VOeFxGv/eflqY
	iBcgqBRvFRXeQiuiwMFmN/WR7BT14KG4NrshNAXGBZ+EomdAiRDQ4ye8tZprIBnbglZf/eYtZH0
	Ia0pk2jPboTwBbmDzOrhK2CM95xMPbTgtLhEsaSAj
X-Gm-Gg: AY/fxX5E8BqCYkuuDEj47/41we7yO8yWnA37/IiB5anVnDi0uCF+Nh4ly+Kd3KU91DB
	nRWZYRbl0MDIHdouB+cXnrYqTcfhFdsjXKCkeGEQnZHw961Q6hIjt+quultjs5jBii0wV7znk5z
	oG/C8YnX9U47NT7mgPZ9Lxy4sa92I0DbvlvnBJHgKsyI1anfCPGYU1sXcNYyAZ0q6E9dyyk+09I
	u7O64lRdVYenN5Lle438gnq3Nui96NwPIk23dIr0nC/nsaa4F0mIknlMqDhDAPPfBaCDhQcm91K
	4FtaVmq3PsssA5nTOQV2KbgE8IxM
X-Google-Smtp-Source: AGHT+IFoirOvNMJpKn6tP51PRi96WA/WP8WHHlPJAFYlT/+WZt2BNZRZRHngFXZC5p9GdQCCqI5te5+CZ9A/FzrtBPg=
X-Received: by 2002:a05:7022:ef14:b0:119:e56b:c1e3 with SMTP id
 a92af1059eb24-12057217cb7mr94c88.14.1765844021847; Mon, 15 Dec 2025 16:13:41
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215153411.3613928-1-michael.roth@amd.com> <20251215153411.3613928-3-michael.roth@amd.com>
In-Reply-To: <20251215153411.3613928-3-michael.roth@amd.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 15 Dec 2025 16:13:29 -0800
X-Gm-Features: AQt7F2r7bucqAHi7gjHHb4xeDTJY1rA6zwbPyLTqR3xjOn4AhUq7dG2mlIrjznA
Message-ID: <CAGtprH_4K9TAH1DoeAW-UHTpMY2sNr8UUehoCPX_SKSQBNoERQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] KVM: guest_memfd: Remove preparation tracking
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	seanjc@google.com, vbabka@suse.cz, ashish.kalra@amd.com, 
	liam.merwick@oracle.com, david@redhat.com, ackerleytng@google.com, 
	aik@amd.com, ira.weiny@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 7:35=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> guest_memfd currently uses the folio uptodate flag to track:
>
>   1) whether or not a page has been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
>
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
>
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-By: Vishal Annapurve <vannapurve@google.com>
Tested-By: Vishal Annapurve <vannapurve@google.com>

