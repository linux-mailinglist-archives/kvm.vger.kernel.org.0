Return-Path: <kvm+bounces-46634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B979AB7BF2
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 05:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F3B47B7C47
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 03:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D627028DB46;
	Thu, 15 May 2025 03:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="EfwlG/Vm"
X-Original-To: kvm@vger.kernel.org
Received: from esa10.fujitsucc.c3s2.iphmx.com (esa10.fujitsucc.c3s2.iphmx.com [68.232.159.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A64B1E53;
	Thu, 15 May 2025 03:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.159.247
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747278180; cv=fail; b=oYbAnu3O234oIfZzVBWpQlgSOocoTPeNhQVGa37Kh6eT7zn1hJ0pmizDmK+TnsJXWAkJ8u0l43X91//W2DteHkxQ8i0oxH/TM2ixY4U2VVsm/vcdJ5Lach+wAa+gETCD1BY/HyNv8agX3iv5lZ1oADMy0+R4O656/smE0H5An4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747278180; c=relaxed/simple;
	bh=wyJwIRPN32zCinU9smw+X/MilryHc/w/X1G4yqEFINE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rY9Oy3/qk6yWwh4flieBzvQLgzQAj6YKiv3jlvENh2fhT3LOtyBaOEnFFiLgQN2eLUj4J4MjCs78NAS/SsXvvhYhVhLKDtr5a0s/ZvGHSTGCDp6szfnttICbfZVonGJ06BlTA4OkEBOHOQj9Ydp6a3saRs4R/v9Ft4o4Oqmbfok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=EfwlG/Vm; arc=fail smtp.client-ip=68.232.159.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1747278177; x=1778814177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wyJwIRPN32zCinU9smw+X/MilryHc/w/X1G4yqEFINE=;
  b=EfwlG/VmX7CKBySjnotZbm8oE+ajqcHNWQHJr4k4PSLbHo8hAFSq1TES
   ylQhsuQdihLywSKG7D0Ub2/GXviyrgkIYPRMl6uXJqeyDmBB6VvGLH46y
   nAKuDwFLCnf9r3MU5XWZoHVddjP8S66w0USvtG+q0ViLbXK8gnhAZPXhN
   m106I1T8VSrKLf/C0jcTFAqv8NJcAzBHEaR9QbxSTraABp+Vz/r+m+AjT
   a0W0YSJVIgcf3j4Z3nUyg8mN3e8gWFN9mVT9vHOM1vxUiXElU/lWV/NZA
   d3c6wYitJgJMwbNd/sMugR9UfFxYiIdO2n62cGnMBmCGiERBO6owAY1zJ
   Q==;
X-CSE-ConnectionGUID: h1qC9i2oS0qDgFGAw1AGcg==
X-CSE-MsgGUID: CHfjGfKHS0+sWLSPOChoeA==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="155577933"
X-IronPort-AV: E=Sophos;i="6.15,289,1739804400"; 
   d="scan'208";a="155577933"
Received: from mail-japaneastazlp17011030.outbound.protection.outlook.com (HELO TYVP286CU001.outbound.protection.outlook.com) ([40.93.73.30])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 12:01:41 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HXBtGZqHJHLbkZU7N9h+CwS7m8LmCn4NK8HVSzmNKG/1DwP18SqzcrnXm0zlfPBIEMtZDgq7BCIFeJq3I0zQpkTYUbQUjkf3QAq0m67Q4Gp/8eC+n30WDqsgvZuw1yNuktNsT70NKPTHTlW2d+mz0pbXrnJ8oB5unjuJPGrbIsR9DQ334LbfpetVCV1WYzY1qJD4dJvvaQ/XoPsXLZkGqpCVUReHkXNUzxoIbtLCsoE4+Z3y/DS6BhSc1Dxe0nbNmKN+kaPG2sQpPwBxubKrKfCcnjNpHjLlXLm9bRlRlKOON+1Z2YyQBrzL2k/aEu1DU3FA+4p+YGbT05H8EJ7mNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyJwIRPN32zCinU9smw+X/MilryHc/w/X1G4yqEFINE=;
 b=LYM7AiRGTtgrYNJlxnrewn6AW3kG8/QKrVgWBzFvTJUp4Pig4nXfGt6zLkYsKNTFZwjq+P5g48M649a+QK89P3c/9n1zgXjZXOeSLk6Ecr1OxNn4z2CS7pkJDtxuPkyL+HpRG3cdUWThq4S1ij90eA5RyDhS6+kj3zVR2Mno3GL3C+mtThikb7n20DNmAqM5cRUHtIRKlFJ91mjnahKNYOxyQ/uY28+kA+SE14EZtsDJpaFDx1TAK8eJ0VGKSjHy3vmLE0ZcrN8RFoBTSnuE4GvHsSXTCApWGj2P2zHuYdBj9JffwhDcwVvBmfTBwJdi5KUiweonvWpx/a039zQk7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 (2603:1096:400:389::10) by TY4PR01MB14432.jpnprd01.prod.outlook.com
 (2603:1096:405:235::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Thu, 15 May
 2025 03:01:38 +0000
Received: from TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8]) by TYCPR01MB11463.jpnprd01.prod.outlook.com
 ([fe80::5df7:5225:6f58:e8e8%6]) with mapi id 15.20.8722.024; Thu, 15 May 2025
 03:01:38 +0000
From: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>
To: 'Steven Price' <steven.price@arm.com>, "'kvm@vger.kernel.org'"
	<kvm@vger.kernel.org>, "'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>
CC: 'Catalin Marinas' <catalin.marinas@arm.com>, 'Marc Zyngier'
	<maz@kernel.org>, 'Will Deacon' <will@kernel.org>, 'James Morse'
	<james.morse@arm.com>, 'Oliver Upton' <oliver.upton@linux.dev>, 'Suzuki K
 Poulose' <suzuki.poulose@arm.com>, 'Zenghui Yu' <yuzenghui@huawei.com>,
	"'linux-arm-kernel@lists.infradead.org'"
	<linux-arm-kernel@lists.infradead.org>, "'linux-kernel@vger.kernel.org'"
	<linux-kernel@vger.kernel.org>, 'Joey Gouly' <joey.gouly@arm.com>, 'Alexandru
 Elisei' <alexandru.elisei@arm.com>, 'Christoffer Dall'
	<christoffer.dall@arm.com>, 'Fuad Tabba' <tabba@google.com>,
	"'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>, 'Ganapatrao
 Kulkarni' <gankulkarni@os.amperecomputing.com>, 'Gavin Shan'
	<gshan@redhat.com>, 'Shanker Donthineni' <sdonthineni@nvidia.com>, 'Alper
 Gun' <alpergun@google.com>, "'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
Subject: RE: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
Thread-Topic: [PATCH v8 00/43] arm64: Support for Arm CCA in KVM
Thread-Index: AQMPKfif4GpC56WX1Xmo2sNneTWC8bFsMmOw
Date: Thu, 15 May 2025 03:01:38 +0000
Message-ID:
 <TYCPR01MB11463F53A3487AF7C669A534EC390A@TYCPR01MB11463.jpnprd01.prod.outlook.com>
References: <20250416134208.383984-1-steven.price@arm.com>
In-Reply-To: <20250416134208.383984-1-steven.price@arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 =?utf-8?B?TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5Njgw?=
 =?utf-8?B?MmZfQWN0aW9uSWQ9MTI0ZTE1YmQtYzQyZC00YjA2LWFmNjUtMjE2Yjk2MzQz?=
 =?utf-8?B?NzA4O01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMz?=
 =?utf-8?B?OTY4MDJmX0NvbnRlbnRCaXRzPTA7TVNJUF9MYWJlbF8xZTkyZWY3My0wYWQx?=
 =?utf-8?B?LTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfRW5hYmxlZD10cnVlO01TSVBfTGFi?=
 =?utf-8?B?ZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFkNTUtNDZkZTMzOTY4MDJmX01ldGhv?=
 =?utf-8?B?ZD1Qcml2aWxlZ2VkO01TSVBfTGFiZWxfMWU5MmVmNzMtMGFkMS00MGM1LWFk?=
 =?utf-8?B?NTUtNDZkZTMzOTY4MDJmX05hbWU9RlVKSVRTVS1QVUJMSUPigIs7TVNJUF9M?=
 =?utf-8?B?YWJlbF8xZTkyZWY3My0wYWQxLTQwYzUtYWQ1NS00NmRlMzM5NjgwMmZfU2V0?=
 =?utf-8?B?RGF0ZT0yMDI1LTA1LTE1VDAyOjQzOjQ2WjtNU0lQX0xhYmVsXzFlOTJlZjcz?=
 =?utf-8?B?LTBhZDEtNDBjNS1hZDU1LTQ2ZGUzMzk2ODAyZl9TaXRlSWQ9YTE5ZjEyMWQt?=
 =?utf-8?Q?81e1-4858-a9d8-736e267fd4c7;?=
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYCPR01MB11463:EE_|TY4PR01MB14432:EE_
x-ms-office365-filtering-correlation-id: 7b347297-fee0-44b4-866f-08dd935ccf4c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|1580799027;
x-microsoft-antispam-message-info:
 =?utf-8?B?dG93d1BSbjB5SHZTZTRyR1E5RGNVekdLb2VZQTVUR2p1OTRhRG9ybU56VG5P?=
 =?utf-8?B?UEN0SGJwam1qRlkyTlJJSS9nMGhyNVBMQnNnY0ZRVThRZTgyb2NtY1g0ajdp?=
 =?utf-8?B?bWN3Ti9lb3YvRXFNbVBId2FTU3dKeGVuYTBtZE1RTnVjNjRvQ2dNc2hDUU4y?=
 =?utf-8?B?VGVEejVxTGZaZnFtSldFR0VJUUZZVGY3ZDNyTnVFREw1eE5jbUV4eFZ1YUZ3?=
 =?utf-8?B?ald5VFo2NjFoeU5nMFd4cEpYT3ZoTlhtbXdhYzAwK3RBT1RZZzBrd2dJMm9P?=
 =?utf-8?B?SzlIQnFrU1ZkTHBqUDNuMFJJUnhOd2VmamI4NXJvQkxVWlhzK2piNytMcDgr?=
 =?utf-8?B?WG5XcW5HanZNbGtyWXZrYUVJUzZITjF5M2R2TWFNYVY4YThDb2t2blJWZjdo?=
 =?utf-8?B?WC96YVRJRHJ4dzFqdjFrT1QwNnFpSTY2d0lOWksvdm52YkZsZXlMdFl1STZN?=
 =?utf-8?B?d0lTNmNhdlcrZFUzb1BmVHplT2FnVGFUNFFOaXp0WGFaNk51RjNrWks3bzhi?=
 =?utf-8?B?UTREa0NzTXRWNFhrdWdBZlJxaEJvZVNSVCtVc2ErYmV3RXJQWm1CeldCWDFW?=
 =?utf-8?B?UzBpOUg0dXV3YmVhUTdQNHlGOEpMM0VEcWJLMzJKWXd2TGtUYnBDb0hZRkp3?=
 =?utf-8?B?WldidlltcjI3NVBDTXJHR0lNNVJ3eTdWZnYyMG1GMGV0cHZKUXc0Z1IranFP?=
 =?utf-8?B?MEh1QndidVl5ZE9tTjlrM1VRUUxrUE9jUEd1Skt1S2E1cGZUYXZKSjBwckEx?=
 =?utf-8?B?UWdjL3pDV0lTVVNZMkFiS05WS1pDaEl6TExmQkM2eUpyUVViVG11VEtheU5a?=
 =?utf-8?B?ZU1pWHBiN0VZWDl4R2dnNCttTkVucHE5cmVvcjRNR0pVNHI5M1Y4RFBmUHpk?=
 =?utf-8?B?VS9LMWJSSnRSZTZhRlJ6UDlKanYvNGRsQy80RlVaWk1hblFxc2ZFWjV1aTl1?=
 =?utf-8?B?Z1RmZGp0eEZnTUV4dkNKdS9pa01RQ3JDOEJDc21xMlZMQ0ZoVWhmSzkyeWtx?=
 =?utf-8?B?YWtUYTBQaTlTSk8wdXZSaFdPd0UrdTc5OU1mUDd2bTlJN2VyRXlIaFFGV0NP?=
 =?utf-8?B?RmVGQU9od2NjRjhhaXc1VnphbW5icUhvTjlPdkU3ZUkyckNFRmhvT3hxTnor?=
 =?utf-8?B?ZkdKeE9JQVNQbFBmK0FCNnFuTGdUYm1HUEN2Vm00NGd5TnlBQ3h0bmtiWFdn?=
 =?utf-8?B?ZkRYVjhxL1JuRmxaUWxJMm5nNUVkOFk4bm1oSGxpeENuTm9iMjZmdEtnb1Y0?=
 =?utf-8?B?L3ZJaEt5SUpDd2g5ekphRXlCbENFVncvOGhVWVVmTm5nYWc0bzY4RGRMWnIx?=
 =?utf-8?B?N0Nsc21hZGtmWSt3OXpYUGV5a3I5eGxrRDNNVGdxeG84SW8wNE5pUGhaSmJX?=
 =?utf-8?B?THhuMGh5eVVmRm93N0E0OVRFYm5kZS9ncTc2VWFMdmUvMUVtSnBBcXJrMW9u?=
 =?utf-8?B?cHNyNS8rSUNrc1hFT2cxQzdsNVozNW4yT1VUbmRCVDJ3TlpuU0xUdEFIWmpF?=
 =?utf-8?B?dEpTbEZJSUppR2dNUUNVUmZBUFc1K3ArTWxDZHBKVDdkSDhrMnc5TDNvNlgr?=
 =?utf-8?B?cktFRGNVM0ZCZGxxR2RpMk1iWkYxdjUwaWlRU0paQk02SVpZZmRJbTZSMlcw?=
 =?utf-8?B?NmpIdVppbE9pcEQ5UHdHbWtmZXh3dWxKMmR1c3JYeFA1dlptZGtiZ1ZVd3E2?=
 =?utf-8?B?Q3dueG96bmJpOTd0UTM0NEd0SnloUzR1NlRaTUFsOHV5NlFkVzVkcUNTSnAw?=
 =?utf-8?B?M0R1bjUyRmdseVBVMGlHTnBRdGtwR0pvUzRTWHA4Tkx0WkF3bzl0Vk9yZXIy?=
 =?utf-8?B?SSs5NnllWVBWb3l1Tk1sZXl4SDk5Y25nL3V2ODRQM1ZYeGMyNElRUGRLMXlh?=
 =?utf-8?B?dWpocjUwUS9NL2tYSEh2UXM3VWRKeU0rOHM0b1FlaFo1REdXYkNDL1pMZi9i?=
 =?utf-8?B?UG1MZDhTWjdqOTg5akt6YkRqVFdFTERFd2RYYXpkTG9TYk9EMDlLVW9XV2p4?=
 =?utf-8?B?eVlOOGJLL1BRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB11463.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(1580799027);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Nk5RTzl4dk1xREdjYXlNUy9Eci9OZnNpWE1oNlFkTU13ZHNtcHk1dTNQdlVw?=
 =?utf-8?B?L0p3Nmh4MXBzdlMzVVp6NFRWQ3QwWi9VRGxjMmx0dDUxSDlSdnRidmE2UGVQ?=
 =?utf-8?B?YnhGRGdJNHg2SmozNnNWU21CWk91dFBwNU5nM2MxR2g4VXNodEFNdkhtYjJJ?=
 =?utf-8?B?N21CbzVzbXVOd05HT2RSL1Q5WFBUdUE5MEpETElpTEVOVXBRSVUxUVhpTXNC?=
 =?utf-8?B?NHVCekoydW5YUHZjNzhvZFBXZHNxZUJ6cFN5dm5pbUllRWpEQ1BibUFpcDZ4?=
 =?utf-8?B?YW9aZ2xSQWpkRXU1Ly9NQmlETi9FaXF6VmM2MjZEalNOZTBOR1lHNWFGN1ZB?=
 =?utf-8?B?ZFhFb2Y2RnB1T0FTNDNqZGs5YlRsTkEwM1lOVzFNNURQSjVYWFdqWEhkbFpF?=
 =?utf-8?B?V25QODF2VDdwVzVYNkVTNHM3UzllaFJ5eWp0QTZjMWtObHdpek5NL2RoRzJ0?=
 =?utf-8?B?V3NYaXJxWC91S3piM0RoT3ZVQVVObHBNUWlyM2dzVHNjU25iNzFFdll0Qk12?=
 =?utf-8?B?NnladkJ1Vk5ja0dpbW9ScVJxQzdORTJId1ZWMFgrL09XZU9lUXlHaHFrL21N?=
 =?utf-8?B?K1A2MmUyOTZNTzJtaFZqRGFzZ09HU3BGV3RxbnJXbm1zbVFRQkNVNVcvK1dZ?=
 =?utf-8?B?R05CZ3hpVmhVQ3BhWlVrTUQweDBpZmtqSWJ5NmRSMXUyQUh3eTJTVWt5Rm9Z?=
 =?utf-8?B?YlRLRVBzMHJJQ0pXWnoxN0NocXdScnlrTGxMbkxidW90eDRyMGYzY3Q3YWx2?=
 =?utf-8?B?Z0hlQVp5dVFUM0VrSXJvUTRzdTZxUE1WUWE5bUZTRnpMOFp3d0FMRS96eXdw?=
 =?utf-8?B?Vm9ObkdsNHRDSGJaUlAxT1d4WlJSWC94WThKVEE1d3NiTlBpd2VNbjhLRXVU?=
 =?utf-8?B?SnRzV2R2NUxpREhnU3FudlpUUDB0Szl1NGlDc1NGcnkvWG5NUi80UXUva1Jv?=
 =?utf-8?B?Ulg3M2NNMjFmRTlURDdnWXR5aXNFTER1Z1Z1NDNtR3lPQVBVZWhaS0haeXlC?=
 =?utf-8?B?K25NL0E1RCtJbnNiR0VQTWd3WlF1dXUrMWd0ZlF6UE55bFREbFg3QW5yakFX?=
 =?utf-8?B?OVFPeDNwcmMwZFFZTndtYVRIZitUOUtzbVdkUys5NlJQZ3ZIZXIzSmdJSEFR?=
 =?utf-8?B?YW1lNUMzTXh5V3hYd1E3L0xQUXhUNEM3SGk4RGtpRTQ0dzloVzJLcU0vSC9N?=
 =?utf-8?B?Q0xHMUxYN3EwUzkxSE9IR1NkckhZaTV0V1ZOa1Mxc0RtVm4rVjgrL1dWUnZT?=
 =?utf-8?B?dEFYQWNUOWJrTzQ4WG9KcVNnV0hneENuVU84aGJlYVI5aEE1SURkUUtZbVg2?=
 =?utf-8?B?LzhkTTg1SWpCM1c1OTBQYUtjK2I4TUtvZkZxdEZqbWlJTk9wblQvcUg2VlEw?=
 =?utf-8?B?NE9Vc0oxMzNueEpJbGd4ZlhaOVVsRE9CTkxQVTNxQnEyMjMwNUtIWU5lQndS?=
 =?utf-8?B?cmEvdDRXeVpCTXhOVWduMlNJODNBUnh0VWE4K3JzZ2dKalBSTi90Q0kxaVhn?=
 =?utf-8?B?bGxPOU95aUxGUVNjSXRSM0ovRDBiWW5tQjVieksrbkZPcUtYSDVVczZLQ2pQ?=
 =?utf-8?B?eTNDTzRCU3J2d2l4OVB2UHo1MmtpTkluWU1UQ1ZmaVdZemNrRHZYRVJRR2t2?=
 =?utf-8?B?Q3JLZmEzYnRITHdjdjBMbmhQZlJpSVp6RERmVEMwS2J0Z1dJNWVNYXh0MTdO?=
 =?utf-8?B?MUt5QmR6WWovSnRxSkljR3ArbGhnUUd1RGhjRHlSU0VvRldNYVliL2dyVnB0?=
 =?utf-8?B?RDlDeEhVUVpxejVUdmhtS3hHTWtlMU9Ob2U2WUNCVS9Jdk1zR1pEaTZ2WmxX?=
 =?utf-8?B?Zjhud3pueGZBQ2h1TTNuZDdvczhGWjJXN0ZabDdSRit1YVplN3RNZHowYjBo?=
 =?utf-8?B?MDRWTG9sMEhWNlhaS1FiRzZESkpzcld4TWd5eUZud2FXck5INFRXaStiNTEv?=
 =?utf-8?B?U01XRk1UYkNXSFlXQzFQLzRUMklGc2toVU9uWExhZFEyVWdITHhjYTc4WEcx?=
 =?utf-8?B?ZGlITjZGbVB5aXlMd0M3UEpYWW5Na2ZlZXFWUDEzc0o5YTlxSWExa0xaeito?=
 =?utf-8?B?RTZZY0F5SUdHang0WUJyZCt0eU13Q3hrRExRSnllY0F0SUlicEQzK2VLZi9N?=
 =?utf-8?B?UzFUekFSWHVTOG9RM3J6eFFTUnRxQmlGbEYxSDNQOHNmUCtzVVg0cm1tZU4z?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cu5f7ItQb5/b/lWPu0HmZp9fTlMOEWE1lRGFjDKhOy0rtWM+bSC1Luut/id7QBe/oeZ7+HNaY63ERL8T1XP3q8HIEhmmHxpPZnAM2mhURRtwEJKVUXQMPuGaagHwuzyomWQsS/EIsG/8rhnGwLEQaumsUvG3M/r/L0GrAw0RxYuBqPASxktIAaITC6EoMB1uR1cVZNzplA4kSxPIudz/HwmzVpWgRLMU0xu5GRzzJKsDyz67hxmIau3bVxMpAkPYPzit8l4zMtji9xTBBAPFEOKmFomykl98lDqCvMWAdrimESKuq9HAkqJq7IaGZfwv7Ne1FH6iuhnCwsLcHxcLf/UxBggUTBJoQv27LQfMQhjEZCyWPZh3x3+xVIRcGS9mDJ0PWKCdbtCSBKSLEZPsVdThDjgNh+Wg6NDNpJT/SsBgMaF4B4RgcnCT/+dq8ccexTA5dVYCePRY0fon5M5q0gv9y5ZRcquB3oybvCdlNfu7abIishVsaLk9qdvOM1CyU5bMOb6vpsRBDXNSy94gcDWLarMcecCDrM7Qf2B/g3Erb8KhFUkoI3ncoeO+oOZ+stR++2v64CX7BcrmcCQ7ymokJiKlgv/h3QMjYCkc6xVSo8psC0agk6wZhsqD+zDP
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB11463.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b347297-fee0-44b4-866f-08dd935ccf4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2025 03:01:38.0284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l/TW1v3N0gCxeeMG5/7S9Nv02im3q/gltXcrwi4WtDXf/0eZmp1MSCt4f8s4SkINzkCptaCHiZvA/PjD6vymXUlOcjWmO8d1D2DJWqEzKkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB14432

V2UgdGVzdGVkIHRoaXMgcGF0Y2ggaW4gb3VyIGludGVybmFsIHNpbXVsYXRvciB3aGljaCBpcyBh
IGhhcmR3YXJlIHNpbXVsYXRvciBmb3IgRnVqaXRzdSdzIG5leHQgZ2VuZXJhdGlvbiBDUFUga25v
d24gYXMgTW9uYWthLiBhbmQgaXQgcHJvZHVjZWQgdGhlIGV4cGVjdGVkIHJlc3VsdHMuDQoNCkkg
aGF2ZSB2ZXJpZmllZCB0aGUgZm9sbG93aW5nDQoxLiBMYXVuY2hpbmcgdGhlIHJlYWxtIFZNIHVz
aW5nIEludGVybmFsIHNpbXVsYXRvciDihpIgU3VjY2Vzc2Z1bGx5IGxhdW5jaGVkIGJ5IGRpc2Fi
bGluZyBNUEFNIHN1cHBvcnQgaW4gdGhlIElEIHJlZ2lzdGVyLg0KMi4gUnVubmluZyBrdm0tdW5p
dC10ZXN0cyAod2l0aCBsa3ZtKSDihpIgQWxsIHRlc3RzIHBhc3NlZCBleGNlcHQgZm9yIFBNVSAo
YXMgZXhwZWN0ZWQsIHNpbmNlIFBNVSBpcyBub3Qgc3VwcG9ydGVkIGJ5IHRoZSBJbnRlcm5hbCBz
aW11bGF0b3IpLlsxXQ0KDQpUZXN0ZWQtYnk6IEVtaSBLaXNhbnVraSA8ZmowNTcwaXNAZnVqaXRz
dS5jb20+IFsxXSBodHRwczovL2dpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9rdm0tdW5pdC10ZXN0
cy1jY2EgY2NhL3YzDQoNCkJlc3QgUmVnYXJkcywNCkVtaSBLaXNhbnVraQ0KPiBUaGlzIHNlcmll
cyBhZGRzIHN1cHBvcnQgZm9yIHJ1bm5pbmcgcHJvdGVjdGVkIFZNcyB1c2luZyBLVk0gdW5kZXIg
dGhlIEFybQ0KPiBDb25maWRlbnRpYWwgQ29tcHV0ZSBBcmNoaXRlY3R1cmUgKENDQSkuDQo+IA0K
PiBUaGUgcmVsYXRlZCBndWVzdCBzdXBwb3J0IHdhcyBtZXJnZWQgZm9yIHY2LjE0LXJjMSBzbyB5
b3Ugbm8gbG9uZ2VyIG5lZWQgdGhhdA0KPiBzZXBhcmF0ZWx5Lg0KPiANCj4gVGhlcmUgYXJlIGEg
ZmV3IGNoYW5nZXMgc2luY2UgdjcsIG1hbnkgdGhhbmtzIGZvciB0aGUgcmV2aWV3IGNvbW1lbnRz
LiBUaGUNCj4gaGlnaGxpZ2h0cyBhcmUgYmVsb3csIGFuZCBpbmRpdmlkdWFsIHBhdGNoZXMgaGF2
ZSBhIGNoYW5nZWxvZy4NCj4gDQo+ICAqIE1vcmUgZG9jdW1lbnRhdGlvbiAtIHRoZSBuZXcgaW9j
dGxzIGFuZCBjYXBhYmlsdGllcyBhcmUgbm93IGFsbA0KPiAgICBkb2N1bWVudGVkLg0KPiANCj4g
ICogSW5pdGlhbCBwYXRjaCBhZGRpbmcgIm9ubHlfcHJpdmF0ZSIvIm9ubHlfc2hhcmVkIiB0byBz
dHJ1Y3QNCj4gICAga3ZtX2dmbl9yYW5nZSByZXBsYWNlZCB3aXRoIGFscmVhZHkgdXBzdHJlYW0g
ImF0dHJfZmlsdGVyIi4NCj4gDQo+ICAqIEltcHJvdmVtZW50IGluIHZhcmlhYmxlIG5hbWluZyBh
bmQgZXJyb3IgY29kZXMsIGFuZCBzb21lIGltcHJvdmVkL25ldw0KPiAgICBjb21tZW50cy4gQWxs
IGZvbGxvd2luZyB2YWx1YWJsZSByZXZpZXcgZmVlZGJhY2sgKHRoYW5rcyEpLg0KPiANCj4gICog
RHJvcCB0aGUgZmluYWwgV0lQIHBhdGNoIGZvciBlbmFibGluZyBsYXJnZSBQQUdFX1NJWkUgc3Vw
cG9ydC4gSXQncw0KPiAgICBub3QgcmVhZHkgZm9yIG1lcmdpbmcgYW5kIEkgd2FudCB0byBmb2N1
cyBvbiBsYW5kaW5nIHRoZSA0ayBzdXBwb3J0Lg0KPiANCj4gICogUmViYXNlZCBvbnRvIHY2LjE1
LXJjMS4NCj4gDQo+IFRoaW5ncyB0byBub3RlOg0KPiANCj4gICogVGhlIG1hZ2ljIG51bWJlcnMg
Zm9yIGNhcGFiaWxpdGllcyBhbmQgaW9jdGxzIGhhdmUgYmVlbiB1cGRhdGVkLiBTbw0KPiAgICB5
b3UnbGwgbmVlZCB0byB1cGRhdGUgeW91ciBWTU0uIFNlZSBiZWxvdyBmb3IgdXBkYXRlIGt2bXRv
b2wgYnJhbmNoLg0KPiANCj4gICogUGF0Y2ggNDIgaW5jcmVhc2VzIEtWTV9WQ1BVX01BWF9GRUFU
VVJFUyB0byBleHBvc2UgdGhlIG5ldyBmZWF0dXJlLg0KPiAgICBUaGlzIGFsc28gZXhwb3NlcyB0
aGUgTlYgZmVhdHVyZXMgKGFzIHRoZXkgYXJlIGN1cnJlbnRseSBudW1iZXJlZA0KPiAgICBsb3dl
cikuIFRoaXMgd2lsbCByZXNvbHZlIHdoZW4gTWFyYydzIE5WIHNlcmllcyBoYXMgbGFuZGVkLCBz
ZWUgWzJdLg0KPiANCj4gICogVGhlcmUgYXJlIHNvbWUgY29uZmxpY3RzIHdpdGggdjYuMTUtcmMy
LCBtb3N0bHkgZG9jdW1lbnRhdGlvbiwgYnV0DQo+ICAgIGFsc28gY29tbWl0IDI2ZmJkZjM2OTIy
NyAoIktWTTogYXJtNjQ6IERvbid0IHRyYW5zbGF0ZSBGQVIgaWYNCj4gICAgaW52YWxpZC91bnNh
ZmUiKSAnaGlqYWNrcycgSFBGQVJfRUwyX05TIGFzIGEgdmFsaWQgYml0LiBUaGlzIHdpbGwNCj4g
ICAgcmVxdWlyZSBjb3JyZXNwb25kaW5nIGNoYW5nZXMgdG8gdGhlIENDQSBjb2RlLg0KPiANCj4g
VGhlIEFCSSB0byB0aGUgUk1NICh0aGUgUk1JKSBpcyBiYXNlZCBvbiBSTU0gdjEuMC1yZWwwIHNw
ZWNpZmljYXRpb25bMV0uDQo+IA0KPiBUaGlzIHNlcmllcyBpcyBiYXNlZCBvbiB2Ni4xNS1yYzEu
IEl0IGlzIGFsc28gYXZhaWxhYmxlIGFzIGEgZ2l0DQo+IHJlcG9zaXRvcnk6DQo+IA0KPiBodHRw
czovL2dpdGxhYi5hcm0uY29tL2xpbnV4LWFybS9saW51eC1jY2EgY2NhLWhvc3QvdjgNCj4gDQo+
IFdvcmsgaW4gcHJvZ3Jlc3MgY2hhbmdlcyBmb3Iga3ZtdG9vbCBhcmUgYXZhaWxhYmxlIGZyb20g
dGhlIGdpdCByZXBvc2l0b3J5IGJlbG93Og0KPiANCj4gaHR0cHM6Ly9naXRsYWIuYXJtLmNvbS9s
aW51eC1hcm0va3ZtdG9vbC1jY2EgY2NhL3Y2DQo+IA0KPiBbMV0gaHR0cHM6Ly9kZXZlbG9wZXIu
YXJtLmNvbS9kb2N1bWVudGF0aW9uL2RlbjAxMzcvMS0wcmVsMC8NCj4gWzJdIGh0dHBzOi8vbG9y
ZS5rZXJuZWwub3JnL3IvMjAyNTA0MDgxMDUyMjUuNDAwMjYzNy0xNy1tYXolNDBrZXJuZWwub3Jn
DQo+IA0KPiBKZWFuLVBoaWxpcHBlIEJydWNrZXIgKDcpOg0KPiAgIGFybTY0OiBSTUU6IFByb3Bh
Z2F0ZSBudW1iZXIgb2YgYnJlYWtwb2ludHMgYW5kIHdhdGNocG9pbnRzIHRvDQo+ICAgICB1c2Vy
c3BhY2UNCj4gICBhcm02NDogUk1FOiBTZXQgYnJlYWtwb2ludCBwYXJhbWV0ZXJzIHRocm91Z2gg
U0VUX09ORV9SRUcNCj4gICBhcm02NDogUk1FOiBJbml0aWFsaXplIFBNQ1IuTiB3aXRoIG51bWJl
ciBjb3VudGVyIHN1cHBvcnRlZCBieSBSTU0NCj4gICBhcm02NDogUk1FOiBQcm9wYWdhdGUgbWF4
IFNWRSB2ZWN0b3IgbGVuZ3RoIGZyb20gUk1NDQo+ICAgYXJtNjQ6IFJNRTogQ29uZmlndXJlIG1h
eCBTVkUgdmVjdG9yIGxlbmd0aCBmb3IgYSBSZWFsbQ0KPiAgIGFybTY0OiBSTUU6IFByb3ZpZGUg
cmVnaXN0ZXIgbGlzdCBmb3IgdW5maW5hbGl6ZWQgUk1FIFJFQ3MNCj4gICBhcm02NDogUk1FOiBQ
cm92aWRlIGFjY3VyYXRlIHJlZ2lzdGVyIGxpc3QNCj4gDQo+IEpvZXkgR291bHkgKDIpOg0KPiAg
IGFybTY0OiBSTUU6IGFsbG93IHVzZXJzcGFjZSB0byBpbmplY3QgYWJvcnRzDQo+ICAgYXJtNjQ6
IFJNRTogc3VwcG9ydCBSU0lfSE9TVF9DQUxMDQo+IA0KPiBTdGV2ZW4gUHJpY2UgKDMxKToNCj4g
ICBhcm02NDogUk1FOiBIYW5kbGUgR3JhbnVsZSBQcm90ZWN0aW9uIEZhdWx0cyAoR1BGcykNCj4g
ICBhcm02NDogUk1FOiBBZGQgU01DIGRlZmluaXRpb25zIGZvciBjYWxsaW5nIHRoZSBSTU0NCj4g
ICBhcm02NDogUk1FOiBBZGQgd3JhcHBlcnMgZm9yIFJNSSBjYWxscw0KPiAgIGFybTY0OiBSTUU6
IENoZWNrIGZvciBSTUUgc3VwcG9ydCBhdCBLVk0gaW5pdA0KPiAgIGFybTY0OiBSTUU6IERlZmlu
ZSB0aGUgdXNlciBBQkkNCj4gICBhcm02NDogUk1FOiBpb2N0bHMgdG8gY3JlYXRlIGFuZCBjb25m
aWd1cmUgcmVhbG1zDQo+ICAgS1ZNOiBhcm02NDogQWxsb3cgcGFzc2luZyBtYWNoaW5lIHR5cGUg
aW4gS1ZNIGNyZWF0aW9uDQo+ICAgYXJtNjQ6IFJNRTogUlRUIHRlYXIgZG93bg0KPiAgIGFybTY0
OiBSTUU6IEFsbG9jYXRlL2ZyZWUgUkVDcyB0byBtYXRjaCB2Q1BVcw0KPiAgIEtWTTogYXJtNjQ6
IHZnaWM6IFByb3ZpZGUgaGVscGVyIGZvciBudW1iZXIgb2YgbGlzdCByZWdpc3RlcnMNCj4gICBh
cm02NDogUk1FOiBTdXBwb3J0IGZvciB0aGUgVkdJQyBpbiByZWFsbXMNCj4gICBLVk06IGFybTY0
OiBTdXBwb3J0IHRpbWVycyBpbiByZWFsbSBSRUNzDQo+ICAgYXJtNjQ6IFJNRTogQWxsb3cgVk1N
IHRvIHNldCBSSVBBUw0KPiAgIGFybTY0OiBSTUU6IEhhbmRsZSByZWFsbSBlbnRlci9leGl0DQo+
ICAgYXJtNjQ6IFJNRTogSGFuZGxlIFJNSV9FWElUX1JJUEFTX0NIQU5HRQ0KPiAgIEtWTTogYXJt
NjQ6IEhhbmRsZSByZWFsbSBNTUlPIGVtdWxhdGlvbg0KPiAgIGFybTY0OiBSTUU6IEFsbG93IHBv
cHVsYXRpbmcgaW5pdGlhbCBjb250ZW50cw0KPiAgIGFybTY0OiBSTUU6IFJ1bnRpbWUgZmF1bHRp
bmcgb2YgbWVtb3J5DQo+ICAgS1ZNOiBhcm02NDogSGFuZGxlIHJlYWxtIFZDUFUgbG9hZA0KPiAg
IEtWTTogYXJtNjQ6IFZhbGlkYXRlIHJlZ2lzdGVyIGFjY2VzcyBmb3IgYSBSZWFsbSBWTQ0KPiAg
IEtWTTogYXJtNjQ6IEhhbmRsZSBSZWFsbSBQU0NJIHJlcXVlc3RzDQo+ICAgS1ZNOiBhcm02NDog
V0FSTiBvbiBpbmplY3RlZCB1bmRlZiBleGNlcHRpb25zDQo+ICAgYXJtNjQ6IERvbid0IGV4cG9z
ZSBzdG9sZW4gdGltZSBmb3IgcmVhbG0gZ3Vlc3RzDQo+ICAgYXJtNjQ6IFJNRTogQWx3YXlzIHVz
ZSA0ayBwYWdlcyBmb3IgcmVhbG1zDQo+ICAgYXJtNjQ6IFJNRTogUHJldmVudCBEZXZpY2UgbWFw
cGluZ3MgZm9yIFJlYWxtcw0KPiAgIGFybV9wbXU6IFByb3ZpZGUgYSBtZWNoYW5pc20gZm9yIGRp
c2FibGluZyB0aGUgcGh5c2ljYWwgSVJRDQo+ICAgYXJtNjQ6IFJNRTogRW5hYmxlIFBNVSBzdXBw
b3J0IHdpdGggYSByZWFsbSBndWVzdA0KPiAgIGFybTY0OiBSTUU6IEhpZGUgS1ZNX0NBUF9SRUFE
T05MWV9NRU0gZm9yIHJlYWxtIGd1ZXN0cw0KPiAgIEtWTTogYXJtNjQ6IEV4cG9zZSBzdXBwb3J0
IGZvciBwcml2YXRlIG1lbW9yeQ0KPiAgIEtWTTogYXJtNjQ6IEV4cG9zZSBLVk1fQVJNX1ZDUFVf
UkVDIHRvIHVzZXIgc3BhY2UNCj4gICBLVk06IGFybTY0OiBBbGxvdyBhY3RpdmF0aW5nIHJlYWxt
cw0KPiANCj4gU3V6dWtpIEsgUG91bG9zZSAoMyk6DQo+ICAga3ZtOiBhcm02NDogSW5jbHVkZSBr
dm1fZW11bGF0ZS5oIGluIGt2bS9hcm1fcHNjaS5oDQo+ICAga3ZtOiBhcm02NDogRG9uJ3QgZXhw
b3NlIGRlYnVnIGNhcGFiaWxpdGllcyBmb3IgcmVhbG0gZ3Vlc3RzDQo+ICAgYXJtNjQ6IFJNRTog
QWxsb3cgY2hlY2tpbmcgU1ZFIG9uIFZNIGluc3RhbmNlDQo+IA0KPiAgRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS9hcGkucnN0ICAgICAgIHwgICA5MSArLQ0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2Fz
bS9rdm1fZW11bGF0ZS5oIHwgICA0MCArDQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9o
b3N0LmggICAgfCAgIDE3ICstDQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ybWUuaCAg
ICAgfCAgMTM3ICsrKw0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9ybWlfY21kcy5oICAgIHwg
IDUwOCArKysrKysrKw0KPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9ybWlfc21jLmggICAgIHwg
IDI1OSArKysrDQo+ICBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL3ZpcnQuaCAgICAgICAgfCAgICAx
ICsNCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaCAgICB8ICAgNDkgKw0KPiAg
YXJjaC9hcm02NC9rdm0vS2NvbmZpZyAgICAgICAgICAgICAgIHwgICAgMSArDQo+ICBhcmNoL2Fy
bTY0L2t2bS9NYWtlZmlsZSAgICAgICAgICAgICAgfCAgICAzICstDQo+ICBhcmNoL2FybTY0L2t2
bS9hcmNoX3RpbWVyLmMgICAgICAgICAgfCAgIDQ4ICstDQo+ICBhcmNoL2FybTY0L2t2bS9hcm0u
YyAgICAgICAgICAgICAgICAgfCAgMTYwICsrLQ0KPiAgYXJjaC9hcm02NC9rdm0vZ3Vlc3QuYyAg
ICAgICAgICAgICAgIHwgIDEwNCArLQ0KPiAgYXJjaC9hcm02NC9rdm0vaHlwZXJjYWxscy5jICAg
ICAgICAgIHwgICAgNCArLQ0KPiAgYXJjaC9hcm02NC9rdm0vaW5qZWN0X2ZhdWx0LmMgICAgICAg
IHwgICAgNSArLQ0KPiAgYXJjaC9hcm02NC9rdm0vbW1pby5jICAgICAgICAgICAgICAgIHwgICAx
NiArLQ0KPiAgYXJjaC9hcm02NC9rdm0vbW11LmMgICAgICAgICAgICAgICAgIHwgIDIwMSArKy0N
Cj4gIGFyY2gvYXJtNjQva3ZtL3BtdS1lbXVsLmMgICAgICAgICAgICB8ICAgIDYgKw0KPiAgYXJj
aC9hcm02NC9rdm0vcHNjaS5jICAgICAgICAgICAgICAgIHwgICAzMCArDQo+ICBhcmNoL2FybTY0
L2t2bS9yZXNldC5jICAgICAgICAgICAgICAgfCAgIDIzICstDQo+ICBhcmNoL2FybTY0L2t2bS9y
bWUtZXhpdC5jICAgICAgICAgICAgfCAgMTk5ICsrKw0KPiAgYXJjaC9hcm02NC9rdm0vcm1lLmMg
ICAgICAgICAgICAgICAgIHwgMTcwOA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAg
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyAgICAgICAgICAgIHwgICA0OSArLQ0KPiAgYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYyAgICAgIHwgICAgMiArLQ0KPiAgYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXYzLmMgICAgICAgIHwgICAgNiArLQ0KPiAgYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLmMgICAgICAgICAgIHwgICA1NCArLQ0KPiAgYXJjaC9hcm02NC9tbS9mYXVsdC5jICAg
ICAgICAgICAgICAgIHwgICAzMSArLQ0KPiAgZHJpdmVycy9wZXJmL2FybV9wbXUuYyAgICAgICAg
ICAgICAgIHwgICAxNSArDQo+ICBpbmNsdWRlL2t2bS9hcm1fYXJjaF90aW1lci5oICAgICAgICAg
fCAgICAyICsNCj4gIGluY2x1ZGUva3ZtL2FybV9wbXUuaCAgICAgICAgICAgICAgICB8ICAgIDQg
Kw0KPiAgaW5jbHVkZS9rdm0vYXJtX3BzY2kuaCAgICAgICAgICAgICAgIHwgICAgMiArDQo+ICBp
bmNsdWRlL2xpbnV4L3BlcmYvYXJtX3BtdS5oICAgICAgICAgfCAgICA1ICsNCj4gIGluY2x1ZGUv
dWFwaS9saW51eC9rdm0uaCAgICAgICAgICAgICB8ICAgMjkgKy0NCj4gIDMzIGZpbGVzIGNoYW5n
ZWQsIDM3MDkgaW5zZXJ0aW9ucygrKSwgMTAwIGRlbGV0aW9ucygtKSAgY3JlYXRlIG1vZGUgMTAw
NjQ0DQo+IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX3JtZS5oICBjcmVhdGUgbW9kZSAxMDA2
NDQNCj4gYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9ybWlfY21kcy5oICBjcmVhdGUgbW9kZSAxMDA2
NDQNCj4gYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9ybWlfc21jLmggIGNyZWF0ZSBtb2RlIDEwMDY0
NA0KPiBhcmNoL2FybTY0L2t2bS9ybWUtZXhpdC5jICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC9h
cm02NC9rdm0vcm1lLmMNCj4gDQo+IC0tDQo+IDIuNDMuMA0K

