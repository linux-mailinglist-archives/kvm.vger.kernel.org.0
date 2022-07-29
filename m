Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0608584FEA
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiG2MDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 08:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236075AbiG2MDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 08:03:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29127863DF;
        Fri, 29 Jul 2022 05:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B376F61EED;
        Fri, 29 Jul 2022 12:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D36DC433C1;
        Fri, 29 Jul 2022 12:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659096190;
        bh=C4owJoJbiJY8z4Ue5e98Blzfaibi9xP4wmji4tk/3+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AusHQAaIfH7Lxpn+JB7bIJYGJYwYth+HzubZ42i+xYqgP97b81F5pS46C/y3lYS9E
         a0kHGubE1KrtyycAYB0eYdGM8iRFfskLZ8cEgd1M12JRU0lTa40ObXZhjOvr08CvMi
         ajgGSubSGyuwIHJLweNwyLS3OOCsGSeynPJc5fVGr3CA5E8MWVE2ZU5cIsevdL5ToL
         jFB51jTwEO4+5feB5HVlyJyn8cJDFyLR2YqzuJwmwLiPbe3OFz5FxYaXKrpNDxBGVS
         /iJj1FGDoplFtuxIETf6zUi3tg6x5tgbfX8kXxvCSaCEEpFHJfKN9O1+YzOILKtLwF
         ZILimrn4kwwtg==
Date:   Fri, 29 Jul 2022 15:03:05 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jarkko Sakkinen <jarkko@profian.com>,
        Harald Hoyer <harald@profian.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SVM: Dump Virtual Machine Save Area (VMSA) to klog
Message-ID: <YuPMeWX4uuR1Tz3M@kernel.org>
References: <20220728050919.24113-1-jarkko@profian.com>
 <a9da5c1e-eca9-b3e7-3224-c9d5a26287fb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9da5c1e-eca9-b3e7-3224-c9d5a26287fb@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 28, 2022 at 05:15:43PM +0200, Paolo Bonzini wrote:
> On 7/28/22 07:09, Jarkko Sakkinen wrote:
> > As Virtual Machine Save Area (VMSA) is essential in troubleshooting
> > attestation, dump it to the klog with the KERN_DEBUG level of priority.
> > 
> > Cc: Jarkko Sakkinen <jarkko@kernel.org>
> > Suggested-by: Harald Hoyer <harald@profian.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
> > ---
> >   arch/x86/kvm/svm/sev.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 0c240ed04f96..6d44aaba321a 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -603,6 +603,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> >   	save->xss  = svm->vcpu.arch.ia32_xss;
> >   	save->dr6  = svm->vcpu.arch.dr6;
> > +	pr_debug("Virtual Machine Save Area (VMSA):\n");
> > +	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
> > +
> >   	return 0;
> >   }
> 
> Queued, thanks.
> 
> Paolo

Ugh, I made a mistake, sorry. 

It should have been:

print_hex_dump(KERN_DEBUG, "VMSA:", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);

I sent wrong version of the patch.

BR, Jarkko
