Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A954DEBC
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376402AbiFPKMS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376388AbiFPKMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:12:16 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FAF5D5F0;
        Thu, 16 Jun 2022 03:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r2UDlYq5t6O5tFjJgY4OT/pXRUI5OvQVarwp5eb1G9E=; b=WZHZ0tfWmtiq3U2bqK0Hcu7UbF
        BZxQ9o1zxQYH9VsyHy7HWtrDu/07NB1LfbdWW5zHXi23rELYc/ihdRqz2LLyrU9N9XXwme3O+rpx9
        gW/F+e+eJNeCWZ3+KkkHE1BaTXuY66cLFmdiVRSlyz+7df/xxe9EyauB5BrB1Ka/zO74ulVe5HHg9
        Ph8GwTK9rwh9qOCLJCDF3D3hznAyEUedBOTpAYaVeSL/5jYSwD6koAby05D08XkazjDjYbbI3kI/f
        cdk8hKClwnQeltpgzW6B/qN/bS/WGCu7iCfaldBO4O5USf5oZC2U2dwhd4GCiNC881JBhkCdXONkL
        K9C0Jhaw==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1mTu-008O7N-NK; Thu, 16 Jun 2022 10:12:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3EEED301D92;
        Thu, 16 Jun 2022 12:12:06 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2157F2020C0EB; Thu, 16 Jun 2022 12:12:06 +0200 (CEST)
Date:   Thu, 16 Jun 2022 12:12:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Message-ID: <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:24AM -0400, Yang Weijiang wrote:

> To minimize the impact to exiting kernel/KVM code, most of KVM patch
> code can be bypassed during runtime.Uncheck "CONFIG_X86_KERNEL_IBT"
> and "CONFIG_X86_SHADOW_STACK" in Kconfig before kernel build to get
> rid of CET featrures in KVM. If both of them are not enabled, KVM
> clears related feature bits as well as CET user bit in supported_xss,
> this makes CET related checks stop at the first points. Since most of
> the patch code runs on the none-hot path of KVM, it's expected to
> introduce little impact to existing code.

Do I understand this right in that a host without X86_KERNEL_IBT cannot
run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
was exactly what I did while developing the X86_KERNEL_IBT patches.

I'm thinking that if the hardware supports it, KVM should expose it,
irrespective of the host kernel using it.
