Return-Path: <kvm+bounces-13240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640B98934FE
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87E31B23E74
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B949A16F856;
	Sun, 31 Mar 2024 16:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nc26yfw6"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E11448ED;
	Sun, 31 Mar 2024 16:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903645; cv=fail; b=mona1TqqQ7mOm1dx0CL0K3EMWWnqnTfZYUsJqv0HbXpDD+q3+x9m/Re7BJaZVRHTojMwquuzOgDs3BwsrsjdY/9yAP0SIx5JjT5+nEe7rTuWUweiILgD6aZa67HPqoUF74ZmPWZEhwVXPsv0EpDEZL4ZdJ6/R3q1X9qCqgp/iGY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903645; c=relaxed/simple;
	bh=EmOm5p9QtgZUdS5mUEG5ayNTbU9p+fjJ6Tihs+vvPDo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=crnewibE8YFU+U3oIcPXVs06uXUa3YMh10H5aFGMgXEQ/s0CG08P5NsDC6WmdHKktgXVVDU23yRg5cuQ8GTDUsgtNuwdh+Rq0Y+ZYH2Lw2zK3Cm60rvII94nz/lCvodQiKXMZ85xuh+oo/NUVKlO/7YE7ENBRcYzx953nFaqMb0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nc26yfw6 reason="signature verification failed"; arc=fail smtp.client-ip=40.107.244.41; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 5BA1E201C7;
	Sun, 31 Mar 2024 18:47:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KfeBO4mkHbi4; Sun, 31 Mar 2024 18:47:16 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id F380620728;
	Sun, 31 Mar 2024 18:47:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com F380620728
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id A9999800051;
	Sun, 31 Mar 2024 18:40:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:40:15 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:36:18 +0000
X-sender: <kvm+bounces-13115-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
 NOTIFY=NEVER;
 X-ExtendedProps=BQBYABcARgAAAJuYHy0vkvxLoOu7fW2WcxdDTj1XZWJlciBNYXJ0aW4sT1U9VXNlcnMsT1U9TWlncmF0aW9uLERDPXNlY3VuZXQsREM9ZGUFAGwAAgAABQAMAAIAAA8ANgAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5EaXNwbGF5TmFtZQ8ADQAAAFdlYmVyLCBNYXJ0aW4FADwAAgAABQAdAA8ADAAAAG1ieC1lc3Nlbi0wMQUADgARAEAJ/dJgSQNPjrUVnMO/4HsFAAsAFwC+AAAAsylSdUnj6k+wvjsUej6W+0NOPURCMixDTj1EYXRhYmFzZXMsQ049RXhjaGFuZ2UgQWRtaW5pc3RyYXRpdmUgR3JvdXAgKEZZRElCT0hGMjNTUERMVCksQ049QWRtaW5pc3RyYXRpdmUgR3JvdXBzLENOPXNlY3VuZXQsQ049TWljcm9zb2Z0IEV4Y2hhbmdlLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9c2VjdW5ldCxEQz1kZQUAEgAPAF4AAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IRjIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249V2ViZXIgTWFydGluOTU1BQBHAAIAAAUARgAHAAMAAAAFAEMAAgAABQAWAAIAAAUAagAJAAEAAAAAAAAABQAUABEAm5gfLS+S/Eug67t9bZZzFwUAFQAWAAIAAAAPADUAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LkRpcmVjdG9yeURhdGEuSXNSZXNvdXJjZQIAAAUAIwACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNlU3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8AL
	wAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW5zaW9uBQAmAAIAAQ==
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAm0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc29mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAAAAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAGAAAAG1hcnRpbi53ZWJlckBzZWN1bmV0LmNvbQUABgACAAEPACoAAABNaWNyb3NvZnQuRXhjaGFuZ2UuVHJhbnNwb3J0LlJlc3VibWl0Q291bnQHAAEAAAAPAAkAAABDSUF1ZGl0ZWQCAAEFAAIABwABAAAABQADAAcAAAAAAAUABQACAAEFAGIACgAIAAAAzooAAAUAZAAPAAMAAABIdWIFACkAAgAB
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 35915
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=139.178.88.99; helo=sv.mirrors.kernel.org; envelope-from=kvm+bounces-13115-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com B67EB208AC
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711753215; cv=fail; b=fjdA/KPuC/sIeqaVY0oi6TFRyIES80fOAdBPMtaMQ9A82xaK722jPMpDP5uRpw1TDRnbpyFznjP9/Wx21YefB827hdm3kEvIx74zjcXiunSTLqHcgzJwIztYjf1ofsZc2kKi6AWLKfuspBDhUx8scQLyGT8+MjjyUfS7WXaUfwc=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711753215; c=relaxed/simple;
	bh=GxarBB3QQXDtAmxKX8+rgDQfQVE3hghOjKcRWraa+k4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HsE8q9F6LYfYnMlfLKuLnv9O+oEuUbw9RNotxN5x8lROSKV36F8erowkx3T8A7TuDXzr6O+kU4CrCEBqJ710cdP0htYrMyVI1mRWa6lOwWkBhSGSmyBwm2ctHe9IpUAvbJoSHIn4mjehfry30ZOKzrAsZESfAH+1dlC89lUeS94=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nc26yfw6; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BElzFv0DBW0MUfZQD8UJs5q9+EA6fwy/roXbmEq+TK27HwkmLuLGaSnZEaC4z7LizwxFP+9CcgtZSYe3Ii/x3Qmyx2+qpZC8UzOKYuThs/JgABKZIcsDlHgXuf91vyYHD+eNeDFavLFzfMdZo2aHfXt6nbKGXqbANG1fHpmqqa/XuV/gj8KYH5rwG+G2KsejSM58/o+SoRJo4tf0r7lMElBZNkVB7ERvDWxQuuE+2+oUQLMCIXrnckx38ToRkbf0LSv3pwmBSoITpf9FxRved2imYa055K8dViM8qFqfybVrwd9UIQYfHaZdKZ1RO+Q8fGV/oNpLYiqpqYBgwaOOtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=;
 b=napnASBwyJG2prTZxam5z33xxl91ON59wzWY5AlObaNMOHV0cnd5AXmXzslMwl1QfB6IKjCNbGRvKeaSztlCXq1EJmJRKNxP/QGz33VOQxT6Ba77MSmZ9Gvharo7064GKpA8UYIMK8cOKZHtCpeZ7KJoUep/ZNRgl6SMVToBBAzcZaOe+6QjxVtGP0/o8HuSAW/+wy96FFUxfFexc0D6205fpRzXzn5uVuIzoZMwGPSHuh88nLjcONk5HXY29Ev4ytXUbmwKtvwDnx/Q0QAqKpocUh5NtX8894m8J5EScyJE5OVIw+bypKeljQQaBmiv3JPmTl+HzucpKl9Fw5SmNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=;
 b=nc26yfw6BEddsMoLxmBknQWv7NoJVdW5TsUPbDB5WD56lIuKOC7ktJ7shNNMaS3nlkqYjDppMlO0nis5MV9UNDgd2MVhA+tVr1V4K8Zjyb8ngbfZX76ombAOPObrwYT1QJa3l86MicBWrhhigVCjwXVrKkwqgm6WOguSMG1TIU0=
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Fri, 29 Mar 2024 17:58:17 -0500
Message-ID: <20240329225835.400662-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: c27c7199-0608-4e58-824a-08dc5043fc68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CPhwmHFRTbcoEsG1eJurOstXAgzf72Ze7qRd5sd1y6H95KtLVWAy00ly7s0y7UOv9/Fa0d8LCHeobZEAV2wMHMBwvDPt5XAgtaP9QWZ+6Pr3bZziTFcZgcMbr04m8pJ+cA9GwKvf6S/OMzrLt1uriEl9sVG2Bf4VpxzIMljD40wtDfDmpx31u8s23d/bIMGv6jQFVj3JsuuUr7+HOjkJs/H2mEbB7cC3VTL0Er3ZMCNT6/L4bqA37k9zeBppe0b5nePPH2UflxHzfh4xMNZ6ttcvsy6mHWLMBExEFEIQhgQ1TOSYMs8niYK+J7Io8C7NWgJtTPqSs9KwMJTb6+9bCVfzJj/ZLfHIJofmlifP5hfGvMx93ymUl3BiC9gNvHQiHNEoEJzJao3IpwR3tvvhnaU3WR7e+uryr7q7iOu9+JcYiXmTkCvbv2nJKeo8lbfwacgdTl6AOMDpdHAitMLR2yKnrPiwH9iJqUttjiJRr0tl6Nw0MUpWYJdQmvO2WKorsDgqWLh1Kh7yCTmsLHo3/F5EQ95LrJUpo/oDYlT4Y8rCFA8M/0cQ/BoREHUAEIJf31yyt0jDtOkCL3L4IuUvAGqIRGTU2nEaPf0gSnJ2SZa7+lm1s/2tb6l75eI+PLBLm7LdN75fg4zFqX9400AtenkM7z03+WcUgV0uQT6QARZn2e8eElJMYIpPr3dLb7aqYFKckjQdmJgdLdQvqbbyTfg7fdW4eBNPlSyVZ81qEcbrDLftDw463QUQ57VRGBO
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:10.6256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27c7199-0608-4e58-824a-08dc5043fc68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 211 ++++++++++++++++++
 3 files changed, 265 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index a10b817c162d..4268aa5c380e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
