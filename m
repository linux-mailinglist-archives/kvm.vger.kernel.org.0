Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E235A9D7E
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 18:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbiIAQtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 12:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiIAQtH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 12:49:07 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0AC98589
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 09:49:06 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id g5-20020a4ac4c5000000b0044af7c8c4b3so3136402ooq.1
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 09:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Dk92OPS4QuOf8RnofQ74QJW3xdAQdyp1diADNixFBw8=;
        b=gcXzGo9RnujNWZTB/HJtIFcJQkhQSznUQxZlN1jhZ1vEsqpHOX8/heRIvFuatd6L0a
         81wDu9fcWsB5OzflgUTyTDVSwxftwEn+444s59coj4dvGevj6mSM4fZ+RqiQffMYcoVO
         mwVGS6iyQOCmNGiEvddjOZZa77rY3epCncuBjCjRxqgAi7Eq/fEITdPbEsLT0AJ7CtUE
         qI1Qxl2Wc7kMvBpEaZqQSGipk3QEgvke9FAbn70pBkt5P/1DPG1XHvjXgQndt0Xp5Bjt
         lA2SLxC37fCZ54f1rS3cBrIVew75/hnIusxBxmoOwWn0Yd7hOPeWvMJzlf41wS5TmD6q
         Bgpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Dk92OPS4QuOf8RnofQ74QJW3xdAQdyp1diADNixFBw8=;
        b=kCav88nFsCBUYRnJWJe3fGXdd8eI4DHFPVe1C6Cy/pCapF6/u6obhhYOR/G5Uuu48h
         3/sDdzajHnjfpBmZtTBnaaIgAIsM/ATWEBXxXWLVCmI31R1ABf75PdvgKImNrpKgAtZZ
         SNNhYh9cnak7Paof7TtF2XN6EBLgmaYiUYroQWfF0XwZ01L6auxkAFnvhBX3mMq+XjVZ
         JVOzqMKli7G8YkDwr+iRJdrXxlwebQHmD4kI98X7fTy0kHzDHHMjWS7Yu+OeHrK/XUo+
         XC9U4w4GKzXoqNju7kwJI/LoQQ+t2Xzt9gHHMJBiKxI178KqGR0Vt77S+BQLbqQJQm7q
         kBDQ==
X-Gm-Message-State: ACgBeo2Xs5KKrsNUrJFsW8XFaUSDCbWAb9JjaSMkJQeqz3vGD22KVWew
        yQdcyWjP/EifCrlCoa7iH720b+EgDTFy62Ao4+YJ6Q==
X-Google-Smtp-Source: AA6agR4RYCaxAhCsl9zntPXvgm5prBQLLUHq4Z5vH2R/iq0/2RImrxeFw59kn5p/Em355q/9y22DoOT/o3MCNmwYsQ4=
X-Received: by 2002:a4a:d41:0:b0:44a:8081:733c with SMTP id
 62-20020a4a0d41000000b0044a8081733cmr11048854oob.71.1662050945270; Thu, 01
 Sep 2022 09:49:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com> <20220826231227.4096391-5-dmatlack@google.com>
 <20220830234513.GA2711697@ls.amr.corp.intel.com>
In-Reply-To: <20220830234513.GA2711697@ls.amr.corp.intel.com>
From:   David Matlack <dmatlack@google.com>
Date:   Thu, 1 Sep 2022 09:48:39 -0700
Message-ID: <CALzav=dLSwM50=wnia_=k=Q53fHZer0TdAF7y_csC+DOWifQzw@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] KVM: x86/mmu: Handle error PFNs in kvm_faultin_pfn()
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022 at 4:45 PM Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
>
> On Fri, Aug 26, 2022 at 04:12:21PM -0700,
> David Matlack <dmatlack@google.com> wrote:
> >
> > @@ -4185,15 +4181,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >       fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, NULL,
> >                                         fault->write, &fault->map_writable,
> >                                         &fault->hva);
> > +
> >       return RET_PF_CONTINUE;
> >  }
>
> nit: unnecessary code churn.
> Otherwise, code looks good to me.

My mistake, thanks for the catch.
