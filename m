Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537E84DE82B
	for <lists+kvm@lfdr.de>; Sat, 19 Mar 2022 14:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240675AbiCSNbX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Mar 2022 09:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiCSNbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Mar 2022 09:31:20 -0400
X-Greylist: delayed 983 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 19 Mar 2022 06:29:58 PDT
Received: from twosheds.infradead.org (unknown [IPv6:2001:8b0:10b:1:aaa1:59ff:fe2f:55f7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5108D174B8E
        for <kvm@vger.kernel.org>; Sat, 19 Mar 2022 06:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=twosheds.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Cc:To:From:Subject:Date:References:In-Reply-To:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=sEEJnlNtFxHH1oDWt8CRMO7YKzL14njz4tY92tpoRKQ=; b=qN4OwH1D/C43eId9uY8SsSjhH4
        NBsU02QzRL9IBCnk4/wKpMo/cK7oUM36iadyTaPQ8hEq3P7p7GoqUuGpxqQ4a+K9UFhoJkoGywstS
        UB4Ktac/0qOlYp/PUV6C9H+o2j0pxUz3KZB7iwBJcv/dUg1vqu8WgjxT32YhZ67pm9y7oOJv9dGgC
        hhQpcWYsR3xXPAOZl5CyPI8aSLVnPQW2spTUlPmVNPog9nsZFCtfusauMED0bjh5kvQSPGt9BfKKW
        W6AA9eyymZBl0jP5KWBaP4WrR2UI6xJHmlMEh7ikE0W/oFEimyEhZMV+l2KAdMFzR7FTsfTaXvTRK
        jCcV5kbQ==;
Received: from localhost ([127.0.0.1] helo=twosheds.infradead.org)
        by twosheds.infradead.org with esmtp (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nVYtP-007mvD-0T; Sat, 19 Mar 2022 13:13:15 +0000
Received: from 2a01:4c8:1064:8ba9:1:1:3fe2:a99d
        (SquirrelMail authenticated user dwmw2)
        by twosheds.infradead.org with HTTP;
        Sat, 19 Mar 2022 13:13:15 -0000
Message-ID: <100b54469a8d59976bbd96f50dd4cd33.squirrel@twosheds.infradead.org>
In-Reply-To: <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
References: <20220316045308.2313184-1-oupton@google.com>
    <34ccef81-fe54-a3fc-0ba9-06189b2c1d33@redhat.com>
    <YjTRyssYQhbxeNHA@google.com>
    <0bff64ae-0420-2f69-10ba-78b9c5ac7b81@redhat.com>
    <YjWNfQThS4URRMZC@google.com>
    <e48bc11a5c4b0864616686cb1365dfb4c11b5b61.camel@infradead.org>
    <a6011bed-79b4-72ab-843c-315bf3fcf51e@redhat.com>
    <3548e754-28ae-f6c4-5d4c-c316ae6fbbb0@redhat.com>
Date:   Sat, 19 Mar 2022 13:13:15 -0000
Subject: Re: [PATCH] Documentation: KVM: Describe guest TSC scaling in
 migration algorithm
From:   "David Woodhouse" <dwmw2@infradead.org>
To:     "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     "David Woodhouse" <dwmw2@infradead.org>,
        "Oliver Upton" <oupton@google.com>, kvm@vger.kernel.org,
        "Sean Christopherson" <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>
User-Agent: SquirrelMail/1.4.23 [SVN]-7.fc34.20220108
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 3/19/22 12:54, Paolo Bonzini wrote:
>> On 3/19/22 09:08, David Woodhouse wrote:
>>> If a basic API requires this much documentation, my instinct is to
>>> *fix* it with fire first, then document what's left.
>> I agree, but you're missing all the improvements that went in together
>> with the offset API in order to enable the ugly algorithm.
>>
>>> A userspace-friendly API for migration would be more like KVM on the
>>> source host giving me { TIME_OF_DAY, TSC } and then all I have to do on
>>> the destination host (after providing the TSC frequency) is give it
>>> precisely the same data.
>>
>> Again I agree but it would have to be {hostTimeOfDay, hostTSC,
>> hostTSCFrequency, guestTimeOfDay}.
>
> Ah, I guess you meant {hostTimeOfDay, hostTSC} _plus_ the constant
> {guestTSCScale, guestTSCOffset, guestTimeOfDayOffset}.  That would work,
> and in that case it wouldn't even be KVM returning that host information.
>
> In fact {hostTimeOfDay, hostTSC, hostTSCFrequency, guestTimeOfDay} is
> not enough, you also need the guestTSCFrequency and guestTSC (or
> equivalently the scale/offset pair).

I would have said nobody cares about the host TSC value and frequency.
That is for KVM to know and deal with internally.

For guest migration it should be as simple as "guest TSC frequency is <F>,
and the TSC value was <X> at (wallclock time <T>|KVM_CLOCK time <T>).

Not sure I have an opinion on whether the objective time reference is the
timeofday clock or the KVM clock.


-- 
dwmw2

