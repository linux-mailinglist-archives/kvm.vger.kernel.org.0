Return-Path: <kvm+bounces-43034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7E64A832D3
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:53:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3C4D460907
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21612144B0;
	Wed,  9 Apr 2025 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0zjvVE7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8B214226
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 20:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231982; cv=none; b=XbE8tkWE8eGMEjDTj7hsbPDEFteZBUx1Aal3Np2uw/U7L5nsgPCTkRlS9RR2lP8ZWOZ/fJIOs/XcUlm/V3w8MoUXhcqD8uosRwecpC7HxCDcfjwZPsmckZFPlT3E2vPQKd9khR3l49qJxE3NKXSir4gqMsmsBYrYdKFAwniR5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231982; c=relaxed/simple;
	bh=JvO8apHjlhclIbQx/gRDzmFM+JJoJVlhgncErTZaOgw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SyyUwH9hJUUUgq2Z7KkfUYbqvMejQfMxN3eGBKjoCiZIOJWw89CnkBhd0gVp7ra0GKym0v1lp4C5S9+fIsYmauTavm+gG+a/fVTSJ8QjH3H+m9DCd3HFD+2keqOGlzV0UjWEnY6uvobf9VxpiCl6wxgPcLKB9oeJBPyEoOoFWN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0zjvVE7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744231978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CwwVdMIzXzZhcHVHa5dTX3xLMXj/2he6DFDzqhP+Y1s=;
	b=K0zjvVE78OzogS6tyD1h6xtR/NvcAJjBQIhHc+Wr2usCUq5kxNnb2jPQ8RWOBjEYnoe9tc
	jmnp6sr0ZUhuu2Ja0ZW2Gzxvo+9u8u8CCoXccb31mZ7PRV4SmUaE79bzUUl4I4S4+ClmBZ
	R01wzt++swSssmNlc8PkEkE5rncQfLI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-6Vil30ByMaCi5HLBlHYYbg-1; Wed, 09 Apr 2025 16:52:51 -0400
X-MC-Unique: 6Vil30ByMaCi5HLBlHYYbg-1
X-Mimecast-MFC-AGG-ID: 6Vil30ByMaCi5HLBlHYYbg_1744231971
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4766afee192so1575121cf.0
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 13:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744231971; x=1744836771;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CwwVdMIzXzZhcHVHa5dTX3xLMXj/2he6DFDzqhP+Y1s=;
        b=wXRougldKE9qs8cMyublNzYoMxMpRPk/Fcy+4Ppbdx31ODlw+N3rJtUgc/YgwvLfpM
         oeuHpDT2eQ0Ub9NiWL+rFg/QhP6/CUxMUukvRVNd0OPp2ztiz5xCFReRWGpgBxtOvQ4+
         f5Mqa8xPHFp+xrgbrBGejDX79MCjo43nrAF7awWdLojOeRDU48a4xLjLa9tYPyZQ97Iz
         WvxCRxe9WDWGT3YcWjo/rQrtY5VGHb2UJLRCrKl0cgOf4nHkZdk6ahiHI7gFxO2nTqbT
         PnWyrXbiUgWnzJ/O58p1LA0Hf8wddbOVjg8et1ThE8fGPtTt12WqYQz4iBdeGao3rihr
         mmTA==
X-Forwarded-Encrypted: i=1; AJvYcCV9Xf6D4H13HtF1ZlHZq3MBpwNHclaL9YJHWkBx/x6SnSsNNwWNNZ8qXQdl2N6Q7uFIQiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy8jBWqgIzoAXw6XWQfCZdZKy6iHkhV57XAgCabBNBYRHDVldo
	le6zJWHIgMO0GBimrPIpETrTYRHpc2bQaJtUWJe7IKDB4P69UnRdpYFGjM/CU0bqle+5mC8OKbE
	+MY5JXxnb1ttXZYSMLA5Qg7KTvC8yEtgmYm3TfVxA/J5XJ+ycHg==
X-Gm-Gg: ASbGncvriERRWgH2FnnasaCI9BAy5Aaip1dknb1uh63DFbWYzgFw8nQhqSj8oMqEn9S
	YvQQ3UBNSZ8xmdoDh4shs2ypU7ZZibj89HP1XDrAmo69YBurwH8XeKxXEEEHkaloh5VG3wUfY85
	dn4InsruBKrx0z0oVTBbOYsrbaVwSvIYJl1RCxBDsmyk5egA+7KvoftlY7hRXWGYMLxcHyFJaoN
	cYm5ujLbh8KbbGCZoBb+fTG/IuffH4fF2Yd4/Hp7l/jiN9H3WibphvXHqIHsvy21dd+ZeH5U+K8
	YtlOpyMJbPU=
