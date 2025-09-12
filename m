Return-Path: <kvm+bounces-57398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 615A7B54FC7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:39:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F5B01891D47
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D1D3093B6;
	Fri, 12 Sep 2025 13:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZF2G14cQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18017238C08
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757684355; cv=fail; b=JmWrr5aMU7DA6T1A9vE0JhDzLoVefBbuyY2NHSjgKvuskqaAMnyhBhsPpxINXEI+NqNVJNLsr/su7I0fL8e27vV51v1ZBudlSlnq+K+DTjcko9i9aK0hWeXPZA4++zQpHbIGYimRFVy+PgaPd4ia4W7VYMcJcAr+g+kJiIVAdSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757684355; c=relaxed/simple;
	bh=c5I6feuMv3y5XsrrC3i6id7EEMMnzc8ROVpQvLdUa4E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JacDMwMYguZyLui9+4UoG4zT1BogdVRSDdDOQh2TYlWh/oX+2T1lmf2YG7grYoCCZ7hfjas/NiXZdF/mCAlibtLgMQhfn6C2tL6G0AHVak0hYA4h1nxgxNIthdyUwY+eoP7HaD/hwTz2Ff89qqCkYtImbQIW5paSypz80pE3eVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZF2G14cQ; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNGp78IEPzy/j8Bi3eRbpieNbGGMJhZajcelYbmn9oLr4csEwEZNIb+yVr9xnOHv3hrYNh1bozgMCHOjJcj6OQuJNn/g/69GnFq3Z7wEmN8CugDWl3arxAaQdiitXWWy5unZbHunwkuP6OLQFb9mVNbIhWxsWN2Sd1Uo0/p+Of/4dNLwmZ2gdjGItUt60n2cLtdGzWKKo2W0w5/Y1F2OZr++3kW8krgVL8JqkD6zFJ5YrYAPffj69fVWQxtga2izV1U20/4nsziKplMEKt2lUjpSYSNbtxY5/dNIImHMGPqwrrk7MsENekHsX8XlAO3xrjVC7i867oLuwOqmwi4R4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ukam/XSO8Rv2TK1pihvwVPaSvoK131YVOexlwKPWc08=;
 b=WA+kcqo8s/EaPa6eEl7+8w8fQsMOfwQrVN+Yv6mNuNYZinAE7Eyq9JA2U4eA5j3DaZorEsbUFpPwpPIHcKhkZT/lcMTR9YAfyaMsoXEkhxTECWnNkGhozmxCUznmO6xBn0pYGH2V0a2XyLeTafW05MaQcIBRsCadOO9b62WkDF6l/Cm4fgtdy8jZUUvu1vyhxyTNo5cJUbOLO9CeNJgEIN58C9d8AgfwhfkVX3beZCYow+189MylgRdsEI9wY/RV71Loh9z8D5gfyAOnC3qrv1sN/a47J7rKrLXb1Xy2xngjorGDoUFRgeqvlVFb+1bpSytw4t0QIfZZUhit2AQi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ukam/XSO8Rv2TK1pihvwVPaSvoK131YVOexlwKPWc08=;
 b=ZF2G14cQSwRFGPn3s/1HG80Ws9kEKk81zKe+6RGa4c32QWPaK1U95S1MLFilYeEw8V4u9QqcUYTJVA9fK270NJUloO8fmKLg1eQS8ZClrnrkAepBH3kcP5tpHvf+rET8e4vfa9izmrPhi29d4vKHG2mBZnbCSYLwvw9wN4+Piq0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BY5PR12MB4100.namprd12.prod.outlook.com (2603:10b6:a03:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 13:39:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 13:39:11 +0000
Message-ID: <dd3672b6-5ee4-470f-9b61-f7ddef8bec72@amd.com>
Date: Fri, 12 Sep 2025 08:39:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/7] target/i386: SEV: Consolidate SEV feature
 validation to common init path
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1757589490.git.naveen@kernel.org>
 <bd64baf06e483cf8df0f7b0f98cf5ad3dd5bff80.1757589490.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <bd64baf06e483cf8df0f7b0f98cf5ad3dd5bff80.1757589490.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0021.namprd21.prod.outlook.com
 (2603:10b6:5:174::31) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BY5PR12MB4100:EE_
