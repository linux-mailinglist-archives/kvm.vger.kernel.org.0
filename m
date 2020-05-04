Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8362E1C32F7
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 08:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgEDGbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 02:31:16 -0400
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:30786
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbgEDGbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 02:31:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1MEnqCYMt3Ws+6WCHoYwzN7V2XBnXUeV8pncfmjqJHogg0rPHkXKjjutlBFMnidgy1OpEsHG90GlW08emF/v9VPrRNXgP2ZEqNd/18qwTkMXJAAKDU7ykBxttQYIMMval0Mh5ASkvnjLYDtCQd+YCtZ0d6jQklUvqqpP5VrkCIzfRa8xA9Jz04g1WmUU8e3Z8gGPrb+e8YcUo5toKMUJwSHcqbiVM+RDEpMN97vT1yU0vAy8iJMQqBAG1KhlPncqe0TArdlYJ4o5PjGeDBPU0dnyTgaPklWqjF6QiOtSURfAImiQqQAB4kHvyT3TMx1uvvVEbDUGVtICbssnszhVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJs9APsA/TA2m/74703C5FE7qbDPux9zMDGgDchf5J0=;
 b=NM5+rT93mF9/OV6ef8MIeOqJe1MCjT3gV+6do+lO5cp+OFtNw/7a9Sw0P1PQOhVF2/uIkA1Ok9xWagN7ynvmCsbZmWmuW4W9hJLbHTv6MZxgYIONeZRWYqUdasQbEnu8kDEO93bvIKtKWHCjlt1dFP7cMZBCrIf2+doP+cK0k7zgLQIjC/Bd3LA7syT5fShsyHGBS9BSCZN6W+0ksw06VXRDqs4kI/8F8ffapB9DGt17C30bgfMPQa3HrxOaIZJi5wcADHnhX+GyZBGoAb3uGuN4uMK/dDlLbkLmM3UbuwatKszmcQiW1/KkGQ7RmQFH99LaKcGpi/z3cv/LOBhQlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pJs9APsA/TA2m/74703C5FE7qbDPux9zMDGgDchf5J0=;
 b=2oipZs19OF2Chopy4zHtywlwKeztQEfyUGjV+oyk0O5NwsYWgXPqclNtqE7woCsTvi2iqJG8y/H8LL7+uQkzn9pSDBuQ0xu8pC+Iy5n9y3lthwJV2rS/otOOVIdrN7ZZvPeYWF3L7hVx93sejuugNGWDjUmOCbkaGO5J+KgIVmg=
