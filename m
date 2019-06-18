Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBF24A4D8
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 17:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbfFRPMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 11:12:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfFRPMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 11:12:02 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 242CE3024552;
        Tue, 18 Jun 2019 15:12:02 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF3A34D1;
        Tue, 18 Jun 2019 15:11:56 +0000 (UTC)
Date:   Tue, 18 Jun 2019 17:11:54 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, libvir-list@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH RFC 1/1] allow to specify additional config data
Message-ID: <20190618171154.3828eb6b.cohuck@redhat.com>
In-Reply-To: <20190606101552.6fc62bef@x1.home>
References: <20190606144417.1824-1-cohuck@redhat.com>
        <20190606144417.1824-2-cohuck@redhat.com>
        <20190606093224.3ecb92c7@x1.home>
        <20190606101552.6fc62bef@x1.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 18 Jun 2019 15:12:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Jun 2019 10:15:52 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 6 Jun 2019 09:32:24 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > On Thu,  6 Jun 2019 16:44:17 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > Add a rough implementation for vfio-ap.
> > > 
> > > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> > > ---
> > >  mdevctl.libexec | 25 ++++++++++++++++++++++
> > >  mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
> > >  2 files changed, 80 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mdevctl.libexec b/mdevctl.libexec
> > > index 804166b5086d..cc0546142924 100755
> > > --- a/mdevctl.libexec
> > > +++ b/mdevctl.libexec
> > > @@ -54,6 +54,19 @@ wait_for_supported_types () {
> > >      fi
> > >  }
> > >  
> > > +# configure vfio-ap devices <config entry> <matrix attribute>
> > > +configure_ap_devices() {
> > > +    list="`echo "${config[$1]}" | sed 's/,/ /'`"
> > > +    [ -z "$list" ] && return
> > > +    for a in $list; do
> > > +        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
> > > +        if [ $? -ne 0 ]; then
> > > +            echo "Error writing '$a' to '$uuid/$2'" >&2
> > > +            exit 1
> > > +        fi
> > > +    done
> > > +}
> > > +
> > >  case ${1} in
> > >      start-mdev|stop-mdev)
> > >          if [ $# -ne 2 ]; then
> > > @@ -148,6 +161,18 @@ case ${cmd} in
> > >              echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
> > >              exit 1
> > >          fi
> > > +
> > > +        # some types may specify additional config data
> > > +        case ${config[mdev_type]} in
> > > +            vfio_ap-passthrough)    
> > 
> > I think this could have some application beyond ap too, I know NVIDIA
> > GRID vGPUs do have some controls under the vendor hierarchy of the
> > device, ex. setting the frame rate limiter.  The implementation here is
> > a bit rigid, we know a specific protocol for a specific mdev type, but
> > for supporting arbitrary vendor options we'd really just want to try to
> > apply whatever options are provided.  If we didn't care about ordering,
> > we could just look for keys for every file in the device's immediate
> > sysfs hierarchy and apply any value we find, independent of the
> > mdev_type, ex. intel_vgpu/foo=bar  Thanks,  
> 
> For example:
> 
> for key in find -P $mdev_base/$uuid/ \( -path
> "$mdev_base/$uuid/power/*" -o -path $mdev_base/$uuid/uevent -o -path $mdev_base/$uuid/remove \) -prune -o -type f -print | sed -e "s|$mdev_base/$uuid/||g"); do
>   [ -z ${config[$key]} ] && continue
>   ... parse value(s) and iteratively apply to key
> done
> 
> The find is a little ugly to exclude stuff, maybe we just let people do
> screwy stuff like specify remove=1 in their config.  Also need to think
> about whether we're imposing a delimiter to apply multiple values to a
> key that conflicts with the attribute usage.  Thanks,
> 
> Alex

Hm, so I tried to write something like that, but there's an obvious
drawback for the vfio-ap use case: we want to specify a list of values
to be written to an attribute. We would have to model that as a list of
key=value pairs; but that would make it harder to remove a specific
value. (I currently overwrite a given key=value pair with a new value
or delete it.) We could specify something like ^key=value to cancel out
key=value.

Does it make sense to write *all* values specified for a specific key
to that attribute in sequence, or may this have surprising
consequences? Can we live with those possible surprises?

> 
> > > +                configure_ap_devices ap_adapters assign_adapter
> > > +                configure_ap_devices ap_domains assign_domain
> > > +                configure_ap_devices ap_control_domains assign_control_domain
> > > +                # TODO: is assigning idempotent? Should we unwind on error?
> > > +                ;;
> > > +            *)
> > > +                ;;
> > > +        esac
> > >          ;;
> > >  
> > >      add-mdev)