X-MS-Office365-Filtering-Correlation-Id: c8ef262a-2dc6-4126-50e8-08ddf201c16d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M2crRDF4YlNYM0ViN3JsMTVNYlJKVll4OGo0ay9NdU1lcUx1aWsrY25tZDNl?=
 =?utf-8?B?ekxIdWpxMUIzUTJIQmg4bWxYMzFKSVNiN0s1RGc4dkRKcE9rV2xpcWxDamdn?=
 =?utf-8?B?VVBmSWtmL3FwUXZkNmkvY2wwLzFjTE85VE1sV0pPT1N4ek9qYWlkb1VaODJj?=
 =?utf-8?B?UVpPVkdLYXcvL3pXbFFyTC9abmJuQmdtU1hWL1ZETGpJYUxRaWFFWWQvOGc2?=
 =?utf-8?B?MWxvd1I1V1pCOEJvTVFNa3RNUUxjS2NncExsMGZ2QStZNFNOOUsxSTB2YWRq?=
 =?utf-8?B?MUVpTjBMVDQ4N0dEYkNDVFUwRTVsUkgyTEkrOXFqb2RSems0TnV2cnZYcE5I?=
 =?utf-8?B?aFFUSDd5cUJkOFg1aEJiYk1BdVB1Y09iZEZOZWlrU3g5TWkzRU04OU5JV1FM?=
 =?utf-8?B?TG81WXdkUVhuNDVSUU9PVGJCbHVJU2hPZUFmUVlab0t1TmJ3ZnJxYVJuU1Nl?=
 =?utf-8?B?T3B4dTY3VkNVdjU2bndtbWppNVBaZFNqWTd2cUNPNFFKQ3FHWklSYkV2WEJT?=
 =?utf-8?B?VytGMnJvbkJiekhrUnZCUjBGNUpjRlM1ZWxGUVNlRllHVFpFUTcxOTBMMGVo?=
 =?utf-8?B?ODBjdkM3TU1tZFZoWEszdVViY0hUdTBUWUJLdTFoQTQ3dzNCTkxJMzcrcnBQ?=
 =?utf-8?B?cFFXYUlDTTVNdVJYTVhzK2ZRc2pFOWFFUS80djZvMEVrTk5Ea0I1aVZJaEFC?=
 =?utf-8?B?a3hhYmU0U0pDS2JtU3NabGV2Uyt6VXNIOXQra1AwcHdmUHJZZmpYaGFZcUJo?=
 =?utf-8?B?R2lEYy9SM2pSUzdUSU5jbEd3QmRSd3lLSVpFaWNZYk45TU5BNzExVUxobGVP?=
 =?utf-8?B?RDBJR1Y3OHBoanZ0WVFqLzV0VzRYUXFPc3ZHVi9IbytHUmozUGNkQ0lnMEND?=
 =?utf-8?B?RW5Wd21kR2xPeHF4R0xTVjJCMytXMm1ENVRxY25ncnhsMndSTG1IUEYwSXBs?=
 =?utf-8?B?Vnd4QkgxSFM4Yy90TXRQb0VUL3B2eWtjbVZqaGJsczl2NTlleFNCbm5vN3NS?=
 =?utf-8?B?VUdtdSs3SEpHdGtISkUxK2J4ZFo1WlZRMHErT2ozcTYweGNWRUlXdlEyQzNm?=
 =?utf-8?B?UExSTityODdtV1RjenpLQ240YXErZGlMUzdIOE9KK3YwR2RmckQ5WldZcWhL?=
 =?utf-8?B?dGZGcE5KZkhHaXl1V21FWnBSUXVNd0Fwd2VBWURoa3lKVmNBeWZzTEZVTGVF?=
 =?utf-8?B?V1lEUVdYU29DWDluVUxIRmwzM3pybEthemdYZ3ZPZjNKKzh4T3JtOU16MlBz?=
 =?utf-8?B?clhDTU5laFlIQUhEMWZabTJycXI1TVNZbWNOK1VMVEcvaExsZngwcm5DaXpO?=
 =?utf-8?B?Lzk2a3JYbVNTSmxNaUVSejZ3bTN6MUhqZmpBbkRxOEd6a2VYKzR1NG5zOTRX?=
 =?utf-8?B?NjQ0RVg3d0cxemplUU5VTURCelVuSHNXQ1oxcVdjSzVwcFBQWjJrMzVPbE9h?=
 =?utf-8?B?cTEyakZCOGdwWkUrRFVoVC9CdnpaS25laWZTaERURFF0MkVrSXBnSmFTTDM3?=
 =?utf-8?B?QnJMblByY3UwL2JkcUgrNE55RVpmV293TmtNekR3TjJlaTVoWjBWQ0tMZm5v?=
 =?utf-8?B?enkzdHBlVG9OcndJY29OM2JrT3ZnV1gzOE1tQlJOemRHMmFZUVhpMlA0M0hY?=
 =?utf-8?B?UVVibmEvY1ZwSng4ZXQ5UlVvS0FBeVErc1g1NFpqOHFUeWJEbm0wWmxiRW1j?=
 =?utf-8?B?WG9CTVlYYWNlRnE3Wi93ZlpBOWlWbWtLLzNqUDk2Nm15bXVNYWFGTWdXb2Fl?=
 =?utf-8?B?ZG5YZ1gxNHQvcC9mVGZSczdXMWxhSU1GSUJtbFYxQSszcDFtM1V2Y3ZOSHBV?=
 =?utf-8?B?ZVBneHl1clhEdjVIcWYzVGwzOThkMHA5YXNnZWEyOWc3bVpKQWFpTlBkTWhW?=
 =?utf-8?B?cEVBK0g1RnFDVFZBdzNsZGQ5bDNVcVIwdXdWNlZMU21ERnFzSU5Ob0J6aUdH?=
 =?utf-8?Q?S8/L16h0wpg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUNSa3Z4NVVXS3h0TjBnQmpEaGpkWjQrbU4zREdwQ1FIWmF5YnBxY1BmNFFt?=
 =?utf-8?B?N2M1ckVOUlQ0RmIwK2N4TjRsZHVTZW5zMzJaelJ2QzUwK1drQ215bkwwakZm?=
 =?utf-8?B?elJYdmsrT2IzQ2hUaDFRL2NBb1VabmhWOG5wS0tMdWQ3d0RPQmZKRTA3eTNw?=
 =?utf-8?B?cFhTaG1DcDdnQlRabzBTYVdqNTZOVU93QWl0bDlMalZNa3BtcXl0MmhObG51?=
 =?utf-8?B?WHhZVkQyRGJlcGNOa1Z3VHBIUzBGS1FtV3JZM1RWYy9sMEtzN2JWeWVybU5j?=
 =?utf-8?B?a0FkWDNGcDliQnpiZGhheU1yOG4xcGNSb2lLVWtuUG9zYkRVUEZSS2hHMUJy?=
 =?utf-8?B?akxOYnpGVnVIU1Z6Sm1jdm5kZDBxUnlDb05abnNGc1V6UVVhTGZUN3FUWmJ2?=
 =?utf-8?B?UXF1eXdLaVpIMTE5RHBRRWhRaWUvRzdjQlAyVy8vMGR6OVRXUDBRNVZiZWx4?=
 =?utf-8?B?NHlSa2ZuNXMyb1JkUjN0cUx4VzZZb3hMUmtFMHV4NnFqSkE2YmlTKzFDaWV1?=
 =?utf-8?B?VWQ2M0tiVE1aa3did2pQaElqcVhPRWMwa0dHR0ZaQWlWaW9YVWFpSklmOXF2?=
 =?utf-8?B?QkhhUGlMTWc3RVdqSWhKRHBtcG4wNTFvWmpSdjg0YzFZdlhLSGloVllDZmdH?=
 =?utf-8?B?c0pNM3lEaWErRlNpSkQ2ajRTQ2RwSlJ4Yjl6TVRUV3F5cnBVemw5cXE0L2x0?=
 =?utf-8?B?aVVZT3JGejkrbW9Odk9ZZCs1bzNYTURtdHk5bGtCUlJ2Y212K0RFZjkrWHFJ?=
 =?utf-8?B?WGNaZXNYdzVrWjc4TmovVHdiNWlkaFBzRXVEcEplbGFzYjNWOTBTbi9weC9i?=
 =?utf-8?B?RjhNRkxsMW5vQWxaN0Q2eEwwUVU5K3pvNGNkU1l2WlBxTWpqRHBOU1FGN1dq?=
 =?utf-8?B?c0h5V0VndHo3Z3RpYktUMUx5YnBlM0NwR2RscUZydWlHWksxYXdHNktad0M5?=
 =?utf-8?B?aldxZ2pmSjFxZGlaRnVXWlBiaGpPbUJLRHNXTUdINTIxM2IrYW5WcmdNYUgy?=
 =?utf-8?B?bHZ1dDF3OTNJNVcwczExSGo3Tkc1SktJV25WdXo5RGp3SERVbW1NOHVrbmN2?=
 =?utf-8?B?S2pLenF5TENFUHd2YkNLRnB4eUliTjFMNEV5cmZESGpHMGpTZ253bWwrMkY0?=
 =?utf-8?B?L2M4Y3hGZ3ZJNG1vcVhLdzZIQTZBQXdIMkxoWDlUMUxXU21YZWx3MUhKMVdD?=
 =?utf-8?B?WnFQcm9YbnhOUGN2V2xFN05jclJTNkhoNlRhRTJFaElFcWhHUzJMcHBMTHQ4?=
 =?utf-8?B?ZDNoek1NUlkvWklpUjV5WnFKNktXM0FwODF2Y3BQY1E0azRvOVlZZlA5S0RU?=
 =?utf-8?B?dDczdVZLYm5LdTMwdUtFZ3FHcEFNTTBzbDJ4R0wzK0k1M1kzMDU4VitLKzZh?=
 =?utf-8?B?Z2NJQjJTWWxGWXF6VDc0ei9YYk1IUXBQSExXYTZmTkZ3TUJ5dXhBZjRsSDRX?=
 =?utf-8?B?NGx2SXJ5ZC95WUl6ckpDSXhJM2JRejU5aXk2OC9tV0Y2bS9BZDhJbkw0L1RC?=
 =?utf-8?B?czNvSHlxRlFRNzNPQUluWkwrd0pEZm9pL0F0elpqSXY0RTlMQzA0UC9lRzU3?=
 =?utf-8?B?b0h1MTZWdFhoUCtkcDJZTVBYQjdGSDIxczYvK0lyaVJuZ3VrbGpTNW1FN3FQ?=
 =?utf-8?B?LzM3eW5BVGQyV1NWZXJvNTZvWE5KVUM0ekw3U0t4YzZCSGtrOWxscHA2NWI5?=
 =?utf-8?B?U1RIaTRkNzY5OWJBMmkxUHdNYnBLK21hRkUwV1EyRmc3YWFVNmo5aHhORTNk?=
 =?utf-8?B?UnUySnFtOXR5dGZBTmtxNHRwTmhhaEFCQWVsUEtyVzk4WkVmeUNoNkFzSHVz?=
 =?utf-8?B?QmYvQUFtQWVWb0dJcFBxVHhjcWovUjVEOUx6ZmpHWGgzSEtISWF4dDJ5dDZZ?=
 =?utf-8?B?QXIwVWZyamEwWm1WSDQ4Ty9RZ1BSR3hubHdRU3FOZFFQS3JLRXhEaXFsZ0Jy?=
 =?utf-8?B?SmZqWjkxVWYyVzZpZ3U5V2ltclpMakt6TUJXV3hUWm1MY00zWElYUFB5azhM?=
 =?utf-8?B?d0tEWHdtTW91dEFGRExJTFBERERiemJZbFY1YytpZ1RERHJQcnRGS1RYNERs?=
 =?utf-8?B?eElNOWdjQXM4RStXSDV5R3ZHMzhEZjg5Y0IvSkZlWmZPWEgvSEthQUpDWTZX?=
 =?utf-8?Q?ijoCJkUsDxqavQuYfGqMrj4T3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8ef262a-2dc6-4126-50e8-08ddf201c16d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 13:39:11.1780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSpFZULycCSmBRylP97GgVHdX0YsExzAyVtJdumqmpu2hoPP+rdu4aS+zJICh2y+OASLtyQVY4znbRYfVUiDSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4100

