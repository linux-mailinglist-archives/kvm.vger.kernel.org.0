Return-Path: <kvm+bounces-18129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A8068CE6A1
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 16:05:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 873F4B219A5
	for <lists+kvm@lfdr.de>; Fri, 24 May 2024 14:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410E512C483;
	Fri, 24 May 2024 14:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLwA1ko5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6E12BF38;
	Fri, 24 May 2024 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716559516; cv=none; b=cRulPINJRzXl62WvcoSgEmNsZyw4yfmGG64pIyw7h52wtwlnBw+yRqxxUPtHxNlG9qeKOyTa+WaQuKnvubNkbxqw44YL94vqLXN1vAAOqDW7GorohLFAqU9lsl/zCOKiCOcfDGUF538OOjssyecIOjC7X2bD8ofi1kvkRucZORI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716559516; c=relaxed/simple;
	bh=DCCBpwajUaHHrXRMmBxroBKg0DeNFPrf5Xbzu6XBIiY=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Xk4hYNTY00swDuo2uIAalVjCCu1+WEwLMgwsZ7RpRskT0AsSdjLlQu7ep7j/rv2O4SFrhMJNgJ4OOWj5IiaYJalZiA23Usjb/6fvfZinWV89v/SpbTpWKDxc/Js03kjKUKzPuiMWsj6yS12ycHraUpTNmUdeJQ2ie3rgmRARUwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLwA1ko5; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4210aa00c94so4226985e9.1;
        Fri, 24 May 2024 07:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716559513; x=1717164313; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=202i6Q3HfmZI4lv+uYm0BvyUdBZ8rn9ftqmt4YhUNng=;
        b=NLwA1ko5RUayGbcZ4NgzNwRA2HpwuD12+YXhs0NYxKlQswSPOq/aUwxih+aGQzM7NL
         O4JRydJlmm6bJPjKti1BUL1Eu1ZY7fgxQogmvPs+N69myXtF1ux/T9hWOV+9ao5sRk0f
         C9EHOiOj4K20DVrFfSAlwPMzwA+72n6q4B55R2UKgxCJXheGrTEmKqulM2J3vzL+WBYK
         sdF2EhOgzFQemlxfjlb2GuKxcQnz8t7R5y+mHL8t8a4LnsT54pyBgL8SXxyqUuxVVz0M
         QylMHRaerQ2XVgIspeeNOsUic5wqhS4sli+yXqiitrGp11Yr48RuEfPiBa5vuaUL+Z4H
         prYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716559513; x=1717164313;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=202i6Q3HfmZI4lv+uYm0BvyUdBZ8rn9ftqmt4YhUNng=;
        b=odfVQHnPlLDG+dMcnoJH16hpNgtTvonG2CEskBYoZxNJKXXif2ksmhcaSCz+hCSXam
         tho2lzmzUjf0C2EjtfOWLwLU9IzL6JfPre10MXB6KDvbRtsviWPM2GLBUrwtuUTx+roM
         gdo/+ZY4HhCoi8pMs95xa806VQgThgOKbmi8VKpySubwPnXYmlaB11HaWE5U3U8VJHX4
         YBCSzUfGZaZBIki9VqVxGeKJPZTIR4U+66vT73YJ9qs6cKHSGwS/lhYPe749fz41dmne
         2dle2M1kS+fkAC5/3O7oqRVfFEBM/yL3UzyHw/VObp99HzEVHEsxYT98NYRXUsKUF3yW
         IxUw==
X-Forwarded-Encrypted: i=1; AJvYcCXk6GzVxhEnFkIbRuMBzhvIM3a5cnKa77Q6mS3RNqzkGBoOzjIO0Qao917fKtN/V8AQAwaJgWmVRJMZM9TyHWTY3x2sx7EuuaTB+3+0wypwYD3+Fe8TkGD6/nwCTyDHy4eqURfesjwe6rXNk6D7/hAYiX3FIZ6jy4MXyyZ5
X-Gm-Message-State: AOJu0YwLNcMfyVK9wkAa96pZSVjbVaaTy8giZ4b5Cq1Hepy8XNynjMGO
	wj5YW0Pb52T2BEz2n8mg3jaJqf+TmMwtuiPc+mlmOsqTMenxoZMb
X-Google-Smtp-Source: AGHT+IHookBXCob4FhjQkQ0u0NJchDyk7V1pnwWjKmR8kw1/QDJd+XKHFWKc9Vg9F0+aXp5mgdhDFA==
X-Received: by 2002:a05:600c:3506:b0:418:4841:162a with SMTP id 5b1f17b1804b1-421089d85b4mr19597135e9.15.1716559513089;
        Fri, 24 May 2024 07:05:13 -0700 (PDT)
Received: from [192.168.0.200] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42100f598d7sm53564005e9.23.2024.05.24.07.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:05:12 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <03b1a60c-59a3-4a5a-ae3d-56819d1b8e66@xen.org>
Date: Fri, 24 May 2024 15:05:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [RFC PATCH v3 14/21] KVM: x86: Kill cur_tsc_{nsec,offset,write}
 fields
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
 <20240522001817.619072-15-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20240522001817.619072-15-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/05/2024 01:17, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> These pointlessly duplicate the last_tsc_{nsec,offset,write} values.
> 
> The only place they were used was where the TSC is stable and a new vCPU
> is being synchronized to the previous setting, in which case the 'last_'
> value is definitely identical.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 ---
>   arch/x86/kvm/x86.c              | 19 ++++++++-----------
>   2 files changed, 8 insertions(+), 14 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


