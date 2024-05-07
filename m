Return-Path: <kvm+bounces-16788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE8F38BDA0D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:09:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E09501C2283F
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F354EB5F;
	Tue,  7 May 2024 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L7XawHrG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4755CA93C;
	Tue,  7 May 2024 04:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054950; cv=fail; b=sEmq78wxP5P8jRzSsOEIHhvyWKfAkFOVNcTm5+eYQsUdDzPOYiJnk/VVKB6b4cjTifA6/zkz7hs+IWU20Fo9bmRHwhQVTXYiky5aOg5zqaHa++HB9PabUfK1wMM2btBOW5tEUcw34qQjXfzr2fxslZAVvASew5E1cOPknqRmRP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054950; c=relaxed/simple;
	bh=PJk8rQCNz/+5dk6DVmUqv+99oYGSUrN7gQIU19mnCPU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eUZojynwEskbllMS+iGw1Zdll4k48BC8EuaYeTH6oGpNPbCjVoeE6NwtYaI6ccZtxhnqDCerKlJD2CInDnipnP/xM5ByLMKQ2xjYJ1zmpIKQu2uUIzA5LU1y/59O8a8K3aIlnE4ctg3xWmi94gjn7nJdwmS1j7WUJ7oYT3HCaec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L7XawHrG; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dt8/mDbWzCAnK7ZIxGxRyoI4YyWUcpcKVlgQHpZoH0qL4hNoGQx6hDCNd/piAWXxxBS9UL4SaiciGQudRmvl0FSw2e5i1qm2YAorSRDQ8impdcVkKvlw9gnxJSWs2+KTpqBed4VK8e0sFmjGcxzwkih2/9MB+c6V8MvkZcjr1omcfKT/siYuuj5zeNDB/64HEOrXvIt7JypfTmiWMv/3jdY13suhspKpk3ospDsM4VEartkp0Ok30X/F+3aHtNO6G7Y5bKmxgiNfwtJMsv3YOxNEjmu1bP736DISktgPktV+04vOPUob2xvnmybeGyLZMujt+fYmE+R0orucfJL/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUUym2ATWSWcx3lQ9Wgy8jvSbvPQxKCaPDckU4hJ7j8=;
 b=k3W+5w3zC69lfOPvWOQblRpJhteZTnt5luoJPOUzkA/Xt37VHMZZFVHQXCayxVK4/DMdUqg3urzaL5yu4fmy7V9hxk3o3dmkyHTXZ7XyXTEd8nFeLrTA0+C288e9o2V7McnOGl4S3DU6cev/haUrgyiTnOhOUMjda/cFxumDszW5CSAE1wz9IacDJo0fpD3mKEf9UVzEIsZMQj+umaiPFB0CS3MVLlvFb3rJCTOVtJHLgmvythjj6e4fH6pGklix0Pw04Yd3eaePh8YOY7XrBpBzVIurDZ6bVcOoD5ooDgNVRVHXWcJxF8CYU+NSg1vKj6foYHBNIf64rg2XUhgDDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUUym2ATWSWcx3lQ9Wgy8jvSbvPQxKCaPDckU4hJ7j8=;
 b=L7XawHrGDOt1cTPPflgQmx8rOIELheeNocc90sqol1RdTtjGWCYkeYqsmaTmpaFjxd2uNW0wThLInUdgPl1goDSqFoYTR3NH0mCIo5wgZOwt4EVtgqb1B8UVJvLdUGmu17G4nxTdSPM0VpN6n5IVfvGPRtptzRlY6U7j7qvam8Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 04:09:07 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 04:09:07 +0000
