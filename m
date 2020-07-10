Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0221F21B1F7
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgGJJFp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:05:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43962 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727876AbgGJJFo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 05:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594371942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rBMD0sSb0w5KCpcjnu5JAG0eeG/Qn+GEjvEGuxcUNnk=;
        b=XH0ujO8sr/5/bvksFotVAHwQeLwyGvRu+sVhaNRQ/TK7hq5eDKozdvxn/ExacnUpqD8zvh
        Hcxe3hd9DNAsoYpqoYUXOVDyZOVafUJXYyBXUhCQuDn8jJK7lHtCO6x7olqsfU85AcYA2D
        /coLPDsWzBkB511SkUThLf0pta6fD5o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-wevINQRJO3yMbHu3KMBJ4g-1; Fri, 10 Jul 2020 05:05:41 -0400
X-MC-Unique: wevINQRJO3yMbHu3KMBJ4g-1
Received: by mail-wr1-f69.google.com with SMTP id b8so5310891wro.19
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 02:05:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rBMD0sSb0w5KCpcjnu5JAG0eeG/Qn+GEjvEGuxcUNnk=;
        b=bq4Jy/n33HXFspBX9IwY4BpJ0erkptk+AnJlRgKDTMhFKwaFRo07UC+BJgg6RqjQ84
         cvq+pMdkbkPvnIFvyFvROt+D4SjgcY3pPtC4wGJKvRR89BQuSv+F8FRhyK3z8rxUAcd0
         /UsSJ4qSBWrkfjk21eDtrLm8Jw9b/QK4D3Bxk/+HugzEQOp3PG3lFuHmbbL7W/GbP/UD
         CGkRySa0iklC+xLuAesgt+b562pCdve2SlKqGZAYLm2WGLpIEn+10bu4StmXNXuv7rGq
         pcsC5xsZcv0joXSVN9rAtYDOHE9mqypa9cTUTfHJe5U25v/rwz7v8Ph3UF8hgBut5zHA
         ME4A==
X-Gm-Message-State: AOAM531Y76sDkm3UkDZV/5MHQt59XoX4lDhnHVCvEav/SLOsCMYjeRT0
        eYj0qWBaBhOf+j9CIfXsrdbmh152c0TRgeZKc2XSruW2noP5CAQa4bwZMdtwFom7ab86AtBNJLt
        +dqRjUBv0M49s
X-Received: by 2002:a7b:c94a:: with SMTP id i10mr4339719wml.183.1594371939193;
        Fri, 10 Jul 2020 02:05:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxdSKxSnNl4oHDK3tCHLmcJEHYYFjHnDOEs4+Y09FVBCBpRkm8rhElrxBVkZIHFDJvwZdaGw==
X-Received: by 2002:a7b:c94a:: with SMTP id i10mr4339689wml.183.1594371938901;
        Fri, 10 Jul 2020 02:05:38 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id w14sm9373016wrt.55.2020.07.10.02.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 02:05:38 -0700 (PDT)
Date:   Fri, 10 Jul 2020 11:05:30 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Makarand Sonare <makarandsonare@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2] KVM: nVMX: fixes for preemption timer migration
Message-ID: <20200710090530.evy5ezrhnskywbt2@steredhat>
References: <20200709172801.2697-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709172801.2697-1-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On Thu, Jul 09, 2020 at 01:28:01PM -0400, Paolo Bonzini wrote:
> Commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration",
> 2020-06-01) accidentally broke nVMX live migration from older version
> by changing the userspace ABI.  Restore it and, while at it, ensure
> that vmx->nested.has_preemption_timer_deadline is always initialized
> according to the KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE flag.
> 
> Cc: Makarand Sonare <makarandsonare@google.com>
> Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> v1->v2: coding style [Jim]
> 
>  arch/x86/include/uapi/asm/kvm.h | 5 +++--
>  arch/x86/kvm/vmx/nested.c       | 1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 17c5a038f42d..0780f97c1850 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -408,14 +408,15 @@ struct kvm_vmx_nested_state_data {
>  };
>  
>  struct kvm_vmx_nested_state_hdr {
> -	__u32 flags;
>  	__u64 vmxon_pa;
>  	__u64 vmcs12_pa;
> -	__u64 preemption_timer_deadline;
>  
>  	struct {
>  		__u16 flags;
>  	} smm;
> +
> +	__u32 flags;
> +	__u64 preemption_timer_deadline;
>  };
>  

Should we update also Documentation/virt/kvm/api.rst to be consistent?

Thanks,
Stefano

