Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4524942961C
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 19:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhJKR5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 13:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbhJKR5q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 13:57:46 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CEC061570
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 10:55:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h125so5507119pfe.0
        for <kvm@vger.kernel.org>; Mon, 11 Oct 2021 10:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nXSnf3uwD4BHjHwEieIvu9mOpU3k2AcxP4+SqJSLu9c=;
        b=AkFrlihMIQ1QhP32hDNyZ0SP9eoy01+WG69np5nepFAlfbJERvWyNzKf05ONRSwds/
         7ESdHVOcMj+nRP+Th1Wdvpu/n+RA/p4OYSiHsOi9ollU7UqGfYS4vjWpPhBQOsklnWM/
         3+scu56T9DeK4rkl2cNozpQy7XemQzR0JroU6NG0Jxf2yRJwkfY4Xeaun7MyKHalGbrq
         TvU4C7HxC7ZcG7qi+8NmWnU7ovCf8Y+pYnuCFRQGQHAVB/QGxxx2WTcoUoIEakKDRVn8
         vbxqmF7nQM4kOjt8CYylsSiZx0079hF1Ej2txzjLVoLUISUghgBXhxRH0v0euu2zihkr
         QHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nXSnf3uwD4BHjHwEieIvu9mOpU3k2AcxP4+SqJSLu9c=;
        b=sKpmB0Z3OmXVdiDsQfYOxSrx11a813QKNFYQL4VLQX96xoNaPfXkoEBV0ch+IZhlf0
         vrGWE1Ev+FOp1yozIxVvFAaR29KbsUA210JH8ZcUD96LIqWajNlu7QTZz0mmGRAv4SJu
         +kvnZgjPK4eq2gVWdy7qbc7cVYNO8o97DX6hhAxqWjHW+EQVuUzvvsjD3AoEA1LD6Z0N
         hGXLgSTiDNlng4GQTw5zC+6vtQULIEfTBwQD5WRCHDcNH8OTITmt0x4pvJMVUqiuW4tv
         VoV0rAqEyJuB6MbsszCsk1dh1qsBlBAHM/smeiv1PeBNwZIiTXw7lE/XJKv++af47vYw
         Fb8Q==
X-Gm-Message-State: AOAM5307DWzLNNxIB8gsi9P1IWyDaPKL4S/y/quiTVxDr4IxEV1sjG6y
        Nj+V9+w/iaHsemOQDLlrYYdAcg==
X-Google-Smtp-Source: ABdhPJyILzC3JCIB1eIqwxmSw/iHOyiFDOmr2MJm/zr7SIquK4zRGR3RwJXRdAHbbQcQ5X5CsKEWRQ==
X-Received: by 2002:aa7:83d9:0:b0:44c:915b:8268 with SMTP id j25-20020aa783d9000000b0044c915b8268mr27513339pfn.43.1633974944994;
        Mon, 11 Oct 2021 10:55:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c142sm3654255pfb.9.2021.10.11.10.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 10:55:44 -0700 (PDT)
Date:   Mon, 11 Oct 2021 17:55:40 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: x86: Simplify APICv update request logic
Message-ID: <YWR6nJLdR21CbGtz@google.com>
References: <20211009010135.4031460-1-seanjc@google.com>
 <20211009010135.4031460-3-seanjc@google.com>
 <c446956c622d5f6561f5248c7f686033ffc2ee69.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c446956c622d5f6561f5248c7f686033ffc2ee69.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 10, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 18:01 -0700, Sean Christopherson wrote:
> > Drop confusing and flawed code that intentionally sets that per-VM APICv
> > inhibit mask after sending KVM_REQ_APICV_UPDATE to all vCPUs.  The code
> > is confusing because it's not obvious that there's no race between a CPU
> > seeing the request and consuming the new mask.  The code works only
> > because the request handling path takes the same lock, i.e. responding
> > vCPUs will be blocked until the full update completes.
> 
> Actually this code is here on purpose:
>
> While it is true that the main reader of apicv_inhibit_reasons (KVM_REQ_APICV_UPDATE handler)
> does take the kvm->arch.apicv_update_lock lock, so it will see the correct value
> regardless of this patch, the reason why this code first raises the KVM_REQ_APICV_UPDATE
> and only then updates the arch.apicv_inhibit_reasons is that I put a warning into svm_vcpu_run
> which checks that per cpu AVIC inhibit state matches the global AVIC inhibit state.
> 
> That warning proved to be very useful to ensure that AVIC inhibit works correctly.
> 
> If this patch is applied, the warning can no longer work reliably unless
> it takes the apicv_update_lock which will have a performance hit.
> 
> The reason is that if we just update apicv_inhibit_reasons, we can race
> with vCPU which is about to re-enter the guest mode and trigger this warning.

Ah, and it relies on kvm_make_all_cpus_request() to wait for vCPUs to ack the
IRQ before updating apicv_inhibit_reasons, and then relies on kvm_vcpu_update_apicv()
to stall on acquiring apicv_update_lock() so that the vCPU can't redo svm_vcpu_run()
without seeing the new inhibit state.

I'll drop this patch and send one to add comments, there are a lot of subtle/hidden
dependencies here.  Setting the inhibit _after_ the request in particular needs a
comment as it goes directly against the behavior of pretty much every other request
flow.

Thanks!
