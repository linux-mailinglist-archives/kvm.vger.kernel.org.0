Return-Path: <kvm+bounces-13969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8FF89D1D0
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 07:10:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C474928470A
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 05:10:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F765646E;
	Tue,  9 Apr 2024 05:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l7jNsjtw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2139.outbound.protection.outlook.com [40.107.237.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D588138E;
	Tue,  9 Apr 2024 05:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.139
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712639406; cv=fail; b=pQ/y50woPQqHOeWjcDs+xMSJjpCAjEDa92p+ZO+5cwe1GSOEglrQd3nIIEL7bs32zEOwug2fg1s/x9NmyrFjXPXuzTwIAMnuQW1dfxNURH+AWNlK9R3E+AxRZkyWzLQNbARLZS4sXUuuhOvtcxtRphEnOu+WMGwH6xdAZSBgOww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712639406; c=relaxed/simple;
	bh=JzUi6/BRSgRXfwyrjMVWYG/frQWlzqKvCrmhJtceBkg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YVW4RXWZ74U7etrgRkTDs0Kc5hSg72Gyt94GiMKVPG9hOIBOFY3bHwuhmp4hqv+HCL2PZ9ErYpiqRyaBLlkzzMS2GovM8W2/J3Y3aunMTp1jYxmgmb+OJLyWQ2J3wS3khwQ2gd+LNqk4aL4HJN4/bS547R3+WH4orOgoBCX4b1Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l7jNsjtw; arc=fail smtp.client-ip=40.107.237.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOTUJmw6cJgMzbe0o7R9Cul1JdH+l+qVznKhbEe1H0acjIH7JBc241s+EY3wiopnCymbp4aEgyh4y2bWvzp3Kc3lNLD7V7O1ZEPn4+6oxJ/kyt+04umN8ubhOAsq0df5SflX9TEHL0iu0rruHwK2EyAZ0Dp6PgNkXtwDnzX1fHJJH2YwS/yxZKHLPjOKQ1CA4x7UyTaLSupefVhxevpXGHdPmPlmTUoF7PrWOa+uZ1PZUZrlkRz+EELmtgbxoLItjiVQ7iQJCjOe3RX7Q7xZ1JyhqnHc9NNSwE2uz0rKZG6Ck/N9m8u7/W5rE1KbTcKjSRtengQyV9WU5j+sooOFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6Ts0G5uwRAnSVXR82LWg+sqgcTqKhdCntM5t6QKYb4=;
 b=DuS0HQMzIT5mbrk5KIfVUc/dtZiagiH+yonAQgSbsXKVoiefdMqXiqcjoZYNpCtYDU0EelnfmI8Wil3q4kOXEaQkwNb7xhZVANrve6oirgc0D7RFSMIXbH1EgfzT7hEfAjjQCOkrTRjCF0hK9nQjwBZGP7il6KD1iHTMRqhVB/fsm1noPbfomoIpivZRv/OYPCr7mg9EXJ6/J/NvRBh1qJoHFEo+zJIAPeYYn+sj9QqYqwEQRf6LeBxvSGQ7DovMwU5to72MihksRdiQ7UepQHyHX39xJMDiatsDNqVBiX/VxLQHnOke/B64bLGZjjoTqXsFD3o9XUNLxYAhP//PUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6Ts0G5uwRAnSVXR82LWg+sqgcTqKhdCntM5t6QKYb4=;
 b=l7jNsjtw8JineIM46ss6mmYjSZ9Vq5kqblZTSw82OlDmP+w5DPHxl2O7jJG61hHP8b33j0Ls9fJxltcHwgPfxFbRv8+t7WB3jFU4zf95YvwpfQTgl0bnJ5tyFGVBzqKgI33hpIdPWCqCFlNqxRVnq4oPAuZZoqtIpIN9mB13TpE=
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH0PR12MB8174.namprd12.prod.outlook.com (2603:10b6:510:298::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.46; Tue, 9 Apr 2024 05:10:01 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1%4]) with mapi id 15.20.7409.042; Tue, 9 Apr 2024
 05:10:01 +0000
