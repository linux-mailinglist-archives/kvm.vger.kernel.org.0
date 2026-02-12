Return-Path: <kvm+bounces-71010-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJykKmlBjmleBQEAu9opvQ
	(envelope-from <kvm+bounces-71010-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:08:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 28AF213123B
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:08:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 12A70304A9E7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A4E32C31E;
	Thu, 12 Feb 2026 21:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8jy3zsw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32A729A32D
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 21:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770930520; cv=none; b=sXlW5tYzGXsxLvuemZPsGy8BXsAR4+83Zk28dvLZ5cL8CNqYBu0rSyESLkULyDyuEededrkw9UjABZUlLeZDdEgEQUJRgqOuxiA7cGj/uU7J8LAoBAXJfNCBIVid6QiLvC3nUnQ3cN7Xr8IS1Vadf5RHSqH0wf+9HOGWZnLiUuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770930520; c=relaxed/simple;
	bh=Si4a3lubEVIsFr5xg//zf0cPvmnb0GNinNu5h5MauAE=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=DGj+YT9ZbGw1yNI5cNSx15z+A95HVXkADzkTsPDhe2BPKrg59tNGztwWWNlks27euaVfZ+DeD4k/DxsOPDWRSOIkOjXjU1+SFQKCwc1DOGfxHMQDDULaHS3iPW0xvLzpcMN7gUUMIOkvREVWXQbFVOXxfy1q+uW4ZuKU/J3Etxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8jy3zsw; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-676de68a609so1989743eaf.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770930518; x=1771535318; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DEi6lE69DtAre9+98et1Td5y86Gv96d2+RPCeTq+27M=;
        b=f8jy3zsw9Uhk0b4rInPMiIs/KIJkcZftveWo2R13oY5ZXtqJoVJZKhiYEPY/PzrFzr
         mpCP0oOH9McaaBPWnQyEGSqZLIs47USxQ5YmisJIjhA5xl/cXYd7krqkBh1h6BWqk/gY
         EoiZIuUnBCzmJmrlmECggq37K3gNx+6mbmCqHLWVeCri9A7STJDwzVovNcnMG5KBoiNt
         wlj8rrJ9h7bFf3Cow96e3Voems+MqtAm5rjlVWu9fmRAnvzIMRK4TlvkKl68BmVNYIG6
         uhw3Mw4o+HOsOgeTRuu067BqT9eBnV5WK0CeqSH7vIt5vMEOQKnzzVO0qsErxTxKkAXF
         eH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770930518; x=1771535318;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DEi6lE69DtAre9+98et1Td5y86Gv96d2+RPCeTq+27M=;
        b=Db3DU369X+dAkGEmBoDql0t2t4THasZ9sRcXz7Lvqldy3jdmRSxvV1fdMHE0LqL8AQ
         fwushKZdkoH9Bp7OthkoEURJQNeeUro0wkOF94RQ2G8QCkFFpoC6IVRqkNNzi63+KkmX
         0SHv1iQ51NZJXtTBBy0uVqt6k1piBRHiGtsHD9OOZLfNf3rHopTR078IOE5so8rGi1L+
         o+nFSnTa3JQVY5m9P+0vnrGRzlo3thdWuYmT7kKA6gEsWIoYh5MONJOLo8eAHjyAh845
         qQfWA7uUHft2Q6v66oOq3zof2ZxDAbb4fChvGMvwMOSEvsdN2QRGh8BVUTiFDK3wscx+
         FLCQ==
X-Gm-Message-State: AOJu0YykqyE2Bhti8KTXt7E3nlM4ycaUPP6JSh+9ml+SdnAJxXZXH+wj
	7uOOGyBERbbWn5Xxn9jBBiqjUV2B7FHzfPJXBtAgRFy803o9z4EpwXfN0U3Wn8TjBBXNVFv8oEU
	NxVvaIXvTEcdOXK/XqFLbeul7Ug==
X-Received: from ilmv6.prod.google.com ([2002:a92:c6c6:0:b0:468:4e21:6fcf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:61d:b0:663:2b12:14f1 with SMTP id 006d021491bc7-677243b521amr65721eaf.83.1770930517469;
 Thu, 12 Feb 2026 13:08:37 -0800 (PST)
Date: Thu, 12 Feb 2026 21:08:36 +0000
In-Reply-To: <86v7g5asp4.wl-maz@kernel.org> (message from Marc Zyngier on Tue,
 10 Feb 2026 08:49:59 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsnt8qcxhdpn.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH v6 00/19] ARM64 PMU Partitioning
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, alexandru.elisei@arm.com, pbonzini@redhat.com, 
	corbet@lwn.net, linux@armlinux.org.uk, catalin.marinas@arm.com, 
	will@kernel.org, oliver.upton@linux.dev, mizhang@google.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, shuah@kernel.org, gankulkarni@os.amperecomputing.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71010-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[22];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[coltonlewis@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 28AF213123B
X-Rspamd-Action: no action

Hey Marc, thanks for the review.

Marc Zyngier <maz@kernel.org> writes:

> On Mon, 09 Feb 2026 22:13:55 +0000,
> Colton Lewis <coltonlewis@google.com> wrote:

>> This series creates a new PMU scheme on ARM, a partitioned PMU that
>> allows reserving a subset of counters for more direct guest access,
>> significantly reducing overhead. More details, including performance
>> benchmarks, can be read in the v1 cover letter linked below.

>> An overview of what this series accomplishes was presented at KVM
>> Forum 2025. Slides [1] and video [2] are linked below.

>> IMPORTANT: This iteration does not yet implement the dynamic counter
>> reservation approach suggested by Will Deacon in January [3]. I am
>> working on it, but wanted to send this version first to keep momentum
>> going and ensure I've addressed all issues besides that.

> [...]

> As I have asked before, this is missing an example of how userspace is
> going to use this. Without it, it is impossible to correctly review
> this series.

> Please consider this as a blocker.

Understood. I remember you asking for a QEMU patch specifically.

I had hoped that the use in the selftest was sufficient to show how to
use the uAPI. If not, I can send out an example QEMU patch to the QEMU
ARM mailing list.

> Thanks,

> 	M.

> --
> Without deviation from the norm, progress is not possible.

