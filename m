Return-Path: <kvm+bounces-57886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3000EB7F2DF
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95C614A7F46
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7EF33C757;
	Wed, 17 Sep 2025 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X+p04iBr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BDC33C746
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114889; cv=none; b=cMWX942sJm4Voav9sM+ZtvNk+Ux2ibKiGDfhLIPYyv0f2LWMWnE37VloNSWmEVO8lyC3WUiZZ5Nx9uw53NjDIKNZeX4YFSQPBlDeYNsJz0/bt0shkEiNo1+BxZaW8SSJZvE2faC+2ufNOJl8rvXpSSrlWwwXgTG+tAqmWjhNIeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114889; c=relaxed/simple;
	bh=WbMt08VUPJcs6SUg2Se74Sn0+CZFx6WJ/eZRXR7L1+M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jkTlQTW6SDolfvN2y6XqL+vMRKyDa2kol0mbbXwIfcpUVNKclWmT7KU98Xmn/ydencx18SKEPyiDGgZenkAWkHbbd5RbHzTYpfAnYZNcYCRmtSt7xaExraIAoA8TWmY8tifrF5a1R8fa76nPF/fnNbwnphihXo9JFagVS+UFZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X+p04iBr; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54ccdd1806so2128751a12.2
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 06:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758114888; x=1758719688; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+dStKelxvhfQdf95uSaYkcCy0EFr9PxQZO0L0kZj6MM=;
        b=X+p04iBrQBKNcITEGKbAPjFJJ+tF7y37wQHmmxoEMZxmKe6gaASMB/hrUVYHq6RvRB
         Fwgha99+3PlP0AkDE6xwWKcnwJf9qzeOgYX29HQ1jYxF+387dvVDYV4zNWTzoy5btfeS
         bHmTJM6SrAasxwva/zsaNenVF0NWQRDF9rEYPawXDEpZw8OkSn4H967kv01uhmIpsf97
         aSF6dquka08k+3pIiTINeD7Be3lp8n2OSHgKjE/aij7S9STjY+UmNqCCP1ulLJWPJ7hj
         kfSJfjL8vIaDLsDBX42/d+QVspKW+DCSIuqG2W/T2pKTXmm3tJ6kWPN3FyU2/dnaaE5R
         RtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758114888; x=1758719688;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+dStKelxvhfQdf95uSaYkcCy0EFr9PxQZO0L0kZj6MM=;
        b=bmC5xLiZFfQS5o3glQNXTEphGoH4+C9X8T/6ad3emSQllCGQuvydN4oGKG+d3kDNsY
         qcmY6uqYG4OcmHUDlmoWOzXRotV43fkcqe2y88Git2mLC2BN4lhK49GCeuwUKGeX8SpA
         PLh7MjFP6jSznXQ/S4lLbHxdIzwcWDSy9/NSeZIGF+vu7nr7VuqiG4gewnDwonB8YMx3
         IOPmjfTRFyBkJOAb2jpN3xiJCH+xrisN79lHT7NGMKga83L5zFjXyJzTdzY4KIbw2YIo
         0vbdyaONUf3AzHnMwhYnEfhbod4el+pHlCMPhxixGOQPuNflbw7zOZS6GSYnmsZ66/sM
         4aSg==
X-Forwarded-Encrypted: i=1; AJvYcCXYRcb/TUQ5COenmfXTNJvQMjO6iDemLfczvXFcrO5KjlMk4PVKilOpbuTSys4rPw0vYNk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVeKWOAivR1jUY+tVcUWCzwmnGNIzHo8yn+UGDjuX449+N0XdT
	+Q85wZhmUyZDgY3dLQJqxEKtyHsxsBxA7ytDb0e0bgSWKTO/lOZJlxXWRcs1K7Q2InyXf3Am27R
	GZ+Y96g==
X-Google-Smtp-Source: AGHT+IFM7f2Z2olWNtKq3AasdeRyFgxmIxXSINLJwEK3VfS5x2oQhprQuWkvpKlJfPJnsnCvz3TmY6cyB0o=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:32e:879e:cac1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a05:b0:32e:d599:1f66
 with SMTP id 98e67ed59e1d1-32ee3f53853mr2804657a91.30.1758114887330; Wed, 17
 Sep 2025 06:14:47 -0700 (PDT)
Date: Wed, 17 Sep 2025 06:14:40 -0700
In-Reply-To: <b3fae3e0-1337-430c-beeb-290dc185b8bf@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-5-seanjc@google.com>
 <b3fae3e0-1337-430c-beeb-290dc185b8bf@linux.intel.com>
Message-ID: <aMq0QOX36DOWEXHK@google.com>
Subject: Re: [PATCH v15 04/41] KVM: x86: Introduce KVM_{G,S}ET_ONE_REG uAPIs support
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 16, 2025, Binbin Wu wrote:
> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> > ---
> >   Documentation/virt/kvm/api.rst  |   6 +-
> >   arch/x86/include/uapi/asm/kvm.h |  26 +++++++++
> >   arch/x86/kvm/x86.c              | 100 ++++++++++++++++++++++++++++++++
> >   3 files changed, 131 insertions(+), 1 deletion(-)
> [...]
> > +
> > +#define KVM_X86_REG_ENCODE(type, index)				\
> Nit:
> Is it better to use KVM_X86_REG_ID so that when searching with the string
> non-case sensitively, the encoding and its structure can be related to each
> other?

I'm leaning _very_ slightly toward ENOCDE, but I am a-ok with ID too.  Anyone
else have a preference?  If not, I'll go with Binbinb's suggestion of ID.