=20
 See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
=20
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provid=
ed
+data into a guest GPA range, measuring the contents into the SNP guest con=
text
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that G=
PA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it =
can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had th=
e
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentati=
on
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encry=
pt data into. */
+                __u64 uaddr;            /* Userspace address of data to be=
 loaded/encrypted. */
+                __u32 len;              /* 4k-aligned length in bytes to c=
opy into guest memory.*/
+                __u8 type;              /* The type of the guest pages bei=
ng initialized. */
+        };
+
+where the allowed values for page_type are #define'd as::
+
+	KVM_SEV_SNP_PAGE_TYPE_NORMAL
+	KVM_SEV_SNP_PAGE_TYPE_ZERO
+	KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+	KVM_SEV_SNP_PAGE_TYPE_SECRETS
+	KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
+used/measured.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 350ddd5264ea..956eb548c08e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -695,6 +695,7 @@ enum sev_cmd_id {
=20
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -826,6 +827,20 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
=20
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c7c77e33e62..a8a8a285b4a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -247,6 +247,35 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
=20
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data =3D {0};
+	int err, rc;
+
+	data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
+	rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ON_ONCE(rc)) {
+		/*
+		 * This shouldn't happen under normal circumstances, but if the
+		 * reclaim failed, then the page is no longer safe to use.
+		 */
+		snp_leak_pages(pfn, 1);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc =3D rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2075,6 +2104,185 @@ static int snp_launch_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
 	return rc;
 }
