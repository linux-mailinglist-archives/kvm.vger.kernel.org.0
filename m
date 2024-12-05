Return-Path: <kvm+bounces-33172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE299E5DFC
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 19:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 142B518856E8
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 18:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43526226EF5;
	Thu,  5 Dec 2024 18:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="j437SR17"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C1F217F29
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 18:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421984; cv=none; b=T4m4CMgsX2iBHOOOjJR8XArdGkXOnd7i5u4LBFe4/NFVuzbQ+g2ws3sxB42z+eqrSNpHOxiZSvYMm4M7x80gydQ+7kVy7Bj8Bch6q3wSfdmH2xykZlCIDqjlGNIJXQQTXlLdJdo5YfD24vHNR2MAS9YQBjcLsR9zO2D+2xZPINM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421984; c=relaxed/simple;
	bh=7VVbtfLDThTIMEGNmmhgSkVFgY39ZieNAqopuJdypZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvAPleap27+zJgFvAUsXxhPt2k9cwbku5afhBLgVEFSzmdkxDTepYy2snViSmtTw+2r749rnfJfMUA0fy7H6aAzdbkObD8HMm5T6WTdnOpw6pkdMNUtyPc0wPT9ePKEyU+fjbfPe3bhTILkhzGxHsknRdkho2icEaGbH97giptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=j437SR17; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D590C40E0266;
	Thu,  5 Dec 2024 18:06:19 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id YxO2JqUaNSpj; Thu,  5 Dec 2024 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733421976; bh=N7Y0QhHqCr16DPB06dfs7uScT4sFuJ+tQLfiCR1AakA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j437SR17Nzg6rvthcHmfdPUYN3qqyQeI0Kl7v6VIMRgOOsgROq7SuX2K5EgQePIBB
	 IuSb0EkfhNM1qoVQwlyHWdxHYP0FTruaHQxWJij+cQIuxGpJ1IR1g4wqtsKl36oxSh
	 qZ/2mn3kUZRwAWWkUikmyVeq88Et7i3QWpq21Oz1A3CA9TdZAJdvk6b0YH/eQrJ4ry
	 76g3fT1D0RanKQQ2tfIAh+NLAStV9fuuT0RQlHHpVjEU/+susQzQvzawMUUla2YFYO
	 uzMlD9eixuvMB9lisarPRH56D+8dTqDrUBnrovHpTtWcOeQBmBIodjlYXeppYEkMb9
	 RYnhFZH4tMhZyALRaHQGHbsZ1rholEziZd9nBoRuYFwVbMbgwT/ra0KWi3YoftMVay
	 SVdiknUf7cS5bATR5bNHbMLl3vEMtzowNBoRyIWh9AhF4KWITiSPGjEwEmAx+uvv8g
	 oXY6h/uEKH/Q7XulouwKWr7bDptKfzDXyTk7sh9wpO7ZmnbRYeSfeYpsADmT9sTBeU
	 72Zc3omlC3lk3Ur/Yb6MmGXJ/HbQ5usI3G1ZlTTDz0dYTD+MJXASIncT1YqH34H7Ek
	 e8646uZrpAljGuoT2mV+Dbswn+xoRtp0iyYI4Bz6ys8SB2fu6DA0j98W7jZAYJXxqN
	 gHpdhF9GkAbK+vmoP+IwXIFk=
Received: from zn.tnic (p200300Ea971F93C5329C23FFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:93c5:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 50FA340E015F;
	Thu,  5 Dec 2024 18:06:09 +0000 (UTC)
Date: Thu, 5 Dec 2024 19:06:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com, jmattson@google.com, Xin Li <xin@zytor.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 12/15] KVM: x86: Track possible passthrough MSRs in
 kvm_x86_ops
Message-ID: <20241205180608.GCZ1HrkLq2NQfpNoy-@fat_crate.local>
References: <20241127201929.4005605-1-aaronlewis@google.com>
 <20241127201929.4005605-13-aaronlewis@google.com>
 <Z0eV4puJ39N8wOf9@google.com>
 <20241128164624.GDZ0ieYPnoB4u39rBT@fat_crate.local>
 <Z09gVXxfj5YedL7V@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z09gVXxfj5YedL7V@google.com>

On Tue, Dec 03, 2024 at 11:47:33AM -0800, Sean Christopherson wrote:
> It applies cleanly on my tree (github.com/kvm-x86/linux.git next)

Could it be that you changed things in the meantime?

(Very similar result on Paolo's next branch.)

$ git log -1
commit c55f6b8a2441b20ef12e4b35d4888a22299ddc90 (HEAD -> refs/heads/kvm-next, tag: refs/tags/kvm-x86-next-2024.11.04, refs/remotes/kvm-x86/next)
Merge: f29af315c943 bc17fccb37c8
Author: Sean Christopherson <seanjc@google.com>
Date:   Tue Nov 5 05:13:01 2024 +0000

    Merge branch 'vmx'
    
    * vmx:
      KVM: VMX: Remove the unused variable "gpa" in __invept()


$ patch -p1 --dry-run -i /tmp/0001-tmp.patch 
checking file arch/x86/include/asm/kvm-x86-ops.h
checking file arch/x86/include/asm/kvm_host.h
Hunk #1 succeeded at 1817 (offset -2 lines).
checking file arch/x86/kvm/lapic.h
checking file arch/x86/kvm/svm/svm.c
Reversed (or previously applied) patch detected!  Assume -R? [n] n
Apply anyway? [n] y
Hunk #1 FAILED at 79.
Hunk #2 FAILED at 756.
Hunk #3 FAILED at 831.
Hunk #4 FAILED at 870.
Hunk #5 FAILED at 907.
Hunk #6 succeeded at 894 with fuzz 1 (offset -30 lines).
Hunk #7 FAILED at 1002.
Hunk #8 FAILED at 1020.
Hunk #9 FAILED at 1103.
Hunk #10 FAILED at 1121.
Hunk #11 FAILED at 1309.
Hunk #12 FAILED at 1330.
Hunk #13 FAILED at 1456.
Hunk #14 succeeded at 1455 (offset -35 lines).
Hunk #15 succeeded at 1479 (offset -35 lines).
Hunk #16 FAILED at 1555.
Hunk #17 succeeded at 3220 (offset -40 lines).
Hunk #18 FAILED at 4531.
Hunk #19 succeeded at 5194 (offset -38 lines).
Hunk #20 succeeded at 5352 (offset -38 lines).
14 out of 20 hunks FAILED
checking file arch/x86/kvm/svm/svm.h
checking file arch/x86/kvm/vmx/main.c
checking file arch/x86/kvm/vmx/vmx.c
Hunk #2 succeeded at 642 (offset -2 lines).
Hunk #3 FAILED at 3943.
Hunk #4 FAILED at 3985.
Hunk #5 succeeded at 4086 (offset -1 lines).
Hunk #6 succeeded at 7532 (offset 6 lines).
Hunk #7 succeeded at 7812 (offset 6 lines).
Hunk #8 succeeded at 7827 (offset 6 lines).
2 out of 8 hunks FAILED
checking file arch/x86/kvm/vmx/vmx.h
checking file arch/x86/kvm/vmx/x86_ops.h
checking file arch/x86/kvm/x86.c
Hunk #1 succeeded at 10837 (offset -3 lines).

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

