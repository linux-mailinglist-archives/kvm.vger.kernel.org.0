Return-Path: <kvm+bounces-2433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDA677F74DE
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 14:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33729B2148D
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 13:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FF328DD0;
	Fri, 24 Nov 2023 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="aqTWnF+4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2104.outbound.protection.outlook.com [40.107.94.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA8F10E3
	for <kvm@vger.kernel.org>; Fri, 24 Nov 2023 05:22:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKqyEDpLStiTCsc32VTG66Hk50CXG6BUzjJDE5bjUZgRJa8iIhiNOBnf3msr3osepxfIisrFHXcVtVMro5m3yZbK4U74Im12z+Xy0fV76Cv9bpsDPkHLc77eAK9vTSFto5uHov2nK1XBj77dyPNO3Un6b/IVcu0vewXmiivMkOP1j5FhOD8bfui9BuBUmLr97epSrshGNvAG3JK2y9xU0wonSdWfpFmOsqW2bjDCp5UeEJS4QClo/EyPSHrt9fXAzphqTSu/ydIn/ZgqhY460pVR+gngaN1YnhBj0SbdysIMdMjp6zdEepm99tOizYVlOvW9Jr/7zGTSbwclXFkE0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaBZt15ZFQEIR1UTuNo0gbXOZ1VTAmNY+w5cHAwDavs=;
 b=iTpIinp6KZnlrljgVgsf64h66jiD18b5tNXikZlBomX3sQ+ns2KldHGYztKCkzcwt3iOA9/7lnUOFEmofzlJneK2+zLrAxVIOfJOgxeHrAqLCQYCxBXZp/0tkoZX5oLvVN17V8gyu2OoxJCOW54jqoKWO3ZREaGx1mkjAJBWCva+pBdNrVKlHAbAFTGGSzSG2ItoUWJUBCFSlM3tLXt78cYEzQNbmXtlg0x4d7IAfaOzOoAS1QmqkcT+L+00pMZCbWU8xudPaJO8br9HbVlyVjiGZzHvKIG1V/Kng040QwfVX6XZIBHWzZnQUvQ9Z9kUxJGLeWlCDf2g0snqd5xFtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FaBZt15ZFQEIR1UTuNo0gbXOZ1VTAmNY+w5cHAwDavs=;
 b=aqTWnF+4fkBvI5X/nnccuv3HLS5N3E1Pgz/hUHdsBNEf/LHu5oliKYn15OaYi+V+TXBJslXuCaeRL0bWX95g3LALjN3ZJXDYRmBzq0wUL6JPAPfhFOLdZFholhh2lV+4TaeAk+/9lHrTf5nf7o3SjB1d58kIqACqgwKdck6ftcI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SA3PR01MB8037.prod.exchangelabs.com (2603:10b6:806:31c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7025.20; Fri, 24 Nov 2023 13:22:34 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::9968:1c71:6cfe:6685%3]) with mapi id 15.20.7025.020; Fri, 24 Nov 2023
 13:22:34 +0000
Message-ID: <e18700d4-061d-4489-8d8d-87c11b70eedb@os.amperecomputing.com>
Date: Fri, 24 Nov 2023 18:52:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/43] KVM: arm64: Nested Virtualization support
 (FEAT_NV2 only)
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: Miguel Luis <miguel.luis@oracle.com>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <DB1E4B70-0FA0-4FA4-85AE-23B034459675@oracle.com>
 <86msv7ylnu.wl-maz@kernel.org>
 <05733774-4210-4097-9912-fb3aa8542fdd@oracle.com>
 <86a5r4zafh.wl-maz@kernel.org>
 <134912e4-beed-4ab6-8ce1-33e69ec382b3@os.amperecomputing.com>
 <868r6nzc5y.wl-maz@kernel.org>
 <65dc2a93-0a17-4433-b3a5-430bf516ffe9@os.amperecomputing.com>
 <86o7fjco13.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86o7fjco13.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:610:59::37) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SA3PR01MB8037:EE_
