Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5CF268EC
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 19:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729523AbfEVRMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 13:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727984AbfEVRMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 13:12:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D5C6C057EC6;
        Wed, 22 May 2019 17:12:52 +0000 (UTC)
Received: from amt.cnet (ovpn-112-13.gru2.redhat.com [10.97.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CDA460BE5;
        Wed, 22 May 2019 17:12:51 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 8DB22105190;
        Wed, 22 May 2019 13:45:20 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4MGjHc8007844;
        Wed, 22 May 2019 13:45:17 -0300
Date:   Wed, 22 May 2019 13:45:16 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH] x86: add cpuidle_kvm driver to allow guest side halt
 polling
Message-ID: <20190522164516.GG2317@amt.cnet>
References: <20190517174857.GA8611@amt.cnet>
 <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
 <20190522150451.GA2317@amt.cnet>
 <fa7a52af-4cd4-9c60-7a16-138bd0a14de0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa7a52af-4cd4-9c60-7a16-138bd0a14de0@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 22 May 2019 17:12:52 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 22, 2019 at 05:44:34PM +0200, Paolo Bonzini wrote:
> On 22/05/19 17:04, Marcelo Tosatti wrote:
> > Consider sequence of wakeup events as follows:
> > 20us, 200us, 20us, 200us...
> 
> I agree it can happen, which is why the grow/shrink behavior can be
> disabled for halt_poll_ns.  Is there a real-world usecase with a
> sequence like this?

If you have a database with variable response times in the
20,200,20,200... range, then yes.

Its not a bizzarre/unlikely sequence.

You didnt answer my question at the end of the email.

> The main qualm I have with guest-side polling is that it encourages the
> guest admin to be "impolite".  But I guess it was possible even now to
> boot guests with idle=poll, which would be way more impolite...

Yep.

Thanks.

> Paolo
> 
> > If one enables guest halt polling in the first place,
> > then the energy/performance tradeoff is bend towards
> > performance, and such misses are harmful.
> > 
> > So going to add something along the lines of:
> > 
> > "If, after 50 consecutive times, block_time is much larger than
> > halt_poll_ns, then set cpu->halt_poll_ns to zero".
> > 
> > Restore user halt_poll_ns value once one smaller block_time
> > is observed.
> > 
> > This should cover the full idle case, and cause minimal
> > harm to performance.
> > 
> > Is that OK or is there any other characteristic of
> > adaptive halt poll you are looking for?
