Return-Path: <kvm+bounces-8286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2109484D5A8
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 23:16:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE8DA2824B9
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 22:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A0B8149DFB;
	Wed,  7 Feb 2024 22:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TApMJgiS"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211F1149DF2
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707343659; cv=none; b=NBUwln7ECitUJT5wwF2bFa/BezXc8BWP/JUygQ4kAsX6DDKLta895l3PDEk6Wvxwi0Q/tnyc5nyjWDGGqOfkFPScvclQ2BaEsLIPsDFpjftNoi0DwNTRdzQjq2WmMIvKfD4jP4/j7w0On/DgwC1NIsZ9CcERDoL8Cv65pNAL7Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707343659; c=relaxed/simple;
	bh=lQKTmXXfyL2HGCwmb6GhwD64ciTo7eQTjNUAe0lEzl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSzhdgLk6K1wLLC7C5S6FLI2bVE7H0ajeZAzeTRZWfGazrweqZyBJTw7gbYWocGXK0UC8oNaoRBXLbnHfcr2+SNAli05+29qa5CPp+83kIPiyG6ty43R4fAawAYF0toYsmnQ+XaUD9V8EQ7C5o8dJGpZYJt2gnhXRZ3GlQo5NJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TApMJgiS; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Feb 2024 22:07:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707343654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=31fjjN/2eR9+G4chn6VsAsEY/daqpMI5kFarOQVJ+Oo=;
	b=TApMJgiSddK6T73OIk+8bc+zjN5Ckb/zGPufuxwpRpcrqE0AAbToUBmGaLGYq/aOaL91k+
	rBpb74dgeEPezUcB20eIplglFepUzPejJu7NrgBnIAWjLJNlcqRj6DAGGp/6g4LXtzuqgM
	hbS0VMTzTuFuEz4t2xcKDXCppCyGer8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com,
	nadav.amit@gmail.com, isaku.yamahata@gmail.com,
	kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
Message-ID: <ZcP_JHsMJUlvjAs1@linux.dev>
References: <20231109210325.3806151-1-amoorthy@google.com>
 <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com>
 <ZcOysZC2TI7hZBPA@linux.dev>
 <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 07, 2024 at 01:21:05PM -0800, Anish Moorthy wrote:
> On Wed, Feb 7, 2024 at 8:41 AM Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > On Wed, Feb 07, 2024 at 07:39:50AM -0800, Sean Christopherson wrote:
> >
> > Having said that...
> >
> > > be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_FAULT_INFO
> > > is a lie.  Userspace can't catch KVM in the lie, but that doesn't make it right.
> > >
> > > That should in turn make it easier to write a useful changelog.
> >
> > The feedback still stands. The capability needs to be squashed into the
> > patch that actually introduces the functionality.
> >
> > --
> > Thanks,
> > Oliver
> 
> Hold on, I think there may be confusion here.

No, there isn't.

> KVM_CAP_MEMORY_FAULT_INFO is the mechanism for reporting annotated
> EFAULTs. These are generic in that other things (such as the guest
> memfd stuff) may also report information to userspace using annotated
> EFAULTs.
> 
> KVM_CAP_EXIT_ON_MISSING is the thing that says "do an annotated EFAULT
> when a stage-2 violation would require faulting in host mapping" On
> both x86 and arm64, the relevant functionality is added and the cap is
> advertised in a single patch.
> 
> I think it makes sense to enable/advertise the two caps separately (as
> I've done here). The former, after all, just says that userspace "may
> get annotated EFAULTs for whatever reason" (as opposed to the latter
> cap, which says that userspace *will* get annotated EFAULTs when the
> stage-2 handler is failed). So even if arm64 userspaces never get
> annotated EFAULTs as of this patch, I don't think we're "lying" to
> them.

I don't know about you, but I find describing UAPI in terms of "may" and
"whatever reason" quite unsettling. I like to keep my interactions with
userspace deterministic.

Overall, I find the informational capability to be quite superfluous as
it pertains to this feature. Userspace has *explicitly* opted in to a
specific behavior, and the side band capability provides no useful
information. You can easily document KVM_CAP_MEMORY_FAULT_INFO in
such a way that userspace expects to take this sort of exit.

Nobody has presented a use case for annotated EFAULTs on arm64 beyond this
opt-in and there is zero interest in predefining UAPI for anything else.
x86 may've done this a different way, but that's their business.

We're not making UAPI out of any of our other EFAULT returns right now.

> Consider a related problem: suppose that code is added in core KVM
> which also generates annotated EFAULTs, and that later the arm64
> "Enable KVM_CAP_EXIT_ON_MISSING"  patch [1] ends up needing to be
> reverted for some reason.

The single rule we try to uphold in the kernel is to *never break
userspace*, so I don't see this being in the realm of possibility. The
moment we expose a feature to userspace we're on the hook for it in
perpetuity, and if we break that then you're welcome to send a nastygram
to Marc or I.

-- 
Thanks,
Oliver

