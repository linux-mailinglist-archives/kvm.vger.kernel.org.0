Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B503CABFF
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 21:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244271AbhGOT1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 15:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245494AbhGOTYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 15:24:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CE6C08E88F
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 12:05:50 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so4884019pjb.0
        for <kvm@vger.kernel.org>; Thu, 15 Jul 2021 12:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=95Ws8SoLDeiiC/xhmaFN6B+CWti1BA+DLMkI6ssQcrc=;
        b=bXgqBDsfHWFL6lNl+ymP4+ZDG2O7lhysegxs2WgM1sb+KDzSHsLee4tCgbCcHbjBwK
         ut8YjXqdfcqQSdkyeY4ORZsTR7LrvSTAKQzKDj1lBTtmochzK9Bvy1DdZvOjqiVAfkyA
         pMakKFR7BPLQJBJl84dBFUeRatT5TG7AYBby0sznDUUSRsnfWpfYH5UJXDRXer8bYXqw
         /gokUDRqvJPDMNRdAo91HtpubE3Bi0UDgJ2V4k8NwLlVRPY1REiO/axpAcWWZ62Jot1y
         1DGUNW4EQp5T+C3sKvArazOa5s77xxev9/50SWdn60cM+Lai05BEmNHYlUjlUUa7WeYD
         OY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=95Ws8SoLDeiiC/xhmaFN6B+CWti1BA+DLMkI6ssQcrc=;
        b=MP/prJ2lIW2xeto92ZnXRTa40oKzWDyjLYHaAHoiF/179NcyCD/14aaHgH9xfZ9sGQ
         bnmvpQlv/dHcJdeiulgRFb+crRtS4ov9AntFBPuwkNnMepTTtK57kuVbMemOyIZZZMJS
         2xOfIU66uG9mGzpcH0f3CDK0MFPiag85z6s1AAuG3YpEQd52Y+rivOz4gY7j3O4I0cGz
         P9I+zDwx81qflUnO4Lb30QMx8a8bhvT51eqXvJy10TBkFPfXZz5OYADQNp6DgV+/qREx
         BSIZHd9lPV51nkXPys+lufAB7xDyFZqlnqvKzeBjcQPbuE5DxvOcAD6ahRqLXI3Q3UrH
         mO8Q==
X-Gm-Message-State: AOAM531/TTnRKVHXnpZxEJy4rZqD2mBH4dZFOUmt6qlWmUvtQGXHNB5y
        8OEFVLWMXlpKId+61DYuliMtzg==
X-Google-Smtp-Source: ABdhPJx388Ovjy8T8KG/KZjsWpsxdyCjDHlh69BUYNbAAAuCfGgp9HGfgp34yhD86wCKMusZ2YWj/A==
X-Received: by 2002:a17:90a:9f91:: with SMTP id o17mr11395903pjp.29.1626375949904;
        Thu, 15 Jul 2021 12:05:49 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a22sm7352206pfv.113.2021.07.15.12.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 12:05:49 -0700 (PDT)
Date:   Thu, 15 Jul 2021 19:05:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org
Subject: Re: [PATCH 1/2] nSVM: Add a variant of svm_vmrun() for executing
 custom guest code
Message-ID: <YPCHCX7rBvKXI0Ts@google.com>
References: <20210715180824.234781-1-krish.sadhukhan@oracle.com>
 <20210715180824.234781-2-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715180824.234781-2-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021, Krish Sadhukhan wrote:
> Current implementation of svm_vmrun() and test_run() sets the guest RIP to a
> wrapper function which executes the guest code being used by tests. This is
> not suitable for tests like testing the effect of guest EFLAGS.TF on VMRUN
> because the trap handler will point to the second guest instruction to which
> the test code does not have access.
> 
> Therefore, add a variant of svm_vmrun() that will set the guest RIP to the
> actual guest code that tests want to test. This will be used by the next
> patch in this series.
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm.c | 14 ++++++++++++--
>  x86/svm.h |  1 +
>  2 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index f185ca0..50b6a15 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -227,9 +227,9 @@ struct svm_test *v2_test;
>  
>  u64 guest_stack[10000];
>  
> -int svm_vmrun(void)
> +static int _svm_vmrun(u64 rip)

I'd prefer to stay with the kernel style of two underscores for inner helpers.

>  {
> -	vmcb->save.rip = (ulong)test_thunk;
> +	vmcb->save.rip = (ulong)rip;
>  	vmcb->save.rsp = (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
>  	regs.rdi = (ulong)v2_test;
>  
> @@ -244,6 +244,16 @@ int svm_vmrun(void)
>  	return (vmcb->control.exit_code);
>  }
>  
> +int svm_vmrun(void)
> +{
> +	return _svm_vmrun((u64)test_thunk);
> +}
> +
> +int svm_vmrun_custom(u64 rip)
> +{
> +	return _svm_vmrun(rip);
> +}

Why bother with the "custom" wrapper?  Just expose the inner helper.
