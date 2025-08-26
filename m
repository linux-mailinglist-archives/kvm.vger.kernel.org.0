Return-Path: <kvm+bounces-55743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1011B35EAE
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:02:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A85007A911C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 12:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7B62C0327;
	Tue, 26 Aug 2025 12:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="u8gJnw/9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0535AD4B
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756209730; cv=none; b=dwENMjQciKuM0DbcxVuVmc+J2YPw1MoErz1esmmhRbsq8ajK7xKCLGfQxVaQLO/AN5e/zMTb86AD/5x8BwzsUnmGLsC8/T7g6tvOKOLpVbYiWThvqVa3b3Z4WvsSc72MHldPiauzLVfJI0SVbbHeLswQW4lMqxMN70SjpcW0Um0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756209730; c=relaxed/simple;
	bh=2oWYxQE1xA9zM1fslapkRH9/o5p8p0SBqOfminunBLo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=URveAGpe9ZmXpbkUic6sq9GlmDJxkQ+T70Z6nVhUOlL11LOn9jtS0MQFNi2fovKRxR3QzWyvDoNwfXyQNu2NFyZV5Tkcct/MwiJlEUou0ABUjXQrnHeTWGzedQi9yrnRwwgNVuTMKF1/mDFxDDMSyzJEHLoE0MErC7F44QpIg4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=u8gJnw/9; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b4d89217aso29214145e9.2
        for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 05:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756209727; x=1756814527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oWYxQE1xA9zM1fslapkRH9/o5p8p0SBqOfminunBLo=;
        b=u8gJnw/9rwHb5XF0U2wwaJj2XQPxASeiTBnz7s5MiSzy2NNFzw3SDS343i3jmHLlLc
         GJq6CUfZk3RGKzAdOvXl8Rfi7N3EtLAro2pHMiHuaeqIeja4CBOrSXfa1ieziT30BNv6
         2uQT/QPYh5Yrrv1oSfkopOlnMeuzBrP/p/selwwMuMD6ndMKgFn2UXX/HuOJeZ898d+t
         yCb35v+qxlsdHgr3hoAO5MNz+XT9fCFjHxwhx57s3aNj9/7Y7JPucH3FNrBvo1Pf+zV5
         evSOSOcGZQSY2Tu5JnwqRQRmKbeyI7JiN9glZpRemzSVrpUBAp6+VjVQZUI+//7tScRr
         gLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756209727; x=1756814527;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2oWYxQE1xA9zM1fslapkRH9/o5p8p0SBqOfminunBLo=;
        b=v8jJxRTDqWA4G6pvTyzevWkLZGnIDUFTC/lf1o5KOixAhOlvXOczGmOGcFlREZIDgN
         4pkFhK1yIpchNwcjLVRj8pPyj1ITRtf79LB+SBFDULZGTTVylEBz7yKIwtmsF3LcntTh
         LC1Bjd56kzDjNC0YRwvX1WmwzykNej0MeZ0Bl+VRAUYKEhEiWV4OhHsWqTH82OjEuLtR
         Y4XpRYreU2XcpL5AEvhXvjEcDTrV63bjzkgDLiRpwWFFoPCBL5BqpMqvJVH3YgoLxivv
         z4dZnNqB40dPPyzxgIAVd9E5WBnK+Vc1ma0C5O0HNWGIFM2+Dqn7gBwulvOFMXa++BbS
         rtxg==
X-Forwarded-Encrypted: i=1; AJvYcCXBVafXKE9FmAbaYtnbY0nmeYiWdT934PSp/Hxq18LIhfnTK2PcEfmNuxAAF/ti4Q7ufMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqpD6q1THErvWvCmDWnyR+wVVFe6E18WmKrrDemg0BAVrYPmcn
	HRffNzq8bbGf7U+cgdBD3q+cIDdIZARcFk2pfBgtHKvpfJzLvQm5HbGIkZEb8B963RI=
X-Gm-Gg: ASbGncv9STMtwbFc9e74ksvCRI0aBuHP94pugNt2pTpYz9xxqnqWAzP+gZptl0GjUCE
	iR8MIApoyqXdGF9PM6rIQRzXEfT8fC7y5xs51D8DyYTX+D0PYWqBYlBVQGyThl6WPOJk4ve4aqB
	bU5ZNHWiq86/t4H017gU7Xyp+BcYPSwf30tof/F0jQ0Z1WAyzbN4rppd9yxwonE8BLSQb1/N1Mn
	+H441nYZgFFBrspovajnD/KBZ5VcLOFhAThSo1V3vGma2phkU56xorJua1NXEDkbKWmjsSomdv/
	q07iQw+v33SOA60O13rcPFesiC0UwNfW9+/MetxK0lN2rlVo3N8kb4LihhNYrKMquMaVtMMHmfX
	aJ/WpnaostxaF0jqi2oekZ+Rx5glQOC2v0Q==
X-Google-Smtp-Source: AGHT+IEyTsigtZPgbhvpx+MuI5EopTwKZjdoMifD1NTSeNO2daXO9CQzMNBjpRdj5UTuY7k2V4tUsw==
X-Received: by 2002:a05:600c:3b04:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-45b517e9d34mr148656765e9.30.1756209726803;
        Tue, 26 Aug 2025 05:02:06 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66b6985bsm14737615e9.2.2025.08.26.05.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 05:02:05 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E51785F80C;
	Tue, 26 Aug 2025 13:02:03 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  richard.henderson@linaro.org,  kvm@vger.kernel.org,
  qemu-devel@nongnu.org
Subject: Re: [PATCH v2] kvm/kvm-all: make kvm_park/unpark_vcpu local to
 kvm-all.c
In-Reply-To: <20250826132322.7571b918@fedora> (Igor Mammedov's message of
	"Tue, 26 Aug 2025 13:23:22 +0200")
References: <20250815065445.8978-1-anisinha@redhat.com>
	<20250826132322.7571b918@fedora>
User-Agent: mu4e 1.12.12; emacs 30.1
Date: Tue, 26 Aug 2025 13:02:03 +0100
Message-ID: <87cy8i1ebo.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Igor Mammedov <imammedo@redhat.com> writes:

> On Fri, 15 Aug 2025 12:24:45 +0530
> Ani Sinha <anisinha@redhat.com> wrote:
>
>> kvm_park_vcpu() and kvm_unpark_vcpu() is only used in kvm-all.c. Declare=
 it
>> static, remove it from common header file and make it local to kvm-all.c
>>=20
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>
> Reviewed-by: Ani Sinha <anisinha@redhat.com>

?

I assume you meant reviewed by Igor but I'm not sure what b4 will do
now.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

