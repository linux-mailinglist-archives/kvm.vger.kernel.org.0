Return-Path: <kvm+bounces-38815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0AC7A3E94A
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 01:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87FF83BF75B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741AA1A270;
	Fri, 21 Feb 2025 00:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pNqQGaap"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A3AD27
	for <kvm@vger.kernel.org>; Fri, 21 Feb 2025 00:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740098728; cv=fail; b=Mryvw/5OWFOhowsPrTQg3awMmnvFg2YsjH8R2ZiXHf7EKspUqPIA/IA0zud7NIEm4SK8g0TOTxt+cLwQqPfYJsB6I3DU3uQShtB9+S/hwYQF9sFcuq47SgsnD5Uh5H9lEmz2IVVVLY89VRcMqkHbBU/hPZ0zXb6hUd3XlCVDgHQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740098728; c=relaxed/simple;
	bh=lrRQXOrwyk7vOHDUICii9cpkNmNb7Rwm/cJTx6LtNdw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G/upasseXoircGM5vyYMYWHsarVHWG+zYDunFg0rQXqQXaHVHgzrTQbFQhqS2MagThD89xtSIQVLel4lgp9yJw6/LPo3IU60JHRd9ystnbJ5fA1uyBqF0YI6HwoFfZN6XMuqEfNBWxF724H9GQ4XKn3NZiUs9DR3W10sszYDtx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pNqQGaap; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLLDODlDEI6Fixwu/tLDoB+BYXJ3XppnkpWje5AZbGRMIHsU8tcp/asBYxmNDBv5dVAoShrMPhK/YyoB2+H6ACFwCzfbifVhZnIudnZcsj72azjEmHFyCaZDLGRQR7jhm088qNKen2oEwxzb/Q/tCMn+PihvW4ee9RYxxbhasKIZAUDlLdWx/y5qSMUp2LyapS16AxcZVZJqmioIhJLIxpDgdRs+oKozsJnYLap9w9RjuVS1oF0o8ItSedrD8yXrm1biGAWR/xXE1vDMzcItn2pL9Jbzbi0v6PnBLbEcAFOJWoE8cgoS78IhX/utM3k85EViRH/ZaW10Wfm2i8kXVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLBCuRW7BJwcuPeXiB29u0mcclenuvr/Xq10aP4hs0M=;
 b=k59pzM3rHOqDLmFZUXunI8mxjUVC+lYuZZyzyu27Qc0HLBcwW/b5GBj6QAaLrPc5wz5kgyxtm/X7MG/gZ4XZDpY6xCIQh3NIGwPJGoDh4YcOWi4dV0PQbY+IMdQ4Qp+bSOQde0nH7Xg687YPPx02G/VzqL2OAoNwuymx9udY+8KKRxqglAZHQHCiX6vz27r68MiHI5bU9AA5tiLsz3MGaW76/3h8xIYIZW9/Pt/0Kiky+vrQg2g3sZc38TX3TVYMVv1M+HoTUt4JuNENOgR/OMCH99n5MzsmMcDEMORH+DpGAZn0GZiOkM6kFWvuEDsacbLjtKMmA3Vb1RkE1STtpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLBCuRW7BJwcuPeXiB29u0mcclenuvr/Xq10aP4hs0M=;
 b=pNqQGaapVcpEF56SVqGZ+2CokaAeyks4iUBuLhxLcfIyknNbHo6fHEKH3kkjNmZHXX0KJNnmwnoYAcSaabXJ58Ezb59frQc6i3grqeQ9CGBb0pe+4FTjzbqVekRyjW16fO0vEHa4Eou8UWYkA+wPP4PEoVxlPsLdxyVe2jtPcOo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by PH7PR12MB6612.namprd12.prod.outlook.com (2603:10b6:510:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.16; Fri, 21 Feb
 2025 00:45:24 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::b0ef:2936:fec1:3a87%4]) with mapi id 15.20.8466.015; Fri, 21 Feb 2025
 00:45:24 +0000
Message-ID: <5f495e9b-ad97-4094-88de-0f3220c8756b@amd.com>
Date: Thu, 20 Feb 2025 18:45:21 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/6] target/i386: Add feature that indicates WRMSR to
 BASE reg is non-serializing
To: Zhao Liu <zhao1.liu@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 davydov-max@yandex-team.ru
References: <cover.1738869208.git.babu.moger@amd.com>
 <ad5bf4dde8ab637e9c5c24d7391ad36c7aafd8b7.1738869208.git.babu.moger@amd.com>
 <Z7cZVNsZ/PCXA1+7@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <Z7cZVNsZ/PCXA1+7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::9) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|PH7PR12MB6612:EE_
