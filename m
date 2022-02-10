Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3D04B08C9
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 09:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237891AbiBJIrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 03:47:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237855AbiBJIq4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 03:46:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511DF10E2;
        Thu, 10 Feb 2022 00:46:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CtPlGfGeJblHo45EgphSGBpGmGJSjC9Sp+fAgHRiwpo=; b=otcoQWJYMknpD+VGvc01UmXfOl
        0SLD08uQvJZiipRk7p7TzGR85q/ql4smnZpEW9vCcm20YitnITppJgzGHwRIbyMDwvKCtqhPegBld
        XjYuIDvcsBbp+Fd6PWocrY8ZI9MibVkrS3Zo9wh13cRY+5FUr/oU2sgHJ/MWwlDQKJpn9dL8H98tm
        In40MTVFcnJDKkFnm2U0Glz2503ZLRpQa0yDqZ+WYjD8QMMVX3N8CYIg2l+VGN3acUiEkiBGpkavg
        NoGI2G+1v6lPftwIyFN3OikiIAOPYJJNEUb2nd9LCPFiF+I1jj6LGucqobQFwwLOydZL7s8mtg9g8
        p7DpGGTg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nI55j-009HAg-88; Thu, 10 Feb 2022 08:46:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D8A1D30023F;
        Thu, 10 Feb 2022 09:46:13 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C0733206D238C; Thu, 10 Feb 2022 09:46:13 +0100 (CET)
Date:   Thu, 10 Feb 2022 09:46:13 +0100
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
Message-ID: <YgTQ1UQUcBKzqUk+@hirez.programming.kicks-ass.net>
References: <fe53507b-9732-b47e-32e0-647a9bfc8a80@amd.com>
 <20220203095841.7937-1-ravi.bangoria@amd.com>
 <YgO4vn2w5kT43HGh@hirez.programming.kicks-ass.net>
 <b775ab2d-c293-d8f0-a436-1ec19c6315d8@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b775ab2d-c293-d8f0-a436-1ec19c6315d8@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 09:35:14AM +0530, Ravi Bangoria wrote:

> Peter, On subsequent tests, I found that this 'fix' is still not
> optimal. Please drop this patch from your queue for now. Really
> sorry for the noise.

Just in time, and done.
