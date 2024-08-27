Return-Path: <kvm+bounces-25144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2957C960A29
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:27:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D60B928239A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 12:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 875011B4C58;
	Tue, 27 Aug 2024 12:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G4a2AZ1T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD33A1B4C2E
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 12:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761588; cv=none; b=XeLaZ+w/IvHj2aMRy7qmp0hPket/0zHp8iWSjE0Ml+hAo5dSB+U4cdjUlMwox1LKFlZgBlw2wACi//Xi7vjx8PtuaXOtVwy0mNeiLu+p6sNekargQ+h6SNeMTa4GzCYUJ8jwNXTVaGxgjxuvP34qPziML0OpwuxVJPOUq7Dj1lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761588; c=relaxed/simple;
	bh=zIC1kd6xmYNGSXHmMs7yn4omvLXOwR7/BGz7+Du2s1U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Tl4L8EdD+SL2qqEpCsq1LryWp6B6WIgcqeaMtnR8tc8t86+uM/2q1UEC/ULXFofjrzllYBbFlY/vDGG/BBarXAdkBKBYSq+zjfYZlvn3QzQ/Y+LJBgr30jsXALFDfXgopxkjwFvF492HnjtrC+/bbrp+8GoVYQcw2OcO9BAJ67I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G4a2AZ1T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724761585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3pqf4vIDiJZIq0NvzPPjp8hfkf3fzLyKRmzc9tkgSTY=;
	b=G4a2AZ1T/hYmmJ7Ea3gxtcwbf9GqoGkDPZL8ldBsswXyb70AdUlOJteKZkjUyZ9Wnq58Y4
	2rzINXcEvZwv35lFywGRoEh1TwfnEqK4euoWj7HoPsur4ihAySsejpSMlW1I/XnQmpr6Z5
	7tvIqbiIEIxwetgX3l+sgBXz6NMWEcM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-y-Ul_CPtOw-27rCzWzUC0w-1; Tue,
 27 Aug 2024 08:26:24 -0400
X-MC-Unique: y-Ul_CPtOw-27rCzWzUC0w-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C20161955D54;
	Tue, 27 Aug 2024 12:26:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6072119560A3;
	Tue, 27 Aug 2024 12:26:20 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 05FFA21E6A28; Tue, 27 Aug 2024 14:26:18 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Ani Sinha <anisinha@redhat.com>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Paolo
 Bonzini
 <pbonzini@redhat.com>,  qemu-trivial@nongnu.org,  Zhao Liu
 <zhao1.liu@intel.com>,  kvm@vger.kernel.org,  qemu-devel
 <qemu-devel@nongnu.org>
Subject: Re: [PATCH v3] kvm: replace fprintf with error_report/printf() in
 kvm_init()
In-Reply-To: <03C06183-B8ED-405D-8B9C-532E30B8E412@redhat.com> (Ani Sinha's
	message of "Tue, 27 Aug 2024 17:47:44 +0530")
References: <20240809064940.1788169-1-anisinha@redhat.com>
	<8913b8c7-4103-4f69-8567-afdc29f8d0d3@linaro.org>
	<87v7zmmq9f.fsf@pond.sub.org>
	<03C06183-B8ED-405D-8B9C-532E30B8E412@redhat.com>
Date: Tue, 27 Aug 2024 14:26:18 +0200
Message-ID: <87plpui239.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Ani Sinha <anisinha@redhat.com> writes:

