Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449EB65B709
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 21:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbjABUCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 15:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjABUCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 15:02:18 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E58521B4;
        Mon,  2 Jan 2023 12:02:17 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A059F1EC0518;
        Mon,  2 Jan 2023 21:02:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672689735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=QfkRnZ8rB5PER1Hjpd4mBmBLogx74L19nz9zOgfhl18=;
        b=qa8K5TXi6a8VfthYzIFjpTBIjFj9eQJSPfIH1VQ+mfjfiEupRte6mF4aGmAC4I7NISFiR5
        w9CBxK9iP8YjzP6eBf13M8VU3T/dKlHqWigm+ODKHeRNYDHkeHtp3QfFZhhytSzlN4T7BU
        8ueypGzaB2bJTgAKDXztWIbzDKbyfBc=
Date:   Mon, 2 Jan 2023 21:02:11 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, thomas.lendacky@amd.com, michael.roth@amd.com,
        stable@kernel.org
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y7M4IzNYBtfEJe6Z@zn.tnic>
References: <20230102083810.71178-1-nikunj@amd.com>
 <3169b54b-d990-7707-5ec4-cde7261318fe@google.com>
 <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <45487a87-764a-7ff3-292b-4a55fe29f7ba@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 02, 2023 at 08:50:23PM +0530, Nikunj A. Dadhania wrote:
> >> +		/*
> >> +		 * Terminate the boot if hypervisor has enabled any feature
> >> +		 * lacking guest side implementation.
> >> +		 */
> >> +		if (sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT)
> >> +			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
> > 
> > We can't help out by specifying which feature(s)?
> 
> The purpose of SNP_FEATURES_PRESENT is just that, at present no features that need guest 
> implementation is part of the kernel. For e.g. I will be posting patches with SecureTSC 
> enabled, that will make the following change.

I think what David means is, can we have sev_es_terminate() say exactly which
feature wasn't implemented instead of users having to dig out which one exactly
wasn't by trying to find out what their SNP_FEATURES_IMPL_REQ and
SNP_FEATURES_PRESENT masks are.

Looking at the GHCB protocol, where GHCB_SNP_FEAT_NOT_IMPLEMENTED reason code
goes is GHCBData[23:16] which is not enough... And the VMSA has SEV_FEATURES but
that's guest-only.

I guess we need a way to communicate those masks in a more user-friendly way so
that it is exactly clear because of which missing feature(s) has the guest
terminated.

Hmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
