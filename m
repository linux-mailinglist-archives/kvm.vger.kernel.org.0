Return-Path: <kvm+bounces-40826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD879A5DC7E
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 13:22:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31F063B3C39
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 12:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA96A24291B;
	Wed, 12 Mar 2025 12:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma8sIwI5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FBA3232
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 12:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741782155; cv=none; b=t5F1yxWurxOgh+4c8ZALGV6JrBAILHlYKP5UpVPG9ruQgB/LKV/K26PWlWlCKqW/mCf8A28Seg9JmNTQyRVfMUGppsRTaqwG+N8RXZNptyAT9wlgfJRLYUuvRjzdVDsFZ4L+5MsCDkCJkfhMzmAG/bAGuPR7MCeT1uX/PMrz51c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741782155; c=relaxed/simple;
	bh=b3SPoXq+q0fJCQnjD9EiQdK/XHzu4BaOKr5jHZIcVyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IgEq3Y3A4gKAL7cNqlsqb/9uwskBEWccDGuWaNGVAl7efN212Jvj9RG69kkZcy+gRIbgnhUjLB5+OvjvygQY+agNgXKXAko5myxJaV+rZmOnc/YDSjfN4Xnlqf5o7gOkf+72HqYea8xLEQSVdrVyEPMMrEHf3RqDRwIykJQ8T7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ma8sIwI5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741782152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DPRWkNl2nLos7QUvYH28gU/BVhbS7HBoq6YbRwrOFbU=;
	b=Ma8sIwI5nEVxAfCbXUTYa72lGzZT28I20Se+K+tAWLtZ83/JZ8JJpquQQoPZZn+uw7EICG
	rJawId5mccRQD3B9OLbAxL9Xru9g2sfEDF8k4AtB2zj8cKz0igSHp1VkIqYIuEbPO3jf78
	Uj1yd1V0rmgMH+wdR9LqlDZMeEIQGnY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-JcXGB-nYOsqQL-mDaIX_bw-1; Wed, 12 Mar 2025 08:22:29 -0400
X-MC-Unique: JcXGB-nYOsqQL-mDaIX_bw-1
X-Mimecast-MFC-AGG-ID: JcXGB-nYOsqQL-mDaIX_bw_1741782148
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30bff0c526cso21332431fa.0
        for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 05:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741782148; x=1742386948;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DPRWkNl2nLos7QUvYH28gU/BVhbS7HBoq6YbRwrOFbU=;
        b=VS3O44P8qkztMsT9bQPWmd2XIlD5qnARAzHy1rmjQzv3m0nXNHUOv/h4WmeDWa0yFE
         0gXN0kEio9tB+YgE1M/VJyn0cGnfxjooqb6Ozuh4j+/yZFyiwNawSjC7mtfn9cV2J2vC
         Q7oGoI9lBaM5bLBuu5z1F9p+y2h0Dd3rb1JJFingLQZ1N2AsYz4rKRTPWyQIDsc6Elnz
         LOtR/aQtyF1YBhdiRgiF2K0RU7O/O34Sl5A65HNw6qAxgVHg4HQR6sINPzTo+aEIiHj0
         C3desd09uCNI0C1tQvcTTL+DZe8KX+Oep3Rt9QVd837RLhUO8ac1+Ow+v8cGXkDYeIxs
         SzPw==
X-Forwarded-Encrypted: i=1; AJvYcCVsZ2jGq4ZMbh/KfctaZYd4jXZVeTh69gvsZgeXM2Bg8L2QBTfBt9KmYj+jFG6ergfEQpU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJJH+qJozosrH5CoWZeLQxPc4fPlbKgLtS24zysezpbpSMigkn
	YJ5O+NvtDyaVSSOPc4mXKupvRINzb3Y0GM4mN1jga43v1C4IFtP+drPPtL3nufz8kO1yEgYRd9v
	DrMb1BBX1DnLOjS2fvZpKiDTZzo8X+lKkXGTu2KL+O6F4o6UsWg==
