Return-Path: <kvm+bounces-55547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC7CB32459
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:29:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3167AB67B72
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7879034F498;
	Fri, 22 Aug 2025 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="POqtATle"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626E34F46F
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897995; cv=none; b=T2q+kZoRZdnAKP7BGCG+CZbKEE5rCUWKOsNgkrLHTTvq7uqjo6APosY8lLwguPrCoy5rKR55uKbecXPzCoRLA9ZRdXPKzk6ulRyRKKyIZY5bkZOXx1049UomNxbkIpNor+91sR7MK1UZT4BwYSd8+m57tZMYCxKnRg9H+8/a97c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897995; c=relaxed/simple;
	bh=YREmKh0Fboin7Z98DEMinTdbhs/073LBC+MjzBhLJ7A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oimSH24S0m6SmDsLSHQmUg7P7uLMAjL0aPqACKUPwnPCIq6pKz3DTKuPs1HOw5UvsMQUlHDjwB1NIG6ocGCcybhy5y25oMdpOlpMjaQSdvwauAQeL8MDcuxuyAOtfWqfu8GMLFZFqynUjOokRMlHrjivvYUVzaU8b5mtt/SOPKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=POqtATle; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e2506aso2523014a91.3
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755897994; x=1756502794; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EQUN3cu4Z6jhJOuigxfBc3jUQuHypS3MX4G3wGMZeLE=;
        b=POqtATleSJSlV3iMQy18tEjmGPVBRyAbbubDJq3UZO5gcBtzpr3DTnYCUlrKWv9H0G
         MX346RhClwa1APvx6q+bQH6EYVEZLizk4O9NwrMyUUnZJg3ZxrlmbELFe1jV+x4TA6Nq
         3iI1auMcal56ZOh8L7n6iCk4cE3cujZfyOfsDgEFBqy3TMi63ZxwbiWd7MTF0meOxaAB
         qiCZdfteSCi3flpwr5qctfplOnHzdUTQ45bxF6s49NqwXqpOP23kV60zoyPWKtBlogR4
         d5nWhq8q0F4Rv3z0YF/wF1garj+QvA9D/lKYp/zwFSHKv+44M7LgWhLj5eisJgSfFuwC
         2YnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755897994; x=1756502794;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EQUN3cu4Z6jhJOuigxfBc3jUQuHypS3MX4G3wGMZeLE=;
        b=sa0kqZ8iRAVGUdXBV54ZA9bPf04nDhP9jjsOHVP4BjOy6vTbcmQanXlMk9t+Hnm7DN
         pN7BML2eoidMxjt+96HVFqhFOncEITFhO/ZH/rSiFnjepMnBMWqYyANd6m6ASIe0iVbA
         4iO9YhRE9yqN6WqojE/fSjJ+2Umu5YkIF/6+kZ4M+OjJAjOTSJo6m8+Ypt4kvUnXGnxq
         6ZuR/SIgKi8jwJJgAl2OkCKicR3LLdsMkZrf9ghtxocO5FPhcnZjxK481tSbjxvvADmy
         rlDpzP9K6sPxHvId58lcLP6kRd4D/IrufsErn3fW6xSRCp2kgw88InU9ockpYjaT44b0
         mgSw==
X-Forwarded-Encrypted: i=1; AJvYcCV5H0r4BEFV2YcNQjMxdl6J2j5GtXz3JUBBlz/oTul2lp8TkKQsJcWJIrzKJChqaSXu2nI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyIz+4o9uQpBvC0Zy4ztDKSe0B8CHrqBYjVynmDPTrhxE/Y6jz
	1ow3p4lu7gU7DyLo3c00ckCjQ29BG6HkS7hkLGYAX2LmRTMcxI20j9MKL2B8T4W07Gwq2fnL5Ig
	7v2L78iwNIGLVGg==
X-Google-Smtp-Source: AGHT+IEYvgtfmLrdKKCDi0VmUAdVIvAX4P0QTCRSeSsfn9oPPDleSUrFNy2Tx75Bst5Qh836IgaTXfjb+a1ETg==
X-Received: from pjbsg17.prod.google.com ([2002:a17:90b:5211:b0:321:c2a7:cbce])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dd1:b0:312:1c83:58e9 with SMTP id 98e67ed59e1d1-32515ee155cmr5544091a91.5.1755897993841;
 Fri, 22 Aug 2025 14:26:33 -0700 (PDT)
Date: Fri, 22 Aug 2025 21:25:04 +0000
In-Reply-To: <20250822212518.4156428-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250822212518.4156428-1-dmatlack@google.com>
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250822212518.4156428-18-dmatlack@google.com>
Subject: [PATCH v2 17/30] tools headers: Add symlink to linux/pci_ids.h
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	David Matlack <dmatlack@google.com>, dmaengine@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Joel Granados <joel.granados@kernel.org>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

Add a symlink to include/linux/pci_ids.h to tools/include/. This will be
used by VFIO selftests in subsequent commits to match device and vendor
IDs.

Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)
 create mode 120000 tools/include/linux/pci_ids.h

diff --git a/tools/include/linux/pci_ids.h b/tools/include/linux/pci_ids.h
new file mode 120000
index 000000000000..1c9e88f41261
--- /dev/null
+++ b/tools/include/linux/pci_ids.h
@@ -0,0 +1 @@
+../../../include/linux/pci_ids.h
\ No newline at end of file
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


