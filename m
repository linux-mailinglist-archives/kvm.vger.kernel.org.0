Return-Path: <kvm+bounces-43250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEBEA885DB
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 16:54:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 433701769EE
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 14:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE37627FD70;
	Mon, 14 Apr 2025 14:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjtG/CAn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FA4427584E
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744641841; cv=none; b=BYGSNQMcO63ehW3nIzr6SeVREBdM0UOyJC0QlXgUz4LHZMzHHd9eo9Y5lMFuZsRUuVdCJK8C9Ah5+7m+hhBVobcA08pvXo7QG1zEcIcxj8n3u47od/0dZx6vQQPdq/zUKccnrCnp7IPGFi1sgwEMTr3xFyrJJenIlXb19JlSRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744641841; c=relaxed/simple;
	bh=uMNdskFvWxs/ZeJV24VQb2bK2kwD4jcq/9MRREdZl7I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XtHms7iChjHyJM9tzpI3bO9JdWTaix0mBhjvM87OTPyv8661ckdZ2v7TC+b8xpg5s0t8hsXSj2vtsZWcfOj9rMlH15kOkXQmcpczU27St+DBi4zHm8MEH98RrqpFUoTQmyQ5PYwsCyB0Npb69usf8SRCzJb+3P9sZ+aj+ufFNiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjtG/CAn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744641838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kjqVtifpWkKj0b4Ug0nm9RhQbFWSBSXQpQ4bYLNf9BA=;
	b=IjtG/CAnQJAXusTwOhQS+xBO01DqJFMNSYLQ6FSgESfrn+fQymVqgR9OfIjg9IS62ubTzX
	/Y7MqD+/54KJVOMhLx1LII6Hfn2hh7CN2KbIVFPnQcDv7V7EMyFiEVfG5PQR2ks2Clw1Iz
	t6HKiccuREkJGabakRSJDJ9ByTt7WKE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-7b8nn3xhMnS9ULKMMP5nrg-1; Mon, 14 Apr 2025 10:43:56 -0400
X-MC-Unique: 7b8nn3xhMnS9ULKMMP5nrg-1
X-Mimecast-MFC-AGG-ID: 7b8nn3xhMnS9ULKMMP5nrg_1744641836
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e91d8a7183so79449696d6.0
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 07:43:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744641836; x=1745246636;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kjqVtifpWkKj0b4Ug0nm9RhQbFWSBSXQpQ4bYLNf9BA=;
        b=AXzciK5UIDyVGXbncYrQgXdiEO3KfZpNb4P09cs6TtLPyG//2RMKpuGMHrznx2y9uu
         aGUcCDXuHcD2y4SshphBLamiwWAk79a6eb4C/Lc4bSOLiQoXuTVF1XASqbEOFNTb+JQ4
         3/878M8PbNFpumTSUKOCFKvVXNUiu0sFqIRUaANl+h16SnpP5kO2vlaOplSctiB1viJY
         HyVGYTBboUpIjoK74kqCyD3/KjP8IhFtCN1bF6d753YBoLReAnnGLZreQ1+0prV9phRR
         8YT0/9eyc2lgwq/OW+ULcCUZm/vWvny9vbLr+RTz7ZDb7jvjDWopHyRJpx2WwGLD0oNi
         XlXg==
X-Forwarded-Encrypted: i=1; AJvYcCWvlZgfU/2SKtjyeAo0eFnYn80rvALFr7ATYwYQaRqluAHABQnoRPp/4yyvAMiefIAg9Mg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZvgmExq+J20z/2oMw5viMCMdjaC9nAEORG6KQDQ1/Svg2PQTg
	YSjwlsvDBTPQ8n6NMn/dx65zum9v5xjccwWzyuIi7Cun+oONEBHqPdd2YOyxlEz//lYAnLh2+Z3
	qOI9TpQ/C3PBTrHKOB5HNAzOOBswr83kSTEsz8gcg4dJnOGPjIg==
X-Gm-Gg: ASbGncuIfB3PRGatPPgS3wgB7u+4FkFShNwOUsbeoKPDjaKLM/yQH7AU8i/xsfoOiui
	s6eBub94PZlGBPec0Xgjqa4h6ztKtV8XyxRJ7g6RZnoarsD8DYnTWG+J69i3/xtCDrlMz/oHr16
	V2Lgb9qdejIB6gH2TgIdYlr6V8EYly25Ui4bnuT1AIyYi1uCW3U4yRDSj3Qn8qk1BISpFkDofC1
	uISV8rry6fEYuRck7OipmkutDXYrevQdHBOrca8ospG547eahNFXe2Mw8IN+H2/Fal/K94FQOs6
	zg+4oAkDXbk=
