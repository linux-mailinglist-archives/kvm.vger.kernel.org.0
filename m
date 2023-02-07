Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE6968CBE6
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 02:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjBGBZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 20:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBGBZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 20:25:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34C327986;
        Mon,  6 Feb 2023 17:24:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE7DB815D8;
        Tue,  7 Feb 2023 01:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B2EC433D2;
        Tue,  7 Feb 2023 01:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675733087;
        bh=X1Zsj8DRbsZT6BWE20BEoF6LfNqBKh8aufazCHqLhys=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=FGJHgl5Ishtwb36m1f8YKIPb3ZZ9phL8hEsY1Gmmt2NqmMwlpqpPokvtXoiNElogu
         Fy8/RU1ccqMSLTL4jASHw12F0HjYplJF6GvqyJHurldaLVXe8rBDGbx1ehvC1K8/KL
         Jp8Dqa360bXJ2AuCvyQeqy+g5ITGmYhJ18NxCW6OEDFP4h09+88+4HLCedZ9XcwGH9
         ifuh8BKLyvhZCoQzJkft18lFfOZ518LeG+G075yNGQFdUl5SdLrjiveWO6WtUS6OUM
         O/pCjaSmIlUU6W9kkkIP9u06pMrOc+8J9NbH/zzBRlqjsjLIZW6PBAW/65DzRXIWiU
         XgDEhqbXhjV7A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id AED635C0A1A; Mon,  6 Feb 2023 17:24:46 -0800 (PST)
Date:   Mon, 6 Feb 2023 17:24:46 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v6 02/11] cpu/hotplug: Move idle_thread_get() to
 <linux/smpboot.h>
Message-ID: <20230207012446.GW2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-3-usama.arif@bytedance.com>
 <877cwuxtcg.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cwuxtcg.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 07, 2023 at 12:33:03AM +0100, Thomas Gleixner wrote:
> On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> > If the architecture code is to register its new pre-bringup states with
> > the cpuhp core, having a special-case wrapper to pass extra arguments is
> > non-trivial and it's easier just to let the arch register its function
> > pointer to be invoked with the standard API.
> >
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> 
> Same issue vs. the SOB chain.
> 
> Other than that:
> 
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

I pulled David's earlier version of this series into -rcu strictly
for testing purposes, so perhaps Usama pulled the series from my repo.
I don't have any record of doing anything more than test that series,
so dropping my SoB entirely makes the most sense here.

							Thanx, Paul
