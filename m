Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51B69D25E
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 18:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjBTRuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 12:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjBTRuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 12:50:50 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9892128B;
        Mon, 20 Feb 2023 09:50:21 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0B28A1EC04DA;
        Mon, 20 Feb 2023 18:50:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1676915410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=bwxrmMj2mOhFOpUwjeGU/UbbKBMLtBWO125onjebAs8=;
        b=FoUfwnLMKo9IrSqAIx2RAzvNDd5eyrw8LvSXPxUE5AtEjEvDoUz+Ph+r6XA3M4OnRXT2Vc
        7X41bpF9uMgZUtI+rf8WMPC75kqv+dLhNZbzPKL8j+SmdveIJ7IGVQdYFnjzvyMBY4V/Fe
        GZb2+MVxxdDfLbQVYOzAi6Ota/RbFJU=
Date:   Mon, 20 Feb 2023 18:50:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>
Subject: Re: [PATCH RFC v7 13/64] x86/cpufeatures: Add SEV-SNP CPU feature
Message-ID: <Y/Oy0cvhXIm5kLTh@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-14-michael.roth@amd.com>
 <Y9qx5NbZIRdpHy5J@zn.tnic>
 <20230220162647.czmii5swwsz2wdhy@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230220162647.czmii5swwsz2wdhy@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 20, 2023 at 10:26:47AM -0600, Michael Roth wrote:
> On Wed, Feb 01, 2023 at 07:39:32PM +0100, Borislav Petkov wrote:
> > On Wed, Dec 14, 2022 at 01:40:05PM -0600, Michael Roth wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > > 
> > > Add CPU feature detection for Secure Encrypted Virtualization with
> > > Secure Nested Paging. This feature adds a strong memory integrity
> > > protection to help prevent malicious hypervisor-based attacks like
> > > data replay, memory re-mapping, and more.
> > > 
> > > Link: https://lore.kernel.org/all/YrGINaPc3cojG6%2F3@zn.tnic/
> > 
> > That points to some review feedback I've given - dunno if it is
> > relevant.
> > 
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> > 
> > I read this as Jarkko has handled this patch too. Is that the case?
> 
> Yes we shared some patches via an internal tree at some stages.

In the sense that, he took Brijesh's patch, then he did something with
it(?) and then Ashish took it from him and then you took it from Ashish?

This is how I'm reading this SOB chain at least...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