X-MS-Office365-Filtering-Correlation-Id: 1061053f-ec48-490f-80e5-08dbecf06adb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pHVrE3bFjc0fOEXj0QuNLC4YVaoEgCIjo5TU/TjZrGmOFpik0Vm01yt1eMAg3vHV/oR97cCzZVgL/lzfFWyS64QIu3nEkOBtVacTAY1N513FRPRZwp6Kc/Hd32EIW44b4LmXv03PGpTXt91jyEDSq1diQMaW24qxWcR02XYy8R0eh+Gry/ZH3uhfI+KM0dpoMuvWubiied+W+xQ6WOjf7a6tAgHlmoUcno5LXv3cj3kc41V5viW6yVCz2vFRsIzB7J6H4uUtbX5ELxX5A0qxU9K49YPltWdq6NhgUX47vDERCVlFZx+tvmf7slAAtXVnix308hJCTa/71qGz/ioDXXj5YSuQI+vLtO+fL9KoGlbGa0v6lefjGQBz//vUVY9crSSn9J1sN413S+mQsQhmMpp0FatST+YQa/W7NxHofM08izV79O3Rjbaikg37ScRGHUYWTKWYGsOe+f6sU+q4KtEs75ynf12s48qi0oxGiA0lcGe/1tdUnSOhNVZWy0fpsR0/T/OJiIrNIHqz3rf4ZXuSkHx2L4ip8WUIEP4Y09TdXr572997sT2fd2AeaT+4ZSXc113Alns+e/04Xb6h1Ct48KcdRWV7CWmlUA6o+oA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39850400004)(396003)(366004)(346002)(376002)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(6916009)(66556008)(316002)(5660300002)(66476007)(8676002)(8936002)(4326008)(54906003)(7416002)(2616005)(966005)(26005)(2906002)(478600001)(6486002)(6666004)(6506007)(83380400001)(66946007)(41300700001)(6512007)(53546011)(38100700002)(86362001)(31696002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OHBEWVgvc212N1poQjJtUDlhRzJjSzFiRk84aE1QYThSUW16ZVBuZGdBa0lH?=
 =?utf-8?B?T1NtYW82cmVjaFhxYUJCNncxbk1DeUt4ZktvVmhMZ1VMaGhjc1NNZFRQb1pJ?=
 =?utf-8?B?LzRNZE8yQkszNnNrSGY4Mkc1dHZvMWFEWjFvbndQMjM1SFNkNjBHWEUyU3NE?=
 =?utf-8?B?YmRlUmF6dSttQ0JOMzd5SktMREVxTXdFU3ZPNE55MFNRbTBKRTlXR2dzbXJp?=
 =?utf-8?B?RkNCZ2hqZkh0ZG1jTXI5NVFpRmdLT3hVTkJZR2FuQjc1SjUyQ01JUnhPK1Rq?=
 =?utf-8?B?K01KangvMUhCcHh6aDRGc2h0SFlmS1BzSEhBdFBnU0g2WmY0cUZyUHl6bnNY?=
 =?utf-8?B?SDBiNzFyUGZ4cXJtdklXMVNyaEsrenVOaFpmK1R5c2lIaGUxd1NaL1lsRXph?=
 =?utf-8?B?QklMNzZLSno2cG1pdXd1NjVTMk5YdGFGc3lYaURqSjlvVmh3M0l2VStDTTl2?=
 =?utf-8?B?bjJQK0lBc2h2K1JyMTMvZEhlaU8rY3hHQWFBODJoUWtHdGNrOXg1MG5GSmUx?=
 =?utf-8?B?YjN2MmxnRW9IaldPbFBkWEhqaXNyNTBRcC9aMWdidGlBV2Evek13dGFQbjZ0?=
 =?utf-8?B?WUxDQThVd3d3dnhxSUJrTTlVRDVPN3IxWlhOaDBHZkhnNStNNURDT09Oc25Z?=
 =?utf-8?B?RmZRVVAwQnNUODVXY0NjQXZ1QnNKaW44T1lkbFNnNmh5eit0d3NGTitGZG1G?=
 =?utf-8?B?ZkczYU9HaXFFa3l3WG9CMkduNmNudGFZYXlseE9jcnRISTY1V294WDg1WVZ0?=
 =?utf-8?B?alRtZUlyaENPUzVLUWpKalF3TlhNVHl3cFFjNXVrVEplYkJ2cHpneXdoeDdG?=
 =?utf-8?B?bkdpdkRIdjIzTWdGR0N5SmZzMVBKSVNEMy9PeFpqNFA3YnFNUHpEYnd6Q0py?=
 =?utf-8?B?YTZUOGFuU0ZiOUh2THIrU0prbjFDa01hRGRhRWlQeUtTTWFESHhubmY4dXQx?=
 =?utf-8?B?VjN3NUI5cmx6aFhPQWd6aDdFbExsNHVzN3Jac2JCU09NYVJ0b3hidGwvRktP?=
 =?utf-8?B?QytsalYvK080Skd3VG5pajlla3FHNGFXd1NNRmtDZCs4OTZCam91SWVNbllI?=
 =?utf-8?B?RlJCa2I5OW9zY1krUHAyWk5pTnBIUDJqdlNNSVNQVUl2QmJVRXJlcFNnajIx?=
 =?utf-8?B?aGJXSUVZcnlxTXNUS1Y4NlZkZEJKbnVIT2E3Nk1uR1hwR1FzWmhUaUw4UkJn?=
 =?utf-8?B?dU5IZGh4OUd4Tm91ZVRaMFRjVUtUQnRMQmpMTlFWd3lsRXZXZlRGSFhEWXRM?=
 =?utf-8?B?MTJzYjhpbmJ2Qm01ZTlHcU5BWThQV3dpSFYwVUVoTHkxUUd2QUZRazFkOFAz?=
 =?utf-8?B?YXp5SzhhamtJTWxITG1jd1lydGlldnNyaHNUb1NFdC85cGkwc1ZRSHJoNTRS?=
 =?utf-8?B?TmFGZmFlR2IvRFhZS1E3RVpXKzA0Zkg2OWVPMUtuSVdnOFhaK1BpUkQyenBv?=
 =?utf-8?B?NjcxQnNvRHFKSTJibTNCN2MzK0dGeTRZdmtNN2lsWDFvMmdmYnJMMjBGM0NZ?=
 =?utf-8?B?UkJKODNtY05lUW5HZzFzc3NBNk5jT0wydVhMekVHa3c3d0c2OEY2eE1nNFFX?=
 =?utf-8?B?TVZzTWl0NWV0STl6SXl1Z0lSeFpUamJQNWZPQlNQdm80V2JqSmdlNE5MS3R2?=
 =?utf-8?B?dVBiblE4Y3VUeUdaOVY3UTdwTlc1K3JJL1FUaDNYQWhFaHdLdWRJUStkMlhX?=
 =?utf-8?B?RXVTV2lacnpSVVRpTTRHRE1NckhOdVAwR3hBd1U4a0xWMVR4TXVtd2hyMHN5?=
 =?utf-8?B?a3lCbDBURFlBQXBJM1NqQUFRMndpK1U4TXNIU2NScDlxS2RsNWUxMitFU0xn?=
 =?utf-8?B?YnB3Yjc1NHp1akNpeDFjL1l0dVdkcVF3VFJpcXdnSU5uNEcyRm5pWU9HRW9Q?=
 =?utf-8?B?ZXpla3lPQmdseVhhQ0NSMEJsQVVNcDlId2wxUDJEL0Y3N0pwT1Y1VlBnVGtm?=
 =?utf-8?B?K2YyK2VsTGV2WjhyNEdHTlR2NmhYZXRvSUM4MDNKSGNnVllRckhJb0hPYXV0?=
 =?utf-8?B?OGEwZTNNL1RNYWM5cjBSYXpNdTMyeFlVSU1LbUdqOVRBZWFhcDdFd2NBYVlv?=
 =?utf-8?B?SmRnTC8zUGhhZm84Y0VqUGtMTVd1WkdOWEg3UnBya3ByaSszNmFPa2ladnp3?=
 =?utf-8?B?N1pMbkRDbFdVdENLNVhTTlI5Wm1tRDBBckZNMWRQMnZFMTd5ZlJ5V2hGdkN1?=
 =?utf-8?Q?2wEldDKRSBRkmkv2K0+JULd2Q1F6a0YPaNzLNn6ZQsul?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1061053f-ec48-490f-80e5-08dbecf06adb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2023 13:22:33.3417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dmBcylSl8+n0kkQoLCV+H7SX2/E2sUhOkX4GF+k+23TkZxK+KBMXzAiPW1dneSEUbUeqZkgr/9EcDWU6J7J6QdrgpPT7gCyW4v44Twvqae/DIlXFWlZjYp37ikWh4s8O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB8037



