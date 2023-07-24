Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582D576011D
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 23:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjGXVW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 17:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjGXVW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 17:22:26 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB7D1729;
        Mon, 24 Jul 2023 14:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YkoRbeLVaVK30ciGHcNJcByjOt3PGpem+NftI6TFNug=; b=gjrW1OZdmJmEIUIHsMoQ9NLXlt
        5TN51EkVi4D2IjYFQjbBd6KPjHM5/R5f0CdIV5SVdJo4uflMwoEnPBIIlPdwbuqT6hVRrCL8WLhCC
        Of1I9zYIK+NrVBQgKiD8gCpWgQbIHhY1/f+RlfXphreES7ysccFAXuWSd+jcsaTH6L8kqiCfNM0Rx
        +nCKXU1QyJhWvS+HpVaXAwf9pw32OyxhHOXQOSn0GySakA63foLAYybpoz/OVJY9UrHaLInrgcuex
        kLpl3ciZ1RR6w63rYlmga4MBc+5MnEWNDGPRj2TVZP16s8CfguU+JFvcFl7OV6qimdJTQUZ4FI8C1
        +KdbziFQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qO303-002id3-2b;
        Mon, 24 Jul 2023 21:21:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1EA1F300579;
        Mon, 24 Jul 2023 23:21:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 07BDA265C4A2D; Mon, 24 Jul 2023 23:21:51 +0200 (CEST)
Date:   Mon, 24 Jul 2023 23:21:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
Message-ID: <20230724212150.GH3745454@hirez.programming.kicks-ass.net>
References: <20230721201859.2307736-1-seanjc@google.com>
 <20230721201859.2307736-15-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721201859.2307736-15-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> Check "this" CPU instead of the boot CPU when querying SVM support so that
> the per-CPU checks done during hardware enabling actually function as
> intended, i.e. will detect issues where SVM isn't support on all CPUs.

Is that a realistic concern?
