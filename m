Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5E15AC302
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 08:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiIDGhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 4 Sep 2022 02:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiIDGhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 4 Sep 2022 02:37:10 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DF0474C1;
        Sat,  3 Sep 2022 23:37:07 -0700 (PDT)
Received: from nazgul.tnic (dynamic-002-247-250-198.2.247.pool.telefonica.de [2.247.250.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 609571EC03EA;
        Sun,  4 Sep 2022 08:37:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1662273421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A/yg6xLScDG3nkcrMuFvwn0cTlwl9YzQi+dbx7SZXE4=;
        b=pN97dF0fDmXybRWJ/KRiBRIBo09g3o8gogusERQNNw/JE8r+lwYvwNsl/Jei5OIwVjhq/B
        b4JnlpbPeLY2hOK5QXqEsipafAphSpvCQIRejvFSC4daKFKQhmr2vc9Y4uQKMLfCCpLJxz
        kn63o730nFrlWU4nmmHm95lGJS7I//U=
Date:   Sun, 4 Sep 2022 08:37:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YxRHfzN1AV7GZf8o@nazgul.tnic>
References: <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxGoBzOFT+sfwr4w@nazgul.tnic>
 <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxLXJk36EKxldC1S@nazgul.tnic>
 <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BC747219-7808-4C39-A17C-A76B35DD6CB3@alien8.de>
 <SN6PR12MB2767C4C296281D25306885A78E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN6PR12MB2767C4C296281D25306885A78E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 03, 2022 at 05:30:28PM +0000, Kalra, Ashish wrote:
> There is 1 64-bit RMP entry for every physical 4k page of DRAM, so
> essentially every 4K page of DRAM is represented by a RMP entry.

Before we get to the rest - this sounds wrong to me. My APM has:

"PSMASH	Page Smash

Expands a 2MB-page RMP entry into a corresponding set of contiguous
4KB-page RMP entries. The 2MB page’s system physical address is
specified in the RAX register. The new entries inherit the attributes
of the original entry. Upon completion, a return code is stored in EAX.
rFLAGS bits OF, ZF, AF, PF and SF are set based on this return code..."

So there *are* 2M entries in the RMP table.

> So even if host page is 1G and underlying (smashed/split) RMP
> entries are 2M, the RMP table entry has to be indexed to a 4K entry
> corresponding to that.

So if there are 2M entries in the RMP table, how does that indexing with
4K entries is supposed to work?

Hell, even PSMASH pseudocode shows how you go and write all those 512 4K
entries using the 2M entry as a template. So *before* you have smashed
that 2M entry, it *is* an *actual* 2M entry.

So if you fault on a page which is backed by that 2M RMP entry, you will
get that 2M RMP entry.

> If it was simply a 2M entry in the RMP table, then pmd_index() will
> work correctly.

Judging by the above text, it *can* *be* a 2M RMP entry!

By reading your example you're trying to tell me that a RMP #PF will
always need to work on 4K entries. Which would then need for a 2M entry
as above to be PSMASHed in order to get the 4K thing. But that would be
silly - RMP PFs will this way gradually break all 2M pages and degrage
performance for no real reason.

So this still looks real wrong to me.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