Message-ID: <19f634de-7d72-4abc-87ff-599d22e310bd@amd.com>
Date: Tue, 9 Apr 2024 10:39:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/3] Export APICv-related state via binary stats interface
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
 mark.kanda@oracle.com, suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vashegde@amd.com>
In-Reply-To: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0208.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH0PR12MB8174:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K8qbvJvC/TBamAa4EdOlFVnQF3F63VVnfiPjHs19U93x+yQlbDL2pMWUX298R5PleXNxKmiMEFMkzSrwaLVVvVOOhVkra41ABcBzChw3Il68wRo0AoSuAC6FTnLABIn5iF6Zj3jcdwd5QfPByb9bvTcNjul52iWcBAajHt44+ENzIGfqP7/92zbWqArHQPzxiJM1W7yBUOTtrVVIRaLcfVeXImvBNq+u+FAQJpEZmn08eOyb9Ov9Ufkvh/J8LtSYIqtoC6KIBbPo9D5sR/bcRHwqy1iAhtF+ewgpGvMmZVkB/w/Pfar1RIYLVlO/akwc1uHpqRqCoAYsWlKtZgWcAqz3yTTWB43NvSp1s2Oy20NXLtwHVzkum/KSFIvFiWlcm7hOEW2f4mhX1o3Sn3A3tL5DlewQnfFwlETKVodvX6RXT0SMDmGBZ7adF2czgOnLqgVVcdyjjcoU0asQFGSmk/3fYK5HR2974EQ+LwBQVkz4qiOiUFBXtsmpaYmoWlojLkEDOlF4fi4bM1bIeD4t/+0quprXwQAb9bdxTzHmSm7dVQ/U54ITLS0EXbEQm3vNt5DFes0Kf7HQoZCR6DSRBRrQNZh4zXwoBIa8Wwls2T5UKPPNXpvRaQVoulEE0faV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkQreWt1WGZrOTBHZWQ4cXJCRzBXbVZzeDJmR0FJaW9rM0ErcFY5QXNzQ2pD?=
 =?utf-8?B?N2ZTdE9VU1FkQXdQZ2pPTjdDaVBUMnJsKzkzWTFLTkk2dFFaVGo2OS9yNVdJ?=
 =?utf-8?B?UVdKYXRYZXk2K2FibloybzdVbDVFM2ZiRG1UYjJYeU9zTndpc084b1pTbVhM?=
 =?utf-8?B?TUZMRG1qVFhZK2lqUWRTb3J1bVhBM1dRT3R6UzA1UUUvaUlwU1VadUhqR084?=
 =?utf-8?B?cmg2R1lYdzR6TmNuYStpcXRyNVdJMk8zTTJOV0ZNVlpaU3JKUjRPY2wyVnBM?=
 =?utf-8?B?bk5SVStPUkhZWVRnN1VmK0MxbVRINklZSFhqSXZVczc1dGNTVVBGd3Voc0tQ?=
 =?utf-8?B?bVZFZFNmajFUdUFOcyt5bTgzc1RINENwZnkrMjRqOHppZ29mQUVOYjd6MjBH?=
 =?utf-8?B?eHlnN2hSYitQdWcxRG5ZU3JhOWpFdVBQTitZU0UzR2VGSTdpM2xWMUdrVk8r?=
 =?utf-8?B?WGJqdzJpRUl1cHZiTFpyUkdlaFVNQ1lmWFFoY0RDZ3JtY1kzSmptTEY5bU01?=
 =?utf-8?B?KzVERE1mRXkrbmtDbEdVbzdLV2NpQmNQZ25Ub0lmZ1ZZaFBGS1BYZU1lVnMr?=
 =?utf-8?B?UEJLa1hRVUhFK25MK0ZuU1J5QTZOLzFYZEYxMVVFenA3NnoyTG5TWTFZRUdV?=
 =?utf-8?B?MFhJNEJ1bXZlYjZuQ1FHTHJScW1oWFNLVTlLYWZaVDNvRkYzVjQ5a1IzaStl?=
 =?utf-8?B?ZTV2QVBobnFDU3k5QUVCUXNFVEJ2VzZnejNEc1d6djJsa3FQOXVRU1lJL0tC?=
 =?utf-8?B?c1BPN0VMbmQwSDdXa0hLUGNTR1JMQmd3Q01PZGtHMzY4cmVjMitzSFN6L09F?=
 =?utf-8?B?OEU0bFZubjJ1TUNlTHhGTTVIcXZVc1MzZ0JhQW85cXNLWFJQS2FkVFlJT29l?=
 =?utf-8?B?T3YvMVkrbWVscTZzL0txVDltbDhYbUE3UGJwUk5CcmZzb1dIaUFYMTErUU9O?=
 =?utf-8?B?ZmEyOGU0Z09WZEsvZ1MwcWJwdzVpTEp6Tnlad3dPWFZRT010QzZ6UnhJWEZL?=
 =?utf-8?B?WjBZRmFTcCtGUGdnL0pKRXhMa2hkUmpuTmFXQmFvQjh3NVM5eFVRYW1uN3E1?=
 =?utf-8?B?UGpZcncrNnFrdTB0c1FWUHg0VVRlNTgyNlA5aGlyU2k4aVcvUk9xVGZwQkZi?=
 =?utf-8?B?dGNWbmE2TjdtTDhXNzgvcVJXOXBsUWFOOVYrZFlSdmRqTlhid0Z6YnpWZmx2?=
 =?utf-8?B?T2czNnZUVEs0aGpIamlBQ3AxZHhENUhFcEt6bGJnZXVuOW1PUU9KK2wzbG9q?=
 =?utf-8?B?NkFueXhkY0NrRnBpQ0E4Q2lUNytZb05wWUJnZjNpdGswUWMzWmVEQWNmdXVL?=
 =?utf-8?B?dTB5ZTZFZFdjNFBWY1E1S29mcHpPcHBrNXYwbi9PRHkzS2tuQTQ1a3doU0FN?=
 =?utf-8?B?QlFRaXhPVWxjZ3JkdUtPb0Zob2lpN2N3dCtWSVp6d0FCbzhscklpQzVYTW9L?=
 =?utf-8?B?VStocGVPeTVYR09ydUJnWnF2TnZnd2FtM2FMaHdXa1NRbkRaNGVySVpSbGtk?=
 =?utf-8?B?YnZDcitjZ2dNOHg5SkZZZFA3SmNJcWYwM1hteXJlU1MvUFg5akI2aEtvdDRO?=
 =?utf-8?B?WS9qZzNkcGdBWXdNYUdRSEtPTjB4WWs1ZWdyNzdBU2dhK01wR1hIL01Jb1Bp?=
 =?utf-8?B?alZwK3R3YVl3aVVwbVZwT3c0L2ZKTG1QUDdQNjRqVGpIV2NtbTFyekxodHNX?=
 =?utf-8?B?SXpOTGtJSVFsUGhJcFkzVGVnV1BCTTN6ZEJISW1UVHlST2pkU0t6bGhyODZV?=
 =?utf-8?B?MEI2dUE0Z05RWHRvbDJoZnY4OHZZaUl3cDEzancyTmF1YlUrL0VXb1YvenB0?=
 =?utf-8?B?S1hMaVE2SGxZaXl5UUl3TENPUTEzU1I0M1RKbFF2RHNkVGlwNWhDdmIrZkpR?=
 =?utf-8?B?VHE3d1FBM0VFZDBLNDJPSEg5SkdUbGc3QTk1NStXcEk0V1Z5YXZ5TjdMUmsz?=
 =?utf-8?B?UHBzd3NFb3pzaVhUdWU2K0xXKzY4ZVdCU29tWG9kemxDUjJjK2NqRW5oMnBx?=
 =?utf-8?B?TWdCeVlNZFdRZXpJc05ydWxuZUk5dnN6UmZKMW1pNjQ0Z0xPWUZlKzV0Y3I4?=
 =?utf-8?B?VThYRWNQaUhKcFRpdm9BNCtJYzVlUmZhZGdyZVdKblN0ZXJHeW9wY1lkRmRG?=
 =?utf-8?Q?uFCrNE2bCJRnfYgrM8ZArJXl8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5ef270d-b437-4ec1-4b36-08dc58534ed8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 05:10:01.3118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U69+9jNVvSvsHW4SFr7Xk5ccYom/C7slEoTXg9nK2SlWKkxC6ETA+0huJK1XBtUiAqCVTcez3uSMuHIhGNI6Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8174

