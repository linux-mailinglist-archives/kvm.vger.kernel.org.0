Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E7262DC04
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 13:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbiKQMx6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 07:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiKQMxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 07:53:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7703CFCF9;
        Thu, 17 Nov 2022 04:53:31 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7de329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7de:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9B7F11EC06A9;
        Thu, 17 Nov 2022 13:53:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668689609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7s6Ef+tv/rK2OHlIXq5H1UB2O1jdMVLrAerbtF74Hks=;
        b=VS74B92d2MbWRhzVmFBxw9H5pwI0RTGgg0DiKTGkJHICPhdt4vfacqiwh7zpxnJ6np6PQX
        UqMMJFuqkS/izfsm5RieZWa4X+amDbZt6fEUeIe9pQTI+SGHLvOBiMxNKWViwL1thiDMq7
        wsSN+sOAVdUZzMY7kQDwsp2NdT5E1YM=
Date:   Thu, 17 Nov 2022 13:53:24 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y3YuxGO8Kycymxg3@zn.tnic>
References: <20221117044433.244656-1-nikunj@amd.com>
 <Y3YP5FQ6OHzVFKbp@zn.tnic>
 <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7e224da6-6b02-2972-1334-bc8e7894cdab@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 05:50:34PM +0530, Nikunj A. Dadhania wrote:
> Purpose of this patch is older guests kernel that have SNP enabled
> (5.19 onward), when a particular SNP feature is enabled by the
> hypervisor that needs enlightened guest, older kernel wont be able to
> support the feature. There is no mechanism that the hypervisor can
> find out what feature is supported by the SNP guest before hand.
>
> For example PREVENT_HOST_IBS needs changes on hypervisor and no
> changes in the guest kernel. In this any guest kernel having SNP
> support should work.
>
> While for SECURE_TSC, hypervisor and guest kernel changes are
> required. And older guest kernel will not work if hypervisor enables
> Secure TSC. When secure tsc feature is enabled following define should
> be changed:

This all is still veiled in mist to me. What are you trying to do here?

- Make sure older SNP guests boot on newer hypervisors?

- Newer guests boot on older hypervisors?

So, first, pls explain in detail what the goal here is.

I'm reading the above in multiple ways so you need to spell out first
what you wanna do.

PREVENT_HOST_IBS doesn't need any enablement. So why is it in the mask?

SECURE_TSC needs enablement on both. Why aren't you checking only this
one.

IOW, I would expect to check *only* for features which the guest needs
for the hypervisor to support before it boots. But not check everything
wholesale.

IOW, I see it this way: guest boots, sees what the hypervisor has
enabled as SEV_STATUS cannot be intercepted and acts accordingly.

Now, the question how *old* guests should act here is a whole different
story as it depends on whether this gets backported to old guests -
which doesn't make them old anymore as the checking will happen - or to
really old guests without the checking. There it doesn't matter.

And come to think of it, this whole deal is no different than having
feature bits in CPUID and the kernel implementing them.

If the kernel finds a feature bit set in CPUID, it enables the
corresponding code. If it doesn't know about it, then it doesn't do
anything.

Pretty much the same here: if a SNP guest finds a feature flag in
SEV_STATUS, then it enables the code corresponding to it. If it doesn't
find it but it needs it due to enablement, then it stops booting.

So let's define the problem first.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
