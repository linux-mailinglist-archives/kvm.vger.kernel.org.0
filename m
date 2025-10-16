Return-Path: <kvm+bounces-60198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D41FBE4DF2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF6775E1019
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547DB22173A;
	Thu, 16 Oct 2025 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b="W++12eaC"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.st.icloud.com (p-east2-cluster2-host3-snip4-10.eps.apple.com [57.103.78.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC4E22129B
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.78.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636304; cv=none; b=YB9r+AGlsKS9BiRiipChX/VxNd3/zWz+eAtkWP8SeMK9hT/xrYv5+0oXbHMsXo+rhZ4WbIfyu80EoJ2XOAtW4G2xx8kv++ymS3Ivonql851xbP9Ohdq6IjbV/19n83HRoQstnCjOaaEgXuyrjfemB5Z0zuQS/HRWiEbmVW2sz3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636304; c=relaxed/simple;
	bh=Std8vhl5XVqnH6KDZNU5jTMgCSlZUu668RDV5S6M6M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCmCnGfiABHlAdAgerUo59NHGJiB4w8cjEBebhT4sC7Ia5VbgGI1HK6L8+0UB68PWLqzLreAX8SLeEQhlnsqfyNikBwvoI3Vw1Uj+bq45IFj+YghBYd3V1WoMwJzO2AwQZOMnXtS2MoyxxJcH5tdOMhPoJ5wqbD1K5ZYC15HE3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr; spf=pass smtp.mailfrom=unpredictable.fr; dkim=pass (2048-bit key) header.d=unpredictable.fr header.i=@unpredictable.fr header.b=W++12eaC; arc=none smtp.client-ip=57.103.78.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=unpredictable.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=unpredictable.fr
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 6EE051800119;
	Thu, 16 Oct 2025 17:38:19 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unpredictable.fr; s=sig1; bh=lE935EhSo6eiiRGBTf1TCzdO8HBh375WWDyS664DB/c=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=W++12eaCy96hQ9x+mbUtcmZUoDvKj+5sPov5MvuBlgxYfTHNGz3omeu/jfUHRuvonAq++9ZzkIlGvPvAHTu5iukjNUUV/jvJrsgqQmIoBmlSf4dPl8NwVnIXhvzjIl8P1GWrAWXp3BZJLA2rIGiAzbNNYNelcWIk7COPSQuY2XSOIW9qF35d6E8aM2qlqbNFs2ctCFu6slZgYDbPcD3kg+68JtWbxPzubAkwT1fbKrphcvGJuJawqYKQg4xN8Q7rkSSW2iAMaQY4ACGml4qJL42lMr6PBuTRocu/ptN5knWPLaOzMrjzJdtnm7hRFsdMa3laC9gw29HVFf5E5HmVTg==
mail-alias-created-date: 1752046281608
Received: from localhost.localdomain (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id B39F318000A8;
	Thu, 16 Oct 2025 17:38:15 +0000 (UTC)
From: Mohamed Mediouni <mohamed@unpredictable.fr>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Igor Mammedov <imammedo@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Pedro Barbuda <pbarbuda@microsoft.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 03/24] qtest: hw/arm: virt: skip ACPI test for ITS off
Date: Thu, 16 Oct 2025 19:37:42 +0200
Message-ID: <20251016173803.65764-4-mohamed@unpredictable.fr>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251016173803.65764-1-mohamed@unpredictable.fr>
References: <20251016173803.65764-1-mohamed@unpredictable.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE2MDEyOCBTYWx0ZWRfX749a2SXYeHr3
 J5opij+NZ8W1L3rLUkZizWfNE1oh3Mx1jrncl/LyfcYXPBobM10lkJGai7DS39UTdV9U0MoL5W3
 JnjznS5+w70uWLEIRvWT3cTPPnXw6d6VKVQByzghN3O3r2R6ca3IdTVXSPOy/BFa3XUEWdOlyz1
 zWZoMewIH0ZYg8OH6BmjEAxuYtpxGT66CuvYf4HZl+7sB9yF4RJq7TP0jRUU2JD4DCT95tPa347
 G8A8JDzM9cYHtnkVfZkIeiSf5mKZ43VafG6olAqocq4o80PJXUNbhVhc1RfDPDAJwURcjAkCo=
X-Proofpoint-GUID: SKxZss3_oV4GvMKJxKSlK1Dpi1Nwz3gF
X-Proofpoint-ORIG-GUID: SKxZss3_oV4GvMKJxKSlK1Dpi1Nwz3gF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=982 mlxscore=0 suspectscore=0 clxscore=1030 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506270000 definitions=main-2510160128
X-JNJ: AAAAAAAB8gRNF0hAdUMpu6gHhQeAPZFTUpHzUwdjfRuA1QHQU2+1roDqpXUA+Iz24pM0SS1sj2TNTl9ihTh5Yjp8dyUI/BwdGC6FIjH27Mvl2/TwgDcZnsdH3XTWRVewenvNGTxmwiFTBlqlRkP0is8SOZmr+cbhxCQqn4FDKWg7gSe/XQWcB/rZSsxiL6stjA6NQYPnjMikbP17puQssDEavPtY5Pmr+lK3vjKyJ4BeJChw90+oVud0HAbeIxXQI5+zfY15WDSh2nzCZe4ThQDrkC6f9f/tRXC15QjMl3SJ4RnAfAYkV0LmHl5AEp/OfB1B8LDxwYWHiAvlJZz3awEFMnLVUCrytLa2yvmMcr7uXZT1Km693S7g0DhSAn93MDYW56upxhsGp8cQpxbvT2BON99oajiS4cj6VKWdLoP/7GFd0WSolrXUufLRKCjRU84IYU4gMJc0pn1xj6YSZkL6hnM25uX3vpoaI9xL/mOvHZxS5RDBEgNfsW+Emk5BDZ33bNQ1v/lHf0d+viheTezE5vUq+O2DyCGnedr7PPST6SHvkV8SqCGYwVzPpRjvEdhFi/TTFfY9mrAivjaxCG8S10OeRaY9miQY7OWqKbl61t26sfPQtAC4FbQ+7GZe26mWErn7Ye+fIFzdRRFuRftWqwlILSikjbfG7trasNAztRJd6IX6X3/gvlzLFE04ZfcR4Jg7QLkiSA8fjvFszl4v2PZIGmt3HwqS+TqMQI7ZuApr8I4GmTSziUB7oFniId2Y9qc1+96Xfx9L8K3E1yMRkAccZinU9gv/jAaDE0OXRtf9gjzdO3Q0F89/g/fA2F8vM5A7rHkUMjthuLEaxXcRl4FcEaq5Uiw8hnhPmB8sUjtobvwvvNAz0nzaE58z8BQydTV7QObrEyNQHRoGwjrY/lzg

Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 tests/qtest/bios-tables-test-allowed-diff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/qtest/bios-tables-test-allowed-diff.h b/tests/qtest/bios-tables-test-allowed-diff.h
index dfb8523c8b..bfc4d60124 100644
--- a/tests/qtest/bios-tables-test-allowed-diff.h
+++ b/tests/qtest/bios-tables-test-allowed-diff.h
@@ -1 +1,2 @@
 /* List of comma-separated changed AML files to ignore */
+"tests/data/acpi/aarch64/virt/APIC.its_off",
-- 
2.50.1 (Apple Git-155)


