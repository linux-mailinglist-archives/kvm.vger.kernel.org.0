Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B431C3628
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgEDJwK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 05:52:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55649 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728166AbgEDJwK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 05:52:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588585928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cz/LbRGm4/RWQX7PDtmaj7fSkZzDaX+5dG2vfOr7ypY=;
        b=bJJUfFMXT7KQenyqCjXkyoIBH2E2dQU7p9GYgQiGZyKYMiqOp6VTsNaug+C0ekWFWneixh
        HIPPGGXDjzyRDu8E69f/uDJ7ea2/6VliaXFAUdXIgiM9VTefRxb/ax6Ttdbhn5oEk2iIcS
        JeFPkAXYnNa81qqE47poIMLwE3EqwqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-d3HKFaiXMkO2GdJyJ_S3OQ-1; Mon, 04 May 2020 05:52:03 -0400
X-MC-Unique: d3HKFaiXMkO2GdJyJ_S3OQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4B59107B265;
        Mon,  4 May 2020 09:52:02 +0000 (UTC)
Received: from paraplu.localdomain (unknown [10.36.110.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8609960C87;
        Mon,  4 May 2020 09:51:59 +0000 (UTC)
Received: by paraplu.localdomain (Postfix, from userid 1001)
        id B2EAD3E048A; Mon,  4 May 2020 11:51:57 +0200 (CEST)
Date:   Mon, 4 May 2020 11:51:57 +0200
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Anders =?iso-8859-1?Q?=D6stling?= <anders.ostling@gmail.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        John Snow <jsnow@redhat.com>, Eric Blake <eblake@redhat.com>,
        qemu-block@nongnu.org
Subject: Re: Backup of vm disk images
Message-ID: <20200504095157.GJ25680@paraplu>
References: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
 <20200501150547.GA221440@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200501150547.GA221440@stefanha-x1.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 04:05:47PM +0100, Stefan Hajnoczi wrote:
> On Wed, Apr 22, 2020 at 07:51:09AM +0200, Anders =C3=96stling wrote:

Hi Anders,

> > I am fighting to understand the difference between backing up a VM by
> > using a regular copy vs using the virsh blockcopy command.

tl;dr: While 'blockcopy' is one way to do a full backup; there's a
       better way: 'blockcommit'; see below for a URL to an example.

To add to what Stefan says below, here's the difference: a regular 'cp'
is just that =E2=80=94 an offline copy when your guest is shutdown or sus=
pended.
However, libvirt's 'blockcopy' lets you create a "point-in-time snapshot
[or copy]" of your VM's disk _while_ the VM is running, and optionally,
lets your VM to "live-pivot" its storage to the just-created copy.

The use-case is "live storage migration". =20

Say, your original storage of your VM is on NFS-A, but you want to do
some maintenance on NFS-A.  Here, 'blockcopy' lets you live-copy the
VM's storage from NFS-A to NFS-B, _and_ make the VM use the copy =E2=80=94=
 all
this without causing any downtime to the users of the VM.  Now you can
freely do the maintenance on NFS-A.

A 'blockcopy' operation has two phases:

(1) It copies a VM's disk image, e.g. from 'orig.raw' to 'copy.qcow2',
    while the VM is running.  And it will _keep_ copying as long as your
    VM keeps writing new data.  This is called the "mirroring" phase.

(2) Once the copy.qcow2 has the same content as orig.raw, then you can
    do two things, either (a) end the copying/mirroring, which results
    in a point-in-time 'snapshot' of the orig.raw; or (b) you can
    "live-pivot" the VM's disk image to just-created copy.qcow2.

Management tools like OpenStack (and possibly others) use libvirt's
'blockcopy' API under the hood to allow live storage migration.

There are other useful details here, but I'll skip them for brevity.
Read the "blockcopy" section in `man virsh`.  I admit it can be a little
hard to parse when you normally don't dwell on these matters, but taking
time to experiement gives a robust understanding.

> > What I want to do is to suspend the vm, copy the XML and .QCOW2 files
> > and then resume the vm again. What are your thoughts? What are the
> > drawbacks compared to other methods?

If your main goal is to take a full backup of your disk, *without* any
downtime to your VM, libvirt does provide some neat ways.

One of the most efficient methods to is the so-called "active
block-commit".  It uses a combination of libvirt commands: `virsh
snapshot-create-as`, `virsh blockcommit`, and `rsync`:
  =20
I've written up a full example here:

    https://wiki.libvirt.org/page/Live-disk-backup-with-active-blockcommi=
t

You might also want to refer to this page.

    https://wiki.libvirt.org/page/Live-disk-backup-with-active-blockcommi=
t

            - - -

For libvirt-based incremental backup examples, I'll defer that to Eric
Blake (in Cc).

[...]

> A naive cp(1) command will be very slow because the entire disk image i=
s
> copied to a new file.  The fastest solution with cp(1) is the --reflink
> flag which basically takes a snapshot of the file and shares the disk
> blocks (only available when the host file system supports it and not
> available across mounts).
>=20
> Libvirt's backup commands are more powerful.  They can do things like
> copy out a point-in-time snapshot of the disk while the guest is
> running.  They also support incremental backup so you don't need to
> store a full copy of the disk image each time you take a backup.
>=20
> I hope others will join the discussion and give examples of some of the
> available features.


--=20
/kashyap

