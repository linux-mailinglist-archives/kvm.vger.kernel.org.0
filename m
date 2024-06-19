Return-Path: <kvm+bounces-19951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B525390E744
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 11:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAD321C211FF
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 09:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1776D80C09;
	Wed, 19 Jun 2024 09:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A9vVny14"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4847C7BB13
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 09:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718790575; cv=none; b=gXr2Ps6H23bzDi3OW+Sb6xZijLTPZ6CuGyuphjpybSEjAOf2e2937GKfpOZxeVDqq8SJgRf8EVLTEFSSicfTQf8c1fZOAwOP0JBpEVhmas5PjucFzYEhVlknPCDonsif/th76tVYhOQm5m/uDGf1OZXdWmtfMHDwI4qjMWxrJTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718790575; c=relaxed/simple;
	bh=3tcrTWtBBs390EOUGfLAbgVqfABEWhBTmWYXhVi/f6s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mtIC47RLi0Phj4z5LCcM43HQQtlDrA7dTNIikBl12kLWRB343MMhqcoNxTrA9VaSxZtnGfkpKRqhRoHnen55bA0XCexDnIk1fvKJAYjubOk2xgNF5zs0YPuXtIUqeRU3zdfIo7tP0TpLPQOYOfXdvL9AgHImGmz0zPHVxyyh7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A9vVny14; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52bc3130ae6so6773988e87.3
        for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 02:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718790571; x=1719395371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZjtPRtpkJLg/ogEv09VMOdk8FrTUkXY1EysubWY2fGE=;
        b=A9vVny14kEUqrBdRNc/fY9jOB1+v4UC3HgafPcmpzj+Yq6aD4Fgj46uxtg666sa63q
         Fcw9x+utWbzZi3qFaq5rs9oVsS70ZmnLDexg3DOEz/E8FqMmJLbRyT2xJBCeFXYDuksf
         q/OUtP2eAGk1hvcBsAfIdNbUq6joFw3p/LhOXF6ZtzfJN/9YJFBdA2MSI/4OjV+L7/4a
         YySEUJcbL4FMk8EmqcxsN4B/Vl5zgZ5QfLPt+TrWdc0A0gxpENmrpM5zx1fmg3Umv1ey
         pKNS2CPbeJ0V+RPysOUsB38zgS09vdOFCkV/XjPwqhB8uXS8nhlRIT6IxZA+yzLqN/Vp
         pMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718790571; x=1719395371;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZjtPRtpkJLg/ogEv09VMOdk8FrTUkXY1EysubWY2fGE=;
        b=WgqUguu0M7kFmzPykTalaLZa4nPiWBian/exI++FANFmYmibciSy/AIIMRsPJANYwU
         5qDu0fXo6So1SdAlKGHM7qHBnybI61eHjVjVlFGmfYAoABLYUwUaeVzBWikSRAGx0xKk
         vGUyQ3eRiq8NHjEDF4iUEDDClwBLIurRJH2pWZCSgTxJtSih2vATKFK185NEHttDi3nY
         BEMIcTrMFRsIGUr+Ou+6+fStrLgHNgoT2BYdFtaad5ea50OAIFK2bAEhwv7PJKxlNvvs
         QTzeaMKStbAFmX9ywbHBXVBORpR+u0Yj7NhQzxNcQbhBkxKtc7FpyCIaStkFoZuikMJF
         +Aww==
X-Forwarded-Encrypted: i=1; AJvYcCWGeWRkrTdbhgV5Y9oxIYHsLP/am0yG4CxQ1TEwbOu79Kfq62CimmEQDF4V2rcJ6txDyna7H3sMe9fIal3kAaL8Bj/9
X-Gm-Message-State: AOJu0YxtGm/RvF4j0iSu3kzeXQamB4kr0X8t0i4r7KQHogAftjQSUY4k
	zfBRa4hVZu8laNIQTz3sd3QB4CMxYHZc5Qp1+ZqVc4Lb6GVJ6D0eGj9WOcLe3PM=
X-Google-Smtp-Source: AGHT+IFZ4Bs6HOrr7cCkBsUdVsmcbltrAhLdDO8C6hljtXM1CyiC/jIYipaT61lxotWMKvpCLzO9Xg==
X-Received: by 2002:ac2:5189:0:b0:52c:9f3a:2bee with SMTP id 2adb3069b0e04-52ccaa37769mr1007899e87.38.1718790571345;
        Wed, 19 Jun 2024 02:49:31 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-422f5f33c43sm226145235e9.7.2024.06.19.02.49.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jun 2024 02:49:28 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DB09F5F919;
	Wed, 19 Jun 2024 10:49:26 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: "Dr. David Alan Gilbert" <dave@treblig.org>,  qemu-devel@nongnu.org,
  David Hildenbrand <david@redhat.com>,  Ilya Leoshkevich
 <iii@linux.ibm.com>,  Daniel Henrique Barboza <danielhb413@gmail.com>,
  Marcelo Tosatti <mtosatti@redhat.com>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Mark
 Burton <mburton@qti.qualcomm.com>,  qemu-s390x@nongnu.org,  Peter Maydell
 <peter.maydell@linaro.org>,  kvm@vger.kernel.org,  Laurent Vivier
 <lvivier@redhat.com>,  Halil Pasic <pasic@linux.ibm.com>,  Christian
 Borntraeger <borntraeger@linux.ibm.com>,  Alexandre Iooss
 <erdnaxe@crans.org>,  qemu-arm@nongnu.org,  Alexander Graf
 <agraf@csgraf.de>,  Nicholas Piggin <npiggin@gmail.com>,  Marco Liebel
 <mliebel@qti.qualcomm.com>,  Thomas Huth <thuth@redhat.com>,  Roman
 Bolshakov <rbolshakov@ddn.com>,  qemu-ppc@nongnu.org,  Mahmoud Mandour
 <ma.mandourr@gmail.com>,  Cameron Esfahani <dirty@apple.com>,  Jamie Iles
 <quic_jiles@quicinc.com>,  Richard Henderson
 <richard.henderson@linaro.org>
