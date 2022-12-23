Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A08654A5A
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 02:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiLWBE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 20:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiLWBEB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 20:04:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CCC3B413
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 17:00:18 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id m4so3580343pls.4
        for <kvm@vger.kernel.org>; Thu, 22 Dec 2022 17:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9fNngnnpE2StonojfqQey1eQCIEtpFm3j4CmrqaN8gA=;
        b=bqqhyt59RZ5/7uexDzRRAXepjZVuBZumLQVNbYyYwnmJdFK5uPPDp136NtYUkMl8go
         ETJ/ONXb/ZNy3XuM0z+SLweQdxyzTr2v2qvLkD8QmYr7hwB4ah5TedSe+7a4byts+8fR
         AUWCsJEPQEtoT7H+WF27A2LC9+h/fp8rHpITGkFHCfcUKDnGlWmi0YS9sZ0KVL+ZvcCl
         8aBhox831l2QBwyqKlHZizYh+NMC9xTjjkXtZRYt8NiTVkXn/TEmpDsxCgQj9629oAeh
         xNcnNXpCv4lrcogZAoUdn3ob2yDSRnWdYWCUAYnAuD81ohkCSwmDlKPPh3YOQ2hmUB6j
         jTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fNngnnpE2StonojfqQey1eQCIEtpFm3j4CmrqaN8gA=;
        b=F8fMAIIS2CPSu16am8TGlIJS//PfIFF3K2JFDoMlQYsUwVGSFsKHnqZ6LGJMEtWS14
         ahkuHgyEmHIXtqykS3Hpca7uDeNjlELxpE2inlL2TGM+/iOLeEwNXxDwLNIqbycgjMN1
         HI9PGCFs2K7S7XQJDRo0NVkKQ6rf0mbG+rU+QU5j09bwpDvCq430k7lcoDjNxqoIhIOL
         BuAjmyg/g31UrCHyksOG+oRYvA8h2r8DoaL92nIi2ipyDDqIexS5irsIf6MGpJoeQjCB
         pUYy6+b693lOUe4mRPRRHypbrN6/s/XlnPe73BbxTrIcTDSLOuI87BPDwICLQ7EBsjmT
         8jww==
X-Gm-Message-State: AFqh2koK9442uO8sOGtn7fGuQphu2p/bGNHvONJF+W2zXJFXmE/SazrS
        qkCUeISnhCqu97N68HikhVD8oeVI9nztMXtl
X-Google-Smtp-Source: AMrXdXtKUNrR6zj/7PH2VEbsItoUuVA4yZcHcLe5RCHjCNX53q/K79iy62BAlgWiKIhyuf9E98mKsQ==
X-Received: by 2002:a17:902:a608:b0:189:b910:c6d2 with SMTP id u8-20020a170902a60800b00189b910c6d2mr1164911plq.1.1671757207187;
        Thu, 22 Dec 2022 17:00:07 -0800 (PST)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0018f6e4e425dsm1088195plp.198.2022.12.22.17.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 17:00:06 -0800 (PST)
Date:   Thu, 22 Dec 2022 17:00:03 -0800
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH 2/3] KVM: arm64: Handle S1PTW translation with TCR_HA set
 as a write
Message-ID: <Y6T9kxfCo86q13Iq@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-3-maz@kernel.org>
 <Y6M4TqvJytAEq2ID@google.com>
 <Y6NGcFXLtwOt0+d6@google.com>
 <86ili3byn8.wl-maz@kernel.org>
 <Y6TFAClKlJgkFKef@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6TFAClKlJgkFKef@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 22, 2022 at 08:58:40PM +0000, Oliver Upton wrote:
