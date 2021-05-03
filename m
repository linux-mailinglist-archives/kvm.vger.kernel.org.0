Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90BDD371818
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhECPii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 11:38:38 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:6496
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230122AbhECPih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 11:38:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GD+e1c7To+qJ0U/IfLiCosftZPGiaK+20rYDlM6GpvIzuiKd2JOTUAMcL4SXwPUVgQcAjiUyfMiJpLfhQPAR0CnmbHa5EcMKeSrnIm920XvT/5C8JJrVbMDOai5G0Ua4iYr4Nddrhs9xshW7vZ83QMz2/gkcRTTbBVlJONE74fFuU0Zm3HPWiEn20eu9wFekqsYWS9tV7ErSYBH/nTCtiSieXwFrkAE4IyXGXbRryrTz2XkT/04zIAT7/pgQ325AwgXsgfunhjWiablBBdsRS027ox57iCdyEJ9Yhqq7zaI8A8YhRnjQRygfv0H2McROLHhC4UFDJkLqG3gUmdsnrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nK1H+cBBvb0i3r3Z521wN32UIXwvRUurwbbmGiEaXts=;
 b=hTl/AdRqjDTgCtvmHJFbdL7cuVSWMXzdxHmoSw06hisCQ+EDnjSZnPcediVxKF7OLoMOXTfsWTkY0jMdOMxDOSRI5R7DnpNzbnVnGTNZWF/eIMyUYoG99vIxtcFUahdsj0GxjXGH+PU2njay4+zixRLPuLCXfmSINbX1MPSxrgQ7TZBcwauClg656Ln4UhQ43gyh5aETz8cOAVuZgvEdbb8t7z01hrrZJuOBNgZfMpzMSQQdayil/jOMM17LVRrPwoPJg1E/GRRGjcIQbOXy/HNrDIIadPP2eXA2s+V2nlGNFc6oLMg1/Hha49jGLrgdwycDSw4+WjV4tf5xjoXvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nK1H+cBBvb0i3r3Z521wN32UIXwvRUurwbbmGiEaXts=;
 b=SMJvzgwFEVBgKa/BNzP+qZ//4+2JjqRvzKuzfSUVuShBvfQfT8+o3zaHHTg47fPnNbPfCZ29I5vIDvLxFXpISVUXcQq95RKvgWdKLdVX9ogdm1QHq/U26Mv12n4qCrkRfL4CRwMA/2K2aC+6NPtTsxjhXQbBNBbUby0P6RxPM70=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2541.namprd12.prod.outlook.com (2603:10b6:802:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Mon, 3 May
 2021 15:37:41 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4087.044; Mon, 3 May 2021
 15:37:41 +0000
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        jroedel@suse.de, thomas.lendacky@amd.com, pbonzini@redhat.com,
        mingo@redhat.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part2 RFC v2 10/37] x86/fault: Add support to handle the
 RMP fault for kernel address
To:     Dave Hansen <dave.hansen@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210430123822.13825-1-brijesh.singh@amd.com>
 <20210430123822.13825-11-brijesh.singh@amd.com>
 <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <d25db3c9-86ba-b72f-dab7-1dde49bc1229@amd.com>
