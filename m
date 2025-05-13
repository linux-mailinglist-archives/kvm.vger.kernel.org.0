Return-Path: <kvm+bounces-46327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDC3AB51B7
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773084A6446
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08634221282;
	Tue, 13 May 2025 10:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XzZnigDH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEB22690CC
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130882; cv=none; b=OHM9xqNm2XZ7gc6rIHRHfoMTGd+BfskNK8EdlQqhDjFGHXZOSV3VXQHaS/s/rPF/+k+f/67Nfd8UEn2oSylN+3wS4rIsXdEqt+LJBR0kmhfVAIjpvv4s/FW/V8yJvV7El3UilxNYLe2GNPLuM3l92qZBqxiIah0IvCn/0SoYI7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130882; c=relaxed/simple;
	bh=kqKafGbIZsYKk8Zhbxbx0TD1p6gu+vnuK9h1UF++ZhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHHcMCVeoR0Pk47MQGYDofOF8xZH6pFh8hZ3Zif0IWrHkqt1leLz+CAgnbEFKNCDSEA8FBKFeBNwlCGmBWUk4tUQzQB0quj1lFSHLCwSoxTFaZ32lOYjj4uJ62q0obV+JN4iw93Dqt29VYkAkaAKoP6xakUPz9Xl7eD+/kDtB6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XzZnigDH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cfba466b2so61548415e9.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130878; x=1747735678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=XzZnigDHYMnkauaQO09ZTjkdKf6NAMHNWMuTDdGLoS5OrQo26RWjPKSBA0ZX2XHh2O
         BOfToDj/Xd2e0OGffgUiqjptp35Hk/Ixx32rYoJx0yWugqqfcLQX3CD73mmkdU/PZ4At
         uFsPZj++sryrOShXj9ehr2JI6kT8yyTMZuXwYxwDrTU4hVkNLe4Jl/LWSeaJs7QmbqBw
         7DIf5+KcblcOqh3ebgyGYqNFWDlLzMo5dfkGoIPnoETBAx+Yk8PyEnCzfTNxHgx006A/
         zXgGFZYv0KyyKD2IEkiQJQIa+0ijj8C0R3aCKtXlqVy/U1OpF3uBZnyeFcCMqPwHVndS
         C8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130878; x=1747735678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q5InSWHz49sEJKfoQ2QNQ6ZQPGuqc5C2fmBxgyhIp60=;
        b=UvECg+dAdNbM+xWquJXZJXGlj7d3j3zZblGWlfoN8Lb16eHTpXbJ+gWfG97BrpJyJb
         0rcCqrBgXw/2ugWVmgPkOpcQOpzY+CwghoEfDvfMAORbpf9g3aFU9PnqHmIV+GcWC4ut
         bHi523wJ0m0021o5z7Kr0bEEq1N7QopVTkOevx2YJ0Lia/31jdQUPgczF8CTqdqBdON0
         Z/9rzKDwoq22Z+x5MOhAR1NffWUKrt214whYU+MwXu9PWlFTKcuacmxGlopoFkWasz0j
         S/vYFtE7IGgC/P04nwuu1xioQqqAsozWX9y6kKuqJXZ1wfYmlOixM4NKaCLAPRXcNQ7O
         Tjvg==
X-Gm-Message-State: AOJu0YzTRV9SJU/OITcNNJy4Eivc0Phm5yqsYq933qeNZyYtbABV1PqC
	ZSNbVzMKSvKBAo7Lv3Z2Ia8tz1B/GnxRBoIziuaD6jYGg1M2sM++khOJxShCPAg=
X-Gm-Gg: ASbGncurSzWRSmUPzP6xnbtQb/LIPX6uNgCoZcnBBFuBAa+09nQdo/OBcJckaxYUvB8
	Mrz6BEMHGgqZaYWRWiNGlUV8ET6t3If9tio9YsHnvTpr3YYWn/zeB+zs9CqYpfBlpeVkd6GbIlL
	eR0hizTp16TY4NGk7UPTjVIWAi517sy7inKOQ/DntRM2ngNIawRZCVge3ODH7tz5n66YFmkVQ97
	hWN6OLvKnBxN1VWdXl9QTH/+HiGgLdksJdaoJjIIja50Z5lsVk0YBsvMXYbeyGKydGdgLybeqI1
	Cp4bxEy1zQ/abtEDinp3ljND0UCBa1kGyq2gxf8knw8t6+zdpdsWMqyjRetg2RVnEoWi2UCOtez
	biyEwGKo7R+IZi0pYSUUDKSe7q7XL
X-Google-Smtp-Source: AGHT+IGVl3rC7KK+BwwSzbsyoT3gT98jHfPfE5lBvTNtcTCODedbnoCbc3sTwSrgs84c28D80Z+Seg==
X-Received: by 2002:a05:600c:608b:b0:43c:efed:732d with SMTP id 5b1f17b1804b1-442d6d6ab7cmr158700585e9.16.1747130877943;
        Tue, 13 May 2025 03:07:57 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442cd328455sm209323035e9.2.2025.05.13.03.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:07:57 -0700 (PDT)
Message-ID: <09194fbf-a2a3-4166-8f28-9a43f02b0df8@linaro.org>
Date: Tue, 13 May 2025 11:07:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 27/48] target/arm/arm-powerctl: compile file once
 (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-28-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-28-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


