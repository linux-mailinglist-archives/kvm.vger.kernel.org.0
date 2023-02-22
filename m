Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5627069F226
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 10:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjBVJtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 04:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjBVJsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 04:48:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00FA234DC;
        Wed, 22 Feb 2023 01:46:53 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677059186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lX7t4eNJpUd+FIylBrybVCZctPOCrlFQiVjFX2fFY+o=;
        b=u+ppGWmucKqpOWHmZ+NLpxavWBcEqSJst3Yn6S3sCmOef2TnWaNJXO/sZGTROz3ApcDQLo
        SJhAzjVFrg/C+IThgMV5rsDTFFRb70Ly8Yh07b93P3/mP4nAzeYAUekMtwQSO+NO2NVC/I
        P8RLqBXRlSRsKgSqvrEbcCe6Xng5yHfRPAqOhZR2XFoAaqJeQhA8voAmYWifS6KcNyUPkP
        7cNNaRNMq3BToTBbBJs22begklQfppjwu7QUkErAWGBCilo4kmjBPVdvJYBYTiwYAXVppp
        NAAIzUVPWPVRV1qADuKB2C0fv0B492k2UwQ0LbdJBQ0XMW73LTKmnEuBZtqg9Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677059186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lX7t4eNJpUd+FIylBrybVCZctPOCrlFQiVjFX2fFY+o=;
        b=jjPZw4ffdEwKY0XAY8DQfZ+9766w086OXQYFuDwgITe7wnvW5Af7B82bqySUquV/ekSq6g
        7mb5Dv1MA25iXXBQ==
To:     David Woodhouse <dwmw2@infradead.org>,
        Usama Arif <usama.arif@bytedance.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Kim Phillips <kim.phillips@amd.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Piotr Gorski <piotrgorski@cachyos.org>
Subject: Re: [External] Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
In-Reply-To: <e7036423216287e86eab4daf9dd1acdaecdd2b49.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <42dc683e2846ae8fc1e09715aaf7884660e1a386.camel@infradead.org>
 <37c18c3aeea2e558633b6da6886111d0@natalenko.name>
 <5A3B7074-0C6D-472B-803B-D76541828C1F@infradead.org>
 <3d8ed6e157df10c5175c636de0e21849@natalenko.name>
 <5c557f9b6f55dc2a612ee89142971298e6ae12d8.camel@infradead.org>
 <ee0d0d971a3095d6a1e96ad4f1ba32d2@natalenko.name>
 <5b8f9c89f7015fa80c966c6c7f6fa259db6744f8.camel@infradead.org>
 <ce731b5a4a53680b4840467977b33d9a@natalenko.name>
 <85ceb3f92abf3c013924de2f025517372bed19c0.camel@infradead.org>
 <3e5944de08ef0d23584d19bad7bae66c@natalenko.name>
 <26E5DC9C-0F19-4E4F-9076-04506A197374@infradead.org>
 <f71275dc809cfb32df513023786c3faa@natalenko.name>
 <10CA27BB-ADC6-4421-86D2-A83BD7FA12E0@infradead.org>
 <9153284c37a79d303aa79dbf07c10329@natalenko.name>
 <e2e6616f691f1822035be245ec847f7c86a26367.camel@infradead.org>
 <87356yofw3.ffs@tglx>
 <aac036a17b1bcbabe8ee5a7c69fb2dfbc546d06e.camel@infradead.org>
 <11cc090b-82aa-f2f5-0f08-b8e63e662947@bytedance.com>
 <e7036423216287e86eab4daf9dd1acdaecdd2b49.camel@infradead.org>
Date:   Wed, 22 Feb 2023 10:46:25 +0100
Message-ID: <87cz62m3ri.ffs@tglx>
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

On Wed, Feb 22 2023 at 08:19, David Woodhouse wrote:
> But the BSP/CPU0 is different. It hasn't actually been taken offline,
> and its idle thread context is still in cpu_startup_entry(CPUHP_ONLINE)
> which got called from rest_init().
>
> In testing I probably got away with it because we're only using the
> *top* of the stack, don't use anything of the red zone, and thus don't
> actually bother the true idle thread which is never going to return.

:)

> But I don't think it's correct; we really ought to have that temp_stack
> unless we're going to refactor the wakeup_64 code to *become* the idle
> thread just as startup_secondary() does, and *schedule* to the context
> that was saved in the suspend code.

And thereby messing up the scheduler state...

Thanks,

        tglx

