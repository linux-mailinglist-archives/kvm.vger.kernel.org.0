Return-Path: <kvm+bounces-18713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D433A8FA9CE
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:15:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 750DD1F24C9E
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121E313D897;
	Tue,  4 Jun 2024 05:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O66PS6JO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ED12A8D0
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717478013; cv=none; b=UY656l6OHYRRypVOBIkgeJpP/dxLNpHeoElZLGey2V6ZN0q+PV2UPT5K5Evj4THOs81W7i4wQysoTAdSTvLTfrVmD6DMZ8zny0Jx/5zL5IBOPJmhsKWOz7F+2L8pBHoBW4OoL1Tpcdm3uxQ4mJzMhcqnhP0qeoPpwSPrFU9A2ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717478013; c=relaxed/simple;
	bh=va0UFpIASYHPfbzqO5kjm+RfiMFz0r0LowL8jG4pqzI=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=T0bWseYH2b21XJIdUNDzIeZg7GpytyCvaHGDOR/Lcl+URnUpFmI+x2g4VUvg5OusjVQDNaCogixNirtugym/pj4lx6MzRQXecSyCtpX2bSm9Jn2Ok+AmkQkT5a4Ex9OmEUl7rDlm+diYO44YXT2lgiidOqA2yIdDNEOn3gmJJrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O66PS6JO; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1f44b594deeso37236795ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717478011; x=1718082811; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GT7SfBTLOwpc/YXnH4XWcLEq77fXjMD17/6UtGiAP8o=;
        b=O66PS6JObnjfPQGQbBVwI500yzXa3xAruOeWgjCu+Rej9CyjnVrszdSvdul6kvJHjn
         uJk3Ihrqrt1/fy9o8mLAOLsHnI/539ZwL/rRdtx8zqmHCYRs7sEUgEnSfa2bz9gR1EnC
         soTpiHna2jSeOoFKv0HanaaRyKa/ZaduYz5c5lGyKKikxBhgprqQcCLx/r0y2q0YkBIb
         lHOoP8RE0zfh6zVMDjH7mBwj4VKpLGwLTGXouDL4uLVZVDQhCbiBOm5sK0dRkUOrI21Y
         qlRFc7qnNrk4gLuNo02JI0ryuosPcazfPnVcvFEuoYHVE1zRkqCwpBDHQ0TWL/o6M2Rw
         LFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717478011; x=1718082811;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GT7SfBTLOwpc/YXnH4XWcLEq77fXjMD17/6UtGiAP8o=;
        b=AC0qN8X10MYLsjFgsVwrWfuIR1GRdPpT5XCi2CYgTKTyExdfYLA8ICweAspdB0O5M7
         LraCszIOF0hApUALFcD2x2uZo58r372iN0BPwuO7OnznDiZre0ulYAuXEEVRiQ4+eNPP
         Jzaac7DdK4P3Rxw6hSGa9zVXmRAs6L0d3wiBihURYmKntVIVtbN+9ycZRXY8KIObWRNW
         dCyKoFJyvuhBs5DbGYKgNTjfeSsq00HExwVfzh6NUoyWY3MgU0Xl16EnNOjW5tHJIRAP
         t8RaacvWdjw7cz18CLEAXK9kJU9goXQ+JqeyvrjLzHgP2DAAWg1FmRaeFhbpddyFGmyV
         2Ycw==
X-Forwarded-Encrypted: i=1; AJvYcCXIG2VkQY6ONnvgN03WmUhGJg77HexAewyrJd+2HkBlVpLRqlxLB4YVtAZVgj95DDKaBNE8mSAiPSMHWpuMVABSqyzG
X-Gm-Message-State: AOJu0YzrZOPS67ljrSpvsnk83tOKHriYfKmtopQKv9e2vOD5zCc0pws3
	JcEUgB6ouTb08oBsPRsczalPpbrW1seFpvLPjCJVVpdVrYITIyA3
X-Google-Smtp-Source: AGHT+IFKbc5LjfirCcL45hrRasbp0xZlyYx9lCORURuAdAoEsU4e3Bn/DyFE6rfUbq7e8XuWC9Sp8w==
X-Received: by 2002:a17:903:1109:b0:1f4:b7ff:ac4a with SMTP id d9443c01a7336-1f6370453a9mr122074735ad.37.1717478011071;
        Mon, 03 Jun 2024 22:13:31 -0700 (PDT)
Received: from localhost ([1.146.11.115])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f6323dd918sm73910735ad.164.2024.06.03.22.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:13:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Jun 2024 15:13:26 +1000
Message-Id: <D1QZ53WOLR1C.1QGLYWZV6QFFD@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 14/31] powerpc: Remove broken SMP
 exception stack setup
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-15-npiggin@gmail.com>
 <7059d458-048a-40a5-b21e-4e15568d1f54@redhat.com>
In-Reply-To: <7059d458-048a-40a5-b21e-4e15568d1f54@redhat.com>

On Mon Jun 3, 2024 at 7:30 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > The exception stack setup does not work correctly for SMP, because
> > it is the boot processor that calls cpu_set() which sets SPRG2 to
> > the exception stack, not the target CPU itself. So secondaries
> > never got their SPRG2 set to a valid exception stack.
>
> So secondary CPUs currently must not run into any exceptions?

Yes, at the moment. It was broken anyway.

Patch 16 creates a proper environment for secondaries, including
taking interrupts.

Thanks,
Nick

>
> > Remove the SMP code and just set an exception stack for the boot
> > processor. Make the stack 64kB while we're here, to match the
> > size of the regular stack.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   lib/powerpc/setup.c | 16 ++++++++--------
> >   1 file changed, 8 insertions(+), 8 deletions(-)
>
> Reviewed-by: Thomas Huth <thuth@redhat.com>


