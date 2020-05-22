Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E579A1DF1CD
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 00:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgEVWZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 18:25:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731111AbgEVWZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 18:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590186354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RE13U10VZKBg+i9d80FBqzbnGRh0EIeAg1GDlPx5sdM=;
        b=Om0I0XPAi+ZPAtTMbjsOpsygYXZ2xovnR7V/kOIs7j8f+z3p7+IpeT9sBbTVJAMGW6318j
        9LIchdcGB2x2RcyiAXjsx0jQ/Q8Y/4dWew8U1eYfzGtlvc6in7YJcROmXNrpCaqPgyHQxA
        0VVYnWwv3FbtBCZl+8+2VjrbkDHgal0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-6-QiEK-lMru0oEIMPGdXPw-1; Fri, 22 May 2020 18:25:52 -0400
X-MC-Unique: 6-QiEK-lMru0oEIMPGdXPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 189C88005AA;
        Fri, 22 May 2020 22:25:51 +0000 (UTC)
Received: from x1.home (ovpn-114-203.phx2.redhat.com [10.3.114.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9894F1059138;
        Fri, 22 May 2020 22:25:47 +0000 (UTC)
Date:   Fri, 22 May 2020 16:25:45 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Qian Cai <cai@lca.pw>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, jgg@ziepe.ca, peterx@redhat.com
Subject: Re: [PATCH v3 0/3] vfio-pci: Block user access to disabled device
 MMIO
Message-ID: <20200522162545.28bb7db4@x1.home>
In-Reply-To: <20200522220858.GE1337@Qians-MacBook-Air.local>
References: <159017449210.18853.15037950701494323009.stgit@gimli.home>
        <20200522220858.GE1337@Qians-MacBook-Air.local>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 May 2020 18:08:58 -0400
Qian Cai <cai@lca.pw> wrote:

> On Fri, May 22, 2020 at 01:17:09PM -0600, Alex Williamson wrote:
> > v3:
> > 
> > The memory_lock semaphore is only held in the MSI-X path for callouts
> > to functions that may access MSI-X MMIO space of the device, this
> > should resolve the circular locking dependency reported by Qian
> > (re-testing very much appreciated).  I've also incorporated the
> > pci_map_rom() and pci_unmap_rom() calls under the memory_lock.  Commit
> > 0cfd027be1d6 ("vfio_pci: Enable memory accesses before calling
> > pci_map_rom") made sure memory was enabled on the info path, but did
> > not provide locking to protect that state.  The r/w path of the BAR
> > access is expanded to include ROM mapping/unmapping.  Unless there
> > are objections, I'll plan to drop v2 from my next branch and replace
> > it with this.  Thanks,  
> 
> FYI, the lockdep warning is gone.
> 

Thank you for testing!

Alex

