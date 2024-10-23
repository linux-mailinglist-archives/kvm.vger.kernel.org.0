Return-Path: <kvm+bounces-29473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 415AC9AC256
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6576B23AB8
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 08:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDB11662F1;
	Wed, 23 Oct 2024 08:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aKD5AqyS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FD2157E78
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729673705; cv=none; b=To/xLOL2d5h2OKUS3n4KzbPEegRaTS3HfN+UPlbgr65rU8+0OwF+IihUkE6btAG/JjJT9YSthdgZ/bMQrrNqWlEgsuev+B1oqcJHL1absGAy+K2CS0nLHlf/5KUv1CoUa9Kh7k0HWdmCcZxEWYsF/ZDhMJTBWRsA91I4g/7UaOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729673705; c=relaxed/simple;
	bh=HfQXdylzDl0c9aRRGgrMVa5EhB6hfhw7YWDKePUKfo8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qBq0ryYRDu8JnI3MfFXdaA+w7QtDQOJQrDxVxDNSj5gWu8KVCpjhZSSpT2sDN0uRJOT+cGe4ByFTCeAVVi2/VPFO+uxMmcc0NVb50J+weuHu6B5+jhLk+2pd9XuA+RM7D+sEd4PGdVEIWBLoWhsAJ9SnmGO4hl6h6LI6H4Q0U1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aKD5AqyS; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a6acac4c3so787028466b.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 01:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729673702; x=1730278502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4nV+gFBdOxqmJZLzNg4LSvDE9AZxO4UfO8dN4L5Zwg8=;
        b=aKD5AqySCWccUcMMq6UJV6VdUBtlVu/FR1546UY6P6ZNixo/hLi4eVo2MWeaxzSDzb
         AIzbbY/SfjbBIJp9z8i5hlSArhY5y40r4U3mqkuaKcFe+JxgxSPocAe3e5qpqxbpV+OO
         p1EBirMpzI/PlP2r2fEtK08mPx3snknx58S40A70as/mBpayblxmOfVlryGCoqi7odmd
         B6h88LD/sIVmhaig67bk/a/LUHI4eIEeA2YnMs4LtDfgYD2cYPy03fAR0taD6FFmfPO3
         FlmTZFkrRxMKnxi7EFb3pTSVhDDlz+eQCo5B12rgevsOICA2xB5Zs4BFxlUfS0kA80OR
         m1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729673702; x=1730278502;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4nV+gFBdOxqmJZLzNg4LSvDE9AZxO4UfO8dN4L5Zwg8=;
        b=ExiltmCIJOWzztjWml1vtMqkHf/NoGBYzPjBgK8D9idL9bDolaYfoNqT1A+dfH+y5o
         QrOxzZtuecejX/i2ptZB+GAdPZTIaHRSvE6HRWLev69cepTitOJPvEO3hojJshBIixnU
         9rL5HvkcO5VXj/+zqc1tzJo+n4FXPw0HW7hO9Ta9r37aXRy+18XEuIBsXt0rAd9JxPrm
         VzPvIru3zH9UrrFg6YVWGq4AkmZW9ac40YH9dT72qItogUOhsW3iLOqPJioL/tYmBNam
         uSFfhCyfY/Bikt3pGWllRqzRZ3Il4yabUtaBfvpia9SLrg38XDpF7mcCpph8iv/3gBo4
         PZ3g==
X-Forwarded-Encrypted: i=1; AJvYcCX9/o7RRcJBbDlqj/UBuhC64yZ6me1BQd27okAykYTAD7isPEwSI//EbJpqsVdlYdPdZy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGVqbFs4FuDME8MWjHAmKZZy+QUfRf7j2E7MVaWKA2tvsXHjRE
	SEQxDnX23wwY/LX8AgGAwklp/Pn1si4jI6WITZAcsIoGFr8f/VGJ/xQ1JjHg0Ws=
X-Google-Smtp-Source: AGHT+IH5mgOf6nBi3FexnUloTPhurMRvjZcBfsAfb+txFGnfsd/xbEK3VgHAOJKBZRN/XgBmwtSTaw==
X-Received: by 2002:a17:906:c151:b0:a99:e505:2089 with SMTP id a640c23a62f3a-a9abf9219c3mr146622966b.45.1729673701922;
        Wed, 23 Oct 2024 01:55:01 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d6328sm445752966b.40.2024.10.23.01.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 01:55:01 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 293D55F89C;
	Wed, 23 Oct 2024 09:55:00 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>,  qemu-devel@nongnu.org,  Beraldo
 Leal <bleal@redhat.com>,  Laurent Vivier <laurent@vivier.eu>,  Wainer dos
 Santos Moschetta <wainersm@redhat.com>,  Mahmoud Mandour
 <ma.mandourr@gmail.com>,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Yanan
 Wang <wangyanan55@huawei.com>,  Thomas Huth <thuth@redhat.com>,  John Snow
 <jsnow@redhat.com>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  qemu-arm@nongnu.org,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eduardo
 Habkost <eduardo@habkost.net>,  devel@lists.libvirt.org,  Cleber Rosa
 <crosa@redhat.com>,  kvm@vger.kernel.org,  Philippe =?utf-8?Q?Mathieu-Dau?=
 =?utf-8?Q?d=C3=A9?=
 <philmd@linaro.org>,  Alexandre Iooss <erdnaxe@crans.org>,  Peter Maydell
 <peter.maydell@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Riku Voipio <riku.voipio@iki.fi>,  Zhao
 Liu <zhao1.liu@intel.com>,  Marcelo Tosatti <mtosatti@redhat.com>,  "Edgar
 E. Iglesias" <edgar.iglesias@gmail.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 07/20] tests/tcg/x86_64: Add cross-modifying code test
