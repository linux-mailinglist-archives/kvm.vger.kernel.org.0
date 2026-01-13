Return-Path: <kvm+bounces-67976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A89D5D1B20F
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 21:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E5E53025146
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 20:00:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0122318BAE;
	Tue, 13 Jan 2026 20:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WTl9gKp2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B788023771E
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 20:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768334429; cv=none; b=nt4P4vmx40pCzKWsBIQLhT1asBIMc+XtxQclaEJSmC2ST0XQ5v8sy+6CgQwLbN7r2UbZVWs4audNL/nw4YkbS9gI8zYpQxj667/V9KqsM7m/qxYfqEOP/Cjvko/GO2vxjAnysgsq7NBcy1q+WXEcC8nZxGQ32rcnJnuUj8p4TLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768334429; c=relaxed/simple;
	bh=UJSxkPtKnmu26iI4eC5P2sHS/Q8u4kg6tHt8q7nDwsQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hiTuKwyg0oCadNCxJDUjcqLNx++QgqOYJB0XO54ePPQ+ulANcgNpv9U+KPOg/9ocFuJeeElM7ykRAAsr3upEJilqdnVtc8nGtial+FNeHVxsS+/7Iw/n7cmsmOwU3hveb1N4fvI6z45GbIdOXXCpSwm1V773IBikKLdPXg+0q9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WTl9gKp2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34eff656256so7929164a91.2
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 12:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768334428; x=1768939228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CePKVYrIIDGvhaBrmpLfIj0FOHj9rbBKVaqfUS6ApcU=;
        b=WTl9gKp2+9QzmplrQtdMimI5fcKL7y1ODIgIHqJQ5r2cqh+Ec2qfMEJx0bx9qBK39p
         4pZv9+GITpaEuJlQN8tHA7s8Bkh34fEev7WiK/nKuSnVILQ/t3rJ2camq/kW+vlY6aDv
         RwfEetb1dBIVc5sf+LUj3Qn1OvEkYfeg2pWR5m6YdVFtfIo0b6VNyyg2flZPITnFBBXO
         m4UHW4H1cZzZa55gjmQ/1hWU8mbzQJThmQDKeZko83bk9WacHnvmhkHbD3DOr/bblkOV
         nwrMz+Bv3HfdMVg1OmGPjrpM0Z9ZmdJmqU/EQjJTfX+CUFS2R6ANfS7qmHASVHWSQfPQ
         2WRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768334428; x=1768939228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CePKVYrIIDGvhaBrmpLfIj0FOHj9rbBKVaqfUS6ApcU=;
        b=oF4zjSPa9lbiZTYjaSjzA4jxWiVgPRFE7neMrj3PbV1Lb4zGqcDRSumW+sruwsqREi
         BkALKOC39jxZ7BpYEhV6jn8slWUjv0S4WMAJHmdiRPzlG9UfJQyamgiYj3CgMOAyeV9W
         eC1EAzQjgpH+35475EPtM0DZYqjeeZev7tdsSldfUBmb2tp8/x2g3wJeDZf+vmflhuB9
         A+ZnYtw/LYoNA7NXd6FrMuRLgFcZE32gF5QC7HIxC/1gvO/w77AxexrckuxPP1UKEidT
         tMUuj0yZFJALaTV+pTZ7M77ySW6SwKf1xekyKJDmGq2V5rJjSnTEhl0LLf6aGhMU+ESh
         40Hw==
X-Gm-Message-State: AOJu0Yxhjr3+lvS0zGyqemcxM19zKaGWzwNjPW9nEN8YtHbelvmv5c6+
	Qnr7EaLOssiNZLrRxz+4VGcIL9s7bnMnF7WCaS2fNd5FHEJvUBbiM7IVA/qoWB1jucjPjowttK3
	rNsNPAA==
X-Received: from pjbev18.prod.google.com ([2002:a17:90a:ead2:b0:339:e59f:e26])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2711:b0:34f:62e7:4cec
 with SMTP id 98e67ed59e1d1-35109091bb0mr207935a91.5.1768334427814; Tue, 13
 Jan 2026 12:00:27 -0800 (PST)
