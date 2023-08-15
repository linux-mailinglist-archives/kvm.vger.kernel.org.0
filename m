Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6208D77D67D
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 01:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbjHOXCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 19:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbjHOXCM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 19:02:12 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EF01FC7;
        Tue, 15 Aug 2023 16:02:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6887b3613e4so245254b3a.3;
        Tue, 15 Aug 2023 16:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692140530; x=1692745330;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNpDKDCZDD5WexNj/cj/aiOz+RKCFDny2Mo09Q2qH44=;
        b=aFUJ2SEMYYNcqH/i8LJ3DWP3hh8rDK3GtHkvERq1G8lGSIEJ4MYVw/Ly9vAQCpaJLI
         rHzPCIBTe4S74uOPShoPAEzivYpNXhb/Xrf3IMQLPq37ywhQUn2A4x49mWtXdGIAPrS0
         Q9YFE4ZygTXFi6oHiGewVzZYBol64xlDTEDBMd56mtAosjl3CjsxLtZV2rmTVXPNUrQU
         ezrMNHe3rOTaA5l6henTKYotwEer4obqIZolVi/ZlszpIf5eBDQKT/7wQJxP/IYPYfwP
         EOuIAs08FbIP35pqe6iIDdXKVnR+OpYZM5pEldu4Z9EtIrVndtPbyJLBlZyVFW+ZctPW
         drLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692140530; x=1692745330;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xNpDKDCZDD5WexNj/cj/aiOz+RKCFDny2Mo09Q2qH44=;
        b=Q/jBsfc8l7VKsqV6I3GORLsT/Z9TLtyxAc21q0F+1p3zOhcynWUFI2eAcD3bcAHfj6
         9hu2aIf+RlUQj+d/nMumzNyjdHSg/E7RPaXPyMHjz51UMGPjsvmYYm1v3xIhiaqpvbXY
         s0h/oGfxn0jXUp8aiwm7osflj96c3BrpzIg5Q3htg7sOaK8piqWGZ7H7nqgp/SRdg8k8
         nEr7XEQlzSkgCowOIXRKmXcliWYU+JoCyhY/GuMbvYbivg7OGakj9P129ULXUHOsYDCD
         Nb6L0wkrRjP6KvHMJHkcTiPElLJcvrygLfw9IsYiwiaN2gFL0sKREDEVooNIgeL4M7rQ
         D/JA==
X-Gm-Message-State: AOJu0YyCKNXVAPISJM3X6A50Nt+VFj2VUjAlzGH5WeEiS863shGeVxgf
        8VEBsbJzwmswhZhpC0jH5UU=
X-Google-Smtp-Source: AGHT+IFa8lH1VeD1bxeTZcgSXqR7B1RW6dXnxF2zzq2G3IXv0ZUjqDxLEy3u3wV0POYgU7ve/4nMlw==
X-Received: by 2002:a05:6a00:3907:b0:66a:48db:8f6a with SMTP id fh7-20020a056a00390700b0066a48db8f6amr199340pfb.12.1692140529814;
        Tue, 15 Aug 2023 16:02:09 -0700 (PDT)
Received: from localhost ([2601:647:4600:51:4685:ff:fe0f:d124])
        by smtp.gmail.com with ESMTPSA id s14-20020a62e70e000000b00687196f369esm9780651pfh.62.2023.08.15.16.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 16:02:08 -0700 (PDT)
Date:   Tue, 15 Aug 2023 16:02:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: Re: [PATCH v15 059/115] KVM: TDX: Create initial guest memory
Message-ID: <20230815230207.GA1436700@private.email.ne.jp>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
 <19a589ab40b01c10c3b9addc5c38f3fe64b15ad0.1690322424.git.isaku.yamahata@intel.com>
 <CAAhR5DG8hHKVjoN+pWKBVivSm8zkBX5NMbKAuWUL2Tkhaj1YRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhR5DG8hHKVjoN+pWKBVivSm8zkBX5NMbKAuWUL2Tkhaj1YRQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 11:50:02AM -0700,
Sagi Shahar <sagis@google.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e367351f8d71..32e84c29d35e 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
...
> > @@ -1215,6 +1271,95 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu)
> >         tdx_track(to_kvm_tdx(vcpu->kvm));
> >  }
> >
> > +#define TDX_SEPT_PFERR (PFERR_WRITE_MASK | PFERR_GUEST_ENC_MASK)
> > +
> > +static int tdx_init_mem_region(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > +{
> > +       struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +       struct kvm_tdx_init_mem_region region;
> > +       struct kvm_vcpu *vcpu;
> > +       struct page *page;
> > +       int idx, ret = 0;
> > +       bool added = false;
> > +
> > +       /* Once TD is finalized, the initial guest memory is fixed. */
> > +       if (is_td_finalized(kvm_tdx))
> > +               return -EINVAL;
> > +
> > +       /* The BSP vCPU must be created before initializing memory regions. */
> > +       if (!atomic_read(&kvm->online_vcpus))
> > +               return -EINVAL;
> > +
> > +       if (cmd->flags & ~KVM_TDX_MEASURE_MEMORY_REGION)
> > +               return -EINVAL;
> > +
> > +       if (copy_from_user(&region, (void __user *)cmd->data, sizeof(region)))
> > +               return -EFAULT;
> > +
> > +       /* Sanity check */
> > +       if (!IS_ALIGNED(region.source_addr, PAGE_SIZE) ||
> > +           !IS_ALIGNED(region.gpa, PAGE_SIZE) ||
> > +           !region.nr_pages ||
> > +           region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
> 
> During an internal security review we noticed that region.nr_pages is
> always checked after it's shifted but when it is used it is not
> shifted. This means that if any of the upper 12 bits are set then we
> will pass the sanity check but the while loop below will run over a
> much larger range than expected.
> 
> A simple fix would be to add the following check to test if any of the
> shifted bits is set:
> +           (region.nr_pages << PAGE_SHIFT) >> PAGE_SHIFT != region.nr_pages ||
> 
> Reported-by: gkirkpatrick@google.com

Thank you for catching it. I ended up with the following check.

  region.nr_pages & GENMASK_ULL(63, 63 - PAGE_SHIFT)

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