In-Reply-To: <17ab6a26-bfd2-4ee6-8fc4-c371d266dcb1@linaro.org> (Pierrick
	Bouvier's message of "Tue, 22 Oct 2024 17:33:21 -0700")
References: <20241022105614.839199-1-alex.bennee@linaro.org>
	<20241022105614.839199-8-alex.bennee@linaro.org>
	<6b18238b-f9c3-4046-964f-de16dc30d26e@linaro.org>
	<4c383f09bd6bd9b488ad301e5f050b8c9971f3a2.camel@linux.ibm.com>
	<17ab6a26-bfd2-4ee6-8fc4-c371d266dcb1@linaro.org>
User-Agent: mu4e 1.12.6; emacs 29.4
Date: Wed, 23 Oct 2024 09:55:00 +0100
Message-ID: <87y12fkxln.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 10/22/24 17:16, Ilya Leoshkevich wrote:
>> On Tue, 2024-10-22 at 13:36 -0700, Pierrick Bouvier wrote:
>>> On 10/22/24 03:56, Alex Benn=C3=A9e wrote:
>>>> From: Ilya Leoshkevich <iii@linux.ibm.com>
>>>>
>>>> commit f025692c992c ("accel/tcg: Clear PAGE_WRITE before
>>>> translation")
>>>> fixed cross-modifying code handling, but did not add a test. The
>>>> changed code was further improved recently [1], and I was not sure
>>>> whether these modifications were safe (spoiler: they were fine).
>>>>
>>>> Add a test to make sure there are no regressions.
>>>>
>>>> [1]
>>>> https://lists.gnu.org/archive/html/qemu-devel/2022-09/msg00034.html
>>>>
>>>> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
>>>> Message-Id: <20241001150617.9977-1-iii@linux.ibm.com>
>>>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>>>> ---
>>>>  =C2=A0 tests/tcg/x86_64/cross-modifying-code.c | 80
>>>> +++++++++++++++++++++++++
>>>>  =C2=A0 tests/tcg/x86_64/Makefile.target=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 ++
>>>>  =C2=A0 2 files changed, 84 insertions(+)
>>>>  =C2=A0 create mode 100644 tests/tcg/x86_64/cross-modifying-code.c
>>>>
>>>> diff --git a/tests/tcg/x86_64/cross-modifying-code.c
>>>> b/tests/tcg/x86_64/cross-modifying-code.c
>>>> new file mode 100644
>>>> index 0000000000..2704df6061
>>>> --- /dev/null
>>>> +++ b/tests/tcg/x86_64/cross-modifying-code.c
>>>> @@ -0,0 +1,80 @@
>>>> +/*
>>>> + * Test patching code, running in one thread, from another thread.
>>>> + *
>>>> + * Intel SDM calls this "cross-modifying code" and recommends a
>>>> special
>>>> + * sequence, which requires both threads to cooperate.
>>>> + *
>>>> + * Linux kernel uses a different sequence that does not require
>>>> cooperation and
>>>> + * involves patching the first byte with int3.
>>>> + *
>>>> + * Finally, there is user-mode software out there that simply uses
>>>> atomics, and
>>>> + * that seems to be good enough in practice. Test that QEMU has no
>>>> problems
>>>> + * with this as well.
>>>> + */
>>>> +
>>>> +#include <assert.h>
>>>> +#include <pthread.h>
>>>> +#include <stdbool.h>
>>>> +#include <stdlib.h>
>>>> +
>>>> +void add1_or_nop(long *x);
>>>> +asm(".pushsection .rwx,\"awx\",@progbits\n"
>>>> +=C2=A0=C2=A0=C2=A0 ".globl add1_or_nop\n"
>>>> +=C2=A0=C2=A0=C2=A0 /* addq $0x1,(%rdi) */
>>>> +=C2=A0=C2=A0=C2=A0 "add1_or_nop: .byte 0x48, 0x83, 0x07, 0x01\n"
>>>> +=C2=A0=C2=A0=C2=A0 "ret\n"
>>>> +=C2=A0=C2=A0=C2=A0 ".popsection\n");
>>>> +
>>>> +#define THREAD_WAIT 0
>>>> +#define THREAD_PATCH 1
>>>> +#define THREAD_STOP 2
>>>> +
>>>> +static void *thread_func(void *arg)
>>>> +{
>>>> +=C2=A0=C2=A0=C2=A0 int val =3D 0x0026748d; /* nop */
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0 while (true) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (__atomic_load_n((i=
nt *)arg, __ATOMIC_SEQ_CST)) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_WAIT:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_PATCH:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 va=
l =3D __atomic_exchange_n((int *)&add1_or_nop, val,
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 __ATOMIC_SEQ_CST);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_STOP:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn NULL;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 as=
sert(false);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __=
builtin_unreachable();
>>>
>>> Use g_assert_not_reached() instead.
>>> checkpatch emits an error for it now.
>> Is there an easy way to include glib from testcases?
>> It's located using meson, and I can't immediately see how to push the
>> respective compiler flags to the test Makefiles - this seems to be
>> currently handled by configure writing to $config_target_mak.
>> [...]
>>=20
>
> Sorry you're right, I missed the fact tests don't have the deps we
> have in QEMU itself.
> I don't think any test case include any extra dependency for now (and
> would make it hard to cross compile them too), so it's not worth
> trying to get the right glib header for this.

No we only have glibc for test cases.

>
> I don't now if it will be a problem when merging the series regarding
> checkpatch, but if it is, we can always replace this by abort, or
> exit.

Its a false positive in this case. We could tech checkpatch not to care
about glib-isms in tests/tcg but that would probaly make keeping it in
sync with the kernel version harder.

>
>>=20
>
> As it is,
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

