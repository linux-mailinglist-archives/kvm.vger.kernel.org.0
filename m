Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21CD31A71B
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 22:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhBLVuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 16:50:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24036 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229815AbhBLVuu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 16:50:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613166564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b6HmAk0e01qdqw5/ti+VXBJEF2HavfImZWnbUgYu3S8=;
        b=eUXpA27XTvHFdmdLsqNTGA0p6GANawB0Jji41EhHrpAfQv7iFpbV9nmPrOYmlkaKDaX54/
        065YBiv1du/jU87BRe2I/Jr2WUW+S/Zec8x5t+bvxQwh0iJ/hmvgBHo7iXUXuWs5pNl3Tj
        L+J7VQnjoKIeWq1mMqGwe6bgrZakM2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-qVDrB6S6N1mHD1QZQDX2Ig-1; Fri, 12 Feb 2021 16:49:21 -0500
X-MC-Unique: qVDrB6S6N1mHD1QZQDX2Ig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E95F3107ACE6;
        Fri, 12 Feb 2021 21:49:19 +0000 (UTC)
Received: from gigantic.usersys.redhat.com (helium.bos.redhat.com [10.18.17.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6917A19D9F;
        Fri, 12 Feb 2021 21:49:19 +0000 (UTC)
From:   Bandan Das <bsd@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        "Huang2\, Wei" <wei.huang2@amd.com>,
        "Moger\, Babu" <babu.moger@amd.com>
Subject: Re: [PATCH 0/3] AMD invpcid exception fix
References: <20210211212241.3958897-1-bsd@redhat.com>
        <ac52c9b9-1561-21cd-6c8c-dad21e9356c6@redhat.com>
        <jpgo8gpbath.fsf@linux.bootlegged.copy>
        <CALMp9eQ370MQ1ZPtby4ezodCga9wDeXXGTcrqoXjj03WPJOEhQ@mail.gmail.com>
        <jpg35y1f9x8.fsf@linux.bootlegged.copy>
        <CALMp9eSk1Ar0UB0udM050sZpGaG_OGL3kOs4LbQ+bigUr_s8CA@mail.gmail.com>
        <jpgy2ft6sn5.fsf@linux.bootlegged.copy>
        <CALMp9eTC2YmG04WVVav-bgzq=6oZbu_5kd-6Dfog3SjkBJcHmg@mail.gmail.com>
        <jpglfbtyrn2.fsf@linux.bootlegged.copy>
        <CALMp9eSQW9OuFGXwJYmtGH9Of8xEwHUx-e-OBcxSFVKTFNF1dw@mail.gmail.com>
        <9ff537b7-b204-18fd-6c59-bdb712ed7e20@redhat.com>
Date:   Fri, 12 Feb 2021 16:49:18 -0500
In-Reply-To: <9ff537b7-b204-18fd-6c59-bdb712ed7e20@redhat.com> (Paolo
        Bonzini's message of "Fri, 12 Feb 2021 22:42:52 +0100")
Message-ID: <jpgpn15ufc1.fsf@linux.bootlegged.copy>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 12/02/21 21:56, Jim Mattson wrote:
>>> Not all, we intercept GPs only under a specific condition - just as we
>>> do for vmware_backdoor and for the recent amd errata. IMO, I think it's the right
>>> tradeoff to make to get guest exceptions right.
>> It sounds like I need to get you in my corner to help put a stop to
>> all of the incorrect #UDs that kvm is going to be raising in lieu of
>> #PF when narrow physical address width emulation is enabled!
>
> Ahah :)  Apart from the question of when you've entered diminishing
> returns, one important thing to consider is what the code looks
> like. This series is not especially pretty, and that's not your fault.
> The whole idea of special decoding for #GP is a necessary evil for the
> address-check errata, but is it worth extending it to the corner case
> of INVPCID for CPL>0?
>
Sure, no worries. I will have fond memories of the time I spent extra time
on a trivial patch to address Jim's concerns(ofcourse valid!) only to find out
now he has changed his mind.

Bandan

> Paolo