=20
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, struct kvm_memory_slot =
*slot,
+				  gfn_t gfn_start, kvm_pfn_t pfn, void __user *src,
+				  int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args =3D opaque;
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	int npages =3D (1 << order);
+	int n_private =3D 0;
+	int ret, i;
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	for (gfn =3D gfn_start, i =3D 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args =3D {0};
+		bool assigned;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute =
set\n",
+				 __func__, gfn);
+			ret =3D -EINVAL;
+			break;
+		}
+
+		ret =3D snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared s=
tate, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			break;
+		}
+
+		ret =3D rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to convert GFN 0x%llx to private, ret: %d\n",
+				 __func__, gfn, ret);
+			break;
+		}
+
+		n_private++;
+
+		fw_args.gctx_paddr =3D __psp_pa(sev->snp_context);
+		fw_args.address =3D __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size =3D PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type =3D sev_populate_args->type;
+		ret =3D __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UP=
DATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret) {
+			pr_debug("%s: SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n=
",
+				 __func__, ret, sev_populate_args->fw_error);
+
+			if (snp_page_reclaim(pfn + i))
+				break;
+
+			/*
+			 * When invalid CPUID function entries are detected,
+			 * firmware writes the expected values into the page and
+			 * leaves it unencrypted so it can be used for debugging
+			 * and error-reporting.
+			 *
+			 * Copy this page back into the source buffer so
+			 * userspace can use this information to provide
+			 * information on which CPUID leaves/fields failed CPUID
+			 * validation.
+			 */
+			if (sev_populate_args->type =3D=3D KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+			    sev_populate_args->fw_error =3D=3D SEV_RET_INVALID_PARAM) {
+				void *vaddr;
+
+				host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+				vaddr =3D kmap_local_pfn(pfn + i);
+
+				if (copy_to_user(src + i * PAGE_SIZE,
+						 vaddr, PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+
+				kunmap_local(vaddr);
+			}
+
+			break;
+		}
+	}
+
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, undoing %d populated gmem pages=
.\n",
+			 __func__, ret, n_private);
+		for (i =3D 0; i < n_private; i++)
+			host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args =3D {0};
+	struct kvm_gmem_populate_args populate_args =3D {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	unsigned int npages;
+	int ret =3D 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
+	    (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages =3D params.len / PAGE_SIZE;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
+		 params.gfn_start, params.gfn_start + npages, params.type);
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot =3D gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd =3D argp->sev_fd;
+	sev_populate_args.type =3D params.type;
+
+	populate_args.opaque =3D &sev_populate_args;
+	populate_args.gfn =3D params.gfn_start;
+	populate_args.src =3D u64_to_user_ptr(params.uaddr);
+	populate_args.npages =3D npages;
+	populate_args.do_memcpy =3D params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO;
+	populate_args.post_populate =3D sev_gmem_post_populate;
+
+	ret =3D kvm_gmem_populate(kvm, memslot, &populate_args);
+	if (ret) {
+		argp->error =3D sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %d\n", __func__, ret);
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2165,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r =3D snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r =3D snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
--=20
2.25.1


X-sender: <linux-kernel+bounces-125490-steffen.klassert=3Dsecunet.com@vger.=
kernel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com; X-ExtendedProps=3DDwA1AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9y=
dC5EaXJlY3RvcnlEYXRhLklzUmVzb3VyY2UCAAAFABUAFgACAAAABQAUABEA8MUJLbkECUOS0gj=
aDTZ+uAUAagAJAAEAAAAAAAAABQAWAAIAAAUAQwACAAAFAEYABwADAAAABQBHAAIAAAUAEgAPAG=
IAAAAvbz1zZWN1bmV0L291PUV4Y2hhbmdlIEFkbWluaXN0cmF0aXZlIEdyb3VwIChGWURJQk9IR=
jIzU1BETFQpL2NuPVJlY2lwaWVudHMvY249U3RlZmZlbiBLbGFzc2VydDY4YwUACwAXAL4AAACh=
eZxkHSGBRqAcAp3ukbifQ049REI2LENOPURhdGFiYXNlcyxDTj1FeGNoYW5nZSBBZG1pbmlzdHJ=
hdGl2ZSBHcm91cCAoRllESUJPSEYyM1NQRExUKSxDTj1BZG1pbmlzdHJhdGl2ZSBHcm91cHMsQ0=
49c2VjdW5ldCxDTj1NaWNyb3NvZnQgRXhjaGFuZ2UsQ049U2VydmljZXMsQ049Q29uZmlndXJhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAOABEABiAS9uuMOkqzwmEZDvWNNQUAHQAPAAwAAABtYngt=
ZXNzZW4tMDIFADwAAgAADwA2AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmV=
jaXBpZW50LkRpc3BsYXlOYW1lDwARAAAAS2xhc3NlcnQsIFN0ZWZmZW4FAGwAAgAABQBYABcASg=
AAAPDFCS25BAlDktII2g02frhDTj1LbGFzc2VydCBTdGVmZmVuLE9VPVVzZXJzLE9VPU1pZ3Jhd=
GlvbixEQz1zZWN1bmV0LERDPWRlBQAMAAIAAAUAJgACAAEFACIADwAxAAAAQXV0b1Jlc3BvbnNl=
U3VwcHJlc3M6IDANClRyYW5zbWl0SGlzdG9yeTogRmFsc2UNCg8ALwAAAE1pY3Jvc29mdC5FeGN=
oYW5nZS5UcmFuc3BvcnQuRXhwYW5zaW9uR3JvdXBUeXBlDwAVAAAATWVtYmVyc0dyb3VwRXhwYW=
5zaW9uBQAjAAIAAQ=3D=3D
X-CreatedBy: MSExchange15
X-HeloDomain: a.mx.secunet.com
X-ExtendedProps: BQBjAAoAs0mmlidQ3AgFAGEACAABAAAABQA3AAIAAA8APAAAAE1pY3Jvc2=
9mdC5FeGNoYW5nZS5UcmFuc3BvcnQuTWFpbFJlY2lwaWVudC5Pcmdhbml6YXRpb25TY29wZREAA=
AAAAAAAAAAAAAAAAAAAAAUASQACAAEFAAQAFCABAAAAHAAAAHN0ZWZmZW4ua2xhc3NlcnRAc2Vj=
dW5ldC5jb20FAAYAAgABDwAqAAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5SZXN1Ym1=
pdENvdW50BwACAAAADwAJAAAAQ0lBdWRpdGVkAgABBQACAAcAAQAAAAUAAwAHAAAAAAAFAAUAAg=
ABBQBiAAoAEAAAAM6KAAAFAGQADwADAAAASHViBQApAAIAAQ8APwAAAE1pY3Jvc29mdC5FeGNoY=
W5nZS5UcmFuc3BvcnQuRGlyZWN0b3J5RGF0YS5NYWlsRGVsaXZlcnlQcmlvcml0eQ8AAwAAAExv=
dw=3D=3D
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 62.96.220.36
X-EndOfInjectedXHeaders: 35971
Received: from cas-essen-02.secunet.de (10.53.40.202) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:00:51 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:00:51 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id C46B0208AC
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:51 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -2.85
X-Spam-Level:
X-Spam-Status: No, score=3D-2.85 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_NONE=3D-0.0001, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dunavailable autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mq7LLScd9YAI for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:00:50 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D147.75.80.249; helo=3Dam.mirrors.kernel.org; envelope-from=3Dlinux-kerne=
l+bounces-125490-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=
=3Dsteffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com D255E2087B
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id D255E2087B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 594661F25574
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F097113EFED;
	Fri, 29 Mar 2024 23:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"nc26yfw6"
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12=
on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03713CF91;
	Fri, 29 Mar 2024 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.244.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753215; cv=3Dfail; b=3DfjdA/KPuC/sIeqaVY0oi6TFRyIES80fOAdBPMtaMQ9A=
82xaK722jPMpDP5uRpw1TDRnbpyFznjP9/Wx21YefB827hdm3kEvIx74zjcXiunSTLqHcgzJwIz=
tYjf1ofsZc2kKi6AWLKfuspBDhUx8scQLyGT8+MjjyUfS7WXaUfwc=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753215; c=3Drelaxed/simple;
	bh=3DGxarBB3QQXDtAmxKX8+rgDQfQVE3hghOjKcRWraa+k4=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DHsE8q9F6LYfYnMlfLKuLnv9O+oEuUbw9RNotxN5x8l=
ROSKV36F8erowkx3T8A7TuDXzr6O+kU4CrCEBqJ710cdP0htYrMyVI1mRWa6lOwWkBhSGSmyBwm=
2ctHe9IpUAvbJoSHIn4mjehfry30ZOKzrAsZESfAH+1dlC89lUeS94=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dnc26yfw6; arc=3Dfail smtp.client-ip=3D40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DBElzFv0DBW0MUfZQD8UJs5q9+EA6fwy/roXbmEq+TK27HwkmLuLGaSnZEaC4z7LizwxFP+=
9CcgtZSYe3Ii/x3Qmyx2+qpZC8UzOKYuThs/JgABKZIcsDlHgXuf91vyYHD+eNeDFavLFzfMdZo=
2aHfXt6nbKGXqbANG1fHpmqqa/XuV/gj8KYH5rwG+G2KsejSM58/o+SoRJo4tf0r7lMElBZNkVB=
7ERvDWxQuuE+2+oUQLMCIXrnckx38ToRkbf0LSv3pwmBSoITpf9FxRved2imYa055K8dViM8qFq=
fybVrwd9UIQYfHaZdKZ1RO+Q8fGV/oNpLYiqpqYBgwaOOtg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DRRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=3D;
 b=3DnapnASBwyJG2prTZxam5z33xxl91ON59wzWY5AlObaNMOHV0cnd5AXmXzslMwl1QfB6IKj=
CNbGRvKeaSztlCXq1EJmJRKNxP/QGz33VOQxT6Ba77MSmZ9Gvharo7064GKpA8UYIMK8cOKZHtC=
peZ7KJoUep/ZNRgl6SMVToBBAzcZaOe+6QjxVtGP0/o8HuSAW/+wy96FFUxfFexc0D6205fpRzX=
zn5uVuIzoZMwGPSHuh88nLjcONk5HXY29Ev4ytXUbmwKtvwDnx/Q0QAqKpocUh5NtX8894m8J5E=
ScyJE5OVIw+bypKeljQQaBmiv3JPmTl+HzucpKl9Fw5SmNw=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3DRRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=3D;
 b=3Dnc26yfw6BEddsMoLxmBknQWv7NoJVdW5TsUPbDB5WD56lIuKOC7ktJ7shNNMaS3nlkqYjD=
ppMlO0nis5MV9UNDgd2MVhA+tVr1V4K8Zjyb8ngbfZX76ombAOPObrwYT1QJa3l86MicBWrhhig=
VCjwXVrKkwqgm6WOguSMG1TIU0=3D
Received: from BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::3=
7)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 =
Mar
 2024 23:00:10 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::66) by BYAPR02CA0060.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:00:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Fri, 29 Mar 2024 17:58:17 -0500
