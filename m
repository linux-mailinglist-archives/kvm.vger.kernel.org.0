Return-Path: <kvm+bounces-6982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB91483BB79
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E16251C21F53
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 08:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 120C317BB4;
	Thu, 25 Jan 2024 08:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="aQa0CheU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2104.outbound.protection.outlook.com [40.107.244.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF381798E
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 08:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706170490; cv=fail; b=A2SFTRJrZAaxNYAMLue5pbvPvff/FBv9LyHLw+EcJ6gsSclE/ylux/uyAPUsLYki4cas06Xex5f8HJBW0o+N1KiJNOxXy4tyjjtvizr0DraHlCvi57wKYe8KETceuziRBwx2tPwqeDZ7ZaPFBjFuBuHpN3Pd3pEsqGX0yNyYY/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706170490; c=relaxed/simple;
	bh=iXEZO8kIjeLqGH1ZH8Dwz34Zb9O6ZipYLAXJidP+2IU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RGWjt9+LMcRriGp7lGp1yGn6c2sDZzuQt3LvGLJS3PJ1/BR21odQELf2SAC7GtqlMBs8V6TVuHCrOyl8cKp9ciU3lA8S8mnsAHKZJMSWZq272uUzYHUt4Urv6avH2Hj0p7dNGf2Ztx/oSaiEsSPi68ruar4liiKGM/s3elwIbHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=aQa0CheU; arc=fail smtp.client-ip=40.107.244.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwtHUgnzb1IkcG+WgIuyN+NCv6taTomq3sRCPUQgColQozFNzUf4JVie9w5ZkDHHSNNTl/EdO5/XfK3ORzi6hiKii2mXPVD01N9tGETISO5LOBpP9QY/mWWPCuyzN6+ot1yCJguidVtbYRdiHLYN8AESmV/5w1gKkryHFuvOth4IcItJNrDhCVImbjETXzYb024zjkGSsXkknMI8EXoca9RvX3yVlZlJFIW7Zub/+wTPf0KIj33QghP3v327fUZKEKIuuNgDE5g5Z3kwr4XQ27bZbWsTg7Vvs0LZqZwa7SQP2tBHHASnZm98546rPOy7QrSAph+VdippBsEo1QhDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0xj3M+k3GJLaTzUSGWj0lEhokgo3+w5BngQLsqSrbT8=;
 b=k2L+TanIyWA5qYgKBmA9QUVcWUwGzpmUiQ1a+3m9FUkqJOAn128EgYmhfcaoRBlnGAwCGmOWcxYJx7eSguvG8hDWSmZxOhtzZqq+cpnwAUrcgqWZHQstK3bP7sWUSjY1IUfowqoCoDgKLZ1ogb1TueXop33n1qhp9FYQ270xXAhsiv4tFT4Lk3WNwNrvSvuVSr3kH4yTlR4A8H/EH7R8FjF/623KrEkXlhKZrXDp6nM78sulsJ8Rdyusu02GFCB7psNqYpwQ0dFznkS3g0rwl+qceeo5xVg9NRggJE+hviXMBah61INnZyrni2Js4R8ZX6qODuvjH4ciN8ADgSsekQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xj3M+k3GJLaTzUSGWj0lEhokgo3+w5BngQLsqSrbT8=;
 b=aQa0CheUL6TEHnzD/vLI2UKMGC2MxApzKN9Q/0fG45vQGrKd4VgZpqDGrQJSd/uMt8e/lo70NJIgPtkVW8P0jTc9CRmyu7w20DVjl/4N1wTyUG65Hd/wp4q+fPJub6K9BYgZmxPttr7RUV5PZIG3OZ6WwA52/Io5uj6XyLxLUHE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 SJ2PR01MB8617.prod.exchangelabs.com (2603:10b6:a03:542::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Thu, 25 Jan 2024 08:14:44 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::a0ca:67bd:8f75:4f37%5]) with mapi id 15.20.7228.023; Thu, 25 Jan 2024
 08:14:43 +0000
Message-ID: <3b51d760-fd32-41b7-b142-5974fdf3e90e@os.amperecomputing.com>
Date: Thu, 25 Jan 2024 13:44:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/43] KVM: arm64: nv: Support multiple nested Stage-2
 mmu structures
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Chase Conklin <chase.conklin@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Darren Hart <darren@os.amperecomputing.com>,
 Jintack Lim <jintack@cs.columbia.edu>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Miguel Luis <miguel.luis@oracle.com>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 D Scott Phillips <scott@os.amperecomputing.com>
