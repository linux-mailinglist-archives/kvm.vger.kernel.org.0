Return-Path: <kvm+bounces-17661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36EDC8C8B5A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 19:42:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7799285EA5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 17:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA811422C2;
	Fri, 17 May 2024 17:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bf+iiWoo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376CB1420C9
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 17:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967603; cv=none; b=RKecxMoNK0LnDnkrPEvfpQMwKl2VVQJEEiEH7Yh6ECP9sTdL/kfJP3+Fu7UuIp7+n4XLOvy+4jmhwfJRB3Lcb0ES9OpiaV7rapkHQucHnx7npnRSEQ2I8+apVZ3uN4dcxHiChxjEROEdRH2HDhuwMCHwqXx+sG2c+Vo90XTYmFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967603; c=relaxed/simple;
	bh=W4F7sJUHxFqCTId2bNTUdmAnN3//eoKwFQZjhNWBFKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sxWuQ/AUbTavsAycpLhTo8dSzILIoHDTnuMksVJXbuSL1n+rLHt+fKxXNvgNpOw6Du+6IbsjQ/q5ISHDsTPm6BzURlgh97GUzFhilq11yE1pY6fdj/NoBgwiQJy0iylsOqkyIwh9ypPK4HULZkmc8/6Sk7C6TnHFSF9iNx9+1ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bf+iiWoo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be5d44307so154196967b3.0
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 10:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715967601; x=1716572401; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=1b3X2JvgnH28eJymLWDZCCqY4xP7X8B28QNw1JqxSDU=;
        b=bf+iiWooKboF4o7W6rhqFd7Jffk2+esxAqp/Von2WynQIc0X7DbIaUzBkA95hbv6yZ
         /HSbCxJV9wCILDXfK+GgI3hbFKEc15NMGRuR5g70AsyAZfBghVen7pTLjMdn9p/lnLrk
         sNd1lrcjU9MocDH93uvo0cZylsTC/Rqhb+dHyWxlp9jMY23OWdrjoYJy6gxhqkD5sr5c
         3oXxYNk7Xo+c7ZMpbIwtdyK+DeOswNfBPk3vpv1W3ttHbN8G2HA+hj5F2R2MD1KBWaTV
         2rTgEK5AwYUMiX9IJ4eFTSS+hfAQF9WzLKMgBpFRbrJpbtIRXQGyK1E55L8fcIL92hA1
         omnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967601; x=1716572401;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1b3X2JvgnH28eJymLWDZCCqY4xP7X8B28QNw1JqxSDU=;
        b=Zd15jySE8llnjASXA6rc0kfoB9Enuoe+KarmfEblUSKJBXQ/qtlwrf0RsivKpGDlhT
         R//dCDoEs+WnkHjipfmKDiy546g/wCTHxWt9uBnyBJi+PSi0DZ8eL9ajT8MA8lfdywnt
         NkpSw/wghZrlWz5UFGwS5xtpt7Uq0JxP7xp94rFDGpspZuUYhFk550hKfV7f9bD5EXLg
         alDMDg1TAvMbOXiKPw2mnaXx9lUzbl4OdziVr0+rRRJ0DjrkvlslwEqqEubzuAHf1AbB
         f7sKyWXjfeeEW3CYefxsGITV8RZxIHbjpw5BiaEHA/9Y8VFh6OGqk3I6zA7dsObc/AsC
         +uxQ==
X-Gm-Message-State: AOJu0YxZYWE8Vh/NhSf1Uf0By1x1oetqwq709ld0uBUEBHlm2oJStZyE
	4p969MzozpDz9kIH/jDbtFHfm1E9qpdWePM7RroR/Z6uY0p36SGZ9fVqtZIPsSh0AUN99SC98pT
	QyA==
X-Google-Smtp-Source: AGHT+IGn0mSXHlGmapLZadEc+H9mZtBJCjVeNzVsof7AUPIDogJQNa21HHKOK/MSnxG3No8b3f3wHmbaQp8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6202:b0:61b:ee2c:d5ab with SMTP id
 00721157ae682-622aff8fd3bmr50886937b3.1.1715967601361; Fri, 17 May 2024
 10:40:01 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 10:38:46 -0700
In-Reply-To: <20240517173926.965351-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517173926.965351-10-seanjc@google.com>
Subject: [PATCH v2 09/49] KVM: x86/pmu: Drop now-redundant refresh() during init()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Kechen Lu <kechenl@nvidia.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Drop the manual kvm_pmu_refresh() from kvm_pmu_init() now that
kvm_arch_vcpu_create() performs the refresh via kvm_vcpu_after_set_cpuid().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index a593b03c9aed..31920dd1aa83 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -797,7 +797,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	static_call(kvm_x86_pmu_init)(vcpu);
-	kvm_pmu_refresh(vcpu);
 }
 
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
-- 
2.45.0.215.g3402c0e53f-goog


