Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9312169DDFD
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 11:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjBUKhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 05:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjBUKhh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 05:37:37 -0500
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D769F25E11;
        Tue, 21 Feb 2023 02:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
        t=1676975848; bh=kttlikzHwisAM0E2qY/d8RHeLStCZm5KlaC55tFr4CU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=A4g5I85hUYVQJ4SHKWhlfMQrRbyItlwUavJVuBjGob+k8vmVXjA7H6nNXFrV49req
         7zjwdT3tnAEserZ62WFgSVtsO+wfG2cz7p7Hla51+t7h0OBdtuXiOR1EtR41O6m/oS
         4iGCHu89NLXDtXQBWSc3x/5mAupivdX9iD64G4XI=
Received: from [100.100.57.122] (unknown [58.34.185.106])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id A5054600BD;
        Tue, 21 Feb 2023 18:37:27 +0800 (CST)
Message-ID: <35d54051-3876-4fb7-d1c8-d1c605420962@xen0n.name>
Date:   Tue, 21 Feb 2023 18:37:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v2 02/29] LoongArch: KVM: Implement kvm module related
 interface
To:     maobibo <maobibo@loongson.cn>, Paolo Bonzini <pbonzini@redhat.com>,
        Tianrui Zhao <zhaotianrui@loongson.cn>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-3-zhaotianrui@loongson.cn>
 <bf4111f9-f722-1847-4f1d-964c5356f392@redhat.com>
 <0fa9c062-d3fc-61e5-4d54-6bc29f7c64cf@loongson.cn>
 <3f16a8e1-21d9-808e-aa1a-4f1d6f6f291b@redhat.com>
 <2875aa3f-0dc4-4e48-17ad-42c703e12063@loongson.cn>
Content-Language: en-US
From:   WANG Xuerui <kernel@xen0n.name>
In-Reply-To: <2875aa3f-0dc4-4e48-17ad-42c703e12063@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/2/21 18:18, maobibo wrote:
> 
> 
> 在 2023/2/21 16:14, Paolo Bonzini 写道:
>> On 2/21/23 07:59, maobibo wrote:
>>>> Also, why does the world switch code need a copy?
>>> There will be problem in world switch code if there is page fault reenter,
>>> since pgd register is shared between root kernel and kvm hypervisor.
>>> World switch entry need be unmapped area, cannot be tlb mapped area.
>>
>> So if I understand correctly the processor is in direct address translation mode until the "csrwr t0, LOONGARCH_CSR_CRMD" instruction. Where does it leave paged mode?
> The processor still in paged mode during world switch context. For example
> when vm exits from guest mode to root mode, it executes world switch code
> from kvm_vector_entry, PC register points to HVA address, however vmid from
> LOONGARCH_CSR_GTLBC is not clear to root mode. If there is page fault
> exception, hardware treats it exception from GPA-->HPA rather than that
> from HVA --> HPA, since vmid info in CSR_GTLBC is not zero.
> 
> In page mode, there are two kinds of address: unmapped address and
> tlb mapped address. For unmapped address there is only cachable/uncachable
> attribution, but not RWX attr; and there is no tlb handling for it.
> For simplicity,  unmapped address can be treated as window filtered address.
> 
> It will be fully root mode only after this piece of code is executed
> during world switch context; vmid is zero and PC points to HVA.
>          ori     t0, zero, CSR_GSTAT_PVM
>          csrxchg zero, t0, LOONGARCH_CSR_GSTAT
>          /* Clear GTLBC.TGID field */
>          csrrd   t0, LOONGARCH_CSR_GTLBC
>          bstrins.w       t0, zero, CSR_GTLBC_TGID_SHIFT_END, CSR_GTLBC_TGID_SHIFT
>          csrwr   t0, LOONGARCH_CSR_GTLBC

AFAIK all of these is probably coming from Volume 3 of LoongArch ISA 
Manual, which is unfortunately not publicly available at the moment. For 
sake of meaningful reviews, when can we expect to get our hands on the 
manuals?

-- 
WANG "xen0n" Xuerui

Linux/LoongArch mailing list: https://lore.kernel.org/loongarch/

