Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E942D39AA
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 05:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgLIEhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 23:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgLIEhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 23:37:36 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB13BC0613CF;
        Tue,  8 Dec 2020 20:36:55 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4CrPQY6Dvbz9sWL; Wed,  9 Dec 2020 15:36:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607488613; bh=4qK0Qeph9aujlXGIFVNGaEAyJsEJ75znCDH6aXQBnaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=saNnipqailTWZYEW7o1ETFKqbdiCFVgtlrhAlbhLtiElZxzzwFEmnfrXPdhBgys+a
         d0gWxSbTajAn5DXmA7bQthrlka5qpKKBNb0qzC5wHWZfEKW9R5UbkP/aeUOBiWnzOp
         mvs92dvWGLufV0p3b/bsxctGKwxuID2zW33fh1P0aOnWWlSCPtJfzelfqljdkxhv5u
         scToA9zMk+qWYvWTpaZH0dZi6DIN4IX7CmFf+0qa945U/7r7vAlCj75hxjI8ngjxPb
         4UU3yHvWOQitK25dHPKpKMuTBleyugeZWWYLEbhnxOX1u40KESNUmiwjJsCS6u+f7/
         6cz08KAshW+3Q==
Date:   Wed, 9 Dec 2020 15:36:48 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc:     mpe@ellerman.id.au, mikey@neuling.org, npiggin@gmail.com,
        leobras.c@gmail.com, pbonzini@redhat.com, christophe.leroy@c-s.fr,
        jniethe5@gmail.com, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 4/4] KVM: PPC: Introduce new capability for 2nd DAWR
Message-ID: <20201209043648.GB29825@thinks.paulus.ozlabs.org>
References: <20201124105953.39325-1-ravi.bangoria@linux.ibm.com>
 <20201124105953.39325-5-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201124105953.39325-5-ravi.bangoria@linux.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 24, 2020 at 04:29:53PM +0530, Ravi Bangoria wrote:
> Introduce KVM_CAP_PPC_DAWR1 which can be used by Qemu to query whether
> kvm supports 2nd DAWR or not.

This should be described in Documentation/virt/kvm/api.rst.

Strictly speaking, it should be a capability which is disabled by
default, so the guest can only do the H_SET_MODE to set DAWR[X]1 if it
has been explicitly permitted to do so by userspace (QEMU).  This is
because we want as little as possible of the VM configuration to come
from the host capabilities rather than from what userspace configures.

So what we really need here is for this to be a capability which can
be queried by userspace to find out if it is possible, and then
enabled by userspace if it wants.  See how KVM_CAP_PPC_NESTED_HV is
handled for example.

Paul.
