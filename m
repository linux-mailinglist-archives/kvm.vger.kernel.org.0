Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBC53E1F02
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbhHEWpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240914AbhHEWpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:45:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF56C0613D5
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 15:45:03 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso13197705pjf.4
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 15:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4BfhlnmFVBH/5WZ+qdtlmbrJsorAcYIvFXwLK0XohYE=;
        b=dv98SU3dX8RvvgAVciCvnnGdC9GdQBT286CvsF4rU/Akmb+g2mgUeL6+xZTH19oea+
         PnZBh41abYDMAqjnI9FTwv3orGtpr5ZlF6Oz4r/RkL+jkAalhQf8XE20g/a3UJUf4gLY
         hfyzyBdWheKYTHb9xX/jYAyv8xfKYxfl9z7yQuPHFBtm5In6vHlXrcgEGy/lFJxQq9VB
         oDspbK92DQPxh4tua6tBF6eu5oPbIZep2J9Nr2QYPTmTXwQ6vUFd+VzQb2c71QQYU3PU
         A30umMTNbWF3Fbp/2BRmhGpW/vzx9JMFjtQGysO9xL0mM6utCdWnsnhuiEOw1OjNOYjw
         HbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4BfhlnmFVBH/5WZ+qdtlmbrJsorAcYIvFXwLK0XohYE=;
        b=RP99QvhLwbCait6ECbbNvrzSlN+MgJOk6KswrK10g2kVNFaDcVEjnyvTk9Wu6QHPXg
         FLIBZgXvojrPpv3K988w8AlZnBx2aQFs9rHtJRD/dOFnvYH/hQ/j0HcJ3whyjAIWSaI3
         6gyYn/fohIeVoe1HpgxDLinktextlhjSeNNTDpbmra2WKhJuYbZg79fZBjDqB37vPzDT
         lckhdTQ5IzqH8yup2HT0S2W264Mxab86EXiKsrmEkJlrOi5FEHbq4oTLtsVDU8Rh9Qzt
         xNyU6+/6Nc2fo0XoViNgGTzy3xq1ObF7+TZjTSELIvEHj7FAYOHd32eONgw8mhBNBL8d
         ujGQ==
X-Gm-Message-State: AOAM533Ex7PMdEX7wGag0IxJfuK5OR2HyDsSLGuDSidSDOCe4//Pfq8l
        s2z+0Jci58ySAF8DknSfbYJmJg==
X-Google-Smtp-Source: ABdhPJw4q5DAgxtnqJyDPEsfxXtC/QMaCaEKKBZ1CNwiagIlAz0LXZl+nmurr1SxbQ1y+AedALE82Q==
X-Received: by 2002:a17:902:bf01:b029:12c:d762:96c with SMTP id bi1-20020a170902bf01b029012cd762096cmr5872304plb.15.1628203503162;
        Thu, 05 Aug 2021 15:45:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d2sm9146309pgv.87.2021.08.05.15.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:45:02 -0700 (PDT)
Date:   Thu, 5 Aug 2021 22:44:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Wei Huang <wei.huang2@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com
Subject: Re: [PATCH v1 1/3] KVM: x86: Convert TDP level calculation to
 vendor's specific code
Message-ID: <YQxp6gg4W/pZsGuW@google.com>
References: <20210805205504.2647362-1-wei.huang2@amd.com>
 <20210805205504.2647362-2-wei.huang2@amd.com>
 <CALMp9eQ_SHmFn0ahTyOnyk+JDs_D0qxN9Hc9VFMGDDixc13jUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ_SHmFn0ahTyOnyk+JDs_D0qxN9Hc9VFMGDDixc13jUA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Jim Mattson wrote:
> On Thu, Aug 5, 2021 at 1:55 PM Wei Huang <wei.huang2@amd.com> wrote:
> >
> > This design assumes that all x86 CPUs have the flexibility of changing the
> > nested page table level different from host CPU.
> 
> I can't even parse this sentence. What are you trying to say here?

NPT inherits the host's CR4, and thus CR4.LA57.  So KVM NPT is stuck using whatever
N-level paging the host kernel is using.
