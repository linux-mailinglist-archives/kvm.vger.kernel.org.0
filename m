Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEFF35451E
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhDEQ0P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:26:15 -0400
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:9312
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233795AbhDEQ0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 12:26:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PC1OfPlFC085AGDBPksWflZwdqkxvISZH9jwmO1sPSan1UyZ0nqSLqS8UMqL8aWzkNh11ZjHa2KQKSSnF8OwhNp+JsRr7XOOiGkbNH6rE245a40CfBNJUPIx42bSFgZ8ZIi/iCQdkpl8Qc2bwO3OOVFK9TwThEhLFX3w5RLLZwZWKauwSRbrkKdkWwC0oD/fPVigttjMzUWzq94x2HZEk+URPBSBO/spHUUO3vGTzFLkkvKPCQ3Gah4nheLPGJhZR6fzeTMG1uQWs1jp8TNi1NfqyTf3rfmg7gtaTkwMCZ7Oyl/+ZmyAxfcTTlU5/O3JExRs1tXPk+fzKYyuXIBZtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7PIIXTjjFobtpcgLSxNkv/FCPUW0/Tib/twCpbjY4=;
 b=Ia6CAcjqMXLltWYLIaCGs/N7P75mUqOvOorfuTJocnq7YvM6NWvCknGcUHz4R7HqoOw0+tSLj++n9V7e98JntE5h4GnZtBwphDATLl9LUoJwQY5E56VefP8HdqGJhCb0zbU9r1x1wIpd2bhvIbKQ8gaC2jjnnVaMG/XF9aySSJpijsdFeWi7CSYTRWK/ZxcIXEpMspK2zLYctIT/lmx11iPbNXPy82u6mQoBq/Xsk2IhJ214fVdBPSAo2dif+2hTirDFNH/5ssH1RRKqRoasuZkrKz/gsK/vyHbYBcllJXSPGzsJ4rmLZliJ0Hz8ojvHwE6LtJSqfteOHlP29+XYIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jL7PIIXTjjFobtpcgLSxNkv/FCPUW0/Tib/twCpbjY4=;
 b=4LFh3WInbyozAiBNm/S3VEfbi2cS7+zWzGYS78x9P9nXiJ6eDjaaTiKL2MrYwjsauCCK6xAOn8G7K5zvIQH+m3m5erDqHPvc0v/bxaoGsrGDrMzaKfQ2AFhOofRgJaaiC3aQwip8IzDdC9vpv+8uqch2o5HwGe0I4cKK+4AHaMA=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0022.namprd12.prod.outlook.com (2603:10b6:910:1e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Mon, 5 Apr
 2021 16:26:03 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8910:71f2:c193:d302]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8910:71f2:c193:d302%10]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 16:26:03 +0000
Subject: Re: [PATCH 2/5] crypto: ccp: Reject SEV commands with mismatching
 command buffer
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
References: <20210402233702.3291792-1-seanjc@google.com>
 <20210402233702.3291792-3-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <bc82825c-03ff-1b3f-7166-f6e5671f0a4f@amd.com>