Message-ID: <20240329225835.400662-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org
List-Id: <linux-kernel.vger.kernel.org>
List-Subscribe: <mailto:linux-kernel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-kernel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: c27c7199-0608-4e58-824a-08dc5043fc=
68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CPhwmHFRTbcoEsG1eJurOstXAgzf72Ze7qRd5sd=
1y6H95KtLVWAy00ly7s0y7UOv9/Fa0d8LCHeobZEAV2wMHMBwvDPt5XAgtaP9QWZ+6Pr3bZziTF=
cZgcMbr04m8pJ+cA9GwKvf6S/OMzrLt1uriEl9sVG2Bf4VpxzIMljD40wtDfDmpx31u8s23d/bI=
MGv6jQFVj3JsuuUr7+HOjkJs/H2mEbB7cC3VTL0Er3ZMCNT6/L4bqA37k9zeBppe0b5nePPH2Uf=
lxHzfh4xMNZ6ttcvsy6mHWLMBExEFEIQhgQ1TOSYMs8niYK+J7Io8C7NWgJtTPqSs9KwMJTb6+9=
bCVfzJj/ZLfHIJofmlifP5hfGvMx93ymUl3BiC9gNvHQiHNEoEJzJao3IpwR3tvvhnaU3WR7e+u=
ryr7q7iOu9+JcYiXmTkCvbv2nJKeo8lbfwacgdTl6AOMDpdHAitMLR2yKnrPiwH9iJqUttjiJRr=
0tl6Nw0MUpWYJdQmvO2WKorsDgqWLh1Kh7yCTmsLHo3/F5EQ95LrJUpo/oDYlT4Y8rCFA8M/0cQ=
/BoREHUAEIJf31yyt0jDtOkCL3L4IuUvAGqIRGTU2nEaPf0gSnJ2SZa7+lm1s/2tb6l75eI+PLB=
Lm7LdN75fg4zFqX9400AtenkM7z03+WcUgV0uQT6QARZn2e8eElJMYIpPr3dLb7aqYFKckjQdmJ=
gdLdQvqbbyTfg7fdW4eBNPlSyVZ81qEcbrDLftDw463QUQ57VRGBO
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:10.6256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27c7199-0608-4e58-824a-08dc5=
043fc68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
Return-Path: linux-kernel+bounces-125490-steffen.klassert=3Dsecunet.com@vge=
r.kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:00:51.8224
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: 260b5ce3-ecf7-489e-dffa-08dc=
504414e3
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dmbx-es=
sen-02.secunet.de:TOTAL-HUB=3D33493.502|SMR=3D0.324(SMRDE=3D0.003|SMRC=3D0.=
320(SMRCL=3D0.098|X-SMRCR=3D0.320))|CAT=3D0.061(CATRESL=3D0.023
 (CATRESLP2R=3D0.018)|CATORES=3D0.035(CATRS=3D0.035(CATRS-Index Routing
 Agent=3D0.034)))|QDM=3D10812.197
 |SMSC=3D0.011|SMS=3D0.413(SMSMBXD-INC=3D0.407)|UNK=3D0.001|QDM=3D20522.834=
|SMSC=3D0.219|SMS=3D5.705
 (SMSMBXD-INC=3D5.210)|QDM=3D2146.601|PSC=3D0.016|CAT=3D0.008(CATRESL=3D0.0=
07(CATRESLP2R=3D0.004
 ))|QDM=3D5.359|CAT=3D0.006(CATRESL=3D0.005(CATRESLP2R=3D0.002));2024-03-30=
T08:19:05.380Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-FromEntityHeader: Internet
X-MS-Exchange-Organization-OriginalSize: 23885
X-MS-Exchange-Organization-HygienePolicy: Standard
X-MS-Exchange-Organization-MessageLatency: SRV=3Dcas-essen-02.secunet.de:TO=
TAL-FE=3D0.054|SMR=3D0.022(SMRPI=3D0.020(SMRPI-FrontendProxyAgent=3D0.020))=
|SMS=3D0.032
X-MS-Exchange-Organization-Recipient-Limit-Verified: True
X-MS-Exchange-Organization-TotalRecipientCount: 1
X-MS-Exchange-Organization-Rules-Execution-History: 0b0cf904-14ac-4724-8bdf=
-482ee6223cf2%%%fd34672d-751c-45ae-a963-ed177fcabe23%%%d8080257-b0c3-47b4-b=
0db-23bc0c8ddb3c%%%95e591a2-5d7d-4afa-b1d0-7573d6c0a5d9%%%f7d0f6bc-4dcc-487=
6-8c5d-b3d6ddbb3d55%%%16355082-c50b-4214-9c7d-d39575f9f79b
X-MS-Exchange-Forest-RulesExecuted: mbx-essen-02
X-MS-Exchange-Organization-RulesExecuted: mbx-essen-02
X-MS-Exchange-Forest-IndexAgent-0: AQ0CZW4AAXIZAAAPAAADH4sIAAAAAAAEAK07CVcb=
R5otdIEMPmPHjj
 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
 TLlFQ9ic3RjHXNbI215HVJwP2RxqvVBCMV6+OK9UihLhlk3CkrTenC
 xlC9bB8+jmukjBsX4CMPaPBTjsN6i4Yadp0o54zQXWTnArOUvo9CqB
 gTbkzjM8MpGWTcNMcTPks83jIAQl7DnzfVFmtJZrpMZ0SMtyVtuFEc
 L7Pv5VUZXJDdAXZMCtdNjuoF3uM12FROdz+R7jUczvXK7+AZEF3Hgp
 iDkqEdjts6aOt6T8ftgiz778QDuNpmyc2kOxeuzK8A80YhY3P+fi7e
 77CIqJL5uEitaCqMP8jFk05iCcTnHCqOzIl7hNwUdtC5PD7/P8sMFP
 0VUAAAAQrFAzw/eG1sIHZlcnNpb249IjEuMCIgZW5jb2Rpbmc9InV0
 Zi0xNiI/Pg0KPEVtYWlsU2V0Pg0KICA8VmVyc2lvbj4xNS4wLjAuMD
 wvVmVyc2lvbj4NCiAgPEVtYWlscz4NCiAgICA8RW1haWwgU3RhcnRJ
 bmRleD0iMjEiPg0KICAgICAgPEVtYWlsU3RyaW5nPmJyaWplc2guc2
 luZ2hAYW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4N
 CiAgICA8RW1haWwgU3RhcnRJbmRleD0iMTAxMyIgUG9zaXRpb249Ik
 90aGVyIj4NCiAgICAgIDxFbWFpbFN0cmluZz5taWNoYWVsLnJvdGhA
 YW1kLmNvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgIC
 A8RW1haWwgU3RhcnRJbmRleD0iMTExNyIgUG9zaXRpb249Ik90aGVy
 Ij4NCiAgICAgIDxFbWFpbFN0cmluZz5hc2hpc2gua2FscmFAYW1kLm
 NvbTwvRW1haWxTdHJpbmc+DQogICAgPC9FbWFpbD4NCiAgPC9FbWFp
 bHM+DQo8L0VtYWlsU2V0PgEOzwFSZXRyaWV2ZXJPcGVyYXRvciwxMC
 wwO1JldHJpZXZlck9wZXJhdG9yLDExLDE7UG9zdERvY1BhcnNlck9w
 ZXJhdG9yLDEwLDA7UG9zdERvY1BhcnNlck9wZXJhdG9yLDExLDA7UG
 9zdFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDEwLDU7UG9z
 dFdvcmRCcmVha2VyRGlhZ25vc3RpY09wZXJhdG9yLDExLDA7VHJhbn
 Nwb3J0V3JpdGVyUHJvZHVjZXIsMjAsMTU=3D
