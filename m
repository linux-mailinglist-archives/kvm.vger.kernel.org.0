Return-Path: <kvm+bounces-3707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D85798073BF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07F9E1C20A30
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E898405F6;
	Wed,  6 Dec 2023 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jJYjx/30"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2065.outbound.protection.outlook.com [40.107.93.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC62139;
	Wed,  6 Dec 2023 07:33:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZ+5wWhp4sWiI5sejVlVqDqKMq12TKBN7PxvBAfmlXMYlEvAwfMxE/+beAfnag5E9pS8xBcBebQVKTzh+xIedYL6QVcrciQHH58BkfihTf2Y5Y5F1clfdcvlWqM9sAW6mjGcDy9UuvU3kqqTD+nNj+bbihjcjS64+tbNJJMmSA+kh8sYlFY7OPFfdRsC/2y55VZVTZ6UK8W6AjX8J3cNWogrvxMnOyZ2qBmRoCTA4FHlVCbZvf1w4GCX7uCKPoJwuEQexfMxDR8PrRICLk2l8GX68CAulo11xjsUNLH/YJHOTeMB00TbByIPVrfuRi3MI1jjnulBZaKNS6H52xPELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ng+Sxp/F1Ue1BnN/6E6PDO9PDFDn4689ylff8nQ5jD4=;
 b=ckLMJDMDBRIvoMBHd9kSXy2lovlmlcrgZpg7m5e+a0fYS+nIIx25wlWknl35ydMT9EozK81MFbzgS29S1+aJY5f/YCzJyqaRPD8drUazN2tTM0RygmObN0bqQ691YnDKkyaby0RafJNdXzvnVXjve+nJ0oBvJLa5SnNZogM0lEtyFSvGqsLTgKJ4NLY+bRuMBR0EwsxxCV0b5y+ztB+mqYu7AnW+yeaPzJbRb7kejCpDGIvNKsvtWwARVh0zf39hUf3gJQcCRxd/vb0staakgm8TJV/Fi20izz9aXbZXJFrX5xAzL5t3i55RP3xZDz3k55+paqk6WC90dYRdEPwE7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng+Sxp/F1Ue1BnN/6E6PDO9PDFDn4689ylff8nQ5jD4=;
 b=jJYjx/30/LO+3A1q3slhcxQpVIkhH770HQDL6XJNNzz/vPbiNSUngkq8mivFUEnxQ9zHR+Fuk+r61t8Xdn0mdQB4RLNllCXo2tTS43jZXh8K6mAmdsvARN/UTK18qf8upIAHrnqrZSeMUsPpqAp87q/nDuje3KOxqKFoICmHViQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by PH7PR12MB9201.namprd12.prod.outlook.com (2603:10b6:510:2e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 15:33:16 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1d68:1eb8:d7dc:4b43]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::1d68:1eb8:d7dc:4b43%6]) with mapi id 15.20.7068.025; Wed, 6 Dec 2023
 15:33:16 +0000
