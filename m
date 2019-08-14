Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66E388CD7B
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 10:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfHNIBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 04:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57874 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfHNIBo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 04:01:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CF023001839;
        Wed, 14 Aug 2019 08:01:44 +0000 (UTC)
Received: from gondolin (dhcp-192-232.str.redhat.com [10.33.192.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E88E808D0;
        Wed, 14 Aug 2019 08:01:38 +0000 (UTC)
Date:   Wed, 14 Aug 2019 10:01:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190814100135.1f60aa42.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 14 Aug 2019 08:01:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 14 Aug 2019 05:54:36 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > > I get that part. I prefer to remove the UUID itself from the structure
> > > and therefore removing this API makes lot more sense?  
> > 
> > Mdev and support tools around mdev are based on UUIDs because it's defined
> > in the documentation.    
> When we introduce newer device naming scheme, it will update the documentation also.
> May be that is the time to move to .rst format too.

You are aware that there are existing tools that expect a uuid naming
scheme, right?

> 
> > I don't think it's as simple as saying "voila, UUID
> > dependencies are removed, users are free to use arbitrary strings".  We'd need
> > to create some kind of naming policy, what characters are allows so that we
> > can potentially expand the creation parameters as has been proposed a couple
> > times, how do we deal with collisions and races, and why should we make such
> > a change when a UUID is a perfectly reasonable devices name.  Thanks,
> >  
> Sure, we should define a policy on device naming to be more relaxed.
> We have enough examples in-kernel.
> Few that I am aware of are netdev (vxlan, macvlan, ipvlan, lot more), rdma etc which has arbitrary device names and ID based device names.
>  
> Collisions and race is already taken care today in the mdev core. Same unique device names continue.

I'm still completely missing a rationale _why_ uuids are supposedly
bad/restricting/etc. We want to uniquely identify a device, across
different types of vendor drivers. An uuid is a unique identifier and
even a well-defined one. Tools (e.g. mdevctl) are relying on it for
mdev devices today.

What is the problem you're trying to solve?
