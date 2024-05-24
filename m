Return-Path: <kvm+bounces-18142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D88F8CE927
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 19:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A067128236E
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 17:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD93B12FF99;
	Fri, 24 May 2024 17:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="cod7Bk1x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844CB12C460
	for <kvm@vger.kernel.org>; Fri, 24 May 2024 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716571073; cv=none; b=EhR3D73+EAvXBcMaOfO7jt5yTmUZbvnvYjX4Mh6OoGbqJfso5hDxXnK5KFKrkrtvJCwQHwVBAFWqtMAhxpqb17z7+3FyMx66FcdJ31jwrIlTppee8A6HnWMlgyDJa0cMzF66dsM9FirAqrT+hXVKShVPKI2I1eJOBnIIEafTf00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716571073; c=relaxed/simple;
	bh=aP0165QcLcHzLMJYEu7SmZ+MzBAnpItX430VOnNGL/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q/OzXAEXlrWS5fXr6fTAv7+0UsMdoHC9Hp8mddIzlHTdKvbIkajUxn5tFUtwwUYKwqc5XLqqekoFW+TKnskLqMnHqicvCsBYWGoqVwPST1Hg79NUQc1r7C9phyf9MNII6okk91ybBW3rUAq9pr0OMo3powurdw0zRq6kyPjjzwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=cod7Bk1x; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6a8691d724eso22477676d6.0
        for <kvm@vger.kernel.org>; Fri, 24 May 2024 10:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1716571070; x=1717175870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WUUxz5qySMlLMqK3AlZAbp/sidfKbTTTihQT5JLcleI=;
        b=cod7Bk1xKdT0eVdIvOj5xx3bHwDZRYc8cb/w1fjTJS4TnlFwwhB3zkvh1S5ymdD7ye
         cPbEGGfGvYg+P6IScIuFvrlQObUV/SRJvRH7nwPC0uHQ8gFk9DX8M6p+gctLDM08kJDi
         O4Q30rW53Zu9dWQoJMsrq+ZyStN/wXCIk/DZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716571070; x=1717175870;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUUxz5qySMlLMqK3AlZAbp/sidfKbTTTihQT5JLcleI=;
        b=pBjJnEw/duRjeecSwzSMpJbcpfJob2Mg6m33i37GbE9XcQEGoqkrNtn3tt7fuMP2EN
         irbMjmqemADmuB6sIZLjkShntXgEUtYEOYcLlrBXepHnkZ7jZ58ejbiGRlPjTWfUFyhk
         mIRvADOD40Wdd7X9zE7TuqR+4glau9iqxNyncysj3s2uSZ0bQzi2/YQN652yUxhrEVxJ
         XDpgufxTCQKPJfN3C5ipHCDi64vDahwgxvLbK/q28lIP20Y1gDsFzwUCSLr5d1EGbm0d
         z9Ms3U2/+cIVuC05tXRlj0tUaNCc1a+fxFT7Kq9yYHmaBusXhjUg3Mgc0YphHMUHB+Vh
         AV+g==
X-Forwarded-Encrypted: i=1; AJvYcCXXnF2xLtdzUCpB6SAXhRTbZT21ewWBJhSgly0NFNRHEGDzVLSH8UBYIBrkjiIxvGA4CXlXwGM7QXctigh03yjDAIVk
X-Gm-Message-State: AOJu0Yy1ajrRgScTtLki+heIuAUQOtmYtpft0/LNKfpEyXnBJAixt1XH
	ns9CwUlkTG+sRTh2ughb3GQslRWcaYcOjQEQTerHdsUXfB/jIcaupOb1giE2bm8=
X-Google-Smtp-Source: AGHT+IE0OlUSmCf+vA2Bi9uY3k9E09THPtvrJH1In6r2i3fDfePJETCBKA4x+i9M5nI7mHOelosTAg==
X-Received: by 2002:a05:6214:5503:b0:6ab:7ab6:a0e8 with SMTP id 6a1803df08f44-6abbbc7191emr27473686d6.25.1716571070230;
        Fri, 24 May 2024 10:17:50 -0700 (PDT)
Received: from [10.125.231.30] ([217.156.233.157])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ac16321a47sm8919966d6.130.2024.05.24.10.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 10:17:49 -0700 (PDT)
Message-ID: <a5411542-7d63-4169-9529-4a5ef7b69212@citrix.com>
Date: Fri, 24 May 2024 18:17:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
To: Alexandre Chartre <alexandre.chartre@oracle.com>, x86@kernel.org,
 kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
 pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
 konrad.wilk@oracle.com, peterz@infradead.org, seanjc@google.com,
 dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
 longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
References: <20240524070459.3674025-1-alexandre.chartre@oracle.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <20240524070459.3674025-1-alexandre.chartre@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/05/2024 8:04 am, Alexandre Chartre wrote:
> When BHI mitigation is enabled, if sysenter is invoked with the TF flag
> set then entry_SYSENTER_compat uses CLEAR_BRANCH_HISTORY and calls the
> clear_bhb_loop() before the TF flag is cleared. This causes the #DB
> handler (exc_debug_kernel) to issue a warning because single-step is
> used outside the entry_SYSENTER_compat function.
>
> To address this issue, entry_SYSENTER_compat() should use
> CLEAR_BRANCH_HISTORY after making sure flag the TF flag is cleared.
>
> The problem can be reproduced with the following sequence:
>
>  $ cat sysenter_step.c
>  int main()
>  { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }
>
>  $ gcc -o sysenter_step sysenter_step.c
>
>  $ ./sysenter_step
>  Segmentation fault (core dumped)
>
> The program is expected to crash, and the #DB handler will issue a warning.
>
> Kernel log:
>
>   WARNING: CPU: 27 PID: 7000 at arch/x86/kernel/traps.c:1009 exc_debug_kernel+0xd2/0x160
>   ...
>   RIP: 0010:exc_debug_kernel+0xd2/0x160
>   ...
>   Call Trace:
>   <#DB>
>    ? show_regs+0x68/0x80
>    ? __warn+0x8c/0x140
>    ? exc_debug_kernel+0xd2/0x160
>    ? report_bug+0x175/0x1a0
>    ? handle_bug+0x44/0x90
>    ? exc_invalid_op+0x1c/0x70
>    ? asm_exc_invalid_op+0x1f/0x30
>    ? exc_debug_kernel+0xd2/0x160
>    exc_debug+0x43/0x50
>    asm_exc_debug+0x1e/0x40
>   RIP: 0010:clear_bhb_loop+0x0/0xb0
>   ...
>   </#DB>
>   <TASK>
>    ? entry_SYSENTER_compat_after_hwframe+0x6e/0x8d
>   </TASK>
>
> Fixes: 7390db8aea0d ("x86/bhi: Add support for clearing branch history at syscall entry")
> Reported-by: Suman Maity <suman.m.maity@oracle.com>
> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>

Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>