Subject: Re: [PATCH 9/9] contrib/plugins: add ips plugin example for cost
 modeling
In-Reply-To: <78003bee-08f7-4860-a675-b09721955e60@linaro.org> (Pierrick
	Bouvier's message of "Tue, 18 Jun 2024 21:40:32 -0700")
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
	<20240612153508.1532940-10-alex.bennee@linaro.org>
	<ZmoM2Sac97PdXWcC@gallifrey>
	<777e1b13-9a4f-4c32-9ff7-9cedf7417695@linaro.org>
	<Zmy9g1U1uP1Vhx9N@gallifrey>
	<616df287-a167-4a05-8f08-70a78a544929@linaro.org>
	<ZnCi4hcyR8wMMnK4@gallifrey>
	<4e5fded0-d1a9-4494-a66d-6488ce1bcb33@linaro.org>
	<874j9qefv0.fsf@draig.linaro.org>
	<78003bee-08f7-4860-a675-b09721955e60@linaro.org>
Date: Wed, 19 Jun 2024 10:49:26 +0100
Message-ID: <87jzilcleh.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 6/18/24 02:53, Alex Benn=C3=A9e wrote:
>> Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:
>>=20
>>> On 6/17/24 13:56, Dr. David Alan Gilbert wrote:
>>>> * Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
>>>>> On 6/14/24 15:00, Dr. David Alan Gilbert wrote:
>>>>>> * Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
>>>>>>> Hi Dave,
>>>>>>>
>>>>>>> On 6/12/24 14:02, Dr. David Alan Gilbert wrote:
>>>>>>>> * Alex Benn=C3=A9e (alex.bennee@linaro.org) wrote:
>>>>>>>>> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>>>>>>
>>>>>>>>> This plugin uses the new time control interface to make decisions
>>>>>>>>> about the state of time during the emulation. The algorithm is
>>>>>>>>> currently very simple. The user specifies an ips rate which appli=
es
>>>>>>>>> per core. If the core runs ahead of its allocated execution time =
the
>>>>>>>>> plugin sleeps for a bit to let real time catch up. Either way tim=
e is
>>>>>>>>> updated for the emulation as a function of total executed instruc=
tions
>>>>>>>>> with some adjustments for cores that idle.
>>>>>>>>
>>>>>>>> A few random thoughts:
>>>>>>>>       a) Are there any definitions of what a plugin that controls =
time
>>>>>>>>          should do with a live migration?
>>>>>>>
>>>>>>> It's not something that was considered as part of this work.
>>>>>>
>>>>>> That's OK, the only thing is we need to stop anyone from hitting pro=
blems
>>>>>> when they don't realise it's not been addressed.
>>>>>> One way might be to add a migration blocker; see include/migration/b=
locker.h
>>>>>> then you might print something like 'Migration not available due to =
plugin ....'
>>>>>>
>>>>>
>>>>> So basically, we could make a call to migrate_add_blocker(), when som=
eone
>>>>> request time_control through plugin API?
>>>>>
>>>>> IMHO, it's something that should be part of plugin API (if any plugin=
 calls
>>>>> qemu_plugin_request_time_control()), instead of the plugin code itsel=
f. This
>>>>> way, any plugin getting time control automatically blocks any potenti=
al
>>>>> migration.
>>>> Note my question asked for a 'any definitions of what a plugin ..' -
>>>> so
>>>> you could define it that way, another one is to think that in the futu=
re
>>>> you may allow it and the plugin somehow interacts with migration not to
>>>> change time at certain migration phases.
>>>>
>>>
>>> I would be in favor to forbid usage for now in this context. I'm not
>>> sure why people would play with migration and plugins generally at
>>> this time (there might be experiments or use cases I'm not aware of),
>>> so a simple barrier preventing that seems ok.
>>>
>>> This plugin is part of an experiment where we implement a qemu feature
>>> (icount=3Dauto in this case) by using plugins. If it turns into a
>>> successful usage and this plugin becomes popular, we can always lift
>>> the limitation later.
>>>
>>> @Alex, would you like to add this now (icount=3Dauto is still not
>>> removed from qemu), or wait for integration, and add this as another
>>> patch?
>> I think we follow the deprecation process so once integrated we post
>> a
>> deprecation notice in:
>>    https://qemu.readthedocs.io/en/master/about/deprecated.html
>> and then remove it after a couple of releases.
>>=20
>
> Sorry, I was not clear. I meant do we add a blocker in case someone
> tries to migrate a vm while this plugin is used?

Oh yes - I can add that in the core plugin code.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

