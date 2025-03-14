Return-Path: <kvm+bounces-41055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 408F6A610AB
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 13:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7669316C9B3
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FDF91FE444;
	Fri, 14 Mar 2025 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="p4We5gCB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8011FCFFC
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 12:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741954283; cv=fail; b=JJv+j8fUkFCH1eU71y4WhhfWBIQ73xDMfNI60IAXnvGxRIa/cBQFt2bftEV3M3LhyRng4hlkNY1CSWzCJdu0iKhPS7r4B4kEipehgzxeZA3xGNyfSuZX+4Kvl1xbrUGziLTuTLU7eKh2WTaj1HDGcMyAtegSmv/4jnfcKuVorwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741954283; c=relaxed/simple;
	bh=jPJi5Ui6FgGCXVCQg6LVtfSDGr6klYLLwdeSFzKqwDM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eN/wpEfxRU8166Zho50raEkuZrDsn8zhhfsIZqHDxYgjjSAeN5DSCJAz4+9Oq1R5dm5L0wmUY+Tjsbaq15WEjBlC3zVSLQs70fFrVxpW0peYEHVCOiGaiBvFKDFjXPLO/9AvZQGp7Vlmx9Qt2xLfNLDVhwu3WpKYrzqPa/4SqeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=p4We5gCB; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9/0o4cTDYNHxcJev3CbckvmxO5ghHkTvebiHOT8YVCZwsmZjhYd24n11lix/Ci/Mtf8xra0p2xip34dSnm57oHTVf7a5BmzQLXJErAIgi0fotr/pajMaYIw25wYsF7O7iWeiUDzE2uL65szdCuH6nCLBqafJDCBJQVdWyG+QntZfasZSoNnVvNF7YKWj28i9HkMOvTaXmL6vIZhs9JMeD0zwe+dSWNyq7fDwhVgwwhK1gA8R4T8df7Njg/HE6Ca8g5v/jNhB6Kuv7WzLc27/cs8DGKQt2qVNS9OLR/fPlFiv9k/5wWOxADNqKfr2nFtwQBmqDwj25ljXa2wY7Y7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mCt9QJFZXO7T6IBcEgP/07pgFynddTgp592PNEifR0=;
 b=KuNldqtM9nuRrTYdhaYFQU92J9UunV8MIKXr5fsFH/C3R4xu9DexYgK2TzC1J1aI+ZWVtXz3umfTHeBuHNPu61uYjI4ATy4wE+hDooXhfQTlUJmhGOyq7N//JJpNNlqdJI33v8ttSQAtWCiISUPrzXTH6mJyawScP6MiLBkwkAQvGdgkE39yvcLVleelJh/bo0/fbvJASq6zUbJQhPI96qB07TqZTe8gowaTm7qKiD3/MyKePGzIsYoV86c4ReIhZBYrgtqDiHEV/VuSiZxlFRxbvaEgUXpJiD5hGMKQ0Ry84v1RVCVsXuhWYP3rDpsDgnChWg+Gqg8t29hsmZI9Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mCt9QJFZXO7T6IBcEgP/07pgFynddTgp592PNEifR0=;
 b=p4We5gCBRUEDwSiI/u3tqIvB/gS0hr/DXrSLuhEhI/UOkYjfFMkQmREPT5+6EV8WKAU4K/xVhryS/SvII4bKt3u5GDhCa8g8IXbQpUW9uo+eWJ8coegbfcj8ySAJo2lAJ8O8FENxnadQMCV96aq+nhWYmutdl0WKH6GU4oTfG1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by CY5PR12MB6479.namprd12.prod.outlook.com (2603:10b6:930:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Fri, 14 Mar
 2025 12:11:18 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8534.027; Fri, 14 Mar 2025
 12:11:18 +0000
Message-ID: <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
Date: Fri, 14 Mar 2025 13:11:13 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250310081837.13123-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0440.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::19) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|CY5PR12MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: 2750ce95-fdd4-432e-709a-08dd62f15365
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aEZMMnQwckRIN0RaZnlINFNLZDhWTGlIa1ZmS3N1QkpUMm05WmtxZk9KLzdJ?=
 =?utf-8?B?aDFBOXc1YVdpblBjWlVKaks4Tm9GWkVCSEVvbWp0bXEyNjgwOHJ0VG1DSko2?=
 =?utf-8?B?eEZlWVp5V1Z6WlFtQWVkandBUGwwWHZDaWxWZHgvZXhsQUI4M2pHYkdSd2Vo?=
 =?utf-8?B?UmgzTXJtVEljaXc0VzUzTnJzZ1NvTGtEdDlFN3cyV3greUFndlJ5c3laSUlh?=
 =?utf-8?B?aG9NOEFqN3dJSmdRczlJVnNuOWhkZnJnVWcrVjBDZmtRUzJzL29QbU8rN3Az?=
 =?utf-8?B?VlR0NzlKSXRwc2Z6TVYwRml1M0p2b3kyOGtLRlVYcUhoOGRsSmxBd056amRi?=
 =?utf-8?B?RGxlOEJNTElyVUIxeFBlRUp5RmFDS3dIRkFabkFFSXdMOWEzUDBHOVVXLzMy?=
 =?utf-8?B?dk94M3p4enJYK0laSmpaY0dWQlQ4UE51dENEZk40aFRLVGlLOVpJaFUxcmo1?=
 =?utf-8?B?T0NNQmJEOVpXQjdOdExORUNsaTJkMlhSVEFzand3MUYya1VDU1V2N2xKcVM5?=
 =?utf-8?B?Y2ZPbitMOWN3WXUwZVFkd0hYSEdhTjU3SGF0SDNrMC8zTW9MWlpncGV1eGpG?=
 =?utf-8?B?anpnN1BVclJ5NEJqdGc4TlcvR3E1bnZqSmZSelVtQTd6ekFrbjhYbW5QbzhR?=
 =?utf-8?B?THFIWjQzWE9vYmVRV3dTamFZWGdINmpMaXcyTVBIRGJGelVKazkzQmgzOXRE?=
 =?utf-8?B?d0dYS1o3ZE12dHN1V09QaUhmMjJTTTJkeHFRazVhbFY2TStXdlBHUi9mZWVi?=
 =?utf-8?B?Y3RDV0l5MUpGeFVBQ1hFVTIwVnpaTHZzVnhQVE9zbk1LcllhQTlFNFlTdzlL?=
 =?utf-8?B?VHRIQ3Z2WEg1bXdQeERxd25SWnpDbDZpS2g1SU5rei8ya090NWdNWFprVzhL?=
 =?utf-8?B?WXdrTzBGc002UTlqL0I5YUU1WlBSNFY0cStvWkE2N0t2Ym1uaTdRanhad05X?=
 =?utf-8?B?SEYxWDFwSDZ3R1dKR2tMaG9IZEovaHdUZGtKYTYxQWgrTHoxWENLOFhuZmk5?=
 =?utf-8?B?ZzZXMGRJQ2t3WlRJbEpYTkZMcTBkeE9GazQ4VVVIY0g0UHRYS0FKbk1RczJK?=
 =?utf-8?B?Ty9kclV6T3pURVNTNmJ2ODk4cHJMcnNCbk9lSUhHTlNyb1lQRkJ5SGpSbURK?=
 =?utf-8?B?OXFLZFp3dFZmQlZyMk1ZeDV6MXBUQ1JRQ2pkN25oWWlTL0tWLzdTVEF6aU5i?=
 =?utf-8?B?T0tFcmloY0t4SDBoTk5Gdm1hZXU2aFgzc2xrc0xydWdhTkZLMDdtRGIxamw0?=
 =?utf-8?B?NHVyWlZHdHluUmF6RDhQRmgwQ1JRT29mTU1hV1U2RlA0YXBMM21wWnQxY2tt?=
 =?utf-8?B?RkhMMlYwUUtIY092dmd6MGFrN0hXdlZwU2FXWmh3dXJNcjU4N2t5OER5Q0My?=
 =?utf-8?B?REhmMlRSOWJqTkhyOElpUC93RGpUWmVBZU9Dd0tnWGk4M0JFS1ZvdEFheE9x?=
 =?utf-8?B?cjBCQVYreFJuTjFKWGRIejNFbGgrdEIrNEpTcTlmT1cxYmxlcTFuWjFMRlV3?=
 =?utf-8?B?VmI0OTBCNFBEUXRBdllWVWVKSHlRUzRQY001N0xiSXJKZWhGVlpOZGc0cnRF?=
 =?utf-8?B?dG5YZWNYM1NJU0N5RkY0TzRFd2VvenRSaC9PYlJIVUFCNEF6ZGFJUlhuc3l3?=
 =?utf-8?B?anV5RXFOWmlaRkNlNUFpMU1UYmdtcFJxU05ucWR1RktQbVhyYkw4U1dXQURM?=
 =?utf-8?B?dldGSE1zM0paOU80Q0xRdXhzWlhtYWZZd2Y5aDRtQ1V1Q2ZHSytaNHJxRDk2?=
 =?utf-8?B?TC9yRVIwUDMrTTEwNnk4b3VFZ2RvYWhjYWxDVWw4YTZuSElVU2EwWDVENW9T?=
 =?utf-8?B?RlplOE5yQTUwMzcrZU5LRmxEcERJdlB3eWNuNVhBK1VVSTViUTBhU1M0N0J4?=
 =?utf-8?Q?hcOMmHojVHObS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVltRHZSd0NqbE4zN2NLQXZTcnhFMzdqY1ZiUFlId2lBTzZ6d1dleFdaNmVP?=
 =?utf-8?B?YTRTUUttVDFUNnR5cGRwUDJHYThSMnA5NkhheUhQZGFPUzJyWnJTUUE3NUtN?=
 =?utf-8?B?dlVMNVgrYVBTcTdhZ3Rsa1ZTUnFmVnJ6K0VJelBOQ2E0aWM3dUJ4R05YZWhr?=
 =?utf-8?B?SHpQN1lyNGc3RCtKN2loR1Rybk1aWWllTWtoS2pSUmdYd3YrVjNQMUwzQ083?=
 =?utf-8?B?OWo3TUJyZGpEdDdzNm9kRkNMcXJkQ0dDeS9hN3c2ZkcxU2VJQUxaOWFsM3dS?=
 =?utf-8?B?anFhUFY2eDQvdXVna25KVWRUN0J2U0lUSFozU3FxVkxUMFo3bjFVR2ZzRUEz?=
 =?utf-8?B?RHdmRDgvcXcybHR0dkt3TU9iNFJtd1A5VGx4Y3dScm1IQk5CSitFV3l4bUQ5?=
 =?utf-8?B?QTlBY21RSVd0ZytmM2tJeXhGYXRKenJZU3MyQU9ESTA3dUJCTElYWll3dHh6?=
 =?utf-8?B?UDJXbS9ZRk1zd2JCSjd6TWlvbE12QU5DcXJ6QkFxeHU4ZFV6TGdiM2FjUTkz?=
 =?utf-8?B?UW5rSzgyekRHVi8xZFM2RmtzNUVQMU9HT0xkayt5eUwrOUsvNFBwVG53d3hN?=
 =?utf-8?B?YXNhZHFMOFNmMnhZOE1sTEdoZEZQT2FRL1lNeFBSdHcyOEZNWTgweFZ1c2VH?=
 =?utf-8?B?cHk2OGVTNE9QeHdwdmtBUFp1bUI5S3Y5OFJWRThlb1llWnF3MG5lRmZzN2sw?=
 =?utf-8?B?OSs1eWFSdFJGTUlJeUNaVzcwQmxnaHE1a2NBTG13Si9xak9DblRMK0h6THg0?=
 =?utf-8?B?N0w4dXlzRFhiaXNTRVlYYW9PekhDTVkzVms0cGRudk5ESnp6Rmw3VHRKL3pr?=
 =?utf-8?B?S1BYZWZWNzg1cjVkbUlxU1FJaXgwc3VlVzZUbUtpWVJ0U2lIUGRMbFN2YzdI?=
 =?utf-8?B?Ri9jNE5Tam0vTDlwM25JODh0enJ4Q0RiZWNTVXV2cXBFZmFLQ09oWTAycVdQ?=
 =?utf-8?B?ZWFvWWc1Tkt5RGFmK1BuanA3NkVLaFd4MjlnY3NRcy9INnRNRFZua3AwZ2RP?=
 =?utf-8?B?ODQrYWx2TndHQkpwOWpRd2xNZk50SVZKaGZwVlZhSWhBMTdTVkIxTVRQNDAr?=
 =?utf-8?B?TUdYRHNxZWZJUmIrMFdYRlZnVEM4ZlZvRWU5eTZkcjFvei8xS1U5cUdhaUpn?=
 =?utf-8?B?NWVSZ2ZXeFdTaXhObURwb2lYa2N3ajJnTHhsaUtrR1NHb0pmK09EVmF4bVFr?=
 =?utf-8?B?SjFvTlpmOTk3SXkvcSt6aUFvM1RZQzhvM2ZwNnRDNXNFYldsTWN4L2Jnem1a?=
 =?utf-8?B?aEJ3cXBwbHdjYzVUZDVwbTFXZ2liUDh3ZE5KK2F2bmVYQnI3bUdZU0NiK2dk?=
 =?utf-8?B?WGZwZW55RTY4QVlyTEF4VXNLUmR6Y3E1YVZLeHNYc2pXNlp4SzMvN0hDWmND?=
 =?utf-8?B?aWNydUZrTkhuZ0FmbFBGL2tBRVhrajduYmpkSFpFeTJMZXRnUWdnUWtVRmVi?=
 =?utf-8?B?WkhNUDJ1eGdiM3g5RjJKM3dxckJzQWg1Q2J2RTVlYTl5WmRSQnN0UkVGNDNk?=
 =?utf-8?B?V042a2twdnhwZENIUG9ybU5lNmwwdlZJQ2pvamFrVTdVYzdkcERxY1E4NWdK?=
 =?utf-8?B?OTlQcHV1eFVVd1crcjZma0lWT2tYNytheUdvanlKNHdBQzV5VjZBVTU2SnhP?=
 =?utf-8?B?ckdVaFRHTHJESG94MHFqQlRVNVEwZG5WV2kvT09xdmlpWWE4TXZWd081WStI?=
 =?utf-8?B?eTJlT2h5K1VqbGRXMHI2dmhOaVhVMis5dXVuQnF3S0IwOS9ZeGNzcEtlK2FJ?=
 =?utf-8?B?TTVLU2lnanpzaHRpN0UyR3l3aWdqbGMzVU9kcUV0NUtKaWhTZzU3MHNUdEVB?=
 =?utf-8?B?azlOUVM5c25MYUhmNGZlcWtZRWxmRjg2SXBhVmhmMVYyZWdyL1hXUlM4VFpx?=
 =?utf-8?B?WVRtUXYrcEx6RlZENU9OaFRwR21vamI3MGJRTDFNZytDVUJDTENGL2wvbzNZ?=
 =?utf-8?B?enlPd0hTaXZxVVZxaXNmbTAxbUtMVDNTTUVhQmRwMENjellXOFc4NVM1bWJO?=
 =?utf-8?B?K3FENWVHZWw4Y01WUWVic3FBYVQ4MW53Ylc5Y2hZMldGdkJRSk1kTEVjb0Qr?=
 =?utf-8?B?Z3N2Z3RqVHJyaDV1R0MrQUx5bzFJZGZxazc2Q1ZPdklNY2xIbDFhMUNXQlhs?=
 =?utf-8?Q?B29hicDhW39uqoh0rqoQ90uEw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2750ce95-fdd4-432e-709a-08dd62f15365
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 12:11:18.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfK544zROinJMRMMypxDmV2B2sKlsxgxmSdvnt6XshP1l8xS7Kqkma2Qg8xKlM8aK7QPd8pi5IZROecr+LnT6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6479

