Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21C68A7D4
	for <lists+kvm@lfdr.de>; Sat,  4 Feb 2023 03:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBDCcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 21:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDCcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 21:32:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD2A75198
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 18:32:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j1so907315pjd.0
        for <kvm@vger.kernel.org>; Fri, 03 Feb 2023 18:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJbv4yo9z1tKADvI6a3aboLzFFTaY4TL3y4qXVEelc0=;
        b=Ctz0TWzwdQWLHfmJLuyKsEqy7JnxDb7MCEbgueEzLymTkHOWkAxgNkO4+qaqH8Yctl
         2GwGZbsUY7V3SHBpV6JkmrhJ9yYl+7GBWjYmduyXzzzMDGkeNda1WpY8EVErXg9teiuC
         gf2JLnot74AiLehs21xhCIebWXsmROXY2WctSFuWkPF0y4bSQwCLICGj+VLPjScFuT/7
         WkOFKv7ni8wWPcQlchUD61WfLBGVqnAkJ0L3Jn/SEXt8GeQfN02oNyf3p+u5hORrOt7P
         fMFCZxFEZVut1mwY1rFKDXlx8LBOH12khTISsxzLAMnxM/mVQfBbY5CnSjUFu7jLqlBE
         aUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJbv4yo9z1tKADvI6a3aboLzFFTaY4TL3y4qXVEelc0=;
        b=S1kQro1wlQ5x5j+K5aPxe48LeJQ6B92p6u0DKLpqvdIgojA0cJeClqWMh85ymICfUE
         mBE9oIXGeI/I7BcI0ndrzHHriCqk57kTXGu9iggebqHnnOrXL7efjCuvo4qQt/8KIc+2
         rSy5jL976TiiqShw1KlhlE8xeOv9hPuNW6I5n+ZTItCeg77hFps5hi7I6AiXUQ13PyGt
         TcxdO1SU7eWFAwslvIuCWsBD9FUaSp/gr420GNRiFw4hryofkp6OJer+ZtnQWrjGXY6V
         gdaRGxOsCjiCU+eFbVh9OUlPQImMK+Ht7e3Gf2zZIp5MATIznClMmylDG+8F/zNYYLAi
         IFow==
X-Gm-Message-State: AO0yUKWsjuWD3UXOeKbupnzHY8qh/PHROS88fzBNa0oYK1hDoKFr3Bro
        V3ijOgrfoUOPIw4m0QTsTcuEzA==
X-Google-Smtp-Source: AK7set9ci3NH6OTBikQiPjHIfm+Xp9bgU+h1YrCilT1EqyMOVWawa6TRCT8/tEWDgc88aYNQxAdd4g==
X-Received: by 2002:a17:903:22c6:b0:198:af50:e4eb with SMTP id y6-20020a17090322c600b00198af50e4ebmr84078plg.17.1675477968822;
        Fri, 03 Feb 2023 18:32:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o16-20020a170902d4d000b0019678eb963fsm2290195plg.145.2023.02.03.18.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 18:32:48 -0800 (PST)
Date:   Sat, 4 Feb 2023 02:32:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 3/3] KVM: selftests: Add EVTCHNOP_send slow path test to
 xen_shinfo_test
Message-ID: <Y93DzL77oRCWbJOB@google.com>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113124606.10221-1-dwmw2@infradead.org>
 <20230113124606.10221-4-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113124606.10221-4-dwmw2@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023, David Woodhouse wrote:
> @@ -57,6 +60,7 @@ enum {
>  	TEST_EVTCHN_SLOWPATH,
>  	TEST_EVTCHN_SEND_IOCTL,
>  	TEST_EVTCHN_HCALL,
> +	TEST_EVTCHN_HCALL_SLOWPATH,
>  	TEST_EVTCHN_HCALL_EVENTFD,
>  	TEST_TIMER_SETUP,
>  	TEST_TIMER_WAIT,
> @@ -270,6 +274,20 @@ static void guest_code(void)
>  
>  	guest_wait_for_irq();
>  
> +	GUEST_SYNC(TEST_EVTCHN_HCALL_SLOWPATH);
> +
> +	/* Same again, but this time the host has messed with memslots
> +	 * so it should take the slow path in kvm_xen_set_evtchn(). */

	/*
	 * https://lore.kernel.org/all/CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com
	 */

> +	__asm__ __volatile__ ("vmcall" :
> +			      "=a" (rax) :
> +			      "a" (__HYPERVISOR_event_channel_op),
> +			      "D" (EVTCHNOP_send),
> +			      "S" (&s));
> +
> +	GUEST_ASSERT(rax == 0);

There's a lot of copy+paste in this file, and we really should do VMMCALL when
running on AMD.  That's easy to do with some changes that are in the queue for
6.3.  I'll repost these selftest patches on top of a few patches to add helpers for
doing hypercalls using the Xen ABI.
