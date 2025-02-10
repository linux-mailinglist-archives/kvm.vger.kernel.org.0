Return-Path: <kvm+bounces-37704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E7BA2F506
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:20:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97C1C3A9986
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 17:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C1812500B4;
	Mon, 10 Feb 2025 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4J3eRMQ9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A336B24BD0C
	for <kvm@vger.kernel.org>; Mon, 10 Feb 2025 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739208028; cv=fail; b=F2oan8boK/DxxUHE/BtC8+yYA3RHW0H2vDbAhjHcwSfsOPbMGgE142NGowyiylZpMS/CPtd4J9S3HKcyBzapcCcNcwA3Kj7ANAgbq393G97yQHB3ENUW2EZjE5cWaF8qTcND/6YhK1bgIVKnY2JyGhj2WJQO6I5L9ZVd1HG8Qhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739208028; c=relaxed/simple;
	bh=FKAnf9Nl4bgOaFNmkW7gS9HvxnbhRhod9qEEt459PHE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GbR5jDHOUtY1vOpLTAIfX4YH1rvGVURaIkae0zZzWTOtYw50uoiW4YcYgWo4L+ucpIJcOMHndWo+go0jywkmqY+ny5nFLv7SbLTWBuajt66DI3NnB2tkuSeWTuu6iKvRvF1irbsJCD/gtEorRG1Lph7GwWzUY8dSwJ+OdZ1jJ/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4J3eRMQ9; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkjO4edTunjJYjZKKdmIclzOd8bXG374j1T5dAk9AplzezqA2lg7bZZYqRKDetEBlvBbW+y/H5y7/ISUb78TDeUFvPA9XrTwAUfNb4/YpJqHIPr4lVbJAvyBhVP28mN1y1C/VMS6ifjHjQV8tHNu1oMfRfz0+rj4Nbnw4c1YgK4z96wfnmjknffwgFNeFU3EgJ9vB8iiUWVIOUYQjM2I0/75gkd4WuqyHJ7U6wZ3XwnBqTcOXlLVOF33ERxdkYn3jTqGq/T9vVxUbgmMfI1ELkdAhapFfSO3WUCODsZzLTqTyt5f5U/gKKBtpGKobOgZFm2Dm3X6w9bhXDXSMmsYRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqS4lwdGkSX4CUtKoLgudBLAMHEz2gpXQavjZVA5bLo=;
 b=Tu6nxBSDWdiUViwlC3J42GP46kXroShw/HEWNGKCIp6gCidiBb7gNPZ/+JBYOuSYOnazTmrHJaIJy/EnTsfVH+8RGIOjA5OKbDDOc9AeXNLNAdHAX2Izii/SRyoGGUdCY5wdw8s9w8ugdLgtV97ibD7ahnYndcZV7SDzDWgGloRaDVrI6KrxVh+c/nl615nWFlYXuM7vByX0NJ/6khTmt59h+XSjQ4iDqYLrLqgr/McpPSORrRBn8rZNPITUOTv3mZquPNHfdL2LjRhsO47sqm7px9SvX3pjOi+yd7iq2cIB5nCD2Z4f/H1QC8ggtJlxL71iy0oqcunZCPyfmzmn5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eqS4lwdGkSX4CUtKoLgudBLAMHEz2gpXQavjZVA5bLo=;
 b=4J3eRMQ9U0dfZ7yxbHi/OjaS3wBsJkRGFJwIphw0vn7/AoeCGtO1wdIjpeDJHuAej5hekpKkIcI75uCknHDFq4PWHF7vBkDoTorWSw+rCVQaq78u9nFlddQQUXmiSCS86Z+CewBN3+8uAtJRvNxTWYzOpv8oio2pt7fGd9XePSI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB7938.namprd12.prod.outlook.com (2603:10b6:510:276::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Mon, 10 Feb
 2025 17:20:24 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.015; Mon, 10 Feb 2025
 17:20:24 +0000
Message-ID: <244cf1cf-72ae-ccfc-6bf1-261bf4463b8a@amd.com>
Date: Mon, 10 Feb 2025 11:20:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 1/2] x86/cpufeatures: Add "Allowed SEV Features"
 Feature
