Return-Path: <kvm+bounces-66598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD9BCD81AE
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:10:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4469730A9540
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5D32F533E;
	Tue, 23 Dec 2025 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EPiMElSZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Zn4u90AE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912F32F4A19
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466311; cv=fail; b=b6UXhGPQelFkhS0kbmuMUA37KStyvKCKdWvjQ+XbfS4zA1vAFSgAad2vUP/svkVLxeohGwnvSx95QkI27nNcV4ZCzqz2XG4satI0lesE3thvY3IhS108rJ/jCz9cWaCB30oU2r/kmZQ5rtXDcxwKkswCGPn1w24z9jNIKR2tbxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466311; c=relaxed/simple;
	bh=YhYFyOANB4ccCizP9nTgXnGyI98VE2AGFzG1Y1FWVOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cCWA3XK3awRzp5m8Mn+sxQuxXX3+cBXTkdnqKlTm3odq7ulqqoBGW3bKvqcYJIO82mrfWPRTPLVvkYCaSasRAl1uhpqRVozjUHWl6SA7SfJejyRD0dpnfdOw4bA8wuPhclAB1LIFEQP+aKAIk431qY5fMFmGIXtzL/V2QqcIZ80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EPiMElSZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Zn4u90AE; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Loae733160;
	Mon, 22 Dec 2025 21:05:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=K59Atg1kGI6ejpCUQDy4+O8tdigkzUYDugAw6t8iV
	jM=; b=EPiMElSZrIJSYC8tLYcP+hOSUQivsYFeWBByJho4LjfGOSc3pn0HAvfTS
	jeMeIeyUYHb5Bq8vXiF2BRjqbfx/RF+/KF7/dJ7Ddg27GdevDtRLeh6OVhBQ1Vu5
	j6hnF1Jkthj+HR7mwOQkVoq1MEWMxVDRYosr2++JNfabWo7GwPHHnF8vFhOQtVzC
	8+PIw7F6GOWD7YTBr4rjCPyfEYy0yXaMxIrjwXkCKZ4W12qc6mo0HiWO5jYowEQg
	5iQUzELiEN8DLznKg114IvDIw83c7acn+rucUIYdPx/I5U+ecCv30fTlvwmzbgYK
	0J4mEKEIzPXtcwvd+YnhR1a7kXhxw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-5
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uvqDL4J1OE1s1BwokFy/02cxgOwDZNIjXkA85KuvEGy8aNzA89YCUZr/zWZ1tn+PlpyaAXiiHtjB1tgvLdAmM6Fo57Gw7ce/7gpaCBAcSa1kBp3CWeufrhkJn4NcC/NUCinCOivCXBBeQTea9ZQM3Vj3kDj6EiC5G9159ZGg1JiFLjZC9zEQbo/nfbXbsU1MFMfwiL8w2/npA0kSzUlNstP3FuDimnZJ8xjo8hMgrBSe9UYzKw3Y89aCex11JPGvOmfzZ7vPHpkFD4qv30q4IEyvY5oxsALe58ZfSXqMbHcDVXsvko+j9HboXZoFw1CNuQf+bSyPZpR+qsgEQJWFOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K59Atg1kGI6ejpCUQDy4+O8tdigkzUYDugAw6t8iVjM=;
 b=mt2l2izqh4fXh9Rojq55rDQJdxnQ9WFx7YZxL1JE2UnJo5I4GZ7DZOrXpKg7fItIMfevQu5sodXYF0fxBqDbzgHvCy2v5L9ORqkRGZSrUxed2GvxPJyhO2KcNPkS/+NiKhF572W5eibNFZZCNgsbEi32xZ0Y0KnCU0DPUWS+nUnD3QZ51hipV/clozo1wptFvqjNRJ9cJ1KH/kLcmPlfqFBe/g3GruS3fGyGnIFi7+xpeRTxyHJZARlmQ2ubkVr0Sy2Q1aDMxmnxcOH9+jYK/yk0eaGmjBaYBRbATsZyvX69ZDPmTm3xqCijtFRkKrC1OMW5XLGWeurDQEsDV6u2sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K59Atg1kGI6ejpCUQDy4+O8tdigkzUYDugAw6t8iVjM=;
 b=Zn4u90AEmTt0qcU3HcoOXlA3koMarEnX5xhhX7oEC5PnWnAsxm2lJa149yjDOaf/lu446JPuzD6YiRkFr7cVY+S3o9CWGF7fSdxY2HKNDiav5nGrMYujc7WPnAz6aN1xHUpehegJq6OWi2i+FlGMgBERaOtWO5zF5N7TNmrE/mkHaqInIc4tFNtQQFWhTSnKRbOHQr1+g7Yqb2b7vL8bvV3uXgGCX2C+SXPwfvI0+oN5L2pSIQA4k3VLr3Qu9x5n/BAC1nxTYdsrULWcT32/wcSBmUkmknDnuzEXApl6FS1NalDzW+m1vY0IWHtNFCFEzfIg+miDJbvDx26RS3fhcQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:02 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:02 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 09/10] x86/vmx: add EPT user-only execute access test for MBEC support (needs help)
