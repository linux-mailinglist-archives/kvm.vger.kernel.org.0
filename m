Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E406050E1
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiJST4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 15:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiJST4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 15:56:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41115B12F
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:56:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id h13so18243454pfr.7
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 12:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHRehVb3nobhCxM9BGtj8DbvLG7cHiWYtLrCxEvN5bI=;
        b=oS3SEVJHqywnlUKVup1k6w7IO+6IXNKdfrBVo6MibuWnzfbCfXM0W6CN71Q1qz/NAb
         n4m9vglKu2RmZQMHn2HeOXpOP2yB92QQYrjK7eWN3xyQbY2ZgQfkECSo/shEw1VFwCed
         C3gK+pKBxbwVAEjJpqVflPzC9wCOoWgD/0CJMbRcA8PDFMsIiMwhv1FZyDXJ/hzuqckJ
         bocTnMYhA8lLepwCATRvQRv0mfUg0EZWmyS/S1V+6qQ3DEQ9O/Y/D/7c2J0DiHCuI+ns
         hg6ymWJSHfMoRiRjkFvrCFOy+UjbG8KUySmWu5nLFG3xSJhbigmGtZBhpMpMxgsCh//i
         aMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHRehVb3nobhCxM9BGtj8DbvLG7cHiWYtLrCxEvN5bI=;
        b=UAnpaNqziy7V9kwFi0f8mcxMBZSfCteQP52WAQktm9c7Lxt0K9yzCJmGLXHV2FoCQ6
         NDAz2w7wubCnwnSrZCB8dRnTich9g7gq7wP7s+ZatJtSbAm4wIuwHONxTqpSPqgsJeO9
         W3rrdsMMFLuwCVeMzSyRqE96m9xTvDkctwQyYhrOlqvOjKxv4ff18t3yZUSnk5pX20eL
         XbzAdAnOzlQ3oMdgAB0A1YyhwwL2toheFZZJWBIeFn1mGx80yk2K7CvRoNEA+OXJtL2C
         Z5OwXkBC5qM5A7ECNNpUDM5VhO0A777cVB64o5xBR/Q+h0i14lGquzlFMWSy0DsE3iYs
         vXoA==
X-Gm-Message-State: ACrzQf0FTIhXlD8s+tK2/kc597bW6HuPF8yWD5aGTFXsCWdBvZpDFP7J
        dznbAfNkEkvCHTdC7br8QJXjzQ==
X-Google-Smtp-Source: AMsMyM7FZ0WZqd37NvhSyoPssgJRo7cV4ZpZBlERJ02E7d49EnVDQvFWVmcZiKFGJuok+Pnngqmk6Q==
X-Received: by 2002:a05:6a00:1488:b0:563:9d96:660f with SMTP id v8-20020a056a00148800b005639d96660fmr10119527pfu.0.1666209367876;
        Wed, 19 Oct 2022 12:56:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k88-20020a17090a4ce100b00206023cbcc7sm342549pjh.15.2022.10.19.12.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 12:56:07 -0700 (PDT)
Date:   Wed, 19 Oct 2022 19:56:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 11/46] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <Y1BWU/95SXDu9yJL@google.com>
References: <20221004123956.188909-1-vkuznets@redhat.com>
 <20221004123956.188909-12-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221004123956.188909-12-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022, Vitaly Kuznetsov wrote:
>  int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
>  	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
> +	u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
> +	int i, j, count;
> +	gva_t gva;
>  
> -	if (!hv_vcpu)
> +	if (!tdp_enabled || !hv_vcpu)
>  		return -EINVAL;
>  
>  	tlb_flush_fifo = &hv_vcpu->tlb_flush_fifo;
>  
> +	count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
> +
> +	for (i = 0; i < count; i++) {
> +		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
> +			goto out_flush_all;
> +
> +		/*
> +		 * Lower 12 bits of 'address' encode the number of additional
> +		 * pages to flush.
> +		 */
> +		gva = entries[i] & PAGE_MASK;
> +		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +			static_call(kvm_x86_flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
> +
> +		++vcpu->stat.tlb_flush;
> +	}
> +	return 0;
> +
> +out_flush_all:
> +	kvm_vcpu_flush_tlb_guest(vcpu);

No need to do kvm_vcpu_flush_tlb_guest() here, the caller is responsible for
flushing on "failure", as indicated by -ENOSPC below.

>  	kfifo_reset_out(&tlb_flush_fifo->entries);
>  
> -	/* Precise flushing isn't implemented yet. */
> -	return -EOPNOTSUPP;
> +	/* Fall back to full flush. */
> +	return -ENOSPC;
>  }
