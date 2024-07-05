Return-Path: <kvm+bounces-21051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E2B9928F71
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2024 00:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 097A31F22133
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 22:53:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55F1168493;
	Fri,  5 Jul 2024 22:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fLofhqMJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F5145A0B;
	Fri,  5 Jul 2024 22:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720219994; cv=fail; b=srsut9LfrLHyGEFgazuppBFlbjvWPd88qkaCuwaVHs+TR7LsY7QVtVyZavltLl6QQoUShzNlbyAphHQWbvVKpyh+kbIjYgE3rTgNDi5vw2sTTuEXsGr59dnboXzP8WGDkAzsljB3AnHha/8odybm5nsBp+rwSEX3YfG9q3D4VTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720219994; c=relaxed/simple;
	bh=4ejWxWKsAmkFtGAqMmBv5O0WoWxkiXoggkTY2HGzNGc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UuaU/w1LsrsZbqpNeN4Dfgj0MNKHW0CcPju45OHEdenkNJ5+L4B1GmBb6XQZVV1rNUfyVbH29XCt9lG4dTxftrydgxMuEKymJjSuwm6F2OOdo5mtxtJOfLqIeXCyxOBoBLFQ+WbNFjvBs3e3b3k3EeVmqx0Q+Enld9XGIwktRWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fLofhqMJ; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZjZMRov1MuKOM9K3WJR/PwDca9NH7iUX09jL/B05cZ75cuEUDM1PqbZszrOf9fXLlBktBxUK9p/VMec1IDBDyzobxhu6QiUVve2gRcE1DdgKsVZxOg1bq5+tjELdZCDO7WJ0ZZBDkEibmrDF38Fqhm+HOFEzsA40HF6c8wf5oviaEmg5Mf3Lfe4K10kIXYYKsgU+G1kaGWmyB3WZo2vePenE+Uh4MpFyWJ4WdZSifBQga0QI0Z4vuvN9XhK8GmeXhhGqk7rnqza+fyV5ucKYFiG1msRGTyunsgVTAz3sxi6FOgdT+eZT4h+4yhU4TsajR4BCDC3j714LMKWgNMC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ejWxWKsAmkFtGAqMmBv5O0WoWxkiXoggkTY2HGzNGc=;
 b=K5hdMisStNfChJ7FJrTwSISvtUScY7zmveP6czwZiluUZQ/q9vmCagCXJvPWfTpjUMcRTr+bzsQfzGkvgFySsFIk7VLa+etMoYFVhka78Fgf03wygx7FkqxNZ8PD8jyz2ofDAlFDVyaeP0L58xqMMECbZY7GAU7s7QqfJUbgirSaRUSOlHUTuRGhwX3uKTDeZH2ujA1YJX3xYw6zg3EioMIBc95QCD9N7mH5DutPPf2j+5cX5pGIZozGU0gQy1r8KIXYe6P1okTm/QrSZtnyR7ilVyMkUrABdzuODFNcYu0xxTLqqGiReZYRQR8RMoBCSINvoLdte3cChXXsgFq2nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ejWxWKsAmkFtGAqMmBv5O0WoWxkiXoggkTY2HGzNGc=;
 b=fLofhqMJYjPyutEnitf2NkcCfjmzIswZiG0fTFY03JctHEBY5udt3BqHTf3fuEFynVccpzFRhUZ2KpuFDJuum3wJ2oYL1NhLcdVqxbtcAqtjgYoQJNMkqZ4WGlykalGxO459wA3nPIbsyvhKPx0IV1xtX8D7/Qj6qUUGTXWca8ewZWB8AGtk++/K1BpGkk0TZuI7LBVEjzKAFlVncD3fQ9cMDFFAuOOl7HOSnnBUodx3TtNtdqpDWMArzWsa/LSGHHPBli3BaMzzYNhCC6ZKkmubrusYsHlaq/LqWUdO6FVfPopY/6+wNwrQeIgEExsJvulI8ud9TOr9z/qWdWp3JQ==
