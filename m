Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3756C4382E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732839AbfFMPEE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:04:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40856 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732479AbfFMOS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 10:18:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 899448B125;
        Thu, 13 Jun 2019 14:18:57 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9686B2AAB7;
        Thu, 13 Jun 2019 14:18:51 +0000 (UTC)
Date:   Thu, 13 Jun 2019 16:18:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH RFC 1/1] allow to specify additional config data
Message-ID: <20190613161849.070cbc3c.cohuck@redhat.com>
In-Reply-To: <1d859c27-31e2-64ca-f505-19abe9bffed2@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
        <20190606144417.1824-2-cohuck@redhat.com>
        <20190606093224.3ecb92c7@x1.home>
        <20190606101552.6fc62bef@x1.home>
        <ed75a4de-da0b-f6cf-6164-44cebc82c3a5@linux.ibm.com>
        <20190607140344.0399b766@x1.home>
        <1d859c27-31e2-64ca-f505-19abe9bffed2@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 13 Jun 2019 14:18:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Jun 2019 10:19:29 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 6/7/19 4:03 PM, Alex Williamson wrote:
> > On Fri, 7 Jun 2019 14:26:13 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >   
> >> On 6/6/19 12:15 PM, Alex Williamson wrote:  
> >>> On Thu, 6 Jun 2019 09:32:24 -0600
> >>> Alex Williamson <alex.williamson@redhat.com> wrote:
> >>>      
> >>>> On Thu,  6 Jun 2019 16:44:17 +0200
> >>>> Cornelia Huck <cohuck@redhat.com> wrote:
> >>>>     
> >>>>> Add a rough implementation for vfio-ap.
> >>>>>
> >>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >>>>> ---
> >>>>>    mdevctl.libexec | 25 ++++++++++++++++++++++
> >>>>>    mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >>>>>    2 files changed, 80 insertions(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/mdevctl.libexec b/mdevctl.libexec
> >>>>> index 804166b5086d..cc0546142924 100755
> >>>>> --- a/mdevctl.libexec
> >>>>> +++ b/mdevctl.libexec
> >>>>> @@ -54,6 +54,19 @@ wait_for_supported_types () {
> >>>>>        fi
> >>>>>    }
> >>>>>    
> >>>>> +# configure vfio-ap devices <config entry> <matrix attribute>
> >>>>> +configure_ap_devices() {
> >>>>> +    list="`echo "${config[$1]}" | sed 's/,/ /'`"
> >>>>> +    [ -z "$list" ] && return
> >>>>> +    for a in $list; do
> >>>>> +        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
> >>>>> +        if [ $? -ne 0 ]; then
> >>>>> +            echo "Error writing '$a' to '$uuid/$2'" >&2
> >>>>> +            exit 1
> >>>>> +        fi
> >>>>> +    done
> >>>>> +}
> >>>>> +
> >>>>>    case ${1} in
> >>>>>        start-mdev|stop-mdev)
> >>>>>            if [ $# -ne 2 ]; then
> >>>>> @@ -148,6 +161,18 @@ case ${cmd} in
> >>>>>                echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
> >>>>>                exit 1
> >>>>>            fi
> >>>>> +
> >>>>> +        # some types may specify additional config data
> >>>>> +        case ${config[mdev_type]} in
> >>>>> +            vfio_ap-passthrough)  
> >>>>
> >>>> I think this could have some application beyond ap too, I know NVIDIA
> >>>> GRID vGPUs do have some controls under the vendor hierarchy of the
> >>>> device, ex. setting the frame rate limiter.  The implementation here is
> >>>> a bit rigid, we know a specific protocol for a specific mdev type, but
> >>>> for supporting arbitrary vendor options we'd really just want to try to
> >>>> apply whatever options are provided.  If we didn't care about ordering,
> >>>> we could just look for keys for every file in the device's immediate
> >>>> sysfs hierarchy and apply any value we find, independent of the
> >>>> mdev_type, ex. intel_vgpu/foo=bar  Thanks,  
> >>>
> >>> For example:
> >>>
> >>> for key in find -P $mdev_base/$uuid/ \( -path
> >>> "$mdev_base/$uuid/power/*" -o -path $mdev_base/$uuid/uevent -o -path $mdev_base/$uuid/remove \) -prune -o -type f -print | sed -e "s|$mdev_base/$uuid/||g"); do
> >>>     [ -z ${config[$key]} ] && continue
> >>>     ... parse value(s) and iteratively apply to key
> >>> done
> >>>
> >>> The find is a little ugly to exclude stuff, maybe we just let people do
> >>> screwy stuff like specify remove=1 in their config.  Also need to think
> >>> about whether we're imposing a delimiter to apply multiple values to a
> >>> key that conflicts with the attribute usage.  Thanks,
> >>>
> >>> Alex  

One thing that this does is limiting us to things that can be expressed
with "if you encounter key=value, take value (possibly decomposed) and
write it to <device>/key". A problem with this generic approach is that
the code cannot decide itself whether value should be decomposed (and
if yes, with which delimiter), or not. We also cannot cover any
configuration that does not fit this pattern; so I think we need both
generic (for flexibility, and easy extensibility), and explicitly
defined options to cover more complex cases.

[As an aside, how should we deal with duplicate key= entries? Not
allowed, last one wins, or all are written to the sysfs attribute?]

> >>
> >> I like the idea of looking for files in the device's immediate sysfs
> >> hierarchy, but maybe the find could exclude attributes that are
> >> not vendor defined.  
> > 
> > How would we know what attributes are vendor defined?  The above `find`
> > strips out the power, uevent, and remove attributes, which for GVT-g
> > leaves only the vendor defined attributes[1], but I don't know how to
> > instead do a positive match of the vendor attributes without
> > unmaintainable lookup tables.  This starts to get into the question of
> > how much do we want to (or need to) protect the user from themselves.
> > If we let the user specify a key=value of remove=1 and the device
> > immediately disappears, is that a bug or a feature?  Thanks,
> > 
> > Alex  
> 
> By vendor defined, I meant attributes that are not defined by the mdev
> framework, such as the 'remove' attribute.

And those defined by the base driver core like uevent, I guess.

> As far as whether allowing
> specification of remove-1, I'd have to play with that and see what all
> of the ramifications are.

It does feel a bit odd to me (why would you configure it if you
immediately want to remove it again?)

> 
> Tony K
> 
> > 
> > [1] GVT-g doesn't actually have an writable attributes, so we'd also
> > minimally want to add a test to skip read-only attributes.  
> 
> Probably a good idea.

Agreed.
