Return-Path: <kvm+bounces-10590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4A0E86DBF0
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:16:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E36E287631
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50FC869955;
	Fri,  1 Mar 2024 07:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k3YS6FVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D769D09
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 07:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709277322; cv=none; b=WLuAHWGwuMe6OhDG4s3BO91+BatP+/xQrZaWZ5jb5lOl/V/mj1nzC0P5lPz3+nr973OM14jZlYKL+b0PNelwNCdabX5olR/uynESmeEbGyUdYP+aoy4lj6W7SjI8bSKxSCiWDIHO8o9SRSvX68G/MRlH4ZXnw/74GbCyjSCKLpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709277322; c=relaxed/simple;
	bh=pkw5kP0B54RIahX+61JuGPHVjlBBrYbg9/OrhzkucqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NqROwcntLkmaAUnNx5asTcbDu341EV70qmHlHzcw1TFb7p9XjddLm09RpTl+JPEbRqONYIOOEUSCsoUi+UuWqzJyujWcAZVDth2yOGYzm9j/A14Vwq//p5eNYySqn5xByoERWinRZSvHaV3csTGemBDpQHGLg3sinBVY+nE3l78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k3YS6FVK; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5654ef0c61fso8305a12.0
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 23:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709277319; x=1709882119; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sp6OVhMqe3QL4ysD/MCCjB6obFRvvViLhX6whzMXoxQ=;
        b=k3YS6FVK3tCS/xcKgewzp4f0Ev7Aa6hOYaY+u70lKZer8FPYfZ+uoUFOtB3qG0hN40
         JN7/QOGmrKojuWuGxBvgHhXwWsTsl0w1xRP6c+TK3Q83qPYgxuOpEXJ0mGaApHHd7eKw
         R55LrkXNjvNhEpx9rK+2LPxoJzpoUoZz5xG4nhm9ZQpmGdEvQPt7jVXEPB2iWCC3t6CN
         CmtPB197kEFRaUnQHryyWBm3dc+yKSXQrY92yu1I2BTWbtxhEDSnjjevWMBDJ89cU2zB
         fponaW3pLRZqLjQMmf5ePkMQzChYSeKEnubwutmdHTJm1HE8/Z7lnAHhQeBeYEX4eTr4
         BMnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709277319; x=1709882119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sp6OVhMqe3QL4ysD/MCCjB6obFRvvViLhX6whzMXoxQ=;
        b=sLI0/JqbGkPzABL08FwASb1pqVlaRTZQGtFIWwALrX0q3M2sLvz4PUP91qx7kfNimy
         vwRx2rrMv7GnDh/yHKXWgreWRCR4x3ki/moWWctOxJT78QVUisaRHjIhBPTSm2VuRbWQ
         OROdzxqOs21Dq5KLV2aH7JikCAlsymIaTOHVRoTyssAVNWPhv74X+GymdHdbrCMvNT2/
         v3Q/nD+3rsyPp9ciDCU0YW42lQX4M5WakGxuwxmiyhwhZ8c7oe/xC2Qx1ZFFa651x2v+
         I+69RstpDbl9F1ZOD2eOxTEbRrKDyvyefvVdOBB+nBZJYzDlZ9Nf3sXpYF/zhl/WcdZf
         xz3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVcy2zwtAeJYVCux9Ifm/8w46WAU12H5Vv+Gk+TQPYF+B3DFjBKRlGcEUAaUTZz7M3WjP1+bM+AfJbYs7F8VoCYDvhq
X-Gm-Message-State: AOJu0YxEPY4gyDPcvUy+phVIPzH6fKP1k/astOG4cJ1e+KdZZRySLUad
	lFyQeThqy0fJ1eGfho6/cf/xAVQue6gRcJfyUwWxEY1Ly7SUNTICkacZVh0eE7Ews10m+mfGfj3
	W4b7RGAlszCcKU4E5WsOilCOgTWzKJOFwzN28
X-Google-Smtp-Source: AGHT+IFQxFfkyBjFBIwuIIcURoj5pdw1Ead9KkqLXdFHWhP+/s8dFRPImaYuijs2JPADg8di8llv1t1viqbksnAhQtU=
X-Received: by 2002:a05:6402:5244:b0:565:4f70:6ed with SMTP id
 t4-20020a056402524400b005654f7006edmr106314edd.6.1709277319291; Thu, 29 Feb
 2024 23:15:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229170409.365386-1-mic@digikod.net>
In-Reply-To: <20240229170409.365386-1-mic@digikod.net>
From: David Gow <davidgow@google.com>
Date: Fri, 1 Mar 2024 15:15:08 +0800
Message-ID: <CABVgOSnTfUBWcX4o68ZoZC+vZSEzUp=UikQM5M70ECyS44GfNQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Run KUnit tests late and handle faults
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>, Kees Cook <keescook@chromium.org>, 
	Rae Moar <rmoar@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morris <jamorris@linux.microsoft.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marco Pagani <marpagan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Thara Gopinath <tgopinath@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-um@lists.infradead.org, x86@kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000761ddc061294237c"

--000000000000761ddc061294237c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Mar 2024 at 01:04, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wro=
te:
>
> Hi,
>

Thanks very much. I think there's a lot going on in this series, and
it'd probably be easier to address if it were broken up a bit more.

To take things one at a time:

