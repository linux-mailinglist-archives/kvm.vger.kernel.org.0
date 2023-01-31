Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F236827F5
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjAaJCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjAaJCI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:02:08 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83D654C6EA;
        Tue, 31 Jan 2023 00:58:33 -0800 (PST)
Received: from 8bytes.org (p5b006afb.dip0.t-ipconnect.de [91.0.106.251])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 68D1C2240D5;
        Tue, 31 Jan 2023 09:57:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1675155445;
        bh=HND3GhRQqeOUknErw80DpidVfZ5cmPK3Nh8LxM5ynBA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fAbfc0JEueUVQyWR48ST1c9tf6NNWpXRpGXbW11UWVXJFmMrv3ZrX96q68FEPiSW6
         KqpKSv/6GcMLVW2SJjc5KVwXh0uetPwEuT6aOR4409RKV+4aU3wLEYcnvCU/jKPT7Z
         eIw0ozyu7Li6FEsz9tNbP6QnxOYCGdG13yNpteVI14Ig/ZeJW4EN5EcOgzuJnseKVV
         +hBnVrVkQBhSmvmsbCy/K9MOiO7vfr0IrUaQhRf1+CAQeS1YXBTu4nA3Lzyf6G/tp5
         JQ0vaiXJM8VVOYuiqqxUMS52gmQlgKNmch8Su25qBBS31n1hTroiIQ/lNirtb1HGKp
         kJAt+lq0K5O2A==
Date:   Tue, 31 Jan 2023 09:57:24 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     Alexey Kardashevskiy <aik@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [Question PATCH kernel] x86/amd/sev/nmi+vc: Fix stack handling
 (why is this happening?)
Message-ID: <Y9jX9AKYP8H34wGI@8bytes.org>
References: <20230127035616.508966-1-aik@amd.com>
 <Y9OUfofjxDtTmwyV@hirez.programming.kicks-ass.net>
 <Y9OpcoSacyOkPkvl@8bytes.org>
 <b7880f0b-a592-cf2d-03b9-1ccfd83f8223@amd.com>
 <Y9QI9JwCVvRmtbr+@8bytes.org>
 <3bb3e080-caee-8bc8-7de9-f44969f16e75@amd.com>
 <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38C572D7-E637-48C2-A57A-E62D44FF19BB@zytor.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 09:30:38AM -0800, H. Peter Anvin wrote:
> It's somewhat odd to me that reading %dr7 is volatile, but %dr6 is
> not... %dr6 is the status register!

The reason is that on SEV-ES only accesses to DR7 will cause #VC
exceptions, DR0-DR6 are not intercepted.

Regards,

	Joerg

