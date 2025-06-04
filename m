Return-Path: <kvm+bounces-48361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A654ACD743
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 06:43:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E63C1895B27
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 04:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315E42620E5;
	Wed,  4 Jun 2025 04:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="am5feQLD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AB117548;
	Wed,  4 Jun 2025 04:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749012195; cv=fail; b=FjsRKeiJjfn6UhgVMtXNdoofq6YXMK0JgYPydlMrP5q5ArFoElUkiviNo6uzwV+j/AmgouMH+MCowd6hRFDMIfZY3EvYJSgJtJ94IrW1tu5pva03k3D6pUKBkhL62e6B5yYA088VNWxY3rU98q1f0RRvKsnHowtxw8/rFeoU240=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749012195; c=relaxed/simple;
	bh=bK/MoGOjXCvBkHERg4LwslVhgU5MU4YJKDd8gomd4vk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sRfRlriWLhfUxgOeogeKw9luLDHfepQIpnTM1uewr0g4nWcflV/RE6UNuiXD0JxnASzmp4nIZoPYTKTScMcn11Fld9lmGuakxWLDbhh8xQjGpmzjytN3OC+5iXt+7YhrfBp+Xls6KmLalSNS/Z1qzw+P/K3QQBSZMhtMjoPFX7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=am5feQLD; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcUM65RyCWxtueTestfBJUd22JAqpFcXOFLfwWG12KpEkZAD2ahIDAcSDZ5leBdfvaW8Jymphpli4hEXpLfnRC4lffX+ZwxLEMIz0nWV1asbNpvnSmSpvRKLogj7tQybvG1StlCkff7yb7xoXaKaO8ZAfqp7VC7xx6K9pmqWDk4bgj9+dSKggerEEIS7hMkFPW8vRCCGcwMTTjVSYkAUyzn3ppyARDgkVH06ytHd6vohvfSvhez7N3XRMFykHF9H8qO+DZPzIkoK+ajnOXJwz0eEf06X+wFP+YJ9ZKdbeYTzrTLiVqtlbnK27VYbnsGN5IG+w+0umKLgkV2sxrfCiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAUf7hMHq3F+gwARGHNbOuXPM++2dXUD5MMfyI8PRfI=;
 b=HhrqrMkrTBPYKkrcDG8Q3os/k6vIKpZrXjk/3ZT43VLPQz3bVqXrzPHt02/awRxh6j+0X0LASURRyCxsxs4W9r2uJ3OXM9UECS7SqhcnxNknu5LTG8oJ3B/Lxh3qAncn6XBC6xAKcPYnvmJ4KfrXMjaLSnIYW6Uo/+1NXiF2DUIv3D3jlMFfGIeOd+qXaHid9NfgmlbXlwAwkJz/I9nLGUDaQWD7PnM7tBUKjJwOY4ip3QNVFsvbVavynE5ufuPE9WzbC/wkrakAVM6e08KGGCS6kBV1D+bWtl6jlw60/QNkG5CIGtFpoeHUYjWvWMYxYIz0LFZs3DXnjDKuq/wJYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAUf7hMHq3F+gwARGHNbOuXPM++2dXUD5MMfyI8PRfI=;
 b=am5feQLDb4l6F8gJSNdvfdZCW74eII4q1EHU0xcSsOWACpo3v+6VdKME13exdvE1W3ZokpwfotVhx68vvF0B1uurRY2UG/wAPZEVm2SWUMw1O/0vyJ5Jq9c4Yg4kqCt5k3bPko118A98tSww8q8eYu7SMQ1MgecQXbt4wkmmI7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 CH1PPF5A8F51299.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Wed, 4 Jun
 2025 04:43:09 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%3]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 04:43:08 +0000
