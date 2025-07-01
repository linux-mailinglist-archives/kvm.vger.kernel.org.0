Return-Path: <kvm+bounces-51208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D604AEFFF4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 18:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 446077A5835
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE212279DD8;
	Tue,  1 Jul 2025 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wilIUNHC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA341F3B98
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751387699; cv=none; b=cFiOQvETBCASiF03asM3Y+pEOEMWjQ4Ihu2AS+2x4+aV1jqESn5iLzgazne8K0GHyycGJVyg/7w5ehRi1yQP5Mt5KEmm1HIOyjfgF9zmxpRI73HsCbOnmAhR4zZHQKuHadKeOtSm1W6AOPLJ0ko6z5E3vQl+DQhkH0LV2k4JVLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751387699; c=relaxed/simple;
	bh=VnczMvA6GYs3uiiGJsTHmMHkFMKf+NB92F52lqFyp4U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNN23ybm7kGZRsyopRuz6A0Xcb+m33YVX7X6KXv7Yd+qZuSVo65mbJvOcFYkAANdYxCwj+oIqfov1rcjcUJg0kdyaYxmuBbV1OjvtKtMJy9m19vAPCe0YgzNrIH7v1JHLQYhVcpMaoEyr7WmhAIMLe0pmqYfn3aH5KPBu5PqmfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wilIUNHC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-450ce3a2dd5so27331285e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 09:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751387695; x=1751992495; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2K10LNjVF7YPHB2xQYULfdat2hC8OE4Tb7cNChuI7E=;
        b=wilIUNHCzYZX3nhbJuwSawzsrNi6KbsVh2y+82nMrurWn/5VmX8M4nUBpJIhbaHtXy
         vGHrgbmLb6t6a8NGvbWHlX5qjPF7PO6iAl4aXF8TQpT0eNXDwvirzoBL7nPa1HOnbuIV
         tBaJI5pih4HgMlM/z9VUMSF8PgJ3oXWrzZiiFaYCPdFd7NaB3OkB2fgHRG45j4TEqTBK
         +9pPM+DBAr5PZ0zczbW/t9vsYu8PN8CPyA2IsH1vK04dZRwaIRBwtLWOhw982225GtMv
         BqeHgaG2Zt7sGFGa7797rCgex+Uh/IjqBeR56/6xY+xYV4l2Swy4YEZSLmVl63qsHtls
         /MVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751387695; x=1751992495;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2K10LNjVF7YPHB2xQYULfdat2hC8OE4Tb7cNChuI7E=;
        b=R/5ynS4YO1HhWQpQ2NLj9NO85uTqjKFN/TdmoXaWId+bnwYjfmNpfhQ4JZYvlgH2OK
         4WAvo+61483SnEvS3dQc1/lXdn9XIhWJYGkp0LO/+3L30Ev1AgGdRIONWzdc5rqr5okB
         gWHSqQgJO4bbuV9nOa3oTMGWBKfB+PNRx0VOZ4RnjFOwj6AbJ4ErdTtKx4omraRavey0
         8d7bTjIqib7hITL/yUZJtAnIdNd3pJwbi/jg6Vj7Ds+15tply8O3ofKmxJX6VaIGb6fu
         JywqcDZsbu2E6zkc5RTHDL7eL8Gs8mWu/wkMg61/A9BC2qWro3iJxd6sRbanGelg1f/h
         ioNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsuWYqLR4o+q0dVWRbYMNBeD8vJxQ8NIeWT4aN87YVJF6GS9HKGlbCR9KkAmriQhmSUxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YztMox78tAHN2q1C6myTC5Y0x8VcUI9XdqDFoN0cOaR6Db/XD3C
	SJWhWUrqwWGRLPZzzg0DOr0yp1XlYytOb4g3QPO/eqLirZ0DaUTMTF/UKAt56zCDVQw=