Hi Alejadnro,

On 2/15/2024 9:31 PM, Alejandro Jimenez wrote:
> The goal of this RFC is to agree on a mechanism for querying the state (and
> related stats) of APICv/AVIC. I clearly have an AVIC bias when approaching this
> topic since that is the side that I have mostly looked at, and has the greater
> number of possible inhibits, but I believe the argument applies for both
> vendor's technologies.
> 
> Currently, a user or monitoring app trying to determine if APICv is actually
> being used needs implementation-specific knowlegde in order to look for specific
> types of #VMEXIT (i.e. AVIC_INCOMPLETE_IPI/AVIC_NOACCEL), checking GALog events
> by watching /proc/interrupts for AMD-Vi*-GA, etc. There are existing tracepoints
> (e.g. kvm_apicv_accept_irq, kvm_avic_ga_log) that make this task easier, but
> tracefs is not viable in some scenarios. Adding kvm debugfs entries has similar
> downsides. Suravee has previously proposed a new IOCTL interface[0] to expose
> this information, but there has not been any development in that direction.
> Sean has mentioned a preference for using BPF to extract info from the current
> tracepoints, which would require reworking existing structs to access some
> desired data, but as far as I know there isn't any work done on that approach
> yet.
> 
> Recently Joao mentioned another alternative: the binary stats framework that is
> already supported by kernel[1] and QEMU[2]. This RFC has minimal code changes to
> expose the relevant info based on the existing data types the framework already
> supports. If there is consensus on using this approach, I can expand the fd
> stats subsystem to include other data types (e.g. a bitmap type for exposing the
> inhibit reasons), as well as adding documentation on KVM explaining which stats
> are relevant for APICv and how to query them.

