Return-Path: <kvm+bounces-7931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E2A848550
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 12:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7590BB23292
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 11:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A24F56B6C;
	Sat,  3 Feb 2024 11:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="v1m+rxxA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE71CAA9
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 11:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706959438; cv=none; b=iNuhewYJG83C/dhwFhFGVC9iu/t5gAERgesflawVifX9u9D/I16ZBFxsmH1Z2JN1eUDApd4D+PAJBgm58b0unKOfnrgZw5Vlkbs9kUrtkwCdp6YHvhNpMAxoFvJvWITFGbXaP0Vxfgjv76f1ePVjqi9GZDvUr2Yhj2HyKHgtoPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706959438; c=relaxed/simple;
	bh=hD9/qlUVEJDTqu+6VtT0vFxodLaOBA8U3McoYrH0DUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o458FZWwX1VhtC9FIbA0rg3dBy/0rnUjaVcxUoaXid3gDHVuRREVxrgrUprPRptfsmvIdgzmxpoRza/Ndcdx1wg75vlsht653UCfn+zCKqDfuvilk0aLD/6jBTk+1oGQ4kVmcUtieJzxZOGzEmACjIGgOcWRtLOtIyhl4mg0TKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=v1m+rxxA; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d74045c463so24218945ad.3
        for <kvm@vger.kernel.org>; Sat, 03 Feb 2024 03:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1706959436; x=1707564236; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bSAtRqrGA4Qilfsh+L9FviEDBUsiw2624Ro/wIEyZrY=;
        b=v1m+rxxAU3PvzJD3+ARd1Fzv+im/aJ2QwSONe4UbOe156yKtu4FXV/IQtyp2+W5uRx
         2JDoI/hLlkjwCeCDy7qN/KPNsCpJOsnmPExF1vbjN7U9L55Tb9K96Ds3ax0uEer8YI+a
         VPane5mLjadPzIG6rey2jUn3Hu/HTTAyaI8iZCYeNe+AlgQkbVnfqpgDptSdEZFRPODG
         DDzSzzHWxVqZ7RK12GTzpxAreFJl8MCqsvJunLO0pPn+TeeovJWBQk2wrvQzyXiqaLvK
         A0dD/yZpwppOT1PYoYRPC5/6R16bj37hVjCVEbROhQ7NVnoifBbfJlxX2NmGgjbQjesM
         tn7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706959436; x=1707564236;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bSAtRqrGA4Qilfsh+L9FviEDBUsiw2624Ro/wIEyZrY=;
        b=Je9uS1HqAymLu3MA8LPrbpQhmyfo6d9S0TvB2EEPGsfAW4LPrmZqJLEHzzKv0RLREC
         9ODXjNWfsYdfb40p31lMmLjtsGN7pzHxah29NIFQ9W/ZKL5eu3HAIVO8Dw4rvQgPpy69
         F5g5Zk0utUSPkvFNywqq9/oP3jD48wxf+wNElkafJBFdzLaRfD53k8leg/ioqjsVtJL9
         8AEK6OgQPATC6RCu/+cBfRbG2wr2ZPk/dMJ1J0rxCTqwMO0nLPstAgcDERsbdO8neMQ6
         aQKNLH5wq7y6kZLpWJgaiDF05gIFjdap9CDLmLR0IBiGQL6gFdGccE8EvflJLAAeSS5G
         wq7A==
X-Gm-Message-State: AOJu0YzSaMgX3llSf5bNPSQNWEuWphTuE1MhnNF9AOLwYPZ/JEpohg2r
	xdWWWwb3creufUkYYiJCVNmfg9d69yYZ83vVPeCrB3+R5yZptZOsGmj/H/WURWA=
