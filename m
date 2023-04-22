Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEB16EB937
	for <lists+kvm@lfdr.de>; Sat, 22 Apr 2023 15:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDVNC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Apr 2023 09:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjDVNCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Apr 2023 09:02:55 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5E31738;
        Sat, 22 Apr 2023 06:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e+ZQpws+aLlultjpyJGVbdTQ3yuVJ1uHStKDrzIzps4=; b=gYQ9VAhZlnN1+237ibWOMTYKWA
        CwUPsfV5jaWlXPmcY8KS2x439XvMd+wppOPj2RkAaPEUilsDn8RiXjeU2Wugr1ikYQ76H8ys6mAXo
        545pZsdWt23E/QFGoMCq5n1CovUGASgGmzuUYzZijnce82U/kRWLIvJKEuWIV1KfkEM4aiVvr0FSg
        QBnWOHNOzdu4hekbFmsRrHpl2XAK4+OOIe/qX2sRbyLXylriBVCVWo+UIbXMb+UEBj5Fu2HqdW35H
        JKBXyNDbV8E7J6ye/c6KCTYTcs4HzIg7qzo8HpjUpJrYnqjvAqfysChUZMz/Y8IQnlSdlqzf7WDA0
        l3lVi4jw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pqCt0-006FqJ-1g;
        Sat, 22 Apr 2023 13:02:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B15E5300070;
        Sat, 22 Apr 2023 15:02:40 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 90A9720979C1B; Sat, 22 Apr 2023 15:02:40 +0200 (CEST)
Date:   Sat, 22 Apr 2023 15:02:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 00/21] Enable CET Virtualization
Message-ID: <20230422130240.GJ1214746@hirez.programming.kicks-ass.net>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421134615.62539-1-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 09:45:54AM -0400, Yang Weijiang wrote:

> Implementation:
> --------------------------------------------------------------------------
> Historically, the early KVM patches can support both user SHSTK and IBT,
> and most of the early patches are carried forward with changes by this new
> series. Then with kernel IBT feature merged in 5.18, a new patch was added
> to support the feature for guest. The last patch is introduced to support

Yeah, at the time I had to hack up kernel IBT guest support, because the
platform I had to use (tgl-nuc) didn't have serial and so I had to use
KVM :/

> supervisor SHSTK but the feature is not enabled on Intel platform for now,
> the main purpose of this patch is to facilitate AMD folks to enable the
> feature.
> 
> In summary, this new series enables CET user SHSTK/IBT and kernel IBT, but
> doesn't fully support CET supervisor SHSTK, the enabling work is left for
> the future.
> 
> Supported CET sub-features:
> 
>                   |
>     User SHSTK    |    User IBT      (user mode)
> --------------------------------------------------
>     s-SHSTK (X)   |    Kernel IBT    (kernel mode)
>                   |
> 
> The user SHSTK/IBT relies on host side XSAVES support(XSS[bit 11]) for user
> mode CET states. The kernel IBT doesn't have dependency on host XSAVES.
> The supervisor SHSTK relies on host side XSAVES support(XSS[bit 12]) for
> supervisor mode CET states.
> 
> This version removed unnecessary checks for host CET enabling status before
> enabling guest CET support, making guest CET support apart from that of host.
> By doing so, it's expected to be more friendly to cloud computing scenarios.

I've on ideas about cloud stuff, but there is fundamentally no relation
bewteen the host making use of IBT/SHSTK and a guest doing so, so there
should be no dependency there.


> To run user shadow stack test and kernel IBT test in VM, you need an CET
> capable platform, e.g., Sapphire Rapids server, and follow below steps to
> build host/guest kernel properly:
> 
> 1. Buld host kernel. Patch this series to kernel tree and build kernel
> with CET capable gcc version(e.g., >=8.5.0).

Why does the host kernel require a CET capable toolchain if the host
kernel does not in fact need to make use of these features in order to
provide them to the guest?
