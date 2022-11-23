Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12F7635BEF
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 12:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbiKWLkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 06:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236235AbiKWLkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 06:40:47 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6716C11E813;
        Wed, 23 Nov 2022 03:40:46 -0800 (PST)
Received: from zn.tnic (p200300ea9733e747329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e747:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DF82D1EC0409;
        Wed, 23 Nov 2022 12:40:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1669203645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sSCQP9l7EhlMRg+/Nb1FBm7eXGpDbXJPkykAqRekjL8=;
        b=XChS0OLbpDpwYCthmECg64pzeg2wuaUGEsH7mVtaY8AyG9TAyxZJ2z8EseMsdi8ctBUmFD
        JHK+Ue4N3Z1Miq7lXAZGQZpIJEeOKOffGTstEdq2e1h76z7sIfdz11x9l/WSGmiR4HMI+x
        T9jayzgCDzwQxtJAQVGE3G5IjeSHWWE=
Date:   Wed, 23 Nov 2022 12:40:40 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Kalra, Ashish" <ashish.kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        michael.roth@amd.com, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 14/49] crypto: ccp: Handle the legacy TMR
 allocation when SNP is enabled
Message-ID: <Y34GuNXaa3csthJY@zn.tnic>
References: <3a51840f6a80c87b39632dc728dbd9b5dd444cd7.1655761627.git.ashish.kalra@amd.com>
 <Y0grhk1sq2tf/tUl@zn.tnic>
 <380c9748-1c86-4763-ea18-b884280a3b60@amd.com>
 <b712bc81-4446-9be4-fd59-d08981d13475@amd.com>
 <Y3qdTuZQoDZxUgbw@zn.tnic>
 <cffed3c2-55a9-bdd3-3b8a-82b2050a64af@amd.com>
 <Y3yhthJTIWqjjAPK@zn.tnic>
 <d85bf488-9050-13d6-a23b-1440a4df4c81@amd.com>
 <Y3yoB015qCpbnUzl@zn.tnic>
 <13bd73b6-592c-66c4-cd42-0913380da745@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <13bd73b6-592c-66c4-cd42-0913380da745@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 05:44:47AM -0600, Kalra, Ashish wrote:
> It is important to note that if invalid address/len are supplied, the
> failure will happen at the initial stage itself of transitioning these pages
> to firmware state.

/me goes and checks out your v6 tree based on 5.18.

Lemme choose one:

static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
{
	...

        inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);

	...

        for (i = 0; i < npages; i++) {
                pfn = page_to_pfn(inpages[i]);

		...

                ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
                if (ret) {
                        /*
                         * If the command failed then need to reclaim the page.
                         */
                        snp_page_reclaim(pfn);

and here it would leak the pages if it cannot reclaim them.

Now how did you get those?

Through params.uaddr and params.len which come from userspace:

        if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
                return -EFAULT;


Now, think about it, can userspace be trusted?

Exactly.

Yeah, yeah, I see it does is_hva_registered() but userspace can just as
well supply the wrong region which fits.

> In such a case the kernel panic is justifiable,

So userspace can supply whatever it wants and you'd panic?

You surely don't mean that.

> but again if incorrect addresses are supplied, the failure will happen
> at the initial stage of transitioning these pages to firmware state
> and there is no need to reclaim.

See above.

> Or, otherwise dump a warning and let the pages not be freed/returned
> back to the page allocator.
>
> It is either innocent pages or kernel panic or an innocent host
> process crash (these are the choices to make).

No, it is make the kernel as resilient as possible. Which means, no
panic, add the pages to a not-to-be-used-anymore list and scream loudly
with warning messages when it must leak pages so that people can fix the
issue.

Ok?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
