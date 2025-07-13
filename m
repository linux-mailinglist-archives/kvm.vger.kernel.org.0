Return-Path: <kvm+bounces-52238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0465B02E63
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 04:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CDD64A065C
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 02:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAAD513B5A9;
	Sun, 13 Jul 2025 02:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BZ/lOopX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C69F9EC;
	Sun, 13 Jul 2025 02:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752372743; cv=fail; b=EYp4G84ML8IqR+wDcoyoi5v4TldyKHLdnxPMxrPcy15qLRxMboyHWdcC7raxuO6lvZSlqNWzLldxZHqxEQ6+vN0TX25xhSE+2BBZgmREzSgvNDoIeHXBr+wRWs5nXdqHpGfrg8xMyPpeD0vxb1D77SAcz7gsb3QEaNk3OApgvpc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752372743; c=relaxed/simple;
	bh=hAftpFzcSEHOE8szU31oSi4QHVP+tyLoXu5OWrEL9Sw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OxVM2bllUgKLcR8vXYmcruYspYNfjKrBXz5qOAseYjstO6py+/Dc6wBEWSpr0PNhBnRl317waKCkw+B/GVWgIqHxdqOwv7Z+g9Z7XvFlkeT67jRdRBhKuu3ajpqVz+iX4crrMr7sftsqzWoWS4LXQ6rtodLXYgGWnIHT0i+OkAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BZ/lOopX; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qbJiN7JwIpWzs4I1liOPlNEbPTLK7kOMBThEofWmcZw6aIN7Y0U8FgUHeZ8f0F5wWMHwZkunOHza6T81GcqqfjAb9u0yI1qClJZ9sE07iZ6hcbm0cuNq6VD4vcd+iwfCP4sFbHn7342HItYieGDolvwRW0Qs0OfCBijroTWXVv2tWLNbG7HWwCBy2r3QyCdet9UkojqSb/fO8vkae1YGWJEhrKdA3vWE7yawHOMFfTbj9ppknOQG34n87DsO3wrsrx4ugdexcJ1XX6SLhMO3VXwcT80ATGz63VyFPLHu4VY4ydo/KqjDn7M81AAF9zQDGq5GQcQvSnagOgLJ3jy1hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DZK3E4MwakaMSsh1CS6yMxdrpqssNlcBvFafIG73VdA=;
 b=E4yjUshXAoVkzDAZyxgAKX4iI+PhpBhYg4klyPLudvyRRnjstw62CMzVduO2YZ4BAxbX8aUs/QIGsbe2GVjoe2XW9Idy+Zv94un3HYIeB+xVtsGA23LtcZPfbzLmh1H8hfNYtR4aW+QQjO8tUwmOsS8tz5u+PqfjSCTsHzRzRtjSQoTnbV2C9Q2Or+pM/ykEIDN7xf4UXVMXjT014C4c2K2HAROvVFx6W+fgOQbk6OhsigeXAjpMb/26JpwJQc1h4fkxegtXzfX6Vo5Uxu2wAKt2k+C7dudVNCy+qm7Z1yJ8wQ4W6f7FXVAWokQnHbY3N5Bovwn2o9sROSrvQ8lgvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZK3E4MwakaMSsh1CS6yMxdrpqssNlcBvFafIG73VdA=;
 b=BZ/lOopXCbB+udOKyXzVI08BhUaZm8CrlDKbz9jnMGM3R0+KfNGyFLfRudLCmffWfR3GJZvjs9484Tc4B663G3hUxp+CPyJB/9fAhqvKRJnOR7UZw8qOD26IA9DY7lZkHskOzUF+qTcBtijOQe6ZrlijJUGwn1EKZ6/g9zikQjs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 BL3PR12MB6476.namprd12.prod.outlook.com (2603:10b6:208:3bc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.28; Sun, 13 Jul 2025 02:12:15 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8901.024; Sun, 13 Jul 2025
 02:12:15 +0000
Message-ID: <d648e1dc-4409-4263-861a-8c30e96719ac@amd.com>
Date: Sun, 13 Jul 2025 07:41:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v8 15/35] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, kai.huang@intel.com
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
 <20250709033242.267892-16-Neeraj.Upadhyay@amd.com>
 <aG59lcEc3ZBq8aHZ@google.com> <be596f16-3a03-4ad0-b3d0-c6737174534a@amd.com>
 <20250712152123.GEaHJ9c16GcM5AGaNq@fat_crate.local>
 <e8483f20-b8ee-4369-ad00-0154ff05d10c@amd.com>
 <20250712184639.GFaHKtj_Clr_Oa3SgP@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250712184639.GFaHKtj_Clr_Oa3SgP@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0107.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:276::10) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|BL3PR12MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 70aaf0b7-f657-4f4a-d4fb-08ddc1b2af43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWJ4UUJ0NEpScHNCWEROK0p1a3NIYjEvZFNtODlKZVJOYXpJSkN4VGJUdFYz?=
 =?utf-8?B?YnYyeFFFTTJVL3dlWVFHUTNicVRydktTN3RPdHJyeWhYUytGdDFSVGlkRFla?=
 =?utf-8?B?NXNSNnJDa092YUdMYVBuTGdaZmlvaTdnbVRSSWpYVktSNkx3OTNXb1A5b0Vx?=
 =?utf-8?B?SThESXlLKytldTVIc1UvQ056RWpjOFF1eHgwMUlXK2p6YjJ0QXFFRkplT24w?=
 =?utf-8?B?aFh3eElNTEZYcmJxK1pZZWluYkhuOTVMN0hrMkMxWlNLWjVJcitNc2t3djN6?=
 =?utf-8?B?UE1UKzkrYUtSZjBpby9ZM1VXRFVoVnNsdTlacmdlSDZvd29RMkVqUWVuMnFi?=
 =?utf-8?B?NkJoY01vSW8xRjdLMHRwUWVpSmxrSTg3RkthbmlDaTJBZ1ZrRFg2NmQwVnpi?=
 =?utf-8?B?RnFDVmtqdWF3bWhCSGNia1RES2p3SGw1K25ibTUwM1R5TWdZVisxRGNpRzRO?=
 =?utf-8?B?U09rQytVSU5Ob1R0cHNNWXVzeGozd0RFbHRlOHVmN0NvVWVVVVgzcEw4ZWEr?=
 =?utf-8?B?dEQ5bHVwaDNjS1FRVG0vRDJ5Ty9WL0t4NXByQzlMTitUTzRSYVJ4RnYxejBS?=
 =?utf-8?B?SDFyWVZFeXljRnA2Y05OZUNFcHl2TFhBU0J5cm1vWjlEV2xydVNsbVhwU0VK?=
 =?utf-8?B?QXc3c3h6YnczcklmcmR6bStKOFR0Qk5zVzUxblVTV3B2UFFVTFVMSzNlYkVT?=
 =?utf-8?B?OWQ2cGs1VTM1RytsbFVPVjh0VjBaMXpVcFc3Q294cGRSQ2FXazljcng0YXJC?=
 =?utf-8?B?eHhtLzh6bUtZcmM5am9OMXV5TS9WVFJlWWhsaWpSdUdXM3RESWJIdW93ajBo?=
 =?utf-8?B?UjhubFAzbHQrQUVaOEFReDRCc2RPc1ZSY2ZFaU02VDJTcTh3bElsYXZrOTFw?=
 =?utf-8?B?UVBMMUFNd1hHVFl0LzhSYmZJMG0vUk51cDcwTDV1OUFUSThmakhONFBYMTAy?=
 =?utf-8?B?SnZmRFZaWXd6aGJvZFNXdU9OR2xKSncxd2ZmMG8xdHcxbWFJQnVTNEJGZmxY?=
 =?utf-8?B?ckJlaEtmYXR6aHViNVdNSnE2T0ZyMWFOWUtqSWpHdHZqaXlndTY0N3RkRXNS?=
 =?utf-8?B?bmpBVjUyS3BzZ0l3Tk0rTDA1TndjZ2k0YkprQmQ5c3BBenpTTFhRY1ZEanVE?=
 =?utf-8?B?MERnWUFieFh5TDF0UTJYVUJPKzhNWHA1ajAzS3lJdE5VNkRDdVNEeXJQTHll?=
 =?utf-8?B?cW9GNWh1TFEzNFRCc25LZi9Ja3FGRXVXU201MzRZQTVyRnZUYUtLR2ZMVFhB?=
 =?utf-8?B?TkJDS3FJRlgwM3lpdnpiZGxyYWd5dThPUmRVZnM4aVhpT3Z5MmNCSE5Qc3RF?=
 =?utf-8?B?OGIvd2hKSDZZQ1RkajNBck9QenRTQXg3UnQ5Ky9RZXpIWFJoUW1jempnV1NB?=
 =?utf-8?B?Q09tejR0WFFjQzJPQzNIRFVhTzllUUNCTlBxZ01yeWI5cS82TFhvRlZOVk1I?=
 =?utf-8?B?eU0xYXdXNXhRM3IrL01KQTBPcUpYNVdZMWFEZDJjTjAvZ2dKL2tmeERTUXY1?=
 =?utf-8?B?Q0tocnd0OG9sWHVGSDR2V2FRRDVjd3pRSXNKWStDd2ZUS0ZmVGxRNWozR2VQ?=
 =?utf-8?B?MlBQZ3RRLzNQcWdSbDNEalNFd2greXhmRnFlQitkdURURnEvN1ppWmpLWnVY?=
 =?utf-8?B?Mzd0SW5OS003dERIWFFSb2lVUHBENmJTTE05U3V4TCtrS1h3Z2hsL05sRHVr?=
 =?utf-8?B?REJHTDhIZDV2NzdnRDd2ZHhubHp2T1JJdG1MVU5BdE96RVR4YlhlVnQvVjRv?=
 =?utf-8?B?YWlIbWM2RUlQQ21MUW5BUkpTNnJMeWVjNGJ6TXZKcmlsWTlLSkJDMkhGVkM2?=
 =?utf-8?B?QU9JeDduMVJmeDhtQTRJRk9pQmVpdEtyUEhEZ1lFT0xGOTlMaU5JWEtFQThF?=
 =?utf-8?B?WTRxZzFkY2RaeG41U3JLYzVUODgwaDhkQjdXVFZZRFFJdk0yY255dnZGOVR4?=
 =?utf-8?Q?xPttp8QMc/o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzgvRVhseVRUVlZLRlhuY1lZZmZNVmxmRzJqdG5GRWtZM1dmVGMyYXZyaXRs?=
 =?utf-8?B?ZkN4YVRHVzZBT0JPQmlDOW5aUkc2ajhXQS9nWStkK0ZFY3lDT0R0WDFhTFFm?=
 =?utf-8?B?aXk5U3dFNHZjajc4S3dBc3pONG13b09ObElpY0tGcXorRUc4QkxxTWxWaTRG?=
 =?utf-8?B?SlZVd1U4N3pQcG1HSURQb0dNZG5vT2lmT1hHWFpEOTRpaEVsVHJvQm8vblJp?=
 =?utf-8?B?SVpwdDJ5OTROM0k2Ny9tOGNDcW05Wm9lRnFvV3kxaUV5NGFqemorZ01ic3dG?=
 =?utf-8?B?WlAzOVFnazRPdjNOaVZWVFU4Vm9vSnVTTlk0dGtIK3Ivc29UUVB2L243Z05M?=
 =?utf-8?B?Mk9aV1ZIQStBWTNKVTRVbjRkbGZnVlN0ekhuMElTK25rVm5UQXZjM1lleVNP?=
 =?utf-8?B?UFVzUktZWHQ4SStQRGVzT0liVTlEM2xIRnp2Y3l0RlNDSFpycjVpaGlJM0lk?=
 =?utf-8?B?NlpxVnpYbjUyYlphZjg5c0NjN0E0aFFmcGtOOGxRZnljNHVhNlhjNUo4a1Fn?=
 =?utf-8?B?azdLRTV3bHdOVjJvcSt5bll5Q290K29oMVZGdWt0N1hWRDBNYTZ4TEJ3UU93?=
 =?utf-8?B?VFF6SzBsVHE1QjRhYjZTNDVvc2owYU9obDU1ZitHcG9vNlcwUFZWTVNCaG9u?=
 =?utf-8?B?ejIrZlZoZkhBeG10UXBMTWswam1oRXVQdWVMdE0vSmoveUdkdDF0REZ1VFhm?=
 =?utf-8?B?aTdZdlVUSXZxOC9jM0JoaGNLd1Y2UHFtc2NzYlJVZVA1dWVra0s4K3lwNlJ4?=
 =?utf-8?B?a254UXVBbnlGWC9pMFdqenNMeHV2ZHdGSXRzcjZDbXA3YUc1OURwN0NpU3ov?=
 =?utf-8?B?Myt6MUZUaDM0SWZUOCtJbzhoM3ozNkxRdUVwVUtuTzViQkozVEk4azlmLytQ?=
 =?utf-8?B?ZHh4TEIzUWo3Rm1nYW9oRzdoWTM1WERsZWJLekp5TWFWQzFhdTNLaDlNTGsz?=
 =?utf-8?B?SU1rRTZTNitzTGM3dE80aTNCN0lRemFpSlRIQWh1WVJhWjVXWmFrcm94QnpX?=
 =?utf-8?B?SWdiWSthcWpnMnFCaEEwZXA1dlZMbWtCeEZiVDBIeXovRkFiR2VxTHVBTFFR?=
 =?utf-8?B?U1JGcUl2NENPeVBFejhYNGJKUzU3dmxPOXl1ZDlPaXhUaEZ6T2JUQmlHYU5M?=
 =?utf-8?B?a0hjTnVRaEJDdHFBaFVBUDBkbEEyME9kejd5bmU3UDBBemtuNkNJeFFoWVRn?=
 =?utf-8?B?V1ZXYnJCd25nemM2M1lKZnRxVnRycUk4Y3A2MW9PUXpwK3lXTjVjc1VXTi90?=
 =?utf-8?B?QVRiUTk1T2l1K1hJcS9QUk43Yk1lSnBSZ25vVVVybnZiaFV0VUZhWWgyMFNX?=
 =?utf-8?B?elhlVHA5ZXBwalBRUWExSDI0YUcwUVEvZVdxRnhXTmpKNEl0d0ZpRGEyb2I0?=
 =?utf-8?B?b0tsaGtsaU5SNXREazdYTEtaYUQvN1pRdlZuUUhoWnoxRmhFL082UHJqZitn?=
 =?utf-8?B?ZFhWZ3htd1g4bFU0dysycWRHRjE0MjlBQUdXM0ViZFdHcXh5TEpHdWV3NTFq?=
 =?utf-8?B?ZlQwK01wZjVnMXg2Y3ZJVDZVem05YmpKU3RhNG8zREVZTkY2NG81SHNweW91?=
 =?utf-8?B?YTZDQm0wUDAzUGtCUlFmN2JLYXBSR1N6T0dJUFp2TnBHSCtCTkovWVVpOXZm?=
 =?utf-8?B?YThaZTdORnBtQWZFdUpscy9zUVYxOSswbmw2aWdqdm1paktTakRZaTlWVVJ5?=
 =?utf-8?B?eDVyUkNSM251K1BDZGQ4ZGFibEtBQlRzMGdVUWhhYS81OW5YMUwrY0xRSDM1?=
 =?utf-8?B?QTFESnBOeVFBaFdxQ2QyTnRkUUdDMXNvYkpDMldiWlZXWTloTE1hRkdZaHAw?=
 =?utf-8?B?UEFMd2I1YzRNWEhNd2g1cmhsZ0daeHFKK0tzRGkzVFdGMHB4TENoRjgwU2Vt?=
 =?utf-8?B?UlBIdUF2Y1hHODF4dnlZSjBlYldNQnVDZU52U3pTV2hmeUdHS2V0QjlzUVNU?=
 =?utf-8?B?U1FyTWVQR2h1ekhGSlNnc0VBSTk5a0hJaHQwOFhhQ0NOeldERFc4eStaRFh6?=
 =?utf-8?B?Um1YM1NDOHBNSituOEVVVWNuU0tybGN1R2ZGOFRSa3F4MVVaSDBqcTN2Mmpa?=
 =?utf-8?B?Z1NIM3F3R3dTN2Y0S1RWV0k3QlovM0hwYjBjQk8xSXJUY0Y1SlIxYitkVWpC?=
 =?utf-8?Q?D7DpWi6EIHhUgSeKvOdNqO8IX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70aaf0b7-f657-4f4a-d4fb-08ddc1b2af43
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2025 02:12:14.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtBVkrMvXsBRkx9r3itUyqBQBpnLl5OVXSw7DJaA0rJo0DTKfKDD4S4FCJNAQUxRDEXmso1O5DfQ/0zgY4Z04g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6476



On 7/13/2025 12:16 AM, Borislav Petkov wrote:
> On Sat, Jul 12, 2025 at 10:38:08PM +0530, Neeraj Upadhyay wrote:
>> It was more to imply like secure APIC-page rather than Secure-APIC page. I will change
>> it to secure_avic_page or savic_apic_page, if one of these looks cleaner. Please suggest.
> 
> If the page belongs to the guest's secure AVIC machinery then it should be
> called secure_avic_page to avoid confusion. Or at least have a comment above
> it explaining what it is.
> 

Ok. I will change this to secure_avic_page in next version. Thanks for taking a look at
it during weekend.


- Neeraj


