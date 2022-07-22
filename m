Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCD257E9A1
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 00:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiGVWZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 18:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234255AbiGVWZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 18:25:55 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5148965A;
        Fri, 22 Jul 2022 15:25:53 -0700 (PDT)
Received: from zn.tnic (p200300ea97297621329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9729:7621:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFCE81EC02E4;
        Sat, 23 Jul 2022 00:25:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1658528746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=emiawl0ZNbUbhwPd8wD23nmKvXFNPldjeUy0zLg0tu8=;
        b=eNQANAVlpHoclXI7HJ9Le6r1ZbS/iErXCHKwynRvmd73vdwfp6eQVw1ymNnEsRmPAaXC4w
        Ebxz9VE60nC3MAtQQzpMQMj0daKH8XQ/n7m6f6fADdwGeLsIYGC2St44DA/pIqrE+sewKM
        48fmPx4N0N76V4OTDJSFL8YTsgIDDfo=
Date:   Sat, 23 Jul 2022 00:25:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Kalra, Ashish" <Ashish.Kalra@amd.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Message-ID: <Ytsj5Wi0clIR6p9l@zn.tnic>
References: <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <YrTq3WfOeA6ehsk6@google.com>
 <SN6PR12MB276743CBEAD5AFE9033AFE558EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YtqLhHughuh3KDzH@zn.tnic>
 <Ytr0t119QrZ8PUBB@google.com>
 <Ytr5ndnlOQvqWdPP@zn.tnic>
 <Ytshp+D+IT8eaevH@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ytshp+D+IT8eaevH@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 10:16:07PM +0000, Sean Christopherson wrote:
> Yar, just wanted to be make sure we're all on the same page, I wasn't entirely
> sure what was get nacked :-)

Not nacked - we're all just talking here. :-)

> Heh, you're definitely more optimistic than me.  I can just see something truly
> ridiculous happening like moving the page size bit and then getting weird behavior
> only when KVM happens to need the page size for some edge case.
> 
> Anyways, it's not a sticking point, and I certainly am not volunteering to
> maintain the FMS list...

Yeah, no need for it to be a sticking point because a pretty reliable
birdie just told me that we're worrying for nothing and it all will
solve itself.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
