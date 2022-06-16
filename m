Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E2654DF98
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376708AbiFPK71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiFPK70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:59:26 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4364EA37;
        Thu, 16 Jun 2022 03:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZkPfOde6LsK0Glx12hkc81WxEBScqSjLnE5JE7ziIK8=; b=F58PV9TK4+5Y/Ni+iIf7FjLqsv
        EmNgEdycjPhFe2KJ6SLdLFdtZl9cmlZrTx49IYfyK97KdSMdp6YQKcDrY/Fc9gF8CiTY9UJ+lkf7M
        Y8pOlAUIFyhWgCcuVXXoZn+6wAtybGO25/jiMDOiDLrPd0Xw/kA2+ST0UN6t1M2Mo2YwxrvirPlvI
        7NKw0DeZSwQD8e+8pd5q2SOp191+3PzToSZwiXXpx7jIYI8eaWjzgaT2T3xo9MaTuTd8EtDFAiu+W
        QGTRqIVBAsOZsKdWlQObFv/BkCgSh2hijoZgp3wFVHs/RMw1+0P5ZFAyKPwC8lvE46oV0/789Oqp2
        b/P3xQkA==;
Received: from dhcp-077-249-017-003.chello.nl ([77.249.17.3] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o1nDM-008OiG-9b; Thu, 16 Jun 2022 10:59:08 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id ED23F980DD0; Thu, 16 Jun 2022 12:59:01 +0200 (CEST)
Date:   Thu, 16 Jun 2022 12:59:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 16/19] KVM: x86: Enable CET virtualization for VMX and
 advertise CET to userspace
Message-ID: <YqsM9VkQ4cTSJ4Ct@worktop.programming.kicks-ass.net>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <20220616084643.19564-17-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616084643.19564-17-weijiang.yang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 16, 2022 at 04:46:40AM -0400, Yang Weijiang wrote:
> Set the feature bits so that CET capabilities can be seen in guest via
> CPUID enumeration. Add CR4.CET bit support in order to allow guest set CET
> master control bit(CR4.CET).
> 
> Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
> KVM does not support emulating CET.
> 
> Don't expose CET feature if dependent CET bits are cleared in host XSS,
> or if XSAVES isn't supported.  Updating the CET features in common x86 is
> a little ugly, but there is no clean solution without risking breakage of
> SVM if SVM hardware ever gains support for CET, e.g. moving everything to
> common x86 would prematurely expose CET on SVM.  The alternative is to
> put all the logic in VMX, but that means rereading host_xss in VMX and
> duplicating the XSAVES check across VMX and SVM.

Doesn't Zen3 already have SHSTK ?
