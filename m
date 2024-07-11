Return-Path: <kvm+bounces-21421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B9A92EC1F
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 17:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F72A1F250DB
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 15:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79D0416D304;
	Thu, 11 Jul 2024 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zAAlILJ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934716C877
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 15:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720713494; cv=none; b=k3Ca7Xaa05H9MMOJdtecCPDMakAiN57IUm7+SLg+36A7LuJlKR4FrrfgiWOacpcjLGBg85Lcz8Ug+h8YEzwkI9ncvCmVjVEPY5toqcd4AxTDZnRJmbYHeRTqz4CO8EpuuFCRKQrVUaV4a6GIUX4HSh7PjVcl6uj/rndyL1h6DVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720713494; c=relaxed/simple;
	bh=lZ57MzrlCzRCw5y4d12vHyfxZcRH9OCyRy8OqmzQvRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JJgitxJxN8foQAfpBaOIh7dyEXNlK1qstfj7VpArhy72q3q2p+1ZldNgsxTRrBXcVNj3YTK2+Gln3FfPl3ksuobfLbVuFtFoX3OuB82FU/OLawrQ3hrV2BmDuJZn893umi3wBw3mLPu5AjnuZk9TITONb5bnH+dB4TUw9lFI5yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zAAlILJ/; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52ec0ad4fa4so3372e87.0
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 08:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720713491; x=1721318291; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZ57MzrlCzRCw5y4d12vHyfxZcRH9OCyRy8OqmzQvRw=;
        b=zAAlILJ/KTtx7c6CyhfxfIWf/9ce96dqTTXiXGzDXjfUpe8xpwaT6PgTm9wCD1r9Po
         +HMtZMVHTJGY6ATiPxYgGYZe3MQySo40znm2k6Gn/qt3r38sAS33d3rV5n8TQo4rdSxl
         GyX+DEkk8BB8ozsYMpO4NFNaHItyqN31z4ywW8g1IfhqzGsoh7tFbxQfJvbQBi4vTl5v
         M2/3s0Rlx/pQ7KulzhKM63P4qqb47Mw/55XhEzF8+enoB+NE9Ahjw7ZNvaUdspcki3l+
         wwFPtIESgcAeSErdcllTfxIoY22B4jYgmMfQhw6murHq5cHWJeLh+dUAqEk0a4V9Opwx
         b9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720713491; x=1721318291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lZ57MzrlCzRCw5y4d12vHyfxZcRH9OCyRy8OqmzQvRw=;
        b=SSy2nk/p5Q1jNCYC1337/vKYLve33dwCJimRGHcZK5VpteWJRpCpPXdACawW/kvDmX
         qa7WerLQlApFieOCBvpTjG60dvJIswHsmBCl+KRZu0ScndrmrR6wVN6IpMkq5vYwIR6j
         j8SPoYvlKG5lAaFzlk5w3Rc3jdnPTcwPKhybodyOgihh/Vlf7dSw74dE041/27YWdyo/
         /Hm0me8aWDJfl7MvVV/3euv9ecFyGEMkjjm7en0INHpC9kfR4laGYgMOt9HXxTZaLFTG
         fgYYQDWF8z1tLFm/MX0BWJ0LUEtnEzaYGsmyzHPvkcI3qhfGaZ9P2JjpHsSKONWpH1sd
         LN9g==
X-Gm-Message-State: AOJu0YzFFrYY7m5gQUklmYa/vAfv3PHX1xa5jbxx5wIIU6tLaIJWtiNX
	uKn6Ib8MXVB3lrcDnlaQH/sFDkUXB63dGYJEclzL0MqsTA9/W/w4sW0ZuZNILll9nW5RddTEqQh
	UVT1Is3KUpE4LIhkgY3YJk2Ly+2B/05mIvO+z
X-Google-Smtp-Source: AGHT+IHQseqdHefTsVPVRXUMWIpckUFaJt5NZYFbaaDXHkwiXRWpcE/Zv8cBwZBUtzEWxm+xIla85YyZTZg5GUR0dpg=
X-Received: by 2002:a05:6512:3f0d:b0:52e:934c:1cc0 with SMTP id
 2adb3069b0e04-52ec5b0213cmr130645e87.7.1720713490965; Thu, 11 Jul 2024
 08:58:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com> <20240710220540.188239-6-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240710220540.188239-6-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 09:57:59 -0600
Message-ID: <CAMkAt6rQdGAjW3=+2hmZ8RXzdDH2NsPT=eqAg=kaJ_Cz0qbQWA@mail.gmail.com>
Subject: Re: [RFC 5/5] selftests: KVM: SEV-SNP test for KVM_SEV_INIT2
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, seanjc@google.com, pbonzini@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 4:06=E2=80=AFPM Pratik R. Sampat
<pratikrajesh.sampat@amd.com> wrote:
>
> Add SEV-SNP VM type to exercise the KVM_SEV_INIT2 call.
>
> Signed-off-by: Pratik R. Sampat <pratikrajesh.sampat@amd.com>

Tested-by: Peter Gonda <pgonda@google.com>

