Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A27D1DC0F2
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 23:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgETVIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 17:08:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45114 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727983AbgETVIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 17:08:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590008928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NDXFwaANeSRgHjjtGuv6a9pUflLvS5TDaJmPMi98Sp4=;
        b=Qvwd4GnDGvaxJJJZFXuUIR2iaYZpaH4RQa/tImfcOntwSrPCeimbODQhuuWsRwbehS04rQ
        EoTt7KnHd0/AWkD10ZX1HxSFB/ghj1NBGwX7PjqHdJ+6SdCkX7fqCE5/aEHijGxwwGJ2ha
        8mXCEK6nxF2UTpV/14GeRe6dU421frU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-B7Katbi6Pr26cOX6xyfFdA-1; Wed, 20 May 2020 17:08:46 -0400
X-MC-Unique: B7Katbi6Pr26cOX6xyfFdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89688461;
        Wed, 20 May 2020 21:08:45 +0000 (UTC)
Received: from starship (unknown [10.35.206.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13015106F755;
        Wed, 20 May 2020 21:08:43 +0000 (UTC)
Message-ID: <2401913621cc7686d71f491ef55f30f78ebbb2eb.camel@redhat.com>
Subject: Re: [PATCH 00/24] KVM: nSVM: event fixes and migration support
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Date:   Thu, 21 May 2020 00:08:42 +0300
In-Reply-To: <cecf6c64-6828-5a3f-642a-11aac4cefa75@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
         <6b8674fa647d3b80125477dc344581ba7adfb931.camel@redhat.com>
         <cecf6c64-6828-5a3f-642a-11aac4cefa75@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 22:42 +0200, Paolo Bonzini wrote:
> On 20/05/20 21:24, Maxim Levitsky wrote:
> > Patch 24 doesn't apply cleanly on top of kvm/queue, I appplied it manually,
> > due to missing KVM_STATE_NESTED_MTF_PENDING bit
> > 
> > Also patch 22 needes ALIGN_UP which is not on mainline.
> > Probably in linux-next?
> 
> Just replace it with ALIGN.  (I tested it with memzero_user in
> arch/x86/kvm/ for convenience, and the lib/ patch ended up out of sync
> with the actual code).
That is exactly what I did.

> 
> > With these fixes, I don't see #DE exceptions on a nested guest I try to run
> > however it still hangs, right around the time it tries to access PS/2 keyboard/mouse.
> 
> IIRC you said that the bug appeared with the vintr rework, and then went
> from hang to #DE and now back to hang?  And the hang is reported by L2,
> not L1?
Yes, and now the hang appears to be deterministic. The initial hang could happen
randomally. I remember that once the nested guest got to getty prompt even and hanged
on shutdown. Now hang is deterministic when kernel prints something about PS/2.
I will re-check this tomorrow.

> 
> In order to debug the hang, a good start would be to understand if it
> also happens with vgif=0.  This is because with vgif=1 we use VINTR
> intercepts even while GIF=0, so the whole thing is a bit more complicated.
I will check this tomorrow as well.


Best regards,
	Maxim Levitsky

> 
> Paolo
> 


