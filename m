Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE1437B472
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 05:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhELDVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 23:21:25 -0400
Received: from ozlabs.org ([203.11.71.1]:51885 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230115AbhELDVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 23:21:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Fg0R41KWyz9sSs;
        Wed, 12 May 2021 13:20:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1620789616;
        bh=B7bwN8TGq/XZZxAawjw/TbSLhlFTW9dhi19LbHpXU+I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=JKjxrgHjtGz8SZ8PBhyqW7xbbXsyEQYnLz0GshsaBHyP0OESW3EzsnTzoZfzvT/NG
         quJ37NmTwLbKzIO0VDVtvSbky+i44eNlIq0Fmsk87gduhFreQjvUOAFk+/qSSKTiMM
         B4b6CcSx13IoZXyp8IwI/ZHRdaTt6i46S/qFF5oSNYAk9sVkWRCfNJ5shupPG2B7sR
         3+bA4VB6uqgLzPJcgO7okXeOmoWwhMZE/kFRbXmTt5FT4kR/9JNDkai78WZ/pO0FMt
         6LrSK0YL4SmA8CrMWLSCwWjRIWYk68YJK3NknUyTNfCThEeLg2KIr45e2Lfd0f5gYi
         wiLHK2jSmU1Mg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: PPC: Book3S HV: Fix kvm_unmap_gfn_range_hv() for
 Hash MMU
In-Reply-To: <YJqzJyBvU0A8VG9p@google.com>
References: <20210511105459.800788-1-mpe@ellerman.id.au>
 <YJqzJyBvU0A8VG9p@google.com>
Date:   Wed, 12 May 2021 13:20:15 +1000
Message-ID: <87lf8ky6xc.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:
> On Tue, May 11, 2021, Michael Ellerman wrote:
>> Commit 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based
>> MMU notifier callbacks") fixed kvm_unmap_gfn_range_hv() by adding a for
>> loop over each gfn in the range.
>> 
>> But for the Hash MMU it repeatedly calls kvm_unmap_rmapp() with the
>> first gfn of the range, rather than iterating through the range.
>> 
>> This exhibits as strange guest behaviour, sometimes crashing in firmare,
>> or booting and then guest userspace crashing unexpectedly.
>> 
>> Fix it by passing the iterator, gfn, to kvm_unmap_rmapp().
>> 
>> Fixes: 32b48bf8514c ("KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU notifier callbacks")
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> I plan to take this via the powerpc fixes branch.
>
> FWIW,
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Thanks.

cheers
