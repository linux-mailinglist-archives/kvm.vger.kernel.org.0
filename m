Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B444B865A
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiBPLA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:00:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiBPLAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:00:48 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D093B0D17
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:00:36 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CB18D6E;
        Wed, 16 Feb 2022 03:00:36 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 732E13F66F;
        Wed, 16 Feb 2022 03:00:35 -0800 (PST)
Date:   Wed, 16 Feb 2022 11:00:54 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool 1/2] kvm tools: fix initialization of irq mptable
Message-ID: <YgzZZvjOAEWwaoO8@monolith.localdoman>
References: <20220216043834.39938-1-songmuchun@bytedance.com>
 <YgzZGDscKEh1uAS0@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgzZGDscKEh1uAS0@monolith.localdoman>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Forgot to add, would you mind rewording the commit subject to:

x86: Fix initialization of irq mptable

Thanks,
Alex

On Wed, Feb 16, 2022 at 10:59:36AM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Feb 16, 2022 at 12:38:33PM +0800, Muchun Song wrote:
> > When dev_hdr->dev_num is greater one, the initialization of last_addr
> > is wrong.  Fix it.
> > 
> > Fixes: f83cd16 ("kvm tools: irq: replace the x86 irq rbtree with the PCI device tree")
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > ---
> >  x86/mptable.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/x86/mptable.c b/x86/mptable.c
> > index a984de9..f13cf0f 100644
> > --- a/x86/mptable.c
> > +++ b/x86/mptable.c
> > @@ -184,7 +184,7 @@ int mptable__init(struct kvm *kvm)
> >  		mpc_intsrc = last_addr;
> >  		mptable_add_irq_src(mpc_intsrc, pcibusid, srcbusirq, ioapicid, pci_hdr->irq_line);
> >  
> > -		last_addr = (void *)&mpc_intsrc[dev_hdr->dev_num];
> > +		last_addr = (void *)&mpc_intsrc[1];
> 
> This looks correct to me. I think there was a copy-and-paste error from the
> device loop above where the interrupt lines were added to mpc_intsrc.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Thanks,
> Alex
> 
> >  		nentries++;
> >  		dev_hdr = device__next_dev(dev_hdr);
> >  	}
> > -- 
> > 2.11.0
> > 
