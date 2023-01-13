Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17007669AD2
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 15:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjAMOp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 09:45:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjAMOpA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 09:45:00 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637B99B285;
        Fri, 13 Jan 2023 06:34:39 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DFD041EC06EE;
        Fri, 13 Jan 2023 15:34:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673620476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Tupfp8exSpQ4RbZCFKZqWdQOqhq4P6GGAsJ+a2D0UiA=;
        b=ez7twyV8r/e81WS/tbD53J8+AErW3z0qB4278JGKImv1VqOOCl1mPfVpOFxrRJ28COpxQh
        Dv1Gq7oYynLuj2xK9oaktn6HgMReadvqdPvF6eFjiLTcuQhSsMnFEKro/KuoY1OpfH1HFh
        wAglyU90GKfDGW7vcQmeT3ce5DqinWQ=
Date:   Fri, 13 Jan 2023 15:34:36 +0100
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
        ashish.kalra@amd.com, harald@profian.com
Subject: Re: [PATCH RFC v7 04/64] KVM: x86: Add 'fault_is_private' x86 op
Message-ID: <Y8Fr/F1RV0B8CHq5@zn.tnic>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-5-michael.roth@amd.com>
 <Y628y6hQK38+IAev@zn.tnic>
 <20230105024256.ptujtjgzcdmpakoa@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105024256.ptujtjgzcdmpakoa@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 04, 2023 at 08:42:56PM -0600, Michael Roth wrote:
> Obviously I need to add some proper documentation for this, but a 1
> return basically means 'private_fault' pass-by-ref arg has been set
> with the appropriate value, whereas 0 means "there's no platform-specific
> handling for this, so if you have some generic way to determine this
> then use that instead".

Still binary, tho, and can be bool, right?

I.e., you can just as well do:

        if (static_call(kvm_x86_fault_is_private)(kvm, gpa, err, &private_fault))
                goto out;

at the call site.

> This is mainly to handle CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, which
> just parrots whatever kvm_mem_is_private() returns to support running
> KVM selftests without needed hardware/platform support. If we don't
> take care to skip this check where the above fault_is_private() hook
> returns 1, then it ends up breaking SNP in cases where the kernel has
> been compiled with CONFIG_HAVE_KVM_PRIVATE_MEM_TESTING, since SNP
> relies on the page fault flags to make this determination, not
> kvm_mem_is_private(), which normally only tracks the memory attributes
> set by userspace via KVM_SET_MEMORY_ATTRIBUTES ioctl.

Some of that explanation belongs into the commit message, which is a bit
lacking...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
