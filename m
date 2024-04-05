Return-Path: <kvm+bounces-13743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7577489A224
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 18:09:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 146BB1F21705
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 16:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F52171647;
	Fri,  5 Apr 2024 16:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RF1P1tAq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C87171066
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712333285; cv=none; b=jv8jICBUVjctaVjbK0mGvPy2YVza4bfr83VGZ2Y4sT2Y8VNfN0jgtR3zpqYjN5LmgTbbcDqc4ODzvLbg8LFjH7dCX7MMVZeUU2rt7pup4B/vrZBIHOp+QiTJSABY4mLdcCWSViadEmvLhdfj9kbtPpCGT3q3yXOpVEeG5sC6UKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712333285; c=relaxed/simple;
	bh=WQf37KnE8UstSt4WJHEZVKafftMROgs9kzOlz+UeEzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iU9xSc2Ph05tCbrbBrj3eagAsCqlnmxlqWYp3UFa9kOzRQ1fEB0Ijr9XXxb9kRgzWiJJ5Ec/uW00B84CXyV8HgEKgTDybzvJicMj1TY3sMINFUWFNi5tWEefOfttLl4KRPXxegOim5zZ+sqkdUxzfeKcVwJL610sViAGn8Ay7/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RF1P1tAq; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so47671139f.1
        for <kvm@vger.kernel.org>; Fri, 05 Apr 2024 09:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1712333283; x=1712938083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAuKDU6QiZ6ML3XGubjP2fNWyg1GAOwTBQh+lV89r38=;
        b=RF1P1tAqP3quLAouu2FwQVEKMZfuTL/RhbhOTdyP7oTf3gFptlw/NVwiayTL9e2JgE
         Uk5xCIZssSK6EvgKVWsChs3tfpMRfspjYJqtKqKl4iHHLDiY5viu6FVIaiMcr4D9wkuF
         ON7QY9G+UxHZZWqbwZbrWIXqrpsywHPYczIOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712333283; x=1712938083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAuKDU6QiZ6ML3XGubjP2fNWyg1GAOwTBQh+lV89r38=;
        b=UuDeNyPU1Zs1m2dVZ7T935/Oixrt53x2Lf/p96+6DLplQW/h/HeI9BEdINb6PBzL7f
         yQ4hFwmYqzDx/1f6dAzkWLPTGRTHIeQQ1upc1WpHz/L/ciLHUList4NCojAgnq8pu90x
         tMTT3zEHFpDteiYpIiwtvdpNjW8Z5c9Vj1dLRZ+zQNrdMtKQ3sjqnBpOs0Qmo4z4BPid
         igeVckJRzq/x74ZbAUJTX96Jl74lcY31OwXSuT9OqqvHnWPXyMOVbn2oqFOfgmMkOXL4
         FLC2o+UZdKi9r7U3n1BWTk1DgnDQ2yDcb6X4vRuvxL7ecttKbwTCtYpPO5YxVGQapVHv
         X0wA==
X-Forwarded-Encrypted: i=1; AJvYcCW3Mz82M6XfO8hBTyaiuIIUM3reURqbdV+T3IiAw2Uk4djBE6QENezGcTtgB+ZZeJs1GV8jAxWbUR5sdRN/1qIGYyep
X-Gm-Message-State: AOJu0YxeejRlVICPxXGIKnt/DJd2Cn3ld0p64M8zPQO12AiVKJR+T9Ge
	XU1a5kjkuGDqyoISiJMgkenEO1AriXo+CJavjqYlrOrC8ayBWiBcTnfnVtTK+e8=
X-Google-Smtp-Source: AGHT+IEFSBlsclA6e2FP+b8IjmZLWOus+sNYfoqoIt8htlDfnprRT5+aCUKOtOxFEmmqkr93Xto/Bw==
X-Received: by 2002:a05:6602:148:b0:7d0:bd2b:43ba with SMTP id v8-20020a056602014800b007d0bd2b43bamr1795873iot.0.1712333282821;
        Fri, 05 Apr 2024 09:08:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id f4-20020a5edf04000000b007cc78dafb96sm578949ioq.7.2024.04.05.09.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 09:08:02 -0700 (PDT)
Message-ID: <60d96894-a146-4ebb-b6d0-e1988a048c64@linuxfoundation.org>
Date: Fri, 5 Apr 2024 10:08:00 -0600
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] Handle faults in KUnit tests
To: =?UTF-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
 Brendan Higgins <brendanhiggins@google.com>, David Gow
 <davidgow@google.com>, Rae Moar <rmoar@google.com>
Cc: Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Eric W . Biederman" <ebiederm@xmission.com>, "H . Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Marco Pagani <marpagan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Stephen Boyd <sboyd@kernel.org>,
 Thara Gopinath <tgopinath@microsoft.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Zahra Tarkhani <ztarkhani@microsoft.com>,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-um@lists.infradead.org,
 x86@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20240326095118.126696-1-mic@digikod.net>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240326095118.126696-1-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/26/24 03:51, Mickaël Salaün wrote:
> Hi,
> 
> This patch series teaches KUnit to handle kthread faults as errors, and
> it brings a few related fixes and improvements.
> 
> Shuah, everything should be OK now, could you please merge this series?

Please cc linux-kselftest and kunit mailing lists. You got the world cc'ed
except for the important ones. :)

thanks,
-- Shuah

