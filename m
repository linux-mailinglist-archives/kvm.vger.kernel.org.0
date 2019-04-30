Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4121F3D8
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 12:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbfD3KMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 06:12:08 -0400
Received: from ozlabs.org ([203.11.71.1]:37659 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbfD3KL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 06:11:56 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44tckx4sQPz9sB8; Tue, 30 Apr 2019 20:11:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556619113; bh=AQeVPSFLu79BGPceGwtpJuSoVxK5dJm5025Eey/7Fv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Rnja0K5AVpCienJcHXlGDKnAOc2y+X9Y8Owiau8x7dNzJ5ALsrsOjXYC3LIucQvLR
         MZ4imMhJ4iTm4Si/P9wji6IOGO9k1h0rZQqXXg/Yz1+Xfolj8vsoCiyxXOi1OcsSVg
         N1lqxX3lwto4yvV7TUSl52NVCFdj4HQa9T3eWzs70jog62S0RFlOI3GZIAk+3MtSAA
         ghexFAFmOmsZqLh2PwlapzUgXNhqUbiXvy7aPAiAx+/sNx/tTaSpU7JyFVBRnlWfLq
         kF5lmPiC1Zt69V4WAtV6iuujBlevv/lNind8gb+cOf2zFWSwCMfztOXLw9E1kAFnuu
         j3gltX9FPFqGg==
Date:   Tue, 30 Apr 2019 20:07:48 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Handle virtual mode in XIVE VCPU
 push code
Message-ID: <20190430100748.GG32205@blackberry>
References: <20190429085745.GA17146@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429085745.GA17146@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 29, 2019 at 06:57:45PM +1000, Paul Mackerras wrote:
> From: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> 
> The code in book3s_hv_rmhandlers.S that pushes the XIVE virtual CPU
> context to the hardware currently assumes it is being called in real
> mode, which is usually true.  There is however a path by which it can
> be executed in virtual mode, in the case where indep_threads_mode = N.
> A virtual CPU executing on an offline secondary thread can take a
> hypervisor interrupt in virtual mode and return from the
> kvmppc_hv_entry() call after the kvm_secondary_got_guest label.
> It is possible for it to be given another vcpu to execute before it
> gets to execute the stop instruction.  In that case it will call
> kvmppc_hv_entry() for the second VCPU in virtual mode, and the XIVE
> vCPU push code will be executed in virtual mode.  The result in that
> case will be a host crash due to an unexpected data storage interrupt
> caused by executing the stdcix instruction in virtual mode.
> 
> This fixes it by adding a code path for virtual mode, which uses the
> virtual TIMA pointer and normal load/store instructions.
> 
> [paulus@ozlabs.org - wrote patch description]
> 
> Signed-off-by: Paul Mackerras <paulus@ozlabs.org>

Patch applied to my kvm-ppc-next tree.

Paul.
