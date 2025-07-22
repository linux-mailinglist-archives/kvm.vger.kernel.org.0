Return-Path: <kvm+bounces-53139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC10B0DF75
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F1E0586112
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988712EB5DB;
	Tue, 22 Jul 2025 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0ON5ihzK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7227C2EB5C9
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195509; cv=none; b=Yzj/ETuwEHY7d/7Fnefj1txouK8TsAc5aVsAul+U7oNpX2cwckaEimqHJgB6/6sj7FB5dWgXalNA1QwfBAneU6cF10+K7wDx+krcUJ0QYg4feXGOWdN6lG2Duz6iFzEQz0eVOrDwaZiEJFDn0ic0Vu1622GXDf2GcNbKTm2F/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195509; c=relaxed/simple;
	bh=HVfN2TYraPSfCxVo0AJHXJQLDHAZdY3bb6bzfYt4LeA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rtjd/Rr+FH4jFCIKsUf6JBmdPwFFvOplJQJPG9ue5LYJweKFQydYqg1FpL8iAe0TctsxUfjDn0VOk7i6m6hOk0IsszK4bxEtyPMKFBO6ruYOrUODHXa8w7i3WNFmcvXZyKcfDBLNcumbqIQpsWqPzLWrLAh8sSeyyAiqUIMdZqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0ON5ihzK; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b321087b1cdso6369226a12.2
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195507; x=1753800307; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nZgPKLrP/qotO+TNh068TYlpA/4yneLkKMwvnezIBBc=;
        b=0ON5ihzKHu3w+2mvEp1zUZ1v3JNv3S9uPQlKy2+3GwmSOfJFlzYE1IsB4r9pfJAihB
         DOMhSpYLfYWb/iKrac3pyHyTdvnSZ/KF3EY9S29qoZVTiqRqJVKpWktQAAWjU/d4UaMC
         1y6s4GlF5gutBCccizeD3Ytm+5ZQ8iDUZb+NM2jN3oib52ra6KkA7QoMxFQuJn34KiNY
         SzX3v27wdfZ/ABd0i5b/mY3oTsDI1IoUAiZ8Or11TF7H8LJ24KERnQ0ktADNmar0aHCx
         WUcvB33W+xAqJ9EDtq5JVjphoI635Ezixsj+829iVEb6nUNSuEzaOu1h8fVbHZz5NSJS
         nhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195507; x=1753800307;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nZgPKLrP/qotO+TNh068TYlpA/4yneLkKMwvnezIBBc=;
        b=YuEx+6QETbOlEA1AW5XtfE0ylGKXpTA016Fn3Lq9/VzTl7a5ftv7PUzGO6JuKnKk9L
         OB/mpz4+VTbtsjfJv1wD3VarL12i6anjj+6wcySURtbxpH3hTdz9XH3uiHhEDs6aXqrP
         k89fOwAAa8ux2dPdak8B/SiF2f8E41m2nER0yZGcQONZw/bfsYt4ztKQgMn00TgkNiYw
         4H6e7XfSngdzrmAAZAXu3vdMzVgvp2ujYj1uf7XKnfgBU1YGtRuvvEb2IH44S3XvJmJN
         c9wdrRzXkRdx0+oEQZFQaSdl7J9wDAg++v1Z51bTvi6gWfCJdCNczLCFkM/THaq6RUHu
         cIUg==
X-Forwarded-Encrypted: i=1; AJvYcCVPEoMclXit9VthnRYq09BNEyIb8cZlR4ec0QMHkiyN2PRzEraSXDMS4s6RAxKgENgq+no=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCTGxgH+JSrDif4s3TYePodMK/mcnI5sqb+uePLI7kuK3jSM74
	Ln/Mty+r2a+YYajs7T2j2dkLPS9oXuBd7Jck/MXyjRgsCgq0PWLDam0gwM4o2dQerU4N+eYuheD
	uAiz84A==
X-Google-Smtp-Source: AGHT+IEye6ryF3i4GwrrW44YhrNpbw96+Sg2XleT9SYl1PadbAW/x1ROmWdG2BYhq8vejYeKBT2EUnzq5Ms=
X-Received: from pgbfm10.prod.google.com ([2002:a05:6a02:498a:b0:b2c:4fcd:fe1b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1508:b0:220:94b1:f1b8
 with SMTP id adf61e73a8af0-2380db8e8d7mr31142351637.0.1753195507419; Tue, 22
 Jul 2025 07:45:07 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:45:05 -0700
In-Reply-To: <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250713174339.13981-2-shivankg@amd.com> <bdce1a12-ab73-4de1-892b-f8e849a8ab51@redhat.com>
Message-ID: <aH-j8bOXMfOKdpHp@google.com>
Subject: Re: [PATCH V9 0/7] Add NUMA mempolicy support for KVM guest-memfd
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Shivank Garg <shivankg@amd.com>, vbabka@suse.cz, willy@infradead.org, 
	akpm@linux-foundation.org, shuah@kernel.org, pbonzini@redhat.com, 
	brauner@kernel.org, viro@zeniv.linux.org.uk, ackerleytng@google.com, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pvorel@suse.cz, 
	bfoster@redhat.com, tabba@google.com, vannapurve@google.com, 
	chao.gao@intel.com, bharata@amd.com, nikunj@amd.com, michael.day@amd.com, 
	shdhiman@amd.com, yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com, 
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com, jgg@nvidia.com, 
	kalyazin@amazon.com, peterx@redhat.com, jack@suse.cz, rppt@kernel.org, 
	hch@infradead.org, cgzones@googlemail.com, ira.weiny@intel.com, 
	rientjes@google.com, roypat@amazon.co.uk, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, kent.overstreet@linux.dev, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, chao.p.peng@intel.com, 
	amit@infradead.org, ddutile@redhat.com, dan.j.williams@intel.com, 
	ashish.kalra@amd.com, gshan@redhat.com, jgowans@amazon.com, 
	pankaj.gupta@amd.com, papaluri@amd.com, yuzhao@google.com, 
	suzuki.poulose@arm.com, quic_eberman@quicinc.com, 
	aneeshkumar.kizhakeveetil@arm.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 22, 2025, David Hildenbrand wrote:
> Just to clarify: this is based on Fuad's stage 1 and should probably still be
> tagged "RFC" until stage-1 is finally upstream.
> 
> (I was hoping stage-1 would go upstream in 6.17, but I am not sure yet if that is
> still feasible looking at the never-ending review)

6.17 is very doable.