Date: Tue, 13 Jan 2026 12:00:25 -0800
In-Reply-To: <DS0PR02MB932134A724D4702B62914DDE8B8EA@DS0PR02MB9321.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20221005211551.152216-1-thanos.makatos@nutanix.com>
 <aLrvLfkiz6TwR4ML@google.com> <DS0PR02MB93218C62840E0E9FA240FAF68BD8A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aS9uBw_w7NM_Vnw1@google.com> <DS0PR02MB9321EA7B6AB2B559CA1CDFDD8BD9A@DS0PR02MB9321.namprd02.prod.outlook.com>
 <aUSobNVZ9VEaLN79@google.com> <DS0PR02MB932134A724D4702B62914DDE8B8EA@DS0PR02MB9321.namprd02.prod.outlook.com>
Message-ID: <aWakWRrEUeaIeVna@google.com>
Subject: Re: [RFC PATCH] KVM: optionally commit write on ioeventfd write
From: Sean Christopherson <seanjc@google.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, John Levon <john.levon@nutanix.com>, 
	"mst@redhat.com" <mst@redhat.com>, "dinechin@redhat.com" <dinechin@redhat.com>, 
	"cohuck@redhat.com" <cohuck@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, 
	"stefanha@redhat.com" <stefanha@redhat.com>, "jag.raman@oracle.com" <jag.raman@oracle.com>, 
	"eafanasova@gmail.com" <eafanasova@gmail.com>, 
	"elena.ufimtseva@oracle.com" <elena.ufimtseva@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jan 13, 2026, Thanos Makatos wrote:
> > +Paolo (just realized Paolo isn't on the Cc)
> > 
> > On Wed, Dec 03, 2025, Thanos Makatos wrote:
> > > > From: Sean Christopherson <seanjc@google.com>
> > > > Side topic, Paolo had an off-the-cuff idea of adding uAPI to support
> > > > notifications on memslot ranges, as opposed to posting writes via
> > > > ioeventfd.  E.g. add a memslot flag, or maybe a memory attribute, that
> > > > causes KVM to write-protect a region, emulate in response to writes,
> > > > and then notify an eventfd after emulating the write.  It'd be a lot
> > > > like KVM_MEM_READONLY, except that KVM would commit the write to
> > > > memory and notify, as opposed to exiting to userspace.
> > >
> > > Are you thinking for reusing/adapting the mechanism in this patch for that?
> > 
> > Paolo's idea was to forego this patch entirely and instead add a more
> > generic write-notify mechanism.  In practice, the only real difference is
> > that the writes would be fully in-place instead of a redirection, which in
> > turn would allow the guest to read without triggering a VM-Exit, and I
> > suppose might save userspace from some dirty logging operations.
> > 
> > While I really like the mechanics of the idea, after sketching out the
> > basic gist (see below), I'm not convinced the additional complexity is
> > worth the gains.  Unless reading from NVMe submission queues is a common
> > operation, it doesn't seem like eliding VM-Exits on reads buys much.
> > 
> > Every arch would need to be updated to handle the new way of handling
> > emulated writes, with varying degrees of complexity.  E.g. on x86 I think
> > it would just be teaching the MMU about the new "emulate on write"
> > behavior, but for arm64 (and presumably any other architecture without a
> > generic emulator), it would be that plus new code to actually commit the
> > write to guest memory.
> > 
> > The other scary aspect is correctly handling "writable from KVM" and "can't
> > be mapped writable".  Getting that correct in all places is non-trivial,
> > and seems like it could be a pain to maintain, which potentially fatal
> > failure modes, e.g.  if KVM writes guest memory but fails to notify,
> > tracking down the bug would be "fun".
> > 
> > So my vote is to add POST_WRITE functionality to I/O eventfd, and hold off
> > on a generic write-notify mechanism until there's a (really) strong use
> > case.
> > 
> > Paolo, thoughts?
> 
> In the absence of a response, shall we go ahead with POST_WRITE? I have the
> revised patch ready.

Ya, fire away.

