Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCB077F65B
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 14:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbjHQMVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 08:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350902AbjHQMVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 08:21:50 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6611030CF;
        Thu, 17 Aug 2023 05:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692274872;
        bh=sLthMGDrejd/+Upyz0eADzLiwIR8d6FGoid5g5aROAs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=fyK30UdMARTCEL0DhU0ZobRNv7juNp+cglDorOULB/oR7vFlum5jGurL316AFaTxa
         pkvrH2XVNiKIv/NZQva5jX9AVjHBM86hmnxsMtM8BS0HH1J/S71pl1eJk7I3gxPovM
         ZRkmKSQCyGROHjrouAKDud0QtEYn2/WXqXpnHWEGnPkt+uEBKoJI8Go2hIUowQKmiN
         tPNLUxgii+DIDCASmNzJO7YhROkSw58E3PLB4Wt1gP1tTyozgaamL1O1fxs07Avewd
         4pIIru7p21N+HdgX1VOVgp1mU48XiZlZCFVzwamou9KImxaKzWogO5YYRa+iRgLRFN
         HTlfRMXT9gKXg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RRPHX4kpbz4wZx;
        Thu, 17 Aug 2023 22:21:12 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jordan Niethe <jniethe5@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
In-Reply-To: <20230807014553.1168699-5-jniethe5@gmail.com>
References: <20230807014553.1168699-1-jniethe5@gmail.com>
 <20230807014553.1168699-5-jniethe5@gmail.com>
Date:   Thu, 17 Aug 2023 22:21:08 +1000
Message-ID: <87a5upeu6j.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jordan Niethe <jniethe5@gmail.com> writes:
> The LPID register is 32 bits long. The host keeps the lpids for each
> guest in an unsigned word struct kvm_arch. Currently, LPIDs are already
> limited by mmu_lpid_bits and KVM_MAX_NESTED_GUESTS_SHIFT.
>
> The nestedv2 API returns a 64 bit "Guest ID" to be used be the L1 host
> for each L2 guest. This value is used as an lpid, e.g. it is the
> parameter used by H_RPT_INVALIDATE. To minimize needless special casing
> it makes sense to keep this "Guest ID" in struct kvm_arch::lpid.
>
> This means that struct kvm_arch::lpid is too small so prepare for this
> and make it an unsigned long. This is not a problem for the KVM-HV and
> nestedv1 cases as their lpid values are already limited to valid ranges
> so in those contexts the lpid can be used as an unsigned word safely as
> needed.
>
> In the PAPR, the H_RPT_INVALIDATE pid/lpid parameter is already
> specified as an unsigned long so change pseries_rpt_invalidate() to
> match that.  Update the callers of pseries_rpt_invalidate() to also take
> an unsigned long if they take an lpid value.
>
> Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
> ---

This needs:

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index 709ebd578394..08e32b44ee32 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -857,7 +857,7 @@ unsigned long kvmppc_h_svm_init_done(struct kvm *kvm)
        }

        kvm->arch.secure_guest |= KVMPPC_SECURE_INIT_DONE;
-       pr_info("LPID %d went secure\n", kvm->arch.lpid);
+       pr_info("LPID %lu went secure\n", kvm->arch.lpid);

 out:
        srcu_read_unlock(&kvm->srcu, srcu_idx);

cheers
