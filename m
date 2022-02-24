Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FF4C29CA
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 11:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiBXKoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 05:44:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiBXKoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 05:44:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AAAE28F46C
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 02:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645699418;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PMrO1wHK+f0i5l49rTbD4HIL+P3tUpsU4mhMhEe7j9I=;
        b=U39vRN5eVzPspjEZxMcWjF5rn7iua2JO+2+zgNASCSgL0eV7fz6jErtSfhDCpdEHVmbvsm
        8auRODNVN1lSMKpt/al4yb+kY2poCx2Auoo4jjcl9wbTp38l05Wea/fjcysfkrThEq17uT
        RJax8PFXg2MulWpecs4N9/8bNRECKJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279--UbWN4hpN0-INrWLYK-Htg-1; Thu, 24 Feb 2022 05:43:35 -0500
X-MC-Unique: -UbWN4hpN0-INrWLYK-Htg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 831FE5123;
        Thu, 24 Feb 2022 10:43:32 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCE9E83197;
        Thu, 24 Feb 2022 10:43:28 +0000 (UTC)
Date:   Thu, 24 Feb 2022 10:43:26 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, adrian@parity.io, dwmw@amazon.co.uk,
        acatan@amazon.com, colmmacc@amazon.com, sblbir@amazon.com,
        raduweis@amazon.com, jannh@google.com, gregkh@linuxfoundation.org,
        tytso@mit.edu
Subject: Re: [PATCH RFC v1 0/2] VM fork detection for RNG
Message-ID: <YhdhTlhnj46gqhk+@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220223131231.403386-1-Jason@zx2c4.com>
 <234d7952-0379-e3d9-5e02-5eba171024a0@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <234d7952-0379-e3d9-5e02-5eba171024a0@amazon.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 09:53:59AM +0100, Alexander Graf wrote:
> Hey Jason,
> 
> On 23.02.22 14:12, Jason A. Donenfeld wrote:
> > This small series picks up work from Amazon that seems to have stalled
> > out later year around this time: listening for the vmgenid ACPI
> > notification, and using it to "do something." Last year, that something
> > involved a complicated userspace mmap chardev, which seems frought with
> > difficulty. This year, I have something much simpler in mind: simply
> > using those ACPI notifications to tell the RNG to reinitialize safely,
> > so we don't repeat random numbers in cloned, forked, or rolled-back VM
> > instances.
> > 
> > This series consists of two patches. The first is a rather
> > straightforward addition to random.c, which I feel fine about. The
> > second patch is the reason this is just an RFC: it's a cleanup of the
> > ACPI driver from last year, and I don't really have much experience
> > writing, testing, debugging, or maintaining these types of drivers.
> > Ideally this thread would yield somebody saying, "I see the intent of
> > this; I'm happy to take over ownership of this part." That way, I can
> > focus on the RNG part, and whoever steps up for the paravirt ACPI part
> > can focus on that.
> > 
> > As a final note, this series intentionally does _not_ focus on
> > notification of these events to userspace or to other kernel consumers.
> > Since these VM fork detection events first need to hit the RNG, we can
> > later talk about what sorts of notifications or mmap'd counters the RNG
> > should be making accessible to elsewhere. But that's a different sort of
> > project and ties into a lot of more complicated concerns beyond this
> > more basic patchset. So hopefully we can keep the discussion rather
> > focused here to this ACPI business.
> 
> 
> The main problem with VMGenID is that it is inherently racy. There will
> always be a (short) amount of time where the ACPI notification is not
> processed, but the VM could use its RNG to for example establish TLS
> connections.
> 
> Hence we as the next step proposed a multi-stage quiesce/resume mechanism
> where the system is aware that it is going into suspend - can block network
> connections for example - and only returns to a fully functional state after
> an unquiesce phase:
> 
>   https://github.com/systemd/systemd/issues/20222

The downside of course is precisely that the guest now needs to be aware
and involved every single time a snapshot is taken.

Currently with virt the act of taking a snapshot can often remain invisible
to the VM with no functional effect on the guest OS or its workload, and
the host OS knows it can complete a snapshot in a specific timeframe. That
said, this transparency to the VM is precisely the cause of the race
condition described.

With guest involvement to quiesce the bulk of activity for time period,
there is more likely to be a negative impact on the guest workload. The
guest admin likely needs to be more explicit about exactly when in time
it is reasonable to take a snapshot to mitigate the impact.

The host OS snapshot operations are also now dependant on co-operation
of a guest OS that has to be considered to be potentially malicious, or
at least crashed/non-responsive. The guest OS also needs a way to receive
the triggers for snapshot capture and restore, most likely via an extension
to something like the QEMU guest agent or an equivalent for othuer
hypervisors.


Despite the above, I'm not against the idea of co-operative involvement
of the guest OS in the acts of taking & restoring snapshots. I can't
see any other proposals so far that can reliably eliminate the races
in the general case, from the kernel right upto user applications.
So I think it is neccessary to have guest cooperative snapshotting.

> What exact use case do you have in mind for the RNG/VMGenID update? Can you
> think of situations where the race is not an actual concern?

Lets assume we do take the approach described in that systemd bug and
have a co-operative snapshot process. If the hypervisor does the right
thing and guest owners install the right things, they'll have a race
free solution that works well in normal operation. That's good.


Realistically though, it is never going to be universally and reliably
put into practice. So what is our attitude to cases where the preferred
solution isn't availble and/or operative ?


There are going to be users who continue to build their guest disk images
without the QEMU guest agent (or equivalent for whatever hypervisor they
run on) installed because they don't know any better. Or where the guest
agent is mis-configured or fails to starts or some other scenario that
prevents the quiesce working as desired. The host mgmt could refuse to
take a snapshot in these cases. More likely is that they are just
going to go ahead and do a snapshot anyway because lack of guest agent
is a very common scenario today and users want their snapshots.


There are going to be virt management apps / hypervisors that don't
support talking to any guest agent across their snapshot operation
in the first place, so systemd gets no way to trigger the required
quiesce dance on snapshot, but they likely have VMGenID support
implemented already.


IOW, I could view VMGenID triggered fork detection integrated with
the kernel RNG as providing a backup line of defence that is going
to "just work", albeit with the known race. It isn't as good as the
guest co-operative snapshot approach, because it only tries to solve
the one specific targetted problem of updating the kernel RNG.

Is it still better than doing nothing at all though, for the scenario
where guest co-operative snapshot is unavailable ?

If it is better than nothing, is it then compelling enough to justify
the maint cost of the code added to the kernel ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

