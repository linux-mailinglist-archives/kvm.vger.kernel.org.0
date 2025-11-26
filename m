Return-Path: <kvm+bounces-64706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D337C8B668
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3068B35364C
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 18:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA7D311C2A;
	Wed, 26 Nov 2025 18:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KHPh8coR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6Zi6U6y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408371F5820
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764180853; cv=none; b=US9a7F5JrZ9OtIqIcsZlzmWuo2NWWvlu0iygc0kYY3eS3GEWPZ+JITMo5gnffeiDN//mof5awYtksvPuo3AcCq8UI+W3w1zsAalzaCV2uXe9O4MTykwGZVDyEVri40KJZYJMVDvhR9+ucSxT5efQAqEUdj1ZxLh9Dz9IUXaXB80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764180853; c=relaxed/simple;
	bh=+mNz0HpBiDl7Hyu6xnI3/BUuyrrdqK3+ff05ZqmVMzw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kN3TpqMx1pdjFZDsywMQB3YZUiuC/fvLrW2kBPVobzH0o/Krytoo4HkFiI8+gpX1EAy/wBqmERGCorObe/l6/xTZdHac8JFKp01Rkd7h2otlUs6KwpYzdARyQTA0lgMG6J0GCOhuIETv5A4gPKuyowObzbZuOr0w1WURNkVC7js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KHPh8coR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P6Zi6U6y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764180850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JZ1JFLfDJyHJ9fVE+aQO1m/51zmhjWIAf3KyEb5wIAQ=;
	b=KHPh8coRg89Qkp2qmQ5aRohHpPtDqJg2xIgI+w2z8uZ0wWmp6k5CC4sbFinP14mwJBjtsy
	j7jtvNf0HEl+jPOpdnyuvrZcf/VGUQs/syqq/buxxvsWGbzCQWhGuP+CRsc2PvL6ZQPNRM
	+zbF6cYcqXUZ6bvU1rmJHCz1YYA2AHA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-iUOeQymZP1m1KHL4Vwfh2g-1; Wed, 26 Nov 2025 13:14:08 -0500
X-MC-Unique: iUOeQymZP1m1KHL4Vwfh2g-1
X-Mimecast-MFC-AGG-ID: iUOeQymZP1m1KHL4Vwfh2g_1764180848
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b19a112b75so4089585a.1
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 10:14:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764180848; x=1764785648; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JZ1JFLfDJyHJ9fVE+aQO1m/51zmhjWIAf3KyEb5wIAQ=;
        b=P6Zi6U6y6mWyzAkGYHLc/BG7Fp734yTY33TCMifvhEMt5izGv4pXwZkvjL0vgCRV5t
         0TzsWpMcKKCctiuIJWlwqSww7RhymBRd0s0wcxx3w5Y5TI2kPQ62svM212Zt7v2tsqfM
         aizdWgjmzKJ6vz5NuOB3C9PNRpBUQ46KtEoQ4PyQWN4xgFkMHXj0LbW7KeiZssm1/BSa
         O2UQl0XEEWtmkobCYfhE/BUOASSjA7FVY+kaERXO0Kezmo5AK/7006aybgFuUbVtHE4z
         A9oc/45Ke+n9r4/Pm9CY6O/l8aVYv+xVQjlTMZF3kV1QC8E4Lm1Y422Bv8UCPKR3KrlS
         w0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764180848; x=1764785648;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JZ1JFLfDJyHJ9fVE+aQO1m/51zmhjWIAf3KyEb5wIAQ=;
        b=v15tkCQ3uPYbfZQhfakT2xOLiEGmG1TRk1AFXdHSN7j2Dn1TJWMCgr0BFxHnSq1HVg
         rmz0mtfHwzaGZvLvGMcbtC/RD+6x27+c3GFYlWfGQZd874j3d/kVvQie6grm9pOMzRn5
         l9JlXjHTdw+h4Kk2HmDUhH9Fhclmvorzbp1eZ5QD3y9eB8GZYjC94Vcarh8ACy+Wmzd1
         m5kYG1731SzaQp1tgx3ErHMrWFvC/XRWwL2dkumyaytrEYbcONZc4uGG28AQa0Du7zmp
         sEoTTRMUgWdmaTu4xRxmquZwG6vbI+H53CB4nlMn6hinAoGa04kk7VazymNyosUr3kRS
         qa1g==
