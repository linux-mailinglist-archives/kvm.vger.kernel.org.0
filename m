Return-Path: <kvm+bounces-25645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A42B2967DC6
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 04:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25B071F22475
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 02:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FF92C182;
	Mon,  2 Sep 2024 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L2AF+Qpb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97423125DB;
	Mon,  2 Sep 2024 02:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725243791; cv=fail; b=u8lAEfwEiEjuRXBQTvcRrJfDK9nZdK2JohksK/DAZvoTZGd4CMJZLug+BR3o6xsxbqblXYv6gHC9ypXyat+enibuxMlEA7aMh3eQ5w+4pxXPOYeHUTDayvxsGTc9tv2ylWapeDuM7OtRHXMiseJr1w0I0dXLXa9GvdfKBPKODVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725243791; c=relaxed/simple;
	bh=Qi3axy08O8fxYEg/maYwSroNK1ptOk+BbJaOLFd70/w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q6TzOcBluyTYjirQomfMMriHIbWI4dmlHJguboCj0droZNfgVoAGaFt8rVxcyJcd7eMNTRA0MducpdgkBQUa59iNg060ZEvpN7mgQuo0uOGaRyCFb3KlukHovHsJIkcMAmbL4fFJ0UDMKjN1TEUbaPki3Rc96tp0pLz1xx1hcVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L2AF+Qpb; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8ZoGJFQmcMx9jA/WAwDaO0pxF+WytTF17T8fKdsulpY6IpaWepbA6tcjn84bd258PV0fdRFR4xWXJgBLHWNPxyKNfiOll5tSdZSyb7T/NTrl59kc6cCRhxTIt0gvZC4mzU7LBf6qGtKjgEKNrfRUiJfRRy+aPpaSgVQFNfln1zmv5CGpP6QqUqccIaUYDdWsDOYttF78UfTD61TBQWlDEWBSQpb+TYNGbRd/CRuXNjeoGR/W/o+WqQPmIrNN1ah1+3/7AM4Uo83Xuv4pc/xQPgySYK3YGKBiySidSroonhJD9+KnHpPiFyrBawCxyjchTjB0T2sgJH2mTBmIiIESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2q0D34oZl5VkvQi5fbUU6rwUiJpmo0ncLQAHi9NvbsE=;
 b=a0AUIT9e2Wk4QuL0x34H5xrIqPU8WypMWMNELkqGuYaPCPdO1dg06inMhjvmBbOaEuXGlSERQ9vupsWr/tCoJu9ycFb9wafUJaIQ86f/skWhwXQq4iRisb5Zhoi/JRAuwxWWEn1vAmacccQdLRMIibYPQ8JO60coRSaj7X7tJnkxWfKcFvszBq3pD+7gQzWj0Hsl/BFfnrLudzKTrbV7Hjrz4kbnwQRlxHTKuRI165Jdg7+xrK8er6A0a+eP8CuyehKJcKOsmFQ1iksjXJUxaC17HUb03hbGOzn0/HXvvFOCqNBIUYomNpn2vqKUFBtk+btlsT48swnPHjzxGI887A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2q0D34oZl5VkvQi5fbUU6rwUiJpmo0ncLQAHi9NvbsE=;
 b=L2AF+QpbqVkyWxOO6xY9rtrKYSUDW51cfL+HncG0E1R8yJTOqLYTn/cOrG/RFJc62CzSD3ngsVBvWTn528MSBYbtOR1wIngVAc3N8LQ2sHbOy+xzCPALrX2zYTJyhfRtTPfw9enxEyBdUk3n6jh6kXQIpMKqLa0/5nwC4q6V5OI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB9223.namprd12.prod.outlook.com (2603:10b6:510:2f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 2 Sep
 2024 02:23:06 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%6]) with mapi id 15.20.7918.024; Mon, 2 Sep 2024
 02:23:05 +0000
