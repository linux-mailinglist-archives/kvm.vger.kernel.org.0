Return-Path: <kvm+bounces-58815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DAC4BA1166
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 20:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15C477A3EF6
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 18:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E9E31B11A;
	Thu, 25 Sep 2025 18:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AqKobH/j"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37322F25FE;
	Thu, 25 Sep 2025 18:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758826497; cv=fail; b=lQrBlZOdWfjrMVt+UIHgZorKz8IdaykJgzelgRKda5L8+tb9SZb5WLIrvONos6KW9yM+CGVCe5hH9SO/Y/4ihGi5YLOoLF/Fp38sqnqSqEfJbm35y1cFYdHfWM8Faa6EdCyB8zkamlpirbByauG/oUqYzA+8P+hk2NDmu7MXkbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758826497; c=relaxed/simple;
	bh=WCXUnaewEqKIk0mYqkQAG0XHIXu7zHMHV0r/tpXj2XI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jpmITqoTZCgti5YALSiIrHLRKGX/o4aZopoBuKpSGlwhIbpFecA028CcxpLn2CCRGd0KIQMPpD9NpeAMyts257GS21nx9S+pU/BBA1DUzMjrSOSeQyA6OyJ7kJgq64UH35IxQEPZAjP3cBLrEOSjDAyZk0iTN60xKrLVZERKEgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AqKobH/j; arc=fail smtp.client-ip=40.93.198.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MdHlvHzK4carRmVwJ3TLcCw2TPGIs6IlGNfBsOWufCNhkounafThgnf1C1dJZeCmvP1BWQtf5I0EojSYGg8bo7fHV8pXqa9tRLmhkjUUPhAk/2o16ONnWHh3FQbMC/rljJGtCdW4kkiHs+qpGwqSuh1RURAd5MN+HEhuQk5YFddfCMqa2iwzTufesD2Y6lt1aKyB5yp38eBNMdJl+3a6lsXaZox2MG53ewYrrNvLrcgCZk0eqmBSjOCWEurQJ5dBulwhYP4YbI0k9XSKlE5KtGblGxZsfeR5wBAypwo1DuRlEwLqjYpNVSw2ptKPX2MVZSuW8+bOHFULtkQHK17/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwzqiTPuSE4RoPyXoV8uQAr9dEyIPjf8vct2mGcDWfg=;
 b=dJb04gcuqnszNTl8s/c8qT/rFjURe56PMxlIe7YHlq/eDMOG2I16ggRklFxW46orEpIJzJ/LPu4IUNA9KAAVT6g/zoNCWLQG+Ju2G/tM7dtZs/weVYNuFD528nKqKX36t+EcrkTgkJ6YzXUssqeFn3TGH05Z3ejjaF9EX1Eb+QLpgQpZFlfg5ODagVqZ/NRPGR/D8cKAkxC5JB1p85W+BUO90VFMgmOj0X46QgT42bqkVMo3ICOVotBl60Ez0aKoE10FvJ5qEwpyAnb/3V5E1CHSrP5xS577nkkiylWPlvVkGXeABPUZw+7075Lu4NqnaeWcTayCEq2MQSZ34ocW+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwzqiTPuSE4RoPyXoV8uQAr9dEyIPjf8vct2mGcDWfg=;
 b=AqKobH/jBA137XQM3FcPXJT8pXFj3kKuri42I7OHQk91JeJsK7cacmS46CPpV79pasve0HMeaFipoalo4cHux6tWQGvXS+gKmEkLXQ8+jsNHTrHCdTZFrKgIknB65HEwHsnAeS+v1ajTJGisqz1aQidfgz4R5+jy7Ozz/+IEn3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SJ0PR12MB5676.namprd12.prod.outlook.com
 (2603:10b6:a03:42e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.23; Thu, 25 Sep
 2025 18:54:50 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::8d61:56ca:a8ea:b2eb%8]) with mapi id 15.20.9115.018; Thu, 25 Sep 2025
 18:54:50 +0000
