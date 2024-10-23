Return-Path: <kvm+bounces-29474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8551B9AC266
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 10:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AA6E7B25049
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 08:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7461E1684B0;
	Wed, 23 Oct 2024 08:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jmLijMLa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93A516130B
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 08:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729673850; cv=none; b=IFnlr9nAeWDQDQ6nymH3NGt/5U8YJq4khYUortdewjadGgESVmxQ612XPo+ioT/ZlVYKSiwNPj7/J0e1JbnvqzvWmBjerVrYm9cJePVIfdlSm2fs7G2SCBaDCqKMOeMTyO9oOud6AsCHvPdnpltB2F6VsW+CTHv7ZSan91oo1y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729673850; c=relaxed/simple;
	bh=KTUSW1Z8tLZQuyPEOoAIxbKgyrcsJEr17roneK/olk4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=hE1edalfOAdPTr9L+SDvi1EuwgXWdgwgim/1WbqCANswbsfmFCtkjfS87SIHEyJyHg/iudma7vBEGnId121mtOoMBWFVMO5occ/1zNvNz/S6zHgsWfecAJkJd71muzovspA1oKdll1x8Hcm4PrX7i87o8i4ZRvTcTNYFOXvvqiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jmLijMLa; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9a16b310f5so837587066b.0
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 01:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729673847; x=1730278647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eu9HNFhzHWeZ50qGe67KBPhEI+rp9HKwcRfZHlrfZvE=;
        b=jmLijMLaYeZHjfyAl08qBURcez/S8A6cGFADhKsbJqK+a8h+uJYLA5BtdQdBwhw5H7
         28yI6YT+ny+K8sBU5G8X5Ocy443cFOwxL8jyuoCOrceVv/hicqbgqjXxX7715XNQf+mW
         a+8Lwr0dBpuD9r5P39nKXYSc86/jyAWf/lmYarLQiOD5xkj2GzTSxnX7vNnaG61bqM9i
         LqwphoOE9FXKPLnY41ZMQiBlrbz57YgI3jPwRtoQ5665UHIkEsv1nhj4iT2ksI83UY+T
         rhth3xpP8/fqFBEWvbOm+wWqi0v0eh7YTTCte9VsLUgLGatC+VJsSQv2ma3KdJasztgs
         nAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729673847; x=1730278647;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eu9HNFhzHWeZ50qGe67KBPhEI+rp9HKwcRfZHlrfZvE=;
        b=Xm0uaudzJ9qmNs65t9mnDT1zheCJJfyhgcjTLYWNSgjtkdaAgWitmg5KYmw+VbWHbj
         iwr2l0MWxJW64vTSBX5uDYu59rZFHjX2W8n0w3sJVkXIt12vzeaYIEaZeTHhTS82uHvn
         gXvwjDMwLWRuXSv4dSnlP30i9puaEXMyrQSy5BC56OKPYm02/6hgzoDoPFV/6dkT21lE
         sViYiV+R73b2/4xiKsk4NlR/uVJfFVsUH7cOoy4j2+WMkgQrZ98Q0xT1SkfGamI7c3v2
         cnOw450U9gyXXbCAF8b3TUSnHHCDHj64LrSuh6PJIy4w4/YyscKXP0RkOCLJmtYTnRoM
         +LTg==
X-Forwarded-Encrypted: i=1; AJvYcCWZtAxoJl8tt/uDvjHxjkq/LkElCyeeb8PQWzotLG7ewQ3SqgrJ1hyuy85PfJEHNDIFtfk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEr72pFpsH6iLOBWK7/EYRQVGpg9G5YeoSASfOZMBMSYVtFoE+
	pdWv3XyPQz5/UXRxo1I5ZeFAlARAAo2JLPy2Wx0L8bA3C7ShVbk/bTCzR8C5rYQ=
