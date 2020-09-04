Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C8E25DBBF
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbgIDObj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Sep 2020 10:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730395AbgIDObi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Sep 2020 10:31:38 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE301206B8;
        Fri,  4 Sep 2020 14:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599229897;
        bh=Ovne3zPGozEcouB+wDQ/5CsnhQR2Yaomg+oiECsR7c4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ys2qUxkdrc2bt7b+dBy/+jS317c4d7xtuPAKrXIXg//u0JUvlm0/azD+UP0UL/3oc
         arIq7LwSUlMnT/oq5GGpSVdyI18HDgX/f1muAN1Nrj4h+UaP4vIid+cv4Y3HmON6po
         uOPI7u7lN8wFPEf+S80Qh65xr3zmFsjIjfY9tf+k=
Date:   Fri, 4 Sep 2020 09:37:53 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2] KVM: fix memory leak in kvm_io_bus_unregister_dev()
Message-ID: <20200904143753.GE31464@embeddedor>
References: <20200902225718.675314-1-rkovhaev@gmail.com>
 <c5990c86-ab01-d748-5505-375f50a4ed7d@embeddedor.com>
 <20200903172215.GA870347@thinkpad>
 <87ft7xoiig.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft7xoiig.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 04, 2020 at 02:04:23PM +0200, Vitaly Kuznetsov wrote:
> Rustam Kovhaev <rkovhaev@gmail.com> writes:
> 
> > On Wed, Sep 02, 2020 at 06:34:11PM -0500, Gustavo A. R. Silva wrote:
> >> Hi,
> >> 
> >> On 9/2/20 17:57, Rustam Kovhaev wrote:
> >> > when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> >> > the bus, we should iterate over all other devices linked to it and call
> >> > kvm_iodevice_destructor() for them
> >> > 
> >> > Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> >> > Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> >> > Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> >> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> 
> >> I think it's worthwhile to add a Fixes tag for this, too.
> >> 
> >> Please, see more comments below...
[..]
> >
> > hi Gustavo, thank you for the review, i'll send the new patch.
> > Vitaly, i think i will need to drop your "Reviewed-by", because there is
> > going to be a bit more changes
> >
> 
> Personally, I'd prefer to make struct_size()/flex_array_size() a
> separate preparatory patch so the real fix is small but I don't have a
> strong opinion. I'll take look at v3 so feel free to drop R-b if you
> decide to make a combined patch and feel free to keep it if you make the
> preparatory changes separate :-)
> 

I agree. A two-patch series is much better in this case.

Rustam - please add a Fixes tag to the first patch and see if it can be
applied to -stable. If so, you should Cc stable@vger.kernel.org, too.

Thanks
--
Gustavo
