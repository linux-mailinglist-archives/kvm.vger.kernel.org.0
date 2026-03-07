Return-Path: <kvm+bounces-73210-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LVPKrWFq2n/dgEAu9opvQ
	(envelope-from <kvm+bounces-73210-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:56:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C18F229877
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD43F3035A68
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0642A3074B1;
	Sat,  7 Mar 2026 01:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="R05NPP0q"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012008.outbound.protection.outlook.com [52.101.48.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953DA326D65;
	Sat,  7 Mar 2026 01:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772848542; cv=fail; b=XRGtTanFyBZDArHsDNR9mEbbO7o3bOknWZLHDq3Dklc+jO7pXLVq3B8jHrMvSWUnWAfxVy5KHG3g/sdXN1BvbhWOSoNRUfBowE5ALKMEbD6IBHMbUN90WX01CNeeuI8yVPSWM0SDJFwcHeoxI2GSRzct/Uj9qrj/ETpWSxA5KjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772848542; c=relaxed/simple;
	bh=JFLS95BWPMobRe/oL2fd/3QoWTn9hr/JZruhjPSH3zg=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VtExES8Qi3vpXtWR/fTx2jUJ5mNx5bVz4G7ZR2mkL2GeFBYrWjpvRCPK+vNLmOGH5Pv7Qccq4FOyetktJNLb/ZxmoTASWj7H6VOCAepYZR3hIvf6Kx1hfifreG+FN7gWodqZSLA/4Y/N++idX8HSnFIfVhrjERVTzUcycz+mEvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=R05NPP0q; arc=fail smtp.client-ip=52.101.48.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H5qf1/KoYmftzE47K7SpBIBUE8WJ/1/q78Sf1XA9TiJQxR4Cf4vUmZ6B9O8TLLh+taLrubLyORgQKylY027lNep1Nd37JjHaIUlFetamMX6k+z7QNo47455fGGjqHo20ewMSgyCtbeg1ADDEanTpPulTPK2UKkEt1Xqzp2PNgz3Z7cfwvybyHlnfSoF+83PDnKCXaDkbIZ5slsRCJaHLDyPoDCD8H0XpKWNQhcVwG3WvPHmQRFWd3srXNfBoPTKdLIeFxtIrwo8pY4PgKQjAAbf3uSEj8U6noAwK+kIqEG0MIbnSxgSB+pTGjWjCh6krh1OKgQ9/Gu/Lg7Iinzq4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JFLS95BWPMobRe/oL2fd/3QoWTn9hr/JZruhjPSH3zg=;
 b=ZsDDhceclQAxCI4ohKhtuF8bebMstWU/X4ajXYXRdMa62n4QIqUm0ls80xWN/UhBjiez5TJWm3be21wZZtT8x3ZUDBuIYmdRwNKRL7kJQK+RPayPiD6xWPBcf/9ZE3NsuSQfmO7wIx9GrrMcyA53UoFEPBsk/6YxeCooLokz71j8ShslV38/OPh9jNF5duuXrkFD2+2uVlZW/rVyEA3EztHLUhzg5rjyclUuaPh/yBHkDzTv0NNfimEK15WNmDxsJPZPLgnuQsGKKsCYUMJDOLoLpFxC0lrOVxBEuzZpg9irFloRKlCK5+ie/xrY81YwKSdhF1bzOrT40Rdc5EBY3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JFLS95BWPMobRe/oL2fd/3QoWTn9hr/JZruhjPSH3zg=;
 b=R05NPP0qCB/nvE0HMv2YI/WLlHB5Wk7FhqJsToeKIVE95jn7dtddeUFxW2x/2GGsaE390Iyy0qH/2028a341wDdI8ghoG5XrARhrQ6lrYfx0lNI/z7oTDDL4WsRB0YDvuz+JgRXPQpxxOqjSFwROBQhCy6XqDtCBCyGmJLYas9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by DS4PR03MB8153.namprd03.prod.outlook.com (2603:10b6:8:281::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Sat, 7 Mar
 2026 01:54:22 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9678.017; Sat, 7 Mar 2026
 01:54:22 +0000
Message-ID: <34cbc227-f01f-4d4b-b6ab-19bcb02d7e3c@citrix.com>
Date: Sat, 7 Mar 2026 01:54:18 +0000
User-Agent: Mozilla Thunderbird
To: yosry@kernel.org
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 venkateshs@chromium.org, venkateshs@google.com
References: <20260307011619.2324234-4-yosry@kernel.org>
Subject: Re: [PATCH v2 3/3] KVM: SVM: Advertise Translation Cache Extensions
 to userspace
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20260307011619.2324234-4-yosry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0475.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::12) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|DS4PR03MB8153:EE_
X-MS-Office365-Filtering-Correlation-Id: 03191bac-c294-4174-57dc-08de7bec73ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	mHwDkEBab2UL38d6ptFr7olZ7RWRebFCW0XXZyKh8zGEczJT9FjGzdy6oKFP/vpYBmMDu5B19vLQqJoqNse+cBq0QW9wrH4Odqw1hdc64KCOa2iiaT9yr9L3YuNJkY/d9IYqbGge4rJcLt2REUYCgnSvT7QOd7kftdhS6My1LO3yLBXr+BoYiG6EsSV/PDAZqzvDjULxiMh2Gw5p+90Kcd88qcm10HmXVpBGEYCTsZgRd1xKPY/Kx+NZ/HA5xm3nRFwdFOobQeKUImYRta787tOmhC0w2Im6mivei7Y2HYazppdIyCWIjLEkq9r0RcnRMIBlcThqrLVVRrbFIqZnTcPpG4d2hnJvQLBe5k4ZF6XZjIkIDOy7ZTiGBC2LY0wTFp5Wrg/CcF+G/XLmPbjt296yymL6WUgbi6+v3vG5KXLs0/9Ufs24eX0407YVHnGxXkWTpzRUtLJWaOXAu1534yajCHaMBtikD0dbTSy1t9cDEj4aYH9aiMkLOKfQPnElYRiMwn5ZwYMoYf5VlzdrzbFnHOhvBv9x8YxAfF2FGyXZaamIgeBAiC55fU0wRctYGiQIa03bdZu/9ymrhA5hUWrkMike2UZkn5o9PcFP0qaVX2te3R953ONWomLoEnRWFrkabK4vqqd8Jh3ghJMsTRqEwYy8TONZOzBK0Vppq18SxS7tXrpnAbIg7GtUjEz962OTOj8K9vbu4SuZUNeh4jqNM4ogZlGtbMjARUgjHgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTBrS1QzRC9CdE1uSVZCYVYvSTRuMFpzYXVXTk5SK2tGNHd3NTlCeklBTzRI?=
 =?utf-8?B?M1dhamlrUEtZZGxzb29rOHdraWNCeFhxY3pJUERKc01ZRXc1OWd0dHJTYVJI?=
 =?utf-8?B?NVBGSEtFdldHeXdSU1FTMSsycXphb0p2UjZBaldLcmtiYXU2MlJWWFQ3RkEr?=
 =?utf-8?B?RlJ6YTdmMS9nRXYvQ0dsT2FiR3BHcW4wOXV2ei80UkR0WTY3eWMraWEzWERL?=
 =?utf-8?B?dFpxM2IyMERWZ3dsUFBKL2I1bWxiWFVGK3dBcElxNWJGTEw3OTl5Y0plMXBU?=
 =?utf-8?B?SmpJNGQ5ekNqamE1SnN6azVtNlkvQ01iVUo3ZC9ySElsL2tIcXcwWTlpNHl0?=
 =?utf-8?B?RFBoWmprQm5ac1FrQldMd2J1aGIvWHkyM3JqUjJjNkVBcVBHVUI2NW80VHd4?=
 =?utf-8?B?ZEZWcVVBK0l4czJXOGtabW51bkdjb3lSK1c1OUxsN05jbXJzZW9WMHpINTkr?=
 =?utf-8?B?UWtvVmd4eDlETWFZZFptV0hJb2wwRGRWcW9MaWF5MDZmMERKcjlhY0NOellR?=
 =?utf-8?B?ODRhNE1qT0NrTXJydkk0RHNSSGNSMXYxQ2JESDhNQUVvT1FXMjU0OHpvRUlw?=
 =?utf-8?B?OGNXRCtjR090M3NVRm1jbEJHckxRdkJYSkVVcmRXWmczQmwwU1UvQk9tdzFz?=
 =?utf-8?B?K1RFZkgwRzd0enAvNHVvRndBSG9QczA0TzRYOGI4YUxlTU9WRDhtSEdjT2VK?=
 =?utf-8?B?R2VtdExINndWUDVROEkwNEhyY1VrdFd3cHRWRUdTaU9OczhPOUM0RW90dDly?=
 =?utf-8?B?UXI5VkFZL3pkdmI0SzQwYXByUUhHWTNDdHVZMmRWcFlpV3c4M3FXYnRRTkFT?=
 =?utf-8?B?ZEdKd3F2MTBkZWtBc1AzTGs0NmJaNlpvSFhmS3RkVUc5VXlZbVZxSmkxTy8z?=
 =?utf-8?B?aXRrR21FbXNkVTVCWkIyNzVpbVpxbEF2Y09kempHTmhRUmF0VlVKTG5xaFBX?=
 =?utf-8?B?WFhLQkIvWGNVY3hEK1lsaE5lS3VCWG0zL0VyRyt1MytPUStFNkVKZm53N1px?=
 =?utf-8?B?WjBUeGZ5K014TE1QWU5uczFjTUYxeHl1UzhBM0orNWVpRnpQb1NEQTM2WkZX?=
 =?utf-8?B?bnBIZGxNZGJNc0xyV3A0aWJ1SlkyVDFWOFVYdEVjNEg4bGlvWGE4WEV6cWgz?=
 =?utf-8?B?QWU4S0oxZGQvbFZtVFBOWCtmankrbDRrRVJoY3M3enJoOGVqZWpVQVFDTzJ3?=
 =?utf-8?B?RXkzMkNLRWRYZXNOU2l3YkVMNnRCcHFNamNQTExQY0hKYUZob0U5OHRGcjM2?=
 =?utf-8?B?SDd5UEhOSW96bkJrYmE5M2dPTkh1WG9QZ1djb3l2UjljOGsrWEQ2eDZaRUVG?=
 =?utf-8?B?WkVZYlJrb1g3UmxTOTlHTVRpeXhWTmd0WnA1YzlhSnptS2gxZCt3RkNlWTdt?=
 =?utf-8?B?SzBWYzlHKzJhblhiZmtoUGt3NmgvVk1DS2xJSjBvcVVuME01VzlwOXdXTWhL?=
 =?utf-8?B?eUdiRWhTdWdzNjh4SGllME5OZ3lMRkVndFNKS2RYbFNmVDhQb0hEUzZOZWtY?=
 =?utf-8?B?N1FXZnlMdDhkNWdQblZWdWJNaDVSZ2FLaDczUGlwdjZKOVMwT1JpV2tSVWM4?=
 =?utf-8?B?VTJOMWZGOWhnYldZUmk2eEhMa09SZVFqVXo2THo3NUJMUFh6UXkyTldqc3F6?=
 =?utf-8?B?WGpONWd2c1kweDZvVzRqUTNXUkpTY2FUNmpLMlZqU3IzcUlYWGxvenhtYkNo?=
 =?utf-8?B?aUVKU1dTMUtOTVVNdE9vNXRoU1ppZTl2T28zT2puZmxmQm1WWVFwNFEzU0Zh?=
 =?utf-8?B?M0s2VDltVFh6OUprVHFHL3Q4aGZ4M29talpKTUFKQlFiM1ZjRWJxV2lrZGRp?=
 =?utf-8?B?TWF6NHY0djNVZGh0NjNtdFdDRzEva3pTMEZRbEZDeHd3YVE0SFZGdldlL1Za?=
 =?utf-8?B?Wkx4OGx5ZHFKdjdOQmhVRWdvc05DVXNJZ1NnSzB6Tkt4Zk9EWGF0UFdEOWxU?=
 =?utf-8?B?UTNWc0xCTDgzM2gyWUQ0cGRqeTV0YXpVekNDWjhwSXdNSldDTStHSWdoOXFO?=
 =?utf-8?B?QUhEdm1FVHJwT3VHZlFYNTBKaGt2UzNDMkRqNjhUSkJ2WFhGSlRyQXgraDhY?=
 =?utf-8?B?RTBIUlhxbDNXbTRML2pSNWhic2owZ2kxcTdtRlVVblNMNTd6dzZWYUMydVZl?=
 =?utf-8?B?Tm53N2lpQlJkWUNlZ0lxZkh2WUpJQXhHam5IMzByZmZ1QVcvZGZ4eGpuSlJ6?=
 =?utf-8?B?VktkbFFIOFdDdGM3Q0JWQXptRVR0ajlHV2F2K2VpbEVSMEpFSTdvb0pUa3Ra?=
 =?utf-8?B?czFjdGh6d1pOaGNYaXBhUWJTNFcwZE1QdXpKdWRUZ3dkUElxZHRBcEJJR3N6?=
 =?utf-8?B?YU9hbERyYTQ2dXBtcDBBQ1pLQlBQcUloRGRkWGtiZVFPdXNIcWVWQT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03191bac-c294-4174-57dc-08de7bec73ed
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:54:22.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FmuF0nByqIimpeLX9N6zkLuqTBTqZptAdnvn16RuTL6B4c2SDf7PLxYsYKWv3VpdlqQ5kT38oMd1hgw0Pt5klEEDSpmioy6WYGe3YeAvX9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR03MB8153
X-Rspamd-Queue-Id: 2C18F229877
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73210-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[citrix.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.954];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

> From: Venkatesh Srinivas <venkateshs@chromium.org>
>
> TCE augments the behavior of TLB invalidating instructions (INVLPG,
> INVLPGB, and INVPCID) to only invalidate translations for relevant
> intermediate mappings to the address range, rather than ALL intermdiate
> translations.
>
> The Linux kernel has been setting EFER.TCE if supported by the CPU since
> commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions"),
> as it may improve performance.
>
> KVM does not need to do anything to virtualize the feature, only
> advertise it and allow setting EFER.TCE. If a TLB invalidating
> instruction is not intercepted, it will behave according to the guest's
> setting of EFER.TCE as the value will be loaded on VM-Enter. Otherwise,
> KVM's emulation may invalidate more TLB entries, which is perfectly fine
> as the CPU is allowed to invalidate more TLB entries that it strictly
> needs to.
>
> Advertise X86_FEATURE_TCE to userspace, and allow the guest to set
> EFER.TCE if available.
>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>

I'll repeat what I said on that referenced patch.

What's the point?  AMD have said that TCE doesn't exist any more; it's a
bit that's no longer wired into anything.

You've got to get to pre-Zen hardware before this has any behavioural
effect, at which point the breath of testing is almost 0.

~Andrew