X-Gm-Gg: ASbGnct8qEtgVb1dOESzRBwajOfqRHKssCrn0SWOz/lLT1Wa62XskHDWgu/FPHWq/NB
	XwhkNrbzv2C9j2JqiQrFK7WO7IkbnX5uIIXfq6FdZ1b+uBHsN8owbHrjBAl/42qlR7iu08j23TH
	/p6otLUmGCzA6T3jCehI+XM7Qhyq6o3BQdHZGXxykx+a5iGFXCcofzdAMEC8J3Ca7AO2B8MAdkP
	ewz8zlzkiyUdAtEw/5Ab9AHTFLvObT6de1KG96bgOhw9g4cuFNzwrMORb2oUw/wMpgBkPHPDI0H
	/JvMF2OWH6mxlWhNk+HNNQ==
X-Received: by 2002:a2e:be05:0:b0:30c:c7a:d98 with SMTP id 38308e7fff4ca-30c0c7a0e25mr51188881fa.25.1741782147931;
        Wed, 12 Mar 2025 05:22:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWfgju5A2/UIZdEYK/IjBij/vjP1ystRZ5v2z4XI80BttFgw4A2UjJNQGinXsNU3xv7Fvzjw==
X-Received: by 2002:a2e:be05:0:b0:30c:c7a:d98 with SMTP id 38308e7fff4ca-30c0c7a0e25mr51188761fa.25.1741782147528;
        Wed, 12 Mar 2025 05:22:27 -0700 (PDT)
Received: from [192.168.10.81] ([176.206.122.167])
        by smtp.googlemail.com with ESMTPSA id 38308e7fff4ca-30c1b89ec47sm9027231fa.0.2025.03.12.05.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 05:22:26 -0700 (PDT)
Message-ID: <c6cea2d0-80b5-4d05-84a7-0dc25c219d1d@redhat.com>
Date: Wed, 12 Mar 2025 13:22:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
 rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Nikunj A Dadhania <nikunj@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <cover.1728719037.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/12/24 09:55, Isaku Yamahata wrote:
> The current x86 KVM implementation conflicts with protected TSC because the
> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
> logic to change/adjust the TSC offset/multiplier somehow.
> 
> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
> offset/multiplier, the TSC timer interrupts are injected to the guest at the
> wrong time if the KVM TSC offset is different from what the TDX module
> determined.
> 
> Originally the issue was found by cyclic test of rt-test [1] as the latency in
> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
> the KVM TSC offset is different from what the TDX module determines.
> 
> The solution is to keep the KVM TSC offset/multiplier the same as the value of
> the TDX module somehow. [...] Ignore (or don't call related functions) the
> request to change the TSC offset/multiplier.
> 
> [...]  With this patch series, SEV-SNP secure TSC can be supported.

Thanks, I've squashed these changes (apart from setting
vcpu->arch.guest_tsc_protected) into the corresponding patches in
kvm-coco-queue.  Just one small change is needed in patch 2, to
which I will reply.

For SEV-SNP, all that's necessary on top should be

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d92e97baea0f..beddeed90ff0 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2481,6 +2481,9 @@ static int snp_launch_update_vmsa(struct kvm *kvm, struct kvm_sev_cmd *argp)
  		}
  
  		svm->vcpu.arch.guest_state_protected = true;
+		if (snp_secure_tsc_enabled(kvm))
+			svm->vcpu.arch.guest_tsc_protected = true;
+
  		/*
  		 * SEV-ES (and thus SNP) guest mandates LBR Virtualization to
  		 * be _always_ ON. Enable it only after setting

For the sake of testing, I applied the latest SEV-SNP host patches
from https://github.com/AMDESE/linux-kvm/commits/sectsc-host-latest
to kvm-coco-queue as well, plus the above hunk; Nikunj can integrate
it in the next revision of
https://lore.kernel.org/kvm/20250310064347.13986-1-nikunj@amd.com/T/.

Paolo


