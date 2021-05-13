Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AD37F68B
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhEMLQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233273AbhEMLPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 07:15:33 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448E7613CB;
        Thu, 13 May 2021 11:14:24 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lh9IM-001C2V-Cr; Thu, 13 May 2021 12:14:22 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 13 May 2021 12:14:22 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, drjones@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: arm64: selftests: Request PMU feature in
 get-reg-list
In-Reply-To: <20210513130655.73154-1-gshan@redhat.com>
References: <20210513130655.73154-1-gshan@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-05-13 14:06, Gavin Shan wrote:
> Since the following commit, PMU registers are hidden from user until
> it's explicitly requested by feeding feature (KVM_ARM_VCPU_PMU_V3).
> Otherwise, 74 missing PMU registers are missing as the following
> log indicates.
> 
>    11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when
> not available")
> 
>    # ./get-reg-list
>    Number blessed registers:   308
>    Number registers:           238
> 
>    There are 74 missing registers.
>    The following lines are missing registers:
> 
>       	ARM64_SYS_REG(3, 0, 9, 14, 1),
> 	ARM64_SYS_REG(3, 0, 9, 14, 2),
>              :
> 	ARM64_SYS_REG(3, 3, 14, 15, 7),
> 
> This fixes the issue of wrongly reported missing PMU registers by
> requesting it explicitly.
> 
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index 486932164cf2..6c6bdc6f5dc3 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -314,6 +314,8 @@ static void core_reg_fixup(void)
> 
>  static void prepare_vcpu_init(struct kvm_vcpu_init *init)
>  {
> +	init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
> +
>  	if (reg_list_sve())
>  		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
>  }

Please see Andrew's series[1], which actually deals with options.

         M.

[1] https://lore.kernel.org/r/20210507200416.198055-1-drjones@redhat.com
-- 
Jazz is not dead. It just smells funny...
