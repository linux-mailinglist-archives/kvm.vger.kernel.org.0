Return-Path: <kvm+bounces-57337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D361B5394A
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E3FBAA0C29
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7508C35AAA7;
	Thu, 11 Sep 2025 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KmbCJ+Bc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB70335AAC3;
	Thu, 11 Sep 2025 16:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608105; cv=fail; b=cbYdGO5xgwHnmNSFTippIrG/k7qGzLJhBS9aTnZOXAsX5GHTs5hjBKsMcyqwvZzbxV9aJvozCh9uKyylyKUxjUIUF8LNZuUQ+gZV+4IK8WH1SDsNpFez/ZbFuax4w9HXL4vUOUOiujDh5t01+cA9fiFeJ6vP0mT3vq4z3Wd+oro=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608105; c=relaxed/simple;
	bh=TVUKEXNTHk73Sws7Q+6GNSBbpdQJk3ukrTuXgs0JIUY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y6XEz33kr/m6TAyHrrG6HBjRnS5ZARERCvWCclpFMTC+S7vLWojmRkJbT0lfNGnJXFGftjGtY1mfyzazy26JSURAZJSOTZdv9XWrceR26GgBO5ykdIxt1Dch0CVDRVCdN2uzFEmPwx37OKYBB4i29y+ZYi5wM+AZdXP3nnRrCGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KmbCJ+Bc; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d6RN0e/CSymzYwTo+MotKi2lNx6ozIZpQgl95FNPpnhPo3NvOkg6ifpWxYpgnlzxDsA4Ufg3Ip10wPAaprH4xs9V/MZJqQAMmMSkw3fV0oXUqvVcuNXgXwUpZuGGbmMmXNoHAv7gg21XFVffZSN79gbO+ujZEP8TZ+ErjXTz3TKsGEaebr6s1IfhgrdoD9+N4MIsliNzwTnjZ9DyMvttFGlTL6ylxmNKBtoZpxmW6/0HiS3nsfMEf59P3EC3BGz7y3XVdV8CKpXSuwGiGNvIPDo0EMUvdbVHqxdp75+eYKmzPiFR4WGazbHm5dULOdtk3oo5Rw4ftoUymk1qJOhQww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnEBdxWFAx7p0W8WosQ5qj+bOJRvkFXbB+PpYGnHw1Q=;
 b=CTxYM7maylAjWib+Dn2OUXzxxElvYap+PeGoLX+/t8aE/Vp+9AwJ6j/BZQYpfmE5PIY5XSidKo9qqLL/gQsSvf1RtbFcr5nSb15TQcQdGFSukapN4Dz3JmtOcjVOQ+wTr1MJLk+y497HuXQzizPVN7UPz8g3HE+Ic+LizF7HVbkk205p1gNJiJlsTTksNg2Ss90qgTJDEkLQ3puU4aLbIMxZ8lsWczHGvutQWZWk5hx2NknuyQsZDTRaSvR6zkUGmigoRzg/j1FpSOdSfR7WELzaU7WazR0GhkUwh8JsrTk+FEbQ8J4eey1Pl6VIIs03q3br22X2XSeSsfF6h8dTXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnEBdxWFAx7p0W8WosQ5qj+bOJRvkFXbB+PpYGnHw1Q=;
 b=KmbCJ+BcFtQW2Dyp1QeY+j9mYzJz0ecjaIheYndXQzVOH9OheMjT9B3C7BGm9E8pTb7HSQo77Xut/uEizLDQ6JSS/JZg37idIjWbI0NBL/r53Lf3dvXjSOTjZC/9W333abul+3jMQeerZzAqy7ZtzL5E2uyb3k0IWqOSTjaZm54=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH7PR12MB7306.namprd12.prod.outlook.com
 (2603:10b6:510:20a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:28:19 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::bed0:97a3:545d:af16%7]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:28:19 +0000
Message-ID: <4af4def2-b4d8-4826-8613-a5fca9900e13@amd.com>
Date: Thu, 11 Sep 2025 11:28:15 -0500
User-Agent: Mozilla Thunderbird
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v18 26/33] fs/resctrl: Introduce mbm_assign_on_mkdir to
 enable assignments on mkdir
To: Borislav Petkov <bp@alien8.de>
Cc: corbet@lwn.net, tony.luck@intel.com, reinette.chatre@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, kas@kernel.org, rick.p.edgecombe@intel.com,
 akpm@linux-foundation.org, paulmck@kernel.org, frederic@kernel.org,
 pmladek@suse.com, rostedt@goodmis.org, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, seanjc@google.com, thomas.lendacky@amd.com,
 pawan.kumar.gupta@linux.intel.com, perry.yuan@amd.com,
 manali.shukla@amd.com, sohil.mehta@intel.com, xin@zytor.com,
 Neeraj.Upadhyay@amd.com, peterz@infradead.org, tiala@microsoft.com,
 mario.limonciello@amd.com, dapeng1.mi@linux.intel.com, michael.roth@amd.com,
 chang.seok.bae@intel.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
 kvm@vger.kernel.org, peternewman@google.com, eranian@google.com,
 gautham.shenoy@amd.com
