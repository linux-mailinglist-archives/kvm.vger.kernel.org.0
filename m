Return-Path: <kvm+bounces-33898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 628B39F4041
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 02:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 639A9188E0D3
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32A912C54B;
	Tue, 17 Dec 2024 01:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O21C1UEX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6968C0B
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 01:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734400423; cv=none; b=RwZGaltdpC50x7u23vylLSIjXEx+p4U2PvQXblDcJavwjs/IUDSfVhLraNKb1O2t2hxTzlUTKRk6c1ayA0j+sKH09agguUsLG6hhEfmcAyC+z/Dlc2RczEarAK3fGC0FCZcnveYttYfbrU43d15NW2ItwC78TI7PdVON2X8nGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734400423; c=relaxed/simple;
	bh=ilntF6YVSO5sInTM3axI58GzWNG1kBWXkdw+YnQ0Ckc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q0bdBlHs//odk4lCUqeLvJkzrRMkt98VBfepFCwRn3ykq2laZL9uOOSby9Y1Z4KNuB9atcOsVImh3w4x/dHtKPbWbshWYv/r9LhlzeBy7WpvhyoxwG5A7SkELrP+bw4wYWVt+JvVakHYy258o6GF0TjRCNMxAT8p9mxeO7XbZoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O21C1UEX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216266cc0acso47395805ad.0
        for <kvm@vger.kernel.org>; Mon, 16 Dec 2024 17:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734400422; x=1735005222; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KTzYjrWXJcMf7xD7/sgDE240NDaU1rTlGzLti0JBz6s=;
        b=O21C1UEXr8712kcffJ4vdVKYT4GPgFlnOcdLkxVeuDcUO7MA4/N96fqM1Eo4dvMPeL
         fqrph3D/G/GCvp8TW88AC13NwYK3yYw0zvxsNorVc0TvvVsi7NqRF/1VDOGL67LSYxKJ
         IIWcLUlEKZF/zkWg9zMVwtcbuUx4VTRqAvGg9mN2zk+/F9KwyOSe8pOQLKd9K99Y66Wj
         zFUt3fLyvh0oOw4xlIZRamWefq/x3psqUPDfGLKEPm1ZtpfFM1p2pLvmt8fxkNMUGGY1
         SITfFu6TcLZUHo61CTmaM3NkqlIYbDKjKV5AIN8hcLdlL4XIIK+dWcuO89mX1VzM2BvI
         SG1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734400422; x=1735005222;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KTzYjrWXJcMf7xD7/sgDE240NDaU1rTlGzLti0JBz6s=;
        b=auGTpCA0AcGoZM/LbqpDv5tuj5le0C+P3WxvXDKGInsIa72kfMa7N7owCI9hYbOYFd
         7W+fsAvJekuZlux95of6qtS3M48/WqmZAOfONRFVl7exmA8ksy7ns6GBw7LAvPGwJpRN
         q/FsC/XFiOY3aWShIEgmaRxWQFnTw1rXXTtHEcmTiENneJKatMmW6wxvX1n8O3KE6GPS
         X2LD5lBneohA2VocpBA++BjOQwGxlhBLnoIWPSLNROIWFcorIGfywLnnGmCEIe0Tpflf
         L/vbL4hSCdkyjwrgHfYskQMcex5q/0+7+6RYLMKv8bcAOUe8bHgPIp4QhPpjJ6gXV4HC
         X2qA==
X-Forwarded-Encrypted: i=1; AJvYcCXerP1Hh3Egedn9iFDFvnVDzWj1lk4L5wGkGwNP0U/oyeYkQVfPkBGEmhLaOEX2g7I1m6Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGCblkGkD+ProyeWm+QqrnoGSmPi7/24KF06c8R3PLPzmX+G82
	IKf5cePQDKCl88ZHXex2m4V1cnytiDZmN4rkX9JwX0D89yOQMY/ZI56L5SozD+1OI53txnt5UPB
	zHg==
X-Google-Smtp-Source: AGHT+IHv2boA/tZKcg2YKHvyns8uPZgq+Desi9Yft6dkx0kwb1X6UpJKnJ9YbVAAXAi+a9ZwUe/kONiIzFI=
X-Received: from plxm1.prod.google.com ([2002:a17:902:db01:b0:214:bcea:1b7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:120e:b0:215:5d8c:7e46
 with SMTP id d9443c01a7336-218c9262f10mr21055695ad.27.1734400421608; Mon, 16
 Dec 2024 17:53:41 -0800 (PST)
Date: Mon, 16 Dec 2024 17:53:40 -0800
In-Reply-To: <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com> <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
Message-ID: <Z2DZpJz5K9W92NAE@google.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Adrian Hunter <adrian.hunter@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024, Rick P Edgecombe wrote:
> On Tue, 2024-12-10 at 11:22 +0800, Xiaoyao Li wrote:
> > > The solution in this proposal decreases the work the VMM has to do, b=
ut
> > > in the long term won't remove hand coding completely. As long as we a=
re
> > > designing something, what kind of bar should we target?
> >=20
> > For this specific #VE reduction case, I think userspace doesn't need to=
=20
> > do any hand coding. Userspace just treats the bits related to #VE=20
> > reduction as configurable as reported by TDX module/KVM. And userspace=
=20
> > doesn't care if the value seen by TD guest is matched with what gets=20
> > configured by it because they are out of control of userspace.
>
> Besides a specific problem, here reduced #VE is also an example of increa=
sing
> complexity for TD CPUID. If we have more things like it, it could make th=
is
> interface too rigid.

I agree with Rick in that having QEMU treat them as configurable is going t=
o be
a disaster.  But I don't think it's actually problematic in practice.

If QEMU (or KVM) has no visibility into the state of the guest's view of th=
e
affected features, then it doesn't matter whether they are fixed or configu=
rable.
They're effectively Schr=C3=B6dinger's bits: until QEMU/KVM actually looks =
at them,
they're neither dead nor alive, and since QEMU/KVM *can't* look at them, wh=
o cares?

So, if the TDX Module *requires* them to be set/cleared when the TD is crea=
ted,
then they should be reported as fixed.  If the TDX module doesn't care, the=
n they
should be reported as configurable.  The fact that the guest can muck with =
things
under the hood doesn't factor into that logic.

If TDX pulls something like this for features that KVM cares about, then we=
 have
problems, but that's already true today.  If a feature requires KVM support=
, it
doesn't really matter if the feature is fixed or configurable.  What matter=
s is
that KVM has a chance to enforce that the feature can be used by the guest =
if
and only if KVM has the proper support in place.  Because if KVM is complet=
ely
unaware of a feature, it's impossible for KVM to know that the feature need=
s to
be rejected.

This isn't unique to TDX, CoCo, or firmware.  Every new feature that lands =
in
hardware needs to either be "benign" or have the appropriate virtualization
controls.  KVM already has to deal with cases where features can effectivel=
y be
used without KVM's knowledge.  E.g. there are plenty of instruction-level
virtualization holes, and SEV-ES doubled down by essentially forcing KVM to=
 let
the guest write XCR0 and XSS directly.

It all works, so long as the hardware vendor doesn't screw up and let the g=
uest
use a feature that impacts host safety and/or functionality, without the hy=
pervisor's
knowledge.

So, just don't screw up :-)

