Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730217AB44A
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjIVPAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjIVPAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:00:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1CE196;
        Fri, 22 Sep 2023 08:00:04 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695394802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yymdn5Ib3vdedE1bKPjXhrIk07DP2toWMx0YBeOSCKc=;
        b=JCA+KUnb692VWlx1fmj161S4ivDwYTrM1u8X2p5arIqoauHvahJMRyQgJNnCijDhvdZTN5
        2vhPfci1iBhuF4Qy2zYMF8JGpNHrq0VAOBaIOZz4r3zSiAs1S0WjK2Y/a5ZLPZiRHiR72P
        REbPguOF78kSQmQ7J0MndgAQ5u9+VLIa/hw1U5uaXSml+++MgocMsUUHEo8yUUBhh55/dy
        QQw13O85IYkSyENm5eCNprEvBu0VGY6MYJBQev1Uj1n9rrZjN0zSSXrLOJq5WBnRYuLa3i
        /YCovSEvga/R0iW5oDIVClJYgWEFtXfzNaoHbWAAyTqcD536K6Nb5/nqacqCUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695394802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yymdn5Ib3vdedE1bKPjXhrIk07DP2toWMx0YBeOSCKc=;
        b=CIDz5h5BcX/Bz/jkuzgX2qYw3Xx+SDJYkCZCT8rgToE1CkxZkoLWZYWz8rraUAqGtvF28b
        64aTOX6aC7JwbuBQ==
To:     "Li, Xin3" <xin3.li@intel.com>, "Li, Xin3" <xin3.li@intel.com>,
        Nikolay Borisov <nik.borisov@suse.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Lutomirski, Andy" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Gross, Jurgen" <jgross@suse.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
        "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>
Subject: RE: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
In-Reply-To: <SA1PR11MB6734445986E951E686172419A8FFA@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-4-xin3.li@intel.com>
 <dda01248-f456-d8d7-5021-ef6b2e7ade2c@suse.com>
 <SA1PR11MB6734F205C2171425415E4F00A8F9A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <SA1PR11MB6734445986E951E686172419A8FFA@SA1PR11MB6734.namprd11.prod.outlook.com>
Date:   Fri, 22 Sep 2023 17:00:02 +0200
Message-ID: <87o7hugsnh.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22 2023 at 08:16, Xin3 Li wrote:
>> > > +static __always_inline void __wrmsrns(u32 msr, u32 low, u32 high)
>> >
>> > Shouldn't this be named wrmsrns_safe since it has exception handling, similar
>> to
>> > the current wrmsrl_safe.
>> >
>> 
>> Both safe and unsafe versions have exception handling, while the safe
>> version returns an integer to its caller to indicate an exception did
>> happen or not.
>
> I notice there are several call sites using the safe version w/o
> checking the return value, should the unsafe version be a better
> choice in such cases?

Depends. The safe version does not emit a warning on fail. So if the
callsite truly does not care about the error it's fine.
