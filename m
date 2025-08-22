Return-Path: <kvm+bounces-55524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 431DBB323DB
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 22:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DDD01D63FC2
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 20:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C9730AADC;
	Fri, 22 Aug 2025 20:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YPcgNAbW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAB4139E;
	Fri, 22 Aug 2025 20:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755896268; cv=fail; b=GkLl+RUUWOJntoIXMBngdiZifvQsDN6Ys3srSkuNi6n4ythfZsSAuk8Nh3q46ZPrarV6eZ+/a3yGtLxb0qSglThUfmmrrUl9nC7h/3Z/YlfqRyNfw7oq1NCpN7bwG6G5MPG03cfwNr1W5kZD7CC/Bxp3v3B+4oxQjXrSW60EJNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755896268; c=relaxed/simple;
	bh=jhBUCGzn+amkVvvOYFgaYJ5x0ssYke0okdPsdieFbJQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ruZuUPXCZ+MyOTkilcEzAmFpkuE56cJ4l3I2W5rKxdQfkOVNJ8JS7o8OV7RBnsaTNhJ4chhp7rlDYXovNIHlNSAD8Che1Kr0pvYdh4I7JvXcRGc5kMc6SzS9jIlxqb+zs0xR14ZoT61gbra6CtEtcwgt25WokV9mZPG4/MQ8+BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YPcgNAbW; arc=fail smtp.client-ip=40.107.220.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFNzvI6lV88ml2NkBwlMT2PVlL4XZs+I3xasGMk9U7NaG3UIhAjlhh7HLTLHh9zU3X9S1365LbNIrQM8jLQC8r0bj/AoV37UedgeghUq/qZwjgmLjpm7J1egPJyJ4p6Bny/sXn4+Mf4K/fvzcf3nvR+AzqpQhmtRwT8+Aj3X3q9NzN9cVJVHHvdTVMAzCxvcNLJZ3VNZnoIWm2pwBZ2fK+KGOfNe3m4d8q7R/2hQcefvrSziNEeHhh+3YSblnxVbeqHotI5lhVgyy2LhHwdq4sytisuHShK4vQp7AGlDaEovA7H2kMPL5s9H9SOHm1OCuEi8osmud+VbqlvcE/7AyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=REyDoP4aOMHnvhbZICr+yVCYP/DFDH8pVASSseYShuw=;
 b=TINhwOq5p6Zj56kI+xl0fhFF6eXjW4vc0EigRLhySLAc7TJAf2DVtUny0IlspfxUbOwBl4xsFkeWVUpAwFw+424aSqw1yXXLzy50e4a6LNRvvPUjtNZzULGqYtdr+73mfyuphy//HlJ0gVRdUEXxCxtvEcFirQq6rQk3LlkbwEOe5mK8zT4dTOSg4rphb+pZwB55j79FzyP57ZHb2zyzm3wOJT5hQRLQ4ZnqZ6xUGkZKiOELmUnpl36QKnQes2rVtMG3RMxuf38ipV1553OucXDDE9jiTM8ieMdjQJxylqyKAibDvnGhq9CrzF9Gb+f7XT8RoHcrK8CwupMYteMXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=REyDoP4aOMHnvhbZICr+yVCYP/DFDH8pVASSseYShuw=;
 b=YPcgNAbWTKRpK3IhmvYk8SlnfhntWFxrn1mpPmMM8vjlE+/0K6OB9zoJmCcj8XVdk4/2qQcYhSPeNMgXBYhGCIjo0fGopVTjWuMou14Ck3otMEbNedcFx52/eiDAIZyqllEhB9VhwLTaLR9LAgrDSYtAS/rRbY1Iph4nmnCNsF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS0PR12MB9273.namprd12.prod.outlook.com (2603:10b6:8:193::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 22 Aug
 2025 20:57:40 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.9031.024; Fri, 22 Aug 2025
 20:57:39 +0000
Message-ID: <2de8bad3-cf18-466b-b6b5-79c399ebba2e@amd.com>
Date: Fri, 22 Aug 2025 15:57:37 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] KVM: x86: SVM: Update dump_vmcb with shadow stack
 save area additions
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com,
 chao.gao@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