X-Gm-Message-State: AOJu0Yw6SsiFEE4xNS1xGb3ro5uH4/4LXpfquqs06BFxFyWLeMfQuG9U
	+cdfVqSRyTduLGDlL0IxgMPJkU4GA5hUIed5F8K1jteb6QmheFt+U6Wc5N1b/8xUSsH36wIjXVV
	ETtaiQ+e00+ZBOiyKw4fEzA0U6W7Sfqq1h+P7N8do/OzYXUVo94iLhMbTbIo/0QSzEnJ5wccgGZ
	IK4J6sYmD9NapwalziZ0HHCXqbV5/cHgJd/6+3rAQw
X-Gm-Gg: ASbGnctq8AF3lULL/oPPpxf8QZXNmC0euvNFG6QJ41LUAyIQHyXBshsvInNACqgyfke
	EcVvz+YpcqrmixjyBSAlvd4Cg5w1ThuE/X7a7likebyrSkImOjpoLiTuuHxWjFzVYY33ozd8Z9d
	FzevEjpB30c+whXibDGlkG6fqGpYlIDsyxxG8++/4CQl8tbFBffKkCFDFdh0zDdnIwxjJqtzW5E
	TOhhPn6HMyx+ffAPw/LRTr95JnLs8PLhlXFiBG3SLnMIOjJXWXqqtptVgVenJm6JCiT/5vxa/zZ
	SVRRWKgJ0KdxBEfHd320g1EsAu0kzIbAOrBIkeJICgHIWKR/TJE6ELg+cOk9vJ4si3OkqZeqXHx
	kXGd4Gvi/RELexPjxigbd39koIw+ADP8ISautIcWiN23J5h5Oda0hv2pC
X-Received: by 2002:a05:620a:2688:b0:89f:27dc:6536 with SMTP id af79cd13be357-8b33d469962mr2694191485a.54.1764180847875;
        Wed, 26 Nov 2025 10:14:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHv17OHmbz/pjfKkhwVp4YOBz5vyhl34GsYjeFc1nO/cWjbe0TRwUjTrkWnitt09vMlmj37w==
X-Received: by 2002:a05:620a:2688:b0:89f:27dc:6536 with SMTP id af79cd13be357-8b33d469962mr2694184985a.54.1764180847232;
        Wed, 26 Nov 2025 10:14:07 -0800 (PST)
Received: from ?IPv6:2607:fea8:fc01:88aa:f1de:f35:7935:804f? ([2607:fea8:fc01:88aa:f1de:f35:7935:804f])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295c2276sm1438129585a.30.2025.11.26.10.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 10:14:06 -0800 (PST)
Message-ID: <b0bdc3f140238d23e2de8f706c06331db1d57e79.camel@redhat.com>
Subject: Re: Question: 'pmu' kvm unit test fails when run nested with NMI
 watchdog on the host
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Date: Wed, 26 Nov 2025 13:14:06 -0500
In-Reply-To: <2eae45e037c938785b9e36d0f5265becca953d9f.camel@redhat.com>
References: <10d3f95717b7072e30576b7e3931ea277399fdf8.camel@redhat.com>
	 <2eae45e037c938785b9e36d0f5265becca953d9f.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-11-10 at 14:51 -0500, mlevitsk@redhat.com wrote:
> On Wed, 2025-11-05 at 15:29 -0500, mlevitsk@redhat.com=C2=A0wrote:
> > Hi,
> >=20
> > I have a small, a bit philosophical question about the pmu kvm unit tes=
t:
> >=20
> > One of the subtests of this test, tests all GP counters at once, and it=
 depends on the NMI watchdog being disabled,
> > because it occupies one GP counter.
> >=20
> > This works fine, except when this test is run nested. In this case, ass=
uming that the host has the NMI watchdog enabled,
> > the L1 still can=E2=80=99t use all counters and has no way of working t=
his around.
> >=20
> > Since AFAIK the current long term direction is vPMU, which is especiall=
y designed to address those kinds of issues,
> > I am not sure it is worthy to attempt to fix this at L0 level (by reduc=
ing the number of counters that the guest can see for example,
> > which also won=E2=80=99t always fix the issue, since there could be mor=
e perf users on the host, and NMI watchdog can also
> > get dynamically enabled and disabled).
> >=20
> > My question is: Since the test fails and since it interferes with CI, d=
oes it make sense to add a workaround to the test,
> > by making it use 1 counter less if run nested?=20
> >=20
> > As a bonus the test can also check the NMI watchdog state and also redu=
ce the number of tested counters instead of being skipped,
> > improving coverage.
> >=20
> > Does all this make sense? If not, what about making the =E2=80=98all_co=
unters=E2=80=99 testcase optional (only print a warning) in case the test i=
s run nested?
> >=20
> > Best regards,
> > 	Maxim Levitsky
> >=20
>=20
> Kind ping on this question.

Another kind ping on this question.

Best regards,
    Maxim Levitsky

>=20
> Best regards,
> 	Maxim Levitsky


