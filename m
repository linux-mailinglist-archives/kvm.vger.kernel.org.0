Return-Path: <kvm+bounces-69552-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ASVN+dze2mMEgIAu9opvQ
	(envelope-from <kvm+bounces-69552-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:51:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C85B12B4
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B8F030162A8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 14:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512093314C5;
	Thu, 29 Jan 2026 14:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nX/vI5wE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D7233149
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769698274; cv=none; b=ekBzWchixFO9gcNDUi2Ah0+Ocx7C0PVg6P41D2p9id5Aj4ToxBsSZt/aZWRjhLeevBx6X0pjWfQfkBw/+9HsvwO+GwTb41qGCu5kdMAV2j8zvY2WWdJmhEd/trF9ly3uJ9KSPC4/DFt3MPQ1uGWNQ7UufGAxTGaO/uHVCP1eq5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769698274; c=relaxed/simple;
	bh=oM+7UUJdpz1OO1k3PHX0fdPguu2Vcpzyfe6jwB2RS8k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IzM27vZ0uvpAFgOI6URlLSadI61Mw+hIOj6t2OT1F1L5r2BLwOv+b/X87ltBr4HPin1VAtok4hiTwCKGfg7kXWUW0rVnO5UUPPPdB5xmR1qH6Aob5U5id7WXN97qhtvcV5JVS/8PyNXuwhb/yzGJrqRxH+8jIHKIk8PnEB5Yw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nX/vI5wE; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so9012995ad.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 06:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769698273; x=1770303073; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dI0DzUb+KQ9H02mJnIhZJ92CcKiOgQ087wkT8EgGVcc=;
        b=nX/vI5wEIpNVXBQA/b41i09Ssh+Jsyd3hc6uxENcwZbXLNar7iWzGejsortBxENOii
         3G+RKyqyXzfEgYB0tY2NVQ59v3qKgf4ZsRfM7aofEZE3rZ6Ir9lKeII04cMaEOQ9b1Gh
         bS5oRcDHQ4M71/r+LIDqFUYSqKZD8HC8bfPQ9IBLcI09q8BGuO1xxrtmCo3BFJlZT5vM
         djoNIodcsivm7oc+KVQAsTudXpVmXkw3cMInZXqb2IAN4dCDHziDwhNIAAfYWbtiFsnG
         gM3+4sRbC1cW4sKgEBiYymo44JCVzIW9bh5bBd5ihiY+q75KID294tjJgzucVmRDYLqv
         wklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769698273; x=1770303073;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dI0DzUb+KQ9H02mJnIhZJ92CcKiOgQ087wkT8EgGVcc=;
        b=wmM9J0IsXVSnkRvYyb/yRdhPhwpCkru9Rh5KbkYk82motIaoJJYEVrucqYOPt4qt3c
         DrmahrwrwB31nmiWqxpfeWW4H4k0NVFqK2E3C2TC4DxDGHOu3Wth0z78RIujTVc8PBko
         E+fZg7kMGa/le/nH0zzO2wbHKw/Ghk+rsbj2K9UocKPWGAMTuubigwZMgARFSTCZy1oq
         KJW6URKKNA1tbt03OuE0tLXJt/xF5iDsOWMonvo/fVdEvFSOSpm/6ju3FrqVb/+H+zSG
         NzkB1wajbtU2ryiApNuv8FwLuC8bF1SeVvuR+NKYxhINVVtdm2NcR7ZoAJbDdwj+SOgl
         nQkA==
X-Forwarded-Encrypted: i=1; AJvYcCVsnOPmavBbIlzwZCid8eovqnD6MzAOJanJxhA73R8+Qk/zqdNjMjAg1hyumH5xJcLEFwo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZWeLzxVoRTETcsxXPUWKCXMyfP47yh8KlWJCl9W0ixIBTbhJA
	4RtI4SEmM9D2XabnVJDHI6to5Dro25Um93a6LmxkBg3KtGpyA5df4UBoeEhbQZ9vvvko9ok5rRT
	4ttUSPA==
X-Received: from pllm10.prod.google.com ([2002:a17:902:768a:b0:2a0:a0e0:a9c3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ef44:b0:2a5:99ec:16d7
 with SMTP id d9443c01a7336-2a870da13b0mr99177525ad.7.1769698272741; Thu, 29
 Jan 2026 06:51:12 -0800 (PST)
Date: Thu, 29 Jan 2026 06:51:11 -0800
In-Reply-To: <aXHEpfcyHtaMcqPz@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <20260106102136.25108-1-yan.y.zhao@intel.com>
 <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
 <aWrMIeCw2eaTbK5Z@google.com> <CAGtprH9OWFJc=_T=rChSjhJ3utPNcV_L_+-zq5uqtmXm-ffgNQ@mail.gmail.com>
 <aW_DQafZNMQN5-gS@google.com> <aXHEpfcyHtaMcqPz@yzhao56-desk.sh.intel.com>
Message-ID: <aXtz37RP2fHIgjLi@google.com>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Kai Huang <kai.huang@intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fan Du <fan.du@intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Chao P Peng <chao.p.peng@intel.com>, 
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Jun Miao <jun.miao@intel.com>, 
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69552-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[google.com,intel.com,redhat.com,vger.kernel.org,amd.com,suse.cz,kernel.org,linux.intel.com,suse.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[29];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 35C85B12B4
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Yan Zhao wrote:
> On Tue, Jan 20, 2026 at 10:02:41AM -0800, Sean Christopherson wrote:
> > On Tue, Jan 20, 2026, Vishal Annapurve wrote:
> > > On Fri, Jan 16, 2026 at 3:39=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > > And then for the PUNCH_HOLE case, do the math to determine which, i=
f any, head
> > > > and tail pages need to be split, and use the existing APIs to make =
that happen.
> > >=20
> > > Just a note: Through guest_memfd upstream syncs, we agreed that
> > > guest_memfd will only allow the punch_hole operation for huge page
> > > size-aligned ranges for hugetlb and thp backing. i.e. the PUNCH_HOLE
> > > operation doesn't need to split any EPT mappings for foreseeable
> > > future.
> >=20
> > Oh!  Right, forgot about that.  It's the conversion path that we need t=
o sort out,
> > not PUNCH_HOLE.  Thanks for the reminder!
> Hmm, I see.
> However, do you think it's better to leave the splitting logic in PUNCH_H=
OLE as
> well? e.g., guest_memfd may want to map several folios in a mapping in th=
e
> future, i.e., after *max_order > folio_order(folio);

No, not at this time.  That is a _very_ big "if".  Coordinating and trackin=
g
contiguous chunks of memory at a larger granularity than the underlying Hug=
eTLB
page size would require significant complexity, I don't see us ever doing t=
hat.

