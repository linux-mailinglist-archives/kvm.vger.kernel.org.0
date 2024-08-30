Return-Path: <kvm+bounces-25438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 695B096562D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 06:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21A24283C58
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E51D14A60D;
	Fri, 30 Aug 2024 04:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aaSIGMie"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4655145FE5;
	Fri, 30 Aug 2024 04:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724990692; cv=fail; b=nDmUHwO1E3XvaJkvswN6VeSOl7i+q1ksAdfJrWtaPTeaYokqVgZGyk7WpXWIK1AawlNTRDXSzQzE3WbOWPm+dQh8+8adi26sLZikWMwNKWUg4jv783ttRiCJ4qnanvL3mu62E+s19SnyW+h7SQxA0eh8N9YHjWu7xnvNo+ZQNYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724990692; c=relaxed/simple;
	bh=9xUflKnYWKu530kHM+hHZoCI01mmejZnKQEt1nfiReM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Rnlg+2Uhl8K1ljQEFEQBb+CrXSkAAd2VLgQZgYkt/6MQ4joOYNVhFQBTYcSx7MGTllJRPEUcgEJp+gd1jOyCqoZtDS4ENizRJA2tDQl3KzNUO4k7Gs0nx5HnEe8nxnnqtxg4ndM4JRiVUzHv2eS7fmfap7gCrQE4fJk1EtCgU04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aaSIGMie; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3KawF81R+8q9OdSMmhvcZCc64dcOGsDbaVdH8ifM+sHsCiGoX1tFS84GhwaCBgtlgt3e9SDhuB6S5WO4FbUbITGR4Nfog6e6pSm0C6Sjd3kjLje33fx/2r6kHlyXaHMZHJ9dXxB+QhHbORaABb3DFvn4Yj6pp+Y3a6JAHkWx6rwZUXz/HkHRjKG6zwYF3P6wcjIV/1d7kQauWrXIK007Zgtnixb9/9VdtsP/jHCS9f7VdqnPIZUf7jBS7wxBLodbkIngxaEXNQhXk096ZUhQysvL4Bz009PAWr7+NWafUWNy/syL9tvLADA8rFVOj6/L6pt2LYv14iRqjj26QzW+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMAXxug6ataqABs4x9v268/R9pBcvXHqBW+pdtUImNE=;
 b=mXKbggxzyq3Ni5g9SQZbDR8QHInqjNj3zJ/mEpq6gWxHvxv2GsDgXhwN3eDk49ztZqlhtrxD+qh2NB0U2qfWncQVXHqYpGONfH/AsrT0+IIPaPi0IRjE1XriygZGtOwnElh7Vf1QJqMYDHx7oclmH2LJ+iRt8/zILXNljVb0EwA6LZskiWmk64e2GcfzZmDhZfN+QriasRZvjgKLsBgDdipBDifx/8/GCBtEXLg9Orz3cVbmy/3Wc4r0vPEpn1hSoqtTRgNnUp6YVKFcB7S1NdfL04GPK4C1xjEbhcTJQNQz5RjSlSfyprPzNMChReTmM/7GukFfcXC5ho9SA+g72Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMAXxug6ataqABs4x9v268/R9pBcvXHqBW+pdtUImNE=;
 b=aaSIGMie2rYoTkZ+FbhnW399KfRjzZXBPLqbAqH882PgterDZmRp2JhhtPZ3O0wN/+yjzj6vXlfdCIpc/POl6HjbW7upvgA17cdCxd9hw9EC3/W+AitzuU3Cf5shDEYMawARj1C00H/AUsucnaA5wzDqaSy50qbcWd4RIhk14ws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 04:04:48 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 04:04:48 +0000
Message-ID: <63d577c7-2c2e-4cd6-b5af-b2d10237793d@amd.com>
Date: Fri, 30 Aug 2024 14:04:38 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 03/21] pci: Define TEE-IO bit in PCIe device
 capabilities
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, kvm@vger.kernel.org
Cc: iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-4-aik@amd.com>
 <66d12cb51dc9b_31daf294e9@dwillia2-xfh.jf.intel.com.notmuch>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <66d12cb51dc9b_31daf294e9@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY8P282CA0013.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:29b::22) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4359:EE_
