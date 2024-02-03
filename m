Return-Path: <kvm+bounces-7933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F27FC84855E
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 938F7B28249
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 11:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E665D901;
	Sat,  3 Feb 2024 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Zutj+3Rz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278BD5CDE4
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706961400; cv=none; b=iTcmTXqU6/8iUzmiKJu8+UQb3CJ3AnLjQjxZ3VcGfYsXPZrmO/0gPn8jw1x3VNXV1Wu4xihztb6cBij2c48hzGPXybgP+ZgijewleIuYGVYMlTVVzCx7ceXOhGaRp7o8kIlofGfGJhUhzxULfej2cFaX07wBGXZ+4sHrnbwj8cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706961400; c=relaxed/simple;
	bh=GcMr2yYQh+IWyjTwLCUDDU1iy7PoinClZpp0zwVEt6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sIrcA3e9Z/96Bk5tdvCt1muZH1sQ1PbckIEHUKGeMoh4lva+zjQqKE9iefR+Qi0ms5tsMkYIOe7LoAfS1tBKuLMWTvoYvYvrUeUhKuGPc0bpWCVAhU875enhcrpasZJktXnKy81425+34yRBXVUqlCQgX1hXZcC3RTnOPWZZqdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Zutj+3Rz; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1d91397bd22so23947245ad.0
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 03:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1706961398; x=1707566198; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bkQjBftO9m+++qBi2Wr4fsXvHgz/k5Iqw3XhapBO21g=;
        b=Zutj+3RzIu/SF8i+oKAtDy3BtxEe2JqI95t2osgHlMKs3XhfqmfjD1hNE289GCG2NT
         r+PSl52UeNezOyA9J3tmw3Sc2dHGEhYCuCh8zebEiS+vYT6k1Z994xWjwfDZNhPxKyx7
         OQiu+PM3QizhgwappRS91ccc/BIs6y9/cboFk1c5jLTidCFHLYaZc0VPHEYSMEk6GCHc
         4BonN3iWgQDEs3Vj6CJN1fCSOauZh0K5bSFQHK8y42HQMGAI9KMKgr2FL2haAgfqBp6t
         vR3lpRHNssomtCMdfEOj1fvZFjo8zgLi/kceJPLXdvGU4/sBG/7vnfVYSQTDaP/9wO0v
         4TBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706961398; x=1707566198;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bkQjBftO9m+++qBi2Wr4fsXvHgz/k5Iqw3XhapBO21g=;
        b=rNRs6affguYDaPyn7oxh818ydTGwdvQIedGdoHPXH7QsInavgsoN7UBLkwfJijokH3
         LDWLu7+XB6PKb+fk5wscaabZ5sGfgI0kjzy/fxUxo845EuSF/GetDu43fgXABeb3MT7w
         KUnih6Ilw4q4yeAME8b60hWQgdy5mljzOePdaVJWEISbPnqcnE2+k4Pu7T1MpghASGGd
         8ODutvvpxgyH70afMqN8dramEbjN4MhSb8CQN9cV7WtVnCDUuc+vZjWgitCeQmm07dZQ
         ACspXHpzHkkjdenOmOEV6JXGOtuVlKDjRQHf/h4JH7oxw0PHfsT7xxarXfXT08hxfKqP
         aDXA==
X-Gm-Message-State: AOJu0Yy4ZBVgeR4le1qdSOGlp70EuhREaC/AE3OhacwxIq0VWS3PEEdX
	9I1WEULPdfVeUkJB+5hu5Ib8Nbwr26bm9SLFjOnihsfNJZG2pb9X3iB/YZSpLYg=
X-Google-Smtp-Source: AGHT+IHB+AmjSBxtv5wYPSJMbqsO9run7tNYs9Khwxwkq68D/UBBem7OVeFSqNuKg8auq+cu2CpFdA==
X-Received: by 2002:a17:903:2114:b0:1d9:8ac8:d79d with SMTP id o20-20020a170903211400b001d98ac8d79dmr1339459ple.19.1706961398378;
        Sat, 03 Feb 2024 03:56:38 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU9w6jw97GTrrv2YrzHdBM9dTeWQ3vVHTI56/t5JZ3zc41gPoVX+1fgSED7vAQySu4hIf6KJcJO25caBrCb2bc4uPWYpDkKZo76S3gu0PCoBNWXYvcf98BFBkYi6CumHUVWOmuSXKQBJuyu8GXAeYRqC4R7lySSP32Ill/st0sOdtQQLfxXQ+68gn1ZXKUWDSNPRRbGgE+kBdbd+SvBUmooxD2s7W8TfRIz7W73Xgz3uCPZeY+xRalhm36fPJtLdk0ev8OOx5tdaCCjTMKgX0D9113dxr9Sse5+lGDTC0EQrWzfFOj/aLgU70mnENuxu5dBPZ0nAIOENnJV90PjrOdyk9cS3Sg2jSKxRTLeXVy6QSpZPe8/nJfZ5Iz0rYnfmRl1DskPHm3Ys16ui3CgVg5Yncrh49RujvCFamU7utyWnt0reuYzY434JFD1mbr5orJR1gsxeKo0YC+/M/DY7OxL6ah7jFiI3c9U1qozWLbF8hfhleWTwNxgWeWLlCJ6HmuT+E2PiG5JtSuqtBQmI8z3cOFBu0FUlu5i2uQ6yR5ogi9hmJeOcqIM/BQ8Atg1/G92t+WraYM9SFzyQwuMQHvETJo4j6J3MPtfkvtGYHcTiq9XKbjhiVw4KxwiP+H6x1EmbsZZgwd4EdF3kVhq1KbY8eWQwtmySGMTMc6RiuGTbH4EMMaaKK2zZziUWA86NWX9xYsmgrKZvi+biDgxXFU+e83WqQVPhTIVAwqAccqTpuZNYHmLTfEHCm6YEl3iiNWiq5j9x0NQOajkmvVx15TPuKI/ne3DS+aQiHa8nrxBmOYdbnfR7B5qcEVXNW9JeuvFh7IGm/St7fpXXXNHGUtC9bUTp94dnNbDU1Ciz1uSn0PWaw3aP9JR+cN24Ftcrr9HjQGVaZWwhPkMMBoDync9/+u63uxS5R9v9uQzbOqboWE+5cxQo0J6snNoVO9SZJroY9
 aXreSYG0y7+bBFPJOZHO8NvCI1L9LA+274wPonY7qpn7cBhFLyYV2lOYMZuIYlcBrG24h/I1JWwJ9zECGQMSXrVxWZ8Z4mz4kTnYoKeKpvqT/F/Pp9gGtSwyVn/ayVr8/h/erlkDjltIwjj4cAtYxxdyg8ZuGuemnE9XSbxp2UDxZtmFniE+8mJk0uXyfh37pcPvBS1bRE8NX+QuKgC6kvL2d2D5FmAPoeYI3Xmh85WWDp48Smp7rfOnGAC6TGDYOcfeSHysujFEycXMvJWulSAQOLLyOu9bS4JWC25fRguqK8NlKTJ4eWmL91uygH31Jhqouo