Message-ID: <80303130-e9bb-4b38-bb9a-7e611336946d@amd.com>
Date: Wed, 6 Dec 2023 09:33:14 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is
 enabled
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 x86@kernel.org, linux-kernel@vger.kernel.org
References: <20231205234956.1156210-1-michael.roth@amd.com>
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
 CwQWAgMBAh4BAheAAhkBFiEE3Vil58OMFCw3iBv13v+a5E8wTVMFAl/aLz0FCQ7wZDQACgkQ
 3v+a5E8wTVPgshAA7Zj/5GzvGTU7CLInlWP/jx85hGPxmMODaTCkDqz1c3NOiWn6c2OT/6cM
 d9bvUKyh9HZHIeRKGELMBIm/9Igi6naMp8LwXaIf5pw466cC+S489zI3g+UZvwzgAR4fUVaI
 Ao6/Xh/JsRE/r5a36l7mDmxvh7xYXX6Ej/CselZbpONlo2GLPX+WAJItBO/PquAhfwf0b6n5
 zC89ats5rdvEc8sGHaUzZpSteWnk39tHKtRGTPBSFWLo8x76IIizTFxyto8rbpD8j8rppaT2
 ItXIjRDeCOvYcnOOJKnzh+Khn7l8t3OMaa8+3bHtCV7esaPfpHWNe3cVbFLsijyRUq4ue5yU
 QnGf/A5KFzDeQxJbFfMkRtHZRKlrNIpDAcNP3UJdel7i593QB7LcLPvGJcUfSVF76opA9aie
 JXadBwtKMU25J5Q+GhfjNK+czTMKPq12zzdahvp61Y/xsEaIGCvxXw9whkC5SQ2Lq9nFG8mp
 sAKrtWXsEPDDbuvdK/ZMBaWiaFr92lzdutqph8KdXdO91FFnkAJgmOI8YpqT9MmmOMV4tunW
 0XARjz+QqvlaM7q5ABQszmPDkPFewtUN/5dMD8HGEvSMvNpy/nw2Lf0vuG/CgmjFUCv4CTFJ
 C28NmOcbqqx4l75TDZBZTEnwcEAfaTc7BA/IKpCUd8gSglAQ18fOwU0EVo1liQEQAL7ybY01
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
 /5rkTzBNUwUCYSZsLQUJDvBnJAAKCRDe/5rkTzBNU+brD/43/I+JCxmbYnrhn78J835hKn56
 OViy/kWYBzYewz0acMi+wqGqhhvZipDCPECtjadJMiSBmJ5RAnenSr/2isCXPg0Vmq3nzv+r
 eT9qVYiLfWdRiXiYbUWsKkKUrFYo47TZ2dBrxYEIW+9g98JM28TiqVKjIUymvU6Nmf6k+qS/
 Z1JtrbzABtOTsmWWyOqgobQL35jABARqFu3pv2ixu5tvuXqCTd2OCy51FVvnflF3X2xkUZWP
 ylHhk+xXAaUQTNxeHC/CPlvHWaoFJTcjSvdaPhSbibrjQdwZsS5N+zA3/CF4JwlI+apMBzZn
 otdWTawrt/IQQSpJisyHzo8FasAUgNno7k1kuc72OD5FZ7uVba9nPobSxlX3iX3rNePxKJdb
 HPzDZTOPRxaRL4pKVnndF2luKsXw+ly7IInf0DrddVtb2647SJ7dKTvvQpzXN9CmdkL13hC5
 ouvZ49PlXeelyims7MU0l2Oi1o718SCSVHzISJG7Ef6OrdvlRC3hTk5BDgphAV/+8g7BuGF+
 6irTe/qtb/1CMFFtcqDorjI3hkc10N0jzPOsjS8bhpwKeUwGsgvXWGEqwlEDs2rswfAU/tGZ
 7L30CgQ9itbxnlaOz1LkKOTuuxx4A+MDMCHbUMAAP9Eoh/L1ZU0z71xDyJ53WPBd9Izfr9wJ
 1NhFSLKvfA==
