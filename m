Return-Path: <kvm+bounces-52527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 871C2B06523
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C6C2D1797D5
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD478283FF2;
	Tue, 15 Jul 2025 17:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OZKoNd1Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12591F4701
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752600569; cv=none; b=k3ugqGKKUiXpNsopHR4cFiyEkiV/+yRsy6cSwYoxFRfCFlE4/6CRkQPAvg9kOb9QC/CKRVnuk8qaqXUCtfUpbEwG/CrSKnqy7PZ3VLU/ARbbN+shlQkgAXetpj5l6kTHW0sxSCCYpVLAe+r+jIrTNfl8pyxrVfzPydEX2U8lreA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752600569; c=relaxed/simple;
	bh=bgZLIuUBUSHsGtkAaOrQiDJBJMPGmvZLJOqI7kSAk3Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RZQQxlcN9FQ+LkJjZ3EYNzQ70q45q4A7bllWyPjRY58sKnkx0rV3fUtm0UPL8WWen+R8tAsoX7MlF9fPqTdBJ6hVolfUAFIv9z9dwQMPvjIEs8LxjOc2hHLRov+mM1BrUh+0/XO2VkEzMK0EaLP6Hzmfa+qekZIX2ags/Wt7Mxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OZKoNd1Y; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-455fdfb5d04so19894255e9.2
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 10:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752600565; x=1753205365; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p77qLlmQm6mw1/vACqNGs3V36Q2nIwbu1jpy4ppWkNU=;
        b=OZKoNd1YBInrFT/6siqo+/oV5Q2xGgwFDf1Nd5acs8GoEigCxt+Bt8kn+NC0CY4yB+
         mELX4dg5o99lOsCJ3/oWSbfpDFTdQToZtLUqgG01SIk+jBSYprKf/wfWVEy3YteMSiGn
         hp6KOS85YfVYKBbE/aCsS5uMK4BeZr8Y+lFtZ7rMuLNkO9+r0tDnpkz2OiXEU2w9ojsi
         Cf+ahb+R+HJm41z7CU1g9HArX4/FMP7GccF6TYCXYr+UxQeatbL2EAHTRhMOF/h1JOOh
         F/fVpZm+HvJzF105TsF+tKYNkgMCswAwp2GTjiC2OGxd6Rp/UXQj+FgiVEmLJbI1Y86F
         KMVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752600565; x=1753205365;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p77qLlmQm6mw1/vACqNGs3V36Q2nIwbu1jpy4ppWkNU=;
        b=XfwRbv9D/LdC6RdwSbq/ipkrDjADRIgc8NU/V5uHR+qVsbkQ99yaUGTtFUWgY4hjfG
         Geqb82g9yYVpuluoz0mli7q+N0F9gR+VbKRbyXi3TwVD0NguyTdSlYaFgfSdQiEqXtCL
         pzwmaH2hfCpzWf4o7wDiPkbupP1/tI0v9oroG0zQvlanFaehuCKmSeZtQ3VZ5JIqn0Sl
         7U/rsNscpbTHg3rni1NJk2SlBwCl+M987J/wmRE5mo2AbiZxMmFH4OcBqr1oUm86NBC6
         KIeZIUwHWbHa5TkR3Fi9I1ON47g9Fz3y/4bRhmXMDDJagDMJe7QKYPMKn8DXO2sD7Egk
         mzDA==
X-Forwarded-Encrypted: i=1; AJvYcCURZlYJRMNQEFnmC4QZfiURBGujtDZRcc+7CW7O2IJN454UeMQM1RPQ7cIhpxVNsIpa6T8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSa5/GX3JONlDeeCmEFmnRVIwSZckkpUCLrwd0EI4oN3AyYHdK
	ea7DOX5EUeZQIV0vwL/pN+iuROjXeRRoieGKc9vOrwRxifj0yz5j8OWhmb80xRnm1gA=
X-Gm-Gg: ASbGncuAcAwFQs52HmnCnmB5k0LnxpluT/sgsejo/FG1ymgdTP3xB8L/yhbxKAvybUI
	luwWAI1yn4o5Mrmbqefe/spb8c91bCWFXkNMfhyhHszKmjie7csvXD/gOXT8anhOvW0IeOwNkIB
	iOle86Cnv0NBN/6oNym3VhUxXk1koRLU895iMTYB8SBfzeJ/tFqfZaPhqP9EfiR+VKZKtUEz9J9
	ECYg6s3tn49dUFhIhSpyn2fhZiIbF3idSq5V2IbACaZgpCJQQ6Q/R6OYxTvenToNS4T+xH2AOGh
	hSIvllxmk/MD5o2TBneznNaEEOXdY9i+EIqfqnwjBXObTjPBgM7JP4IQLM21dp0EtWHwk745hm2
	iwYMvSAwAPIvVxRH2v1C+HZU1u7+/BBfzl+hRkCn+5j4qLoFiKz56izRBQ7aWbL/yWA==