X-MS-Exchange-Forest-IndexAgent: 1 7193
X-MS-Exchange-Forest-EmailMessageHash: 4C0A0896
X-MS-Exchange-Forest-Language: en
X-MS-Exchange-Organization-Processed-By-Journaling: Journal Agent
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:RC:REDACTED-af51df60fd698f80b0=
64826f9ee192ca@secunet.com:86/10|SR
X-MS-Exchange-Organization-IncludeInSla: False:RecipientCountThresholdExcee=
ded

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 211 ++++++++++++++++++
 3 files changed, 265 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index a10b817c162d..4268aa5c380e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
=20
 See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
=20
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provid=
ed
+data into a guest GPA range, measuring the contents into the SNP guest con=
text
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that G=
PA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it =
can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had th=
e
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentati=
on
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encry=
pt data into. */
+                __u64 uaddr;            /* Userspace address of data to be=
 loaded/encrypted. */
+                __u32 len;              /* 4k-aligned length in bytes to c=
opy into guest memory.*/
+                __u8 type;              /* The type of the guest pages bei=
ng initialized. */
+        };
+
+where the allowed values for page_type are #define'd as::
+
+	KVM_SEV_SNP_PAGE_TYPE_NORMAL
+	KVM_SEV_SNP_PAGE_TYPE_ZERO
+	KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+	KVM_SEV_SNP_PAGE_TYPE_SECRETS
+	KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
+used/measured.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 350ddd5264ea..956eb548c08e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -695,6 +695,7 @@ enum sev_cmd_id {
=20
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -826,6 +827,20 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
=20
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c7c77e33e62..a8a8a285b4a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -247,6 +247,35 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
=20
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data =3D {0};
+	int err, rc;
+
+	data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
+	rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ON_ONCE(rc)) {
+		/*
+		 * This shouldn't happen under normal circumstances, but if the
+		 * reclaim failed, then the page is no longer safe to use.
+		 */
+		snp_leak_pages(pfn, 1);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc =3D rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2075,6 +2104,185 @@ static int snp_launch_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
 	return rc;
 }
