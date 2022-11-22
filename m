Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92763445F
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 20:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbiKVTNl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 14:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiKVTNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 14:13:39 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5833E86A6A;
        Tue, 22 Nov 2022 11:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7fBCU6btn2ZSChSQBKi+ngIee2Y4f+0YlH8/FhLpy98=; b=NXABkzLhZPVQ4q4a4a5Yn8tSo0
        MpkbPG9F3xJcLgKUhnksbXsl+A0KKeCEGpacNd6khyo7SXFFybehzs+XaYEDAn5t9pRrYq1TThlAJ
        pDwp1yGZg9RyfqSwt55C622Igr8IQwnqDHb9p98ufNLcFi3y6Kqwu+WAtZiENmUHQ3A7lklhPEEN/
        rvmB3RX1Gv0OfMoMQQ0358KnLBBAAlKaKjAC3j5NUgiRAmkzp73rbJ1mf3u+dwXlW5gc0JeXwHAZj
        in2Gi8wKxOgqX5jOWarRVzxnkkoz4L/EKQ4t51BQwZg3wv+PFqlaGVdnvYbyzPN9CvbyoQKaR25E5
        kzt6K8Wg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxYhv-003Ys2-IN; Tue, 22 Nov 2022 19:13:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C7653300202;
        Tue, 22 Nov 2022 20:13:21 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AC26120B64111; Tue, 22 Nov 2022 20:13:21 +0100 (CET)
Date:   Tue, 22 Nov 2022 20:13:21 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 22, 2022 at 07:14:14AM -0800, Dave Hansen wrote:
> On 11/22/22 01:13, Peter Zijlstra wrote:
> > On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:
> >> +/*
> >> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
> >> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
> >> + */
> >> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> >> +{
> >> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> >> +}
> > 
> > Suppose the user has NOHZ_FULL configured, and is already running
> > userspace that will terminate on interrupt (this is desired feature for
> > NOHZ_FULL), guess how happy they'll be if someone, on another parition,
> > manages to tickle this TDX gunk?
> 
> Yeah, they'll be none too happy.
> 
> But, what do we do?

Not intialize TDX on busy NOHZ_FULL cpus and hard-limit the cpumask of
all TDX using tasks.

> There are technical solutions like detecting if NOHZ_FULL is in play and
> refusing to initialize TDX.  There are also non-technical solutions like
> telling folks in the documentation that they better modprobe kvm early
> if they want to do TDX, or their NOHZ_FULL apps will pay.

Surely modprobe kvm isn't the point where TDX gets loaded? Because
that's on boot for everybody due to all the auto-probing nonsense.

I was expecting TDX to not get initialized until the first TDX using KVM
instance is created. Am I wrong?

> We could also force the TDX module to be loaded early in boot before
> NOHZ_FULL is in play, but that would waste memory on TDX metadata even
> if TDX is never used.

I'm thikning it makes sense to have a tdx={off,on-demand,force} toggle
anyway.

> How do NOHZ_FULL folks deal with late microcode updates, for example?
> Those are roughly equally disruptive to all CPUs.

I imagine they don't do that -- in fact I would recommend we make the
whole late loading thing mutually exclusive with nohz_full; can't have
both.
