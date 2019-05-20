Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD3F237B8
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfETM74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 08:59:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43565 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730458AbfETM74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 08:59:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id r4so14466520wro.10
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 05:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pkO4PC33MqiVXyJNRdC0g8/J88V1RdotEhUb7HdmXrk=;
        b=fEbhyzbPDwFpuxZUcmb2OTyiMJrAaDRW4Yakzzx/wRB8MwTXyDwZ92qULpxgBVIDp0
         d6hwVSzvjl357x1yEugrzG540a/vrzrkNF7STOqCIfq+zycn2qSV/uINLgsqngM7Yyyt
         yjQWRBtQM3o3FaBK8g0kfJDyLPo/7s4oc1vdGH4ytAhpGLGxvT2Sv6c0DgJcVhdhzvoJ
         PVlFvUqQ2VSGTwkoHM3CP66+5B7LULR7h+wePv773sjWhMx+ajUTVGSPDzbyYZt8431S
         IKNhvKbhmob6IyKCNZOIDYQJadQLWUFwrgsy9fp2LocR3Deaf/puF4AkGyhF+JoFYkXy
         q+NQ==
X-Gm-Message-State: APjAAAVCigXAiP3ek+8ITUsYRoEPl86Hlc3f/N38IyiZegegL8zIkxjb
        T5j1XebntoEY2i6b7EK+cO1cUw==
X-Google-Smtp-Source: APXvYqx5nismn0kDLWt2YpHHxnaA9nYk5Ow40f7u7NI9GV0L3vExEj8zGSyA+39NXUav1iOvK0tOrQ==
X-Received: by 2002:a5d:4089:: with SMTP id o9mr2703376wrp.6.1558357194916;
        Mon, 20 May 2019 05:59:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id y8sm13850354wmi.8.2019.05.20.05.59.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 05:59:54 -0700 (PDT)
Subject: Re: [PATCH] i386: Enable IA32_MISC_ENABLE MWAIT bit when exposing
 mwait/monitor
To:     Wanpeng Li <kernellwp@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1557813999-9175-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dcbf44c3-2fb9-02c0-79cc-c8a30373d35a@redhat.com>
Date:   Mon, 20 May 2019 14:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1557813999-9175-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/05/19 08:06, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The CPUID.01H:ECX[bit 3] ought to mirror the value of the MSR 
> IA32_MISC_ENABLE MWAIT bit and as userspace has control of them 
> both, it is userspace's job to configure both bits to match on 
> the initial setup.

Queued, thanks.

Paolo

> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  target/i386/cpu.c | 3 +++
>  target/i386/cpu.h | 1 +
>  2 files changed, 4 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 722c551..40b6108 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -4729,6 +4729,9 @@ static void x86_cpu_reset(CPUState *s)
>  
>      env->pat = 0x0007040600070406ULL;
>      env->msr_ia32_misc_enable = MSR_IA32_MISC_ENABLE_DEFAULT;
> +    if (enable_cpu_pm) {
> +        env->msr_ia32_misc_enable |= MSR_IA32_MISC_ENABLE_MWAIT;
> +    }
>  
>      memset(env->dr, 0, sizeof(env->dr));
>      env->dr[6] = DR6_FIXED_1;
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 0128910..b94c329 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -387,6 +387,7 @@ typedef enum X86Seg {
>  #define MSR_IA32_MISC_ENABLE            0x1a0
>  /* Indicates good rep/movs microcode on some processors: */
>  #define MSR_IA32_MISC_ENABLE_DEFAULT    1
> +#define MSR_IA32_MISC_ENABLE_MWAIT      (1ULL << 18)
>  
>  #define MSR_MTRRphysBase(reg)           (0x200 + 2 * (reg))
>  #define MSR_MTRRphysMask(reg)           (0x200 + 2 * (reg) + 1)
> 

