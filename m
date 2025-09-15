Return-Path: <kvm+bounces-57599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B42B582A5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 19:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 020143B2701
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 17:00:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E916F2773F2;
	Mon, 15 Sep 2025 17:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="umzzBUFA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AA11805A
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757955645; cv=none; b=ds8Q9Uy2duV4F8o2P2VJVhU4Nw3KS1J2pl9KXmOEYemo+BkXB4tv7wXMNvYudlwqhlJTaOX1nDhM3HOLiDQZuKe5kSAhbkFKZL4KyRw10Ae2sCliP1bZq/4OdNLglsq/R4E7hEbHe18dqdUI2hpyQcsZWf5Vrolwpo0Dbou4DVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757955645; c=relaxed/simple;
	bh=8PxneQeOv/lA5FM5mKO84O7CcXV29XKqLv5rWJEZVB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IckVVPl8sIPNqDSHfqkuemtqY7vdKzrYh5JLczZPTt3vM5zzb5kjtWwxkMe2HvbDZ2gjesf758ATkMJiH5vbEBvvVKZGao+XYcW+SFPATE0EIVrUIEvc1Ve71avOunIMnq4ksB9bs2EkISibNz2Q5jDltig65WzFLyYqXe/tk1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=umzzBUFA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e0b001505so1970281a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 10:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757955643; x=1758560443; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wxFVtxN3tgRer9OorGw1rSwesdEyfhvsd/NDtysxL1g=;
        b=umzzBUFATfoU1BcPunD5siGNY5X512hye5bnuUq7kW/KvwkE5KZQqMfNKE1cXx5ABA
         Ve4vLVnzUu3mXcfQ3GIcSWjPuU0Da2oJ2TTePFq5o5mz3RWxeqQzyIOuc5TeaxLEuY6c
         FYXl/yxO1++pgJG7+0wmwDgtzEZDQc6YvwshUYOL02e68oSXmNi/FEhmOz0Is/H0NzaP
         zGBYHvmIeFr7+VtWExRjW6/Zf8O8s2NfMMM3VZ9g+8v/BHPcNEEhwIvRWFIjViQgcnnI
         NENv/Ji9TozHijt29UNfRbeuReJvBm33CPA8sPxg7cIWQgeOdg/2dnMZjLCvkKLufPmC
         E7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757955643; x=1758560443;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wxFVtxN3tgRer9OorGw1rSwesdEyfhvsd/NDtysxL1g=;
        b=Rq5CPGH+wRgMYsQIsBKTgN2E+gtm6j6HnFZokKCcXTJMkQJby8rCVDe0UBxG7Z4eZJ
         OqUooQ9gcMtEk6X94gsCoPY8No2OcHxU/k1pt5tOfmx9uj/+lYR3AdI5Kvw+tTsE12w5
         EZnDkRfSZ4rQXkdQauE179FzY2FOAIjnbH6Eo3bNUi5LhN2lDt7qnIros5dke8LU4zl3
         Fqk3R2sc+UNgbOw0oFa4IHk5xrxbuxsOz5cMHMPdcTqjjNSbiip7pfS3eRgetP8iSQcH
         UHjcIcPpRU8rXlErUCT3mRiY4Gvi7Y3V+qUmS1/cmJhlTsEX0UCS6h10KeqhlPuU/cFs
         ZNFA==
X-Forwarded-Encrypted: i=1; AJvYcCXaR4+RWF282DWexTkW4OWgBqd6Ewk9fiijdtJ1X+NhrIZjBrGQUwQbBnUPGAWiyjeTFHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe8vBJbEB5h/jdQq6YOSHxiUhr9L59N4Sp4exKWnyJStwlXYNO
	ZIpHYdLjIyoEBdENb66ys2vtF4j0CPUHyKAS2KkFLeP4VXirwP8WDUfHK0cnTu/I84wLfdthHUj
	RfWlWcA==
X-Google-Smtp-Source: AGHT+IEBh2YE0i6AygzJ4eZnRmYv6+ppmyhOgn0HXl7KSONyNYepQesQNZVPyUFZ+8BI91okOls8ZC7vyBI=
X-Received: from pjl12.prod.google.com ([2002:a17:90b:2f8c:b0:32e:38f5:e86a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:554f:b0:32e:38b0:1600
 with SMTP id 98e67ed59e1d1-32e38b028ddmr6647879a91.6.1757955643085; Mon, 15
 Sep 2025 10:00:43 -0700 (PDT)
Date: Mon, 15 Sep 2025 10:00:41 -0700
In-Reply-To: <aMfM4Fu+Q6gpZKYF@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-36-seanjc@google.com>
 <aMfM4Fu+Q6gpZKYF@intel.com>
Message-ID: <aMhGOVFg2PvhqHhj@google.com>
Subject: Re: [PATCH v15 35/41] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Chao Gao wrote:
> >+static void __vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
> >+{
> >+	int i;
> >+
> >+	for (i = 0; i < NR_VCPUS; i++)
> >+		do_vcpu_run(vcpus[i]);
> >+}
> >+
> >+static void vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
> >+{
> >+	__vcpus_run(vcpus, NR_VCPUS);
> >+	__vcpus_run(vcpus, NR_VCPUS);
> 
> ...
> 
> >+	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
> >+		sync_global_to_guest(vm, idx);
> >+
> >+		vcpus_run(vcpus, NR_VCPUS);
> >+		vcpus_run(vcpus, NR_VCPUS);
> 
> We enter each vCPU 4 times for each MSR here. If I count correctly, only two of
> them are needed as the guest code syncs with the host twice for each MSR (one in
> guest_test_{un,}supported_msr(), the other at the end of guest_main()).

I'm 99% certain you're correct and that the second run is unnecessary.  I suspect
this is leftover crud from an earlier incarnation of the test that used a separate
VM for the "unsupported" features case (before I realized that the test could
abuse and test the fact that KVM doesn't require homogeneous vCPU models).

I'll triple check and post a fixup.

Thanks!

