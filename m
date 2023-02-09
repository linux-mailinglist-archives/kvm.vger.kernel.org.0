Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87C8690D86
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 16:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231698AbjBIPtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 10:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjBIPsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 10:48:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F398C643F3;
        Thu,  9 Feb 2023 07:48:13 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675957692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jZn9RTUF+LwBP9Hkzz4Eth05nQousspojnFQshp9zzI=;
        b=k4y/Q7Uc+iXzYdT9/nBww9wFacKB7VSdNsXKtkVaseeyC4T3YYeOOibbLApvDUi2jH/DeR
        X9aJHYqhJH5C3aRANfxA3Hv+KHtuwfIS97J7E4noKn8dbvISLnmniKVq7DMh+OayKQNExQ
        l3JrmezENL+H8JLd0sRo2K5Qyhd3yb4e6V81gh8NcBomuxhMbQI7YwvnIYAUZapjmBfrsj
        K7BnxSdOfVUzGtTPsWhBN/4tKUOu+8THUM8DUzDcsOfHiK/sR12LeWM+VFIA1R43gxJTlF
        ibj1Ee92J1K8MDIh3ZPAqrikSDz4Wg+WduoWSOJyJOqeIvvjjTli01DNdZzROA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675957692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jZn9RTUF+LwBP9Hkzz4Eth05nQousspojnFQshp9zzI=;
        b=pheqyOp3bPPq0xST9/niNa1p1Sgm/cfr1xQjUuA1wHI2kNI9i1EfdSN77EY4ajkLaWt4Rz
        4CPis6VSeRs8jfAA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, paulmck@kernel.org
Cc:     kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [External] Re: [PATCH v7 0/9] Parallel CPU bringup for x86_64
In-Reply-To: <eea887fb7d634c24529743fce8295b2f78eb861d.camel@infradead.org>
References: <20230207230436.2690891-1-usama.arif@bytedance.com>
 <20230209035300.GA3216394@paulmck-ThinkPad-P17-Gen-1>
 <8e2f03e2-9517-aeb4-df60-b36ef3ff3a75@bytedance.com>
 <f07b371ae2eb11f541c665b488b3d4b6bf1a81b3.camel@infradead.org>
 <87357f2gyd.ffs@tglx>
 <eea887fb7d634c24529743fce8295b2f78eb861d.camel@infradead.org>
Date:   Thu, 09 Feb 2023 16:48:12 +0100
Message-ID: <87wn4q262r.ffs@tglx>
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

On Thu, Feb 09 2023 at 12:10, David Woodhouse wrote:
> On Thu, 2023-02-09 at 12:53 +0100, Thomas Gleixner wrote:
>> > I could probably add a Co-developed-by: tglx for that first x2apic
>> > patch in the series too, but then it would *also* need his SoB and I
>> > didn't want to be owed two, so I just pasted his suggested code and
>> > didn't credit him.
>> 
>> That's what Suggested-by: is for. For that I don't owe you anything. :)
>
> Well, I didn't think that was really for suggestions which come in
> 'diff -up' form, but OK :)

I can't even remember, but probably diff -up was way faster than writing
a novel :)

Thanks,

        tglx
