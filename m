Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5553C390CFA
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 01:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhEYXgk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 19:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhEYXgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 19:36:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897AEC061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 16:35:08 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f22so23079326pgb.9
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 16:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Lxgxwvu6bAHcpIBi46sfdxXVLtVYTXMU6wXoIYMfsmo=;
        b=iMwF9Z55RdUMMmhqCYSVovxPUEagkTngm9ru8FdnFSF1csZzncsPoRuohZDl1LHKQe
         gya8NK5DEDRymB4uhEF/dm4tnjRJWoQD0yb9m+EHSejMhMxBJL+15CD1Cp8th4pCcYA9
         mCFldpKyYixTuCUtxP5zVbMtvfYY4YCWpKtnfGyADb3GCJ9+Q7osXRt2JHEh1dCSVucX
         qUn0qIoZLH0o1+YwWWcJVaoqIX5cY3snS09BFtVwvw+wgGdqfYuJWeNP6FLpaNANdwFE
         rRKJsdDN+hcAA+hOTmD6bIJ0yYIDI2ABRPhBr7As9OlMzfqq44KJX3dpUKd45+4dJHRk
         RLMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lxgxwvu6bAHcpIBi46sfdxXVLtVYTXMU6wXoIYMfsmo=;
        b=Z5Vc+SVhJBVipjFqhL1LyTydK97jCXlr/uDmp+nLs/BA7uPzdwWjFXI3WJ9Th2cXXB
         gqzQ+kvBUJLHP+e8KcCftaHOreMAOKZal9x/rnCVeMhqY+CHetqA2+ZrhYVr6bznanuW
         US9LPniOZJyg33MGajU3lF2ZsKnGzOptatExp+V3JAiDzWotDqUnNORRBQ4iMzJ04bcv
         bN1AQU3gwt7/uJ2pTHabaysbUBodIR3v4R2kIFRTlzzgQSD4FsAc0omNzxvm2BQHMRR3
         PQjOPRmLhY22BTbdWJCPAqtr1B454XHPGvrILDtY2c6VNfVNNIOrpAZCS2raRLTV7dKS
         Qmtg==
X-Gm-Message-State: AOAM530zhK3S5WsXyOspGD0zX/FrAnTtm0Rs34y65SCeh3kL8buqdCSi
        P+eXHRZV8unpnCIMopV6CmJtCA==
X-Google-Smtp-Source: ABdhPJzr+PEXMYZXU15SCAQLmYVDEP5e9yb/rTnDUO8P6McASC9IHAFm7vIdGRzrt9cwZYZ4huukeQ==
X-Received: by 2002:a62:f24b:0:b029:2dc:9098:c14c with SMTP id y11-20020a62f24b0000b02902dc9098c14cmr32335885pfl.19.1621985707873;
        Tue, 25 May 2021 16:35:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l7sm2864094pjh.8.2021.05.25.16.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 16:35:07 -0700 (PDT)
Date:   Tue, 25 May 2021 23:35:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Stamatis, Ilias" <ilstam@amazon.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "zamsden@gmail.com" <zamsden@gmail.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [PATCH v3 09/12] KVM: VMX: Remove vmx->current_tsc_ratio and
 decache_tsc_multiplier()
Message-ID: <YK2Jp2tZzIkik142@google.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
 <20210521102449.21505-10-ilstam@amazon.com>
 <2b3bc8aff14a09c4ea4a1b648f750b5ffb1a15a0.camel@redhat.com>
 <YKv0KA+wJNCbfc/M@google.com>
 <8a13dedc5bc118072d1e79d8af13b5026de736b3.camel@amazon.com>
 <YK0emU2NjWZWBovh@google.com>
 <6d18b842e1ab946da2e0ebfae79fc51c3193802a.camel@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d18b842e1ab946da2e0ebfae79fc51c3193802a.camel@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 25, 2021, Stamatis, Ilias wrote:
> Hmm, this patch actually still removes the caching and introduces a small
> performance overhead. For example if neither L1 nor L2 are scaled it will
> still do a vmwrite for every L2 entry/write.

True, but there is an ocean of difference between the relative performance of
vmx_vcpu_load_vmcs() and a nested transition.  vmx_vcpu_load_vmcs() is also
called much more frequently.

> So do we want to get rid of decache_tsc_multiplier() but keep 
> vmx->current_tsc_ratio and do the check inside write_tsc_multiplier()? Or 
> alternatively delete vmx->current_tsc_ratio too and have 
> write_tsc_multiplier() receive 2 parameters, one of the old multiplier and 
> one of the new?

My vote is to kill it, eat the barely-noticeable perf hit on nVMX, and tackle
the aggressive VMCS shadowing in a separate series.
