Return-Path: <kvm+bounces-38172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A28A35F7F
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 14:54:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E799B188D80D
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2025 13:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E54F1264A91;
	Fri, 14 Feb 2025 13:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="L6/L9wip";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="L6/L9wip"
X-Original-To: kvm@vger.kernel.org
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [104.223.66.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352822641FA
	for <kvm@vger.kernel.org>; Fri, 14 Feb 2025 13:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.223.66.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739541282; cv=none; b=cFroRNQMIDRF7NBLrO8miQu5/D+YxyDTH6RAtyigb9aFCZybfl8FyGtOLJ4hK/0RIBvq5uQduhqGJqcKnYQBznuLCR3qCgr6zKXWabWT08GiRSMN/nSvDD51fyWvj0A3am5TRaRX2073xZYmyhIFEFZa5fH/B1KOi3xrewSvqzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739541282; c=relaxed/simple;
	bh=9GEtvxm6k9W+hbIndFA8tWfpv5TR8uTWSseHKuwNEec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ceKhOjNt2dvB/Z8K7XA5PSPfO/EfMBwL43jke55QbpwQ1sCJDZv+DqD8fnJ9Gx3ajNrTMHGCp5O8D5WjBrck31PiNwBCxSXxh9K9/77zMFZNZOcUfdxjkd6iM+fCDvbwthZxFY5iwvKLzYzC1Q8jpIwWPqDeE6iKBNXROEE2G3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=L6/L9wip; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=L6/L9wip; arc=none smtp.client-ip=104.223.66.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1739541278;
	bh=9GEtvxm6k9W+hbIndFA8tWfpv5TR8uTWSseHKuwNEec=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=L6/L9wipsTUP7c7heUeFshYGWrCaQD6dohn/qbHxPasMbS3bA91XeGhTl0cUDHXgI
	 SNx/Bv3K5ctJrK9LbhyKAbrhVbEtGrqHuqDDV9uo1m+ZVKHIuJ7gwA7k4/+O9lTOK7
	 OeqLg9soNMCmd40PIL5oT+8RMu6fZAblN8jtf/NM=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id E9A951280BCA;
	Fri, 14 Feb 2025 08:54:38 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 0TrHb8hFefNW; Fri, 14 Feb 2025 08:54:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1739541278;
	bh=9GEtvxm6k9W+hbIndFA8tWfpv5TR8uTWSseHKuwNEec=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=L6/L9wipsTUP7c7heUeFshYGWrCaQD6dohn/qbHxPasMbS3bA91XeGhTl0cUDHXgI
	 SNx/Bv3K5ctJrK9LbhyKAbrhVbEtGrqHuqDDV9uo1m+ZVKHIuJ7gwA7k4/+O9lTOK7
	 OeqLg9soNMCmd40PIL5oT+8RMu6fZAblN8jtf/NM=
Received: from lingrow.int.hansenpartnership.com (c-67-166-174-65.hsd1.va.comcast.net [67.166.174.65])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 45DBE1280B19;
	Fri, 14 Feb 2025 08:54:38 -0500 (EST)
Message-ID: <16ecae506c9a207cc714929a62a38d6fbe67df0f.camel@HansenPartnership.com>
Subject: Re: Collecting Open Questions from the Linux Kernel SIG Call
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Steve Rutherford <srutherford@google.com>, linux-coco@lists.linux.dev
Cc: kvm@vger.kernel.org
Date: Fri, 14 Feb 2025 08:54:36 -0500
In-Reply-To: <CABayD+f-1kTZZaKx7Okbi_eoua8uv8qa4_-XMa28CigJ58dZrw@mail.gmail.com>
References: 
	<CABayD+f-1kTZZaKx7Okbi_eoua8uv8qa4_-XMa28CigJ58dZrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[added the kvm list because of the similarities to virt]
On Thu, 2025-02-13 at 10:26 -0800, Steve Rutherford wrote:
> Hi all,
> 
> I'd like to aggregate a list of open questions. This list is
> definitely incomplete. Please add to it!

Sure, but first I'll reiterate the points I made in the meeting.

> 
> * Should there be a standard for common protocols? (But not the
> underlying interfaces, since those can not be universally shared)

So on this one, it would be nice if that happened.  However, the way
the world works today is that every hypervisor has its own guest to
host communication protocol, usually embedded in a hypervisor specific
bus and its drivers (and then they each have their own separate drivers
for the same function), so having one more for a new SVSM
virtualization component just follows that trend.

> * What is the correct method for capability discovery with the SVSM?

The current way the SVSM is discovered on AMD is via an MSR, which
seems appropriate for something so deep in virtualization.  

>         + Do we want the SVSM to touch ACPI? (No, but what instead?)

To clarify, the reason we don't use ACPI today is that the ACPI tables
are constructed in OVMF using host information from the KVM fw_config
device which the SVSM doesn't touch.  To allow the SVSM to modify the
ACPI tables, we'd have to make it terminate the fw_config device, pull
in the information and then re-supply it to OVMF in the modified form.
It's not that we can't do that, it's just that it's way less messy not
to do it.

>         + Going across the common protocol seems pretty reasonable
> * What SVSM capabilities are common and complex enough to warrant
> further discussion?
>       + Observability?
>       + TPM?

Once we accept that the SVSM protocol is really just another
incarnation of the hypervisor bus based guest to host communication
mechanism, I think what we're really asking is what features would we
like to be paravirt.  The two above seem natural.

> * How should the shared code within Linux be organized?

And, given the similarity above, I think where everything goes is
fairly easy.  In our case the discovery mechanism is likely going to be
different between AMD SEV and Intel TDX (and the Arm and RISC-V things
when they come along) it makes sense for the core communication
protocol to sit deep in the arch code, but from there we can expose a
message passing (request/response) API which will look the same for
every architecture and which exposes the basic messages described in
the SVSM protocol document.

Perhaps the only outstanding question is should we have our own bus
like all the other paravirt to hypervisor communication systems?

Regards,

James


