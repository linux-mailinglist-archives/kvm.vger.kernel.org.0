Return-Path: <kvm+bounces-19593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6E690779E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 17:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C6E71F2315F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 15:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B2B12EBC2;
	Thu, 13 Jun 2024 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SmGpTdQ0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9C32BB04
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718294200; cv=none; b=V7mznXkMidOe183dttBxm9aUL60SoFR/kO3Fak1+jesL86A1Fdum0ZQZ3H2g+wiVNlXyBOzbkvbo/hhy/OLMEd4xeDNxkpPGGXvKxovwRl1mYTSb5xCArUqNbRPwwHZt/wQnnqAyYgUcuBUhNopo0PRsmfYu7ZAul+dxUNSBf7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718294200; c=relaxed/simple;
	bh=CnL2wkkIbEGtC/SWlVURu8sMQFMqBajpjMRHk4Ifyu8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=so/t6XlI1KSF17BY0I99eC6/A6It5a58lwsEI+DbfDXD/t3ayts2wLuvVO4abzr0kbYl9RhtrptfqH6CDSLEqwcrd2zd+m5tL4GQZjqeasfRJ25eYmrRxpX12KX82eE3o+YmW216XG79lKJXfBkSwpHBJ57Z0c893etIQafbO2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SmGpTdQ0; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ebeefb9a7fso11952221fa.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 08:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718294197; x=1718898997; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8YtzJE9zAkjTgDWzFu3+UQx6DXuF/sVtVwjxO60G1W0=;
        b=SmGpTdQ0nXs3Zprz7ZqgEnwUryKbWYugxSIIwp55QIEgpyE0znoK3lA7HRqQN5DiVZ
         S9xfyUtxUG8feZoaAU8kmxCW5RaAj2yaq4kPH8vy3kgPZdo6daj27uYmBGj09f04D4vn
         /dYY5kxPd2qVlZoSeWXz+QfY/dkZT48QpY0N8k4GetzMgw0A99SZXUFd/9LxPeBmSfd6
         Hd3qZxhU+hGcPmdXt50CDkVxqQkgoVwUQmIUsqVNPKtqQ1L5HTNgD/7QlTOAiyQcvRIW
         aBXGRDMFTo0K4uZvsC8UnDwo3btsIPmLJwq55YZyy0Y73C5Ebfd7CLzgtjbBD/hHqePH
         oBcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718294197; x=1718898997;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8YtzJE9zAkjTgDWzFu3+UQx6DXuF/sVtVwjxO60G1W0=;
        b=HqJVvApd398S8BU28v8bocCHWr+SoasnHw2eW1Ho3w5A/Eq7MIwTCWZqSd2VUH/1ID
         jJyqj/8nqhcnNYY79rHWTKSbfexu/ypzfKH0sleaL1WS+4tE1IzeGgJZboDcBpDcYJCb
         UyCo8Z6xXEvqUx/0a1BiUbrrFD+cyMEKa+yH5huv9vwKdr1lZ0eaP933iABssnOb7nbO
         2On5/jBiJ3UsEhGQqJTyO042ChuKIsfATX186Yeb53r4dlCqW17NGzd/T/xkQQT2GKmj
         j72e15MP06+BHrk1i4MaQsrRFC64OBjskbFm9q9b8mJbAgHOToizonIvXoBUKaeliruI
         KhIg==
X-Forwarded-Encrypted: i=1; AJvYcCVrJnr6bz89aWL3srCwCy9QE3/QSGdYgsKWWSotCs4jkyOx+1GcrQaxjU8vSFHTL6UgdgbiznrnfNhnYL8LtoQfIYwn
X-Gm-Message-State: AOJu0YyzAt4e1TwKOBmS7mt2s4oTfoDzfPtzuK97F+63zDF1wLR5Pu4p
	VYOY5kGErQsVKsNK69RFPPWe0v1AWjFA1oV0qGpT9ZcrwuuISDzi5YvZ2eF/lEo=
X-Google-Smtp-Source: AGHT+IHJaYZKsvz64jRvX35XKihrVj916LiCpv7D+1hg0yA075wN+w0ZLiWmKimWI+45ynqIxOrYNQ==
X-Received: by 2002:a05:6512:6c:b0:52c:8024:1db with SMTP id 2adb3069b0e04-52ca6e9a378mr100980e87.63.1718294196984;
        Thu, 13 Jun 2024 08:56:36 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422874de5d5sm66893595e9.33.2024.06.13.08.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jun 2024 08:56:36 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F36735F7A1;
	Thu, 13 Jun 2024 16:56:35 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  David Hildenbrand <david@redhat.com>,  Ilya
 Leoshkevich <iii@linux.ibm.com>,  Daniel Henrique Barboza
 <danielhb413@gmail.com>,  Marcelo Tosatti <mtosatti@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  Mark Burton <mburton@qti.qualcomm.com>,
  qemu-s390x@nongnu.org,  Peter Maydell <peter.maydell@linaro.org>,
  kvm@vger.kernel.org,  Laurent Vivier <lvivier@redhat.com>,  Halil Pasic
 <pasic@linux.ibm.com>,  Christian Borntraeger <borntraeger@linux.ibm.com>,
  Alexandre Iooss <erdnaxe@crans.org>,  qemu-arm@nongnu.org,  Alexander
 Graf <agraf@csgraf.de>,  Nicholas Piggin <npiggin@gmail.com>,  Marco
 Liebel <mliebel@qti.qualcomm.com>,  Thomas Huth <thuth@redhat.com>,  Roman
 Bolshakov <rbolshakov@ddn.com>,  qemu-ppc@nongnu.org,  Mahmoud Mandour
 <ma.mandourr@gmail.com>,  Cameron Esfahani <dirty@apple.com>,  Jamie Iles
 <quic_jiles@quicinc.com>,  "Dr. David Alan Gilbert" <dave@treblig.org>,
  Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH 8/9] plugins: add time control API
In-Reply-To: <c4d36875-c70d-4e2c-b3a8-c50459c9db0f@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Thu, 13 Jun 2024 10:57:22
 +0200")
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
	<20240612153508.1532940-9-alex.bennee@linaro.org>
	<c4d36875-c70d-4e2c-b3a8-c50459c9db0f@linaro.org>
Date: Thu, 13 Jun 2024 16:56:35 +0100
Message-ID: <87r0d0vnt8.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> On 12/6/24 17:35, Alex Benn=C3=A9e wrote:
>> Expose the ability to control time through the plugin API. Only one
>> plugin can control time so it has to request control when loaded.
>> There are probably more corner cases to catch here.
>> From: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> Some of your patches include this dubious From: header, maybe strip?

I think because my original RFC patches went via Pierrick before pulling
back into my tree. I can clean those up.

>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> [AJB: tweaked user-mode handling]
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Message-Id: <20240530220610.1245424-6-pierrick.bouvier@linaro.org>
>> ---
>> plugins/next
>>    - make qemu_plugin_update_ns a NOP in user-mode
>> ---
>>   include/qemu/qemu-plugin.h   | 25 +++++++++++++++++++++++++
>>   plugins/api.c                | 35 +++++++++++++++++++++++++++++++++++
>>   plugins/qemu-plugins.symbols |  2 ++
>>   3 files changed, 62 insertions(+)

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

