Return-Path: <kvm+bounces-51502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4ACAF7E18
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 18:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7593584F29
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 16:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E8B259C94;
	Thu,  3 Jul 2025 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cPhYRBec"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D2325A340
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 16:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751560932; cv=none; b=MeG84KULwpYjf4KDYr1JYtcziICSU3rh3vkWQwCM/fUB4ZKbyUUnLP9OR4zCsD+2HAz3qUNuSPekrRcBSOs90mUq1jeuugF0Mp0Y5LfF5YpfxwlxeAjXdWjdmOuYQdBgD5zNKHp5t5VkvhzXuOHD78twlHGkP+tuOteY+Xaf3eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751560932; c=relaxed/simple;
	bh=D2J/BCscecf0Z8cqmO2GZhIThRFmXhmPVe2tkaoJ9QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l9pjqDgEmdSf2McjxrKsY7kHYWz4VrTABbyYUop9OBVb90RTbPdjZXHN12fNZ3g4pQ9Q3gq7tpSFwdcXc0uiJXgWS7E+3xzT0PQli8YSkWx1ojZ65DVMSNALMT3X81vsTxYse4mr4xEp0r6s4KLgA0dEMIeecauYiKRtH72Q164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cPhYRBec; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a548a73ff2so15216f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 09:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751560929; x=1752165729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=89VdT6B6Uu37n7jCg16nfxI1G8F7uZUBb7nUaferbJ4=;
        b=cPhYRBec9abHlBlqlgGOFSh7xYKyTvVLbpsiXDlgYMCDuCBznqozhnvCWfC+BCk99s
         YPAPXlSz+SwOXENZsaCN1eT6l8hBtneN/Ew70wtrwJzDqI/klC+8n7KF2/PHxEyGDs2z
         VicdPyiENdD9FuPoZLhLW/9tq1Wh4uSiqD2Gv44/IEDXzA2K6PBBA9eXBx5GUpChmCQ4
         /gCSUUnhIl8XQNPrUBbllZu7md3Ml25glxzXef39lvGnVAhP7GI2RukA2GYONDZhBovu
         l1RQi48YqBa2OzlPF4KwKb7npUSNfDbEKHrl5BK7R5QyJkyMm9RlkxST0cVvmJ//t9ZG
         XsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751560929; x=1752165729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=89VdT6B6Uu37n7jCg16nfxI1G8F7uZUBb7nUaferbJ4=;
        b=iISZcZv15MBt+wo2hlTWNy2g2KUXwiOiNAYCPWnGJiwiRXGWmttDP06+33f2nTGlsN
         1SDrc85JDvo9Rv4umFDbk227A5pYkG5/S8ao1Vf7jqeLVowp6OC+A+pjadSbpCoEXfol
         CmS69e2tsp7ysApuBzymYAn8NPQbFpCgfdohI69ftBRIlmW1+d8LTqym4m/XrF2yfQiW
         CH66hvHpXeOoRM9uBiXeBd1c6zpxLL3C/FIZFO8h6FqEztJvlEEEQ6heVYzidJOYTnYz
         OuFSS0Oy0yVdhO52jX3lVpYiuu8DUmYkoz9qqbGDrJN7V03l+w6JS5DPhFNi+fBJxe4T
         ZITQ==
X-Forwarded-Encrypted: i=1; AJvYcCXneexIkzVMLGB1jdY5KsplyRZ1YlwLnZ6Kov48rvBepF8oTxBVAgP3u4MotAeVAlW1Qzo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQEE0NeeAV/qoki9QNqFKqpJdUiv4ByDQaxhDgWUOgjNsLV5u0
	W0WXYJd1FgpjAU9Ggn7W1kTlCbujNP+SrIib/f9oiGfS0bDz/OCB3AskQaPA+hRZBdU=
