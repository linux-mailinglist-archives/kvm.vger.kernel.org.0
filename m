Return-Path: <kvm+bounces-53527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1C7B1354F
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 09:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76FAB173C1D
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 07:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90062223335;
	Mon, 28 Jul 2025 07:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijItCgtA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3862722154D
	for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 07:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753686344; cv=none; b=kg6RZFR4jE5N/t/EpeJ817J46FJqagYRpeTmxS1wtWhNRRQ9UP26mYewo9QN1MMUq/RiggWCdKLIwuk62SWpMDUM6vtN5X69lYGBwruSSzjQ+R8q3CBIep5bzpiXcVElx8cJXw88OgEyJHz4IC13+E5XPGU6j9LTX+HnYQlr9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753686344; c=relaxed/simple;
	bh=kQwpUu3pdIcVVkEM6j2jRU78dQ5txh+ni/j6a59ryYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3V4rsslHaLPTDUu1rSg0cc0G5E46IDOfrPwL5jkk1ita72HxqdWwgzPHeyT+j0IQSvlX7OiaRbrPNNOybfVZkV+t9F/5EJVSLByHXCXSYS1f7IkV8pcSvOZXU+B2MgrVNvepL3mxqk+nHeKTRa1O6vfposiix16c9XLPH7XV0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ijItCgtA; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-553aa258aecso7293e87.0
        for <kvm@vger.kernel.org>; Mon, 28 Jul 2025 00:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753686341; x=1754291141; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=ijItCgtAXOr/Sn1hwkyD8P+i0hXjQoCMDPDzDdbbgvoOJrLsXL0yF8d69MDjgp6Bt8
         dj/h0ORS2K8JEa5X3cOlIoRla+QROz5BEfWqHHWFMe++7tBhpcAQU3YBS9EHxgX9Dhb1
         Cr9HYYz5RQ38mDvYUs93AKyKcxuvFcMy0WkoxCAl+aVUv8X1SKbLnpkS0MuWQFPZVjk6
         Lm+WuPJ3YN2Lgz2Ntco+ooWj4AFlY1hNepZK00VZDdNYMw9So45M9MoxTDoo2PpnrGGH
         4dq7XIWsWOgdyBKYLDSY9AzY6lThlUBRpQXycWst1ejCZhEprt5b0Abvo5dpvYXkrhSH
         S1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753686341; x=1754291141;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ABzFGAudwjHSpGmDKnmCejI++sq8wZtuTDnQk4QEthU=;
        b=kqXraBT79KLEqIYmzlcWNlY1TmQ8WWyQW5Z5CEY6s+oYY9rpcT2OnHS4NJ67xC/Lr0
         ThZAy2ns5EgSm2yT0FQRn8n+sv1RIAbvfCF6tX3iZOOKl2X5BKQpu0R7VDC3qD3rAjI6
         3PHkzcfiSxtroSX37g8bcsV9oJ25p8lsg3JxxC5NNgARcFIXC2pZwD5r00S8RbTBr0zK
         zOnrTqI19G86bv1xe5na1Q97AARriTT1ECuB934pNxHwchp2YXwW4W9uMjY+oGRjSiLw
         qJSCz5bq8lK7tdIFhneYLWOt6Loy69dRYa0UPV65ZpHKegmxB9l0NQ7ZU5FXkMaCVjeq
         ah2A==
X-Forwarded-Encrypted: i=1; AJvYcCVAYCgrsxd6GMfsHuHIs8zAz3qVBrUW7+fhflvnPjzNAYN0oLNSeZ0/uvUplQ9cSkT39TU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfNWIXm16J/YzT36l2+o+Y/n3hXgWjourx8Ho/C3kBV4og4Mnw
	SxeumbmY+BGsjvkIMZvxw0DVYmnpq6P1kLykPdxwL1m5m66+WLRjW0AZYWPV5xl+NNClSi8O9OK
	ojvf7vwlxi5KV9ppb/5iGL+v8KI1ViJB4kGrOqzhp
X-Gm-Gg: ASbGncvKgrB+ZlyUMsjMAIeAcrHPLb2Am3S/thLYYnlmEChb/z0rxkt7wSe+LcvAUuP
	zYyEGDixx7YXb1E0AigF+23Calv2dtSNAajEt/Cg+s4PAeurlZuYHq/vrJqehNBB66auVgIS7pK
	1vy+PNwmwsQs0q0TSLnl2pqXIhyINPBhmaWDMWvgrwyPsf3ZrNUEN3K9vbPLRNYZy+O1VlDPG4w
	GaZjGBBZZNgG7iCpw==
X-Google-Smtp-Source: AGHT+IH+nhG03vhszpw4SpGxLBcsItXrblXPXI/Z3jowcjOUQPpqAObstdzHVPgpSKZxUwqvLJJMux8lmEFM7MWk230=
X-Received: by 2002:a05:6512:2117:b0:55b:5e22:dfb2 with SMTP id
 2adb3069b0e04-55b63a96040mr246280e87.0.1753686340942; Mon, 28 Jul 2025
 00:05:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com> <diqz4iv1dudx.fsf@ackerleytng-ctop.c.googlers.com>
 <aIObJH439LQWjnqq@google.com>
In-Reply-To: <aIObJH439LQWjnqq@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 28 Jul 2025 08:05:01 +0100
X-Gm-Features: Ac12FXyVGBddx8pm5Wrn9wDW0AE2GoOgT_q7kkPWz9XW40HNA-igFWzzFSoA1tE
Message-ID: <CA+EHjTyhSU0WiAc7GhwrdZjoUe0w5Uk-gGxd_AD6SRmezYNROQ@mail.gmail.com>
Subject: Re: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

On Fri, 25 Jul 2025 at 15:56, Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Jul 24, 2025, Ackerley Tng wrote:
> > Fuad Tabba <tabba@google.com> writes:
> >
> > [snip]
> >
> > Did the patch [1] for x86/mmu that actually allows faulting when
> > kvm_memslot_is_gmem_only() get dropped by accident?
>
> Ah shoot, it did get dropped.  I have a feeling Fuad read "drop the helper" as
> "drop the patch" :-)
>
> Faud, given the growing list of x86-specific goofs, any objection to me sending
> v17?  I'd also like to tack on a selftest patch to verify that KVM can actually
> fault-in non-private memory via a guest_memfd fd.

Whatever you prefer. No objection from me for you sending out a v17.

Thanks!
/fuad

