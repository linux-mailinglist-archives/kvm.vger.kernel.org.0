Return-Path: <kvm+bounces-25115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B808595FF0B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 04:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAAE31C21932
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 02:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAB791401C;
	Tue, 27 Aug 2024 02:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lWReZazp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23438C8FE;
	Tue, 27 Aug 2024 02:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724725674; cv=fail; b=e3pIdTqwnTDiKGdTTX6ryf6NPrBF2e/O3lAeBBQSlVARWWaXfAZTj10djgYv2Sn18z9aJJiM6uPJhKDnuLMybf80rfndsealPr5x/1Z7GDhsX5yL84ke6PG1jOxzMe1FzVCq2UpZWLUMZOwGJom7E+l7keiVNQd/e6ljPZgW6ME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724725674; c=relaxed/simple;
	bh=VGW1eycIR5sz0olJiySnYN+NjSOOMQmA/mdo7Jc3Zn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LZUSMhNAg1kAcL8XRdkKP+0aotqjqrgq3mSJyT3sg6dS3DqZSTesDRGlQ0x3UppQlx+LWq8aqk/vWQL/5uVZ/44oIKQzGPT1MKC8PUs4zKbbmizFTpfwijlKcNoDYx8lywb+9QpLSAcJ5KZ64i0FVuF70+dF8cceHaRZPuKL+V8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lWReZazp; arc=fail smtp.client-ip=40.107.100.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4R62nCIisZaAAtBUJN0FRgReh8eVKiLhWlmmpxklxC9WOIAzeKmb2KawW4O5nfDBddI5h3/G+kbdDMRBblLzIuOGhGKlolbc1UNHEpnJYwatXj1BUrY26Ix5I2R4oiQRHzzDgru8I71k5oY+T7atC5AadShJwU1hPghkEgqqRe5+97y9TftdFqVoa0lOi4609HqahX/i+RCsSkLeyHz2jsZe2hJREyYcMPS9DTssNDev4kHNztSgARUaxHIswgRFI+/05IKH9bXfDAPAIlAAhKlLvt29EBzwnsjOB3m9IhX4PPkd63MuWb4A7u+JByQLMDvrWU3rGVexoOtLFkvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MudohPZ+p6HlIansA6QHhJLapzsqJwZl1wXCbKbxqhk=;
 b=yFbs4NyLOVIKOsiYBryWMJ49mNC/xR37YPuryerGG2fK3ZLBKJFhPt6AsIn0rDa2gpxMmdSnUxV+jdaDO5apefJFWkh5+fAL+7wuBkIkQG6bpNHjyeLKrALc6PfWXx1LJYqvlLHpcwjRJallm2S9BJ1Ka/jxGauDC6NqyFUYFpz5AMVSll+oR3WWn7kfAc8GJjaWq8kV/TyKTFK+WVGp7zKoio9I+VVRuPfkEOiG82oz3ZGbGtoqXuVljk6QazVpTqm98oCPHl6xfAKzBInMz9B7JWbXXivZ/5saLTXTGFEP9RiOMz2LU2hB7spMP9EbqHLz67eP4FJoyug+ijPz4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MudohPZ+p6HlIansA6QHhJLapzsqJwZl1wXCbKbxqhk=;
 b=lWReZazphAal8wPwIJaX64RtxHqRu+WjqD0r3KBxswTMWhujxcaZyKH8qEl7bs+YG8nknCYfhEDjmzPcmudFR3nzDonWcHwXp5ArmfaF5oMp+MMox+FyLhhIQfH8W0caTT/MAroB0h1Vhl4oy8FrLskT+mL4FZ/qbpOgR3n7QdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN6PR12MB8516.namprd12.prod.outlook.com (2603:10b6:208:46f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 02:27:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 02:27:48 +0000
Message-ID: <477f3f50-0015-46ea-96c7-dae0971f9fc6@amd.com>
Date: Tue, 27 Aug 2024 12:27:37 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
 "michael.day@amd.com" <michael.day@amd.com>,
 "david.kaplan@amd.com" <david.kaplan@amd.com>,
 "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>,
 Jason Gunthorpe <jgg@nvidia.com>, "david@redhat.com" <david@redhat.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0120.ausprd01.prod.outlook.com
 (2603:10c6:10:1b8::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN6PR12MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ba5a736-aaac-4dcc-f033-08dcc63fd7e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UEdjMjNEdWRhTXg0bmttRGlTNUtJa2wyeWF6K29JS3VaRlJkV1BRMEhrTkNh?=
 =?utf-8?B?eWFWZDFmRmUveWV3cDhyMjZMcy9ZZEg1WHFaQXpFWWtGd0lvTnhFMFdzTk9w?=
 =?utf-8?B?cm1GV3EveHI5ZXJsOFdSdEtGK0xkdFR5Y1pyZTZOU3dMWE4xSXorZmwxMy9J?=
 =?utf-8?B?aEtic1liMTR6ZUlLK0tHS1M5QkVFT3NWSFJydU9qbk5aY0NwQjlpalZkMlVu?=
 =?utf-8?B?NEVSSlYzTUQ3d1h0TEY5c0UvdnlVTHpKb3RpVzk1NnpTekVkeW1iSmdabXo0?=
 =?utf-8?B?VWJCcUtpVkZBVnJMM1NwRE4xQVpSdzRFUkxaS3FNWmM4SVQvZjg2YnFPQzVU?=
 =?utf-8?B?SDNrcFJTNDkxdU9UZ3RrUGlqc2dua3ZTZ1o5TjdOakhrQlZBNGZzRVJITFk1?=
 =?utf-8?B?ZU13RDdlNnRqUHluQ3ZZSElNQU45ZldtVWFudGd2ZDlvTGJ2RHNsZTRiWXc4?=
 =?utf-8?B?U20vRUd1ZUtjTUhyb0Jhb2xIeUlWdTNGaEVVY0l0OElDcEJQN3FoUUlVZ0ZF?=
 =?utf-8?B?UzRkSVRYQnV0WHcrMnJrT3RwWkl3SFUwL2FRZ2V1a3BtRlhrc3NPTnBWUmRQ?=
 =?utf-8?B?eGJINkx6bUdmaGZzcG91Z0cxVEYyMmQyYlpGWmJhd2tNaGdzZ1J3VlBlVElU?=
 =?utf-8?B?VkNsZ01xZksrSTAxbjN0MHFLb2pvN0taVkp5UmhQd3ZQckoySXE1R1M2RVpY?=
 =?utf-8?B?eVJTZWprODNjazlUY1NSNTMwUGUzeXhBTE56SWYwZ0V1NVA2VkVzd1h3c0Rm?=
 =?utf-8?B?TyttWG5sa2hNc3RYaTZLWEpXNjZKaFZYMFkzV1hxQUxpd29OTDZtdTh6bTd3?=
 =?utf-8?B?Q2dybTBwMVhtemJWR0JCZnBWNDUxUWhrYkVVSmkxaHhieEFjODA4a1h1SEdW?=
 =?utf-8?B?YUNxZVkyQUpvbjV5MmRsV2swalVaWmxHbDVvc3ZVQW1YcFdseXJoM2dXSjM5?=
 =?utf-8?B?TDEydFFYUy9WZ01lRjlMYzljY3ZIbGdSZTRSd2Y1ZjlDOWNsODFnUlFES0RL?=
 =?utf-8?B?QTM5T1JNYThEUVRpTFRHS0tFcFZkTTEySDNqeC9YM0xUb0RweDNZTmIyR2Qv?=
 =?utf-8?B?Zy9Yd0p2cmJZbWVkRmgwV2xBZytBMXBvdHFFTmp0M2drdUNCMUxGSFdmUjFI?=
 =?utf-8?B?VjFONkRLUS9FbHJ1N0R3REhkR1hVNXlJZER3VVJpMy9QVXp5SDU1ZG9kbnNV?=
 =?utf-8?B?ZWNyZy9SNHRMZ1BQeVBsN3dwRG1YOGphNlIrN0NaY3VnTVpYOUlUQlNSSlUz?=
 =?utf-8?B?QVBBT2pXL3pGNXRYUXhhRHk5NUUwWEJmRlR4WXUzRDc1Y2twM3RqMXpSenRs?=
 =?utf-8?B?Qmh5NzB4ZlVMNERneFJsWjgveDhDRFhxYTZHV3JJMURyRHlWN1I0em15VkVD?=
 =?utf-8?B?cHQ5UkVCWHU0b3h4b0tWSWhXTjdtT1lDeGNwdVNlbGVjOCs5U2JZbEl1L2wz?=
 =?utf-8?B?Ujc1MDhhVGp4OHRiVDE4VFJPL3p2MDZNdXI4Q1ZUcHpFcGZ1SUUzcWZ1NDZm?=
 =?utf-8?B?K3FmRkpPSC9KdmxoOTMvK3dVNEROM1ROUnpBNEZSMk9CekZmNGpLeWpoRHZT?=
 =?utf-8?B?WTU4SXVZT1pTWnZQMGF1cHpxblhpVlEvdlpZV1BMT1RKeXNwalJtenlCdVFl?=
 =?utf-8?B?bG0vRnNnbGFjRE1LSUhVa2xTa21xTFF5L1ZmeWgrbmFGMDR1VE9mUFdMc25X?=
 =?utf-8?B?WGw2dWJRUHJTTTF0aG5wejVOWWRZWWJidm5UVWxxWHpuMFdXR1ZBaENZU21r?=
 =?utf-8?B?ekd3cUxnUnhFY2s1NGJQYm9sR1duL0lNWWhSNlpTMTV6MmkwVVVQOThETzNG?=
 =?utf-8?B?ak9aU2NtdWhTeTkyZHRyZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGRWTmFsK0NqMEt2OHFISDBmeDRkeEFlSk5zRWdDVkxvTWd2d2QzZkNURzRS?=
 =?utf-8?B?RkZEaXNxNmRhZ1BFQTRIMlc1TVVnRW9iOE9xeWF4U0RtbFh2REtWREN5VXpo?=
 =?utf-8?B?NkN3RStCWHFWSHNGazVJenU4WkJIMmJuSXRTM2VWakplTE1hWk5ISmZXVUNU?=
 =?utf-8?B?YXJDQU5HVEszaXlTR1ovQzhqalRNMTVvOGFsVlZzQlQvMlh6blNlZFVVM2hV?=
 =?utf-8?B?dis2YXNXd2JTcFMyQkFuMUZaMFBTWTZGYkM4Q0d6ZU1panVjY1YrenVPSzlV?=
 =?utf-8?B?TFhhcHBrbHd4Q3dqcGJEZit3VmtvWENJYjFaWllma2trQlh6YXNCdW9NSldn?=
 =?utf-8?B?ZlkyYUYzQWV5dDR5OGtySGV0dlJxZ3h2UWVLVTd3SENnbDdaWXlUZy9mUUcz?=
 =?utf-8?B?L0cxT3hGR1A5TFlXQ0xoMS9UNFNCUGZRV2Rpd0NWd2R6UXIvaklLa0pFa3RO?=
 =?utf-8?B?aUl4U1BJdmswd3dHVlJKK2VHRmdoMHBiTXlDdG9qQ25jbGFpaUhuSU4vR0VG?=
 =?utf-8?B?RnBXekY2Sm41N3hGd2RvYjM4ZzdnNTNpZGFZcUtNYWNpNnRFeWtZSTBFR203?=
 =?utf-8?B?RitrVDdLR1JkVjBsZ0VOT0lKemRaWUdHaUxEeUwwOFRBQlZRc1k5eURHcXNa?=
 =?utf-8?B?TFZsL09EdDVhZTkzQmx1TVUwdEE4WndDZkhoM1ljRXl5T0htaTZodDZXREd1?=
 =?utf-8?B?aUdobDlTY1hNRzZwVGJqckxMQXdROGRnU3JZK05SdE1LOGZZeTA4dzFQYW1y?=
 =?utf-8?B?RlF0YWwzWEtMK25MdzJUdGZrZmNuVHUzT0RsV1B6eTdDa3VSRmQwU3d5c2h0?=
 =?utf-8?B?amtKamlHSm5zYVdFR1VDQ0FrdVVONVBURjdPekhrd08zOVRqWmZjTmY3Ty9j?=
 =?utf-8?B?dDk3S3pmbXBxSFRQNWlGWlJsalp0QWhwdlpJWGMrZnlWVENibFJzVENiNkl4?=
 =?utf-8?B?Q3pmTWNIT3l6T3IxU1kzeEZjQytnaHFaaUJLL1VIS05jYlQ0cFRkUmk1b1Zz?=
 =?utf-8?B?VDV5YVpPTDVSZEdJNWJRRkc5WHRxTDNEWURRdW1lWE1JMWViUkdIRWx0YkNP?=
 =?utf-8?B?aU51S05yN1l2UTM3dGgrY0h1Z0NORGpldS9GQWVwWUxNQnY2aEtUNTVmb2Vz?=
 =?utf-8?B?ai9qSTVDOHMvSFdyb3BadnMxUmtiQ0hsbVJOTjlOdFBXVUxjbVg2NTF6RHBQ?=
 =?utf-8?B?empZUlNvM1dFeFRSMEc3OW80T24wZFZpMjJaS2RKNHdyVmxlZHVEV1F0YXdP?=
 =?utf-8?B?VkpUVGZka1ZPSTFvQTM0Wmg5K2kzZUQyVityNjNvcXkyM0xIa3o0Qjdrby9I?=
 =?utf-8?B?K3JCL0NBbitOMzBoNFlRWHpWa0wyejZBZ1B3WEd6cUNaanljQ3hSSGV5MXZL?=
 =?utf-8?B?Rk92aXBGdm5sc3l5UTVFcHF5OFlZTlVoRkRVcnFFak5XVFRERDdoazNvTWQ0?=
 =?utf-8?B?bC9ZK2owbVdRQ0lXZnFzQzUyVGJncEFFdnZmc293UUxMYjlsWGc0NmlxTzJr?=
 =?utf-8?B?Tk01NFZxWERrNEZFdEovdk1GMk12SHp1THZ4T0FNTWphNlpLTHpHTHhUcjVw?=
 =?utf-8?B?U2FzeEt6ajF1a00rTkNtZHBaNHhneXB6QUZuekE4WTVIL2xVS2JsSTVUd0hw?=
 =?utf-8?B?ZHczOEdFYWxEVTcwSTBjMmNLb0ZmYmFCQUF1c0FTQ2U4VTZWdUdtcnNnSGdo?=
 =?utf-8?B?U1VuUUo2YjBOTXhJRXA0V1luQU5Ld3drSit2T0o0NFYvVGZ2Z1RHL1lkanBs?=
 =?utf-8?B?V0V5QUNVWGo1cFRkSkY5aXRJWTNkZnhPVitObGp0K2tRdGlrT2NoZk5sVTNz?=
 =?utf-8?B?TFFCbVBwT0RabG5ZczQxQnFSbTY1NTEzWis1ZHVBM25XT2MrbGU5RTF0cFRa?=
 =?utf-8?B?bmFZQTRUbUc0eDFKZTV4OGEvM2JKdTNYb1lxYWtGZGFQaUlHOHF2ak5MbHRr?=
 =?utf-8?B?T1FBS1V2RDZXd3Q1YmdYajlEMjZPQ0tBVTR3U21namJKQ2s5SXBmZWpxYUZS?=
 =?utf-8?B?cHoyME0vRjhvT3FvVlVrTXphTFl5dWM2aG9LdW03cm03ZDhzTlRnenJ0alJ0?=
 =?utf-8?B?dnZ3MTVQdEtVZ1BUd1VpemNqM0dUV3ZRblVFbXRWcGE4UlBnZ1BEeENUUTI0?=
 =?utf-8?Q?8dLQAIhznQuIPa8WP1v/oLOrI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba5a736-aaac-4dcc-f033-08dcc63fd7e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 02:27:48.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Znq+8ZbQg/svzqjh+u+QQ2p+ECtpsG2lwAEinRnuz5Z4De7vd6qfs9yOnN6lY3aiB1f2MpkWB6UMBQ8SkChq6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8516



On 26/8/24 18:39, Tian, Kevin wrote:
> +Jason/David
> 
>> From: Alexey Kardashevskiy <aik@amd.com>
>> Sent: Friday, August 23, 2024 9:21 PM
>>
>> IOMMUFD calls get_user_pages() for every mapping which will allocate
>> shared memory instead of using private memory managed by the KVM and
>> MEMFD.
>>
>> Add support for IOMMUFD fd to the VFIO KVM device's KVM_DEV_VFIO_FILE
>> API
>> similar to already existing VFIO device and VFIO group fds.
>> This addition registers the KVM in IOMMUFD with a callback to get a pfn
>> for guest private memory for mapping it later in the IOMMU.
>> No callback for free as it is generic folio_put() for now.
>>
>> The aforementioned callback uses uptr to calculate the offset into
>> the KVM memory slot and find private backing pfn, copies
>> kvm_gmem_get_pfn() pretty much.
>>
>> This relies on private pages to be pinned beforehand.
>>
> 
> There was a related discussion [1] which leans toward the conclusion

Forgot [1]?

> that the IOMMU page table for private memory will be managed by
> the secure world i.e. the KVM path.
> 
> Obviously the work here confirms that it doesn't hold for SEV-TIO
> which still expects the host to manage the IOMMU page table.
> 
> btw going down this path it's clearer to extend the MAP_DMA
> uAPI to accept {gmemfd, offset} than adding a callback to KVM.

Thanks for the comment, makes sense, this should make the interface 
cleaner. It was just a bit messy (but doable nevertheless) at the time 
to push this new mapping flag/type all the way down to pfn_reader_user_pin:

iommufd_ioas_map -> iopt_map_user_pages -> iopt_map_pages -> 
iopt_fill_domains_pages -> iopt_area_fill_domains -> pfn_reader_first -> 
pfn_reader_next -> pfn_reader_fill_span -> pfn_reader_user_pin


Thanks,

-- 
Alexey