On 3/10/2025 9:18 AM, Chenyi Qiang wrote:
> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
> uncoordinated discard") highlighted, some subsystems like VFIO may
> disable ram block discard. However, guest_memfd relies on the discard
> operation to perform page conversion between private and shared memory.
> This can lead to stale IOMMU mapping issue when assigning a hardware
> device to a confidential VM via shared memory. To address this, it is
> crucial to ensure systems like VFIO refresh its IOMMU mappings.
> 
> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
> VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other. Therefore, similar actions are required for page
> conversion events. Introduce the RamDiscardManager to guest_memfd to
> facilitate this process.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> RamDiscardManager interface. One potential attempt is to implement it in
> HostMemoryBackend. This is not appropriate because guest_memfd is per
> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
> particular, the ones like virtual BIOS calling
> memory_region_init_ram_guest_memfd() do not.
> 
> To manage the RAMBlocks with guest_memfd, define a new object named
> MemoryAttributeManager to implement the RamDiscardManager interface. The

Isn't this should be the other way around. 'MemoryAttributeManager' 
should be an interface and RamDiscardManager a type of it, an 
implementation?

MemoryAttributeManager have the data like 'shared_bitmap' etc that
information can also be used by the other implementation types?

Or maybe I am getting it entirely wrong.

Thanks,
Pankaj