> On Thu, Dec 22, 2022 at 09:01:15AM +0000, Marc Zyngier wrote:
> > On Wed, 21 Dec 2022 17:46:24 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > >  - When UFFD is in use, translation faults are reported to userspace as
> > >    writes when from a RW memslot and reads when from an RO memslot.
> > 
> > Not quite: translation faults are reported as reads if TCR_EL1.HA
> > isn't set, and as writes if it is. Ignoring TCR_EL1.HD for a moment,
> > this matches exactly the behaviour of the page-table walker, which
> > will update the S1 PTs only if this bit is set.
> 
> My bad, yes you're right. I conflated the use case here with the
> architectural state.
> 
> I'm probably being way too pedantic, but I just wanted to make sure we
> agree about the ensuing subtlety. More below:
> 
> > Or is it what userfaultfd does on its own? That'd be confusing...
> > 
> > > 
> > >  - S1 page table memory is spuriously marked as dirty, as we presume a
> > >    write immediately follows the translation fault. That isn't entirely
> > >    senseless, as it would mean both the target page and the S1 PT that
> > >    maps it are both old. This is nothing new I suppose, just weird.
> > 
> > s/old/young/ ?
> > 
> > I think you're confusing the PT access with the access that caused the
> > PT access (I'll have that printed on a t-shirt, thank you very much).
> 
> I'd buy it!
> 
> > Here, we're not considering the cause of the PT access anymore. If
> > TCR_EL1.HA is set, the S1 PT page will be marked as accessed even on a
> > read, and only that page.
> 
> I think this is where the disconnect might be. TCR_EL1.HA == 1 suggests
> a write could possibly follow, but I don't think it requires it. The
> page table walker must first load the S1 PTE before writing to it.
> 
> From AArch64.S1Translate() (DDI0487H.a):
> 
>     (fault, descaddress, walkstate, descriptor) = AArch64.S1Walk(fault, walkparams, va, regime,
> 								 ss, acctype, iswrite, ispriv);
> 
>     [...]
> 
>     new_desc = descriptor;
>     if walkparams.ha == '1' && AArch64.FaultAllowsSetAccessFlag(fault) then
>       // Set descriptor AF bit
>       new_desc<10> = '1';
> 
>     [...]
> 
>     // Either the access flag was clear or AP<2> is set
>     if new_desc != descriptor then
>       if regime == Regime_EL10 && EL2Enabled() then
>         s1aarch64 = TRUE;
> 	s2fs1walk = TRUE;
> 	aligned = TRUE;
> 	iswrite = TRUE;
> 	(s2fault, descupdateaddress) = AArch64.S2Translate(fault, descaddress, s1aarch64,
> 							   ss, s2fs1walk, AccType_ATOMICRW,
> 							   aligned, iswrite, ispriv);
> 
>     if s2fault.statuscode != Fault_None then
>       return (s2fault, AddressDescriptor UNKNOWN);
>     else
>       descupdateaddress = descaddress;
> 
>     (fault, mem_desc) = AArch64.MemSwapTableDesc(fault, descriptor, new_desc,
>     						 walkparams.ee, descupdateaddress)
> 
> Buried in AArch64.S1Walk() is a stage-2 walk for a read to fetch the
> descriptor. The second stage-2 walk for write is conditioned on having
> already fetched the stage-1 descriptor and determining the AF needs
> to be set.
> 
> Relating back to UFFD: if we expect KVM to do exactly what hardware
> does, UFFD should see an attempted read when the first walk fails
> because of an S2 translation fault. Based on this patch, though, we'd
> promote it to a write if TCR_EL1.HA == 1.
> 
> This has the additional nuance of marking the S1 PT's IPA as dirty, even
> though it might not actually have been written to. Having said that,
> the false positive rate should be negligible given that S1 PTs ought to
> account for a small amount of guest memory.

Another false positive is TCR_EL1.HA == 1 and having the AF bit set in
the PTE. This results on a write, when I don't think it should.

> 
> Like I said before, I'm probably being unnecessarily pedantic :) It just
> seems to me that the view we're giving userspace of S1PTW aborts isn't
> exactly architectural and I want to make sure that is explicitly
> intentional.
>
> --
> Thanks,
> Oliver
