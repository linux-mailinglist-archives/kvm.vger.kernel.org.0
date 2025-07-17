Return-Path: <kvm+bounces-52718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E65B08823
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 10:45:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 022474E0E13
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 08:45:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E2C285418;
	Thu, 17 Jul 2025 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YTyTxjBj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0BF1C7009
	for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 08:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752741947; cv=none; b=NbiuWpoLaGjeVt1oTODXIujwlzwXFYVEoNOHE4g1/8d4txYs+K0q7lLDgaWKxJGSEnbyjfsSzdEysRN4WgighrNkLXCxqt8VSUgzJvfFmODSuOouckrcmUpSK0mFyYBt+zyu0Q+F/EKGJ00MZC5NFPmxEuTJhgFvVY34e0lDd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752741947; c=relaxed/simple;
	bh=8RbcorR2SaRlzZR+qVP56r4BPseQWMhBcmGaKURl6Xk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qrk+n3f+wM8JTKhuqGD4WcDm4HjGwKjmnfODvCAr2jt6jq0LkMdhhLA2RTJmRrpkxnujC3s/EjZaBjs9BK0IU8eom0mdf3/RwkNYxnO//NwqFi9kz7KIfsxZmmWw7c9MoQ3a9PK0UhMdd2Jue096uYTZROs7Mi2SEveQyfv9eGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YTyTxjBj; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a4f379662cso515519f8f.0
        for <kvm@vger.kernel.org>; Thu, 17 Jul 2025 01:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752741944; x=1753346744; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xZ4OUL/O6x+anLhegvg4iCGqGFbYPglXhLHI/aOL+AA=;
        b=YTyTxjBj7fJKkVqImkfcPGG/rCaku6H3j25EN4SD9NMdAo3GaZ8u3OVspLUiKmFw9a
         W68a74xjULZziRs4eq8WJIrzf9Mx97QKHS1rf4jCeenAbruezsGC/xOIXJlmToBW5RLk
         5rIxZDz0Gd0GyGaqdxH4iunrpVY9QUNe+K3wA1lDzjA8YxCJqYPMD/YgxSnlUv4IzDpl
         adn4D9tJy/MSo3PGMmTSFfpn9n2fDvfbeTmlHNtt5zz82KIWC/2/Aew/QyyQsvHg67wL
         W/iVKAWLoWWQ7mi+sP1+LmnUBYKgMKzdf16xd0dqHo5X8Wx4T+hfUrX4tqq5/ZHpbm3S
         XP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752741944; x=1753346744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xZ4OUL/O6x+anLhegvg4iCGqGFbYPglXhLHI/aOL+AA=;
        b=PeB+QSj+7Ves+Sym/nDpzB6DEBfKxfWMTX9md5FaUILU9LCOF4xXdxovAwJAbDekGT
         c6oHEXHUkq+TTeWJhjsQX95Zm+Miym16yOYJ4BpI3AxjU+w2k7OBnMvbfNk4dI5N5slC
         BF+4EbDPhgH4wCUCySjU6aW0h6vsrP1CYqJKZofflSqT/v8IfwRA+OLHQ95az+G/68I8
         tWwjLIIuMcIdyNuMNKh3qB8iTOUKpyKt2YyDIpEUkpd+Uwg4lh0nQciAjmGzUREuH7xb
         rziWHdcbc4e16Z/EtnzcakvFUvtvdG386A2WzV8WlgIw5TweyOmneQ4yxDDEn/NEahpr
         it9w==
X-Forwarded-Encrypted: i=1; AJvYcCUMKV1R3HQSqL+Fa5tWd5T0xkwsuqOekUIU1g4rgj7p+nDusxHe5OsgWxmJ+o1tQkp5j7g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0ul3aNwk3/lqWr3TPzYKMR9XQPZymavMMUv+67NPExxhJq9Xg
	qGa2ST5Wxr9dVMRhwCeGfOMIU7eZa4ze2hHJjvjjY5SgHgHZWq5DZ/RJ7x7xQTUebRI=
X-Gm-Gg: ASbGnctHxnnKXyO+I1p8R6v3iDkA/DILSeIdvIVdRo3fA+51f6CLGz9fMdJowEzLXZx
	yceENz5/usRMqQLTKgkF/AYWwHjRX7I8PagWUkeL5W3BKUJDiU12jXYW7vtxwFAlQ2CtLOps3fP
	KlUeZceAoRFktwbeUV3fTkZNtmdnAlUh0JmWsGmaCUgvtC/van6x1FA5IZy/V76lWQXu094i4+F
	1hUtfyHp0ZkNvuJkgovODG05xHesGXJ1j9phyYCAZt2VIEnRAenGqPbzRpcHLR6bHa+HX7Dw2nT
	PvatVxVJtBbBtckoOu3ZmZGOhzWLeBfPwkN5YMkuEq3o4hxGo2gfaG6nQ/OwiJF3n+7puAfMJ8v
	SF/g7KnlzJ4GsxcMgTB1SGrnCx26trKEqGy3kF5bhBL2wSFVFgHXcAdmy73ibzh4eaQ==
