Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C829C1B04CC
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 10:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDTIuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 04:50:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725865AbgDTIuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 04:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587372599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2nctafG0roNHL3aalWgLNZ+cvN2uDJVeLDPJ2crTDE=;
        b=AdsGV8pw8czvc3ASpR2yEbvETR0kocA91iIiEnwo9tDPurfAjAO34bTEOl8iwQpcgRDk0s
        byEWc9dtR8aY3895qeJLBy0NhAdKMZ8X8HvN7nfxaaU5axz6lczSy5B76doLCX+o+fej1C
        hpmM7vvAJxl4/u0IgitBuFtGwWCPC8M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-Anju_kQxPTCCKw3TZ1YcZQ-1; Mon, 20 Apr 2020 04:49:55 -0400
X-MC-Unique: Anju_kQxPTCCKw3TZ1YcZQ-1
Received: by mail-wm1-f72.google.com with SMTP id o26so3279086wmh.1
        for <kvm@vger.kernel.org>; Mon, 20 Apr 2020 01:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l2nctafG0roNHL3aalWgLNZ+cvN2uDJVeLDPJ2crTDE=;
        b=mIW6ky9WJLAUYwu3HdAPnMydRDuzzTtUMl3fQXK5+ljb8eYYpUfzMjiCO3cyUN2+RX
         8yYe/n3wrZVNwFthnyXGFQxhB7NyCgyUL3yeAQFnM56tQ+wo95o+Bm84piQUstHNdbde
         Zcoe9MsuzHCPwRc/hEIhfVHEAGAe0rFWj4vqwc2BtYXEXXerxO8dFXkIUv4edU9chj7k
         cY2mwZdxohDDaf/HXyd57ChUdgUdj5nDxLuNcyCyVgbXNJMFq8Kf4t9lMmzxHKSbuYil
         WX8aV7FNcHOV2LT8tbXQI4gkF7vr7sa2/PkNVsXbnk3ejb/MMv6fE4QJnz/wOXBWzh59
         bqEg==
X-Gm-Message-State: AGi0PuZckCeNIcU5w9a1s+mopFWuQUs4x3bCKIFGZjGoaURL4kbYfakG
        diTDaTu9aFMYcWzM5+oqZi2x0bMaMDWiy6ebGonBQk3KcfVLGC3VePfBCSuRl2hijHZdnMhMmK2
        wCP2r/2krKbqQ
X-Received: by 2002:a1c:7715:: with SMTP id t21mr15692070wmi.182.1587372594456;
        Mon, 20 Apr 2020 01:49:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypJSZR71Dv0gJg7tIqGGj+fqHotFBvTdXiQ9tKzcVP0g6w5T4JQsk88hEvQGKfSKLT9N641kaA==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr15692057wmi.182.1587372594256;
        Mon, 20 Apr 2020 01:49:54 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v131sm483808wmb.19.2020.04.20.01.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 01:49:53 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 2/3] KVM: eVMCS: check if nesting is enabled
In-Reply-To: <20200417164413.71885-3-pbonzini@redhat.com>
References: <20200417164413.71885-1-pbonzini@redhat.com> <20200417164413.71885-3-pbonzini@redhat.com>
Date:   Mon, 20 Apr 2020 10:49:52 +0200
Message-ID: <877dyatubz.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> In the next patch nested_get_evmcs_version will be always set in kvm_x86_ops for
> VMX, even if nesting is disabled.  Therefore, check whether VMX (aka nesting)
> is available in the function, the caller will not do the check anymore.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/evmcs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
> index 73f3e07c1852..48dc77de9337 100644
> --- a/arch/x86/kvm/vmx/evmcs.c
> +++ b/arch/x86/kvm/vmx/evmcs.c
> @@ -4,6 +4,7 @@
>  #include <linux/smp.h>
>  
>  #include "../hyperv.h"
> +#include "../cpuid.h"
>  #include "evmcs.h"
>  #include "vmcs.h"
>  #include "vmx.h"
> @@ -333,7 +334,8 @@ uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu)
>          * maximum supported version. KVM supports versions from 1 to
>          * KVM_EVMCS_VERSION.
>          */
> -       if (vmx->nested.enlightened_vmcs_enabled)
> +       if (kvm_cpu_cap_get(X86_FEATURE_VMX) &&
> +	   vmx->nested.enlightened_vmcs_enabled)
>                 return (KVM_EVMCS_VERSION << 8) | 1;
>  
>         return 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