X-Google-Smtp-Source: AGHT+IEetbCw3v3Wg7oRMJ4/uLwnGdMXt+12vLUongo9duAKsyNOh2w2TBpxLD2SByXbpUz8ryFiNw==
X-Received: by 2002:a05:600c:1c10:b0:450:6b55:cf91 with SMTP id 5b1f17b1804b1-45623234fdemr62288915e9.6.1752600565129;
        Tue, 15 Jul 2025 10:29:25 -0700 (PDT)
Received: from [192.168.69.239] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562797b8d2sm24769385e9.8.2025.07.15.10.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 10:29:24 -0700 (PDT)
Message-ID: <6b4ed606-c0d2-4dfe-8795-a2af6bc500b6@linaro.org>
Date: Tue, 15 Jul 2025 19:29:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/69] qapi: Move definitions related to accelerators
 in their own file
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org, Markus Armbruster <armbru@redhat.com>
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, Eric Blake <eblake@redhat.com>,
 Michael Roth <michael.roth@amd.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-29-philmd@linaro.org>
 <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
Content-Language: en-US
In-Reply-To: <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 18:42, Philippe Mathieu-Daudé wrote:
> Hi Markus,
> 
> On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
>> Extract TCG and KVM definitions from machine.json to accelerator.json.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>> ---
>>   MAINTAINERS                |  1 +
>>   qapi/accelerator.json      | 57 ++++++++++++++++++++++++++++++++++++++
>>   qapi/machine.json          | 47 -------------------------------
>>   qapi/qapi-schema.json      |  1 +
>>   accel/tcg/monitor.c        |  2 +-
>>   hw/core/machine-hmp-cmds.c |  1 +
>>   hw/core/machine-qmp-cmds.c |  1 +
>>   qapi/meson.build           |  1 +
>>   8 files changed, 63 insertions(+), 48 deletions(-)
>>   create mode 100644 qapi/accelerator.json
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b1cbfe115bc..c3ce0d37779 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -507,6 +507,7 @@ F: accel/Makefile.objs
>>   F: accel/stubs/Makefile.objs
>>   F: cpu-common.c
>>   F: cpu-target.c
>> +F: qapi/accelerator.json
>>   F: system/cpus.c
>>   Apple Silicon HVF CPUs
>> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
>> new file mode 100644
>> index 00000000000..00d25427059
>> --- /dev/null
>> +++ b/qapi/accelerator.json
>> @@ -0,0 +1,57 @@
>> +# -*- Mode: Python -*-
>> +# vim: filetype=python
>> +#
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +##
>> +# = Accelerators
>> +##
>> +
>> +{ 'include': 'common.json' }
> 
> common.json defines @HumanReadableText, ...
> 
> [...]
> 
>> +##
>> +# @x-query-jit:
>> +#
>> +# Query TCG compiler statistics
>> +#
>> +# Features:
>> +#
>> +# @unstable: This command is meant for debugging.
>> +#
>> +# Returns: TCG compiler statistics
>> +#
>> +# Since: 6.2
>> +##
>> +{ 'command': 'x-query-jit',
>> +  'returns': 'HumanReadableText',
>> +  'if': 'CONFIG_TCG',
> 
> ... which is *optionally* used here, triggering when
> TCG is not built in:
> 
> qapi/qapi-commands-accelerator.c:85:13: error: 
> ‘qmp_marshal_output_HumanReadableText’ defined but not used [- 
> Werror=unused-function]
>     85 | static void 
> qmp_marshal_output_HumanReadableText(HumanReadableText *ret_in,
>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> 
> We previously discussed that issue:
> https://mail.gnu.org/archive/html/qemu-devel/2021-06/msg02667.html
> 
> where you said:
> 
> "conditional commands returning an unconditional type is a bit
> of a code smell". Is it however a "non-smelly instances of this pattern"?

For now I'm queuing this patch moving only KVM definitions,
not the conditional TCG one.

Regards,

Phil.