References: <20250806204510.59083-1-john.allen@amd.com>
 <20250806204510.59083-3-john.allen@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20250806204510.59083-3-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0177.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::32) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS0PR12MB9273:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ebc0b8c-8e18-42b1-2dd7-08dde1be87c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TTVOVm95dkkyWFlZbXhod2JhVHlid2R3KzJRTi85NW9MU2htUzgyN2l3dEJF?=
 =?utf-8?B?RkRFckk1MWZzck9NUE1HaGEvSlo3RDRyaDlIUUl4MERjamIxZDRONGw2dndi?=
 =?utf-8?B?UHR0WkkxVWszV1JJd1VseWlWS3h1bjlabW0vMWYxSVdSUTR0cFdVdUtkMFFQ?=
 =?utf-8?B?YXlUZXFjMmNHaDJRYk12VndOa2JKeU9wVlNob0IrQ2NSUE42Yk1rdXYyaTlt?=
 =?utf-8?B?SGFIcHR2dFZWQ0J3Q1pkazRxZzhxbmtrV1dwSWVxcTNGTWFHR1ovQk9LUWxS?=
 =?utf-8?B?d2ZaMC9SbExjaHN0NjdydzBiVkZ6UU8vazlQbVo3L1VaaXVyQW5EejRrcFJG?=
 =?utf-8?B?U0VSTi9hakpLcEo2SVlmS3ZkYis1dlB6Q0MydVdyeTUvemV5Q3RNTEw5ZjR4?=
 =?utf-8?B?TjNIaVM3K1cwUTYvUnZYSGVla0c3ZnR3SHZqdHNjRG80MnlXVnZRMUFiZWNz?=
 =?utf-8?B?RFNTY2gyMWQ4V2xyc1ZBVDlYc0lQbGd3eDQ0RGM2NklvbmJpVExHdmUwb2ow?=
 =?utf-8?B?SkNQZ2R0YmxidURiWHhGYzkwS2JVaEVIZllNTXo3cFhEbVIya0lmQXNxdjc3?=
 =?utf-8?B?SnNPNlZ1bGU1NW1zNDhEU0UyUkZSeVVZdDNwLy9WM0J5THBhZWdYSmlUN2hm?=
 =?utf-8?B?KzM2ZHpFV0NnMUxBYitEOGViUzBTR0hRSkx5NERZRk9CSjFnaTNPczZuSEhC?=
 =?utf-8?B?M0I4d0xBbTV3QVA5NFluZEpKZjVqaGU3T3MzNTliWmdETlM4QjBDNmtsWUpj?=
 =?utf-8?B?aFdKelhVMjlQUlRHTDhPcDR1Q3hkd3FGM2xIRzdacmkrTjhrSTdqenpPZFpi?=
 =?utf-8?B?Wk12d1pOZ0dreFJYZ0VybFAzR3lqOGVOQTlJZDRZcDlLUEhTNEkvM0dsVnUy?=
 =?utf-8?B?WUl0SDNQK2xVN0NQZXo5VDViSFRLa3VoNi9HanVSQlFmQTRUMURPcDVsMjVY?=
 =?utf-8?B?Ly9wNWtFR29iS2RoMnN3Y2UwbnFNcDVZUFVNemVhRlNsS0ZSNUZPN0xJNkVT?=
 =?utf-8?B?R2tYTG5HWXRySzNEU0tIaHM2YmR0MTQ5bFNiUGl1N2dlZ0FDQW16YUU2RE04?=
 =?utf-8?B?WUovWmN0NGlUZWlJVWVlMzVCZFMxcHZoOWMzbkMzWnkyajBGZ0ZEbDMzYi9p?=
 =?utf-8?B?UldiVmNUNHRTYVVybTMyK055MEt5N2J0bENGbEhQNnR5YmNMRW84T1Vza2V6?=
 =?utf-8?B?Snd6VFNGSXFreFlHNUxvSjlXdG1vMWliTEh4cU1EMWtVNXF3VVpXRnNDWStD?=
 =?utf-8?B?bGhaTFFvRXVWR2VMVUVyTDk5M05NVW5mY1BqQ2dxRG80YTNxUW1tTVhYQTBC?=
 =?utf-8?B?VE5jc0I1elQrMkdEOUhKR3JrWTlxRS9DZm9PVXlEM0V0YXRJNEoyWGtKdEEr?=
 =?utf-8?B?VDhqOVE1ZTd3bk5aYlpwMFZ1REgxd3dVV1g0ZExIWG91L3ZZOFIxbFhxaFpu?=
 =?utf-8?B?c2d5djBKMk9ZMURkMis2Vi9jUzc1d28xcFNpZkNPSWlXbSswRjBFQU9vcEtm?=
 =?utf-8?B?aWo4WVZzaTRRYXhiSktqWlRjMHBmc3pST3BvTzVpY0pLS21FbFJTZ1NiVno3?=
 =?utf-8?B?UVMxSW1tc3JkeXJtYmpoYnhxMm91bm9FcGtGVlMvSWt5ZnNTWVc4YVlMN1hM?=
 =?utf-8?B?ZHJ2SSsyYTNzb2c1ZFVhbU53dW10ZlhTczVNQ093VjM5QkJ1SVNaeG5PUkdq?=
 =?utf-8?B?UDh4ZWlWWlp4NzlEYlBDSnRKVnM0RFY2M25Fai9tUE1MN2JnVjMzcTJrWUdC?=
 =?utf-8?B?S3VtU2Y1RDNzM0U1VC8razE1MkpOYXR2cjhQckpLMit3cHZBekhqdWVjNTVG?=
 =?utf-8?B?VWZWbVhlOXdrMk1aM3dLOGt6d0QyTjViWnZ5WERIR1hGM1RQVUtlbnZGY0hI?=
 =?utf-8?B?VldOOHk2dWwzWHYzYmhwaTBiSC8yNGJzR1JINzNaV3FRQVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cE53L21wVTcvRXZQd2cxamVwUnNGNUVrUzMvYVh4UW5DVDd0czM4VWdhcmkw?=
 =?utf-8?B?N2RQRCtoMHRkZGNmblk1ditnTXpXakVpMzlNU0c0cENncm53U2ZHcnZldUtv?=
 =?utf-8?B?TldiWEw5R2VoaTRjZ1pzRjV6NzhHR1NPYVZQbE1TbmE2ZVg4TTB1SHl3WmQ0?=
 =?utf-8?B?YVpaMFJodXQ1L05aMG9tblVJelRqTzRHUXJ1UXdITForbmJZblNzNW9FQm1z?=
 =?utf-8?B?eTRaOExEK0tSRGlBSE1HTUdiUDRGV05Ub042V3B1bHd6TjM0bkpITlpnM1J3?=
 =?utf-8?B?ZXhtU3RFOGVuSWFOS3FHcmZLQ1FHeWtMbWtTYUtMYy9yQVBUYWc0OHFZckoz?=
 =?utf-8?B?U2tJdHgvMEMwMXArOG1Wc2ZBbGl4SkpNeW41MHRnQjFaQXFIRE9wK1duUFhS?=
 =?utf-8?B?OThLOVJMODNOWlpQSWJIN1J3b1pSd2hTWXlCbFppbkNLVTNkaDdMbDBLVzdp?=
 =?utf-8?B?bVVPdklBN055Tkd3V0lSVzFhb2J1NGVxVDhWdFFzb3hxd2o1dVNnQStyRENT?=
 =?utf-8?B?dUF0UjBnSi91ZEN3NVUyQ25aeWVxdkc1SWR4VUliWkZsZXRZRVZpZm4rbWlQ?=
 =?utf-8?B?WVJjWXRqMzVkbGIydGZpVWtqWUlmQTNNTWYxSGVPdCtidXNFRnVJcmJkV04z?=
 =?utf-8?B?VUFndTd0MTRzRndFZ0daVGdHRWZXZ01xMmN0Z3dSdjRYSGxxSUNKSEMwWDdY?=
 =?utf-8?B?djRMaGhlZzRQSWREQjJZc0IzMExodTdib0lKVC81UXcraE83TEgraVh0eFhj?=
 =?utf-8?B?bjNTTko1eURPQmVpUE1IZTJkem5LNW1oaHEwTVc0QXorOVYya0lUS3RkTkYw?=
 =?utf-8?B?Z2FqZk5qU25sdWFEYkV0aThVaklYZW1NaDUzZlVIM1pidlM1MmdFRTdvS2FS?=
 =?utf-8?B?dkRjVkplTzd2dkorZkdZUzl4OGdlYkVmdHJtVkdYdlM4S1doUUVEYVpxVVZ6?=
 =?utf-8?B?SkVybzF2RFNueXloQU9MVEhETVM2NWoycjR3WkVCRnE5VmszNnFMdThsdW00?=
 =?utf-8?B?NFd2ZE9xUER2NEc3Y0JCTm1iSDlEaHYyL1FDTmROS2FrbWhKTkxLeG53bVVD?=
 =?utf-8?B?eG9KakwzVjB0QWp6OWtERFd6aUJ0aHlXQzJVdTV6QmJrWmVkWktTUU9RcDNi?=
 =?utf-8?B?QzZvZ0dEbmxiZGFPbVVkVVZCdHVLMmlhTTJTblgrSThoTE5DME1IZnVSd3dq?=
 =?utf-8?B?TWNXaGpOYkpQV0dDRy9qTC9WN1ZNSEk1cWVjWWFCL0F1azVlNm9GeEwzNjkz?=
 =?utf-8?B?ejI5QndFNnUxc0czeG5JSFU5a3Ivb05ybGhVUE01OWVOMldONzhRMlJJajFS?=
 =?utf-8?B?bTlQSDdRSDJ5S3gzV09CUVA2TVJlUHpvZTh1eGZzNU9RNnNOMmk5dWdKRWFp?=
 =?utf-8?B?U1NaTzV3SUVTQVRXVWs0R3E2ZnkwbTRDUGcrOFFvRDBlTVNHaUFwSVgvYnBr?=
 =?utf-8?B?TDRhbjV2akNXN2hUVE5JbDlFZWN5WFJHZGZVMjFvb2V2MUo0TFdzUEd6M0di?=
 =?utf-8?B?K3JQU2d5T3lPb0pNK01ha0h4dzRIR0hmRHhMVjRiVFovSVRsdk85ejBKQitx?=
 =?utf-8?B?YlRIemNRVnVqbk1XR0hZUHhldmYxN2hLeXNTTDIrVVk1c2RmYWw1d3doNStD?=
 =?utf-8?B?Mk1BeUZRWTdmMlZlSG1hUitQRHdqcmdickt6MXJQQjBZU3dNUExTeTJpKzdv?=
 =?utf-8?B?anpseVpDc0lGSGNWeFlZMVBBOWxleUozWE5lMlJQUnJBRG5CZEdkWUkrenJq?=
 =?utf-8?B?T0J6ZzFWZml0SWJrRmViaGk4cVRVYWRTUE9uckQ1b3VwZGg2U3FGZksxNkox?=
 =?utf-8?B?cVVxV3p1ZVVNWjMrSEorRnNpZlVuTk9QYXZBOFlJeGpwTnFSazAwYklpSHZL?=
 =?utf-8?B?WDkvL0E5QjZpRUZFRnJpWjRDaUpNZDlsQTdFVXU2TXJxQ1FYNVNUMDF6cXla?=
 =?utf-8?B?ME1ERGd0TlN0MUlSaW9GTHc2bVFSVThaSGpEamNicG5mWWdvTG9ycWRHSHox?=
 =?utf-8?B?TUdseVl0Yk1kQVdVMWhERFBXOTRWbUJFQ3oxbzJybDBnakVaS2E5VExsQ0hY?=
 =?utf-8?B?TStUeXN5c0lDdi90bitucEFWTUxqRE1IZlFPT3A3UVdtaTBLbENycU1YNjRa?=
 =?utf-8?Q?UdX0hUd8TaQ8xhY1q4xTac+Yd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebc0b8c-8e18-42b1-2dd7-08dde1be87c3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 20:57:39.7931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OdPm8tKq+4SWhfWMbtE5ZcHEwu5s9nP/tx92A+467oD/RAzn1VhQFY4uO0uwJdFWhQfXbmJiWHoVW6ZhPksxMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9273

On 8/6/25 15:45, John Allen wrote:
> Add shadow stack VMCB save area fields to dump_vmcb. Only include S_CET,
> SSP, and ISST_ADDR. Since there currently isn't support to decrypt and
> dump the SEV-ES save area, exclude PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
> and U_CET which are only inlcuded in the SEV-ES save area.

There has been a recent patch series that can decrypt and dump VMSA
contents, so you could add those fields if you think they should be dumped.

Thanks,
Tom

> 
> Signed-off-by: John Allen <john.allen@amd.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index d4e27e70b926..a027d3c37181 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3416,6 +3416,10 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	       "rip:", save->rip, "rflags:", save->rflags);
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "rsp:", save->rsp, "rax:", save->rax);
> +	pr_err("%-15s %016llx %-13s %016llx\n",
> +	       "s_cet:", save->s_cet, "ssp:", save->ssp);
> +	pr_err("%-15s %016llx\n",
> +	       "isst_addr:", save->isst_addr);
>  	pr_err("%-15s %016llx %-13s %016llx\n",
>  	       "star:", save01->star, "lstar:", save01->lstar);
>  	pr_err("%-15s %016llx %-13s %016llx\n",