In-Reply-To: <20231205234956.1156210-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:806:127::24) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|PH7PR12MB9201:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f17c42b-be00-4991-d0c9-08dbf670aa8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jNhvfX/wOimbAaC/l1D7vDqcZg67T2+MuNmkAFnDY2MLhcKJkxqogooJVcW0I46mg45LKHp3V6ZfnVEGtUgjaFTdpm37R2P5R4glLGo7FZdts5JLIZ+w9vrENEXPYw0ntcZEoa3uUjDn5L3GOo3BJs54e5HpY0w8cnO9bdKke7LQfMNNqwjLWq8OzuOrVvqvG5U5SxYT14yfDuzV3wRr+Rrj/R6GW7bBMjZOvAqbttudRuQxU8A5tUmiCuMgyjOAtGB1Q/XCtyJmO1y6KavFZqLw05Zv2TgXBtuBIVT8OquRlpBiuPpheGh6iwhcMmjoDUA+S0d/OtxEKLqXqu+Z172327PJ3Cv3lHT4JMSdV3TvfmL0HslR1RV90rBPf9/dBr+xEKkW8N7yRPBrNA+hfCwfzgJ3ar59lOiDU4lGxuricu7g7Uvh+0Al9ky03srNz/bxGvVtZSIFvJHdZweY2HWsDvdn+Zd1vDMjOE8nln8A/lgUC9c6DMpug8TG6UXbPDynwyrJ3gFjen/augokHlEH50fl/44g97LGicziFZ14lyCoYEXbd++nruhdOURezMHfgVoQK1AN69H4lqvvMEayMG2FJHuxvNDnY1HCUw9hNSP8lRQ0KLFrdw4w9QUQ01CdAEgspNKQc9zhoBgeqw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(136003)(346002)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(31696002)(5660300002)(7416002)(2906002)(36756003)(41300700001)(86362001)(6506007)(6486002)(478600001)(6512007)(53546011)(38100700002)(83380400001)(2616005)(26005)(31686004)(8676002)(4326008)(8936002)(66556008)(66946007)(66476007)(54906003)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHRwd3d5M29vZi96eWtJQ2ozeUp2bkpWa01oR21yNTFJNk1uNXd5eElxSXhL?=
 =?utf-8?B?T2kxaXFtT2w3ckxPamt0Skh1eGFNRjNweU84V29jT005OWlIeFFvd2ZYV2tK?=
 =?utf-8?B?M1lqa1RrVGMwWG9KdjF0dE1YU25iOWl6VURyak94VXliNWpvbTh1YVVGVDcw?=
 =?utf-8?B?UE41MHlkSkJPendDNGhWdWhmQWIyVHpLYWJBeWxmSzhIczVRK1dxQ1NKT0d2?=
 =?utf-8?B?ZnZLQ0l0SHZ1dVJmcG96OHcwSkNlUllSVk0rbnVkVGFpVXBXb3BCVTFvd09y?=
 =?utf-8?B?eFN2bnpobFRJaXlicmpJTEs4a0krRXNPYjgrcDAwRGRVaTZaRm5nY1RtMGkz?=
 =?utf-8?B?NllDVUdUamFmSEUyNVIwQ09lcGtKZjJ6Q3h1SUlCbkoybTFucGd4aXJweUlD?=
 =?utf-8?B?WnpLTWRxOXNOb2gxQUZndndjTFpXaVVvT1Zka1pLVjNnR2pucDR0N25XMGs1?=
 =?utf-8?B?OWlHbDNnUU40YXhkTlBmWG5uMW1SaEFwTnhldGtOTWdXNzMwOVRhUVRNN2NT?=
 =?utf-8?B?bkltWm9aR1Y5TDFXUG85ZlRKbXJwVFp5Ukx6c0VCdWVVTkZlRFdaNU5nZUVN?=
 =?utf-8?B?WXhQT0YwbmhwUkQ0WUZXdnNCaDBzMG1pd3c2ZklDS0MrY01XUWVkZytXU01C?=
 =?utf-8?B?TDVSNDRFOCtjWXllTG9DUXVoTkdtOU5keXEwV0FybCtkY0N3NHRpeE5oQ3ZJ?=
 =?utf-8?B?Z3N1eUFxeGl2clduY0s5SW43TitPWHM1MitXUXczSjlsczM3M3ZualVyZGda?=
 =?utf-8?B?VmFTb1pCYXY3M0NTU0l3ZFYyRVNnUGd6UXBYeENrTnNEWllrOTFaS1Vpbjdx?=
 =?utf-8?B?MXR6N1cwVG1EVG9mcXFmS29ZbFVVZVkvYktWamVkNzZhOWx6MEczQitlWXVE?=
 =?utf-8?B?VmhkajNySU9wT1N1eUl1ZmFnalNza0hYMEt0amt2OEs0YUUvSXIzbUZHeTBq?=
 =?utf-8?B?cW0yS3Z4NmtBM3U1RkJReUdHbXNrWkZsWGo1VjZ5RXFVVE1ybWFDb0tpd1JD?=
 =?utf-8?B?YlBsNm1zTGxDK1h1SGwxb1ZxMjNvL3dnMzBtVHd6dCtaT3J2Z1o5V2NtVHZ3?=
 =?utf-8?B?QUxvV3d4cXRIV210TnV5SEc1QkxrRkxYT1A5NFhVRFRFUmIzUG5HaFlWSDZR?=
 =?utf-8?B?Z2Z2NU5hSkdFTlcrTXVpamo3dlhZQXQ2V08wYS9IU1liK294OGZaQzdrYVA0?=
 =?utf-8?B?ZHo5WUFlRmw5SG8yclllbzlvV3AzUHh6L3NpM0RtYTZ6NERSczFLaS8zRFUz?=
 =?utf-8?B?VlRHMXNvb1k4VjU4R1cxd0JaeGZqZ0QvVmxMdW9Kd1VYUHIwQS9WYzJRRWJr?=
 =?utf-8?B?eGZhMWsvNUM0d2MyeUZWbjU5TjlRWVZPcjA0cmo0UkRQaWpzZVpJcEdMdWJp?=
 =?utf-8?B?aWdHdWM4cHdBRkFING9vQ0hXclFiQm1Eb3ZtQlk3cGo4aS9xY01kQ2pRWUY5?=
 =?utf-8?B?Yktlc0hhUldyb3FQV05qNTNab00vK0xZcm5tS2tKaXpBU2JZMXdkM0FtOHF5?=
 =?utf-8?B?VmdUSWtkOGI1WUlvaXBOSGRDVVBicEV0dkQ0TWVlcjVab2UxRlV2RG56VnNK?=
 =?utf-8?B?eFNSNjZZalFWRWhXYmFWUUVFMlJGdFFENjVtc2tTWnhMbzFPM3J2aHFkS3NP?=
 =?utf-8?B?dVNNM3kzRld6eFhvODVsbnRLQzM5MHQzQ2hUM3pYOElWTS9SSmR3YXh2dXB3?=
 =?utf-8?B?TU5oc1U0c2JHNkh4NkF2U3FSRGFEU254R3FjQnBUTGFRSGtyaDhmUTBCeVhl?=
 =?utf-8?B?MDBIMjF4Q24ybVkzV0JPbjJBM0NILy9Pa1NmRHpFSGxKbitwMi9oUGdkVktE?=
 =?utf-8?B?NGFkWXFZN2JCaEJ3SkhlUWVUbG4zV2ZEdHE5NmVsSHg3dGJScjNrUFl6V29B?=
 =?utf-8?B?amxETXV5OVRwRm8vM01PTnVBVjdHRUlVNVMvaU1acUh1alFKTGpKNC85dFNU?=
 =?utf-8?B?VXI5TUxKaDFpZjN4bmxEbXVpZkZxMHJDOGtiNnVDdGg1d3k0a1lNeXRqRkM1?=
 =?utf-8?B?elh4QlFUbDNJaVBFdlkyTitrRUhwaTdMNjdMbG5HUFRHaXV5bHl2N3ovbTlv?=
 =?utf-8?B?ajcwb3RlcFVtOTBJUjlJWFFhc2RkbDlvQlZWQ3ljbE5DL0hNMkNLbE8wVjk3?=
 =?utf-8?Q?wFCFB1VQ2op4f5u+TOybDfrFn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f17c42b-be00-4991-d0c9-08dbf670aa8b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 15:33:16.3361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5wxLVM87w6DYkJLTzJwUUWlEj0lTZJdaci6LyYbZx7oHuKVuS41PiFC+Lv1/dbxyCUyGElK4RjPTvGkvnz5dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9201