Message-ID: <c65b0cf9-a3cb-4e62-a40c-a69a14ea2255@amd.com>
Date: Wed, 4 Jun 2025 10:13:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 28/28] KVM: selftests: Verify KVM disable interception
 (for userspace) on filter change
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Chao Gao <chao.gao@intel.com>, "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-29-seanjc@google.com>
 <83d8cd7d-0e7a-4d01-bff9-4c05815474ae@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <83d8cd7d-0e7a-4d01-bff9-4c05815474ae@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::11) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|CH1PPF5A8F51299:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cbd26c7-e61b-4067-e946-08dda3224d8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1pBb2h3QldrL0Fwa0UzUzk0REVFZjl6VkhiM1FCekRTTDJjVEYwQTUxdngy?=
 =?utf-8?B?dytQLzUxN1hqdGRkVm9XTmN5YmdELzh6UlpYRDRBSktka3p1bkkrWk9ycFRP?=
 =?utf-8?B?NUtjaFR4ZVU2TW5zNE80TEtpN2lGclVldVN1WFZDbWd5bHE2RVRmRjREbWhY?=
 =?utf-8?B?WnZGZG13aWZtMjRVSTdleGpuRXFnZnBNclRVTXUzQlZrR1dibmFmdThld0o3?=
 =?utf-8?B?SjZydS9PY3NTVGE2N1YzWXU4TkVYTHo2TWFZckNjZXg0SGpKcE9aclVMcU5K?=
 =?utf-8?B?NUlGcE9BdUhlblNUdWhhQzRjU3RLbDVmT3NCUTM0R2ZBR250emdNUEhWdWxM?=
 =?utf-8?B?QVhITFRJSHVVcEdEZlJkSGU3aTRXY29iYThtSFROYTlXTlZTNWk0QnRmQlZi?=
 =?utf-8?B?YmhaeDdKc09xKzZPaHJzSG9CdFY0dEdwL3p1TXR1UzNtSVBQc2tPK0JRT2Nj?=
 =?utf-8?B?bWZVVTVoTFc4UkIyZncrZTJEbEhjT0JqZkd4YUNVYXpObG11L3dob2tPOTdT?=
 =?utf-8?B?QnFjY09MZE04UTJQdzlhdmxvQ1lZN2I5eWVlMFpBajZ3UllYR2d6N3dqZXIr?=
 =?utf-8?B?bGtSRURwZEFBelAxc0lLbnJyQVRFaWVQZkpoTko4c2prY3pLUzluNUlUT0Qw?=
 =?utf-8?B?MVRBM2NUQUFMVHlhZ1hLc1YwdktXTUNjYVZXRzBtOVc1VW90WWhOTVlsbkxV?=
 =?utf-8?B?aUh4cExja0lER2ZoUFN3L2JjczNIaW9aUzhlVXM4M0RUNVhZalRxM3NrZS8y?=
 =?utf-8?B?RTJDdHAzbmd2L2VTY295emM4V28rSnhyeWlSWEx6dUJiMDNrK3B4empCaWI4?=
 =?utf-8?B?SGU1QWFzY1hTbnBlbzhkVTVULzJNUnlwdXhZTDFDR0lIMTkydjhjVFQzeVgx?=
 =?utf-8?B?RmI4cnlQZE1OSngwOEFkSmxib0JMc1NNdnJvZ0ZEZzBWUHllUkpaVTkxQ3ht?=
 =?utf-8?B?UERDREphZ01acUcrT3AveGc4eE1qS1JnZmxXbEUxUU9UcTRQL21Jb1lXRGNM?=
 =?utf-8?B?RGtRajJVVHdnQlE0R0NsdWZlMXBaYXA0TTBlMTJFR3VFRTA5QzFMNzQ2SXJ3?=
 =?utf-8?B?SUZ5MGhZMVJlT1A3MHh2a2NKdC90WGxyWWJiK2dXY2o5YVRLVHpVWjRTSWZT?=
 =?utf-8?B?Y1lPVXZFMkJFajNuQXFIUlV4b0dndW1ldzBkVS94ZXRCczdaQXpxVWhtZkw2?=
 =?utf-8?B?bHArUGlaTXNOV2l0ZGlldWZBbGhhcDFYVmNBb1Zvb2ViWC80VWI5K2FqSUs4?=
 =?utf-8?B?VFg3enRPWDRWZm5scUl0TGN2TERNR2NvU2ZRS2ZsUEd6SGo0OWttREZ4Zlo0?=
 =?utf-8?B?YkJjdmN5ZGhlL1RleVpjTzhBLzBjVlZESE1KSWt1MFlkRFRzbG1MUVc5bjJl?=
 =?utf-8?B?eUFSZ2NYSFh3RlZCQ3N6eFEvT2ZmVGMrZGZNMmVETC9EdjhjeGEzd2VDNGFQ?=
 =?utf-8?B?b3hlL1lMSDNsV2NFWXJybElPKzI0dXplU3MwZXlmY2FYVnp5SWpxWXd5UVQ3?=
 =?utf-8?B?L2ozSEZ5azNWbHhvUWpRT0ZYTUV5aVZObWtKVjNSVXR0MEpyZWZQTUZyTTJl?=
 =?utf-8?B?Q1NZQVJnZkNuYk15UlF4ZUI4SnRJSmFjTWJ5T0RET2J3ZlBSQVZZZmhKZW1D?=
 =?utf-8?B?ajlwU0ZsaG82eXhTN2ZEV3dvR3JWMWFvTDhXQTM3aWNUT3l0N014bStYOWYw?=
 =?utf-8?B?NC9qRWI3cmlRUUFFMXBWVUpWY1A1QTNKQ0F5eFJiNHhWV0RDR29WdDZBaHVV?=
 =?utf-8?B?amJQT0xBQ25oOCtrLytsd3FzTTVpdWhqcU56NklVOG5PV0pUVDc3dmt4dTVn?=
 =?utf-8?B?dGs5d0dZamxjWDFIMVBsT2E1Z1FKWTlQWTdJTWJOWDcycHl3c2NvalVEWTVR?=
 =?utf-8?B?YVNXd2F2NDVYUlEwL2cxTDFva3VEdE1peENxL3RRemRlYTU2NktCczhqWE9W?=
 =?utf-8?Q?45WKBDq9Fng=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlprSGhkRi90T2I3WDllVGtLczl0aW5XNTNXWjhmK0N2RTRjQ0JaR0J0STV6?=
 =?utf-8?B?eHlZdXNMQnB4dXZMYXRKZlorSUc4c1VLWHdJa2xDQUxoekd5SEFTWkNGVXZ2?=
 =?utf-8?B?dWxMWjgyZnJlTDBGUDlKZ2NueWhKd0FwK0tiZC9oZ01BM3FVeXZ6bDg4anR4?=
 =?utf-8?B?V1RycWF0M1p6WUozLzA1V0JXQW43ZU5GR1FNWnAwOWRTVmhTOVhiZ1JEQjVy?=
 =?utf-8?B?MmlwNVRIZnRZbHdqOUQ5dlJNUmYzajdndmFtdVVreFVYU2p2VG5GTVFGdjNr?=
 =?utf-8?B?WjU5MWhJZWFmSDhFVzUzbWw1cElrQU1jYUZzalFKQVFYR0pUa1RDWVhYV1hM?=
 =?utf-8?B?SWFFYyt5THBOck55aFo4aXlvZkNhdDVqK1NCbEpwaUdxZ3Y5WEk3bWRkNmRx?=
 =?utf-8?B?YmVpQ3B6b1pjNEJFUkNzQUp5TW1VTVpWbHVBYllpK05rcndOMUMzdjViZEdi?=
 =?utf-8?B?YVV6RXU0c21xOStEQkdCNXhOTXRzT3M4a3NtZFJyMjBSeTNFZk1NdU5kaEJH?=
 =?utf-8?B?ZEsxdS82d2UwRmxUTzRoa3ZuWW5yQ3dPL0cyWXJRaFdqb3hHdEtNMXBmQmN6?=
 =?utf-8?B?YTRWSThrQUZrSUtRNXZ4YjVNUGxpNVZROWdTdEp2ZHNrQTgvdi9Fc2kwZXJ5?=
 =?utf-8?B?bjVFM3BiekNSWkZZRGtTV0h4OUhRWFNqSGdIRXBPY1JFM0hGRGFrS1kvWVEw?=
 =?utf-8?B?RkZFSmFvNFB5dXBtcUU3Q3k1V1VVVEJqTy9JaWdVVHlzR2R3Q08yS255Q1RS?=
 =?utf-8?B?N25ZcWI2ajUxRFVReXdJOXZ1a3A4a1VrcVFuYWlOa0xJUTcvN3JIczBwYXkr?=
 =?utf-8?B?bTJxaE9DTWtaRWFTN0hDZUoyMitKUFhHc3FtLyswZDVaTHk2NnV6QllxZzRX?=
 =?utf-8?B?Wnp0RldTbndHWVYrOXByMDhnQ2EzeW1XeWNUL1pnckw1V0RIMC90eWIrcEgz?=
 =?utf-8?B?eWF0YUpPZTkyYTg5cjNrSFFBU0x4cE5aeWN5REtBaTRNRkpvZnB4eWtsejUz?=
 =?utf-8?B?R2RCcE5nbXN4UUJJZXdoVXppREExSHdCb2Ntb1ZHNnlUdFlmR3FIRWJkckFw?=
 =?utf-8?B?akcveXVHYzBTVFRIblZBNWlrUk5ObXlFM0JaRXg1Qnd1bGVrTXg2TUhGOXpY?=
 =?utf-8?B?RTFKVVJSaGsybVBZLy84OG5xVUtBL2RZRnVqaktiNk9Sa3RpdTVIcDBCTWtP?=
 =?utf-8?B?ZFI0WWJ5Y0IrYlRKb0wzQ21NUWdIVEs4Q0xnbUdkVHNIYmlkZys2OUZiMGln?=
 =?utf-8?B?b2tMR2NCdWE2Q3lFdXBDMnVkL1lSTW9sQ1dQeGRjRTNUQnRNZi90R1Z0R1Fs?=
 =?utf-8?B?OGw2UitNZlEvMDJyV2lwTENUSGlNVVJMUFFLa3p3OHJkQkdSZTRDTVhDanVG?=
 =?utf-8?B?YWZrcS9yTEgwMGk1Z0dnTDN2R3VEbSsrY0FEMHp3K2VrQ1BUdmNuZjcyUWp3?=
 =?utf-8?B?a1pOb0pRS2NsUlBjY24yR1ErVWRWNDdLL1RibG1RNFh0aVlYM1F2OC9RQUJo?=
 =?utf-8?B?UUN2bXhsazNGaFhicmtYeklFNnZwelY5UnRvd0lPR3JLa1FobjlKdGRGejJK?=
 =?utf-8?B?MVNrbkdaSzh3NDFQVnJicEhMSEhOdjVQKzNxelJnR3hkZ092UEtJenBoaUJE?=
 =?utf-8?B?VThTdG9uc1RmTUVXdno4Rk5CQkVtTlhhZnpWWlliRlpteXo3S01mWkF0UFZi?=
 =?utf-8?B?Y1gxQnd0eCtaS2k2R1Yvc1ljN2tESmRrd0FzVGJ4VWJuSUhmSndrUzhURkRn?=
 =?utf-8?B?U01EMHZ2cTN4QWlyTU5CUjBLb2NDUkZXNU4rSm5qaHZxaWpGbWY2WG5KUE5C?=
 =?utf-8?B?QnVsTjRtckFMdUcxYUJZRkY3Vi9rZDRzWThRWlJkRXVIVE14cWVSTUt5aytM?=
 =?utf-8?B?QUFZTlQxY0VqaU1IQzFRMC92SVBvWDRUMCtDMmZENlFrZlgxMHZkemViWit4?=
 =?utf-8?B?TGpselk4b3Z0SFp6dUx6aHJUL2hwTU8wQk51KytsMjJ2b0F4MlFpaTRQUTB5?=
 =?utf-8?B?M0t4R2JaVUZRQnl6WEFiRnlSZkw1eFp2a1ozQzJxc01lZ29rb1QzZXZEbWJl?=
 =?utf-8?B?djNHcjBueUlrenpMTXRQRENKWExkaGp5R25abGthRXlWd3VzWkdYWUxtVVB3?=
 =?utf-8?Q?eJvNIeq5hG1oCvGmQN5ic9M+w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cbd26c7-e61b-4067-e946-08dda3224d8c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:43:08.5705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IcB76ozIN2B4rt+ZXVh12pEKnSgtvAom3DaxnR45RSpkV8oof8Ga4xhGKD6M4ia1jU4THds8ZcMTWH29kPbzoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF5A8F51299

