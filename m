Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE6633462E
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCJSB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:01:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233368AbhCJSB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 13:01:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3ED3964FAB;
        Wed, 10 Mar 2021 18:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615399286;
        bh=nmBnWUW/EBCBjUO3cuezAL9YIQYYT7/E+Zau1+tfllg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LZEU0AHJCK4sl63V+mLsSn1vNnJ5QckmFW1n7FsbcSW/OkuERkVtRJoQe8JOrkXXb
         uWWwFKGldFtGhY0jeevpHEwqnZy1/nTcHEfihFfOXb/8dwjJ4r8jsfwyjU7Pja8oV3
         hVWV46xTpLIc7WXdtSUEBlmGtPj2k1Tkvd20ZkaUSiDiQVS+j9lQMzgSHip1+y/NvU
         uMJc/U56CJxidI8Pp1+f+4k6KMvRA0whJzO8he023+D0a7dWq4wAmRzKuT/dAE+J0O
         lj18VMhTTZXce8wmQXP7jD/aL1ly8uhQdGzQQYRmiuvWV9cxSWt4hiIA5SEWewwJ9L
         0QJBqVv3lhbrQ==
Date:   Wed, 10 Mar 2021 20:01:02 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Kai Huang <kai.huang@intel.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, jethro@fortanix.com,
        b.thiel@posteo.de, jmattson@google.com, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-ID: <YEkJXu262YDa8ZaK@kernel.org>
References: <cover.1615250634.git.kai.huang@intel.com>
 <20210309093037.GA699@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309093037.GA699@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 10:30:37AM +0100, Borislav Petkov wrote:
> On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > This series adds KVM SGX virtualization support. The first 14 patches starting
> > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> objectionable then give Paolo an immutable commit to base the KVM stuff
> ontop.
> 
> Unless folks have better suggestions, ofc.

I'm otherwise cool with that, except patch #2.

It's based on this series:

https://lore.kernel.org/linux-sgx/20210113233541.17669-1-jarkko@kernel.org/

It's not reasonable to create driver specific wrapper for
sgx_free_epc_page() because there is exactly *2* call sites of the function
in the driver.  The driver contains 10 call sites (11 after my NUMA patches
have been applied) of sgx_free_epc_page() in total.

Instead, it is better to add explicit EREMOVE to those call sites.

The wrapper only trashes the codebase. I'm not happy with it, given all the
trouble to make it clean and sound.

> Thx.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette


/Jarkko
