Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F47751BFA
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbjGMIpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjGMIop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:44:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E225412D;
        Thu, 13 Jul 2023 01:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nKk50Eg8ji6xzjaMJJdtqWsCaeey4iaTT9Uk5E6Yuzw=; b=eh21mBJIOEi1u1XWYpbOc5SQKr
        pys+TeaqH+dlml9x6rcC3QvCg0Vv3t852n5F4Uk7Y0IxC7AtH9BhS8mNdH571LwRzXUnDgtxFkOsr
        r2vJ7aYKiQ3KxMZFMeesGTiqlykZ8gLNtDgF0riIBj12hIbSckcD6OZ00VSRR6L31aMX5WLvxZ09d
        UDwW6uGmlybYBKk9WcKt8chESv8MFkbo00qeLsQ7hnRNk2X3B5JOgephOTGbHop2n3psKz4U9l2Zk
        XFOr9ethtD3IQGy0n27i/LwbqTwSpeMR2G1EfcEBzD/3euxJzES97S6/kuQt6uZCdUF0y22gwK3ga
        nwuyu2qw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJrv4-004ZTn-1T;
        Thu, 13 Jul 2023 08:43:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D0CEF300362;
        Thu, 13 Jul 2023 10:43:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B82BC245CA116; Thu, 13 Jul 2023 10:43:24 +0200 (CEST)
Date:   Thu, 13 Jul 2023 10:43:24 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230713084324.GA3138667@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
 <20230712165912.GA3100142@hirez.programming.kicks-ass.net>
 <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc5b4df23273b546225241fae2cbbea52ccb13d3.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 08:02:54AM +0000, Huang, Kai wrote:

> Sorry I am ignorant here.  Won't "clearing ECX only" leave high bits of
> registers still containing guest's value?

architecture zero-extends 32bit stores

> I see KVM code uses:
> 
>         xor %eax, %eax
>         xor %ecx, %ecx
>         xor %edx, %edx
>         xor %ebp, %ebp
>         xor %esi, %esi
>         xor %edi, %edi
> #ifdef CONFIG_X86_64
>         xor %r8d,  %r8d
>         xor %r9d,  %r9d
>         xor %r10d, %r10d
>         xor %r11d, %r11d
>         xor %r12d, %r12d
>         xor %r13d, %r13d
>         xor %r14d, %r14d
>         xor %r15d, %r15d
> #endif
> 
> Which makes sense because KVM wants to support 32-bit too.

Encoding for the first lot is shorter, the 64bit regs obviously need the
RAX byte anyway.

> However for TDX is 64-bit only.
> 
> And I also see the current TDVMCALL code has:
> 
>         xor %r8d,  %r8d
>         xor %r9d,  %r9d
>         xor %r10d, %r10d                                                       
>         xor %r11d, %r11d                                                       
>         xor %rdi,  %rdi                                                        
>         xor %rdx,  %rdx
> 
> Why does it need to use "d" postfix for all r* registers?

That's the name of the 32bit subword, r#[bwd] for byte, word,
double-word. SDM v1 3.7.2.1 has the whole list, I couldn't quicky find
one for the zero-extention thing.

> Sorry for those questions but I struggled when I wrote those assembly and am
> hoping to get my mind cleared on this. :-)

No problem.