Message-ID: <49226b61-e7d3-477f-980b-30567eb4d069@amd.com>
Date: Mon, 2 Sep 2024 12:22:56 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH 13/21] KVM: X86: Handle private MMIO as shared
Content-Language: en-US
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-coco@lists.linux.dev,
 linux-pci@vger.kernel.org,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Dan Williams <dan.j.williams@intel.com>, pratikrajesh.sampat@amd.com,
 michael.day@amd.com, david.kaplan@amd.com, dhaval.giani@amd.com,
 Santosh Shukla <santosh.shukla@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>,
 Alexander Graf <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>,
 Vasant Hegde <vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-14-aik@amd.com>
 <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <ZtH55q0Ho1DLm5ka@yilunxu-OptiPlex-7050>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0027.ausprd01.prod.outlook.com
 (2603:10c6:10:e::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB9223:EE_
X-MS-Office365-Filtering-Correlation-Id: 941fee20-9d68-4418-cc52-08dccaf62d56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UTAwQ3Zna1kzUGRpdCtBRmdMUGJQTFlaMHVNOUNvSkQ4S21UVk9NOHVZcmJZ?=
 =?utf-8?B?VVZVOWhpRkpzSEdNaTRPZURqMXIvc0s2RjRuQ1B5VWY4MklnMGx6Ung4eEdk?=
 =?utf-8?B?RDVIemdkVnlML2lMNWQvb1ViSUY3eEtrcGxNQ0poUVlEVUp3NjgwVHRBa0Jt?=
 =?utf-8?B?Rmp1SFVNMnZxalQ2Vmovd1dBRURJSjVOV1VsdUZtYmpuMXY2TjR4Z0gvc1B5?=
 =?utf-8?B?TVFVb0ppdXkxK05PQm80QzJ6eWJXVFhuWkdiUGU5N1FDd0xOdkEvc0dBWlJV?=
 =?utf-8?B?U0hvRHRFTGZHV1E3UEp1QkdpRzhGLytEc3hYY05KM2N4Wm5ITms3RWdCekMy?=
 =?utf-8?B?NDBqV2EvRE1scHo1TEN1UW5xc3FPNVlFd3dQSFRXOThXNXRrcytGZ2k1YVhG?=
 =?utf-8?B?TFUyU25EOGNhQk5aeUl0d2lOL2lOSTlSLzNNOU40L3ZsVlhHL2NuSXhYQngr?=
 =?utf-8?B?SlVXYmtNQTlQb0RtMWxIRXVOTE5IZHFDWG54ckFMKzUwYWZoMGZGOXZBdWpF?=
 =?utf-8?B?QVU5bXg0d29nTTljWHNWTDJqejY1UytJSDFweXJEcCsvTDRCcTI1eXZNM1p4?=
 =?utf-8?B?Ky9ITzRDNlVRTHUwSmg5QVBJQnIvNW95MU9CSUlXcGp4dm5SNnpXRjlGZ3lu?=
 =?utf-8?B?SGY5Z3c1YVRBRjkrS0VKeXRlM2FJMUpTTDRCcXdmVEF2MnVwTjBzQUkvVlpD?=
 =?utf-8?B?RGNiSG9sdE5ETVpKbzBsTXFXK255SlcwaVpyZmZRcTB2NlltVzdkRmxzVXlW?=
 =?utf-8?B?Vlg0VWkxLzVETE1IblFkbTQ0SGMySXAvZmhiVzE5OEpsZE4vTTE3ZE9zcDlU?=
 =?utf-8?B?eFZtWlJscFBscThtdjFiN3pCcm8xZjluVkIxZzVIeFdjYmJPOFFBNHJva1Nt?=
 =?utf-8?B?RytRNERuQ2NKSGI3SkZlWE1qMXFJT2dRRFJYVlVwL1V4ZGtrYnNWbTE1T2tm?=
 =?utf-8?B?cFdYN0tMOFlMelBVOFNOY2FFMGg4VEszR0k2WUUwdks0UGxhYm1veTFXenRJ?=
 =?utf-8?B?TG0vY1JGeDFORkE4MHVUSkdNbGNlcENpanUydnhVZkFwa25BWHZHSmVhb3FM?=
 =?utf-8?B?L1VHZWJ0cXgwZlFJcVREbml6QUl2S0E5cy9tOTBKYVlDM3cvU0h1SE1wK3A5?=
 =?utf-8?B?NzhTa3VvWDltZTQ2aWNGQXZPNnRoS1hKak5DMnN4aUJCSitoUkdWbThrVS8y?=
 =?utf-8?B?ZkdiSjcwQ2d4Q3pkTVVzbDBadUlLRzYrV1ROaVhnbmRMbitkalNyMUxxdEU0?=
 =?utf-8?B?b0NPb1djL1cyN0p3aTFHZGN5SitOOCtjVXYzQjJKWFRSbkdKbmZ2b0RybDlP?=
 =?utf-8?B?a1lHUVhQR3NoZ0FlQUlLeUlOeHFqZVRsUXlCZ2Q5alpORlEyVTZXZitsNDhu?=
 =?utf-8?B?TDlUTGp5R05oUTNQWnJCM3hpc05nMllWcVVVNGRRSUEwNlE0cUJZSzc5K0dj?=
 =?utf-8?B?SGdHSDlTZlVoaXNnbjFucHJkQWFFNXFMb21DQTVMNXNNYjVRdFdpaUN1TnRu?=
 =?utf-8?B?Qm14dVZvZ3NVNWhjVHBjdnA1WGpTNlVyQjZRbmw5STBtejBFYWYwWDY0SlZT?=
 =?utf-8?B?aFhkQW5sVTBmQkdRQ2lIRFFKbzBoZkNMRkRBYUk1TEx5YlFIOWRaY3VQdXhW?=
 =?utf-8?B?R1YyWUVWZ3Y4U0kzT3c2TGM5NDRvWXQyUHp1UjNmaGlaczlHbFNPdmN5TVRE?=
 =?utf-8?B?N2s5Zm40QUVXQjZmTUhRWmcwUFcweks5K2UyMVhEUVlRVUpDaWZvemk2R09F?=
 =?utf-8?B?bjRNMGRJTzRESmlTUzdtNUFLL2k1V29yVjFVQVRQUzJlK3Z4K055OHpqKzR0?=
 =?utf-8?B?M2RMejYycEhhckZVZEJYZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWo4SG9WRGgveThXbENvcjVGRHFlVEEvSXR4dE5sQ1lodVROMmZiS3FwUzZB?=
 =?utf-8?B?YWRTYUNRRk9QZm84aWR0cFBIa1hmbCtPaHVmNElwNElQQnFoS0JYUUxaYUNR?=
 =?utf-8?B?RmorcmRUbFoyYXc5RjdrQ2hwb1h5VjAvM0NWSEJ2M1FRUkRicjRlTGZaMlhF?=
 =?utf-8?B?VHRIZ28rUEhYblhyam9UWjBZVDc0MzNTZ1VlZ2NRcWpKSWNUdEZxWU1QQVhz?=
 =?utf-8?B?NHVDK0xnYUtiYzZ0dXJTVW5vTHU0WTBqR2MvRTJkMFBGWm9KSG5veGNyWFIr?=
 =?utf-8?B?NlpxaXVtOXZIcE9xT0xLcDlScUZNT24zUnNoa3hveU1nczdTdUU1Q3hndzVu?=
 =?utf-8?B?VlFDQTFTOUdRbUYya05Ebm0rRzlMcHZHTGdoYmVKSEg4VFZEMmZNOHVNYjRy?=
 =?utf-8?B?S1Q3RWNFYWVhWk1SR21EdmlmenBNQUM1aGpTaHFZc0dGeFMxbEs0MG4rOGNM?=
 =?utf-8?B?UzBFQmFLZndOTHJ4MHVKQVBDK1ZVZnZ1WmZERUtHWUJLdlV6T2d1ekJNb1RN?=
 =?utf-8?B?YlozYlVHK1N3STY1UVpWU0VLeXJmMUlUcEdISlRTczZFcC9TeHJCQnBMNDZU?=
 =?utf-8?B?REppN0lGZnRsQVZTdjMvaVhPN1pSaWZVTFlFQ3BUTzhiSEV4ZlhQOGhzYzl0?=
 =?utf-8?B?VnhhWlh0SXRLTnBFN3k1ejdKTmR2RmhiRkhSL05uNHlrTXVCdmxkSjM0ME9k?=
 =?utf-8?B?TFRSWXNIaklrdFlHQzJNODJxeEJ6aDZxRjJLMnNNem54WlcvVGVlaHVBWDNr?=
 =?utf-8?B?U2NMVzlCanRtSGo3MmNhd0FLeXZSOVdDeXJvZ0xXalZ5cVlrOGU1RlVuQ2RF?=
 =?utf-8?B?eUVXVG9RamIxZDBLNHV2cEFwOGRTSzJuajdJYUNmdE9XYzhac09DVHFNQlFp?=
 =?utf-8?B?b0JjRFdOZU5WSVk5VXE5Q1k1aDJwUncvaklYWVdPbGNKbWZPSytpQWVXOG9T?=
 =?utf-8?B?bzBXVXp0alZKemk3dDBFZ29aVWRjYmhWYmVqS29CdEl0QmplT1oyZlNmS25n?=
 =?utf-8?B?eHhUVW9QUU9Remtra3oyNkc2ZVpNYno0YnVJSjRFM0UwUFBPYnFTZGVvd1Fl?=
 =?utf-8?B?enYydS9QNHBuMFoyYUVHT01UWnhId3hxQkVuL1NBZEx6djMxcmRFWWRXVHp4?=
 =?utf-8?B?NEpIdTZ3TjNTT3hTQ3NEdWJmS3NMY2VXREMvYTA1eWNpNmNmRUVlZXdEaGxP?=
 =?utf-8?B?eElvMnliMDBBZkVxSG1tZzdJd3pNbjBVbzJoS21vZlhqUzBSbGQ5bEwrOWJM?=
 =?utf-8?B?azh1alJHWEFTZFh3RHB0U09DODVVYVU2dTQ0a2NyTXRsUWRvWm5xRkwrWTJC?=
 =?utf-8?B?SkhJUVpKYjFYZDIzZGNsN3QrZ05GWHBVYUZlMUZsU1NHN0VZYkI3T3krZE1w?=
 =?utf-8?B?TzYzYUxrQ1Rnc3NGRmt1UWwzZ00xVmhZVzFJZnB6cUlmeVU0VHhoUXdpOU55?=
 =?utf-8?B?VXk4S3ZmejducGRKM0dLOU1VMkY3aFNFZmFCOTNZMzF6YVQ2QzRxdE5LbUwx?=
 =?utf-8?B?K0czNnNZRUlBTExKUU5jZjhOTjMzM2xUVDdmUmliR0FPN1kzMncreWJINnUr?=
 =?utf-8?B?ZnVPN3BCWlVSNjM4cjUxN2U2NEFJV0p4V0I1Qno4WmVqQVZ1Z1prdlNXbCtl?=
 =?utf-8?B?TDFhdUVNWEdzdGp4SGNKb3N4L0l3dFZ1ZUhVdHFnYTBrajFCQWpNVnpwY2w4?=
 =?utf-8?B?MmJGR0I1OXJ2b2FjSUJEeEozTGg4TmludzhpSnduUlhUakJoUzlGSi9LTy95?=
 =?utf-8?B?OFpCNGs2Z3VEZmdsWFFyVUF1cUFjSGZSd29Wa0QvMzgxdWwvWjVKZVRnUUlB?=
 =?utf-8?B?RTZqanNtaWdaN1VhSDhoYkNBVFc4TnFPamNHTDIxMENzeDdXL0lMMTR0VTY2?=
 =?utf-8?B?dUhVWlpVYmpETHhDNm8yRDdiNHlMU0NDL3F2eFdHYXZnRklpbnBUWTBLaUY3?=
 =?utf-8?B?am5hU1pmVEZEMUJtYlFLenE5YzRTNDArbUpvelJFMGpVc0VDVVhwek4za3JR?=
 =?utf-8?B?eXFBL1J3djlnRFNJT1hURHJlUStINTJXRTk1eU9wK2l1d0VXU1FEazhWK3ZV?=
 =?utf-8?B?UVh2RjNCcVBRTkozVDdkcVlGWmJkczQxcFpqUk1tLzgvTG1QVGp2a3ZwdmlH?=
 =?utf-8?Q?LV9cJ1gudGjxzqXONi+Xw+w5n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941fee20-9d68-4418-cc52-08dccaf62d56
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 02:23:05.4130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X6nb3Fc2I1nFlD3zKOxeOJUwuE/zGUT6pmN/CBlbx8ghW/Q0twmNFV24Ya5nPEpPhaaX8YYxyWYBH5/goniDJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9223



On 31/8/24 02:57, Xu Yilun wrote:
> On Fri, Aug 23, 2024 at 11:21:27PM +1000, Alexey Kardashevskiy wrote:
>> Currently private MMIO nested page faults are not expected so when such
>> fault occurs, KVM tries moving the faulted page from private to shared
>> which is not going to work as private MMIO is not backed by memfd.
>>
>> Handle private MMIO as shared: skip page state change and memfd
> 
> This means host keeps the mapping for private MMIO, which is different
> from private memory. Not sure if it is expected, and I want to get
> some directions here.

There is no other translation table on AMD though, the same NPT. The 
security is enforced by the RMP table. A device says "bar#x is private" 
so the host + firmware ensure the each corresponding RMP entry is 
"assigned" + "validated" and has a correct IDE stream ID and ASID, and 
the VM's kernel maps it with the Cbit set.

>  From HW perspective, private MMIO is not intended to be accessed by
> host, but the consequence may varies. According to TDISP spec 11.2,
> my understanding is private device (known as TDI) should reject the
> TLP and transition to TDISP ERROR state. But no further error
> reporting or logging is mandated. So the impact to the host system
> is specific to each device. In my test environment, an AER
> NonFatalErr is reported and nothing more, much better than host
> accessing private memory.

afair I get an non-fatal RMP fault so the device does not even notice.

> On SW side, my concern is how to deal with mmu_notifier. In theory, if
> we get pfn from hva we should follow the userspace mapping change. But
> that makes no sense. Especially for TDX TEE-IO, private MMIO mapping
> in SEPT cannot be changed or invalidated as long as TDI is running.

> Another concern may be specific for TDX TEE-IO. Allowing both userspace
> mapping and SEPT mapping may be safe for private MMIO, but on
> KVM_SET_USER_MEMORY_REGION2,  KVM cannot actually tell if a userspace
> addr is really for private MMIO. I.e. user could provide shared memory
> addr to KVM but declare it is for private MMIO. The shared memory then
> could be mapped in SEPT and cause problem.

I am missing lots of context here. When you are starting a guest with a 
passed through device, until the TDISP machinery transitions the TDI 
into RUN, this TDI's MMIO is shared and mapped everywhere. And after 
transitioning to RUN you move mappings from EPT to SEPT?

> So personally I prefer no host mapping for private MMIO.

Nah, cannot skip this step on AMD. Thanks,


> 
> Thanks,
> Yilun
> 
>> page state tracking.
>>
>> The MMIO KVM memory slot is still marked as shared as the guest can
>> access it as private or shared so marking the MMIO slot as private
>> is not going to help.
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 928cf84778b0..e74f5c3d0821 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -4366,7 +4366,11 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>>   {
>>   	bool async;
>>   
>> -	if (fault->is_private)
>> +	if (fault->slot && fault->is_private && !kvm_slot_can_be_private(fault->slot) &&
>> +	    (vcpu->kvm->arch.vm_type == KVM_X86_SNP_VM))
>> +		pr_warn("%s: private SEV TIO MMIO fault for fault->gfn=%llx\n",
>> +			__func__, fault->gfn);
>> +	else if (fault->is_private)
>>   		return kvm_faultin_pfn_private(vcpu, fault);
>>   
>>   	async = false;
>> -- 
>> 2.45.2
>>
>>

-- 
Alexey


