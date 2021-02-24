Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1526432470F
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhBXWnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:43:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25638 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235254AbhBXWng (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 17:43:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614206529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7loNY6a/CYvNtMJopL3QUeRwqTiWCpARGe5VL/q/8gs=;
        b=PgRL9zUgUEx2Y6UNAxqZ3EIlqc1bwxTKkwc5W0mL+ugBE3aB3vrE8I0ca2h1LOQPjKCqtd
        Hl1dRuv34ztev2/IUMNZMmOP9jXYqkqHQPCAJR3sFzyFrmziY5LeP7DjDKkoVnqtsTp/Cv
        Vzz7iVsPAGQH0J0o+cBz+1hq7Nj+uus=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-LJdQtZDmNqS4iedhBwjsow-1; Wed, 24 Feb 2021 17:42:07 -0500
X-MC-Unique: LJdQtZDmNqS4iedhBwjsow-1
Received: by mail-ej1-f71.google.com with SMTP id p15so1517264ejq.22
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 14:42:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7loNY6a/CYvNtMJopL3QUeRwqTiWCpARGe5VL/q/8gs=;
        b=GmbO1fF1xfn33msfNkUjpLJ3uKEPvd9GVKlcQbuAfFJQ0Hsu7r/Gj+Ikjeekb8NVq8
         ejZofLNmCBDgS+LMOuj3q0Ad9REzWYb8TkEKwqavXkWzWhrdhhmGGr+wrogvGylSi1ok
         4aY8wzdu+iA8KTs872Vkw7nz9w0EIX5S47E+AltWAvrZOZT1Di7Nmk0Kiic/5z4uWtwp
         ldKXx++/TIvfQlcUELzSfhu0NTy1itjw/xhKSCa+dr1zieZtY1fPvhuDmFJuebkSJu1p
         qF9BQAyG7iHC1xS6Mb7V6ZINZDqVOmJKeyZIZuKh+7ecXTOEe7gTnk7U2wpP9NKJYPtj
         312g==
X-Gm-Message-State: AOAM532hqW/xmjFxC6DyQ0KJnv6+1Kq8mbNosN8N40oIR1suCexXVMYq
        S/zYR0dc/TBIBIgbfuKHfTc1HrD1YMXi8kkzPheTuxcRlOl+o3SZ1iMV5IglhnN62YFwLMmW46l
        MWRRxMKCBEW2n
X-Received: by 2002:aa7:c905:: with SMTP id b5mr45108edt.161.1614206525813;
        Wed, 24 Feb 2021 14:42:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxX6wHCinOs4mbPbm2b7t4ZXywkzoSCLQSDAz3ddGk0HJEmKYxvUxfEaGzcRz0oxz/i60stnA==
X-Received: by 2002:aa7:c905:: with SMTP id b5mr45085edt.161.1614206525568;
        Wed, 24 Feb 2021 14:42:05 -0800 (PST)
Received: from redhat.com (212.116.168.114.static.012.net.il. [212.116.168.114])
        by smtp.gmail.com with ESMTPSA id w24sm2387595edv.67.2021.02.24.14.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 14:42:04 -0800 (PST)
Date:   Wed, 24 Feb 2021 17:41:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Adrian Catangiu <acatan@amazon.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        gregkh@linuxfoundation.org, rdunlap@infradead.org, arnd@arndb.de,
        ebiederm@xmission.com, rppt@kernel.org, 0x7f454c46@gmail.com,
        borntraeger@de.ibm.com, Jason@zx2c4.com, jannh@google.com,
        w@1wt.eu, colmmacc@amazon.com, luto@kernel.org, tytso@mit.edu,
        ebiggers@kernel.org, dwmw@amazon.co.uk, bonzini@gnu.org,
        sblbir@amazon.com, raduweis@amazon.com, corbet@lwn.net,
        mhocko@kernel.org, rafael@kernel.org, pavel@ucw.cz,
        mpe@ellerman.id.au, areber@redhat.com, ovzxemul@gmail.com,
        avagin@gmail.com, ptikhomirov@virtuozzo.com, gil@azul.com,
        asmehra@redhat.com, dgunigun@redhat.com, vijaysun@ca.ibm.com,
        oridgar@gmail.com, ghammer@redhat.com
Subject: Re: [PATCH v7 1/2] drivers/misc: sysgenid: add system generation id
 driver
Message-ID: <20210224173205-mutt-send-email-mst@kernel.org>
References: <1614156452-17311-1-git-send-email-acatan@amazon.com>
 <1614156452-17311-2-git-send-email-acatan@amazon.com>
 <20210224040516-mutt-send-email-mst@kernel.org>
 <d63146a9-a3f8-14ea-2b16-cb5b3fe7aecf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d63146a9-a3f8-14ea-2b16-cb5b3fe7aecf@amazon.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 02:45:03PM +0100, Alexander Graf wrote:
> > Above should try harder to explan what are the things that need to be
> > scrubbed and why. For example, I personally don't really know what is
> > the OpenSSL session token example and what makes it vulnerable. I guess
> > snapshots can attack each other?
> > 
> > 
> > 
> > 
> > Here's a simple example of a workflow that submits transactions
> > to a database and wants to avoid duplicate transactions.
> > This does not require overseer magic. It does however require
> > a correct genid from hypervisor, so no mmap tricks work.
> > 
> > 
> > 
> >          int genid, oldgenid;
> >          read(&genid);
> > start:
> >          oldgenid = genid;
> >          transid = submit transaction
> >          read(&genid);
> >          if (genid != oldgenid) {
> >                          revert transaction (transid);
> >                          goto start:
> >          }
> 
> I'm not sure I fully follow. For starters, if this is a VM local database, I
> don't think you'd care about the genid. If it's a remote database, your
> connection would get dropped already at the point when you clone/resume,
> because TCP and your connection state machine will get really confused when
> you suddenly have a different IP address or two consumers of the same stream
> :).
>
> But for the sake of the argument, let's assume you can have a connectionless
> database connection that maintains its own connection uniqueness logic.

