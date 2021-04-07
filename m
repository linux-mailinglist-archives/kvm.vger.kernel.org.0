Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE1E3572E7
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354723AbhDGRRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:17:03 -0400
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:52673
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235711AbhDGRRC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:17:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/CqrsLqCPMwiZHMa/8PlkSCOJ3sfxD3v7lseTfDmTFbeRmgBCPl2IIxN++oX7CmwqA4+ELKz/SN1NnQvLLL/tX9fIDU5wIZpGdf8t4EoA4IOQNNFPcExNxu4MmEgc34vuEmvtMWfmRkzPjBjxk90JGA5BBgbUhEhJkHXhdfjycV8hoiZPCxd1hTpcPZ4lEtHHnuHNaB2FjEbEXBE1coZEhXp0akbgsgOuYkp54nXOK/S33Hpet19Uh+YLbV4DBW44lZEKhn8KW6EYOHbx69Oj85k6hfocewdDaAyUGT/Vc0/nzN5viS8YoEs5T1rsJr1+oAdjoy53XGTlp0t0aqgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVCkUY5/5FIAt66FsPL5EkSkixonalKsV7IfqZrLAIc=;
 b=ZDTXTxhElxMeucxLBlsx0Of42MinkIEta8GLEYzbsP7kYdXCQvy5GQRO7xC14pwX4PWOKEt8T919E4YvSM+fmYXbLNnaTpsQkiSHyTOjz5o0iiMxQwgftvFxiaRI/XPBbhRJ/qgA51f7lNBk+Pn5z3rZl9ZcSuL+DjtQ58KR72ojl9Ae2qnKDE5AL9mMCxryqYrgftCoM5whKwzqEHvTm8xroXn8XWwy4Ixgwq1ZMrOP6B69XFJgoTkiDNnikPOA/0QEElnQ884cjn5u6CHtkhFKi/BA0njgrBjplKn5cJBcKn8WLMCDFVubZFUTWF/ZcCTXmmMdmWfCUhATThtstA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVCkUY5/5FIAt66FsPL5EkSkixonalKsV7IfqZrLAIc=;
 b=TiiCjYbRsNEXT66/3aQc3HFTj1n3s6QD7gSZbW8eJoQG6vaCeMAzT3/LPCfuFH0XUMMYJw+bjZzgMsO49EYktWmy4TKondVqnVFJgm3jZSmMPvgD8sCnQWMRdPiguAKe2yUm41iueUcOPtFY8f2CFsgIyyQF9bJ7+pBZQbinbEA=
Authentication-Results: csgroup.eu; dkim=none (message not signed)
 header.d=none;csgroup.eu; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 17:16:51 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4020.017; Wed, 7 Apr 2021
 17:16:51 +0000
