Return-Path: <kvm+bounces-25238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6827C96242B
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 11:57:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25CD8287756
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 09:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902F516B392;
	Wed, 28 Aug 2024 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cLX516xz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3161A166F3A
	for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 09:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724839028; cv=none; b=lwVMFZm+YV5oKUMhEclzVB+yqIndwUtnQKnjhU08hhi2hfSuVV4YnW/6Mqtru/DKZcYwHFoPtPqoKbbreBy4e+HlX4U0FTU/wgtCuRq39mHIorEPlp4LXWx1R3IRIkcOu/E/6DcRRExvZ0FESvulKaGiTFGlSD5+wQ+fHfCGO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724839028; c=relaxed/simple;
	bh=LEy74Zw656dYSfiYEALOoHeYXujRIcOuH5SYkYP9nO0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1lxWwwzkgYjV7n9/8HmDPuMwP4miuS7hqZDd07186zzlKP/zN8AvVR7EX47TLSrJPk0SUN13VvQ8n6UfATIcMY1pWwGynC3o0i5sx0A6mt2gtPfYo4adn2r4otuQTw1ECUf6ZLH8C6by6xwG+cLmDZi8t0YBAgH2uFBlbtnkOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cLX516xz; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-45654a915c3so16393031cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2024 02:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724839026; x=1725443826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/w01ATfQ5iFSe5b+Ys5UtncabpXCouoyZAmSsqQh8mI=;
        b=cLX516xzvE3CBMz4tbs7M2u1Iairn6uGkA6HEuzhK22tvcFewLbk9Yq6HEkML/Buc7
         ENFIzvtvDJukwlW2hK04PeCSfFoU/MhMan6AfHWrXQE8+N4Fv05qo3p3xjEkdCJxCjSM
         hpMc9PN4dBgTD98n1OBdTDDp18hKN5kcFxXks2kb8R7a6be/E5PrfA4+fF/1O5BuBZaH
         pDj6wPDmUKGNR1ah3rd1MUOt5hAB7/HeWZV5yTn37VRCvopiUIyeU/CXMKVVFP5aDHLU
         88vqbfyUiS8hR4V6K38pb7i3xfFGsnpTlkqKA4ybJ9lPB7yIvUBiOreAzfcioiKKlRSZ
         EzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724839026; x=1725443826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/w01ATfQ5iFSe5b+Ys5UtncabpXCouoyZAmSsqQh8mI=;
        b=ERrHuaYTpJro/ZnDh95XzYvxVF+8JW6+C6J+knJ/f37HCHCBHn34actMhaAaYk8GLy
         QveqSnYHTgJ/Xdam07d/R0eiQYDvTgWx6ttZ6xZkc5iYbQqwOg3v/XJB7u8Qyd7ET9Ft
         lbbI1QIBXMNyO6kANyCi4OEHe8f5GKqks/kCM/DzKToyyEy+UXhOCukMEEZl5ovDRfk+
         cKRqtkjw1D+pMfz3eOXgciCpRlqvlQhW7EzRDoIYtvB2CBN62nGLN7xynec1xOhibHWm
         tlW1AOqzksQ19RZL49r4QnOMNrbhhrPvYBtam9++W0fcvgfKs20ufNHakwDwuHDIIX+O
         VWpA==
X-Forwarded-Encrypted: i=1; AJvYcCW5xBzy+jZ4Mrc18zxEwNz7ne7xbkHq84JRxCFh1j+GlVamgctyQh71nlmKo/mo+Cj5iB0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzS+14+gSptsSAwKojeHgonviUz7njqpmQLPL9e/a8SvPTiDnmG
	kCykYp0zdbxgz0tsavTwMyxz43OLgumg+K69lWFcChJOjglfTILy7XdFcRLJT/No1AdTezCQIy5
	J/l7eO+Ky0z2iqFV66RpRmk+O91GBgyUj5xy0
X-Google-Smtp-Source: AGHT+IG755zhUmVaoZLR2dVE41e3w369EHxX+Xgc4offEnaxg3I9YM9h/fuYa94K8JqvIpoiiQBIzEUXugHQz/G1RHM=
X-Received: by 2002:a05:622a:1f14:b0:44f:f06a:d6f5 with SMTP id
 d75a77b69052e-4566e62d7c7mr15550821cf.36.1724839025818; Wed, 28 Aug 2024
 02:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820043543.837914-1-suleiman@google.com> <20240820043543.837914-3-suleiman@google.com>
In-Reply-To: <20240820043543.837914-3-suleiman@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 28 Aug 2024 18:56:54 +0900
Message-ID: <CABCjUKAx7Q6BYqffVC=vUteeNEdjdtX7a45OP4FSGH7p5h23oA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: x86: Include host suspended time in steal time.
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 20, 2024 at 1:38=E2=80=AFPM Suleiman Souhlal <suleiman@google.c=
om> wrote:
> @@ -3735,6 +3735,14 @@ static void record_steal_time(struct kvm_vcpu *vcp=
u)
>         steal +=3D current->sched_info.run_delay -
>                 vcpu->arch.st.last_steal;
>         vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> +       /*
> +        * Include the time that the host was suspended in steal time.
> +        * Note that the case of a suspend happening during a VM migratio=
n
> +        * might not be accounted.
> +        */
> +       suspend_ns =3D kvm_total_suspend_ns();
> +       steal +=3D suspend_ns - vcpu->arch.st.last_suspend_ns;
> +       vcpu->arch.st.last_suspend_ns =3D suspend_ns;
>         unsafe_put_user(steal, &st->steal, out);
>
>         version +=3D 1;

There is an issue here: We are calling a function under UACCESS, which
raises an objtool warning.
I'll be sending a v3 with that addressed (and the function return
value wrapping in patch 1/3).

-- Suleiman

