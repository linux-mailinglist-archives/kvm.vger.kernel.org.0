Return-Path: <kvm+bounces-57648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6B9B588F7
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 02:15:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4DCB1B20DA9
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 00:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FF72AD02;
	Tue, 16 Sep 2025 00:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QhVp9ylA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0D91A26B
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 00:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757981694; cv=none; b=PHDNOPf3p+aYZWgAmvRm2JFWZcuH88o3GKdmfRTu9f6z0slm44HJ0WqH8jj/8xcMdqRjQzzFm8E8bWTtMH2XsU57aK9LP2ri/72kzzrmDp23VO3D/zt+t/sP3FVPRvG3FqDSPjdMPxw8CfEr6rKmow36DW20eL65A1HsvKn983U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757981694; c=relaxed/simple;
	bh=OsLjW4akU3BY9HxHKes/Fg5vhJqLQgUMAvjfTlox1sI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=neZteaFqvO6Pe71LWXr/bWAsYjw4xvO5PGAsyxKFyxf8ocCDg12gVY32ScT19PaiFONpNWIZhTb89YPThBmfEt6Wjb1+SnqR/oO0qeBUNwuYlLfFIiksA8WmJepl71dsvCZyyvd0qmLScpBEnvqEnC03mzNpEH4V1DP3GBP37EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QhVp9ylA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e43b0f038so1300412a91.0
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 17:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757981692; x=1758586492; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dgU9Sr+X5atOvzaN9B3C4feqI08CRCY8bdW5NoV8iVM=;
        b=QhVp9ylAWM3NpoowJVl1fHtV/0zvIUq2hgMoKhJE8jemRVPPQovmadLMhcjBQjHFeD
         j60mvZCk42Jt+HeBV3Ijc30lzBZjZb5IxyjPg+YwpVUcOUv2uaYCwYWMuAZRu6NHREul
         kbVXhjTowms3bbnGMJI8lLVwvV7FoiFU1V/dGykO0xoMdnlv4x3hEgvO6oTJ5dtK2NPP
         P5qJdF3UK3spj5hGk/JHZnr/pDOJElOjI5dIciTqcjR9CRsWWylQqJPGSQ63kbtFVAqg
         9oHQJJMjBNCneCzx6zZIV76op37GoWhAiAQPgbklgsahJQUMAG6DaQ5wGBY/ggUh4Fty
         Yb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757981692; x=1758586492;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dgU9Sr+X5atOvzaN9B3C4feqI08CRCY8bdW5NoV8iVM=;
        b=gRzznEgoA0D2+EO3mgUp20BSjTrX+zl/B738xS8Q4lK046ww+tQT/eylclnoK7d8V5
         xfALu1+nvm8vC1E7eOlSXMR8UbPg6QTJkRX9ou9+X4qe6GxW6yL/FWJCPv8cBLpShOMl
         LtbFk10ZEnBqi9shSN6YvFjLO9iDrwrOCaQR7R8M8sCbbiy2XrxSUZKGNJ5H5O68eoGj
         ANn7TSysqWKG9RL+nAY29HEH9hs5iymxdOH/PeHkVYLlxoz2/KvXdc8QrNK7r2kBrc6V
         sBKcvCTTg7v7frOmu3ybtw5QMH5vOYonjeJUNkMYgeVRB6Qa4WBMbASz+qjBBH4msHPU
         1m1A==
X-Forwarded-Encrypted: i=1; AJvYcCUdwiUNCwoLvqDJrHR/J5VKBgj0PJGLVFV+6vGkRuUvTNOwehco+A3QlQ/xc9UCutFy8So=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUK7VdaaCLPFEJt2Rv0G1XG/JHhK8OyFSsWWV5jEOPNwzlY68Y
	5ArpVqmnXGV+w/X+MpMfZYv+7dNHSDkBilWgCeNZ7UEpzeYWFpLiZE3f/BhRge/I24c0eNnicKo
	quZIEgg==
X-Google-Smtp-Source: AGHT+IEew5+npo2+KFfx/iV3GURHHosp8EbaGuPuT3orq3HxhycBVJIX/rJ6KysoanrGXrj9mgjO4GOefsU=
X-Received: from pjboh4.prod.google.com ([2002:a17:90b:3a44:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fc6:b0:32e:1ff5:5af4
 with SMTP id 98e67ed59e1d1-32e20049fbcmr10250226a91.35.1757981692221; Mon, 15
 Sep 2025 17:14:52 -0700 (PDT)
Date: Mon, 15 Sep 2025 17:14:50 -0700
In-Reply-To: <aMfMk/x5XJ1bfvzv@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822070305.26427-1-yan.y.zhao@intel.com> <20250822070554.26523-1-yan.y.zhao@intel.com>
 <aL9rCwZGQofDh7C3@google.com> <aMfMk/x5XJ1bfvzv@yzhao56-desk.sh.intel.com>
Message-ID: <aMir-qs5zwmoXU6A@google.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Test prefault memory during
 concurrent memslot removal
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, reinette.chatre@intel.com, rick.p.edgecombe@intel.com, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Yan Zhao wrote:
> On Mon, Sep 08, 2025 at 04:47:23PM -0700, Sean Christopherson wrote:
> > On Fri, Aug 22, 2025, Yan Zhao wrote:
> > +		if (!slot_recreated) {
> > +			WRITE_ONCE(data.recreate_slot, true);
> > +			pthread_join(slot_worker, NULL);
> > +			slot_recreated = true;
> > +			continue;
> If delete_slot_worker() invokes vm_mem_region_delete() slowly enough due to
> scheduling delays, the return value from __vcpu_ioctl() could be 0 with
> range.size being 0 at this point.
> 
> What about checking range.size before continuing?
> 
> @@ -120,7 +126,8 @@ static void pre_fault_memory(struct kvm_vcpu *vcpu, u64 base_gpa, u64 offset,
>                         WRITE_ONCE(data.recreate_slot, true);
>                         pthread_join(slot_worker, NULL);
>                         slot_recreated = true;
> -                       continue;
> +                       if (range.size)
> +                               continue;
>                 }
> 
> 
> Otherwise, the next __vcpu_ioctl() would return -1 with errno == EINVAL, which
> will break the assertion below.

Drat, I missed that kvm_vcpu_pre_fault_memory() returns -EINVAL on a size of '0'
(see the wrong comment snippet "Either prefaulting already succeeded, in which
case retrying should also succeed, or retry is needed to get a stable result").

I'll circle back to this tomorrow.  IIRC, there was a reason I didn't want to
check range.size in that path, but for the life of me I can't remember why :-/

