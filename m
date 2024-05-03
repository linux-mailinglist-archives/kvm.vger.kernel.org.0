Return-Path: <kvm+bounces-16516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B28A78BAEA8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 16:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9035B21EA9
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 14:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F6631552E0;
	Fri,  3 May 2024 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ADcoalrC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10238154455
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714745840; cv=none; b=EraK2vKm37pkv9/fTiRvHSYNqZWRXG2uEoGBgemPb1e/Bn92mijppYF77cMvF9J84ZojCm7Rf/se6/gYqw87EXOcjmAYgv7wZq8uxpvz/H6zg6K5X/kfTTmbKx9ZTif6yXLndGLc4i92IyY5N7iiyuxnUjct+0RfdLycygbhfp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714745840; c=relaxed/simple;
	bh=Tw2mHGCJBZondqE0Nbp48iklfjoW+xXMxK0fvzgsi4M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nzwFA8I6uqEAXFUIFLkt+stU5euvdkfnzKP6IG20fj5ob42mIxACD5Nc8d0E/3mPIq5CiGP8bICVzGcRE6XU08N9lQugOp842kAz5LYuxaqUcNG7fGc1hEpGcYHU5hQYCU7Ijf0RC01Mc6LR5BJVNEY92D5M0jcmyvN8lKYvpws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ADcoalrC; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1ed1553c530so14493245ad.3
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 07:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714745838; x=1715350638; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=euaWG2d1xrAd5eW72Lhyga6K2ICgPg5ZdZZkZnwoCG8=;
        b=ADcoalrCktZfm9wwMo8gYx9SYC7zLL5WOagtw8vpTsMTMkDbDzwn95quOU8z6A+z1U
         w3TcXHWTbmcVuYw4tep1j7zpQqyxRgG8Zmy0i2amxcPEcPB7me4Miuzh4DLRxlcMO7nQ
         ueorGKQaj4HmY+AFj9YvipJgTu56gqJsy1E8TAj6ATM2MT3SuR07pTfXyVj/cJtQwsjW
         djpTznxnz05V/o6pRcmmqjoJ8q/lYDziFUKM1xTnYnGKW4ptJbezWxRVqvNt80w0JtSa
         Mm/qsQFB/dc0+ut/dR1mnRuPDNfp+8HOB7OmHUIUiB4DZ2kYIsguNl3LjkgyyeyNAudn
         J87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714745838; x=1715350638;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=euaWG2d1xrAd5eW72Lhyga6K2ICgPg5ZdZZkZnwoCG8=;
        b=F5Jq+aLGjHGzpvPmIVur0FSjb9CybatyZe9YtI2YiN9s6NzHwmVSjHdaDWKkS8U/C9
         A4eQJCCRffhX0Cme5zwG7SuomuUCba0PLSXRPavpiQM6xJCiFvnUdqNC03u7hzAuKigO
         VHThOl2JTee2j4KgFyzm2YPoAQYTDBmb0tUUb9FJLSzJUsntnG32Nv9TaBtoy468unv2
         UYHA2ufHrPPLeSeupDYxodqhioWhBtcL1CNO7+fBgPOq4Dkjgczd36wiRhg+Mj7QRDxy
         i/+AhrvdI/g/n5flgKQb91eaLdruSPyK0ZZxr6wIIZb/CHDwQD7Qj91qRJDap8oa3NhJ
         1QbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOf/dizjJ/Loqx+VMTKYtOM70ARn/QnBkXoHZRBs0UkQmBNni960Jaj+Ass+HD+CQ+rmlllIVjItX2V85eq+h+ZNhd
X-Gm-Message-State: AOJu0Yx3vl1/Hi0tbEBU3RYK/HYHCVe1Chj/ZMEtos/BFq0GQ+s/WzNn
	eA+UtEqunQbpd9DBVjqS8ATgVRahnOz8QWBo6csEmOMRDFV+uoZFiOHV5Wx2JOnm+ddjNkkgzqN
	8Yw==