Received: from [157.82.200.138] ([157.82.200.138])
        by smtp.gmail.com with ESMTPSA id mo14-20020a1709030a8e00b001d965cf6a9bsm1216785plb.252.2024.02.03.03.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 03:56:38 -0800 (PST)
Message-ID: <4291ba65-8a25-4242-a7de-bc403749531c@daynix.com>
Date: Sat, 3 Feb 2024 20:56:28 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/21] gdbstub: expose api to find registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Rolnik <mrolnik@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Laurent Vivier
 <laurent@vivier.eu>, Yanan Wang <wangyanan55@huawei.com>,
 qemu-ppc@nongnu.org, Weiwei Li <liwei1518@gmail.com>, qemu-s390x@nongnu.org,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Peter Maydell <peter.maydell@linaro.org>, Alexandre Iooss
 <erdnaxe@crans.org>, John Snow <jsnow@redhat.com>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 David Woodhouse <dwmw2@infradead.org>, Cleber Rosa <crosa@redhat.com>,
 Beraldo Leal <bleal@redhat.com>, Bin Meng <bin.meng@windriver.com>,
 Nicholas Piggin <npiggin@gmail.com>, Aurelien Jarno <aurelien@aurel32.net>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Thomas Huth <thuth@redhat.com>, David Hildenbrand <david@redhat.com>,
 qemu-riscv@nongnu.org, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, Song Gao <gaosong@loongson.cn>,
 Eduardo Habkost <eduardo@habkost.net>, Brian Cain <bcain@quicinc.com>,
 Paul Durrant <paul@xen.org>
References: <20240122145610.413836-1-alex.bennee@linaro.org>
 <20240122145610.413836-17-alex.bennee@linaro.org>
 <1c9a2e94-0c54-446b-99a2-69e25e9725df@daynix.com>
 <875xz5pyaq.fsf@draig.linaro.org>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <875xz5pyaq.fsf@draig.linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/02/03 20:44, Alex Bennée wrote:
> Akihiko Odaki <akihiko.odaki@daynix.com> writes:
> 
>> On 2024/01/22 23:56, Alex Bennée wrote:
>>> Expose an internal API to QEMU to return all the registers for a vCPU.
>>> The list containing the details required to called gdb_read_register().
>>> Based-on: <20231025093128.33116-15-akihiko.odaki@daynix.com>
>>> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
>>> Message-Id: <20240103173349.398526-38-alex.bennee@linaro.org>
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>> v3
>>>     - rm unused api functions left over
>>> ---
>>>    include/exec/gdbstub.h | 28 ++++++++++++++++++++++++++++
>>>    gdbstub/gdbstub.c      | 27 ++++++++++++++++++++++++++-
>>>    2 files changed, 54 insertions(+), 1 deletion(-)
>>> diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
>>> index da9ddfe54c5..eb14b91139b 100644
>>> --- a/include/exec/gdbstub.h
>>> +++ b/include/exec/gdbstub.h
>>> @@ -111,6 +111,34 @@ void gdb_feature_builder_end(const GDBFeatureBuilder *builder);
>>>     */
>>>    const GDBFeature *gdb_find_static_feature(const char *xmlname);
>>>    +/**
>>> + * gdb_read_register() - Read a register associated with a CPU.
>>> + * @cpu: The CPU associated with the register.
>>> + * @buf: The buffer that the read register will be appended to.
>>> + * @reg: The register's number returned by gdb_find_feature_register().
>>> + *
>>> + * Return: The number of read bytes.
>>> + */
>>> +int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
>>> +
>>> +/**
>>> + * typedef GDBRegDesc - a register description from gdbstub
>>> + */
>>> +typedef struct {
>>
>> nit: Add struct name; docs/devel/style.rst says struct has a CamelCase
>> name *and* corresponding typedef, though this rule is apparently not
>> strictly enforced.
> 
> I think the wording is a little ambiguous here, especially with the
> reference to typedefs.h where the anonymous structure typedefs are held.
> In this case we don't need the structname because there is no internal
> reference to itself.
> 

The majority of structure typedefs have tag names though; grep "typedef 
struct".

That said, I'm fine even without a tag name. As I mentioned earlier, 
this convention in QEMU is not consistent, and I have no other reason to 
have a tag name.

