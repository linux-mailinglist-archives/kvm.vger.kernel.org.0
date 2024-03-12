Return-Path: <kvm+bounces-11633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CB2C878E05
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 05:55:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FFB028287E
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 04:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A3B405FC;
	Tue, 12 Mar 2024 04:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vQV6saQD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCC640879
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 04:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710219312; cv=none; b=RNC1DwFIBUUq5RIh3g/k3CiZJ0omLuUXvknBpTQX8mUZsahNlN79eCpW6gpU9zSSSSpArEoF7a6onms+yBQeunb/QnDy0gV5ExTIeHx4Y9Dl3/Q3+DXgdAArNgw+KqlLB0fez0N2i0mQPb9edEWCwpi6dU6ULfPI85MEJrcerFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710219312; c=relaxed/simple;
	bh=AcmNjGHka4cSC1B5F7l1GCL/J5Uhs7SbycfeGUvjatc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E15yEvLUtGeAYUKyjAkhUOhQXELgzM7VP55sNDnzU2umFZ/t1ZqSu0IDY1dqeHAlj09ZVE/mMtExX6caFpcX3xO5dDrTeGORPBtfWNxFNwAQZpwl/d48GN/p08Fwsx7KP3TJAT+jdPxRrMP8IuZR/W6opgAZYU4mQ87sdeIJ+kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vQV6saQD; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-568251882d7so10148a12.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 21:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710219308; x=1710824108; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O9DTKYQduqnfi3X4F3Po4rQxz7DF77LzIr7VgJw8MJQ=;
        b=vQV6saQDnibGrilFJvc3maDRyMECk2bkoaMDhmiREfyuqCgtPy7KuS5tUXxJ/xfG+T
         cSDOz/ytpvKCOffoHrXHV2AkXsra1cHn6Fd35xVssxwtWARrEjHteF6/a0WqXs8SC5vk
         21hzje6PKaNmmFB1xBzK/tQOGzxkGSEx5UBYJUfcBg6p9pInW5qptp6FIwYzlKqrYXp3
         VptdkLkiwpb1XZgUeh6x50DjEfVGtB1iGNJKzcSYmkSkbcBh6D4eJukcMnnxC9QNTS3Q
         98XeFjO/QUbqP8b/PKHFJsWfNucCiAUpmtXLG+yjI4uM2TgU2ogKkNmciIOwMsjd7nhy
         hDIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710219308; x=1710824108;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O9DTKYQduqnfi3X4F3Po4rQxz7DF77LzIr7VgJw8MJQ=;
        b=oWv/b4kz+ntajD0A2viQfANw+/L/01ZqjhFeUH3JzryJ4RSO+s6CJdGGP4XYYLKtgW
         I4nftZPDmKG94PwYtiJkp2FOgAcVzODeSaSBixMitt3t4NQveWCEx8C9wcPlLqXgjMYe
         qIZ3GJdGimLPNkyYE5OxGcpO4QsR4QDBQZosezX8Z181DYCvuH+SctwLyeIH7f3bnlWG
         sNfzTopIwoeinPfRsW0MKl6z+tk0TkZHE4XdxtF1NCLONL8lVgA/2fnXF58dac8EYTS7
         RJ5s+yA6CCdkt6scPabu1kRIMoDahWGjRwXI5+uEnCwxYn6sR62AHUTyTJEheIsjsFig
         uDeg==
X-Forwarded-Encrypted: i=1; AJvYcCVRNfiF51PN4c45v78WeOlXJM1UaovJtXNYDwzJpO7NnzngncNs5jEEr+bnu9RBsXrCzIXPFFm38s1h47ONXhFns3aO
X-Gm-Message-State: AOJu0YwxEjDRj3CDJhaiiyNzLWLt2bZ0OpuwS5eMPjt6n5abpPrKolFl
	shOiqQ1P0yMhBwna4tsoIYmtwWRl+9zeYVizWfOE8k75p6rNkLfLGo+Tnoez1ziOTruI5WE4SYQ
	KQ99diAywRKplWpmPtggE1ouq58S54ij6xmuq
X-Google-Smtp-Source: AGHT+IGU5iSaMuUMD3OWkgCq+HPlwyciThiIOt12D5freNFWYAnSma6L8D3ymybDwqVGF32n/LebfHUfkgbXb3HlaVY=
X-Received: by 2002:aa7:c2d9:0:b0:568:5e6c:a3c4 with SMTP id
 m25-20020aa7c2d9000000b005685e6ca3c4mr109961edp.0.1710219308194; Mon, 11 Mar
 2024 21:55:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301194037.532117-1-mic@digikod.net> <20240301194037.532117-8-mic@digikod.net>
In-Reply-To: <20240301194037.532117-8-mic@digikod.net>
From: David Gow <davidgow@google.com>
Date: Tue, 12 Mar 2024 12:54:57 +0800
Message-ID: <CABVgOSmq5JhBdis1rDoD3eYQ_dhaWyEjXNfwasL9sWFMwLpjzA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] kunit: Add tests for fault
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
	boundary="0000000000005f937606136f76ff"

