Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06E0740E03
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 12:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjF1KFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 06:05:44 -0400
Received: from mail.xen0n.name ([115.28.160.31]:49980 "EHLO
        mailbox.box.xen0n.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232646AbjF1Jvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 05:51:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1687945890; bh=mERR5o/6GAasOdmhfFEv0s0jaV6yQdbTTBXBhqFAqgI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ag+B3SY2EAgFH+HU437SHcr9olebrpCEhzkgGhOszvll4+B2qkAon0dWQPULujxqZ
         HtSHHGOTWf0z5sZCcNI88A/TucYf0UT/cq/COITvzTEPtOsd6cI+elKhe3jo2WQCzh
         iKK29Zl+6XHUqPRR0+zbcAkiDZ1NCjaPRn/LjwEY=
Received: from [100.100.34.13] (unknown [220.248.53.61])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id B59C7600A6;
        Wed, 28 Jun 2023 17:51:29 +0800 (CST)
Message-ID: <cfc87f85-3a09-8a9e-4258-4fb1fd8013ab@xen0n.name>
Date:   Wed, 28 Jun 2023 17:51:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH v15 27/30] LoongArch: KVM: Implement vcpu world switch
Content-Language: en-US
To:     zhaotianrui <zhaotianrui@loongson.cn>,
        Jinyang He <hejinyang@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, tangyouling@loongson.cn
References: <20230626084752.1138621-1-zhaotianrui@loongson.cn>
 <20230626084752.1138621-28-zhaotianrui@loongson.cn>
 <f648a182-7c26-5bbc-6ae5-584af26e9db1@loongson.cn>
 <7017277c-3721-b417-5215-491efae7c8a9@loongson.cn>
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <7017277c-3721-b417-5215-491efae7c8a9@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/6/28 16:34, zhaotianrui wrote:
> 
> 在 2023/6/28 上午11:42, Jinyang He 写道:
>> On 2023-06-26 16:47, Tianrui Zhao wrote:
>>
>>> [snip]
>>
>>> +    ldx.d   t0, t1, t0
>>> +    csrwr    t0, LOONGARCH_CSR_PGDL
>>> +
>>> +    /* Mix GID and RID */
>>> +    csrrd        t1, LOONGARCH_CSR_GSTAT
>>> +    bstrpick.w    t1, t1, CSR_GSTAT_GID_SHIFT_END, CSR_GSTAT_GID_SHIFT
>>> +    csrrd        t0, LOONGARCH_CSR_GTLBC
>>> +    bstrins.w    t0, t1, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>>> +    csrwr        t0, LOONGARCH_CSR_GTLBC
>>> +
>>> +    /*
>>> +     * Switch to guest:
>>> +     *  GSTAT.PGM = 1, ERRCTL.ISERR = 0, TLBRPRMD.ISTLBR = 0
>>> +     *  ertn
>>> +     */
>>> +
>>> +    /*
>>> +     * Enable intr in root mode with future ertn so that host interrupt
>>> +     * can be responsed during VM runs
>>> +     * guest crmd comes from separate gcsr_CRMD register
>>> +     */
>>> +    ori    t0, zero, CSR_PRMD_PIE
>> li.w t0, CSR_PRMD_PIE
> Thanks for your advice, and I think it need not to replace it with 
> "li.w" there, as it has the same meaning with "ori" instruction, and 
> "ori" instruction is simple and clear enough. The same as the following 
> "move" instructions. What do you think of it.

Just my 2c: I'd agree that pseudo-instructions should be used wherever 
possible and helping readability.

FYI there were similar usages way before, but all were cleaned up with 
my previous commit 57ce5d3eefac ("LoongArch: Use the "move" 
pseudo-instruction where applicable").

Such usages apparently came from an era when the LoongArch toolchains 
didn't support any pseudo-instruction, and are less intuitive especially 
for someone not familiar with LoongArch assembly. Given that familiarity 
with LoongArch won't be widespread (unlike with e.g. RISC-V that are 
adopted more widely), we should optimize for readability when writing 
code; it's also a best practice in general because code is read way more 
often than written, and people care about semantics not unnecessary 
details like "how are moves like this or that materialized".

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

