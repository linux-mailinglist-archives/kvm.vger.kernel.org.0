Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F87B438F5
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732335AbfFMPKV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:10:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36522 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732330AbfFMNyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 09:54:36 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 20C1AC04B93D;
        Thu, 13 Jun 2019 13:54:30 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 111EE4E6A8;
        Thu, 13 Jun 2019 13:54:20 +0000 (UTC)
Date:   Thu, 13 Jun 2019 15:54:18 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH RFC 0/1] mdevctl: further config for vfio-ap
Message-ID: <20190613155418.7fa17ed2.cohuck@redhat.com>
In-Reply-To: <2f8e2b74-8119-2886-5a70-ccdcf0fb4619@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
        <234ed452-45bd-e7ec-f1be-929e3b77d364@linux.ibm.com>
        <20190607165630.21ad033b.cohuck@redhat.com>
        <2f8e2b74-8119-2886-5a70-ccdcf0fb4619@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 13 Jun 2019 13:54:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jun 2019 14:30:48 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 6/7/19 10:56 AM, Cornelia Huck wrote:
> > On Thu, 6 Jun 2019 12:45:29 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> On 6/6/19 10:44 AM, Cornelia Huck wrote:  
> >>> This patch adds a very rough implementation of additional config data
> >>> for mdev devices. The idea is to make it possible to specify some
> >>> type-specific key=value pairs in the config file for an mdev device.
> >>> If a device is started automatically, the device is stopped and restarted
> >>> after applying the config.
> >>>
> >>> The code has still some problems, like not doing a lot of error handling
> >>> and being ugly in general; but most importantly, I can't really test it,
> >>> as I don't have the needed hardware. Feedback welcome; would be good to
> >>> know if the direction is sensible in general.  
> >>
> >> Hi Connie,
> >>
> >> This is very similar to what I was looking to do in zdev (config via
> >> key=value pairs), so I like your general approach.
> >>
> >> I pulled your code and took it for a spin on an LPAR with access to
> >> crypto cards:
> >>
> >> # mdevctl create-mdev `uuidgen` matrix vfio_ap-passthrough
> >> # mdevctl set-additional-config <uuid> ap_adapters=0x4,0x5
> >> # mdevctl set-additional-config <uuid> ap_domains=0x36
> >> # mdevctl set-additional-config <uuid> ap_control_domains=0x37
> >>
> >> Assuming all valid inputs, this successfully creates the appropriate
> >> mdev and what looks to be a valid mdevctl.d entry.  A subsequent reboot
> >> successfully brings the same vfio_ap-passthrough device up again.  
> > 
> > Cool, thanks for checking!  
> 
> I also confirmed this. I realize this is a very early proof of concept,
> if you will, but error handling could be an interesting endeavor in
> the case of vfio_ap given the layers of configuration involved; 

I agree; that's why I mostly ignored it for now :)

> for
> example:
> 
> * The necessity for the vfio_ap module to be installed
> * The necessity that the /sys/bus/ap/apmask and /sys/bus/ap/aqmask must
>    be appropriately configured

What do you think about outsourcing that configuration to some
s390-specific tool (probably something in s390-tools)? While we can
(and should) rely on driverctl for vfio-ccw, this does not look like
something that can be easily served by some generic tooling.

> 
> >   
> >>
> >> Matt
> >>  
> >>>
> >>> Also available at
> >>>
> >>> https://github.com/cohuck/mdevctl conf-data
> >>>
> >>> Cornelia Huck (1):
> >>>    allow to specify additional config data
> >>>
> >>>   mdevctl.libexec | 25 ++++++++++++++++++++++
> >>>   mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >>>   2 files changed, 80 insertions(+), 1 deletion(-)
> >>>      
> >>  
> >   
> 