Message-ID: <ecd2b4c9-32d7-0436-a68b-17b94df85875@amd.com>
Date: Tue, 7 May 2024 09:38:44 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/3] x86/bus_lock: Add support for AMD
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-3-ravi.bangoria@amd.com>
 <bb6a554f-4823-59ce-16a4-48bd5b911d63@amd.com>
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <bb6a554f-4823-59ce-16a4-48bd5b911d63@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: 51b58ec2-3838-47cc-e3eb-08dc6e4b7070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmd6Nis1ZmF6YXRiWUFFMHF1K09DRHJQVExoMzVhSEtCamNmcFR3TjlXbVhr?=
 =?utf-8?B?VlZyaTA5K0o1NzZLRkRCREF0OTRNQlZLYzN2VzJDajBxVXA2TGVUNzJ3c04x?=
 =?utf-8?B?N0p3ZzJHQVJoTmo2Ymk2dE5KbThEOVJXTHNYa1JySTgxelE1RUNCQU12Z1Bp?=
 =?utf-8?B?YzJ4VDlsSTFSYWFzbTI0cDZYc0RoMUp4U3pqMDJNNHpDRUk2eFRDVXkzNEVi?=
 =?utf-8?B?QTRLV0gzbjNCQ1RFUzRPNVgrUThDbWppdXF1Q2FTcVIwbFZMQ1h3bEdQZFVx?=
 =?utf-8?B?QThwd0s5ZWdZNTlLM0tUVnBqL2FwTDhGa0ltY0FMQWFjeHBBdlFFWUlPU0pB?=
 =?utf-8?B?YXhFRkhVUVJUME1SMmZadTdYeVlnVysxVGtabGpzb0tEUzRwb0NPNzhraTJ0?=
 =?utf-8?B?WnQ1MjhJeFJQM084K2ZVTmoyMGJmeE05VVlIbVhMSEp0Y05LNXUrTFlWbS90?=
 =?utf-8?B?bE9oQkxQaXRUbXhYWCtxSkZTcDl3WjhZQkR6eGY0YlpzdXU1MU1oOW0zZWpV?=
 =?utf-8?B?QzJ4US8zUUQzTHZhNjFkWi9xYVlqMlB4cE9BNTF5TXlpMWREZDl2THhVcUJn?=
 =?utf-8?B?cVI2RGM4eit1K3BTdEtKQ2llUE1oS003d2ZzOWtDdVhvLytTdFlkYitMb0Vz?=
 =?utf-8?B?QURXUlRpZ01yWFkrQnRyeWdPTmpuQk8xTWJXTVlsWEkzdnJJaTVOQWdCMGRJ?=
 =?utf-8?B?bGtQeldvL1dQZGNhQnpFWm9DN2ZuOFFNdit6YTBwMzlOcXg0LzBDemFJWXM5?=
 =?utf-8?B?RytCSUpoamYzU09sbmV1RERBS2gxbkJJSkF3d2d4bDdXUDZwMVBzSVpVZGl3?=
 =?utf-8?B?SVNEMkRTOUlxNCtkMml5WHlycFFBTGc5REhoWklJbi9VTTlubytUMnhPRzJo?=
 =?utf-8?B?WUYxNDRmSjdFMlM2NHl5VlZNVUpjUk9TK25tTEZpcGdFVWZ0VFByVzUyNXNX?=
 =?utf-8?B?T1JzaGMxTEk3ZWJtTDdNYnF6dStTSmh4ZXd2OFo4TDMxdEZaN0tXQUE3MVlu?=
 =?utf-8?B?czNNbjAzbnhmT3BweXNvWjRoUmxoRjRsTktGRWNQeXQxckxDdmJ5N1ZLOWZa?=
 =?utf-8?B?cWtRR3dmZXZWcUtiWTBjVHo2S2FhSGJDemF3TGpMeFdINllQY2pseFlzdGhV?=
 =?utf-8?B?Zk0xbGNCRzhHUW03V0FyL3JrbUxtN3F3amtycWc2Q3FqdWVOK1JyNXI5YkV5?=
 =?utf-8?B?ci9INWRRL2ZITVFZZk04bnlCR3lqcFkvNjI2TGdFaDdma0FRWVZ6NHp1QWl1?=
 =?utf-8?B?UUpyMDM3RTRNbEtCL1JTeDZRZlVkR3NoVnFMNVJqSnhLMDFXZzZkTjQ5ZW5w?=
 =?utf-8?B?cGd4ZHIvbzJUL1VPZEtURGdqVDBzbG9tVlpHb0FrRlFhWnhVa3pQZkFSNGpD?=
 =?utf-8?B?cURlL1M1VmRWUzBQcVJZRnpnOTR0YnJJd3ZqbFhrT3R5OFd2U3lDaDZMTlJN?=
 =?utf-8?B?L2FzSWViM3hhemRYOUdHN1JkbEVuWkVYZjdzOU1RaDFhTlNsODEzcy9CWmFn?=
 =?utf-8?B?TTVGREpOanNBMGp6aHl6VWpqWFNFc0lFRnd5VDZKZ1RMazFJeVB0MlZGa3pJ?=
 =?utf-8?B?WnIxdzdER2g3eGhVNzJ3eEdDZjRyL200WlN5S2pxWE12OUVBSGhkcGRaTnlU?=
 =?utf-8?B?VkkybnN0Tk5ZRlo1djV4ZXdtYVBVLzh5R25HSko4ajdSUVpjWUR1QW8vQTk0?=
 =?utf-8?B?ZFJ0YklxTGdIMllGWEdKVTFuaFpRT2FRbjhIUXZkdUVGcWQySDNCSUh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFZtVjZRRTMxSGNTcVc5RHBXM1k2bkY2cC9DY01BdU0wc3ZGeEFmL3lHYWY3?=
 =?utf-8?B?bVo5dlBzd1BsQThkUmwzQWZsa3B6M2I0V1R1UTNzOUI5bFVpVklxT2EzTU53?=
 =?utf-8?B?U095VWdGZHY5cDQvbVRsQTRGZlJyOWFpbjhPOG1XRkd4aUhINUlyNDVZekV3?=
 =?utf-8?B?c1NqSkNkYjlpcEtiYVFnRFFydFVlSVRhbmR6V0IydkJ5bzBqOTFYQTN3c2FB?=
 =?utf-8?B?bVdnVFNYeEExQUVWSUZjalQrcmtwaDFVNTRYcnBKSnVrc1AreUFDVlE4djNu?=
 =?utf-8?B?cTk1dzM5cm9HSnpWZkR1UnhBVVoyaFk5c2l1V296WDdScVpwdU4xdTRUVEtG?=
 =?utf-8?B?K05KNUJTTHNaT0IxMGZPTW5tZlJLQmpKdnFUYjRUMlRqYm5QVWgvOEdrYW5E?=
 =?utf-8?B?YllHSUlndmlFVVBGUSs3VFQxYUlNMXNmaHlwRktWd1BFeGxVdGRCdVZlMU9j?=
 =?utf-8?B?aElhTkdoUUdXd2FvL05NTVM4MW8vNi9ac2FDZkduYzA5SUNocklqOUtsNEJo?=
 =?utf-8?B?NWpNcVk1T2JkYmlIMlBNODRJSVppNXFVZVlkcXlOSGVINEkwWm9XL0F2VDRY?=
 =?utf-8?B?TmlkRENaTlF6TG1ZS2FJV2lsVGEwMzVrTmdiTFVLbDhrbUNMeXVuMW1BSmVR?=
 =?utf-8?B?d29mbGFFYUN5T2xCaHVLNjVwTHdkNTZYb1MrMkJHdUxIbExPQWREckROQW5q?=
 =?utf-8?B?UkN3RjlQWk9pd2tiL2UyV24xQTBTVTBoL0JtNWpPRkVkWmpaeVBwTDVQRXZW?=
 =?utf-8?B?TkxPWU4xYWZJN0Mxc3ljMTNYQ2xpZC92MjRENEE2MkZqa0ZNYWZOUko3V1FQ?=
 =?utf-8?B?T240V3BaMndFS2h0enFaUE8wbHdlY21LY3I5UFh1VGxlUmFvS3NpM0lUTGp3?=
 =?utf-8?B?TjBuNDd3Wjk3UG92ZHpsZ29KNERRQ1RVdTRDc0szR1ZHa3VIbEpLbDlqdVdp?=
 =?utf-8?B?MnpiT3pTRThFaHJReTlrcTdxQ1JnODNaelZXeXNscjlrT1N0K0FJWjdFN3gx?=
 =?utf-8?B?OEM4d2l3NTlwdXBZekFwRVBvV3I0UXMwQ1dKTWVIcWhkekFrZ2FiRVYxaVZi?=
 =?utf-8?B?OTREeVJkb1ZOblNLbFFHa1dMRWxEYmJtTjNoQlJTaWVwZXc1Wm9pZnpodlVF?=
 =?utf-8?B?Z3NDTDJVbnViVHgyeWc2Y0phTGVuYVlUQkcrQzJGdXZsOEFGbkoyVytMRWYv?=
 =?utf-8?B?L0h6elJDMVdJSG5PK3hITlZvbnVmSEV6cXUxcVc3RWRLUlFKTVdTRmF3M1ZM?=
 =?utf-8?B?bmpaeEd4cS9oM1N0Q1htWmdYNGFHOHoyZVhOUW1OZFcyd21ZZ0NEUlhnd1Jh?=
 =?utf-8?B?U3AwTHRsT2ZZd0Ewb0wvS0hUdWJLSThDbVJ3Rzg4Y2pGS2FpbWJtcHNOMjc3?=
 =?utf-8?B?azg5WUk2aWs5bXl2eWphTU1JRTF4UE9HTnlGOGN3RFZpZm8xSHczTHRORHBE?=
 =?utf-8?B?amd1NmVEMHRNV1lLYWFnS3kwbVN1aFFpbTZ1MWJRakloLzVVbVJJSzNSWG1C?=
 =?utf-8?B?dTJHQ1dYWlgxeDF5cEJWUVhaT3k5N1JUaFFZQlZ0MTdqY1hYNUNRSFl3QnRp?=
 =?utf-8?B?V2dJTzVOUDdyU25KdkdxcURadDZ6dGFNT0RnZXVnRUlXSU5nbEFNUTN0RGxB?=
 =?utf-8?B?ejk0a3J3Sk82VWpCU1h6VElOcFR3eWhqZ2t5NGN2ODZOMG1PMk9TanFiTTc5?=
 =?utf-8?B?QmRjdHNoejE5VlRaSHN3NkNjN3NLUjFXV0Z0b2tYbUVSOWx0MWt4NXIxYWI5?=
 =?utf-8?B?c0dDTE4xOTRCdG9SczE5MVBJY2Z5UjVmcFM3c3Qvd203YTRvRU9Ic1JxUGJZ?=
 =?utf-8?B?SG5DK3BBUU11WVFCamRORTM0T3Nyc0xxSlkyTllyTGNVMXk2Qndnbkp2RHlU?=
 =?utf-8?B?NjRITVFoeGNkNVpGTmQ5MU5SQXExZ3EzNXAzZk1ZaXJraXp3VWZvd2FXZDBv?=
 =?utf-8?B?YVArd3dHUVNXMHZ5ZzdxdFIxZTR0MzhIN2hnUkRHVlVrd0VacGVHL3Z1OUhC?=
 =?utf-8?B?QVBlZ3BJYVNSWmp5SWJxVFljY0hTcmFUYXI0NmdaQ1hrZVlNa2pGZHJkRkF0?=
 =?utf-8?B?WEJjT21FZk9ZVDlUWmNXN0N2NlJ2eGk1QjV1Ti9ESkdRTVlwbGptMGx6d2RH?=
 =?utf-8?Q?o9Q5zsuUKqaqLyLbZU1NV7N/7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b58ec2-3838-47cc-e3eb-08dc6e4b7070
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 04:09:06.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OxqNPK65HLM6boAZGldAFBlshTWpOXK0ytd9fEVMUu0MvR7HFdfAwzaBfabWJaYgy3/hcIK87blFYFNDHEdhwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index 39f316d50ae4..013d16479a24 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -1058,6 +1058,8 @@ static void init_amd(struct cpuinfo_x86 *c)
>>         /* AMD CPUs don't need fencing after x2APIC/TSC_DEADLINE MSR writes. */
>>       clear_cpu_cap(c, X86_FEATURE_APIC_MSRS_FENCE);
>> +
>> +    bus_lock_init();
> 
> Can this call and the one in the intel.c be moved to common.c?

Makes sense. Will do it.

Thanks,
Ravi

