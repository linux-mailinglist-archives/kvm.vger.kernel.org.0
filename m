Return-Path: <kvm+bounces-5146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F05B81CAD5
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 14:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8040285DEE
	for <lists+kvm@lfdr.de>; Fri, 22 Dec 2023 13:45:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9CDC1A28F;
	Fri, 22 Dec 2023 13:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OnrgXYe9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2473D199A7
	for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 13:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40d31116dbeso19979595e9.3
        for <kvm@vger.kernel.org>; Fri, 22 Dec 2023 05:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703252708; x=1703857508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1eQLtUBmvM7qf6L4q7EV35KVsS6WxNrpt1uXoUEq+k4=;
        b=OnrgXYe9HeHFOw+F6D99vQpvahGzcPa5N74rbhUoSDq335+luLg4KKnRB2v9QOFR/c
         up0UsflVzS0E49oY3BRLSuiH/FQReN5clNu5QfdL2OuCT13f5SW2C2iG0ar4s5fSnW9f
         0AlcNs8xW+1EC86xwQezMcrCpjEBBNsqbfho/SD8kzpaI9IbnNipFXcFDfFvNyKC40PY
         ImU/Yb65IT7lJQySj7tuOJr180G8mNA9DnUZA/7dc2AJp0ZXTaIAhyrMQ6s/X/bkCzEw
         I4ZAIv8DBI6M+YXuXYEB8STkwiTKL/fdNUzoBrQqSQIUw2kV8R227MZI3Qpoa4qlMWBf
         tbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703252708; x=1703857508;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1eQLtUBmvM7qf6L4q7EV35KVsS6WxNrpt1uXoUEq+k4=;
        b=dtZnWt4fJjJI+ooJh+mgyHBvo5+MrDNA7CgUFcM/YAQkZUVUdDHMeMtfDsmNW7w75o
         LsQ1TCjoJ7fED2ARQSmzQjSD8ZfbHeRxj9HQX+0qgReoAhiExtgMWv8bf8XgDc3uLihi
         2pLOpN8psER3qiCE9pWUy4cNzLLjwV8DYRmGARk+yjSIY9a6qGw8kVnB6bfcyTLc5wNp
         WmYHhMjeQt27rrTbSr6RWgUYnCLbCF1x40R1B2i+45It4ig4NTByuAlOw37I+Qjo1mMW
         AID70iyqlCEk704PNVywhJP7XSXbWO67dGoPf8A8M2zFkS1FXuM3Inu0Cb3Ggec6itd2
         mJxQ==
X-Gm-Message-State: AOJu0YyABKDPh95MPzIX6Kw7stxI0lyoAtU2nAlilFoJipE6zhcGZ5J1
	Ok8f1AquiwTSzFXN4lKNi1xAftsyDGr8gg==
