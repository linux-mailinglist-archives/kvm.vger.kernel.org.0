Return-Path: <kvm+bounces-45843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C13AAF8A5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF1C11B64A6F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 11:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8614F221F3D;
	Thu,  8 May 2025 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WZ1/gswV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2086.outbound.protection.outlook.com [40.107.101.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C131C3F02;
	Thu,  8 May 2025 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746703234; cv=fail; b=OpIaqpuGiRAfwDYL6qP19aKJrMcjEgNiCyjQ0bCFQmx3eU2Hm0ao2k53E1Y12xAmgvKzA/1QXdRzy2VP58l+OTLE6xM8I+cL259hbPBZc2AbM0MkG9kCfm1r0BR2WMaiUUxb3T9HdGKA5YOYuw2YNbWEheVSsrH2Wh2ljYAE4Iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746703234; c=relaxed/simple;
	bh=mlMXxIhFbTL77wTPKV5O0T7d6niKik4ggjTQkbf5/l4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a1O/xfUUBRsU+9Tgvt7ua6KU+IlOoNR2ev0et6hG2S10aBchjTH8VQfnIGvJtkr/P83IWtdKgydhw7rgkVg9elMmWbv4KuoJweAE7juoV5s+Bl8fCnE5eiEjL9uS36rqoAyL8XdinQBRl6WWeOU2U1ojN+zYSTP5RCZC4121xbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WZ1/gswV; arc=fail smtp.client-ip=40.107.101.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhqYtry9o7wJx7hC5j1hRdYgHetsQ5AIiANAip3MVIIqrwQNH4+xykifUMY5bfnoRoTJhnRAq05nVReOp7yNEdrnselewSqa4cc+6cIvpERm1t3Xs8eYwP/h+IDVFuYRKmhKBtY1HUoUDs8vwk+M0hxRJ6yrT9teg25mv5/PbZY3MjpBqVFqo1WeE4LNYofup2bJl2S49y02725x1K6esEsoVdRgIvfQUsSWgrErbL3CWC3Z39xO4EoF1ixgysFAgeUVA9ei3PX0JHdHHFspTzW8A/nBbY9eFvYPgowkrZ9E5VJvx1VTnOtqklTRzZdLz3DGLFFHmUtycG9UZBOkdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbY+lx0lGE8dn5zKk+KIxUa1Lei6PZVsNDzhOdX95QA=;
 b=Gxss0fgUFwsZQFzbEDL5j/xeYzlvJm8cRiiWNYsvtIPWFiklWDQ+3L6SipE7OzqGSPdCup+bypHhynaLTzgVceShz9AL7A2ufol+9X7+pag7d0jhCiVWviiltXMuhB3jDt9yymXuVfcdoXgy0S6V+F0ZJInYCSUfRg+h4nn+axjj0H4i5SyCVlGx69APZZWv6446tz49mwKjJJIZwrjt0leqwtzxZaZ9mOrL8d36rJbh7Tju329gccPLVP86f9deIgX+F/v3me1zxJT1B38tHm75Er6cYYNJhh6HXTmVFQQ0XQWmJdtztWIbDeR6oNmlMlMIROMtv6Guohr2ZuoVmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbY+lx0lGE8dn5zKk+KIxUa1Lei6PZVsNDzhOdX95QA=;
 b=WZ1/gswVL9WOZ93+nK5t5kXnxA+PkE7S5/oH+BUwD62XKEzP02bzSdPBxRahBlDSLzxjf14NS0wiwLRk1tCgcE9yf3pcve3k9bR0Lh1JFKUIdLckFW0DbP3MlYz8KoeovfbeTVVJT6A9gKtguevXrzbu/SVHyJrPCXEHGxUTKgc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 11:20:25 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 11:20:25 +0000
Message-ID: <710bd9c4-efa4-444e-8699-5a6430e8d6be@amd.com>
Date: Thu, 8 May 2025 16:50:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] perf/x86: Enable NMI-source reporting for perfmon
To: Sohil Mehta <sohil.mehta@intel.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org
Cc: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Sean Christopherson <seanjc@google.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Daniel Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
 Lukasz Luba <lukasz.luba@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brian Gerst <brgerst@gmail.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
 "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
 Jacob Pan <jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Nikolay Borisov <nik.borisov@suse.com>,
 linux-perf-users@vger.kernel.org, linux-edac@vger.kernel.org,
 kvm@vger.kernel.org, linux-pm@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-9-sohil.mehta@intel.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250507012145.2998143-9-sohil.mehta@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0039.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:271::13) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 768430fa-11fe-4a71-167d-08dd8e225454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTdqUm9ndWIwR2doK3NpNUFaWFl6TmJjNWFTRklPa0JhRmxjaGRHTzBrZ2lO?=
 =?utf-8?B?SlU5MFZwa201cnRTbUs5aE92bjZrYWpKYzJ6TG1FNVpaRE5MVnB0bFZUcmcz?=
 =?utf-8?B?SDZMbVZCWXVOMHZmeTBVYzc4VXpyK3lab2tpOU9MQkZkL0daVk9FbGQ4N2dE?=
 =?utf-8?B?YkpGUU1ONXMrQWVxVHFuT25BMjVhM05TSGhwaU45QXdCSEFkNzRyZDdUNmpO?=
 =?utf-8?B?QVk0YWl3ZUt5cmg5cjlzTURmTGZ1SmIzN0JzS1hmM3llZlkzb3NHY3NyRW44?=
 =?utf-8?B?NzNwcTVocmtqeURZcCtSMjYvSWVDVUlvN29ubnEwSEhyejZ3NTBEZGw5cXdk?=
 =?utf-8?B?T290bzJWeTZkNWxRQldzc1hwWW44cmR3ZytSYWJ1Rkt3QWtEdFRXRDdSOU8w?=
 =?utf-8?B?dkhIWFl1eEc1WTVOOGY1czFZSGNVL0pKY0pvNEYzN2JKd0UwWnVFMXJBdDVt?=
 =?utf-8?B?ZFBFYUY2NXJEOXovbUlEd2hoZlB0R2xYN3lYR3cvcGQzWDFJazBsZDJzWEtD?=
 =?utf-8?B?MXEweEFjVGtZYlZ0T3pMVUd4a3BZYVpWUnJQOGlTNGllUzJBQUNMY3lmRFNM?=
 =?utf-8?B?TlYxNC9LT1d1TjRMQVNzY2lFRXlwU25GaTV2ME41emg4c3pPQTRDRFFiZ2NH?=
 =?utf-8?B?eDdHWjRpTHB4bW1BeXI3Q0lDREFkYk5GUDhXclp5dG4rWWEwRjhNVTE4Vmdx?=
 =?utf-8?B?U0JTclJrMFZkdW9US0lPbzlJWHBDSXluL0M3ZmNKVGFBSDNCRitqRkIxSWhB?=
 =?utf-8?B?amdWUHpGNWlmQVhFZUh2K2xrUjErQW9GcFNJUndRci9DR3QweDV4VC84NXhK?=
 =?utf-8?B?NkNNbFQyNDRwZFBvMDJrNy8xeTFTQWQ1M01mL3krNDNoSDFQOW9pMXJEU2tt?=
 =?utf-8?B?dmVSblI5b0pjcGJpTUhEOEZJQWppL2tUTjFvQ0RzRW1FRVhMMS84K3oxamFG?=
 =?utf-8?B?WVdWV3Q2V0tSVXpkNjJ5dlRVczVIQjhlYTVxYzJpbzdQVldFTTVnNmpjZFlO?=
 =?utf-8?B?SzFWSk44cmRKa01ZK1ZmdjgrNWNIVWtUaTRqU1d6TXB3S29zRXU0Ym1jS3NI?=
 =?utf-8?B?T291dGJvbGE3dWE3ODZ5Y3JEM1hKMU04bnljdlVpYVRDNGhqZlA3ckY5U2V2?=
 =?utf-8?B?aFdzSTdEbXNPaFgxdExKaHBZQVc2RGZpanBRTWVjN3ZYdUk0V2hwZHJGcUpV?=
 =?utf-8?B?UUV2UFVKYnZ2MW5lTThGdEZnQ3VGNUI2RFg0aFhMRVBPdkgvTkYwMFUzUmsx?=
 =?utf-8?B?eUFOeGd0bnpoRS9oU2dXTFJ2VDlwRi94OFkvdjZWYzdteFc4NU9qcjc2WkhT?=
 =?utf-8?B?Qk03R0dyZVdEcUJ5TmsycTc1UVNzOFVEMHYyZXg5dzNFb3crSmdaK3RrcWUr?=
 =?utf-8?B?SjE0eCthKzg1dUVLQWFYRjMwTW9zeklWVjN4S3dIZWc4dGViWFpaVFkyNHUx?=
 =?utf-8?B?TEVMVFJGYjNlZDU5VXlhODZiSGc0SU95bG1tOWNRc1Y5S29JNVVMU1dpNVd4?=
 =?utf-8?B?YVJ3bUdCSEtJQmM1WGxtSVF6OWdnalNDYXdhUWtIbWxTTm5CbTBHYzhuVktl?=
 =?utf-8?B?UVB6Y3pnOHVQVVlhSmxyNlBJR21GSDlXUENsYVV1UGY4NHJPam0xcVVoNVhQ?=
 =?utf-8?B?dk9jYllwU2psc1BsQ3BVZmpwTFhOZ0NJVUJTNU1lZVNMVHFGbHMyS2pQVGVa?=
 =?utf-8?B?cEg5SGNyb09aVnpqNnUwZk91OFlxekVwbllQSEhBWWJIaERUeVBuWUdFQmhU?=
 =?utf-8?B?czl5R1VaeHFZNG5QOC9iUWNUekdEV3JnRURYM0k2UUR4YXBNeEtKemFZTUxK?=
 =?utf-8?B?b1c0ZlA4UU9ZKzl2MzJLZWNIK2t5cWFIMG41VzBYQ1VmMWJOMVRCWHZIMm1V?=
 =?utf-8?B?QmFaQWZWQTBQditrS1d1ZDVUOGVXVlNzeXhMWjF4U2l1SzVIajBSUFlZdVpP?=
 =?utf-8?Q?krMeIRfX92s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWwxVW1CazVoaDYxcy92TDdNcVV3VG1LK0dlRlVBYUNpQW9SOWhjcTRwRFd0?=
 =?utf-8?B?S0J0MWlhaHpQVnVYNVBvSHFCakNOV3d5aGwyejBMNTZrTUxPb0s4L1ArWDdR?=
 =?utf-8?B?NEJ2Qmd2TFMwUURsRWg2NWh1M28wVzVTRzBwOTMvVTFXeXY0RFdkWkZ5OHhT?=
 =?utf-8?B?Mi9QVFgrbEhrbVVvNTIxK3FGUzh2RXhKQ1FVdEJYU3JGclIxWlpHNkZ5Z2pM?=
 =?utf-8?B?SUVKK0lJT2pybEdCaWZ3blB5bDhQbXhRUkFpYTg2R2E1eDhYc3lFTnNlcVVx?=
 =?utf-8?B?Rm5PUnVDdmxTajQ1WFMrVUp5S3VWaHUyTjg4d2dNdzE5Rjd5dGd4S1ppQXI3?=
 =?utf-8?B?b1c1T0lCZDI2M3Vsb09Ra2dOVXVDMVBWeGVRUEN1Y05pUCtsYlRZYjlUMmh2?=
 =?utf-8?B?aTZyMGdpbDRlZHZuWUVBeGwvMndZcTk2cFdqbUh3RHNvbHhBWUZtMlBMM01B?=
 =?utf-8?B?QkppQXQweC9RMjVIMFhxRzlXSXVLYnRLVjNUWVRPSGlQYjhYSWNVUkFMYkJi?=
 =?utf-8?B?MVgwTzV1ZzA1OE96SlpsY242TWpJcGl5MnBkKzNyMjl4UnZYZmFJbUIvWDdG?=
 =?utf-8?B?b2R3OGVYWDNtclk0cHRYdW16NUJvVmhaTitubkV3NytZSnRyMUE1WEhYMjZm?=
 =?utf-8?B?Z1lCSi9UZFI2alBXTG5jZFQ5d1BHODFNRzN3TTJjazVubHJsamlvNjE4cnJU?=
 =?utf-8?B?T0lwVEc4TWZDc1lDcjcraGgvVi9oK1dUSVNza3BOd0dkRzZUTmFOa1B5eURT?=
 =?utf-8?B?bFhrSndnNTJPZk5WdmhVeml1K2tzNlA4TlRYUlJtdGNwL1Q0UmhWNUU5c0Jm?=
 =?utf-8?B?SjRlT0x4OUZoN3BCNGZXL09UVEgyU1dGZXF2d1hncC9uK2d5Y2tmVXRXNnJC?=
 =?utf-8?B?NW9hM3R4djB2MDBJZmd0ZEhmVyt2Y2praXRmdGhJZGcxa3pKZitzYzNvV1BL?=
 =?utf-8?B?VVdHb2V0Ym1GZFU3Z1lwS3lYc3IxVkZVV05OOUI0aXdNcTJ1NW1CcTkyMXov?=
 =?utf-8?B?YWpqbzVETThjenh0bXBUUEIzaWlIUFlDRmQrcWhpbU11bG16SVZSS3dRZ2cr?=
 =?utf-8?B?V0xqV0xKSk1xY3hxdXFZUm9oU0MwSEtnR0VZbDd4NGVLNHhKdWVDdjFxdUVL?=
 =?utf-8?B?WWlxcUJwcnpWeWs5eW1UUTZwdkV0Zlg0UW5La2FOZGVHVEdlZnJneW9IYmpZ?=
 =?utf-8?B?bEtpRFFiZ0pBVHlZamFxQkxpMjgxZllsaG5jV25Gc1B6SGVuK09yL3VpTXhT?=
 =?utf-8?B?STJJTlgyWW1OMUdYa2FzcXZWMVhEU2xRbXp1Rk5aNkJ1M0x2L2paWXJma0FE?=
 =?utf-8?B?WmpnOVVWblRjTHhHczQ0MGp0cld2b1c3Yno3bmsra1ZHR1JLekFPYVJEL3dq?=
 =?utf-8?B?eEFORGp5NDBVOEs2MTdFY1ErSXU1Tm85MTZFNHRQVmY1Y3Y4YjV3N2pCQkhH?=
 =?utf-8?B?bG1vTEpFU3FqclVDZlhjZW1lNzVGUXhXODN4eDk0dEl2azlnSlZJcjVRQTQ3?=
 =?utf-8?B?NXMrTWtDN3F5dUhNQ1IvbndMZHFkeXArVVUySUFPSVVOOWc3SDYvMzEzaTJm?=
 =?utf-8?B?VnN6KytQTFBpZXZoYkdBeGlsdDdxc0VwZXhnRDd1LzNnZ29RbGpGenp1M2pK?=
 =?utf-8?B?S1pXMldObG9GcUVTc0VxMFRMYVpaOUF1MjB3WVd1ZmFGVTdsaldFVnlqdi9i?=
 =?utf-8?B?RjJtd1ZTdWZUOFlKK3JPd3hxeFR0L3NOdlpnNTNqenZHY29FOFJpV3hVaGUw?=
 =?utf-8?B?N0lPSFBsb1FMekt5UzI4YllDZFYybENDeUpkOTU0dkhxUVA3NFFWd0JHb2xi?=
 =?utf-8?B?M3lmSDgrWXowTGhTa2lZZjZhR2FqZERNd3gzaXBQeE5XWTZ4RURaTjVBTnpu?=
 =?utf-8?B?OFBYRThRQ1VlV0o3NjBSeE5NNW5YUUw1NlN2Q21NR2FvRWM1ZlU4cjVXUFI2?=
 =?utf-8?B?eGRmS1JtZzBYcVdwOVBNTUNFSVh2MldHZmVMdVZMaDlsWUZPTlpQYzFaN21P?=
 =?utf-8?B?UDUxdUZKclMzZEpvT01LQVdSWEJaKy96TXBJK0tjeXBHMDE3MGRiem5sQWlN?=
 =?utf-8?B?RW5rc0pDOFJ6VjNnazQvY1pUVGpTVDB5c1dvYTVML2grcWwwZEpDRXc5NHB0?=
 =?utf-8?Q?eKvqpDkF8Cy5g7CSrhrM1Y3zq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768430fa-11fe-4a71-167d-08dd8e225454
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 11:20:25.6708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7uAOZgWgIJcU29KHXF2QVMo0s7FBiqm12C1748ON+gzaOg43INF/a7pWUPsVkccflge3paXPt2oXIEuIpebJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178

