Return-Path: <kvm+bounces-11845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAAF87C566
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 23:56:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF9DD1C21538
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3869101DA;
	Thu, 14 Mar 2024 22:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mbophuYk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CFCC13D
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710456991; cv=none; b=kpvPfjwfp66CTUklK9XsFzJRGahxRmt0UBEWLNnh4XuXHvoE5YDDFiEB0QxKabcVEJUlA0ZD1k+KGT+0bbNQV15P244FlIolYotEUKOLPS/t1XtxUyowJAGFs/TDs59a01yDpCZAE6KJfLfqP/MG97C/Lp1Lflp+l8wMkibCAYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710456991; c=relaxed/simple;
	bh=zUGwVd0Yv0nkOSW9GUHRgOk7KhLFU9jjeRUEPHTKrY4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T0FvsaYLjoLeZxTLs6LaJEinsJ+wwehZj2vvIH0Z9V9HRS8PrvQmZC7cisP4ejcsk7cOlIQ7PNSZK/H8BNTna5oiZ2hO9+qyYBoaYDaekoahDgC4DOL7tj5FGBwUd2CeTeEqkCPfL5iQYyGIF4Gj4w3aruOR8vU00v+Bw3HrxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mbophuYk; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e6bf91a8dfso1596475b3a.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 15:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710456989; x=1711061789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XbqpstRtYQ8JkMb3zpP7dCjT/ZA8dEtLsJkyinUWLF4=;
        b=mbophuYkBhPIA2DdTdZXvjo0Omt1x10Its4SdYzox4K6eCR/cHNo/TmJ9tK6BMu3Hz
         32qWQRQaJaIAnuANjSHgt0wp4CQfHggheHwyuHHy52XrXbX5YDL2AZDsjbjViz3NHrIS
         U7eUaSQeUh4VvzK6R2FUhxdN7TKGUFsMfOL3VCGakOIliK1F4OZysnmVcX1ldpsCOWDi
         NPzhUa2GVYK7EM0FzknllQZ0HNhso+mX8gYkdcv4wqPzh0ZuoDKtLmsu8U8z58WmkYrU
         738wIoKGl3NQaHVQ7JuqwkJiAHfzZuZJ0HEZ614ZjkeWCb4dONYLcme2s214+sLTyQwn
         r60Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710456989; x=1711061789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XbqpstRtYQ8JkMb3zpP7dCjT/ZA8dEtLsJkyinUWLF4=;
        b=mc4JRhYKzoOBbB8FYDne2D+5J3wGYUkwIf1fXVgBjq/WXDdEtJXVuvnGNq+q2hrLy8
         YqSLQuiYAuWZ+V7qHoLSE9lvEejA+qnazbcOBcnDfc8ti5zH9JC/M7/rmElp3TF4uTtc
         6Asjt9l908Wc+LUOhuhgi8Z7aB7cRA8XgX+14z351WePbMvelykNW9Ofpf5epYaFkPu7
         etd7kXXcJW9FiKWUmwBW+V95Nywbm2swfdRL26oIuxLMMth19XS7cEIIFRh0dc7jLJ99
         HuiAc44PEiBPUw6taVCl6pS0lLw0h+DwwLtVk8VuHvMMr/a9B8lDVfrlAGJx2G7eyynr
         7Y8A==
X-Forwarded-Encrypted: i=1; AJvYcCWo3saTlH9WBS9/vKSK/V6gqwh/azeXDJQCU+nw79wlgkMe9tl5Ccax//vw+Ua50347bX7eK0GnUE0uD7x2Hx+sxOkn
X-Gm-Message-State: AOJu0YzgkThKuMkKURPOLIMp9UH23n/2b5IC0ytr3zJEZ9s67yDcqBjM
	E7JOiFBsqiJowbLyesdrFTSrOmM9L4uaEwRK55l+d4JW1zB6LwiACRILHCPHJaw+UgDUOg3xyKR
	G4g==
X-Google-Smtp-Source: AGHT+IHL1nGWRPUt2Oy0hxjclaJNlV5M3ONGqW8lRTubyLes97erS22uxfuXyy1x83TcEl2bg5Z3zG2zvOA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d18:b0:6e6:c38e:eaa7 with SMTP id
 fa24-20020a056a002d1800b006e6c38eeaa7mr137828pfb.5.1710456989038; Thu, 14 Mar
 2024 15:56:29 -0700 (PDT)
Date: Thu, 14 Mar 2024 15:56:27 -0700
In-Reply-To: <20240314220923.htmb4qix4ct5m5om@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240226190344.787149-1-pbonzini@redhat.com> <20240226190344.787149-11-pbonzini@redhat.com>
 <20240314024952.w6n6ol5hjzqayn2g@amd.com> <20240314220923.htmb4qix4ct5m5om@amd.com>
Message-ID: <ZfOAm8HtAaazpc5O@google.com>
Subject: Re: [PATCH v3 10/15] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	aik@amd.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 14, 2024, Michael Roth wrote:
> On Wed, Mar 13, 2024 at 09:49:52PM -0500, Michael Roth wrote:
> > I've been trying to get SNP running on top of these patches and hit and
> > issue with these due to fpstate_set_confidential() being done during
> > svm_vcpu_create(), so when QEMU tries to sync FPU state prior to calling
> > SNP_LAUNCH_FINISH it errors out. I think the same would happen with
> > SEV-ES as well.
> > 
> > Maybe fpstate_set_confidential() should be relocated to SEV_LAUNCH_FINISH
> > site as part of these patches?
> 
> Talked to Tom a bit about this and that might not make much sense unless
> we actually want to add some code to sync that FPU state into the VMSA
> prior to encryption/measurement. Otherwise, it might as well be set to
> confidential as soon as vCPU is created.
> 
> And if userspace wants to write FPU register state that will not actually
> become part of the guest state, it probably does make sense to return an
> error for new VM types and leave it to userspace to deal with
> special-casing that vs. the other ioctls like SET_REGS/SREGS/etc.

Won't regs and sregs suffer the same fate?  That might not matter _today_ for
"real" VMs, but it would be a blocking issue for selftests, which need to stuff
state to jumpstart vCPUs.

And maybe someday real VMs will catch up to the times and stop starting at the
RESET vector...

