Return-Path: <kvm+bounces-60173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 367D9BE4CA3
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 13E994E1647
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DB8E3346AA;
	Thu, 16 Oct 2025 17:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YfS0NjNI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6AC33469B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634613; cv=none; b=L+C2I1VsLSJDyT7TGA8GJGQEyr6rFQcyor4o986wnWFeD7hxD3KOT3/NgoLDjlUJu3qg7r1db19ldqWROvQY48htmGuaV3ig/gYvCH+oAfXeiiNLlSJG9VRbIFofVlwsJnhg2Dg4MI82ag6zAMTP7deXg47nvgvYbUbSrqBVS2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634613; c=relaxed/simple;
	bh=odr/L5DbP43zVojwCvpugJ6j5qeMLHCemIDDK1cywqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZtZ2hZXsGNzfHb8qEA8lWHcx9CO+N1PO7qcBZydjKwW7rc7V5upOMc28OIr+uz431QZXuHZHADKij5EMz3ToeSusrXirSORicwf2T7eqRYyni1MS3VMJJUsF0HXJ1SDkS4xxinDRU5svW4DaecFhFPulngeTNMe0+PGcBOsADg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YfS0NjNI; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b632a6b9effso636379a12.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634611; x=1761239411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W+y9590Rju55IBWNEEnri44H8IFlGQsvQbodRDeKMnE=;
        b=YfS0NjNI8NBaqJS9IWkhznujKalEelN3b4ezXDP0dBccdIzpui28OI8Pkpuup2PfJj
         MvsxYoiJlR8rMbAnkq36xqt7S0DMgxY0B7j2Fofx1fMM4Tq1Yt+dWyXnKwaGcKa1m8hU
         vMShg0g/MyAlzH0xoI5gihCaxbYKYsqAkgbux6LpAyN3zgdfSWWOqmelylA1ctw+ul8D
         zzEuIRXvemXZuXB1W3lYtYzClaItiKY0UnObBMhmhsfIWUry5lknX+Eaj06pqdMs9ZH4
         URo6c9WG9X38/rnJrc00M5HwAEXPan4EQ9nB+tVPtFiW21Tf8lsM8jZAudbfviOeekDG
         fHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634611; x=1761239411;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+y9590Rju55IBWNEEnri44H8IFlGQsvQbodRDeKMnE=;
        b=r7ulYvfGktIzfendwx+GkpH3ynGxu/VmM1F4XdEYxd/vSmND0TUEs6Etz2eU3knvAW
         G66n8gHgG2fN8vs2Ws60+7nZnizL0L24heJVlKTZXRyAV/xnGjAWB8O/P6kSbK9FEzMO
         uicq4PclutS3ocGOe1OMc2Js7xxQcZ0UFNOUn0SxtmE3EVnS8luBT6iWcH+LXiQBacJm
         E8PfS7wfEZ9mpxXLJSeWqENRQnr8fiUdq1r9tlsPSrFGl7i5/ZCUexinnHnd1NLrOxrC
         M9tTmeAfYOYtnPdrp9LDe4dADH4ultccWVbhUF/j4m+WrctepjfhGAPC5v8zwQMgeF50
         uA3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWE1vEFVA/2az3unfHFPYKhgJGHRrowu77I756pxkrY38ypCiIPu0PoBseKXbWwv5GhyTo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM9DCNNmO/Zua/0RD9MUabfXpp81ZOSnZ64K/E9P5vZSKnazo3
	9UKXqcuqqmdOryAFDhy3MzMPALEi1X49KHJuhgRJX+Xlqm2QAMi6HAvbiKYWOehBW5k=
X-Gm-Gg: ASbGnctMqgHNU64xW7WoTYzyvLlTnx/iSGfFpBQyOLUgDp7r32hh4nZZOFJZ3Z5DWBU
	Ob46C45FVwioGnOWhn2mSS8w7dKuMBNOKzW1EFxKSQiYqkTCsYvWmFRRihDllCkO5A2WUMlxnyH
	w4qGjKhG9rjA3zv9ZMnKMfpXuOqUV88uym4JW/LF3L4MUEhxwz9WEnvfiFwSeqgwF7VQVA9SKKp
	wIlvBrxI2Qioe3PbqKR6nyW1n3ay7PV+WResAvTHxJNx5XXXzHtdsHQBBxKdssMdieoqGCy3VQa
	dPM6ydhhGG2eV4ZfRierRB04KxBgUKIAfYCwbORkjfjKrqf1LG8UUZlVWNBgGbl7zza5kzmnC94
	psHEefMkD+AsHyh/2y8e7YiSVU9pB26mEa2+2UymCs4Wty+PWvi1iYY+131uzmS5SS1nTdz7cl2
	d0IVQCzPD1kpvTLegJV0whoVM=
X-Google-Smtp-Source: AGHT+IG7g9yccGCOr/5huwpVE+juN7DtgCivkbOxdSHJ6ZzNVUlh2v23F9GTlu369LKOQmKWdP6tJA==
X-Received: by 2002:a17:902:e944:b0:290:b14c:4f36 with SMTP id d9443c01a7336-290cba4edaemr7926005ad.31.1760634611255;
        Thu, 16 Oct 2025 10:10:11 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-290c5c7d305sm10174435ad.70.2025.10.16.10.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:10:10 -0700 (PDT)
Message-ID: <72f680c3-e2f4-4023-a6c2-b508e5af1c0c@linaro.org>
Date: Thu, 16 Oct 2025 10:10:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/24] tests: data: update AArch64 ACPI tables
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-6-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-6-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> After the previous commit introducing GICv3 + GICv2m configurations,
> update the AArch64 ACPI table for the its=off case.
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   tests/data/acpi/aarch64/virt/APIC.its_off   | Bin 164 -> 188 bytes
>   tests/qtest/bios-tables-test-allowed-diff.h |   1 -
>   2 files changed, 1 deletion(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


