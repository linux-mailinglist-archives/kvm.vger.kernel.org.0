Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8253866CE66
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbjAPSKT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbjAPSJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:09:50 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702813F2B9;
        Mon, 16 Jan 2023 09:54:42 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id x7so15121496qtv.13;
        Mon, 16 Jan 2023 09:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kIDoERHtKfd57GD1gNwdQBw7qJacIkRCHvUuRpuup6M=;
        b=PhlBzZHV2Srh6ST8+N4VoHPUB72ojrpmDLpjwaiXkX+DEXoZBISwh2qgbqlQRhxlzG
         uj/lWXJvuQxb7H7ZrDeeHOuT1sLphpJlYlNBuYb6Jn4r30DrppmKNdP7VbjCLvCUOvRG
         WnhEnEmWDK+ml86o8EobTNY3KdT4icmLV1QMxAltEUF4bnp/t/FeiPnua9LEfK/z3AzS
         H6p0JLTLzlmOQg8z4XFd7VDcqougnt2zL5bohmpM7NnFWZ4zQueY//z4EM44kn6sDYKI
         GHHaXcBGuHJ+CIMIuCGAWxCY5F+gDgigrU36Jbn1iZYiNVjUlHFOXLU/CyYsfwA5qslv
         RUwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kIDoERHtKfd57GD1gNwdQBw7qJacIkRCHvUuRpuup6M=;
        b=Olj6syn3sq5MErM2+2LAE/heWhHs/dg8jeTb0yDZvsZhwidn4k0xbnDs/5w9vRHq3R
         WV7RVpJtD7mttY7+0GVfAktZq/BfJjfagS7874FROfOgEs25pfELdf88ZBqx83uzfDRK
         H2l9aFUjHYEjXeboILFfAZNaZsQTcYGD+YX7Ha1QXnU4Wg1ZVzU3CgvKj9LfrBGz6CAo
         JOo18GrbxDDQJrAttyhuZQJKKZhI8Agbvg7wxBTJbwwuOIdvRA6G1nzbEgGnFD8EZ65Z
         eKNdUbXpMf15hfjHmQebU4VyxB6l1DrdIjXDCJfgxccKa/rfJXiktE359cmi0q/GC4bj
         j48g==
X-Gm-Message-State: AFqh2kq/JeaYD8SoNlOvZqgVfJ5oxTaTGyK2UXrBf1HwuXN5MUZd4iwB
        NwWHf/oYTrBgEGJNrYnH/bA=
X-Google-Smtp-Source: AMrXdXuUzJcLaAlzmpvUna85zh01jrDJVlmaL6EVzSj7aBYgDIsGc05M0zPB6W0tPzHRoby1NpCOng==
X-Received: by 2002:ac8:7253:0:b0:3a5:d1a:8f1d with SMTP id l19-20020ac87253000000b003a50d1a8f1dmr122876679qtp.27.1673891676883;
        Mon, 16 Jan 2023 09:54:36 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id f9-20020ac80689000000b00343057845f7sm14775040qth.20.2023.01.16.09.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 09:54:36 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id AE14E27C0054;
        Mon, 16 Jan 2023 12:54:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 16 Jan 2023 12:54:35 -0500
X-ME-Sender: <xms:Wo_FY9x2QVNigvH8Ke5WPGrzvBE1hwxQsST1xByMI2DIMHCmd9VcxA>
    <xme:Wo_FY9Rfb-akwKAbGpTUV_RkxS2RXsQ9g9XvoDWc1iQCKmPto22c9WAu0P_Juj-T-
    2G9TqC8Y3lV_ojQqA>
X-ME-Received: <xmr:Wo_FY3WdVFQIQG18FbyfDr-DZtVZNnW-cO7RBY-3sZ1scO9SrvIaLQimdCUSUZMGggXH0KJLmplmNw4ULuVM9KP9Zvu2fuPtNCc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtgedguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhq
    uhhnucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrf
    grthhtvghrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveei
    udffiedvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedt
    ieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfh
    higihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:Wo_FY_iUPdAVQUcLG57kLIFYYXVIp4TZPGOrpvkLVTpSb7ufJDdkFg>
    <xmx:Wo_FY_AB857gbqQknkcRFoAVhXv23gzuS_l3xWCO0GcEnVm83q4bBQ>
    <xmx:Wo_FY4IPXGsR2JqcahNhp8OlTLGwWHS_rM_2hCCZ9tt9XERt0tSrbg>
    <xmx:W4_FY73bCBiYTeqcqT2kjwNnZa5vyn5hRKTE8jbg_Y1egv4QVEsUQA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Jan 2023 12:54:34 -0500 (EST)
Date:   Mon, 16 Jan 2023 09:54:32 -0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     paulmck@kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: Re: [PATCH 2/3] rcu: Equip sleepable RCU with lockdep dependency
 graph checks
Message-ID: <Y8WPWJ6TKg5ikZYr@Boquns-Mac-mini.local>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113065955.815667-3-boqun.feng@gmail.com>
 <20230113112949.GX4028633@paulmck-ThinkPad-P17-Gen-1>
 <Y8GdYgSBtyKwf/qj@boqun-archlinux>
 <20230113191120.GB4028633@paulmck-ThinkPad-P17-Gen-1>
 <456f6c15-3043-6da2-349d-c0c3880c1a55@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456f6c15-3043-6da2-349d-c0c3880c1a55@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 16, 2023 at 06:36:43PM +0100, Paolo Bonzini wrote:
> On 1/13/23 20:11, Paul E. McKenney wrote:
> > On Fri, Jan 13, 2023 at 10:05:22AM -0800, Boqun Feng wrote:
> > > On Fri, Jan 13, 2023 at 03:29:49AM -0800, Paul E. McKenney wrote:
> > > I prefer that the first two patches go through your tree, because it
> > > reduces the synchronization among locking, rcu and KVM trees to the
> > > synchronization betwen rcu and KVM trees.
> > 
> > Very well, I have queued and pushed these with the usual wordsmithing,
> > thank you!
> 
> I'm worried about this case:
> 
> 	CPU 0				CPU 1
> 	--------------------		------------------
> 	lock A				srcu lock B
> 	srcu lock B			lock A
> 	srcu unlock B			unlock A
> 	unlock A			srcu unlock B
> 
> While a bit unclean, there is nothing that downright forbids this; as long
> as synchronize_srcu does not happen inside lock A, no deadlock can occur.
> 

First, even with my change, lockdep won't report this as a deadlock
because srcu_read_lock() is annotated as a recursive (unfair) read lock
(the "read" parameter for lock_acquire() is 2) and in this case lockdep
knows that it won't cause deadlock.

For SRCU, the annotation mapping that is 1) srcu_read_lock() is marked
as recursive read lock and 2) synchronize_srcu() is marked as write lock
sync, recursive read locks themselves cannot cause deadlocks and lockdep
is aware of it.

Will add a selftest for this later.

> However, if srcu is replaced with an rwlock then lockdep should and does
> report a deadlock.  Boqun, do you get a false positive or do your patches

To be more precise, to have a deadlock, the read lock on CPU 0 has to be
a *fair* read lock (i.e. non-recursive reader, the "read" parameter for
lock_acquire is 1)

> correctly suppress this?
> 

I'm pretty sure that lockdep handles this ;-)

Regards,
Boqun

> Paolo
> 
