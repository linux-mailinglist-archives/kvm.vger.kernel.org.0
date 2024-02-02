Return-Path: <kvm+bounces-7870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3362847BF7
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 23:04:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C7FD288C59
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 22:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E474785926;
	Fri,  2 Feb 2024 22:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="utht3VX+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B001883A09
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 22:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706911434; cv=none; b=WFpJYapef/3zDF9XDzmp6cuIvld7LpczqpV8C5RhXerZGx9laXNdlu+8LiQr5WBHek9RREMRcSAgmbfnKjXsls3INXoPh984zaYN+dQTZXKhLlZTXSXIL0ZxxJJsDZaSK5DH6k/DoUCqKEDRCrjNtrzbG9mjICrS2wdsa4e/qDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706911434; c=relaxed/simple;
	bh=mS6RlgWUtAgL4Hsb+bdLT8pfZr5Df9vOrkPpbDxrTGY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KWUJo3znHtL0RNqYBzzhVJp2VN68j2q/gIEjvwxOGudnIWQObyz9pLErFVe4SuHiSNrJ+Z/oDK5HS7qHpGVxaH4SclWGhtQYYOS/Y6UrzBuakiXKvtJDaWI5uFt0BlhqKY/by1yE+Vz41pXrSAz7yAw8+TLvhjUvmy4iRlzPM6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=utht3VX+; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso3579859276.0
        for <kvm@vger.kernel.org>; Fri, 02 Feb 2024 14:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706911431; x=1707516231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9fdyvAj2ceAkBq1V2vAT6+dViND/2+FyBMSAlIkBp4A=;
        b=utht3VX+hyijieij3Wso5n4JB6SH8vZdI/W8yRyEGPT7tQOqeVuXJJJHKJJwvhFaHl
         AvH/c581c9tp6Iu1thyIbatXeHi9I0s/O1q2ZYc4Dicp26DEbG62o9+uV9s94tFjHz8L
         jN+1R2pAOsr2e8kbAM9/MXU/x8I6LF1ij+H9JjySyHckLcZSk77iXY0JWzlqg8p5Rj9d
         rKZ3pCZNXG7/6X4fx4zo0GKxgkzQFHBq9oxESFAPf2roGPMc/d1bTfDDpMk2+Bg1bb+a
         ci+i4PTYBqBltTCPpekJPQeFxcMCrNRGfhEBHsExte+70+NW63BiNuojNEEd5+tgY17g
         hAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706911431; x=1707516231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9fdyvAj2ceAkBq1V2vAT6+dViND/2+FyBMSAlIkBp4A=;
        b=X/UoTCx+kScCxq9GtJxV3SJp41DLZvAHXKglzjcRXF4/EZLLIEe8pxCqJm1kD2MDwE
         fbBOlBprrgiobfD2p8ctbcH9F+QILCBLEwlhtnjIG67KcYoEsGN+pVAPvU9RMf9hFvAy
         IRjWpvC+64jW8fFXxNHvZ+YKbxp5zuqCNVO86qrJyZ4VSi43dcIk8szIU0jg87lcMrwg
         OpzH2Aciv08HQu97pGngxN+yMQxf8vyv6A1nu4sBpJjWsUu4uqZLhVGU0fCJN2Mv/5z7
         HtzmRFaNawd6Bjpr+XxULLm7vOP/4oHP4+nO+BnOL6glBT9Ba9DQp2MWUYraDmPZIOPH
         HLjA==
X-Gm-Message-State: AOJu0YygDrFU5g88hb8nn98idY9/ckCA7pJALqNu3hXobzk2FqdNe19J
	/TsbatGwBIOi7EXF8anGwmY4umaLfV7JrfRGGqXErbLF+4NId8siTrMoMJU/AxJumlzoM0AzUi7
	Y5w==
X-Google-Smtp-Source: AGHT+IFpPBhkfQUEm966eS1GQX2rrTrFBtCY3uv3k+mXuiT5na9D0Sj1i0Fisqxp9eDGDSeUa0YKmeBQquo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:240f:b0:dc6:4bf5:5a74 with SMTP id
 dr15-20020a056902240f00b00dc64bf55a74mr297595ybb.11.1706911431732; Fri, 02
 Feb 2024 14:03:51 -0800 (PST)
Date: Fri, 2 Feb 2024 14:03:49 -0800
In-Reply-To: <b45ee6cf-fa51-49eb-93ba-a54f4469470e@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240115125707.1183-1-paul@xen.org> <2b4d020c-08ba-46ac-b004-cd9cb7256bd9@xen.org>
 <ZbMIu84Zi2_PF9o4@google.com> <b45ee6cf-fa51-49eb-93ba-a54f4469470e@xen.org>
Message-ID: <Zb1mxTgzJRWLtofw@google.com>
Subject: Re: [PATCH v12 00/20] KVM: xen: update shared_info and vcpu_info handling
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Feb 02, 2024, Paul Durrant wrote:
> On 26/01/2024 01:19, Sean Christopherson wrote:
> > On Thu, Jan 25, 2024, Paul Durrant wrote:
> > > On 15/01/2024 12:56, Paul Durrant wrote:
> > > > From: Paul Durrant <pdurrant@amazon.com>
> > > > 
> > > > This series has one small fix to what was in v11 [1]:
> > > > 
> > > > * KVM: xen: re-initialize shared_info if guest (32/64-bit) mode is set
> > > > 
> > > > The v11 patch failed to set the return code of the ioctl if the mode
> > > > was not actually changed, leading to a spurious failure.
> > > > 
> > > > This version of the series also contains a new bug-fix to the pfncache
> > > > code from David Woodhouse.
> > > > 
> > > > [1] https://lore.kernel.org/kvm/20231219161109.1318-1-paul@xen.org/
> > > > 
> > > 
> > > Ping?
> > 
> > Sorry, I have done basically zero upstream reviews over the last few weeks, for
> > a variety of reasons.  Unless yet another thing pops up, I expect to dive into
> > upstream reviews tomorrow and spend a good long while there.
> 
> Hi Sean,
> 
>   Have you had any time to take a look at this?

No, I was hoping to get to it today, but that isn't happening.  It's next in my
queue after David Steven's "KVM: allow mapping non-refcounted pages" serie", so
hopefully Monday or Tuesday will be the day.

