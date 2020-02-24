Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCCD16AA30
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgBXPe6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:34:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47155 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727359AbgBXPe6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 10:34:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582558496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gJpm/Tebxdb+Wgu5FleyadSnWEMf3LJQp0WKqRm+nww=;
        b=LGhmu04SUQHKbimh5NVPs6pSKROAdZefAuvGNTQhE1h8UaPJEPtJsaxzBNjImnNzjSVJpw
        XIEeju+FZ/A924ki00YTwEwBycjUU/MLccV32xLQPcr1uTsG2qum7u4Jrbizli8Jj8Ul17
        Fcd0lPjIboOfPUiw+zW+Dzm/frdJW2c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-p2FX4w08PvWJFqCtxIxTXg-1; Mon, 24 Feb 2020 10:34:55 -0500
X-MC-Unique: p2FX4w08PvWJFqCtxIxTXg-1
Received: by mail-wr1-f70.google.com with SMTP id d15so5772881wru.1
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:34:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gJpm/Tebxdb+Wgu5FleyadSnWEMf3LJQp0WKqRm+nww=;
        b=EH5QYX6Yk5JJb3Mfk2811wYiii139nXAJvYkWw/J78svKszvvReeUgb57WiYJRzloz
         M+3S5yrGojitOKLDNOjke9+/ecJUCZAV1SBvFNDXLYE/rmRpAuSLY8pu97LxsYAAwjE7
         a11/SmS8ltnGIaxrrdewQILKv5OImYAwQelIja1v8mR7Ul3hvN8bxJqG2WOUDDscDLhi
         0YS+wSJRbJaaq0wsilH2auYIVdJqSa3OfAJZ4kQsahb/yfxhQY26MC4vgxMNKlNu4iu6
         JnowIVudsXnsfLLp4e0YD1uLWVh198ISwndEb4a440JQGnWBQDdRgAilrI4YciX18CuP
         SIBA==
X-Gm-Message-State: APjAAAVLfxD/Z9c/LzpuPxq3eHzPEJYh2sW4CKGV6NcMWYzdDSc3fjwn
        YA4hj4pVHGx0PQmVPghI946t7RrSOGZXMCEgLoq0o5WiERc4hL7zBmMZj5iTR8wglzVdGPCEc5T
        IZsEWyvNI9lFA
X-Received: by 2002:adf:fe4d:: with SMTP id m13mr70779364wrs.179.1582558493874;
        Mon, 24 Feb 2020 07:34:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqyw8uV+kl1oe26PuuKsug4I1PsBgu1fKa3k+NmiwBlb7ilHNgl3jdn80PtQIp1HxIROanNicw==
X-Received: by 2002:adf:fe4d:: with SMTP id m13mr70779351wrs.179.1582558493679;
        Mon, 24 Feb 2020 07:34:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id n13sm19124830wmd.21.2020.02.24.07.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:34:53 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 36/61] KVM: x86: Handle GBPAGE CPUID adjustment for EPT in VMX code
In-Reply-To: <20200201185218.24473-37-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-37-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:34:52 +0100
Message-ID: <87mu98ngmb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the clearing of the GBPAGE CPUID bit into VMX to eliminate an
> instance of the undesirable "unsigned f_* = *_supported ? F(*) : 0"
> pattern in the common CPUID handling code, and to pave the way toward
> eliminating ->get_lpage_level().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 3 +--
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index f4a3655451dd..c74253202af8 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -416,8 +416,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	int r, i, max_idx;
>  	unsigned f_nx = is_efer_nx() ? F(NX) : 0;
>  #ifdef CONFIG_X86_64
> -	unsigned f_gbpages = (kvm_x86_ops->get_lpage_level() == PT_PDPE_LEVEL)
> -				? F(GBPAGES) : 0;
> +	unsigned f_gbpages = F(GBPAGES);
>  	unsigned f_lm = F(LM);
>  #else
>  	unsigned f_gbpages = 0;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fcec3d8a0176..11b9c1e7e520 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7125,6 +7125,8 @@ static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  	case 0x80000001:
>  		if (!cpu_has_vmx_rdtscp())
>  			cpuid_entry_clear(entry, X86_FEATURE_RDTSCP);
> +		if (enable_ept && !cpu_has_vmx_ept_1g_page())
> +			cpuid_entry_clear(entry, X86_FEATURE_GBPAGES);
>  		break;
>  	default:
>  		break;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

