Return-Path: <kvm+bounces-72594-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAGaKjE7p2mofwAAu9opvQ
	(envelope-from <kvm+bounces-72594-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:49:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDEB1F6581
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 15A193011526
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C068B38424A;
	Tue,  3 Mar 2026 19:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="YVIWWUan"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A137C913;
	Tue,  3 Mar 2026 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567232; cv=none; b=icXjoAwiW9uQTep42T6MGBvoUFlFzxN67duOrznKhyDCNoEXsq/YebxThVyS0jFoH1oJop1rvvXhr776dlB5MJ/dPYvnyLnqScAYR0LKo9Wp7cjA6+12G3cRrWuAhV57bae+b+w/p4mqAwrIYG9hhWtESqcsE+bh/VBiVCqFf9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567232; c=relaxed/simple;
	bh=FFoUUgLLLnHrVHSgZKdGWrj/Zzc/IjeI8odU81fBw/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=HU3tvatC8PoXf7GTmWqwI8LVtPCYg1iADMLd9OpZIYQCmrKGAIaccUJVHGjEKc1IDCZqmjaFNJhIO2kj1Cs2piCZW65x4+mUL8iF88K+aCfI0CZoiMYXqs41QfR3h9VQ9KfLBpeEset30WBBeCkp28NZOVsmV0BMq8Sxq0R7hJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=YVIWWUan; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623JXPIC2954747;
	Tue, 3 Mar 2026 11:47:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=m68iMg/79Z0vCiOI+k
	qMHYeljiIZfBGvftBHgaVVOeM=; b=YVIWWUanEgiGkJMETK4zN630npw0FbBC3U
	oQyvLk40O+X6hcIqOPbmGoNClSQnFkjQKAZ+HFgrTNliv7GYr3iInwhfywxtamGM
	YiRwI2tASNxaVFhAHa79sMICpJP78uxMK3SyTKNpaQ6dGndMUD8qQ5PrEG+okvN7
	FnHOVoP+59m/vvDBaeQFru7q+MjgzwG5QPYzIAFbEj1MQAKhSrIjzJiJ0kztJclT
	/u8C9/jPKucw4Eapzjy4tFVBDT5D3BwVmloTuC5xj7jyKAEVKzoffzfYayl30L19
	iXiFnpePzkVlAvC90L6yXkcw9Imq7cfLsjsuEgsaK4nHmOTUQVvg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cnmv6j15h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 03 Mar 2026 11:47:02 -0800 (PST)
Received: from devgpu015.cco6.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Tue, 3 Mar 2026 19:47:01 +0000
From: Alex Mastro <amastro@fb.com>
Date: Tue, 3 Mar 2026 11:46:24 -0800
Subject: [PATCH] vfio: selftests: fix crash in vfio_dma_mapping_mmio_test
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260303-fix-mmio-test-v1-1-78b4a9e46a4e@fb.com>
X-B4-Tracking: v=1; b=H4sIAJA6p2kC/x3MTQqAIBAG0KsM37oBTYrwKtGicqxZ9INKBNHdg
 94B3oMsSSXD04Mkl2Y9dniyFWFex30R1gBPqE3dGmccR7152/TgIrlwcFNou86aJjpUhDNJ1Pv
 /+uF9P2UhKXRfAAAA
X-Change-ID: 20260303-fix-mmio-test-d3bd688105f3
To: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>,
        Shuah Khan <shuah@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alex Mastro <amastro@fb.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE2MSBTYWx0ZWRfXyaE+9Xv1KlcK
 x3/KO4YR3HP5sOcpVKGyVm6ByirgHFez3b5NBTXBeHLYtcP/RxHTybvucz3R37kTi7FYml/7gld
 SaFluTQZwQ4TKdjmG6uSLAzQb0og5D+0XxfCnqO4paZ9qHX8nGD32vbAtrkJmI6ET6MkZlYqc6R
 XiW4YAxh5FLQB692B6yVltvxKZEocdq1f9RbHymqnkMZgSmxp5/kODZ7H5jkss+qvOL7anODQnm
 b+KbeZmiFeVKlUxZNCTe1YpbuRVXq80itk18HSg10SF6TlYOyRdAE07Fm2xhLk9NGiwAAVM64p8
 kEFxOby4JXE1J0imPj+0hUnA5t+GSLMPd4soFMlea6n48wBXK/iEXaHZR0GJSZo84B55xhSXRGl
 5d5UJG8PL5U+Wqgm8+cu2my5DABvWtAwYuQZa9El5rEF+8TTfjaAEB0gxSw5KPl3RrBO4sETjpe
 lGlgMrwSsue04kjT9Uw==
X-Proofpoint-ORIG-GUID: E2ILvsxEFhCI6XfJ4tVKyhV7SvGNzNup
X-Proofpoint-GUID: E2ILvsxEFhCI6XfJ4tVKyhV7SvGNzNup
X-Authority-Analysis: v=2.4 cv=eJceTXp1 c=1 sm=1 tr=0 ts=69a73ab6 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=7x6HtfJdh03M6CCDgxCd:22 a=8elwO82fXORLTBIkMd32:22 a=FOH2dFAWAAAA:8
 a=v1GANntm_XrVRo8nrZIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_03,2026-03-03_01,2025-10-01_01
X-Rspamd-Queue-Id: ACDEB1F6581
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[fb.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[fb.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[fb.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72594-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[amastro@fb.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,fb.com:dkim,fb.com:email,fb.com:mid]
X-Rspamd-Action: no action

Remove the __iommu_unmap() call on a region that was never mapped.
When __iommu_map() fails (expected for MMIO vaddrs in non-VFIO
modes), the region is not added to the dma_regions list, leaving its
list_head zero-initialized. If the unmap ioctl returns success,
__iommu_unmap() calls list_del_init() on this zeroed node and crashes.

This fixes the iommufd_compat_type1 and iommufd_compat_type1v2
test variants.

Fixes: 080723f4d4c3 ("vfio: selftests: Add vfio_dma_mapping_mmio_test")
Signed-off-by: Alex Mastro <amastro@fb.com>
---
The bug was missed because the test was originally run against a kernel
without commit afb47765f923 ("iommufd: Make vfio_compat's unmap succeed
if the range is already empty"). Without that fix, the unmap ioctl
returned -ENOENT, taking the early return before list_del_init().
---
 tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
index 957a89ce7b3a..d7f25ef77671 100644
--- a/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
+++ b/tools/testing/selftests/vfio/vfio_dma_mapping_mmio_test.c
@@ -100,7 +100,6 @@ static void do_mmio_map_test(struct iommu *iommu,
 		iommu_unmap(iommu, &region);
 	} else {
 		VFIO_ASSERT_NE(__iommu_map(iommu, &region), 0);
-		VFIO_ASSERT_NE(__iommu_unmap(iommu, &region, NULL), 0);
 	}
 }
 

---
base-commit: 96ca4caf9066f5ebd35b561a521af588a8eb0215
change-id: 20260303-fix-mmio-test-d3bd688105f3

Best regards,
-- 
Alex Mastro <amastro@fb.com>


