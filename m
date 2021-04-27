Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA2E36CE68
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhD0WFi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237136AbhD0WFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:05:37 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0E3C061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:04:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c19so6444911pfv.2
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tvy9sjWqnF7JDLiqaC+vIZWUwHqerNYoWSgKZH8wt6M=;
        b=me1+oJICsXM/Honee56OF6na2Z0Qe5yGdxkxw7as4C5ZgfzMtjQlpHfnmNak4ps01w
         DxFLH3IDfdqPaUuCb9yLX6dg3RNuritgPghiVHkqFJHFBJvS+CHD7DR+MB4LVcq6YZdD
         iFC35b73L3K0ItwA2PUAQsTkcLCacyl0w2WtTs3iLRB4d4Jw75w0wSxcbsSOpDooGsQr
         NOO1CCqzrxph4RjD11FMIiiOYGTm3xlf9u7EovjM6KmpPhK8t5O85LZN1OB7aQpX5hlW
         hGPrprBRcItrz4FhcKYLiwtGPoo28sIbRahPRTA5i5vcRS4YmFC8VtHoW8uAv/KNZAaY
         NrMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tvy9sjWqnF7JDLiqaC+vIZWUwHqerNYoWSgKZH8wt6M=;
        b=GtEqCVlgcxvYQ0+BEJD86EnBQLkhdadXVKsaB/kZT83cOg+XcmNe0uAJLs2J5fOd4P
         ehInwI9cKRUMyir0LyIMLHlBbMqYOK6tMUA5aSpQd6yL/cQ5VN4ZCI4OgyfKeB/d3BlA
         A5/IOzUHMxmwBBokerDdhjyV0+imfWn8/zr9Rs/LVzawbTaMSX7UpJJEXBukBkyqmgYe
         rg9KVZqMhssvZwHg8M7LNSHyDOjSEK2ighIziFrjeXNPXTaZUTs3WSAdUH2oD003fnZk
         rcF7qijYcKlqRGU/Y7pe3inG6CvKFt1Ttj8+Q939qFq/6l/V7wylnFDzKrFws/mcEMVs
         X8Ow==
X-Gm-Message-State: AOAM532vFdC9AvAwIh1hnex+4Q74DygBotFXGyB2vBuetlT46J8OKNfs
        xO5ydDAkT4HwZ1p5P9rB6cm69Q==
X-Google-Smtp-Source: ABdhPJzyI0QDlQb9VCOlfpWW47x4/lUh4o18JWTGrDq9omVNi86NR1NQOYD6sx1HCX1/v89M9XzJIA==
X-Received: by 2002:a63:144e:: with SMTP id 14mr23922285pgu.53.1619561091467;
        Tue, 27 Apr 2021 15:04:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id in1sm2965300pjb.23.2021.04.27.15.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 15:04:50 -0700 (PDT)
Date:   Tue, 27 Apr 2021 22:04:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        srutherford@google.com, joro@8bytes.org, brijesh.singh@amd.com,
        thomas.lendacky@amd.com, venu.busireddy@oracle.com,
        Ashish Kalra <ashish.kalra@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        x86@kernel.org
Subject: Re: [PATCH v2 1/2] KVM: X86: Introduce KVM_HC_PAGE_ENC_STATUS
 hypercall
Message-ID: <YIiKf21hqOo4W17H@google.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
 <20210421173716.1577745-2-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421173716.1577745-2-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 21, 2021, Paolo Bonzini wrote:
> @@ -8334,6 +8350,26 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_PAGE_ENC_STATUS: {
> +		u64 gpa = a0, npages = a1, enc = a2;

newline

> +		if (!guest_pv_has(vcpu, KVM_FEATURE_HC_PAGE_ENC_STATUS)
> +		    || !(vcpu->kvm->arch.hypercall_exit_enabled & (1 << KVM_HC_PAGE_ENC_STATUS)))

|| on previous line, pretty please :-)

> +			break;
> +
> +		ret = -KVM_EINVAL;
> +		if (!PAGE_ALIGNED(gpa) || !npages ||
> +		    gpa_to_gfn(gpa) + npages <= gpa_to_gfn(gpa))
> +			break;
> +
> +		vcpu->run->exit_reason        = KVM_EXIT_HYPERCALL;
> +		vcpu->run->hypercall.nr       = KVM_HC_PAGE_ENC_STATUS;
> +		vcpu->run->hypercall.args[0]  = gpa;
> +		vcpu->run->hypercall.args[1]  = npages;
> +		vcpu->run->hypercall.args[2]  = enc;
> +		vcpu->run->hypercall.longmode = op_64_bit;
> +		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> +		return 0;
> +	}
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
