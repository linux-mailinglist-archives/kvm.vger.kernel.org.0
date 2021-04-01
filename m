Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB0352329
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhDAXFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbhDAXFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:05:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83725C0613E6
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:05:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id s11so2505187pfm.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M3okJYq6mMyda+/xQ/7TMgoAp55unT4u7DqAN42FxVQ=;
        b=cT1e0JNGFt9WaLlOQa/N9A6A9youYriOM3LEuRfbXgFUjev3Z17MgF4SG2Xl6dE6T1
         w8v3QQhsWd53b7Lyt2JJXckATwhlCeSYBGOFOO3o5C7qRp+UVQ/hvGhxxLn1FoU5uz22
         ZryojmhjdsksXR8mFUZ/ja7RpUCZIG1/cwtCVq4WBbo5aP5df+tfR7ndH/LppS55MsXF
         Yj7BCRwWg7PqKZjf9/FTwHIX4MUQPVKBcEa8wFdTbyfLuJ9hz/gMQTuRzaNj4cwzRPEV
         SujAZu7wHpmGhitbRbLXEckKSRhZxjrWq+NiYmOctqFQyo4cdo25XghaHytISRC/wmi5
         LC1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M3okJYq6mMyda+/xQ/7TMgoAp55unT4u7DqAN42FxVQ=;
        b=Ogk/IJEWi9nZlmm25FAKYxxmZ4hnalmje9KDDO1MW94ZbyIJItDz/9hMocvr3flP4q
         dS5t/HVUBsUrpjSrqOcVZKAlHSk6jZuWpUmMHUIZaf3MQFYRjFtuVJ1gqD0kgN7AuEGe
         BvNJRaBC6y5DQ6z59KXP06Wd1Cxglly4g7lBkXVKdc4f7oy3vAYx9bbhzR+byKbmQruD
         auzETN4hqLGZKdDQAdOVtqy++g37LZ4qIB0+W4/u7bbwSHy/jUVXOGpFkuJ99jFxAfiw
         0vH6IR56v4VDBKfXSU7cDmRmZwQfoO/AoqaOVy1D96CZoj8t6MXD3ZNLK6ZVqwxo9Q9r
         aNSA==
X-Gm-Message-State: AOAM531wgpMr+vHahWFDhe9JnIQsZtH7HwirLn+1B+yp96/J2mWkbm2j
        oF2TRmprJZirmCtDUladochjGOcCKNLSDA==
X-Google-Smtp-Source: ABdhPJzByp+cP91stOzHEZTf8VPSFd6gx8jb/PJ7dK7E34KPinzt/KOa0EUoXxB7dpEFiaM99ijkrw==
X-Received: by 2002:a63:dc43:: with SMTP id f3mr1082973pgj.290.1617318320918;
        Thu, 01 Apr 2021 16:05:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a22sm6968192pgw.52.2021.04.01.16.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 16:05:20 -0700 (PDT)
Date:   Thu, 1 Apr 2021 23:05:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 2/4] KVM: x86: separate pending and injected exception
Message-ID: <YGZRrOBVvlhVTyG8@google.com>
References: <20210401143817.1030695-1-mlevitsk@redhat.com>
 <20210401143817.1030695-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401143817.1030695-3-mlevitsk@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 01, 2021, Maxim Levitsky wrote:
> Use 'pending_exception' and 'injected_exception' fields
> to store the pending and the injected exceptions.
> 
> After this patch still only one is active, but
> in the next patch both could co-exist in some cases.

Please explain _why_.  

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  25 ++++--
>  arch/x86/kvm/svm/nested.c       |  26 +++---
>  arch/x86/kvm/svm/svm.c          |   6 +-
>  arch/x86/kvm/vmx/nested.c       |  36 ++++----
>  arch/x86/kvm/vmx/vmx.c          |  12 +--
>  arch/x86/kvm/x86.c              | 145 ++++++++++++++++++--------------
>  arch/x86/kvm/x86.h              |   6 +-
>  7 files changed, 143 insertions(+), 113 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a52f973bdff6..3b2fd276e8d5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -547,6 +547,14 @@ struct kvm_vcpu_xen {
>  	u64 runstate_times[4];
>  };
>  
> +struct kvm_queued_exception {
> +	bool valid;
> +	u8 nr;

If we're refactoring all this code anyways, maybe change "nr" to something a
bit more descriptive?  E.g. vector.

> +	bool has_error_code;
> +	u32 error_code;
> +};
> +
> +
>  struct kvm_vcpu_arch {
>  	/*
>  	 * rip and regs accesses must go through
> @@ -645,16 +653,15 @@ struct kvm_vcpu_arch {
>  
>  	u8 event_exit_inst_len;
>  
> -	struct kvm_queued_exception {
> -		bool pending;
> -		bool injected;
> -		bool has_error_code;
> -		u8 nr;
> -		u32 error_code;
> -		unsigned long payload;
> -		bool has_payload;
> +	struct kvm_queued_exception pending_exception;
> +
> +	struct kvm_exception_payload {
> +		bool valid;
> +		unsigned long value;
>  		u8 nested_apf;
> -	} exception;
> +	} exception_payload;

Hmm, even if it's dead code at this time, I think the exception payload should
be part of 'struct kvm_queued_exception'.  The payload is very much tied to a
single exception.

> +
> +	struct kvm_queued_exception injected_exception;

Any objection to keeping the current syntax, arch.exception.{pending,injected}?
Maybe it's fear of change, but I like the current style, I think because the
relevant info is condensed at the end, e.g. I can ignore "vcpu->arch.exception"
and look at "pending.vector" or whatever.  E.g.

	struct {
		struct kvm_queued_exception pending;
		struct kvm_queued_exception injected;
	} exception;
>  
>  	struct kvm_queued_interrupt {
>  		bool injected;
