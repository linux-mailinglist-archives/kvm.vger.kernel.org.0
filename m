Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBDC3C64B4
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 22:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbhGLUIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 16:08:07 -0400
Received: from mail-co1nam11on2081.outbound.protection.outlook.com ([40.107.220.81]:45344
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231693AbhGLUIF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 16:08:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgT656WVTYbSzrWfcpN8hvWhZVzHLoBpBVdOFV5/NoCadohRbyHar2flZR9kBiuBOzIwz1ten4bVrhHZG7EzBSzSgKFClS1nz0JvCLrkGohJLf2GGBtNe4BGEZ5/k51qjGsisYqQ2WuVI5Klaat+uCCydJb/dVLcX6CmPCo6VTTnuvkvbIAz+gAmTC8LZGQxEM9B6gJ3wPQ6XJFAJ0+I8nQQZKADb2XErtA4WRtYp+iRTl5jaO50YwRz9r6vizDuWQm3JGGtGa1kOoXljiTwTQXcfRaDeE197r0P33SNYfZw3A55/VmlcnTIyNkJnQLtjdeBLjaOSdCatSibuqQtFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qD3eMhZaPQW9rr3sgBBOmZjvmp2gUxke6MHYHu3/B3U=;
 b=L6mT1Mo2pdgzL1ndvy6TQ6OmLCAO6/GCeFaeW9IxC75DJcqUduVLwAY3jKPFmYh3yX/r38mLfd0kSHqm7VYSbXnh4qlWLaV6BOaFZxGTS7J1NqEk/3P57aeHWv5PGm8iRcxTLDIFMeS3mm4Gf8feyfE72Uj0FHRdIWw3LaJxOiVFiFOCHZMSaWEGrdcl7rKW95Df2fY2mrZVas3moqk85YWAjYs8cROV04BxugDk6rfvS24QbTj7Jk+KP5ZDlDVA0GaJuZYDPMQYDsuQl3T7fUhfo+PunNpodWY3Miwp9vEEsGOqkp3h+cjWGLfzBZIJ2+FAQMFRAa01wMHCLQiGeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qD3eMhZaPQW9rr3sgBBOmZjvmp2gUxke6MHYHu3/B3U=;
 b=OsVJd5qoH+81sbFAMu1QviFoL7Nkcf6FW06QAXc6RymqTsHgFA2GMb5ujXVCkQ1/V6iYQmZQ+qOoGByLOMn0vtjUwVf8NYIT4pAJgRzCpGb+ILTDV+j4b51ReEjAiJRKsYvTNm5Kr28JbSopmT7SmKYukF76SiZBzswK23eyqa0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2543.namprd12.prod.outlook.com (2603:10b6:802:2a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Mon, 12 Jul
 2021 20:05:15 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 20:05:15 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM, SEV: Refactor out function for unregistering
 encrypted regions
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-2-pgonda@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <11c371de-88d0-32a9-a262-45e62c623b4d@amd.com>
Date:   Mon, 12 Jul 2021 15:05:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210621163118.1040170-2-pgonda@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0036.prod.exchangelabs.com (2603:10b6:805:b6::49)
 To SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.95] (165.204.77.1) by SN6PR01CA0036.prod.exchangelabs.com (2603:10b6:805:b6::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 20:05:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5c33b7c-2a76-4d0c-fe54-08d945705d5c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2543:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2543E6CB835EFAF5468E7668E5159@SN1PR12MB2543.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RX7Tz+MJWmWdL270hU0PfjmKf30d0z/0+qAxc0GN0NRb3dzSFWajE1hFH4It+1M3maK2fPYbsyuWef7tN6ii2TFvTrKzKSgzOnVR2CeoWyKgTUEGbzEWCe2oH0xfm6rNwzW54VUX0cTYNLBEyfB8qtmK/FLVJeqwzm/ozukMyc00480leS0tTwRUlP8ZLaCCcB2iY3D863YOxvIAVoSpnUqKfR0bKCUoMRI4lPDuT0hLsEY0dCij5i9xfoFpas3MRPm/dJbe62iV+8xwJvtqmqovr4wbOfbMdqw7zD0ac7lwgcornRKZoKTj7Geql8e5S2bjZcLnOioDkR1I6eF3DGjG1xpvGK9NQZcgF0cbplrJxBoTgI+lJYw0hEcg9FVmJyCQtUi8qA/ef9DbxlQNvhYGh6briXNEWo2z5vWKraYKzxhOLm41lNyVtVdnH9qA4v18dKNkxR4hrenwvLqGCPrZBFYtxveJVgl8ZB0GMhklo9SWNCne20z2b9wfuqRjRVVGAxRvlhNvZbjjLyFUzDFnFAUlbjGDIawtgZueFWB1uuttFx9R6SILEIwGKENkoSv1a3B6riyJBPTcaWfP0iQkC8+Tlb12hu6p0rnBdaLgvJR92pHxzx6yTCqYeUvwpZpsuqF30hCEJ9KyugaAwii11OkUFp2DDiZJ+NYm9Iyaj04xcuPOaBprwFax+Wg2gDrB75v+Z4Pqwd+1gRr1xYrobKLCT072tASPBhQNUow=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(478600001)(53546011)(316002)(16576012)(186003)(52116002)(7416002)(8936002)(38350700002)(54906003)(38100700002)(2906002)(26005)(36756003)(6486002)(2616005)(31686004)(44832011)(8676002)(66476007)(4326008)(5660300002)(31696002)(66946007)(956004)(66556008)(86362001)(4744005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHBGaHlMSnhLMFRaSndpd0pJMU9qVldtV3NiMGZ2V0dLRlRlVUtjK0tqRFRs?=
 =?utf-8?B?L1hUSXMzNjhHWUR4YmU0TTRCWCtzcG9jRWlzOEh2Y3JzeXBNRGpiZ0U3bTdu?=
 =?utf-8?B?LzFteFJOL0FXR3JtRG9mdWZxVXRvVDh3clh6UWV0TnBkV3JVa3VsN0R5S0c3?=
 =?utf-8?B?SmFBZ2R4RnBoMklFNWJTM0twUStReGRuNjBFZEczZDA5UWxrdjBKZDVYeXFz?=
 =?utf-8?B?aDZHNFlqdUYza2M0TTlCbGwzdlhMajMxcVFsMzdNVlBid0xYTTZLQmxvcFZl?=
 =?utf-8?B?a1hKUSsvV2pVU0xnU2xUalI4SWpldU9nayt0MzFwOTZNYmFxQ0YwVHhUOUtR?=
 =?utf-8?B?STBqQUdweS9DMzEwRVh4YVQxS3daYWJ4Wmk2WnlPaUN3dExvMlk4TlRqcnNH?=
 =?utf-8?B?NkRMeWNoL2o2MS9IdjdzcEhxL0N4OVpGMTlMOTlFSHBTeUlsdXdDYUdZeXZU?=
 =?utf-8?B?eXBMckZybDQ1eTY3VTZHUEZIQ3AxeG9uZWdTa0pUcXkrY2N0aG9CZ3M1aUNn?=
 =?utf-8?B?T0Z2N0Y3SmF3UE1wYWNKVmRTMGhhaWpXVTNqbldiRnd5R0E2NFRUdEFsN2xv?=
 =?utf-8?B?SG5hWkErSndMMHlPQzBtYTI2UHlvTWlKdDBXK3YrVkd5T0dWZ2JpUXhHRk4v?=
 =?utf-8?B?MG80Zm12R3pKOXRYR1RnM3poZ1EvMk94djIzRVVNRkRVVEJZdHJSWFNaVDdt?=
 =?utf-8?B?dWF0SDFvVFJteFJ6bkxaeU1MeVp0OVJGWWtjRXdCYjF6d1pWTE5pK0xUQnd6?=
 =?utf-8?B?UFpFWEMvRWxsYXYybXU4b01UNVpGR3haVWtUSzFmTkpjaFBTWHFPYnd3M3Zu?=
 =?utf-8?B?eWJjTkQ3K0M5bjdTYzRZKzdPYTd6Zk5HeDZXb0F4bjFML01pSFNwS3VLYkZR?=
 =?utf-8?B?YzB6eXZRTUdBS3FyY2wrSTRsNzhpUHhFS2d4MjJtR21jOEVsV3d1Y1Q3K3dv?=
 =?utf-8?B?YkM0TXJ5ekQ5TlVpR2IxM3RHLzUxdS9pc0c4dXh5bXNTeXVnUm90eFRScEFU?=
 =?utf-8?B?RW9MenFxQlZYNzBsUHBXREpqVzJTc0Y3dWQ2aENPd3Y1T3lSZER2dFY1Rnlu?=
 =?utf-8?B?U3dKV21iVHQ0Kzk4YmpvUjhXOG1CK3dMbXNKSVZyRk4wNUJzSldOaXJWb1lF?=
 =?utf-8?B?UStRQW5hV3piQ2pUNjF2YWU4SGk3a3hXRk0wUWZ0N1hteVIrczJoZW9CNThh?=
 =?utf-8?B?TnhQVlFjUnpVZjdQSkl4MFBkRldIU0kzQjh5bHlJN0NCL3RWZ2x3RG42RzVX?=
 =?utf-8?B?Y0JreU1xdE1uQXNpUHFkY3VtT3cvQU42QmFrckZjRFdZbVh4Zm1MbzdEZjNE?=
 =?utf-8?B?TVpMVGY1aTRGODZXRHlTYXp3L0VuZ2VKcTlXMndFVUZ1Wm12VktSSmhMVTFy?=
 =?utf-8?B?eTNJaHBPbHlCMzVabWpyU1ZiL2JQZFVLSmRSOTljSUlUZkNnQnFXUWdLbFVq?=
 =?utf-8?B?RGpvZHhmWHZ3SWE1YkJENTcwaGs2Wm90S0JNeEZkSUJISGlZNGtYbElLMmx3?=
 =?utf-8?B?YTJjc0ZLVlBCQTFrdGJJWEV2WVBwTVVnZ2VyeFBZTDVTTFpGZVVGMkErWEU1?=
 =?utf-8?B?djJqV0JzUy9yaFgxTVBybWNJT29QVktZbGxqRVViZHFGajRoNzFvR3dzbEdD?=
 =?utf-8?B?WDZZanNrYzltTlRSRkFPSXFla2lGR2dkTkpaTXBkM3RKTG5hek40RTZISnlM?=
 =?utf-8?B?cnZmLzhXSU05TDZvSk9BSWNpdmhRaUpTUTdBendyelZ2MU9HU3ZhNXV5aENV?=
 =?utf-8?Q?hju78GHrLq3oNm3+/nKuoG2DXQFjilYNVAPyzdF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c33b7c-2a76-4d0c-fe54-08d945705d5c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 20:05:15.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m32Fmw+uaV8/v/bpxvONUCtYSNjGTiMzHHu3LwAokmlb5/mcarDUvXnSqUvrYXEu5j3PVILFORhWOg7cqCdZbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2543
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/21/21 11:31 AM, Peter Gonda wrote:
> Factor out helper function for freeing the encrypted region list.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks
