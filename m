Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAA3C8346
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 12:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhGNK4g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 06:56:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229836AbhGNK4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 06:56:35 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4320E6117A;
        Wed, 14 Jul 2021 10:53:44 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m3cWL-00DGry-4a; Wed, 14 Jul 2021 11:53:41 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 14 Jul 2021 11:53:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com
Subject: Re: [PATCH 2/2] KVM: arm64: selftests: get-reg-list: actually enable
 pmu regs in pmu sublist
In-Reply-To: <20210713203742.29680-3-drjones@redhat.com>
References: <20210713203742.29680-1-drjones@redhat.com>
 <20210713203742.29680-3-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <c06f2f53614fa7f98e33a43d117a267a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-07-13 21:37, Andrew Jones wrote:
> We reworked get-reg-list to make it easier to enable optional register
> sublists by parametrizing their vcpu feature flags as well as making
> other generalizations. That was all to make sure we enable the PMU
> registers when we want to test them. Somehow we forgot to actually
> include the PMU feature flag in the PMU sublist description though!
> Do that now.

Ah! :D

> 
> Fixes: 313673bad871 ("KVM: arm64: selftests: get-reg-list: Split base
> and pmu registers")
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> index a16c8f05366c..cc898181faab 100644
> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
> @@ -1019,7 +1019,8 @@ static __u64 sve_rejects_set[] = {
>  #define VREGS_SUBLIST \
>  	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
>  #define PMU_SUBLIST \
> -	{ "pmu", .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
> +	{ "pmu", .capability = KVM_CAP_ARM_PMU_V3, .feature = 
> KVM_ARM_VCPU_PMU_V3, \
> +	  .regs = pmu_regs, .regs_n = ARRAY_SIZE(pmu_regs), }
>  #define SVE_SUBLIST \
>  	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE,
> .finalize = true, \
>  	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \

Good timing, I'm queuing fixes. I'll pick those in a moment.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