Date: Mon, 22 Dec 2025 22:48:49 -0700
Message-ID: <20251223054850.1611618-10-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: 59034d45-0f9c-4752-7c87-08de41e0d465
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tG32BkxHxCRml8cGbF8odFUaTNMNrHw1z/wcpeH0gBTfHleB8nPHiB1hD0gt?=
 =?us-ascii?Q?opp3RuQgD9YJW3ClP1OIDNukcMbhbthJ9Akzo3Tf/hbSz0xe2iuoLurC7oT8?=
 =?us-ascii?Q?KCnkXz57kD0QZZwPqpLMFpxEEh9C0N5nWTEaWKPpv39fQBFKz4kSF9kSeoP3?=
 =?us-ascii?Q?AZ4TwnIcpCCZtaDlWkKeDXsJbvYsujVdCfVY+guyq8yHdTaODmgFZtZDJ6JB?=
 =?us-ascii?Q?r/t4bvjvmHpTQ45JNjaJXlBwpusSsly9jbq9HFEHhnUhpytSYSC/i/ADpGMA?=
 =?us-ascii?Q?Ft3+4Scu+7ebPTq9r/sQ05tXmLjidvSnL5N2jIfX3dVZ8ta0DnJNdUUt6vF8?=
 =?us-ascii?Q?4hdV74omR2bc5jaWo8MIZ9cp5p9wVtesHmOnkTW531SHvVWpgAql7w2cHTKK?=
 =?us-ascii?Q?YP5mnYYqG4NAA4mGW2RLsTS4Sdwfl9j9qKGx4fYyDEHFyIOrPug0eHR7VcNK?=
 =?us-ascii?Q?y/prVRHmSD5wZDF3EZU1Xlm3dLLWvj3td569et/B5WnWWLJQnrN6zsDQS8JN?=
 =?us-ascii?Q?Sx8BEusRTjZpyADSbnC34qobzKfxiJC6nJdW69BFC9eID40LbSVgQaB4HDyO?=
 =?us-ascii?Q?jL00o12N77TFsDDLdqHYjAT2tSno1st+nkfyQU1X/2rT1+YrKJEBFXSkLy2R?=
 =?us-ascii?Q?TEoc0Vj09nVYFdRUBjMXTkZ8or0qj5UXFti7kGXlrYSaYJUW8gKpNDMSD+Et?=
 =?us-ascii?Q?mRzbDu0Q7zxTDmbuofmWtDBEAGk0hk7R1Rhp1B2uT9V0mKHkWAA2Gw36N2+b?=
 =?us-ascii?Q?L0t4HSAYW9TioclNhZrkKZZYg1go6BuQxtmbeW2RxIZoexCk0ZImKJCC7hOu?=
 =?us-ascii?Q?QInY6D5d6xj0qowu9UYIdcWcpM+veiPdVD4CINOG9mtzOjrZ+F7mQPRpTiCY?=
 =?us-ascii?Q?iqDpxaqpM929psnPbpSgrXeqs023dejr/yYlrKA9ZBMn3QObVGNRbfI9sPmg?=
 =?us-ascii?Q?xxHX8XomkzFeGOcDZNbCJks62VAI6aJZxB0b3WEccLesbb1n5DOt4Z8iC7fa?=
 =?us-ascii?Q?mSaHMrprGyTUtSgrGfp9myMT8P6VzzywxAJ99i07gai1eOivqpUMc4J5W2Pi?=
 =?us-ascii?Q?D4X9t+mO++b+zU99ffsDgJuBDsg/SWKm9t3VwBE0i49AaJ098dYKGMSdzCwm?=
 =?us-ascii?Q?DVDwF7yej9c0KEyfaTXwHv48JSVf6qFCboULr7ukqSra/1bZspkUVCSGfCqf?=
 =?us-ascii?Q?zKE5KKaZ9DDeeGHiuG/wzKmC3mOBPaPNwB/ipb3Z+M9UKo7qNhjksONyJa7R?=
 =?us-ascii?Q?HTgC265FnTw8T+rJohhcDPP3zSTVj2qFpi4fNswK2VdUX/uL8VjlKUKxW2eo?=
 =?us-ascii?Q?7FmEB3PZRu2bB1qeVYqmW9oz/XzKPRDQx4hHUEDIa/flisvt2T3wW9dj+rk5?=
 =?us-ascii?Q?VaYVlldjj+JrKpWCmAGQqXnNF6gtk3Djqsrs2pwDXtEVGiRa/gwZIVJARuFw?=
 =?us-ascii?Q?VhseD8mUxAQSHwMWrImmY2/NU/cyodieHKpYFWmwP0Wpa9OdV1PKRmXE6YRI?=
 =?us-ascii?Q?GXCRbUOmA3vWajbHvPhwUNWn+YLtoESh6amc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0fTSOsAJ61TFFudbjDAZvjRLWDqW95Dj+b9CDOISX7dwQn/AoNydsDRui8EK?=
 =?us-ascii?Q?+2nERQh31gZVZ2PSJixEsIe6wQd3SOQ32tr2XmzCjy4OViCta9tQacSFGDja?=
 =?us-ascii?Q?hE2+cgRKIfowoxWgBQh+KlTI9z/WBz7etfZmEJT6r2Hijgbq+mfFfAhNUQ0J?=
 =?us-ascii?Q?uzfDVKgQV9eUgsvKsd+g+7gxfClhEhg0Gq7ks9Fpov0ZI+5pMhMjBG4J2hH8?=
 =?us-ascii?Q?gl5bTQ3yZ5nzCUqXTlismswMHrYikfvzwyl+Fc2Z5ylRKd9e2ZuJ5pVGd0jP?=
 =?us-ascii?Q?ylhVqgeCwyaaJjL94qZzg1VbdazmqwkTfQZ5afb6AAioKkx9GAfVHLQ9tRWV?=
 =?us-ascii?Q?Iv/f/2jwkmZgwAhZWpqsFIequEHKEM+5CZ3qeqsweLHDnoZAfGQiXtxjolLh?=
 =?us-ascii?Q?/hucrMtZtY3wuRv6lQu3w9wIhktNvIBMcUySkHpbGAk9ZGkRRnmEF84RCyKm?=
 =?us-ascii?Q?iVtW5qIRnB7TQb/SPKypm99GEKoc4zeplCcdaA4yqvuQR0ccJQf6vCt4e7+7?=
 =?us-ascii?Q?ruQjiZoWsBMY6y9r4hnyo+WAdLnzzgBclTxRoKRiAq5zkycr/DRksTX41V2I?=
 =?us-ascii?Q?Sw6hT2dLnnMpexPYS7GVHlzG8mLlj3b9Yyhck+xoNms+RWR550vkVYd56NkW?=
 =?us-ascii?Q?DtwjK9J6U56FZmvnGk05Q/lzfLE964KmE75pKTXj47woRICq7hgWnb/pqKMt?=
 =?us-ascii?Q?fVCMTsov/CP+DbRGlBmQTxFcVTg2LtnizD3ATYiYNSIIUQSTe03KfiNt3ld/?=
 =?us-ascii?Q?iy4+RGZb6XDtkYl+be1U0vaIvGc6Sm1H2RwEOghVnUQ5MTxJxSUaRgPW5Q3n?=
 =?us-ascii?Q?g90ctER37a2WLLU20U/xlTWw9YSSWn0lCR9jCQYHMHtn0rV9Zw/a5YfUsU9u?=
 =?us-ascii?Q?ykeCDao52GRwonE//OkMowVO16grlYRneOZZZEOklFaoix0+1SFMUT/TVD9g?=
 =?us-ascii?Q?4ASL+VVQ1gc/ktEn+lhDtRAy2j8Ov5md5omV2W8KdcQhouMHi72zI/tJlePo?=
 =?us-ascii?Q?o2fUoxmfh/N4TYsUJVWM9c2Q/Hr4Ne0z50uUnLwM6aWcLTsLdmqbdPiq7+T0?=
 =?us-ascii?Q?Wma74hlJirxtYDN8h9ewDf+kNVS4mqwIYRGRLH18FkC0VCuKGSeBDA0QMmcg?=
 =?us-ascii?Q?fEIpLShJOP0XdQ6+3CXQ7/wSS64YaFrrCT4CuqN12aHIPw3Bs5Bm6Ysn1Tsq?=
 =?us-ascii?Q?O1HeGZXR8aKGP2zGkk8pgY+dyAsH4TvCFzHFqpc9SuodtjSbDqGfpP1v8ezu?=
 =?us-ascii?Q?+g3xRFbcyFxiM+R2fjJ29pv+NDS+hB6nbxpV6NHbIyweyUJgeEZTw3JU5HYJ?=
 =?us-ascii?Q?f7r4GUkNY9X9fskDzc9vSeoYShpNHxa1TmhgQzUPIefggE3XfxlHNnoYdKf7?=
 =?us-ascii?Q?Pqo+RDk4O/GmoBQGv/7fN15Z1xutIwXN/gYgUB7j2XforCOeiZHisXfo5Z8/?=
 =?us-ascii?Q?DAJBiIpbn4qSfqKWut9v6U8lcefPPC3FF8Dk1DGRu4ulfdCf/tP7PITPv246?=
 =?us-ascii?Q?yDhy3zYmeaj0maxIO4V7LiJFO8wv2i6eKAn6tBefE78dYLsbwU5w1dTa6d28?=
 =?us-ascii?Q?C9eCrKDOaoTj5PFeWQ4jDdjicQQ01DYyxBSVKTTeMCQPWABkPp5oWRp3yrR9?=
 =?us-ascii?Q?eRjnIp8xaW1FqFjn/P2usGonMBacBdwnZlhF89TRj1VOehfwc3yPGFeXLyNQ?=
 =?us-ascii?Q?xBuX62p9wqq+3QzR6N3zvropZA696CZZkIF4LEByhtCfa8d/9EeRkC1PJxZM?=
 =?us-ascii?Q?5PbSRffhKRsBOsmjpgZ/tdQgWGxYO9k=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59034d45-0f9c-4752-7c87-08de41e0d465
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:02.6095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2Ris4R7HlKJrBWGVK4Q2Uvojmy4vg43rMDWp1KiEdioJNZwhU50LOwRz0eyUoMQ/7s8KGkf9p9s3hsCHlaatx6rlgkQdE6a/Ow9xbmXEwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: DEmLre2AsPllcJiSBKtigoHgJmewBjoc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX9bV/bRMWPwY5
 m05TFa7PBqnw0eESp0H76FdLl8CeTiZLsL3/t3OkUS3tJTeku4/1dloHwplxkSWUz/fE/ZuDb9T
 RU7u+BeDqEiZD+acyxXy5uAmASarvX168IKOhZ/zf9hcMEtu3LzkQikRDGdK5cp6TDn2P1CtXAK
 W1S9PC3wzqD/t9mC2VNft11x+4Np29X+wgfx6Ni+UfLQydiw6W0un2xTeEldWZCpK1TvADP2nG1
 5WQiNbbZ5Dyh4JzQxyztDTR6nPhLWL1X5cbaYndN33+r5fySbVEw7Ue1EFggwcdMZn9UTIMSnvS
 +3yJnJYyUHWp1pF9BfepziEitVpP6p1zU6ZINC+MZ/96JRupZxaiN+0uoftfzJKhHNziid9TECl
 DmIzN1jXzXpUIJYQwNvdnVWKXS7bJfI2V3OLsNrFntTMhWONMScGxf6XEUQdHx7oq9Hj91j3gTH
 gPL8Q6tKRA56CtamKWw==
