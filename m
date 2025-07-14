Return-Path: <kvm+bounces-52335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD917B041A8
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 16:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81AB43ADCFE
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 14:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B003256C81;
	Mon, 14 Jul 2025 14:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uAGeiYYl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50239256C60
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752503387; cv=none; b=JjtFh4xchdgcpqX62QeHnWIMvWYM+B1tqptzVm8BvP327Bu8jPkJcYlbOiBbCp4HWVDrqACd2WGVVuEs08x+2AGJk3UJ+re7UlVC/T2rcAK+++rAuFF6cmJJ6xbE7qgfhHewhoqicF5+S8k3GwyrwliZApUc5dz1r0f3DTO+wTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752503387; c=relaxed/simple;
	bh=ufySmEqBbtquRctyHihRjgUCBqAXenXpl+S/YpUoETg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q2oprc6KlTaMv3khD2Y2mTZh2Aa0JF50HJMMjhfXMv3aL4jhwiEugP/mGsDzqfJznKYANLzRh4Xz2d+IOEzn6oX8+uVMr/b0hu8bFFjkXV3zZpUyPbXtfT58neiRakKiOFXiwab/Qvvn1GJcSrAFyhlE1trJ0Fd3zIoXDVkdHuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uAGeiYYl; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31215090074so8362188a91.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 07:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752503385; x=1753108185; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4tygLsD/nDlBf1TdRSRDBMb7SCjx6RmbKyS7KTfm/5Y=;
        b=uAGeiYYlEN4XcxPWc1DhZ+BblDxuOpENsykrj5Fo/OjMSd+VyUuAbLtLZIDa3/PpS8
         fE89x5B/KJ4eso9VP4RnwXBvxMl+2pMJcBlJk0Rwyu1n+K+P7k47Y7L29FUvo9zgBjWH
         tctFQDko7GFoCusCFg+Or8osiMabp4eJGBNDKYgjxDaBaH+k6DQt1Sku977niS3pUUl6
         AMmz/yHhxwGyRPfkdGU9g4O0+lvsna/KxTOCjPI6EI6i3UUcfuLLJXOu6g+HYKK9VnK8
         ifTlbptTikje2HezoJ7sVWui1XLRABpbi66W978jq5lrK1BQxoeAgpm7Y0S7HbrvdgJD
         scig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752503385; x=1753108185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4tygLsD/nDlBf1TdRSRDBMb7SCjx6RmbKyS7KTfm/5Y=;
        b=YwmvE/Dv8cUCJA1FsALNhIsS+hxI52/kwyejuAUtNl/1eoQN9c1Ggul5y24o7WVo63
         gCclMm8ZAWwLcqNn91/loG3V0vFgmVVSgWxRT6RLdTTndkWt0E+vA0rioH6xR9pOlzpN
         mXLD24ismy0o5OoRpU1X4RoTbXjEMP3/4WvvCAawUoo/rK94cB/DXIJmNBueqa3WZwG8
         0zbp2NJHdqJjFTD3fEel+K4DHETxAf3fu/slaHjErVGG/fojo6dnieiWqU0ld3BYL0Pz
         7O4u/4jfDVTnfsC1nk/2G/5S9HFLtRMOXVNk/cCaGxC01Wkyxx9U4aOYt6dUV85s09ct
         aIxg==
X-Forwarded-Encrypted: i=1; AJvYcCUmSsksARxM4iJZ/t0hlu2ujPwnZ4jFO6okc+qVa7NPg9um5BRDfCnmbiTDRFdYSZD6FYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxrQFIGxPLirid6q3H3rj1i+HIV1Tr/iNDJA770hjAPZkpFi50
	KIdV5foZAggKcDe+H7lDTEtd3dKGTwW/x0gnmzpN8LRUPDt3pwM9HiPwcSW1iA1/qU92hp11BK8
	tB4u4rw==
X-Google-Smtp-Source: AGHT+IFkGn9Pwfi4frrhWyUFfdwjDug5P0qHJhq+LIZYaS8C2on2pMqnJ55kCHqRmZFrnUCz7f8esSFTOXQ=
X-Received: from pjmm3.prod.google.com ([2002:a17:90b:5803:b0:30a:31eb:ec8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a10:b0:31c:23f2:d2ae
 with SMTP id 98e67ed59e1d1-31c4f4dc5femr18443109a91.15.1752503385575; Mon, 14
 Jul 2025 07:29:45 -0700 (PDT)
Date: Mon, 14 Jul 2025 07:29:44 -0700
In-Reply-To: <85ple4go0k.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250711045408.95129-1-nikunj@amd.com> <aHEMmmBWzW_FpX7e@google.com>
 <85ple4go0k.fsf@amd.com>
Message-ID: <aHUUWMnTBfcRO7Uj@google.com>
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, bp@alien8.de, Michael Roth <michael.roth@amd.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sun, Jul 13, 2025, Nikunj A Dadhania wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Jul 11, 2025, Nikunj A Dadhania wrote:
> >> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
> >> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
> >> incompatible GHCB version (less than 2), reject the request early rather
> >> than allowing the guest to start with an incorrect protocol version and
> >> fail later.
> >
> > What happens with ghcb_version==1?   I.e. what failure occurs, and
> > when?
> 
> SNP guest terminates with following error:

So this probably isn't stable@ worth then?  Because I don't see any risk to the
kernel, this is ultimately only a problem if the VMM is broken, and the "fix"
doesn't provide any meaningful change in functionality (the VM is dead no matter
what).

