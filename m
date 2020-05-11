Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A091CE3BF
	for <lists+kvm@lfdr.de>; Mon, 11 May 2020 21:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgEKTR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 15:17:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60812 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731243AbgEKTR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 15:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589224644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ie7/DlaccXJnR8nAMaUf9Lp/+6UCJjEnsPmnssVsEw=;
        b=KoAlgSyN6xu8qboAuV8fOO/nfv3q/zvnGfeE3cDo9RB6Pj5rHRtPuCgffvG4Ce1asu40eg
        taY28GaWe8U7+mSt5tlozzi8bviSURJpTep2cgCPhIoFMStWZMcu05sFJv6TGkxeCzlbM1
        doxvDGjMr4XymT7iVpztYPYHhgcLkpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-QPfJ05Z2PdSTRFakJ_ozFA-1; Mon, 11 May 2020 15:17:23 -0400
X-MC-Unique: QPfJ05Z2PdSTRFakJ_ozFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31798107ACCA;
        Mon, 11 May 2020 19:17:21 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-80.rdu2.redhat.com [10.10.114.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C51AB5C1D3;
        Mon, 11 May 2020 19:17:20 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 40169220C05; Mon, 11 May 2020 15:17:20 -0400 (EDT)
Date:   Mon, 11 May 2020 15:17:20 -0400
From:   Vivek Goyal <vgoyal@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RFC 1/6] Revert "KVM: async_pf: Fix #DF due to inject
 "Page not Present" and "Page Ready" exceptions simultaneously"
Message-ID: <20200511191720.GC111882@redhat.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-2-vkuznets@redhat.com>
 <20200505141603.GA7155@redhat.com>
 <87y2q5ay8q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2q5ay8q.fsf@vitty.brq.redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 05:17:57PM +0200, Vitaly Kuznetsov wrote:

[..]
> >
> > So either we need a way to report errors back while doing synchrounous
> > page faults or we can't fall back to synchorounous page faults while
> > async page faults are enabled.
> >
> > While we are reworking async page mechanism, want to make sure that
> > error reporting part has been taken care of as part of design. Don't
> > want to be dealing with it after the fact.
> 
> The main issue I'm seeing here is that we'll need to deliver these
> errors 'right now' and not some time later. Generally, exceptions
> (e.g. #VE) should work but there are some corner cases, I remember Paolo
> and Andy discussing these (just hoping they'll jump in with their
> conclusions :-). If we somehow manage to exclude interrupts-disabled
> context from our scope we should be good, I don't see reasons to skip
> delivering #VE there.

Hi Vitaly,

If we can't find a good solution for interrupt disabled regions, then
I guess I will live with error reporting with interrupts enabled only
for now. It should solve a class of problems. Once users show up which
need error handling with interrupts disabled, then we will need to
solve it.

> 
> For the part this series touches, "page ready" notifications, we don't
> skip them but at the same time there is no timely delivery guarantee, we
> just queue an interrupt. I'm not sure you'll need these for virtio-fs
> though.


I think virtiofs will need both (synchronous as well as asynchrous
error reporting).

- If we can deliver async pf to guest, then we will send "page not present"
  to guest and try to fault in the page. If we figure out that page can't be
  faulted in, then we can send "page fault error" notification using interrupt
  (as you are doing for "page ready").

- If async page fault can't be injected in guest and we fall back to
  synchronous fault, and we figure out that fault can't be completed,
  we need to inject error using #VE (or some exception).

Thanks
Vivek

> 
> Thanks for the feedback!
> 
> -- 
> Vitaly
> 

