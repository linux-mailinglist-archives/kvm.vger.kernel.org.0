Return-Path: <kvm+bounces-16446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC19E8BA36F
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C471CB212C1
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 22:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D37381BC53;
	Thu,  2 May 2024 22:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ujVMxPHJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D3518EB0
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 22:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714689926; cv=none; b=MSj8EX0e52VnWx5dK5tOKGEmPtm6kMLBheSwrJi1FyHcXIZ0wj4O310p2wVIG7u6micaVZx7/RNT63Z4MabX9YJDshLMXaUDw4LiVaSUfsn6MTHBXZErkyAZIHmPindUzAhxq6PqKw1zQw/Dvg210bydgN0ENkT0Yj1BX8YE1ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714689926; c=relaxed/simple;
	bh=I3uuLxNzOCssz8m+55xA6cGRFEwNKBKZs5w/RJydG7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FjaC9oOtYul4uvsPFVmhP0KAs0xOv2VIxezzJ1zW4NkE4BpgMWNzGuyhtQOvwnDApij2qhYj8wetrfDXuozLC/Uc6aQ5KEklXDBpkWWu1XgU7ZWqt0DrWXFIzAyXtZzT6A2Mm9xawmH4brTyQnJ9bemrmlIPxXTd1X3pown1Oi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ujVMxPHJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de615257412so7027870276.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 15:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714689923; x=1715294723; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ng8wdniletCwnFQX4IxNkyDUgPARM59dfJ0NnGdDa/E=;
        b=ujVMxPHJ2Cn7k+MIfeXQJknX/zdFnoKByglTesLMNxj9NselwIXhhpSSTGw4glqJL/
         UUVuvlEYuBXfS9wvx43VAFRprj+J2AdpfK2KPsBl115Wz0HP//N62Esnh97eVseorvZB
         x4CYopuRvL8/28ozmAeuYmxynuLVqi6BBF03BHJjxanCvSHuHdaL+9IYTpkxmX5+T9G3
         rgsnEDk0iO0LMYeZvxKiA2yfbZVa5Ojc+dIjb16R84BRheBPuBLT6uh5DVkGXcwLumsI
         sJ6WZ7Ripb3ZfvvXusjMN0r9N/pOJdqMtkxg1GYkzf+sOfH84O6btzuIUxWvOonOpzKj
         G8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714689923; x=1715294723;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ng8wdniletCwnFQX4IxNkyDUgPARM59dfJ0NnGdDa/E=;
        b=P1+PK3O8heoyMDLOKH8r6FFW4Feh2SmHSoOuTM0CFED1C5F/PDX1ndREbVGUTNrRZU
         syMh4k0uCN6jcl85k1zsQHUu1oRYg2GwOxwzW0BtXjCJzSVzz5VUW6GblF9ZtzSKWB/q
         6YucuRB4yvMHSErJquxZTc9EoFkt0NITO9jf4f4tb2KEpoiFYqjAlJHDmuyZjQBdKFtU
         jo/jZYniMgvN4t8iZmyYm6XaNf7t3AMZH80LrLgovt/Gozy68aBfnO4d6UdtZT4B6LpR
         Dq0g01UNOiazUjsyYHYLp6oiYX4xAxLh541dmz0loEbhCRltgVWCd3rDvNqRjoV4ErJK
         /8Pg==
X-Forwarded-Encrypted: i=1; AJvYcCUAtmHYd/1N5/jU23tfhumK9azR/vSxfL5Z8vZq8DU1OB3hL0ph2Au3+ZEOJdTD5WmmxAnJ57J/xdCbeR64P0G2Ca5B
X-Gm-Message-State: AOJu0Yx6wypP7C+IJ1QRdHOymFSo78lcRdamXUI9Lk7ediOWPdUn3lJI
	NlxM//8HfvGgNW9dIWwcJjaqSB6pfWBrEV+XK9yoDg+Pz7GMgWE24wwb2TR1M1OdHVHEb7aoDrw
	Csg==
X-Google-Smtp-Source: AGHT+IHSaclY4T7RoFl8xX5G9CqldxXXjOMPdHJpuQAdr0cFPX+iMLHEEOj88Q1SBORTFHpk2Agd2Mml/kE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154f:b0:dc6:cd85:bcd7 with SMTP id
 r15-20020a056902154f00b00dc6cd85bcd7mr359179ybu.3.1714689923750; Thu, 02 May
 2024 15:45:23 -0700 (PDT)
Date: Thu, 2 May 2024 15:45:22 -0700
In-Reply-To: <20240502210926.145539-11-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240502210926.145539-1-mic@digikod.net> <20240502210926.145539-11-mic@digikod.net>
Message-ID: <ZjQXghB6imRFU4HX@google.com>
Subject: Re: [PATCH v4 10/10] selftests/harness: Fix TEST_F()'s exit codes
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Christian Brauner <brauner@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Mark Brown <broonie@kernel.org>, 
	Shengyu Li <shengyu.li.evgeny@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, Will Drewry <wad@chromium.org>, 
	kernel test robot <oliver.sang@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> @@ -462,8 +462,10 @@ static inline pid_t clone3_vfork(void)
>  		munmap(teardown, sizeof(*teardown)); \
>  		if (self && fixture_name##_teardown_parent) \
>  			munmap(self, sizeof(*self)); \
> -		if (!WIFEXITED(status) && WIFSIGNALED(status)) \
> -			/* Forward signal to __wait_for_test(). */ \
> +		/* Forward exit codes and signals to __wait_for_test(). */ \
> +		if (WIFEXITED(status)) \
> +			_exit(_metadata->exit_code); \

This needs to be:

		if (WIFEXITED(status)) \
			_exit(WEXITSTATUS(status)); \

otherwise existing tests that communicate FAIL/SKIP via exit() continue to =
yield
exit(0) and thus false passes.

If that conflicts with tests that want to communicate via _metadata->exit_c=
ode,
then maybe this?

		if (WIFEXITED(status)) \
			_exit(WEXITSTATUS(status) ?: _metadata->exit_code); \

Or I suppose _metadata->exit_code could have priority, but that seems weird=
 to
me, e.g. if a test sets exit_code and then explodes, it seems like the expl=
osion
should be reported.

> +		if (WIFSIGNALED(status)) \
>  			kill(getpid(), WTERMSIG(status)); \
>  		__test_check_assert(_metadata); \
>  	} \
> --=20
> 2.45.0
>=20

