Return-Path: <kvm+bounces-362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FCC7DEC20
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 06:08:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EBF39B21210
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 05:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2405D1FB5;
	Thu,  2 Nov 2023 05:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Si1/3Guk"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2E51FA1
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 05:08:25 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210BB10E;
	Wed,  1 Nov 2023 22:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTJb9EPXM2PEA5JmQZBxYInZOos4vKsDL2QC2bBCpaBMFfBFpZ3mOwdkzYAQocVyiEOwEdfIWWXufNYpBDocx7LOj/0K6kixZq6zC8CZuXktLJ8F6kTBSjj6QUh+HSfati9AJ71f3krK20aTv1S03yNrAw9YHeOa4kEL97fCuL3Kcy/GQ5Epja8dpP+qQ/EpYFIAez+yssrtnr7zCVbXHILVhQcEnakDHy8nJvANcleLnVf2mIggxy4iNvsNLgbjDw/ckVFybpVRKfxpQcdtN47XwNl5eMjDfV2ym4HDKWZBW0nkMwm3jPDQgi5S5U5ksaknVoLnID3egeXDVAoHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdPpYIESJI3LAKdvleFugDACrzPivxwQA1xZvKlyNYc=;
 b=eGUjDQNEM6fqTSNTkPI141QqQUm4uGSo1l4qhRZJxOJnZh9Xo86IC+XhlW6CMcmz3Oj4vknZ6n/9z6s20TCdgmByDKl75uWq80nfI85Tq5iCQt1l1JP5CfnFAr8EpS1lnEURdXT1DWmJ84O/J9tzH/PU43N18AuWr8G2sdQ9QsvuULS9wP8RpVTrv/MDQmAsHZTgWYgA2pqiLzSY/2EMo6AZxev5UCvLtVEhG1HeXlYhICEqf6npuUI+sQD2cOlLbr9k8QWVr396WxKHehoceqNTzWtgRKo1iAtSSQHVCeXXsGbrkI17alrtc1MXb+B4XOCFmLE/KNeWPRBpj9Ms3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdPpYIESJI3LAKdvleFugDACrzPivxwQA1xZvKlyNYc=;
 b=Si1/3GukXRobJAKQRyBgClHIftZilMsj0o6AuQU5JyRBzDiyZorfTVPw2ZdDAZo2HdtitZTk4qXwyJGfHhFY0KdcPDZNyRn3q0/yhtwPqiLeMLvkHIBg6Ppy8547wWgXneFYbP77ctaetJ84tG1ViEz7+nw/G7pA6QwvWq+0Cr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4319.namprd12.prod.outlook.com (2603:10b6:208:1dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.29; Thu, 2 Nov
 2023 05:08:16 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 05:08:16 +0000
Message-ID: <d45e8111-1b7b-4c18-a612-09709f6d813c@amd.com>
Date: Thu, 2 Nov 2023 10:38:04 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 08/14] x86/mm: Add generic guest initialization hook
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-9-nikunj@amd.com>
 <afc3e286-5a2d-62e8-e55e-b95ebe4373f4@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <afc3e286-5a2d-62e8-e55e-b95ebe4373f4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:49::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4319:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dcbdc66-89a7-4104-e08c-08dbdb61b8bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/BvHrkxN5O4o0Mh+3zJsCOrmg6aHkUrY/u/AzSErnPp248IEN/+QflFNkgj4j6283F1K9505VgKN8KOmqlHbN0nwLOeKQDE2P6ZJIf+s1GxmPh0pBvD8tMg/p9p3MguyeNBLmvgkcFhVWya2t+Zpwi1Yw96lDBc2pfdvod/yxtcuB/0vjO1+NbiPGM36x++tJBEd5xPnLeKTIpT1Orf+3wiMzi9n7djcVLerrS8hO+jY/vaMnWptE/1F7kDm7pwuZiajbyFYCPqlhbGM0USAuha3YcBOBzt2TOjHR5HkcVseQGzHNlgYFV4dw5qBQFxY5M7y3ZPbTIVcw0TZalkHc+8nYdcr4dEUh/9qclnFQOOa3ZSZUY/+yPTcrQxAhVJm6YRtcFuBIGP0WraVZMg/pB7an6GPC0lFdC1RH+3lR7pX5u8Rll5hLpXnGsi+4+v4dFiHoslQslXxRprGhf+a2zawRllBm4kBWJEvwrzM3NksDD9t3jC6Cbmd/WMzkEztC+3drlIpuCdgpyX5MOLINJG4BIghuWIW3+AZRmTGBcEJjRAkNOYa6nYltFwseKMi2pkZR4H2ALnO5iwSRPUs+WrSFJX7n0tPjJbFpgtvIxeGAsxQrlB0I6hNrpMmJuTB25REbKKlcznte6dPxkwd2bRRA3ZPJ6IAn/+HZY+PQwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(136003)(346002)(39860400002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(2616005)(38100700002)(31686004)(31696002)(36756003)(41300700001)(8936002)(4326008)(8676002)(83380400001)(478600001)(66946007)(316002)(66476007)(6666004)(6486002)(53546011)(6512007)(6506007)(66556008)(7416002)(2906002)(4744005)(5660300002)(3450700001)(26005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cFBRbmtwSW4vekxaNUZhN2hkakVVcUdKTzJ5V1p1SndBajBvN0huYkFGZVdG?=
 =?utf-8?B?cnlhZlhhR3J3SmJJV2Ywc1RUb2JQaDJaUmx0UFhJV0g5VkNHT05DZEYwRzZu?=
 =?utf-8?B?eXhlR2pLRTJKeE1YZXN3N04zcmlrQmxtbllINUMzVmJsMVhsNUd4anY1ejZE?=
 =?utf-8?B?a0NtQnBGdUFEWDZoazlOMlVKekwrS3hyR0grV0NkM0FqcDE4YXBLUjFvZlBm?=
 =?utf-8?B?YTJmb1o3MHVwVVIxVjdEM3htbFFPSTZoSGIrVzdvV1k4OWF6cDZmMDJhdGVp?=
 =?utf-8?B?eGNTc0ZTaWZHNWhqSWpFT0xNaXNUTGlZRDdndzBLSkVseFl3bWhDQnhhV1ZV?=
 =?utf-8?B?Z09xRlEyR0F2Wlg4OWxuUEVGbTFqeEIvOUZRQURHRlFUUlU0WU1Hbk9Jcm0y?=
 =?utf-8?B?ZXBqY25ob01odW9kWjBwcVBoQjNkVjFteUNnT2N4M0dKV0RGQUFGZVNaV0JW?=
 =?utf-8?B?QXpHWjBXVCtrVlZCcWxKMlBGZmFzZU0vRnVhaEptKzRkVEZ3aUc3ZFBnZWJn?=
 =?utf-8?B?M0tVM2Rqamx0Tk5KaDRpUkdZdDd0ZHkzWEhPcVdkTEcrOXlLZ1V1TnJScWxH?=
 =?utf-8?B?QjJoWHJrWW1EMkdEVVFQQ2diR0d5MUdPMlVxTG4zM2pFR0ZEQUVqbUxzZDVz?=
 =?utf-8?B?VGpmLzByRTJXUWpvNnVhWnEyb0VnVUNXQjFQOWRZZnRZNkx1MmJITytnM21z?=
 =?utf-8?B?SThoaDJrZ25qVFdpUFZJd1djcmJoV3JoR2lGY04rZWpIekFsSVExLzBybXdD?=
 =?utf-8?B?TWoyK3BlekdBZ01sazFwTmc3R282TTBkcWlJQXEvTFRjSDdURkV6c0hmY1Vh?=
 =?utf-8?B?UndpcVdrN1l6c1l1MkV2cDlkU2FmcUoxMzdBSHUwL2E4Ykk3TkZuZUpKOE5O?=
 =?utf-8?B?cW9kODIzZEJ3S1ByTmdVMU9zV3ExQ2pBQlg1akNxeEdnbWNuU3RjeHZHQWpZ?=
 =?utf-8?B?alczK1RPVUpGWVhQcjlKSUNnY1FTdjZmUDg0Q2MyeFJvdmQ0aEsrREd1dzlK?=
 =?utf-8?B?OXRUaWF4N3gwUXo1UlpqaDV5aDVFekxMMXBMV2tkd3lGamEwR2J6VVE0eTJ0?=
 =?utf-8?B?cGVCKzNpc1huLzdJTElYSDBBZFdwVTRuUGExa1hUbmF4VU0xa1NsYnI4UGtR?=
 =?utf-8?B?MndqRW9BUDdFZHpRVHdEYWRGeGYrSWJhUTZiNW5PWHNYMjhGTTJGVVFNRXVU?=
 =?utf-8?B?Zmh2L1d3WkVHV3M1U094dkZNVnlBNlhScFR3Sm4xZHVEWU5kQ2R4MlN3OHZm?=
 =?utf-8?B?a000a0RuTjhsaHVOdUk2dGpjMFUvVjlETU1scDRoTU1aUzNSampHRXREWnNh?=
 =?utf-8?B?ck9rRTVSaDRRemlYNVVIZHRQc2NnSERBaVluL3diQTVRbEkyZS85YWVwR3dy?=
 =?utf-8?B?eUhWYXRyYVNzREZMNDROT01WT3NWdGI3UzBITUhYZ09YallaaGw3UEViQm9G?=
 =?utf-8?B?Lzl4ekxRYzRHUjYxMFhYcG5MKzdNY05BR0V4VlpuQlMvcTRMbVFETFBxQ1VN?=
 =?utf-8?B?UDV0UTBROXhPTDBtV0hYSnJRdDA4aG5IYzViZXIrM2dES2JVV2VCVHZEZ2Uv?=
 =?utf-8?B?ZHpVcDd5bkVzd1Zoak1EOFBubWd5Qy9pMmk4T3FTcERRSVIveUwvRFhEY2Nn?=
 =?utf-8?B?czdyT1M3ZzJCTEoycGNSdFJnMkxac2dRM1BRSWdUTUxwSGxFUUF4YmtrRDd2?=
 =?utf-8?B?b3p4L0dkVXF2TXpEemkzeld0VlBHd0FZYmtzYTFxSjBvVlFERGxpakpMZXJD?=
 =?utf-8?B?MHpiRE5HMW4zalU1SWlXWFRQT3Zqa2ZSdWFERENwTGM3REZaQi9sdUFkaURZ?=
 =?utf-8?B?RVBjVmpvOUdrTDcvNnVGRjh6QkhXUWtaTTlRbm0yZVptMVl6WDJ1VTJ5dmFY?=
 =?utf-8?B?VkpUSTVveXRmUEo1TzMvY2NrMlp1djdET25jZ3ZPbHZieXdqcElYSGJvR3hU?=
 =?utf-8?B?MDZiVkR3VnB1TzdqanVRTVFlVHplaW51WS9hazVUdmJvNkcxNXg5cDVpL1J2?=
 =?utf-8?B?eW5IckZ5YzNaeklVdG1VZFZCQXhGMk83WXpxUWRsZTVlTHFqd0lQZ2RLVnJ4?=
 =?utf-8?B?cmEzTEh5M29WVFlrY1NFNlZnZDBLNU9BR09QQms4d2lrcW0yUFc5OUMya0JR?=
 =?utf-8?Q?MD7+sMTf8zWT3Of1a5Y4yjlF9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dcbdc66-89a7-4104-e08c-08dbdb61b8bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 05:08:16.4880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np2dChy/Tw7ZsN8DSJ/UHYXU2nM5HvglLQ5Ujax02WQddklNvCXzOxhGWaTycKq+EJbpIMT4bxUnJtoMcqZuIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4319

On 10/31/2023 12:49 AM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> Add generic enc_init guest hook for performing any type of
>> initialization that is vendor specific.
> 
> I think this commit message should be expanded on a bit... like when it is intended to be called, etc.

Sure

Regards
Nikunj


