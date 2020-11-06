Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8ED2A92D6
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKFJfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:35:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41907 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgKFJfy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Nov 2020 04:35:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604655353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COh7322GhHnYTfoWCK648pPK1F4ogcTwn4taOORgpuE=;
        b=et0SjcajHDnLWQ5Ahrgq3OERkzsd39oadJrTn8X/+7OIXeEGLxJujWmhfT0L6jYX2g8fZi
        uWB3FolYu6lm61rOLjaEQnXiecov1nzoC1lLitUslhZy6TIpQVj/patGTIpkgcF10g1GU0
        Wsjp1QDxltA7hexvrqPIauO+HQTR8Qc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-00P6dVgWM4-VvR_4QpxmJg-1; Fri, 06 Nov 2020 04:35:51 -0500
X-MC-Unique: 00P6dVgWM4-VvR_4QpxmJg-1
Received: by mail-ed1-f69.google.com with SMTP id f20so300432edx.23
        for <kvm@vger.kernel.org>; Fri, 06 Nov 2020 01:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=COh7322GhHnYTfoWCK648pPK1F4ogcTwn4taOORgpuE=;
        b=szi4ieIbgZpgNcj4qkDcS1GdIRUy8IiH7zDdZBc/Wa1ZlxCgVxs4QHvByXIRMTMp8X
         XZn6OkhfMr3w5HHtcrEXm4tHoLfmmi8mto/YKGevHdcT/aaGfrjRZRsFQp65KtWvKJ8W
         0YPuvpl/RIenOtQRJFcJzzRq5oSVjBoi771WDJ7YC8aWp26RLWDyNNQiI/3Ve9QZsM5C
         I4wBMc4cpVQaLIvSf2sZDXnqJUyBedbwotIrFVEEWIuyZoO5CApg3RS340ZhPOILObuD
         722gG7w82HDZU0jqzNURwjKsAZFZdTfGwXL3q1c0MjK/TbhuUPG/EGb/mbdLKxl4m9dy
         sbAg==
X-Gm-Message-State: AOAM530A8XlHtFaEy3axjhYs5kMpqeDIsNzVJ93Rmw3G8X6evTVIyzyX
        is4yBPsWUjZKUQj7cvHH9HuWBV1aEBSLZCmwwRgIKwx2Qppv9aMFyh6pJHhjRvgEYN6obG1IqR8
        T3EuQbEH3Iw+4
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr1052202edq.151.1604655350420;
        Fri, 06 Nov 2020 01:35:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxCyBjacm4/sWb+AyM7ztQpZR/p9PyzAKj5KqdlXmlv9S87IqV7wnB9RlzqOueD7Gf0frb6xQ==
X-Received: by 2002:aa7:c40b:: with SMTP id j11mr1052185edq.151.1604655350213;
        Fri, 06 Nov 2020 01:35:50 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i13sm485679ejv.84.2020.11.06.01.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:35:49 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH] x86/kvm: remove unused macro HV_CLOCK_SIZE
In-Reply-To: <1604651963-10067-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1604651963-10067-1-git-send-email-alex.shi@linux.alibaba.com>
Date:   Fri, 06 Nov 2020 10:35:48 +0100
Message-ID: <87o8ka3k0b.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Shi <alex.shi@linux.alibaba.com> writes:

> This macro is useless, and could cause gcc warning:
> arch/x86/kernel/kvmclock.c:47:0: warning: macro "HV_CLOCK_SIZE" is not
> used [-Wunused-macros]
> Let's remove it.
>
> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com> 
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com> 
> Cc: Wanpeng Li <wanpengli@tencent.com> 
> Cc: Jim Mattson <jmattson@google.com> 
> Cc: Joerg Roedel <joro@8bytes.org> 
> Cc: Thomas Gleixner <tglx@linutronix.de> 
> Cc: Ingo Molnar <mingo@redhat.com> 
> Cc: Borislav Petkov <bp@alien8.de> 
> Cc: x86@kernel.org 
> Cc: "H. Peter Anvin" <hpa@zytor.com> 
> Cc: kvm@vger.kernel.org 
> Cc: linux-kernel@vger.kernel.org 
> ---
>  arch/x86/kernel/kvmclock.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 34b18f6eeb2c..aa593743acf6 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -44,7 +44,6 @@ static int __init parse_no_kvmclock_vsyscall(char *arg)
>  early_param("no-kvmclock-vsyscall", parse_no_kvmclock_vsyscall);
>  
>  /* Aligned to page sizes to match whats mapped via vsyscalls to userspace */
> -#define HV_CLOCK_SIZE	(sizeof(struct pvclock_vsyscall_time_info) * NR_CPUS)
>  #define HVC_BOOT_ARRAY_SIZE \
>  	(PAGE_SIZE / sizeof(struct pvclock_vsyscall_time_info))

Fixes: 95a3d4454bb1 ("x86/kvmclock: Switch kvmclock data to a PER_CPU variable")

where the last and the only user was removed.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