X-Google-Smtp-Source: AGHT+IFyc707r97nFb1fUFU6MymgM12uRQv1WFsoBXvbFD/R85hDyverRoAN6WkYq3pdWfalSFssHg==
X-Received: by 2002:a05:600c:4f02:b0:40d:4d75:980 with SMTP id l2-20020a05600c4f0200b0040d4d750980mr8318wmq.71.1703252708181;
        Fri, 22 Dec 2023 05:45:08 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id az3-20020a05600c600300b0040d4954ac04sm1253567wmb.43.2023.12.22.05.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Dec 2023 05:45:07 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 734CF5F7DA;
	Fri, 22 Dec 2023 13:45:07 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: qemu-devel@nongnu.org,  "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
  John Snow <jsnow@redhat.com>,  Aurelien Jarno <aurelien@aurel32.net>,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Yanan Wang
 <wangyanan55@huawei.com>,  Eduardo Habkost <eduardo@habkost.net>,  Brian
 Cain <bcain@quicinc.com>,  Laurent Vivier <laurent@vivier.eu>,  Palmer
 Dabbelt <palmer@dabbelt.com>,  Cleber Rosa <crosa@redhat.com>,  David
 Hildenbrand <david@redhat.com>,  Beraldo Leal <bleal@redhat.com>,
  Pierrick Bouvier <pierrick.bouvier@linaro.org>,  Weiwei Li
 <liwei1518@gmail.com>,  Paul Durrant <paul@xen.org>,
  qemu-s390x@nongnu.org,  David Woodhouse <dwmw2@infradead.org>,  Liu
 Zhiwei <zhiwei_liu@linux.alibaba.com>,  Ilya Leoshkevich
 <iii@linux.ibm.com>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Michael Rolnik <mrolnik@gmail.com>,  Alistair Francis
 <alistair.francis@wdc.com>,  Daniel Henrique Barboza
 <danielhb413@gmail.com>,  Laurent Vivier <lvivier@redhat.com>,
  kvm@vger.kernel.org,  =?utf-8?Q?Marc-Andr=C3=A9?= Lureau
 <marcandre.lureau@redhat.com>,
  Alexandre Iooss <erdnaxe@crans.org>,  Thomas Huth <thuth@redhat.com>,
  Peter Maydell <peter.maydell@linaro.org>,  qemu-ppc@nongnu.org,  Paolo
 Bonzini <pbonzini@redhat.com>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Nicholas Piggin <npiggin@gmail.com>,
  qemu-riscv@nongnu.org,  qemu-arm@nongnu.org,  Song Gao
 <gaosong@loongson.cn>,  Yoshinori Sato <ysato@users.sourceforge.jp>,
  Richard Henderson <richard.henderson@linaro.org>,  Daniel Henrique
 Barboza <dbarboza@ventanamicro.com>,  =?utf-8?Q?C=C3=A9dric?= Le Goater
 <clg@kaod.org>,
  Mahmoud Mandour <ma.mandourr@gmail.com>,  Bin Meng
 <bin.meng@windriver.com>