References: <20231120131027.854038-1-maz@kernel.org>
 <20231120131027.854038-18-maz@kernel.org>
 <f0416fa9-b4f1-4bad-a73b-b1d7ecbffc62@os.amperecomputing.com>
 <86le8g86t6.wl-maz@kernel.org>
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <86le8g86t6.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:610:118::6) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|SJ2PR01MB8617:EE_
X-MS-Office365-Filtering-Correlation-Id: ab1427ad-8e16-4a77-7afe-08dc1d7dafc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oVH7VHw3n8LcUzUzZVYyQAjcWUFq9G9l1/4kl5g7vUIkLnkp1ysVqfsp21wWk45wFmr8BSEBoYs+6SAO1Kgwki/6l9MZzXtaWuG4WHAXTX1AFUEVCF/3S2+ddWbrogj6LIulK0WJZHyOhwpc2t1QFeRwaTdb4p7dBXG4ZnC7J7TPRdV5rZKPLcEkDT+9SZ2sKiB83w9T1CEt39qHf4Wn/bgdiZ5pyUGFq1pUpfR4Oq7CH1WKKX4MgaoTTV3IqyVWmM3txhQIkk8V80JqNjJnYA2CuIlzh1qLowNp1JQIkCHsEajf20aBctWt9l1cHi+CCQcszqfFO/UWljERC0KQ+7d/Kbv5cT8PsdjFzlMgt4O2pp3m/5tewvEUdfvWXbIgilk1dndYA3eke+b7fN8sUJ7cv3PWiKhXnY0uUm2+xFC9EKBEgPbvOIz7IPabCxoL3o+4g69blhdCdZUVxaBKaej1GlEOwhhHSbY0KMSkjWjjkqGK35NK5NiZ5W/aadx0xuCGSVIDh3+fxCGdRa81fc6jX2IdtUTlzyvOl3z5HE85wr1zoZ1ImUmv3ofQKPodRTVEDb+TFbsl0vP29GTp2d750nB/oUHLYdHqdDwj1hhCWMLqdkZrUGIilidYHbav
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39850400004)(136003)(376002)(346002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(31686004)(83380400001)(41300700001)(31696002)(86362001)(38100700002)(2616005)(107886003)(26005)(6512007)(6916009)(66946007)(66476007)(6506007)(66556008)(6486002)(53546011)(316002)(6666004)(478600001)(54906003)(7416002)(2906002)(4326008)(5660300002)(8676002)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cTQxd2tPMVlOSnFpb0dZOE01RG0vQlJ2S2xmKzdqKzNVZ1MrRXA0R0hYUXFE?=
 =?utf-8?B?aDlsYjlPSnh2U1hFSi9paVlLaWt5ZU1LeHh0L1dJRG9hYzJlaWNxcUtBNUtz?=
 =?utf-8?B?TEZ0cjdKSVhlZUhzcndUS1hmVnoxOSt2ZW5xQlA0MDhySnZrRHZLUlQ0L0lj?=
 =?utf-8?B?TXErMGtQS3BVRkNGZXA1TlRPRnVodFdaSUUrcTRCbThEUEEzTXNkdEw4R0ZR?=
 =?utf-8?B?NllqamVtdVhjeGhrZHR0dWhyNFBZY003TWhLTXJLcHhOMXZENk1GR3pac1dK?=
 =?utf-8?B?ZkFmS0dvMnFNNUp2Lyt2UG5RbHJCaXorTjdKazRmRmsyODRGSlY0TFgwSWFs?=
 =?utf-8?B?U2EwaGpzbllyT3MzM2tINGFjV055OVU5MXd0TWJFck0zVUZ1Q3crb0IzZlhj?=
 =?utf-8?B?ZFFUVHBhdC9xVUpMUEVad0F6RmVUaVNmcFdWQ0c0M3NjMnBUdlp0d1d6KzZV?=
 =?utf-8?B?ZEFPTzZyNlpxeTdSaExiVkdCQjduUWJ5aDZiSE1HZlJGdWx0eXpGUHRFcWt5?=
 =?utf-8?B?V1Nidmx0T3BkSWlOeWZGR3MvQ0UxVjZtcmlMa3JKUXZVVC9HS29tZ093NXNi?=
 =?utf-8?B?aStuQkZsYkdMTHNyNk5zRTBQZW5ERmhZUUNRSCtyRC9qT0dOWTkyemdoUWYv?=
 =?utf-8?B?STJYWXFXTjh5Ym5DazVQSVVDWFhaa1dGNTA2TlNkRXBpNTZMcWQrekQ4dDdF?=
 =?utf-8?B?Q2NvNnZXS3ZReXExTllncGpucHFNTnUwY0t1NFlZNVN3a21zUUJYQUFnL2dY?=
 =?utf-8?B?U2dtZ2RwNWVaUmR6MHVGbmg1MDNQMWJkRlJtOVVGbDZIQVlwUTMvWGFmeklt?=
 =?utf-8?B?VndDVHRzVzdFY1BBMDQ3dmxZQzZWVTI1SXFBN0RaM1BFb2NscWlxNjJmdWNS?=
 =?utf-8?B?eTZ4R29vYThDVC9HWWFFcDRtRGhyUWl0L28xd1pWeWdvZzVyVG5ITGRUTHFB?=
 =?utf-8?B?VmVtbFFxRVVQNWRvVnNaRkZnVlFBa29scXZDQlBMZzNGMXkrUEZJZFBscTVJ?=
 =?utf-8?B?WEtIcExlS05IcGdDeUJjYmpkNDNTTWxrRWFZWVNpU2hYZXBwS0NTTFFyY2dl?=
 =?utf-8?B?a2h0MUdVcDY5cmRmR29saVVMd1BRNFcwYytQaW1nVmptWVNDWDM5TFNFM2RG?=
 =?utf-8?B?aW8yMTBOUWpmL01DOGFqUThFZ3BvY0s4c3RNTGM0MEprQjNScDFNYW9RbWlT?=
 =?utf-8?B?YS83bEJQTkRmV21JMWE0c0lya1VaUU43cVJ1bmZxdXEvWUVDdVpkT2dCcmVR?=
 =?utf-8?B?ZmEwSWtGbmlCcFA3U2toMXJWL0pUN3JxT1FhZG53RmhWN05kMjZNSmp6QkFF?=
 =?utf-8?B?c0t1T25CMDluL05SQ3drdW5SN1k3WFhFZW5ObUVvVThRNU9SQllnclQvdDZO?=
 =?utf-8?B?WC9PcmM0ODJGU0NCZU82Qm80bFpTSXhtV1VzMjlUYTAydkFkcGt3bHJPZVdM?=
 =?utf-8?B?eHgwQmZIaC9tbGNXZ3BoaDhBTktUb0F1c3VReU83elFmVUQ2L1FMUm4zdVps?=
 =?utf-8?B?a3dxdEo5b0NBWGZWanNTa0RFVFZINERRZzJJcWhkYm1ibHNkK3ZOclY2TmNF?=
 =?utf-8?B?TEFxQTE0UittaVI4OXRwYXREK1RSYlFKYjZMZ0NRZ00rcklTaTdSSThXclR3?=
 =?utf-8?B?WXE4U1NSdi9kc21XM1dPa0ZHSDRPVy9pVkkrNWJRRUQ3ZnVnbnNRcUNIak4z?=
 =?utf-8?B?SSs0eU5BeVg0UDUzbHY3bXpOWS8vVjlCSTc4bnpiUUs3WisxVWNzTkNSNjRM?=
 =?utf-8?B?UkpPNEREekdaeTZHcE5lakxSbXB6U2czRjNIUGNEV3ROdklYWk55S01jTDhP?=
 =?utf-8?B?ck1mSXkrT1hmSThwcWF1dDd3L09kUVk4VE9udWZneFFlcDhMeStyS1FDeEdO?=
 =?utf-8?B?MjdwMlc0MDM5OTA1cDRKcjVXVWV1ZVVkaWVlazg1L2oxeWJndDFnckZIK2pS?=
 =?utf-8?B?STdKczBTOFBUSjFFcmhHbExyRnJRdjA3djhRd3crMGI1VzcvWjlCMzlFU2ZZ?=
 =?utf-8?B?d1U0QXdKaEVZMURrbTIzdHM1VzVBdDFud3lWbVVZS042SG9Qc09EZmdzYkxK?=
 =?utf-8?B?eTA3NEh4TWtDYnRHOEJTdU9tNnVHbzhrUHc1NllYdGpKZHo1L3p2M0gwRzhZ?=
 =?utf-8?B?Ulc5aTc2Q3J4REF0QVE4b2E4QWhkTGFycENrSnBkRzU2MjNBWnhPVVNrQ0Fq?=
 =?utf-8?Q?oG+op2V89ceSi1kAto8ye9Pp6bx21NpNolaYIAaJHxdx?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab1427ad-8e16-4a77-7afe-08dc1d7dafc0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 08:14:43.7969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycrDRjtCSILx+NRth00NKO9qriOAzyJZ9eVQNyLkkerGMp/NDepNZU5Nhhs/y7jZXG0/15r3sRUAUFjQ0NNrYVLA5rwfBln1w2plkld1piPVjN65IjfMjBPW1S3R8XmZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8617


Hi Marc,

On 23-01-2024 07:56 pm, Marc Zyngier wrote:
> Hi Ganapatrao,
> 
> On Tue, 23 Jan 2024 09:55:32 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> Hi Marc,
>>
>>> +void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (is_hyp_ctxt(vcpu)) {
>>> +		vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>>> +	} else {
>>> +		write_lock(&vcpu->kvm->mmu_lock);
>>> +		vcpu->arch.hw_mmu = get_s2_mmu_nested(vcpu);
>>> +		write_unlock(&vcpu->kvm->mmu_lock);
>>> +	}
>>
>> Due to race, there is a non-existing L2's mmu table is getting loaded
>> for some of vCPU while booting L1(noticed with L1 boot using large
>> number of vCPUs). This is happening since at the early stage the
>> e2h(hyp-context) is not set and trap to eret of L1 boot-strap code
>> resulting in context switch as if it is returning to L2(guest enter)
>> and loading not initialized mmu table on those vCPUs resulting in
>> unrecoverable traps and aborts.
> 
> I'm not sure I understand the problem you're describing here.
> 

IIUC, When the S2 fault happens, the faulted vCPU gets the pages from 
qemu process and maps in S2 and copies the code to allocated memory. 
Mean while other vCPUs which are in race to come online, when they 
switches over to dummy S2 finds the mapping and returns to L1 and 
subsequent execution does not fault instead fetches from memory where no 
code exists yet(for some) and generates stage 1 instruction abort and 
jumps to abort handler and even there is no code exist and keeps 
aborting. This is happening on random vCPUs(no pattern).

> What is the race exactly? Why isn't the shadow S2 good enough? Not
> having HCR_EL2.VM set doesn't mean we can use the same S2, as the TLBs
> are tagged by a different VMID, so staying on the canonical S2 seems
> wrong.

IMO, it is unnecessary to switch-over for first ERET while L1 is booting 
and repeat the faults and page allocation which is anyway dummy once L1 
switches to E2H.
Let L1 use its S2 always which is created by L0. Even we should consider 
avoiding the entry created for L1 in array(first entry in the array) of 
S2-MMUs and avoid unnecessary iteration/lookup while unmap of NestedVMs.

I am anticipating this unwanted switch-over wont happen when we have NV2 
only support in V12?

> 
> My expectations are that the L1 ERET from EL2 to EL1 is trapped, and
> that we pick an empty S2 and start populating it. What fails in this
> process?
> 
>> Adding code to check (below diff fixes the issue) stage 2 is enabled
>> and avoid the false ERET and continue with L1's mmu context.
>>
>> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
>> index 340e2710cdda..1901dd19d770 100644
>> --- a/arch/arm64/kvm/nested.c
>> +++ b/arch/arm64/kvm/nested.c
>> @@ -759,7 +759,12 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>>
>>   void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
>>   {
>> -       if (is_hyp_ctxt(vcpu)) {
>> +       bool nested_stage2_enabled = vcpu_read_sys_reg(vcpu, HCR_EL2)
>> & HCR_VM;
>> +
>> +       /* Load L2 mmu only if nested_stage2_enabled, avoid mmu
>> +        * load due to false ERET trap.
>> +        */
>> +       if (is_hyp_ctxt(vcpu) || !nested_stage2_enabled) {
>>                  vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
>>          } else {
>>                  write_lock(&vcpu->kvm->mmu_lock);
> 
> As I said above, this doesn't look right.
> 
>> Hoping we dont hit this when we move completely NV2 based
>> implementation and e2h is always set?
> 
> No, the same constraints apply. I don't see why this would change.
> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