X-Google-Smtp-Source: AGHT+IHPaqap/JjgDEzVtaBWCtzuONuSGi44VB6rioaLH3Z6bjrWFq6xvyRFUPfLWxury4+JZw7MgQ==
X-Received: by 2002:a17:902:780b:b0:1d8:f394:da39 with SMTP id p11-20020a170902780b00b001d8f394da39mr4375822pll.65.1706959436157;
        Sat, 03 Feb 2024 03:23:56 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWIhe73GuX77EdQC21jhOMH1cCMjup0xs9XUgvz1QDsTzxwNqNeC/XIRhOf9K5GlOal62DOk+GXrrsjLBUo3QzsWA5hx6PvHCmMOGtGVfaibSCr+dkYmjD/2iZYJnbmyWr9A2ZuWdUYte5beZq9faKwqpkWoI5qyA7OgmxThmp/FZA0n0+Dqyp8Ex4LSeEHvzKqZQSzqt65SS6eN3qGWruwuJf24r2v/Ut+VXwMmQted5ZWQOc6+4TULF8gGR9Qamo1/FtpwCTs9p7sRovVRajDWSFo13Y1pWVteuLkhnccEFtrYeCzrMqp1n+AWdnhobXzDvXAqZJIj6DipcL8RLrx2DZeuOQjcFW9Z3cBx2PpLtlElkG1/hJw7JcGjj4F9fJCFXkVDg5byreRU++FMXXYsFATP1SsN7oDjcae3q4vx/5fw5AYSq7xSMMbZ6YX0TJRN5ROwlWxtvwtppkCGUWw4qlHJRaUxbCeZY9Jl6lLd2ahPSRoKxtQNAu889P9pXLVngVE+d7A9LpA3v4Nrs5zZcNFeFBUrK+cY4aVq3bevKcobon8M3GXDrM+NRUJokn/GoYnyUtvAEb7l+oOHlfuu0tVuvEIfPmyTVPZ2i9xmz6MUzR1cB4pvTZF4M1GOKigg1Tl2ueeacSKbFcwNll3d7a/xkEY3MUC9tM5QNL1Jt9sdG7rUa1BOpHJO0HUUavRQ1d51RtI7j8RAg/PlEmEYkeVUqiw+rWm6A1iypL1RzM+8ek/ZfzUpXkPV9lBHN3ttgTxkVGcNYjXW/Jb91DDYF55YaDZ7HUd4UCbwfMXNLxjGTtT5S0Xv/fD9VCsWhon7d1F489j00eV7fA2m8ACC6wCJfixmMEMndGogPhzxI/nBs1exxVLTAik9QqDSKVqlfyY4fR+3HsLMGZtqpvH3WwUhRYPJvrf+r6CRy45yB6A9zxhvHJ4hjhPfr+oj+0SJz
 QCPZi+ctqp1tXcFw4iL9vK2pBKIx7b9JCAgW0k4U0xnm7hKt1oXV2osBAVWRohKhI84gaCMy1S+A/jgfK3+AOSljo4jkKK6qbhO5khAntnenwGukz046w54fE29MTQFeyxJnvE4Q0OttlXReGZ8+t+GN249dt42XQtML7wEQ/pfvf6Djbxbsb0xniUgAJoMJh4SACHRM/bMrcthBIVR+rL+kSNC8PJY9/WztPYUkbyEa+2e8RUsUxuoZmf1ww8bWQYOhPtgsUur6T4l1T7eqS/WiMxTb8Q8et9XJ4I9x8kUo85ZYRtcpcTp2qTPCpWRQ==
Received: from [157.82.200.138] ([157.82.200.138])
        by smtp.gmail.com with ESMTPSA id g24-20020a1709029f9800b001d7207fa2a7sm3054236plq.152.2024.02.03.03.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 03:23:55 -0800 (PST)
Message-ID: <1c9a2e94-0c54-446b-99a2-69e25e9725df@daynix.com>
Date: Sat, 3 Feb 2024 20:23:46 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/21] gdbstub: expose api to find registers
Content-Language: en-US
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
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
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240122145610.413836-17-alex.bennee@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/01/22 23:56, Alex Bennée wrote:
> Expose an internal API to QEMU to return all the registers for a vCPU.
> The list containing the details required to called gdb_read_register().
> 
> Based-on: <20231025093128.33116-15-akihiko.odaki@daynix.com>
> Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> Message-Id: <20240103173349.398526-38-alex.bennee@linaro.org>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> 
> ---
> v3
>    - rm unused api functions left over
> ---
>   include/exec/gdbstub.h | 28 ++++++++++++++++++++++++++++
>   gdbstub/gdbstub.c      | 27 ++++++++++++++++++++++++++-
>   2 files changed, 54 insertions(+), 1 deletion(-)
> 
> diff --git a/include/exec/gdbstub.h b/include/exec/gdbstub.h
> index da9ddfe54c5..eb14b91139b 100644
> --- a/include/exec/gdbstub.h
> +++ b/include/exec/gdbstub.h
> @@ -111,6 +111,34 @@ void gdb_feature_builder_end(const GDBFeatureBuilder *builder);
>    */
>   const GDBFeature *gdb_find_static_feature(const char *xmlname);
>   
> +/**
> + * gdb_read_register() - Read a register associated with a CPU.
> + * @cpu: The CPU associated with the register.
> + * @buf: The buffer that the read register will be appended to.
> + * @reg: The register's number returned by gdb_find_feature_register().
> + *
> + * Return: The number of read bytes.
> + */
> +int gdb_read_register(CPUState *cpu, GByteArray *buf, int reg);
> +
> +/**
> + * typedef GDBRegDesc - a register description from gdbstub
> + */
> +typedef struct {

nit: Add struct name; docs/devel/style.rst says struct has a CamelCase 
name *and* corresponding typedef, though this rule is apparently not 
strictly enforced.