X-MS-Office365-Filtering-Correlation-Id: 81823d61-40c1-4ab1-36ea-08dd52110727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SE8rQy93RktxdFlET0tNbGdldTJscnhRZW9BUk9PN3RDYXFKNjliV21uSHl4?=
 =?utf-8?B?QXNtZ1lvSXc3YytzRXZtSFFsbmFKeWp6VEpqTnRmY2FnZHZTS25nWGZJOGVV?=
 =?utf-8?B?cE5qeStEQWZkaVpEZ3ZndXBBcnhNY0d6My96RDA5ZzVaaWUvWTNQMkJScjdS?=
 =?utf-8?B?R0pQMTlLTHdnT0RZNXpnZGF0YjVUM3VialFQcXRJc1g0aG9LZVp5VWpBTzAz?=
 =?utf-8?B?TzNTamJBS1NUaHp0MXV4UXk3SW9SUzlxVDhEcTQyc1kvMyszSE5wdlE2YkRp?=
 =?utf-8?B?cjdubWczczBQdm1TeHR3VDZBbk1LeS9iajhKRTJ0Z3MyMWtkS1hNVUNVWnpC?=
 =?utf-8?B?S0s0VnNjZVdpdXBDVDhGRzFZb2xZRlNMWlBMVHdXTWJtKzk3WVQ0MGVVaDNB?=
 =?utf-8?B?UHBDMHIxZFFiN090K01FdXd4U2RkeVdDVTE0NUFBQk4zeVEwSG8vNmhXeDhl?=
 =?utf-8?B?QVJ6eDNaOTJmV0o1SHptckpEYUx0RXJHVXdhc0NORVkzN0l1QTYyY3BqSXZy?=
 =?utf-8?B?Z3gyQ1MrdGlLazhWNGppTGxWZ0hrNGg5Y2tnbHVpbXZHM3lFeHhmQXM2TkNt?=
 =?utf-8?B?Z1J3a0JodUFPSTVLbUMrc3p6SDJIM21BcDBXTkdQc3l0aHd5K0dxdmpaM0lO?=
 =?utf-8?B?RTl2aHhEcVRKdzliMzA1di9RTjJJMEMwZ0Y5aHJJZFErbVRZK0xKckVrMDVy?=
 =?utf-8?B?b1VQQ1d1Nk5EWFI4UzZxb01rc2lEeEdtSnF4NVRBYjdWOGJLMnZqckc4WUN6?=
 =?utf-8?B?c2hRd2gxN082NHRGMlc0WmVrUWlFVHlJbUdXMXpXT2NDY283Um9tcmhNVzli?=
 =?utf-8?B?elBoTjYxUWNvSWVzVitUVm5XeFU2M1h5ZGJrNkdBSGY5aTJOeGZlSnp1cjhO?=
 =?utf-8?B?WWtqcDZkWEpmZFNEa1Z6SDEzbnZTTVBWa0lFZ1FIRXRsVWN3OGRwV0syWWNz?=
 =?utf-8?B?SEd3MGs5YW0rRnNmN3k3ek42TDhCZVhkdTFPcnFVWDB4UnpPU2VIZzVjcDFp?=
 =?utf-8?B?TXFpWjNEeUZXejFCZU9yZ1ZXdVZhM3dWRGE0VTUraGcwV2VWMUorWDRPK0FL?=
 =?utf-8?B?ZzVadXc4VFdWNnJhSHBJelBmMFJldG9mNzMzQ253ellFWXVJZnFsaE40Z3Na?=
 =?utf-8?B?NEUwMlVmSG5mM3BSZmxVU1pjb3ZTOTFyMUdFTDJyYW9oVEsvQTJqNS9ncWZp?=
 =?utf-8?B?YklGZklWVEp1STNLYW1pWFREZ0xNNk1odjhJWUs2eXVpWG1GMHdUYityWnBO?=
 =?utf-8?B?aHh4eFRNdW1OR3ZVTEcrZzZSNlNvQnB0c1hjdkhweHJxRVFERnZJTm5ZODZ2?=
 =?utf-8?B?ZTJjeGhBcGEvb1E0UE9nd2hVbDE0Q3pGcEV6VWtocG1uTDNUMzhmY0VOTGVF?=
 =?utf-8?B?UCtwOWkxSGNlNFE1V2ZMQ2llUng0ZnlKbnQ2SWlvSDlpUEo5a1NQN0xDSXYy?=
 =?utf-8?B?L2xjcHA0cUNSNUpZS0dhZGhGMk1jRDJSKzBjSkhNNWdPd1VFWXRLamswa3Ix?=
 =?utf-8?B?TUdYay85WTdtcmdCTWV1ZTBIWUZTbEN2cHNoMHNKVHNPWS9zUGc2WHgzQXI0?=
 =?utf-8?B?RjhBZ1ZmK3hwU290NmFNL1pIVGUwMmhrVmpiQ044TzBRUUw5OTFITWZ4a1hw?=
 =?utf-8?B?TmFqZVFKS3VQWVRpeUpPYnlPYTRNZFFTSjMyRldKQThheTgzcVhEQjhaNksy?=
 =?utf-8?B?cml2ai96Mm9RdVkvS2s4SWkvZENsM1N4M05zdkEvcHR1KzVCdml2M093VmNR?=
 =?utf-8?B?a3JhVlMwU0V6K2szYTdKVUxhd0JiQlpDQjVFYUlDUnUzdXVMSVZaMWVZNjFq?=
 =?utf-8?B?RTJsK3d2ZlMrK09EMk9BTkZNU3pabGhBdThVc1ROT2doME1NS3BKRmdLaW5k?=
 =?utf-8?Q?8KlDGqDat5QE/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFdlRjQxdFZsTHY4NU9LWkIzMTJGZVdteXFsZDlWd0FWWTZ2QVlxOERHUitJ?=
 =?utf-8?B?QWNnQVJSZ1BqUTk5UC9pRGNuSE1oSGF2RXVOSDRDL3dRNDc4cXUxMUEwTG9x?=
 =?utf-8?B?SDZqTGxSZkExenZQQVhWSU5odE0vZnpEckxWZjk3WnJUaEd2bW4xMCs4SkRX?=
 =?utf-8?B?VDl3RkxFNU1ub2xFWUI0TU9NZ0hhemhXUDAxYnRTMlNVYWtWdE9nbzE0Y3Z2?=
 =?utf-8?B?YTFuQVhIVHVTYWpIc3h2UHVKVjd2d2RBeFJrWmJIRU50VTIzT25JeDVYUmxs?=
 =?utf-8?B?K1NvS3U0WFVSc2NaWkpja0VyTzZybjV5SmRsRks3OGZnTFYxUzZPc3l5Z1J3?=
 =?utf-8?B?dkRIMDlMZ1huWnIzbjhqNWNIUzYvb1drVTJvWVZTMkFjTGNhWTZWekwyL29v?=
 =?utf-8?B?dDYreFVOUmRTYXREbzZ0YVlaNk1HWU1KTEFweHdna3FFcnFEam1QMTFPNHdN?=
 =?utf-8?B?V1F4YkoyendHNzgxTUZzK05XWVZJZnZtZXdlSStaU3NxeTgybCtaQXAyZVFv?=
 =?utf-8?B?akgzSW9sQ0M4RW5rWlFpclUwRmgvd0V6eVhsRXBaNUpyb01sYW5TUjZxVklI?=
 =?utf-8?B?d1JtQTFma1dTTVBJM2IzQjdoZ2RpdDlIUFhzVXBNbUV5TVBZblduWVZsU1Vp?=
 =?utf-8?B?SjFSNWRjZ2Rib2VzWWhKYUViLzBkMEo4QlZBV0VIRU0xTTBGdzU3cWJhTmxJ?=
 =?utf-8?B?VDV6SzV3dlZYaGQwZGxqNGgzT2xHUzFCNjg2d1RkVjBSYTc2RXB0U2diZk9M?=
 =?utf-8?B?Y2dBUWY5ZmlTUktlTmFodTVPNGhiVk9GZ05tS2tjaUhqd0E1TXg5R2VvM1hZ?=
 =?utf-8?B?akk1UXFjcnJsL1BGTDJOSC9DUE52SlY4Zms1N3BlemlHQWNnMzVpdzNpYkg0?=
 =?utf-8?B?Zk9URFkxY2RLcDhRRlU3TkVYdktwdWpjK2hNQWxrOHRVTG9FZ0VNY0VsTzBh?=
 =?utf-8?B?eHF4UkdPQURmMlIzaGN6ZW5BVkFreFpGVEtVajBXZUR0QXlXZC9BNWc4VGtK?=
 =?utf-8?B?ZzBDWDJaM2ZPVzMza2xZZnhuaUhiRlFGMmYxNkZFV1VHVXAvSC95UCsvd0Fx?=
 =?utf-8?B?Q1BmVDFodjdXWTJWcDhDZ2lQS2o2OGxkTWVlb2p2b0doMnBmTUxDTGU3UmJh?=
 =?utf-8?B?MHhJb3JzajU4QWEzT1pIc0lWREsvUUtCN25OOUxxOU5hN0k0clBCa3JXSDc3?=
 =?utf-8?B?UDU3R1ZFYWVnbUNXdDFjLzdYZ3lIMXB6YW1MejE0UWVTdkd2R1NlcGE5UFFW?=
 =?utf-8?B?dGdMaWlKaDVJNVBPa1NIaGxWMFdVSHFvaUtpR2JFUHF6dDMyR3h2UGxhUkc0?=
 =?utf-8?B?ZDRxVGF5TjV5OWlGWEZqZkh3aUNtUSszd081bWFvbUhEL09DYVo5bnpvQmN4?=
 =?utf-8?B?Q2I1cmxvbzdRL2ZHOUdsODM4Y2NsNTg1d2MrcUJRcmY2djQ0VTFEYmRicWE3?=
 =?utf-8?B?d3ZsTVNHeEtwN2E2MlFsZlhGNVVtajZzc3hLcmdGWnpZeVIyVVowZm9HZTRY?=
 =?utf-8?B?Y3F3TWZmakU1MVZiNDNqeFRhS01DSGY3YjZrOWQvOHljb3J1MWhaRFpWcmda?=
 =?utf-8?B?cVJaTWNaTk9ma3djdW5JWWpSUld0Z2dOWU1CZmsrQTFTNEYrNE9GZDN6Tlh5?=
 =?utf-8?B?czdIN2wvZXFnb2dQRk4rQ0NtejIzTWVBWkF2emc4cDBSemVaVWRjU1FGL1Z5?=
 =?utf-8?B?cFpVUkMwU2JWNDgzWERJSmNOd21xcHhnT2s4TUpENjBuanQ3TmY1RmVEaFc1?=
 =?utf-8?B?eXVCTGtSREdvN3RmQmRtdUg4WFJacTZOdUJONWY4UkxOYWtJb2xibm04cCtQ?=
 =?utf-8?B?Wm1lRmxTczhsZWc2T05aUHFVcFRENHJBaTJEdFpJQ2tnNzlEaTFzdjlKY2xl?=
 =?utf-8?B?MC90cm02MkNDZ0NyOTdoc1Z6NlpVZ1lHKzRpcGhvbzVhY0VvbXVpQUZFOXlw?=
 =?utf-8?B?dk82Q3hielIxaEhIKzVlU09LNzdUUmZLNyticUFrNHk5SWl5L0FHMkRUTGg3?=
 =?utf-8?B?dEhCNGRkdlArZ2R6eG1sb0kxMmpHVExJSTd2QkJFdjhOYWVHUmxLWkJXV3N5?=
 =?utf-8?B?R2VHNktjR1MxS3JqOTU1Rzk2VnBZMGJJaklOZ3J4MHQ1OENQNGFJL3BKaXRS?=
 =?utf-8?Q?q1cvGZELdgl/mcHafy11e55Tj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81823d61-40c1-4ab1-36ea-08dd52110727
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2025 00:45:24.5977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loBqG/Favyxt/Ucbe0elMBjY+zx1Tx5rhpyyplKgNYr9mbcQ9uAcwbokbdsMnzOu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6612

Hi Zhao,

On 2/20/2025 6:00 AM, Zhao Liu wrote:
> On Thu, Feb 06, 2025 at 01:28:37PM -0600, Babu Moger wrote:
>> Date: Thu, 6 Feb 2025 13:28:37 -0600
>> From: Babu Moger <babu.moger@amd.com>
>> Subject: [PATCH v5 4/6] target/i386: Add feature that indicates WRMSR to
>>   BASE reg is non-serializing
>> X-Mailer: git-send-email 2.34.1
>>
>> Add the CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
>> MSR_KERNEL_GS_BASE is non-serializing.
>>
>> CPUID_Fn80000021_EAX
>> Bit    Feature description
>> 1      FsGsKernelGsBaseNonSerializing.
>>         WRMSR to FS_BASE, GS_BASE and KernelGSbase are non-serializing.
>>
>> Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
>> ---
>>   target/i386/cpu.c | 2 +-
>>   target/i386/cpu.h | 2 ++
>>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 

Thank you,
Babu