On 5/7/2025 6:51 AM, Sohil Mehta wrote:
> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
> Program the designated PMI NMI-source vector into the local vector table
> for the PMU. An NMI for the PMU would directly invoke the PMI handler
> without polling other NMI handlers, resulting in reduced PMI delivery
> latency.
> 
> Co-developed-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> ---
> v5: No significant change.
> ---
>  arch/x86/events/core.c       | 4 ++--
>  arch/x86/events/intel/core.c | 6 +++---
>  arch/x86/include/asm/apic.h  | 1 +
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 031e908f0d61..42b270526631 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -1695,7 +1695,7 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
>  	 * This generic handler doesn't seem to have any issues where the
>  	 * unmasking occurs so it was left at the top.
>  	 */
> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +	apic_write(APIC_LVTPC, PERF_NMI);
>  
>  	for_each_set_bit(idx, x86_pmu.cntr_mask, X86_PMC_IDX_MAX) {
>  		if (!test_bit(idx, cpuc->active_mask))
> @@ -1737,7 +1737,7 @@ void perf_events_lapic_init(void)
>  	/*
>  	 * Always use NMI for PMU
>  	 */
> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> +	apic_write(APIC_LVTPC, PERF_NMI);
>  }
>  
>  static int
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 09d2d66c9f21..87c624686c58 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -3202,7 +3202,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  	 * NMI handler.
>  	 */
>  	if (!late_ack && !mid_ack)
> -		apic_write(APIC_LVTPC, APIC_DM_NMI);
> +		apic_write(APIC_LVTPC, PERF_NMI);
>  	intel_bts_disable_local();
>  	cpuc->enabled = 0;
>  	__intel_pmu_disable_all(true);
> @@ -3239,7 +3239,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  
>  done:
>  	if (mid_ack)
> -		apic_write(APIC_LVTPC, APIC_DM_NMI);
> +		apic_write(APIC_LVTPC, PERF_NMI);
>  	/* Only restore PMU state when it's active. See x86_pmu_disable(). */
>  	cpuc->enabled = pmu_enabled;
>  	if (pmu_enabled)
> @@ -3252,7 +3252,7 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
>  	 * Haswell CPUs.
>  	 */
>  	if (late_ack)
> -		apic_write(APIC_LVTPC, APIC_DM_NMI);
> +		apic_write(APIC_LVTPC, PERF_NMI);
>  	return handled;
>  }
>  
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 9bade39b5feb..b2f864e77d84 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -29,6 +29,7 @@
>  #define BT_NMI			(APIC_DM_NMI | NMIS_VECTOR_BT)
>  #define KGDB_NMI		(APIC_DM_NMI | NMIS_VECTOR_KGDB)
>  #define MCE_NMI			(APIC_DM_NMI | NMIS_VECTOR_MCE)
> +#define PERF_NMI		(APIC_DM_NMI | NMIS_VECTOR_PMI)
>  
>  /*
>   * Debugging macros

For AMD processors that do not support NMI source reporting but use
x86_pmu_handle_irq() and perf_events_lapic_init()

Tested-by: Sandipan Das <sandipan.das@amd.com>

