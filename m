Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AE9495E27
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 12:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380076AbiAULIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 06:08:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380063AbiAULIi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 06:08:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642763318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qma9gIxOUbhX/BVTtuu5JqQZ2WxKpLdnhLFIIGrBSvo=;
        b=H7yR3ema9MDx6r1JgpbDpCGKOJduFOxbW6t+Qq+LqdVkas8zbYaAiPrSXtKHZMfnrgI8Ub
        EfZhZ5RaOmXDGxraxxN92D9Emm5Mn6I/XpbNxXdGdlbWtxuF5XPVoky4vXth662HsbUsqf
        oatZWCPx3bx580iC+kmovEM8zfut+rY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-emtHVvnPMKidRLaAhQVLAw-1; Fri, 21 Jan 2022 06:08:37 -0500
X-MC-Unique: emtHVvnPMKidRLaAhQVLAw-1
Received: by mail-wm1-f70.google.com with SMTP id j18-20020a05600c1c1200b0034aeea95dacso9236669wms.8
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 03:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qma9gIxOUbhX/BVTtuu5JqQZ2WxKpLdnhLFIIGrBSvo=;
        b=465mmSzIuwwJ1KeDv12fGv2yB+QZhJpQcY+seip3xTQafW+hxzrIExPlE2aMZsYL7k
         xvWClM3/5UUk2QilncqcVv+HvGna0AFFjDBBuBgDrwbs9MwrqrkCfJ+y2LxX1t3mK04I
         NBJ11Ki3j+pdAVafiUbuk7sCiQcQl5booLFf1Ea7DChrsgkCPquRlctOOHA8JgNICGou
         KAvohBOQum+pFiRryRzGpGU/9xU62wN0hUbZCBtV0Kcr/y/qR+2KhlhQbHV381vVva5S
         kNfXMHmxjFNJpIMYcnYkCZmU5v/dhp5N1nnEkZeDZQtEtDSwRSc/0xenO4eSoOe5logH
         6PQw==
X-Gm-Message-State: AOAM532swAu22H7ERkgot/QTarPncoVAWqbj1Qqfe6Y1+18kdVN7Z6zj
        Ua6s8fVgYA6Li6JH5cTDl6hFppljvhhkFmiRrbaRRNzyF4hzMdVW16glviltlY3atTDEFsdOdc9
        +l95a6ObXIPBvsex+UF3x2lZB/UTWakIALrUtl6ynANf+MZf5SbxIZXNuGjwfkmAQ
X-Received: by 2002:a7b:c747:: with SMTP id w7mr286318wmk.54.1642763315871;
        Fri, 21 Jan 2022 03:08:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz9zPma8jvQKORaYLq5Caitk1EcCGl+RAFyyB9UYuJb0hY0i7y1NymByU0zqwRZpqLq83WMdg==
X-Received: by 2002:a7b:c747:: with SMTP id w7mr286291wmk.54.1642763315540;
        Fri, 21 Jan 2022 03:08:35 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g7sm5653030wmq.28.2022.01.21.03.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 03:08:35 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: skip host CPUID call for hypervisor leaves
In-Reply-To: <20220120175015.1747392-1-pbonzini@redhat.com>
References: <20220120175015.1747392-1-pbonzini@redhat.com>
Date:   Fri, 21 Jan 2022 12:08:34 +0100
Message-ID: <87r191jqh9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Hypervisor leaves are always synthesized by __do_cpuid_func.  Just return
> zeroes and do not ask the host, it would return a bogus value anyway if
> it were used.

Why always bogus? Nested virtualization is a thing, isn't it? :-) It
is, however, true that __do_cpuid_func() will throw the result away.

>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 3902c28fb6cb..fd949e89120a 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -692,9 +692,17 @@ static struct kvm_cpuid_entry2 *do_host_cpuid(struct kvm_cpuid_array *array,
>  
>  	entry = &array->entries[array->nent++];
>  
> +	memset(entry, 0, sizeof(*entry));
>  	entry->function = function;
>  	entry->index = index;
> -	entry->flags = 0;
> +	switch (function & 0xC0000000) {
> +	case 0x40000000:
> +		/* Hypervisor leaves are always synthesized by __do_cpuid_func.  */
> +		return entry;

FWIW, 0x40000XXX leaves are not the only ones where we don't use
do_host_cpuid() result at all, e.g. I can see that we also return
constant values for 0x3, 0x5, 0x6, 0xC0000002 - 0xC0000004. 

Out of pure curiosity, what's the motivation for the patch? We seem to
only use __do_cpuid_func() to serve KVM_GET_SUPPORTED_CPUID/KVM_GET_EMULATED_CPUID,
not for kvm_emulate_cpuid() so these few CPUID calls we save here should
not give us any performace gain..

> +
> +	default:
> +		break;
> +	}
>  
>  	cpuid_count(entry->function, entry->index,
>  		    &entry->eax, &entry->ebx, &entry->ecx, &entry->edx);

The patch seems to be correct, so

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