X-Received: by 2002:a05:6214:501d:b0:6d8:ada3:26c9 with SMTP id 6a1803df08f44-6f230d7ad92mr185320646d6.10.1744641836158;
        Mon, 14 Apr 2025 07:43:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGel5tH1Eww8AUnNw43KwiocL2hPNlXM4/YDX3le/rvzrhbUb9fxhhQvoE2YODqL1n6WcfW1g==
X-Received: by 2002:a05:6214:501d:b0:6d8:ada3:26c9 with SMTP id 6a1803df08f44-6f230d7ad92mr185320156d6.10.1744641835603;
        Mon, 14 Apr 2025 07:43:55 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f0de970badsm84997516d6.26.2025.04.14.07.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 07:43:55 -0700 (PDT)
Message-ID: <6af77fa765ecee9cf1368d0715b65a383d67bc7e.camel@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sandipan Das <sandipan.das@amd.com>, Sean Christopherson
 <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com,
 whanos@sergal.fun,  nikunj.dadhania@amd.com
Date: Mon, 14 Apr 2025 10:43:54 -0400
In-Reply-To: <3bb22f41-9218-47c1-8a0f-c484bdaeb9eb@amd.com>
References: <20250227222411.3490595-1-seanjc@google.com>
	 <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
	 <Z_WmdAZ9E2dxHpBE@google.com>
	 <3bb22f41-9218-47c1-8a0f-c484bdaeb9eb@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2025-04-14 at 12:02 +0530, Sandipan Das wrote:
> On 4/9/2025 4:13 AM, Sean Christopherson wrote:
> > On Tue, Apr 01, 2025, Maxim Levitsky wrote:
> > > On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
> > > > Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> > > > DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> > > > context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> > > > just supported, but fully enabled).
> > > > 
> > > > The bug has gone unnoticed because until recently, the only bits that
> > > > KVM would leave set were things like BTF, which are guest visible but
> > > > won't cause functional problems unless guest software is being especially
> > > > particular about #DBs.
> > > > 
> > > > The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> > > > as the resulting #DBs due to split-lock accesses in guest userspace (lol
> > > > Steam) get reflected into the guest by KVM.
> > > > 
> > > > Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> > > > likely the behavior that SVM guests have gotten the vast, vast majority of
> > > > the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> > > > option for a fix, e.g. versus trying to add proper BTF virtualization on the
> > > > fly.
> > > > 
> > > > v3:
> > > >  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
> > > >  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
> > > >    it's guaranteed to be '0' in this scenario). [Ravi]
> > > > 
> > > > v2:
> > > >  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
> > > >  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
> > > >    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
> > > >  - Collect a review. [Xiaoyao]
> > > >  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> > > > 
> > > > v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> > > > 
> > > 
> > > Hi,
> > > 
> > > Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
> > > (if I am not mistaken of course).
> > > 
> > > We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
> > > set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
> > > (If I read the code correctly, I didn't verify this in runtime)
> > 
> > Ugh, SMM.  Yeah, KVM doesn't propagate DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> > value.  KVM intercepts reads and writes to DEBUGCTL, so it should be easy enough
> > to shove the bit in on writes, and drop it on reads.
> > 
> > > This means that the host #SMIs will interfere with the guest PMU.  In
> > > particular this causes the 'pmu' kvm-unit-test to fail, which is something
> > > that our CI caught.
> > > 
> > > I think that kvm should just set this bit, or even better, use the host value
> > > of this bit, and hide it from the guest, because the guest shouldn't know
> > > about host's smm, and we AFAIK don't really support freezing perfmon when the
> > > guest enters its own emulated SMM.
> > 
> > Agreed.  Easy thing is to use the host's value, so that KVM doesn't need to check
> > for its existence.  I can't think of anything that would go sideways by freezing
> > perfmon if the host happens to take an SMI.
> > 
> > > What do you think? I'll post patches if you think that this is a good idea.
> > > (A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)
> > > 
> > > I also need to check if AMD also has this feature, or if this is Intel specific.
> > 
> > Intel only.  I assume/think/hope AMD's Host/Guest Only field in the event selector
> > effectively hides SMM from the guest.
> 
> Just using the GuestOnly bit does not hide SMM activity from guests. SMIs are
> generally intercepted (kvm_amd.intercept_smi defaults to true)

Hi,

Actually this setting doesn't really work these days, at lesat not on my Zen2 machine (3070x).

Long ago I tested it, and despite loading the system with SMIs either via APIC or via 0xB2 ioport write, 
where in both cases I noticed significant slowdown of a VM, pinned on the receiving CPU I got no SMI VM exits.

BIOS likely has an option to override this setting. 

I guess the reason is security, because with SVM,
one can effectively block the SMIs from being processed on the host.

Best regards,
	Maxim Levitsky


>  and handled in the
> host context. So guest PMCs are isolated by a combination of having the GuestOnly
> bit set and the #VMEXITs resulting from SMI interception.
> 



