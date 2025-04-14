Return-Path: <kvm+bounces-43211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68852A877E9
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 08:32:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2813AFEF4
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 06:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449991A3175;
	Mon, 14 Apr 2025 06:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jpcsFwZS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07A02F32;
	Mon, 14 Apr 2025 06:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744612349; cv=fail; b=MaIHbBFA1ZeXs3e/ZA98tcBSRH+MBVLNwx46RBSNALFUxNCRmC/zWMe2c8pswoxe19toYoWjG13GmzTPCBXPaPc3qXB5OmFs4ElYD/KkX4TYa/nchSXpeQb0Q/w3wrKi/ba5RXZZqBsl1O58bO32Ct5fB+rCpGbddq1o8Ga7SZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744612349; c=relaxed/simple;
	bh=ViRyzW5MIwR6psugui0GYI5lAx0D6C+xxBBK60sD3jU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n+NpTVGWrJl/c47WNfM6MXyVJX7z7Uoey8O29lim/VkGApMt4S2NQlhM6AZBJO9u2cBhmXF95YCdLQvx8JorM7av9XBNF/nMJo4ow65XCwLyeN3uqPLScJovMq/Za+dmQi2EsZ3Z15IDXQnKBrJx6ATfL61PmB9xeYmCG3c/AGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jpcsFwZS; arc=fail smtp.client-ip=40.107.94.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBdzjQ1CTwWRGqeyfNcXwirWtPNoqqnXe0xAT8D549MFem1Qv6ZPGnsARYqXNfoidIXzbp2xUXPwo4ELyrLBOrenV+UyE1DjJ4NwLBEFHa7LGfHxdvHmmy5Wh0ZFuSroV4wBwBPQsNBpd6dd2iIEPP21zl4w66Ps5gGBRR63S3RJX/+A8dO9YAgB02gEBUmr3R8hbcYNRfXF1yMzFbZOWJuI0I0LcoHiWQ+5cr6U6eMzM2IB8vmUosbeSLUDpEEw63gYBE2kUfmFH6kHgSNojCxayZHMHYfjnttvd9gPIJ431R862U82FCZ/HhZLxM+LSMNiBOfHebMSCYi0C6Z4jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71pM8UARxlJs5LtV8CFsbZENIidxjZfRIUBbmHn51P4=;
 b=YalE/4MUNkJZMoQbnPIX15iwHIwjFazIMMEUDVc0twzzv0QZC4aIcb559Pm5GZqMwS2YAoV3d+05ezQO35XFF+OpO/1VWPLRelU0Ahe502rlT3xYzIU8mXhkXj3z9zq5KzCp8FyFModrSBwp+eXIAHNx4IAu+hR8jlZcBv5pK2P6J3kMHvUrLBWnzWFv1JN9Xtx/uTYU8tBnBew6uyBpB8HjDkLGheAzl8hLn2Kq+yoMsF8joXV7fIra1OEM0DP7uVsXbxvYMHL7d8UiUgEHK5z6bikW6dhgSSngKXyKcFXwCADSlZ3WAUE30zdpWpF7lBvvH0Ql3gWxk+GtVRVYzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71pM8UARxlJs5LtV8CFsbZENIidxjZfRIUBbmHn51P4=;
 b=jpcsFwZS0xlxS5JkVuiMkKySKI9gxVg+M1ly/JATKKKZXy/kmFMyKdaOvlD93cdioKgFk4qBrDaoiQ6Q/kamq6y2JUC8jqbSceLjT69dyx4j/+CEeALxNwUmIz21VJ0Z2+279yDf0qZ1nwo5EG6gXETTho+5FiiBKYGuaF3Ye/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.32; Mon, 14 Apr 2025 06:32:23 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 06:32:23 +0000
Message-ID: <3bb22f41-9218-47c1-8a0f-c484bdaeb9eb@amd.com>
Date: Mon, 14 Apr 2025 12:02:15 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
To: Sean Christopherson <seanjc@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ravi Bangoria <ravi.bangoria@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com,
 whanos@sergal.fun, nikunj.dadhania@amd.com
