Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5565669525C
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 21:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjBMUyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 15:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBMUyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 15:54:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B9920069;
        Mon, 13 Feb 2023 12:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=L9Lp70nKi81urUNH/P20ez0LtfS+viLTxmxtWz3Dtp0=; b=H3t89eeMooGlhIz6hiBQXvjRQQ
        dM2XLF1imB62BLLyF8ysJ5H2Bvmj3Txr0wpFPF/Kg8ztcRrLp5+eltRMS6YlUMl2fcGctmmYeOBAm
        e6L5Ll90FgfvtPBTG/g9tGx/uaK3RXQCcb9winjrAKvpF3Jy3sqn0NQQEpD2r0moOXEV0qGLlYnhX
        pwEMhOBgf6RJPoTIV8Np7OZ08kLySOEFenh9NKCnmX4XN2FB42dSWblW2wmm7Es3U00Ge5KOfM3R5
        ZBRhQsbg667/r6P/Yc8dxHpj8Blv7VOEBY/UAZZTSbb7F0Bes4alcGflAcxHi/8HPHMWgefRKOrlv
        xStaFbEg==;
Received: from [2001:871:43:561d:2d56:2cf3:ed22:ad26] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRfoT-009SDs-00;
        Mon, 13 Feb 2023 20:52:37 +0000
Date:   Mon, 13 Feb 2023 21:53:15 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com
CC:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v8_9/9=5D_x86/smpboot=3A_Serializ?= =?US-ASCII?Q?e_topology_updates_for_secondary_bringup?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87v8k5s3dq.ffs@tglx>
References: <20230209154156.266385-1-usama.arif@bytedance.com> <20230209154156.266385-10-usama.arif@bytedance.com> <87v8k5s3dq.ffs@tglx>
Message-ID: <BE9F9210-4DBD-4A9F-BA5A-A7B5BA580FCC@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13 February 2023 21:43:13 CET, Thomas Gleixner <tglx@linutronix=2Ede> w=
rote:
>On Thu, Feb 09 2023 at 15:41, Usama Arif wrote:
>> From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>>
>> The toplogy update is performed by the AP via smp_callin() after the BS=
P
>> has called do_wait_cpu_initialized(), setting the AP's bit in
>> cpu_callout_mask to allow it to proceed=2E
>>
>> In preparation to enable further parallelism of AP bringup, add locking=
 to
>> serialize the update even if multiple APs are (in future) permitted to
>> proceed through the next stages of bringup in parallel=2E
>
>This one is also only relevant for further parallelisation, right?

I believe so, yes=2E But it's low-hanging fruit and might as well go in no=
w=2E
