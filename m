Return-Path: <kvm+bounces-7932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1389984855C
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:44:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8591F1F25723
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 11:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C855D8F4;
	Sat,  3 Feb 2024 11:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d8VZdElL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17585D737
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 11:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706960673; cv=none; b=J8EuRUV1+cY55h84Shs1dOwqZ+9YrvZK/KUzWHcWpn/KjbDM796t4fqnJI5WctQlxAbfM0CuMeQ9SO9vhNuF4v+Fh6ImKQhzR0/qHtYqkiFyqAYNU8EyED6+BGlU3xB8yPkZykVZ70EKHXKNTdB6r3duISywOhpspfci/CwswKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706960673; c=relaxed/simple;
	bh=6UkEt4AZVM88QbqVM9M87GFP5cvezgbYb9I61yimnJM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VAvpdF/oY10dWNa7NKpDP6UgJH3UGMIKm6eeY+40O83w2A5VFulyqDaPH9UXbK5I6DQvysSqorgMFUWOee329Is3fqwozr7grhIbb8vtSJBefoPRUz/vMJ7QbmOcAGSekAvbnNWuVuqmkcM7Pxazse70tKhPBf/eRhptt9yLii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d8VZdElL; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40f033c2e30so26104815e9.0
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 03:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706960670; x=1707565470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7i2eVmx3bgBKTW0/dA1vFA1Ra0CFTZkkFTgcLaocM4=;
        b=d8VZdElLkPvTt7xc1fOGRlSp4Eo1o7t34qwmljNBY0n49Wl3HTsaqc03+QIcEzevAR
         RmCHzRVMDNwmcZzD2EtVoPAyC1dhMbvvItwoFj+9OxffOubEXFYeSdrQ/vJwU9ahjgSZ
         JmmIClZ5uswWdtpAABbAWjlli0IrmEaIAlKrVL2upxTYMqE/b9LLqBqLo+9KTn7jCI1A
         WOvXR7uBf7BMzeiBysCO+h+uK84aUQVnaTRmJa1QtBEg4273TFRlEkQ2r+FisCWqQERK
         dYaig+Q4DjaL3EZLhzeNwSZ/dPwhgRwAw/jWbZvASgIEkdhPD97Wi+KqsWgwPzcmghmK
         1upA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706960670; x=1707565470;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J7i2eVmx3bgBKTW0/dA1vFA1Ra0CFTZkkFTgcLaocM4=;
        b=B2ifyN/UooKbPp/5p1tNG1I2fT6sLpUshgO4iYuDYjPBM0UYqdREf4KNYmiVgxpJs4
         WX4lXtOKtmNDrHEtXZ5qf6qsVYBh0QlYKUPDLfSbMhtd+4s3ymmZY23k7ve4cAaRzoEs
         mxeT/DT9vF5/0OIVWw0IwXjlfxFcDWQ7RXmNyqLF48tXGlcHigXEiiFsbwZWrBGgohPZ
         oB9r4Q2keXxPGjPQaEFSfLztwbKM81OauJEeFd5c3FHA1C5seTuTCHrkp9Qz9wIcIMbn
         iRoXSWxfCKxkoA9DVNsY/z//9FtmFD4HkP3MA59+xyVQZqFWIVp7kCuMcZUQ8ttbWqBq
         alFw==
X-Gm-Message-State: AOJu0YyM3nfAWZAQC83ocJnE/KHT73sh9GYBDpfzcTgW9iBg4pONZaT5
	TDMM3BoRDfPqPdfu8ijiQdzYH6tfdVj0nACWgzLKDVlxu6Wf9MxQVRkP/id2eEA=
