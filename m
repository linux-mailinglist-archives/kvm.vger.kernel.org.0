Return-Path: <kvm+bounces-50381-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 849A2AE4984
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D8DF3AE634
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E2ED29A30E;
	Mon, 23 Jun 2025 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G4VJRtwI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F6329A9E1
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694487; cv=none; b=Wq6erEiSVnq/L6Yq74rzLgH+gJofirv6qxw93LMRwdQXLXXwNMkZqc8/AKG5PrCZ4lBteSU1De+glxpjctbDYRZc5zeaHy+s3hI3ys10zLkmP1UhyaEl3iDu3PusjPB/MmO7MCiZigw6V5JFAKLFpJGRF1aNDaQZQJKYxSnLTmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694487; c=relaxed/simple;
	bh=c6uuemKxsomdTgRJVgVq+uTGQyiPEZkW/49HWAdUeeE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cYysaeF/JEUx4TOuryvMf1+Zv0pVNomGXUiIV8nt35aCrLOIGxCfrw4qiqX2On4WdOHnVhU/kgSvb2E7n6slmr8Jtm2XpCLNALeJ/0jeL7nDAxe5dUB6WHBBt3JZ+Sdlp27jwPbjQXUOjvsihzKjOwZi+IcL5aiV2XQbWSrKvgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G4VJRtwI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so3558673f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 09:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750694484; x=1751299284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DU4bZBou9LAAVdVrr6Ld25ONMj3wdbLa4mOlTx6S01A=;
        b=G4VJRtwIoqQ+OFF8LGUiVWh42PayL+ipE8KtOKKqwOcSMcYQrPT1nTcl//mPk2RzXq
         vH3ZTEVam7ZSCxwfoSBHah2YNFkjwrNQhrKubUxzabLNDyDrPdNkp/45HXd8RygcSzKo
         I/neihnckiOmg5I5HGvqPtRC5/Vtw2buCSokn2BAIQSgig2kPJ7MpfJ5HkldB3vsDh3d
         jItTkeSg8AhMzm2efurlLLY+vmim+IOTymWbQseYuJ23zLNmV3iuIcwva2eg46+Thb+x
         8xqEDEdRk3q3MWclpQJcC4bkhqTSGvt0J4uyeNul9a7FCKpBkrPq0DDKZ+fBkoZiru2J
         o2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750694484; x=1751299284;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DU4bZBou9LAAVdVrr6Ld25ONMj3wdbLa4mOlTx6S01A=;
        b=omfnP920+YiUbRwlfZ5bIG9BjHY6TuD5sjvsc4Lmcw/b2c4x4nJzoUhl4bmmyO5dj7
         g/Fdj4GVC4GXmq0YyOPC2jr9T0/KCALEjdoqoEZaJ9PPGQoknqBVtLNY9daWARTs2h+o
         ILG00p6FtBIAo4vxzzP+ADEv8ddSStFBGn7CDhVNwbd4QNgnZoym7KyvgoNEK7+p/NgH
         487dzbvZEWh7Wk82j3OD8EfF4ds7ZWEsKmCNd/oh8vIgS6d6H0Q4xUKAFkszbr+KdHVD
         fKQFsA115SeiOZKB/6ldKqPjOWxLrQvNE0sxz/QC/b6Stscdp1TMJ2L0wSlE+sbsklYz
         ECyg==
X-Forwarded-Encrypted: i=1; AJvYcCWkO9fRbMlJOPe8stiWyHvdI9+28h0cHvjBeFtl2ac/f1HQqwtU8qynGQse3AWhWzEtbfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBkOybZkuOUlZOpTzTk3Y6HGklY7BFau6/jsYrw2vuglf9VqGu
	0PhMwhcoHBuSiiMnYo773lHm5S8UT5dRdw10Q4AYy2efyWOaHQYC3ZjdSQhl3x2GPsQ=
X-Gm-Gg: ASbGncsHynHStbWa5FFUd7xcd7P80ch1ESh2Wqz4CWlzzFGwQYk0KMkyDR4+RAHU8Vm
	H17Br2LyOjFMbzSLU/f97F6xWEgmnJaw6dJXa9Z/DOVarvKSaXJ1dpMn1AIffY9x2ilzXfGelZy
	3GDJAzMvkQRoGjWbsJM3WlYJcAk0Kf/t1c1jaTzzGGi0Kbrfm7XqLOlXl9Makk0496XV4sz7keq
	8O9ieiRZZPYQHMSYeCZSNHHVe9XUIyRne9iYyfTWeXfa9dNfG35wEerBQJNC8BTK5Tos173ivQu
	Chb984O30Xhv6X0/qTj4q7huRzCbmaf1PH0Y5O8ApM4214aNbPz/QA8WOLpZ4QM=