X-Google-Smtp-Source: AGHT+IEkbd1iXj9Aj2fc5MX0hN+gYpbHOqjyyYU3Qnv4GxuUq7DNedPP9W0UoyidBwlVqvNsEo9Fjw==
X-Received: by 2002:a17:906:478c:b0:a9a:3ca0:d55a with SMTP id a640c23a62f3a-a9abf9ae37emr157756266b.57.1729673846839;
        Wed, 23 Oct 2024 01:57:26 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912d638fsm448745966b.18.2024.10.23.01.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 01:57:26 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 665CA5F89C;
	Wed, 23 Oct 2024 09:57:25 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  Beraldo Leal <bleal@redhat.com>,  Laurent Vivier
 <laurent@vivier.eu>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Mahmoud Mandour <ma.mandourr@gmail.com>,  Jiaxun Yang
 <jiaxun.yang@flygoat.com>,  Yanan Wang <wangyanan55@huawei.com>,  Thomas
 Huth <thuth@redhat.com>,  John Snow <jsnow@redhat.com>,  =?utf-8?Q?Marc-A?=
 =?utf-8?Q?ndr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,  qemu-arm@nongnu.org,  Daniel P.
 =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,
  devel@lists.libvirt.org,  Cleber Rosa <crosa@redhat.com>,
  kvm@vger.kernel.org,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,
  Alexandre Iooss <erdnaxe@crans.org>,  Peter Maydell
 <peter.maydell@linaro.org>,  Richard Henderson
 <richard.henderson@linaro.org>,  Riku Voipio <riku.voipio@iki.fi>,  Zhao
 Liu <zhao1.liu@intel.com>,  Marcelo Tosatti <mtosatti@redhat.com>,  "Edgar
 E. Iglesias" <edgar.iglesias@gmail.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 18/20] meson: build contrib/plugins with meson
In-Reply-To: <fe33c996-3241-4706-9ac1-85f00cb8f388@linaro.org> (Pierrick
	Bouvier's message of "Wed, 23 Oct 2024 00:51:32 -0700")
References: <20241022105614.839199-1-alex.bennee@linaro.org>
	<20241022105614.839199-19-alex.bennee@linaro.org>
	<fe33c996-3241-4706-9ac1-85f00cb8f388@linaro.org>
User-Agent: mu4e 1.12.6; emacs 29.4
Date: Wed, 23 Oct 2024 09:57:25 +0100
Message-ID: <87sesnkxhm.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> On 10/22/24 03:56, Alex Benn=C3=A9e wrote:
>> From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Tried to unify this meson.build with tests/tcg/plugins/meson.build
>> but
>> the resulting modules are not output in the right directory.
>> Originally proposed by Anton Kochkov, thank you!
>> Solves: https://gitlab.com/qemu-project/qemu/-/issues/1710
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Message-Id: <20240925204845.390689-2-pierrick.bouvier@linaro.org>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>>   meson.build                 |  4 ++++
>>   contrib/plugins/meson.build | 23 +++++++++++++++++++++++
>>   2 files changed, 27 insertions(+)
>>   create mode 100644 contrib/plugins/meson.build
>> diff --git a/meson.build b/meson.build
>> index bdd67a2d6d..3ea03c451b 100644
>> --- a/meson.build
>> +++ b/meson.build
>> @@ -3678,6 +3678,10 @@ subdir('accel')
>>   subdir('plugins')
>>   subdir('ebpf')
>>   +if 'CONFIG_TCG' in config_all_accel
>> +  subdir('contrib/plugins')
>> +endif
>> +
>>   common_user_inc =3D []
>>     subdir('common-user')
>> diff --git a/contrib/plugins/meson.build b/contrib/plugins/meson.build
>> new file mode 100644
>> index 0000000000..a0e026d25e
>> --- /dev/null
>> +++ b/contrib/plugins/meson.build
>> @@ -0,0 +1,23 @@
>> +t =3D []
>> +if get_option('plugins')
>> +  foreach i : ['cache', 'drcov', 'execlog', 'hotblocks', 'hotpages', 'h=
owvec',
>> +               'hwprofile', 'ips', 'lockstep', 'stoptrigger']
>
> lockstep does not build under Windows (it uses sockets), so it should
> be conditionnally not built on this platform.
> @Alex, if you feel like modifying this, you can. If not, you can drop
> the meson build patches from this series to not block it.

I'll drop from the PR and let you re-submit.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