> object stores guest_memfd information such as shared_bitmap, and handles
> page conversion notification. Using the name of MemoryAttributeManager is
> aimed to make it more generic. The term "Memory" emcompasses not only RAM
> but also private MMIO in TEE I/O, which might rely on this
> object/interface to handle page conversion events in the future. The
> term "Attribute" allows for the management of various attributes beyond
> shared and private. For instance, it could support scenarios where
> discard vs. populated and shared vs. private states co-exists, such as
> supporting virtio-mem or something similar in the future.
> 
> In the current context, MemoryAttributeManager signifies discarded state
> as private and populated state as shared. Memory state is tracked at the
> host page size granularity, as the minimum memory conversion size can be one
> page per request. Additionally, VFIO expects the DMA mapping for a
> specific iova to be mapped and unmapped with the same granularity.
> Confidential VMs may perform  partial conversions, e.g. conversion
> happens on a small region within a large region. To prevent such invalid
> cases and until cut_mapping operation support is introduced, all
> operations are performed with 4K granularity.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v3:
>      - Some rename (bitmap_size->shared_bitmap_size,
>        first_one/zero_bit->first_bit, etc.)
>      - Change shared_bitmap_size from uint32_t to unsigned
>      - Return mgr->mr->ram_block->page_size in get_block_size()
>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>        case.
>      - Add const for the memory_attribute_manager_get_block_size()
>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>        callback.
> 
> Changes in v2:
>      - Rename the object name to MemoryAttributeManager
>      - Rename the bitmap to shared_bitmap to make it more clear.
>      - Remove block_size field and get it from a helper. In future, we
>        can get the page_size from RAMBlock if necessary.
>      - Remove the unncessary "struct" before GuestMemfdReplayData
>      - Remove the unncessary g_free() for the bitmap
>      - Add some error report when the callback failure for
>        populated/discarded section.
>      - Move the realize()/unrealize() definition to this patch.
> ---
>   include/system/memory-attribute-manager.h |  42 ++++
>   system/memory-attribute-manager.c         | 283 ++++++++++++++++++++++
>   system/meson.build                        |   1 +
>   3 files changed, 326 insertions(+)
>   create mode 100644 include/system/memory-attribute-manager.h
>   create mode 100644 system/memory-attribute-manager.c
> 
> diff --git a/include/system/memory-attribute-manager.h b/include/system/memory-attribute-manager.h
> new file mode 100644
> index 0000000000..23375a14b8
> --- /dev/null
> +++ b/include/system/memory-attribute-manager.h
> @@ -0,0 +1,42 @@
> +/*
> + * QEMU memory attribute manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#ifndef SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
> +#define SYSTEM_MEMORY_ATTRIBUTE_MANAGER_H
> +
> +#include "system/hostmem.h"
> +
> +#define TYPE_MEMORY_ATTRIBUTE_MANAGER "memory-attribute-manager"
> +
> +OBJECT_DECLARE_TYPE(MemoryAttributeManager, MemoryAttributeManagerClass, MEMORY_ATTRIBUTE_MANAGER)
> +
> +struct MemoryAttributeManager {
> +    Object parent;
> +
> +    MemoryRegion *mr;
> +
> +    /* 1-setting of the bit represents the memory is populated (shared) */
> +    unsigned shared_bitmap_size;
> +    unsigned long *shared_bitmap;
> +
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +struct MemoryAttributeManagerClass {
> +    ObjectClass parent_class;
> +};
> +
> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr);
> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr);
> +
> +#endif
> diff --git a/system/memory-attribute-manager.c b/system/memory-attribute-manager.c
> new file mode 100644
> index 0000000000..7c3789cf49
> --- /dev/null
> +++ b/system/memory-attribute-manager.c
> @@ -0,0 +1,283 @@
> +/*
> + * QEMU memory attribute manager
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "exec/ramblock.h"
> +#include "system/memory-attribute-manager.h"
> +
> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(MemoryAttributeManager,
> +                                   memory_attribute_manager,
> +                                   MEMORY_ATTRIBUTE_MANAGER,
> +                                   OBJECT,
> +                                   { TYPE_RAM_DISCARD_MANAGER },
> +                                   { })
> +
> +static size_t memory_attribute_manager_get_block_size(const MemoryAttributeManager *mgr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K or 4K aligned,
> +     * Use the host page size as the granularity to track the memory attribute.
> +     */
> +    g_assert(mgr && mgr->mr && mgr->mr->ram_block);
> +    g_assert(mgr->mr->ram_block->page_size == qemu_real_host_page_size());
> +    return mgr->mr->ram_block->page_size;
> +}
> +
> +
> +static bool memory_attribute_rdm_is_populated(const RamDiscardManager *rdm,
> +                                              const MemoryRegionSection *section)
> +{
> +    const MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
> +    uint64_t first_bit = section->offset_within_region / block_size;
> +    uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
> +    unsigned long first_discard_bit;
> +
> +    first_discard_bit = find_next_zero_bit(mgr->shared_bitmap, last_bit + 1, first_bit);
> +    return first_discard_bit > last_bit;
> +}
> +
> +typedef int (*memory_attribute_section_cb)(MemoryRegionSection *s, void *arg);
> +
> +static int memory_attribute_notify_populate_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    return rdl->notify_populate(rdl, section);
> +}
> +
> +static int memory_attribute_notify_discard_cb(MemoryRegionSection *section, void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    rdl->notify_discard(rdl, section);
> +
> +    return 0;
> +}
> +
> +static int memory_attribute_for_each_populated_section(const MemoryAttributeManager *mgr,
> +                                                       MemoryRegionSection *section,
> +                                                       void *arg,
> +                                                       memory_attribute_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size, first_bit);
> +
> +    while (first_bit < mgr->shared_bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
> +                                  last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int memory_attribute_for_each_discarded_section(const MemoryAttributeManager *mgr,
> +                                                       MemoryRegionSection *section,
> +                                                       void *arg,
> +                                                       memory_attribute_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const int block_size = memory_attribute_manager_get_block_size(mgr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
> +                                   first_bit);
> +
> +    while (first_bit < mgr->shared_bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s", __func__,
> +                         strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_zero_bit(mgr->shared_bitmap, mgr->shared_bitmap_size,
> +                                       last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t memory_attribute_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +                                                         const MemoryRegion *mr)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +
> +    g_assert(mr == mgr->mr);
> +    return memory_attribute_manager_get_block_size(mgr);
> +}
> +
> +static void memory_attribute_rdm_register_listener(RamDiscardManager *rdm,
> +                                                   RamDiscardListener *rdl,
> +                                                   MemoryRegionSection *section)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(section->mr == mgr->mr);
> +    rdl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&mgr->rdl_list, rdl, next);
> +
> +    ret = memory_attribute_for_each_populated_section(mgr, section, rdl,
> +                                                      memory_attribute_notify_populate_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +}
> +
> +static void memory_attribute_rdm_unregister_listener(RamDiscardManager *rdm,
> +                                                     RamDiscardListener *rdl)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    int ret;
> +
> +    g_assert(rdl->section);
> +    g_assert(rdl->section->mr == mgr->mr);
> +
> +    ret = memory_attribute_for_each_populated_section(mgr, rdl->section, rdl,
> +                                                      memory_attribute_notify_discard_cb);
> +    if (ret) {
> +        error_report("%s: Failed to unregister RAM discard listener: %s", __func__,
> +                     strerror(-ret));
> +    }
> +
> +    memory_region_section_free_copy(rdl->section);
> +    rdl->section = NULL;
> +    QLIST_REMOVE(rdl, next);
> +
> +}
> +
> +typedef struct MemoryAttributeReplayData {
> +    ReplayRamStateChange fn;
> +    void *opaque;
> +} MemoryAttributeReplayData;
> +
> +static int memory_attribute_rdm_replay_cb(MemoryRegionSection *section, void *arg)
> +{
> +    MemoryAttributeReplayData *data = arg;
> +
> +    return data->fn(section, data->opaque);
> +}
> +
> +static int memory_attribute_rdm_replay_populated(const RamDiscardManager *rdm,
> +                                                 MemoryRegionSection *section,
> +                                                 ReplayRamStateChange replay_fn,
> +                                                 void *opaque)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == mgr->mr);
> +    return memory_attribute_for_each_populated_section(mgr, section, &data,
> +                                                       memory_attribute_rdm_replay_cb);
> +}
> +
> +static int memory_attribute_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                                 MemoryRegionSection *section,
> +                                                 ReplayRamStateChange replay_fn,
> +                                                 void *opaque)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(rdm);
> +    MemoryAttributeReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == mgr->mr);
> +    return memory_attribute_for_each_discarded_section(mgr, section, &data,
> +                                                       memory_attribute_rdm_replay_cb);
> +}
> +
> +int memory_attribute_manager_realize(MemoryAttributeManager *mgr, MemoryRegion *mr)
> +{
> +    uint64_t shared_bitmap_size;
> +    const int block_size  = qemu_real_host_page_size();
> +    int ret;
> +
> +    shared_bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +
> +    mgr->mr = mr;
> +    ret = memory_region_set_ram_discard_manager(mgr->mr, RAM_DISCARD_MANAGER(mgr));
> +    if (ret) {
> +        return ret;
> +    }
> +    mgr->shared_bitmap_size = shared_bitmap_size;
> +    mgr->shared_bitmap = bitmap_new(shared_bitmap_size);
> +
> +    return ret;
> +}
> +
> +void memory_attribute_manager_unrealize(MemoryAttributeManager *mgr)
> +{
> +    g_free(mgr->shared_bitmap);
> +    memory_region_set_ram_discard_manager(mgr->mr, NULL);
> +}
> +
> +static void memory_attribute_manager_init(Object *obj)
> +{
> +    MemoryAttributeManager *mgr = MEMORY_ATTRIBUTE_MANAGER(obj);
> +
> +    QLIST_INIT(&mgr->rdl_list);
> +}
> +
> +static void memory_attribute_manager_finalize(Object *obj)
> +{
> +}
> +
> +static void memory_attribute_manager_class_init(ObjectClass *oc, void *data)
> +{
> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
> +
> +    rdmc->get_min_granularity = memory_attribute_rdm_get_min_granularity;
> +    rdmc->register_listener = memory_attribute_rdm_register_listener;
> +    rdmc->unregister_listener = memory_attribute_rdm_unregister_listener;
> +    rdmc->is_populated = memory_attribute_rdm_is_populated;
> +    rdmc->replay_populated = memory_attribute_rdm_replay_populated;
> +    rdmc->replay_discarded = memory_attribute_rdm_replay_discarded;
> +}

Would this initialization be for
> diff --git a/system/meson.build b/system/meson.build
> index 4952f4b2c7..ab07ff1442 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -15,6 +15,7 @@ system_ss.add(files(
>     'dirtylimit.c',
>     'dma-helpers.c',
>     'globals.c',
> +  'memory-attribute-manager.c',
>     'memory_mapping.c',
>     'qdev-monitor.c',
>     'qtest.c',


