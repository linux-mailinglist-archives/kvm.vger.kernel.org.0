Return-Path: <kvm+bounces-25142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 514ED9609D3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:18:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8A1FB221D0
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 12:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3761A2540;
	Tue, 27 Aug 2024 12:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApT2nbqI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11241A00E3
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 12:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761089; cv=none; b=SAwEMNWNgjh5qVzWgizljgBJPIOsTywYh4EZ9hES7NaKYt7AWrXRi/Lk2E8denyzPyRB3WsWRWt2JVkpN25d9Dl170oVyWOSed4mF7NqzYaRzAcrBD7KszFiIqjbgWNDDOmoeUZ5PbblJ8fVYvAwZflIgRVUvM0GK6h+adfqNmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761089; c=relaxed/simple;
	bh=jIO0cRArg2/XIVHSCBjrEYB4DjHT7vkln4SlSmAxVJo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NLcAXVBYU5x+gEeAbo8CNFjXnGHPrmh4XYTDkKy+2oX+VVTCSaGUtN7MtMJni3idvolYfjBEESnj4Ra0/foZkUS530bz8CaZdFH5dyhbMLotVGaPHXZk8rGGhUa7aHXvivFmKbDU9p9EvAD14+sjUD65x4W3Y6bz8JHX7smC5qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ApT2nbqI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724761086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3EiTPZ2qWaTRorA0xI6FP2nhQmqz8XNx/iknuS88GzQ=;
	b=ApT2nbqIdEvaNWQMNcNuBPx5qQ8LzAINZHbwIbpKWEJpEqEuxjkKbpxE4EiwNSldwA8oQK
	80VPlGgQmJiLQbDaD5oIat8Pd4I6vbpxt02xW9i2G+7e34O/1CjjFUakklI1WRbJEaqNs9
	3x+6nl59WPnjQNo5m+3oyiNJ0oyr+6k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-w8nJg3bQOBGhqJ1DQWBvxg-1; Tue, 27 Aug 2024 08:18:04 -0400
X-MC-Unique: w8nJg3bQOBGhqJ1DQWBvxg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3718eb22836so3486420f8f.3
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 05:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724761083; x=1725365883;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3EiTPZ2qWaTRorA0xI6FP2nhQmqz8XNx/iknuS88GzQ=;
        b=ZT/RrYM19lWQ4/59RKf5kYXGx8YAox8fBJIiJ6VsJSKQPUy/23RvAejTJ2kOuqNzj0
         0nUw7S5ac2P7ec37Im+RYF+YMHx+c0rdy3th+JKRwzw78HAFN6aL5B+EwI7ZQ/Ajofc1
         a/JXViU0qBYnwtIAFALqEhdxjTVIBOhV/pnwa9FrSQ697RW3/LJ3qiwWpegdJIgJN+Hh
         Wi34DHAuMNEwxX7dCXq/NvrS7nZs71SPvOCggqfMemenoPuUXFD7HedA8WlLIekEyK5O
         V7vO74QMta6kpwj8PNewhjAma3YbpTMw18zTUehSi1llLPS23n4+E/r9li442KlCsD2d
         AXjw==
X-Forwarded-Encrypted: i=1; AJvYcCW5NzQ11fLnvyqS31QYwLz2udqWgpPiH0zhqAq/ZiV8W/tkjlrgC4Rr1ZSN1Cjm9SVtY10=@vger.kernel.org
X-Gm-Message-State: AOJu0YykboSHSsCs4JXX2YDnH4+vm9lQ8+x/WA2lIastCkVcrA7cVYD7
	lcBsa/Giaqec8bjgaVVpUdd7JJIZPwjfLrKJdVI24ZUi3jThT0XnSNsKMLV52A9mqGkGjJoZrOJ
	qgaItO7b4OJw0e/BSoV2p58qmIcQIyLUT86FxXoZsB2g47KjZ9g==
X-Received: by 2002:a05:6000:b88:b0:371:8af5:473d with SMTP id ffacd0b85a97d-37311840cb5mr7924316f8f.12.1724761083121;
        Tue, 27 Aug 2024 05:18:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGKZ7lsET1X/0DxMuelSdo1KQrt6r0yhxj3/qYEXESLmw2vm2Thtj1uVKCxQA6nL30WO0oPuw==
X-Received: by 2002:a05:6000:b88:b0:371:8af5:473d with SMTP id ffacd0b85a97d-37311840cb5mr7924295f8f.12.1724761082506;
        Tue, 27 Aug 2024 05:18:02 -0700 (PDT)
