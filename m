Return-Path: <kvm+bounces-60171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B1C3BE4C9D
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:08:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8080544921
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828F43346A8;
	Thu, 16 Oct 2025 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pavYhhJB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEF33469B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634524; cv=none; b=KyV/1EDrGvHw/dEz17xbREll4rAot5fm77YOcA9ic7cv7Umz84l9KWrwaPsoKb5XpGwrUGkTi5NzLaz4uYzMB7nbuvCAvSDGVjWqCjj6SpnQFWxcWEoJ1//mtfqc/y6DIunHWKnpkkO5vVFdZ4yoNLSXuktmAtz2ptI/jw7QPYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634524; c=relaxed/simple;
	bh=GiXr47St6boUtlb+21w+0kKeNIYuIFVdz2lY8xpuELg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PtrxPCtTljt/VCu5yroI0GBskgOuNqIssSHAb7MFtKQ+qBWvQNtmOacXc1wQLmSNwRPptiIx2Sh41f642cYfMBwepIRAryCv2KPOnD60bPN+AatI31DdRtP3o93bHzIthf2+Nj26vDiRTCi5pBfgbDTczkspbxwHbIVQiDRwaq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pavYhhJB; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-33bcf228ee4so161468a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634522; x=1761239322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uEb7VEbvyYjCc8j5dVK2DcmXJGpMPlFdSk8E1hsGY2s=;
        b=pavYhhJBk4OuRwNk+x3mHi2av8S0Bpb8SzJslMW/QzOjyuNdEhXw+Xnocf52FMWcuE
         S+vefY53k8ujS/wOEiH8Gkdx0hO+FLO2GeUCaqBxrByY9CF86lD9HCJS4aq+BgjAvbqH
         OQUTFEjGo856DMfT/6lhJ7XiVTrP8TBD7Ayzx0UphU8Jm1qqzSQaIF0gCNBlVAt1PbiT
         /gU/u6rAE4u4Q6NR0L5SrsQCciHZTZ2qQ8ZfbIq8x6eKi2QckfYu+NRg/94BSVnsLyM/
         qVeF08Rw5iq0pd0RuwMrJ4xCe+QY6NQ3/WOTU1Uo1r6EmqbdWFj1rpanWBw5W72LiNwj
         e/eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634522; x=1761239322;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uEb7VEbvyYjCc8j5dVK2DcmXJGpMPlFdSk8E1hsGY2s=;
        b=EQcZRyXngeDpETjgORMcBDciOFGTKGmahalqH2Q9QG9bP/Kpxea7OsmC98i8aptq+n
         SIhLaNTp+WFEBRQYKtgsbUUTN7We0hv/WShOUK74d6ErTDsxMu+qTQnQze5S4Ih8vvUb
         eJHQJl7vjYzoIg4k4u6wkEqJrOMLFAeJ01BhidEvejaLaH/9SeJmt2uThO/TrJ6aNunr
         X8JFH2FtuPFivsJ4kPFnGcNfEeHj1ZhTrcrUlgB/gDBD4GQo7gCxRpwK8lTX/KnkC6Bs
         /QhHTlUNVxx6itV/UGCKWKRi7c8dEG5Jgz6ceIWWeM0KyLdR3MWs5E1gZECp2p3y4ERY
         XwCA==
X-Forwarded-Encrypted: i=1; AJvYcCWEd3OAmrKq4OFreKJM/FpygFdIhO8E7jdUbpZ9m436HqBnqAqtq5x8mVn4f9g942wuWZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxM6jzB21hIFwS5xTDQmw/UGWM5k6WHWRFyC3+yEgX6ScTj4Id+
	q505ioNeIikwUwyWobX+uqrEqryDg+O4iw8bZ9EqjpF5mSnhGkdyFfGy1J5XWDCufJk=
X-Gm-Gg: ASbGncsoBFNhunjXP1MZzU+fyrdszjhwWl82BGJvHpWD6dABhJvr+riOp2lB15SE+Lb
	sFQWTalRLZyqq9/aLR9RN2oGbl64dodVriZt1Zctox9Pd/y8Kbgztl1UUC2NsJ4T6d40Y7NvlP6
	y9ReHML8hj7uZg2/73MXsQqtSqaYionAbf791OfacjncsI8d5VmqUa1Amj40yEKhXAEIf8RRoiA
	2RRZdNhNXwhB8KVmj/ItwSel+ix8KUfXgvE8+zC3Lx7zbzqi4MQ8V8/itxdxfDAXOEngb7gCvZK
	p4qkYRhIfuvDQhZR+9P3CRXoruK/tzbaQ1GKzrEaZQ4MYGsW71ZGk76sxBgjkcQZ8BieL0kBNc2
	TBhMCSpdGI6uycpVsZX2vvXi0lMpSxj+pSs3fD53E2YG+PLteNEeG5WW7P+aY8Mvk8EPf4XzXzG
	gG9WM4Z1psIWJS
X-Google-Smtp-Source: AGHT+IGvlt/Fftn9IU6QjMkh9CuyfliAiXLfcmx5y43Vo4TArp0VvHRZtq2j14CuUV2d8EZCmHthIQ==
X-Received: by 2002:a17:90a:e70f:b0:32f:98da:c397 with SMTP id 98e67ed59e1d1-33bcf8f735emr569066a91.24.1760634522240;
        Thu, 16 Oct 2025 10:08:42 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bb6522fc6sm2541227a91.2.2025.10.16.10.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:08:41 -0700 (PDT)
Message-ID: <eeca5101-ac66-496c-beec-e6b17853be44@linaro.org>
Date: Thu, 16 Oct 2025 10:08:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 03/24] qtest: hw/arm: virt: skip ACPI test for ITS off
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
 <20251016165520.62532-4-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-4-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:54 AM, Mohamed Mediouni wrote:
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   tests/qtest/bios-tables-test-allowed-diff.h | 1 +
>   1 file changed, 1 insertion(+)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


