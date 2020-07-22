Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1959228F41
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 06:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGVEiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 00:38:08 -0400
Received: from ozlabs.org ([203.11.71.1]:52763 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgGVEiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 00:38:08 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BBN4Z1SHPz9sSt;
        Wed, 22 Jul 2020 14:38:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1595392686;
        bh=+UMHJPVwgl4Xx+nAF4LfZpg+F8EXxX6RQrkl8G38zfw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pQVgS2a0qHdVxcPxWA4+DD/AphAftqF5lssILA3yqNkS9xVQXbI4NI4hMZa4tpcKW
         A8T8fqUFsKnT2O3HO319G37Wk40+vqxL2V7PWhsD8adtt/fK3NpR9Y9gQhceTQszzK
         fHqF4pKjW8wQLiAR5v0gT5Ij7cYdoCrdCxhckY7JUrwijW9JJIj7IltySyx0eIi748
         gP5HUAqp1sPSmIplUDpuzVwezK7xv3uY9Orcsz/MFLfMxFgLPBJPbL67jRzjtQOtZU
         +mZsGK8PtywLli6g0qAy62utOfY/zK3MzM7uFlUEFdVv6cKFA6+fX0nXk9e9ek/sKk
         pQrOzfB+tACqg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, maddy@linux.vnet.ibm.com,
        mikey@neuling.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        ego@linux.vnet.ibm.com, svaidyan@in.ibm.com, acme@kernel.org,
        jolsa@kernel.org
Subject: Re: [v3 02/15] KVM: PPC: Book3S HV: Cleanup updates for kvm vcpu MMCR
In-Reply-To: <20200721035420.GA3819606@thinks.paulus.ozlabs.org>
References: <1594996707-3727-1-git-send-email-atrajeev@linux.vnet.ibm.com> <1594996707-3727-3-git-send-email-atrajeev@linux.vnet.ibm.com> <20200721035420.GA3819606@thinks.paulus.ozlabs.org>
Date:   Wed, 22 Jul 2020 14:38:05 +1000
Message-ID: <87v9igqi4y.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paul Mackerras <paulus@ozlabs.org> writes:
> On Fri, Jul 17, 2020 at 10:38:14AM -0400, Athira Rajeev wrote:
>> Currently `kvm_vcpu_arch` stores all Monitor Mode Control registers
>> in a flat array in order: mmcr0, mmcr1, mmcra, mmcr2, mmcrs
>> Split this to give mmcra and mmcrs its own entries in vcpu and
>> use a flat array for mmcr0 to mmcr2. This patch implements this
>> cleanup to make code easier to read.
>
> Changing the way KVM stores these values internally is fine, but
> changing the user ABI is not.  This part:
>
>> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
>> index 264e266..e55d847 100644
>> --- a/arch/powerpc/include/uapi/asm/kvm.h
>> +++ b/arch/powerpc/include/uapi/asm/kvm.h
>> @@ -510,8 +510,8 @@ struct kvm_ppc_cpu_char {
>>  
>>  #define KVM_REG_PPC_MMCR0	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x10)
>>  #define KVM_REG_PPC_MMCR1	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x11)
>> -#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
>> -#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)
>> +#define KVM_REG_PPC_MMCR2	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x12)
>> +#define KVM_REG_PPC_MMCRA	(KVM_REG_PPC | KVM_REG_SIZE_U64 | 0x13)
>
> means that existing userspace programs that used to work would now be
> broken.  That is not acceptable (breaking the user ABI is only ever
> acceptable with a very compelling reason).  So NAK to this part of the
> patch.

I assume we don't have a KVM unit test that would have caught this?

cheers