Received: from LV3PR12MB9404.namprd12.prod.outlook.com (2603:10b6:408:219::9)
 by SJ2PR12MB7822.namprd12.prod.outlook.com (2603:10b6:a03:4ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.25; Fri, 5 Jul
 2024 22:53:06 +0000
Received: from LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b]) by LV3PR12MB9404.namprd12.prod.outlook.com
 ([fe80::57ac:82e6:1ec5:f40b%5]) with mapi id 15.20.7741.027; Fri, 5 Jul 2024
 22:53:06 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy
	<robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>, Keith Busch <kbusch@kernel.org>, "Zeng, Oak"
	<oak.zeng@intel.com>, Chaitanya Kulkarni <chaitanyak@nvidia.com>, Sagi
 Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>, Logan
 Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>, Shameer
 Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian
	<kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, Marek
 Szyprowski <m.szyprowski@samsung.com>, =?utf-8?B?SsOpcsO0bWUgR2xpc3Nl?=
	<jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
Subject: Re: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Thread-Topic: [RFC PATCH v1 00/18] Provide a new two step DMA API mapping API
Thread-Index: AQHazF+htO0U/r7i6UGE17elces3prHkfuAAgABWr4CAAD4zAIADr7CA
Date: Fri, 5 Jul 2024 22:53:06 +0000
Message-ID: <a7f1c69a-bbaf-4263-b2c2-3c92d65522c2@nvidia.com>
References: <cover.1719909395.git.leon@kernel.org>
 <20240703054238.GA25366@lst.de> <20240703105253.GA95824@unreal>
 <20240703143530.GA30857@lst.de>