X-MS-Office365-Filtering-Correlation-Id: 13b4c34f-b5e9-4d32-e29b-08dcc8a8e38e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aW1uaXIrNThBRFduc1E2K2kwUzFKclBONzV2YTR2dmdOZTE4Mm05ZE1jdXdW?=
 =?utf-8?B?MUN3MWloU1JkZUdjaVIrVXJEK3huSDBtM3A4cStaZVU4ZklqU2dsUnhOTnV3?=
 =?utf-8?B?Ky8rNjRWOHcyUC9JS2xaRnFpMmZDbkJuY3FLN0VNdFcwVkR1N3laMElwSWpx?=
 =?utf-8?B?T3hDY2JzNTFGRGdVOHB6MzNEK3grWlVBU216OC9BWk81L3dRTCtJaFQvaG1a?=
 =?utf-8?B?T0RFTUQzeVJCN2NmZHkydWtPQ3JjK25hZmZ1QzBobndDZTBsVm1qc2lhSG9Y?=
 =?utf-8?B?UVg0R3k5UnBTRnh3QkZKT3o2YWU3WUtLVDF6UFo3OHYxZ294eG9oandZRWZq?=
 =?utf-8?B?clVzaSt0RVJVNjEwSmMyUlNwa1JrYkZOeGNVSmtvbXlDSEdJYzFYcHZHdFdT?=
 =?utf-8?B?Y0lKSmtwQmw4SnJ4MzdVdm9wTFdnRnQ4OStsU3ViQS9MdjB0bVlFb1IydStM?=
 =?utf-8?B?ZWVPTkp1TDRQYjAvOE4vSU5KQW9yQ1VIVXBJd1d2OVhmMjRSRHZnSXNFdnRK?=
 =?utf-8?B?NWRSeWp1eVFwOW1xaTc2cnREQ0QwMnFRNEZSUzUvaSt5V0dVZVdDYlIvTklI?=
 =?utf-8?B?VnhnUENHaXF0Y3pONlNQSDU5TWlVMzBMTGFGTWp2UVQxaFhFRW1UMmZoWEtZ?=
 =?utf-8?B?ZGh1czUxZzF4T0hDNzgwMlNHYU5iRnZIOUIzNHdRSE5CTFVNanpxazJ1Q01r?=
 =?utf-8?B?clhaZm85dldOMGlFVkxoTnRGd0I5Y0RLa0NQclhFMmE3NXl5YkdhVCt6TWNu?=
 =?utf-8?B?dUl3bW1XZUpyb3hndUgyYW54M3REdUYyalRxU2thdVVhLzI1T0QySHhUWkU1?=
 =?utf-8?B?Qk4yd3Q1TWgrQmpQcERoQ1VtcGRKZm5rMkY1Ky9sbHJzS0NJeHFiMjBENE9Z?=
 =?utf-8?B?QkthMUtlSVhZRWZOUlpzRUlmeFZ1My95M2IxZWdYSE1hNnpvL2JJeXVFUmtz?=
 =?utf-8?B?Um1ITnpLWkgveDdWN2o4SlhlNEhBTWJTaHFjYWlxb3FaSDh3anhacWFPbWRr?=
 =?utf-8?B?TkF0Z1dhWHVpNXVVRkRsL010ZTZYTTNqdFVaWGFCVDJoSEdxcmhORDVJSFZH?=
 =?utf-8?B?dmFTUzdoUTRRWnFjL20yMnZISmJPMHY4aUkrVnkramtjNzlYNzdPR0JNZUUy?=
 =?utf-8?B?UXdVdFlERlVia3BDZFRaTXJxcWVvUDJibU9TWG1QOGVXR2s1c1BzS0pHOGVZ?=
 =?utf-8?B?RisrWnRQL0tKR2I2SEV2ZEZmRGlyS3dOT1NzY2dEcjB1OGJCYUZ0TUxpbXJU?=
 =?utf-8?B?K2dyMktneTNtVUxLOEdRcnFwNWN6U2x6eFpacUpaTm9qQ0MwczVWeFZwdmRx?=
 =?utf-8?B?Zm1ybjFEeE15bzZ5SWpweHFFM21RV3JYMUtUcFZtSm5TNjQ3MitHdjhNUi94?=
 =?utf-8?B?Und3cG1aSCtwR01kVWkyZkxWZmdSb01HbEVPUm5Sbk9ZdjFBOXovL2FTN0tx?=
 =?utf-8?B?WjdYQnhTajdlT1RDK051clpnaFI5ZWRQekRvYmdScHJHQmpsY2JGemlpRUdE?=
 =?utf-8?B?SDhsZGUyaXpFQU9kV1pqTHd6eWtZWGdORmdZSGY0ZS8yVzdKZVRUQ3M2c1JF?=
 =?utf-8?B?bEM4M1Vrc2wxbTJ4TTgzZG5uczFoNDF0aWo0Z29PdHFPUnBvaGs1bDB6cG4x?=
 =?utf-8?B?VnVFZmh0TmdiMFk3Zk5zMExlMFcrcElPeEc1cTlFbVFrQlpQdHJiRHJFSWhz?=
 =?utf-8?B?cUF4TlplaHorY3VjRU0zNkVRcC9mVzJNejFCN2duT2tjZ2lkOUdqMEhsOCtH?=
 =?utf-8?B?L1hLN2ljeVpqTzEweXZvYjBwYm5lb2trYWdUQ0Y4K0h1eVpFTlBUbHZjMUFY?=
 =?utf-8?B?TUIzaVFmZS9YdjEwZG9RZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjJmYTNIVGtPYUttb3pJU3hkUnBtcHBhMnpMbTViay85YzJKaVYxdW04MUI0?=
 =?utf-8?B?K1VtdzBvRWdlanhYQVpVWVRxMndrRTlVT2Q0VlZ6VTRhdEN1VmpVOTZDTkFi?=
 =?utf-8?B?M0NVbjdzTUYrWkt4Z3FXZkNQQndHazl2KzBLSDBLbVd0NVIxbFhDYjlOWmhM?=
 =?utf-8?B?RURUSkcxT2tGR3Ztb21WeTdDNFBVOFdnVkhmYlkyMlpHUjVYbXhEWUFQU0dw?=
 =?utf-8?B?R1RzQnJaSWIxOTY0b3NOb0lmL2pNSFZoNzZhRVdCMm5LY3NZeFBRa3RRcWMv?=
 =?utf-8?B?SkF4VUQ2S2ZxUHVSYmlCeGtUZFNxVC9BZVduSjBBYkxIU08za3dERTU3OWl2?=
 =?utf-8?B?eW5DdGFjaENkYWNiK0FZTG8xdG80RjZNOWYwNUJDTitqb0I5djVwTGlvVnA3?=
 =?utf-8?B?S3hBdTJFMGlXU29zamxJay84WERJS3VuYUdsL3Q4QkFKM0daRUdjV1VqZC9u?=
 =?utf-8?B?U2FDcjlzTDRvcGFhUWk0alBJUHFsbnpncVBZNGNwemNQanREcDZ1SUJ0ckE5?=
 =?utf-8?B?UWlLdTdnTjQ2ck1DdkdIa0hRSFFmSzJkMS9pbFNrVVB2UnIrUnNadS9lYkM5?=
 =?utf-8?B?MU9rS1BSdnF3UDJzWVFrSFpEdjVRaXZDemVNM1Ezb05IK2o5Q0NUMEtUY0RF?=
 =?utf-8?B?WURPSTlUYW5JYmdFNUlNb3BmbjB4OTJ1aUl0V3NpcUYxUklSa041SGdHMmpJ?=
 =?utf-8?B?THRyeG10akhZOGN4bFRUdFAwRmdGOGMwbTRsNGcyVWgyMmQxQUU0SHJVU1dO?=
 =?utf-8?B?a2ZET0dNakVDRzJOVFBpRHBOSTFodFZGNVN0WCtEbERwK2taNTdnZWpna0w4?=
 =?utf-8?B?QkpJVGtJejdnb1dUNzNzOFF6VFhtaVRpR3ZReVZMdzZFdnE4b2w1NWJhK2ta?=
 =?utf-8?B?UitQQ25KSjlqUmFJN0lqOEwxVENpcHlha0IycmFVSW5OY0F6YzRDdlBpUytM?=
 =?utf-8?B?QTg5VGpDNXY5OWtJaDJtYnUxVWhad0dYSlZ2NFJPbFNIVTRmRm5rNDRZZmVu?=
 =?utf-8?B?akdVcEYxTnd2N1pGN0lkREhMWjJ5Z3V2VzFCMGFTKzdodnVveDRHeHpvR2M3?=
 =?utf-8?B?UUJ2R1d1MlpWcXRHMzQyM0F2ajArZS9yVmxkdGlEbEU4eHdsUUE1QkplVXVp?=
 =?utf-8?B?ek4zZ3c5aTh0NkJLTlFWYVN4blZ2VkoyMmVVdGFaMU9HMnRnOTkxZHgrWkl4?=
 =?utf-8?B?MFlZTUZCTytxdFR0dHNCY1JsQ1IrRlVrZ1ZYSlZNeDEvK0UrVkZQdGZSMGQ5?=
 =?utf-8?B?aVFINTNqQ3J4bmJLemVzOWJtVCs2NElkeHdFRG1tL01xcS9KM096YjN6U1hn?=
 =?utf-8?B?VFB2ajZLZWdKWDcwM3N1QUNLK3MwcnM0anBUcHN0ME5nME5LZW1DQzBDaytG?=
 =?utf-8?B?andleDhTUjU3dUZKMXA5Y2hSUWh3d1VqNmRDNGdQWUg0dXdmYkZmMDAyYTFm?=
 =?utf-8?B?SEtSc0xTZDFOb1lrSS9ITHkrdDZVU2JrSkNYNGFRVllQcmkwcmF4aExjM1Fa?=
 =?utf-8?B?bmVkT2I2TitGT3llWVl3Qi9oMVNsSHErZVN0aTVkUEVJTzJqM0FJUWRQelAx?=
 =?utf-8?B?MWp2KzZOMzBjbXdRR2pOL2ZsdWFKVWdDZ3lvRTZDZy8yZzVEanp2Qzl1dDIx?=
 =?utf-8?B?SlczOWxwd3NubXpVRllrV0R4RC91MjRlcDZWQmE3YUU0dmdlYlk2TE1LSmd6?=
 =?utf-8?B?MjBtOVB2YWRMalhUTDI2UUVTbWl4MS9rYVkvNG9MS1EraFRzQUpMMjBkcHZw?=
 =?utf-8?B?NEtKbFIyWmZFVUJENy9jd2Mwb3haZVVXYUFCckNqVHllVy85cHhDb3FNTnNO?=
 =?utf-8?B?K3FubWpnYVMrYkdqUXBoRURDcUlCbHZ2b2ZkZ3gzWnJqOW9jZy96UGQ5OGth?=
 =?utf-8?B?aThHMHFVWEphZFhXVEtGRHpaeXdmNnB4S21ER3R4c3RTVW0vS1lXQ3FaRUw5?=
 =?utf-8?B?Tjgwb25VakxYUDJwaW0zOVp4RFBQekN3NlRRenY2azV6K0R1OGh1cnRuVU1J?=
 =?utf-8?B?U200MDYvNGxmTDFzdzJXMXk5QXlBeHV2ZnQ4TDM0UTVHSGJHRjhVWGVmQnl1?=
 =?utf-8?B?SGliZ205ajVqRUYreWVMZ0phay9WeGs3WEt5eDJ3MXNLYkdzTHhNR2tqMnJW?=
 =?utf-8?Q?/eiXVAAKSnxyA60Bm+g+PgRU9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13b4c34f-b5e9-4d32-e29b-08dcc8a8e38e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 04:04:48.0528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjDDXj1vL+PWC0YkNJdJ6sfRIDf4YE/lrAKSePNV7AX+VAvn8vsn7Iwzm0QTsrBynFI/aSp9LgfpNjq8IhGFsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359



On 30/8/24 12:21, Dan Williams wrote:
> Alexey Kardashevskiy wrote:
>> A new bit #30 from the PCI Express Device Capabilities Register is defined
>> in PCIe 6.1 as "TEE Device Interface Security Protocol (TDISP)".
>>
>> Define the macro.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   include/uapi/linux/pci_regs.h | 1 +
>>   1 file changed, 1 insertion(+)
> 
> Not sure this is justified as a standalone patch, lets fold it in with
> its user.

not sure either but this one is already defined in the PCIe spec for 
some time and lspci knows it but it is going quite some time before "its 
user" makes it to the upstream linux.


-- 
Alexey


