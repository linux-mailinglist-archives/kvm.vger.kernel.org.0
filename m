Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB57581C7D
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 01:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiGZXmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 19:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiGZXmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 19:42:05 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A6D183B6;
        Tue, 26 Jul 2022 16:42:05 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 23so14429819pgc.8;
        Tue, 26 Jul 2022 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uajGByBwmJBtRXdtEgHNvuYygiAj9bOQyZ9TwhkQwZc=;
        b=nGkq57BehddFLQp1Mq++xeiMsD25H7Y/EdKGZP5iU92WLNXQ2RXplicPL99p4O+GNh
         2JxZ0wuz+Yt0JnWyLOZaTCN2P4PiUF9DelflAuEIkN4d1QZMse7AQbAMLYtS+3X9P7wk
         /S6AygTLNb24qPKx9ZMRUzRrqPbC329UbAwYfIrEOERXD1zqNgefoqRB+PycGZh577yM
         kZidNbfsZxti5Y+L5b2PqDTo/V6P+VfPYdAcZ7kJfcvW55YEx0QT7wZRULilyYru1hMO
         qqGVcrhBjRt2sKXwEu7b9HTid+84WEXtaMF95H6GTo3rqAEJkYl6zjfUx3pzZL+mYnhE
         f1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uajGByBwmJBtRXdtEgHNvuYygiAj9bOQyZ9TwhkQwZc=;
        b=dkpEuGrXygAHigvdkYPOOshgaWnfGocq6+Z/56yI1kP6wlYmcB6pLnpbgjhD9syQzG
         gceatr3bj0wOLSykI5uvG1YmVoXMxKCi07tJqRsbW5U2DXMrTXZZzw2N5tCoGJlIQknQ
         uicpMdsmZmR/OiZJFSt0PYa7GMPV9LmbJ1Jbmc3deT9BvyviTXEHlqNIezLweauypu3s
         SqAkXYoxrln02BTlY5jMlcbb2JTpx/Cxy0H/nhB/l+J7yMG6ibStKfUVwExU2xTGKZ1/
         sys78HJ7FmDPIjL2YCwGmBXAG3g57HyfiDhxD0GHmT+UfSR1MhLWozq1/QnjSNufDRn0
         ISBA==
X-Gm-Message-State: AJIora9Nnzz5CXgHjoENAvZGQz+/27K/ER2XZZ+2FFQV7IEK4xNbtgoe
        4wGsczSElEgCorpksAmXpxX/b1ucNxA89g==
X-Google-Smtp-Source: AGRyM1sWRnfK0RAsivOiFWqt5xy/3ijvpmxV6u95zaZuZGxs7bwdyzmSewPtxjTgqIMwuQSkppVr1g==
X-Received: by 2002:a63:2bc1:0:b0:412:706e:73ad with SMTP id r184-20020a632bc1000000b00412706e73admr16025972pgr.488.1658878924520;
        Tue, 26 Jul 2022 16:42:04 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id u3-20020a626003000000b0052513b5d078sm12287921pfb.31.2022.07.26.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 16:42:04 -0700 (PDT)
Date:   Tue, 26 Jul 2022 16:42:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v7 046/102] KVM: x86/tdp_mmu: Support TDX private mapping
 for TDP MMU
Message-ID: <20220726234203.GE1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <94524fe1d3ead13019a2b502f37797727296fbd1.1656366338.git.isaku.yamahata@intel.com>
 <20220712023657.zd6raab553kofxsc@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220712023657.zd6raab553kofxsc@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 10:36:57AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> > index 62ae590d4e5b..e5b73638bd83 100644
> > --- a/arch/x86/kvm/mmu/paging_tmpl.h
> > +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> > @@ -877,7 +877,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >
> >  out_unlock:
> >  	write_unlock(&vcpu->kvm->mmu_lock);
> > -	kvm_release_pfn_clean(fault->pfn);
> > +	kvm_mmu_release_fault(vcpu->kvm, fault, r);
> 
> Do we really need this? Shadow page table is not supported for TD guest.

For consistency. pair of kvm_faultin_pfn() and kvm_mmu_release_fault().

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