On 6/3/2025 11:17 AM, Mi, Dapeng wrote:
> 
> On 5/30/2025 7:40 AM, Sean Christopherson wrote:
>> Re-read MSR_{FS,GS}_BASE after restoring the "allow everything" userspace
>> MSR filter to verify that KVM stops forwarding exits to userspace.  This
>> can also be used in conjunction with manual verification (e.g. printk) to
>> ensure KVM is correctly updating the MSR bitmaps consumed by hardware.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
>> index 32b2794b78fe..8463a9956410 100644
>> --- a/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
>> +++ b/tools/testing/selftests/kvm/x86/userspace_msr_exit_test.c
>> @@ -343,6 +343,12 @@ static void guest_code_permission_bitmap(void)
>>  	data = test_rdmsr(MSR_GS_BASE);
>>  	GUEST_ASSERT(data == MSR_GS_BASE);
>>  
>> +	/* Access the MSRs again to ensure KVM has disabled interception.*/
>> +	data = test_rdmsr(MSR_FS_BASE);
>> +	GUEST_ASSERT(data != MSR_FS_BASE);
>> +	data = test_rdmsr(MSR_GS_BASE);
>> +	GUEST_ASSERT(data != MSR_GS_BASE);
>> +
>>  	GUEST_DONE();
>>  }
>>  
>> @@ -682,6 +688,8 @@ KVM_ONE_VCPU_TEST(user_msr, msr_permission_bitmap, guest_code_permission_bitmap)
>>  		    "Expected ucall state to be UCALL_SYNC.");
>>  	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_gs);
>>  	run_guest_then_process_rdmsr(vcpu, MSR_GS_BASE);
>> +
>> +	vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter_allow);
>>  	run_guest_then_process_ucall_done(vcpu);
>>  }
>>  
> 
> Test passes on Intel platform (Sapphire Rapids).
> 
> Tested-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> 
> 

This test passes on AMD platform (Genoa)

Tested-by: Manali Shukla <Manali.Shukla@amd.com>


