Return-Path: <kvm+bounces-61902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 30615C2D9A7
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 19:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 88B6934B554
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 18:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5069231B130;
	Mon,  3 Nov 2025 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vn0biv5X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99233101DE
	for <kvm@vger.kernel.org>; Mon,  3 Nov 2025 18:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193418; cv=none; b=qk3lkR+GWfIXLGgDe8nFREVi3N5orX9zYTDk0ZuYnJugLbEpm0ndsKlJI578fjF4YdnZwvBjispxIpuMqguxRi1Rc/F36cFIHTFth8KI9SufOAtzzo3Z0EB4r6TY7YmOsFvrWjZfGVrCIKheLUnifTAYYaQdGMgj/HnS1fQxXE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193418; c=relaxed/simple;
	bh=4ED02VWniegSWjMSraq/TNN/5Dbka9gNRIkS0tQGkkY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2zzN2/1XiCnsLBXX+vbDF8mBJdPyZwnOCkIck07hGUPFhOfODUEwmuyOHHqgJu/UgT1Ciq8gqDjA0YscZbUZTpURfU8S1I0D5/DnhX2Wrs1Wm2YAXUowJhqO8izw9CiOMLcXCxQLGcXKt5sAw3hCWAKTrWvYIAN4QJX/7HdXZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vn0biv5X; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-63c2b48c201so502a12.1
        for <kvm@vger.kernel.org>; Mon, 03 Nov 2025 10:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762193415; x=1762798215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ED02VWniegSWjMSraq/TNN/5Dbka9gNRIkS0tQGkkY=;
        b=vn0biv5XFixOVkaOsNElFiLw7GSr3v0sGCvhwUWeWTnZfn6oxg4rpqOnKvWdtuW8Db
         VVp72Lqjuyik7MwaNiC2UU6cETd2tPtqaI+wjxznnUhLmu/x3vD+Z4T5uBt6+Gexjx33
         OfdVHYeo9L2j5dVXxYoxdt/2dE+MMD46t9bpISZibkIFQV0g96B6d2MomAQwI0fOcy1J
         lIq4ent/3aQFbpRulzHzfxwWbcgxeHzDWVoGTqwdDTpL5G5oSsFXBbF61AqlAYW27B0M
         0yM5R0fmQpWavvhz6cSQJbB1RApUzZ7Au9ISCsyw4i0wKjmhOjW/Dp/f+AjVM33tNorE
         j+iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762193415; x=1762798215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ED02VWniegSWjMSraq/TNN/5Dbka9gNRIkS0tQGkkY=;
        b=gYtzjQsMaLFuOqUB46kXwStLgO7rvuQvbZ12zEgC3MzlP793Wabv5bCIdTezBTuWO7
         u1bsN5Dj/2W3r2XswijaCTsEOAP8sTfackhZ2XdMGAJBBDDL73Yu1VkUP42JV8HqvYqY
         4NiImWmvIRAyj1grD7fIJBuWP7hP0IHP4P9U0MyvUHhzinV24udoCIPCeduqI0bK3uWh
         d/BLRDUo9IzfmwLg2yCwKopt7caex68bngyYLuL92ENRktCb2u0xvree8oMqvZ5IgaBH
         cptj98P/k2xAlqJww6nd/bWyPWFfr9dqQRPsXLOHWKaRdEppAsdgvmIQTOJGBp9szsHZ
         XVqA==
X-Forwarded-Encrypted: i=1; AJvYcCVAh22R88MxpVasu5AJlvO64wVajJB2Vvf9ccQrITgs0N1XdBkQdiBmYyA8YhnRW87nnk8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb70qPt5gxa0QrVSDTjdAO1TOmHYRtowQ8SlORaWApCDv0mqaR
	5pYvypVbBOTlZJlVLkZuxa7e5RmOL4e4GKfdr0DtVYHrE467Si5EDqJMAvtYG9/v3iVChssnMmN
	aSW2S3TammPBHLVVkE5o2fz//TYspObcqswtHHew0
X-Gm-Gg: ASbGncs5ZIgTN7x584aOx78saiKSoeqgIPDtL+Ek/DxEBE6+4RA6VVsoVw3sBIAKS77
	HAjN7HEcO70r/vY3bmAENpqHCmLBtGnEO3b7mMR9OJDIW6x69AV8cHEANuxD3aNcT78PZEEm3Zb
	nhI80AwXecehFdiVehYrBfo9P5Ooe6e+AR8RanOgXIpJ/TOjjKbN1TiWP03mtd1IzwVcaCVt/aJ
	uov9yZFIu4z98z1Py7cJZzvU6+LBEfmYK1sw4r6WQhFy8ddjgy/xGZQQIylSfoYPs3fK9U=
X-Google-Smtp-Source: AGHT+IHUauanUYd1e7ix3qxNI+nf8m5YZ9W3HIg2Y2bCf6Z1aPZ/pLTwOmWVSROFbPBb5yX6WokFYhupkcNCK8cYl0g=
X-Received: by 2002:aa7:d3cb:0:b0:63c:11a5:3b24 with SMTP id
 4fb4d7f45d1cf-640e6b07f8bmr2072a12.1.1762193414886; Mon, 03 Nov 2025 10:10:14
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251101000241.3764458-1-jmattson@google.com> <tavsqj24pscngpu5pxfuvpsylcn72anoc7q5i5goip5lb5fqpt@xh2srbojpvfs>
In-Reply-To: <tavsqj24pscngpu5pxfuvpsylcn72anoc7q5i5goip5lb5fqpt@xh2srbojpvfs>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 3 Nov 2025 10:10:02 -0800
X-Gm-Features: AWmQ_bkh8yBQ3ipmp-BEbt1K8wg1WQqBL_wc3EK1ju8h5AeW1-z5RpdwWJH_lzo
Message-ID: <CALMp9eTvkg0JB4gOniUrPJ1-Xc4van3+DSco676UuC6ZY4PjLw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: SVM: Mark VMCB_LBR dirty when L1 sets DebugCtl[LBR]
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Matteo Rizzo <matteorizzo@google.com>, evn@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 9:42=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> On Fri, Oct 31, 2025 at 05:02:29PM -0700, Jim Mattson wrote:
> > With the VMCB's LBR_VIRTUALIZATION_ENABLE bit set, the CPU will load
> > the DebugCtl MSR from the VMCB's DBGCTL field at VMRUN. To ensure that
> > it does not load a stale cached value, clear the VMCB's LBR clean bit
> > when L1 is running and bit 0 (LBR) of the DBGCTL field is changed from
> > 0 to 1. (Note that this is already handled correctly when L2 is
> > running.)
> >
> > There is no need to clear the clean bit in the other direction,
> > because when the VMCB's DBGCTL.LBR is 0, the VMCB's
> > LBR_VIRTUALIZATION_ENABLE bit will be clear, and the CPU will not
> > consult the VMCB's DBGCTL field at VMRUN.
>
> Is it worth the mental load of figuring out why we do it in
> svm_enable_lbrv() but not svm_disable_lbrv()?
>
> Maybe we can at least document it in svm_disable_lbrv() with a comment?

I'm happy to do it in svm_disable_lbrv() as well, just to reduce the
cognitive load.

