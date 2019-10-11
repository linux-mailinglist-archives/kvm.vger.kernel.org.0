Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59A7D432C
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2019 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJKOnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Oct 2019 10:43:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726728AbfJKOnG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Oct 2019 10:43:06 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2DF392A09AC
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 14:35:02 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id x11so2818059wro.15
        for <kvm@vger.kernel.org>; Fri, 11 Oct 2019 07:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BMhlHZig+1RhiRk7V7Pz4VOZHaUmDl77u5gqUPus1Vw=;
        b=nyAPihhbCsM66M7uaeh528EXpMkPSD+jkCNRwQ14xMIYe0+NRQAMHmFcQ+7Zyumwwv
         aIQz6PvRh5VHvTMReg95iQVKyAX9tSiia4E5TEFZ3qT2E5Vmp85fcf5+arjYS3PhEPmr
         iRd+rBiSwTHn9R/KDErzxBaGf6Kd8vkpvOQ80lb8zatQII0zl5eOUpaBH+J/HqfjASgO
         t0+C9YgRjn/5tQ/KeDMnYIeguPOWJwIJXAZSj0sKd+sDQavOt/2ibAVhfIYpepjgpXIJ
         6TYwE+HaHVN8gL3o4BBjHUZMDKj95KHJB6zMrczm3Jhw6vSkQRkO9xLZsmVXBNQ/S+Qd
         Ti0A==
X-Gm-Message-State: APjAAAXCGV2bgcMk21u5TsDgqd2zGnrS7qT4Ii09a3cGHahz+Cj58ayf
        8xQ9lEKIjXHwjeAv24G15R9yg9lSmmgOVhavPZD4JAEKQa5xiIK/2OGec0brMsGQxn2eTq8ssdI
        Ho9HcJ+oGTsXZ
X-Received: by 2002:adf:dd88:: with SMTP id x8mr3048517wrl.140.1570804500913;
        Fri, 11 Oct 2019 07:35:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx+Irj2vNmRio/nFmNCYUOj5zRQn/cFuQoq8tEJPRY6eLYwjr9hshihDbQlKDa3IF+n7XZANw==
X-Received: by 2002:adf:dd88:: with SMTP id x8mr3048504wrl.140.1570804500699;
        Fri, 11 Oct 2019 07:35:00 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id g185sm12205685wme.10.2019.10.11.07.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:35:00 -0700 (PDT)
Date:   Fri, 11 Oct 2019 16:34:57 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Adit Ranadive <aditr@vmware.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/2] vsock: don't allow half-closed socket in the
 host transports
Message-ID: <20191011143457.4ujt3gg7oxco6gld@steredhat>
References: <20191011130758.22134-1-sgarzare@redhat.com>
 <20191011101408-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011101408-mutt-send-email-mst@kernel.org>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 10:19:13AM -0400, Michael S. Tsirkin wrote:
> On Fri, Oct 11, 2019 at 03:07:56PM +0200, Stefano Garzarella wrote:
> > We are implementing a test suite for the VSOCK sockets and we discovered
> > that vmci_transport never allowed half-closed socket on the host side.
> > 
> > As Jorgen explained [1] this is due to the implementation of VMCI.
> > 
> > Since we want to have the same behaviour across all transports, this
> > series adds a section in the "Implementation notes" to exaplain this
> > behaviour, and changes the vhost_transport to behave the same way.
> > 
> > [1] https://patchwork.ozlabs.org/cover/847998/#1831400
> 
> Half closed sockets are very useful, and lots of
> applications use tricks to swap a vsock for a tcp socket,
> which might as a result break.

Got it!

> 
> If VMCI really cares it can implement an ioctl to
> allow applications to detect that half closed sockets aren't supported.
> 
> It does not look like VMCI wants to bother (users do not read
> kernel implementation notes) so it does not really care.
> So why do we want to cripple other transports intentionally?

The main reason is that we are developing the test suite and we noticed
the miss match. Since we want to make sure that applications behave in
the same way on different transports, we thought we would solve it that
way.

But what you are saying (also in the reply of the patches) is actually
quite right. Not being publicized, applications do not expect this behavior,
so please discard this series.

My problem during the tests, was trying to figure out if half-closed
sockets were supported or not, so as you say adding an IOCTL or maybe
better a getsockopt() could solve the problem.

What do you think?

Thanks,
Stefano
