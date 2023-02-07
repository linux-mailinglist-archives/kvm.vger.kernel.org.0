Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5DB68DA98
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 15:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbjBGOYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 09:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232536AbjBGOYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 09:24:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E3824CB3;
        Tue,  7 Feb 2023 06:24:39 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675779878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48zTNCiq8jyQl85rZUjjKFb4zKzbUXhtUJ1Hwi8S0CA=;
        b=HtKMdz8LlTmkbYTe/u01gq+8liQo8V4y0xKSVfKLz8kWn9e+g+8KTUmW5FlgkQXkCAvrEy
        tsty9t1gAis6jVlJlKzvbA/bldqioOfgr7EFTfHaoZHRInOBFwRWdXsvsBrar8L5KF2jcz
        i1jEBvew8OBdyxa44yjZk2uzLCGKreegVF1WBwi94YPOEtLzsu5NGWulfrYCmhzhUCZGYv
        StO6tmeCMnji+F8/FkVhZhl3QoMgg0lM53MkHjE4af6rDFNk9kQpnxJbLL4F77q1RjnMVf
        2NMmZl/y482tYELfhSpVRQBAsCqiyHoxlEhyt92HCe3+WeZW6U4NyXe8NeOPyg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675779878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=48zTNCiq8jyQl85rZUjjKFb4zKzbUXhtUJ1Hwi8S0CA=;
        b=d5xsa3caE7KBVhLFcJhb3fyVD5ad+qU4xOetisuvWAC04OuM0Fpg7Htn7w5YXoHaMhmnhI
        rLi7LspkXjaPaIAA==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com
Subject: Re: [PATCH v6 01/11] x86/apic/x2apic: Fix parallel handling of
 cluster_mask
In-Reply-To: <921cfe295fcd398168e5454e01193045de312688.camel@infradead.org>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-2-usama.arif@bytedance.com> <87a61qxtx0.ffs@tglx>
 <d37f3af69df09ff542024ed93a37865b28dfa86e.camel@infradead.org>
 <921cfe295fcd398168e5454e01193045de312688.camel@infradead.org>
Date:   Tue, 07 Feb 2023 15:24:38 +0100
Message-ID: <87v8kdv9i1.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07 2023 at 11:27, David Woodhouse wrote:
> On Tue, 2023-02-07 at 10:57 +0000, David Woodhouse wrote:
>> =C2=A0=E2=80=A2 This CPU was present but no other CPU in this cluster wa=
s actually
>> =C2=A0=C2=A0 brought up at boot time so the cluster_mask wasn't allocate=
d.
>>=20
>> The code looks right, I don't grok the comment about partial clusters
>> and virtualization, and would have worded it something along the above
>> lines?
>
> As I get my head around that, I think the code needs to change too.
> What if we *unplug* the only CPU in a cluster (present=E2=86=92possible),=
 then
> add a new one in the same cluster? The new one would get a new
> cluster_mask. Which is kind of OK for now but then if we re-add the
> original CPU it'd continue to use its old cluster_mask.

Indeed.

> Now, that's kind of weird if it's physical CPUs because that cluster is
> within a given chip, isn't it? But with virtualization maybe that's
> something that could happen, and it doesn't hurt to be completely safe
> by using for_each_possible_cpu() instead?

Yes. Virtualization does aweful things....

> Now looks like this:
> 	/*
> 	 * On post boot hotplug for a CPU which was not present at boot time,
> 	 * iterate over all possible CPUs (even those which are not present
> 	 * any more) to find any existing cluster mask.
> 	 */
> 	for_each_possible_cpu(cpu_i) {

Looks good!

      tglx
