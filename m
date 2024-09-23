Return-Path: <kvm+bounces-27312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C677C97EF5A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 18:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 774F71F22191
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 16:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E3E19F422;
	Mon, 23 Sep 2024 16:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b1ETxZzd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DED619F12E
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 16:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727109381; cv=none; b=DipZgYdYcUuZusETValkX0MbQw1+lkC57nxj5QDlXTj1q249fscpswetLkNb1RR6FY1XHMAw5LQ2TJVnbHUgdRGJDK3CU5csQ5J3mnlJprloB3JrzF+MsGl6SBHIEVtdMTKOjREH+cNj1f4PKt85MSXQElnHoVPqX5rVzfS1PVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727109381; c=relaxed/simple;
	bh=wvBAxmzNjHiDLqGE0qislghbbe+hn5M+zzwLRJyw/Ys=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cc/UA4S7qOK1oXnrKY+FZNv0J0WozrXp0bDRfXjgPshbQk9kV1LIaMgi9kyplMliUX4/vdQZxA8k59UVZf5+beQWb87G3h0gsjJAbeZDjiGi8zFkVLmGg0lgyP+3ZiIVDLyEronmaqXGEQnAZGvvubhtF3aYFx0n7rgmBWvhWQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b1ETxZzd; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f74e468aa8so46958521fa.1
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 09:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727109378; x=1727714178; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wvBAxmzNjHiDLqGE0qislghbbe+hn5M+zzwLRJyw/Ys=;
        b=b1ETxZzdEB8V1XLqv/GqDwOp5EN3K6cXEkHGYN0xkQlr4sDgAj7dmrcVnlaxHC1t6r
         eR8DbggWqzA2HqjMA5sFfaNj75lh2X6eOe3pQahS8nSJCPAuV847CTEYxfLTs+QfRM9g
         TiTJWotYTBR38daEjIqdolJ+HgXOim+YwKdmJn1A1j0wPd+RFuUUfsN0jkkyEfs2lRxg
         jM0AhGHXZS+Ge+qvGOoayQgRx71xkbq/1zwnSzuCVHZxb7z0OXMbl0DuTuI0YglARKpJ
         9HAGuWWhe+dUMhJ6WtKPdG7n3l9E8IauErdc2UcIFbpcO81KXk30L42qjxtNBtAlDTC3
         dBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727109378; x=1727714178;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wvBAxmzNjHiDLqGE0qislghbbe+hn5M+zzwLRJyw/Ys=;
        b=jMMkE6uqIykrGvfDsuKRiHQc3ekCNLYS/PmIS1AZpYbkhaP099ziyTEqCDemMpHq2U
         h0TKZMFDMEbrwJJLgtv9znda3M7EqzYlDBTERam9I36rwOnc3scdTLIcy4w8Wy0OnJ6w
         UTpSFKEa7Gd03a9craPQ4OTNXppsf60FsYwjQVhrcP/B5jCq8M/epRzvMXHRAEMU8wCp
         yEVjuYX4aLXNL869Ch9vrkc3f7qtUrnSCxxIJkQ/9VVmJEOCt3Yn63NNCnhgwS0zQCad
         A5x/N/YYKeOw00ICAUaZN9Bw4po+lSBn+08u4xpnmEUTCVLSFO2w0aSSrVnTKMPcmpGC
         4h2w==
X-Forwarded-Encrypted: i=1; AJvYcCWDOks5K7JAZOjPAeOYNDJ4pjQrN+jcE35jm6TGlAKXFiD2VCgOjc3XRm4coBdDEkwo5O0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkM1NIh/iEZ+Tq0WPBmqLW9unxSoCLx5wSIitEOY2ckve/OaR9
	KPjhP96ozjq8vmnM/Ctgu0I/i6tfT0+wR16zD5NzmdhSDNPaU+as
X-Google-Smtp-Source: AGHT+IEG0MqDRP7tkoJ+vbOz1nm3RL6hhOM4PQpwie45ZQeoUdSoxRpdUCp00qTMhNzQPHNqgyIb8g==
X-Received: by 2002:a05:6512:308d:b0:533:3223:df91 with SMTP id 2adb3069b0e04-536ad16306bmr5954628e87.24.1727109377356;
        Mon, 23 Sep 2024 09:36:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:8b28:99fa:f2d8:b8ae? ([2001:b07:5d29:f42d:8b28:99fa:f2d8:b8ae])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-536870a88cbsm3325907e87.222.2024.09.23.09.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 09:36:15 -0700 (PDT)
Message-ID: <946d286165525b1aa4b38cc29706a42fc07bdbf8.camel@gmail.com>
Subject: Re: Proper Online VM Backup
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: shadowbladeee <shadowbladeee@proton.me>, "kvm@vger.kernel.org"
	 <kvm@vger.kernel.org>
Date: Mon, 23 Sep 2024 18:36:13 +0200
In-Reply-To: <D59ssnpunq60gA6lEmbgpSHb5-BYRZ8cw4oquCTtxmV276-oB7KDNPD59i1n2eqHh1kRu7r55V_tvEVrvHvmCFtugMigbqDdXQaqtfLKKlc=@proton.me>
References: 
	<D59ssnpunq60gA6lEmbgpSHb5-BYRZ8cw4oquCTtxmV276-oB7KDNPD59i1n2eqHh1kRu7r55V_tvEVrvHvmCFtugMigbqDdXQaqtfLKKlc=@proton.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-09-22 at 16:53 +0000, shadowbladeee wrote:
> Hello List,
>=20
> I have a KVM server running about 40 VMs these are a large variety of
> OSes ranging from different Linux version, Windows 7s, OpenBSD,
> NetBSD, FreeBSD machines.
> I looking for a proper way to back these up, I don't expect features
> like Vmware's Vmotion to move them live to another server however I
> would like to move them offline to another server and in case the
> sever explodes all I would have to do is spin up the same VMs with a
> script.=20
>=20
> Sounds easy but none of the solutions what I found so far are
> perfect. First I was just doing rsync based backup of the .qcows
> images to the other server, this "mostly" works with Linux and
> Windows however the BSDs don't like it they go from file system
> corruptions at boot time (which is still fixable manually) to the
> point the KVM doesn't even boot.=20
>=20
> Shutting down the VMs to do the backup is not an option.
>=20
> I have tried these 2 methods:
>=20
> https://libvirt.org/kbase/live_full_disk_backup.html
>=20
> https://github.com/abbbi/virtnbdbackup?tab=3Dreadme-ov-file#complete-rest=
ore
>=20
> Makes absolutely no difference, the same issues come out with the VMs
> then if I would just rsync them.

In order for a guest OS to be able to boot cleanly from an image
backup, the guest filesystem must be in a consistent state when the
backup is created, and to ensure this you need cooperation from the
guest during the backup. When using QEMU, this is usually achieved via
the QEMU Guest Agent (QGA), which is what is likely missing in your
VMs.
On Ubuntu/Debian Linux distros, you can install QGA via `apt install
qemu-guest-agent`. I don't know if there are pre-built binary releases
available for Windows and *BSD, but the QGA code is part of the QEMU
source tree,
at=C2=A0https://gitlab.com/qemu-project/qemu/-/tree/master/qga?ref_type=3Dh=
eads,
so you could compile it from source.
If QGA is installed and running in your VM, it will take care of
freezing the guest filesystem before beginning a backup, and thawing it
after the backup is complete. This should work with both methods
(libvirt-based and virtnbdbackup) you referenced above; if you use
virtnbdbackup, see
https://github.com/abbbi/virtnbdbackup?tab=3Dreadme-ov-file#application-con=
sistent-backups
for additional details and options.

