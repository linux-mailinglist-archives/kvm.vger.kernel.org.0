Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001ED5456DC
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 00:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240262AbiFIWDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 18:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiFIWDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 18:03:47 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC50D1BC7A7
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 15:03:46 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id w21so22271885pfc.0
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 15:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=3fLDJMra1cUxw9Bo4bBFiSvY30gHtTJK+K8BSr9H0Go=;
        b=POznO7xtc2EQgGT0gPSrVacX0jcpWt2L3jbI0eiEEYlfs4JumePLV0iGTAXknAWm6m
         lDAj+T1MHJrdj/Ry519PbjfDaQ0SxII74FTo7Iv9IigvI7cn/48MK8aL/MatDY/CHfuY
         cAvZQKdwpHl7kzXwy7GVnzAVfwA/LOpE/7+BioTRLNFwLFAo0XKxG6QTs5EMTo36Vabh
         bZul8e7P/jYPGUp59mAb39jbfqZzWW4OJrRUoNNSp3TbkUSa2MiUToViyjuq40cFctkQ
         w6YYPxN5h0PgIPBPr2z9elmpSnopKY3KdxafYkrRoFXdIyJeopvmPaNKy+uCX8oD4nPk
         HX5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=3fLDJMra1cUxw9Bo4bBFiSvY30gHtTJK+K8BSr9H0Go=;
        b=60wdPxmFzaxCnagRmP5sGaFYi/MakhvSijpCTM4HJY3yYoSJ9VtQsC9Qzr6fyAhTvD
         YgApTOItF7DMG7b82T+EEcBiT+GBSy8o/rRYy7RmwsDD6SKfDWk8LLZHGMlSpQoQarOI
         XwToy89ip5BWYYy5pv2+xTG0VCnX5RrylCROSFjIlgowpv3CMH6kiJpekcaHROYVQqj6
         AtH7HK2WRXUdz8ff4JTfywovIBprXi3N3wEBjwTLnPmixf6yok6pOoss7klKP/bWQpZp
         /N6CE84XDr8Mj2z1oYxo7My9LdZ1K+CzbvzDEz+bu3b6bQfdWuA3+si5FIGiraZnXOE7
         d2IQ==
X-Gm-Message-State: AOAM5323Pog6FQ/HKWczQL0MnS0MbsOOJSCb3rwkn7E8zdjuUAS5K1kt
        KmOpJ3k3mXE0JT05Gx0MB2huNsZ6eRjltw==
X-Google-Smtp-Source: ABdhPJzS8zigFMeyYlo7wBfGOzlceycNVK55lDvzEix+3NPNnvtB6sA8xEoAifNgzxg6dil4LIOydQ==
X-Received: by 2002:a17:902:f682:b0:163:f4e9:5145 with SMTP id l2-20020a170902f68200b00163f4e95145mr41734336plg.63.1654812214372;
        Thu, 09 Jun 2022 15:03:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s142-20020a632c94000000b003f5d4d4f947sm17846640pgs.78.2022.06.09.15.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 15:03:33 -0700 (PDT)
Date:   Thu, 9 Jun 2022 22:03:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/6] KVM: x86: move all vcpu->arch.pio* setup in
 emulator_pio_in_out
Message-ID: <YqJuMki3oTJp7Qwu@google.com>
Reply-To: c@google.com
References: <20220608121253.867333-1-pbonzini@redhat.com>
 <20220608121253.867333-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608121253.867333-3-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Paolo Bonzini wrote:
> For now, this is basically an excuse to add back the void* argument to
> the function, while removing some knowledge of vcpu->arch.pio* from
> its callers.  The WARN that vcpu->arch.pio.count is zero is also
> extended to OUT operations.
> 
> We cannot do more as long as we have __emulator_pio_in always followed

Please add parantheses when referencing functions in shortlogs and changelogs,
I find it tremendously helpful.

> by complete_emulator_pio_in, which uses the vcpu->arch.pio* fields.
> But after fixing that, it will be possible to only populate the
> vcpu->arch.pio* fields on userspace exits.

Same nits about about pronouns.  In a similar vein, be explicit about what "more"
mean; I had no idea what "more" meant until the second sentence.  E.g.

  The vcpu->arch.pio* fields still need to be filled even when the PIO is
  handled in-kernel as __emulator_pio_in() is always followed by
  complete_emulator_pio_in().  But after fixing that, it will be possible to
  to only populate the vcpu->arch.pio* fields on userspace exits.

> No functional change intended.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/trace.h |  2 +-
>  arch/x86/kvm/x86.c   | 18 ++++++++++--------
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index fd28dd40b813..2877c0e92823 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -154,7 +154,7 @@ TRACE_EVENT(kvm_xen_hypercall,
>  
>  TRACE_EVENT(kvm_pio,
>  	TP_PROTO(unsigned int rw, unsigned int port, unsigned int size,
> -		 unsigned int count, void *data),
> +		 unsigned int count, const void *data),
>  	TP_ARGS(rw, port, size, count, data),
>  
>  	TP_STRUCT__entry(
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2f9100f2564e..8e1e76d0378b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7416,17 +7416,22 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
>  }
>  
>  static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
> -			       unsigned short port,
> +			       unsigned short port, void *data,
>  			       unsigned int count, bool in)
>  {
> -	void *data = vcpu->arch.pio_data;
>  	unsigned i;
>  	int r;
>  
> +	WARN_ON_ONCE(vcpu->arch.pio.count);
>  	vcpu->arch.pio.port = port;
>  	vcpu->arch.pio.in = in;
>  	vcpu->arch.pio.count = count;
>  	vcpu->arch.pio.size = size;
> +	if (in)
> +		memset(vcpu->arch.pio_data, 0, size * count);
> +	else
> +		memcpy(vcpu->arch.pio_data, data, size * count);
> +	data = vcpu->arch.pio_data;

Oof, passing NULL for @data and then overwriting it below is gross.  It also makes
@in redundant for this one patch.  Might be worth adding a comment, even though
it's transient?

>  
>  	for (i = 0; i < count; i++) {
>  		if (in)
> @@ -7454,9 +7459,7 @@ static int emulator_pio_in_out(struct kvm_vcpu *vcpu, int size,
>  static int __emulator_pio_in(struct kvm_vcpu *vcpu, int size,
>  			     unsigned short port, unsigned int count)
>  {
> -	WARN_ON(vcpu->arch.pio.count);
> -	memset(vcpu->arch.pio_data, 0, size * count);
> -	return emulator_pio_in_out(vcpu, size, port, count, true);
> +	return emulator_pio_in_out(vcpu, size, port, NULL, count, true);
>  }
>  
>  static void complete_emulator_pio_in(struct kvm_vcpu *vcpu, void *val)
> @@ -7505,9 +7508,8 @@ static int emulator_pio_out(struct kvm_vcpu *vcpu, int size,
>  {
>  	int ret;
>  
> -	memcpy(vcpu->arch.pio_data, val, size * count);
> -	trace_kvm_pio(KVM_PIO_OUT, port, size, count, vcpu->arch.pio_data);
> -	ret = emulator_pio_in_out(vcpu, size, port, count, false);
> +	trace_kvm_pio(KVM_PIO_OUT, port, size, count, val);
> +	ret = emulator_pio_in_out(vcpu, size, port, (void *)val, count, false);
>  	if (ret)
>                  vcpu->arch.pio.count = 0;
>  
> -- 
> 2.31.1
> 
> 