Message-ID: <6929b406-0de5-4dfe-a940-f2c8cb38cd60@amd.com>
Date: Thu, 25 Sep 2025 13:54:47 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v9 09/10] fs/resctrl: Introduce interface to modify
 io_alloc Capacity Bit Masks
To: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <bmoger@amd.com>, corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, kas@kernel.org,
 rick.p.edgecombe@intel.com, akpm@linux-foundation.org, paulmck@kernel.org,
 pmladek@suse.com, pawan.kumar.gupta@linux.intel.com, rostedt@goodmis.org,
 kees@kernel.org, arnd@arndb.de, fvdl@google.com, seanjc@google.com,
 thomas.lendacky@amd.com, manali.shukla@amd.com, perry.yuan@amd.com,
 sohil.mehta@intel.com, xin@zytor.com, peterz@infradead.org,
 mario.limonciello@amd.com, gautham.shenoy@amd.com, nikunj@amd.com,
 dapeng1.mi@linux.intel.com, ak@linux.intel.com, chang.seok.bae@intel.com,
 ebiggers@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, kvm@vger.kernel.org
References: <cover.1756851697.git.babu.moger@amd.com>
 <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
 <1cd5f0a7-2478-41b8-97cc-413fa19205dd@intel.com>
 <7c6a4f7e-e810-4d81-b01d-b0cbf644472f@amd.com>
 <0c110b5f-de24-4ffd-bc9c-3597493bab7d@intel.com>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <0c110b5f-de24-4ffd-bc9c-3597493bab7d@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:806:f2::24) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SJ0PR12MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 080d0bbd-291b-4d6c-7d9d-08ddfc65017c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bit2VC9TaVRyc1FILzExRGlEQ2NGZjlndDZZL0NMeVUrR3NLM3FNZTMzaHIy?=
 =?utf-8?B?QWF6WlJlL2pkV1JZYkVpYndLQWVXNjc4MGE0YzliQmI2YzdZdC82Vm9LOW9R?=
 =?utf-8?B?VDdxL3YvVEQrWlBUN1RKSWo3djFlcVg2NUVQc0JwZzM4dHdvT2VPbVJpR2pB?=
 =?utf-8?B?TWxHeEkwQ3BTR3NHNXdaTDBPcHpBZ213b2txRWdWYzFubmJMcXRmemoyOStm?=
 =?utf-8?B?VDU1YUNidWtQcVV4S0tmblVVTFA4U011ZkYrWm04RlVxdzZsbkxDQ09GSXRM?=
 =?utf-8?B?bEVUTmg1empsNFJDR3ZhMzBkSDFtbC95czFwaVppeVBreVFEQytnZi9zdUVP?=
 =?utf-8?B?NEMvTnE1My8zVEh4ZEUyQi9QdEQzTDIxTHFqZ3p5V0Z3TkhveExHbFFoamRU?=
 =?utf-8?B?c3RWSTVGSUE1RkE4Y1NGaW0zS0orWHlpU25LVk42VXJlQXVyUzBKZlFJM3Y0?=
 =?utf-8?B?dDJsSHd1TGhjaFFSQkFXSXBwL3ZGdElzODY4RlhsMnFoUDFkSElUT3AzVDNn?=
 =?utf-8?B?N1NxajcwbEJZaVkwR3RIc2tkQ1NXenFqVStqWEQrMXJSMGFnSEh2ekMrYmFu?=
 =?utf-8?B?ZU9FVWtpUHpEZzRmYXpRWkJsQzBjSkV4bFoxSXJMS1l4a3JWK2U0YThpRjdW?=
 =?utf-8?B?eXpsekF5QWRYNEQ0OTN3M3dJR0ZBZjdKTi9tRTErMVhrMmxSODBPRmpWSGtP?=
 =?utf-8?B?ejM2MUVrSUpQVnNyUlMrdEc5QjZ0OVFCbGhUOEtDS21MTHhCWjJYZTZYRHZz?=
 =?utf-8?B?Uzk3WUIzUldaSXA3VTNSeFNwQThmMTVqc3ByeDZPekZBVWsxdTZyalNuQ2VZ?=
 =?utf-8?B?c25aQ2UzcHoxVlhzcFJQazFQM0Z6WDVhV2xPdmE2MUFJT3JTNE5nSDBoa0h3?=
 =?utf-8?B?QktNcU02Y1VzM1BkbEVoazFDKzhCYzJ5alRZcnNCcmpLL1NFZFJGL3k5Um1s?=
 =?utf-8?B?T3ZXakw1czNyOHdPSC8vVEZkTDcydzlBZnNXY2ZFNGVqTE9DNjVpWlR5WmhB?=
 =?utf-8?B?cVFnalR5MUdDdEZEd0RnSWMrckFVQUsycFV5enNQNFJsSHhJaWd2b1pYWmV2?=
 =?utf-8?B?TzFVSUtKUE5mRlAvbWZ4Snp5S3IwV2tlZkRmN2FFd3ZUZWRzeGd5UUl4M25N?=
 =?utf-8?B?RDVBeWpvSDZQblhmNHcwTEtERHdZcVJxMlJrbWNRcEo4VDI4bTllUStLbGR2?=
 =?utf-8?B?YlVUakRGV3hVSzl0RmdndWV4ZWxQZG9ReFJIcXM3Nm1hSUtqSktoYnJONUgx?=
 =?utf-8?B?WEVqUCtIdzZ1NlR2RVhHZkNQZ1haSVV3M2hWeHhhbGRvcFdNdDlLUjFEa3NL?=
 =?utf-8?B?ZjhWWWplMzJjMExxSFpiTnhybWR1S2l3a245ZWZLL0ZjUnJxaGZvK3FncDI2?=
 =?utf-8?B?ZlJQZVh5d3hpOHVlOExBYWpCM3ZCemhsaU5WMEkzbTVvOWdZWEJ3OFArZFU0?=
 =?utf-8?B?dCt3N3NGNTJjTWhIVXB1Sk0yQ0NmeTI3KzZ1ejVualVqeEw5ZzgvdU9pSW8y?=
 =?utf-8?B?UkVpR1NtYm5seXJmSmZNYWlYNEtDSHl3OE9mWGVJeUYwN2c4NTR2Z0xsQ2NN?=
 =?utf-8?B?WVVzYmVRczdUY3NaSG5ucHMzOC9zSWxrbm0zYitrdDZkR0RBSXZqd05rSWxt?=
 =?utf-8?B?ckJuNVBBcGFFRkpBZnVaUWNXUWU5YlhEWFduRjNHMkk0QXZRVHFwZXBDMzZ0?=
 =?utf-8?B?anlEYUczT3BOeEtLaE9Ud2RYMVUzaVp5TVQ5SEVwZStheXJIOGxOcW1tRjZG?=
 =?utf-8?B?T1Z4VHdlUDduSUxSdXBudFZnUWRYSWhhN3NVYzQzRkQwajN0aVFTV1ZYTThv?=
 =?utf-8?B?UitUVVFJcG1oMFRCMDdCbStLekpIcTJuYmxSWGxlRzNQWnVudEVvakpvcWFG?=
 =?utf-8?B?U1dhL2s3MnRVNk9WQTY2RFFIQ05QNkhtWEVRc2k3b1dmdEw2TktOcFI5cS9m?=
 =?utf-8?B?RWlBU1FHQW1NWnVWbGpReEkrd250NXJVMXVDR2tpbXVFaUN1Ykpra1lQT3FU?=
 =?utf-8?Q?Fd2atPcGaxz6qLcHH+oDZ1ODq8N/ww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzUySDQ1d0xhdVVML2VGaVNjU25hVGVKTEtBQUxIWTRWWm9XWm5TMzJtSTRi?=
 =?utf-8?B?RCtJZEtFU1B2Wi9ZSGdHam5vQ3RoZ2dOVGVxYlhOMUV5Sy9ncXZrbDQvU2xr?=
 =?utf-8?B?bmYyVHN4Vm5yUGNhaTJkY3poeGtoeGZMVzBNOVRPUUpJY2hqd0pQeUR6aVFC?=
 =?utf-8?B?ZmFkZ3BrMGMybElTVDZNMzd4R01NdmNLbFRFUWJKQWZNQlB4ZlU3eG1qYkpN?=
 =?utf-8?B?dUVmbXdsNmpvVkhGaENwbnNjSVVJeEhqVXJKajIvMmhLQ08rM005akUzZGE5?=
 =?utf-8?B?ZDh4aW5CdE1VaytaM2VadElkL1lHQVBWV1VMVktNb0xobDQ5blM5LzJBc0hS?=
 =?utf-8?B?ZWZ4TWRHemNyVkppWmlHS3hUMWZyQ2NObnljVU54cy93TVlkc2Jwenl6OHRi?=
 =?utf-8?B?MkpjZzRVQ25JZjRpOEtmUXA5bHlLdlJicHR0S1pQSGdMM0krU1pkUE9vaUw0?=
 =?utf-8?B?WERTVmcrTmlUMlRNV3ZXbEROWlU2NVZOOEpmTFg4SE1kaHFkYnF2YmR0UlBG?=
 =?utf-8?B?VjRsc2laSmNZek0rd2JvTURJRmtieWc5QUZvYS84eGtEcFBveTMwUlQ0aFVM?=
 =?utf-8?B?M09OMUJ3RFJyV0pLTVcvM2EzdVdLQ0c3UDF6VzJYdnp3OWV3eTVReHdTanMy?=
 =?utf-8?B?TWg5R2l2ZTJwMjd2b1RnQmJtY3NKSFkvcDFKbGlGbmc4VCtiK29zbzV3WVhL?=
 =?utf-8?B?dU9sVjlRbmU0VC9paGxkYVE3cUVzNVRlMGVSUzBvb2ZHOUdkeWl4YTM0dmk4?=
 =?utf-8?B?c1BQY2hjazRKaWYzZWprWnp0WWRLZ1NpWXVtNk1hZDFtMUFSbVJ0eHlwYkVi?=
 =?utf-8?B?UWtpWi9wUnl2UVAxWHl5L25jTkVVU0JBMXQ1anFESktlTGRYSXZtZWZ0T3pB?=
 =?utf-8?B?bkQ0YkZleTUvUWhMQWcra3hpczIwYUJJTTZ1emNWTDZGamwxWkZXZ29zc044?=
 =?utf-8?B?SnVRU0tzbHc5QkxXcEJOV0V6bXJwQkxuRmVFVDVZN2xNbUJaSlNaYWJudHhH?=
 =?utf-8?B?ajV5Ui9WWFUrYkZHNGV5M21tSDVYTUMxZ2Q1Wm04L1QrNTgzYUxucG5Nd2E4?=
 =?utf-8?B?TmFFQ2RZYWRJTkpEak1ncFBXdHdxS045cW9EaGtFZU5HTlNuYTQyMHFjQmFM?=
 =?utf-8?B?Slc4ZDhtRUZMVStiam9kRVllK2x0MmtoRHE1U1ByK0dCVzE0TEhZZVAyZXZ3?=
 =?utf-8?B?SFVIT1JxeklCNHFMd2xldkwyNFk2NXMzdFhoTFJRMFdCQ042cWZQWDBWcVdt?=
 =?utf-8?B?cFdWbDV5a3JUbTZ2YlRnOERrRUwzU25SSnhlMzdOVVc2KzB2NnBOYzNaeTJL?=
 =?utf-8?B?Qlc4SE9sSWQ3T1g5K1dHeHhFcHZ4WXg4UU5Bemx5d0NjOUFwemJ5Ty82SnhF?=
 =?utf-8?B?blFUa1E5NDgrN1FaV3pTSUdlTllIdTZyMUQ1NE9uVG83bkxHUis0QUZhOGdl?=
 =?utf-8?B?aFR4ZVhIamJFRXpVbVVQUzBvdTFkaWFnNW1tUEh2TkE0ZDBQcWI0SmdXV0hr?=
 =?utf-8?B?N3BtNXZNSWpnZG43SVo0L1JxbG9qd3NzY2tuMWZYRW9QRlNvZkRkV09KZ3FM?=
 =?utf-8?B?MlMyQnhJTEp5R0RLbEIwV3V1YzgvOHdlaFJUQ0hoNVB4T3Y4ZzJETmN5RzdJ?=
 =?utf-8?B?YzdhN2NNODJuc2laWVYrRWFySW1yYm1HR0M0MzBXYkNyYlZxaFJZRmE2Y3pz?=
 =?utf-8?B?dThUSUlKb2tUN2dhdlNTTXBrU1B0TFRkZTNYc0lCZENrcFVUZUhBdkdUdDNt?=
 =?utf-8?B?UE81YmFTeUhyV3RRK0ZQZjJSZ0c0NHNkNnBwVS9YS2IvOUY2ZlRlYVk4SXVt?=
 =?utf-8?B?WjlNRUJ1KzhXNHh0VE5QV1RUODFSUmJ4d1pYV296MDNRNEdzVGlJUEVKSlVX?=
 =?utf-8?B?Uys0b1BIbi9CS01WNTNmdFcwU1R0dFIwejBUNGhmckg1M1Jld3djcnllL25r?=
 =?utf-8?B?T2IxakYvVFdXYVczM1F6bTY1U0tOdWp2RGdEVHFHMStqYWVCdHBmTkRZL21O?=
 =?utf-8?B?ZDhrR0dCbUszOXlnbUJuYno0Ym9vYTVSM2NObDYvQ2tCRmdLVHJaZmMrVUpI?=
 =?utf-8?B?RWo3Vys2aFd3SVZ1OUxkZEJRMnQxblpEKzU2VVhmeFhZMXQ1bUZBM2lwNnRp?=
 =?utf-8?Q?p22M=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 080d0bbd-291b-4d6c-7d9d-08ddfc65017c
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 18:54:50.5213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+MkAbae4J7jTwErMymTkxn8nLDSbIICp8ESOD6Vvl9srnG4ajE2J9XV/4hvj1q7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5676