X-Gm-Gg: ASbGnctcezNgKVIYECcIFAV95pwIVmtbk2lSeX925jztNGuEal+pJy+UzFyWGrKYzh7
	/ggrrVjFscF5pawIhsNoAxcxBIb87GX1dEVE6TPzfkaQeoxeSwddt/KE/HcdD8PBluwXMVT89n0
	hBKFWMzMiH47IavH+DGxghqmXPjMTBkPQ05mGNGhrVWK8TbGI+Dz4xIKugpOe0gke0Jv55lnOUw
	KboXsiBDrqMkNbGzgTfRWlU8oPH4w2kUtbZDTMGF6m4MSSJUqUgTGaHoRu8YOqH4IWRPIiBGp2k
	QiGag7I9c3y0glrXIXw4sOdyuVBIgqNN3N5aJ4vKu7LvhDg6mXn6ktvXydOJ5HghY7RCjDEanxY
	IftOS12iqX8cwhxiRLIHAO5fTTZRfhA==
X-Google-Smtp-Source: AGHT+IELwnWyYcu4hvfdvvbC7DYEvVdua5rlUoWfFzyQB8GHFmkYY6GB86F+9a8HBtGke/AvoPoUtg==
X-Received: by 2002:a05:600c:1913:b0:453:8ab5:17f3 with SMTP id 5b1f17b1804b1-4538ee837e3mr172158175e9.22.1751387695285;
        Tue, 01 Jul 2025 09:34:55 -0700 (PDT)
Received: from [192.168.69.218] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538234b30dsm200624615e9.12.2025.07.01.09.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 09:34:54 -0700 (PDT)
Message-ID: <30fb9500-b38d-4143-a4d8-d72d30a18292@linaro.org>
Date: Tue, 1 Jul 2025 18:34:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/26] tests/functional: Add hvf_available() helper
To: Peter Maydell <peter.maydell@linaro.org>
Cc: qemu-devel@nongnu.org, Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Alexander Graf <agraf@csgraf.de>,
 Bernhard Beschow <shentey@gmail.com>, John Snow <jsnow@redhat.com>,
 Thomas Huth <thuth@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 kvm@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
 Cameron Esfahani <dirty@apple.com>, Cleber Rosa <crosa@redhat.com>,
 Radoslaw Biernacki <rad@semihalf.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
 <20250623121845.7214-26-philmd@linaro.org>
 <CAFEAcA9MLMJBFk+PQCJT8Bd+6R+vaho9_vXmDCjPU5cp6B7LfQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAFEAcA9MLMJBFk+PQCJT8Bd+6R+vaho9_vXmDCjPU5cp6B7LfQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/7/25 17:50, Peter Maydell wrote:
> On Mon, 23 Jun 2025 at 13:20, Philippe Mathieu-Daudé <philmd@linaro.org> wrote:
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Reviewed-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   python/qemu/utils/__init__.py          | 2 +-
>>   python/qemu/utils/accel.py             | 8 ++++++++
>>   tests/functional/qemu_test/testcase.py | 6 ++++--
>>   3 files changed, 13 insertions(+), 3 deletions(-)
> 
> This seems to trigger errors in the check-python-minreqs job:
> https://gitlab.com/pm215/qemu/-/jobs/10529051338
> 
> Log file "stdout" content for test "01-tests/flake8.sh" (FAIL):
> qemu/utils/__init__.py:26:1: F401 '.accel.hvf_available' imported but unused
> qemu/utils/accel.py:86:1: E302 expected 2 blank lines, found 1
> Log file "stderr" content for test "01-tests/flake8.sh" (FAIL):
> Log file "stdout" content for test "04-tests/isort.sh" (FAIL):
> ERROR: /builds/pm215/qemu/python/qemu/utils/__init__.py Imports are
> incorrectly sorted and/or formatted.
> 
> I'll see if I can fix this up locally. (The missing blank line
> is easy; I think probably hvf_available needs to be in the
> __all__ = () list in __init__.py like kvm_available and
> tcg_available. Not sure about the incorrectly-sorted warning.)

I neglected to rebuild the Python package, sorry...

Don't worry dropping this patch and the following.

