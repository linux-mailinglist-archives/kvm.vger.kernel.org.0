Return-Path: <kvm+bounces-59492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A4CBB8F22
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 16:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 265E44E8935
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 14:54:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440A023E325;
	Sat,  4 Oct 2025 14:54:41 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [83.223.95.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB9521C9F4;
	Sat,  4 Oct 2025 14:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.223.95.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759589680; cv=none; b=IeTa4hReoF8DD9J44hp6qLAThPCLTKYOnP1neeiL0IN0s2IcGyBZ0vHGiAyuGDhIt8UN4dJwGqGEKffjcvYgg7CBRTNbrToEIOc7CtCQEHjwwhI8gTQ9vUt0AFIQIrgJltkf5KRoe8hkfNHhAxFosbpO5QI8l3SfAqei18BhFx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759589680; c=relaxed/simple;
	bh=E1PELn3f9+vSNYanvcwk+NzMgS4y/154mPXdeM8POKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cPRHuc3nYGgCsrDejhvSuSJRtgCIMGEJ8zPVdp9BFjj3t0sVyVjsvvqTcg1Po8v4nqSQe/xIAWCagMQH8cEQAoO02DN/gdpfumfTcqhBJT5hPrMf9vn7TaQwtcZndq7Yfv3g6Q1VqJSSoqB64SqvEQOVEzUfHAnob4paDZoxP3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=none smtp.mailfrom=h08.hostsharing.net; arc=none smtp.client-ip=83.223.95.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=h08.hostsharing.net
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "*.hostsharing.net", Issuer "RapidSSL TLS RSA CA G1" (verified OK))
	by bmailout1.hostsharing.net (Postfix) with ESMTPS id 06EE82C06845;
	Sat,  4 Oct 2025 16:54:29 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id E3D2DFDCBB; Sat,  4 Oct 2025 16:54:28 +0200 (CEST)
Date: Sat, 4 Oct 2025 16:54:28 +0200
From: Lukas Wunner <lukas@wunner.de>
To: Farhan Ali <alifm@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, alex.williamson@redhat.com,
	helgaas@kernel.org, clg@redhat.com, schnelle@linux.ibm.com,
	mjrosato@linux.ibm.com
Subject: Re: [PATCH v4 01/10] PCI: Avoid saving error values for config space
Message-ID: <aOE1JMryY_Oa663e@wunner.de>
References: <20250924171628.826-1-alifm@linux.ibm.com>
 <20250924171628.826-2-alifm@linux.ibm.com>
 <20251001151543.GB408411@p1gen4-pw042f0m>
 <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae5b191d-ffc6-4d40-a44b-d08e04cac6be@linux.ibm.com>

On Wed, Oct 01, 2025 at 10:12:03AM -0700, Farhan Ali wrote:
> AFAIU if the state_saved flag was set to true then any state that we have
> saved should be valid and should be okay to be restored from. We just want
> to avoid saving any invalid data.

The state_saved flag is used by the PCI core to detect whether a driver
has called pci_save_state() in one of its suspend callbacks.  If it did,
the PCI core assumes that the driver has taken on the responsibility to
put the device into a low power state.  The PCI core will thus not put
the device into a low power state itself and it won't (again) call
pci_save_state().

Hence state_saved is cleared before the driver suspend callbacks are
invoked and it is checked afterwards.

Clearing the state_saved flag in pci_restore_state() merely serves the
purpose of ensuring that the flag is cleared ahead of the next suspend
and resume cycle.

It is a fallacy to think that state_saved indicates validity of the
saved state.

Unfortunately pci_restore_state() was amended by c82f63e411f1 to
bail out if state_saved is false.  This has arguably caused more
problems than it solved, so I have prepared this development branch
which essentially reverts the commit and undoes most of the awful
workarounds that it necessitated:

https://github.com/l1k/linux/commits/aer_reset_v1

I intend to submit this after the merge window has closed.

The motivation of c82f63e411f1 was to prevent restoring state if
pci_save_state() hasn't been called before.  I am solving that by
calling pci_save_state() on device addition, hence error
recoverability is ensured at all times.

I believe this also makes patch [01/10] in your series unnecessary.

A lot of drivers call pci_save_state() in their probe hook and
that continues to be correct if they modified Config Space
vis-a-vis what was saved on device addition.

Thanks,

Lukas

