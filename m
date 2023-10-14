Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C57C93F6
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 11:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbjJNJtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Oct 2023 05:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjJNJty (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Oct 2023 05:49:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFC0B7;
        Sat, 14 Oct 2023 02:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=B/87SAaBNpjhcH93Fzv1JgJikdrvTdlmfDD4O28z/QY=; b=HyeDSIA/T1QZrVocc24JkH3TZ9
        Exw1T8DjomzMLFhEDzvu+hDo2DOduJj7PFMOnGdcm1rekt4q3ql2l1erjCVS4hw66x67770soASXD
        ZWErq0fisKxAp48r/QlZbb/6clCOVoTvSa3NlUZZ+JV0W6s8kZ3BzZN6X28sIuA1ITh1/86j2/qVt
        ytuVoZjlyTO52GoNOSZMWODdlufhBS+fnAHMVn3fgtL07FDycuRZS8ACle/sjAXkB6yI7nuO6g4iZ
        iwOSw/V2q9V/djzrLTJuWrjiMtDM0708bfFKNKMAv1aLQhl81AM6pLHMCHwkJfhwxUmsaDvUH0N/E
        B11hCcHg==;
Received: from [2a00:23ee:1950:579c:f76b:d9be:e375:650d] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qrbGw-003ah4-2a;
        Sat, 14 Oct 2023 09:49:29 +0000
Date:   Sat, 14 Oct 2023 10:49:15 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Dongli Zhang <dongli.zhang@oracle.com>
CC:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_1/1=5D_KVM=3A_x86=3A_add_par?= =?US-ASCII?Q?am_to_update_master_clock_periodically?=
User-Agent: K-9 Mail for Android
In-Reply-To: <ZSnSNVankCAlHIhI@google.com>
References: <ZRtl94_rIif3GRpu@google.com> <9975969725a64c2ba2b398244dba3437bff5154e.camel@infradead.org> <ZRysGAgk6W1bpXdl@google.com> <d6dc1242ff731cf0f2826760816081674ade9ff9.camel@infradead.org> <ZR2pwdZtO3WLCwjj@google.com> <34057852-f6c0-d6d5-261f-bbb5fa056425@oracle.com> <ZSXqZOgLYkwLRWLO@google.com> <8f3493ca4c0e726d5c3876bb7dd2cfc432d9deaa.camel@infradead.org> <ZSmHcECyt5PdZyIZ@google.com> <cf2b22fc-78f5-dfb9-f0e6-5c4059a970a2@oracle.com> <ZSnSNVankCAlHIhI@google.com>
Message-ID: <BD4C4E71-C743-4B79-93CA-0F3AC5423412@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 14 October 2023 00:26:45 BST, Sean Christopherson <seanjc@google=2Ecom>=
 wrote:
>> 2=2E Suppose the KVM host has been running for long time, and the drift=
 between
>> two domains would be accumulated to super large? (Even it may not intro=
duce
>> anything bad immediately)
>
>That already happens today, e=2Eg=2E unless the host does vCPU hotplug or=
 is using
>XEN's shared info page, masterclock updates effectively never happen=2E  =
And I'm
>not aware of a single bug report of someone complaining that kvmclock has=
 drifted
>from the host clock=2E  The only bug reports we have are when KVM trigger=
s an update
>and causes time to jump from the guest's perspective=2E

I've got reports about the Xen clock going backwards, and also about it dr=
ifting over time w=2Er=2Et=2E the guest's TSC clocksource so the watchdog i=
n the guest declares its TSC clocksource unstable=2E=20

I don't understand *why* we update the master lock when we populate the Xe=
n shared info=2E Or add a vCPU, for that matter=2E=20

>> The idea is to never update master clock, if tsc is stable (and masterc=
lock is
>> already used)=2E
>
>That's another option, but if there are no masterclock updates, then it s=
uffers
>the exact same (theoretical) problem as #2=2E  And there are real downsid=
es, e=2Eg=2E
>defining when KVM would synchronize kvmclock with the host clock would be
>significantly harder=2E=2E=2E

I thought the definition of such an approach would be that we *never* resy=
nc the kvmclock to anything=2E It's based purely on the TSC value when the =
guest started, and the TSC frequency=2E The pvclock we advertise to all vCP=
Us would be the same, and would *never* change except on migration=2E

(I guess that for consistency we would scale first to the *guest* TSC and =
from that to nanoseconds=2E)

If userspace does anything which makes that become invalid, userspace gets=
 to keep both pieces=2E That includes userspace having to deal with host su=
spend like migration, etc=2E