=20
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, struct kvm_memory_slot =
*slot,
+				  gfn_t gfn_start, kvm_pfn_t pfn, void __user *src,
+				  int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args =3D opaque;
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	int npages =3D (1 << order);
+	int n_private =3D 0;
+	int ret, i;
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	for (gfn =3D gfn_start, i =3D 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args =3D {0};
+		bool assigned;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute =
set\n",
+				 __func__, gfn);
+			ret =3D -EINVAL;
+			break;
+		}
+
+		ret =3D snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared s=
tate, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			break;
+		}
+
+		ret =3D rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to convert GFN 0x%llx to private, ret: %d\n",
+				 __func__, gfn, ret);
+			break;
+		}
+
+		n_private++;
+
+		fw_args.gctx_paddr =3D __psp_pa(sev->snp_context);
+		fw_args.address =3D __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size =3D PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type =3D sev_populate_args->type;
+		ret =3D __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UP=
DATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret) {
+			pr_debug("%s: SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n=
",
+				 __func__, ret, sev_populate_args->fw_error);
+
+			if (snp_page_reclaim(pfn + i))
+				break;
+
+			/*
+			 * When invalid CPUID function entries are detected,
+			 * firmware writes the expected values into the page and
+			 * leaves it unencrypted so it can be used for debugging
+			 * and error-reporting.
+			 *
+			 * Copy this page back into the source buffer so
+			 * userspace can use this information to provide
+			 * information on which CPUID leaves/fields failed CPUID
+			 * validation.
+			 */
+			if (sev_populate_args->type =3D=3D KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+			    sev_populate_args->fw_error =3D=3D SEV_RET_INVALID_PARAM) {
+				void *vaddr;
+
+				host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+				vaddr =3D kmap_local_pfn(pfn + i);
+
+				if (copy_to_user(src + i * PAGE_SIZE,
+						 vaddr, PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+
+				kunmap_local(vaddr);
+			}
+
+			break;
+		}
+	}
+
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, undoing %d populated gmem pages=
.\n",
+			 __func__, ret, n_private);
+		for (i =3D 0; i < n_private; i++)
+			host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args =3D {0};
+	struct kvm_gmem_populate_args populate_args =3D {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	unsigned int npages;
+	int ret =3D 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
+	    (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages =3D params.len / PAGE_SIZE;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
+		 params.gfn_start, params.gfn_start + npages, params.type);
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot =3D gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd =3D argp->sev_fd;
+	sev_populate_args.type =3D params.type;
+
+	populate_args.opaque =3D &sev_populate_args;
+	populate_args.gfn =3D params.gfn_start;
+	populate_args.src =3D u64_to_user_ptr(params.uaddr);
+	populate_args.npages =3D npages;
+	populate_args.do_memcpy =3D params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO;
+	populate_args.post_populate =3D sev_gmem_post_populate;
+
+	ret =3D kvm_gmem_populate(kvm, memslot, &populate_args);
+	if (ret) {
+		argp->error =3D sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %d\n", __func__, ret);
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2165,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r =3D snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r =3D snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
--=20
2.25.1


X-sender: <linux-crypto+bounces-3089-steffen.klassert=3Dsecunet.com@vger.ke=
rnel.org>
X-Receiver: <steffen.klassert@secunet.com> ORCPT=3Drfc822;steffen.klassert@=
secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-essen-01.secunet.de
X-ExtendedProps: BQBjAAoAqEmmlidQ3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbm=
dlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAA=
AAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1h=
aWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.197
X-EndOfInjectedXHeaders: 24458
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mbx-essen-02.secunet.de (10.53.40.198) with Microsoft SMTP Server
 (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.37; Sat, 30 Mar 2024 00:00:40 +0100
Received: from a.mx.secunet.com (62.96.220.36) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35 via Fronte=
nd
 Transport; Sat, 30 Mar 2024 00:00:40 +0100
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 69546208B4
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:40 +0100 (CET)
X-Virus-Scanned: by secunet
X-Spam-Flag: NO
X-Spam-Score: -5.15
X-Spam-Level:
X-Spam-Status: No, score=3D-5.15 tagged_above=3D-999 required=3D2.1
	tests=3D[BAYES_00=3D-1.9, DKIMWL_WL_HIGH=3D-0.099, DKIM_SIGNED=3D0.1,
	DKIM_VALID=3D-0.1, DKIM_VALID_AU=3D-0.1,
	HEADER_FROM_DIFFERENT_DOMAINS=3D0.249, MAILING_LIST_MULTI=3D-1,
	RCVD_IN_DNSWL_MED=3D-2.3, SPF_HELO_NONE=3D0.001, SPF_PASS=3D-0.001]
	autolearn=3Dham autolearn_force=3Dno
Authentication-Results: a.mx.secunet.com (amavisd-new);
	dkim=3Dpass (1024-bit key) header.d=3Damd.com
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 44Cyap1acLTm for <steffen.klassert@secunet.com>;
	Sat, 30 Mar 2024 00:00:37 +0100 (CET)
Received-SPF: Pass (sender SPF authorized) identity=3Dmailfrom; client-ip=
=3D139.178.88.99; helo=3Dsv.mirrors.kernel.org; envelope-from=3Dlinux-crypt=
o+bounces-3089-steffen.klassert=3Dsecunet.com@vger.kernel.org; receiver=3Ds=
teffen.klassert@secunet.com=20
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com B3F592087B
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99]=
)
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id B3F592087B
	for <steffen.klassert@secunet.com>; Sat, 30 Mar 2024 00:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.2=
5.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F078282B3A
	for <steffen.klassert@secunet.com>; Fri, 29 Mar 2024 23:00:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7221B13E413;
	Fri, 29 Mar 2024 23:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.com header.b=
=3D"nc26yfw6"
X-Original-To: linux-crypto@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12=
on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A03713CF91;
	Fri, 29 Mar 2024 23:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=3Dfail smtp.client-ip=
=3D40.107.244.41
ARC-Seal: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org; s=3Darc-20240116;
	t=3D1711753215; cv=3Dfail; b=3DfjdA/KPuC/sIeqaVY0oi6TFRyIES80fOAdBPMtaMQ9A=
82xaK722jPMpDP5uRpw1TDRnbpyFznjP9/Wx21YefB827hdm3kEvIx74zjcXiunSTLqHcgzJwIz=
tYjf1ofsZc2kKi6AWLKfuspBDhUx8scQLyGT8+MjjyUfS7WXaUfwc=3D
ARC-Message-Signature: i=3D2; a=3Drsa-sha256; d=3Dsubspace.kernel.org;
	s=3Darc-20240116; t=3D1711753215; c=3Drelaxed/simple;
	bh=3DGxarBB3QQXDtAmxKX8+rgDQfQVE3hghOjKcRWraa+k4=3D;
	h=3DFrom:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=3DHsE8q9F6LYfYnMlfLKuLnv9O+oEuUbw9RNotxN5x8l=
ROSKV36F8erowkx3T8A7TuDXzr6O+kU4CrCEBqJ710cdP0htYrMyVI1mRWa6lOwWkBhSGSmyBwm=
2ctHe9IpUAvbJoSHIn4mjehfry30ZOKzrAsZESfAH+1dlC89lUeS94=3D
ARC-Authentication-Results: i=3D2; smtp.subspace.kernel.org; dmarc=3Dpass (=
p=3Dquarantine dis=3Dnone) header.from=3Damd.com; spf=3Dfail smtp.mailfrom=
=3Damd.com; dkim=3Dpass (1024-bit key) header.d=3Damd.com header.i=3D@amd.c=
om header.b=3Dnc26yfw6; arc=3Dfail smtp.client-ip=3D40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=3Dpass (p=3Dquarant=
ine dis=3Dnone) header.from=3Damd.com
Authentication-Results: smtp.subspace.kernel.org; spf=3Dfail smtp.mailfrom=
=3Damd.com
ARC-Seal: i=3D1; a=3Drsa-sha256; s=3Darcselector9901; d=3Dmicrosoft.com; cv=
=3Dnone;
 b=3DBElzFv0DBW0MUfZQD8UJs5q9+EA6fwy/roXbmEq+TK27HwkmLuLGaSnZEaC4z7LizwxFP+=
9CcgtZSYe3Ii/x3Qmyx2+qpZC8UzOKYuThs/JgABKZIcsDlHgXuf91vyYHD+eNeDFavLFzfMdZo=
2aHfXt6nbKGXqbANG1fHpmqqa/XuV/gj8KYH5rwG+G2KsejSM58/o+SoRJo4tf0r7lMElBZNkVB=
7ERvDWxQuuE+2+oUQLMCIXrnckx38ToRkbf0LSv3pwmBSoITpf9FxRved2imYa055K8dViM8qFq=
fybVrwd9UIQYfHaZdKZ1RO+Q8fGV/oNpLYiqpqYBgwaOOtg=3D=3D
ARC-Message-Signature: i=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Dmicr=
osoft.com;
 s=3Darcselector9901;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-A=
ntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Ex=
change-AntiSpam-MessageData-1;
 bh=3DRRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=3D;
 b=3DnapnASBwyJG2prTZxam5z33xxl91ON59wzWY5AlObaNMOHV0cnd5AXmXzslMwl1QfB6IKj=
CNbGRvKeaSztlCXq1EJmJRKNxP/QGz33VOQxT6Ba77MSmZ9Gvharo7064GKpA8UYIMK8cOKZHtC=
peZ7KJoUep/ZNRgl6SMVToBBAzcZaOe+6QjxVtGP0/o8HuSAW/+wy96FFUxfFexc0D6205fpRzX=
zn5uVuIzoZMwGPSHuh88nLjcONk5HXY29Ev4ytXUbmwKtvwDnx/Q0QAqKpocUh5NtX8894m8J5E=
ScyJE5OVIw+bypKeljQQaBmiv3JPmTl+HzucpKl9Fw5SmNw=3D=3D
ARC-Authentication-Results: i=3D1; mx.microsoft.com 1; spf=3Dpass (sender i=
p is
 165.204.84.17) smtp.rcpttodomain=3Dvger.kernel.org smtp.mailfrom=3Damd.com=
;
 dmarc=3Dpass (p=3Dquarantine sp=3Dquarantine pct=3D100) action=3Dnone
 header.from=3Damd.com; dkim=3Dnone (message not signed); arc=3Dnone (0)
DKIM-Signature: v=3D1; a=3Drsa-sha256; c=3Drelaxed/relaxed; d=3Damd.com; s=
=3Dselector1;
 h=3DFrom:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-S=
enderADCheck;
 bh=3DRRM0X1XPmrPHJ/xejsVZHGx/fhXzSZlUOWEIzd5vxwg=3D;
 b=3Dnc26yfw6BEddsMoLxmBknQWv7NoJVdW5TsUPbDB5WD56lIuKOC7ktJ7shNNMaS3nlkqYjD=
ppMlO0nis5MV9UNDgd2MVhA+tVr1V4K8Zjyb8ngbfZX76ombAOPObrwYT1QJa3l86MicBWrhhig=
VCjwXVrKkwqgm6WOguSMG1TIU0=3D
Received: from BYAPR02CA0060.namprd02.prod.outlook.com (2603:10b6:a03:54::3=
7)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.41; Fri, 29 =
Mar
 2024 23:00:10 +0000
Received: from SJ1PEPF00001CDC.namprd05.prod.outlook.com
 (2603:10b6:a03:54:cafe::66) by BYAPR02CA0060.outlook.office365.com
 (2603:10b6:a03:54::37) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Front=
end
 Transport; Fri, 29 Mar 2024 23:00:10 +0000
X-MS-Exchange-Authentication-Results: spf=3Dpass (sender IP is 165.204.84.1=
7)
 smtp.mailfrom=3Damd.com; dkim=3Dnone (message not signed)
 header.d=3Dnone;dmarc=3Dpass action=3Dnone header.from=3Damd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=3Dprotection.outlook.com;
 client-ip=3D165.204.84.17; helo=3DSATLEXMB04.amd.com; pr=3DC
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDC.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=3DTLS1_2, cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA=
256) id
 15.20.7409.10 via Frontend Transport; Fri, 29 Mar 2024 23:00:10 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=3DTLS1_2,
 cipher=3DTLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 29 M=
