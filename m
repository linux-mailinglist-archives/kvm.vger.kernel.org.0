Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A8F142C0B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 14:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgATN0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 08:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgATN0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jan 2020 08:26:35 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E5E521835;
        Mon, 20 Jan 2020 13:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579526794;
        bh=klYwhSlzXGsDXrYWVAaBb32aIuKy3FUULwLCrFi2k0c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FwF+8LB/UCFSgtVn0ih4G4gqnqAVSZjaeZM8Jq/DOgl1pngNGCGMNDMHmbN+bcjoG
         jyDtt2PLwsQeXv3ysNL8YlYrjJsTVuoR6u4h8bvhUOEOjbjMAtgFDPAIeC3sH32+hp
         syxisp4DxaTeQ9fFXoP9L8bbkl7qf0+5QIjwN7Fc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1itX4a-000HFR-O1; Mon, 20 Jan 2020 13:26:32 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 20 Jan 2020 13:26:32 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH] arm64: KVM: Add XXX UAPI notes for swapped registers
In-Reply-To: <20200120130825.28838-1-drjones@redhat.com>
References: <20200120130825.28838-1-drjones@redhat.com>
Message-ID: <99903fdb3e0d34cb7957981b484fc28c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

Many thanks for this. Comments below.

On 2020-01-20 13:08, Andrew Jones wrote:
> Two UAPI system register IDs do not derive their values from the
> ARM system register encodings. This is because their values were
> accidentally swapped. As the IDs are API, they cannot be changed.
> Add XXX notes to point them out.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt    |  8 ++++++++
>  arch/arm64/include/uapi/asm/kvm.h | 11 +++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt 
> b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..11556fc457c3 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -2196,6 +2196,14 @@ arm64 CCSIDR registers are demultiplexed by 
> CSSELR value:
>  arm64 system registers have the following id bit patterns:
>    0x6030 0000 0013 <op0:2> <op1:3> <crn:4> <crm:4> <op2:3>
> 
> +XXX: Two system register IDs do not follow the specified pattern.  
> These
> +     are KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT, which map 
> to
> +     system registers CNTV_CVAL_EL0 and CNTVCT_EL0 respectively.  
> These
> +     two had their values accidentally swapped, which means TIMER_CVAL 
> is
> +     derived from the register encoding for CNTVCT_EL0 and TIMER_CNT 
> is
> +     derived from the register encoding for CNTV_CVAL_EL0.  As this is
> +     API, it must remain this way.

Is 'XXX' an establiched way of documenting this kind of misfeature?
I couldn't find any other occurrence in Documentation, but I haven't
searched very hard.

If nobody has a better idea, I'll queue it as is.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
