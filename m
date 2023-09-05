Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDE17927BF
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbjIEQFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354908AbjIEPsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 11:48:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50012E6;
        Tue,  5 Sep 2023 08:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=oN1/o7F9/6LDlcpPRnnV2k1YHO8uJPGZqhYNkDc/YIo=; b=WrGusg59kaQkS1bKn5H01f0gKg
        /Zog6xOLqLuP7nyE56bIAiu5u3y/LtZ7X720Y9BKz22djt+hADbaAKmg0rjgRmOgi7Nntwa8c+uJq
        Msgbsf0Xvu3+gPt1OhXlGS3O6AUry+pjrFJz8Rkp2ZS1BQdx0L48PW9buBKUvuSOU4mO66CnTLvqO
        bAGa4+Ju3dxwsC6JCJFRc8ery0xZsSnqLAZuTQ7qOXJmTRn6dD/VSxWIl3hudvUweNzpO3cixady/
        mbw/+MSdoiPJXauGuwx9J0LzGaiqFt7y05Ix+oDmH91bqX+1qyBqhsDvrN0zyqeP8eaXZ0d34lU0s
        TdjmnmUw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qdYHJ-00B6Fg-3c; Tue, 05 Sep 2023 15:47:45 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id BF4D0300687; Tue,  5 Sep 2023 17:47:44 +0200 (CEST)
Date:   Tue, 5 Sep 2023 17:47:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, linux-doc@vger.kernel.org,
        linux-perf-users@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, bp@alien8.de, santosh.shukla@amd.com,
        ravi.bangoria@amd.com, thomas.lendacky@amd.com, nikunj@amd.com
Subject: Re: [PATCH 00/13] Implement support for IBS virtualization
Message-ID: <20230905154744.GB28379@noisy.programming.kicks-ass.net>
References: <20230904095347.14994-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904095347.14994-1-manali.shukla@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 04, 2023 at 09:53:34AM +0000, Manali Shukla wrote:

> Note that, since IBS registers are swap type C [2], the hypervisor is
> responsible for saving and restoring of IBS host state. Hypervisor
> does so only when IBS is active on the host to avoid unnecessary
> rdmsrs/wrmsrs. Hypervisor needs to disable host IBS before saving the
> state and enter the guest. After a guest exit, the hypervisor needs to
> restore host IBS state and re-enable IBS.

Why do you think it is OK for a guest to disable the host IBS when
entering a guest? Perhaps the host was wanting to profile the guest.

Only when perf_event_attr::exclude_guest is set is this allowed,
otherwise you have to respect the host running IBS and you're not
allowed to touch it.

Host trumps guest etc..
