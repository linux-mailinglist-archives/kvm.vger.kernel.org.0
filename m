Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3F668EB0C
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 10:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231237AbjBHJW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 04:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBHJW3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 04:22:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDC21BC1
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 01:20:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29279CE1FF7
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 09:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490D3C433EF;
        Wed,  8 Feb 2023 09:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675848004;
        bh=szmgP+e9Vsro13o4ECnuveaXGwL0/2kZ8N53HolbQmg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=p5gAp+JeKmkVU/hTiy8bkT5wOwAh8OioAr3Z7v0N8pC0ECZj/n2hG3khWuKfWQxaG
         U10+ApGwJjN52nWB6etohMzfzemgUv9ZoLxAajC9AOyblV+rbDHcVWUXdqEdoNM1qW
         IBpiUJjyEYDvaHaYL5INT/g+XXE9nTZN9lRMb+qAmTVWEA4WBM7LxdcjGhRqF0/WOG
         ZpzcErVS+OEn37sogQ6XoiFQnmuCFa8bxlu15XwQvP0ZYvI3JFtcxxBut+KRN01y2Q
         CYB+V5mt9mQeQxPWd03Ke8F/R9E4Echo/vOaPQCDv2ZUTUYr1U9qGX0BG8e9TjED/L
         lzFwQAureBVCg==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Vineet Gupta <vineetg@rivosinc.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     greentime.hu@sifive.com, guoren@linux.alibaba.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context
 in the first-use trap
In-Reply-To: <91cd3bf5-9c68-df1e-32a8-55f2cfedd84a@rivosinc.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com>
 <20230125142056.18356-11-andy.chiu@sifive.com>
 <91cd3bf5-9c68-df1e-32a8-55f2cfedd84a@rivosinc.com>
Date:   Wed, 08 Feb 2023 10:20:02 +0100
Message-ID: <87zg9o1pkt.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineet Gupta <vineetg@rivosinc.com> writes:

> Hi Andy,
>
> On 1/25/23 06:20, Andy Chiu wrote:
>> +static bool insn_is_vector(u32 insn_buf)
>> +{
>> +	u32 opcode = insn_buf & __INSN_OPCODE_MASK;
>> +	/*
>> +	 * All V-related instructions, including CSR operations are 4-Byte. So,
>> +	 * do not handle if the instruction length is not 4-Byte.
>> +	 */
>> +	if (unlikely(GET_INSN_LENGTH(insn_buf) != 4))
>> +		return false;
>> +	if (opcode == OPCODE_VECTOR) {
>> +		return true;
>> +	} else if (opcode == OPCODE_LOADFP || opcode == OPCODE_STOREFP) {
>> +		u32 width = EXTRACT_LOAD_STORE_FP_WIDTH(insn_buf);
>> +
>> +		if (width == LSFP_WIDTH_RVV_8 || width == LSFP_WIDTH_RVV_16 ||
>> +		    width == LSFP_WIDTH_RVV_32 || width == LSFP_WIDTH_RVV_64)
>> +			return true;
>
> What is the purpose of checking FP opcodes here ?

From [1]: "The instructions in the vector extension fit under two
existing major opcodes (LOAD-FP and STORE-FP) and one new major opcode
(OP-V)."

[2] highlights the width encoding.

(And Zvamo is out from the spec, which used AMO,0x2f)

[1] https://github.com/riscv/riscv-v-spec/blob/master/v-spec.adoc#5-vector-instruction-formats
[2] https://github.com/riscv/riscv-v-spec/blob/master/v-spec.adoc#73-vector-loadstore-width-encoding
