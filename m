Return-Path: <kvm+bounces-25119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 490309601C4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 08:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0137C2842AF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 06:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7658146D68;
	Tue, 27 Aug 2024 06:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KkWGAd27"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0DA8289C
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 06:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724740248; cv=none; b=dg6XK3IzUmEaQVxxlVcg/bnZieNOwY65Pv9KTGiEgJZiNIVAUbCFxDtOwAM+u8KHnjhn1PuBu5xqHwqKI6EKUUzRdeHEWUTTkzM/vS0X5MwUZELYe24M+q7OPmhf133px8ipNoyQIgIHVANp4cpIFhzxXmsQAmJYyYde1KJt9JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724740248; c=relaxed/simple;
	bh=hq12jodiTUWQWGFIbgwgPrOsPWCD1Y3mkPhbX8CyPwI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=k5FYuQ1RfYQxXY3Eq4t+t389aV3lT1v6V7IAtuXnnp/dyBJ3SNmBQxW+jKHKgzYzacOmWK+Y9EemsjI706cXXsQAA3cLPNOvpAdizRPIxN7enSRxsJuBfDzqlQFacdTYb5YqYgteroarL3zKhhsxrEOWgm1ByQFkDDKLTFZ5JYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KkWGAd27; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724740245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J7ee2KV+Lqz+23D3Fwl+N0nP1Ygl2fAs/LiLzNVq+xI=;
	b=KkWGAd275JGRUGDkmnoX0pBHb1ELslFZIYT4WoOkSmiJxb3FFDtzd3mCgMAc4GMz9kEgyO
	PPceu3KTY3S4EBEtjPI3UUtaiVY2DmLpKNk8st7uLlO7N/Nflg8juBO2JzP3iNUgMxo7vX
	lZ67UQ9j8R8hAmwxUP2hR3DVGmAsp4w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-401-I6ZRyGUsMTyzN4TmTB0tUw-1; Tue,
 27 Aug 2024 02:30:41 -0400
X-MC-Unique: I6ZRyGUsMTyzN4TmTB0tUw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89AF11955BF6;
	Tue, 27 Aug 2024 06:30:40 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EC1141956054;
	Tue, 27 Aug 2024 06:30:38 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9EA7421E6A28; Tue, 27 Aug 2024 08:30:36 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Ani Sinha <anisinha@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  qemu-trivial@nongnu.org,  zhao1.liu@intel.com,  kvm@vger.kernel.org,
  qemu-devel@nongnu.org,  Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
In-Reply-To: <8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Fri, 9 Aug 2024 10:35:57
 +0200")
References: <20240809064940.1788169-1-anisinha@redhat.com>
	<8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
Date: Tue, 27 Aug 2024 08:30:36 +0200
Message-ID: <87v7zmmq9f.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Hi Ani,
>
> On 9/8/24 08:49, Ani Sinha wrote:
>> error_report() is more appropriate for error situations. Replace fprintf=
 with
>> error_report. Cosmetic. No functional change.
>> CC: qemu-trivial@nongnu.org
>> CC: zhao1.liu@intel.com
>
> (Pointless to carry Cc line when patch is already reviewed next line)
>
>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>> ---
>>   accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>>   1 file changed, 18 insertions(+), 22 deletions(-)
>> changelog:
>> v2: fix a bug.
>> v3: replace one instance of error_report() with error_printf(). added ta=
gs.
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 75d11a07b2..5bc9d35b61 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>>       QLIST_INIT(&s->kvm_parked_vcpus);
>>       s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>>       if (s->fd =3D=3D -1) {
>> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
>> +        error_report("Could not access KVM kernel module: %m");
>>           ret =3D -errno;
>>           goto err;
>>       }
>> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>>           if (ret >=3D 0) {
>>               ret =3D -EINVAL;
>>           }
>> -        fprintf(stderr, "kvm version too old\n");
>> +        error_report("kvm version too old");
>>           goto err;
>>       }
>>         if (ret > KVM_API_VERSION) {
>>           ret =3D -EINVAL;
>> -        fprintf(stderr, "kvm version not supported\n");
>> +        error_report("kvm version not supported");
>>           goto err;
>>       }
>>   @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>>       } while (ret =3D=3D -EINTR);
>>         if (ret < 0) {
>> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
>> -                strerror(-ret));
>> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
>> +                    strerror(-ret));
>>     #ifdef TARGET_S390X
>>           if (ret =3D=3D -EINVAL) {
>> -            fprintf(stderr,
>> -                    "Host kernel setup problem detected. Please verify:=
\n");
>> -            fprintf(stderr, "- for kernels supporting the switch_amode =
or"
>> -                    " user_mode parameters, whether\n");
>> -            fprintf(stderr,
>> -                    "  user space is running in primary address space\n=
");
>> -            fprintf(stderr,
>> -                    "- for kernels supporting the vm.allocate_pgste sys=
ctl, "
>> -                    "whether it is enabled\n");
>> +            error_report("Host kernel setup problem detected.
>
> \n"
>
> Should we use error_printf_unless_qmp() for the following?
>
> " Please verify:");
>> +            error_report("- for kernels supporting the switch_amode or"
>> +                        " user_mode parameters, whether");
>> +            error_report("  user space is running in primary address sp=
ace");
>> +            error_report("- for kernels supporting the vm.allocate_pgst=
e "
>> +                        "sysctl, whether it is enabled");

Do not put newlines into error messages.  error_report()'s function
comment demands "The resulting message should be a single phrase, with
no newline or trailing punctuation."

You can do this:

    error_report(... the actual error message ...);
    error_printf(... hints on what to do about it ...);

Questions?

[...]


