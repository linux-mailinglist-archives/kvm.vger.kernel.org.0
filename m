Return-Path: <kvm+bounces-49066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A199AD5756
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BE441BC1792
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 13:37:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FC6296152;
	Wed, 11 Jun 2025 13:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JZkjaTAJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6017628C017
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749648976; cv=none; b=TgOGye5M/XLnvU/H+5zFe89ZpvfaFOyMerFNmJJxaK2tTSJo2hBtGgXH5pXPwQdIQOyG2UYgE50drZxmMwzaed4WeDZFdXU5GNJJGUNkSGt5B0PAeuTaUaLtivqyOnzZHUnVVyRsw3PqUdnjAoDs3cR8r6DCbxJC5+ObatEfzsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749648976; c=relaxed/simple;
	bh=foDRggao2pYcHMNl7l0j332jRkRfHwDtkPEVvxWcYTU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFAfVjCgkDif5yQwE1+qvziulB/TyGaJSMAnIiZnKivVSURp9kyr8teqAYMLC9R1XLN421cOVQJ4l6zTk+XBYifiCcGP+tK7qfksiE/J+SEat+YC1+CYM0GPESOmtqoIJSo01dbRwKUOd2tshue0p0nLHFUls1oRD8L9t08qTbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JZkjaTAJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so6545983a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 06:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749648975; x=1750253775; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pfAxzbGHD1h7TlrrEjy4MuzNkN+FBi/cByX4hDugIdQ=;
        b=JZkjaTAJPRExhm+qzaIRd057+uWePXge5soBiXCJFpkLa6MJjCucWUKiQmPZU/Z00P
         6CkCchj78HOqUPa+qWBqoNLPCI73TKkl8fH3rRYUMuxuHr9PCMV8c5vrtsPs245UUVEV
         AGi8eApPJiOW4BSvy9eLVUeygAle/KsggAhvZVo20odOv3PJrtr09HLgd+mttKDdp4D7
         ARzX9N+MREisLfbsiDgy87RJjG9DNzHSi4gxkw9KgTFg6eKQB/v/3DDK36Q3P7yO8Q25
         4x7F5hSVrE2HsGNsiS9CAveyYM5YkOHUbZN9SJrts3Wzx+q/Nhye0CMoNMuKD7Y8E3O7
         fvOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749648975; x=1750253775;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pfAxzbGHD1h7TlrrEjy4MuzNkN+FBi/cByX4hDugIdQ=;
        b=TuSaXpP31XYZ+TLy/uC7RBfp7VHCTfTubsQx0J7vn914nfHnDxNG68b2D0JQg0XHuE
         7hC76xCmzg5z4oaPr67todL75TA+WQ4lnhKDR0JHgb4Tszqsv1Korh501WTfIzXYxjYg
         Ebt0GvCno0NP0fq7gIIOhWT5KDnbWFBfJBU2RKqcCoNaFQoQHoVSQIBOZefdXPstja0G
         COyFBx9wuQxAmJakWs9qXU/U6idTqtxYL1haIyAbhaGkepQwJ8ZN5L2Ngm34MvKlnElJ
         cRR8Ti4LahDTGHod0T/wq3zSJvhB0FQVBQxT/EEQItl4fz0mvUsp7ANpnNivwLuUYTXW
         2hOA==
X-Forwarded-Encrypted: i=1; AJvYcCXV99akgEgS6w+2z9DU6IsEdbaI+V4SMwJD2vncw2ewOfQfNEqlZOGv6ra7ll1+z+hARgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQcnTDmFouBo923ZC9AE/r6nA/fbovGaZSwgiZRAAU0gyUfl3f
	MkV9f+FTcy3JraT6INZTS5Gf21GOLvESkKY9QBnJhgRULUFTiI2aGlT/FyTuW+2u+8apkwPib2p
	fb0ITuQ==
X-Google-Smtp-Source: AGHT+IEtDBdONPbDClDPpRyEekyTLdny9CD7x9lmInSpyvD3kQD1fk5WL1GDHKdOdV56nwFKWh9s2QlP4bg=
X-Received: from pjqq12.prod.google.com ([2002:a17:90b:584c:b0:312:ea08:fa64])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3506:b0:313:14b5:2538
 with SMTP id 98e67ed59e1d1-313af21d130mr4589060a91.35.1749648974702; Wed, 11
 Jun 2025 06:36:14 -0700 (PDT)
Date: Wed, 11 Jun 2025 06:36:13 -0700
In-Reply-To: <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
 <20250610021422.1214715-5-binbin.wu@linux.intel.com> <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
 <aEh0oGeh96n9OvCT@google.com> <31c4ab96-55bf-4f80-a6fd-3478cc1d1117@linux.intel.com>
Message-ID: <aEmGTZbMpZhtlkIh@google.com>
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, Kai Huang <kai.huang@intel.com>, 
	Jiewen Yao <jiewen.yao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Tony Lindgren <tony.lindgren@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Kirill Shutemov <kirill.shutemov@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 11, 2025, Binbin Wu wrote:
> On 6/11/2025 3:58 AM, Sean Christopherson wrote:
> > On Tue, Jun 10, 2025, Rick P Edgecombe wrote:
> > > It seems like the reasoning could be just to shrink the possible configurations
> > > KVM has to think about, and that we only have the option to do this now before
> > > the ABI becomes harder to change.
> > > 
> > > Did you need any QEMU changes as a result of this patch?
> > > 
> > > Wait, actually I think the patch is wrong, because KVM_CAP_EXIT_HYPERCALL could
> > > be called again after KVM_TDX_FINALIZE_VM. In which case userspace could get an
> > > exit unexpectedly. So should we drop this patch?
> > Yes, drop it.
> > 
> So, when the TDX guest calls MapGPA and KVM finds userspace doesn't opt-in
> KVM_HC_MAP_GPA_RANGE, just return error to userspace?

Why can't KVM just do what it already does, and return an error to the guest?

	if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
		ret = TDVMCALL_STATUS_INVALID_OPERAND;
		goto error;
	}

