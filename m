Return-Path: <kvm+bounces-64050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F34DC7706C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 03:41:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 46D6A3520A9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777EC25BEF8;
	Fri, 21 Nov 2025 02:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="n1xmwxM/"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EBF22688C;
	Fri, 21 Nov 2025 02:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763692861; cv=fail; b=UHQYIDhUS+4rx1GtaoTUqqu4SwZPP+xNksIIsU6XxBlrj1wqUDwC12RKJH0Qadln0OKSUeehMAAPzd8cTeRBHjQRacpKVEQ5urg31kxlMoxptJa5FRbPpYOlLhy5IsTjevk/CqaFThPxr07RErP+3hYqP5tYElPRMDQWggwfGTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763692861; c=relaxed/simple;
	bh=vPhJk73UebGRXKGGY1UlwrVsRaKwqSwwtAclSD43Urg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VKzpXbYnLb/GAoTdSsaSb/JjkGSiMQ7c0b/ZUBaZML71RGxT6zewMd9HPaIb/H6RM/BQBRvgtvJYiPq4bo8CsJaS2ZZaEeKd200KMs1VvHPmQXFLy/I6951JmVzGRuSwKEquRuBk6qg88Q3A7ljbtBe9t1TcBfvr3DLe4unfssg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=n1xmwxM/; arc=fail smtp.client-ip=40.107.201.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=egpYZTAm5eQ/s+is0m7rSh96qDkJ7UhGmvO6l+tlhl2nVZvU3WKpgoPtxQqRHZzYvfD39tzj0sA8cyyD6FELkb3BkpnmUwo5qH3t0mFfZHiPnfFnfc4FzOywsFcOURN0ewvcfJ/Eu0jJgzKcJL2jvHkeD1OpK/lrdFXXUGYou70oULr0b8t+HJcs4UUITOpgDyS8/Q/SQbZcJH+9MfdVOpkXycPpbG/IJJufA/618vwAP8bsVnQdim1xDnDOZmZW2RhxOafaNvk9+gyk3j1uTA9+DXuM5srpo6p5aGPkUCDjSp6rKpKKMyJWQAQ/w1WWcbHXAkL0NOy+IpvlGNQgng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LipAgv9jcNcvT8i3jyTqtZubFQT9rLmXmJa3bI7+hg=;
 b=v4GnEJ4AR4Czf2T9u/1b4vXDuaR0lt8QYpzc2mn0p/kgW8i8zzpAQl3HrOrT2yVX56sl71VyJxJhJiyq9RoT6tzWHVGuXQSzOZE8NWiM0bWn2CJqPvDK98nBPQDeXj1IjPGIGurZIKtmBpl+3oJh5zCopHViLlcYj8ccp7rKAzK7KUe5JxgOE0qKAvMZz3pi0fZIwc09H+zISmJxcaRFZIurxzzizLLNHFV3vdZITFjYiC9eytQYnx9oNCmD4/BmUNCEqvDveKuc/wwYqLUTXGILfo91XJ8D8kj0gZiJ8fnrCSK0OMasboF/zXpn2L23KQKgToH6PhNokLTVqn6/RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LipAgv9jcNcvT8i3jyTqtZubFQT9rLmXmJa3bI7+hg=;
 b=n1xmwxM/bZTeS/iIbpe2VS+WYFViwjxxhedgQjDFDsyoQ1wVwpni+1VtiBEtb1EMGqPDsdzQwq/kCnu4txvz/i+HX4a0ka6CjrirrGZL/IsKUP9cZBJY3l8ECO9mRSxo1mFyVOuVt8awk7rQegUt2jDcXk3EHT4UiTnziplmF04=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by BN9PR03MB6153.namprd03.prod.outlook.com (2603:10b6:408:11e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 02:40:55 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 02:40:55 +0000
Message-ID: <1c76cb00-1fe1-4fd0-b7b9-86ddca6115ba@citrix.com>
Date: Fri, 21 Nov 2025 02:40:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
To: Sean Christopherson <seanjc@google.com>, Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
 linux-doc@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
 bp@alien8.de, tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk
References: <20251107093239.67012-1-amit@kernel.org>
 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aR913X8EqO6meCqa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::14) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|BN9PR03MB6153:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d71aa7e-1c58-42b7-e231-08de28a76504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MW1YamR2TGNHbEw4QllhZEsyNTQ4aUlpc3F4M0R3UWRrR2RqeVJFOWdyODly?=
 =?utf-8?B?NTU4M1I5L1ZNK0FXV1RPYU16NnNWcFlNR3VmaEducjdvcWR1aUJEY2lUeVEx?=
 =?utf-8?B?Mlc1RGthamRBdCtkS0RaT3pHYTFUZStacWgrOHo1cVZIK05Xb295SXhpWHhP?=
 =?utf-8?B?QVpRYytyN1hId1dWSXFSUC9QUExFMGtJU0dVVlRoQVNOb0JiK3lnd0pvS3Fw?=
 =?utf-8?B?TGhmaVhoQmdoYTVtMC9lK1NubTVQc1IwSExKT2xsSG9WSG5xLzVaQVZMN1hN?=
 =?utf-8?B?V0ZIU2JUUDBVQ2IzemVHcVZXSkdFR1YzME9kak9sYzFaT0h5Q05NK0xEa2dk?=
 =?utf-8?B?d2E5OHRHU3ZLL0hnVzU1cFBBdVMrRy93K1hVWG5zbGxyVDNMT0Z6REd0QUhK?=
 =?utf-8?B?b3E0Y0FKeGJWWHpBSysxN0FwTWNoSXZGMnU5K2FYdGVjYXluVk5veG55Sitn?=
 =?utf-8?B?WWZpRHFQd1BBRTRGTk8zT0EwSkMxaWZVZHBkdWZsTzVhMHJ5ZnFNWTV1VTRo?=
 =?utf-8?B?UnNVV3FUMmU5eStHYU56RmNKQzJvMzBJQVQ1ZWQ5cWtnUVhGMnoxbEJibWNJ?=
 =?utf-8?B?MVRCaHFmNncvakdPM2ZWdFIwcEIrbFFHNkxQYktZKzE3TE5XQUtxcFFWcXZu?=
 =?utf-8?B?WllOZ0Y0OEhSVWpwWVY1LzNyd3hROEFmYjRzTUg4azB0SGtFcjhKUVdwS1Jy?=
 =?utf-8?B?NE8vck4xdTZvT3Y4NDBxMkt1RkNMWnBNcER4WmIzOEVsQU5vT3lDc0d3dHFu?=
 =?utf-8?B?OUJ3b0U2MUM3Mm45Q3RiNFl3Ulc0NVNwczdGMnFPMVVhcE1xRlBVQWgyODlr?=
 =?utf-8?B?WjdVNDFMVityVmcvdnVPL3dEaFh1K2U4bkl1cnFmU0J3dXFoQXY1SHQ4RkxJ?=
 =?utf-8?B?NW5UdDFPWngzSXlxNFJNaUxhSmFqUlVaM1ZhWkpJd3RnMDA1ZWpQRnd0MDM0?=
 =?utf-8?B?eVVSaE8wNHNuQTg2emZNZnRPZURIZDZjNHVwenduUTFYQ2p6SlIyaUEyV0ht?=
 =?utf-8?B?alljSlI4NGNtN2tscTc0VktXMWprRjFyajc0aURzcnYwSXhqckZuTkFFUzgr?=
 =?utf-8?B?NWtoaktIQWo2cGI2S3FSYWdoMU5XUGhXU29rLzdCNGtqdEsxY213ZFh1ZHoz?=
 =?utf-8?B?WEt5Qno0M0JhbUxqaTBmWHVXTUM1ZVdHcVVNVVkzMTZ1dTRqNXNicDVYY3ZT?=
 =?utf-8?B?SnRpVTJJUnpxRU4wNHVMcnVnTnVEK3gvM0RITjFDWFhiaHFaWk8zZWdpNzVo?=
 =?utf-8?B?VklVMzVHdjRmSDZYUGxSbGVISUtSUHFWcFVvUnNrdWdYWXRWRDk4L1A1R3BI?=
 =?utf-8?B?QTJkdGpmUlN0MGFWSWtuRmNwUVdYN0k0b2ROK1Q2eDBGVjh4MVZsYWxBK3Nq?=
 =?utf-8?B?SHlLUlprMTR4UzlnMlhuclA2MkpKSVlua0FaUU1TYVNBWklwdnZLQmVqVXUz?=
 =?utf-8?B?SXh5WEMrOGNoNDdtUkFIQ3JUc3hEOEJraG5rS2VyN0tjSDNGVzJpZ1M3emwx?=
 =?utf-8?B?bytLaGVjZ3IyZ3FMSGF3Uno3ZFVMdEVPLzdPZ0sza2xyT0J5WDB0UUdLVzlW?=
 =?utf-8?B?UEJQUVpDcnkwQnBLcHBRNHNFeFZVNFlmTmxKT0tVUDJXd1FmaGhXODl0MG5V?=
 =?utf-8?B?bERsTXNmQ2w3Mjg5UlBhb09TcXEyYVVPZ3JnWVBEcm40RGYzNmIrdTZtd1RD?=
 =?utf-8?B?N1lyMHdQS1F2emwrWlRRR2c1aG93RFRGYjNVWDV5anhqM3dscjZpMjExcVJ2?=
 =?utf-8?B?b3FOSko3UFpnZWFHTjJSWTdrNThoVzhDRWNtdWljVnpYYThlTzM3K2I5eWhP?=
 =?utf-8?B?bzBBZDM5VkNvdklCTVZmd1o2enBWSDg4UW16OTU4dDVqeVpJaXh5ZldFaGhP?=
 =?utf-8?B?K2hpZ1VHSURRVTFCUTlFcTZGUTBsU1F5L25YOFVSOGNjVkg5Z0lScElxVWJl?=
 =?utf-8?Q?Ja4yGNNvICifpT4KshXxHByi5BB970Nw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWdLWWd1dzRyaUJhcERxSFBITXJBa2tSL05hMGZKK1NYUXhsemVmQWtZcFhw?=
 =?utf-8?B?dmZsM3hLRnRKajBvRUk1ZHBHblJHWHpJRjRta0p4Z0JjR0JTOGpWejR6bGJV?=
 =?utf-8?B?TmZaOWROSTRuclpPcGoxZmQ5a0VNZ1dSWVdPQVhyYk0rSVZrM3krSEVncDBy?=
 =?utf-8?B?ay9yTVZMV3JIbUE0WEJxV0pMeFNTRWtlRzBjbURCSTRyaFBwZmNQS1ZlWkNF?=
 =?utf-8?B?Vk5YUTh5NzZxWWRnenF5YWQwbklhajJURUtCM0did0JoakRsbXJXckZ2eitB?=
 =?utf-8?B?MmVYSlE2VkpIRWNsK3YwR3NtQVY1Y2llZUd6OE11N2w4QWJuYTlTcmYvZWVV?=
 =?utf-8?B?cnVGUXZXMGRmaW5PMlNSb0htWkJUTHJ5Q0dwdU50SC90MnNsODFNOTJ0aFh3?=
 =?utf-8?B?K29SZGxWTm5Nc2RWL0FtbnkyS0ZyazQ1ZGN1QkVnQmFnMTBnRHI2TlI3NkpT?=
 =?utf-8?B?Tk5RcCtJNE1pbS9KeDZrZjJGRlMwQWhxS3dNOTBteGdCSnVveEFlQjJwUkkz?=
 =?utf-8?B?bVIyYlBXSUZGU0dSZ0k1cUxISld6aFRuZk4vKzhrU1phV28zc3crVFg2OHRR?=
 =?utf-8?B?NFZHVFFCQ3pZMGxKZGxVbnJkRHd4a01sWmFwSEpUWXFxUWlmbTRiVDliRlpS?=
 =?utf-8?B?TmdYZG1BOWtWU0R0K1lSd1BONW8wM29DMVpTcGFLbU9OTmNmejN0RVdreVF5?=
 =?utf-8?B?YlAwam51M2JaNkJhTC9oNjY4Y2NudldiaDJwK3RtSDlZSGJINERqcmg3dXpx?=
 =?utf-8?B?MitmazJLNkR0RjR5SWhadk40OWZXSzRtU2NZMVU3cW9RNFVOdEs2cmdIUEhF?=
 =?utf-8?B?cGovVGh1ZW5wYXozL200WStnR0Vlem00RVpUMzBSSzJ4TkZzN3JrV3pIZGp5?=
 =?utf-8?B?MU52SWFJRnZOUVlJRFVXYThmd0FGeFVDUis0bXB6cDNtQmlGaU53OXpBaUpq?=
 =?utf-8?B?WTB1UWErQUJnOERoNmM3SzVrKzd6U1ZWN0hCUFNEWG44TXp1SnpYanhYMml4?=
 =?utf-8?B?ZkZaaGJHTDEwRTRIZ204SGE4Ri8yYVhEZlFyMkIzS3U2OWRGWGZOUDh1MDBL?=
 =?utf-8?B?UVFxQmlLQ05DaHNobnlsNzNjS0FyZVE4dHpBakRmU3FscDA3N1NvZXd3cHU5?=
 =?utf-8?B?SDA4azd2YUpKb0NrU1JZL0pMM1RFSS9XN1I2Vkh6bFhvSnZjZkdqSzIvakU4?=
 =?utf-8?B?UHpZV2FuQ3JZZ000NmZLVDJMcUFTb3ZmSzZiYUcxMXY0Y2trb2hxKzdPbVpi?=
 =?utf-8?B?SStjSFExc05JQTVYUjUvOHZqNWNYUUtTNWk2MkZwa1laQnozVnpidmxDNUNm?=
 =?utf-8?B?Vlk0OXhKNDVVQi9ULzdiSExuZXFwL2ptRzFhdllnbU1pRXJIb29Pa1pJcFBV?=
 =?utf-8?B?NDBhM1RkNFhTYXNmV1RXaEhISElKUXdKc2JuYWVHMnRMYzA5bTJNeFozWStG?=
 =?utf-8?B?UitkNXlIcTJ3TnFkTkZjZWEwdGZEVy9rZU9rbkhDTWU1cGhxbk9YS2ZTM29k?=
 =?utf-8?B?U3NoTlFISC9hdXR1OFJhbEdjRytNRE5Sbko5bEFzT0diaUhaOCtrdDQvc2g2?=
 =?utf-8?B?Q0lsWXNnTjhYTG1wa3RGWVFjbGJHNFZBeXlVZDdSeml4WFM0dTl0SjA5N0ND?=
 =?utf-8?B?QVhZbkltNjZJcU9kbFhIY3dSdUUzTlNRdEJNYW4xWXBHQzRRL0M2OUFQRHY2?=
 =?utf-8?B?YVVaRUxXSVFCdTNPOHZYUFl0L1pOV1Q4YmhXMXg5T3hZUnBnLzBrbnpFR05Q?=
 =?utf-8?B?V1BaN0k4c0VuQ3p5Sit5cmxkOVo2VnNHb28rVkpVOGlTaW9UUmVMRTRsNmtr?=
 =?utf-8?B?Yk5mK3VNQW5BQTdCdHBaeVdqY1dLdjh0RjhUcVNXQVBUTUVwQ3hEWEE5M2Ey?=
 =?utf-8?B?U21XK082aFVSVTlQazE5R0xDQktUYk14S2c0dXY5UTA0dkpnUE1MRHZJRXox?=
 =?utf-8?B?Tk9KbXdWUEhuSzczWEd4VGpWKzdEOXE1MTZ1REd4WUtDeFgxdU9wdFFrWEhI?=
 =?utf-8?B?emNqelF1ZllrWDR3R25VbzF0L2VQNiswclRhTkZTMWVzSmNxZnVJNjJwTUxB?=
 =?utf-8?B?cmw3bE1pQXRmaVRPOFlENExtRXZRWmZ3ZkNCNnRSTVBKditUdGlETU05WHlh?=
 =?utf-8?B?NDd1dTBnS1BZZytUVmZYRHkvalA0SWpPWGhCdVQ3SkR6WVhudm42Q1REdEhn?=
 =?utf-8?B?L2c9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d71aa7e-1c58-42b7-e231-08de28a76504
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 02:40:55.3770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Acodjew3WDZlOdAM921HRu6IhRrdoZkD0czyjsfL9Mm9jLz4I9pQUiOog0RJ9pf/9ttuL+20wwAR+1GwkpFiY9o6oxIyQTnMpfs58ik/EU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6153

