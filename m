Return-Path: <kvm+bounces-65378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF06CA8CD6
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 19:32:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 10936315D8A9
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 18:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF8E342511;
	Fri,  5 Dec 2025 18:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BcjtHmvr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3289C257435
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 18:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764959281; cv=none; b=kio7oFmY12KC/EGRxofc6uKhCahtsYO4XAZKFOMJaixW6m5elFEKD0MMLZFM7+bjqLlh9Ip6mThVSxUqj4wz3sWI+HPkixLEul7e427+13dn9Hywb6WfPIZ5G4Gj1EQSF7+tJ/G18SitclqXMoeB2zJwa8HyMCY3o7MD5inMIJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764959281; c=relaxed/simple;
	bh=DnVI7DhZdcq11uuulyz1U4nW2pWbeNIWrCYrcbpan+g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=igokKT9Ii4SZmomFATf5BoQ2uWrXqURgyUT7rU4KCdCOmvQPiioATK+EF4+3uGRpyoFYbRC1X7H7UBhPUgWsznUPdqzBP/PHt2ZKDfjwyiiUBZnVMJRx897opTsFA678agN0QaYLTSzdjO5z1/9VbodPTUsD5GUM2M5dUGg8GwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BcjtHmvr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bc4ef67fso2753893a91.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 10:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764959279; x=1765564079; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7snApl4b9rZr+hFDiStuSOtel4ebSlHz2B6IoQxbkT4=;
        b=BcjtHmvrQosEYVxCjrSORU3ZEvxeQbr5ZsyDJ59pUPUNTdiaF+u5HRMPCX4wUzn5S3
         p3wK9BJz3glIsmeLv2qrUfSL69HM3GbpPdXzb/AYzZkPzMSMCX/L1N2NPrk6Qr+sjqhY
         zH+BFAuLobKKxjFfEhzjtES3nefrK4J5ix2JW8yH4glGyMOJbMDCQlxnbhw+V+Gemfj7
         IBrnRkdF2jgUcovhj/gLTm6WCasY098Bzl/Z8rFnmUymkyXzzLPTUXxOlnMhATz38+ns
         oXnqc4X+PXPZPCqoTUxGbVChLIiNyitS7AhZHnaLeQxboCjKaoP+gOtqW7siCf2Z2ogE
         0Uig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959279; x=1765564079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7snApl4b9rZr+hFDiStuSOtel4ebSlHz2B6IoQxbkT4=;
        b=vAHmuC5c18whGtJ0FM73DsMAKEP+w/sTmzIogvXkjCNGsM65GizXlRxlFOCwFIRd0Z
         0HX53JwePzHKaumOGDN2IhfL8rm0xQlHO7BYHHapTRzLz7U7GX2g7ym5cUnI9M3Blo+y
         +cVu4Zzz+1EkW7/QcqyHBHu29JVlWtPLlTTh8xNf0pZ0IKeU7yDFQIg9hlL1gZHSPXhO
         rRg6C6lLxqKIDnP2YrLmqF8UynvWZiE/wAXy2eyX6JFcrr8XYaEMHeMxZlWJ2HMAnvRk
         OsDmSypVBmlCPV7Ufg45qhGw61in4wn5+hEgKdbzcbENS0XY2lwMHfBdg5l9Da0ZbFRP
         li3Q==
X-Gm-Message-State: AOJu0Ywmu1CfZ1MbnyQmZ1hZYrDTiC2OGxhLk0xdb5UFVtbCEajA7aFo
	TUZeA9EFzO4OGKoN9PSyIGjykzzuRbtVWSiZ2xkC0zn+gsous56ny+/FfAsJ7XEEaOSebPJUMKK
	GraMUIA==
X-Google-Smtp-Source: AGHT+IFGg9fLLRWBimoWcnU6Z3Ll6wJmyiuH3avDXa5xiHQ/2NjphiH7uOFLRwRcK2cvFBWB7ZNAmOD2o+4=
X-Received: from pgbfm13.prod.google.com ([2002:a05:6a02:498d:b0:bc1:88dc:1946])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:729b:b0:35d:d477:a7e7
 with SMTP id adf61e73a8af0-36617e6f074mr225591637.22.1764959279389; Fri, 05
 Dec 2025 10:27:59 -0800 (PST)
Date: Fri, 5 Dec 2025 10:27:57 -0800
In-Reply-To: <2b0de566-0602-4a9e-9c5c-b947617f684f@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
 <aRScMffMkpsdi5vs@google.com> <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
 <aRZKEC4n9hpLVCRp@google.com> <a3d1407c-86d6-46d4-ae96-b40d7b26eb34@oracle.com>
 <aTJAVx7C3vuPDgkm@google.com> <2b0de566-0602-4a9e-9c5c-b947617f684f@oracle.com>
Message-ID: <aTMkLVAwwocNvRae@google.com>
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv activation
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, joe.jin@oracle.com, 
	alejandro.j.jimenez@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 05, 2025, Dongli Zhang wrote:
> > But they're most definitely NOT stable material.  So my plan is to grab this
> > and the below for 6.19, and then do the cleanup for 6.20 or later.
> > 
> > Oh, almost forgot.  We can also sink the hwapic_isr_update() call into
> > kvm_apic_update_apicv() and drop kvm_apic_update_hwapic_isr() entirely, which is
> > another argument for your approach.  That's actually a really good fit, because
> > that's where KVM parses the vISR when APICv is being _disabled_.
> > 
> > I'll post a v3 with everything tomorrow (hopefully) after running the changes
> > through more normal test flow.
> 
> Looking forward for how it looks like. The only concern is if it is simple
> enough to backport to prior older kernel version, i.e. v5.15.196.

Oh, the fixes for stable/LTS are literally your patches.  The other stuff is going
on top; I've no intention of it being backported to 6.18, let alone 5.15 :-) 