To: Kim Phillips <kim.phillips@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 "Nikunj A . Dadhania" <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Kishon Vijay Abraham I <kvijayab@amd.com>
References: <20250207233410.130813-1-kim.phillips@amd.com>
 <20250207233410.130813-2-kim.phillips@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250207233410.130813-2-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::12) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 88768df1-ab07-4de4-27b0-08dd49f73434
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHBSNTNzTTBtSU4zaWV6Tkd0aUhrQ2MyQlJqQ1pNMnVpYlo0S2VkUFJmZitr?=
 =?utf-8?B?U3BTS20zMlQ1OEhMZjl2SndWN1JwenZ0MklUL3NoNzd6bGlFakx2NTlZeVJV?=
 =?utf-8?B?SGl5b1MydFZZSDdlekF1VDBXWExXcm1MOVNybURmNHJiRVNHWlhKY0JLdWdM?=
 =?utf-8?B?aEdYMFVJQ1VockN0MHlYZSs0NVRVSXlXUkRSejl5QkREZTJoc1V0cFo5bFNp?=
 =?utf-8?B?UXloeEEyRUJqenB0V0Y2N3QrVnBKODdWN29iWU9ERUJXTU14a2tzcGkrNHRO?=
 =?utf-8?B?U0hRYVk5ZmhTdUcyV1NKbU1qU1dKS1ZZeUhBVklTTFBYMXFmYkVYMjVjR1Z2?=
 =?utf-8?B?UXJEdE5xd2p0cVlsSzVrandTNFBIamZ6N2Jud3RZc3ZlUmhudDNGZHFRalhG?=
 =?utf-8?B?MzV0Y1JaRDR3SEhiaXk1TkxoMmZ3OVRyWDVxSDZyM0JtMVB2V3dYZzhqQ2hL?=
 =?utf-8?B?NmJoWm5RVTI4NjljclcxUVZXb1dmVTBGOFlBNklaN0Yycy9tUTJDajdkZkRo?=
 =?utf-8?B?VnFsZ1ZJVGFRK1QyTGNCelMrVXVleTRaZS9IemY4NU1UOUIxSHNoK3RmQVFt?=
 =?utf-8?B?Z3dtbjBxVWptbXQ0SmExWk5IcW9CNnIrc214c29mUmNwUFY2dVIyR1hNNTlT?=
 =?utf-8?B?eEFBbEoxVFZlUGRzYzlJdnlZemp5aVZZZXZOUlliOTMzSzlBd3VvclZWVlVP?=
 =?utf-8?B?Q1ZXRE1VdWE2bHgvWWJrbzZYT1NJWmk5bWZ0R1dwWWZ5Y0pMc2tUWGtUNzI2?=
 =?utf-8?B?ay9RazFPWDV2ZGhtcFZGbm80b0ZVYk9ZOCtobi9hOUNqTEdSS2dEY2dxRHVD?=
 =?utf-8?B?ejFZS216OHFGdUtUTnB4U2lTaUF4MW9IN2w0R0ZuaGN3TXUzSy9YbWlvd3Ri?=
 =?utf-8?B?ZDlvMUFhelZEdmNXOXg1RDRJbGF4Ylc2Njh2ZG5PbWpvN3N2R3NZa1I1TXRZ?=
 =?utf-8?B?bDZyTWZvNjYyeGs5d2RFTzdGSGdRdmUzOFc4cnZlUEU5NlZ0NmJhMW5heGl6?=
 =?utf-8?B?UWJqRFVtbGdKQXdwVnFzWGVxdWNrRmpQdEMrdmVOdy83WE96ckhYemxoSkZn?=
 =?utf-8?B?dHJDN2N4bFJKckRWMDBRc1dLQTZqR3BsaXBJTWg0QXJWM2tWOG95VllhN1hV?=
 =?utf-8?B?RUpPWDZ0cEhtSGlGYmZzK29iaE1iUU5qRGgrK2VFYVp6cVYzTktqczMzZWJV?=
 =?utf-8?B?MGtSdU1lWWRzazNPYUNEWi8rMGdrRmFSNExJMWdOS1ZkL1VpbHM5S0dVQk9O?=
 =?utf-8?B?YUtsOXRQM3ZuMmR2U3RtMkFHMHhvWWJvZUQ0bWlXdEJuYTRyYndFa3dsT1Fy?=
 =?utf-8?B?RUUvN25ZcEpUQ0dSNDczZ2pBS0N2MUloZzh3QXdMSWNESUxYQUtYNjNrWHZX?=
 =?utf-8?B?clF4a0VnN3dFV1NwZUd3VXlNOFg5eHNXUVdtSHdrT3lKVFFaSmNWcjh1S1hF?=
 =?utf-8?B?RWpzdGJkL3J1OWRlMzZ3RUVHWmF2K1pqNFZNMlA4TzcveVp0QmVpSWtFMjRp?=
 =?utf-8?B?bVRFWWJQSWJiZi9PaG1DR2wxUGU5N1o1dGMvWmdXbU5OTjV2U0N2VlNXTGNS?=
 =?utf-8?B?VlVObkpwcUt4YUluRHVJb3ptR3J2Uno2c0pVMmFqM2piVVhGczBzWEZUamw0?=
 =?utf-8?B?U2pwb215N3kvRGNFcGFpcWdkS0pNQ2ZCTFpuSm9iMnJsN04wc1FONTg3YU9H?=
 =?utf-8?B?cjI0cTJlcmNvb3p3dU9NdTd6SlR1WkFkY1JRdmxkRlJqeE1xUmZGTWZsMmph?=
 =?utf-8?B?TDlUU01yZGZHY2xobjNqbGdYbEZnSlhXTms0Unp1WWM0MVZvaFg2NDRsOFJq?=
 =?utf-8?B?TWpuU0doT01QOU1vQVNkTmVwWVBPQno2K3JMaGJ5S2NiZFFhbXU1Y1lBWTQ1?=
 =?utf-8?Q?M2L0kY8+Q2a+C?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGt2S3VLWldCeVJzU3kzbjVkMU5welBiNlhxWXBCc1U1cXZjK2UxdW5PNFUw?=
 =?utf-8?B?UUphNFU0b0E2elNMbVdPN1g0YXp1YzRCcGZ1US9OUHRIVlliN2JDZDJET2x5?=
 =?utf-8?B?dUc3d2pOS1ArYzA1Vnk2K0wvWWpZZkNkRkNHRktpYy9MdVBtVjNMUWVPQW1V?=
 =?utf-8?B?Sis0VTByUlUzdWlRdGVVcCtmWk8wRVQwWVU0NVA4Z1ROdVRCTUc2MUdzU1lX?=
 =?utf-8?B?V0lWV2NwQVdIeFRoRFZldUtYL1JOMnpUWVYyNGZvcll5QjRGL0luMjlzZjdr?=
 =?utf-8?B?Ni9rSUJleDZQMmh6SDlOSDJsRUcvbC8vNTBqTjVHb2ZXMGJKY2thZWIySWwz?=
 =?utf-8?B?UFgwR2VOUWVCeEFmZVpJWGtEQUNpRXUyWmhXbUx3WlBKeGN5UEIxdjg3UG01?=
 =?utf-8?B?K0hHSURnRmw0NGFLUHJGNFp2L2hRMFRGaEdudHBEQk9CTUdBWWF4bHV5aDls?=
 =?utf-8?B?Ti81QmpPcDliWHBIK01hN1dUZVYyR1NTQmtjQ21scWErZHhTOHQ0OG5VYU96?=
 =?utf-8?B?djZ3ZXIrWFNaZW1EUTZXa21TbTI2bStzazVNeHhUamV3T0VPN1oyR0MwNldN?=
 =?utf-8?B?MG9zd2ZVaGU2cSt2ZGt5SmY1UUh0RzJrenhyaGlIZ292cjIwdEt3ZDg2cUVh?=
 =?utf-8?B?TFVGN05wZzFxVzU3RzgzRExhalRtNUJvNXV5cXJsY093MWhybHN1OXlaRVVN?=
 =?utf-8?B?aUluZjZOT3JWMWM0b0VnWFNSSkEvL3J4Mmd4U21WcmZ6cDdqWUxRNERhbldp?=
 =?utf-8?B?dS94T3Y5RndjVTZwR0FOUzhZMGFxU0RmTFp1VGJ1dTlGTTJ6RW4rQUMyQmVI?=
 =?utf-8?B?N2Q3aHNQVG1KS053Z0ViOFRZMmswNnVpTmpvbDBvaE0yTWdaZHc0Qm01TlJi?=
 =?utf-8?B?SmVkaTFCWUExQlh5eHFnMnRBRkJGRFR0YWR2Y0NLQ2JHUEtvWGIwRTF2bFZM?=
 =?utf-8?B?OUFXcmJLS2QrOVNYR05wNEpmYnVXTXNGNkZydkErNllLODFSZXJrTFlid0VZ?=
 =?utf-8?B?VkZva0NFakcvUWx6ZXQvMjNQYWVCTFBxUjNGVDNiRFM1MWxHODh2UGdScFNG?=
 =?utf-8?B?TWo2NWw0NEkwVVNVc3piSUpsMFE5cXlVVUF6djI2K3VXR25hNjZNRDNTbTU4?=
 =?utf-8?B?ZVl3U0pjK0N2QmRPNlZXaVRVc0JXN0Vhd0VYSXdMSmdLWDljMFhheksrU2RJ?=
 =?utf-8?B?TXJWaU1rMkNNQkxKZmQ1Qm1GcUlsZ2NIZFpUcW5rbzFFUUVQUE50U094K3pW?=
 =?utf-8?B?QkZZK1k0U0JadnI1RWx2UTBwai9ldkt3TWFBbnBiWitCU1RhWkxFRCtzZDU4?=
 =?utf-8?B?MWlDaC93RGx1WEJhVlFZbUN3ZkhpV28rSEY2cFJDZ0I2MFBNY0w1bUEvYkRC?=
 =?utf-8?B?Zk9YMjlCb2ovWXo4bXUzeVR1K1BuUyt4MDRKRXE2ekJYZ2o3YXVRc1ZsekV0?=
 =?utf-8?B?MTFOdVhpdDAvZ1hzZUVJUEpMR1B3YndCbitHL3VnYklXaWp1bGJQd3JhSWg4?=
 =?utf-8?B?ejl5Vzk4YllZM3ZiZHo3Vkxlc2VRcXZXYkxFV1VwNmF1N0tqM1BvdmRscmg0?=
 =?utf-8?B?OHhYY3psTEp1bDlzTTNjcE5XS2VuUmlTa1hEWTBKbnJuRlAvREpac3RKVjY4?=
 =?utf-8?B?VzA5aGhnVUt0OWkzUTNVbHhtTVJVWm1FbnRmUm5OR2EwSEdnVUZmN0IzUExm?=
 =?utf-8?B?V3FOOFFQSHFGeHhoRjdWNnh4MEVMYVNNc25LSmgyek5FZVRQalJYV1RpeDdP?=
 =?utf-8?B?ZzZuYklOdFIvR290RjM1cnpFdTZLRkc4Qys4U0xVUWZkWCswL29nWmNXUk5w?=
 =?utf-8?B?WmFocVdCV3RRNzdqOXlDb0pod3FKWkQxc0pJTDk4VzQ0UUJEeFNwRkl4Ykp1?=
 =?utf-8?B?ZzdUMTRad1l6NnNQNmZqQUt3T0xES0x2Y0phcEkyT2NvYVVHUGp0MjJneXZ6?=
 =?utf-8?B?Z203RFAxdTQvSE1iMjd4MzR3QkdHOURaOWZUVTFLcmVzRHhNblZHQmU0UFg2?=
 =?utf-8?B?SFUwbElrM3J4enNFMkowY0o2Q3VaRnZUWVord2lucFdpZ1NUT0Y2VEtRMlRW?=
 =?utf-8?B?RG12TjN0THE1TEd4RkdCTVFEOE0zSk43cktqWGR0UExJV2QzcmE2bVBMRmVB?=
 =?utf-8?Q?Hk254BX89uEo3O8+M7WYxQPJt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88768df1-ab07-4de4-27b0-08dd49f73434
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2025 17:20:23.9740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kRj9TfCKjgrNSU9gzP97UytHNqJ6duqmQZ6zrxOqig/TdxDWdYkWvPyTAjVl1lUnY/DssqFSTsE+RT3AvbnrJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7938

On 2/7/25 17:34, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
> 
> Add CPU feature detection for "Allowed SEV Features" to allow the
> Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
> enable features (via SEV_FEATURES) that the Hypervisor does not
> support or wish to be enabled.
> 
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 508c0dad116b..a80a4164d110 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -453,6 +453,7 @@
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" SEV-ES full debug state swap support */
>  #define X86_FEATURE_RMPREAD		(19*32+21) /* RMPREAD instruction */
>  #define X86_FEATURE_SEGMENTED_RMP	(19*32+23) /* Segmented RMP support */
> +#define X86_FEATURE_ALLOWED_SEV_FEATURES (19*32+27) /* Allowed SEV Features */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
>  #define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Allow Write to in-use hypervisor-owned pages */
>  

