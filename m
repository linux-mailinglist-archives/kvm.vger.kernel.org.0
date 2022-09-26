Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927CE5EB371
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 23:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiIZVps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 17:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiIZVpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 17:45:41 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05400A5730
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:45:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id w20so7405677ply.12
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 14:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=LU6EMhAQqyZeVBZagLqvgilvEHHLPOXcgccMpjKfJK8=;
        b=SdVlLvvVTMjaSi11aOpQfXHOJPWLl3QEHOjZ9TrE+4K2qZyGMe0R+vEU6OQvvGET5E
         RYq4938P0Cn8aSs4fMlWLo591kzRK3RjSAab7Q1Z3EJ2pxu2I+8OJ2I4Xk1nVoexS/JV
         SelTDURwvHOvANRxwwuBqduwi5tqlw8U0QyZMnqRLGYP9O962RG7uspZWOOjI/SDgD4W
         F2gYNxbyrys/T1KPXIX2X62lLwtXlZpvC2rcwOf2rTmdX6X3SfuYWPj3t2C13HX2CviB
         PhUhd7QW4Iy/jjZ2BNEX1IWY0Qi6Rrzyxj0oVs9QtMpwNOlYT1C+1IVp1QGxaSK1/I4M
         XLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=LU6EMhAQqyZeVBZagLqvgilvEHHLPOXcgccMpjKfJK8=;
        b=hFEcIVTI7JK4z5uHBTqLYyM+lY1INo4OSTTuabfY1oPoSuQYHfO0M039H2OIwz4Ap9
         ocSmAbqLdnYUgLQ4kkcZz8GJIXY4gR4sYop5dfqEn7qDpATtjRpkTbX8DdSudP5fdJWk
         KyP/0xPLlMYAcoz8ZdV3cvSsIDzWjraC5hv2Qch74jIwch6QAROzJoenXWadtU83jLVg
         gPmdtsv9Gxa0wivjQYJYOY5mFVD/0eVWw92UqKjMR3tcehBbmvPpMYBGjXD9Vm2QwgSO
         1nW8E3hNjXfO61ePjSuG6PLjCksBDqlJ2+4QOYhmSjVT6I8uLD/jhjgMJQ3ds7I7hHLq
         ukpw==
X-Gm-Message-State: ACrzQf1tQVkYsWKgeEhiM8mYAbFtiFqo8ydw8vWaKDRh2NQfpsbl+6oI
        aVDxwL3PkHz3lxHOQlDoxrR4eA==
X-Google-Smtp-Source: AMsMyM5iuBjmHtQ6842LnpNJ6lGgmd6alDfIJ1BUjSGlT55CYKJKOf6ev8jAA9rsOZQ09XERxL0TBA==
X-Received: by 2002:a17:90a:6405:b0:203:6eaa:4999 with SMTP id g5-20020a17090a640500b002036eaa4999mr888718pjj.8.1664228739239;
        Mon, 26 Sep 2022 14:45:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090a1f4d00b001fd7e56da4csm7081945pjy.39.2022.09.26.14.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 14:45:38 -0700 (PDT)
Date:   Mon, 26 Sep 2022 21:45:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Skip tests that require EPT when it is
 not available
Message-ID: <YzIdfkovobW3w/zk@google.com>
References: <20220926171457.532542-1-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926171457.532542-1-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022, David Matlack wrote:
> +bool kvm_vm_has_ept(struct kvm_vm *vm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	uint64_t ctrl;
> +
> +	vcpu = list_first_entry(&vm->vcpus, struct kvm_vcpu, list);
> +	TEST_ASSERT(vcpu, "Cannot determine EPT support without vCPUs.\n");

KVM_GET_MSRS is supported on /dev/kvm for feature MSRs, and is available for
selftests via kvm_get_feature_msr().

> +
> +	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
> +	if (!(ctrl & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
> +		return false;
> +
> +	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS2) >> 32;
> +	return ctrl & SECONDARY_EXEC_ENABLE_EPT;
> +}
> +
>  void prepare_eptp(struct vmx_pages *vmx, struct kvm_vm *vm,
>  		  uint32_t eptp_memslot)
>  {
> +	TEST_REQUIRE(kvm_vm_has_ept(vm));

I would much rather this be an assert, i.e. force the test to do TEST_REQUIRE(),
even if that means duplicate code.  One of the roles of TEST_REQUIRE() is to
document test requirements.
