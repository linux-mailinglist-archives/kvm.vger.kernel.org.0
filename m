Return-Path: <kvm+bounces-63990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0711FC76980
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:23:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 4BF142B609
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 23:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 356C0307AC0;
	Thu, 20 Nov 2025 23:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ioTxPUZR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083C326158C
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 23:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763681006; cv=none; b=PaC239x+C3JWTGAPSjJZmiXUa8wfwjjUCN87BFklSkxP+0EAf4c7lsh5jSL1IOq1Ou3f9yWQY6hLh6Gn/sjz2ddSCKMVptKHVuyYuFvnGOSwN/f/9Z6PtJjwyb3m/qxlbRr6xuxN0ULzLb38JQimCKcVmY23Ni7N+BIkOcL7Hgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763681006; c=relaxed/simple;
	bh=7NUaAC9ZZ3JheU/sWlEoXWP4QHKD7Ltgr4QystVok0o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IVBPk3v/MHHBstAGPWDJZYlL1H6ChrgCw538gM9hRZQOXhYzgCb0Jzg9tZrs4wkEGZdvQ9qjlw+fLlzeMSSN/Uzo/wjXt5eDxfSiGsQUnRdjMY1yalJg25yHYgaC7Wr2NhebB8IeX2GAyYEi4ayjI7dGjPQZ/tqlIH1T277J1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ioTxPUZR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f12fso4116564a91.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 15:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763681004; x=1764285804; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gxeAuLWMyIwoSMm3ZLvJ0r9bpVgYo1R1l3tZr9jnS5I=;
        b=ioTxPUZRmyKI1WCSz/fk9IbLNoMubz/R+tkP95LKueyqTMIZMCVceikd4nH0Ky4lew
         e46rh+7blIAUAbpXybZabSi2kqmKewMsgH6PBAhH4zFgp13EJp3gRmfvphqTTcG8cWcr
         6SQPcLpA70PpgNR2VBTWetthY+J8ACa4xT2kZNm80PZrGzMTOSf7H0pWKrD5Nu0V0B3P
         xcEFshWT2t68X7tdEpWBSwLa2cCFjSZG4Z9LGX2qfT+ufTLAre7yoQK/zymntUxSruso
         S2hA58HGXRTRFoHL7BBYcOn6U3Ow2Z12qaH+h0/zHQwrbRA5GIs75zEzt/0vzrbV6CXq
         9xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763681004; x=1764285804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gxeAuLWMyIwoSMm3ZLvJ0r9bpVgYo1R1l3tZr9jnS5I=;
        b=AXcVQK6KAcMcVc7K1vXjomIf/x0lXQwZhNCR8+F2K6vh2iB3hZyEHzrhRgTqFOczrW
         ZiVFS3qaNE4H+zs4vEDMWwkcWOae42HN9eUDJ7N7tdkE9d4lZcwXB1pni7MLmM/RptVY
         MAw2BHRp08gGnc2QIirmuL9wypu32ckq5zcXLtwyj6Vqqezqd0ZyJOdr0rU9hTlHk9em
         No85aIXJxCkWQMHEbZORKhI3W0NyUeKR1as/Hw8+RCd7/Q6DIjLvEKQU7o3QEkqUTG/l
         pleXnAZu0nh8NMkwkjSgPcbanroesX4rkwLr4mpy9CyYZXVtevMJ42royIrMs+tZ0Zub
         LgfA==
X-Forwarded-Encrypted: i=1; AJvYcCUuriuhXYdKafsIjyr6BdlRzog55cqebEEEqyCbFLt6uMHw3PSbZ+y7ReegHQBTT7A/HIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4O+XH+mY15UP+b9lNF9Ck1Vh3v8L8pp3UFLtaJzD3nrr4Itlb
	7fPDzeNPK1wx7ociF40+nQe0MoA+43LUpLcQ0Adx+C5tStQnyb1HspuS6APXx3gkUraBh6LODha
	15wIh8Q==
X-Google-Smtp-Source: AGHT+IFTSTGnitN3mtVdM1iPzW3U+3Viqzz7ofIpJYcDSQG4T4CcKaQc4vZ3mPPnEAzzO0giHBqES8bkEgs=
X-Received: from pjsc10.prod.google.com ([2002:a17:90a:bf0a:b0:340:c015:8e31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1f88:b0:32e:70f5:6988
 with SMTP id 98e67ed59e1d1-34733f45649mr192348a91.32.1763681004255; Thu, 20
 Nov 2025 15:23:24 -0800 (PST)
Date: Thu, 20 Nov 2025 15:23:23 -0800
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Message-ID: <aR-i6zFLGV_4VwsZ@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 21, 2025, Yosry Ahmed wrote:
> There are multiple selftests exercising nested VMX that are not specific
> to VMX (at least not anymore). Extend their coverage to nested SVM.
> 
> This version is significantly different (and longer) than v1 [1], mainly
> due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> mappings instead of extending the existing nested EPT infrastructure. It
> also has a lot more fixups and cleanups.
> 
> This series depends on two other series:
> - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]

No, it depends on local commits that are very similar to [3], but not precisely
[3].  In the future, please provide a link to a git repo+branch when posting
series with dependencies.  It took me several attempts and a bit of conflict
resolution to get this series applied.

> [1]https://lore.kernel.org/kvm/20251001145816.1414855-1-yosry.ahmed@linux.dev/
> [2]https://lore.kernel.org/kvm/20251009223153.3344555-1-jmattson@google.com/
> [3]https://lore.kernel.org/kvm/20250917215031.2567566-1-jmattson@google.com/

