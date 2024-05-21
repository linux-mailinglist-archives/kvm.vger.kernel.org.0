Return-Path: <kvm+bounces-17837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B40AE8CB011
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:09:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 698DC1F2344C
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 14:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 198667F7CE;
	Tue, 21 May 2024 14:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CSWuwS47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A917F48F
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716300548; cv=none; b=leFQo8ovTwrece6KukGuLCtVZJB/qcoc8zY0JvgMCYiaeQjWdwqartHryG9kN+9GuPz9jHEYWNH69lVO4ajtLqPkH0aPqcFP/RVDX/HYPDhtz/xVxRpbpVXqbi4hKecszTO/cs8efQdWoAky/WM6xNOxYLGDPCkuGaGh9fWbqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716300548; c=relaxed/simple;
	bh=/caslErRT+Hc56Anfjhz6C34hVHNqoRgVZhJ+3+OHxg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q6IosqXhyzg9d3DU4WIptG0hvnekpNAWNN7OTSA6b5E4hGNYTK+cwYX4XZAYbA5qvJF0CKZMHdXi5xJ9nUH4ngJWhXd9zqR7ENByoT5NcoIYsUEfpavGxlu/OsZT2df6I11LOtFGue7uGWWjdQ0C2VgjKZp2r8npa3bUe0NPWZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CSWuwS47; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dee8315174dso18105492276.0
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 07:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716300546; x=1716905346; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESvGWXS0fD/t8ylmnmWa5FToXUokd2bJzguAulWr/QU=;
        b=CSWuwS477MsQct4LeuXgF5z9n9kh2YlCgMjA2JxFq3sOuBI2xWwJJNEP/RQd1DQTEg
         2FwyO8ZofUSODa58yTwTD7FTA7hQUBFVaTJfTWRusfMSp8XR5f/BUAvJWZfH2k+28iKn
         Z4nnUe0nvrQVpFezJXUH1c2i23QfMjb7sEcP+rcaz+MYdKsn0EzQtjMJFR64eni4drvj
         Bbh3cpNTHlVLPYdXdAf/nroyAaoQ6LRiaqxi5foEjQXUaBIZEFrY9W/QBirPsoIKKFBE
         mcWIKVrNZQPCJ8ns2PbyEUKR7k2NmNWkafFk+7pHQ+WvKsKHAUlJ6r/zpzw3O6/+WPdN
         Zulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716300546; x=1716905346;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESvGWXS0fD/t8ylmnmWa5FToXUokd2bJzguAulWr/QU=;
        b=YLAn7rU5Na3ItGkTaH6oCa2x4fZkApl9eAuM1R7cJe5KgOBYRuCdvGnTwzfeY2zYXb
         AtcE1e/jkuKevDobpZu6rLbGodVUEeS+4q6dscDM6bz1w0o+KE27KO3h9yd2diWgDLA6
         p/m20cLZtlavdhTCAVUUlp2S8qLhrMOfS2zD3errMzpPrUKhm6yuGbXb10pzd9YfjFRT
         MsQehEPN8Iy++0SKBC2f4aTlajEjL+ZqGZ1TmQn1jj8vvVFkDeKlgRePdS9hhQaWa8Lf
         GAnHlvImb7QEbfhu5CU3x59W70TB+tBIBAZmeXy4fRqUaP7eaiU15mmf1x4SFwHUL1Xf
         mvhw==
X-Forwarded-Encrypted: i=1; AJvYcCWH8VGARh2oi+KOnPQk9aSIW8fau7umBYHk2Sn6DBKPf4Z0+YUMNzmlVnyKytHhocXXEmtQgBtDjQYzADjEA2YcbarN
X-Gm-Message-State: AOJu0YzN/4H6PDPP+e8awPeyafVZ0KGfqxMYqWgHitsM0kkZzMYBcbix
	tJj2G5z0mHoo7qVsfLlC5pA1/SZ1coEpmT3R9eVBCH+YRs82jZhyiiksu/VYkG5WLf7kX1BhwiV
	VpQ==
X-Google-Smtp-Source: AGHT+IGnbtKlGqlagUBFegiT63ZwMXiGV3RsvKr3ciCENN1Eb4Oh3qQ6ZMNolc8nj81o5KcT7HCT/rT0m+g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100f:b0:dda:c4ec:7db5 with SMTP id
 3f1490d57ef6-df49063341cmr2813975276.4.1716300545914; Tue, 21 May 2024
 07:09:05 -0700 (PDT)
Date: Tue, 21 May 2024 07:09:04 -0700
In-Reply-To: <20240521020049.tm3pa2jdi2pg4agh@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <58492a1a-63bb-47d2-afef-164557d15261@redhat.com>
 <20240518150457.1033295-1-michael.roth@amd.com> <ZktbBRLXeOp9X6aH@google.com>
 <iqzde53xfkcpqpjvrpyetklutgqpepy3pzykwpdwyjdo7rth3m@taolptudb62c>
 <ZkvddEe3lnAlYQbQ@google.com> <20240521020049.tm3pa2jdi2pg4agh@amd.com>
Message-ID: <ZkyrAETobNEjI4Tr@google.com>
Subject: Re: [PATCH] KVM: SEV: Fix guest memory leak when handling guest requests
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Michael Roth <mdroth@utexas.edu>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ashish.kalra@amd.com, thomas.lendacky@amd.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 20, 2024, Michael Roth wrote:
> On Mon, May 20, 2024 at 04:32:04PM -0700, Sean Christopherson wrote:
> > On Mon, May 20, 2024, Michael Roth wrote:
> > > But there is a possibility that the guest will attempt access the response
> > > PFN before/during that reporting and spin on an #NPF instead though. So
> > > maybe the safer more repeatable approach is to handle the error directly
> > > from KVM and propagate it to userspace.
> > 
> > I was thinking more along the lines of KVM marking the VM as dead/bugged.  
> 
> In practice userspace will get an unhandled exit and kill the vcpu/guest,
> but we could additionally flag the guest as dead.

Honest question, does it make sense from KVM to make the VM unusable?  E.g. is
it feasible for userspace to keep running the VM?  Does the page that's in a bad
state present any danger to the host?

> Is there a existing mechanism for this?

kvm_vm_dead()

