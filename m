Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CBE21A798
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 21:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgGITNZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 15:13:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44045 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgGITNY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 15:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594322003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o61SBWDAhCKKLWUhk2861tgk54LZbL4dIS40E+MaPC0=;
        b=QnakQhtzIt427fsoUrbY2B9xAIzGgO+cLLzNoYBDsIEkGnFoUbcwD+oSBD5OfzydC7mQC1
        YDxDdtIdkpzIFptLMnHJJdhKN60WkLPewdyLMnL5cj+ztusUmkXsuboPu2pCZI91HaaPlc
        QvhVg3vY1T9EazaXp4T7wqgBxycwWr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-kHjnVacmP-aelhsYSt6P0w-1; Thu, 09 Jul 2020 15:13:19 -0400
X-MC-Unique: kHjnVacmP-aelhsYSt6P0w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B45510059A4;
        Thu,  9 Jul 2020 19:13:18 +0000 (UTC)
Received: from localhost (ovpn-116-140.rdu2.redhat.com [10.10.116.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F31E86FEC6;
        Thu,  9 Jul 2020 19:13:07 +0000 (UTC)
Date:   Thu, 9 Jul 2020 15:13:07 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
Message-ID: <20200709191307.GH780932@habkost.net>
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net>
 <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 10:00:59AM -0700, Jim Mattson wrote:
> On Thu, Jul 9, 2020 at 2:44 AM Gerd Hoffmann <kraxel@redhat.com> wrote:
> 
> > (2) GUEST_MAXPHYADDR < HOST_MAXPHYADDR
> >
> >     Mostly fine.  Some edge cases, like different page fault errors for
> >     addresses above GUEST_MAXPHYADDR and below HOST_MAXPHYADDR.  Which I
> >     think Mohammed fixed in the kernel recently.
> 
> Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
> mode, so that the hypervisor can validate the high bits in the PDPTEs?

If the fix has additional overhead, is the additional overhead
bad enough to warrant making it optional?  Most existing
GUEST_MAXPHYADDR < HOST_MAXPHYADDR guests already work today
without the fix.

-- 
Eduardo

