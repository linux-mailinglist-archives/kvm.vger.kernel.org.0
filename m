Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C131EA0C1
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 11:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgFAJQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 05:16:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31599 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727013AbgFAJQf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 05:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591002993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Wd9igXbzydG2FapnoJya+QCDVjj2Ujw2KrJzi5Gj9E=;
        b=BcPY4l0DmJCRVSuEI5NzO5NYi7rub8uuNCbAmB2Y0BC9i6bqZH4u5Nw0DwVXuyu2lzCoRr
        hsSWBGzDFSl4C8jQDooX84/+so8NYht5bS2OJzrri33KVpkx5PcuN4eWdIRC3JR56c54qP
        9HsO25eZj6YP7SDx0U2j7ovGo8hqKBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-DxNkUf26OiCA4Azbb0arTw-1; Mon, 01 Jun 2020 05:16:30 -0400
X-MC-Unique: DxNkUf26OiCA4Azbb0arTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33292800053;
        Mon,  1 Jun 2020 09:16:27 +0000 (UTC)
Received: from work-vm (ovpn-113-144.ams2.redhat.com [10.36.113.144])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D68E5C1B2;
        Mon,  1 Jun 2020 09:16:20 +0000 (UTC)
Date:   Mon, 1 Jun 2020 10:16:18 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200601091618.GC2743@work-vm>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200529221926.GA3168@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529221926.GA3168@linux.intel.com>
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (sean.j.christopherson@intel.com) wrote:
> On Thu, May 21, 2020 at 01:42:46PM +1000, David Gibson wrote:
> > A number of hardware platforms are implementing mechanisms whereby the
> > hypervisor does not have unfettered access to guest memory, in order
> > to mitigate the security impact of a compromised hypervisor.
> > 
> > AMD's SEV implements this with in-cpu memory encryption, and Intel has
> > its own memory encryption mechanism.  POWER has an upcoming mechanism
> > to accomplish this in a different way, using a new memory protection
> > level plus a small trusted ultravisor.  s390 also has a protected
> > execution environment.
> > 
> > The current code (committed or draft) for these features has each
> > platform's version configured entirely differently.  That doesn't seem
> > ideal for users, or particularly for management layers.
> > 
> > AMD SEV introduces a notionally generic machine option
> > "machine-encryption", but it doesn't actually cover any cases other
> > than SEV.
> > 
> > This series is a proposal to at least partially unify configuration
> > for these mechanisms, by renaming and generalizing AMD's
> > "memory-encryption" property.  It is replaced by a
> > "guest-memory-protection" property pointing to a platform specific
> > object which configures and manages the specific details.
> > 
> > For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> > can be extended to cover the Intel and s390 mechanisms as well,
> > though.
> > 
> > Note: I'm using the term "guest memory protection" throughout to refer
> > to mechanisms like this.  I don't particular like the term, it's both
> > long and not really precise.  If someone can think of a succinct way
> > of saying "a means of protecting guest memory from a possibly
> > compromised hypervisor", I'd be grateful for the suggestion.
> 
> Many of the features are also going far beyond just protecting memory, so
> even the "memory" part feels wrong.  Maybe something like protected-guest
> or secure-guest?
> 
> A little imprecision isn't necessarily a bad thing, e.g. memory-encryption
> is quite precise, but also wrong once it encompasses anything beyond plain
> old encryption.

The common thread I think is 'untrusted host' - but I don't know of a
better way to describe that.

Dave

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

