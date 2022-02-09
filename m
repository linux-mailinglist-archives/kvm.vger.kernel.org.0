Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAEE4AF21E
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 13:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiBIMvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 07:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiBIMvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 07:51:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBC6C0613CA;
        Wed,  9 Feb 2022 04:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6dGm9Hg6raG07iV8obt7rI9CiZz2G/HOBnlwgFwLPno=; b=u05ARwxDEZedFXXIfxb+xx2gIx
        aOW537iU6kT29p6x0QQtrZW+oBws1oDA0tEGk1MLheGGTyjyHNiZB2woY7WlqUmRePNm49xfjVcJh
        LsW55+G6YDxO3NyFV06Wu+4Y2VsPSoJczhJD9rlixHM3x4BPhjtMxuoxR3pcRwLl83wjdoqrb20Wn
        4Zbb63XOVLW0vaJrYjExO1f5jb8uHqKRYlobiIVZM+9Tn+rEo7oNw8JoobVUtUSPXYbvAOtyeE/rv
        iOy6ppotQfC+svMZ8qaGkZnDmrU3MoKDHrlltHorLaCnrb8/cudyUc/bU7nKh444Kk+6j53erKIHg
        DrYZVg7g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nHmRE-007hqr-T2; Wed, 09 Feb 2022 12:51:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DC3BA30023F;
        Wed,  9 Feb 2022 13:51:10 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8F808265018D6; Wed,  9 Feb 2022 13:51:10 +0100 (CET)
Date:   Wed, 9 Feb 2022 13:51:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ravi Bangoria <ravi.bangoria@amd.com>
Cc:     like.xu.linux@gmail.com, jmattson@google.com, eranian@google.com,
        santosh.shukla@amd.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, vkuznets@redhat.com, joro@8bytes.org,
        mingo@redhat.com, alexander.shishkin@linux.intel.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org, ananth.narayan@amd.com,
        kim.phillips@amd.com
Subject: Re: [PATCH v3] perf/amd: Implement erratum #1292 workaround for F19h
 M00-0Fh
Message-ID: <YgO4vn2w5kT43HGh@hirez.programming.kicks-ass.net>
References: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
 <20220203095841.7937-1-ravi.bangoria@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203095841.7937-1-ravi.bangoria@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 03, 2022 at 03:28:41PM +0530, Ravi Bangoria wrote:
> Perf counter may overcount for a list of Retire Based Events. Implement
> workaround for Zen3 Family 19 Model 00-0F processors as suggested in
> Revision Guide[1]:
> 
>   To count the non-FP affected PMC events correctly:
>     o Use Core::X86::Msr::PERF_CTL2 to count the events, and
>     o Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>     o Program Core::X86::Msr::PERF_CTL2[20] to 0b.
> 
> Note that the specified workaround applies only to counting events and
> not to sampling events. Thus sampling event will continue functioning
> as is.
> 
> Although the issue exists on all previous Zen revisions, the workaround
> is different and thus not included in this patch.
> 
> This patch needs Like's patch[2] to make it work on kvm guest.
> 
> [1] https://bugzilla.kernel.org/attachment.cgi?id=298241
> [2] https://lore.kernel.org/lkml/20220117055703.52020-1-likexu@tencent.com
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>

Thanks!