References: <20250227222411.3490595-1-seanjc@google.com>
 <1b0fbad5b2be164da13034fe486c207d8a19f5e7.camel@redhat.com>
 <Z_WmdAZ9E2dxHpBE@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <Z_WmdAZ9E2dxHpBE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0023.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::13) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a907365-182b-4547-9f02-08dd7b1e1d37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWRLZXI3UDhFRjdUdWNtSUVRcGtPTnd6RzAvUkNONGMzc3l0Y2J2citMZFFS?=
 =?utf-8?B?TFhCUFViNDZCZUxJc0YyMUlHOFpEbTZITzgyeVhKQ2NqUk8rUFZSb0xaeEhL?=
 =?utf-8?B?aTlvWVF0MW5helFSbVBNR3ExQUdCTG5jSjJySzliZ3N3cXhncG1mUGhyUHRE?=
 =?utf-8?B?aFgxdkw1TEJxRHZlbGlKck0rWUxsYkt1ZUMrVTlZZDdZOXNIaUJ6ckVaK2RC?=
 =?utf-8?B?N09selJBanB4a0l3Q1Q1RDlGKzdrN0gzOTltRkhndGF5NjhEanpldm01ZW9O?=
 =?utf-8?B?Tk9FNmZCbC9tY0pqTlNJUitKNVJ6ZVVmWU9GcWM1bEE1TG1qRngwalVhK2lk?=
 =?utf-8?B?RTMwa1BBM1FlRTVncmQvK00yNElxdkJwVGZHQU9kOXJtVkgzZEw4WDhTb1U0?=
 =?utf-8?B?QkYraVdIS3dNVVZvWlNJUVpzTWVzUlFQNE54SVNPWWoxd1hZcDhJMFRBckJ1?=
 =?utf-8?B?eUVDY3JFaEpSaGpXT2J2MGcvb2FQdmFRMjd2Ty9pUXFxRWJhaHpweGpFVFlv?=
 =?utf-8?B?Z0gyVGl2TmU3T2ZpRUxlVkFZT0dpVERlY1pJMGtra2l6eEg5YzdCQ2VxdjFp?=
 =?utf-8?B?RDBMaTBZM1VJWFhxRDMrQmZ5T3ZnK3NpKzZscS9zdk5BZUNTdDRaem8wdE1u?=
 =?utf-8?B?V0lIZUhwYm1NT2hYM2xjUmhxcnl2ZHdMNGdhZkhSV1A5V0YxSHNmQTc2MUR4?=
 =?utf-8?B?Y1U2YWN1MzlVN2pTeWlXU3ZabnVpSHZoa21jQWxtN2RzT0lvZklCTnhSV1h5?=
 =?utf-8?B?MjU4ZVdmN2VUMHFrZGNOMFhTWnR4a1FHd3ZHTHd1dC9SRDRPb0Z0MDN1bWFr?=
 =?utf-8?B?ZkRqNzh3ZGFyV09uemxUVk5IQ2JGQ3RqL2dmenF1MmpJUzFZT3ZLQW1QV05q?=
 =?utf-8?B?d1ZKU2dBLzBuRG9aZHVkTmlseEZDQjJTL1ZPVWhxb2ZrcDNqM2xUZEVLK0pD?=
 =?utf-8?B?N21KSzExY0Uvai8vcG9Ua2RlZkg5cG1BT1lLTk9oQzA0RU1DWFU5THUzanRK?=
 =?utf-8?B?V3hycHRjTmNXd0lUSzRkRk5EYzFhdk1NSElHL254RkdZTUJKY3ladEY0M3ha?=
 =?utf-8?B?MW9SNGNpY2xnK2MrNm9ZNGMyV3dLb2hYbnM4TFl2alA0L0ZRUW9mcXIxYnZX?=
 =?utf-8?B?cE54VGx5UmljQVpiTENuTjJvS0R2N2VYRmwrTW81VEZHZGh4RHBZYzRnMXpy?=
 =?utf-8?B?MmZEa3lnclQ2TjJxeStZbU9pTklpaGE0VHpxMFhBVThGYThIempLaTgrTXZq?=
 =?utf-8?B?cUVoZDY0bCt6Q2xPQkRGTTV4UytkV015Y3ZWT3ZxQ3BrY0xvcWM3WUVMbjhR?=
 =?utf-8?B?OEhBRmJRWEswS3MyL3dXRUNZaGRsTGN3TGVMT2E3T2d4YjR1TFRERlNYMWFG?=
 =?utf-8?B?Nk93OVNOYy9OTzhGUjAwYW1EelN6M3ZiNXFuVnZ5K3puM0lySUZTRFBNL0ZL?=
 =?utf-8?B?d083cDkxSnVOVll4UjN4NXBHa2cyNUtidzJ1ZStjcndLL1ZKWXE1dnYzQWQ0?=
 =?utf-8?B?cXVtY2Q3SEpCdFRMT0dUR09yUjcvUHRWSXUrdVZkYUZSZi91djBWRlJ1WE5t?=
 =?utf-8?B?RzBHampLbUYvNm5mZ3J0Z1dObjhFM2FRTXc1QXo2VUwrdFBmNE5tU2dmSlUv?=
 =?utf-8?B?WlR1dGhRd2hMRzZ6WlhnZmF3ak9sdmFzSXRyKytQa2dzcEIzdC9vSCtEMUtF?=
 =?utf-8?B?Sk5mcktJUkJWeFdCeEViM05wMGNMY2pEYXFTdjcrL3JpU2QwbTR5ZXlhZml0?=
 =?utf-8?B?TElpYUI4MFpCNmxBMExES3pmbXhFTlgrd2lIajlySHVTbVhlWE5WSXZiQW9N?=
 =?utf-8?B?SXUxQ2VFbTFDUEdjKyt1YzAzRUNYOWRvZExKUHJEY2l6T3FCUzNjTEtHSXRh?=
 =?utf-8?B?eXdSdGt0NzFGbjVKV0gzTWJIRXhCMXdvSHF5eEV0eXZpLzl5c2tyTDFlOFRr?=
 =?utf-8?Q?5GW1HO/TYOk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjQxM3JzRjVnc2VsUHd6eDRENitOd29pZEx2S3hDK29yUmE4bnZKVDJWVHFZ?=
 =?utf-8?B?ZEw0VkMzTXdLbjZVaytMeHJYYTlOZllhNXVnbWR1M2RsdTJJVm5HdDBoMTU3?=
 =?utf-8?B?cEh5VE8reG14ZjY4Mk1EKzZveWlGbzFwWVptRWxHcjRBaG1iSUZyMkhQeFZr?=
 =?utf-8?B?TlZzMlRSREw5Q0NpRWo3RjhaVGU4V254WnArejdyZmVPZVQ3eVhzQkROSzRV?=
 =?utf-8?B?VmZsRzlXZWVpUG5LallkY0xWWWY2dEFIQnlMYWpnZXdnZURDdGxZZmRweXJp?=
 =?utf-8?B?ZTJ3ekpCNHh0eXVhVnlHaUNNb1hXVEtvTHhYcUZxeTJHSk14N0tHcGZNaUZK?=
 =?utf-8?B?Qjc3cGVWSEFlU1E5ZXdPTXViUzZSbFkwaDBwUGhZaFJhNlVXVlZoRkk3L0FB?=
 =?utf-8?B?YVQ3Z0YrdWxYRlgwOFN0Z05TeCt5TW9aM0VjNUpYSlI5c3c1VG92d1h6OHJW?=
 =?utf-8?B?RWVpVGFXcXhtTS9GRjlLTG1HaFJJelI1bG1lckNwVEIxMml0K2ZFR1Bidmw4?=
 =?utf-8?B?OHI3enpLbmhORGUxUUxVVWt5VS9lQkhUM2tjYW9XaTEwdkNzM2ZFc1Q2R0pm?=
 =?utf-8?B?N1ZHZEUxajBzbFNiQys3QjJ3T0psUEI2ajhVVlRvZktSNjlGZkMvcHZvSXdI?=
 =?utf-8?B?WDZXakkybWZXRzRXU1VGb084eHNYT0MxVU15UDJkSWh0M3pZK2tOV2VFMDFT?=
 =?utf-8?B?OTNEbHRvT2pGWFoyUUFmUU1qZ2w4TXBkSE5FM3gvamI2a0xpcTlMN1RSL3Uz?=
 =?utf-8?B?T1lpRmcyRHNaUzkrcmtMd2xCa1lMUGRveGxDeWlQbEpJMGJCRm81U2Vrd0Q1?=
 =?utf-8?B?Skk4b1RTNVdYNXBZNXBwVFMyQzMrSm1uU1Z5Y0dLRW9mUm5STC9KTUtwN0xa?=
 =?utf-8?B?MkZjTXhFU1BTWXp5RERYSlFXUE8rYWwrb21la1hIMmFzamY3ems1d2wzdDZ4?=
 =?utf-8?B?K2poN1BxRkhtWmRwMWV5VXhjNlFRand3MkRIMEZkeGhTVWhxa1FDRDZKVURw?=
 =?utf-8?B?dERGMVBIYjcyZXE1VjBXclIzR3BrcHBBQ1dxNGF6L1FhSHhNa1J0di9sbEJU?=
 =?utf-8?B?MGsreG04UThrdzJVYVY4TEFjdXZJZ1c5U044ZVVTVmVSUlI0N3ZXVGpQeCs2?=
 =?utf-8?B?bVd1M0lmbU90VUxJZGhYdDRuY3FCdmM1eHJqdW9wcEIzcFFzVHZnOUdGcTVa?=
 =?utf-8?B?Z2hycWdBazc4U0kzUEJtYXlvSnBxQ2daaGpWWnE4Z0JtRUhiK011cVRERUcx?=
 =?utf-8?B?Nkl1aU1RK1BVQzVxV2VuVE4xRGlwdmoyQ0x0VngvOEtXRTR3S0ZvYVh5MkNM?=
 =?utf-8?B?VGdBRmM3dG93M29YYzhiclV2WHVRZzdhaGpOb3hQU3BmWll2K1FnbWdPZlBM?=
 =?utf-8?B?dEt6KzdwaGQ5MTFmVW1lMHMyazNiWlVPNFNpSnNJdDgzVjJvdzI2L05vZEpR?=
 =?utf-8?B?U0ZtRlFES2JiRHJjMGtTSzRNWHhKWDZDZE5QR0FKeDlxWFFWS00rSVBGK0to?=
 =?utf-8?B?NW0yY1JIbkJ2bkd1WjJ5eElIS2Fzbk9JNkJCMVlyL0piaWtoUVNrVUo3TjJK?=
 =?utf-8?B?ejV4RVRnQnNyaGJrQ1Jqa1RiVHl3R2FqY2ZZZjVkRlgyUTJNODg3eXh2dmkx?=
 =?utf-8?B?RVZHNmZDV29GVnVEUGNBT256U2J0M2FlR3NuWEpWaFBqT0RkVml0eEdSbXlV?=
 =?utf-8?B?UEdZTkZNd0o4bUp1Wm50eEdpc21aQTYzbFErN0dneElkcHEvbW5Fb0JqRFpT?=
 =?utf-8?B?bDRwM3NtbFdOZzBEUEdjVjMrSFJzV2FLZS9CMEE2QmJHdVBoQ1E0SFE0Tnls?=
 =?utf-8?B?L2dzRTdJSGEvT2VDblYrM09remJZRUtjd2JqalgyeW9xVk1OK2tzVmhGZlo4?=
 =?utf-8?B?YVpaekREUkl4Z2hUQlNjUWU4eVBPNlUrMnl1MDdzTldzQ1VucjlwNStDNXl1?=
 =?utf-8?B?RGVtTHRPaUJZV21JakpnU3pNcHBUei9zRVJqdTduSXJIZmx0cEx2cS9tZ1Az?=
 =?utf-8?B?bVQ3bmlBZnkyZU9IamMvejhaOTlxR0w1Tzdzc2hHeHMyNHdpdC9IU1lWRGVp?=
 =?utf-8?B?WEF5Q0U3YUdFa1NPWWRWMGRTOTFyOU51eFptZ0FRUXcxWG8vRUgxd1M3K0ZU?=
 =?utf-8?Q?hFrgkOrlMUJCbKIAL2fUNROmF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a907365-182b-4547-9f02-08dd7b1e1d37
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 06:32:23.0614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvvYs3ZbB+kMGimc64n5cz1v92w814GGTQOtnkCrCT2WdhThtiwPhHwzz9o35BZj3ZeO6lF+rRi+QUEHy55KBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

