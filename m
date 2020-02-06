Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B5E154CE0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 21:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbgBFUXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 15:23:51 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38155 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727526AbgBFUXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 15:23:51 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so6896186qki.5;
        Thu, 06 Feb 2020 12:23:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c2iCNtrYC2+Mdzvmrw5+MQ+tkR8a1GggRuPCY2Z5Feg=;
        b=CYmgcQJGVE41pT4E5lTZdnBm+LY0hAHEJjKseOWehnmNuRG78MqlF3dRJWZhfjVSVM
         WTgC20KgVF4TzeMTMOXx187W5tnu5/HWndCMOYTWF9xxDP/1jx0KVWb7ADGk/w17qe8t
         5jiE9ItqE/x1VXqVdGE5e3OXvQixydL1zelw4O6imOjoAtYaUP64UBmUxGg/8P+qfvSq
         HPlGYvPQUblb2y/TsN5lkyC3YdUGkI2wD/dkYqYbEpyv3krrN/cSA3js/ku2IAtuw2BU
         NaocVy/pLXo27wbSxnE8pl/iFQFA5NKTAqir60Egp/jc34c9cYKDGrxOZMMPISI1APu3
         uqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=c2iCNtrYC2+Mdzvmrw5+MQ+tkR8a1GggRuPCY2Z5Feg=;
        b=OSZdtVjRfOOY0MtK/PksE0E0bz9xsJuho/NBFcEtLzb4A5I6SV0zrV5rW8rAuUV/iM
         ZF309LTu6KAScFOe6kTmCyIuq50W6u53/Dnlu8+8jS/XQcwtgGAun/TJF02ZhCD1hwWg
         7z/F6teugdF57LEn4XDfEnYEnoeoE8IWbGWiuOfZ0tY/lr2YGT6YGbz3UujjvvlUDVw/
         NIBjfqqZLk/fnoFSW7vAtEao+yiKutAxqwJUqS0+eW174rhdbEMCIuWIP5sfddEzdiuG
         6b0/guGR2sYqmKswUvLe9Kb8LRrJbw+Eo1rxv7L0BvaO4rEp1jjhtMUmRdJX9NstRhoP
         /seg==
X-Gm-Message-State: APjAAAX+gVIAm5tTCB0fnlDqJHOBWY9efXEN80KM0f3RHJ3OcnfiZsxN
        nqMSbnkyOcrbMQnP7AC0zN4=
X-Google-Smtp-Source: APXvYqyFgNLaYiSgs+zCYQ+mCBBuWLsboa2rWQ1/9lHdrY252n0AynntA2jYdDxFZLSJrIaFfCmu9Q==
X-Received: by 2002:a37:a451:: with SMTP id n78mr4091402qke.481.1581020629653;
        Thu, 06 Feb 2020 12:23:49 -0800 (PST)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id x19sm206271qtm.47.2020.02.06.12.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:23:49 -0800 (PST)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 6 Feb 2020 15:23:47 -0500
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>, tony.luck@intel.com,
        peterz@infradead.org, fenghua.yu@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] x86/split_lock: Cache the value of MSR_TEST_CTRL
 in percpu data
Message-ID: <20200206202346.GA2742055@rani.riverdale.lan>
References: <20200206070412.17400-1-xiaoyao.li@intel.com>
 <20200206070412.17400-4-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200206070412.17400-4-xiaoyao.li@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 03:04:07PM +0800, Xiaoyao Li wrote:
> Cache the value of MSR_TEST_CTRL in percpu data msr_test_ctrl_cache,
> which will be used by KVM module.
> 
> It also avoids an expensive RDMSR instruction if SLD needs to be context
> switched.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/include/asm/cpu.h  |  2 ++
>  arch/x86/kernel/cpu/intel.c | 19 ++++++++++++-------
>  2 files changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index ff567afa6ee1..2b20829db450 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -27,6 +27,8 @@ struct x86_cpu {
>  };
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +DECLARE_PER_CPU(u64, msr_test_ctrl_cache);
> +

Why does this depend on HOTPLUG_CPU?
