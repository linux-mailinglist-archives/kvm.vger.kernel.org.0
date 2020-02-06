Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCA1546F0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbgBFO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:59:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727279AbgBFO74 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 09:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581001195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmjLVdP5R8RM0ZvRPIl0Xv2Nz6Hwhfs77mUQxh0wahs=;
        b=P/01StAXoV8LVwfdKJI96gDqfR3p14WzSMoSO0dqt+e91/fx/vuvY4kaqs3lgEgtx5CoGk
        EahXYITU4fG0TgV67NZTEjENDhecGXakxcYOQOAIgRiDPMKkaeWm1Xlc3yuf/xSpdlUbVI
        BqtnwnvrPM8X3jymqpeFg+aelWHKQqw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-d9Dk33B-N7CskVSlvjorpg-1; Thu, 06 Feb 2020 09:59:52 -0500
X-MC-Unique: d9Dk33B-N7CskVSlvjorpg-1
Received: by mail-wm1-f70.google.com with SMTP id m18so114140wmc.4
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 06:59:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qmjLVdP5R8RM0ZvRPIl0Xv2Nz6Hwhfs77mUQxh0wahs=;
        b=i4bBcPuulPxNwmB/RDwB9ER77/XNKHjgHY8xP1/mK9EU5cG2yackXVqnKN00jqyBPQ
         Fbi3SkpJnFhJSdVKMh6MPRh8kms0H//Tt4nZVK5O+kxoo9QoYAUwB1tjCMuZA/musCsX
         CkF6tcasfpk31w4NscIf3gDUgHZOaxyi/2gqPamxWs/c/PDOk0DbAwiImNoh8rj2zj1I
         sVfbEisqfPinri4WERlZjWIERWp0Igk4QQAUMcUvORniTF78349rz3/V1dYffFofZFdW
         VAoxX/ztjPrSv+nwxhZ1fudOy8H3X/qORcgr1eHT86RVX/fvVgeNL26Cgi729to3ZVx3
         FzzA==
X-Gm-Message-State: APjAAAWXtWYC1/TidfRV2DViAP31e4bq/3+o8PDaVHZ5z2H0XK2ELZpW
        eIlzLyFGQhhC7p2vTfMTCoRgrx5ON2+CjGoom6UU5Mk0+MZ7G7Yvs2Sic2Y1Z/OE6HdGjH7YcoL
        nCxf0IxR3fG2l
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4902090wmm.24.1581001191124;
        Thu, 06 Feb 2020 06:59:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSFSAnJto9BHznTO5jIGLECUtjqikpIoBHWuDLYA69tq1wXZv9J3fWCOARGMJFmdINf+BaEg==
X-Received: by 2002:a05:600c:cd:: with SMTP id u13mr4902075wmm.24.1581001190906;
        Thu, 06 Feb 2020 06:59:50 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v22sm3885858wml.11.2020.02.06.06.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 06:59:50 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 02/61] KVM: x86: Refactor loop around do_cpuid_func() to separate helper
In-Reply-To: <20200201185218.24473-3-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-3-sean.j.christopherson@intel.com>
Date:   Thu, 06 Feb 2020 15:59:49 +0100
Message-ID: <87sgjng3ru.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the guts of kvm_dev_ioctl_get_cpuid()'s CPUID func loop to a
> separate helper to improve code readability and pave the way for future
> cleanup.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 45 ++++++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 47ce04762c20..f49fdd06f511 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -839,6 +839,29 @@ static bool is_centaur_cpu(const struct kvm_cpuid_param *param)
>  	return boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR;
>  }
>  
> +static int get_cpuid_func(struct kvm_cpuid_entry2 *entries, u32 func,
> +			  int *nent, int maxnent, unsigned int type)
> +{
> +	u32 limit;
> +	int r;
> +
> +	r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> +	if (r)
> +		return r;
> +
> +	limit = entries[*nent - 1].eax;
> +	for (func = func + 1; func <= limit; ++func) {
> +		if (*nent >= maxnent)
> +			return -E2BIG;
> +
> +		r = do_cpuid_func(&entries[*nent], func, nent, maxnent, type);
> +		if (r)
> +			break;
> +	}
> +
> +	return r;
> +}
> +
>  static bool sanity_check_entries(struct kvm_cpuid_entry2 __user *entries,
>  				 __u32 num_entries, unsigned int ioctl_type)
>  {
> @@ -871,8 +894,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  			    unsigned int type)
>  {
>  	struct kvm_cpuid_entry2 *cpuid_entries;
> -	int limit, nent = 0, r = -E2BIG, i;
> -	u32 func;
> +	int nent = 0, r = -E2BIG, i;

Not this patches fault, but I just noticed that '-E2BIG' initializer
here is only being used for 

 'if (cpuid->nent < 1)'

case so I have two suggestion:
1) Return directly without the 'goto' , drop the initializer.
2) Return -EINVAL instead.

> +
>  	static const struct kvm_cpuid_param param[] = {
>  		{ .func = 0 },
>  		{ .func = 0x80000000 },
> @@ -901,22 +924,8 @@ int kvm_dev_ioctl_get_cpuid(struct kvm_cpuid2 *cpuid,
>  		if (ent->qualifier && !ent->qualifier(ent))
>  			continue;
>  
> -		r = do_cpuid_func(&cpuid_entries[nent], ent->func,
> -				  &nent, cpuid->nent, type);
> -
> -		if (r)
> -			goto out_free;
> -
> -		limit = cpuid_entries[nent - 1].eax;
> -		for (func = ent->func + 1; func <= limit && r == 0; ++func) {
> -			if (nent >= cpuid->nent) {
> -				r = -E2BIG;
> -				goto out_free;
> -			}
> -			r = do_cpuid_func(&cpuid_entries[nent], func,
> -				          &nent, cpuid->nent, type);
> -		}
> -
> +		r = get_cpuid_func(cpuid_entries, ent->func, &nent,
> +				   cpuid->nent, type);
>  		if (r)
>  			goto out_free;
>  	}

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