Right. E.g. not uncommon with REST APIs. They survive disconnect easily
and use cookies or such.

> That
> database connector would need to understand how to abort the connection (and
> thus the transaction!) when the generation changes.

the point is that instead of all that you discover transaction as
a duplicate and revert it.


> And that's logic you
> would do with the read/write/notify mechanism. So your main loop would check
> for reads on the genid fd and after sending a connection termination, notify
> the overlord that it's safe to use the VM now.
> 
> The OpenSSL case (with mmap) is for libraries that are stateless and can not
> guarantee that they receive a genid notification event timely.
> 
> Since you asked, this is mainly important for the PRNG. Imagine an https
> server. You create a snapshot. You resume from that snapshot. OpenSSL is
> fully initialized with a user space PRNG randomness pool that it considers
> safe to consume. However, that means your first connection after resume will
> be 100% predictable randomness wise.

I wonder whether something similar is possible here. I.e. use the secret
to encrypt stuff but check the gen ID before actually sending data.
If it changed re-encrypt. Hmm?

> 
> The mmap mechanism allows the PRNG to reseed after a genid change. Because
> we don't have an event mechanism for this code path, that can happen minutes
> after the resume. But that's ok, we "just" have to ensure that nobody is
> consuming secret data at the point of the snapshot.


Something I am still not clear on is whether it's really important to
skip the system call here. If not I think it's prudent to just stick
to read for now, I think there's a slightly lower chance that
it will get misused. mmap which gives you a laggy gen id value
really seems like it would be hard to use correctly.


> > 
> > 
> > 
> > 
> > 
> > 
> > > +Simplifyng assumption - safety prerequisite
> > > +-------------------------------------------
> > > +
> > > +**Control the snapshot flow**, disallow snapshots coming at arbitrary
> > > +moments in the workload lifetime.
> > > +
> > > +Use a system-level overseer entity that quiesces the system before
> > > +snapshot, and post-snapshot-resume oversees that software components
> > > +have readjusted to new environment, to the new generation. Only after,
> > > +will the overseer un-quiesce the system and allow active workloads.
> > > +
> > > +Software components can choose whether they want to be tracked and
> > > +waited on by the overseer by using the ``SYSGENID_SET_WATCHER_TRACKING``
> > > +IOCTL.
> > > +
> > > +The sysgenid framework standardizes the API for system software to
> > > +find out about needing to readjust and at the same time provides a
> > > +mechanism for the overseer entity to wait for everyone to be done, the
> > > +system to have readjusted, so it can un-quiesce.
> > > +
> > > +Example snapshot-safe workflow
> > > +------------------------------
> > > +
> > > +1) Before taking a snapshot, quiesce the VM/container/system. Exactly
> > > +   how this is achieved is very workload-specific, but the general
> > > +   description is to get all software to an expected state where their
> > > +   event loops dry up and they are effectively quiesced.
> > 
> > If you have ability to do this by communicating with
> > all processes e.g. through a unix domain socket,
> > why do you need the rest of the stuff in the kernel?
> > Quescing is a harder problem than waking up.
> 
> That depends. Think of a typical VM workload. Let's take the web server
> example again. You can preboot the full VM and snapshot it as is. As long as
> you don't allow any incoming connections, you can guarantee that the system
> is "quiesced" well enough for the snapshot.

Well you can use a firewall or such to block incoming packets,
but I am not at all sure that means e.g. all socket buffers
are empty.


> This is really what this bullet point is about. The point is that you're not
> consuming randomness you can't reseed asynchronously (see the above OpenSSL
> PRNG example).
> 
> 
> Alex
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> Sitz: Berlin
> Ust-ID: DE 289 237 879
> 
> 

