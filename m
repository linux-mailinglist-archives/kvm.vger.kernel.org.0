Return-Path: <kvm+bounces-22930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 918F59448DF
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:55:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38C101F21FDD
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:55:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BA89170A3E;
	Thu,  1 Aug 2024 09:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="onnhQ36U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A882E170A06
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722506139; cv=none; b=D8rPkVyPep68c8KG9oxENt7OGIBLxWG+ESO0JE6CmPLq/FHVh78P6StfaT5i2Qe/ujl8lkdjZsHNL9qjI6FPyRIjjLZqEVnIi1kg56GZD6zsuapduWDA9TyNgvbFzTISf77xkL8V9QgdOnq28IlNBEEn3mpEFgrhGvw0B8sihl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722506139; c=relaxed/simple;
	bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k7o0mnKLxWOd6I927UZQQcwkU6Hchy+qKq1grN56YgvCnQP1vugBg4iZqk4fp/pm7or9GYWPDr8zKXPq4ELePu4zDlYFzT7JjnaAe0TcqT4OtKtTZOxJmm/ptJ69J3X+SiLRBokv4fMALb0w88xIOrDclXuWA1lE4ybELeL8o0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=onnhQ36U; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a10bb7bcd0so10306362a12.3
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722506136; x=1723110936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
        b=onnhQ36UdlkdRxhGTdsPxR2B8JXD6Spgkxe0uQEck0BJzw8BeexFZnd++xDQR6W7O2
         0kEMLBoU5lC5yQUkGygLamrSo1ws50WEpKQlPFBxBPYzu0qEHEbw8RYIyiuNvbjF6EYV
         6MUNsX76U4iHJ3jf9AO3dEVzozFpAggqOdoGDTSfz1VeqQvSTvjpimzG86eKhke+UR0X
         PqkMzYZWvhY3mR8G0XXvgyRoKXKFpweQfCMjAHuikoqL5hwufVG+iVQdoAZEUBrtIgi5
         j1UNUR7QwHtcXPXTaWMNCZdGNR2xqsTqtVnASmojYVRJDfKy8Bmc7elmmu7PpOuRkS78
         YDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722506136; x=1723110936;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfWoHfDxpbd/BrLn4R6OTlWdsgX7K0q/kTBzQqeOmF4=;
        b=RdTTCzIz22L7Vyzk18b9sD59sGgDND+ggxJr4W7A68nXlwQTsdaEaIZQULdKgHbmD1
         G+gj4isVk+MCrpGdQscAFqAMxZux2CC0xdEsM+QHFkKChZTdgAY2qdPkEefay3Xrx4Ee
         ItkxMHw8CXYpLcQTiP39f6HrCfYxHodBNHt0IULgDo1mpQfDU5p2c4w3bTjN5CnkuxRl
         1Rot6vGHpHAaNaa3rafUNcaDOXFre7lVEHYzVAsUro1iYSjwbTbIvJiOvm3bObHqvzPG
         GeRpyHl+4IpdPaBFuhnb711wjHfELNLLjPGvf8ad08eZRmYJgoP77JRsm8tiKFPjQ5ax
         wcow==
X-Forwarded-Encrypted: i=1; AJvYcCVdgF5hk/v0zTXxyHS7yBiy0V7/BwaXchRKFff4Y8iqY6854YHDS7bWGVuzkcQYyL99TqXNkPVIwiD6mDf/iUejsZky
X-Gm-Message-State: AOJu0YxOOqYLb499fHGGHmuppcpihjiKyZowJ3wWsHs+eAhlJm6MU15R
	5iKsS0Q2sG2v/TW8KLQHxY2V6hJyM2ybuKAXUmANDYgWJWMd0P9pCukL/fFLDEc=
X-Google-Smtp-Source: AGHT+IGb/nSGVf7NWCnHjhhrhlGi5SRtFpH69is58qT222M0oYGxJthjaOlCxTOcuwDzU1FyViVsdw==
X-Received: by 2002:a05:6402:b32:b0:5a3:5218:5d80 with SMTP id 4fb4d7f45d1cf-5b6ff4e0399mr1182829a12.21.1722506135641;
        Thu, 01 Aug 2024 02:55:35 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5ac6377d005sm9858902a12.38.2024.08.01.02.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 02:55:33 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2329A5F80C;
	Thu,  1 Aug 2024 10:55:32 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Marc Zyngier <maz@kernel.org>,
  Oliver Upton <oliver.upton@linux.dev>,  Tianrui Zhao
 <zhaotianrui@loongson.cn>,  Bibo Mao <maobibo@loongson.cn>,  Huacai Chen
 <chenhuacai@kernel.org>,  Michael Ellerman <mpe@ellerman.id.au>,  Anup
 Patel <anup@brainfault.org>,  Paul Walmsley <paul.walmsley@sifive.com>,
  Palmer Dabbelt <palmer@dabbelt.com>,  Albert Ou <aou@eecs.berkeley.edu>,
  Christian Borntraeger <borntraeger@linux.ibm.com>,  Janosch Frank
 <frankja@linux.ibm.com>,  Claudio Imbrenda <imbrenda@linux.ibm.com>,
  kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
  kvmarm@lists.linux.dev,  loongarch@lists.linux.dev,
  linux-mips@vger.kernel.org,  linuxppc-dev@lists.ozlabs.org,
  kvm-riscv@lists.infradead.org,  linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org,  David Matlack <dmatlack@google.com>,
  David Stevens <stevensd@chromium.org>
Subject: Re: [PATCH v12 26/84] KVM: Move
 kvm_{set,release}_page_{clean,dirty}() helpers up in kvm_main.c
In-Reply-To: <20240726235234.228822-27-seanjc@google.com> (Sean
	Christopherson's message of "Fri, 26 Jul 2024 16:51:35 -0700")
References: <20240726235234.228822-1-seanjc@google.com>
	<20240726235234.228822-27-seanjc@google.com>
Date: Thu, 01 Aug 2024 10:55:32 +0100
Message-ID: <87h6c4efe3.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> Hoist the kvm_{set,release}_page_{clean,dirty}() APIs further up in
> kvm_main.c so that they can be used by the kvm_follow_pfn family of APIs.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

