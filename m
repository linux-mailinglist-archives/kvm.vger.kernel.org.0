Return-Path: <kvm+bounces-51928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02623AFE932
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35E9E3BCCC0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 12:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735B72DAFC8;
	Wed,  9 Jul 2025 12:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l3EOiPpC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F9C2D8372
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 12:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752064942; cv=none; b=lzMsaCmN3/a9d3rl/nrKPxRAVre0xiqlpsGopijppWDheYtfgVTTfMNemrQLcY0uqD1qSvhZHFOUoRTsmuUSZ8tOi18XNBFkoMKijiNe69cvWlcdmvweziuzi+1pGPT0xId1e8k+JgfhrjFzTC9LEuBsBOY7AcoY8kKIEtzoIHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752064942; c=relaxed/simple;
	bh=xcEmpScrhurz+lIX7T6fvrOqkrSutQ3Wkp7QvWaW60U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eDKac3fDJr9mbIkku2kAJF0DMt/aL1Z+gNvgyeAAnsOlTjW4q/GQyEJsXn2SDgsYJNaLjA7I6yYauTkR+N5kqDCu752o0GeL29ZvzjvTXyXYY3EvwVLVIma2Cl15Ok9pWYxYSYkHMwcJM6ciafjT69gfGRufCFVnXVt0MKfNb1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l3EOiPpC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso7629583a91.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 05:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752064940; x=1752669740; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TTXuGTEbNkyKGOLgjZUgMziF9L0IeLulgcumpPPYx2s=;
        b=l3EOiPpCrL/5jw3cZiLh1G1ObnPGgLR8TKFpkMzbM5k5XbH1sQvluciUHMz7HuLAmv
         kiiMKUPWH+9D1mCzqubdQ32kwbXuBCwBUAgV8ZigJpbC+Tj399CgaVPoRlS/eR3aTKwq
         h0JJru/f4H9Nc6GWOioO/NBmxvTLNj6c+P1Yf5vmBO7HA3DN4NS7T0r7NZCNfEvbfuiK
         RpySyYiBB6KJpx8o5HC7PfbVvbSXM5CbTThZyumB4NOsceyS2LRg2buCPcOtugXm7be7
         MHQa1dG44S+FmghyEVlno+4p0YhQXopu5lxyqYVEafRSmffSSfIKXw+QZ2SNUvo4TOhG
         hSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752064940; x=1752669740;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TTXuGTEbNkyKGOLgjZUgMziF9L0IeLulgcumpPPYx2s=;
        b=u9E+sUUGT7PAaQdu702O8YiL1drpdhV47REOMT2LAC7Om3/2PwQDz0+M/0COfs+Mbd
         eRPaZ+uBlp2sXKGfu7WN5qU1LnN8lhisX+W2ivTQlbCX/Qs2ZDkqvmmFwxNWKVTbvsD/
         O5nTBc0rNAiWXxgBSLFdtFJofEizg0qxh1jZ5UR/ZxyPlUlKELfvwPj57WItAeT4AM30
         pU4rrs4nIZm6WN3ynW301YWw+NkrI1wCJT7GyOJ/L8whtOHemb21bHaIl3Lkhtghxc9R
         ullHRs3hxdAaX37VwbuTWDmZqZTzqzmeKVM5PguDeyKHdQU2hdP7uQgcZOY0bsvvZgPE
         vddA==
X-Forwarded-Encrypted: i=1; AJvYcCVnjK8giHrrVbDsXkaYdhD2oKMYqcmTY8C/T2IPhIm/xyv6v/5dmGRL6oD1zqPw0ytDRco=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB3WLVo6dYapvVeURFUDJERsktIXkfbqFKrbMWQfk5SyhnZ7H4
	yUcbPwL2dorKHFGAtdwS00PHE9VOBe4eCradViDsb7p82GpfLJlBS6xl/U/GbdeDLJMolP8FYXW
	z0rC11A==
X-Google-Smtp-Source: AGHT+IHGF+B4rOe5PCqjNNRGFNDRN2SqrGbZh1nDjHSp0FfbbyPLv1raSXsz+WYPZKwXudu3PHnHtoZUbeU=
X-Received: from pjbta15.prod.google.com ([2002:a17:90b:4ecf:b0:313:246f:8d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2744:b0:311:f99e:7f4a
 with SMTP id 98e67ed59e1d1-31c2fdc6032mr3614952a91.26.1752064940380; Wed, 09
 Jul 2025 05:42:20 -0700 (PDT)
Date: Wed, 9 Jul 2025 05:42:17 -0700
In-Reply-To: <fb4c14aa629a4dddb44d0fa9c4f7b498@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <fb4c14aa629a4dddb44d0fa9c4f7b498@huawei.com>
Message-ID: <aG5jqVJ0S2nDFMch@google.com>
Subject: Re: [Question Consultation] KVM: x86: No lock protection was applied
 in handle_ept_misconfig of kernel 5.10?
From: Sean Christopherson <seanjc@google.com>
To: "zoudongjie (A)" <zoudongjie@huawei.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Chenzhendong (alex)" <alex.chen@huawei.com>, 
	luolongmin <luolongmin@huawei.com>, "Mujinsheng (DxJanesir)" <mujinsheng@huawei.com>, 
	"chenjianfei (D)" <chenjianfei3@huawei.com>, "Fangyi (Eric)" <eric.fangyi@huawei.com>, 
	"lishan (E)" <lishan24@huawei.com>, Renxuming <renxuming@huawei.com>, 
	suxiaodong <suxiaodong1@huawei.com>, "caijunjie (A)" <caijunjie15@h-partners.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, zoudongjie (A) wrote:
> Hi all,
> 
> I noticed that in handle_ept_misconfig(), kvm_io_bus_write() is called. And
> within kvm_io_bus_write(), BUS is obtained through srcu_dereference(). During
> this process, kvm->slots_lock is not acquired, nor is srcu_read_lock() called
> for protection. 

srcu_read_lock() is called via kvm_vcpu_srcu_read_lock() in the VM-Exit path of
vcpu_enter_guest().  KVM grabs kvm->srcu early during KVM_RUN (again via
kvm_vcpu_srcu_read_lock(), in kvm_arch_vcpu_ioctl_run()), and holds the lock for
essentially the entire duration of KVM_RUN.  SRCU protection is temporarily
dropped only when the vCPU blocks and when the vCPU enters the guest.

> If another process is synchronizing BUS at the same time,
> synchronize_srcu_expedited() cannot safely reclaim space(it cannot protect
> srcu_dereference() outside the critical section?), how can we ensure that BUS
> obtained by kvm_io_bus_write() is the latest?
> 
> Thanks,
> Junjie Cai
> 
> Reported by: Junjie Cai <caijunjie15@h-partners.com>