>> On 27 Aug 2024, at 12:00=E2=80=AFPM, Markus Armbruster <armbru@redhat.co=
m> wrote:
>>=20
>> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:
>>=20
>>> Hi Ani,
>>>=20
>>> On 9/8/24 08:49, Ani Sinha wrote:
>>>> error_report() is more appropriate for error situations. Replace fprin=
tf with
>>>> error_report. Cosmetic. No functional change.
>>>> CC: qemu-trivial@nongnu.org
>>>> CC: zhao1.liu@intel.com
>>>=20
>>> (Pointless to carry Cc line when patch is already reviewed next line)
>>>=20
>>>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>>>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
>>>> ---
>>>>  accel/kvm/kvm-all.c | 40 ++++++++++++++++++----------------------
>>>>  1 file changed, 18 insertions(+), 22 deletions(-)
>>>> changelog:
>>>> v2: fix a bug.
>>>> v3: replace one instance of error_report() with error_printf(). added =
tags.
>>>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>>>> index 75d11a07b2..5bc9d35b61 100644
>>>> --- a/accel/kvm/kvm-all.c
>>>> +++ b/accel/kvm/kvm-all.c
>>>> @@ -2427,7 +2427,7 @@ static int kvm_init(MachineState *ms)
>>>>      QLIST_INIT(&s->kvm_parked_vcpus);
>>>>      s->fd =3D qemu_open_old(s->device ?: "/dev/kvm", O_RDWR);
>>>>      if (s->fd =3D=3D -1) {
>>>> -        fprintf(stderr, "Could not access KVM kernel module: %m\n");
>>>> +        error_report("Could not access KVM kernel module: %m");
>>>>          ret =3D -errno;
>>>>          goto err;
>>>>      }
>>>> @@ -2437,13 +2437,13 @@ static int kvm_init(MachineState *ms)
>>>>          if (ret >=3D 0) {
>>>>              ret =3D -EINVAL;
>>>>          }
>>>> -        fprintf(stderr, "kvm version too old\n");
>>>> +        error_report("kvm version too old");
>>>>          goto err;
>>>>      }
>>>>        if (ret > KVM_API_VERSION) {
>>>>          ret =3D -EINVAL;
>>>> -        fprintf(stderr, "kvm version not supported\n");
>>>> +        error_report("kvm version not supported");
>>>>          goto err;
>>>>      }
>>>>  @@ -2488,26 +2488,22 @@ static int kvm_init(MachineState *ms)
>>>>      } while (ret =3D=3D -EINTR);
>>>>        if (ret < 0) {
>>>> -        fprintf(stderr, "ioctl(KVM_CREATE_VM) failed: %d %s\n", -ret,
>>>> -                strerror(-ret));
>>>> +        error_report("ioctl(KVM_CREATE_VM) failed: %d %s", -ret,
>>>> +                    strerror(-ret));
>>>>    #ifdef TARGET_S390X
>>>>          if (ret =3D=3D -EINVAL) {
>>>> -            fprintf(stderr,
>>>> -                    "Host kernel setup problem detected. Please verif=
y:\n");
>>>> -            fprintf(stderr, "- for kernels supporting the switch_amod=
e or"
>>>> -                    " user_mode parameters, whether\n");
>>>> -            fprintf(stderr,
>>>> -                    "  user space is running in primary address space=
\n");
>>>> -            fprintf(stderr,
>>>> -                    "- for kernels supporting the vm.allocate_pgste s=
ysctl, "
>>>> -                    "whether it is enabled\n");
>>>> +            error_report("Host kernel setup problem detected.
>>>=20
>>> \n"
>>>=20
>>> Should we use error_printf_unless_qmp() for the following?
>>>=20
>>> " Please verify:");
>>>> +            error_report("- for kernels supporting the switch_amode o=
r"
>>>> +                        " user_mode parameters, whether");
>>>> +            error_report("  user space is running in primary address =
space");
>>>> +            error_report("- for kernels supporting the vm.allocate_pg=
ste "
>>>> +                        "sysctl, whether it is enabled");
>>=20
>> Do not put newlines into error messages.  error_report()'s function
>> comment demands "The resulting message should be a single phrase, with
>> no newline or trailing punctuation."
>>=20
>> You can do this:
>>=20
>>    error_report(... the actual error message ...);
>>    error_printf(... hints on what to do about it ...);
>>=20
>> Questions?
>
> Do you see any newlines in my proposed patch?

I see some in Philippe's suggestion.

Your patch's use of multiple error_report() for a single error condition
is inappropriate.

Questions?


