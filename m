Return-Path: <kvm+bounces-17183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAACE8C2647
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03A54284794
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 14:06:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EDF171672;
	Fri, 10 May 2024 14:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A3fIf0oN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A171171656
	for <kvm@vger.kernel.org>; Fri, 10 May 2024 14:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715349898; cv=none; b=lzJR7rSpOJt49I15nZkEQ7v6VBi00nZlDB8PvMlkyH0r0vO+5Kf2Pe4k3lQpGLCzf7dapRafBaipK7r32wW2B0vbvHZADRU6attY/xCpIgcl1SdZaaBFpLop7M5dxJeZpdNy7U6JkymN3QYl10OVpwet8Lp33Ev2SYv1+s9e1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715349898; c=relaxed/simple;
	bh=P9fTiCPU5LNu9fSMjxQ2/KpU8krH4ZDb8EvU1cBSgUU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XEbZsxYdzqgZcR+ZEPtaUZBhU4Z3wrdiLhcBVcbLpB0aZvgMx3ADCi2/ee6P9N7bmAx7cwFLQcxvICupdNXLwG3Mjp9/SePkHC7wgQ9YqYChQpfuM9l5DBzKiql9BtrdVDTBUHAyYvCK9qvfAnpaBzHhKzvCDu1KTRCNA4bnlKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A3fIf0oN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc0bcf9256so3223467276.3
        for <kvm@vger.kernel.org>; Fri, 10 May 2024 07:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715349896; x=1715954696; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lptgC6w3ChpNyW9MHIbYxZ3ZMMcjMFEznHEDQYbM8kE=;
        b=A3fIf0oN6qv0AVa7ThCaE6QffREU10x1ONbRmSIj9k69Y7ve3W+IAeJGEoYAiboZKv
         if7zAsRyO+mirbC1Sxr8SvD2CauyqZt75IYsh561La29RAMiIubC4zryGeM8MYwjAjnw
         T+6X/fBpaEZ1nmSb5etpoRnRIWy38UwhJubfFA9DygGE4bE15hkWRSkC+LLNOQm5Ji/r
         8VwZNLicxIYxAhyNp02YqSWf0rUGWnsAAMBgLkncOXmLYvqPIaug6k4ks4po0Yz1Xgb1
         YsVIYRyP9/4wIljwmJ/ph3gFild19sYoHYN3C5p9s1V8vRbJ2Jetzen4nVlRpIyg7UbP
         J65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715349896; x=1715954696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lptgC6w3ChpNyW9MHIbYxZ3ZMMcjMFEznHEDQYbM8kE=;
        b=trTezqjyp33Te4q1rpHegWqOOhGJrkuO73LF4gyHv86Ri3dkwp/tpMnTFAufjhuQ5Z
         TUIYp4J0OtneGIguVc5AqeocRYvu0Wg0Wuz3GOicW7mPRPD3HJMH7L/b6qcw4pKa5y2O
         0sFJg9YLxaKa/pfNyLKIczEMKmFomF5/Dm3FBw0j+LcYIMOBs/BEQ2nsWJdzk+3e82Ah
         qphlII3S4xb8H23SyBiUkl2M0F6QQk2454JfPDr3XR0TJilYsEfhpNZf2TAVPf6WAxiG
         KUVhOFt1YhNLnDUioK1uZkwLHcZQDfxXsHGw/I9GVmuN2rruFJWpcj7okrOwVt7RPWYz
         Rhjg==
X-Forwarded-Encrypted: i=1; AJvYcCXStHrd7Lfx3KH8TSrGTvOVhgfi9hxSGfbbK+IB1GoYLA6Ih4wYObJCJG6PD3Ud2089QFCuQ+2KkV288ivGELjdZJTy
X-Gm-Message-State: AOJu0YxQ0ecFrOuLqdHwWD9JH7wPQgrpvuiAwYnjSiplcyNfKSLO2mVb
	6Im8iKnYzcRDqcnxn/w/lIwzo+Tu1oOzBgWq5lpjBAs/1jzMXyuzzHnE9PUmwB0Uyw311Nlttqm
	/jw==
X-Google-Smtp-Source: AGHT+IHFJ8lgnm7lxrjhwvOd5/CsqYuUi/u+fXA8g0kwqhmGFvBcB2YMAgNCdEJCKb/uHIQMa7KpHx9cv2o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:154a:b0:deb:88f5:fa0e with SMTP id
 3f1490d57ef6-dee4f1ca69dmr195599276.5.1715349896323; Fri, 10 May 2024
 07:04:56 -0700 (PDT)
Date: Fri, 10 May 2024 07:04:54 -0700
In-Reply-To: <20240509235522.GA480079@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <Zjz7bRcIpe8nL0Gs@google.com> <5ba2b661-0db5-4b49-9489-4d3e72adf7d2@intel.com>
 <Zj1Ty6bqbwst4u_N@google.com> <49b7402c-8895-4d53-ad00-07ce7863894d@intel.com>
 <20240509235522.GA480079@ls.amr.corp.intel.com>
Message-ID: <Zj4phpnqYNoNTVeP@google.com>
Subject: Re: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend specific
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Erdem Aktas <erdemaktas@google.com>, Sagi Shahar <sagis@google.com>, Bo2 Chen <chen.bo@intel.com>, 
	Hang Yuan <hang.yuan@intel.com>, Tina Zhang <tina.zhang@intel.com>, 
	isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, May 09, 2024, Isaku Yamahata wrote:
> On Fri, May 10, 2024 at 11:19:44AM +1200, Kai Huang <kai.huang@intel.com> wrote:
> > On 10/05/2024 10:52 am, Sean Christopherson wrote:
> > > On Fri, May 10, 2024, Kai Huang wrote:
> > > > On 10/05/2024 4:35 am, Sean Christopherson wrote:
> > > > > KVM x86 limits KVM_MAX_VCPUS to 4096:
> > > > > 
> > > > >     config KVM_MAX_NR_VCPUS
> > > > > 	int "Maximum number of vCPUs per KVM guest"
> > > > > 	depends on KVM
> > > > > 	range 1024 4096
> > > > > 	default 4096 if MAXSMP
> > > > > 	default 1024
> > > > > 	help
> > > > > 
> > > > > whereas the limitation from TDX is apprarently simply due to TD_PARAMS taking
> > > > > a 16-bit unsigned value:
> > > > > 
> > > > >     #define TDX_MAX_VCPUS  (~(u16)0)
> > > > > 
> > > > > i.e. it will likely be _years_ before TDX's limitation matters, if it ever does.
> > > > > And _if_ it becomes a problem, we don't necessarily need to have a different
> > > > > _runtime_ limit for TDX, e.g. TDX support could be conditioned on KVM_MAX_NR_VCPUS
> > > > > being <= 64k.
> > > > 
> > > > Actually later versions of TDX module (starting from 1.5 AFAICT), the module
> > > > has a metadata field to report the maximum vCPUs that the module can support
> > > > for all TDX guests.
> > > 
> > > My quick glance at the 1.5 source shows that the limit is still effectively
> > > 0xffff, so again, who cares?  Assert on 0xffff compile time, and on the reported
> > > max at runtime and simply refuse to use a TDX module that has dropped the minimum
> > > below 0xffff.
> > 
> > I need to double check why this metadata field was added.  My concern is in
> > future module versions they may just low down the value.
> 
> TD partitioning would reduce it much.

That's still not a reason to plumb in what is effectively dead code.  Either
partitioning is opt-in, at which I suspect KVM will need yet more uAPI to express
the limitations to userspace, or the TDX-module is potentially breaking existing
use cases.

