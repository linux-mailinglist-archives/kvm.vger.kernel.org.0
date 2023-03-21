Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8F56C3CC3
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 22:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjCUVfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 17:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCUVfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 17:35:36 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3744536FD2
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:35:36 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d5-20020a17090ac24500b0023cb04ec86fso5934978pjx.7
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679434535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CT/htnnAn/ooG8ZLwPOFS8UzYgo6pm63UMG8YjSKlAI=;
        b=hXl5d9DhNirXu45cFaB8nsrBMorOagxIDh97eJTbf388mqS5koHw82EJ3hZuXQw/wf
         wLYjGWXLS69FGWNGQDqrga9loIY3rtdkG7M8+qPRMY9hqfkjm68wxSWqxDj3npYoO1y0
         u1aSWnxjJrhvOPdf5uRVACQh8XgXxAdm3wVXe/o2AfeTLmXWErtxa7cdByNag+TOClzg
         /sKUO+d1VXP27SA8oth/+9q2+bJRUa+qTWQPTLL3bOMIaQTYSHmon85AqLJVe95Ay8fV
         KLmH4PAiG8kyj4CmcjMKvlvY8ulP0aIrxqe0X/x8ef16yaqO/BqqRv4rAFeq4RzY5YIl
         6gcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679434535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CT/htnnAn/ooG8ZLwPOFS8UzYgo6pm63UMG8YjSKlAI=;
        b=sBQGNlGyatBs2HHDEmuBOjeS8pXfQpRYS5aAlhFqnA3ALq569twBdZ3qV/D7CsLk9R
         yIVOH6794UlSCsI2Z/oGafD7hMQywS7NDDHCQJ7mdhJMtvRVdWM+PIqx7iO8LPIrIzOl
         ivgwoqfehiwX+Paqk3zb2b0Nt67/mPBmAOnw/P594ZNu8PAhSblacfLJsunD6DIDup55
         M6L3UOQ3P9+4dKxLdk/387Mv/QlVhICI7uqbp6uMfzv4BgaSzB8MTwY6DuwvBkOUeD/f
         imHGfzDaIdBvM01oMMmMJYwFYJZiMarcdlM8dxdUCC8EI/SlbPhYHXUhfE8jVl1lWTzx
         0p9g==
X-Gm-Message-State: AO0yUKV5hNIVtBeGwWR4P3Tu26cgzmyrRxdctAjxk5xb9JubPKIw5XPX
        oYwoqYtEDkoLE55hHKUFrFP1sq0LTpw=
X-Google-Smtp-Source: AK7set+1ali7XG/Jw5iiNAhipgMe5z+e4sb6wW41QGd/XltoVqqTsfRBarUw+Jb5zof3DoaF1O1Dp5V/JVc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:3293:b0:1a1:b3bb:cd5e with SMTP id
 jh19-20020a170903329300b001a1b3bbcd5emr191934plb.9.1679434535814; Tue, 21 Mar
 2023 14:35:35 -0700 (PDT)
Date:   Tue, 21 Mar 2023 14:35:34 -0700
In-Reply-To: <ZBhTa6QSGDp2ZkGU@gao-cwp>
Mime-Version: 1.0
References: <20230319084927.29607-1-binbin.wu@linux.intel.com>
 <20230319084927.29607-3-binbin.wu@linux.intel.com> <ZBhTa6QSGDp2ZkGU@gao-cwp>
Message-ID: <ZBojJgTG/SNFS+3H@google.com>
Subject: Re: [PATCH v6 2/7] KVM: VMX: Use is_64_bit_mode() to check 64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, robert.hu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 20, 2023, Chao Gao wrote:
> On Sun, Mar 19, 2023 at 04:49:22PM +0800, Binbin Wu wrote:
> >get_vmx_mem_address() and sgx_get_encls_gva() use is_long_mode()
> >to check 64-bit mode. Should use is_64_bit_mode() instead.
> >
> >Fixes: f9eb4af67c9d ("KVM: nVMX: VMX instructions: add checks for #GP/#SS exceptions")
> >Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
> 
> It is better to split this patch into two: one for nested and one for
> SGX.
> 
> It is possible that there is a kernel release which has just one of
> above two flawed commits, then this fix patch cannot be applied cleanly
> to the release.

The nVMX code isn't buggy, VMX instructions #UD in compatibility mode, and except
for VMCALL, that #UD has higher priority than VM-Exit interception.  So I'd say
just drop the nVMX side of things.

I could have sworn ENCLS had the same behavior, but the SDM disagrees.  Though why
on earth ENCLS is allowed in compatibility mode is beyond me.  ENCLU I can kinda
sorta understand, but ENCLS?!?!!
