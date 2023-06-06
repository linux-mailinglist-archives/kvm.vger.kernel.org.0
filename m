Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC1772445C
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbjFFN1a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjFFN13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:27:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3521118;
        Tue,  6 Jun 2023 06:27:27 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1686058046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GE9WjdAFKVw1j/LBC/tJ3tEETtCjZm6/3ok9EzRiww=;
        b=w5R70kFWsU64r33qYY+R3GNo4WBUNJSWY3CITWeMB8Ho1DaAglb56jHjjyHPUdrv0xPFtI
        5mVQK8m+4uvVDtb0PQ04IOvf+Nxe7vbfrUesgfPsikP/YsWsH1P+FFdWBwyfUf64h/LZvF
        fFWNnm46QdtmJKPKnu3m2XwFtDTmwbhp7seekB0dxQ0yqEfBGFF+GFsXK/orl1Zzr2DUFn
        LhZDlI+aJNabFjlfG0h5Mt8G9qm4kNPmhx4HrfCLjDkr4/hDh3LJHMXkniebEdr9m9IiFf
        dQ6EmrUfZn0XPcSvFtp6RdIiC65U8/2DYMYqMqHFTELKgtQh4HlM7H7+2EIvVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1686058046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4GE9WjdAFKVw1j/LBC/tJ3tEETtCjZm6/3ok9EzRiww=;
        b=te48p/rqwl0Wh/jc2Vr4qpI19ykvDLPW9ambOLCElI800bdN5cVIUOd3midi7weyXM/aaQ
        uWeQsj/BVGfDvRBA==
To:     "Li, Xin3" <xin3.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>,
        "Kang, Shan" <shan.kang@intel.com>
Subject: RE: [PATCH v8 30/33] x86/fred: allow dynamic stack frame size
In-Reply-To: <SA1PR11MB673430AC2D6F20C5F77FC83AA852A@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-31-xin3.li@intel.com> <87wn0i578t.ffs@tglx>
 <SA1PR11MB673430AC2D6F20C5F77FC83AA852A@SA1PR11MB6734.namprd11.prod.outlook.com>
Date:   Tue, 06 Jun 2023 15:27:25 +0200
Message-ID: <87fs74lo02.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06 2023 at 06:18, Xin3 Li wrote:
>> > A FRED stack frame could contain different amount of information for
>> > This approach also works for IDT, thus we unify the code.
>> 
>> And thereby remove the useful comment and replace it with an undocumented
>> macro mess.
>> 
>> I'm simply refusing to review this. It's not my job to understand this
>> undocumented hackery.
>> 
>
> I believe it's a nice idea to allow dynamic stack frame size, at least for
> FRED.

Believe belongs in the realm of religion. What we need here are proper
facts, explanations and justifications. Nice ideas are not helpful when
they are not having a value.

> It's totally my bad that I didn't make it meet the minimum standards,
> I will rewrite the commit message and add better comments.
>
> After a second thought, I probably should only apply the change to FRED for
> 2 reasons, the change seems problematic with ESPFIX (which FRED
> doesn't need),

Indeed. Making this FRED only is going to need even more justification.

> and such corner cases are hard to test (self-tests needed?)

There is a test. It's not that hard to find:

# git grep -li ESPFIX tools/testing/selftests/
tools/testing/selftests/x86/sigreturn.c

Thanks,

        tglx