In-Reply-To: <20240703143530.GA30857@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9404:EE_|SJ2PR12MB7822:EE_
x-ms-office365-filtering-correlation-id: 21b83523-1016-4b92-df13-08dc9d453bfd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d3NYUC9UaDBMZVRVYUhXOEFNYkxhSzdMdExUT1RRZkl6L2tzQTlWTmcxZ0J0?=
 =?utf-8?B?NDZPNzVwVVJrSjRvZ1VraTZpZ0M3a1k2TzdwN0ZCWExpZWpRbHJYbXhJYmJx?=
 =?utf-8?B?bjJBQnhSaDhMclJTS2FFR0lQWGFPeENCd2JNUmpvZ3dVVmQwMHhFZzhKMzNj?=
 =?utf-8?B?Nmh0aW9Ld3hDaWVkTncvaDRRTEJPd1FsMXVWQlMzeW92ZGwwNk5PLzhXcXpp?=
 =?utf-8?B?WGFRSVNRSHlSTTJGZ2NPd2lIekI3QkloT2ROTFJZdk9qYXVlZzRDVUw3dEpG?=
 =?utf-8?B?Yyt3b3BQMURGOTVVSExKZTFsSENnSUY3eXdQNWpSMDhBUnByRXR2a1R3MHht?=
 =?utf-8?B?OTZuVWc2Ulltd2s1VTZEUFNjZVA5aEVXeTZaRkNHSVB6MW1QbktUV0QxZThO?=
 =?utf-8?B?MU5qS3RLbm5WT3dremswVjdQR0JHQzVaTXMxclprOS94VHNaeDZ0RzlOTXpT?=
 =?utf-8?B?clhZd21WOVhTdS96Ly9jUnBIYmJWV2MrK005QmZrTWRKeFllaXRBZ2xpTENu?=
 =?utf-8?B?SDY4M0FDbVpNVkQ5UkZmcjBQSTZiMlZXU1M1RkVpdzRNckRUZy9PanJ2TUJ3?=
 =?utf-8?B?R0txaytqRXFHTmxTNVhNM0ltelVJYS8wYUVWL2NRaW5TVXZYZHFEcUVpQklp?=
 =?utf-8?B?WDJJOFRUdFdYaEVSbkJHdFRwa2QrTGZtV1oyVGMvN051ZkVyQ29HQ0xMeW1u?=
 =?utf-8?B?TlI5aHZVZ3VUWEhET2ljSmF0Mko5Q2dIMFZpcFM3TG1hcUNVQnZyVjFNNDVn?=
 =?utf-8?B?WXV1aXVMTVhSMElxNTd4UDUwSkxJN1ZydWZOYkswSEJaaGQ4clRicWE2S1By?=
 =?utf-8?B?UWs5a016djM2ZS9vSlNzMEhQeit1empiNG9pR3A3aXNHQ1ZvdHlmRm52U0pa?=
 =?utf-8?B?VEtwbksramd6V2N1ZkdpMDh6cEczMnJGWGFzR24rUmtZUWxwcm5hMkNOcHBz?=
 =?utf-8?B?U3ZTampJemtXcFlxMW1wdFBzSFl1Y2RsY3VlSitUM1J2WEhMdy9FK0F3VnRU?=
 =?utf-8?B?UnNsNVlnUURKbkZ1U0VGSGdkU0FiWUZucFUrRzJ4L203clpQS3Z4cjg3Q1dS?=
 =?utf-8?B?Ky9qN25ZS3N6b2wyYXJxYzRvRXNlRkd3dWJJa2pVb1BRNkpjbGtFMHduQjcr?=
 =?utf-8?B?aDhWNU81YTZiZTR4akttUzNZT1ZGNTdOMXlRYTdpU05CKzJqdnVBVGVST0Fh?=
 =?utf-8?B?ZEplRTE2dUlpbTNrMjlpakNqaGZFenFva0pxbjZHTUtNT2V5aFRTVWNtVzcz?=
 =?utf-8?B?R01SakJBbHRFbTB6cEZpeTZzRkVMRXZDeFBiUVpSYkpwVHdCa01BN3ZGc1dU?=
 =?utf-8?B?d3JwUTVzeTF4KzNHdTUvenAvTWFlRnBuRHRlSWxSb29zd2JGSDVZdThENGVG?=
 =?utf-8?B?cE00Um9LMkJJUUUyZHpXSlZ5dkwyQ2w2WG1rN2lhTkptVUR0UW15S3ppcWxw?=
 =?utf-8?B?TzNxaDZ3ZUJoZkwxR2hqUEpsMEJiNU1yOTNVVEwwMThhU0d5ZUw0WFJvZkNG?=
 =?utf-8?B?RGplTk9zTHVqZ2wrK3VwZGgycjlPa3JuWlNVcWpFc1EwOEMycFdKZHdmNHV1?=
 =?utf-8?B?MG9jQS9vUnBzYlY0TE9TRVoyMFhnQVJEZjYwM3gyN0lZQkhPSEErTU5Na0lh?=
 =?utf-8?B?d1FZbXBTdGFONlVrNWF0dzVIbmcvZEoxYXo2emk5cko4bTJOU1piejQ0amw2?=
 =?utf-8?B?c1VxVXlacnVGTm1yaFVCUmNuV2ZpQkszVCtjd0dQeW1rVEVHR2FkTHRuT3Nu?=
 =?utf-8?B?MFF2UDdleGk1M0ZBL3ZCSHlxY1NMSUZIS3NiTS9Jdzk4ZmdXYWtsYVpXaTM2?=
 =?utf-8?B?TCtZZXNQN0JTTEk4bjdiVElRU3ExRitWSlE4R1BTODd4S01wTDNYSjc2eGpm?=
 =?utf-8?B?NzdGc0FCM2RReHdzZElacVRRVGtvdFpGbG9BMjNwZ05SalE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9404.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VDJkVWIzZWt4MmVSKzkwR1BBTTlaNVN1SFpWSG5GTWhaWE9SdW1rS3AwbWJK?=
 =?utf-8?B?d3pwOGxZK2RSTGNJdHlMZ3JnUFI5dk12K2JwaXd0RTJlVkh4cmx3OEhPTUs4?=
 =?utf-8?B?WE1rZkliVWZrWmlmOEtvYnFQZmJQNmNVTFIzUjdYRDBlMnhOTGFTZFUzK1d0?=
 =?utf-8?B?MWdkRWRPWG1yQk4vdWVjblBmaEdHUVpWbHJYNmRDVHV1V1BaY0wrUVVrS1di?=
 =?utf-8?B?WHQrcFM0UkZoN2tmay9nNlN3UVRrTVVNS3YvY2hSdWhqOGcwY2RScTkzYzIw?=
 =?utf-8?B?NHZpL1l5M1ZONmdKbHVUNStXd0EyaVd5eXNSRXd6czZKdit2Z1hpNzgvZER6?=
 =?utf-8?B?c1AyNU1Qci8zK1h0Yi9JQzYwQXZZVUdFSldoSTg2RHNjL1Z4YmRwWTMxb3g4?=
 =?utf-8?B?ejV5dW10Zk1MY2UwdURDekVzTTFzcmdvKzF1NjJuR2hrZ1pYZzBOT0QvODRK?=
 =?utf-8?B?Y3R2TkxaVmdmc0RZVHRNZkxUSjRlb2tqRUFLNWxKSWNRZERaMjExNUtpQmlO?=
 =?utf-8?B?bHdwL0J5Nys2VW1mREFuNkMyY2hsL2doWjZqTTVDNllsekpTOUI1RzVrbDBB?=
 =?utf-8?B?aCs2RUpQRHVueUxBd0xObmxYc1hqNXNCcGdQeStxYXJzZmdMYThDckRmQmpr?=
 =?utf-8?B?Vm1wMmEyYXVYU21ITTBPc2U1T0RKdjdtZ0NLVkhQTTJRazFyWXBXdDRwSlFZ?=
 =?utf-8?B?UjY0NEFOc3VlUERvMGdVWjIxMEgwWUpxbk5JUGl5SC91MDNCWWQ0OHpoYkZG?=
 =?utf-8?B?RCtiOWdwMHRKc2xRbjVMTEQ3dVJiM3NvZmhEa3AvdndPRkVtdk9CNnd2dllX?=
 =?utf-8?B?ekhTeE80YS9lN0MxUlFhV3Q0NE56bG12WU4xb29oTnJOSEMzMmI5NUR0VWRw?=
 =?utf-8?B?dThtTDJOQ1ZMRnhpVzhHL1gxUXcrWlRpVW0yUTNlMStzdWx6ckdqNEh1MW5U?=
 =?utf-8?B?L1U3U2NjL1hDL1BmY29uL0JXMjRTbkVVcEIvaVN0bzhqZWJmN1BYbVNDTG9y?=
 =?utf-8?B?T0FpK2VQakVCbnJXRXppRU10SlUvZmdsZXdlenlMdHJQbnk4TmlySDUzYkRr?=
 =?utf-8?B?cnlSUW9kY3k1NU5XaFU4b0tYR2wzdkg5cE1NNFVMK1BvTjVPNkc0Zm1YTHNy?=
 =?utf-8?B?Vys0QlF0Y0JLZTdidXFEUjRVTko4Y1UxTFUzU2xkSjN6bXAraWlxQmFNR0FT?=
 =?utf-8?B?bkIrenBpSXhkSUdLcDNodlBSc2RKQmdsUkFJenJqdFVCM0VzcUZUb3oreXhQ?=
 =?utf-8?B?MmJ4YnVpVUkvNkdRT3RmdW93N0V3MVhyb20yRnNBRTdIWWNwaWszVUlodzNs?=
 =?utf-8?B?NHl3ZHVzRDV1WUVTV0VrTFJsRUpRV25Sak1rYklLRGZOOXM2UU5NemtlUWUz?=
 =?utf-8?B?MnY3NmNCSGt0RC9SWUlQcVpXeDY0SFhhTnF0ajdacENuQkYxWEpqTWwvVjQy?=
 =?utf-8?B?ZnUrTGw3WG9CSklvaWNFcGlDYkVvYXlZbHNNVndScjZOb3VrMmtjSGlEWk04?=
 =?utf-8?B?TmsvVEp2Rnp6MmxYQ0Z5YzE4alViWllLSzZiUWhwWXZiVWk0c2xWRUxucWhV?=
 =?utf-8?B?R1RxWDBrWVk2Qk4raUFhWmhhTjdjN1pDSThKN0JMdlFPZUpDckgrM0MzS3lo?=
 =?utf-8?B?OEpBNmdBUHp3a1hrOUFBc3lFcUxEeCtuM29RQmJJaTAyeDJDVzh1MDZQMjhw?=
 =?utf-8?B?VUtHUFVwc2tWYzVGV2VzYWEzT2xGTjloNjRGMER1UDNKOGhONnovWXRHc3Zq?=
 =?utf-8?B?Z3pMNnc1R2YyU1M1SzR1U0RkU0o0d28rcWpIb3ZCVkgrMXVTM1B6b0xWTWxv?=
 =?utf-8?B?UVdYWmlDZlNESkdpLzVuU214TnlFcEt0bnZaeW1vcGY1L3ExQUFUdEJMTzB1?=
 =?utf-8?B?VmtPdnZJODRLMU1Eb3p1TFA3U1hLNmJGY0RZYXlleElFR3pFbkN5N05mclBH?=
 =?utf-8?B?NFFZdjIyQ2FJR0R2K2tTOGh6OE12cGl4VGZVbG5vdDNOa3ptMXhKeDBkeGRJ?=
 =?utf-8?B?Slljdno0d1pLeTVsd04xRnNSUHdhbGUxdFZXOWJrdUJkTm5udTNFc25sS2J5?=
 =?utf-8?B?aFJqU0p6U1BNL0xGRHNCTkhWdEVwSVhGck8rYXYwRUg4Ym9KZU5LM2F5S1Ri?=
 =?utf-8?B?Y1E1ZVIwM2VrWHhBVEYzQjg4RUlIMVpOQkVwUGVZc09MRTIxa2tPdk12d05R?=
 =?utf-8?Q?CSuqlpNb5Fl0htKknSy0CujoGJxtbymdjpaDTcQz24EL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B8C068E920D594CA84292023EBE3B6E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9404.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21b83523-1016-4b92-df13-08dc9d453bfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2024 22:53:06.4069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E5WR6RD41uwzVjiXkQEdSI/vZ/HpgHrk/wiweuQ0W1gP3JX9Bfdm3SEBKeHrNuN+l+cAycWABq+3PWcY68zn8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7822

