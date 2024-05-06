Return-Path: <kvm+bounces-16718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F238BCCC8
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 13:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E84C41C218E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 11:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A65C142E93;
	Mon,  6 May 2024 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/lnPA3P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C571422C5
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 11:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714994741; cv=none; b=a1gLapaZpbKigVftC6NUuhWlJmCxPaHmTeUeWHe/nUdksoZxiJP4brCtb7/edH8Aabf1l+ifK1rt5XAwQf8+aApGGwMM0lgW7hDXX21bmE2nBW5wMv79TQwX92I1SKIWWjW11Vn2uk4VcgUB2+st6dLOHnq9TCZCnHO00DTcGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714994741; c=relaxed/simple;
	bh=XABrxXp/5HBumr1ooVb911N1diVBYRn/euCHMxn2MUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bUvfGkO5P5RsdoUYeBY8VP6DhRRrscdHGBK4Ha6SXetaRAoTkpAR4pccznj8oFn077Y7c1b59CEzd5tChzGf/GcNYsXYmz4+enW6KfZqACs/c5EqOGSSF2zJ6dLzwb7N+GPaZFh9i1HtyShddFuz6pTcHDnWz3mjeO1I7Bq15NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/lnPA3P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714994738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JG47Pp1zlfriG85ow4HZ0py3cxKRgP/mCU5uk5d/lIs=;
	b=E/lnPA3PLDSIo+Jx3zV1PT5nrhreZ2OVy87yEnFr1nnjvuiPAixWMd9nUwFep9IU5FvQfY
	JawkL1xAPJbdD0igWrlBLOyW7kdf5NNKJS0dH4S0X8N4bwDAp83IHkqR0EG6sepbbg310z
	72Fa/jOKD3NlBv3B2r1+OgcJaTMCfQU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-225-nd3T_uyjNGSCp-N9xiCduA-1; Mon,
 06 May 2024 07:25:36 -0400
X-MC-Unique: nd3T_uyjNGSCp-N9xiCduA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70E6E3C025B3;
	Mon,  6 May 2024 11:25:36 +0000 (UTC)
Received: from [192.168.37.1] (ovpn-0-6.rdu2.redhat.com [10.22.0.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DAB34C13FA3;
	Mon,  6 May 2024 11:25:35 +0000 (UTC)
From: Benjamin Coddington <bcodding@redhat.com>
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: kvm@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: I/O stalls when merging qcow2 snapshots on nfs
Date: Mon, 06 May 2024 07:25:34 -0400
Message-ID: <CC139243-7C48-4416-BE71-3C7B651F00FC@redhat.com>
In-Reply-To: <ZjdtmFu92mSlaHZ2@glanzmann.de>
References: <ZjdtmFu92mSlaHZ2@glanzmann.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On 5 May 2024, at 7:29, Thomas Glanzmann wrote:

> Hello,
> I often take snapshots in order to move kvm VMs from one nfs share to
> another while they're running or to take backups. Sometimes I have very=

> large VMs (1.1 TB) which take a very long time (40 minutes - 2 hours) t=
o
> backup or move. They also write between 20 - 60 GB of data while being
> backed up or moved. Once the backup or move is done the dirty snapshot
> data needs to be merged to the parent disk. While doing this I often
> experience I/O stalls within the VMs in the range of 1 - 20 seconds.
> Sometimes worse. But I have some very latency sensitive VMs which crash=

> or misbehave after 15 seconds I/O stalls. So I would like to know if th=
ere
> is some tuening I can do to make these I/O stalls shorter.
>
> - I already tried to set vm.dirty_expire_centisecs=3D100 which appears =
to
>   make it better, but not under 15 seconds. Perfect would be I/O stalls=

>   no more than 1 second.
>
> This is how you can reproduce the issue:
>
> - NFS Server:
> mkdir /ssd
> apt install -y nfs-kernel-server
> echo '/nfs 0.0.0.0/0.0.0.0(rw,no_root_squash,no_subtree_check,sync)' > =
/etc/exports
> exports -ra
>
> - NFS Client / KVM Host:
> mount server:/ssd /mnt
> # Put a VM on /mnt and start it.
> # Create a snapshot:
> virsh snapshot-create-as --domain testy guest-state1 --diskspec vda,fil=
e=3D/mnt/overlay.qcow2 --disk-only --atomic --no-metadata -no-metadata

What NFS version ends up getting mounted here?  You might eliminate some
head-of-line blocking issues with the "nconnect=3D16" mount option to ope=
n
additional TCP connections.

My view of what could be happening is that the IO from your guest's proce=
ss
is congesting with the IO from your 'virsh blockcommit' process, and we
don't currently have a great way to classify and queue IO from various
sources in various ways.

Ben


