Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37768EF95
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 14:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjBHNNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 08:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjBHNNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 08:13:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFC546710;
        Wed,  8 Feb 2023 05:13:21 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675861999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n8XDCqDBnxgqPmGg/lqlpZYGC1zpGKtx29xTnJMow8U=;
        b=s1H7S/WxZvhEYQg0DS2zT/NovcmfZ+SefxmaQqS50IjIodUN/PkKwaLv1lmAZRxSblJsNJ
        lvleNGBD7fTduMGVgO3sSdMrSyCAO3JJkCjEL5mvDYQ3dll88et+1Krs/L5uFI6brqUpwy
        FWEDrocKf9L3hkLfoCJFUGiybsFGJBTumr3Z/p2ppj4LCYJufxfMqdfERi/hbcJzeaeRvT
        ti/IaTfRXNdX73Pn0/Lx+LGdlROawWYTQOjTV9G2zg20011Qse1nsx75RM+kY9sOqZe4Ix
        wXqem1gO0gmawQYJNSVsHxckRsqqEW2DtAt1KUPkTNV1eogZEmsxUdSHKRqhcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675861999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n8XDCqDBnxgqPmGg/lqlpZYGC1zpGKtx29xTnJMow8U=;
        b=G5Jq9/+RgI3iz9ej47lvj1DBdreMNX8yG77X3fKxJN8DztMrOyotqMCe7tcWYdnabR7THW
        8Wq+cuY6aQ9mvRBg==
To:     Brian Gerst <brgerst@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, kim.phillips@amd.com, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v7 6/9] x86/smpboot: Support parallel startup of
 secondary CPUs
In-Reply-To: <CAMzpN2iejCnBeBdC6+92fUL2k8ZdAq_jEgXX+RSoGMhRZ0UBSA@mail.gmail.com>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230207230436.2690891-7-usama.arif@bytedance.com>
 <CAMzpN2iejCnBeBdC6+92fUL2k8ZdAq_jEgXX+RSoGMhRZ0UBSA@mail.gmail.com>
Date:   Wed, 08 Feb 2023 14:13:18 +0100
Message-ID: <87k00s2tch.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 08 2023 at 00:09, Brian Gerst wrote:
> On Tue, Feb 7, 2023 at 6:10 PM Usama Arif <usama.arif@bytedance.com> wrote:
>> Introduce a global variable 'smpboot_control' indicating to the AP how
>> it should find its APIC ID. For a serialized bringup, the APIC ID is
>> explicitly passed in the low bits of smpboot_control, while for parallel
>> mode there are flags directing the AP to find its APIC ID in CPUID leaf
>> 0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are sufficient.
>
> For the serialized bringup case, it would be simpler to just put the
> cpu number in the lower bits instead of the APIC id, skipping the
> lookup.

Yes and no. It can be done, but I rather prefer the consistency of the
data and the mechanism. The "overhead" or "win" is not even measurable.

Thanks,

        tglx