X-Gm-Gg: ASbGncu6XfU3Bp9vQC0baZptTaSFjf06vVZBdr6FCYghmC/LzWPD41rX6kN8+Ac0oMK
	0Rg3CV76OfZAVexqpe4AxoYYurzpxl0SZZMb5Y6EoBZCRMj6aqiweTSMIr2jL4oqF+6J+akY7Hd
	0MQsU0O0Q2Fr+sZqZ6zxkwmDkMIJRiUPrvh/k5/t+zrxVszyurbWFqCoJkk/orMVOWFLPcOtSLN
	IKQ5h9F5BhTuX+k8s0aG0Hkdpbh902ZlG+GLMUyVzLgyqEmjDRMXZ0i+9KNsPLgNmhiEnB3mCvh
	iTXh0zUnLHPnnHOowCmIsbTHnUhL5onYY44i/e93xO75G4HjSzXefM6Rhx4i3iYl/uTiTzlChX0
	OvTF79yJykUndnn7LhOrXiWCgfrkI0g==
X-Google-Smtp-Source: AGHT+IFlo21nZ+3+OnFGvk4QC6mGpvQXwaYFctOTQS0MBUrwjRweS7+YpfJBsCMfUFSoXbSSr2XgHQ==
X-Received: by 2002:a05:6000:490a:b0:3b1:8db7:d1fc with SMTP id ffacd0b85a97d-3b1fe5c07d4mr6498213f8f.21.1751560928626;
        Thu, 03 Jul 2025 09:42:08 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b4708d099esm235255f8f.21.2025.07.03.09.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 09:42:08 -0700 (PDT)
Message-ID: <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
Date: Thu, 3 Jul 2025 18:42:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/69] qapi: Move definitions related to accelerators
 in their own file
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
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-29-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Markus,

On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
> Extract TCG and KVM definitions from machine.json to accelerator.json.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   MAINTAINERS                |  1 +
>   qapi/accelerator.json      | 57 ++++++++++++++++++++++++++++++++++++++
>   qapi/machine.json          | 47 -------------------------------
>   qapi/qapi-schema.json      |  1 +
>   accel/tcg/monitor.c        |  2 +-
>   hw/core/machine-hmp-cmds.c |  1 +
>   hw/core/machine-qmp-cmds.c |  1 +
>   qapi/meson.build           |  1 +
>   8 files changed, 63 insertions(+), 48 deletions(-)
>   create mode 100644 qapi/accelerator.json
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b1cbfe115bc..c3ce0d37779 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -507,6 +507,7 @@ F: accel/Makefile.objs
>   F: accel/stubs/Makefile.objs
>   F: cpu-common.c
>   F: cpu-target.c
> +F: qapi/accelerator.json
>   F: system/cpus.c
>   
>   Apple Silicon HVF CPUs
> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
> new file mode 100644
> index 00000000000..00d25427059
> --- /dev/null
> +++ b/qapi/accelerator.json
> @@ -0,0 +1,57 @@
> +# -*- Mode: Python -*-
> +# vim: filetype=python
> +#
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +
> +##
> +# = Accelerators
> +##
> +
> +{ 'include': 'common.json' }

common.json defines @HumanReadableText, ...

[...]

> +##
> +# @x-query-jit:
> +#
> +# Query TCG compiler statistics
> +#
> +# Features:
> +#
> +# @unstable: This command is meant for debugging.
> +#
> +# Returns: TCG compiler statistics
> +#
> +# Since: 6.2
> +##
> +{ 'command': 'x-query-jit',
> +  'returns': 'HumanReadableText',
> +  'if': 'CONFIG_TCG',

... which is *optionally* used here, triggering when
TCG is not built in:

qapi/qapi-commands-accelerator.c:85:13: error: 
‘qmp_marshal_output_HumanReadableText’ defined but not used 
[-Werror=unused-function]
    85 | static void 
qmp_marshal_output_HumanReadableText(HumanReadableText *ret_in,
       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors

We previously discussed that issue:
https://mail.gnu.org/archive/html/qemu-devel/2021-06/msg02667.html

where you said:

"conditional commands returning an unconditional type is a bit
of a code smell". Is it however a "non-smelly instances of this pattern"?

Regards,

Phil.

