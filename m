Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D626A44D9A5
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 16:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbhKKP7x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 10:59:53 -0500
Received: from mail-mw2nam10on2050.outbound.protection.outlook.com ([40.107.94.50]:47712
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233902AbhKKP7t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 10:59:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrfxrzVV6xI4QT9LaFpBVSl0QxxHEAvt1wxEp26WOeegaxrTmlM38ekltseyKbXSAXggI2bQL3VOHskQz97nCB+LGNatDhSuWnr+LmdcLA09+eR4OAbJgilY/h7Wh/S4oNKhEczaNrTkUkxyoXkaTI+CqUaz6ZaX9DJnUeL5sGO3ZfVZ9ln6DBXxtgECjomUN6b1RjBDN6lThJCrQvItGfuBU3sDSclr9gTpVZpGPdWfwQtYYE2R//qmprVFNl/rlbzsoNUtOndxc0EI0mqYaflKSXa/d/Auz0GGemXVjbY35DO30h1HEZ2JNSlSX3O9wqVreUlhVnLuUVDkemoy2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IbsozjATCngwdZzaHBtVFoYTrYNjq/KXcaxfuw/ujtQ=;
 b=JCzvLjRhpdP95CKGL2IdZFg2L3XR4d3/sao7Szho749zqH+G/KBqAKxCW5HMmFLnFHHYLiUqiULWnJTs6kam/An9R/KDwMPeXzWtnY5VD6Jb0YJxmyPgUWxiPh01dP6kW4QC0IZuEvtih1xo7LD5RQhvEMrBapr3xjDcisT2Jla7dhH7PPhY5tQ8HSuPjqoVkZ1bCbDD/dpEyPja2fdHkCuWp6eS+35zwewKBAevYmMyq4Ci9X+Nf18SJ+sXpL+hAOVG383FG/CtdFN9zxf4CT5KjiOUbu9c+EMj1waquHH7TMXRidxM+mTTXaApcWtgJWcwgyqrYRWZxq5jyuyERA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbsozjATCngwdZzaHBtVFoYTrYNjq/KXcaxfuw/ujtQ=;
 b=faJyRc5Zkyx1JVuH1YQwbegiK4ys1LDHDWz7V3hyYs+415B4GQpUtMgkxgzisgh2aTxXTvq3vGCIhPw3Rz8vSWWUHW/blD1Zs7zohmhKNatzHwrO3fpbtstywk4ej57tJ2KVD+qL13rivInqkuKyyai5U9hnCDo9rpIczDVNbdU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Thu, 11 Nov
 2021 15:56:57 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%9]) with mapi id 15.20.4690.020; Thu, 11 Nov 2021
 15:56:57 +0000
Subject: Re: [PATCH 1/2] KVM: SEV: Return appropriate error codes if SEV-ES
 scratch setup fails
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211109222350.2266045-1-seanjc@google.com>
 <20211109222350.2266045-2-seanjc@google.com>
 <fc56edb6-5154-4532-242f-4acb8b448330@amd.com>
 <b13cdd98-52b7-f70b-5aad-5f8ca6413bc0@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3bd2d4f8-1077-6f57-ece6-13354f1f5ede@amd.com>
