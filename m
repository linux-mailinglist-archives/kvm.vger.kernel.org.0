Return-Path: <kvm+bounces-58189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52838B8B32A
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:34:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 854417BB86B
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 20:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E80D2571BE;
	Fri, 19 Sep 2025 20:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lG1EEF6Y"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013017.outbound.protection.outlook.com [40.93.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E121B199
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 20:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758314025; cv=fail; b=c6MKS9WYfbPT2uXcgMNFaZN/nWfp8ZLM358v+POzccCdadplHSSgywkYgE3CKaRbnKxpE6sIF0+HuHHGNace2gmtPtvFLUJV7xtPm3nlJvQTqpPImmzcM3BAgLNPM7/Yhyi3wHfl8F4hNSNv95CV0SpkD7xgtlKYXi46TQkXLLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758314025; c=relaxed/simple;
	bh=8dcRc2RAxX431IExcgjAE4/8cR4Kt/qPcqagyn5y8yg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XBB5QCvOGv6kkCHaWYExY7TezwuNcUstLlTtry0sarhTlpLgaS2SJtGDsos4/n/oGGjYWYsTxJBdreRa/Ze0RnKBR2C8wlOZKfD2eeW/XYAJYjeGfIWSkHgbluChLJ0wXyhxSYQYptK0zV3Mz8YxWmlupptbZ4KzBU5KXpwIB90=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lG1EEF6Y; arc=fail smtp.client-ip=40.93.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ghd33wMpvwQMzSrpUMShY7T1TORMKctIxu7Zn5co4RktA2IjhppiOd3YIZpA6G1cKNcoYKDjLh35aL1pIfwod2JVws86rg9GoMWJ8OtfKN/pEG6pT8W/c6Vv0dArOV3MO4qoxmMA4w6HVDAvNlqWw8kD01MpFzc1kFAQeA/cB+7ekbUT3vO9/8Lq5ru2o/zl1Bbp7O51+Csfovl98pZZd6gJgpfuU3l60eRQkXgQzJJfSLg9rofSLGRzXWKbVgQ2Q+90LzGnibaa7HnYDaDK9ZplCIfdVfDKDyvGFw2Yb4BMfrgOiAj7IYN5kSNQ4tSR4DRDvajo0K8yE3rRtzlMXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eXIllE4cDH29X37uqFackrx+pB3QOK0oUpWIzfmslI=;
 b=S255eM8tjLkHd7fp4lv0BTrqHwlkRArynWdmKR6nAl2U12wTlfpunpDqEn8wZmLKebY7IjEEKDWktkaYS+n29gLavbqpNZ7hrcDWM5LUoVQxvvL3Vj0lH4+Yw6Nz7ED5NKJXLwuLp5OYc2WcHtB3UUPqrxUIR4X+qAH/pQMbhahQpRn//Ye3cCm81HyG5pRgwLnxxc4mD9LjwYQAniPVcs8/px32GTgzY8smXxrJWOEVBiH4quPu5QhSLre9bzc2yuafMwLqDISj/JRTPVdMae0Y1oIMbInJpx1A9zTx1mRK2cBniIy+daKAVaf38P7sP/4vRHmRjyTGXEUj/HVRZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eXIllE4cDH29X37uqFackrx+pB3QOK0oUpWIzfmslI=;
 b=lG1EEF6Y7MucEm6LZW8NK+O1afjN6iJRL+Z/hUUmjBpbsngg18sYdZaSoJmOW8dCM/G+L1+NNaFENkQLY0f8Z7IIjUXsO4PVV0XfKicSn2wCvoe697w0NncwOEDfn3mdYCnzg8YIi6GtshYTAHJSx4RlF42TDOi7/SgmyTcfwXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA5PPF50009C446.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8c8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Fri, 19 Sep
 2025 20:33:42 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 20:33:42 +0000
