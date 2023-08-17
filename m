Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B334377EFCF
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348012AbjHQEUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 00:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347985AbjHQETr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 00:19:47 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C05F272B;
        Wed, 16 Aug 2023 21:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692245983;
        bh=46yCubrxx63LRVgs79NO4hFXQN620KYczJPZ0H00CuY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lE4JMBK30qnpZWrJz4xFHBgGig/yKUZ+TibmZnye0s8WDrUpJDF4tBEVHOaiguYDM
         O1tuycU+HIudU18qQ3bocu47yYK5moYKRW6obq+2MriTiZu8nHQe05bF9kSA/RdyNV
         MkMPTdEm5i6P2yDEt93dK4Clz0IUh6oizkEG7TUjTwqc/zDVuPUNpE7F5d0UUD7u1t
         52woLK6Rx5mtGHvGgbvPFcQfPOiI8i3fZtarRXbT2B8hI3zt4b1W7N4P3eFr6cQ3cm
         8kp797Lo1sszlr/wjWrrRyia6YYY8u/Y4ymiCTcI3SJu9QgMNOIRbQnovABEdgOqfY
         i2vFNiNsMyghQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RRBbz1857z4wZn;
        Thu, 17 Aug 2023 14:19:43 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH v3 5/6] KVM: PPC: Add support for nestedv2 guests
In-Reply-To: <20230807014553.1168699-6-jniethe5@gmail.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-6-jniethe5@gmail.com>
Date:   Thu, 17 Aug 2023 14:19:38 +1000
Message-ID: <87a5uq712d.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jordan Niethe <jniethe5@gmail.com> writes:
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2357545dffd7..7d5edbc6ecd9 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4165,7 +4231,10 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
>  	vcpu_vpa_increment_dispatch(vcpu);
>  
>  	if (kvmhv_on_pseries()) {
> -		trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
> +		if (kvmhv_is_nestedv1())
> +			trap = kvmhv_vcpu_entry_p9_nested(vcpu, time_limit, lpcr, tb);
> +		else if (kvmhv_is_nestedv2())
> +			trap = kvmhv_vcpu_entry_nestedv2(vcpu, time_limit, lpcr, tb);

Clang warns:

/linux/arch/powerpc/kvm/book3s_hv.c:4236:12: error: variable 'trap' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
                else if (kvmhv_is_nestedv2())
                         ^~~~~~~~~~~~~~~~~~~
/linux/arch/powerpc/kvm/book3s_hv.c:4240:7: note: uninitialized use occurs here
                if (trap == BOOK3S_INTERRUPT_SYSCALL && !nested &&
                    ^~~~
/linux/arch/powerpc/kvm/book3s_hv.c:4236:8: note: remove the 'if' if its condition is always true
                else if (kvmhv_is_nestedv2())
                     ^~~~~~~~~~~~~~~~~~~~~~~~
/linux/arch/powerpc/kvm/book3s_hv.c:4219:10: note: initialize the variable 'trap' to silence this warning
        int trap;
                ^
                 = 0

cheers
