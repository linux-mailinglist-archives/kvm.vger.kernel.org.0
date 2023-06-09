Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B3A729CED
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 16:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241461AbjFIObq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 10:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240587AbjFIObp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:31:45 -0400
Received: from out-19.mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498A830E7
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 07:31:43 -0700 (PDT)
Date:   Fri, 9 Jun 2023 16:31:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686321100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I2ZSCct79ET/vweEUe5gmT2uOZlVs14bXYM5MQZSFV8=;
        b=uZbv7IDeGRHe1ELPH2wVRT3rb8AAyUEe1RTw67IZ0mVa/mgKJbY5iLmSHVkB/HdgO1P0v2
        Pjx53oICMCuApKHii2HKwkGSQhSd3XG52yi2nnp+8cqXJDH+NAJCQvmeVDZAOHogS/B/Ba
        3h4BSplKeTuiHMjDFSeVARLK7sjalkg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
Message-ID: <20230609-a490dc451a2b45a60dbe9e13@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
 <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
 <20230609-2ef801d526b6f0256720cf24@orel>
 <32f41722-2941-55b5-d11b-200e43319c8e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32f41722-2941-55b5-d11b-200e43319c8e@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 03:06:36PM +0100, Nikos Nikoleris wrote:
> On 09/06/2023 08:21, Andrew Jones wrote:
> > On Thu, Jun 08, 2023 at 10:24:11AM -0700, Nadav Amit wrote:
> > > 
> > > 
> > > > On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > > > 
> > > > 
> > > > On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > > > 
> > > > > 
> > > > > +static void uart0_init_acpi(void)
> > > > > +{
> > > > > + struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
> > > > > +
> > > > > + assert_msg(spcr, "Unable to find ACPI SPCR");
> > > > > + uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
> > > > > +}
> > > > 
> > > > Is it possible as a fallback, is SPCR is not available, to UART_EARLY_BASE as
> > > > address and bit_width as bit-width?
> > > > 
> > > > I would appreciate it, since it would help my setup.
> > > > 
> > > 
> > > Ugh - typo, 8 as bit-width for the fallback (ioremap with these parameters to
> > > make my request clear).
> > > 
> > 
> > That sounds reasonable to me. Nikos, can you send a fixup! patch? I'll
> > squash it in.
> > 
> 
> I am not against this idea, but it's not something that we do when we setup
> the uart through FDT. Should ACPI behave differently? Is this really a
> fixup? Either ACPI will setup things differently or we'll change the FDT and
> ACPI path.

Yeah, you're right. It's not really a fixup and I forgot that we abort
when the DT doesn't have a uart node too. Let's leave this as is for now.
We can do a follow patch which adds a config that says "use the early
uart and don't bother looking for another" which we'd apply to both ACPI
and DT.

Thanks,
drew
