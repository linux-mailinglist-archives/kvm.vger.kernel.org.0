Return-Path: <kvm+bounces-19501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD091905C12
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 21:37:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD9EA1C21144
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 19:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB70183A09;
	Wed, 12 Jun 2024 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="un+L9lm7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5322C3A29F
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 19:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718221064; cv=none; b=YuFpvY9v8IK4E0iphWxURMbDGVyFDxrNiRasJ8hTRmNOIo4Bi39ogEVXDJhEMo6QOGhqK6P2vBLjum9SaWDoh4C7yVFDV/GSRNUWKVYZOU3usGmdfOLYsHs90ovCpLANqge1X9HAk1CUtCs0LaKgYuNDNLVSLeFeAWrCLfbBBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718221064; c=relaxed/simple;
	bh=IAjYSIJy3iUmCe4piphWkEv6nCY066xAzP9Cs/eLYu8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DENHotfq1Lj/8YE8djiUjwQXUAyWUSVeTi8sBugBivCfMTy0mlZeaHcAWXLD/i2K3YhZavPUer66toBMu+3ReT4MDDTdkDYUUf5/S1XFZo/iPEWU4Wpf9pz9EMSyfCkqYFzXcgMZs2VRKNnwGrnpU2NJO4gqIUmB09q4Dzufc2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=un+L9lm7; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57c7681ccf3so117277a12.2
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 12:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718221060; x=1718825860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IAjYSIJy3iUmCe4piphWkEv6nCY066xAzP9Cs/eLYu8=;
        b=un+L9lm7GGs/j+5A081iSBkYEnyc6WhiQGvE2CIHjEA0T6DOC4iXt+ta7WCWDaQ35d
         k2NGogH9/G2Xrill6x6EpvqwRY/9MxfucTRm/xAbDyuQycLfCWJlrAwG/kghNYNh7Zrz
         mV+4NCLqGz5n7UiQBeQJXxHp3Tsjc4CneNjnj6O3ck1ohaysBJ/9t2Y7u4lxvWVS0dlQ
         BdG5YRdZiSKAtAH7Z2+tlGoEgVkFFemeDmg4O1j8NTiegiFpoqH0fZeVIM9ZWVnrg+ur
         dsPDIPsAd/IYDJ91DT6ZRXrG8aB9UTp3MsMIejNOl9qtVhJNDjTfCt31vkmMznr7UxL/
         DVDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718221060; x=1718825860;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAjYSIJy3iUmCe4piphWkEv6nCY066xAzP9Cs/eLYu8=;
        b=Fyt/l613AN9Mp1PaiqB4ZlqiimP1WWyC0vxTRELmTZTu46T7Y0tf1qEkPr2m0dxfEQ
         j8DcnQCGPIwQQerZBOO80n2iJsCRdv2JX8c+rbf4lI2npYpjLIbeYT8DA83WibBatQDY
         Ug/rku48UTIiaQuugxmcYAQSA9tC6K3AvIzjgtbDf0us18UvBlBgiX0M4LMWpOc+Xfs4
         mDK7bAjK/b23+9LIEd+w3hWCh74pbd/IBxq9CqLlt4ZhoIlQSnkxfxlq5WrPmSZwKkNE
         3aV7NjmPqz07K2woHYjNjXPDZq4o2rLN3bEO1buuunPwVsluOtdyTaYMicPGut7VIalp
         topQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnMGv4CEq8vVktSjyyWSR/xctGJCnoDG0MJLWWBIQJSfy7UDI6YZkpU2wAse0m6oZQ4S9uZP30nF6hlQ34F2alqUuK
X-Gm-Message-State: AOJu0YzFe8YgYg7OowKsxdFIw1H6MkVvYIsdeh5hcLoGXV5iMm+dHVsk
	rIZ7eJEhCeQVh4nwUyFCExuKaZIIuuWaarOSHidDuSqX2W/qHpAwowRk94lmyKM=
X-Google-Smtp-Source: AGHT+IHSHF+J9LXbsSxNNhuSucQZPz9yQEv/C3Lxowmc20Y1tTB/+h0HyatGxfAnTBj1AYdb9LL1cA==
X-Received: by 2002:a50:cd9e:0:b0:57c:a7dc:b121 with SMTP id 4fb4d7f45d1cf-57caa9bace7mr1795582a12.34.1718221060693;
        Wed, 12 Jun 2024 12:37:40 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57c92901b05sm3656071a12.73.2024.06.12.12.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 12:37:40 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E44EA5F893;
	Wed, 12 Jun 2024 20:37:39 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  David Hildenbrand <david@redhat.com>,  Ilya
 Leoshkevich <iii@linux.ibm.com>,  Daniel Henrique Barboza
 <danielhb413@gmail.com>,  Marcelo Tosatti <mtosatti@redhat.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Mark Burton <mburton@qti.qualcomm.com>,
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
In-Reply-To: <abe88b9b-621a-4956-877d-dd311a7fd58b@linaro.org> (Pierrick
	Bouvier's message of "Wed, 12 Jun 2024 08:56:12 -0700")
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
	<20240612153508.1532940-9-alex.bennee@linaro.org>
	<abe88b9b-621a-4956-877d-dd311a7fd58b@linaro.org>
Date: Wed, 12 Jun 2024 20:37:39 +0100
Message-ID: <87ikyevtoc.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> Hi Alex,
>
> I noticed the new symbols lack QEMU_PLUGIN_API qualifier in
> include/qemu/qemu-plugin.h:
> - qemu_plugin_update_ns
> - qemu_plugin_request_time_control
>
> So it would be impossible to use those symbols on windows.
>
> I kept a reminder to send a new patch after you pulled this, but if we
> go to a new series, it could be as fast for you to just add this
> directly.

Sure if you send the patch I'll just merge it into the series.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

