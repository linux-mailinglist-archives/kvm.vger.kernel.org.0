Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 810256A0BF5
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 15:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbjBWOhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 09:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjBWOhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 09:37:06 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB75F5653E;
        Thu, 23 Feb 2023 06:37:04 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677163022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1i/E/hYtCftNsRnUTWnUECaLl9fsvytYNRbunmNW3s=;
        b=UkafJkNw5zLNA3Yc/q1fXXmlhkW9bhjLSl8yJpG9m7SrY6oq3GOHEVhuDrd5qbMQMP5G/5
        ojXfgkfHAkacJzUYbBDN1sAR8qKx3r0ZnIKEmiQDkSJXc+/rXue93rcAbD1IiiVr44cR6f
        VL0O7d3939bD8KBgjH2FhldvHoE0sXclIKJVVI4ej9VwPkV3nad9QlHiR5/aozUSRGBmSh
        qw8B586mCtGEcI1JUA6+LPO7nga/PbQmhd5ACYXVqPgEIVFM6+tIEc9NRtr6vtSfNlcgH2
        Lp9RaZ27VxeLEfuIMKTprrty9e4iHJ5DrXIBCYKy7pdIjjghWU4sjwH91URi2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677163022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1i/E/hYtCftNsRnUTWnUECaLl9fsvytYNRbunmNW3s=;
        b=eyUDoEWFudH4HN/PKnP9dg1kuHMHVwtZSw2MDQAk8/mYfAbyQP9jSU46W95tDF6K2Xbg2U
        wsHz4fDQa22gzpDg==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        Ashok Raj <ashok.raj@intel.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <701ce2da00e559d517d4e48bd5d88ccae1198e44.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
 <87a615mz2x.ffs@tglx>
 <701ce2da00e559d517d4e48bd5d88ccae1198e44.camel@infradead.org>
Date:   Thu, 23 Feb 2023 15:37:02 +0100
Message-ID: <87zg94la7l.ffs@tglx>
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

David!

On Thu, Feb 23 2023 at 11:07, David Woodhouse wrote:
> On Wed, 2023-02-22 at 17:42 +0100, Thomas Gleixner wrote:
>> The low hanging fruit which brings most is the identification/topology
>> muck and the microcode loading. That needs to be addressed first anyway.
>
> Agreed, thanks.

So the problem with microcode loading is that we must ensure that a HT
sibling is not executing anything else than a trivial loop waiting for
the update to complete. So something like this should work:

   1) Kick all CPUs into life and let them run up to cpu_init() and
      retrieve only the topology information.

   2) Wait for all CPUs to reach this point

   3) Release all primary HT threads so they can load microcode in
      parallel. The secondary HT threads stay in the wait loop and are
      released once the primary thread has finished the microcode
      update.

   4) Let the CPUs do the full CPUID readout and let them synchronize
      with the control CPU again.

   5) Complete bringup one by one

Thanks,

        tglx
      


   


