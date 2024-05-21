Return-Path: <kvm+bounces-17870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D22BF8CB64A
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 01:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14AEE1C20BE5
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 23:17:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1429C149E1A;
	Tue, 21 May 2024 23:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sO6x8+ui"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56C2E859
	for <kvm@vger.kernel.org>; Tue, 21 May 2024 23:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716333410; cv=none; b=Dh1brHyu7yBHbUIdUsfLs21/XhWku2Yfcs3+ijxw8G4bT4kZUiPhVURgOcstrzP4u0Pqw9J0YcasHOxveBATdKoV2dkJgDG8vw6Whpim5+pJfDw4F4RrF5AAd24QB8Z3fAqiK3goRkFG7UXSyX0tV/4cpFyiMQchiPc4TdhGZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716333410; c=relaxed/simple;
	bh=Ry2b6kPu+p8kFrAdVbxwjoeTuHCP60XH1ZnfrYTGACg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gz3hCiku9N1BozFebTtKDax33YuCJ06qoIecWQPItzmZLVuh0GWIbPJFVSLOEkrlev30EO2M6J6UUOT6MkCHqD7zd4c4vxzND/5gR7jXZyIY1iSHQflt+90vsuHpx4xcsSl59Zno3hp+6sYw4jjAbWir3xZ4dRUn3gHhMaABxq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sO6x8+ui; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8dd488e09so14002361a12.2
        for <kvm@vger.kernel.org>; Tue, 21 May 2024 16:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716333408; x=1716938208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QWx4tDap5TnZgWN5L1koc75NADyLaUKfEEEhuyV4lik=;
        b=sO6x8+uicoxNklsL2/aYHgIbUc7fISL8tdierG5vn525pY0EBb/36Y87Lg6ztoDkqW
         8fbVmUdn3cRbOB036HaCtrARvhgXCWmE68MAhJW2pTRnHN0GU33tWelogC/f9gw732VX
         kBBtcyBbn0Jr7vUfj4UtOWMjv6D5kxIu6aUsSgStMqV1eTaWLjaeI2Zq8IvSPuJGi/x6
         61poF7EXA4PEOV5DGK1GdalVBBg3RpatoxxeiGIpt8XKWnD7NcXvApC5JxKxEoIpgzBE
         RDzgcTlVZ8e8tdCcScO54UqdP8V1d6988RjbFHmUzmUtZZw+3+6tWax3Q8QzgcUEq39n
         NvEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716333408; x=1716938208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QWx4tDap5TnZgWN5L1koc75NADyLaUKfEEEhuyV4lik=;
        b=CuW8RVgRSbi1oSJZmXGRsqjkwu3nirp647CwwLj/XiQDsnk5F5N+Tt2n1+4Mf0s9GM
         KokkyOt6Ul36s+MSuNT9lMfO9FsOAeXhQWr2EQGUBMFxiGUXElY8g5x8a3gpYnJOlsxy
         vAvaSqVTu743Tzt0LHWbP+38vN+LwvQ3QdAsEm5sFjh/eSuFt6cqpYBzepZaXQgoHeD1
         sjPPZ6amqc1FtbI4WVk25fjwplYo3sdnJ0gW5QswgzP9/Dqh/3FvmjRkEAcKTQKoh1uj
         l1ZHl83xUCAHNpQWd8T8c7b7iJzZijKRt7KpjjmY6vhLwFpPBIQxMbvLb7+PMo4QE3vm
         2kTg==
X-Forwarded-Encrypted: i=1; AJvYcCUY2Jr/FsnYoaG0vwPkfYMScLgKevYJUmltMIJWWwRExQygksEsF9h1kwlw+AUemYLHBUHAUQbK5U2mSCE8Kv5Bokan
X-Gm-Message-State: AOJu0YzzKCFKEdVCUAIKDOYVmyJjV6QwjELXG81tm8O9d6Hada3qP8O6
	70x3xk3vVjlL/PxXCAnrRfDtGWRQ1wBCTg+YnIfeYdxaQOxg/WU69E3ljJfOG4WoYxVrz8r9yys
	ELQ==
X-Google-Smtp-Source: AGHT+IHnzE+ZthCssIlHmxg20CnLlKr6bsQKxZ55A80mzM4vh3TMlx+g+JnYoV4TUMf74JNjUWU33z9Lcwc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f7cd:b0:1f3:97f:8f13 with SMTP id
 d9443c01a7336-1f31c975cd3mr10815ad.6.1716333408149; Tue, 21 May 2024 16:16:48
 -0700 (PDT)
Date: Tue, 21 May 2024 16:16:46 -0700
In-Reply-To: <00c59dce-e1e4-47cf-a109-722a033b00d8@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240425233951.3344485-1-seanjc@google.com> <20240425233951.3344485-2-seanjc@google.com>
 <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
 <ZkI5WApAR6iqCgil@google.com> <6100e822-378b-422e-8ff8-f41b19785eea@intel.com>
 <1dbb09c5-35c7-49b9-8c6f-24b532511f0b@intel.com> <Zkz97y9VVAFgqNJB@google.com>
 <00c59dce-e1e4-47cf-a109-722a033b00d8@intel.com>
Message-ID: <Zk0rXkXkchNnRxwQ@google.com>
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, May 22, 2024, Kai Huang wrote:
> On 22/05/2024 8:02 am, Sean Christopherson wrote:
> > On Wed, May 15, 2024, Kai Huang wrote:
> > > How about we just make all emergency virtualization disable code
> > > unconditional but not guided by CONFIG_KVM_INTEL || CONFIG_KVM_AMD, i.e.,
> > > revert commit
> > > 
> > >     261cd5ed934e ("x86/reboot: Expose VMCS crash hooks if and only if
> > > KVM_{INTEL,AMD} is enabled")
> > > 
> > > It makes sense anyway from the perspective that it allows the out-of-tree
> > > kernel module hypervisor to use this mechanism w/o needing to have the
> > > kernel built with KVM enabled in Kconfig.  Otherwise, strictly speaking,
> > > IIUC, the kernel won't be able to support out-of-tree module hypervisor as
> > > there's no other way the module can intercept emergency reboot.
> > 
> > Practically speaking, no one is running an out-of-tree hypervisor without either
> > (a) KVM being enabled in the .config, or (b) non-trivial changes to the kernel.
> 
> Just for curiosity: why b) is required to support out-of-tree hypervisor
> when KVM is disabled in Kconfig?  I am probably missing something.

A variety of hooks that are likely needed for any x86 hypervisor (especially on
Intel) are guarded by CONFIG_KVM.  E.g. the posted interrupt vectors (though it's
definitely possible to use a different model than KVM), the entry point for
trampolining NMIs (though again, a hypervisor could just do "INT 2", at least
until FRED comes along), and probably a few other things.

I'm sure it's possible to workaround any issues, but I would be quite surprised
if out-of-tree code went through the effort of functioning with a kernel built
to play nice with KVM.  Who knows, maybe I'm entirely wrong :-)