X-Google-Smtp-Source: AGHT+IHpdekcjHe9tuPT5sbNvfpbZHtyMeUZcldY1trbSwYzgaJ0IVd+AXhTwUozst+QxUc436Rf0g==
X-Received: by 2002:a05:6000:2f87:b0:3a4:e238:6496 with SMTP id ffacd0b85a97d-3a6e71ff6f8mr20020f8f.18.1750694483186;
        Mon, 23 Jun 2025 09:01:23 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d1190b68sm9598520f8f.86.2025.06.23.09.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 09:01:22 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 7E1DF5F815;
	Mon, 23 Jun 2025 17:01:20 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
  qemu-arm@nongnu.org,  Daniel P. =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Roman
 Bolshakov <rbolshakov@ddn.com>,  Paolo Bonzini <pbonzini@redhat.com>,
  Alexander Graf <agraf@csgraf.de>,  Bernhard Beschow <shentey@gmail.com>,
  John Snow <jsnow@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
  kvm@vger.kernel.org,
  Eric Auger <eric.auger@redhat.com>,  Peter Maydell
 <peter.maydell@linaro.org>,  Cameron Esfahani <dirty@apple.com>,  Cleber
 Rosa <crosa@redhat.com>,  Radoslaw Biernacki <rad@semihalf.com>,  Phil
 Dennis-Jordan <phil@philjordan.eu>,  Richard Henderson
 <richard.henderson@linaro.org>
Subject: Re: [PATCH v3 26/26] tests/functional: Expand Aarch64 SMMU tests to
 run on HVF accelerator
In-Reply-To: <a8a4d2f7-2341-4cdb-8ca9-8deda337434c@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 23 Jun 2025 17:18:26
 +0200")
References: <20250623121845.7214-1-philmd@linaro.org>
	<20250623121845.7214-27-philmd@linaro.org>
	<87sejq1otw.fsf@draig.linaro.org>
	<a8a4d2f7-2341-4cdb-8ca9-8deda337434c@linaro.org>
User-Agent: mu4e 1.12.11; emacs 30.1
Date: Mon, 23 Jun 2025 17:01:20 +0100
Message-ID: <87ms9y1m7j.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> On 23/6/25 17:04, Alex Benn=C3=A9e wrote:
>> Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:
>>=20
>>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>>> ---
>>>   tests/functional/test_aarch64_smmu.py | 12 +++++++++---
>>>   1 file changed, 9 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tests/functional/test_aarch64_smmu.py b/tests/functional/t=
est_aarch64_smmu.py
>>> index c65d0f28178..e0f4a922176 100755
>>> --- a/tests/functional/test_aarch64_smmu.py
>>> +++ b/tests/functional/test_aarch64_smmu.py
>>> @@ -17,7 +17,7 @@
>>>     from qemu_test import LinuxKernelTest, Asset,
>>> exec_command_and_wait_for_pattern
>>>   from qemu_test import BUILD_DIR
>>> -from qemu.utils import kvm_available
>>> +from qemu.utils import kvm_available, hvf_available
>>>       class SMMU(LinuxKernelTest):
>>> @@ -45,11 +45,17 @@ def set_up_boot(self, path):
>>>           self.vm.add_args('-device', 'virtio-net,netdev=3Dn1' + self.I=
OMMU_ADDON)
>>>         def common_vm_setup(self, kernel, initrd, disk):
>>> -        self.require_accelerator("kvm")
>>> +        if hvf_available(self.qemu_bin):
>>> +            accel =3D "hvf"
>>> +        elif kvm_available(self.qemu_bin):
>>> +            accel =3D "kvm"
>>> +        else:
>>> +            self.skipTest("Neither HVF nor KVM accelerator is availabl=
e")
>>> +        self.require_accelerator(accel)
>> I think this is fine so:
>> Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> Thanks.
>
>> However I wonder if something like:
>>          hwaccel =3D self.require_hw_accelerator()
>> Could fetch the appropriate platform accelerator for use in -accel
>> bellow?
>
> Then we'd need to make it per-host arch, and I'm pretty sure hw
> accelerators don't support the same features. So I'd expect a
> rather painful experience. WDYT?

Aren't the features a function of the machine type rather than the host?
Shouldn't an -M virt machine look the same on TCG, KVM and HVF
regardless of the underlying accelerator?

I guess there are cases like split-irqchip which affect the
implementation but hopefully not the guest view of things.

Do you have an example?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

