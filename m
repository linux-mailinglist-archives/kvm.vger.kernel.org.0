Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A6B1C33E7
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 09:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgEDH7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 03:59:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58274 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgEDH7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 03:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588579138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qdo5pHbYFQOLbGu7gTnccHLQen1aY6ME41KM5kNPtL4=;
        b=inw3nGSxvZUPMdAWhxVluC298Wan3QeFsysQSpDfaUSddsk+/+W5e/FSazt6E/LoCNnL/p
        2S7xk8cVt33fza/K0xBUXVR8g1rCQQOHaUpBXuDUgnNyGdJ8FA95FwXScOMzippxuCqmli
        Jk9skgKV1UuSwEOPTX06TnjS1+uKpng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-Pwo7g_CQNCeVRpnz58h98w-1; Mon, 04 May 2020 03:58:54 -0400
X-MC-Unique: Pwo7g_CQNCeVRpnz58h98w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A576C8AB381;
        Mon,  4 May 2020 07:58:53 +0000 (UTC)
Received: from angien.pipo.sk (unknown [10.40.208.39])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C346292F;
        Mon,  4 May 2020 07:58:48 +0000 (UTC)
Date:   Mon, 4 May 2020 09:58:45 +0200
From:   Peter Krempa <pkrempa@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Anders =?iso-8859-1?Q?=D6stling?= <anders.ostling@gmail.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        kvm@vger.kernel.org, qemu-block@nongnu.org, libvir-list@redhat.com,
        John Snow <jsnow@redhat.com>
Subject: Re: Backup of vm disk images
Message-ID: <20200504075845.GA2102825@angien.pipo.sk>
References: <CAP4+ddND+RrQG7gGoKQ+ydnwXpr0HLrxUyi-pshc-jsigCwjBg@mail.gmail.com>
 <20200501150547.GA221440@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20200501150547.GA221440@stefanha-x1.localdomain>
X-PGP-Key-ID: 0xD018682B
X-PGP-Key-Fingerprint: D294 FF38 A6A2 BF40 6C75  5DEF 36EC 16AC D018 682B
User-Agent: Mutt/1.13.4 (2020-02-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 01, 2020 at 16:05:47 +0100, Stefan Hajnoczi wrote:
> On Wed, Apr 22, 2020 at 07:51:09AM +0200, Anders =D6stling wrote:
> > I am fighting to understand the difference between backing up a VM by
> > using a regular copy vs using the virsh blockcopy command.
> > What I want to do is to suspend the vm, copy the XML and .QCOW2 files
> > and then resume the vm again. What are your thoughts? What are the
> > drawbacks compared to other methods?

The approaches have diffrerent kind of data integrity they provide and
downtime they require.

Assuming from the above that you don't want to shutdown the OS in the VM
you've got following options:

1) pause VM and copy images as described above
  I definitely don't recommend this approach at all. The drawback is
  that the QCOW2 file on the disk may have inconsistent metadata. Even
  if you ensure that the gues OS state is consistend and written to disk
  it's not guaranteed that qemu's buffers were flushed.

  Also the VM needs to be suspended during the whole copy, unless you
  have the image on a filesystem which has --reflink support as  pointed
  out by Stefan.

2) 'virsh blockcopy'
 The original idea of blockcopy is to move storage of an active VM to a
 different location. It can be used though to "copy" the active disk and
 ensure that the metadata is correct when combined with 'virsh blockjob
 --abort' to finish it. This still requires the guest OS in the VM to
 ensure that the filesystems on the backed-up disk are consistent.

 Also the API has one very severe limitation if your VM has multiple
 disks: There is no way to ensure that you cancel all the copies at the
 same time, so the 'backup' done this way is not taken at a single point
 in time. It's also worth noting that the point in time the backup is
 taken is when the job is --abort-ed.

3) virsh backup
 This is the newest set of APIs specifically designed to do disk backups
 of the VM, offers consistency of the image metadata, and taking of the
 backups of multiple disks at the same point in time. Also the point in
 time is when the API is started, regardless of how long the actual data
 handling takes.

 Your gues OS still needs to ensure filesystem consistency though.

 Additionally as mentioned by Stefan below you can also do incremental
 backups as well.

 One thing to note though is that the backup integration is not entirely
 finished in libvirt and thus in a 'tech-preview' state. Some
 interactions corrupt the state for incremental backups.

 If you are interested, I can give you specific info how to enable
 support for backups as well as the specifics of the current state of
 implementation.

4) snapshots
 Libvirt's snapshot implementation supports taking full VM snapshots
 including memory and disk image state. This sidesteps the problem of
 inconsistent filesystem state as the memory state contains also all the
 buffers.

 When an external snapshot is created, we add a new set of overlay files
 on top of the original disk images. This means that they become
 effectively read-only. You can then copy them aside if you want so. The
 memory image taken along can be then used to fully restore the state of
 the VM.

 There are a few caveats here as well. If the image chain created this
 way becomes too long it may negatively impact performance. Also
 reverting the memory image is a partially manual operation for now. I
 can give specifics if you want.

>=20
> Hi Anders,
> The kvm@vger.kernel.org mailing list is mostly for the discussion and
> development of the KVM kernel module so you may not get replies.  I hav=
e
> CCed libvir-list and developers who have been involved in libvirt backu=
p
> features.
>=20
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
>=20
> Stefan