Message-ID: <b61ced45-c7fe-4fd8-a3ac-bfa9d527bb3c@amd.com>
Date: Fri, 19 Sep 2025 15:33:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] target/i386: SEV: Ensure SEV features are only set
 through qemu cli or IGVM
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 Nikunj A Dadhania <nikunj@amd.com>, "Daniel P. Berrange"
 <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
 Zhao Liu <zhao1.liu@intel.com>, Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758189463.git.naveen@kernel.org>
 <f9b23c74b04177f0dc088a246bdacf1cb158c35e.1758189463.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 xsFNBFaNZYkBEADxg5OW/ajpUG7zgnUQPsMqWPjeAxtu4YH3lCUjWWcbUgc2qDGAijsLTFv1
 kEbaJdblwYs28z3chM7QkfCGMSM29JWR1fSwPH18WyAA84YtxfPD8bfb1Exwo0CRw1RLRScn
 6aJhsZJFLKyVeaPO1eequEsFQurRhLyAfgaH9iazmOVZZmxsGiNRJkQv4YnM2rZYi+4vWnxN
 1ebHf4S1puN0xzQsULhG3rUyV2uIsqBFtlxZ8/r9MwOJ2mvyTXHzHdJBViOalZAUo7VFt3Fb
 aNkR5OR65eTL0ViQiRgFfPDBgkFCSlaxZvc7qSOcrhol160bK87qn0SbYLfplwiXZY/b/+ez
 0zBtIt+uhZJ38HnOLWdda/8kuLX3qhGL5aNz1AeqcE5TW4D8v9ndYeAXFhQI7kbOhr0ruUpA
 udREH98EmVJsADuq0RBcIEkojnme4wVDoFt1EG93YOnqMuif76YGEl3iv9tYcESEeLNruDN6
 LDbE8blkR3151tdg8IkgREJ+dK+q0p9UsGfdd+H7pni6Jjcxz8mjKCx6wAuzvArA0Ciq+Scg
 hfIgoiYQegZjh2vF2lCUzWWatXJoy7IzeAB5LDl/E9vz72cVD8CwQZoEx4PCsHslVpW6A/6U
 NRAz6ShU77jkoYoI4hoGC7qZcwy84mmJqRygFnb8dOjHI1KxqQARAQABzSZUb20gTGVuZGFj
 a3kgPHRob21hcy5sZW5kYWNreUBhbWQuY29tPsLBmQQTAQoAQwIbIwcLCQgHAwIBBhUIAgkK
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAmWDAegFCRKq1F8ACgkQ
 3v+a5E8wTVOG3xAAlLuT7f6oj+Wud8dbYCeZhEX6OLfyXpZgvFoxDu62OLGxwVGX3j5SMk0w
 IXiJRjde3pW+Rf1QWi/rbHoaIjbjmSGXvwGw3Gikj/FWb02cqTIOxSdqf7fYJGVzl2dfsAuj
 aW1Aqt61VhuKEoHzIj8hAanlwg2PW+MpB2iQ9F8Z6UShjx1PZ1rVsDAZ6JdJiG1G/UBJGHmV
 kS1G70ZqrqhA/HZ+nHgDoUXNqtZEBc9cZA9OGNWGuP9ao9b+bkyBqnn5Nj+n4jizT0gNMwVQ
 h5ZYwW/T6MjA9cchOEWXxYlcsaBstW7H7RZCjz4vlH4HgGRRIpmgz29Ezg78ffBj2q+eBe01
 7AuNwla7igb0mk2GdwbygunAH1lGA6CTPBlvt4JMBrtretK1a4guruUL9EiFV2xt6ls7/YXP
 3/LJl9iPk8eP44RlNHudPS9sp7BiqdrzkrG1CCMBE67mf1QWaRFTUDPiIIhrazpmEtEjFLqP
 r0P7OC7mH/yWQHvBc1S8n+WoiPjM/HPKRQ4qGX1T2IKW6VJ/f+cccDTzjsrIXTUdW5OSKvCG
 6p1EFFxSHqxTuk3CQ8TSzs0ShaSZnqO1LBU7bMMB1blHy9msrzx7QCLTw6zBfP+TpPANmfVJ
 mHJcT3FRPk+9MrnvCMYmlJ95/5EIuA1nlqezimrwCdc5Y5qGBbbOwU0EVo1liQEQAL7ybY01
 hvEg6pOh2G1Q+/ZWmyii8xhQ0sPjvEXWb5MWvIh7RxD9V5Zv144EtbIABtR0Tws7xDObe7bb
 r9nlSxZPur+JDsFmtywgkd778G0nDt3i7szqzcQPOcR03U7XPDTBJXDpNwVV+L8xvx5gsr2I
 bhiBQd9iX8kap5k3I6wfBSZm1ZgWGQb2mbiuqODPzfzNdKr/MCtxWEsWOAf/ClFcyr+c/Eh2
 +gXgC5Keh2ZIb/xO+1CrTC3Sg9l9Hs5DG3CplCbVKWmaL1y7mdCiSt2b/dXE0K1nJR9ZyRGO
 lfwZw1aFPHT+Ay5p6rZGzadvu7ypBoTwp62R1o456js7CyIg81O61ojiDXLUGxZN/BEYNDC9
 n9q1PyfMrD42LtvOP6ZRtBeSPEH5G/5pIt4FVit0Y4wTrpG7mjBM06kHd6V+pflB8GRxTq5M
 7mzLFjILUl9/BJjzYBzesspbeoT/G7e5JqbiLWXFYOeg6XJ/iOCMLdd9RL46JXYJsBZnjZD8
 Rn6KVO7pqs5J9K/nJDVyCdf8JnYD5Rq6OOmgP/zDnbSUSOZWrHQWQ8v3Ef665jpoXNq+Zyob
 pfbeihuWfBhprWUk0P/m+cnR2qeE4yXYl4qCcWAkRyGRu2zgIwXAOXCHTqy9TW10LGq1+04+
 LmJHwpAABSLtr7Jgh4erWXi9mFoRABEBAAHCwXwEGAEKACYCGwwWIQTdWKXnw4wULDeIG/Xe
 /5rkTzBNUwUCZYMCBQUJEqrUfAAKCRDe/5rkTzBNU7pAD/9MUrEGaaiZkyPSs/5Ax6PNmolD
 h0+Q8Sl4Hwve42Kjky2GYXTjxW8vP9pxtk+OAN5wrbktZb3HE61TyyniPQ5V37jto8mgdslC
 zZsMMm2WIm9hvNEvTk/GW+hEvKmgUS5J6z+R5mXOeP/vX8IJNpiWsc7X1NlJghFq3A6Qas49
 CT81ua7/EujW17odx5XPXyTfpPs+/dq/3eR3tJ06DNxnQfh7FdyveWWpxb/S2IhWRTI+eGVD
 ah54YVJcD6lUdyYB/D4Byu4HVrDtvVGUS1diRUOtDP2dBJybc7sZWaIXotfkUkZDzIM2m95K
 oczeBoBdOQtoHTJsFRqOfC9x4S+zd0hXklViBNQb97ZXoHtOyrGSiUCNXTHmG+4Rs7Oo0Dh1
 UUlukWFxh5vFKSjr4uVuYk7mcx80rAheB9sz7zRWyBfTqCinTrgqG6HndNa0oTcqNI9mDjJr
 NdQdtvYxECabwtPaShqnRIE7HhQPu8Xr9adirnDw1Wruafmyxnn5W3rhJy06etmP0pzL6frN
 y46PmDPicLjX/srgemvLtHoeVRplL9ATAkmQ7yxXc6wBSwf1BYs9gAiwXbU1vMod0AXXRBym
 0qhojoaSdRP5XTShfvOYdDozraaKx5Wx8X+oZvvjbbHhHGPL2seq97fp3nZ9h8TIQXRhO+aY
 vFkWitqCJg==