On 24-11-2023 06:21 pm, Marc Zyngier wrote:
> On Fri, 24 Nov 2023 12:34:41 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>>
>> On 24-11-2023 03:49 pm, Marc Zyngier wrote:
>>> On Fri, 24 Nov 2023 09:50:33 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>>
>>>>
>>>> On 23-11-2023 10:14 pm, Marc Zyngier wrote:
>>>>> On Thu, 23 Nov 2023 16:21:48 +0000,
>>>>> Miguel Luis <miguel.luis@oracle.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>>
>>>>>> On 21/11/2023 18:02, Marc Zyngier wrote:
>>>>>>> On Tue, 21 Nov 2023 16:49:52 +0000,
>>>>>>> Miguel Luis <miguel.luis@oracle.com> wrote:
>>>>>>>> Hi Marc,
>>>>>>>>
>>>>>>>>> On 20 Nov 2023, at 12:09, Marc Zyngier <maz@kernel.org> wrote:
>>>>>>>>>
>>>>>>>>> This is the 5th drop of NV support on arm64 for this year, and most
>>>>>>>>> probably the last one for this side of Christmas.
>>>>>>>>>
>>>>>>>>> For the previous episodes, see [1].
>>>>>>>>>
>>>>>>>>> What's changed:
>>>>>>>>>
>>>>>>>>> - Drop support for the original FEAT_NV. No existing hardware supports
>>>>>>>>>     it without FEAT_NV2, and the architecture is deprecating the former
>>>>>>>>>     entirely. This results in fewer patches, and a slightly simpler
>>>>>>>>>     model overall.
>>>>>>>>>
>>>>>>>>> - Reorganise the series to make it a bit more logical now that FEAT_NV
>>>>>>>>>     is gone.
>>>>>>>>>
>>>>>>>>> - Apply the NV idreg restrictions on VM first run rather than on each
>>>>>>>>>     access.
>>>>>>>>>
>>>>>>>>> - Make the nested vgic shadow CPU interface a per-CPU structure rather
>>>>>>>>>     than per-vcpu.
>>>>>>>>>
>>>>>>>>> - Fix the EL0 timer fastpath
>>>>>>>>>
>>>>>>>>> - Work around the architecture deficiencies when trapping WFI from a
>>>>>>>>>     L2 guest.
>>>>>>>>>
>>>>>>>>> - Fix sampling of nested vgic state (MISR, ELRSR, EISR)
>>>>>>>>>
>>>>>>>>> - Drop the patches that have already been merged (NV trap forwarding,
>>>>>>>>>     per-MMU VTCR)
>>>>>>>>>
>>>>>>>>> - Rebased on top of 6.7-rc2 + the FEAT_E2H0 support [2].
>>>>>>>>>
>>>>>>>>> The branch containing these patches (and more) is at [3]. As for the
>>>>>>>>> previous rounds, my intention is to take a prefix of this series into
>>>>>>>>> 6.8, provided that it gets enough reviewing.
>>>>>>>>>
>>>>>>>>> [1] https://lore.kernel.org/r/20230515173103.1017669-1-maz@kernel.org
>>>>>>>>> [2] https://lore.kernel.org/r/20231120123721.851738-1-maz@kernel.org
>>>>>>>>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/nv-6.8-nv2-only
>>>>>>>>>
>>>>>>>> While I was testing this with kvmtool for 5.16 I noted the following on dmesg:
>>>>>>>>
>>>>>>>> [  803.014258] kvm [19040]: Unsupported guest sys_reg access at: 8129fa50 [600003c9]
>>>>>>>>                    { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>>>>>>>
>>>>>>>> This is CPACR_EL12.
>>>>>>> CPACR_EL12 is redirected to VNCR[0x100]. It really shouldn't trap...
>>>>>>>
>>>>>>>> Still need yet to debug.
>>>>>>> Can you disassemble the guest around the offending PC?
>>>>>>
>>>>>> [ 1248.686350] kvm [7013]: Unsupported guest sys_reg access at: 812baa50 [600003c9]
>>>>>>                    { Op0( 3), Op1( 5), CRn( 1), CRm( 0), Op2( 2), func_read },
>>>>>>
>>>>>>     12baa00:    14000008     b    0x12baa20
>>>>>>     12baa04:    d000d501     adrp    x1, 0x2d5c000
>>>>>>     12baa08:    91154021     add    x1, x1, #0x550
>>>>>>     12baa0c:    f9400022     ldr    x2, [x1]
>>>>>>     12baa10:    f9400421     ldr    x1, [x1, #8]
>>>>>>     12baa14:    8a010042     and    x2, x2, x1
>>>>>>     12baa18:    d3441c42     ubfx    x2, x2, #4, #4
>>>>>>     12baa1c:    b4000082     cbz    x2, 0x12baa2c
>>>>>>     12baa20:    d2a175a0     mov    x0, #0xbad0000                 // #195887104
>>>>>>     12baa24:    f2994220     movk    x0, #0xca11
>>>>>>     12baa28:    d69f03e0     eret
>>>>>>     12baa2c:    d2c00080     mov    x0, #0x400000000               // #17179869184
>>>>>>     12baa30:    f2b10000     movk    x0, #0x8800, lsl #16
>>>>>>     12baa34:    f2800000     movk    x0, #0x0
>>>>>>     12baa38:    d51c1100     msr    hcr_el2, x0
>>>>>>     12baa3c:    d5033fdf     isb
> 
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This.
> 
>>>>>>     12baa40:    d53c4100     mrs    x0, sp_el1
>>>>>>     12baa44:    9100001f     mov    sp, x0
>>>>>>     12baa48:    d538d080     mrs    x0, tpidr_el1
>>>>>>     12baa4c:    d51cd040     msr    tpidr_el2, x0
>>>>>>     12baa50:    d53d1040     mrs    x0, cpacr_el12
>>>>>>     12baa54:    d5181040     msr    cpacr_el1, x0
>>>>>>     12baa58:    d53dc000     mrs    x0, vbar_el12
>>>>>>     12baa5c:    d518c000     msr    vbar_el1, x0
>>>>>>     12baa60:    d53c1120     mrs    x0, mdcr_el2
>>>>>>     12baa64:    9272f400     and    x0, x0, #0xffffffffffffcfff
>>>>>>     12baa68:    9266f400     and    x0, x0, #0xfffffffffcffffff
>>>>>>     12baa6c:    d51c1120     msr    mdcr_el2, x0
>>>>>>     12baa70:    d53d2040     mrs    x0, tcr_el12
>>>>>>     12baa74:    d5182040     msr    tcr_el1, x0
>>>>>>     12baa78:    d53d2000     mrs    x0, ttbr0_el12
>>>>>>     12baa7c:    d5182000     msr    ttbr0_el1, x0
>>>>>>     12baa80:    d53d2020     mrs    x0, ttbr1_el12
>>>>>>     12baa84:    d5182020     msr    ttbr1_el1, x0
>>>>>>     12baa88:    d53da200     mrs    x0, mair_el12
>>>>>>     12baa8c:    d518a200     msr    mair_el1, x0
>>>>>>     12baa90:    d5380761     mrs    x1, s3_0_c0_c7_3
>>>>>>     12baa94:    d3400c21     ubfx    x1, x1, #0, #4
>>>>>>     12baa98:    b4000141     cbz    x1, 0x12baac0
>>>>>>     12baa9c:    d53d2060     mrs    x0, s3_5_c2_c0_3
>>>>>
>>>>> OK, this is suspiciously close to the location Ganapatrao was having
>>>>> issues with. Are you running on the same hardware?
>>>>>
>>>>> In any case, we should never take a trap for this access. Can you dump
>>>>> HCR_EL2 at the point where the guest traps (in switch.c)?
>>>>>
>>>>
>>>> I have dumped HCR_EL2 before entry to L1 in both V11 and V10.
>>>> on V10 HCR_EL2=0x2743c827c263f
>>>> on V11 HCR_EL2=0x27c3c827c263f
>>>>
>>>> on V11 the function vcpu_el2_e2h_is_set(vcpu) is returning false
>>>> resulting in NV1 bit set along with NV and NV2.
>>>> AFAIK, For L1 to be in VHE, NV1 bit should be zero and NV=NV2=1.
>>>>
>>>> I could boot L1 then L2, if I hack vcpu_el2_e2h_is_set to return true.
>>>> There could be a bug in V11 or E2H0 patchset resulting in
>>>> vcpu_el2_e2h_is_set() returning false?
>>>
>>> The E2H0 series should only force vcpu_el2_e2h_is_set() to return
>>> true, but not set it to false. Can you dump the *guest's* version of
>>> HCR_EL2 at this point?
>>>
>>
>> with V11: vhcr_el2=0x100030080000000 mask=0x100af00ffffffff
> 
> How is this value possible if the write to HCR_EL2 has taken place?
> When do you sample this?

I am not sure how and where it got set. I think, whatever it is set, it 
is due to false return of vcpu_el2_e2h_is_set(). Need to understand/debug.
The vhcr_el2 value I have shared is traced along with hcr in function 
__activate_traps/__compute_hcr.

> 
>> with V10: vhcr_el2=0x488000000
>> with hack+V11: vhcr_el2=0x488000000 mask=0x100af00ffffffff
> 
> Well, of course, if you constrain the value of HCR_EL2...
> 
> 	M.
> 

Thanks,
Ganapat