Hi Reinette,

On 9/22/25 17:48, Reinette Chatre wrote:
> Hi Babu,
> 
> On 9/19/25 1:49 PM, Moger, Babu wrote:
>  
>> Here is the updated full changelog.
>>
>> fs/resctrl: Introduce interface to modify io_alloc Capacity Bit Masks
> 
> I do not think it is necessary to use upper case if not following it
> by the acronym. I also think "bitmask" is usually one word? So:
> 	fs/resctrl: Introduce interface to modify io_alloc capacity bitmasks
> 

Sure.

>>
>> The io_alloc feature in resctrl enables system software to configure the
>> portion of the cache allocated for I/O traffic. When supported, the
>> io_alloc_cbm file in resctrl provides access to Capacity Bit Masks (CBMs) allocated for I/O devices.
>>
>> Enable users to modify io_alloc CBMs via io_alloc_cbm resctrl file when the feature is enabled.
> 
> (nit) can be made more specific with:
> 
> 	Enable users to modify io_alloc CBMs by writing to the io_alloc_cbm resctrl
> 	file when the io_alloc feature is enabled.
> 

Sure.

>>
>> Mirror the CBMs between CDP_CODE and CDP_DATA when CDP is enabled to present consistent I/O allocation information to user space and keep both resource types synchronized.
> 
> I think "and keep both resource types synchronized" is redundant considering the sentence
> starts with "Mirror the CBMs"?

Removed "and keep both resource types synchronized."
-- 
Thanks
Babu Moger


