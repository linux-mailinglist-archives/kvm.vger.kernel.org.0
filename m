Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91E8998055
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2019 18:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfHUQjU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 21 Aug 2019 12:39:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbfHUQjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Aug 2019 12:39:19 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 63935315C007;
        Wed, 21 Aug 2019 16:39:18 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A6810016E9;
        Wed, 21 Aug 2019 16:39:17 +0000 (UTC)
Date:   Wed, 21 Aug 2019 10:39:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     hexin <hexin.op@gmail.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, hexin <hexin15@baidu.com>,
        Liu Qi <liuqi16@baidu.com>, Zhang Yu <zhangyu31@baidu.com>
Subject: Re: [PATCH v2] vfio_pci: Replace pci_try_reset_function() with
 __pci_reset_function_locked() to ensure that the pci device configuration
 space is restored to its original state
Message-ID: <20190821103917.43487a1d@x1.home>
In-Reply-To: <CAB_WELYZ80FHyjkcXj4WvBVx-N-3ZMURN3OXTqqbELVn90157g@mail.gmail.com>
References: <1566042663-16694-1-git-send-email-hexin15@baidu.com>
        <20190819135318.72f64e0d@x1.home>
        <CAB_WELYZ80FHyjkcXj4WvBVx-N-3ZMURN3OXTqqbELVn90157g@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 21 Aug 2019 16:39:18 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Aug 2019 23:13:08 +0800
hexin <hexin.op@gmail.com> wrote:

> Alex Williamson <alex.williamson@redhat.com> 于2019年8月20日周二 上午3:53写道：
> >
> > On Sat, 17 Aug 2019 19:51:03 +0800
> > hexin <hexin.op@gmail.com> wrote:
> >  
> > > In vfio_pci_enable(), save the device's initial configuration information
> > > and then restore the configuration in vfio_pci_disable(). However, the
> > > execution result is not the same. Since the pci_try_reset_function()
> > > function saves the current state before resetting, the configuration
> > > information restored by pci_load_and_free_saved_state() will be
> > > overwritten. The __pci_reset_function_locked() function can be used
> > > to prevent the configuration space from being overwritten.
> > >
> > > Fixes: 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
> > > Signed-off-by: hexin <hexin15@baidu.com>
> > > Signed-off-by: Liu Qi <liuqi16@baidu.com>
> > > Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci.c | 17 +++++++++++++----
> > >  1 file changed, 13 insertions(+), 4 deletions(-)  
> >
> > This looks good, but the subject is too long and I find the commit log
> > somewhat confusing.  May I update these as follows?
> >
> >     vfio_pci: Restore original state on release
> >
> >     vfio_pci_enable() saves the device's initial configuration information
> >     with the intent that it is restored in vfio_pci_disable().  However,
> >     commit 890ed578df82 ("vfio-pci: Use pci "try" reset interface")
> >     replaced the call to __pci_reset_function_locked(), which is not wrapped
> >     in a state save and restore, with pci_try_reset_function(), which
> >     overwrites the restored device state with the current state before
> >     applying it to the device.  Restore use of __pci_reset_function_locked()
> >     to return to the desired behavior.
> >
> > Thanks,
> > Alex
> >
> >  
> 
> Thanks for your update, the updated commit log is clearer than before.
> At the same time, when I use checkpatch.pl to detect the patch, there
> will be the
> following error:
> 
> ERROR: Please use git commit description style 'commit <12+ chars of
> sha1> ("<title line>")'  
> - ie: 'commit 890ed578df82 ("vfio-pci: Use pci "try" reset interface")'
> 
> Line 2785 ~ 2801 in checkpatch.pl, the script can't handle the commit message
> which contains double quotes because of the expression `([^"]+)`. Like
> the "try" above.
> Maybe checkpatch.pl needs to be modified.

I think we're following the intention of the rule, and as you've
identified it's the implementation of the rule checker that's unable
to handle a commit title with internal quotes.  We can ignore it, and
maybe follow up with a checkpatch.pl patch, or we could just avoid it
as follows:

    vfio_pci: Restore original state on release
    
    vfio_pci_enable() saves the device's initial configuration information
    with the intent that it is restored in vfio_pci_disable().  However,
    the commit referenced in Fixes: below replaced the call to
    __pci_reset_function_locked(), which is not wrapped in a state save
    and restore, with pci_try_reset_function(), which overwrites the
    restored device state with the current state before applying it to the
    device.  Reinstate use of __pci_reset_function_locked() to return to
    the desired behavior.

Thanks,
Alex

> > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > index 703948c..0220616 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -438,11 +438,20 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
> > >       pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
> > >
> > >       /*
> > > -      * Try to reset the device.  The success of this is dependent on
> > > -      * being able to lock the device, which is not always possible.
> > > +      * Try to get the locks ourselves to prevent a deadlock. The
> > > +      * success of this is dependent on being able to lock the device,
> > > +      * which is not always possible.
> > > +      * We can not use the "try" reset interface here, which will
> > > +      * overwrite the previously restored configuration information.
> > >        */
> > > -     if (vdev->reset_works && !pci_try_reset_function(pdev))
> > > -             vdev->needs_reset = false;
> > > +     if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
> > > +             if (device_trylock(&pdev->dev)) {
> > > +                     if (!__pci_reset_function_locked(pdev))
> > > +                             vdev->needs_reset = false;
> > > +                     device_unlock(&pdev->dev);
> > > +             }
> > > +             pci_cfg_access_unlock(pdev);
> > > +     }
> > >
> > >       pci_restore_state(pdev);
> > >  out:  
> >  

