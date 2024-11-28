Return-Path: <kvm+bounces-32658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 545CF9DB0D0
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 02:36:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E175BB2333B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F96A146596;
	Thu, 28 Nov 2024 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2aUZ6RFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C630E140E30
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757686; cv=none; b=n75gFdklMTDSjoVVPtAhD4sJ5dSHrJlQ49rpjQzYoBWPBtNd6+TmLp64faaW/rPUdrs/qxx0U7EKBg5JZj+0s4HAXmqq+fSUxHhhcpI1Ik3ArGzWqlfMl0Sx9gGXDluE6K8uqKZ8V3YVLOXj3Yc9ZKHj5r2i40Unj+MH5YtFF7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757686; c=relaxed/simple;
	bh=SfTqWTXa8BKoYVN/v8dEJW0W+ZanJ5NwKZHbFFSkXUA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QoGyA7hHyfDoR7nsFiAWeedDiiM4gDMKx3qK6WOGjGznevpCCDNdQ+tMY6nUzMh5rF+xj1nQCsWQT+FIH41L+8xd1OhHnrTXKc0+e34/FK7STwgejkLlrZZFpvyHR6ZvrsdFjjNxf7xRne69dGv+xFOYQzpuC5Fq6LMne9gp0DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2aUZ6RFw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea5bf5354fso352047a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757684; x=1733362484; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=G70La0fxRWvS7O6Qk47ARCLzL+vhxpEYYaoXHV45TwU=;
        b=2aUZ6RFwCXBMpKeUusYBJ01/e2fzpimey+Hqxktx3CGpqbqOfYjq4wK9OjZY+HaTDU
         LyAETmWV89bGrzV0kq+PoSREPh0jUpTickq2K8qnTzHJVNgzMrIEjXFzWF5ogVP1d/T1
         SYTdC0kRjpjKlhFAcCfI7kIVUv8c7faxEAxgn2qwhZlPd0UC0oCiRw4rv1bPK3uu9gh+
         XWLsXAMhY7fBgExwQ43j3+rLVpOqdaDS2OEfPP90H+Ye6ZrYsqBtvHXsb3ozeHhYQYUU
         HRAwFoPImLMwS/YLnCwDH+rNsC+N7EbkY8rrfVh2lJD6438a28foNFNCpE6fyt0HSSf3
         auvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757684; x=1733362484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G70La0fxRWvS7O6Qk47ARCLzL+vhxpEYYaoXHV45TwU=;
        b=PEbfHWxCfSXDzm7Bao42q4FgtbzIHuGjRoNZ42o6b1qhhqdIZZGr0UmIUwO5/ipqOJ
         DfroeiTsQJc+uFCPU6hQhqR3UW6fUoBThYtXm/4Ji2LtqjlOrOaxh96EyWz0+bBMkxgF
         BJ3qiFfWjTlplr5bvVkvWoNu6hdkL62IR9WYtPOrwB6e9maS+rVWkMVG+F8Vw23mBFCF
         MYUK+K9RZCVh5qkdyyzRkGdwyato+lg8olT4utm9xcuVpo2MEj9uAOARSVXmwcGI5jXH
         fCIZ5rvxBODbDlUrPO/TrGTL7GUT2bo89hx3ffbk8rzLSVtNrg02/XDCoUEN1BfNP7zv
         vYdw==
X-Gm-Message-State: AOJu0YwPdXril4YYhttQqXR3uCbxMEM6+vju1UCtDrbx4qivO5ivXej+
	WLEDsiQywxHNHnkoOd0/fZN/9gA76e0ZG073Q8r6I9Hvhg+hpqBg/D9Bj3BJadQdapef23OY1sA
	ZZA==
X-Google-Smtp-Source: AGHT+IFToGV0nK6Lp298fFzAmw75HCs6XdDNudr1ZEVggFnYIEoMGXjFW2pcMaufdLz9kGjCHOkick7/ql4=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:2ea:83a6:9386])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b8e:b0:2ea:8fee:508d
 with SMTP id 98e67ed59e1d1-2ee097bf308mr6780563a91.30.1732757684358; Wed, 27
 Nov 2024 17:34:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:34 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-8-seanjc@google.com>
Subject: [PATCH v3 07/57] KVM: selftests: Assert that vcpu->cpuid is non-NULL
 when getting CPUID entries
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add a sanity check in __vcpu_get_cpuid_entry() to provide a friendlier
error than a segfault when a test developer tries to use a vCPU CPUID
helper on a barebones vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 645200e95f89..bdc121ed4ce5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1016,6 +1016,8 @@ static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *v
 							      uint32_t function,
 							      uint32_t index)
 {
+	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
+
 	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
 							  function, index);
 }
-- 
2.47.0.338.g60cca15819-goog


