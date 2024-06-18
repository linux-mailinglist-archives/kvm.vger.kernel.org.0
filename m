Return-Path: <kvm+bounces-19849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EBB90C88B
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 13:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE5971F21B52
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 11:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3386C20829A;
	Tue, 18 Jun 2024 09:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bhEGimsZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B7B208292
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 09:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718704440; cv=none; b=tHnyYWq9ErPzi8H3r0duM4ssBoCNon6aWZcKUqBGeLboKY0Kh7/H9TwVTX9sK2CG2iPyyVS30QVV/umq7ziY37+lYksuRLOhYwossg7m8/AgKog+xg6k6mF9MC9BP1nwpW/wz2N2Ylc/f/ki03WRoJRJi3X7KdS67kJda14lZ/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718704440; c=relaxed/simple;
	bh=GSMbjUYI+aKHLafvouvq/uH/6+NG6/kiQD6w5gQ3TKA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ROHenHf5uzESGZg+oQGysGQZ6hfKF2fF3F9zFyxu5zx+88OGNpyvEJBLX6+NRCU1fdXI2JSEC3y6vv8Oez7jerCSKHwN8AKZXg/IqKpAujUVeBRim4HCXDwN/Z0q3apCCvktI+V5Y/3cvZTmrxHAZSvYk5gqUpypm8uNTwI6EPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bhEGimsZ; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-421798185f0so41556085e9.1
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 02:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718704437; x=1719309237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gXF1PJ4Uha8/rBYPYkTY+qderDnntrtGPsFK0GwQRRc=;
        b=bhEGimsZaT0D7cJYfAT4WT1INurxJ+YWHJ3kKogHrMN3h13zCtql8dYRpsv8C+RiYU
         99TwpcZohBeLeM9DFwNhTu+1btzuimTGTyd2/1Zaz7qzLY98qADQZIe6Cymv2mT/+M/V
         FK8bxiLoD2MRzVixYBQgJC0AmLJhrrcyMga7qjoFvhFUlp1WwFJMnoO7HC2ph8I/dW6R
         3lN0iA2X75GOC80Wa4GRMVd6cAx0nnrwKD4qQikdpX1Kh/G0NC98knaDRJ1EaYm1z1rF
         YS5OjbXHnrww8MCjvKXHpDQomt/JoQCp5ehknQ7buvm323Z18XZ8PU354/z8X8JPWtHq
         lOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718704437; x=1719309237;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gXF1PJ4Uha8/rBYPYkTY+qderDnntrtGPsFK0GwQRRc=;
        b=evmbYlyaCW3JnvVvrG2JXmNKqmTYa/jQz2lsznyKpYbjCuIXd/G7Y3pKHmB4LRe8T3
         mMWcLgQmKLs0kLUnvyHXNPz+iEVothPxP1gtaKfqt1WNDMuUSZbjhFEu5tos+OjreLib
         Ew8/YDN4WcEMPFtrsyvp1zZTNm29RQfl4Y0wjhna62gK/Yrx/Oo+Dp7t9UJQV+75jl3m
         eUbCeXwJOsfvPW6CQcN7BICdHmCltb981+zk5GED3UbYSUBczuh8rPD1U37WN89zvAc6
         RAYvSh803N2kUj4YAjQTdWD2RJA5kb5/kGNNCjO/9o9ohx35YpTFvKO3Yk2l1g/tpA+H
         k79w==
X-Forwarded-Encrypted: i=1; AJvYcCWtfcWpLj1PjGtM8POuVoReOinFzDhUjFMzs6hgRqTtHNuHysh3V1Cu0CPUmL3jXBzgQFjmjNnh0nEm7FjFW0MamQ+Y
X-Gm-Message-State: AOJu0YxcqVQPOrDpZu6pbNItbLVWjX6v3TJNAnV/t/UOubD/tqqLMUcF
	adTLeUqPBhX4Aq+lR5nLWn3/uS9GvFRHxL0P5F/sTkLStunGsgS8CCBDVjd+gcQ=
