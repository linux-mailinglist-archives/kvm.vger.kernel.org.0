Return-Path: <kvm+bounces-21508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 234A792FB78
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:32:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D299628419F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 13:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C92171653;
	Fri, 12 Jul 2024 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kntL+IZA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BD217085D
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 13:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720791123; cv=none; b=X09Z939j9qeRgtaqNGCUiIWRyry7mwGDNZtXsHumzHszhDHIo1EhJHqNvL4CXkLEuGHOrkGHEViK7UTzarosfD5XDX2RLa0PxoYrP+BUzglcSEs+Tgk05qFHue7CqqLkwB9zGWugh+/ekD6jGbrd2/9fpheP1qpjNf6u/U8LvgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720791123; c=relaxed/simple;
	bh=XwEHyALYRExbX2pRbkL3utJyLPIwlkRBZVdNdRJYw+4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mjx/qZioG1VgvaOLKmtWz8XB4eCq98/Ov3FVx+mbVPB20VO66D4uco3ODhoPZ1eeEfkFXQNA+ycgej7a+Z7cGj/rILsticcla6yzB/Dmv8oWTAXazBFpsK9lSL9t/CBKFRULI/CrkD5KOj6N2b2tTiGhK7to16CE45TSeYBfKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kntL+IZA; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2c960a592f7so1709876a91.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 06:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720791121; x=1721395921; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wlcXnTAyG1qwnoAXhkdhe6yOcbdDru78Zg28CF9eSjM=;
        b=kntL+IZAc9twDfCQrDu4zvBe4qgM3ss9BJRX11wbNmAly5ikWZyUsLbci1Pvj73E2o
         zyTTLgOIaUVx+RLlDSOBNLpSGJadfjn+ZlwS2xxKL1eAVQNx/Qg8/gcpIylcTTvUa1gi
         VWQmN2jUEiy95eEK6P0h45tw/1eCPTvbzhPmQsEJ+Ewl8USxQPuGFngdKr5atKTtzrsM
         xabSPh9dvmSeO1I/KZMdXAA3FL1gOQJ3/30tJBHgAE+z0Zys7bRdAER1KdXg40RuAxxQ
         o4znqdyVCSbl7anCJNL6YBlcn4XzyoSbhiaINuS1fonoGzMrwN2sbEaSexiEtDpdXdMC
         ysYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720791121; x=1721395921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlcXnTAyG1qwnoAXhkdhe6yOcbdDru78Zg28CF9eSjM=;
        b=N5soiggLk3qjxebZDXw9sDtYdx6dw0oI7SeNjOwb4WF1Ea5NFObXzyvMYvaQKa7/Yq
         hshRQNIAkD314tpbGmi+uc3o+2SlATzzuvh7aSlebxNvg8/6JpMxUxUGApa2RyID+spJ
         HE6VmU4zC/PSzIsuiWtLMsJG8pn5oCfBdjdYGr+LEftT+T14uCGt3EDg7+vpgyhlDzOP
         cXMYAujila7dAmz0tpW7//WXojTCU/kj7JhznpoN40XLKVh8nfklib8iDcUu8W/oxyFM
         fvYiY+zQEuWMfaX+fbj+0RcAPaeRwMWas+THqGcDuLIRlEnqo8Dq82T14lkcoMW1xvup
         FefA==
X-Forwarded-Encrypted: i=1; AJvYcCUpNme4oIgowg+UQdELhY0YlScH7gGXqL10Vlfkkh0fJ49PnHT6VWpP6JHIwARhlh/9To4P9JhEGQnxgjiWNdfeYR5z
X-Gm-Message-State: AOJu0YzQOPVdGVjkRRopUzjmHqYmhpszdRzb0fquSHSWzmQIIJTq/JDP
	iKbBTIkEWvjAjiTo1IIuPwdLUVQt1gdp/T9ZEs52RDiCagF+Gyty4tFoI403aykST6Ix+R+0o96
	bcQ==
X-Google-Smtp-Source: AGHT+IEVDawGmhURpZGLMNfqqfdjGi+eb1+WnZuWI/OM/9laSwCR3IXn8ahwQlyxin/gJx1/hmD7pDFxvqE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:cb93:b0:2c9:61f9:9aea with SMTP id
 98e67ed59e1d1-2ca35d39330mr44466a91.5.1720791121058; Fri, 12 Jul 2024
 06:32:01 -0700 (PDT)
Date: Fri, 12 Jul 2024 06:31:59 -0700
In-Reply-To: <5a9d0c9c-ef97-4a77-b81b-a67bd27603aa@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-13-seanjc@google.com>
 <5a9d0c9c-ef97-4a77-b81b-a67bd27603aa@intel.com>
Message-ID: <ZpEwT59eveCC79uN@google.com>
Subject: Re: [PATCH v2 12/49] KVM: x86: Reject disabling of MWAIT/HLT
 interception when not allowed
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Yang Weijiang <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 12, 2024, Xiaoyao Li wrote:
> On 5/18/2024 1:38 AM, Sean Christopherson wrote:
> > @@ -6565,33 +6571,29 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >   		break;
> >   	case KVM_CAP_X86_DISABLE_EXITS:
> >   		r = -EINVAL;
> > -		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
> > +		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
> 
> sigh.
> 
> KVM_X86_DISABLE_VALID_EXITS has no user now. But we cannot remove it since
> it's in uapi header, right?

We can, actually.  Forcing userspace to make changes when userspace updates their
copy of the headers is ok (building directly against kernel headers is discouraged).