X-Google-Smtp-Source: AGHT+IEBLqHjQHdStMPIfTOV2hRjujiZ+Ur/yvN7cwiIHGwYCKyLU7DUja4U7oQrbkNg0VCJhfGtrA==
X-Received: by 2002:adf:ec02:0:b0:33b:2326:5142 with SMTP id x2-20020adfec02000000b0033b23265142mr2583318wrn.13.1706960669907;
        Sat, 03 Feb 2024 03:44:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWOjB+MbAchR7jaNpDzLGcatmt9xJy2EZzefqQOW3rcLVp0VxdDGRvt1FNSL++FSbr6/nolkbnFzMUc9PInbcm9VA+o88XM88OoPFbqG7EniWRg9NQ1iv/16badwiKZza4bKTzAnqyazLlkQM7/HvYHKju/lzuMvVHggk7A6vffBI9VY2bWdbZtsB53UcqrbttBKaLb6kNfaythwn4ennkRFX5nFReVbe8cwnrNdXSBEtXb4oePw7glrtdhjbljEIKaL6fvuU2KnFYiLefUa/2bVrlS9r3/Bw+VtfjGVYiFo2T72OHMxqnyzsY5b8x2ccG/VufB0nLekrPJKHGma+Sou1ZcFkndSLrLFr3hlK8inwFpiRA9gTbbWumRd7K7AYhsdztMZCYmYEYq/csdWADJDSZx/+QtSSuSjjox4redsEXMVme59wYgDQvRbSlKv9+lxb69ArxYz1ktvYPR9064vQ0KE4/dvFFmLNVZpYqAaKQahtEHT6HP9iWK2khnjo0+Ef2a9usXJq6etSf1QgfybnWs+6Q6Bah2MFhAd3O6RbOgYPHm2Co8FDaucDhAWa4olZ+5oZ3BQ5G2q5lkqu7+2JhM8KcrffaIEM4/QaYsjIntLFtz3gHMRHTUdcKO+yjD9xz1ufSN2dObcT1k7P+HVKeWW1pYWj4AFtiPQgMRx6CTEVIygg83RogTRoiol4ySrxdmsvg46DQ2XBxfENjENutLbU/C27HE6vX1VDF4s11IdNFwyIuqpT7thZmHC3afZGUaxa311N3K6xsRdJKV5Lpi7s6PRxBZjuBVKAkrGzP3sACBobcc7D9vRLZF8pLK9U8z8k5p6ZGLj0ublVTuuebv3fhkVGfxfUmhspkjMTr/cV3x+IN55Ue81xiwZmt/peO/puTUcMbeVcqZo8kC28UUan4Uz6lwcRLnJGWYnk0M7EJqelxJKlSIjGafx7aLf8
 UdBasNsIoPsBDxz4u0Iitm3boftlZRaV5eIOibH3LBgQ2XwIEMtIgfHdSeLaj+PaG7Qp4y0XibYmseXzulbTJkVQVEayr+evC5IUyiYu7vmhM3XuxTHdDT52XHG7JCA4u10WJFNWlpjOU20SQyScTUMBXS3gft7qOJImc7BzTONBnGVv44tf5PJVknK+rO0aaj806/uM1//oVmG+2XAbcF/ChA2MKFRgqGX9QaDqKbZLBuFisZKIzezv/URo6HmlqumzLQSRI3XVY6eCpEL0l8ZJb5h+a48UYKgLyYr2xW8+aHL5LX3alIVi/gU9/9R999T826
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id y4-20020a056000108400b0033ae593e830sm3894552wrw.23.2024.02.03.03.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 03:44:29 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 177825F7A9;
	Sat,  3 Feb 2024 11:44:29 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: qemu-devel@nongnu.org,  Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
  "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,  Philippe =?utf-8?Q?Math?=
 =?utf-8?Q?ieu-Daud=C3=A9?=
 <philmd@linaro.org>,  Michael Rolnik <mrolnik@gmail.com>,  =?utf-8?Q?Marc?=
 =?utf-8?Q?-Andr=C3=A9?=
 Lureau <marcandre.lureau@redhat.com>,  Laurent Vivier
 <lvivier@redhat.com>,  kvm@vger.kernel.org,  Yoshinori Sato
 <ysato@users.sourceforge.jp>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  Palmer Dabbelt <palmer@dabbelt.com>,  Liu
 Zhiwei <zhiwei_liu@linux.alibaba.com>,  Laurent Vivier
 <laurent@vivier.eu>,  Yanan Wang <wangyanan55@huawei.com>,
  qemu-ppc@nongnu.org,  Weiwei Li <liwei1518@gmail.com>,
  qemu-s390x@nongnu.org,  =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
  Peter Maydell
 <peter.maydell@linaro.org>,  Alexandre Iooss <erdnaxe@crans.org>,  John
 Snow <jsnow@redhat.com>,  Mahmoud Mandour <ma.mandourr@gmail.com>,  Wainer
 dos Santos Moschetta <wainersm@redhat.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  Ilya Leoshkevich <iii@linux.ibm.com>,
  Alistair Francis <alistair.francis@wdc.com>,  David Woodhouse
 <dwmw2@infradead.org>,  Cleber Rosa <crosa@redhat.com>,  Beraldo Leal
 <bleal@redhat.com>,  Bin Meng <bin.meng@windriver.com>,  Nicholas Piggin
 <npiggin@gmail.com>,  Aurelien Jarno <aurelien@aurel32.net>,  Daniel
 Henrique Barboza <danielhb413@gmail.com>,  Daniel Henrique Barboza
 <dbarboza@ventanamicro.com>,  Thomas Huth <thuth@redhat.com>,  David
 Hildenbrand <david@redhat.com>,  qemu-riscv@nongnu.org,
  qemu-arm@nongnu.org,  Paolo Bonzini <pbonzini@redhat.com>,  Song Gao
 <gaosong@loongson.cn>,  Eduardo Habkost <eduardo@habkost.net>,  Brian Cain
 <bcain@quicinc.com>,  Paul Durrant <paul@xen.org>