ar
 2024 18:00:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: [PATCH v12 11/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date: Fri, 29 Mar 2024 17:58:17 -0500
Message-ID: <20240329225835.400662-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240329225835.400662-1-michael.roth@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDC:EE_|DM6PR12MB4106:EE_
X-MS-Office365-Filtering-Correlation-Id: c27c7199-0608-4e58-824a-08dc5043fc=
68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3CPhwmHFRTbcoEsG1eJurOstXAgzf72Ze7qRd5sd=
1y6H95KtLVWAy00ly7s0y7UOv9/Fa0d8LCHeobZEAV2wMHMBwvDPt5XAgtaP9QWZ+6Pr3bZziTF=
cZgcMbr04m8pJ+cA9GwKvf6S/OMzrLt1uriEl9sVG2Bf4VpxzIMljD40wtDfDmpx31u8s23d/bI=
MGv6jQFVj3JsuuUr7+HOjkJs/H2mEbB7cC3VTL0Er3ZMCNT6/L4bqA37k9zeBppe0b5nePPH2Uf=
lxHzfh4xMNZ6ttcvsy6mHWLMBExEFEIQhgQ1TOSYMs8niYK+J7Io8C7NWgJtTPqSs9KwMJTb6+9=
bCVfzJj/ZLfHIJofmlifP5hfGvMx93ymUl3BiC9gNvHQiHNEoEJzJao3IpwR3tvvhnaU3WR7e+u=
ryr7q7iOu9+JcYiXmTkCvbv2nJKeo8lbfwacgdTl6AOMDpdHAitMLR2yKnrPiwH9iJqUttjiJRr=
0tl6Nw0MUpWYJdQmvO2WKorsDgqWLh1Kh7yCTmsLHo3/F5EQ95LrJUpo/oDYlT4Y8rCFA8M/0cQ=
/BoREHUAEIJf31yyt0jDtOkCL3L4IuUvAGqIRGTU2nEaPf0gSnJ2SZa7+lm1s/2tb6l75eI+PLB=
Lm7LdN75fg4zFqX9400AtenkM7z03+WcUgV0uQT6QARZn2e8eElJMYIpPr3dLb7aqYFKckjQdmJ=
gdLdQvqbbyTfg7fdW4eBNPlSyVZ81qEcbrDLftDw463QUQ57VRGBO
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;I=
PV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS=
:(13230031)(82310400014)(1800799015)(7416005)(376005)(36860700004);DIR:OUT;=
SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2024 23:00:10.6256
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c27c7199-0608-4e58-824a-08dc5=
043fc68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3D=
3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=3D[165.204.84.17];Helo=3D[SATLEXMB0=
4.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SJ1PEPF00001CDC.namprd05.prod.outlook=
.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
Return-Path: linux-crypto+bounces-3089-steffen.klassert=3Dsecunet.com@vger.=
kernel.org
X-MS-Exchange-Organization-OriginalArrivalTime: 29 Mar 2024 23:00:40.4527
 (UTC)
X-MS-Exchange-Organization-Network-Message-Id: a325e09d-2d76-457c-d769-08dc=
50440e1c
X-MS-Exchange-Organization-OriginalClientIPAddress: 62.96.220.36
X-MS-Exchange-Organization-OriginalServerIPAddress: 10.53.40.202
X-MS-Exchange-Organization-Cross-Premises-Headers-Processed: cas-essen-02.s=
ecunet.de
X-MS-Exchange-Organization-OrderedPrecisionLatencyInProgress: LSRV=3Dcas-es=
sen-02.secunet.de:TOTAL-FE=3D0.006|SMR=3D0.006(SMRPI=3D0.005(SMRPI-Frontend=
ProxyAgent=3D0.005));2024-03-29T23:00:40.459Z
X-MS-Exchange-Forest-ArrivalHubServer: mbx-essen-02.secunet.de
X-MS-Exchange-Organization-AuthSource: cas-essen-02.secunet.de
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-OriginalSize: 23913
X-MS-Exchange-Organization-Transport-Properties: DeliveryPriority=3DLow
X-MS-Exchange-Organization-Prioritization: 2:ShadowRedundancy
X-MS-Exchange-Organization-IncludeInSla: False:ShadowRedundancy

From: Brijesh Singh <brijesh.singh@amd.com>

A key aspect of a launching an SNP guest is initializing it with a
known/measured payload which is then encrypted into guest memory as
pre-validated private pages and then measured into the cryptographic
launch context created with KVM_SEV_SNP_LAUNCH_START so that the guest
can attest itself after booting.

Since all private pages are provided by guest_memfd, make use of the
kvm_gmem_populate() interface to handle this. The general flow is that
guest_memfd will handle allocating the pages associated with the GPA
ranges being initialized by each particular call of
KVM_SEV_SNP_LAUNCH_UPDATE, copying data from userspace into those pages,
and then the post_populate callback will do the work of setting the
RMP entries for these pages to private and issuing the SNP firmware
calls to encrypt/measure them.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 .../virt/kvm/x86/amd-memory-encryption.rst    |  39 ++++
 arch/x86/include/uapi/asm/kvm.h               |  15 ++
 arch/x86/kvm/svm/sev.c                        | 211 ++++++++++++++++++
 3 files changed, 265 insertions(+)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documen=
tation/virt/kvm/x86/amd-memory-encryption.rst
index a10b817c162d..4268aa5c380e 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -478,6 +478,45 @@ Returns: 0 on success, -negative on error
=20
 See the SEV-SNP spec [snp-fw-abi]_ for further detail on the launch input.
=20
+19. KVM_SEV_SNP_LAUNCH_UPDATE
+-----------------------------
+
+The KVM_SEV_SNP_LAUNCH_UPDATE command is used for loading userspace-provid=
ed
+data into a guest GPA range, measuring the contents into the SNP guest con=
text
+created by KVM_SEV_SNP_LAUNCH_START, and then encrypting/validating that G=
PA
+range so that it will be immediately readable using the encryption key
+associated with the guest context once it is booted, after which point it =
can
+attest the measurement associated with its context before unlocking any
+secrets.
+
+It is required that the GPA ranges initialized by this command have had th=
e
+KVM_MEMORY_ATTRIBUTE_PRIVATE attribute set in advance. See the documentati=
on
+for KVM_SET_MEMORY_ATTRIBUTES for more details on this aspect.
+
+Parameters (in): struct  kvm_sev_snp_launch_update
+
+Returns: 0 on success, -negative on error
+
+::
+
+        struct kvm_sev_snp_launch_update {
+                __u64 gfn_start;        /* Guest page number to load/encry=
pt data into. */
+                __u64 uaddr;            /* Userspace address of data to be=
 loaded/encrypted. */
+                __u32 len;              /* 4k-aligned length in bytes to c=
opy into guest memory.*/
+                __u8 type;              /* The type of the guest pages bei=
ng initialized. */
+        };
+
+where the allowed values for page_type are #define'd as::
+
+	KVM_SEV_SNP_PAGE_TYPE_NORMAL
+	KVM_SEV_SNP_PAGE_TYPE_ZERO
+	KVM_SEV_SNP_PAGE_TYPE_UNMEASURED
+	KVM_SEV_SNP_PAGE_TYPE_SECRETS
+	KVM_SEV_SNP_PAGE_TYPE_CPUID
+
+See the SEV-SNP spec [snp-fw-abi]_ for further details on how each page ty=
pe is
+used/measured.
+
 Device attribute API
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kv=
m.h
index 350ddd5264ea..956eb548c08e 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -695,6 +695,7 @@ enum sev_cmd_id {
=20
 	/* SNP-specific commands */
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
=20
 	KVM_SEV_NR_MAX,
 };
@@ -826,6 +827,20 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
=20
+/* Kept in sync with firmware values for simplicity. */
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 gfn_start;
+	__u64 uaddr;
+	__u32 len;
+	__u8 type;
+};
+
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
=20
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6c7c77e33e62..a8a8a285b4a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -247,6 +247,35 @@ static void sev_decommission(unsigned int handle)
 	sev_guest_decommission(&decommission, NULL);
 }
