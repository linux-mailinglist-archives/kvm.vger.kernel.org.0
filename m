Return-Path: <kvm+bounces-31655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 391FD9C6344
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 22:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 675E1B81F22
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 621B2217444;
	Tue, 12 Nov 2024 18:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LH2AZ4FM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23FC2216449
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435736; cv=none; b=FjjvQEd4NsKH5ylfvSVyu5xX20hFl8zc53CKXgdH2qw7haTU3t09jl3GXzZZ2oqIGeTuuPnVjbJ/UDyqKgnsi98rgUT2NQz3iKDAQTrF+Xl9Cv2ChO1sJ0cNjH1zZAFON90G9LEMEEf52Ke45v+3qDjt3kdl1AK7iB0lCyZ4iDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435736; c=relaxed/simple;
	bh=W4QOB34iHDUpWJQ8v+WEVPSPLvxlPmgNFDX3aJtXUj4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1jPkWVN/yhsmxcwWWfcy6zzuwnLResLGcXSmpfYZYq380Z6Ou/T9MUNsQTN6SSQ55zHK1XEp2Ym+HlEw7vId0pxrzpBjkxkM77HRNq8ZhC5emEL/eMUidPqBcCjr0P62a/wkCFaWp9gsgBAy88ZavLBsuTlpPio1MuzlldsoEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LH2AZ4FM; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e2954ada861so10086763276.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 10:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731435734; x=1732040534; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MngSK2aNtfKYEgf2hNRlirtYcZGlI1I1a3Pi4HPECxM=;
        b=LH2AZ4FMN2/k5nLPCWgCG3Bw2FU14EpbKlush6bNfUd1XH5uhhTro3JmRvyOTq+wTK
         0e752UJk7fO3ib8QEnpPl0gXeQDHNESAmlwSHr1JQpMO+M7kT/zdeE2nuLFz9XV2sQPn
         zSFmq9hil9Nms7GBMC5vbD7LvlZObrFq4gm7AS93zpQxf/7TnrNZweP97lz0j117xgbD
         nV0WsiZRdH6mpn8zkMJCPozVUGaHDPDPkyiAxPU9Pz9SmG6bRfQZYQATA6+DN0SzbCGH
         I+ADo8E8P/4FwI6O6CnhyKolap0u4WxTQO9XMVJCIYatsJv1yOA89n4B+BM+U6Q1mQtM
         CWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731435734; x=1732040534;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MngSK2aNtfKYEgf2hNRlirtYcZGlI1I1a3Pi4HPECxM=;
        b=hYxrLB+pmngxOWgxiLAamXzru9xJ9oNVt2+zyNV1RpCqXXCrk37ifx0K9lSbGfGBj/
         vgcc/vFjrYqtjZRoScF37+vSc2Qhwabrsfsmw2FqMy4h+hCifHpgUGxJ2zYKN/kpofRc
         bo32xbU6c7xIeC2qqBr9gFXH+ksosxFF+ksqjgw0w9Ca5vDthEAz5RRyxqQyJOITJH3/
         ZkFGBNfrLdNof+ssOS0qwvNgaHrVmOTdIWieXW1tQnyDMvVpLrBVwXDFsgE8hIT1prwZ
         JfQkZtqG1WbG7SAKynP2O52iP34y5Xz+jVJOr2mG6xxA+6ziNVKmhWb7ftn/SVnB12Xx
         ASjg==
X-Forwarded-Encrypted: i=1; AJvYcCWYD1Y5cHWMHfKbi6cE9aH0UOMHjbP5y4rYDxZPICieXJJFZP/19jWkFMq4498BXpY/N/0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm0Ozyhzb2x/wlHd5Tac8ntbWW717qHdpixUex0ykSe/RWGGby
	4z3qgwYGGOQldKl0lZ42tYI7OcR2P62SnxJVibFmoTwRGZCONVj675zjb9c1nzIO//N/mV0Hpc5
	7Ew==
X-Google-Smtp-Source: AGHT+IGZGYSeYkhyGhIQNwjnPYziizKdLoKlqE3/c+SeZ9aQSqJrsM+xk7c/t1MtkOqq5B3Lrp0mS4FaV7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:bfc5:0:b0:e25:6701:410b with SMTP id
 3f1490d57ef6-e337f8c911dmr60115276.5.1731435734060; Tue, 12 Nov 2024 10:22:14
 -0800 (PST)
Date: Tue, 12 Nov 2024 10:22:12 -0800
In-Reply-To: <8c70586e-2513-42d4-b2cd-476caa416c16@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112065415.3974321-1-arnd@kernel.org> <ZzOY-AlBgouiIbDB@google.com>
 <8c70586e-2513-42d4-b2cd-476caa416c16@zytor.com>
Message-ID: <ZzOc1PJmM-iKqjMC@google.com>
Subject: Re: [PATCH] x86: kvm: add back X86_LOCAL_APIC dependency
From: Sean Christopherson <seanjc@google.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	kernel test robot <lkp@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 12, 2024, H. Peter Anvin wrote:
> On 11/12/24 10:05, Sean Christopherson wrote:
> > > 
> > > Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > > Question: is there actually any point in keeping KVM support for 32-bit host
> > > processors?
> > 
> > Nope.  We need _a_ 32-bit KVM build to run as a nested (L1) hypervisor for testing
> > purposes, but AFAIK there's zero need to keep 32-bit KVM up-to-date.
> 
> What do you mean here? Running an old kernel with the 32-bit KVM in a VM for
> testing the L0 hypervisor?

Yep, to validate nested NPT (NPT is AMD/SVM's stage-2 paging mechanism).  Unlike
EPT, which is completely disassociated from the host's CPU mode, NPT is tightly
coupled to the host mode and uses/supports all of the flavors of stage-1 paging,
i.e. legacy 32-bit, PSE, PAE, 4-level, and 5-level.

Because there's no architectural way to prevent L1 from using 32-bit or PAE NPT,
KVM needs to support shadowing such NPT tables.  And so to validate that KVM (L0)
correctly shadows L1's NPT tables, we need a 32-bit hypervisor to run in L1.  We
briefly considered writing dedicated tests, but the effort required is absurd,
relatively to the coverage provided.

It's quite annoying, because I highly doubt anyone actually uses 32-bit hypervisors
of any flavor, but nested NPT allows for some truly unique setups, e.g. where KVM
is using 5-level NPT to shadow legacy 3-level 32-bit page tables.  As a result,
KVM has paths are only reachable with a 32-bit L1 KVM, and at the very least we
need to ensure they aren't juicy attack vectors.