X-Received: by 2002:ac8:7fcf:0:b0:476:9296:80a9 with SMTP id d75a77b69052e-4796cbc570amr4106481cf.25.1744231971157;
        Wed, 09 Apr 2025 13:52:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMbuLqvSU6RQLdoc67Ywsz5HftBP1YKDQQ3FM3W1T9eNt155wj0aVoxDILQuMOzmxl5HT0Qg==
X-Received: by 2002:ac8:7fcf:0:b0:476:9296:80a9 with SMTP id d75a77b69052e-4796cbc570amr4106271cf.25.1744231970858;
        Wed, 09 Apr 2025 13:52:50 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47964d75625sm11431951cf.14.2025.04.09.13.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 13:52:50 -0700 (PDT)
Message-ID: <ed9f56b684a95352462ddfcf10d1075494a5776a.camel@redhat.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Date: Wed, 09 Apr 2025 16:52:49 -0400
In-Reply-To: <Z_WmdAZ9E2dxHpBE@google.com>
References: <20250227222411.3490595-1-seanjc@google.com>
	 <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
	 <Z_WmdAZ9E2dxHpBE@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-04-08 at 15:43 -0700, Sean Christopherson wrote:
> On Tue, Apr 01, 2025, Maxim Levitsky wrote:
> > On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
> > > Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> > > DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> > > context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> > > just supported, but fully enabled).
> > > 
> > > The bug has gone unnoticed because until recently, the only bits that
> > > KVM would leave set were things like BTF, which are guest visible but
> > > won't cause functional problems unless guest software is being especially
> > > particular about #DBs.
> > > 
> > > The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> > > as the resulting #DBs due to split-lock accesses in guest userspace (lol
> > > Steam) get reflected into the guest by KVM.
> > > 
> > > Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> > > likely the behavior that SVM guests have gotten the vast, vast majority of
> > > the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> > > option for a fix, e.g. versus trying to add proper BTF virtualization on the
> > > fly.
> > > 
> > > v3:
> > >  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
> > >  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
> > >    it's guaranteed to be '0' in this scenario). [Ravi]
> > > 
> > > v2:
> > >  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
> > >  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
> > >    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
> > >  - Collect a review. [Xiaoyao]
> > >  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> > > 
> > > v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
> > > 
> > 
> > Hi,
> > 
> > Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
> > (if I am not mistaken of course).
> > 
> > We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
> > set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
> > (If I read the code correctly, I didn't verify this in runtime)
> 
> Ugh, SMM.  Yeah, KVM doesn't propagate DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> value.  KVM intercepts reads and writes to DEBUGCTL, so it should be easy enough
> to shove the bit in on writes, and drop it on reads.
> 
> > This means that the host #SMIs will interfere with the guest PMU.  In
> > particular this causes the 'pmu' kvm-unit-test to fail, which is something
> > that our CI caught.
> > 
> > I think that kvm should just set this bit, or even better, use the host value
> > of this bit, and hide it from the guest, because the guest shouldn't know
> > about host's smm, and we AFAIK don't really support freezing perfmon when the
> > guest enters its own emulated SMM.
> 
> Agreed.  Easy thing is to use the host's value, so that KVM doesn't need to check
> for its existence.  I can't think of anything that would go sideways by freezing
> perfmon if the host happens to take an SMI.
> 
> > What do you think? I'll post patches if you think that this is a good idea.
> > (A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)
> > 
> > I also need to check if AMD also has this feature, or if this is Intel specific.
> 
> Intel only.  I assume/think/hope AMD's Host/Guest Only field in the event selector
> effectively hides SMM from the guest.
> 

Hi,

I will post a patch soon then. I just got my hands on the CI machine where the test failed
and yes, the machine receives about 8 #SMIs per second on each core. Oh well...

BTW pmu_counters_test selftest is also affected since it counts # of retired instructions.
With #SMI getting in the way, the number of course soars.

It doesn't fail often at this rate but it does when the test test is done for sufficient
number or times or you just get lucky.


Best regards,
	Maxim Levitsky



