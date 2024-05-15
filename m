Return-Path: <kvm+bounces-17456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCB08C6BDF
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8780B1F21D39
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 18:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520971591E2;
	Wed, 15 May 2024 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lWh02XTr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD96158DD0
	for <kvm@vger.kernel.org>; Wed, 15 May 2024 18:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715796552; cv=none; b=VsWMDsTYzfzwhO6k/dIXY0BLUprxxSivm1I7QCkE21yB+32/wWF1bAH/QJZlXRxqQ/OJSjJ8sDsh2EQK6hVMJdDH1hMK5vOR6zn1WG04lOppZui47U7s+umcFBpf0MnMxXk0rAGb1xSsRdMElhtsvwbYAAn08wSbKLMO4Ag4ds0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715796552; c=relaxed/simple;
	bh=X1eilwXIKYi2Sto9hlcv4frs8weoVtU1FJdWCJMKQ9I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qu8D5sNjtvpp3+VnGjXoduX9lSYfM3hUAeLEVvUB9/hhV2Y8uwedaKQiUKWF+qm5AgtVeH7HM5w4JrRSU/TCsJ0+eElsMhKmp8VaNv8BP5fAJMhrG3VERJua3d++VoMBTlgyvQlWxgPMW0kr4jvCP9C8j9utUm7BrKWWx5zBPPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lWh02XTr; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f468ae6a5eso6042425b3a.2
        for <kvm@vger.kernel.org>; Wed, 15 May 2024 11:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715796550; x=1716401350; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FM+YbThW51PyC7TBL8oH362GzalyAxIIJmwZ5MG51WM=;
        b=lWh02XTr+xq3tJNFf7gr+QYX8v3YZas7ms6T79oRsjGeOExFgwmzucUpmFlHovUu5v
         Y1vlq1MrEYBwUaCq72kIsIKOJA2BhL1ZCoLc+/9u245VIFB0tAqcVycMaFnUHR3Fp0NZ
         eNt2h/rcICcfS4squdVDQqGuQUTbAls3hBKpybOnPaM7tWMecdS+RNtGGQtbjh1F+Kg8
         WvGUtaAbNjvIRf4gapGTNRPvXLubyBRykejY5CXynD0AMSyhKCLV5QbI1s7IuH5yUT2j
         9va/h+a9gbzwrqOaqYPHdiJ22JdAw2WhthzCJe7QXUx5QYSKXH6mspHplxG+rIf7TLzv
         NxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715796550; x=1716401350;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FM+YbThW51PyC7TBL8oH362GzalyAxIIJmwZ5MG51WM=;
        b=oe9h62TXaiNUoXCIUN3dURkHclm6GW7OQy1tMRSzeRRD2zFooSvaGJo+fzTv/wjt70
         3DPt6zepyt9JWrYBsfgFthLiuqtCTpD9ztpXTK6YtR0XML//qQpaCul1Dq8gtvVWdHdF
         fB6fctP1+/DAGNvtTzMVzg57vmVVil8qxVqU4p1hSg9QVB3kNo1SlpyUypQaz0A/XWYf
         q6IttTT/KbBf1Hq2ri2UeCMLQhdiiXtMDQrj0O5owoEyOwux8GXa8XqcAXgWxSJnIj5z
         uoYQcKvTxoaAEiVt2e+o8korCLONWERvE4x1S2YkK+CTChdZ0ycUl5Us+1nSdhN/uKr0
         v7Lw==
X-Forwarded-Encrypted: i=1; AJvYcCVBzm83sRZxr780qNN2L9ZC5KjfhytFlLG8R5NZSGU4TUyxd8DiUDPksII9vaXzD0H0XnnHbm5FTq09WV6LC2BK2eND
X-Gm-Message-State: AOJu0YyG3MkW2ftHQDvhtBMFq/3oeRAf+rBdOzEJcXr5OE7gGZ/RYHRW
	VjGYv0ibk7BIfm95sCuqhcBje1trCUyQb1il/b1biLI1xdCRBGigSCrsiaswHdCpH+Z+VsRazMm
	bbw==
X-Google-Smtp-Source: AGHT+IHWSG85riIKdpeEb0HWEOQwn6FHYwGWC7RjCoXrSFVl84zF2QgZF1t+hVwwKYKqLd1YI1CN+V+lPSY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3a0f:b0:6f4:9fc7:d1f3 with SMTP id
 d2e1a72fcca58-6f4e037d8fdmr713941b3a.3.1715796550399; Wed, 15 May 2024
 11:09:10 -0700 (PDT)
Date: Wed, 15 May 2024 11:09:09 -0700
In-Reply-To: <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-9-rick.p.edgecombe@intel.com> <ZkTWDfuYD-ThdYe6@google.com>
 <f64c7da52a849cd9697b944769c200dfa3ee7db7.camel@intel.com>
 <747192d5fe769ae5d28bbb6c701ee9be4ad09415.camel@intel.com>
 <ZkTcbPowDSLVgGft@google.com> <de3cb02ae9e639f423ae47ef2fad1e89aa9dd3d8.camel@intel.com>
Message-ID: <ZkT4RC_l_F_9Rk-M@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "sagis@google.com" <sagis@google.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Erdem Aktas <erdemaktas@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com" <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024, Rick P Edgecombe wrote:
> On Wed, 2024-05-15 at 09:02 -0700, Sean Christopherson wrote:
> > > Or most specifically, we only need this zapping if we *try* to have
> > > consistent cache attributes between private and shared. In the
> > > non-coherent DMA case we can't have them be consistent because TDX
> > > doesn't support changing the private memory in this way.
> >=20
> > Huh?=C2=A0 That makes no sense.=C2=A0 A physical page can't be simultan=
eously mapped
> > SHARED and PRIVATE, so there can't be meaningful cache attribute aliasi=
ng
> > between private and shared EPT entries.
> >=20
> > Trying to provide consistency for the GPA is like worrying about having
> > matching PAT entires for the virtual address in two different processes=
.
>=20
> No, not matching between the private and shared mappings of the same page=
. The
> whole private memory will be WB, and the whole shared half will honor PAT=
.

I'm still failing to see why that's at all interesting.  The non-coherent D=
MA
trainwreck is all about KVM worrying about the guest and host having differ=
ent
memtypes for the same physical page.

If the host is accessing TDX private memory, we have far, far bigger proble=
ms
than aliased memtypes.  And so the fact that TDX private memory is forced W=
B is
interesting only to the guest, not KVM.

