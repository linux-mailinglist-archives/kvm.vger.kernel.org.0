Return-Path: <kvm+bounces-50765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E73DAE9115
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C03C56A2135
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 22:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF4E2F4304;
	Wed, 25 Jun 2025 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CM4i4c4U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3A526E6E1
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750890450; cv=none; b=R5F3jWAo8UoFhB1T28GLp7KufPFWN0d4PeD5XHxYcLDl1QW/7UvJ6fiM4wDHhCEGD3hFhNX8rYo9C3HVk+zcwIU+vPgejbVt98ZpaPUB21kzGNCNdqOycUasEWpvknsbbzta0lLYnmtWTgEGXHu22xbEBexZrDfdqmPYjs57NPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750890450; c=relaxed/simple;
	bh=vWw3uexPmgGirIdC5hWdSreMJG5sOiwUXmIQy2pr1vo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ajLaEDxD1OPfDkWG/l+lCd7Jnbnle50x6FoVVRlogHhH8skvUa3iVP1RGyJJnAu070/hcIAv5uXsMX3+9HjJToh5MLvKcVPPkcaVs4gm3xuYh4cEBBgv8e3NRQznf4+X0ljSs3MN+wdSumpmFBWZOcVbQWgB88IsqWXzbkRUNRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CM4i4c4U; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-315af0857f2so231786a91.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750890448; x=1751495248; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYMiziqxx+dkKfmpL4cjtXaxzDCKbeuDEZS/eoFgwQc=;
        b=CM4i4c4UOfx/X9HtfPPLdki+Kma9B4tXp0MeFq1+nntxw/HnKXp/09lPKoMXzhOTT6
         ojO4KDtj+C8TJqRPCE6YDv42E2FX5Akh5Cm/jboDhFTduYMwmZGxbIIiJopwAokWKPtv
         pjRYfS3Mzp/Of7BP7eyVseWO4vQYqWEhfE9PAUVUVFSxxXGt+EwM12wwcg//68pptA7i
         V9GGXUfnSMNSVqFDfA6j4Jv6bkox27zfs8P3zB7i1EDmJl0e2YxbgIgzW03VBrVi/CGb
         fqTG7l5n3KF/48gllfsyjYnAAqPfestUaE+OgGKR9FNiFri7I9u0WlxQMlfCvXJwLuSA
         Q4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750890448; x=1751495248;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gYMiziqxx+dkKfmpL4cjtXaxzDCKbeuDEZS/eoFgwQc=;
        b=bd36VjI2pjSVIRfsVHCyUHfcKKQs9Ru9v9M1+2lI95UKgZP8YKryO789avSYYqtK9w
         47nvzYK51f1akWokM/ltUhJPIjs3VOT+BLV/0w2IIPVkFP2RiqlrNaHin5aetGa7be5w
         C2a32Tf02DUZN6qPbaR9niepL5WlmFdkNVLtKvCYqccZ9qWPLvXzH9VN6xRz/EIpsLuA
         /xy1C00hYgOp7UOUOfWpBcjJze+O8d1TlyH8EqD7lzLBygmdzvvCrd9F98BHslRx8kCy
         wzwF4/TPO5pgalpRUoXBkg7fC3wg7/Iz9F2F3Oh0ZQbH/vTGGSu/rz3ThT1fj1JbJIJr
         2e9w==
X-Gm-Message-State: AOJu0YzT8sxferS28HxtJpdSqLoWE/GQ9VNm0PyQBSIsBZ6MT5/kTePq
	QBe9Loh6+n5SSDeeQxrbPfWgt97Sgi41naLaSQ7Erop7g0YQcjoK6ciIFUXSkAXwoJcizUfkWhM
	aIYPqIA==
X-Google-Smtp-Source: AGHT+IHrWdsFl3J6w4HEzuAFNNbssKmcxXqloPX+MrQvOJXMAJjnDmWQLgmVsR7XTsscuW1aXJeG/K0ib/E=
X-Received: from pjbnd12.prod.google.com ([2002:a17:90b:4ccc:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5690:b0:312:29e:9ec9
 with SMTP id 98e67ed59e1d1-315f268a5b0mr6819475a91.24.1750890448137; Wed, 25
 Jun 2025 15:27:28 -0700 (PDT)
Date: Wed, 25 Jun 2025 15:25:45 -0700
In-Reply-To: <20250611095158.19398-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611095158.19398-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175088949072.720373.4112758062004721516.b4-ty@google.com>
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Adrian Hunter <adrian.hunter@intel.com>
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, 
	kirill.shutemov@linux.intel.com, kai.huang@intel.com, 
	reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com, 
	isaku.yamahata@intel.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, 
	chao.gao@intel.com
Content-Type: text/plain; charset="utf-8"

On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
> Changes in V4:
> 
> 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
> 	Use KVM_BUG_ON() instead of WARN_ON().
> 	Correct kvm_trylock_all_vcpus() return value.
> 
> Changes in V3:
> 	Refer:
>             https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
      https://github.com/kvm-x86/linux/commit/111a7311a016

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

