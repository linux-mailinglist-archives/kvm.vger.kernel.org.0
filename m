Return-Path: <kvm+bounces-22942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6532944C4F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D0D41F24595
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 13:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20BB71B3F37;
	Thu,  1 Aug 2024 12:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v3/zJ6Dj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC541A2C26
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722517185; cv=none; b=e4G401VEL6sa8lF9kH5igACTC9FdW+VbEOsfDfyiLAMvMYIp4XbRoXoIymj88m46BQasFgRNWZjtC20nhAMlSHuJGMZ955/F5jOTn0tuB2xiQ26PsrFhFcS3mFBH3dX7U64fghTyHsUfaz9qb35AI2yWbQCswppoCsYY7vhREOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722517185; c=relaxed/simple;
	bh=lkZfUDsv6AzvQBoXmgsoLJig2jgjU9UyJoKSQnyVZIE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Aofg5VVHVu18X9mgz46m01u0SHSt+cMEoq+W2RQAi5Pi6Ss+8S0F3HVUdaCErQPEkibwdLJhnj/uAtdJExD3DkqAU6IGU8OEuOSjfsUTs1xucRzGvLxWL5YWbrXGojmROxUnDGO/dnTqQ/9jjLHehkW/8xaYZCFk6bkDiJ7Xta0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v3/zJ6Dj; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-368440b073bso1393545f8f.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 05:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722517182; x=1723121982; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=reWrZU/QJhlSWLyInbA0OjyEvus8Fj5OWJF3KGaYwP4=;
        b=v3/zJ6DjBtEYGUE70CuH+uyHILiK/Lgtr4VXPgAZ4LxUK7hbhfAIpHCDw8K1Xwdg13
         kU5A4/FUifBroI3c4ldOmoi+LXb/Tf57e02JWOZKJeN/g58ihckjjPLjJZwaAQ4NHvEN
         9A2fF8WqyxU2Xtf7LfCfQ6eVWuCK710kmP5XRU69yrZanvsnI6z0ycnxFXo8ACGNoSxV
         0nMi9Ns65bS04WtCEZz176mbBSy7Wq8JkLoZ7elZ0iDNbKNNHmHI9MzESAG0EX/eGj3x
         ZG+nhuAlk4+n43HgUyM06YU2nESEAYSrZE6WTp7JsSeHzKh4ahJvdK002LyzgHP/bfrb
         ne6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722517182; x=1723121982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=reWrZU/QJhlSWLyInbA0OjyEvus8Fj5OWJF3KGaYwP4=;
        b=hAtqazowE0hqZjt87lAWyLBum+/XnrDHfWDSzHlK0v1g823qcIk7We5/aqBLY7BgeA
         DkMJ/XrwSd4SO6Le8ZRjxDOqkDtkox8WH39LNPT7irNXccTc3GafbmdCH5vxmPYLjTgG
         No6GNQPAxA9yAXi6gy44aPGVvnzJq2XRhOwOF/0f9ZPKqyDn1sF/vvIEaBuvAWxWHNjE
         P9/jJV6T8b3fFzHqoLS4E2IovKC60CBETNUoeHClgn/aUCIFSHXpYQi5sTiBAgo9L5D4
         9gcBfKnwEy6C6/HM4yDjVdCDCURdlTHoa2a8BwmxUN+08YHnI6RAAG2jzZLDl/BQoA/2
         uukw==
X-Forwarded-Encrypted: i=1; AJvYcCUTXgZlQa7Yohip6G1CX4mpVZAuSxOf2bLu3ZbbwyoUt0/w/Zvm4OOYYMFsJKEEnRCzNGaKhO0IDlyGzn7CKBSpGv44
X-Gm-Message-State: AOJu0YzeyalrKcKKqQHcwKPSVbNurChdAwy3D7j06d37fmRA6QhaHd8W
	bXLwLMNBkfc+KhTViU667vxNipTrEwIpHk+3YqGYRyZs3gJUz1hQ3Fq80zcR5mY=
X-Google-Smtp-Source: AGHT+IEnKobr50cUvKpNW3LP+tEde2Lwq8dMN/vsZsHAj9TorGHmI2pf873uTdTxjhnLjEz93nmnWA==
X-Received: by 2002:a05:6000:1b0b:b0:367:940b:b662 with SMTP id ffacd0b85a97d-36bb35d6147mr1226150f8f.31.1722517181543;
        Thu, 01 Aug 2024 05:59:41 -0700 (PDT)
Received: from [192.168.69.100] ([176.176.130.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36b36857d66sm19329382f8f.83.2024.08.01.05.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 05:59:40 -0700 (PDT)
Message-ID: <68710de3-02da-4fa3-936c-62c85197893c@linaro.org>
Date: Thu, 1 Aug 2024 14:59:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/13] tests/avocado/tuxrun_baselines.py: use Avocado's
 zstd support
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Beraldo Leal <bleal@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>, qemu-arm@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Akihiko Odaki <akihiko.odaki@daynix.com>
References: <20240726134438.14720-1-crosa@redhat.com>
 <20240726134438.14720-11-crosa@redhat.com>
 <a7f2d78a-4de6-4bc6-9d54-ee646a9001fe@linaro.org>
 <CA+bd_6L7o05mENKVuLLfMFK9OF6ckU23ue0xmxiWO5oiT4ZEbw@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CA+bd_6L7o05mENKVuLLfMFK9OF6ckU23ue0xmxiWO5oiT4ZEbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/8/24 05:39, Cleber Rosa wrote:
> On Mon, Jul 29, 2024 at 10:39 AM Philippe Mathieu-Daudé
> <philmd@linaro.org> wrote:
>>
>> On 26/7/24 15:44, Cleber Rosa wrote:
>>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>>> ---
>>>    tests/avocado/tuxrun_baselines.py | 16 ++++++----------
>>>    1 file changed, 6 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/tests/avocado/tuxrun_baselines.py b/tests/avocado/tuxrun_baselines.py
>>> index 736e4aa289..bd02e88ed6 100644
>>> --- a/tests/avocado/tuxrun_baselines.py
>>> +++ b/tests/avocado/tuxrun_baselines.py
>>> @@ -17,6 +17,7 @@
>>>    from avocado_qemu import QemuSystemTest
>>>    from avocado_qemu import exec_command, exec_command_and_wait_for_pattern
>>>    from avocado_qemu import wait_for_console_pattern
>>> +from avocado.utils import archive
>>>    from avocado.utils import process
>>>    from avocado.utils.path import find_command
>>>
>>> @@ -40,17 +41,12 @@ def get_tag(self, tagname, default=None):
>>>
>>>            return default
>>>
>>> +    @skipUnless(archive._probe_zstd_cmd(),
>>
>> _probe_zstd_cmd() isn't public AFAICT, but more importantly
>> this doesn't work because this method has been added in v101.0.
>>
> 
> While it's not the best practice to use private functions, I just
> couldn't accept rewriting that for the skip condition.  I can make
> sure future  versions (including 103.1) make it public.
> 
> Also, these patches count on the bump to 103.0 indeed.

Then either mention it in the commit description to avoid wasting
time to developers cherry-picking / testing this single patch, or
move it after the version bump, avoiding bisectability issues.

Thanks,

Phil.