Cc:     brijesh.singh@amd.com, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2 0/8] ccp: KVM: SVM: Use stack for SEV command buffers
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
References: <20210406224952.4177376-1-seanjc@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <26bbc4fb-3300-2c0d-61e9-79e88457ce94@amd.com>
Date:   Wed, 7 Apr 2021 12:16:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
In-Reply-To: <20210406224952.4177376-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN7PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:806:120::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN7PR04CA0060.namprd04.prod.outlook.com (2603:10b6:806:120::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 17:16:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4df5463a-5d0c-4524-8c9d-08d8f9e8eee0
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575729631149392D105D00AE5759@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:30;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7TQ7OgGG0O5ZRPqn2y654uKICnQmCQKBVkJvmOipmkpkLFm1iHP4PNE90AnQezdbHLv0Nb2ccLO6ySep+KJR86bwjZ4ioOjUWqpSHaW/WYBYOuR31QdtRq9UV2HMZ14Q/hMOg2q6EV4VOf+xFXp8cMH4b9kaYoXtzqVfVhgQN6PaIP44VXtXQy/9WaGzsYXM4YLZlVXgGUaXTebitqtmBaHyOav/EMSoCEOVmq9l/h7QI1vCB0sd16nEmKpCGar7cbeEnm+fg3dAMXJdixpz9qNjDPk2bQVj/2QUcOhEY6pEYiriwf01AS0DVdXaHk4KaYzJt1eaNWCaRIpSVQz/BfqD/Wr4ZP55G6YlwoJFZMkcJXrUNJIL9PHAEXdYj1yt0jwFBHGeHG7IK7+cabnJEIPocc6Z6nuFYbCra1y973w139z06x+KL5VwtWD9hxgvY8VYv3PI6EwkCTiwb5lzAUX+GiGX/nANpbPj6PdA6B7p7ZkUho3yoner8ByDCc+cisPHkOxNKG4jdFkPanyly1CHYn2Kbrhl2cSo3lt42ovG+f/kpuAQb7kabCPOZHh8PTszevYN53KUOfOcgDh8FiIdPLoDvW1q0UOnMq9z433mxW78lTOBkPmMyYtEJ8lcItHSVF2gl6SLdpQGsWu/C58/6+VowWABR2g3AR+AN0gVYcelq3KXQe4Ay2rEsv4ic7NGLk3P60IPjXmnm7yuoVtfm3+s7FEUqdQmblZg5qk3Ls2wJJpUmmM0lz5PfIhtGG9imW8Y6aAlzee6/83u+YQQjPIbkc4Caun9mDmGVjkVXHQZN7Fp6DdnyFk+egQYP/9Xu6jS++CLp926A8sbRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(376002)(136003)(396003)(2906002)(31696002)(4326008)(54906003)(66946007)(44832011)(31686004)(83380400001)(26005)(186003)(86362001)(2616005)(16526019)(956004)(66476007)(66556008)(7416002)(316002)(6512007)(8676002)(110136005)(6636002)(6506007)(53546011)(8936002)(5660300002)(52116002)(36756003)(478600001)(966005)(6486002)(45080400002)(38350700001)(38100700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z3U0Tk1XRXlUU3pLTnRWRFFCYkZzUEowUGQ4SlQyMEMxeE5OUmFMdzJ1dkdL?=
 =?utf-8?B?SEdzU1R2UTRJN2hjcmRJQzJyckQzWGhxby9GSWthWEI4STZyekFXYnpZMk1j?=
 =?utf-8?B?cC9LK3lyVlhHVWVYb1VNNlZDVHFQRU1va0d3TmRkSzhIU1BrSUkwcStiQ3Ar?=
 =?utf-8?B?QWVJb2ZZbUQyYVhwcmVUK3oxUnZ5eWJQUTRsWU0wTW5WeEs1M3Z1NFJqSkFy?=
 =?utf-8?B?UWsyTllZaGFSbHJmeGVGM0dzTlZRMlp2OUFBY3ZxUjErZWx6aER6WTZGZ1Yw?=
 =?utf-8?B?dG9RUGFJY1gxMjNSem1pUUkvN1hTMUFyZEZjOTBoZHpzeDJGc1pzMWd0b1ll?=
 =?utf-8?B?c1k2MXZkTENVMVRhZlZVY1FXeTYvRklLSFU5b3g1a3ZlMWRmbFB0ODRDYUlE?=
 =?utf-8?B?alhRMkhZR05PTTFzMlIvVjZaTFVONjRKQllIV3N3ajZ0TlFoeHdCLzF2SlBx?=
 =?utf-8?B?dWQrSGhqU005aFdINngrN21HTGp3ZTVJRElNZGpNRjBhbGVRRnZnVGUxNHdw?=
 =?utf-8?B?b1NLRy9SZWZhUjh1QzFyUzhaZ3NqdUF3N1N5Q3FxRnNkVnF0RkZKaU1xd2hF?=
 =?utf-8?B?OUZubEZSdzRzTms2WThKNlo1aVFnYmRVb3F1V3kydjdMUzdYbS9JMVRBK0hX?=
 =?utf-8?B?RkhISDVLRThrOW9UUVl3cEgwckZkaHpwc0pKRFhhdnUwTHpxMG5GU1NNb2pO?=
 =?utf-8?B?VWtaWStTbHE4aDkwSUZXT2hOb3BkcVgvakducCs2Y0NOM3A1cGc4S2tkTm4x?=
 =?utf-8?B?azlhdDhCdlhYOGhUTVJVNUN6T2R5eUl5Q3kwN3RIYXZ1dUJ0bVFUeVNyWGFq?=
 =?utf-8?B?aEZHVEs4V1UyTHJZanRVTmhjK0NZaXY5cElnL0FzUnJId25QSkwwZ2llQWNE?=
 =?utf-8?B?M3M1aG5CeTBlK2JlNGxMSnlXMzhBOVRaNzc0dFhNNU5Vckxud3pwc29qYXhO?=
 =?utf-8?B?QkNLL3FTNUdhVnZZZ1NoTjJsZmJSV1JZTW1BOUdnMm9ZNEFzS0JXRjBqT0tp?=
 =?utf-8?B?cDJNL3lyc25sYTB1THUvcDVKNUVWYnVTUVlUam5vUUZGZjJDbFM5TG5pNHRq?=
 =?utf-8?B?ayttd0E4cFY5QnVicExPMENaVkc3OVloMHd2TTJDa0hiRFYzUzdoYkc1Y0dX?=
 =?utf-8?B?UWc1ZTdRRGZxY21BL1cwRmcrYzR2cE44MmNyUGk0N2hNaTJiczJNNzExcGNm?=
 =?utf-8?B?SlRSdW51VkhBbVNZWDJMWjlTNlliVFRONGEyNGhSL3ZFR1lzMU0xZmo1a2Yx?=
 =?utf-8?B?Q1ZLY3ZrRVExcTdZSTRLbW10N25GZGhHUnlDZm1mVnc3WFl0VEY0SThKZ3M4?=
 =?utf-8?B?TFgxbHlrTVc5S3pXelNreS9Sd3VqOFR6aThycGFZT25ia2VHcU9jVXVPT2Vj?=
 =?utf-8?B?UndmZ0gwN2NMTjFya2QxZ3JycEt4OFdOMWVBb2VmQlV4N2NGYnFOQXVxYXoy?=
 =?utf-8?B?SnhaKzdJSk1rYkNSRG5VUWZlOHBid0xESXpLekdNMGpmd1JKdmlzR0JtM3FP?=
 =?utf-8?B?a1lBN29uOUsxKzRjLzl3RG1meHI4RWFBRlRVV2tKRHR6eWg0Sy9qNWFYMDNm?=
 =?utf-8?B?NHk3aHM2TUVla0ZyR1FuQ2dWNFpFeTdpL1pJS3RLT3RRN1liOHpsSjA2V1F2?=
 =?utf-8?B?RVc2T21NNWFCdTdURkVZcmpveVFuUlJKYkpFN0tzb3JTcW41cDNpSjJFOTZ6?=
 =?utf-8?B?STBjdTZ6clRCM3VPYTlVZVBWZ3BvOENCb21xc1Y4MzAvTVlqVDF2eEUzTHpn?=
 =?utf-8?Q?eCcIBnJc3XvVBbK6HycWMAKzPrfDqvD+52xn6oa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df5463a-5d0c-4524-8c9d-08d8f9e8eee0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 17:16:51.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHxY3sC/mLs1UbZWMKfptKWMgLUDptxkf4mFH/nYmajxGJdLkS2xKOwLjjDQmkfE3GnmB86T37pG3flK7wwYUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/6/21 5:49 PM, Sean Christopherson wrote:
> This series teaches __sev_do_cmd_locked() to gracefully handle vmalloc'd
> command buffers by copying _all_ incoming data pointers to an internal
> buffer before sending the command to the PSP.  The SEV driver and KVM are
> then converted to use the stack for all command buffers.
>
> Tested everything except sev_ioctl_do_pek_import(), I don't know anywhere
> near enough about the PSP to give it the right input.
>
> v2:
>   - Rebase to kvm/queue, commit f96be2deac9b ("KVM: x86: Support KVM VMs
>     sharing SEV context").
>   - Unconditionally copy @data to the internal buffer. [Christophe, Brijesh]
>   - Allocate a full page for the buffer. [Brijesh]
>   - Drop one set of the "!"s. [Christophe]
>   - Use virt_addr_valid() instead of is_vmalloc_addr() for the temporary
>     patch (definitely feel free to drop the patch if it's not worth
>     backporting). [Christophe]
>   - s/intput/input/. [Tom]
>   - Add a patch to free "sev" if init fails.  This is not strictly
>     necessary (I think; I suck horribly when it comes to the driver
>     framework).   But it felt wrong to not free cmd_buf on failure, and
>     even more wrong to free cmd_buf but not sev.
>
> v1:
>   - https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F20210402233702.3291792-1-seanjc%40google.com&amp;data=04%7C01%7Cbrijesh.singh%40amd.com%7C051db746fc2048e06acb08d8f94e527b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637533462083069551%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=bbNHBXMO1RWh8i4siTYkv4P92Ph5C7SnAZ3uTPsxgvg%3D&amp;reserved=0
>
> Sean Christopherson (8):
>   crypto: ccp: Free SEV device if SEV init fails
>   crypto: ccp: Detect and reject "invalid" addresses destined for PSP
>   crypto: ccp: Reject SEV commands with mismatching command buffer
>   crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>   crypto: ccp: Use the stack for small SEV command buffers
>   crypto: ccp: Use the stack and common buffer for status commands
>   crypto: ccp: Use the stack and common buffer for INIT command
>   KVM: SVM: Allocate SEV command structures on local stack
>
>  arch/x86/kvm/svm/sev.c       | 262 +++++++++++++----------------------
>  drivers/crypto/ccp/sev-dev.c | 197 +++++++++++++-------------
>  drivers/crypto/ccp/sev-dev.h |   4 +-
>  3 files changed, 196 insertions(+), 267 deletions(-)
>

Thanks Sean.

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