Date:   Mon, 3 May 2021 10:37:39 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
In-Reply-To: <c3950468-af35-a46d-2d50-238245ed37b3@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN4PR0501CA0014.namprd05.prod.outlook.com
 (2603:10b6:803:40::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN4PR0501CA0014.namprd05.prod.outlook.com (2603:10b6:803:40::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Mon, 3 May 2021 15:37:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d3ab570-bc1d-4aa4-8ea7-08d90e496385
X-MS-TrafficTypeDiagnostic: SN1PR12MB2541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2541F6FA085A6F59BD5EDADAE55B9@SN1PR12MB2541.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YA0c0IgN7whwCIVTkVC5XsOtWGZe73WD015o3K347b6FB2P/kF3tm5jc1oN9M0XlTbJchuqAfdu9KUXjICTKX7BdKgIbcNrGW3oiXM1bJbxMHAPEQ4brHn6uvTI9NfG6pF036RLYxuPkTRPwfdat1cIDHrTxbkgRI3jqloHXrk+XrDt0g1wAGUzVttPnG3dmpTpELlWIB/kxUlwCx+inHI5wvcBfEMll7X2lipZ5KAw+3Rj3l39HwRlGosr6o91282A5bI+heSHgWNXpWr/HHuxXwnxh5m+LjpllwCTNLHeJL4Yiqhg28Xi1cHVOZIxdCTy+I6XUCkbqYc/4mzaetNLZuB1Fxeqk8wHbKMCtDs3QKbC4WCMxfjd+EDZhYBWulp2lcamo4QIMmcLefZDnRoX5WcGjJiY+yu5Lxft/kpOvP0XZVTbd+rtAjhTcbAWeL61hSW65jthnBRkDdY1PXlCejoWrvGXeDpnLOgsEwUs7HlEPXyNI7kAQ78jhBxLc310hYJu4roVujYfwt1KOe/RQtamfJnuV5XTayOLP7ebO/3LChW4X/Nb3/wXp7+iXqFUf5DbzKRRayA4Gsu3DxNOSIqF9D+kFfwD8Y8/WsUBkXe7iwFliBya2wvQVMAZ20al01psl3KDuSQQ1I1XAuL+Pnbe+PgX3FQjKXeYCY5nlxDGxxC3OVD55/sf8xO2jlB48OWDmAcIQN+r43eau2DYhwrTeVixQqTjZMWODCEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(316002)(16526019)(186003)(7416002)(4326008)(2906002)(26005)(53546011)(6506007)(86362001)(31686004)(52116002)(5660300002)(83380400001)(8676002)(8936002)(36756003)(478600001)(6512007)(2616005)(66946007)(66556008)(66476007)(38100700002)(44832011)(6486002)(38350700002)(31696002)(956004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHR0amNjLzBmY1ZZQlZiaWlzRXk3MlF6Mm5uMm5qK3BQYzQxMC8xd2tlWkRG?=
 =?utf-8?B?QmhEYkkvbks0VnJkckV6UjNyeFNWTGptektWcHpIZ2FVVmdDZERzWVVqR1Bm?=
 =?utf-8?B?WXBvNndKZG85d3Z6dUpJNHd0azVSanFoelIxblJLajlFNkcyaEFzaTIrYjdP?=
 =?utf-8?B?Ym1SSmx1c3ZIcE1WZ2ZPMGhBT1NBbGRJa1Uyc3NPTlBhTFlBRW53QmkyaTF3?=
 =?utf-8?B?TEtuT3ZFc0M2WCswalpXc0M5QnFQcTJuYVo5VHFoQ2srZENjaGtBekV3Y0M5?=
 =?utf-8?B?eTVpbGFLUVNLV3RBSUZGOURpSUJEVzhiM1dobGZ6c2U0WEJYQW5BdENJUlM0?=
 =?utf-8?B?ck12MGZYNHJwdVgxbjZDbE03QlNNajhwbzczdHdidy9FZStEQmJZTENuWDJm?=
 =?utf-8?B?aUNCNkxJZGdyM0IrSHE2a3htZ3RsNS9nVTdOYUhNZ2V6R3RZSmNHeG5DSUph?=
 =?utf-8?B?UmtJY3FOV0FGai9MM2h3NXlRSDd4MXJxL3JCblB0OW9YOGdiNEEzT3pOQVpa?=
 =?utf-8?B?b2U5WU1RS29vRmJOLzFpRThLR24rSWE0cVdvRWxlZFdXMEpqTXhPYmU4M1lE?=
 =?utf-8?B?czJacEdNTFF5RGJoT3h3b3lnZjkyZWxaT3pwL3RaV3lQazhxNWJ2WDlUSDBW?=
 =?utf-8?B?blNwUUtXQk0zalBYNkxPUnpxVENEZXJSRXdpSVlzNWNhaEtobGhPWmU0VE1N?=
 =?utf-8?B?TE4vdWU0QXh1cDQ0Yllaam1FUm5PMmxLM1YzNEkxajhLdWpKaDRnY3hjSW9C?=
 =?utf-8?B?NFo0V1IrMnkzbWJWMkU5aDRuY2REMW9XU3M4bjQxUnBBM1M1MnJQOTRxRzZl?=
 =?utf-8?B?TEZURWkvTnBBK2d6S3VGZG13NU1YUmN4bWRMYVhsbytUNTZ6bVNnazRKdTdG?=
 =?utf-8?B?Q1Ztb3J5aTNqUnhWemEwTUVYQlNqbnhiNjBTTXl6Y0t0UWZWNE5ZTXRDMmtk?=
 =?utf-8?B?anF4aTh4ZVZWRVFpQytBYWhObHJlQ2tTRW9DaVE1L0dwMVoxeFJXOEtDcDd5?=
 =?utf-8?B?clpkR2RPR1pWSGIvZ2k3bWlJM3JISmZ2T0d1Y1R2V25HZTY5MVNVekt3dldk?=
 =?utf-8?B?dlY0SHc0VXNTbXl2dzNZSG1HZzVRS21ZNWVudjVWTVg5M2EwbDIzZjdkTk5r?=
 =?utf-8?B?ZFB1UWUzMnJrL2pkTlNMU1hNTDNYWjZRL1FWMXdJdFA2UTRmbUc0TndzQWlK?=
 =?utf-8?B?ZFNmK0JEV1AvcDhGdmZyM3hqTy9iS0FmazhhalF5RU1FdWI3SWJYQWxjZEJj?=
 =?utf-8?B?NU9rTVlTZ2ErWklXdGs2dkNwZUNzN2dUTlZkS2w3eUdadldVVzlKQlpRVjA3?=
 =?utf-8?B?MmFHelBrWWF3YjlWMXl1bEgyeW5MUE05bHA4YUdvZ1FaUDVXeGMvRjl4enNP?=
 =?utf-8?B?NThzWUthRGxtd3FmZEVQVHdOWTk0VWcxWjdJNFRZV3BuallOZzVyenFJTWhj?=
 =?utf-8?B?T3d3emgvTGJjb0ZvL0FyeVlIcW03ck5uN25mWnk2ZWR6OXR6Z2N3T3FQY2ZG?=
 =?utf-8?B?c1F5WXpEK3ZzL2pwakVVZktRaUxBRGVkS1JLbGVGWStha0VzQXhwaC9mZFcv?=
 =?utf-8?B?NjhFWGxUVHQ1MmhZVFNITmFITjg0QUR2bXhSR2RNUXRNM0FuRzY0QXdDRzYy?=
 =?utf-8?B?ZWs2NXhTcWRKK2s1ajdnYzM0RUpTQ0t4UGFQVlh6cG9tbzFzZER2OGdZdkli?=
 =?utf-8?B?VzNuZGQzWUkwQ2ZVbHZXc1U4MWtMdGZ3UkhEaklORFBhNDZnVkMxU2MzMnpu?=
 =?utf-8?Q?U/keHgbCvbWzkQtAMYoQU+keuOWodR/TlH40sKO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3ab570-bc1d-4aa4-8ea7-08d90e496385
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 15:37:41.6073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwM1FOojzq5yBKEXOy/iZpRKBjJkpvOIPqkFrl3niq354EQ3CIuNS2cCF+vqUhr2ACk3RC9HXzAlY8XnZoGn5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2541
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On 5/3/21 9:44 AM, Dave Hansen wrote:
> On 4/30/21 5:37 AM, Brijesh Singh wrote:
>> When SEV-SNP is enabled globally, a write from the host goes through the
>> RMP check. When the host writes to pages, hardware checks the following
>> conditions at the end of page walk:
>>
>> 1. Assigned bit in the RMP table is zero (i.e page is shared).
>> 2. If the page table entry that gives the sPA indicates that the target
>>    page size is a large page, then all RMP entries for the 4KB
>>    constituting pages of the target must have the assigned bit 0.
>> 3. Immutable bit in the RMP table is not zero.
>>
>> The hardware will raise page fault if one of the above conditions is not
>> met. A host should not encounter the RMP fault in normal execution, but
>> a malicious guest could trick the hypervisor into it. e.g., a guest does
>> not make the GHCB page shared, on #VMGEXIT, the hypervisor will attempt
>> to write to GHCB page.
> Is that the only case which is left?  If so, why don't you simply split
> the direct map for GHCB pages before giving them to the guest?  Or, map
> them with vmap() so that the mapping is always 4k?

GHCB was just an example. Another example is a vfio driver accessing the
shared page. If those pages are not marked shared then kernel access
will cause an RMP fault. Ideally we should not be running into this
situation, but if we do, then I am trying to see how best we can avoid
the host crashes.

Another reason for having this is to catch  the hypervisor bug, during
the SNP guest create, the KVM allocates few backing pages and sets the
assigned bit for it (the examples are VMSA, and firmware context page).
If hypervisor accidentally free's these pages without clearing the
assigned bit in the RMP table then it will result in RMP fault and thus
a kernel crash.


>
> Or, worst case, you could use exception tables and something like
> copy_to_user() to write to the GHCB.  That way, the thread doing the
> write can safely recover from the fault without the instruction actually
> ever finishing execution.
>
> BTW, I went looking through the spec.  I didn't see anything about the
> guest being able to write the "Assigned" RMP bit.  Did I miss that?
> Which of the above three conditions is triggered by the guest failing to
> make the GHCB page shared?

The GHCB spec section "Page State Change" provides an interface for the
guest to request the page state change. During bootup, the guest uses
the Page State Change VMGEXIT to request hypervisor to make the page
shared. The hypervisor uses the RMPUPDATE instruction to write to
"assigned" bit in the RMP table.

On VMGEXIT, the very first thing which vmgexit handler does is to map
the GHCB page for the access and then later using the copy_to_user() to
sync the GHCB updates from hypervisor to guest. The copy_to_user() will
cause a RMP fault if the GHCB is not mapped shared. As I explained
above, GHCB page was just an example, vfio or other may also get into
this situation.


-Brijesh


