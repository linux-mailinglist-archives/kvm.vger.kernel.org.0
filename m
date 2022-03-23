Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECE24E5291
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 13:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243536AbiCWM4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 08:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231730AbiCWM4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 08:56:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468917C165;
        Wed, 23 Mar 2022 05:55:14 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648040112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h7Mrb8Fsde3pJqBhXMbymwp59oXpDJjejh4OrYFjnM4=;
        b=hD7vXlWlc9G4Pn3agAJBeX4ZaHPKNxd5qebkoqv5Sx1/GV4HrZSFtGuKazVB2jm7f0sQMY
        fB/6Kt1X6k16xtAWEk8jWDT9rMynh6sxmyiVKs9aKLW4vKvhg9DgX4yOWks59eo089Q7ht
        oYrcjj3oFU+orOfxUSkg5oo8w88dVwmuy4081sEW+Zb/IawSaPeoc2dvqcSryTyiILDZXD
        1F7Z4+Al5Y0MF3DhfG8lo9q87NP/2F3O2IEWRMjBCy6mRM98TLKQqgqgQ4DdELmoNVWgeE
        wZwphF4UXUXDYEQbFA59dkk0REX7BBD6gxF7MECJYSLIhQ2kO/VEPCt6pwX8ng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648040112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h7Mrb8Fsde3pJqBhXMbymwp59oXpDJjejh4OrYFjnM4=;
        b=nRgb4kwZpe/J2hdx8rPoulcssST4IC/wXnTL0PSRWvXIqRIWH0pTVtb5U0imEkvX5VUTmJ
        d8ddEBunaWiUv4CQ==
To:     Paolo Bonzini <bonzini@gnu.org>, dave.hansen@linux.intel.com
Cc:     yang.zhong@intel.com, ravi.v.shankar@intel.com, mingo@redhat.com,
        "Chang S. Bae" <chang.seok.bae@intel.com>, bp@alien8.de,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>
Subject: Re: ping Re: [PATCH v4 0/2] x86: Fix ARCH_REQ_XCOMP_PERM and update
 the test
In-Reply-To: <87a6dgam7b.ffs@tglx>
References: <20220129173647.27981-1-chang.seok.bae@intel.com>
 <a0bded7d-5bc0-12b9-2aca-c1c92d958293@gnu.org> <87a6dgam7b.ffs@tglx>
Date:   Wed, 23 Mar 2022 13:55:11 +0100
Message-ID: <877d8kakwg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23 2022 at 13:27, Thomas Gleixner wrote:
> On Wed, Mar 23 2022 at 12:04, Paolo Bonzini wrote:
>> can this series be included in 5.18 and CCed to stable?
>
> working on it. There is another issue with that which I'm currently
> looking into.

The size calculation for the kernel state fails to take supervisor
states into account. Up to 5.18 that did not matter because ENQCMD/PASID
was disabled. But now it matters...

Thanks,

        tglx
---

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1625,6 +1625,8 @@ static int __xstate_request_perm(u64 per
 
 	/* Calculate the resulting kernel state size */
 	mask = permitted | requested;
+	/* Take supervisor states into account */
+	mask |= xfeatures_mask_supervisor();
 	ksize = xstate_calculate_size(mask, compacted);
 
 	/* Calculate the resulting user state size */
