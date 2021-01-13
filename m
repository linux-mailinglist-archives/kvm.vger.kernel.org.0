Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757DF2F438B
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 06:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbhAMFP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 00:15:57 -0500
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:20965
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbhAMFP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 00:15:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XR3U5/PbXdD41VfJvqtmEE/FGqLdoy6cbs6PnvhR8GmirJT79ZrdtnKeVcuNWt9cdbOYigzetrXqKqZBC1FXiEV+sZMWdboukr9qo6cOR5Ni/xZ26+t+XPN7iNkxRqj7EjY0PnemNbQoK4FajR9k7YxuJxSGDRevZsb/rTk4YUKRUKd2LovYKnhOBJP95MhByEKnBwj5xQcS2Uf+MRL4g7avKEB2NANY1tq+s/IrlNxTgGFjb/+/wptJ05n0biaIefG5Ex7U5se21KhUVv2m0QDEH0Sne/mjNhkXlsBHcLVqmUxboGT9tAycFM2c9zA5uKdao6iem+km1CKLsrJehQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh9Y+zk2+QhY1QcJLqhNh5v20QyvyeEECBgo54sIxro=;
 b=nAS6KDcreq3Z97StkOT5RNxC6Znt90GMQ83l3w139UAM+YpUOf5/vx1MXkKexdzQhRSwucVi5vTgINi7urgjnW1HGJQZ5SGRsBtwwBsqB7THJgKMF5Nr6g+mY4BizIn7wYIXglUlF5AvJaEGNuGDDjKloRE5ErRwDKul6PpLzFia46g395Wqkp3pP2zdIIT6ssB95N0vN61QQSm28Tu0bnb77gj6jnXQGJB0Ql4XECe9dD9egdKvtBMtmRyUElCIyyWxoDeCPJyt+FQ4vlgE4hPhq3MxvA68Fz16mC9zqzodSZBwWxmSDxQwDH5PRMt+58T0H6UuH+UE7uvkMxRDkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fh9Y+zk2+QhY1QcJLqhNh5v20QyvyeEECBgo54sIxro=;
 b=NG41XASXUnHoSnZ6GTiPTqPVGoWcIKDv65lpMC6Ik/bDmGeC21QfbPG/hKDQKilQJsZYYsjAqe7fqMYJniuauFNfp6U7VN8jbUWtMbBpAyoSB1nQblwqoIdl2C449CPhvTGsslvby4Z19YOYzhPtoXSTI+O2rzmwayfnXTLTRhg=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR12MB1720.namprd12.prod.outlook.com (2603:10b6:903:121::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:15:06 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 05:15:06 +0000
Subject: Re: [PATCH 1/2] KVM: x86: Add emulation support for #GP triggered by
 VM instructions
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Bandan Das <bsd@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20210112063703.539893-1-wei.huang2@amd.com>
 <X/3eAX4ZyqwCmyFi@google.com> <X/3jap249oBJ/a6s@google.com>
 <CALCETrXsNBmXg8C4Tmz4YgTSAykKoWFHgXHFFcK-C65LUQ0r4w@mail.gmail.com>
From:   Wei Huang <wei.huang2@amd.com>
Message-ID: <0d324a3d-8c33-bb6c-13f3-e60310a54b13@amd.com>
Date:   Tue, 12 Jan 2021 23:15:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <CALCETrXsNBmXg8C4Tmz4YgTSAykKoWFHgXHFFcK-C65LUQ0r4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.113.46.183]
X-ClientProxiedBy: SA9PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:806:22::22) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.38] (70.113.46.183) by SA9PR13CA0047.namprd13.prod.outlook.com (2603:10b6:806:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.4 via Frontend Transport; Wed, 13 Jan 2021 05:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8b0bed1c-ccc2-4584-4aff-08d8b78230a8
X-MS-TrafficTypeDiagnostic: CY4PR12MB1720:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1720CF983A9A437B658D39E0CFA90@CY4PR12MB1720.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eancq5IJDqfKZSlGvpyRGBoMrjZQalBVyQgMvOe1kUuOVzzm5hzp8WNyMEnJIpl8OHTZJNBOnV2yyvIs8CGshwZrnnfTyZT5E8GLc/2ERM6eVVjAo8fflq/1jj8Ujlbkw9UoTVBeOwPAaKmLBLYLKaSkKbt05e97aaFWUSTZ8X2WGt712M0L5BTC+qpRSAdVEeB+aAzPIoM0nLXRuke74N0+JPlLMwxHRxNzzvfIcfQS/D+/KhY7RjmRPmGmxqI/aw9UclK0y8NmFAXhGOULifs9m/rPhY4WZPv7+am6ftO4qsPuqBzxDtEymysMCKVUuJrK7e81x6IPXlE+i5UZ1NHAX+Eyob0WA6wstQfN7WiYB2bIoZcVqOcMr8brIfMpj1A5E8d7L7bK7irBf5PtuyYv5M0mT9CnKfxQtqGN4W2GRlqHwsxNinTeXvxxASX0Cfb7zmro3j+5FbOf6vhKkGoihxUNrQ1Leluy191SNdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(2906002)(6486002)(52116002)(8936002)(86362001)(66556008)(316002)(54906003)(956004)(31696002)(7416002)(53546011)(2616005)(31686004)(36756003)(66946007)(5660300002)(8676002)(4326008)(4744005)(26005)(110136005)(16526019)(478600001)(16576012)(186003)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WTVMN0pCVllUWDVSMURTWWkyRHNHRnZjOTRnUnJKcjN3M3lram95VEp3Z2k2?=
 =?utf-8?B?RmpoclBCbS9vVER4ZVJIeEcwM0FadENyVmZGUU9RclVnelhhRHpuMGNkVGg4?=
 =?utf-8?B?Zkk2VHI3SjhTU2VRbklKaytuVWdJMGlINGpPbkRabHdpY01lUjUvOWo0Zm5T?=
 =?utf-8?B?Mk9TNHdIY0hsdFFVUnFTSjNEQm9CWHFHN0xVRFFtYzNiREQ5L05DNUNkcHYy?=
 =?utf-8?B?bitPMU9yN29rcmpHOE5hZ3piaWFQV1I5blRxWjBFb2xYWk9rOXV1TlVFU1VH?=
 =?utf-8?B?S2U5aFlyeEhPaDRDbWNPY1djN2c3TURWYTJWSjZ6YXdmWnpjMFNWWExVT25L?=
 =?utf-8?B?dnZycFJoeEQrbmxXbCtXMW85b2JGc3kydEFodGtlSWlYTkkwbmVPUndCend3?=
 =?utf-8?B?dmpOY0FxcHJybitTa2ttelpUYUlLUjJ0cWJSYU5ONzlKUTA2M0RWTFhPMi9i?=
 =?utf-8?B?M3ErRlU5V1lsZkdsWnJMbzJqYmQzUGRBbmtTWnVyZzRRdW9GWlpheW1IMUpi?=
 =?utf-8?B?NjlKZE5Va1JQMUZNbkFwaWRTTWxoZHowM0t5M3g5M0R4RDhrZldkUitiNnFL?=
 =?utf-8?B?Q2dDVENaVGxvNzZCKzBJczF2T3RqN3FoZUxEcHl5RTU4VUY2bXVSZC9uSDMz?=
 =?utf-8?B?bzlhZTNNNUtpWkM0a2MxakxTNk90RWd4K0twTXJ2ZnpxeFhlQ25TbWx2K0I0?=
 =?utf-8?B?bDdtRVRwQlREZFN4R1pHWFVPdkVEUnFUNVhwNjdaVEdTM2lzbWNVa0VtUlRH?=
 =?utf-8?B?TlMrMmpnQXJ6RUFXQ0kzeXNyQ3FaUDhxR0h4ZVpLYUUySk80NUErK0JDcHBv?=
 =?utf-8?B?NkxSSjVyQWw2ejlIMVo4Njk3c3d3Y21MQ0ZRZzAvaURPTFBmZ2pCcVE4NnpX?=
 =?utf-8?B?b1NsMlFCOWM0ek5mMjRUeGVlOENVclIzamlkSXlZQjBsQTVuZTN1SWcxeFQ2?=
 =?utf-8?B?c21MY0t1V0diazRrcHVQZkFGNnFMT0JtQjJBdlYyK2RYOGM5c3oxUnQvUDVQ?=
 =?utf-8?B?cVdVVk4zNG1VY2V5aFQxUUlnSlpmY25JdjRBOUhoWEs3eTN6SGZ0YmJVbWIr?=
 =?utf-8?B?ZDNaSnV6cFFpRklNeERBUm5YeGZ5Rzh2RHpTMEJ4elI2MEVWNUpWZTQ1bkdN?=
 =?utf-8?B?WFVSUEgxdGhRMjJubjVJWC9LUElFbStHdFlkdUR0cHdQN2NpZUw0WmtBcVdF?=
 =?utf-8?B?bG1nMmIvbmNtRGcyeUszeExHa2Y1WXhLVVY2RSthcTM1QTRWTXlENVRLNzZB?=
 =?utf-8?B?UHNMbGE4MUZkVVRUVVQ3Ymp6QzgxYUt2bDFzWjg5ZlpkbVVCOGN5MTJRU2NW?=
 =?utf-8?Q?WMF1jfoE3G/SVLnvcZ03Y1En/JWW8w0Ebc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:15:06.1792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0bed1c-ccc2-4584-4aff-08d8b78230a8
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Pvhp8OPsHegfLJNW8tSXIzmmDRDvqQw5nI+q7P9EPL2jQxhNrr+AtRHnpKYvTY6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1720
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/21 12:58 PM, Andy Lutomirski wrote:
> Andrew Cooper points out that there may be a nicer workaround.  Make
> sure that the SMRAM and HT region (FFFD00000000 - FFFFFFFFFFFF) are
> marked as reserved in the guest, too.

In theory this proposed solution can avoid intercepting #GP. But in 
reality SMRAM regions can be different on different machines. So this 
solution can break after VM migration.