Date:   Mon, 5 Apr 2021 11:26:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <20210402233702.3291792-3-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN7PR04CA0086.namprd04.prod.outlook.com
 (2603:10b6:806:121::31) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN7PR04CA0086.namprd04.prod.outlook.com (2603:10b6:806:121::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Mon, 5 Apr 2021 16:26:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe9e413c-c786-49de-e946-08d8f84f81c4
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0022CE1233B85B15DB470E11EC779@CY4PR1201MB0022.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owQa2evN2WlAZGHBdapp3xis/rWihkivDRkDjljyqFkKPsFp3Bx2ri76RuoVctpN3yGry5w11D4g26+UlFizXjacBvREIoj+L6w0+3aPKlFlXhPiA6/JTj/6PoPB0GEpsTRCyr90ams3EaWY/1L8C0rbs4G9XXVtQYlSYZDT5HFWYGx4YyxQsKh2xwhK7zjoGWdf/5kdFy2Tcb1SNd5UWZU9F1Aezhz/plhopvlc6xFYR/Kjrmr+35jG0I1pYhaq39lCKfRz2Ra7/7kxOmzLxWevjosio9VklFp2ObvC8Lq1yFKCvu1wHQzkg3kCwe/8GGBvorYFmnvQ+PYL8M6tNr6nS4H7jcAFV+JksOzrE7zfc2bttCJA84oaxbH7OIFwHRXFNvC/vQnZi3/AEmyoofiqVKzr+LboIh/kiRl0wrASph5FU770wZwbEhGA/sZCSN9JEKS5YPD55NFcNxM9pwqo/FzBlV65j9gSKhX34ozV3imIDvhkpQCiYMmj5T4OrT9/BUHY0ZldtsUtxuBH0ZRURdMB0GccBVttvWrmdMjonSpL4kYxjVpoKVbintsooechND7rq13NRd9/+9PYvnkOPfb93tV5JUch5RUBuKJl46xjak9AOMCOCMdtYeaLGFDEZSWhgK9lLSeicj525pQVOjLBBqhh0fiEUNBCkfjCkCJKS0YsoQ+XFlWXw0EpybAO0UoHS08p/3aWh7vtQpUjfwhN4cQDZhVGEUSIUgssjyDpAQC1Vua4pwwDN1hh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(7416002)(16526019)(66556008)(110136005)(4326008)(2906002)(5660300002)(8676002)(54906003)(83380400001)(6512007)(316002)(956004)(186003)(6486002)(478600001)(66946007)(6506007)(31686004)(53546011)(38100700001)(2616005)(86362001)(36756003)(26005)(66476007)(6636002)(8936002)(31696002)(43740500002)(45980500001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bjhXOFBxemZ2akg4U1RDNERxSjJ0TlVWVlBhdVFFSlFzVmwrRUs0TEt0eEg3?=
 =?utf-8?B?ZUM5SkczSHFLRGJZT2d6UEJjempIL3I5NU1pQlBjT3B1WXBNY1R6TlVCeVFS?=
 =?utf-8?B?VldGQ0dJT0VMcjhBS0lpMjZjSUtmZmJ4TlZ3NUJTUHRmNFg3S0F3Sk0wNy9Y?=
 =?utf-8?B?Y0hlM0lMN1dwWEVwSEhxY2dURlNHTzRwRnN6Y0RZVFlxY0FkUlF1VjU1T3or?=
 =?utf-8?B?Q0JIVnFMYmJYK0hmbXVFamk3S0JsZERseGI2RXh3RUpxQVZiMnVqc2ppczAx?=
 =?utf-8?B?cjhncWVXRVl6bEZMWnhIRWJGbk5vWWFoOGJTbytpNFpYZ2pVUU8wNWZvWExB?=
 =?utf-8?B?ekI3YkFBVEpsOGpLMWlZRG12Z211cXAxMjZjNVlLVzNIRVFaQTRxd3gxWEJR?=
 =?utf-8?B?MWx1S0ZRMGptdXlkOXN2N0EzeU9kMFVBQzFrZTlEd1Z1ZHBKQ2ZXT3ZJU1ZX?=
 =?utf-8?B?aXFnOGFQdVBjRGt0R2ZZNkdGUjFxZlcxV3kwdlhkYWFmaW5mdU5BaEFjUlZT?=
 =?utf-8?B?Ky92d2FRdlVKd2hYQ1gzT2JuNkQyRG5DekJKaFNZTlluVHArcUc0VDk4U2I3?=
 =?utf-8?B?TTlmOUp3QjNWb09pSUVBc2ZTTjNSZ2lCZE5ZcStjT1FXRGhoclE5anJWdGhh?=
 =?utf-8?B?dkVIMkNnWG9wVy9DVDNjTnYxRXpsNXdhVXBrS3RRMzRrOHFHNnM2R2NTUTZr?=
 =?utf-8?B?QjZkRlE4bEdxNXc5Vm44ZWRoSHdSZUdkcmx6MmZ3Y3NCQ3NWSzI5RHBMSTY1?=
 =?utf-8?B?NmdJU1YyQnZsTjl5eC9TR3BERjQxNHdZMVdDa3F0SlJxeXRNbHBVdzl3RCsy?=
 =?utf-8?B?VGNwMVpHOUVoV2V3NDRFWis4R0hhaHNxUmNiMFdnTmlhOFdDVXE1elgyYXhJ?=
 =?utf-8?B?anYybkVxZlJJNHpKeFY3N3NGVk5XWUxFcmxUdkxya2EvbE85bWwxanhhZG5E?=
 =?utf-8?B?RndyTjQzMVdLSEF0dEVxcjhFYzhxdW0yVTBPNytoMWxSeHBhOWtDQTdvMnN2?=
 =?utf-8?B?UXl4YkFKYjRDTWUyYzQ0b1gzdFF4RnA5YVlvL3ZWMmg5TFVyYm1oTFBlNG9N?=
 =?utf-8?B?NUJLdGxIS3JORkpRdXRrWHh4MURRd2lHaTJ1M0prZWlkRjVCZGt2Q1dYT0hs?=
 =?utf-8?B?aUtEY0kwSStLUWVtRkJEOFNNdHpsdXdmZS83MlgzYTRGMnhFdEdia1BuQ3Ev?=
 =?utf-8?B?cWs3eElSZDRWK3dnSXdLdkJqdHFjNU1adVlGLzV6TE9hUFBtT3drUkZhK3A5?=
 =?utf-8?B?MEpET0Z6WG96VmxSSUY2Snk5Ym9VRlZxM3hSU2pJTG5BVnpzVWhTWWlzMEIy?=
 =?utf-8?B?OCtXNm5pYmgvQXRJZDVRMVVsRTdqTDBSWDBvNGk4NUhjNU1XYytuT3pOd2Zp?=
 =?utf-8?B?NVdZSFM1bUszSHFlTzZNRUdhaVhrTVUra2ppWjFnT1dCeG9JSUNKMlJFcjVy?=
 =?utf-8?B?V2Q5NmFtZHdBN3BxamFMc2ZKZnhBM2F0OHF6OXE4d2tJVFdpdjY5bHR1bTN2?=
 =?utf-8?B?R3F6YUgycXhUTnUyNy9XWHFGY1draEs4aG5jaFAyUGtTVXhwNi92V0RDN3Nq?=
 =?utf-8?B?K3oxUStNMEZNVDMwdTVMemFmUmxsNndQMHZ5ekdZZEc5dDBNcFNZb1pXaDB5?=
 =?utf-8?B?cG1ESDBTczBFQ3M5eWUyOXgzRGdtTGl6Y1lhRGNnTHM1NEo2aXMyT0l1bFpn?=
 =?utf-8?B?Tkl6c3NESmcxTmJDaUdBUFpKUlV4a2VaR080cUtyN0hJRndUU09oZGgyZUxC?=
 =?utf-8?Q?/rPlbuvLjLwf2pxXp5m2nA2Pj7819j/YEHMRjgg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9e413c-c786-49de-e946-08d8f84f81c4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 16:26:03.8164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FL1y5y5bXgJ8vyXFKJAvAulID8cZiLihXTS8FBHfrqvs860c3b1GdU8wqz9w8DQ7iav2JJxJnhQK9s9wJQqXDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0022
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/21 6:36 PM, Sean Christopherson wrote:
> WARN on and reject SEV commands that provide a valid data pointer, but do
> not have a known, non-zero length.  And conversely, reject commands that
> take a command buffer but none is provided.
> 
> Aside from sanity checking intput, disallowing a non-null pointer without

s/intput/input/

> a non-zero size will allow a future patch to cleanly handle vmalloc'd
> data by copying the data to an internal __pa() friendly buffer.
> 
> Note, this also effectively prevents callers from using commands that
> have a non-zero length and are not known to the kernel.  This is not an
> explicit goal, but arguably the side effect is a good thing from the
> kernel's perspective.
> 
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6556d220713b..4c513318f16a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -141,6 +141,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	struct sev_device *sev;
>  	unsigned int phys_lsb, phys_msb;
>  	unsigned int reg, ret = 0;
> +	int buf_len;
>  
>  	if (!psp || !psp->sev_data)
>  		return -ENODEV;
> @@ -150,7 +151,11 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  
>  	sev = psp->sev_data;
>  
> -	if (data && WARN_ON_ONCE(is_vmalloc_addr(data)))
> +	buf_len = sev_cmd_buffer_len(cmd);
> +	if (WARN_ON_ONCE(!!data != !!buf_len))

Seems a bit confusing to me.  Can this just be:

	if (WARN_ON_ONCE(data && !buf_len))

Or is this also trying to catch the case where buf_len is non-zero but
data is NULL?

Thanks,
Tom

> +		return -EINVAL;
> +
> +	if (WARN_ON_ONCE(data && is_vmalloc_addr(data)))
>  		return -EINVAL;
>  
>  	/* Get the physical address of the command buffer */
> @@ -161,7 +166,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  		cmd, phys_msb, phys_lsb, psp_timeout);
>  
>  	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			     sev_cmd_buffer_len(cmd), false);
> +			     buf_len, false);
>  
>  	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
>  	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
> @@ -197,7 +202,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	}
>  
>  	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> -			     sev_cmd_buffer_len(cmd), false);
> +			     buf_len, false);
>  
>  	return ret;
>  }
> 
