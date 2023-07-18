Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 516BB7576F1
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 10:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjGRIod (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 04:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjGRIoc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 04:44:32 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20AD1ED
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 01:44:31 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 231F92F4;
        Tue, 18 Jul 2023 01:45:14 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7FDF83F67D;
        Tue, 18 Jul 2023 01:44:29 -0700 (PDT)
Date:   Tue, 18 Jul 2023 09:44:26 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nadav Amit <namit@vmware.com>
Cc:     Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Shaoqin Huang <shahuang@redhat.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Message-ID: <ZLZQ6r4-9mVdg4Ry@monolith.localdoman>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
 <20230717-52b1cacc323e5105506e5079@orel>
 <20230717-085f1ee1d631f213544fed03@orel>
 <8d4c1105-bf9b-d4b0-a2a3-be306474bf56@arm.com>
 <4C6E9B6F-1879-48FB-98B6-6F271982067D@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C6E9B6F-1879-48FB-98B6-6F271982067D@vmware.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Jul 17, 2023 at 05:05:06PM +0000, Nadav Amit wrote:
> Combining the answers to Andrew and Nikos.
> 
> On Jul 17, 2023, at 1:53 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
> > 
> >>> 
> >>> Would you mind reposting this along with the BSS zeroing patch, the
> >>> way I proposed we do that, and anything else you've discovered when
> >>> trying to use the EFI unit tests without QEMU? We'll call that our
> >>> first non-QEMU EFI support series, since the first EFI series was
> >>> only targeting QEMU.
> 
> I need to rehash the solution that you proposed for BSS (if there is
> anything special there). I had a different workaround for that issue,
> because IIRC I had some issues with the zeroing. I’ll give it another
> 
> >> 
> >> Oh, and I meant to mention that, when reposting this patch, maybe we
> >> can consider managing sctlr in a similar way to the non-efi start path?
> >> 
> 
> I am afraid of turning on random bits on SCTLR. Arguably, the way that

What do you mean by turning on random bits on SCTLR? All the functional
bits are documented in the architecture. Same goes for RES1 (it's in the
Glossary).

> the non-efi test sets the default value of SCTLR (with no naming of the
> different bits) is not very friendly.

That's because as the architecture gets updated, what used to be a RES1 bit
becomes a functional bit. The only sane way to handle this is to disable
all the features you don't support, **and** set all the RES1 bits (and
clear RES0 bits), to disable any newly introduced features you don't know
about yet which were left enabled by software running at a higher privilege
level.

You can send a patch if you want to give a name to the bits which have
become functional since SCTLR_EL1_RES1 was introduced.

Thanks,
Alex

> 
> I will have a look on the other bits of SCTLR and see if I can do something
> quick and simple, but I don’t want to refactor things in a way that might
> break things.
> 
> > 
> > Nadav, if you are running baremetal, it might be worth checking what EL
> > you're running in as well. If HW is implementing EL2, EFI will handover
> > in EL2.
> 
> I don’t. I run the test on a different hypervisor. When I enabled the x86
> tests to run on a different hypervisor years ago, there were many many
> test and real issues that required me to run KVM-unit-tests on bare
> metal - and therefore I fixed these tests to run on bare-metal as well.
> 
> With ARM, excluding the BSS and the SCTLR issue, I didn’t encounter any
> additional test issues. So I don’t have the need or time to enable it
> to run on bare-metal… sorry.
>  
