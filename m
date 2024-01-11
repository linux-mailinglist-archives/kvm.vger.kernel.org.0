Return-Path: <kvm+bounces-6074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C44D482AEA7
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 13:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A4ED2835D6
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 12:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3558215AC4;
	Thu, 11 Jan 2024 12:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zz51w3LP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E24156FA
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 12:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-336c8ab0b20so4610346f8f.1
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 04:24:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704975880; x=1705580680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A1RkaaWOJSu3tRt3fMogcSn7L2SZU/h+k8yCADoRVlk=;
        b=Zz51w3LPcl5H3Pw+xAnlGOfxfotQ309T5l7jyT/ENUCSNr9G/kUsgqgiaisygtpvvX
         BMZ8GOGFX82PrZ/ZqWWIELwSNYWMb82IlE7/JPR7s2u1MVyqr8XOgru4YZBKmPhdqf64
         CpFy+RQFDWTkOE0MqDBArpGVYwTMi70So2R6KkUSDrudLX6tHbW24vz5HkOc/SUujwkA
         pNWkyGZIjTsIoAYXfqq0wFr4idPhJGTZhfbOEge4LQXg4VSyOyV5sM0XZ1v/CXkNo7Ft
         MHxbOldSlRYuF3kvCADW+cyGGRqyYxu+fvDnecqYtK4o3zMQEZIhqdcTvvsJgrcBSk48
         rRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704975880; x=1705580680;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A1RkaaWOJSu3tRt3fMogcSn7L2SZU/h+k8yCADoRVlk=;
        b=o/dqpFTJOlvOmDcfBdBm4Neu4dygQz0Dc8cBj21jeE35YBCr4gZbGFaPBWB+phi4Nd
         aQfuWZ0ISQlCGqKsTKDBTu0IrUtCnl5Vjx7z/s/PJ7uA3EdOMjbWFGObiFqZ5fYiQ/75
         69CR3gKFCeHk0PBFA2y5Re1S+sdthZwey3E88w487jx2HZeE9Lv+boJoQzOgmMIB/RaS
         3yV0q72xctY6QfyJgYfmuee7PRvDEyhJSMSg8it1DOjynGP2oBVmKeUGuVfQxQQQzB9M
         HyYJe1cAGUbtRTdXGvQYzKCCc7vSY918TVpW2TG6+p91DPlV63tCo3aD9UcGwbMVSBGW
         8sOw==
X-Gm-Message-State: AOJu0YzegcDWn/ykxUA/aQcEmsiWAxjldIBNpuYrC5tDOP4B8gkBGXay
	BI9wiY2pYh6yXjmgkePlMoo2y2aHgbzCFw==
X-Google-Smtp-Source: AGHT+IEqJmabPEzUTHGU1RLVecC2ffwvZaKXWABKkEz3S4ahDb+PVctSP5LR9cXaQbb+fPNjjPq6rg==
X-Received: by 2002:a5d:4b4e:0:b0:336:6db3:1d7a with SMTP id w14-20020a5d4b4e000000b003366db31d7amr644820wrs.103.1704975879726;
        Thu, 11 Jan 2024 04:24:39 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p19-20020adf9d93000000b003378ea9a7desm303358wre.33.2024.01.11.04.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 04:24:39 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id F36AA5F7AD;
	Thu, 11 Jan 2024 12:24:38 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: =?utf-8?B?RnLDqWTDqXJpYyBQw6l0cm90?=
 <frederic.petrot@univ-grenoble-alpes.fr>