Received: from smtpclient.apple ([115.96.30.188])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3730815b7eesm12909709f8f.54.2024.08.27.05.17.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2024 05:18:02 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
From: Ani Sinha <anisinha@redhat.com>
In-Reply-To: <87v7zmmq9f.fsf@pond.sub.org>
Date: Tue, 27 Aug 2024 17:47:44 +0530
Cc: =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 qemu-trivial@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>,
 kvm@vger.kernel.org,
 qemu-devel <qemu-devel@nongnu.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <03C06183-B8ED-405D-8B9C-532E30B8E412@redhat.com>
References: <20240809064940.1788169-1-anisinha@redhat.com>
 <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
 <87v7zmmq9f.fsf@pond.sub.org>
To: Markus Armbruster <armbru@redhat.com>
X-Mailer: Apple Mail (2.3776.700.51)



> On 27 Aug 2024, at 12:00=E2=80=AFPM, Markus Armbruster =
<armbru@redhat.com> wrote:
>=20
> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:
>=20
>> Hi Ani,
>>=20
>> On 9/8/24 08:49, Ani Sinha wrote:
>>> error_report() is more appropriate for error situations. Replace =
fprintf with
>>> error_report. Cosmetic. No functional change.
>>> CC: qemu-trivial@nongnu.org
>>> CC: zhao1.liu@intel.com
>>=20
>> (Pointless to carry Cc line when patch is already reviewed next line)
>>=20
>>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>>> ---
>>>  accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>>>  1 file changed, 18 insertions(+), 22 deletions(-)
>>> changelog:
>>> v2: fix a bug.
>>> v3: replace one instance of error_report() with error_printf(). =
added tags.
>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>> index 75d11a07b2..5bc9d35b61 100644
>>> --- a/accel/kvm/kvm-all.c
>>> +++ b/accel/kvm/kvm-all.c
>>> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>>>      QLIST_INIT(&s->kvm_parked_vcpus);
>>>      s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>>>      if (s->fd =3D=3D -1) {
>>> -        fprintf(stderr, "Could not access KVM kernel module: =
%m\n");
>>> +        error_report("Could not access KVM kernel module: %m");
>>>          ret =3D -errno;
>>>          goto err;
>>>      }
>>> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>>>          if (ret >=3D 0) {
>>>              ret =3D -EINVAL;
>>>          }
>>> -        fprintf(stderr, "kvm version too old\n");
>>> +        error_report("kvm version too old");
>>>          goto err;
>>>      }
>>>        if (ret > KVM_API_VERSION) {
>>>          ret =3D -EINVAL;
>>> -        fprintf(stderr, "kvm version not supported\n");
>>> +        error_report("kvm version not supported");
>>>          goto err;
>>>      }
>>>  @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>>>      } while (ret =3D=3D -EINTR);
>>>        if (ret < 0) {
>>> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", =
-ret,
>>> -                strerror(-ret));
>>> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
>>> +                    strerror(-ret));
>>>    #ifdef TARGET_S390X
>>>          if (ret =3D=3D -EINVAL) {
>>> -            fprintf(stderr,
>>> -                    "Host kernel setup problem detected. Please =
verify:\n");
>>> -            fprintf(stderr, "- for kernels supporting the =
switch_amode or"
>>> -                    " user_mode parameters, whether\n");
>>> -            fprintf(stderr,
>>> -                    "  user space is running in primary address =
space\n");
>>> -            fprintf(stderr,
>>> -                    "- for kernels supporting the vm.allocate_pgste =
sysctl, "
>>> -                    "whether it is enabled\n");
>>> +            error_report("Host kernel setup problem detected.
>>=20
>> \n"
>>=20
>> Should we use error_printf_unless_qmp() for the following?
>>=20
>> " Please verify:");
>>> +            error_report("- for kernels supporting the switch_amode =
or"
>>> +                        " user_mode parameters, whether");
>>> +            error_report("  user space is running in primary =
address space");
>>> +            error_report("- for kernels supporting the =
vm.allocate_pgste "
>>> +                        "sysctl, whether it is enabled");
>=20
> Do not put newlines into error messages.  error_report()'s function
> comment demands "The resulting message should be a single phrase, with
> no newline or trailing punctuation."
>=20
> You can do this:
>=20
>    error_report(... the actual error message ...);
>    error_printf(... hints on what to do about it ...);
>=20
> Questions?

Do you see any newlines in my proposed patch?