X-Proofpoint-GUID: DEmLre2AsPllcJiSBKtigoHgJmewBjoc
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a2301 cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=7jiA9R2z5cqWD02HcTUA:9
 a=+jEqtf1s3R9VXZ0wqowq2kgwd+I=:19
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Add ept_access_test_execute_user_only to validate MBEC execute user
only access.

The general structure of the test is similar to the traditional exec
only test; however, there seem to be problems getting user mode
addresses, even when executing the test from user mode, as we're not
getting the right EPT violation qualifications back.

I'm guessing this is something to do with how KUT allocates memory,
I'd appreciate a hand in brainstorming how to resolve this, as well as
any other suggestions on test structure.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3705e2ca..926e4c84 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2294,6 +2294,7 @@ do {									\
 	DIAGNOSE(EPT_VLT_PERM_RD);
 	DIAGNOSE(EPT_VLT_PERM_WR);
 	DIAGNOSE(EPT_VLT_PERM_EX);
+	DIAGNOSE(EPT_VLT_PERM_USER_EX);
 	DIAGNOSE(EPT_VLT_LADDR_VLD);
 	DIAGNOSE(EPT_VLT_PADDR);
 
@@ -2360,9 +2361,12 @@ static void do_ept_violation(bool leaf, enum ept_access_op op,
 
 	qual = vmcs_read(EXI_QUALIFICATION);
 
-	/* Mask undefined bits (which may later be defined in certain cases). */
-	qual &= ~(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_RW | EPT_VLT_GUEST_EX |
-		 EPT_VLT_PERM_USER_EX);
+	/*
+	 * Exit-qualifications are masked not to account for advanced
+	 * VM-exit information. Once KVM supports this feature, this
+	 * masking should be removed.
+	 */
+	qual &= ~EPT_VLT_GUEST_MASK;
 
 	diagnose_ept_violation_qual(expected_qual, qual);
 	TEST_EXPECT_EQ(expected_qual, qual);
@@ -2390,6 +2394,8 @@ ept_violation_at_level_mkhuge(bool mkhuge, int level, unsigned long clear,
 
 	orig_pte = ept_twiddle(data->gpa, mkhuge, level, clear, set);
 
+	// FIXME: does this need to be modified for OP_USER_EXEC to feed
+	// in differently allocated memory perhaps?
 	do_ept_violation(level == 1 || mkhuge, op, expected_qual,
 			 op == OP_EXEC ? data->gpa + sizeof(unsigned long) :
 					 data->gpa);
@@ -2869,6 +2875,41 @@ static void ept_access_test_execute_only(void)
 	}
 }
 
+static void ept_access_test_execute_user_only(void)
+{
+	if (!is_mbec_supported()) {
+		report_skip("MBEC not supported");
+		return;
+	}
+
+	ept_access_test_setup();
+	/* --X (exec user only) */
+	if (ept_execute_only_supported()) {
+		// FIXME: should we be expecting EPT_VLT_PERM_USER_EX?
+		// as we're not getting it. Perhaps this has to do with
+		// how KUT is allocating memory here?
+		ept_access_violation(EPT_EA_USER, OP_READ,
+				     EPT_VLT_RD |
+				     EPT_VLT_PERM_USER_EX);
+		ept_access_violation(EPT_EA_USER, OP_WRITE,
+				     EPT_VLT_WR |
+				     EPT_VLT_PERM_USER_EX);
+		ept_access_violation(EPT_EA_USER, OP_EXEC,
+				     EPT_VLT_FETCH |
+				     EPT_VLT_PERM_USER_EX);
+		// FIXME: this one gets EPT VIOLATION
+		//   Expected VMX_VMCALL, got VMX_EPT_VIOLATION with
+		//   flags EPT_VLT_FETCH | EPT_VLT_LADDR_VLD | EPT_VLT_PADDR
+		// I'm guessing this is getting EPT VIOLATION for the same
+		// reason the above are not getting USER_EX, because the data
+		// address is supervisor mode linear address, not user mode
+		// linear?
+		ept_access_allowed(EPT_EA_USER, OP_EXEC_USER);
+	} else {
+		ept_access_misconfig(EPT_EA_USER);
+	}
+}
+
 static void ept_access_test_read_execute(void)
 {
 	ept_access_test_setup();
@@ -11707,6 +11748,7 @@ struct vmx_test vmx_tests[] = {
 	TEST(ept_access_test_write_only),
 	TEST(ept_access_test_read_write),
 	TEST(ept_access_test_execute_only),
+	TEST(ept_access_test_execute_user_only),
 	TEST(ept_access_test_read_execute),
 	TEST(ept_access_test_write_execute),
 	TEST(ept_access_test_read_write_execute),
-- 
2.43.0


