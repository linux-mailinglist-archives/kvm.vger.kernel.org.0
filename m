Return-Path: <kvm+bounces-42513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E78A79711
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 23:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C5BFF3B4CFA
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E22F51F3D54;
	Wed,  2 Apr 2025 21:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fsykVB+f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0191F3B82
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 21:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743627861; cv=none; b=nmK63Fi6HWHkgN2HZjnC6bxLVv2xN7rURo2+QH4gEV3UbdKeSEAvcb+dz26OcYHqxi5VTe0bmTFQoVyGV9tiGpePiRWhS6vnLWfg3XQuGWJhkrBUpOuAAgB2w71V1ZoZRbBVLAsLeeZVnsov7pyy7oxJG45LPJz+9fY3zEHydP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743627861; c=relaxed/simple;
	bh=Vfw9nQys8I+huPyRWSgdNMgCg49GbaslzRnU36FYbkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9OmpcnUAaBRZ2I0Ljx4vSHXvwIoTaH21oKmQRw4tnrJBKt81JboMd8l2XN+vLeQzdcBOWhvWQwJTk7OaylxiPiJXOatntczamMMd72EZ9XmRwZN/RkxnsJ4M7DbuqaVuzVxkaJa7TdooCMVtKqiQRO7aKGQ0ZjcA8awenKonnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fsykVB+f; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-47681dba807so321921cf.1
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 14:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743627857; x=1744232657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Noe3DDy0z2CTvHPr8zx/kBmGMiLW3dq2T/XCyIhCd/c=;
        b=fsykVB+fQQrVodOyZCmAMTbw6SxFQVFNRow6Qqbl+H9vBkT5ljnj4TkudcTQZcPlCr
         gggOGHPXkzNaYqqP++KvSPQySuU8XTlCAgmS+oqcvoNriMYlX3OiCo6OwdQI2KBSwK4i
         YyjgOEMOQ/yUT/wVKmpK5WvFY886M+Fr4aoJ3dWtxbpVh4vTbg5t9PEKNSgw3pppBNAW
         dG4DbRC7H+XWxc0aP5I0WtyhLLehLnwunK+Gua6sYQ+GSmkEdVfzuZZU74qqPLSq3c4c
         yjfC5sYVUBRGum4YVPPOCOSxJtXuCR71pvFJTfu91qQhCtyo7tEpJhGpRkgNFl9YVzSQ
         3GEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743627857; x=1744232657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Noe3DDy0z2CTvHPr8zx/kBmGMiLW3dq2T/XCyIhCd/c=;
        b=wac0e1rlpilWoflBdusGik2IcAui4Bjpbe2gqX5SNkuwPi9vf7V77+WJQvndyE8zVP
         fumN8N+6kbyXO2BU+QoKy6AO+OYPn6ew+aMQ4yk5gCMK5Y3JrfjLK6d3qCgIXWtm/TI8
         sGiJUIyIoXAxh7VFfpJkF/mD+mzNrlg634NzDBEsrxF/8Cnh15KoHHN7j2+5rdEMSeX3
         kgFHa0lBM9l5MXQnFqnJTc22hX4s/90LjlHF5PlpAJk6iYvbkRrjUcFx7MIxJXcfPk52
         lNH1sp8Biicm3DH2CStReJqOg/SQRXByeKFFbCSz1ft/Y+2oyxXSrdlwIeCavoZcQ+1v
         CXJw==
X-Forwarded-Encrypted: i=1; AJvYcCWJeCMzazfVs9Yx072Xnp+GoyaHeJaOrDo2q0Ww2oNpFjSRNC/joRMD4vCUdJUOgngxjHo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDxyqES3XyBqVn8D0MXifcljAcKRD/5jAoNO3Lc0F2g7+T9Oz5
	6sgS+jLPebc8rIIMTGVReqbspa33Y66VjyS+v9kafGK3em4552x/vedJFPkyJAhUQMxgzL1LyGJ
	jpxB0/VCtWK/9Bp1NCO6A6R51LDbXdsSQQ3ZR
X-Gm-Gg: ASbGncsWmk504Uc5EH6d3msVoHHH4D/nz3MmsJ+drYhv35USNjmNQLVxkSDc/r36iFY
	NQ/0u1lzwmcdNGQnEb7tI6PIn3Y1AmC7vDWj/DzC85O+T2UAJ1gJqv1pk0cHaslSVZKk6MXQCN1
	1EdBIBNt1t/2ZUQYGdxBYaIh7AFg==
X-Google-Smtp-Source: AGHT+IGYW45ozRLi9bL9GSKrmNMLBs0q1+I1SgbQECqY7JZ9X9Pt9sehBj/WRt88DS5jI5cwU1IS+pidai2+KcquPAs=
X-Received: by 2002:a05:622a:d3:b0:475:1410:2ca3 with SMTP id
 d75a77b69052e-47919304cd6mr262671cf.15.1743627856822; Wed, 02 Apr 2025
 14:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1743617897.git.jpoimboe@kernel.org> <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
In-Reply-To: <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 2 Apr 2025 14:04:04 -0700
X-Gm-Features: AQ5f1JqI2l-_CwD-vrjqsPSf1FBNCueZti99jXQWfPKo6ikElesqHD9eVL752cA
Message-ID: <CALMp9eTGU5edP8JsV59Sktc1_pE+MSyCXw7jFxPs6+kDKBW6iQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 2, 2025 at 11:20=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> __write_ibpb() does IBPB, which (among other things) flushes branch type
> predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
> has been disabled, branch type flushing isn't needed, in which case the
> lighter-weight SBPB can be used.

When nested SVM is not supported, should KVM "promote"
SRSO_USER_KERNEL_NO on the host to SRSO_NO in KVM_GET_SUPPORTED_CPUID?
Or is a Linux guest clever enough to do the promotion itself if
CPUID.80000001H:ECX.SVM[bit 2] is clear?

