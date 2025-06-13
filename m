Return-Path: <kvm+bounces-49337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24505AD7F90
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:19:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 994943B3084
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A970A1BEF8C;
	Fri, 13 Jun 2025 00:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="evBAP4J6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E56B219E0
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749773979; cv=none; b=O/hEVYfPxGBJojd0cz1dENsW/0ejB3EMMjOY3HoI+u9F80zFXkp7nYi9bkVu7ou3tIdbe6BrMB/TSk8cMRfebvacPFdAbdgvuw9ZWc+sL28LgxRidlHLe2PKAjsCwUl3ZELJfKtvLBXPpScVY9TphKgZijnOyAp9QszsFw7qmB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749773979; c=relaxed/simple;
	bh=XKX29iWpKhMQompHnBgc4Myn5jWYJDdT+waJrSl6fzc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bWlNMwdlYzHBDsmagqxcdDv3RZ4ziKGefP2yuSsFK9rbyLPQjx1Qor3dRcazH97RzyuH3jD0cDwA3FuAGKPLs0nKJ0NrSfyVZjyWvk/Ms2fFHNYXzd6XfEyp7tjkvFfPdLwyq/QBLzhCk/RIZszxZ/ROVPscw7fSMBTlEObjPJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=evBAP4J6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74858256d38so1100063b3a.2
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 17:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749773978; x=1750378778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zBXdLKf3EEYV1ASkezHpDPB0kJtg+7zVKaBfxM4yoCM=;
        b=evBAP4J6jgkQysXauVhvsI++1Q8WFQeVqPNed61ULxbbkWQcixjnKBAhNxJTkc24JV
         CLuwAjshcdo56v1m8z8fhzra0dlN0L1qkACA5xU1LF/87i1ZXDW/hdkD1BoD2GK9wmnH
         GhRiUuiNHE6Ee2nbtEga22jy+VO8N33zFz0Vk5xvK3NQYxGRBBlyBG+2IB+5GYCjwpm3
         0ba9J6f4NQI5EMY+tFHrnEGcf9J51TPlBrdzjmak4JLYRBUAVN366ehtWZ67S1VrMqJz
         OoJu/wYUb6Db2JlVclynrrf/0+9+i0mGVn+Lr4h0aO0BrkwA3OOewZfb02f///2WESpc
         zbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749773978; x=1750378778;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zBXdLKf3EEYV1ASkezHpDPB0kJtg+7zVKaBfxM4yoCM=;
        b=DZ13g9u0GONbSMcQooekSW2mSad3eEfdBd1We5GpWBpXJRU8xof9XRypLKmHVqWrER
         QLiakANkRgRHzuVxDzXg+YQPmrSFhjaOE1nOJ1e+yqvJxK3vAzdKuLF5WQkZ9i2wHUN3
         XZRXy+5tgDp3W1xFIhR/9RifSk2HRMzj8xaHSFctqaBPePPfYd/D5N7h3VOddjX69r6R
         4zzJMTI10lGlhEg6Kc5cBAkHGZMxL35kqXZRQEXMv0aRbS9N+0vkseEiNjTK1yGIDEAz
         o9YG+3HuoYBoHvYe2kJqBT3nZluVS7/r/0PedX5nNPvGpSwwQXdeurstXHg7UigpVAoB
         swQg==
X-Forwarded-Encrypted: i=1; AJvYcCUoxaNJtx1/NaFlKBY4n9gNZW5siR2PMgUYlKQo0zgTuIc3iVv7mnrvU0mtNlO/Yi1rtiM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu7dE+wYw2nFYq+ANAf0tT1op78LgPGs6ajx59Ke+drWvz0cwL
	Zy2YGdluHHGScRtxF0JBXgf1kKMwLJr9iYwFQa9v17wd1FA5GhMWd5iYMZJCs9cHTxEAPNrMfqS
	tEaYS7A==
X-Google-Smtp-Source: AGHT+IF0k1+tIZDVtopDDRGGLH/11kf76s150e/KNVxM3GDrSe802uK39miuCbgBaj11TWbqb+85X1tW07M=
X-Received: from pgbdh21.prod.google.com ([2002:a05:6a02:b95:b0:b2e:b370:6975])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:999a:b0:216:5f67:98f7
 with SMTP id adf61e73a8af0-21facc87cc7mr1099362637.33.1749773977713; Thu, 12
 Jun 2025 17:19:37 -0700 (PDT)
Date: Thu, 12 Jun 2025 17:19:36 -0700
In-Reply-To: <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com> <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com> <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com> <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
 <aEmVa0YjUIRKvyNy@google.com> <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
Message-ID: <aEtumIYPJSV49_jL@google.com>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is RUNNABLE
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Fan Du <fan.du@intel.com>, Dave Hansen <dave.hansen@intel.com>, 
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, Zhiquan1 Li <zhiquan1.li@intel.com>, 
	Kirill Shutemov <kirill.shutemov@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"ackerleytng@google.com" <ackerleytng@google.com>, "tabba@google.com" <tabba@google.com>, 
	Chao P Peng <chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	"jroedel@suse.de" <jroedel@suse.de>, Jun Miao <jun.miao@intel.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025, Rick P Edgecombe wrote:
> On Wed, 2025-06-11 at 07:42 -0700, Sean Christopherson wrote:
> > If there's a *legitimate* use case where the guest wants to ACCEPT a su=
bset of
> > memory, then there should be an explicit TDCALL to request that the unw=
anted
> > regions of memory be unmapped.=C2=A0 Smushing everything into implicit =
behavior has
> > obvioulsy created a giant mess.
>=20
> Hi, still digging on if there is any possible use.
>=20
> I think this may need a guest opt-in, so the guest can say it can handle =
errors
> for both smaller and larger page size matches. So it may not matter if th=
ere is
> a rare usage or not. If KVM finds the guest opts-in (how to do that TBD),=
 it can
> start mapping at the host level.=20

Hmm, clever.  That should work; requiring an updated guest kernel to get op=
timal
performance doesn't seem too onerous.

> If KVM doesn't see the opt-in, the guest gets 4k pages.

As in, KVM doesn't even try to use hugepage mappings?  If so, this idea pro=
bably
gets my vote.

