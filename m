Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E135531F3
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349970AbiFUMZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 08:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiFUMZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 08:25:12 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3199AA18E
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 05:25:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AAB7165C;
        Tue, 21 Jun 2022 05:25:11 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B72443F534;
        Tue, 21 Jun 2022 05:25:09 -0700 (PDT)
Date:   Tue, 21 Jun 2022 13:25:28 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 03/23] lib: Add support for the XSDT
 ACPI table
Message-ID: <YrG4uFAJiskvTE2n@monolith.localdoman>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-4-nikos.nikoleris@arm.com>
 <Yq0eaaOiud8pOXZN@google.com>
 <YrA0yajcrohAOIoS@monolith.localdoman>
 <cea12393-ecf5-820d-81ae-0c8b9e81ceba@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cea12393-ecf5-820d-81ae-0c8b9e81ceba@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Jun 20, 2022 at 12:06:24PM +0100, Nikos Nikoleris wrote:
> Hi Alex, Ricardo,
> 
> Thank you both for the reviews!
> 
> On 20/06/2022 09:53, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Fri, Jun 17, 2022 at 05:38:01PM -0700, Ricardo Koller wrote:
> > > Hi Nikos,
> > > 
> > > On Fri, May 06, 2022 at 09:55:45PM +0100, Nikos Nikoleris wrote:
> > > > XSDT provides pointers to other ACPI tables much like RSDT. However,
> > > > contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
> > > > pointers. ACPI requires that if XSDT is valid then it takes precedence
> > > > over RSDT.
> > > > 
> > > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > > ---
> > > >   lib/acpi.h |   6 ++++
> > > >   lib/acpi.c | 103 ++++++++++++++++++++++++++++++++---------------------
> > > >   2 files changed, 68 insertions(+), 41 deletions(-)
> > > > 
> > > > diff --git a/lib/acpi.h b/lib/acpi.h
> > > > index 42a2c16..d80b983 100644
> > > > --- a/lib/acpi.h
> > > > +++ b/lib/acpi.h
> > > > @@ -13,6 +13,7 @@
> > > >   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
> > > >   #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
> > > > +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
> > > >   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
> > > >   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
> > > > @@ -56,6 +57,11 @@ struct rsdt_descriptor_rev1 {
> > > >       u32 table_offset_entry[0];
> > > >   } __attribute__ ((packed));
> > > > +struct acpi_table_xsdt {
> > > > +    ACPI_TABLE_HEADER_DEF
> > > > +    u64 table_offset_entry[1];
> > > 
> > > nit: This should be "[0]" to match the usage above (in rsdt).
> > > 
> > > I was about to suggest using an unspecified size "[]", but after reading
> > > what the C standard says about it (below), now I'm not sure. was the
> > > "[1]" needed for something that I'm missing?
> > > 
> > > 	106) The length is unspecified to allow for the fact that
> > > 	implementations may give array members different
> > > 	alignments according to their lengths.
> > 
> > GCC prefers "flexible array members" (array[]) [1]. Linux has deprecated
> > the use of zero-length arrays [2]. The kernel docs do make a pretty good
> > case for flexible array members.
> > 
> > [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> > [2] https://elixir.bootlin.com/linux/v5.18/source/Documentation/process/deprecated.rst#L234
> > 
> 
> Happy to change this, I don't have a strong preference. To be consistent
> with RSDT we would have to declare:
> 
> u64 table_offset_entry[0];
> 
> But it might be better to change RSDT as well. Linux kernel declares:
> 
> u64 table_offset_entry[1];
> 
> but it seems, we would rather have:
> 
> u64 table_offset_entry[];

Sorry, I didn't think about Linux when I wrote my reply. In my opinion, we
should keep our definitions aligned with Linux for two reasons:

- Makes making changes to the header file and borrowing code from Linux less
  error prone.

- Linux' implementation, even though it might not be ideal, is proven to be
  working.

It might also be that Linux uses table_offset_entry[1] for compatibility
with older compilers, and supporting the same compilers that Linux does
looks like a safe approach for me; I am not aware of an official policy for
kvm-unit-tests regarding compiler versions (might be one, it just that I
don't know about it!).

Thanks,
Alex
