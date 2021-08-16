Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6093ED9B7
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbhHPPRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232441AbhHPPRS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:17:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629127006;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hw341CdRRfI9W7otGB/Ln/3wgaFoJ9zI6kaYPlIdHck=;
        b=A28WCbOJLyeDQff0DgK41dg5ulvGZYYsYJKUh5DY2uV9xvDUQzc0BiQmAiMyVNMDiVOr6i
        aHrDBrfPgMe+yJ//QW8c+Ceg5xE6NloCyXssaZO9+1UjKcjRT9GGbIdtQovPnfgWeswvM8
        /uX1GIeiIZNsT1ac+9ryloQ3m7XvFVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-D2SgY7DZMK623HrSP3CXDQ-1; Mon, 16 Aug 2021 11:16:42 -0400
X-MC-Unique: D2SgY7DZMK623HrSP3CXDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 581196EAF7;
        Mon, 16 Aug 2021 15:16:41 +0000 (UTC)
Received: from redhat.com (unknown [10.39.192.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F3CA319C46;
        Mon, 16 Aug 2021 15:16:33 +0000 (UTC)
Date:   Mon, 16 Aug 2021 16:16:30 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     thomas.lendacky@amd.com, Ashish Kalra <Ashish.Kalra@amd.com>,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, richard.henderson@linaro.org, jejb@linux.ibm.com,
        tobin@ibm.com, qemu-devel@nongnu.org, dgilbert@redhat.com,
        frankeh@us.ibm.com, dovmurik@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Message-ID: <YRqBTiv8AgTMBcrw@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <fb737cf0-3d96-173f-333b-876dfd59d32b@redhat.com>
 <YRp09sXRaNPefs2g@redhat.com>
 <b77dfd8f-94e7-084f-b633-105dc5fdb645@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b77dfd8f-94e7-084f-b633-105dc5fdb645@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 05:00:21PM +0200, Paolo Bonzini wrote:
> On 16/08/21 16:23, Daniel P. Berrangé wrote:
> > snip
> > 
> > > With this implementation, the number of mirror vCPUs does not even have to
> > > be indicated on the command line.  The VM and its vCPUs can simply be
> > > created when migration starts.  In the SEV-ES case, the guest can even
> > > provide the VMSA that starts the migration helper.
> > 
> > I don't think management apps will accept that approach when pinning
> > guests. They will want control over how many extra vCPU threads are
> > created, what host pCPUs they are pinned to, and what schedular
> > policies might be applied to them.
> 
> That doesn't require creating the migration threads at startup, or making
> them vCPU threads, does it?
> 
> The migration helper is guest code that is run within the context of the
> migration helper in order to decrypt/re-encrypt the code (using a different
> tweak that is based on e.g. the ram_addr_t rather than the HPA).  How does
> libvirt pin migration thread(s) currently?

I don't think we do explicit pinning of migration related threads right
now, which means they'll inherit characteristics of whichever thread
spawns the transient migration thread.  If the mgmt app has pinned the
emulator threads to a single CPU, then creating many migration threads
is a waste of time as they'll compete with each other.

I woudn't be needed to create migration threads at startup - we should
just think about how we would identify and control them when created
at runtime. The complexity here is a trust issue - once guest code has
been run, we can't trust what QMP tells us - so I'm not sure how we
would learn what PIDs are associated with the transiently created
migration threads, in order to set their properties.


Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