Date:   Thu, 11 Nov 2021 09:56:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <b13cdd98-52b7-f70b-5aad-5f8ca6413bc0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:806:24::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0092.namprd13.prod.outlook.com (2603:10b6:806:24::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 11 Nov 2021 15:56:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8a3ac41-0117-4c98-c1ff-08d9a52be368
X-MS-TrafficTypeDiagnostic: DM4PR12MB5296:
X-Microsoft-Antispam-PRVS: <DM4PR12MB529667F0E6FA79D8835F1AEDEC949@DM4PR12MB5296.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SNJ6OGN3QMoD5uQepjGoXOoIuylGe0LyficEkMJ873fcpxcpvVXPXqsNopMriN0AQck3Du/pq3aA76YkNnYAfWuPD6/Vtt5n0BedElsGH37QeSViQEblP81p4pCdZ7QKaOdOlhNgj3gRa7p9gt0qwb9fBQ22p9aH1El8NT/hyUx6ZC2ieHbtqJOmM/vJyaJ3+LFtw/+CQJg2Y1fDnl7ZgWcQXZzpJmgP8sls7dr9tJB9b8TcJ6ByOwjXOJvcWU4s9Mi6wOWNu5RmOXlUS8I+EV0YWnwqH6jlTLv+y8MOeP9Dfg5TuxyIyMqCKbLwpauLrj3QCAU3glM6ytgkUZWb6xtG+btiiR+bUPRFwK+WNh9ArRtkEaR+R+DnhyEbIKWdniBWX23/b3Dx8TZBVYCJBLHR4ReuFeR0kkk/CuR3m6fzVmasFNPgqWUPASASNkWSa4Z+pGtqybFkgpCHHg9TsiMvDltvCsO57GS0ybO7ztO/aYwAd9vcFVpch+oHFLhKUUMY1qj4hsi6PE+eMEJuo7MIR/z5dX5EIsd57A3oO3/EaBqjAIdDWJ5C/vKUVY6FmJyK4B+EzYCfJ4VztKgwSvpzQrqPnUyNYShlUKottIJifuObagPbzF1F0s2Vo4CuqqG+AlRt7birRXDynC6ISyFDBLAmlTajLebQYgQZ7CwMXLxUkQgJI1NLu3NF4lVC69bFcRDKfOEWxu8XFj8otnxSyk85aHNCnlY3F6lTslI97q7+xiQpS+gP38DLi8Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(31696002)(26005)(54906003)(4744005)(66556008)(5660300002)(86362001)(316002)(956004)(2616005)(66476007)(2906002)(4326008)(110136005)(6512007)(36756003)(66946007)(31686004)(8676002)(53546011)(186003)(6486002)(6506007)(508600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vy9QSFU3NXF2bmRNZGVjSDIveS9PeGxnb0plSWtLUFFuS2w2ODk5aWZMTjRG?=
 =?utf-8?B?Z2Njc1A3YmFMQ1ZPN0cxaEVzb1ZnWEpmQWE4N3Yxd282WWtaMllyM0k3L3lE?=
 =?utf-8?B?QVJ6Q1B5UXorQjA3TUxnK09obGJmWUxtS0lBb1YxaWFkZmdISGFqbHpUeFJo?=
 =?utf-8?B?ZUloOFl2bFZFVmpYeElYNkllUUkvckxXMUhUdjJZb3ZHNEVSdHhhcyt6L2dl?=
 =?utf-8?B?dkNRUTZrSXJwek9SRk52WlhBY21RS0tQbExsNFF4MzlDQk43VlZvNW9YNHpM?=
 =?utf-8?B?Vk9DdEtTSzBPeE4za2xMY1VKeDEwTUhJRmRrTm9jMEJFYXBxNjBLRk5HeG1S?=
 =?utf-8?B?KzJQTlFJWStOZG9mU2ZQUWxPeURrR1h5SDZGc1BqcXI2TlRnYW1yZnZBSzNB?=
 =?utf-8?B?ZlloTnVRd1Q2NVdsR3hrcUtEMGVzZW9IenR1K1hQbWJreDRmWEhHdDdpZnlj?=
 =?utf-8?B?SFZZN0dwempmSFVmV2w0SExQRlozd2xOZzdRZndYdFI4eWlFYmtZTkVmQ0dq?=
 =?utf-8?B?em1aMERhdU05bnFpWkdodm1YYlRQeWMrMjY1MnF3K1VVdzB3b1FOTnBScVlp?=
 =?utf-8?B?SWxZdmRZN1VVcUdGUktZdFBTcDZaYkZwdTFwekZqRHV2THJqTGxGSFpyanRu?=
 =?utf-8?B?Y0FnWDR6cFVRc09oWDJOY0F5NXh3Qk5pVjJOOUNJRlI4ZTJVeUdVSlZqYXY0?=
 =?utf-8?B?TTdBYkc4U08yUU04TlVwcFR4TnhEVWZBdnZQbkg2TzlzNVdValFqTkFhN29M?=
 =?utf-8?B?OE9yeHd2NjRlSVI4MTFzSzAva1QxdWczMzBFa1hvTWJ2S3loek9LTm1ESWJM?=
 =?utf-8?B?SWg0bVR3aUFLUXJGbkxnTCtPN25aeE5yMHJCZWtsaVhDQmlMWkJPQStVdEJE?=
 =?utf-8?B?N3Fqb1R1MElSMld0ZTEyRlZFT3hOS2UzclpLSzFaS1hUcTR6WXkyaEpKZ0pp?=
 =?utf-8?B?SWpMWkZuTVEwRVhlWVY2M1pIa05pQ1k3bEtYbFo2UkZkd3NCZTMxQzBXSENx?=
 =?utf-8?B?OW9uN3hzUWpEZ1RadHNYNlFJZXI2UGo5SHhHMVpZaGI5b21YejlXOUdsbVVj?=
 =?utf-8?B?Z2NXcnNFdWtTS25HbkNvbVFscUZuU3ZIaE5QbVFTRUw3bjJlZ1JNMGdYZzVT?=
 =?utf-8?B?SUNpZDBRV3ZJcmhGM3BvZnRCTGdpUHlpOXFtdlpnTEZWeDE1TEx6VzN4UVBo?=
 =?utf-8?B?WkhKaDNSKzVPcm5USVlDd0pzRmxnWXFYRHJuQS8xQXE0T3Nldm1YZ0cxNnpU?=
 =?utf-8?B?Njk0bzQ3OXV5R2Jzb2EvSUFBeEIvV0QyZ3Y1OE5nTVVrQTVhWGRGR3Vlc2gw?=
 =?utf-8?B?TVdTNFUyaGdoS0dORktLVDRyc3pVZklxVUJWd0MwTTg0ZHNNemV5cFNNbmNw?=
 =?utf-8?B?REo0Yys3VUhmdmE1eGJZOUVkQkVUMHI5Mmc2bzRidHhPaUY0ckdCZldMQnZQ?=
 =?utf-8?B?SVYrRFpVY2pFQmNXY2ZyNkYwTGRKYlRoaUxTa1dZbUoyd3hTT3NhSm9JQVJx?=
 =?utf-8?B?ZGRxVE1zYTNyeFJuMFo5a3pJUXNrQnZLRW9vR0hvTk9keTBOdGlZTCtramE5?=
 =?utf-8?B?WGRHNWxCenEvK0EwNVdWY2VSNHJ0aS9leE4vVXhUZFh0VFl0ZDVJbjEvM3VJ?=
 =?utf-8?B?V3dueW9VbTBySUgyRExKL3QrbUFkeGp2M1graCtweE56ZmlYdkkxV3hZa0tv?=
 =?utf-8?B?ci9ZUWxRSGZuWWVIM3pVVHA2UG9OVlBkSFVvSXVlZFoyN25kaE93dW91cmUw?=
 =?utf-8?B?VUp4VzNTSUZGVU1HemFxWGh3YTdvQWMwK0JMSVBRUmU0bnBFUU9RaVRxT3U3?=
 =?utf-8?B?QjJzbEpmZFA2WlphSUs5Y3JrNUYvMGxQSmZSTStxTUEzNHh3WXJwT0tocnlk?=
 =?utf-8?B?UkNzZzJBRE95RGk4OFEzTXp5eWYvN0NTZ0RFRkhLVGx6K2FKN1FnSlJPbDh5?=
 =?utf-8?B?YjVocjdOVFlacDBGek8wU1hBV0h3RitlWmxLSEhHUW84SkY1RTlPOVR6VDJT?=
 =?utf-8?B?YmJmNWcyaTdBN0szbFoydUJlMTJVU21Ha2pqYW9nNFlKU2lwK3dJY2VHQkFN?=
 =?utf-8?B?S2ZTeFBwZ2ovWFl6blZYRlA1QTJEZGxONU1kdzNIYnJRZEgwQ3lQSTFnVHMw?=
 =?utf-8?B?VmEzcDJZOFd6c01jN0VWNERwRlVrNTU4S3NPTmpJaDFURXlocXJkVGRqWGVL?=
 =?utf-8?Q?h5szJmYh3diKBjK9QNyiLCc=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a3ac41-0117-4c98-c1ff-08d9a52be368
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 15:56:56.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nQd4bfSn8fajglrXiqYwguL6KzwraNOWizTzElnXtERfK/bOpvO2/uSO9Xzks25mqr37fSMr7l1NYjIVhmbyLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 9:47 AM, Paolo Bonzini wrote:
> On 11/11/21 16:14, Tom Lendacky wrote:
>>
>>> Return appropriate error codes if setting up the GHCB scratch area for an
>>> SEV-ES guest fails.  In particular, returning -EINVAL instead of -ENOMEM
>>> when allocating the kernel buffer could be confusing as userspace would
>>> likely suspect a guest issue.
>>
>> Based on previous feedback and to implement the changes to the GHCB 
>> specification, I'm planning on submitting a patch that will return an 
>> error code back to the guest, instead of terminating the guest, if the 
>> scratch area fails to be setup properly. So you could hold off on this 
>> patch if you want.
> 
> I think we still want these two patches in 5.16.

Ok, I'll rebase my changes on top of these then once you push them.

Thanks,
Tom

> 
> Paolo
> 
