Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82086DA3AC
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 22:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239710AbjDFUmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 16:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239554AbjDFUlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 16:41:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C0A7AB9;
        Thu,  6 Apr 2023 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mWCYh+aHqMQPGU92cJY3RsdVCoOL6xggKE9AswxAjjI=; b=FVfGvilevbgchwqZb52BXeY8SA
        yM4/PlPBCQF19uANo8phcXNg55OCv069MBl+d8kfOQ5fzChyQXwG8hcFBV26OSUTZK3K1MfiWWUTP
        32vXXFNGdIMRTR5weNKpSj9tpJQJ08tYy7FODzQZIricHNb+7nLm/NlEmcEHUZUat4+aVvWRzkbiz
        ZruHBv84ED5dthnKaC9V4SqK0Yq3SlaeD80X0P16qTbl5RgzuVxK7Xp1Z9JmtdzlZpwNiqopTQUez
        SR04HbpaphOyaR+GDCdQeqjdy2CICbldb2Fzsbp+GTvV1FLr5ojiF1w7bxi5Fvgja+sPSUoHU2akV
        mOqncIzg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pkWMX-0009V8-4F; Thu, 06 Apr 2023 20:37:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B0750300274;
        Thu,  6 Apr 2023 22:37:39 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 190072625036A; Thu,  6 Apr 2023 22:37:39 +0200 (CEST)
Date:   Thu, 6 Apr 2023 22:37:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 1/7] x86/entry: Move PUSH_AND_CLEAR_REGS out of
 paranoid_entry
Message-ID: <20230406203738.GE405948@hirez.programming.kicks-ass.net>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <20230403140605.540512-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140605.540512-2-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 10:05:59PM +0800, Lai Jiangshan wrote:
> @@ -915,11 +922,8 @@ SYM_CODE_END(xen_failsafe_callback)
>   * R14 - old CR3
>   * R15 - old SPEC_CTRL
>   */
> -SYM_CODE_START(paranoid_entry)
> +SYM_FUNC_START(paranoid_entry)
>  	ANNOTATE_NOENDBR
> -	UNWIND_HINT_FUNC

That isn't quite equivalent. SYM_FUNC_START() gets you ENDBR, while the
SYM_CODE_START(); ANNOTATE_NOENDBR; UNWIND_HINT_FUNC is
explicitly no ENDBR.


> -	PUSH_AND_CLEAR_REGS save_ret=1
> -	ENCODE_FRAME_POINTER 8
>  
>  	/*
>  	 * Always stash CR3 in %r14.  This value will be restored,