References: <cover.1757108044.git.babu.moger@amd.com>
 <3b73498a18ddd94b0c6ab5568a23ec42b62af52a.1757108044.git.babu.moger@amd.com>
 <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
Content-Language: en-US
From: "Moger, Babu" <babu.moger@amd.com>
In-Reply-To: <20250911150850.GAaMLmAoi5fTIznQzY@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:5:333::34) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH7PR12MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: 546e8a63-9c86-4c6e-8904-08ddf15037db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjJacytEUDVrWWM2M2JZcmpQVnl6clYxbTFWeWtQd0ZsZmdWOGd4K3hUQ2lI?=
 =?utf-8?B?aTBya3l3YlJybUM0ano2bUsvcm5sam5hMzZEMld6a0YxcGIxazFQRGo2Q3Ju?=
 =?utf-8?B?UkQ1azJPa3FRQ09DWTh5QldGQzFhYmNURFU0MjJ1bmtUcmNBRE5yVWxFVlJt?=
 =?utf-8?B?ZDFmYzJkWXp0Y0JHVUpJS0dFc0syOVVhSzh2aytGQ0lZRnRrSjd0TWwxYzFK?=
 =?utf-8?B?bHl1SVRhMC9MakFaRGxnOGhsbE5pc0x6SlFUbjdZa3UyNHlFc2ppdW40SFBC?=
 =?utf-8?B?d2FQR0dwcHBLQTFyREhwNURPK3kzQjBqMmdZNE4wcHlpNTI3OTQ2RDZTZjFZ?=
 =?utf-8?B?Mmxvbml3V0JKSmNpUTZHU29YYzYyY2hLUUZlNUZvRjV2YXBGTnluOENkU0pS?=
 =?utf-8?B?bEQzcnpGbUxxRWpjWG9RRWl5dmxmOGwwdVhsaDl6dm50aU11UWxCQnJBNGQr?=
 =?utf-8?B?bVk1OWZ2QTZkdGZnazlxT2JRclJDN0pDOFkzQjdmcjI5dEtlYUFFNVM0VGRX?=
 =?utf-8?B?cjVlR0JUWGlOWkkyTFlaTHFwOW5CNndVQzhvSDJMZFBnaU91TXRrSXp4SHZ3?=
 =?utf-8?B?aHlVRlFNMS82ZFF4TlFuQmduQkVNekRMKzQxTktlZXAzL243d0QzSmVhNEk5?=
 =?utf-8?B?d3hSUnRBTHNBeHRrbWpZM3UrUDllMzFRZk5mMzRVOGRlRmFnbjJCcXd1SktK?=
 =?utf-8?B?TDJ2ano0QUFwSG5JTGRuTXdzTE5QdnFZVDlFS1NOM2ZaZTBaK2s2SXRsY09x?=
 =?utf-8?B?SytGWnpxVDlpMmtaRkI5bzVGVkpDS05wSVcrbVlhVXhwT0ZjZnRpYW1OZ0c3?=
 =?utf-8?B?eWNzaUlKUlVHRE5LNTZ3SFpKWUJ1SGJFL0xWWUZzNmkva1hoZkplc3RXTnhH?=
 =?utf-8?B?S3VONisxeHE3ZHA0WlY4Mkc3MUxFMzRtK3B3N1dJZWdPb3lSdUxvUmQwZHB1?=
 =?utf-8?B?L1VBQlFESUtmU1RvdWxzZzVkbDduVkNnUGN3UTJWaWlEbUpyV0hvelZ4ZGc3?=
 =?utf-8?B?aWxOdVN0L1hlRmNjU2wwWmdOSklDTjd5N1FrYVNDWjIxRlpDYjA2Wm5TVm5E?=
 =?utf-8?B?K1J2cVVYOG10WTVzZzh1RElQNHc2MjFCd3RqTTFEbDBMUGtaRy8zS2FuWkpK?=
 =?utf-8?B?SDM3KzNHYUF5cGw0aXMrTnhjbzBwN29qc3E5SzRhOWU3RUhNNlBqZjRFVTl3?=
 =?utf-8?B?eU1oVU5DSnhGWTg4NnBDWG9xbVVDSUdGaWppaXRYZGJNanhMUzNSRmcwMzZh?=
 =?utf-8?B?V2tEdEhQWGJkTGFBeU9EV25EaWIwNkg4NmFobGFNS2J3aUd3UmNKSlo4YWNU?=
 =?utf-8?B?d3BBdzlsU0p5R3JLK0dtWENZbmVjU3FWN2lpWWN2TEVkU3VUUmtNazhFaFcz?=
 =?utf-8?B?K3Arc1FGaytDMG9RT0RSZzMwd0JkN1FlemtaWmQ5aW1NVUsva0RuZlZ3djYv?=
 =?utf-8?B?cVZWbnQ1Ui9QNFpHMzhIeENCZWdMRFlJdXlhOEc0R1FZWUM5RWVtNllHNG56?=
 =?utf-8?B?eksrTHhuV1B0bVA3SWpZbVBrbnUwNmJsWUdSazc3Sm15eWR2UzN4V2d2c251?=
 =?utf-8?B?YlNSRnhVWm9QZUd5eGUzaW8zbVRIOGEwejRSaGkzd0h5T3pwcXZsRVFHaHFo?=
 =?utf-8?B?NXZtdzlvL2F3TWU5ek1xWXBzL0ZUU1VJNkVqUGh2dS9IeHFLY3FKM3YydkVJ?=
 =?utf-8?B?b3VURzdUTS9oYllzZUczUmhDazlzbUdFMnhQZVl4d2wxQmZ3VlIyMUxUa1RJ?=
 =?utf-8?B?QkZrM2NXbjdKWFp3Um9HSTJuRmpMNW5NSnFWbS90c282V0ZQa09aMEk4Y2dm?=
 =?utf-8?B?U2w5bWNsYk8vTkhteEJ4c3Q4R0UrR3pBT2xFZFYrODVSSlh3KzZ1ZzVENEFQ?=
 =?utf-8?B?OVBqdlpiTmRJeHd4amNqY3pndlNCeHhMMHIwYmxiTnhhQVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmVueGdVRExoSHk1WGl6dUlVaEVuLzQrMEpMOVJHTE1Ba2NtNnh0VFc1SGdx?=
 =?utf-8?B?SGhWMURvMW03ZlZ2OUxIRzVrbXVFZWUyaWkwY2ZiTEtMOXZ2b3JpT2E3QWVB?=
 =?utf-8?B?RGhmbHdEVE0vekNXN3BMVzRVUWdINEpNYVR3cW50RDdvQnV2U2U1Yy9sUnBx?=
 =?utf-8?B?b1g1cVVER1BDSU41TE9PbG9KQ0FCd3MwQ3hkOTVsSkVxaEs1WGRGU0MwbE5k?=
 =?utf-8?B?M2x1SFp2b1FaS1VCTWk1bGN0enNxY0ZpYzlBMC83MVFSWEYvalhTWlpySzd6?=
 =?utf-8?B?N3pFaHcyQ1lVL0hQTUxyN0NqaEJGTzFYemdXWk5hMXVNNTZqdStUWFBBd3NR?=
 =?utf-8?B?SU5mT20yKzFuUWw0TWI3Z1JVb09LZDFhUWt2dEpwbTVmRit1SjRnRGJ5d2NU?=
 =?utf-8?B?RDRtajFXMkFzMUo0bjlpZjBqbExLSVFkVndyNGgxdW1ZYTUybW0xM2JCMmZE?=
 =?utf-8?B?eEVMYVZULzBxZTI3YzFyUU9rL1UwN0JWeDZGRDhMeG5ZZXNNbTJ3WnYxK1pp?=
 =?utf-8?B?d1luMWZLRXZJUlhYQ1oyeGVVb0o1RUt6emFITjg2RFFtT3pPUkR1TDFWRk1O?=
 =?utf-8?B?dUgvTW14MkVVQVJBREd2WGZCb2puN2ZONVJYMlI3Rnh6OVV0MDB2ckY4NG1z?=
 =?utf-8?B?SlVyZWVyZUpkZVJXUTNPV2MxZEFjKzhJdGJUWnlRaTludzc5OGx5a1VsN0JJ?=
 =?utf-8?B?S3ZzRVI2MDF4UHBSdGQzSWJYRnh4bkY4M0xZZ2pieTFaNU1aRklNY3hIbWpS?=
 =?utf-8?B?NXc5cGpicS8yZSs1VFBIQ2JUbjdETXRka0NKOUNQRlQzY1N2d3g2V1JaMnhn?=
 =?utf-8?B?RnQ2NEtuZk1IM21CenprQllURHE2bm9pdVVNbzRidlhqSW1YVzhadjNDdmNQ?=
 =?utf-8?B?QVdMcmdNVGt6ZjZZVUdET3k2RmplSGdpVVU1Zjlld2FwT1ZhZEU5VUhGMlJY?=
 =?utf-8?B?Y2dyNEJ0U0FpRWlTSktBSWt2OElQNHM3NFB5d1VNbHYxWVkvZGZzcFFyYTF5?=
 =?utf-8?B?TjhBYWgwaVJRRm5nMWwzd0VPdmNuT2NrbHRBWGQrYmlFOFFwaWF4QUpucE1y?=
 =?utf-8?B?bzBPQzRVSDJXdGNleEFTN1YvcDdvK0ZxV0lHRDJIa1o3V3c4b3NMUjZUempV?=
 =?utf-8?B?SjA2WXdYOHdDbGNIdW1kTEYzclQyL1F2QmJBN2VaS2VqUFNCWG5hLzBUYW9R?=
 =?utf-8?B?MEcyWjY5bDc3dlpGUFVweXg2QVIxd2JRdlZjZHlySnVsOG1HMHI2WGZ1UEFT?=
 =?utf-8?B?dzM2TjZIa1hFNktibFJmQmlVRENkWUJDeWFlTEdvek9hL0gwUzFzMUxFL0U4?=
 =?utf-8?B?aGRBNUtVQTB6ODdLaSsvN0h2djFZVURGR2xvSXNyWHd4dGc4REdLdzQ4bWJQ?=
 =?utf-8?B?VnpBb1FDQWFQY3FNOFRQdi9qWHdiUHZoNTNWTUljK1luZ3pCL2gyem5Da2Fa?=
 =?utf-8?B?cWlCVHZIT0xwRXhNMVRQVFlicStnMW9iQW5pUGg4bnUvQXFva3FnZ1JFRmw2?=
 =?utf-8?B?TXdCSkhXUDl6NGlISloxM3lib2M1UTBmeVdlb0w4aVdvanNtcENSRVFXY29u?=
 =?utf-8?B?aTBrYnRNdThFOHdzV2lOSkh1bTNqNTJqL0NCRG9HUi9FU21OQ0lkK1k1MTN2?=
 =?utf-8?B?Y1JpVWxqenVCbFE4VjgvU2hVdjFGamhTaU5hSWZnUDBQbkRWZ1lETjEzWHMy?=
 =?utf-8?B?bGZ1MUt3bkZ4K2FTSk5weEpUUzB3aWRxMjJhenBoK29wOS93NUxVZWgyNERF?=
 =?utf-8?B?M3h5aWpNN1Y3WWVJUXUwODRGWnUxMThXQnhDamNjTytYMlZRN0h5TXg3cENK?=
 =?utf-8?B?cmdURWplMUlMMEhVc3AramNoWk9KTzJTL3MwN3gxUVp4WjhvTVA0RTA3MWNj?=
 =?utf-8?B?TFg1aURiaXdxVldTTkRFQ29oWS9sajVJM2tYRm4vWnhncXdFNm1BdmM4cC9J?=
 =?utf-8?B?SGhhWnh5RDlCK3RjWEpLenFxYlZ0QW8ydG13U3pQYXdaT0YzbDZDOFNvMHRG?=
 =?utf-8?B?NXRZWUJRdFBQN2lrb09pOVYwalFDUE5zTFRtd1p1ZnErYmQzNDBueXBjZ0tw?=
 =?utf-8?B?RkxtMWFnbEI0bzRPOTJ0NXQ4UlBvYmc4dmdDWTV6eWxxc09jQUdVVlBsK1p6?=
 =?utf-8?Q?Jzm8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 546e8a63-9c86-4c6e-8904-08ddf15037db
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:28:19.5462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVygeMgBbUEHsoazGFf5ZY17hpxb7ioSNSdXqgwq8dCWLGFSq8wbYrGWDWRoUTUZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7306

Hi Boris,

On 9/11/25 10:08, Borislav Petkov wrote:
> On Fri, Sep 05, 2025 at 04:34:25PM -0500, Babu Moger wrote:
>> The "mbm_event" counter assignment mode allows users to assign a hardware
>> counter to an RMID, event pair and monitor the bandwidth as long as it is
>> assigned.
>>
>> Introduce a user-configurable option that determines if a counter will
>> automatically be assigned to an RMID, event pair when its associated
>> monitor group is created via mkdir. Accessible when "mbm_event" counter
>> assignment mode is enabled.
> 
> This is just a note for the future - you don't have to go change things now:
> reading those commit messages back-to-back, there's a lot of boilerplate code
> which repeats with each commit message and there's a lot of text talking what
> the patch does.
> 
> Please tone this down in the future - it is really annoying and doesn't bring
> a whole lot by repeating things or explaining the obvious. Just concentrate on
> explaining why the patch exists and mention any non-obvious things.

Agreed. Thanks for the note.

-- 
Thanks
Babu Moger