X-Google-Smtp-Source: AGHT+IHP1oE7whlj7bL7NxqdbKQL2B4A0lGKBZweLux3egDh4x4vy/Gg1bFMH369T+DyMv3qn9vMxg==
X-Received: by 2002:a05:6000:430b:b0:3a5:26fd:d450 with SMTP id ffacd0b85a97d-3b60e50ff9fmr4167896f8f.47.1752741944033;
        Thu, 17 Jul 2025 01:45:44 -0700 (PDT)
Received: from [192.168.69.239] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc9298sm20109523f8f.44.2025.07.17.01.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 01:45:43 -0700 (PDT)
Message-ID: <118bd5fd-a340-4a27-ac3f-fb9774a65746@linaro.org>
Date: Thu, 17 Jul 2025 10:45:41 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 28/69] qapi: Move definitions related to accelerators
 in their own file
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Yanan Wang <wangyanan55@huawei.com>, Eric Blake <eblake@redhat.com>,
 Michael Roth <michael.roth@amd.com>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-29-philmd@linaro.org>
 <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
 <877c08wnlt.fsf@pond.sub.org> <aHdvwYM7kXBU4cji@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <aHdvwYM7kXBU4cji@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16/7/25 11:24, Daniel P. Berrangé wrote:
> On Wed, Jul 16, 2025 at 10:23:26AM +0200, Markus Armbruster wrote:
>> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
>>
>>> Hi Markus,
>>
>> I missed this one, sorry!
>>
>>> On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
>>>> Extract TCG and KVM definitions from machine.json to accelerator.json.
>>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
>>
>> [...]
>>
>>>> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
>>>> new file mode 100644
>>>> index 00000000000..00d25427059
>>>> --- /dev/null
>>>> +++ b/qapi/accelerator.json
>>>> @@ -0,0 +1,57 @@
>>>> +# -*- Mode: Python -*-
>>>> +# vim: filetype=python
>>>> +#
>>>> +# SPDX-License-Identifier: GPL-2.0-or-later
>>>> +
>>>> +##
>>>> +# = Accelerators
>>>> +##
>>>> +
>>>> +{ 'include': 'common.json' }
>>>
>>> common.json defines @HumanReadableText, ...
>>>
>>> [...]
>>>
>>>> +##
>>>> +# @x-query-jit:
>>>> +#
>>>> +# Query TCG compiler statistics
>>>> +#
>>>> +# Features:
>>>> +#
>>>> +# @unstable: This command is meant for debugging.
>>>> +#
>>>> +# Returns: TCG compiler statistics
>>>> +#
>>>> +# Since: 6.2
>>>> +##
>>>> +{ 'command': 'x-query-jit',
>>>> +  'returns': 'HumanReadableText',
>>>> +  'if': 'CONFIG_TCG',
>>>
>>> ... which is *optionally* used here, triggering when
>>> TCG is not built in:
>>>
>>> qapi/qapi-commands-accelerator.c:85:13: error: ‘qmp_marshal_output_HumanReadableText’ defined but not used [-Werror=unused-function]
>>>     85 | static void qmp_marshal_output_HumanReadableText(HumanReadableText *ret_in,
>>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> cc1: all warnings being treated as errors
>>
>> This is a defect in the QAPI code generator.  More below.
>>
>>> We previously discussed that issue:
>>> https://mail.gnu.org/archive/html/qemu-devel/2021-06/msg02667.html
>>>
>>> where you said:
>>>
>>> "conditional commands returning an unconditional type is a bit
>>> of a code smell". Is it however a "non-smelly instances of this pattern"?
>>
>> The instance discussed there wasn't.
>>
>> You ran into it when you made TPM commands conditional on CONFIG_TPM
>> without also making the types they return conditional.

Indeed, I now remembered it:
https://lore.kernel.org/qemu-devel/87r1haasht.fsf@dusky.pond.sub.org/

>>  The proper
>> solution was to make the types conditional, too.  Avoided generating
>> dead code.  I told you "The user is responsible for making T's 'if' the
>> conjunction of the commands'."
>>
>> Some of the commands returning HumanReadableText are unconditional, so
>> said conjunction is also unconditional.  So how do we end up with unused
>> qmp_marshal_output_HumanReadableText()?
>>
>> A qmp_marshal_output_T() is only ever called by qmp_marshal_C() for a
>> command C that returns T.
>>
>> We've always generated it as a static function on demand, i.e. when we
>> generate a call.
> 
> ..snip..
> 
>> I need to ponder this to decide on a solution.
> 
> Functionally the redundat function is harmless, so the least effort
> option is to change the generated QAPI headers to look like
> 
>    #pragma GCC diagnostic push
>    #pragma GCC ignored "-Wunused-function"
> 
>    ... rest of QAPI header...
> 
>    #pragma GCC diagnostic pop

I agree, the same was suggested as comment in my previous patch
https://lore.kernel.org/qemu-devel/20210609184955.1193081-2-philmd@redhat.com/

Markus, WDYT?

Regards,

Phil.

