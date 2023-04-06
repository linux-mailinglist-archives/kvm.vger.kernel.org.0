Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5065A6D9089
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 09:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbjDFHgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 03:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbjDFHgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 03:36:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A16D128;
        Thu,  6 Apr 2023 00:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=TDPAEotj8o6F8kLzXvNoLAs+SKYTvzHm7djobUfwOTc=; b=ApvP7pMC4U3siyul5SjaTyWa8s
        v7eUodewJat7J5QLzVFcIe/0VkJFso/9SrSZ+I9aoSUw847oj2LMsDMNQDNNgnMjrltgjnC+gSXb+
        Tv1RJO4gAqlKmS2FLp8naty8VZwSDtUOs29MCbqshfEkY50bflvsq1ZHl8PnfXcMNFPIBU6X3na6N
        RxkOPtQHR9+eCaKRDEBH+BGtOC/VJunIJhABEGsG5DWAhGExtm1IsQppGmHdEHcWWIgDqHS38Ymac
        bNqay7jtNBYGWIIPRj3UMxhTad4mB90GxQyJ44cQNntUXHcY1zNhFtQ5k/1DW+4vpnZp5dHDqV+cW
        elZG3vCg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pkKAB-00HCMt-Kc; Thu, 06 Apr 2023 07:36:07 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0A8843000DC;
        Thu,  6 Apr 2023 09:36:06 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E696324C025F1; Thu,  6 Apr 2023 09:36:05 +0200 (CEST)
Date:   Thu, 6 Apr 2023 09:36:05 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Saravana Kannan <saravanak@google.com>
Cc:     David Dai <davidai@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        kernel-team@android.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [RFC PATCH 0/6] Improve VM DVFS and task placement behavior
Message-ID: <20230406073605.GB386572@hirez.programming.kicks-ass.net>
References: <20230330224348.1006691-1-davidai@google.com>
 <20230405080548.GW4253@hirez.programming.kicks-ass.net>
 <CAGETcx-qgKeUQ60VhvW+hYUY-sMh-wX1G8zSwJUFpJ-u7aU6aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-qgKeUQ60VhvW+hYUY-sMh-wX1G8zSwJUFpJ-u7aU6aA@mail.gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 02:08:43PM -0700, Saravana Kannan wrote:

> Sorry, that was our intention, but had a scripting error. It's been fixed.
> 
> I have a script to use with git send-email's --to-cmd and --cc-cmd
> option. It uses get_maintainers.pl to figure out who to email, but it
> gets trickier for a patch series that spans maintainer trees.

What I do is I simply run get_maintainers.pl against the full series
diff and CC everybody the same.

Then again, I don't use git-send-email, so I've no idea how to use that.