X-Google-Smtp-Source: AGHT+IFhlF3hgJqwNC1kT5uuSbB14ovBJTJLMfQeME31lq2xN12DFaRayAEeSgz/ORSGrVl6+zvRkA==
X-Received: by 2002:a05:600c:4448:b0:421:819c:5d6b with SMTP id 5b1f17b1804b1-423048262c3mr89662145e9.23.1718704436656;
        Tue, 18 Jun 2024 02:53:56 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075104b74sm13696342f8f.107.2024.06.18.02.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 02:53:56 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 87BFA5F8AC;
	Tue, 18 Jun 2024 10:53:55 +0100 (BST)
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
In-Reply-To: <4e5fded0-d1a9-4494-a66d-6488ce1bcb33@linaro.org> (Pierrick
	Bouvier's message of "Mon, 17 Jun 2024 15:29:56 -0700")
References: <20240612153508.1532940-1-alex.bennee@linaro.org>
	<20240612153508.1532940-10-alex.bennee@linaro.org>
	<ZmoM2Sac97PdXWcC@gallifrey>
	<777e1b13-9a4f-4c32-9ff7-9cedf7417695@linaro.org>
	<Zmy9g1U1uP1Vhx9N@gallifrey>
	<616df287-a167-4a05-8f08-70a78a544929@linaro.org>
	<ZnCi4hcyR8wMMnK4@gallifrey>
	<4e5fded0-d1a9-4494-a66d-6488ce1bcb33@linaro.org>
Date: Tue, 18 Jun 2024 10:53:55 +0100
Message-ID: <874j9qefv0.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 6/17/24 13:56, Dr. David Alan Gilbert wrote:
>> * Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
>>> On 6/14/24 15:00, Dr. David Alan Gilbert wrote:
>>>> * Pierrick Bouvier (pierrick.bouvier@linaro.org) wrote:
>>>>> Hi Dave,
>>>>>
>>>>> On 6/12/24 14:02, Dr. David Alan Gilbert wrote:
>>>>>> * Alex Benn=C3=A9e (alex.bennee@linaro.org) wrote:
>>>>>>> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>>>>
>>>>>>> This plugin uses the new time control interface to make decisions
>>>>>>> about the state of time during the emulation. The algorithm is
>>>>>>> currently very simple. The user specifies an ips rate which applies
>>>>>>> per core. If the core runs ahead of its allocated execution time the
>>>>>>> plugin sleeps for a bit to let real time catch up. Either way time =
is
>>>>>>> updated for the emulation as a function of total executed instructi=
ons
>>>>>>> with some adjustments for cores that idle.
>>>>>>
>>>>>> A few random thoughts:
>>>>>>      a) Are there any definitions of what a plugin that controls time
>>>>>>         should do with a live migration?
>>>>>
>>>>> It's not something that was considered as part of this work.
>>>>
>>>> That's OK, the only thing is we need to stop anyone from hitting probl=
ems
>>>> when they don't realise it's not been addressed.
>>>> One way might be to add a migration blocker; see include/migration/blo=
cker.h
>>>> then you might print something like 'Migration not available due to pl=
ugin ....'
>>>>
>>>
>>> So basically, we could make a call to migrate_add_blocker(), when someo=
ne
>>> request time_control through plugin API?
>>>
>>> IMHO, it's something that should be part of plugin API (if any plugin c=
alls
>>> qemu_plugin_request_time_control()), instead of the plugin code itself.=
 This
>>> way, any plugin getting time control automatically blocks any potential
>>> migration.
>> Note my question asked for a 'any definitions of what a plugin ..' -
>> so
>> you could define it that way, another one is to think that in the future
>> you may allow it and the plugin somehow interacts with migration not to
>> change time at certain migration phases.
>>=20
>
> I would be in favor to forbid usage for now in this context. I'm not
> sure why people would play with migration and plugins generally at
> this time (there might be experiments or use cases I'm not aware of),
> so a simple barrier preventing that seems ok.
>
> This plugin is part of an experiment where we implement a qemu feature
> (icount=3Dauto in this case) by using plugins. If it turns into a
> successful usage and this plugin becomes popular, we can always lift
> the limitation later.
>
> @Alex, would you like to add this now (icount=3Dauto is still not
> removed from qemu), or wait for integration, and add this as another
> patch?

I think we follow the deprecation process so once integrated we post a
deprecation notice in:

  https://qemu.readthedocs.io/en/master/about/deprecated.html

and then remove it after a couple of releases.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

