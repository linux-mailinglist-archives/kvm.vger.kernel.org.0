Return-Path: <kvm+bounces-42461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08561A78AE2
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 11:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44CE618930FD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 09:19:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93682343C9;
	Wed,  2 Apr 2025 09:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f24yHXdo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE6D1C8603;
	Wed,  2 Apr 2025 09:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743585564; cv=fail; b=kNpKxnSJLSq1PseaX9V+d+atsm9FpPnVS8v0RmYokxzNklDSIXym1EQw4Wqp/+zD/ziEBgSvndU9384FJfTYzIpCmrmj5N/akC9EKcCXpgNQdkapsakOoipWb7DhywIpr7xt64xR/iuXNmLB1IXMVqFL1WaY9Zk6ML2bdjiIQAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743585564; c=relaxed/simple;
	bh=Cp+9BmnkYcDGq7HnZKOj7VhFuGHpzAy+1ADlLGxm1+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ky097frPAtCVTcH6Un95bI7vmekiqq9IYGW2RtZXmbyIh3EUQONKzj6BAEaHM0xNQt1rsiTFzz5asnyu7m2x4v4bjJMmWSiJRZacWTtYiSwX8xrGgaKI/r7sia3wiLJqRAbjgB6D8y+0fExhTwWSjESafjHxso1z1s5kdRBx3GY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f24yHXdo; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ha3Lu+QB1EhwLvXy61BVo01+QG5OxbGLjdV9h6+1RLYlzGdzNsmrfpX4BHPPE8EEK1eqr9CBbXazVSuY2B6lZIxBLujm4fXdhLJj6Q0RT1VDjiFQPluJbRGSssH1xHHgPECI4f1zy1l4+ZgkPNyQRKsVTviE0xk+g6BqgtREwqE9PgDh8FNabSgZ+MD0shwHgb74jehUvD31CIS4DRHydfCBZ7gk09aOsDoObio1zqYNz4DsQlcJs2M2kNI85RMnGAOCXPMFYdU3XAWAjgGJHS8m2o2gY/3eOx63L3lnlg8WX0urZk1S6NzwE7I0hgz+ZCh9a1c6ma/op0EQ2RpR8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cp+9BmnkYcDGq7HnZKOj7VhFuGHpzAy+1ADlLGxm1+w=;
 b=ncQ1MENynRU2BClicNBcYoG+THgyGqqPLaj65MyVuGrHwL4kZNlZRKiXW3S7JjRBkPIshmdw8qRPCFVaK2Hw0bRxJ9gS9F42i4gfXP1A1btokVXHSNJTxcrSzU1VZI2NDEBPlmZUd9rX4cwYB5FWyeKH5sas6JdbJpPVcXYOB4AZQR+4154oiZ8SJFm8FVlLDQJ7TWmB5Kv7QiP6IVH90stQBi2osn1VDqCHfdAgCS4rqbEx0LuoddF1Bzi5+Fjb2FwBEhD6dysBGmlmV9gKqrOdl3s9CjLaL+EHLTKqX39j3wXQJ4EtN4+VnK0zEHrll2zDASpjK+cyLtES0i4riA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cp+9BmnkYcDGq7HnZKOj7VhFuGHpzAy+1ADlLGxm1+w=;
 b=f24yHXdo2Rj++8eAklVC0D25bBEEql9mEARyho14BmjZzDDhDLZGvNdzH0d0ODhofC47XqoNrPoSUHocWM66RoZCXA4c4XF8t61J0AcP09YXYUQVDvzDOIeT3XOq0S+AfRi52PjejNG3ika+S3Q1oiVfoWTx9sPCgW8PJkQStJE=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by LV8PR12MB9665.namprd12.prod.outlook.com (2603:10b6:408:297::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 09:19:20 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 09:19:19 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "bp@alien8.de" <bp@alien8.de>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "Kaplan, David"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Topic: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Index: AQHbPFEGhO8cRc5EhkeUBgz5+C52n7LQATOAgAOr34CAAMTygIAD64+AgLiKaQA=
Date: Wed, 2 Apr 2025 09:19:19 +0000
Message-ID: <6bfb74e5f05ab8d4cecda1c09a235ccc59c84be6.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
	 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
	 <20241202233521.u2bygrjg5toyziba@desk>
	 <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
	 <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
In-Reply-To: <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|LV8PR12MB9665:EE_
x-ms-office365-filtering-correlation-id: 0c1c2b1b-e2a0-441f-f96d-08dd71c77301
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aE9OeCtWN0VZdkxRa0tJdmh2VHFqZWZpK3hYNUhtdHBqZ0tVYkU3OUpURTV0?=
 =?utf-8?B?bjhmY2c5cHhyS3VDTWcxQWw1Sk0rMjNjY2QzOVdZRFRSOGJ5a3VWcGVtVUlF?=
 =?utf-8?B?eEluM0w5WEs3cGpNV2F0YjZjOFU0ckcwdkU5d2NkVmplRm5lUHRHK0ZrTU5D?=
 =?utf-8?B?T0pkNVlQVlZpeDc3VHRycFlFbzJNTmpHeXdCT2VYSmJJR3VmVk03VDdRM2pI?=
 =?utf-8?B?VWQvR2pGVGY3bVJ0UWtFKzNkMW5vRXU5TExWR0tvT3lHMTR4UzNEemgwQnBh?=
 =?utf-8?B?WFNiWis0K0gxUy9wbC96Yld0THV4NWJnQlozMld3VitMK2hSL2N0YWZObUxM?=
 =?utf-8?B?U0E0SGtFakJLbFltRXZzU0FFMTNic0g0NGNWcTFmRUNkUmZBTy9ZeXpKeE9l?=
 =?utf-8?B?WU1tendJZ0RGcEhRTjh1NmFHWDFhbHVYS2xTOVVYUjZJOGNiR3c5clJDUkIw?=
 =?utf-8?B?c2JQT1pHR1l4YmFpRDRFT0FTbkkrRjU3VkkwNjF0M2JDZnNwYklvSUMwczIw?=
 =?utf-8?B?RGdpTzNkQk13YkF5emVBSVRzSGNJQ0pBUjBqMDYxbnZ0WDZ3Mi9RLzhsR241?=
 =?utf-8?B?MFI1cW9rVS9EaUZaQ2lzTE9GRVdaQ01NWEplbU03K2lncXU2Kzlwa2J1RTAy?=
 =?utf-8?B?cWtEQTU0dlJRMEc2NS9xdWlZS2wya2tjVk5yeWhuUDN1Ty9uM2VBMjBmaHc4?=
 =?utf-8?B?dnd6V3hCN0lZb2Q1bUxXMXR0R0JPQ2hybEVaSTdScUpHMXdDaG9BeVpkMkll?=
 =?utf-8?B?ZUdRQitGUytqc2FUNm9hM0RFY3A5ai9IRjRGcHZHOEYwR1RlZk5EN0UwbTg1?=
 =?utf-8?B?TW5TeHBVRHp6Qmp6YTU1ckg0L3IyazAwOU9JN21NZ3lzazJBYWNDbGp6QnFq?=
 =?utf-8?B?SHpRU2V3ZTdGY084TVBQWUUyTFEwdURwa3hsQmpsSndML0I0aWtFdVp2NEdn?=
 =?utf-8?B?ckRaVmZ3a1BNU2N0UjR3RVpQYzhjc29adm1ya1lrQ0V4eUJWTWdkbVRmWjBw?=
 =?utf-8?B?blRmS25NVkZvYVgvN2tubkg3L2YrKzNuc21NU2dXL2NYQXFNY0hUeU4wclo4?=
 =?utf-8?B?ekRPTk12RG9JVGlCZjhLWnkwL0VVNFk5RWtnbVlKTVNVNU1CMG83ZnBLRllP?=
 =?utf-8?B?ZHoyRzUrSDBlS2l0MEJKcXJkNUxKc1pLK080eVhrZDNvU2YzUGFUUmFqMTF0?=
 =?utf-8?B?Ymt2eTB1QU9NK0x3Nm5PQkk1SmovV1hWQmU3dnRuU05BUlg0MUhvbVpMVThL?=
 =?utf-8?B?cmp3RDBQUHpFUTNKK3V5UUxDTkJKT0N6Rlkyb0ZSNEk5Q3JJNTdaRXBUQ2V3?=
 =?utf-8?B?OGZabVlraktLdnpFRkFKTDBBU0hRcVBVYjRGZ1lZcytWSU5wNmxwWWdrSzNs?=
 =?utf-8?B?azY3alNxM2lQazBZUlNZVEJ1OGxxZnZNWG13UWN5NnRya013bHZLbG9YYTF3?=
 =?utf-8?B?U2diY1ExSW5KU2MzaitvSUFoc0RYOHJXdWk3VFQzd2JteGZmOVJteVVwS0VL?=
 =?utf-8?B?azBndkZEVVNLSHdZcXhTbzlPUnQvQ2l3elVFVEJseGJzNDRVQ1hsWk1zQSs3?=
 =?utf-8?B?eGV4UkNTejl6ZzlXWG5Cak81MG93aVlZRTNvbzQwenlVWnh2T3dTS1pveHQv?=
 =?utf-8?B?UjVmT0pNRHlRZ1VnWmMrNEtrV3QyYVppNlhDbUVVQXV4bnhyc3lRNDdjenRS?=
 =?utf-8?B?T3Z1dVphVnp0VE1pK3NEOWhKNmJyQVRYallIby9OTTlKbW9GN1pNck55QjJS?=
 =?utf-8?B?VHdVNzl0dy9mcWJmbFRrSFV2RnFaY0VqaW0xT3JLUE1jQVE5OGJtMXRpKzdU?=
 =?utf-8?B?alo3N1FiZXIrdnhNUXpFOWdPNEV6NkFlZFQ2azVhQ2xUeGpYcGJyMXlleksx?=
 =?utf-8?B?VnNDRUxQTVFqNnJvTkEyWHpROE9VTTBnallYc0EwM0JkazFKRUVlRnJmeDlo?=
 =?utf-8?B?Tnd6S1BxY2pMOXZUREFnM1hUYWtwSnBCRHdWc2xuc2kwSFNldlNVd2pxTHhm?=
 =?utf-8?Q?La0iK6MMcJl0lZItroyje0MRmaXvYs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ODQ2U0lkVUo2ZDN5L2RNbmVGOGF4dWpxN09lbmlsaFlTZDZJZ1VacXNPVENs?=
 =?utf-8?B?SkdxSFNoS2lGZW9VTFBJWjdDWTdpVHQrdFNnYTl2dzdwRExISXB3QUxNYTc3?=
 =?utf-8?B?K0tqS3FjSy92ejh3OVE3M0I1UGYxZTRTV2IwdDRVZTdEUFM2eTNodFVpMmZZ?=
 =?utf-8?B?ZStHY3lQNkFCWVRnN1ZZM2tyVUFCeHJUSW1vcHJHUGxXQkRwZHdIR21NeVBq?=
 =?utf-8?B?S3dFL0xJRlNoOHF5NlhRZU8wbW91ckF2b1VGTHJJMkg4ek04T0pMYnNxZzNF?=
 =?utf-8?B?MlBxQUcvUU5wV3FRTndNeDgyUktEejFIcTJOcEVjMmxodHFqc3AzTXJ1TGZV?=
 =?utf-8?B?cnFtemZxQlMwMnpoM0hhSlJmVnhxNTAxOU02YWNpNk1JYXp5WEJndG5JUUQx?=
 =?utf-8?B?UVV5WjJ3V0w1ejNBRVhFWGcyOE5lZHlNblNEN2ZCYUtpdVNrRkdqeURkbmhS?=
 =?utf-8?B?SHQ1TmwwSDM1NXdNRkM4aHJHNVhheTRiZlJVZVhWUkhhMmJ2a0UzelV4ZEhP?=
 =?utf-8?B?R01JYnluVmc3NHcwL1BRbk1oWit0ZWNxdDhxUUM5NllOY1VreGRCT0hhcW1s?=
 =?utf-8?B?UU9YSllON3dheXlBRWZjSUwrcStrSWFjQUhOOUFINE9zVCtIdnNMbExIeXlG?=
 =?utf-8?B?elVVV21kb21tWC9OWHVHbExGM0Y5VjhPTmZTNjJLVWZLMHVINmVVYmEyK2dh?=
 =?utf-8?B?RWVRUWJDektpYnBoUkZPcGZDcWRtYnVkNUsxQzVoZ20xUlZXM1dFVFBTSHZF?=
 =?utf-8?B?dmlHMStHVjRsSmR3UDJJOHZMQTl6OFlyS1IvWEFKdmxqUWlBZzFHRC9wQm11?=
 =?utf-8?B?NjNXbFNyN2xTdnRvN2g4MnNHbHdOY1pkWitWd2taSjRHcGcwYitzSjBjb0Zy?=
 =?utf-8?B?ZHMyU0tSKzFIcHdKOW93dU5tUTVpOUU5NmYrdXZBWXNhSHNjTHdNN3dOUUg2?=
 =?utf-8?B?b1pxVHhoNkkyL0Z5TGE2dDEvTUptVEM2RzhCVm9yUnRieWx6dkxNbForc2lZ?=
 =?utf-8?B?cktsVmREcjZlMjNPNHZ1dmNUWllydGh3U2JTMzEreEFVVXFtTDQ5TVM0bEFS?=
 =?utf-8?B?a2pQN2pXSUFiNWZVUW50VWhuMXVIcmUrYUVoM1hLendaUmRaTnQzRWhRUGpY?=
 =?utf-8?B?TC9LSk9HaEU4NnNqUEJyRDVCNzc4RUp0RUk1T013NlgyOEdUc2hHWG9QQnpJ?=
 =?utf-8?B?aktRRlNpNlFYNEcvM21aZG4wWjhPUkRLRnYxSDlUcWRkeDY4d3R5WTZaNWhN?=
 =?utf-8?B?clY1MjZQQmlNczFkWkpsMXRwMkNQRlBBZFJQQmJUUWY3VTdkTCtNRWI1MndV?=
 =?utf-8?B?elZkOEVGc1FUUksxL2p6NTlob3NlNGVzUlJEZTNFbE5KalVYeWprNDFqYnVH?=
 =?utf-8?B?VFUwd2lISmw1dlJBZTVzVWNWdVhNcUpGdHREM29iL20wNkgwbUQ4UkJCdFRt?=
 =?utf-8?B?VDFmNXh3ZmFOWFFLdkV4ZlZNbDlTVk9XM1VJRDlrcnNBL2V4bjZ2QUhSQ2JF?=
 =?utf-8?B?d0liRlI2QVNHeVpEM01xUGV4NDIxWjRFY2dxL3VESkdNS1VqMm8zTkNQcU53?=
 =?utf-8?B?WVozYmFzVDdSSjVMdHp4M1ZqK1Bud2FFdGl6WG1YUEU4SzFzRDUvcTA4QXd4?=
 =?utf-8?B?bENXKzNlc21WaU1SdzRrSHg0cHEwbGpHQktYK3laajZVZUxMU1Q0ejZYU3ZG?=
 =?utf-8?B?WU0xeU1Lb2RQZGF0aHJzVEY3Z01NcjZVb2d3ZndBVkdrVXdySEFBNUtmdWdk?=
 =?utf-8?B?dHpXTTlMdnVxUEgyNlVHZkY0VS9pY3BBOUFhS2RCYmJMYkUrSEZpZHdQcnRh?=
 =?utf-8?B?amE4ay9pS0RpQnpGZWdyY3pNZEVmNUQ2Qmg5ZStuZmxyVXFsZ2ZWUTcyWHU5?=
 =?utf-8?B?T0hZeTN2TzI3ekxYemxWSURIK1BHZnZJd1RTSTZtV1ZaU2x5WS9IQ0l4VlRP?=
 =?utf-8?B?Qi9MWURCZFB3Q1YyN05wRHdXR2o3blpidCtnRXJZVDcxUVNUZFlHQ1FUU1Ri?=
 =?utf-8?B?OGp3dHAzZmtZUk0wa0l2Q2ZZVzhrRktzNnNSVFZYc2k5UE1zY2xXVVF3L3cy?=
 =?utf-8?B?VFRCOW1uSnRkcWh4dkVWVERDK2JRWnpEeDBrNmZKc0lXb3hnMGNlVnYzQmp2?=
 =?utf-8?Q?hSYnaugf6BSllBW0slz4UtDC0?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A9AE1431B02374085A60AFC470F9ABF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c1c2b1b-e2a0-441f-f96d-08dd71c77301
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 09:19:19.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCr1rme3I/PNMdAOqtVC6BErhmSjFPhZVgawRLo8RaLi+zd6MXQHFEfo7L7215HeQ89WVhrmq9wGo80+qW8G9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9665

T24gVGh1LCAyMDI0LTEyLTA1IGF0IDE1OjEyIC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVHVlLCBEZWMgMDMsIDIwMjQgYXQgMTI6MjA6MTVQTSArMDEwMCwgQm9yaXNsYXYgUGV0
a292IHdyb3RlOg0KPiA+IE9uIE1vbiwgRGVjIDAyLCAyMDI0IGF0IDAzOjM1OjIxUE0gLTA4MDAs
IFBhd2FuIEd1cHRhIHdyb3RlOg0KPiA+ID4gSXQgaXMgaW4gdGhpcyBkb2M6DQo+ID4gPiANCj4g
PiA+IMKgDQo+ID4gPiBodHRwczovL3d3dy5pbnRlbC5jb20vY29udGVudC93d3cvdXMvZW4vZGV2
ZWxvcGVyL2FydGljbGVzL3RlY2huaWNhbC9zb2Z0d2FyZS1zZWN1cml0eS1ndWlkYW5jZS90ZWNo
bmljYWwtZG9jdW1lbnRhdGlvbi9pbmRpcmVjdC1icmFuY2gtcmVzdHJpY3RlZC1zcGVjdWxhdGlv
bi5odG1sDQo+ID4gPiANCj4gPiANCj4gPiBJIGhvcGUgdGhvc2UgVVJMcyByZW1haW4gbW9yZSBz
dGFibGUgdGhhbiBwYXN0IGV4cGVyaWVuY2Ugc2hvd3MuDQo+ID4gDQo+ID4gPiDCoCAiUHJvY2Vz
c29ycyB3aXRoIGVuaGFuY2VkIElCUlMgc3RpbGwgc3VwcG9ydCB0aGUgdXNhZ2UgbW9kZWwNCj4g
PiA+IHdoZXJlIElCUlMgaXMNCj4gPiA+IMKgIHNldCBvbmx5IGluIHRoZSBPUy9WTU0gZm9yIE9T
ZXMgdGhhdCBlbmFibGUgU01FUC4gVG8gZG8gdGhpcywNCj4gPiA+IHN1Y2gNCj4gPiA+IMKgIHBy
b2Nlc3NvcnMgd2lsbCBlbnN1cmUgdGhhdCBndWVzdCBiZWhhdmlvciBjYW5ub3QgY29udHJvbCB0
aGUNCj4gPiA+IFJTQiBhZnRlciBhDQo+ID4gPiDCoCBWTSBleGl0IG9uY2UgSUJSUyBpcyBzZXQs
IGV2ZW4gaWYgSUJSUyB3YXMgbm90IHNldCBhdCB0aGUgdGltZQ0KPiA+ID4gb2YgdGhlIFZNDQo+
ID4gPiDCoCBleGl0LiINCj4gPiANCj4gPiBBQ0ssIHRoYW5rcy4NCj4gPiANCj4gPiBOb3csIGNh
biB3ZSBwbHMgYWRkIHRob3NlIGV4Y2VycHRzIHRvIERvY3VtZW50YXRpb24vIGFuZCBwb2ludCB0
bw0KPiA+IHRoZW0gZnJvbQ0KPiA+IHRoZSBjb2RlIHNvIHRoYXQgaXQgaXMgY3J5c3RhbCBjbGVh
ciB3aHkgaXQgaXMgb2s/DQo+IA0KPiBPaywgSSdsbCB0cnkgdG8gd3JpdGUgdXAgYSBkb2N1bWVu
dC7CoCBJJ20gdGhpbmtpbmcgaXQgc2hvdWxkIGdvIGluDQo+IGl0cw0KPiBvd24gcmV0dXJuLWJh
c2VkLWF0dGFja3MucnN0IGZpbGUgcmF0aGVyIHRoYW4gc3BlY3RyZS5yc3QsIHdoaWNoIGlzDQo+
IG1vcmUNCj4gb2YgYW4gb3V0ZGF0ZWQgaGlzdG9yaWNhbCBkb2N1bWVudCBhdCB0aGlzIHBvaW50
LsKgIEFuZCB3ZSB3YW50IHRoaXMNCj4gZG9jdW1lbnQgdG8gYWN0dWFsbHkgYmUgcmVhZCAoYW5k
IGtlcHQgdXAgdG8gZGF0ZSkgYnkgZGV2ZWxvcGVycw0KPiBpbnN0ZWFkDQo+IG9mIG1vc3RseSBp
Z25vcmVkIGxpa2UgdGhlIG90aGVycy4NCj4gDQoNCkhleSBKb3NoLA0KDQpEbyB5b3UgcGxhbiB0
byBzdWJtaXQgYSB2MyB3aXRoIHRoZSBjaGFuZ2VzPw0KDQpUaGFua3MsDQoNCgkJQW1pdA0K