On 20/11/2025 8:11 pm, Sean Christopherson wrote:
> KVM: SVM:
>
> On Fri, Nov 07, 2025, Amit Shah wrote:
>> From: Amit Shah <amit.shah@amd.com>
>>
>> AMD CPUs with the Enhanced Return Address Predictor (ERAPS) feature
> Enhanced Return Address Predictor Security.  The 'S' matters.
>
>> Zen5+) obviate the need for FILL_RETURN_BUFFER sequences right after
>> VMEXITs.  The feature adds guest/host tags to entries in the RSB (a.k.a.
>> RAP).  This helps with speculation protection across the VM boundary,
>> and it also preserves host and guest entries in the RSB that can improve
>> software performance (which would otherwise be flushed due to the
>> FILL_RETURN_BUFFER sequences).  This feature also extends the size of
>> the RSB from the older standard (of 32 entries) to a new default
>> enumerated in CPUID leaf 0x80000021:EBX bits 23:16 -- which is 64
>> entries in Zen5 CPUs.
>>
>> The hardware feature is always-on, and the host context uses the full
>> default RSB size without any software changes necessary.  The presence
>> of this feature allows software (both in host and guest contexts) to
>> drop all RSB filling routines in favour of the hardware doing it.
>>
>> There are two guest/host configurations that need to be addressed before
>> allowing a guest to use this feature: nested guests, and hosts using
>> shadow paging (or when NPT is disabled):
>>
>> 1. Nested guests: the ERAPS feature adds host/guest tagging to entries
>>    in the RSB, but does not distinguish between the guest ASIDs.  To
>>    prevent the case of an L2 guest poisoning the RSB to attack the L1
>>    guest, the CPU exposes a new VMCB bit (CLEAR_RAP).  The next
>>    VMRUN with a VMCB that has this bit set causes the CPU to flush the
>>    RSB before entering the guest context.  Set the bit in VMCB01 after a
>>    nested #VMEXIT to ensure the next time the L1 guest runs, its RSB
>>    contents aren't polluted by the L2's contents.  Similarly, before
>>    entry into a nested guest, set the bit for VMCB02, so that the L1
>>    guest's RSB contents are not leaked/used in the L2 context.
>>
>> 2. Hosts that disable NPT: the ERAPS feature flushes the RSB entries on
>>    several conditions, including CR3 updates.  Emulating hardware
>>    behaviour on RSB flushes is not worth the effort for NPT=off case,
>>    nor is it worthwhile to enumerate and emulate every trigger the
>>    hardware uses to flush RSB entries.  Instead of identifying and
>>    replicating RSB flushes that hardware would have performed had NPT
>>    been ON, do not let NPT=off VMs use the ERAPS features.
> The emulation requirements are not limited to shadow paging.  From the APM:
>
>   The ERAPS feature eliminates the need to execute CALL instructions to clear
>   the return address predictor in most cases. On processors that support ERAPS,
>   return addresses from CALL instructions executed in host mode are not used in
>   guest mode, and vice versa. Additionally, the return address predictor is
>   cleared in all cases when the TLB is implicitly invalidated (see Section 5.5.3 “TLB
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>   Management,” on page 159) and in the following cases:
>
>   • MOV CR3 instruction
>   • INVPCID other than single address invalidation (operation type 0)

I already asked AMD for clarification here.  AIUI, INVLPGB should be
included in this list, and that begs the question what else is missed
from the documentation.

>
> Yes, KVM only intercepts MOV CR3 and INVPCID when NPT is disabled (or INVPCID is
> unsupported per guest CPUID), but that is an implementation detail, the instructions
> are still reachable via emulator, and KVM needs to emulate implicit TLB flush
> behavior.

The Implicit flushes cover CR0.PG, CR4.{PSE,PGE,PCIDE,PKE}, SMI, RSM,
writes to MTRR MSR, #INIT, A20M, and "other model specific MSRs, see NDA
docs".

The final part is very unhelpful in practice, and necessitates a RAS
flush on any emulated WRMSR, unless AMD are going to start handing out
the multi-coloured documents...  The really fastpath MSRs are
unintercepted and won't suffer this overhead.

~Andrew

