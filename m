Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2482ED74F
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 20:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbhAGTNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 14:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729173AbhAGTND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 14:13:03 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5629C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 11:12:22 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id w6so4460105pfu.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 11:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zVzGJsdQVqDpHLWB0LlEUJh4H0AoOF8yrCl+fLtuTlw=;
        b=GWpjd66dYwwBJeB6IzgoL2wBiojB2Rn9bWYlB6Gg70BnkJmd/gdq6My1oEkvLkwLn6
         sQt6hZpr+gm9aqBkJXLmJeFGdh3Tw0WmzoZ5PTocMfXVC2n+v4hqT4Exq41GgcCIJW4O
         6KOPbGDYPmOvwG8TAjrscT1tJ8yz2C8gfAULls/nF3MYmthj4CDR9jj57f1ti6zaJmIe
         7l0+C4V4K6BCBZ3gYxAtg+eMFLWFMLn7RW6OnRP/8BuvdMjVwT7+hObm2hUdw3ZlKuYM
         aDjzmm1W2qPZzHywdqcVz4NHpAhXtx7gEazlQO7b/g9AhSCUurRB2PLu0sveASjDNX/n
         d7tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zVzGJsdQVqDpHLWB0LlEUJh4H0AoOF8yrCl+fLtuTlw=;
        b=N80HPuFIhjF8bK+THFGwzSN06HPpOsUf1iGnGqPgQciqsn+ZhLJ/NPictDPHLpxxV2
         Ap/2QnvCqxw9Z3fsSOMZ0Nm0t6R2zz3yPU9MpNf528gL+WxuiOTDQ7+mY/R5EHlE7hRu
         02h58ieBolfWdBTBOTksIH6LLDKKTcyTZCcijf+Xwzx69z+Ijo0PNwH7Cei3xbSwiXze
         ZSXk9krP+T/CEISCTvsTbC9D/zywIzSzSIFY2DLXlF32g9gCMyLic+o1+IiLfd77tkFA
         ExKhIcbK/esUv07y7jAta29mhkH0dsC6dqWVK0svh8fS+aoRwd3ZWAp+O5RdQ1AZ4hPC
         xtOQ==
X-Gm-Message-State: AOAM533QDNM/MaO0EdUAUKczeHvSe/4uznHTd1oTI2d+PB/Hspd5UMuf
        FYyeqVwxDFHXqQHgb84e51SLufshxj+bqg==
X-Google-Smtp-Source: ABdhPJwY4s3CnplioBJ5tQsqCDh/uml54mMwojBSfAu4mQMnp0fH0SQtPUforHn4d+qTRBMsfimeQQ==
X-Received: by 2002:aa7:9357:0:b029:1a5:43da:b90d with SMTP id 23-20020aa793570000b02901a543dab90dmr236269pfn.54.1610046742056;
        Thu, 07 Jan 2021 11:12:22 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id a2sm7110822pgi.8.2021.01.07.11.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 11:12:21 -0800 (PST)
Date:   Thu, 7 Jan 2021 11:12:14 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/4] KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
 on nested vmexit
Message-ID: <X/ddDofjpBVO07/P@google.com>
References: <20210107093854.882483-1-mlevitsk@redhat.com>
 <20210107093854.882483-2-mlevitsk@redhat.com>
 <X/c+FzXGfk/3LUC2@google.com>
 <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d7bac03-2270-e908-2e66-1cc4f9425294@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 07, 2021, Paolo Bonzini wrote:
> On 07/01/21 18:00, Sean Christopherson wrote:
> > Ugh, I assume this is due to one of the "premature" nested_ops->check_events()
> > calls that are necessitated by the event mess?  I'm guessing kvm_vcpu_running()
> > is the culprit?
> > 
> > If my assumption is correct, this bug affects nVMX as well.
> 
> Yes, though it may be latent.  For SVM it was until we started allocating
> svm->nested on demand.
> 
> > Rather than clear the request blindly on any nested VM-Exit, what
> > about something like the following?
> 
> I think your patch is overkill, KVM_REQ_GET_NESTED_STATE_PAGES is only set
> from KVM_SET_NESTED_STATE so it cannot happen while the VM runs.

Yeah, which is why I was hoping we could avoid clearing the request on every
nested exit.

> Something like this is small enough and works well.

I've no argument against it working, rather that I dislike clearing the request
on every exit.  Except for the ->check_events() case, hitting the scenario where
there's a pending request at the time of nested VM-Exit would ideally be treated
as a KVM bug.

On the other hand, clearing nested-specific request on nested VM-Exit is
logically sound, so I guess I'm ok with the minimal patch.