On 4/9/2025 4:13 AM, Sean Christopherson wrote:
> On Tue, Apr 01, 2025, Maxim Levitsky wrote:
>> On Thu, 2025-02-27 at 14:24 -0800, Sean Christopherson wrote:
>>> Fix a long-lurking bug in SVM where KVM runs the guest with the host's
>>> DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
>>> context switch DEBUGCTL if and only if LBR virtualization is enabled (not
>>> just supported, but fully enabled).
>>>
>>> The bug has gone unnoticed because until recently, the only bits that
>>> KVM would leave set were things like BTF, which are guest visible but
>>> won't cause functional problems unless guest software is being especially
>>> particular about #DBs.
>>>
>>> The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
>>> as the resulting #DBs due to split-lock accesses in guest userspace (lol
>>> Steam) get reflected into the guest by KVM.
>>>
>>> Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
>>> likely the behavior that SVM guests have gotten the vast, vast majority of
>>> the time, and given that it's the behavior on Intel, it's (hopefully) a safe
>>> option for a fix, e.g. versus trying to add proper BTF virtualization on the
>>> fly.
>>>
>>> v3:
>>>  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
>>>  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
>>>    it's guaranteed to be '0' in this scenario). [Ravi]
>>>
>>> v2:
>>>  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
>>>  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
>>>    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
>>>  - Collect a review. [Xiaoyao]
>>>  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
>>>
>>> v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com
>>>
>>
>>
>> Hi,
>>
>> Amusingly there is another DEBUGCTL issue, which I just got to the bottom of.
>> (if I am not mistaken of course).
>>
>> We currently don't let the guest set DEBUGCTL.FREEZE_WHILE_SMM and neither
>> set it ourselves in GUEST_IA32_DEBUGCTL vmcs field, even when supported by the host
>> (If I read the code correctly, I didn't verify this in runtime)
> 
> Ugh, SMM.  Yeah, KVM doesn't propagate DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> value.  KVM intercepts reads and writes to DEBUGCTL, so it should be easy enough
> to shove the bit in on writes, and drop it on reads.
> 
>> This means that the host #SMIs will interfere with the guest PMU.  In
>> particular this causes the 'pmu' kvm-unit-test to fail, which is something
>> that our CI caught.
>>
>> I think that kvm should just set this bit, or even better, use the host value
>> of this bit, and hide it from the guest, because the guest shouldn't know
>> about host's smm, and we AFAIK don't really support freezing perfmon when the
>> guest enters its own emulated SMM.
> 
> Agreed.  Easy thing is to use the host's value, so that KVM doesn't need to check
> for its existence.  I can't think of anything that would go sideways by freezing
> perfmon if the host happens to take an SMI.
> 
>> What do you think? I'll post patches if you think that this is a good idea.
>> (A temp hack to set this bit always in GUEST_IA32_DEBUGCTL fixed the problem for me)
>>
>> I also need to check if AMD also has this feature, or if this is Intel specific.
> 
> Intel only.  I assume/think/hope AMD's Host/Guest Only field in the event selector
> effectively hides SMM from the guest.

Just using the GuestOnly bit does not hide SMM activity from guests. SMIs are
generally intercepted (kvm_amd.intercept_smi defaults to true) and handled in the
host context. So guest PMCs are isolated by a combination of having the GuestOnly
bit set and the #VMEXITs resulting from SMI interception.