On 12/5/23 17:49, Michael Roth wrote:
> In general, activating long mode involves setting the EFER_LME bit in
> the EFER register and then enabling the X86_CR0_PG bit in the CR0
> register. At this point, the EFER_LMA bit will be set automatically by
> hardware.
> 
> In the case of SVM/SEV guests where writes to CR0 are intercepted, it's
> necessary for the host to set EFER_LMA on behalf of the guest since
> hardware does not see the actual CR0 write.
> 
> In the case of SEV-ES guests where writes to CR0 are trapped instead of
> intercepted, the hardware *does* see/record the write to CR0 before
> exiting and passing the value on to the host, so as part of enabling
> SEV-ES support commit f1c6366e3043 ("KVM: SVM: Add required changes to
> support intercepts under SEV-ES") dropped special handling of the
> EFER_LMA bit with the understanding that it would be set automatically.

Maybe add here that it was thought that the change to EFER would generate 
a trap. However, a trap isn't generated for hardware changes to EFER and 
only explicit writes to EFER generate the trap.

Then the "However" can be dropped from the start of the next sentence.

> 
> However, since the guest never explicitly sets the EFER_LMA bit, the
> host never becomes aware that it has been set. This becomes problematic
> when userspace tries to get/set the EFER values via
> KVM_GET_SREGS/KVM_SET_SREGS, since the EFER contents tracked by the host
> will be missing the EFER_LMA bit, and when userspace attempts to pass
> the EFER value back via KVM_SET_SREGS it will fail a sanity check that
> asserts that EFER_LMA should always be set when X86_CR0_PG and EFER_LME
> are set.
> 
> Fix this by always inferring the value of EFER_LMA based on X86_CR0_PG
> and EFER_LME, regardless of whether or not SEV-ES is enabled.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/svm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5d75a1732da4..b31d4f2deb66 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1869,7 +1869,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
>   	bool old_paging = is_paging(vcpu);
>   
>   #ifdef CONFIG_X86_64
> -	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
> +	if (vcpu->arch.efer & EFER_LME) {
>   		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
>   			vcpu->arch.efer |= EFER_LMA;
>   			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;