Subject: Re: [PATCH v3 16/21] gdbstub: expose api to find registers
In-Reply-To: <1c9a2e94-0c54-446b-99a2-69e25e9725df@daynix.com> (Akihiko
	Odaki's message of "Sat, 3 Feb 2024 20:23:46 +0900")
References: <20240122145610.413836-1-alex.bennee@linaro.org>
	<20240122145610.413836-17-alex.bennee@linaro.org>
	<1c9a2e94-0c54-446b-99a2-69e25e9725df@daynix.com>
User-Agent: mu4e 1.11.27; emacs 29.1
Date: Sat, 03 Feb 2024 11:44:29 +0000
Message-ID: <875xz5pyaq.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Akihiko Odaki <akihiko.odaki@daynix.com> writes:

> On 2024/01/22 23:56, Alex Benn=C3=A9e wrote:
>> Expose an internal API to QEMU to return all the registers for a vCPU.
>> The list containing the details required to called gdb_read_register().
>> Based-on: <20231025093128.33116-15-akihiko.odaki@daynix.com>
>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>> Message-Id: <20240103173349.398526-38-alex.bennee@linaro.org>
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> ---
>> v3
>>    - rm unused api functions left over
>> ---
>>   include/exec/gdbstub.h | 28 ++++++++++++++++++++++++++++
>>   gdbstub/gdbstub.c      | 27 ++++++++++++++++++++++++++-
>>   2 files changed, 54 insertions(+), 1 deletion(-)
>> diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
>> index da9ddfe54c5..eb14b91139b 100644
>> --- a/include/exec/gdbstub.h
>> +++ b/include/exec/gdbstub.h
>> @@ -111,6 +111,34 @@ void gdb_feature_builder_end(const GDBFeatureBuilde=
r *builder);
>>    */
>>   const GDBFeature *gdb_find_static_feature(const char *xmlname);
>>   +/**
>> + * gdb_read_register() - Read a register associated with a CPU.
>> + * @cpu: The CPU associated with the register.
>> + * @buf: The buffer that the read register will be appended to.
>> + * @reg: The register's number returned by gdb_find_feature_register().
>> + *
>> + * Return: The number of read bytes.
>> + */
>> +int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
>> +
>> +/**
>> + * typedef GDBRegDesc - a register description from gdbstub
>> + */
>> +typedef struct {
>
> nit: Add struct name; docs/devel/style.rst says struct has a CamelCase
> name *and* corresponding typedef, though this rule is apparently not
> strictly enforced.

I think the wording is a little ambiguous here, especially with the
reference to typedefs.h where the anonymous structure typedefs are held.
In this case we don't need the structname because there is no internal
reference to itself.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

