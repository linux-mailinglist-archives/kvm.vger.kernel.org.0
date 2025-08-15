Return-Path: <kvm+bounces-54794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2123B28307
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 17:36:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCA87AE8453
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 15:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20759304995;
	Fri, 15 Aug 2025 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dvNNOMCa"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA122C3240;
	Fri, 15 Aug 2025 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272179; cv=none; b=lOIhHM6WaZ9Fyiwv5G+kraIKFIrEe++UtAhcSrIvbQJ+Dkb+XQPs6BQxuGXT+qa71utDrnfo50wpxLwEBzUS1y9+kfKBbTTGipReyvirXJ9zy0gSNn5p96JLaQc4bE8/ruoc/I38IySi2Hyu/m1vG9c3IR3n8+TtyZ2HaE9GXhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272179; c=relaxed/simple;
	bh=LVvtEoWl6zkJ4vXxFj1wZD+JN3DAXY3Ez5tp4hw21jw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cR+i1NmtNJHPTwDVzQLQErh6zfAwszeFGsNY5ZAViJ5gHV1xxqzO4VfVChCBkrz0NVqlwMEkmQwjArjkrNOiJK2xymjpZHwjPXOnRhcbd5+Hm4dmil2KvqorWQZ2LmA9NGS6J9DJCBXt6YZxHTJWztvuuQmAXnm2L43lKTc0ZI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dvNNOMCa; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=LVvtEoWl6zkJ4vXxFj1wZD+JN3DAXY3Ez5tp4hw21jw=; b=dvNNOMCakAet0aULtF2eHCyYfF
	qNVLQncAzyuV257dyRHzIMYwHYWvAet2cSaMNGAoqHsQ1Qck//75/HFd+5JTF0ZxlHVtKG2wD0E6x
	JESccKEWLSGGKevGoXHbkB8QOW0e2MX5VpdxaajR8KZEowGrpRwTeJIyLoPtwbegvRM5NX8bmJtpF
	M+mRz0BaX4DhU9tWskk0s9rkrAly/9V65IQovhNy9xeWKo92pHxo94+G4qdAxNlpkF4nmBlh7Xn6W
	It8h72XxkkEISs6GGPtQpyJ8X2POsp5VIjMSWv31zddJ6LOFlAOU9Cpx44gvr3VM5tkn9bTRJCF4S
	gQwzLQJQ==;
Received: from 54-240-197-234.amazon.com ([54.240.197.234] helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umwTO-0000000ETzu-0QlL;
	Fri, 15 Aug 2025 15:36:07 +0000
Message-ID: <b2667c4ebbe5e0da59542d2d9026322bd70c6c6a.camel@infradead.org>
Subject: Re: [syzbot ci] Re: Support "generic" CPUID timing leaf as KVM
 guest and host.
From: David Woodhouse <dwmw2@infradead.org>
To: syzbot ci <syzbot+ci156aec4dff349a40@syzkaller.appspotmail.com>, 
 ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com, bp@alien8.de, 
 dave.hansen@linux.intel.com, graf@amazon.de, hpa@zytor.com,
 kvm@vger.kernel.org,  linux-kernel@vger.kernel.org, mingo@redhat.com,
 pbonzini@redhat.com,  seanjc@google.com, tglx@linutronix.de,
 vkuznets@redhat.com, x86@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Date: Fri, 15 Aug 2025 16:36:05 +0100
In-Reply-To: <689f5129.050a0220.e29e5.0019.GAE@google.com>
References: <689f5129.050a0220.e29e5.0019.GAE@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On Fri, 2025-08-15 at 08:24 -0700, syzbot ci wrote:
> syzbot ci has tested the following series
>=20
> [v1] Support "generic" CPUID timing leaf as KVM guest and host.
> https://lore.kernel.org/all/20250814120237.2469583-1-dwmw2@infradead.org
> * [PATCH 1/3] KVM: x86: Restore caching of KVM CPUID base
> * [PATCH 2/3] KVM: x86: Provide TSC frequency in "generic" timing infomat=
ion CPUID leaf
> * [PATCH 3/3] x86/kvm: Obtain TSC frequency from CPUID if present
>=20
> and found the following issue:
> kernel build error
>=20
> Full report is available here:
> https://ci.syzbot.org/series/a9510b1a-8024-41ce-9775-675f5c165e20
>=20
> ***
>=20
> kernel build error
>=20
> tree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 torvalds
> URL:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 https://kernel.googlesource.com/=
pub/scm/linux/kernel/git/torvalds/linux
> base:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dfc0f6373094dd88e1eaf76c44f2ff01b65db=
851
> arch:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 amd64
> compiler:=C2=A0 Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
> config:=C2=A0=C2=A0=C2=A0 https://ci.syzbot.org/builds/590edf8b-b2a0-4cbd=
-a80e-35083fe0988e/config
>=20
> arch/x86/kernel/kvm.c:899:30: error: a function declaration without a pro=
totype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
>=20
> ***

#syz test:
git://git.infradead.org/users/dwmw2/linux.git f280e5436b3297ebb3ac282faf555=
9139b097969