--0000000000005f937606136f76ff
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Mar 2024 at 03:40, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wro=
te:
>
> Add a test case to check NULL pointer dereference and make sure it would
> result as a failed test.
>
> The full kunit_fault test suite is marked as skipped when run on UML
> because it would result to a kernel panic.
>
> Tested with:
> ./tools/testing/kunit/kunit.py run --arch x86_64 kunit_fault
> ./tools/testing/kunit/kunit.py run --arch arm64 \
>   --cross_compile=3Daarch64-linux-gnu- kunit_fault
>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240301194037.532117-8-mic@digikod.net
> ---
>
> Changes since v1:
> * Removed the rodata and const test cases for now.
> * Replace CONFIG_X86 check with !CONFIG_UML, and remove the "_x86"
>   references.
> ---

I think UML _should_ be able to handle this with signal handlers, but
I tested it and agree that it's broken, so disabling for now makes
sense.

In general, I'd prefer to have an empty test which SKIP()s here, but
since the suite is empty, KUnit does that anyway, so this is fine.

Reviewed-by: David Gow <davidgow@google.com>

Cheers,
-- David


>  lib/kunit/kunit-test.c | 45 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/lib/kunit/kunit-test.c b/lib/kunit/kunit-test.c
> index f7980ef236a3..0fdca5fffaec 100644
> --- a/lib/kunit/kunit-test.c
> +++ b/lib/kunit/kunit-test.c
> @@ -109,6 +109,48 @@ static struct kunit_suite kunit_try_catch_test_suite=
 =3D {
>         .test_cases =3D kunit_try_catch_test_cases,
>  };
>
> +#ifndef CONFIG_UML
> +
> +static void kunit_test_null_dereference(void *data)
> +{
> +       struct kunit *test =3D data;
> +       int *null =3D NULL;
> +
> +       *null =3D 0;
> +
> +       KUNIT_FAIL(test, "This line should never be reached\n");
> +}
> +
> +static void kunit_test_fault_null_dereference(struct kunit *test)
> +{
> +       struct kunit_try_catch_test_context *ctx =3D test->priv;
> +       struct kunit_try_catch *try_catch =3D ctx->try_catch;
> +
> +       kunit_try_catch_init(try_catch,
> +                            test,
> +                            kunit_test_null_dereference,
> +                            kunit_test_catch);
> +       kunit_try_catch_run(try_catch, test);
> +
> +       KUNIT_EXPECT_EQ(test, try_catch->try_result, -EINTR);
> +       KUNIT_EXPECT_TRUE(test, ctx->function_called);
> +}
> +
> +#endif /* !CONFIG_UML */
> +
> +static struct kunit_case kunit_fault_test_cases[] =3D {
> +#ifndef CONFIG_UML
> +       KUNIT_CASE(kunit_test_fault_null_dereference),
> +#endif /* !CONFIG_UML */
> +       {}
> +};
> +
> +static struct kunit_suite kunit_fault_test_suite =3D {
> +       .name =3D "kunit_fault",
> +       .init =3D kunit_try_catch_test_init,
> +       .test_cases =3D kunit_fault_test_cases,
> +};
> +
>  /*
>   * Context for testing test managed resources
>   * is_resource_initialized is used to test arbitrary resources
> @@ -826,6 +868,7 @@ static struct kunit_suite kunit_current_test_suite =
=3D {
>
>  kunit_test_suites(&kunit_try_catch_test_suite, &kunit_resource_test_suit=
e,
>                   &kunit_log_test_suite, &kunit_status_test_suite,
> -                 &kunit_current_test_suite, &kunit_device_test_suite);
> +                 &kunit_current_test_suite, &kunit_device_test_suite,
> +                 &kunit_fault_test_suite);
>
>  MODULE_LICENSE("GPL v2");
> --
> 2.44.0
>

--0000000000005f937606136f76ff
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
hvcNAQkEMSIEIH104oDLt2YJXGY2Th/tOIltj+ysdkZwtuJlBc32SJA0MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMxMjA0NTUwOFowaQYJKoZIhvcNAQkPMVww
WjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkq
hkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBrXvUN
G/lKjLxrVJtJuNu0UXjEq4q9AyzPP3ilyTKUn6C2JhGJg23/TCAOvjouYFywkRnygEUjOkA1ZGZO
jM3lQhXi9GZq6eq/B+3SGs7zQs+lkp6pL3z/iaFRSl4g+Yh5oXMDsw8XeMiFcvbXYuFQ46bEBfxA
1bITNoyIvKAVKky3fj20sTBCmBcsEvH6JEzv11HE5MtTQmr1d5t4MvDV2clv30x2G27URt9YVmdT
hiwIHvUiaOPgcwZlx1WSgdmcUA2la0mxbi2ivqN1ttncxmNFn0/s4Vi2GAfT8ePnQihW9np0eOHO
Mt8DI8UhWtpTHPthmF/9eHcv6tw/iuFd
--0000000000005f937606136f76ff--

