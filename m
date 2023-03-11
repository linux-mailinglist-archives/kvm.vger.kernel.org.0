Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D256B5CD3
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCKO0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Mar 2023 09:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjCKO0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Mar 2023 09:26:34 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9018710A13B;
        Sat, 11 Mar 2023 06:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=vR10U+fcqxv/e14JRob7bZTSsoQK5EB8PPRGs2G1joI=; b=Hj4kAleXYh0nxJuX9a7dJxk5xe
        G6gUfuZckKwFDcvSSiBCRpVtQaEW6+IVwVzB9x9CBgzcCtOw+ZHkSJYFvhWMYniOs0UpH01L/7YYI
        V2yGS4FKSE6cFXI6C5wVZeu2/4jUpt2lc1uXEk96DTAMGlcMpnbiVDkKIsND0Uxbo88Ye66nxZayM
        1z+J4gYqNSr7QmY1sVcvWvd7uzKNO47nKlyq/LE6TnMSjRa4rJRP1s+mVCT41KgWJi7EKSTACbJNR
        7iZC0s2bQQLdBhWJfTZd4LqV19+1pmhDXlpt+t8sQ3J3l2/N7kdjlnFBCQ5AJLdsGOiNS6fnZOFg9
        IgKqNCvQ==;
Received: from [2a00:23ee:1060:aa8:4d3a:58c2:352c:ef99] (helo=[IPv6:::1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pb0AI-00AErW-Ob; Sat, 11 Mar 2023 14:25:43 +0000
Date:   Sat, 11 Mar 2023 14:25:40 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com,
        brgerst@gmail.com
CC:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v14_10/12=5D_x86/smpboot=3A_Send_IN?= =?US-ASCII?Q?IT/SIPI/SIPI_to_secondary_CPUs_in_parallel?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87r0tv9xya.ffs@tglx>
References: <20230308171328.1562857-1-usama.arif@bytedance.com> <20230308171328.1562857-11-usama.arif@bytedance.com> <87y1o3acrh.ffs@tglx> <5a9d6d4aef78de6fc8a2cfc62922d06617cbe109.camel@infradead.org> <87r0tv9xya.ffs@tglx>
Message-ID: <0871F5E6-5169-4FB6-A77B-7D8B54D91E51@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11 March 2023 14:14:53 GMT, Thomas Gleixner <tglx@linutronix=2Ede> wrot=
e:
>On Sat, Mar 11 2023 at 09:55, David Woodhouse wrote:
>> On Sat, 2023-03-11 at 10:54 +0200, Thomas Gleixner wrote:
>> I think I'll do it with a 'bool unpoison' argument to
>> idle_thread_get()=2E Or just make it unconditional; they're idempotent
>> anyway and cheap enough? Kind of weird to be doing it from finish_cpu()
>> though, so I'll probably stick with the argument=2E
>
>Eew=2E

Hm? I prefer the idea that idle_thread_get() is able to just return a *usa=
ble* one, and that we don't rely on architectures to have the *same* set of=
 functions to unpoison/prepare it, and keep those duplicates in sync=2E=2E=
=2E

I suppose we could make a separate make_that_idle_thread_you_gave_me_actua=
lly_useful() function and avoid the duplication of anything but *that* call=
=2E=2E=2E but meh=2E