> This patch series moves KUnit test execution at the very end of kernel
> initialization, just before launching the init process.  This opens the
> way to test any kernel code in its normal state (i.e. fully
> initialized).

I like the general idea here, but there are a few things to keep in mind:
- We can already do this with tests built as modules.
- We have explicit support for testing __init code, so if we want to
keep that (and I think we do), we'll need to make sure that there
remains a way to run tests before __init.
- Behaviour changes here will need to be documented and tested well
across all tests and architectures, so it's not something I'd want to
land quickly.
- The requirement to have a root filesystem set up is another thing
we'll want to handle carefully.
- As-is, the patch seems to break arm64.

>
> This patch series also teaches KUnit to handle kthread faults as errors,
> and it brings a few related fixes and improvements.

These seem very good overall. I want to look at the last location
stuff in a bit more detail, but otherwise this is okay.

Personally, I'd like to see this split out into a separate series,
partly because I don't want to delay it while we sort the other parts
of this series out, and partly because I have some other changes to
the thread context stuff I think we need to make.

>
> New tests check NULL pointer dereference and read-only memory, which
> wasn't possible before.

These look interesting, but I don't like that they are listed as x86-specif=
ic.

>
> This is useful to test current kernel self-protection mechanisms or
> future ones such as Heki: https://github.com/heki-linux
>
> Regards,

Thanks again. I'll do a more detailed review of the individual patches
next week, but I'm excited to see this overall.

Cheers,
-- David


>
> Micka=C3=ABl Sala=C3=BCn (8):
>   kunit: Run tests when the kernel is fully setup
>   kunit: Handle thread creation error
>   kunit: Fix kthread reference
>   kunit: Fix timeout message
>   kunit: Handle test faults
>   kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
>   kunit: Print last test location on fault
>   kunit: Add tests for faults
>
>  include/kunit/test.h                |  24 +++++-
>  include/kunit/try-catch.h           |   3 -
>  init/main.c                         |   4 +-
>  lib/bitfield_kunit.c                |   8 +-
>  lib/checksum_kunit.c                |   2 +-
>  lib/kunit/executor.c                |  81 ++++++++++++++------
>  lib/kunit/kunit-example-test.c      |   6 +-
>  lib/kunit/kunit-test.c              | 115 +++++++++++++++++++++++++++-
>  lib/kunit/try-catch.c               |  33 +++++---
>  lib/kunit_iov_iter.c                |  70 ++++++++---------
>  tools/testing/kunit/kunit_kernel.py |   6 +-
>  11 files changed, 261 insertions(+), 91 deletions(-)
>
>
> base-commit: d206a76d7d2726f3b096037f2079ce0bd3ba329b
> --
> 2.44.0
>

--000000000000761ddc061294237c
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPqgYJKoZIhvcNAQcCoIIPmzCCD5cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg0EMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
7xDrOPfX3COqq162RFg/MFcGA1UdIARQME4wCQYHZ4EMAQUBATBBBgkrBgEEAaAyASgwNDAyBggr
BgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/
BAIwADCBmgYIKwYBBQUHAQEEgY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNp
Z24uY29tL2NhL2dzYXRsYXNyM3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgw
FoAUfMwKaNei6x4schvRzV2Vb4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9i
YWxzaWduLmNvbS9jYS9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEB
AK0lDd6/eSh3qHmXaw1YUfIFy07B25BEcTvWgOdla99gF1O7sOsdYaTz/DFkZI5ghjgaPJCovgla
mRMfNcxZCfoBtsB7mAS6iOYjuwFOZxi9cv6jhfiON6b89QWdMaPeDddg/F2Q0bxZ9Z2ZEBxyT34G
wlDp+1p6RAqlDpHifQJW16h5jWIIwYisvm5QyfxQEVc+XH1lt+taSzCfiBT0ZLgjB9Sg+zAo8ys6
5PHxFaT2a5Td/fj5yJ5hRSrqy/nj/hjT14w3/ZdX5uWg+cus6VjiiR/5qGSZRjHt8JoApD6t6/tg
ITv8ZEy6ByumbU23nkHTMOzzQSxczHkT+0q10/MxggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIz
IFNNSU1FIENBIDIwMjACEAHS+TgZvH/tCq5FcDC0n9IwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZI
hvcNAQkEMSIEIGSexU9CBLPq9DV5GlLruMl5f6OWP9Np4R5A91eTaG/AMBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMwMTA3MTUxOVowaQYJKoZIhvcNAQkPMVww
WjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkq
hkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAtVqbG
lHBOpfU+NmzsAAOBnHOoc4fGnI9Mg5qKrCB+VBMJaKDIhITAlgSQ69lWlzWjj5mGbnyJA/3Lwigp
+zTNHabaZFe1VbwlJRB8SlxuG9ODnlUXmLQayidJ/dz13AgLsNbTmxm/OtwUp53+hsHv71FcpAbS
ceyu1+AMtncikEcXypW60mauLWY40S60oh3OUtRwaJZXnLIXmmL/H7CXYd1r3enoM3L274qrPLjQ
TJd1eQqEm0UnI/26ycrkYe57yjW40F14sMMB8NkoYkIRQbgSSLzKjb5p4NflQVkTqkAkI9c6pKqh
fsQ6/6c76hHn9wCk9e5Gr1LDCBuS8+HH
--000000000000761ddc061294237c--