On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> Currently, check_sev_features() is called in multiple places when
> processing IGVM files: both when processing the initial VMSA SEV
> features from IGVM, as well as when validating the full contents of the
> VMSA. Move this to a single point in sev_common_kvm_init() to simplify
> the flow, as well as to re-use this function when VMSA SEV features are
> being set without using IGVM files.
> 
> Since check_sev_features() relies on SVM_SEV_FEAT_SNP_ACTIVE being set
> in VMSA SEV features depending on the guest type, set this flag by
> default when creating SEV-SNP guests. When using IGVM files, this field
> is anyway over-written so that validation in check_sev_features() is
> still relevant.

There seem to be multiple things going on in this patch and I wonder if it
would be best to split it up into separate smaller patches.

You have setting of SVM_SEV_FEAT_SNP_ACTIVE in sev_features, you have a
new check for sev_features being set when using an IGVM file and you have
the consolidation.

Thanks,
Tom

> 
> Finally, add a check to ensure SEV features aren't also set through qemu
> cli if using IGVM files.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  target/i386/sev.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 1057b8ab2c60..243e9493ba8d 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -586,9 +586,6 @@ static int check_vmsa_supported(SevCommonState *sev_common, hwaddr gpa,
>      vmsa_check.x87_fcw = 0;
>      vmsa_check.mxcsr = 0;
>  
> -    if (check_sev_features(sev_common, vmsa_check.sev_features, errp) < 0) {
> -        return -1;
> -    }
>      vmsa_check.sev_features = 0;
>  
>      if (!buffer_is_zero(&vmsa_check, sizeof(vmsa_check))) {
> @@ -1892,20 +1889,29 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           * as SEV_STATE_UNINIT.
>           */
>          if (x86machine->igvm) {
> +            if (sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE) {
> +                error_setg(errp, "%s: SEV features can't be specified when using IGVM files",
> +                           __func__);
> +                return -1;
> +            }
>              if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>                      ->process(x86machine->igvm, machine->cgs, true, errp) ==
>                  -1) {
>                  return -1;
>              }
> -            /*
> -             * KVM maintains a bitmask of allowed sev_features. This does not
> -             * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> -             * itself. Therefore we need to clear this flag.
> -             */
> -            args.vmsa_features = sev_common->sev_features &
> -                                 ~SVM_SEV_FEAT_SNP_ACTIVE;
>          }
>  
> +        if (check_sev_features(sev_common, sev_common->sev_features, errp) < 0) {
> +            return -1;
> +        }
> +
> +        /*
> +         * KVM maintains a bitmask of allowed sev_features. This does not
> +         * include SVM_SEV_FEAT_SNP_ACTIVE which is set accordingly by KVM
> +         * itself. Therefore we need to clear this flag.
> +         */
> +        args.vmsa_features = sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE;
> +
>          ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
>          break;
>      }
> @@ -2518,9 +2524,6 @@ static int cgs_set_guest_state(hwaddr gpa, uint8_t *ptr, uint64_t len,
>                             __func__);
>                  return -1;
>              }
> -            if (check_sev_features(sev_common, sa->sev_features, errp) < 0) {
> -                return -1;
> -            }
>              sev_common->sev_features = sa->sev_features;
>          }
>          return 0;
> @@ -3127,6 +3130,7 @@ sev_snp_guest_instance_init(Object *obj)
>  
>      /* default init/start/finish params for kvm */
>      sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;
> +    SEV_COMMON(sev_snp_guest)->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
>  }
>  
>  /* guest info specific to sev-snp */


