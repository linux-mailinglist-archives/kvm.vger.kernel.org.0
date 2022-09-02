Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABEB5AA85B
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 08:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbiIBGwJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 02:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235539AbiIBGwF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 02:52:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F91FA1D3D;
        Thu,  1 Sep 2022 23:52:03 -0700 (PDT)
Received: from nazgul.tnic (dynamic-089-204-154-243.89.204.154.pool.telefonica.de [89.204.154.243])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 36E0E1EC068D;
        Fri,  2 Sep 2022 08:51:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1662101517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=9kUEs2/T4DMChAR3xShTyboJxKta70IsCXwvaVK3RJY=;
        b=YkYEER3f0hCMiu2oU1TYSJf3dywL4jvCMYwGQXlfBVN7MC+mkZWQP/M/Ng/Ihpcsob87+o
        OTFSotKbnlSyf4Yepl+Yk9g2NYxVbVQp8sAg7K/BZSk4FZiAg31UuTN5gBp6/1ylaNkW0p
        ZfisbV5h5VcrBtsUA117bTyfqibeZg4=
Date:   Fri, 2 Sep 2022 08:52:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
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
        "seanjc@google.com" <seanjc@google.com>,
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
Subject: Re: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YxGoBzOFT+sfwr4w@nazgul.tnic>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 01, 2022 at 08:32:35PM +0000, Kalra, Ashish wrote:
> As I mentioned earlier, this is computing an index into a 4K page
> within a hugepage mapping, therefore, though pte_index() works for 2M
> pages, but pmd_index() will not work for 1G pages.

Why not? What exactly do you need to get here?

So the way I understand it is, you want to map the faulting address to a
RMP entry. And that is either the 2M PMD entry when the page is a 1G one
and the 4K PTE entry when the page is a 2M one?

Why doesn't pmd_index() work?

Also, why isn't the lookup function's signature:

int snp_lookup_rmpentry(unsigned long address, int *level)

and all that logic to do the conversion to a PFN also not in it?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
