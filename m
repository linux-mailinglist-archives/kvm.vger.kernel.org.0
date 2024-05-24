Return-Path: <kvm+bounces-18125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 245B78CE668
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 15:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D386D281CE9
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 13:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79C912C55D;
	Fri, 24 May 2024 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HAs0q0N5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD512C53F;
	Fri, 24 May 2024 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716558792; cv=none; b=j1ZqqoNjQ4yffH3w8ClWoUDxqyW3DXt6MyKzj+mtq6OE6iBmstQslv6dQNuUqj3PaGHy7n5weVTDi0pTXUGZTQqiolfH/ngNGB47EFuvU6qBMyHmFqK2efbnDalRjR1/M6xgr7KEmykw8AdQLIPuj2vyyQtDi++Pj1/XGXFB0Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716558792; c=relaxed/simple;
	bh=48OxGlCWOzlUb31iNcUZkr3t9j9WApFJdpDC2NoybDI=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=d28wfECTT0WCS5hjjF/HG70uWug2Fe0raHp0wmit+lOrI6dM4z1ez9Gzhhr193DgL6Mi7In/dyoUWeuzJMbKMCfx3/2d04EQlHhdlk9AP6HWD7JWpJg5+5Ydu38Dyp+soMLt9bY1TnbYiTYQ+Bd+qlArlo2JeUaz2j9yEM3MJEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HAs0q0N5; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2e564cad1f1so100981551fa.0;
        Fri, 24 May 2024 06:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716558787; x=1717163587; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S569fFY4KqVx+EvriaPbjpFfvIMqzAUWJ6RqNzEZH0k=;
        b=HAs0q0N5bmdezJK0/KUSixK2S63iy3jRfUGoQqHGrU/1WQ6Ybb6Q7upSby8FAjETTJ
         8KEk2Ox63c/iP5a1t1Rdl3U7eg4YgyV8dn02btrLIfefTuJ2Hmmb4L81y5I/m/5I5EOf
         7dn1q1CkaJuVNmNaTR8oI9Sn4Noyy+vntZacKnpkONwIH4rrAnJEOz/h1tFB8ibJfNMl
         qRP0ZCw6jTQbLMx2T3Rg28Ua/ndIiwuzVCc7gKIynllrvW5YKjZ1Kd4QFiW0AVpl58DN
         MxDhTzTIl+mvPBqNG/FY7jZecVZ9DbyHrlsb/JV8h9NbvMteM3UHgT7Os+lQkuxksPFw
         4H8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716558787; x=1717163587;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S569fFY4KqVx+EvriaPbjpFfvIMqzAUWJ6RqNzEZH0k=;
        b=nBLBlg0kdPJFrqT/m6KizKn2xZxW4jEYlh2rU655e22/Qu2/OPQedFVV+nT8ZsdUuW
         ZjEiIb6jWDO4aa7fmlKRp9N3vMQ5CmnMZV82QzNC4sBW0Da81tm0xAg2wJ5v9ahFUXLP
         HFFjilxHV2h7g4Cmtk9M+i6wR9b5gHdyN8CiN72ZdJj+Hhe+awnEygX4vjTriB3YizlT
         2ZZDzC/XVo4R6HiPoRj3MtoUHpiDbtJn8ZOi6L+yTdkSnQVTJbF6qUsTZjggq9e1e2sV
         GjISidhMOruYzXJTvHtheVH/HmVgG9k5nu5RG4P2pFxQWn6L2DcAXwtMihq2imHok27X
         hHUg==
X-Forwarded-Encrypted: i=1; AJvYcCULqCRcE00g/Vy6aQGWtN14vZ+eo/3VZh4q4fZsEAV2E2KzsllutjOeZWJYHIQkb0BZybE1WQkM0GlWNnbw3fvSxB9hKpd1w3aV0Xr9JljWD4gtd3ScvC7v3rKCT9mYMtH4As0+Gc4E1BUlsElV5guPCtas82jQBHWlWx8M
X-Gm-Message-State: AOJu0YyBtd0jEM0dQIY/LkL9glGsFW+Jvvfjy+J4s4lK+2RZSlBON3gW
	sdYPUQJh69be0YHSrXbLEVd+Oc9ExmZtiLk5CjKFB4xyj++SOvUY
X-Google-Smtp-Source: AGHT+IGH/CmADwiQ9+iaEDrv+QH+ftV5NSAv+1nOxfTl5Jk7A54/oKiIi21wjyseui0jLKskLXVbxQ==
X-Received: by 2002:a2e:84d5:0:b0:2e9:5cd5:cdab with SMTP id 38308e7fff4ca-2e95cd5cfa1mr11813391fa.49.1716558787369;
        Fri, 24 May 2024 06:53:07 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100f5299dsm52751725e9.20.2024.05.24.06.53.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 06:53:07 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a7f58b0d-6145-4f56-8d53-8a90bee84fe9@xen.org>
Date: Fri, 24 May 2024 14:53:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 11/21] KVM: x86: Simplify and comment
 kvm_get_time_scale()
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira
 <bristot@redhat.com>, Valentin Schneider <vschneid@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, jalliste@amazon.co.uk, sveith@amazon.de,
 zide.chen@intel.com, Dongli Zhang <dongli.zhang@oracle.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>
References: <20240522001817.619072-1-dwmw2@infradead.org>
 <20240522001817.619072-12-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-12-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit 3ae13faac400 ("KVM: x86: pass kvm_get_time_scale arguments in hertz")
> made this function take 64-bit values in Hz rather than 32-bit kHz. Thus
> making it entrely pointless to shadow its arguments into local 64-bit
> variables. Just use scaled_hz and base_hz directly.
> 
> Also rename the 'tps32' variable to 'base32', having utterly failed to
> think of any reason why it might have been called that in the first place.
> This could probably have been eliminated too, but it helps to make the
> code clearer and *might* just help a naïve 32-bit compiler realise that it
> doesn't need to do full 64-bit shifts.
> 
> Having taken the time to reverse-engineer the function, add some comments
> explaining it.
> 
> No functional change intended.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/x86.c | 60 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 47 insertions(+), 13 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


