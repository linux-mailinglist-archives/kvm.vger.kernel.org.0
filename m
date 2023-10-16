Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB197CAB79
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbjJPO2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 10:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbjJPO2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 10:28:15 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17989B4
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 07:28:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5348C433C7;
        Mon, 16 Oct 2023 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697466490;
        bh=3K01tEUdT9I3mg9aM3A3JnKAihTz9I2kU7f1gQDE72M=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=e3iKccS0oRTh6l0OUiXTOCCxgUo75/bvJFDWj65wr/KU0QGgfeMvqlQPu8B3yRs4k
         X/bQyIlV/s7UQdriXmY2UPTiDQo7zssCm/J9+fTVS695s0M6FPZ7l1LlSkhZdkOssJ
         QaWhtWQAqSIk/PBi5RnPj46+KszRaa4a/m7TwJWwVEgP9PjP+URgb6U//tHDPGVJRy
         RRe8QwesdVbNEP0eWz6RJ3xtuykEWouhlYHPjbRPVkmxzl5CPQOsAG5V59kkI2iXOq
         Gq+gR0SU/v7r1m4KmujpqmdS8922UTVVbGXQ7ZN42Njm+oeVC0AX+jxcbMV3XROyso
         tRQYRMvCgIQOw==
Received: from 82-132-232-177.dab.02.net ([82.132.232.177] helo=[127.0.0.1])
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qsOZj-004cge-Bu;
        Mon, 16 Oct 2023 15:28:08 +0100
Date:   Mon, 16 Oct 2023 15:28:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Miguel Luis <miguel.luis@oracle.com>
CC:     "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_KVM=3A_arm64=3A_Do_not_let_a_L?= =?US-ASCII?Q?1_hypervisor_access_the_*32=5FEL2_sysregs?=
User-Agent: K-9 Mail for Android
In-Reply-To: <41C20D2D-BA87-41C5-85BE-611EF53FB5DC@oracle.com>
References: <20231013223311.3950585-1-maz@kernel.org> <41C20D2D-BA87-41C5-85BE-611EF53FB5DC@oracle.com>
Message-ID: <1DFF1105-A2C0-4249-9F71-3C9636C8FBCE@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 82.132.232.177
X-SA-Exim-Rcpt-To: miguel.luis@oracle.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 16 October 2023 15:15:02 BST, Miguel Luis <miguel=2Eluis@oracle=2Ecom> =
wrote:
>Hi Marc,
>
>> On 13 Oct 2023, at 22:33, Marc Zyngier <maz@kernel=2Eorg> wrote:
>>=20
>> DBGVCR32_EL2, DACR32_EL2, IFSR32_EL2 and FPEXC32_EL2 are required to
>> UNDEF when AArch32 isn't implemented, which is definitely the case when
>> running NV=2E
>>=20
>> Given that this is the only case where these registers can trap,
>> unconditionally inject an UNDEF exception=2E
>>=20
>> Signed-off-by: Marc Zyngier <maz@kernel=2Eorg>
>> ---
>> arch/arm64/kvm/sys_regs=2Ec | 8 ++++----
>> 1 file changed, 4 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/arch/arm64/kvm/sys_regs=2Ec b/arch/arm64/kvm/sys_regs=2Ec
>> index 0afd6136e275=2E=2E0071ccccaf00 100644
>> --- a/arch/arm64/kvm/sys_regs=2Ec
>> +++ b/arch/arm64/kvm/sys_regs=2Ec
>> @@ -1961,7 +1961,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
>> // DBGDTR[TR]X_EL0 share the same encoding
>> { SYS_DESC(SYS_DBGDTRTX_EL0), trap_raz_wi },
>>=20
>> - { SYS_DESC(SYS_DBGVCR32_EL2), NULL, reset_val, DBGVCR32_EL2, 0 },
>> + { SYS_DESC(SYS_DBGVCR32_EL2), trap_undef, reset_val, DBGVCR32_EL2, 0 =
},
>>=20
>> { SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
>>=20
>> @@ -2380,18 +2380,18 @@ static const struct sys_reg_desc sys_reg_descs[=
] =3D {
>> EL2_REG(VTTBR_EL2, access_rw, reset_val, 0),
>> EL2_REG(VTCR_EL2, access_rw, reset_val, 0),
>>=20
>> - { SYS_DESC(SYS_DACR32_EL2), NULL, reset_unknown, DACR32_EL2 },
>> + { SYS_DESC(SYS_DACR32_EL2), trap_undef, reset_unknown, DACR32_EL2 },
>> EL2_REG(HDFGRTR_EL2, access_rw, reset_val, 0),
>> EL2_REG(HDFGWTR_EL2, access_rw, reset_val, 0),
>> EL2_REG(SPSR_EL2, access_rw, reset_val, 0),
>> EL2_REG(ELR_EL2, access_rw, reset_val, 0),
>> { SYS_DESC(SYS_SP_EL1), access_sp_el1},
>>=20
>> - { SYS_DESC(SYS_IFSR32_EL2), NULL, reset_unknown, IFSR32_EL2 },
>> + { SYS_DESC(SYS_IFSR32_EL2), trap_undef, reset_unknown, IFSR32_EL2 },
>> EL2_REG(AFSR0_EL2, access_rw, reset_val, 0),
>> EL2_REG(AFSR1_EL2, access_rw, reset_val, 0),
>> EL2_REG(ESR_EL2, access_rw, reset_val, 0),
>> - { SYS_DESC(SYS_FPEXC32_EL2), NULL, reset_val, FPEXC32_EL2, 0x700 },
>> + { SYS_DESC(SYS_FPEXC32_EL2), trap_undef, reset_val, FPEXC32_EL2, 0x70=
0 },
>>=20
>
>Should SDER32_EL2 be considered to this same list?
>

This wouldn't make much sense=2E

This register is only available when running in secure mode, and KVM is fi=
rmly non-secure=2E

Thanks,

        M=2E

Jazz is not dead, it just smells funny