T24gNy8zLzI0IDA3OjM1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gT24gV2VkLCBKdWwg
MDMsIDIwMjQgYXQgMDE6NTI6NTNQTSArMDMwMCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPj4g
T24gV2VkLCBKdWwgMDMsIDIwMjQgYXQgMDc6NDI6MzhBTSArMDIwMCwgQ2hyaXN0b3BoIEhlbGx3
aWcgd3JvdGU6DQo+Pj4gSSBqdXN0IHRyaWVkIHRvIGJvb3QgdGhpcyBvbiBteSB1c3VhbCBxZW11
IHRlc3Qgc2V0dXAgd2l0aCBlbXVsYXRlZA0KPj4+IG52bWUgZGV2aWNlcywgYW5kIGl0IGRlYWQt
bG9vcHMgd2l0aCBtZXNzYWdlcyBsaWtlIHRoaXMgZmFpcmx5IGxhdGUNCj4+PiBpbiB0aGUgYm9v
dCBjeWNsZToNCj4+Pg0KPj4+IFsgICA0My44MjY2MjddIGlvbW11OiB1bmFsaWduZWQ6IGlvdmEg
MHhmZmY3ZTAwMCBwYSAweDAwMDAwMDAxMGJlMzM2NTAgc2l6ZSAweDEwMDAgbWluX3BhZ2VzeiAw
eDEwMDANCj4+PiBbICAgNDMuODI2OTgyXSBkbWFfbWFwcGluZ19lcnJvciAtMTINCj4+Pg0KPj4+
IHBhc3NpbmcgaW50ZWxfaW9tbXU9b2ZmIGluc3RlYWQgb2YgaW50ZWxfaW9tbXU9b24gKGV4cGVj
dGVkbHkpIG1ha2VzDQo+Pj4gaXQgZ28gYXdheS4NCj4+IENhbiB5b3UgcGxlYXNlIHNoYXJlIHlv
dXIga2VybmVsIGNvbW1hbmQgbGluZSBhbmQgcWVtdT8NCj4+IE9uIG15IGFuZCBDaGFpdGFueWEg
c2V0dXBzIGl0IHdvcmtzIGZpbmUuDQo+IHFlbXUtc3lzdGVtLXg4Nl82NCBcDQo+ICAgICAgICAg
IC1ub2dyYXBoaWMgXA0KPiAJLWVuYWJsZS1rdm0gXA0KPiAJLW0gNmcgXA0KPiAJLXNtcCA0IFwN
Cj4gCS1jcHUgaG9zdCBcDQo+IAktTSBxMzUsa2VybmVsLWlycWNoaXA9c3BsaXQgXA0KPiAJLWtl
cm5lbCBhcmNoL3g4Ni9ib290L2J6SW1hZ2UgXA0KPiAJLWFwcGVuZCAicm9vdD0vZGV2L3ZkYSBj
b25zb2xlPXR0eVMwLDExNTIwMG44IGludGVsX2lvbW11PW9uIiBcDQo+ICAgICAgICAgIC1kZXZp
Y2UgaW50ZWwtaW9tbXUsaW50cmVtYXA9b24gXA0KPiAJLWRldmljZSBpb2gzNDIwLG11bHRpZnVu
Y3Rpb249b24sYnVzPXBjaWUuMCxpZD1wb3J0OS0wLGFkZHI9OS4wLGNoYXNzaXM9MCBcCQ0KPiAg
ICAgICAgICAtYmxvY2tkZXYgZHJpdmVyPWZpbGUsY2FjaGUuZGlyZWN0PW9uLG5vZGUtbmFtZT1y
b290LGZpbGVuYW1lPS9ob21lL2hjaC9pbWFnZXMvYm9va3dvcm0uaW1nIFwNCj4gCS1ibG9ja2Rl
diBkcml2ZXI9aG9zdF9kZXZpY2UsY2FjaGUuZGlyZWN0PW9uLG5vZGUtbmFtZT10ZXN0LGZpbGVu
YW1lPS9kZXYvbnZtZTBuMXA0IFwNCj4gCS1kZXZpY2UgdmlydGlvLWJsayxkcml2ZT1yb290IFwN
Cj4gCS1kZXZpY2UgbnZtZSxkcml2ZT10ZXN0LHNlcmlhbD0xMjM0DQo+DQoNCkkgdHJpZWQgdG8g
cmVwcm9kdWNlIHRoaXMgaXNzdWUgc29tZWhvdyBpdCBpcyBub3QgcmVwcm9kdWNpYmxlLg0KDQpJ
J2xsIHRyeSBhZ2FpbiBvbiBMZW9uJ3Mgc2V0dXAgb24gbXkgU2F0dXJkYXkgbmlnaHQsIHRvIGZp
eCB0aGF0DQpjYXNlLg0KDQotY2sNCg0KDQoNCg==

