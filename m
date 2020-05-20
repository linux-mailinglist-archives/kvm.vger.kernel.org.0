Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F0E1DB996
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgETQdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 12:33:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31460 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgETQdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 12:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589992425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bAZr9JpGFpcuu3XfWQIxwcbd9+r9VJYRanbh/qrJCdA=;
        b=PzmLpPEy9Ms7KFQ4McaMei57TrQcdmyLdDh7WL5pYwhCVRWBV+hBl3BGg1Wse2voaZcvc3
        ygg0ReAhIOnYLxYvbpAuJyNfcZ+Z+dfAeoBedmkCio3j5ovcY3c5U72zunV6ZdjwtqMab1
        DuXxK2inNKleTV/m4mYAHyUQxd13HBg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-vZNhlchVN9qeY-x5YdPS9A-1; Wed, 20 May 2020 12:33:43 -0400
X-MC-Unique: vZNhlchVN9qeY-x5YdPS9A-1
Received: by mail-ej1-f70.google.com with SMTP id h6so1553722ejb.17
        for <kvm@vger.kernel.org>; Wed, 20 May 2020 09:33:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bAZr9JpGFpcuu3XfWQIxwcbd9+r9VJYRanbh/qrJCdA=;
        b=i0zA1rjWp6Z6RwiHMF58W9UYVsqV/hn2Zc3bCiJIO5Z810xdN4cCpn5p/gf36ivER9
         YUzAMyVMSb6z91aAT8xZK9hCGdmVbvn4ZanNB3ZzxmY8GVQMTYuF03YOj8kJy7hHz7wH
         4/RTIzS4Z8w1UxJzMg7IgEHnMw1Xoxo1HUgo1rRE8X5VHI0QKakddXgmb0cgZBkxB4DR
         lArrzkS51WCzVA9K0fVYOrxu1QozLZgjtbfTevY43ZEKANaTfBdxOQkRVp2/Ywj/NbR/
         N9Y+SsfbGd0E7conLuDCLSuFXMOopJBn+prUEz3Ta5itiPe9hfHkoHypsgGf7pLTAukV
         Rv+A==
X-Gm-Message-State: AOAM532pL4KbUi9gJQyu+PShYwo3WYrGVgzHcx7wIwpiAHN0/BxrNfBK
        +E4yuyKzyw8OHGkwIv4Fzsgcyw6quzDjIOKiy5/oUeuAycFFM/4O/snjkIx/4YjNgf9r/Mc7r/7
        jk2ARL8WyXIRD
X-Received: by 2002:a17:906:6bc5:: with SMTP id t5mr4270297ejs.459.1589992422410;
        Wed, 20 May 2020 09:33:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7yvH7d/edQcZjZSz0U8YMWI3hpcZy/hW1aUOvFSWb9mTe9xQ9+gEka1tRNCnBYytolrP33w==
X-Received: by 2002:a17:906:6bc5:: with SMTP id t5mr4270277ejs.459.1589992422203;
        Wed, 20 May 2020 09:33:42 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 13sm2347728ejw.88.2020.05.20.09.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 09:33:41 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 2/2] kvm/x86: don't expose MSR_IA32_UMWAIT_CONTROL unconditionally
In-Reply-To: <20200520160740.6144-3-mlevitsk@redhat.com>
References: <20200520160740.6144-1-mlevitsk@redhat.com> <20200520160740.6144-3-mlevitsk@redhat.com>
Date:   Wed, 20 May 2020 18:33:40 +0200
Message-ID: <874ksatvkr.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim Levitsky <mlevitsk@redhat.com> writes:

> This msr is only available when the host supports WAITPKG feature.
>
> This breaks a nested guest, if the L1 hypervisor is set to ignore
> unknown msrs, because the only other safety check that the
> kernel does is that it attempts to read the msr and
> rejects it if it gets an exception.
>
> Fixes: 6e3ba4abce KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe3a24fd6b263..9c507b32b1b77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5314,6 +5314,10 @@ static void kvm_init_msr_list(void)
>  			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
>  			    min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
>  				continue;
> +			break;
> +		case MSR_IA32_UMWAIT_CONTROL:
> +			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
> +				continue;

I'm probably missing something but (if I understand correctly) the only
effect of dropping MSR_IA32_UMWAIT_CONTROL from msrs_to_save would be
that KVM userspace won't see it in e.g. KVM_GET_MSR_INDEX_LIST. But why
is this causing an issue? I see both vmx_get_msr()/vmx_set_msr() have
'host_initiated' check:

       case MSR_IA32_UMWAIT_CONTROL:
                if (!msr_info->host_initiated && !vmx_has_waitpkg(vmx))
                        return 1;

so KVM userspace should be able to read/write this MSR even when there's
no hardware support for it. Or who's trying to read/write it?

Also, kvm_cpu_cap_has() check is not equal to vmx_has_waitpkg() which
checks secondary execution controls.

>  		default:
>  			break;
>  		}

-- 
Vitaly

