Return-Path: <kvm+bounces-72154-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLQyHEWhoWnEvAQAu9opvQ
	(envelope-from <kvm+bounces-72154-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:51:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA46D1B7E73
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 14:51:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1FCD8306BC26
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E5426B777;
	Fri, 27 Feb 2026 13:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XR3vXfwI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B/K+9RLO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBDF3F23D2
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772200243; cv=none; b=aRBxKzYAcbCPg1WjX+px9P8NIuQE04xfZoQ2otseUU6FV0QIVdLDd8192DgaJa6MUBunNzN+QGrKgN/XuzgScayktH8ue8uKxqeFuyZSThgSvSGEP/tMdJZvuF1uNiwfMlpggz8MPCJ2mvyja4h4/xXKJev+q7zWtP9RoYZalqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772200243; c=relaxed/simple;
	bh=c0baeBiKFtNIsavdttVW3dygLzDcANxJx5K2Q81vcXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LMWXD+G4jVrcFgXmk6WUsQ9Ny3fHleSLMizZORlPrxdZIfcnnoKOBlkBnkv+fs0GblRAE5+1j2b4yvXBqUMv1Bf8uQL+Qr378rSMUVM+aOaSpABJ9yf+Fb0JN0C2lpHwWQFpXWIwkMOGAxajvxCfNOQoewWFlrgXBLid1F2FzlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XR3vXfwI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B/K+9RLO; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RB4TK33484289
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:50:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=UCqPGnCmWVQCsvHc/I8KF7
	mIauDPj2v0RjbE6kW19F0=; b=XR3vXfwIypu+k3TAlyzhOMwyBXzSoy3roAsh08
	jyjRjY0elVLYz5y8pD+WyB/LhJLYpXfDYRT9NEqFEj3UpgeZoLFP1MSsPx/D0OD0
	mZqZupUhNcV1IhlGRYWgmVoq0yq3IcSeA9jwIw7/7CBhQlqvTZ7HYjcfkXl4dpop
	/x5aD+b/GfUt9DVbz8AIXlSEPC+z+wnNkoCBhxoWnNHsDuS3cfYYT3nLRdxb6fgU
	MOjGevHIjTCdJ2MYtCrmw24aZrbPk4GpryBFDNSVcIxEK3Q0s6IhEP9HCndZOUAh
	nHWVZXarrQP5qyGOBFTOrCOh6Vy6P/UFD6T7Rt1BN7nCFFRg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cka2xgf2r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:50:39 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c70fadd9a3so1927279785a.0
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 05:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772200239; x=1772805039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UCqPGnCmWVQCsvHc/I8KF7mIauDPj2v0RjbE6kW19F0=;
        b=B/K+9RLOUULiRka65uzwUEZgWfA8Y6jhCSQ1mK3nyK4p0D6ktaNEeqZ1RBhBKFIJ9d
         PtJJnnL0WJNnD4Cl8nNB0bKGeHsr6X+KUaL8EgVb2nUqBnXqt0v7Ed3RqYMvntwhVJaC
         vfRRo9WMY9/Hr4okHg8ggqYASZfSXlguAT+eESx7KU7wFlPCPbsYUPzDMfv+OOKlbCmO
         1HQl6X7KtxX4K5SYyati/qkuGWH6AnAdR7HD031QN6k6OmTQ0ilKY7hZ9AjP1k/cHweo
         Sldyo8GrkPYDYszMr5RdE0xR2ZgSTvE6lVLDWt9FbO/q20AlH9nN4Bkc44GVsMWsToVW
         llDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772200239; x=1772805039;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UCqPGnCmWVQCsvHc/I8KF7mIauDPj2v0RjbE6kW19F0=;
        b=ArMohZZK6o/ICDMlvWT7EdzgoKTP62KrhBtpJtI6Q3QCpbRyNkTkdGdFoa5wSFRnzX
         bubwq0ikf6CRPIlX3J2S1O1+nc3jxcjB4D6OVAhKha0KTtLM94vd7uwO7p0iPph+VVpL
         AtCMFwpENfErYYziUhvQPGD5qT69kjO/17PVGGrJ93Bq1cD0JBDrqn5Gsc8AJFR+erDG
         pX4+zFyc341WBIy/DlUJYDZ4KdcY8QOsq9Af70DT9FLnkwMQrvHNmsL9bE0umLqjkZjx
         o1q5U4ackHHRHkP2EDJ3Q8JXsWf9LQIIMFtOo4Y0h+fS7/pDlUVXtccIj7OM10uujAb0
         eL6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/dYDL9dwvdPSIyAEWPjWVcnp7slDfuSMXuFZf0YG4u3ttBYHBMgvGruG5XLBNfDdPEqM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZqX7umDrQcAnZYg/uYqTPYPeAcP5pICf31xDW30detlOpp+Ou
	ymizt/1VqPN9CPtREl5LlNJegX0J/A6F1QOc4TqjFArXVvnytC3pzz81z/nAVibbCv2xNJOf5ta
	IwzlLEt8BpEjc0C9Jopf+YEvCfixYa+Gw2Onw/H8eTzo2AXTre2bbbUk=
X-Gm-Gg: ATEYQzygpnpe2k/StD8fIqRuHo+SXredxErlEJnwQxjwf8E4wU2CABf0ov/IlcTeXMw
	msl8oH2n1ODFiPMnx1SVWY1AaFKloToTjlQHcW9lWbNKe4S9fYKi2fi5bLziO5F79HtIL1pjacU
	mAjeAa2p0dBCDN4QJq7OepCCnTGsSy3WOuKuFtK39X8a8LH7Pe/NmfcznoP7DIDJ857Ql8KAW7U
	j+IGw39U+kCea9oaoqph35yDn+JLQ+8/2TjUOoeH3n3/gzKE96C2ewEId+ALqaNKJht+rYEUL+1
	zKmzAkeOIYA/gvNyVLBBs3Diti97O9XMn3ONYCZ8Ypz6HVRB92lwLUhsEKLl4pXMJlrPO5yaAYY
	kvRpOG0YZxmFo4SO1n/SZaHL9/N68BNurXc2quVUJ4G8Z+Eu5LYtUQMhJw1Tx
X-Received: by 2002:a05:620a:28c2:b0:8c8:8126:7770 with SMTP id af79cd13be357-8cbc8e7b3e4mr334774085a.67.1772200238886;
        Fri, 27 Feb 2026 05:50:38 -0800 (PST)
X-Received: by 2002:a05:620a:28c2:b0:8c8:8126:7770 with SMTP id af79cd13be357-8cbc8e7b3e4mr334771285a.67.1772200238459;
        Fri, 27 Feb 2026 05:50:38 -0800 (PST)
Received: from localhost (ip-86-49-242-13.bb.vodafone.cz. [86.49.242.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935aec7091sm149414866b.58.2026.02.27.05.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 05:50:37 -0800 (PST)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <radim.krcmar@oss.qualcomm.com>
To: kvm-riscv@lists.infradead.org
Cc: Lukas Gerlach <lukas.gerlach@cispa.de>, Anup Patel <anup@brainfault.org>,
        Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] RISC-V: KVM: fix off-by-one array access in SBI PMU
Date: Fri, 27 Feb 2026 13:46:16 +0000
Message-ID: <20260227134617.23378-1-radim.krcmar@oss.qualcomm.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=BOC+bVQG c=1 sm=1 tr=0 ts=69a1a12f cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=9tUHzIdeCh+UoOnba06Qjw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=9SFidOni61YWn9SpgYUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-GUID: AWuGiMSHBOw3IN7-SO8bBDea1a4tl-M-
X-Proofpoint-ORIG-GUID: AWuGiMSHBOw3IN7-SO8bBDea1a4tl-M-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEyMyBTYWx0ZWRfXwVvXD2xhcZyl
 vw+6CaM3fHyqvz8atPK9uNXUPlgh7p/JxwzJqxN9OrayA1B7j3vylslrUu0flxBGT6b3Ia9dQFR
 GYlolZ4YXBeFY2mQmOlLzLrfi5A838SMGLL9ww4i2AKew+j0sqp7DIX2HynmgVSqQf8XlNyBTFY
 hxk1BmU3+kTmkLAGd37FW9jE8utKO/eUCkm+8S1c6aVbExN71X3ohZsKZjbgXdGGzAujPUR73KT
 gFVMTxoaVbW9xcu0EsFn7BF+MIaAIHXAIS9PExD9kP1bzIrWnP5e9hw3CFmD9RtQHM1gl5RRNk8
 k3dSQrYnb6IBErDF9HkatZJhw2RPpQhNSV9KHnK+cf6av9/wO8NHUO/XmhKuUd08zlbcZpPeVTm
 ik2G6BjSga6yPXr6GbSn1rk4IO6+hcRfV2RbD0yRiKxJGf7oKY4PcVT4S9awe2alparCpkmnh20
 BMmK7o0KITZdJDPVC5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270123
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.22 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MIXED_CHARSET(0.94)[subject];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-72154-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oss.qualcomm.com:mid,oss.qualcomm.com:dkim,qualcomm.com:email,qualcomm.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[radim.krcmar@oss.qualcomm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: CA46D1B7E73
X-Rspamd-Action: no action

The indexed array only has RISCV_KVM_MAX_COUNTERS elements.
The out-of-bound access could have been performed by a guest, but it
could only access another guest accessible data.

Fixes: 8f0153ecd3bf ("RISC-V: KVM: Add skeleton support for perf")
Signed-off-by: Radim Krčmář <radim.krcmar@oss.qualcomm.com>
---
 arch/riscv/kvm/vcpu_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
index 4d8d5e9aa53d..aec6b293968b 100644
--- a/arch/riscv/kvm/vcpu_pmu.c
+++ b/arch/riscv/kvm/vcpu_pmu.c
@@ -520,7 +520,7 @@ int kvm_riscv_vcpu_pmu_ctr_info(struct kvm_vcpu *vcpu, unsigned long cidx,
 {
 	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
 
-	if (cidx > RISCV_KVM_MAX_COUNTERS || cidx == 1) {
+	if (cidx >= RISCV_KVM_MAX_COUNTERS || cidx == 1) {
 		retdata->err_val = SBI_ERR_INVALID_PARAM;
 		return 0;
 	}
-- 
2.51.2