In-Reply-To: <f9b23c74b04177f0dc088a246bdacf1cb158c35e.1758189463.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0105.namprd05.prod.outlook.com
 (2603:10b6:803:42::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA5PPF50009C446:EE_
X-MS-Office365-Filtering-Correlation-Id: b607bbfa-7ca7-4664-4170-08ddf7bbd283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dXVHQ1AzZVVHenlLci8veUI3T2VSRlBHY2JaUkg1Uk4xVGpQSTJ5VElmNktp?=
 =?utf-8?B?YjJQWkR6bE5VcmlNMnhtc0ZGcW1ScExYRkMxZzNEL3VPZHhTcEtwS25uSUFu?=
 =?utf-8?B?c2kwOFQvU0YybnF4NUhpcmQzbWR5UE1YRVR3UWxhTXVWdlV4K0Z0TnZQUDNT?=
 =?utf-8?B?ODJXazBOZnVMN0dWRDY2amtrRklvWnBnVkJPNzRmcGRkMUdieUFCZVk3NlRB?=
 =?utf-8?B?SElDMVBGVnBvODI5UC9YdFNzVVYrbHVxOHFwSFVoa040am1pZ1BlKzZRWE5H?=
 =?utf-8?B?NUtRWFFCODBQdjk5aUxTUGYyMTJ2K1dJVlZYNkxybzl0UWgvQzNudHlyTFVi?=
 =?utf-8?B?aWR0Lzd1KzBDZEozRzc3OGdFWTI1ak5kUmJaQm1BVHJRdDh6Tnp2aXRuWkQx?=
 =?utf-8?B?blJ3ZVFaL0RoNVZhSDc1Nm5DVEJoVUpvOVdHeCtMZEZ3SHdWTTV4eXRsN011?=
 =?utf-8?B?WEdSTzhOUVgvdFRCdHJtQVlDQ2VwR3NrSUFCRHZJMGNFdnFwTGxxVXIxMWZP?=
 =?utf-8?B?TWtGYXkrQUJkdXRsQWNESkl2aWJEQjJCRW9oQ3NJR2t3ZnhoZmtLU3pjQU9w?=
 =?utf-8?B?dTExMlhpaWpremZRNkYyOXZpZkhiZGU1M1pHT3A0U0VPRnpmWXkrNG9FUVYz?=
 =?utf-8?B?YmJKS05ZWmFEOUhLM1ZGWkVxZFBkaHlBTm1tOTMwSHdVV01UOGJia2swUUZM?=
 =?utf-8?B?RVV6S3lFMTU3K3M3c3hMRzQxUHVRNFJnSlhQcVI0M3hMbDVDUHphYVhDMmRZ?=
 =?utf-8?B?ekNZM051TTJtWGtCTmY1QW02Ky9TakY0TlpoTklWcWlhQVo2YzlMekM5OTZW?=
 =?utf-8?B?ak1TOVR1VktYZFdFZklueFBCczBJa3VrdEFBTTdXa1dFNElZTG1VNUkxb0dH?=
 =?utf-8?B?aFFwblUxUGJJb3Q3bEpRVm1RYXBHd0dZcCsyVHdTYjlVWi8rUjg0RnNpeEt5?=
 =?utf-8?B?dXpvbzE2MlI4dStobVRtUUFZN2RvWHE2ZnArYjNSZENpT1M2VkV5anp5UzNH?=
 =?utf-8?B?cTJGbHYwOHFwTWNoV2FaWUpsMUtaNkpYbVFZa20wOU9RVGo2cVMzdjZEdnlZ?=
 =?utf-8?B?Q21UM0pXZzlQbjVRQ3NCdGR3Q0pMRk10bHg4ajNSOFNIR0xjczQ2WkZBT2x2?=
 =?utf-8?B?WDQ0bFhXMkIzaTI1YjFabG1BK3d4OEJlaTJGd2owNS9Nd000M1R1bDMvTzEx?=
 =?utf-8?B?QWhMMVptUFEwZ3pkckJHM2FqSDcxQXJVUzdaRDhOVTkyTVlYMVJVS2NWdldt?=
 =?utf-8?B?aXhSQUpUZWsxODQ0cHI2M1NnWEdxcDVnRUsxcDR2V0lKTm9DK0N3NE1SVjBj?=
 =?utf-8?B?NkVnL0EwVEUwd2YrKzdndnhQZVh4TnVLbzNmVVpmLy9rbmRWNDI1L1o3c0lu?=
 =?utf-8?B?SzJQNzJWK0FtT0oybW9mclFYUnZ6WDJoL09Gb0NUM0pIbnFueVA1YXJHU0Zw?=
 =?utf-8?B?Tml0WHR6bjJVQmN2Y3BjWWxKWlVHSmd0V0kySWI5MnlpSGxCbEk0WkpxN2lm?=
 =?utf-8?B?eDAvME85ZVhHM0R2ZjNzS0NFcXdSeTYxL0dvOGFvdTVsUmlqMHF4c2dUcHM2?=
 =?utf-8?B?NkpmZzlEZlBHZExqL2Z1YktHa1dvc0h0aTBUaWRaaTFqd2ZRVnN1ZS9uTHpM?=
 =?utf-8?B?K1JmWnhHSGZXMUhEbVl0QXhLaUQwYVdpWitCaXZzd09tM2YzQkhuRnNPQTRx?=
 =?utf-8?B?clJ6eHFHWkxibURGTzBIWHRaaTFQRFd6bS8xOGxZeit3dVUrMkhRbU5uMS9k?=
 =?utf-8?B?MWdkWUNPR1h3MGU4QTAyb1M3MG1mcFF6UDFtRXF3L3MzbGRIOUxRdmxpZEhZ?=
 =?utf-8?B?dUY3UDMydkpObkkrTjJnL3pCYkFNU1ZUNWd1TVBtVlA5S096QUZzNlVYcDlC?=
 =?utf-8?B?dEptcWErRS8yaTZXVTMxbkZqd29iQUllNEpBay9OZlFWVVpUUGtENDhkMDRS?=
 =?utf-8?Q?hQSe0NQiki8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1dsM0xNdFRCeU5OcWVuMmtQblFCQUVrbC8zdDM1OEJUVTZCVUM2aXFxNG9U?=
 =?utf-8?B?RTNhcElsVTl0ZmlvTXdzZHB2OC8wNHIyUTZDeHhSaVk1dENVelo5SXV5d3JN?=
 =?utf-8?B?VUdHSWVFMnVvcnhsV0pnN0UvNnkzakluRTZxLzJRQVhHcFZIQTJRaXhDVlVC?=
 =?utf-8?B?NUdCSkdvM3U1NnhwZE9GK3JUWUk2dC83a0VnbUMrb1Z2SkUwdTBOd0pTUjVu?=
 =?utf-8?B?K3NXcERlWnNBYmEwYTNHMzJibUdMT0FJV3RQODVBWEllRHpmWFA1R3ViTWI1?=
 =?utf-8?B?N0lFMlpwVkZqZjVNUmVya01OYjl6QnhDdEVnUEg2bkZkZlRtZ3FGR3prK1do?=
 =?utf-8?B?NnZoT1M2L0p3NTdjRWp1VmlKdjlZSUJRK2lmalBiZUtKbitSQVJFWnZVaUhX?=
 =?utf-8?B?VFRJdWlVeXpDTk45QlRpaFNQUTlEeDlZamlyUzNSTUF2YzNHSjJPYWV5NWdV?=
 =?utf-8?B?em5weHR2NklNalR4ejd2d1IrazYrWEVVQmxpZmh5NVZVYmdtWFJqdG5vNTRm?=
 =?utf-8?B?UFh4eXdtK1FIYTFydzdWNlFPR2xDRkxEL05OSGFPWXowS294RHV3OGk5S1B4?=
 =?utf-8?B?blNsY2ZDNFlnOGhKN25rdUxZV3ZTaVROcG9FNUt5NG1zZXhBUW9WR1I0WHhr?=
 =?utf-8?B?QkUzZHdaOHpDcTRxNDBVRkRwUUNHM0VEVVdyTkhVRXh2YTljVzJLY0dLaDR0?=
 =?utf-8?B?cW9lSWJseTRSVC9lVS9icTdMZDRpRUF4aVd4SGVaZFhqVzMyanhMdnNibWs0?=
 =?utf-8?B?MlUzUmkrQUU4bDcyd054UTM0TldtWW8zQU1kZjNNOHpuVW1GdlFBbEZMTWVw?=
 =?utf-8?B?S3ZtMEpxM2tXbkxQdDJ2Y1VpZUJ0aHE3aG5EeWYwRWlLTGh0M0VLSHpjblpr?=
 =?utf-8?B?QUR0UHNTS0R0eHhvV2did3JjQ2RmMDVxUEl0RnFDeXh5aXl2UmZBbU5QV2s0?=
 =?utf-8?B?UlRhaGxmNE03dDYvTDlzc2plRWpNRjBhWS9GOHEwWmV3Kys2Nnl5S1FWTWow?=
 =?utf-8?B?S3BuWjRhbHViZlJOR2VsS2l4TjJ1Z2pwQytaV3doYWt3aDFFQVJneHBRbkFm?=
 =?utf-8?B?WHlvMXkxRlJTNC9jWkcyZ3M5ZUExK1ZiQ3g5Q3J0TGZEdFdnYTRzT1Y1Z0hU?=
 =?utf-8?B?NVV0M2R2Ky9ZcGZxOWFHWGhOUGxvMUwxUDlPdVlTYjRpUUtkSytKeDNoUGFl?=
 =?utf-8?B?Ty9HU2dvTWJPTjZ5VGJlMjhwbmtWcGh2OSszWnlML3k4T3k4RmZkVjVnTCtt?=
 =?utf-8?B?cyszTkZMZFN2Wk1iSWJJME9JTmU2K1ZvVFcvOGlYbG5Pdm1KcEsvYXQ3WDBQ?=
 =?utf-8?B?ZGJzdTBucTAxWFVlYkRNWEc5ZE9yODBFblF3TCsvNVlGOUFpWmZJSEZEVXp4?=
 =?utf-8?B?WTBYaGNLejIrNUFlalU3MnJxTGJpMmpZUThXWm5QL1ZWc1liOG9OUWw0Zm5N?=
 =?utf-8?B?T3BpK0NBcFg2MlAyRHdhc0xRMFRDRzNIQkM5c1ZTZlkwRU9CNlQ0YjQxbXdt?=
 =?utf-8?B?amZVdXcyNG8wZUVqVG9rS0RHcXF4WkhMRm5DcFhYS2VGaTkvT3FVb3c3N05P?=
 =?utf-8?B?M3VLRGRGLzA4cTJvc1dSeXJDQmhrb1RZM281ckZpQVg3azJxTG1aa0pQdlUr?=
 =?utf-8?B?ajNiam8rZVR4Uk5FZDdWd2tvbFJrVDBhcldRYWNLamJyTFdHL0JoWmdraVJ5?=
 =?utf-8?B?WkI0V1B5Vk5PcituRm9iblZOS0p3dE9Jb0ROeHE2b3o4WWIvRW1WeW1WSlJO?=
 =?utf-8?B?dVZtOTdpdkNXallyVkpRRHdpbTlvbEh3bzVhbkdERHNEcXlrdVdvK25QaUFZ?=
 =?utf-8?B?Wk9KdFRaM3d5V2huNGdtekdMc2V6T0Y2dWpZNVYvbmY0S0l2TjlZUFNXbkpS?=
 =?utf-8?B?L3hic1R1dEUwU2Zuc2Y0bVVlVERmdTNmcEdZU3dTU2JrR1hSc0cxcm8yK1BK?=
 =?utf-8?B?cnJObEdHYW1wT1hEeDNTVDhhOHVlUHluTkVwQ2ZEKzBKb2NIOTE2Y1JQbDFY?=
 =?utf-8?B?Nm1URDFBZDBxZ293UXlwNnZJQzhDUjFNeTdqZkVQdkR4eHhaTXVkOVNYemly?=
 =?utf-8?B?cGEyUlhXbDl4ZDk3WkVQY0lDL0k4T1FmWW5ucWU2SFQ3b3cxRXM4RUlscUxh?=
 =?utf-8?Q?2KKXZnoQW+sb6gOJnjkylS1Bm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b607bbfa-7ca7-4664-4170-08ddf7bbd283
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 20:33:42.0556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5btIc53lJLyyGGtmn+oohvFYYbrVbRE1kNeV4WMdkoVlB0/hax0x6zJ8LdBBIKpODfXpXM7SZQ0jIiIKHb2KGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF50009C446

On 9/18/25 05:27, Naveen N Rao (AMD) wrote:
> In preparation for qemu being able to set SEV features through the cli,
> add a check to ensure that SEV features are not also set if using IGVM
> files.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

One minor comment below, otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  target/i386/sev.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index 2fb1268ed788..c4011a6f2ef7 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -1901,6 +1901,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
>           * as SEV_STATE_UNINIT.
>           */
>          if (x86machine->igvm) {

A comment here about SVM_SEV_FEAT_SNP_ACTIVE being set by default being
the reason it needs to be factored out, would be good to have.

> +            if (sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE) {
> +                error_setg(errp, "%s: SEV features can't be specified when using IGVM files",
> +                           __func__);
> +                return -1;
> +            }
>              if (IGVM_CFG_GET_CLASS(x86machine->igvm)
>                      ->process(x86machine->igvm, machine->cgs, true, errp) ==
>                  -1) {


