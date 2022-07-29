Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD1C585576
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 21:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiG2TMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 15:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbiG2TMb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 15:12:31 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284AA7644C;
        Fri, 29 Jul 2022 12:12:30 -0700 (PDT)
Date:   Fri, 29 Jul 2022 19:12:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1659121948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CWN+KWlLAodm15IDfklP+Ue4DIpvxUP8JtqU/C0gEok=;
        b=fhofxLm/yVuZrN3CdzWL7D+bJ6YfNcUd55wI+jgpUMNYqLJnyG5t+hx9EwjiNtFXVwR8Ug
        eH83lPkqNZOBqJohG4NTOBo4QGf3/EYodfTYx7C8gVQJrkCkuODCn+1wTWpWkzOd9Mmehz
        46zB7OhcSioXsnz8B0XESDY6TBWX4yY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] selftests/kvm/x86_64: set rax before vmcall
Message-ID: <YuQxFDupaZuyUMmP@google.com>
References: <20220628193011.55403-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628193011.55403-1-avagin@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrei,

On Tue, Jun 28, 2022 at 12:30:11PM -0700, Andrei Vagin wrote:
> kvm_hypercall has to place the hypercall number in rax.
> 
> Trace events show that kvm_pv_test doesn't work properly:
>      kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
>      kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
>      kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
> 
> With this change, it starts working as expected:
>      kvm_pv_test-54285: kvm_hypercall: nr 0x5 a0 0x0 a1 0x0 a2 0x0 a3 0x0
>      kvm_pv_test-54285: kvm_hypercall: nr 0xa a0 0x0 a1 0x0 a2 0x0 a3 0x0
>      kvm_pv_test-54285: kvm_hypercall: nr 0xb a0 0x0 a1 0x0 a2 0x0 a3 0x0
> 
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> ---

Good find, this is a rather silly bug. May I suggest the following for
the changelog to better describe the problem (and blame the original
commit):

KVM: selftests: Actually pass function in %rax when calling hypercall

The KVM hypercall ABI requires the caller to pass the hypercall function
number via %rax. Unfortunately, kvm_hypercall() in selftests falls
short and doesn't set the value of %rax.

In turn, trace events show that kvm_pv_test doesn't work properly:

     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0
     kvm_pv_test-53132: kvm_hypercall: nr 0x0 a0 0x0 a1 0x0 a2 0x0 a3 0x0

Fix the issue by taking the function number as an input operand to %rax.

Fixes: ac4a4d6de22e ("selftests: kvm: test enforcement of paravirtual cpuid features")

--
Thanks,
Oliver
