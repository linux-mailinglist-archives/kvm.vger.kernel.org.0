Return-Path: <kvm+bounces-28080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEEB9935AC
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 20:07:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 446231F23C2F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 18:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132A01DCB3A;
	Mon,  7 Oct 2024 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0v2IUBOK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B521E187342
	for <kvm@vger.kernel.org>; Mon,  7 Oct 2024 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728324437; cv=none; b=IhWhVFRVh2v+6Qn0ytOV/rSZzok/bv35DOv0RfRE/qm37tmbEnRXt0a9c/3s+PU1wCNrVxuHNpMX+gbpXS13325no5ljgn4ZLU/BIAofMzYglQ6q9MQ6ZsvAeJ5IlG8MrsXRHg961l0QZLR6DIkCqgnncNhdzFhlByYpiNBxkCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728324437; c=relaxed/simple;
	bh=Ni6BX5KQWkzUj/pu9p2vgFWSsJfGNsVDTxDa1tFaf6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Db8yNEE500QI95+6Yt0ToSFDksFwXxgYkjgolopdoH7Bavg0olnRAnxpGgbVZgELj1jCgGz6lh6TNrxVY3qu8TSvStXAkfTezYc+O54kqTmWqFLgBpJlMcvhJGnLGxwTS+PQQ4YB624CECb4rUuLrV9cey8XdmH/7lQIKEOwN68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0v2IUBOK; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e278b2a5c4so81619587b3.2
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2024 11:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728324435; x=1728929235; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VwUJF7s5S6rOFwH/1ywEO9n1mm6Mhiq+H2CN8zBkDE8=;
        b=0v2IUBOK+x18EUXR1n1nwsizUB5Roj62CqDqS7Gdor9ID+FG85A+1JHbgqRSva4HwP
         vMJX0+MbuO7b69cNw+ldKHKSI8rH5zVOKSbSKTiNJPjKmmJit7lJeNCsS+CCUtDtLg6J
         YJ5tib9NBcm9bZPF98kEdszPhmZ5Nf6qc3ZR9fp39eh01ZKx8YkUqRcZ7LhpJinMb+Hd
         RNxlQjNWtI+ZF9pflzwhiuSvahRKliDP8Bd9uFYwWR7jwbuxr54B8Bkq4/mb1S3cmRIZ
         I0eXLJCA/iNCHSpnAkFTujwsUPd4wpvy1XY+m5pHj1Tp9hNR74+y/pv8SiIFkUWrEOeG
         gdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728324435; x=1728929235;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VwUJF7s5S6rOFwH/1ywEO9n1mm6Mhiq+H2CN8zBkDE8=;
        b=heCMp94AlwQEbl4mK7OYLmT6MQVQIsgmTwjxMUoCslRq/buYm0H794d/4EhNDB37fV
         MQmiDW/PEBPEHus86sUKNT6tSHhl+4V9eye7qhld2YzRokKY6+bhThfaklSzCmfe/B2C
         qRMY0eotz0g6izmhODkdWEeHNanp+hZ5Fg+9qGbQAmTtc5IHGVO5cHfUojvN36Bxkkt8
         7XRVWG57QNeEOArlWgNjwOqLoaltdGdNhscfueChKjaUQTfQfTCRbOY1SGtG7Efy5Owr
         +wX16XypJv3HiTv4OaKoZNPKG1SbbfUHx+Gq5NMnQhArWY0giK2Y11YYFmmeHbqDYPa1
         UfIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUceUE+bmZDIKvEwxEkFW5MVfOZlHsWHXmp4pK0zKjS0AVYQPaMM0YAu+s8AKLP/4J/Hc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHht5T6g9KiKjEcse+cLuAnhQvidhPXHVcGkQ9TVNgcW+KhsGj
	3/8IYcxCifd8TXYOloeWz6OV/Ibo+rJYzvFyF2sXCiYcjLV1xltOJX/EQpt25dkr2F3HX/1i8If
	hHg==
X-Google-Smtp-Source: AGHT+IHojWqKAomAE3uCrn8YPheGegyZrXwQOFdq//Fbnc7LqjEGMuDdg5hyz5LsciiapY8/UB+3hx/1cng=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:690c:961:b0:6db:54ae:fd0f with SMTP id
 00721157ae682-6e2c72aeb70mr1228017b3.7.1728324434662; Mon, 07 Oct 2024
 11:07:14 -0700 (PDT)
Date: Mon, 7 Oct 2024 18:07:13 +0000
In-Reply-To: <SA1PR10MB7815C826ABBCA3AC3B3F3B12E97D2@SA1PR10MB7815.namprd10.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <SA1PR10MB7815C826ABBCA3AC3B3F3B12E97D2@SA1PR10MB7815.namprd10.prod.outlook.com>
Message-ID: <ZwQjUSOle6sWARsr@google.com>
Subject: Re: KVM default behavior change on module loading in kernel 6.12
From: Sean Christopherson <seanjc@google.com>
To: Vadim Galitsin <vadim.galitsyn@oracle.com>
Cc: Klaus Espenlaub <klaus.espenlaub@oracle.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

+lists and Paolo

On Mon, Oct 07, 2024, Vadim Galitsin wrote:
> Hi Sean,
> 
> My name is Vadim. I am from Oracle's VirtualBox team.
> 
> I noticed your commit b4886fab6fb6 (KVM: Add a module param to allow enabling
> virtualization when KVM is loaded) which is a part of 6.12-rc1 (and newer)
> kernel.
> 
> The issue I am observing on VBox side is that no VBox VMs can now be started
> by default. Historically, Qemu and VBox VMs cannot run in parallel (either of
> them should enable virtualization by its own). Previously, when
> virtualization was enabled at the event when Qemu VM starts, there was no
> such issue. I suspect VMware guys might have exactly the same problem now.
> 
> Commit has absolute sense for server virtualization and of course, feature
> can be disabled by specifying "kvm.enable_virt_at_load=0" in kernel command
> line (or by unloading kvmXXX module(s) manually), but it is probably rather
> inconvenient for desktop virtualization users who run other than Qemu VMs I
> think.
> 
> Would you consider to change the default behavior by having
> "kvm.enable_virt_at_load=0", so people who really need it, could explicitly
> enable it in kernel command line?

I'm not dead set against it, but my preference would be to force out-of-tree
hypervisor modules to adjust.  Leaving enable_virt_at_load off by default risks
performance regressions due to the CPU hotplug framework serially operating on
CPUs[1].  And, no offence to VirtualBox or VMware, I care much more about not
regressing KVM users than I care about inconveniencing out-of-tree hypervisors.

Long term, the right answer to this problem is to move virtualization enabling
to a separate module (*very* roughly sketeched out here[2]), which would allow
out-of-tree hypervisor modules to co-exist with KVM.  They would obviously need
to give up control of CR4.VMXE/VMXON/EFER.SVME, but I don't think that's an
unreasonable ask.

The multi-KVM idea aside, TDX support for trusted devices is coming down the pipe
and will need to enable VMX without KVM being involved in order to perform SEAMCALLs
from other subsystems.  I.e. sooner or later, I expect virtualization enabling to
be moved out of KVM.

Short term, one idea would be to have VirtualBox's module (and others) prepare
for that future by pinning kvm-{amd,intel}.ko, and then playing nice if VMX/SVM
is already enabled.

[1] https://lore.kernel.org/all/20240608000639.3295768-9-seanjc@google.com
[2] https://lore.kernel.org/all/20231107202002.667900-14-aghulati@google.com

