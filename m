Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AB33FA056
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 22:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbhH0UNX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 16:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhH0UNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 16:13:21 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E46C0613D9
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 13:12:32 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u15so4594980plg.13
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 13:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iVRDKYgAPMQPQThbu6Z1CqE+JP0XzL3KQxzCLMVoGwE=;
        b=q/4g6SCLTECWGMUJObWraLiTtS2qbjOQkHC1t/4Xnhllm421NW/49aX8SOyaQ+6Scx
         W6rP6CxIr9nJWOfHUzfT+rwY8pCKyvaPQ0CS9uDFen613YZP8KtxG2q+fD86/FpU40KY
         fSw3ksnAPUq7Vy8UpkVkpQAwW6mK1otfhJhRV1LGNSXFoRYyIDTnTmWGHNPzRS+ZOMP0
         Yy3LA/TI6mGPZ3tzElrIHas1KY9uzzRl1tKbz6PuoX2ReKgfPZ4XscpHYscZ2bUR2bw6
         NAGVuQVbSYfnb8dpItz13y1PNGhZ6gLg99DYlzlYKOpMa+3pFO3k3fq5K7vkGb2/zAt3
         QPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iVRDKYgAPMQPQThbu6Z1CqE+JP0XzL3KQxzCLMVoGwE=;
        b=gh4iUJUSjelFgcVHwS+IDlM7UzEsGA/J4L/t0pFNWl318vJncw7IKdrKp7N1PtIWhn
         mrKWCcT9KiDGOWUxJ+5qZEobRKUjRpPfSagQWlTgQ8Z+flAQFZRd5WoEyI9i36uTiCHu
         6KuXu/Srg+W/GIU/mqDJ3O/cuWSgGPHWqELLLfkRjXtP/IXV7YK4PSxbJMjzhFphKHoQ
         1wObbYgG/DJlGvIMq6DVT1zss2o7UI+VQbavi+4pwLFjDFqZd3J1sltzmpxheKcOEcNY
         Owt8LQ/Y0dNmEENdlS7lhCYiFcLNFvmTeRsn4KXvGDDjb/wgatB93L9uuzNyuVcHyO2G
         AixQ==
X-Gm-Message-State: AOAM5331XhSRH0ImgtKK6eVdjVlSX+YWODDDACLr1vkX9ItAZMXLP8He
        HV0miMcoc4isTmflxlneiGT0kQ==
X-Google-Smtp-Source: ABdhPJzcAaF+AnneIG9I9sWTptvibQMRWOM1Y1jvkbGK5+MqPb4w3u4348+y/3rIfL5Zu27WnzTR0A==
X-Received: by 2002:a17:902:a50f:b029:11a:b033:e158 with SMTP id s15-20020a170902a50fb029011ab033e158mr10207875plq.26.1630095151993;
        Fri, 27 Aug 2021 13:12:31 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z8sm7062860pfa.113.2021.08.27.13.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 13:12:31 -0700 (PDT)
Date:   Fri, 27 Aug 2021 20:12:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/2] KVM: stats: Add counters for SVM exit reasons
Message-ID: <YSlHK+ZZFuokMa4S@google.com>
References: <20210827174110.3723076-1-jingzhangos@google.com>
 <20210827174110.3723076-2-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827174110.3723076-2-jingzhangos@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Jing Zhang wrote:
> Three different exit code ranges are named as low, high and vmgexit,
> which start from 0x0, 0x400 and 0x80000000.
> 
> Original-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  7 +++++++
>  arch/x86/include/uapi/asm/svm.h |  7 +++++++
>  arch/x86/kvm/svm/svm.c          | 21 +++++++++++++++++++++
>  arch/x86/kvm/x86.c              |  9 +++++++++
>  4 files changed, 44 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index dd2380c9ea96..6e3c11a29afe 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -35,6 +35,7 @@
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/hyperv-tlfs.h>
>  #include <asm/vmx.h>
> +#include <asm/svm.h>
>  
>  #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  
> @@ -1261,6 +1262,12 @@ struct kvm_vcpu_stat {
>  	u64 vmx_all_exits[EXIT_REASON_NUM];
>  	u64 vmx_l2_exits[EXIT_REASON_NUM];
>  	u64 vmx_nested_exits[EXIT_REASON_NUM];
> +	u64 svm_exits_low[SVM_EXIT_LOW_END - SVM_EXIT_LOW_START];
> +	u64 svm_exits_high[SVM_EXIT_HIGH_END - SVM_EXIT_HIGH_START];
> +	u64 svm_vmgexits[SVM_VMGEXIT_END - SVM_VMGEXIT_START];

This is, for lack of a better word, a very lazy approach.  With a bit more (ok,
probably a lot more) effort and abstraction, we can have parity between VMX and
SVM, and eliminate a bunch of dead weight.  Having rough parity would likely be
quite helpful for the end user, e.g. reduces/eliminates vendor specific userspace
code.

E.g. this more or less doubles the memory footprint due to tracking VMX and SVM
separately, SVM has finer granularity than VMX (often too fine),  VMX tracks nested
exits but SVM does not, etc...

If we use KVM-defined exit reasons, then we can omit the exits that should never
happen (SVM has quite a few), and consolidate the ones no one should ever care
about, e.g. DR0..DR4 and DR6 can be collapsed (if I'm remembering my DR aliases
correctly).  And on the VMX side we can provide better granularity than the raw
exit reason, e.g. VMX's bundling of NMIs and exceptions is downright gross.

	#define KVM_GUEST_EXIT_READ_CR0
	#define KVM_GUEST_EXIT_READ_CR3
	#define KVM_GUEST_EXIT_READ_CR4
	#define KVM_GUEST_EXIT_READ_CR8
	#define KVM_GUEST_EXIT_DR_READ
	#define KVM_GUEST_EXIT_DR_WRITE
	#define KVM_GUEST_EXIT_DB_EXCEPTION
	#define KVM_GUEST_EXIT_BP_EXCEPTION
	#define KVM_GUEST_EXIT_UD_EXCEPTION

	...
	#define KVM_NR_GUEST_EXIT_REASONS

	u64 l1_exits[KVM_NR_GUEST_EXIT_REASONS];
	u64 l2_exits[KVM_NR_GUEST_EXIT_REASONS];
	u64 nested_exits[KVM_NR_GUEST_EXIT_REASONS];


The downside is that it will require KVM-defined exit reasons and will have a
slightly higher maintenance cost because of it, but I think overall it would be
a net positive.  Paolo can probably even concoct some clever arithmetic to avoid
conditionals when massaging SVM exits reasons.  VMX will require a bit more
manual effort, especially to play nice with nested, but in the end I think we'll
be happier.

> +	u64 svm_vmgexit_unsupported_event;
> +	u64 svm_exit_sw;
> +	u64 svm_exit_err;
>  };
