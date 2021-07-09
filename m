Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8349E3C270E
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 17:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhGIPt6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 11:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhGIPt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 11:49:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5198C0613DD
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 08:47:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id g24so5969026pji.4
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 08:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aWRV/nM5DEWXiCQSe/62S8V1L20wuubZeFimG8/S0eY=;
        b=ouHw5uK7Qig/cJRudMZNkpgkYuA3HP9yCXWPjJzIgGCv78msj3WCGK78eFhNe1d0e8
         fkLIrgIHCDigJwKsDF/BMlAQcWr4Fu590jCX6/sL8ngrHygaWLCW/xvlQdJLl2Jr5CRH
         NRFrdtbYv645uAYeXH8hOusnvJ7Nt8xqoF7nSHhNL0FUsgr8bLQaCe49/3NZSeJ32XA0
         TnjS5D05oZM4FEfXtTvch9VGkp08ee6PWlaEC0BxTXJ3LjTGrbz5LSv2GU6GbswPkyqp
         m/uFPsHZWYDo7yLMWLq5nOEH9mCKR+UNxTORFVkKrRFciL9NgD5KCPTfrpFCXee8L4O7
         QRzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aWRV/nM5DEWXiCQSe/62S8V1L20wuubZeFimG8/S0eY=;
        b=Tna0ww/N1sddcdnA0I8jWD8UzRDIVB8BuT0e7HlfRdSAHMucGOYmSs8zHEC7Ojk8U8
         uIRwLE2ojIfj4AF0jQbT+VrGb0uP3x0+yBKqpquArT4ZgRNVaA7s/tjPj/oM7ts1Yy1y
         +cyrMA3noLKZPGMne1O82/mAVrI7GR+O2WmqhKnJaZHgvuXL+cxaMvGmAnkATEvHQ2+m
         /Wdds/PTOSEHRNg2WCdJ/vdgRrosRmn/FWsDKkePCgi8fG2uWOfzuS5E4PwfHyF2n5jK
         fPvbMlCADL1gTh+BKu39o9FbeJTTWpATae8D9w39ekTIpbBVjhEe3L1vhkyz5Yr0PI/N
         gL1g==
X-Gm-Message-State: AOAM53253YoJ6ESnTUO6C8W+/10B0upW/DThA/BEbP5cRaFmGMHvmALo
        I0nARrYIdAV7E0s97DYfYuFm/w==
X-Google-Smtp-Source: ABdhPJxSzgUbe56dtC+lLbeqw5dBgJD5rlSaxgGt55Qv1he1TgNACLH1yFF2FnfBKrT+NjOSvXks/w==
X-Received: by 2002:a17:90a:de8b:: with SMTP id n11mr38743076pjv.11.1625845632179;
        Fri, 09 Jul 2021 08:47:12 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p24sm7495391pgl.68.2021.07.09.08.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 08:47:11 -0700 (PDT)
Date:   Fri, 9 Jul 2021 15:47:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: On emulation failure, convey the exit
 reason to userspace
Message-ID: <YOhvfDfqypLCRZuO@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
 <20210706101207.2993686-3-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706101207.2993686-3-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021, David Edmondson wrote:
> Should instruction emulation fail, include the VM exit reason in the
> emulation_failure data passed to userspace, in order that the VMM can
> report it as a debugging aid when describing the failure.

...

> @@ -7473,7 +7474,14 @@ static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>  		memcpy(run->emulation_failure.insn_bytes,
>  		       ctxt->fetch.data, insn_size);
>  	}
> +
> +	run->emulation_failure.ndata = 4;
> +	run->emulation_failure.flags |=
> +		KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON;
> +	run->emulation_failure.exit_reason =
> +		static_call(kvm_x86_get_exit_reason)(vcpu);
>  }

...

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d9e4aabcb31a..863195371272 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -282,6 +282,7 @@ struct kvm_xen_exit {
>  
>  /* Flags that describe what fields in emulation_failure hold valid data. */
>  #define KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES (1ULL << 0)
> +#define KVM_INTERNAL_ERROR_EMULATION_FLAG_EXIT_REASON       (1ULL << 1)
>  
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
> @@ -404,6 +405,12 @@ struct kvm_run {
>  			__u64 flags;
>  			__u8  insn_size;
>  			__u8  insn_bytes[15];
> +			/*
> +			 * The "exit reason" extracted from the
> +			 * VMCS/VMCB that was the cause of attempted
> +			 * emulation.
> +			 */
> +			__u64 exit_reason;

Rather than providing just the exit reason and adding another kvm_x86_ops hook,
I would prefer to extend kvm_x86_get_exit_info() to also provide the exit reason
and use that.  E.g. on VMX, all exceptions funnel through a single exit reason.
Dumping exit_info_{1,2} and error_code in addition to intr_info might not be all
that useful, but I can't see in harm either, and more info is generally a good
thing.

The only other user of kvm_x86_get_exit_info() is for tracepoints, those could
be modified to not pass in the exit reason.

>  		} emulation_failure;
>  		/* KVM_EXIT_OSI */
>  		struct {
> -- 
> 2.30.2
> 
