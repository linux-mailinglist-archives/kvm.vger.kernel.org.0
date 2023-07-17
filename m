Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F7755C19
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 08:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjGQGug (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 02:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjGQGue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 02:50:34 -0400
Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [IPv6:2001:41d0:1004:224b::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0209EE6D
        for <kvm@vger.kernel.org>; Sun, 16 Jul 2023 23:50:32 -0700 (PDT)
Date:   Mon, 17 Jul 2023 08:50:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689576630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rdjnG9KSgHGUuHJshf606dH+Q25wQfX+wSglBAOxsNU=;
        b=r6qEVg8qskHTK9mb7Xxm0iIil54THr/HF8riWUNLXXazt5wFW2Muc2ct3LUd74FtVADiCZ
        9cZ0iGaMfkpP3Y5JQoRP7k5qYZjtQJw6OkVUro8TDHQgFHV0PoMUEwydKS7xGNV7wK4fdt
        fl31kBQ6W+wQpPBdwKABCK3IKIyx5GY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <namit@vmware.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Message-ID: <20230717-52b1cacc323e5105506e5079@orel>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
 <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
 <94bd19db-7177-9e90-dc1a-de7485ebb18f@redhat.com>
 <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57A6ABC7-8A95-4199-92E3-FA4D89D6705F@vmware.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023 at 06:42:25PM +0000, Nadav Amit wrote:
> 
> 
> > On Jul 14, 2023, at 4:29 AM, Shaoqin Huang <shahuang@redhat.com> wrote:
> > 
> > !! External Email
> > 
> > Hi,
> > 
> > On 7/14/23 18:31, Alexandru Elisei wrote:
> >> Hi,
> >> 
> >> On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
> >>> From: Nadav Amit <namit@vmware.com>
> >>> 
> >>> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.
> >> 
> >> In arm/cstart64.S
> >> 
> >> .globl start
> >> start:
> >>         /* get our base address */
> >>      [..]
> >> 
> >> 1:
> >>         /* zero BSS */
> >>      [..]
> >> 
> >>         /* zero and set up stack */
> >>      [..]
> >> 
> >>         /* set SCTLR_EL1 to a known value */
> >>         ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
> >>      [..]
> >> 
> >>         /* set up exception handling */
> >>         bl      exceptions_init
> >>      [..]
> >> 
> >> Where in lib/arm64/asm/sysreg.h:
> >> 
> >> #define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
> >>                          _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> >> #define INIT_SCTLR_EL1_MMU_OFF  \
> >>                         SCTLR_EL1_RES1
> >> 
> >> Look like bit 23 (SPAN) should be set.
> >> 
> >> How are you seeing SCTLR_EL1.SPAN unset?
> > 
> > Yeah. the sctlr_el1.SPAN has always been set by the above flow. So Nadav
> > you can describe what you encounter with more details. Like which tests
> > crash you encounter, and how to reproduce it.
> 
> I am using Nikos’s work to run the test using EFI, not from QEMU.
> 
> So the code that you mentioned - which is supposed to initialize SCTLR -
> is not executed (and actually not part of the EFI image).
> 
> Note that using EFI, the entry point is _start [1], and not “start”.
> 
> That is also the reason lack of BSS zeroing also caused me issues with the
> EFI setup, which I reported before.

Nadav,

Would you mind reposting this along with the BSS zeroing patch, the
way I proposed we do that, and anything else you've discovered when
trying to use the EFI unit tests without QEMU? We'll call that our
first non-QEMU EFI support series, since the first EFI series was
only targeting QEMU.

Thanks,
drew

> 
> 
> 
> [1] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/blob/master/arm/efi/crt0-efi-aarch64.S#L113
> 