Thanks for the series. IMO this approach makes sense. May be we should 
consider adding one more stat to say whether AVIC is active or not. That 
way,
  Check whether AVIC is active or not.
  If AVIC is active, then inhibited or not
  If not inhibited, then use other statistics info.


I have reviewed/tested this series on AMD Genoa platform. It looks good 
to me.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> 
> A basic example of retrieving the stats via qmp-shell, showing both a VM and
> per-vCPU case:
> 
> # /usr/local/bin/qmp-shell --pretty ./qmp-sock
> 
> (QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['apicv_inhibited']}]
> {
>      "return": [
>          {
>              "provider": "kvm",
>              "stats": [
>                  {
>                      "name": "apicv_inhibited",
>                      "value": false
>                  }
>              ]
>          }
>      ]
> }
> 
> (QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_accept_irq','ga_log_event']}]
> {
>      "return": [
>          {
>              "provider": "kvm",
>              "qom-path": "/machine/unattached/device[0]",
>              "stats": [
>                  {
>                      "name": "ga_log_event",
>                      "value": 98
>                  },
>                  {
>                      "name": "apicv_accept_irq",
>                      "value": 166920
>                  }
>              ]
>          }
>      ]
> }
> 
> If other alternatives are preferred, please let's use this thread to discuss and
> I can take a shot at implementing the desired solution.
> 
> Regards,
> Alejandro
> 
> [0] https://lore.kernel.org/qemu-devel/7e0d22fa-b9b0-ad1a-3a37-a450ec5d73e8@amd.com/
> [1] https://lore.kernel.org/all/20210618222709.1858088-1-jingzhangos@google.com/
> [2] https://lore.kernel.org/qemu-devel/20220530150714.756954-1-pbonzini@redhat.com/
> 
> Alejandro Jimenez (3):
>    x86: KVM: stats: Add a stat to report status of APICv inhibition
>    x86: KVM: stats: Add stat counter for IRQs injected via APICv
>    x86: KVM: stats: Add a stat counter for GALog events
> 
>   arch/x86/include/asm/kvm_host.h |  3 +++
>   arch/x86/kvm/svm/avic.c         |  4 +++-
>   arch/x86/kvm/svm/svm.c          |  3 +++
>   arch/x86/kvm/vmx/vmx.c          |  2 ++
>   arch/x86/kvm/x86.c              | 12 +++++++++++-
>   5 files changed, 22 insertions(+), 2 deletions(-)
> 
> 
> base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4


