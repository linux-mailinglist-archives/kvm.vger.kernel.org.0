Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147262F686B
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbhANRzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 12:55:22 -0500
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:62136
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726744AbhANRzW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 12:55:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dDLXIs5PDp7TSRMsRNzjJoDf9t9lSZ/Y4bVeHwKYwiiShyUwOas+RWW6eG/qdGGGnodkF1WbfniEgufX6h/cwy0xVIxJFSHn0CatzjSpoWs7Vfiw5cWB0q0+Ade27W3U0ba5lUWkMK7ti2vQVjdN6uM8+GGDuEKFRY2nurmrV92wiLNTMvZB9R6CeDi/7NG1oyIeWz2XGXsZXBkFefrfUjizgj27Afz5CjjAHdg1YxluDgnUZCWfGsv60Xdxb6vl35MDhi/0o+JWgS7F49gxwHTG0uUr81Y/iWcbFWDrOR8pFUmmKvbWxsPJ+UxdN0fMdh/Z5ypjJAvFYsxQOYuOUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQk4dD0vCsj2LVlU3BCv2a5toX3+yK1632uJQjxDTs0=;
 b=FLE9I2af3oVd0iVOBzs+/VAF5N45S3ZV85DeuniERJ1B06yxB+d1hS8WVfwJdsrNH5Wam0Upzs3PlBc+1tRSQpTsIDypodiMc6hNywXXUh1zibZkdaQ1LpldNv6Kc7TFtKx3pQFRtzjJiQWx0cuVqFfLoIL7YSW0eZ2ykq95t20jPWiw6ZqoBkDY+YY5ZEN3g7oSfDj1+L61coPhmjXjuHj7MOl/tv0beu8+Ak8B+fiVcJ7FkiqziYUBkh3110QF+DDj//eFJeaZ2fz4YUmrBluXQt3by/JXXUVs/mCqI1Bv/SRBzTZy1VD/ZsJBTFkopRLFzKy7vDIRFhCN0DUGXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQk4dD0vCsj2LVlU3BCv2a5toX3+yK1632uJQjxDTs0=;
 b=k+MLlfKDm1jqbj3PUajpfeSxvis3i14Agg1yL5jHnoYQndL0NxO9uIDY27sTKKo6pXNW+drB+7RPys2rg6Yx+QDSDQMeBYytV+ycDoghSzbZuPJ0oRSEJFoqoQxvQOXDkXnzPaoWISLXmnxGQU4yLZsgnfsVzDIZyXY8q2/t4g8=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4812.namprd12.prod.outlook.com (2603:10b6:5:1ff::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Thu, 14 Jan 2021 17:54:28 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 17:54:27 +0000
Subject: Re: [PATCH v2 06/14] x86/sev: Drop redundant and potentially
 misleading 'sev_enabled'
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-7-seanjc@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <966c10b2-e3b7-8036-271f-6fff8a4029ce@amd.com>
Date:   Thu, 14 Jan 2021 11:54:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210114003708.3798992-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0501CA0138.namprd05.prod.outlook.com
 (2603:10b6:803:2c::16) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0138.namprd05.prod.outlook.com (2603:10b6:803:2c::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Thu, 14 Jan 2021 17:54:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3e781cd-e1c8-4a94-b9d5-08d8b8b56ff6
X-MS-TrafficTypeDiagnostic: DM6PR12MB4812:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB481206882789AECF74929F8FECA80@DM6PR12MB4812.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEB2OmXU4nc5SLy3+oF7JCHJJOkFuUYSRPet53HG7nBxSz2r6gdcmsrznjYHepGmc4ABnMwV/+KEyFYbRp3ddQz28YTxUDGlgAAYRc+dj+UDKZOr003wF9PI6OHgFswe+YxOmE7//p0Ck418QC3RiXjg9q0eNveQ1v8lNlphqLoTqybc55cPOP+GMljnftXW6S0l7oD64HPAizE8r2R5OHD9vA/vJjK87VcVm7o4xzlxayd4LYxj6nL0ZpJdW4L6wuxytJpJg1O/9Gyp0Ae5nb/0OlXUGzVH3017ENLS1MNZfL1uUekj+oc51jIHrA4Fy+7o80EbWRdMJgksMckcedQn8EmTgCQaVTRZqUiXvUeF7nmyXZBSJZh4YXaxvknxorcpGGVEjTr2MkeDZRi754GaC5+8eMB/8e3smgnlP3K8ya6GDgRCrbQIDzFzpPf0sAr39Qm/aJ+Au+AcH98lI0UZd5Y0nm0Q41A3WCw6s+E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(6512007)(110136005)(316002)(186003)(52116002)(54906003)(2906002)(83380400001)(7416002)(8676002)(66556008)(66476007)(478600001)(5660300002)(2616005)(31696002)(66946007)(16526019)(4744005)(31686004)(956004)(53546011)(8936002)(86362001)(4326008)(6506007)(26005)(36756003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OUF3U2E4STFqdW1uQ2xQR1FGQzdFQ3I3YzNXalZOVGVtcnl5K0JWRnhOaU1n?=
 =?utf-8?B?UmJhR0xqZlY3KzVVRTllUEh0c2hCdVIxbDJSZGF5dUlrd3IyYlNRY1F2MjRm?=
 =?utf-8?B?VXh3YnlvS1o5akZ5OWk1S0VvRjJhZFhlUHJEQzZFclZ4cCt3bzMvUndYNHpN?=
 =?utf-8?B?bGR6b3dwOXJiZnZCYXc5cVlLYks2RGJyUEFCdkdydDRMd1FQZitQZlFZN1Jv?=
 =?utf-8?B?WUhtVllhS2I5R1JDQXdNUzJuN1U5bytwQk54WTVFN1B6NEhGbE9TUENRRnZu?=
 =?utf-8?B?b0JHZWhseWVjVDNMVlBoZWdzWXpNbWdQc1FRUnlucTZ0d1d5eVVZUUVuK0o0?=
 =?utf-8?B?YjNvckcvRjA1bU9oOU1QbXdWeCtPcHlicWJpRlRBSWcxMTc1dlBtdXNNanAy?=
 =?utf-8?B?Ymwrdjh2Z3d2ekw5L3lPdWZNQzhKdXN4ak41SzVSZW8rUjQzYWZlZ1p2ZGRS?=
 =?utf-8?B?dkR4UGdhWEQ5TXBneFVZa1pxNnBKNlArOXl3cTBIdW9UN0ZDVkYrWEVxUDR4?=
 =?utf-8?B?KzEzdWpSbU5hNkdCN2Z2aVo0dUdmMXJUcGVVWm50S2Z5ckZ1V3dOQWd0SGVR?=
 =?utf-8?B?QmRRd3dXd2VYeTB1SWpEWFRQc3NJUE81TEsweElyWHVWZ3YyTHVYc01xMFQ0?=
 =?utf-8?B?MTAyNk5SdmE1K0pSRzVmc3VKbTJrdGE0UmNidjZTSU1wdWJGQ25GSmJSU3Fu?=
 =?utf-8?B?UFdRbjZrV09pK0RJWGJDNXZpSXB3NDkxSWNaaVN3QmxYdHVnMEh2bFVRWVpC?=
 =?utf-8?B?d3NZbXdyekV3WmRQWWg0UG9SRkVxRmZQR2lCdStrcVMvdmxNclozQmVtTWJS?=
 =?utf-8?B?SjJYVUs0K2ZnQWVoeE5XT1JjRlpUUmNLdXlVQTB0LzZCTk9KeTdiTjdNUSta?=
 =?utf-8?B?enR1OVVxZVpGVWxmd3BwYy9sbkFsTitGL3NiOFZHb043dkRHNUh1VXpaRU5q?=
 =?utf-8?B?Y2FFQTFBb0ZaUDd0VnpieXdSV0srcTI0Y2NWejA0VGluejhJdHJ1bktVV09O?=
 =?utf-8?B?emJUbFZCUVIwU1ZEemFrckdLdU5BZE9sR004Qk8rd3FsNGduS0lNYmpxY1lZ?=
 =?utf-8?B?bUlHWGdNeWNZNHRCaXVsV0loaTFqZmhvNlV0bUdIeE9IaHJ2bHlvaGZqNUtC?=
 =?utf-8?B?UXBJVFcxUTllZThETFRueWVMS2haY01hd29ZaFBFOFh6ZWcyNW9NZVQ3RDZo?=
 =?utf-8?B?VkxnY0ZvV2ZYR3FhU2xCR0EybUVySWMrUFFRYnZCR2xqY25JU0pJeFIwZGhr?=
 =?utf-8?B?cTRuMjBrMnd5YXd3c2ZVT0lVVlJZa0VYZU15L3dKL3ppUGxrWktlT2NCWXdm?=
 =?utf-8?Q?+xymePvmWIOQXzIFHkQi30vlNJ0heZKFLf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 17:54:27.8937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f3e781cd-e1c8-4a94-b9d5-08d8b8b56ff6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cFPMD+m14+nfeesBMMCqIp2GprO4cZrM0ltaD2kqRKoI2hxe7m0WbOsE/Ate3NgiOeIeMORPoWDTvNJbUhN7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4812
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/21 6:37 PM, Sean Christopherson wrote:
> Drop the sev_enabled flag and switch its one user over to sev_active().
> sev_enabled was made redundant with the introduction of sev_status in
> commit b57de6cd1639 ("x86/sev-es: Add SEV-ES Feature Detection").
> sev_enabled and sev_active() are guaranteed to be equivalent, as each is
> true iff 'sev_status & MSR_AMD64_SEV_ENABLED' is true, and are only ever
> written in tandem (ignoring compressed boot's version of sev_status).
> 
> Removing sev_enabled avoids confusion over whether it refers to the guest
> or the host, and will also allow KVM to usurp "sev_enabled" for its own
> purposes.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/include/asm/mem_encrypt.h |  1 -
>   arch/x86/mm/mem_encrypt.c          | 12 +++++-------
>   arch/x86/mm/mem_encrypt_identity.c |  1 -
>   3 files changed, 5 insertions(+), 9 deletions(-)
> 