Subject: Re: [PATCH 37/40] plugins: add an API to read registers
In-Reply-To: <a26a55b2-240c-48c3-b341-48c1d7195bd9@daynix.com> (Akihiko
	Odaki's message of "Thu, 21 Dec 2023 22:19:25 +0900")
References: <20231221103818.1633766-1-alex.bennee@linaro.org>
	<20231221103818.1633766-38-alex.bennee@linaro.org>
	<a26a55b2-240c-48c3-b341-48c1d7195bd9@daynix.com>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Fri, 22 Dec 2023 13:45:07 +0000
Message-ID: <87y1dmxsf0.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Akihiko Odaki <akihiko.odaki@daynix.com> writes:

> On 2023/12/21 19:38, Alex Benn=C3=A9e wrote:
>> We can only request a list of registers once the vCPU has been
>> initialised so the user needs to use either call the get function on
>> vCPU initialisation or during the translation phase.
>> We don't expose the reg number to the plugin instead hiding it
>> behind
>> an opaque handle. This allows for a bit of future proofing should the
>> internals need to be changed while also being hashed against the
>> CPUClass so we can handle different register sets per-vCPU in
>> hetrogenous situations.
>> Having an internal state within the plugins also allows us to expand
>> the interface in future (for example providing callbacks on register
>> change if the translator can track changes).
>> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1706
>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Based-on: <20231025093128.33116-18-akihiko.odaki@daynix.com>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>> v2
>>    - use new get whole list api, and expose upwards
>> vAJB:
>> The main difference to Akikio's version is hiding the gdb register
>> detail from the plugin for the reasons described above.
>> ---
>>   include/qemu/qemu-plugin.h   |  53 +++++++++++++++++-
>>   plugins/api.c                | 102 +++++++++++++++++++++++++++++++++++
>>   plugins/qemu-plugins.symbols |   2 +
>>   3 files changed, 155 insertions(+), 2 deletions(-)
>> diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
>> index 4daab6efd29..e3b35c6ee81 100644
>> --- a/include/qemu/qemu-plugin.h
>> +++ b/include/qemu/qemu-plugin.h
>> @@ -11,6 +11,7 @@
>>   #ifndef QEMU_QEMU_PLUGIN_H
>>   #define QEMU_QEMU_PLUGIN_H
>>   +#include <glib.h>
>>   #include <inttypes.h>
>>   #include <stdbool.h>
>>   #include <stddef.h>
>> @@ -227,8 +228,8 @@ struct qemu_plugin_insn;
>>    * @QEMU_PLUGIN_CB_R_REGS: callback reads the CPU's regs
>>    * @QEMU_PLUGIN_CB_RW_REGS: callback reads and writes the CPU's regs
>>    *
>> - * Note: currently unused, plugins cannot read or change system
>> - * register state.
>> + * Note: currently QEMU_PLUGIN_CB_RW_REGS is unused, plugins cannot cha=
nge
>> + * system register state.
>>    */
>>   enum qemu_plugin_cb_flags {
>>       QEMU_PLUGIN_CB_NO_REGS,
>> @@ -708,4 +709,52 @@ uint64_t qemu_plugin_end_code(void);
>>   QEMU_PLUGIN_API
>>   uint64_t qemu_plugin_entry_code(void);
>>   +/** struct qemu_plugin_register - Opaque handle for a translated
>> instruction */
>> +struct qemu_plugin_register;
>
> What about identifying a register with an index in an array returned
> by qemu_plugin_get_registers(). That saves troubles having the handle
> member in qemu_plugin_reg_descriptor.
>
>> +
>> +/**
>> + * typedef qemu_plugin_reg_descriptor - register descriptions
>> + *
>> + * @name: register name
>> + * @handle: opaque handle for retrieving value with qemu_plugin_read_re=
gister
>> + * @feature: optional feature descriptor, can be NULL
>
> Why can it be NULL?
>
>> + */
>> +typedef struct {
>> +    char name[32];
>
> Why not const char *?

I was trying to avoid too many free floating strings. I could intern it
in the API though.

>
>> +    struct qemu_plugin_register *handle;
>> +    const char *feature;
>> +} qemu_plugin_reg_descriptor;
>> +
>> +/**
>> + * qemu_plugin_get_registers() - return register list for vCPU
>> + * @vcpu_index: vcpu to query
>> + *
>> + * Returns a GArray of qemu_plugin_reg_descriptor or NULL. Caller
>> + * frees the array (but not the const strings).
>> + *
>> + * As the register set of a given vCPU is only available once
>> + * the vCPU is initialised if you want to monitor registers from the
>> + * start you should call this from a qemu_plugin_register_vcpu_init_cb()
>> + * callback.
>
> Is this note really necessary? You won't know vcpu_index before
> qemu_plugin_register_vcpu_init_cb() anyway.

Best to be clear I think.

>
>> + */
>> +GArray * qemu_plugin_get_registers(unsigned int vcpu_index);
>
> Spurious space after *.
>
>> +
>> +/**
>> + * qemu_plugin_read_register() - read register
>> + *
>> + * @vcpu: vcpu index
>> + * @handle: a @qemu_plugin_reg_handle handle
>> + * @buf: A GByteArray for the data owned by the plugin
>> + *
>> + * This function is only available in a context that register read acce=
ss is
>> + * explicitly requested.
>> + *
>> + * Returns the size of the read register. The content of @buf is in tar=
get byte
>> + * order. On failure returns -1
>> + */
>> +int qemu_plugin_read_register(unsigned int vcpu,
>> +                              struct qemu_plugin_register *handle,
>> +                              GByteArray *buf);
>
> Indention is not correct. docs/devel/style.rst says:
>
>> In case of function, there are several variants:
>>
>> * 4 spaces indent from the beginning
>> * align the secondary lines just after the opening parenthesis of
>     the first

Isn't that what it does?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

