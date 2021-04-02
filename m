Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CC352FE8
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 21:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbhDBTqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 15:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBTqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Apr 2021 15:46:50 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204CCC0613E6;
        Fri,  2 Apr 2021 12:46:49 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0a2000165287017d4f49d2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:2000:1652:8701:7d4f:49d2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ACCA01EC04C2;
        Fri,  2 Apr 2021 21:46:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617392807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=u9QiS1HmSI7RKvl8+3nDKOULgw5gl3PnsHKQrQ29jDQ=;
        b=XtS9xeiKY9utcslaqWEbGdehTkJ22F3lOOiecFuH0tjQaAzezcOY5abVAyjzkoKhRGYTuT
        yub7E0dYPAQO7b+ba2QKSi5wqG2AvQCgg4RVYerpJv8oPTdf6mSnA/q2h5KWmk3jIgmlH8
        JrlYMoAZA0MLptKeW0AJfnMXm4q/dnI=
Date:   Fri, 2 Apr 2021 21:46:48 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 07/25] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <20210402194648.GN28499@zn.tnic>
References: <cover.1616136307.git.kai.huang@intel.com>
 <d35d17a02bbf8feef83a536cec8b43746d4ea557.1616136308.git.kai.huang@intel.com>
 <20210402094816.GC28499@zn.tnic>
 <YGc7ezLWEu/ZvUOu@google.com>
 <20210402191946.GL28499@zn.tnic>
 <YGdwzzvsKTXJeioa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YGdwzzvsKTXJeioa@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 02, 2021 at 07:30:23PM +0000, Sean Christopherson wrote:
> Heh, that's what I had originally and used for literally years.  IIRC, I
> suggested the "!! & !!" abomination after internal review complained about the
> oddness of the above.

Whut?

> FWIW, I think the above is far less likely to be misread, even though I love the
> cleverness of the bitwise AND.

The problem with using bitwise operations here is that they don't belong
in a logical expression of this sort - you do those when you actually
work with bitmasks etc and not when you wanna check whether the functions
returned success or not.

Yeah, yeah, the bitwise thing gets you what you want and yadda yadda but
readability is important. That thing that keeps this code maintainable
years from now...

Also, your original suggestion is literally translating the comment in
code, while

	!!sgx_drv_init() & !!sgx_vepc_init()

especially with that bitwise-& in there, makes me go "say what now?!"

So yeah, you were right the first time.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