X-Google-Smtp-Source: AGHT+IFXmNX8BI/5OInh9uFJfx5hH/VOCZeejP86ugVK83ToSLHsemrYMRjQmBhAQcz5sMlxtgdDcmPXGNw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2d0:b0:1e2:97f1:87c0 with SMTP id
 n16-20020a170902d2d000b001e297f187c0mr247114plc.1.1714745838315; Fri, 03 May
 2024 07:17:18 -0700 (PDT)
Date: Fri, 3 May 2024 07:17:16 -0700
In-Reply-To: <20240503105820.300927-11-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503105820.300927-1-mic@digikod.net> <20240503105820.300927-11-mic@digikod.net>
Message-ID: <ZjTx7BYvbrqFSNuH@google.com>
Subject: Re: [PATCH v5 10/10] selftests/harness: Handle TEST_F()'s explicit
 exit codes
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Christian Brauner <brauner@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Mark Brown <broonie@kernel.org>, 
	Shengyu Li <shengyu.li.evgeny@gmail.com>, Shuah Khan <shuah@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, "=?utf-8?Q?G=C3=BCnther?= Noack" <gnoack@google.com>, Will Drewry <wad@chromium.org>, 
	kernel test robot <oliver.sang@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> If TEST_F() explicitly calls exit(code) with code different than 0, then
> _metadata->exit_code is set to this code (e.g. KVM_ONE_VCPU_TEST()).  We
> need to keep in mind that _metadata->exit_code can be KSFT_SKIP while
> the process exit code is 0.
>=20
> Initial patch written by Sean Christopherson [1].

Heh, my pseudo patch barely has any relevance at this point.  How about rep=
lacing
that with:

  Reported-by: Sean Christopherson <seanjc@google.com>
  Closes: https://lore.kernel.org/r/ZjPelW6-AbtYvslu@google.com

> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Will Drewry <wad@chromium.org>
> Link: https://lore.kernel.org/r/ZjPelW6-AbtYvslu@google.com [1]
> Fixes: 0710a1a73fb4 ("selftests/harness: Merge TEST_F_FORK() into TEST_F(=
)")
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240503105820.300927-11-mic@digikod.net
> ---
>=20
> Changes since v4:
> * Check abort status when the grandchild exited.
> * Keep the _exit(0) calls because _metadata->exit_code is always
>   checked.
> * Only set _metadata->exit_code to WEXITSTATUS() if it is not zero.
>=20
> Changes since v3:
> * New patch mainly from Sean Christopherson.
> ---
>  tools/testing/selftests/kselftest_harness.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/=
selftests/kselftest_harness.h
> index eb25f7c11949..7612bf09c5f8 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -462,9 +462,13 @@ static inline pid_t clone3_vfork(void)
>  		munmap(teardown, sizeof(*teardown)); \
>  		if (self && fixture_name##_teardown_parent) \
>  			munmap(self, sizeof(*self)); \
> -		if (!WIFEXITED(status) && WIFSIGNALED(status)) \
> +		if (WIFEXITED(status)) { \
> +			if (WEXITSTATUS(status)) \
> +				_metadata->exit_code =3D WEXITSTATUS(status); \

Ah, IIUC, this works because __run_test() effectively forwards the exit_cod=
e?

	} else if (t->pid =3D=3D 0) {
		setpgrp();
		t->fn(t, variant);
		_exit(t->exit_code);
	}

Tested-by: Sean Christopherson <seanjc@google.com>

> +		} else if (WIFSIGNALED(status)) { \
>  			/* Forward signal to __wait_for_test(). */ \
>  			kill(getpid(), WTERMSIG(status)); \
> +		} \
>  		__test_check_assert(_metadata); \
>  	} \
>  	static void __attribute__((constructor)) \
> --=20
> 2.45.0
>=20

