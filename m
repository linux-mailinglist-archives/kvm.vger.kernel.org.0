Return-Path: <kvm+bounces-68314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 631BAD32ECD
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73535309AB33
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:46:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F6634DCE6;
	Fri, 16 Jan 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pgrIhbVa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77651E0E08
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768574774; cv=none; b=rHuqucAxIZoWWZJpoEoNO9lIlqBraQpG6UcAPKGPQxpCbuDreCZWxYo5FTF41JOjJvVSLaYqCi8UIN8ElFmBwoaTjeTZ3sMCUzHg0bwX9TJiYweeArG4NLAJR+7G4MqVZVirT/x5evuM+AG70s38Zk0TPmgFO/aacB86y1oVpRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768574774; c=relaxed/simple;
	bh=TpgD5o/rLSTnGKWbI1TKlJ9lRE0JbsCZdsQLvgDlqdo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B4u3FWwZ2SiYcM3VmQuYwhZKELqmTkTtolA+MRvn7OCu/kj0Ei+HkqRnOG1cOjDJ/C1kQaift+GLAucsEzwRmWkXZQrkS82Bh5ad0mHlQQXBx6HleyLKyIMJhY54lRe9P/pxAMNzJu5eBIq5WGG5uYdRaL3FNqRxvei71aYgsQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pgrIhbVa; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so31035755ad.0
        for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 06:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768574772; x=1769179572; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJUGAI6D133JtMaCHh9/YqYn6+JI2o0s1rll4X2ixAw=;
        b=pgrIhbVahUc93I11CflCoJsIJVA3lwI+ic+P+mHwatGu4MHqhUN7+zgU9kodhfhJ/l
         f5IK8Ru2kPLlE0iJn+e7aIksk6PXvI6MiIm0WVjW8C6yYdqg/+ys5T70Xcg72r+CoFBF
         oHLDeLTARfFI5l2Lf4U2J9ZPap8gZV8Xfi/Va17i5JNnDTZ0DxM5gLrdGh+cGK1nJyLm
         Y/idaqKusCGVQIhc8JuNI9W5Agjv3FHjOrdQmwhsBJpPZv1MpjEKTH3UBf4uCQGWizl7
         MpvAqzA6Cu8VeFufaoR/S5rQ8WfuqzE/FkqFrgOoZpdB13k7euWT7JcEeL0Fv4PkXZyQ
         l/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768574772; x=1769179572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJUGAI6D133JtMaCHh9/YqYn6+JI2o0s1rll4X2ixAw=;
        b=doGrOGcHAKehcxE7q0JwSHxbCLFB8I3eIS2sCDl9mnh/1TpyCpTHVLd2Jo1usBRBdj
         e7uyj9E0zzVIyPS2TFOr+UW/sNEiAmG0hp7veoKK19F1GbdXNS3cZjzXLHSOQHoGOv1F
         7z+UUz3XZtMRiUzgE+r/XtNRmhpZGeudoIxTkh2Lm3qdMbkmCHUlj27Kr/31jWenpg36
         Bh7VPBmNVlo62Re/v/td430yzzvbzmpaF0NTnaNMVUzEfz9rykcEwywEs1fbtp5ZO3FB
         tz7zlpfHB/wxBKRbhow15/nGNKWomYX5wQcPLpm1Tp22SSADMmJnud55XuQfEdZzaeDs
         tObw==
X-Forwarded-Encrypted: i=1; AJvYcCUZWBvypzOx2i85sD4e9YAKOyYLf6i3ZyJOEH7fsH4ivJZrQtWhyXcPyc97lAVlZTc41Ek=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNuY5oOdA/4qpG357cqLZAFf6fcVH2IyTmraWY9SzQhwEMay5Y
	dy2FjyPIXyckCUtMrWyoW5eFWhJ08jW7bI+bwqMLAG6NJoJsLbB/2ce2CqQnapEhzNs1h65k8Im
	JYoRmew==
X-Received: from plbkm5.prod.google.com ([2002:a17:903:27c5:b0:2a1:36d4:7f2f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db07:b0:295:134:9ae5
 with SMTP id d9443c01a7336-2a71780af6emr30716925ad.24.1768574772027; Fri, 16
 Jan 2026 06:46:12 -0800 (PST)
Date: Fri, 16 Jan 2026 06:46:09 -0800
In-Reply-To: <aWogMveOU4YEpQ4q@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260106101646.24809-1-yan.y.zhao@intel.com> <aWmGHLVJlKCUwV1t@google.com>
 <aWogMveOU4YEpQ4q@yzhao56-desk.sh.intel.com>
Message-ID: <aWpPMUT4_79QjaF8@google.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	x86@kernel.org, rick.p.edgecombe@intel.com, dave.hansen@intel.com, 
	kas@kernel.org, tabba@google.com, ackerleytng@google.com, 
	michael.roth@amd.com, david@kernel.org, vannapurve@google.com, 
	sagis@google.com, vbabka@suse.cz, thomas.lendacky@amd.com, 
	nik.borisov@suse.com, pgonda@google.com, fan.du@intel.com, jun.miao@intel.com, 
	francescolavra.fl@gmail.com, jgross@suse.com, ira.weiny@intel.com, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, kai.huang@intel.com, 
	binbin.wu@linux.intel.com, chao.p.peng@intel.com, chao.gao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 16, 2026, Yan Zhao wrote:
> On Thu, Jan 15, 2026 at 04:28:12PM -0800, Sean Christopherson wrote:
> > On Tue, Jan 06, 2026, Yan Zhao wrote:
> > > This is v3 of the TDX huge page series. The full stack is available at [4].
> > 
> > Nope, that's different code.
> I double-checked. It's the correct code.
> See https://github.com/intel-staging/tdx/commits/huge_page_v3.

Argh, and I even double-checked before complaining, but apparently I screwed up
twice.  On triple-checking, I do see the same code as the patches.  *sigh*

Sorry.

