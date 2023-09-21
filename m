Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D028B7A9F5C
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjIUUVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjIUUUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:20:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BDB51018;
        Thu, 21 Sep 2023 10:15:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695290903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGuV725+A52UkxEuSgzeQeAhaGDz2ANft+qmFiacDG8=;
        b=Uc1XkSaloHBlxYQ1zN6hh9geAvtQDrA6rzrrOm0XEDhASCCuiOJd0ZUQDVk5pu7smVlZfM
        YcyVj5MIlW6dCw0gZAVps0Rws2yHAHtHT3yI0KmpTXMdgnz/3Z1IfNIMpPSXeG2C1xVIZa
        RVC8GvYWzw2wNPbssRcVWZprhIJD5GCzDZQZel4mnlA7NNIdTJN8FZXnfD5refPia6Z4Ep
        NvWaLlqsVp24Afci/BqY4B8bDTeZUFFOfG/ZbjsHOCaUcJSGcTEfuO29KH+o6OntuQsdt1
        Yeu0DTomo1WSKteeMcOT97KH0jVECo7ht6Xx698kxrEZHO2MRgqhLwxglLtcag==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695290903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MGuV725+A52UkxEuSgzeQeAhaGDz2ANft+qmFiacDG8=;
        b=YhxFLYB1hUEgCK9ZzqoixCOcdsJ9EkBa/RsLR3qBRdXVZTcXsEUrSFZvzIKcv5QclewR1g
        FaT5gQjP7YRGAsBA==
To:     Nikolay Borisov <nik.borisov@suse.com>, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        jgross@suse.com, ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com
Subject: Re: [PATCH v10 28/38] x86/fred: FRED entry/exit and dispatch code
In-Reply-To: <22921663-0e5e-58c0-c6c8-c45f991790ea@suse.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-29-xin3.li@intel.com>
 <22921663-0e5e-58c0-c6c8-c45f991790ea@suse.com>
Date:   Thu, 21 Sep 2023 12:08:23 +0200
Message-ID: <871qerj0tk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21 2023 at 12:48, Nikolay Borisov wrote:
> On 14.09.23 =D0=B3. 7:47 =D1=87., Xin Li wrote:
>> +
>> +	/* INT80 */
>> +	case IA32_SYSCALL_VECTOR:
>> +		if (likely(IS_ENABLED(CONFIG_IA32_EMULATION))) {
>
> Since future kernels will support boottime toggling of whether 32bit=20
> syscall interface should be enabled or not as per:
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=3Dx=
86/entry&id=3D1da5c9bc119d3a749b519596b93f9b2667e93c4a
>
> It will make more sense to replace this with ia32_enabled() invocation.=20
> I guess this could be done as a follow-up patch based on when this is=20
> merged as the ia32_enbaled changes are going to be merged in 6.7.

The simplest solution is to rebase the series to tip x86/entry and just
do it right away :)