Cc: qemu-devel@nongnu.org,  qemu-s390x@nongnu.org,  qemu-ppc@nongnu.org,
  Richard Henderson <richard.henderson@linaro.org>,  Song Gao
 <gaosong@loongson.cn>,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  David Hildenbrand <david@redhat.com>,  Aurelien Jarno
 <aurelien@aurel32.net>,  Yoshinori Sato <ysato@users.sourceforge.jp>,
  Yanan Wang <wangyanan55@huawei.com>,  Bin Meng <bin.meng@windriver.com>,
  Laurent Vivier <lvivier@redhat.com>,  Michael Rolnik <mrolnik@gmail.com>,
  Alexandre Iooss <erdnaxe@crans.org>,  David Woodhouse
 <dwmw2@infradead.org>,  Laurent Vivier <laurent@vivier.eu>,  Paolo Bonzini
 <pbonzini@redhat.com>,  Brian Cain <bcain@quicinc.com>,  Daniel Henrique
 Barboza <danielhb413@gmail.com>,  Beraldo Leal <bleal@redhat.com>,  Paul
 Durrant <paul@xen.org>,  Mahmoud Mandour <ma.mandourr@gmail.com>,  Thomas
 Huth <thuth@redhat.com>,  Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
  Cleber Rosa <crosa@redhat.com>,  kvm@vger.kernel.org,  Peter Maydell
 <peter.maydell@linaro.org>,  Wainer dos Santos Moschetta
 <wainersm@redhat.com>,  qemu-arm@nongnu.org,  Weiwei Li
 <liwei1518@gmail.com>,  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>,  John
 Snow <jsnow@redhat.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Nicholas Piggin <npiggin@gmail.com>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Ilya Leoshkevich <iii@linux.ibm.com>,
  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,  "Edgar E. Iglesias"
 <edgar.iglesias@gmail.com>,  Eduardo Habkost <eduardo@habkost.net>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  qemu-riscv@nongnu.org,
  Alistair Francis <alistair.francis@wdc.com>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v2 40/43] contrib/plugins: extend execlog to track
 register changes
In-Reply-To: <9f9b8359-d33b-4c94-8eb1-fc500d8fc2b4@univ-grenoble-alpes.fr>
	(=?utf-8?Q?=22Fr=C3=A9d=C3=A9ric_P=C3=A9trot=22's?= message of "Fri, 5 Jan
 2024 11:40:07 +0100")
References: <20240103173349.398526-1-alex.bennee@linaro.org>
	<20240103173349.398526-41-alex.bennee@linaro.org>
	<9f9b8359-d33b-4c94-8eb1-fc500d8fc2b4@univ-grenoble-alpes.fr>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Thu, 11 Jan 2024 12:24:38 +0000
Message-ID: <87o7dsf46x.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Fr=C3=A9d=C3=A9ric P=C3=A9trot <frederic.petrot@univ-grenoble-alpes.fr> wri=
tes:

> Hello Alex,
>
>   just reporting below what might be a riscv only oddity (also applies to
>   patch 41 but easier to report here).
>
> Le 03/01/2024 =C3=A0 18:33, Alex Benn=C3=A9e a =C3=A9crit=C2=A0:
>> With the new plugin register API we can now track changes to register
>> values. Currently the implementation is fairly dumb which will slow
>> down if a large number of register values are being tracked. This
>> could be improved by only instrumenting instructions which mention
>> registers we are interested in tracking.
>> Example usage:
>>    ./qemu-aarch64 -D plugin.log -d plugin \
>>       -cpu max,sve256=3Don \
>>       -plugin contrib/plugins/libexeclog.so,reg=3Dsp,reg=3Dz\* \
>>       ./tests/tcg/aarch64-linux-user/sha512-sve
>> will display in the execlog any changes to the stack pointer (sp)
>> and
>> the SVE Z registers.
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Based-On: <20231025093128.33116-19-akihiko.odaki@daynix.com>
>
>> +static registers_init(int vcpu_index)
>> +{
>> +    GPtrArray *registers =3D g_ptr_array_new();
>> +    g_autoptr(GArray) reg_list =3D qemu_plugin_get_registers(vcpu_index=
);
>> +
>> +    if (reg_list && reg_list->len) {
>> +        /*
>> +         * Go through each register in the complete list and
>> +         * see if we want to track it.
>> +         */
>> +        for (int r =3D 0; r < reg_list->len; r++) {
>> +            qemu_plugin_reg_descriptor *rd =3D &g_array_index(
>> +                reg_list, qemu_plugin_reg_descriptor, r);
>
> riscv csrs are not continously numbered and the dynamically generated gdb=
 xml
> seems to follow that scheme.
> So the calls to Glib string functions output quite a few assertion
> warnings because for the non existing csrs rd->name is NULL (and there
> are a bit less than 4000 such cases for rv64g).
> Checking for NULL and then continue is a simple way to solve the issue, b=
ut
> I am not sure this is the proper way to proceed, as it might stand in the
> generation of the riscv xml description for gdb.

I think in this case it might be easier to not expose it to the plugin
user at all. Is the lack of names an omission? How does gdb see them?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

