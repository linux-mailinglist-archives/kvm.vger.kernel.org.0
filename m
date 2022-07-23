Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9857757EC9E
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 10:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiGWIAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Jul 2022 04:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGWIAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Jul 2022 04:00:01 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFC878238
        for <kvm@vger.kernel.org>; Sat, 23 Jul 2022 00:59:57 -0700 (PDT)
Date:   Sat, 23 Jul 2022 09:59:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658563196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ldcXzSGhyZjdlmTZ2qM8ncFsmbAjGlPourkAHG6dO0s=;
        b=YQiVHw7pVpwptBWQhEpviji4IDPGvsDLpXPyWbtVlzKPwU4aQwjcoMnG+sUjpmzlQqqNew
        0BJaqOR8RwB61z1yDR8yK36RbzVV68CasSxo4ktaXn0fNFtTz0Q2dbaqpQFuEht4+F/Rbq
        VYdBfCr10EowuNCCVeust1mGRJphwIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow
 in chained counters tests
Message-ID: <20220723075955.ipoekdpzkqticadt@kamzik>
References: <20220718154910.3923412-1-ricarkol@google.com>
 <20220718154910.3923412-4-ricarkol@google.com>
 <87edyhz68i.wl-maz@kernel.org>
 <Yte/YXWYSikyQcqh@google.com>
 <875yjsyv67.wl-maz@kernel.org>
 <Ythw1UT1wFHbY/jN@google.com>
 <Ythy8XXN2rFytXdr@google.com>
 <871quezill.wl-maz@kernel.org>
 <YtscUOUGKra3LpsK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtscUOUGKra3LpsK@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22, 2022 at 02:53:20PM -0700, Ricardo Koller wrote:
> 
> Which brings me to what to do with this test. Should it be fixed for
> bare-metal by ignoring the PMOVSSET check? or should it actually check
> for PMOVSSET=1 and fail on KVM until KVM gets fixed?
>

Hi Ricardo,

Please write the test per the spec. Failures pointed out in kvm-unit-tests
are great, when the tests are written correctly, since it means it's
doing its job :-)

If some CI somewhere starts blocking builds due to the failure, then there
are ways to skip the test. Unfortunately the easiest way is usually the
oversized hammer of skipping every unittests.cfg entry that fails. To do
better, either the CI needs to be taught about all the subtest failures it
can ignore or the test code needs some work to allow silencing known
failures. For the test code, refactoring to isolate the test into it's own
unittests.cfg entry and then skipping that entry is one way, but probably
won't work in this case, since the overflow checks are scattered. Another
way is to guard all the overflow checks with a variable which can be set
with a command line parameter or environment variable. Eventually, when
the KVM bug is fixed, the guard variable could be forced off for kernel
versions >= the version the fix is merged. The kernel version can be
detected in the unit test by looking at the KERNEL_* environment
variables.

Thanks,
drew
