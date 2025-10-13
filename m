Return-Path: <kvm+bounces-59939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A9EBD5DF0
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 21:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 985674F1D67
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67C142D8767;
	Mon, 13 Oct 2025 19:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iByrEsah"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0F62C21EA
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 19:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760382263; cv=none; b=r5yEGmr1T/oIhqLyjxYme3ya+jKS5Dwayz3h4rJKsooy8TM041IlbrM9Tv0/tEpiFn5RF5/qKfS2yk44J/CxQPp5I6ZDB+iqxwFrvz4LT4Vkc/qGQGFPD1oYLBL4XPBpMAVVjaaG8F0GNhTytnc8Jis90+de6WfdyzaGVDCXQew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760382263; c=relaxed/simple;
	bh=XRprMW462hmHGXXZD42eydpn9MCzdLT2QtgbxxPu/vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HoEpKMppkk+8zIpm9o3gMqplxms9d7CcTsqjhft5Jw/yIoLtUo4O+j0DUTbF9OIOS05ZWwSmVy+R8wRWaEqU+XuK83QsnIghpnDJMpxRlaFI+17L5vMhFL3jmWOJs97xZj9dCPOT7Al3fjYFYT9J0c7CL9db+6LgxTyLIoyE4/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iByrEsah; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-62faa04afd9so22860a12.1
        for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 12:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760382260; x=1760987060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XRprMW462hmHGXXZD42eydpn9MCzdLT2QtgbxxPu/vg=;
        b=iByrEsahQbs7UlwyCh/9hoiMKrUooAmgLYAeLVllnDCWSv2/xb7xNYf6t8SNcm9igs
         uAZ79gjPZ5dp2Q6o0Zu5RQtytmpA2nCf8c9FzgUBHPTTOpAg1X8HmOLSYtUANS9QFVVv
         gN9QvYliTPFsmnaS6KuZAWDzE34EARFXp+uwckZVYdDYVWTen3OVC4UWrPsrqVrKjHye
         UuGu87LU/7yhErWzrOJXjikWeUGtGmOC3DtaRq7F/x1G2gyhTe4lL1El4wE3Baw2LyGL
         l3tr+TlixfvO11ivYSxeG0XTvvlqXgBhPTleE2iWU/JGgPoqbLp1uZfOL8A1SkIh5r7c
         MBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382260; x=1760987060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRprMW462hmHGXXZD42eydpn9MCzdLT2QtgbxxPu/vg=;
        b=j+FiXCtjupn/Zht5plUL03/R0GtNjxySHFg/5MvU7gDNcqMtUWMY3VjVqDuCzKjop0
         m7xoubzrVS5cVjn7HOytDcZnaa779P1cI/qrC57OUec43xlSlQx9siTWfyv2Thf75d+W
         UBwVjuP114L/SHFt/LiKrMIy4PHzhf/2CcljmuR8XslMHyWKtmmdS/XncJln6bSuugAi
         OJ2NXtuRzACl/W9MI31AykYi78RuMox/Ru6YbC2EJMoTdg6Ov1mfa5Bh4EEJ0ZHgdESk
         EexX1am+PqkkaqnctJMZepRUcDfTevRoEaCrsRZ4fcCWS0VSTcdcmvFpUm2i3+Witk1f
         A6Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUPf5e8BCzUGltjgLZpdZXFvgnLG1jh4nPLLgIiWdvzV0f2iZI7lgHNvCIWIT7H2rCTzC4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx490iwKIXAJA7/WSQ4XdIkjARSr/Q+xHUipAwm2yFJ4FeYUQHo
	SKNrmEWcCYuYO0M6veuXCTP6M4VmwlGczJ4wU4XByUCdMv0ZXhXvp6YdeTpiY0VeNf2xs9ZHAiF
	eewXWXfQseb7jaoQqcv1TdzF3/nvvr8hXNi9uZvwz
X-Gm-Gg: ASbGncvk+6m2o/0GicK63j3TOAjBrKEEiFxvym3XWpARh4vNjev1sbJslY0ScFJaRXp
	o5T4nbcutmALQnv0ve1UGZVhT6pAh8wtB/dCB/Up6+Akb6T89B1fr7q0XKR/s0eXwEzyiUhqK1X
	h7OhDrPMQqmYph/iEvCgfjqP9DXoN+84JsVEXp0JQCZv8w6AzdCAPZmUZhzFVp/blBSA4lX85mr
	SP2mPh6LQPN2F5PwVfdfFl/WZPXZT0QeLOrZIPK+sU=
X-Google-Smtp-Source: AGHT+IEYSCXvyAa4onFHDvb+igHl24Iib2rcrPd2zbTby8fnqVM+4LZBGS3gOAA834s4iEnNXAU4cjvH9SEmKADpFLg=
X-Received: by 2002:aa7:c2d0:0:b0:634:b4b5:896f with SMTP id
 4fb4d7f45d1cf-639d529d170mr631558a12.4.1760382259992; Mon, 13 Oct 2025
 12:04:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev> <20251001145816.1414855-12-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-12-yosry.ahmed@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 13 Oct 2025 12:04:07 -0700
X-Gm-Features: AS18NWCV6dlj0kwQollJoONTn_dKeR6as388hv6aq1RgEpIeoM7iXJJUKnuNKLk
Message-ID: <CALMp9eQH1y1rfey6kCyOZs4uBmrRZKhEPLP50i22p5-Bhvxsow@mail.gmail.com>
Subject: Re: [PATCH 11/12] KVM: selftests: Refactor generic nested mapping
 outside VMX code
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 8:06=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev> =
wrote:
>
> From: Yosry Ahmed <yosryahmed@google.com>
>
> Now that the nested mapping functions in vmx.c are all generic except
> for nested_ept_create_pte(), move them all out into a new nested_map.c
> lib file and expose nested_ept_create_pte() in vmx.h. This allows
> reusing the code for NPT in following changes.
>
> While we're at it, merge nested_pg_map() and __nested_pg_map(), as the
> former is unused, and make sure all functions not exposed in the header
> are static.
>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Reviewed-by: Jim Mattson <jmattson@google.com>