Authentication-Results: bstnet.org; dkim=none (message not signed)
 header.d=none;bstnet.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB1466.namprd12.prod.outlook.com (2603:10b6:4:d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.29; Mon, 4 May 2020 06:31:12 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 06:31:12 +0000
Subject: Re: [PATCH v2] kvm: ioapic: Introduce arch-specific check for lazy
 update EOI mechanism
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        borisvk@bstnet.org
References: <1588411495-202521-1-git-send-email-suravee.suthikulpanit@amd.com>
 <e09f0be9-6a2f-a8ee-3a96-c8ffdf3add3f@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <fd2529b7-66f9-fd4e-d071-a38d01e4b61c@amd.com>
Date:   Mon, 4 May 2020 13:31:02 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <e09f0be9-6a2f-a8ee-3a96-c8ffdf3add3f@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0181.apcprd04.prod.outlook.com
 (2603:1096:4:14::19) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:1811:ded2:5c1a:f796) by SG2PR04CA0181.apcprd04.prod.outlook.com (2603:1096:4:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Mon, 4 May 2020 06:31:09 +0000
X-Originating-IP: [2403:6200:8862:d0e7:1811:ded2:5c1a:f796]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ad30cfa-711d-4639-1422-08d7eff4bd16
X-MS-TrafficTypeDiagnostic: DM5PR12MB1466:|DM5PR12MB1466:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1466CCAD497D203C88FB69B3F3A60@DM5PR12MB1466.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03932714EB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnV7mmZi8YH+pYCwewJqBU0sh2JVPuve+0Z+idkAqWtOBwnDukOr1EkuDJq82kjTjH0jOQfQR9T1UNh5hQnzCLq9yfd4FNO4wm4c4ZiiZ4GYTmdQEd0Mn04G74oeKzUEeFcFDDUIPkbBeHGpbnjKkDjLtBnCVDNMB1HqYMv/pI1/6z1z4tkuwTWesn5TIdAvZGJKxBnjZ/6voiOUOqRI6sD/wYtXA64gRAKwn+pzbm90NqMxrdIAAjGJQgwixxEQqIcSkfYI7OIOb1gi+nFsdgt1ZtgVldE2JGud+yyLgHO+YguQ/gSYSvo6Axvkifx8S5Dp8v/kre8rts1Y1xvCATXvlmVq8wbAoxe0tyRt6XZpv14+gLrdZY63gZ/YfPwT8la+akwHjOgYr6SSb0gc1HMxbpM3QRsILeKxH0NmClwADu4u4HkrNIv6O9RDMERS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(44832011)(6666004)(5660300002)(2616005)(86362001)(31696002)(2906002)(4326008)(31686004)(15650500001)(6512007)(478600001)(6486002)(66556008)(66476007)(66946007)(8676002)(52116002)(316002)(36756003)(6506007)(8936002)(53546011)(186003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: S+bPUe2GdRjQtn7rbPlTG/aBqWWtJu1AHu+QjTuEUgAiDVujBfJLvyKwFWZvVvFtnOaUdgjj5nmJeD0nzuUMeyuzThfPRmPCk226uFmopkigk5VmWl9zgGZNNNiqc13PVC+LFqS1ZKx5speOaxH124kQ+ENqTyFrIvMqAxdK2BrukOdKf7s2shRrNnqNXZyL8s15Ibp+adRLVmgNth8NsWYYLUoaBwoSt9yuir0aZWN08Eu/b4lu3COL9Wyu+EvAsP+DHvzthEEcloIXCJb5zCGo6/IcliTT1xkn9DEcuxvDmjPuqgv/WnfUK3hT44zRDC+Hfpgj2Im1Lbd+E1p0DmyZVhlCxX3M4/TNsTH9BCqUAP/CyLuLBmyiUsZtO0sCxCCIccVWPWwg8/abuna1OLIhPDFobVzz3H2QFECMc/qZHskgTMcPbLHIYl+egJn4JIUP5CU2aEsRVH+s/wH3NvVT/g4nobf1ctGo4ngG7W8SJmW9xBcESrpCwPY7KPkUyc3tYkLj1FjMqiZA8x8O9RE+5nkdi+wdFRnNPYCyMDFTA/8Pvyjl6pL7pg95hhIjSQRpv3O6sq4QPYAc39LV9gDb4/MeUwh4Dqclw1MxveskPX+E7E4COuWnDNo2FGWviMccNMt57rhpKGVDv40FdFovcJyZIFNX0sq6wcqNp5xDJB5KFwzMA7PcCggYmjzL0MKJRew3R0PtHxYLsuntGu7LF6WzMIJF552ABmmL2qsJOnlXCtnvixOMDmWw/b5orhX7LPUJ9RvQxCu2XsvCX6HUtHGcaIFzWqByD+/mHPSEcL9jkXsZrozmaS/mJNsy/f6raUl2RUGoxOFbGqSVGfHsRdFahiilLb5XwWdgl78M/44Ltrxiq6S8i+AL8n05
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad30cfa-711d-4639-1422-08d7eff4bd16
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2020 06:31:12.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnJ4T0WZy1SIMNS51bntGhdrbk8OCOU/YNqvQttHlJuDqGI8Hh6rGxlsdnrYokGaU1PTf1pv+Q/43hjC5clwSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1466
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

On 5/3/20 12:19 AM, Paolo Bonzini wrote:
> On 02/05/20 11:24, Suravee Suthikulpanit wrote:
> ....
> The questions to answer are: what is causing the re-entrancy? and why
> is dropping the second EOI update safe?
> 
> The answer to the latter could well be "because we've already processed
> it", but the answer to the former is more important.
> 
> The re-entrancy happens because the irq state is the OR of
> the interrupt state and the resamplefd state.  That is, we don't
> want to show the state as 0 until we've had a chance to set the
> resamplefd.  But if the interrupt has _not_ gone low then we get an
> infinite loop.

I'm not too familiar w/ the resamplefd.  I must have missed this part.
Could you please point out to me where the OR logic is?

> So the actual root cause is that this is a level-triggered interrupt,
> otherwise irqfd_inject would immediately set the KVM_USERSPACE_IRQ_SOURCE_ID
> high and then low and you wouldn't have the infinite loop.  

Okay.

> But in the case of level-triggered interrupts the VMEXIT already happens because
> TMR is set; only edge-triggered interrupts need the lazy invocation
> of the ack notifier.  

For AVIC, EOI write for level-triggered would have also be trapped.
And yes, edge-triggered needs lazy ack notifier.

> So this should be the fix:
> 
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 7668fed1ce65..ca2d73cd00a3 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -225,12 +225,12 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
>   	}
>   
>   	/*
> -	 * AMD SVM AVIC accelerate EOI write and do not trap,
> -	 * in-kernel IOAPIC will not be able to receive the EOI.
> +	 * AMD SVM AVIC accelerate EOI write iff the interrupt is level
> +	 * triggered, in-kernel IOAPIC will not be able to receive the EOI.

Actually, it should be "AMD SVM AVIC accelerate EOI write iff the interrupt is _edge_ triggered".

>   	 * In this case, we do lazy update of the pending EOI when
>   	 * trying to set IOAPIC irq.
>   	 */
> -	if (kvm_apicv_activated(ioapic->kvm))
> +	if (edge && kvm_apicv_activated(ioapic->kvm))
>   		ioapic_lazy_update_eoi(ioapic, irq);
>   
>   	/*
> 
> Did I miss anything in the above analysis with respect to AVIC?


For AMD:
Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Thanks,
Suravee
