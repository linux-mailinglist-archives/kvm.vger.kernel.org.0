Return-Path: <kvm+bounces-10147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A9086A1C6
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 22:36:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AC391F22F0E
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8995614F9EA;
	Tue, 27 Feb 2024 21:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhKNTrEY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FC14F971
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 21:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709069757; cv=none; b=vEuvXJK2XhnQE5xE09Z4Trm8Nrox7oT+ogVxShW0QUfUbjJoF/1nHGxzNL4TCmOzz1a9XvCixDsOq4nZExZqbw3tosgHYtYKsowqvZJvXv6R42ozFq/3L/Q2SPXhVxI3UanWRZvM1FotlFX5BAspFM9RfhzBrftIaHq2VLVPCxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709069757; c=relaxed/simple;
	bh=2REuIryrvhb8IY5ewJb7IEUgAePxkytfDpGv804DBtU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XpLPi+x9M02P/LyfUT7l488kqP0YHxY6eMyRRUWJOUveAs24/2AOg/8wsNsTS2Saa1FSPydoVD1HavQNA76jwojn80+v2LU5/sIact5ZBJN1fOO0Qe6+pQNbcYylclqVgougY56gjpxTsqjW0KD2ZUy3+RbHA0YhiwgmX3HaSyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhKNTrEY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709069754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ys4/mtb/zCFeZVJK605fpgT3Q8mDJMYzpv+wFzJ5MM0=;
	b=HhKNTrEYfjmmQdwTiHPQwlz613uPC9LqmI2e/knDrPa7aXAD4rfySU37hYgmqBicJpg9hT
	mdtCyOZHgqYs7jofcAGoR1mBQz7tBqsOy+Vls4GQ/7XZXgB2GqgKHtcXsVw9Vi0EqlJSkQ
	Bz2ikiaDLIb6R+3PI4F4jCW0B6gOKJc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583--dDU8tf0MoCislTq0yF9PQ-1; Tue, 27 Feb 2024 16:35:53 -0500
X-MC-Unique: -dDU8tf0MoCislTq0yF9PQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33cf68241c8so2521567f8f.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 13:35:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709069751; x=1709674551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ys4/mtb/zCFeZVJK605fpgT3Q8mDJMYzpv+wFzJ5MM0=;
        b=Co4mZgiiJeEIRTGe8tvgZT7R9CgsWi4frvf5zsfhIKCab6+kUMC+IMd3pmajyRroo9
         kbP68LC/qlKSeTxXysWI/SBi6yxP4Q0nyWFc0bh/BRABdVwv5PXTR5XmeegGW6FtIj7e
         a/0E/anzFYfHaHGmVV5WA3fAAyw6kM2YK0LhlhGpSMzblJC60YTXhb2HB4yfvfhMaWKJ
         tZ/Ps4UcF72yMhN8XJvO/A/OosoWQhb/a6wUh7NtF84YUZPHcSoKGrJUEu2wHFsADJEO
         9H1alpoVCKW8WRIfHjEQami3xwXfKpCf0drWo+Rruf4m821MPuwmc6V8nfIuBKaGvL57
         Z1Cw==
X-Gm-Message-State: AOJu0YyBV2/W14EIFkMSHj6FRpjx/56pNCIKTeN2b3u+WfX9BuL5gUcs
	6uCxqL63J/eu8hgZmx/3IO0KdhPtDjh+SOcYLb823zU6NdsrTm4eOFH4f10f4/uUL17ZURAiCF+
	mZf0YqLLfPuZNGcqBzjpKTaByrhX8mFeF4uvQTBUmJcWwr2idkGHBg3MaR7eI/tbqefvw6YRLKJ
	UNhDrJxFhYuKjaopEoXOKG9AbscknmtvB1
X-Received: by 2002:adf:f883:0:b0:33d:86a5:a052 with SMTP id u3-20020adff883000000b0033d86a5a052mr7729539wrp.54.1709069751778;
        Tue, 27 Feb 2024 13:35:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFudc2J2mLvfXTssXGAJUKIVisLTyQ+4K0Yjs9+2zCjktF1ZOaKlOpwmj6zM/fsmBz+xvc9FNXOFe6nCQ/tUEg=
X-Received: by 2002:adf:f883:0:b0:33d:86a5:a052 with SMTP id
 u3-20020adff883000000b0033d86a5a052mr7729530wrp.54.1709069751470; Tue, 27 Feb
 2024 13:35:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227192451.3792233-1-seanjc@google.com>
In-Reply-To: <20240227192451.3792233-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 27 Feb 2024 22:35:39 +0100
Message-ID: <CABgObfakhde_Xwhj1Q5LLkD-TxMCWoAMfz40HC_Nr6y5hDLBYA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 8:24=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Please pull a single series that allows KVM to play nice with systems tha=
t have
> all ASIDs binned to SEV-ES+ guests, which makes SEV unusuable despite bei=
ng
> enabled.

Ok, will do so tomorrow.

> This is the main source of conflicts between kvm/next and your "allow
> customizing VMSA features".  guest_memfd_fixes also has a minor conflict =
in
> kvm_is_vm_type_supported(), but you should already have that pull request=
 for
> 6.8[1].
>
> There is one more trivial conflict in my "misc" branch, in
> kvm_vcpu_ioctl_x86_set_debugregs(), but I am going to hold off one sendin=
g a
> pull request for that branch until next week.  The main reason is because=
 I
> screwed up and forgot to push a pile of commits from my local tree to kvm=
-x86,
> and sending a pull request for ~3 commits, and then another for the remai=
ning
> 16 or so commits seemed rather silly.  The other reason is that I am hopi=
ng we
> can avoid that conflict entirely, by adding a common choke point in
> kvm_arch_vcpu_ioctl()[2].

Yes, I'll do that. I have to respin anyway to get the SEV test
infrastructure. I'll keep posting against kvm-x86/next, though.

Paolo