=20
+static int snp_page_reclaim(u64 pfn)
+{
+	struct sev_data_snp_page_reclaim data =3D {0};
+	int err, rc;
+
+	data.paddr =3D __sme_set(pfn << PAGE_SHIFT);
+	rc =3D sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &err);
+	if (WARN_ON_ONCE(rc)) {
+		/*
+		 * This shouldn't happen under normal circumstances, but if the
+		 * reclaim failed, then the page is no longer safe to use.
+		 */
+		snp_leak_pages(pfn, 1);
+	}
+
+	return rc;
+}
+
+static int host_rmp_make_shared(u64 pfn, enum pg_level level, bool leak)
+{
+	int rc;
+
+	rc =3D rmp_make_shared(pfn, level);
+	if (rc && leak)
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+
+	return rc;
+}
+
 static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 {
 	struct sev_data_deactivate deactivate;
@@ -2075,6 +2104,185 @@ static int snp_launch_start(struct kvm *kvm, struct=
 kvm_sev_cmd *argp)
 	return rc;
 }
=20
+struct sev_gmem_populate_args {
+	__u8 type;
+	int sev_fd;
+	int fw_error;
+};
+
+static int sev_gmem_post_populate(struct kvm *kvm, struct kvm_memory_slot =
*slot,
+				  gfn_t gfn_start, kvm_pfn_t pfn, void __user *src,
+				  int order, void *opaque)
+{
+	struct sev_gmem_populate_args *sev_populate_args =3D opaque;
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	int npages =3D (1 << order);
+	int n_private =3D 0;
+	int ret, i;
+	gfn_t gfn;
+
+	pr_debug("%s: gfn_start %llx pfn_start %llx npages %d\n",
+		 __func__, gfn_start, pfn, npages);
+
+	for (gfn =3D gfn_start, i =3D 0; gfn < gfn_start + npages; gfn++, i++) {
+		struct sev_data_snp_launch_update fw_args =3D {0};
+		bool assigned;
+		int level;
+
+		if (!kvm_mem_is_private(kvm, gfn)) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx has private memory attribute =
set\n",
+				 __func__, gfn);
+			ret =3D -EINVAL;
+			break;
+		}
+
+		ret =3D snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
+		if (ret || assigned) {
+			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared s=
tate, ret: %d assigned: %d\n",
+				 __func__, gfn, ret, assigned);
+			break;
+		}
+
+		ret =3D rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+				       sev_get_asid(kvm), true);
+		if (ret) {
+			pr_debug("%s: Failed to convert GFN 0x%llx to private, ret: %d\n",
+				 __func__, gfn, ret);
+			break;
+		}
+
+		n_private++;
+
+		fw_args.gctx_paddr =3D __psp_pa(sev->snp_context);
+		fw_args.address =3D __sme_set(pfn_to_hpa(pfn + i));
+		fw_args.page_size =3D PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+		fw_args.page_type =3D sev_populate_args->type;
+		ret =3D __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UP=
DATE,
+				      &fw_args, &sev_populate_args->fw_error);
+		if (ret) {
+			pr_debug("%s: SEV-SNP launch update failed, ret: 0x%x, fw_error: 0x%x\n=
",
+				 __func__, ret, sev_populate_args->fw_error);
+
+			if (snp_page_reclaim(pfn + i))
+				break;
+
+			/*
+			 * When invalid CPUID function entries are detected,
+			 * firmware writes the expected values into the page and
+			 * leaves it unencrypted so it can be used for debugging
+			 * and error-reporting.
+			 *
+			 * Copy this page back into the source buffer so
+			 * userspace can use this information to provide
+			 * information on which CPUID leaves/fields failed CPUID
+			 * validation.
+			 */
+			if (sev_populate_args->type =3D=3D KVM_SEV_SNP_PAGE_TYPE_CPUID &&
+			    sev_populate_args->fw_error =3D=3D SEV_RET_INVALID_PARAM) {
+				void *vaddr;
+
+				host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+				vaddr =3D kmap_local_pfn(pfn + i);
+
+				if (copy_to_user(src + i * PAGE_SIZE,
+						 vaddr, PAGE_SIZE))
+					pr_debug("Failed to write CPUID page back to userspace\n");
+
+				kunmap_local(vaddr);
+			}
+
+			break;
+		}
+	}
+
+	if (ret) {
+		pr_debug("%s: exiting with error ret %d, undoing %d populated gmem pages=
.\n",
+			 __func__, ret, n_private);
+		for (i =3D 0; i < n_private; i++)
+			host_rmp_make_shared(pfn + i, PG_LEVEL_4K, true);
+	}
+
+	return ret;
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	struct kvm_sev_info *sev =3D &to_kvm_svm(kvm)->sev_info;
+	struct sev_gmem_populate_args sev_populate_args =3D {0};
+	struct kvm_gmem_populate_args populate_args =3D {0};
+	struct kvm_sev_snp_launch_update params;
+	struct kvm_memory_slot *memslot;
+	unsigned int npages;
+	int ret =3D 0;
+
+	if (!sev_snp_guest(kvm) || !sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, u64_to_user_ptr(argp->data), sizeof(params)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(params.len, PAGE_SIZE) ||
+	    (params.type !=3D KVM_SEV_SNP_PAGE_TYPE_NORMAL &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_UNMEASURED &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_SECRETS &&
+	     params.type !=3D KVM_SEV_SNP_PAGE_TYPE_CPUID))
+		return -EINVAL;
+
+	npages =3D params.len / PAGE_SIZE;
+
+	pr_debug("%s: GFN range 0x%llx-0x%llx type %d\n", __func__,
+		 params.gfn_start, params.gfn_start + npages, params.type);
+
+	/*
+	 * For each GFN that's being prepared as part of the initial guest
+	 * state, the following pre-conditions are verified:
+	 *
+	 *   1) The backing memslot is a valid private memslot.
+	 *   2) The GFN has been set to private via KVM_SET_MEMORY_ATTRIBUTES
+	 *      beforehand.
+	 *   3) The PFN of the guest_memfd has not already been set to private
+	 *      in the RMP table.
+	 *
+	 * The KVM MMU relies on kvm->mmu_invalidate_seq to retry nested page
+	 * faults if there's a race between a fault and an attribute update via
+	 * KVM_SET_MEMORY_ATTRIBUTES, and a similar approach could be utilized
+	 * here. However, kvm->slots_lock guards against both this as well as
+	 * concurrent memslot updates occurring while these checks are being
+	 * performed, so use that here to make it easier to reason about the
+	 * initial expected state and better guard against unexpected
+	 * situations.
+	 */
+	mutex_lock(&kvm->slots_lock);
+
+	memslot =3D gfn_to_memslot(kvm, params.gfn_start);
+	if (!kvm_slot_can_be_private(memslot)) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	sev_populate_args.sev_fd =3D argp->sev_fd;
+	sev_populate_args.type =3D params.type;
+
+	populate_args.opaque =3D &sev_populate_args;
+	populate_args.gfn =3D params.gfn_start;
+	populate_args.src =3D u64_to_user_ptr(params.uaddr);
+	populate_args.npages =3D npages;
+	populate_args.do_memcpy =3D params.type !=3D KVM_SEV_SNP_PAGE_TYPE_ZERO;
+	populate_args.post_populate =3D sev_gmem_post_populate;
+
+	ret =3D kvm_gmem_populate(kvm, memslot, &populate_args);
+	if (ret) {
+		argp->error =3D sev_populate_args.fw_error;
+		pr_debug("%s: kvm_gmem_populate failed, ret %d\n", __func__, ret);
+	}
+
+out:
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -2165,6 +2373,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *a=
rgp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r =3D snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r =3D snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r =3D -EINVAL;
 		goto out;
--=20
2.25.1




