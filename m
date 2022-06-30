Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25303562288
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiF3TB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236758AbiF3TB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:01:57 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E2A1EC5E;
        Thu, 30 Jun 2022 12:01:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crCbM8a/xcbcu4iRkfj7uvmN0MXvCtTlW5n7bi7WL5rhhQTdSEJ7vOkro55lbPkmSP4zXn7mmgeJd64zDf1Z7/hUZATT2YZO3hTyAzbTehpDAiYbsRq5oH0vFDTLcx/PplbVXME8UkHNafcslNJRtZmU4pp8r7nl4kqTsSOLc7Om+KHBIyKrA/dRCLQWSfUU4cbqvKQLPAvPA/9Of0p9sv7JRjzfn7mtJedA2JTdMtTDFv/Npo2XEvMZzXcMRi6dZ5BR5nRmeLMtIIlRjlUEKOB1TzwnovdBt2C0NxNUy/ap23e2cRZ0QOu4Elb8IsH+d1BjE31qa2tYfceQQD/G+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NPYHSBiZN972ACrXZKFkFLLL/jxJviSlN39x1lUt/k=;
 b=cRBVGn+t/C9U9P64t+hNEd5Sn2SnvaGxGdoLhpARM6mCWIi4ETBuuvkQgMehcmwLoV7atOAKhMGNSOD6MHPWiL7iKs7pCRcEsPmXeJuMP3ci50Xobl3Hr/yRa1uFRRZD/2Aeze+51ywC5oqXupNsjs+mXej+0RUNzzt9NOsOn1D5ukH1RSNcr7rr9+aYU8ZtHroYRcLA74xTEbtKaUs3E3VZPY1xWM7AW/S6LC4gpxmGiFDeRTsGGiyCruY5MxyWM22Y8y7Z+A6ugA34FT+LbWUKYA0AGUxzp5qnsgz7VehE2u1DaZu3Igh3+jDn1YwabT0Z9n73T5WXjp/7iA3Rhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NPYHSBiZN972ACrXZKFkFLLL/jxJviSlN39x1lUt/k=;
 b=gyAWvohwyXfknIH3d8Q6W7L0YkZEbZrocqXxVXmRkxBXlYdFsI5uD5yHankxUt5aCAYYKnwN/g4VrhXG9hZH7OqYcGPctitoHwgFkQ7b7s4sHExIakgd/ibbD7c/hOlPKhnJQ+F6HFiF3EXyv6JWkqENyRq77y0RZ0yWzecw95PRFk8a0+8W81+SvIY2AmP+yCz54qUcsUa7RgTL/P7ROjCaw7DzzWGHWUzgKWzRc2pee6DfLpt8i66lC9+g8gMjrFJOfHM7YyCTX71+ttneJCR/GuKUwc18aXDLAbhM0BrGHDvpcxY9qWdBObLckv9B1Te1CFET3Th2XkoQ6001nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by DM4PR12MB5088.namprd12.prod.outlook.com (2603:10b6:5:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 19:01:55 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%5]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 19:01:55 +0000
Message-ID: <0183984a-c95f-c92e-629e-775071b5cd23@nvidia.com>
Date:   Thu, 30 Jun 2022 12:01:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/4] mm/gup: Add FOLL_INTERRUPTIBLE
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>,
        Sean Christopherson <seanjc@google.com>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-2-peterx@redhat.com>
 <c196a140-6ee4-850c-004a-9c9d1ff1faa6@nvidia.com>
 <YrtXGf20oa5eYgIU@xz-m1.local>
 <16c181d3-09ef-ace4-c910-0a13fc245e48@nvidia.com>
 <YruBzuJf9s/Nmr6W@xz-m1.local>
 <177284f9-416d-c142-a826-e9a497751fca@nvidia.com>
 <Yrx0ETyb2kk4fO4M@xz-m1.local>
 <17f9eae0-01bb-4793-201e-16ee267c07f2@nvidia.com>
 <Yr2p7sR3IjiGTGd3@xz-m1.local>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <Yr2p7sR3IjiGTGd3@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::42) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea10d29a-c539-43de-f89a-08da5acb0031
X-MS-TrafficTypeDiagnostic: DM4PR12MB5088:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ST6NcLY0OA6ZPhsSPBZJE94HUfZ8koquPdq+GH/+q+pCm+clH+bbC84lPwqmDoxwjfqPllfvXcNqcnCGyRRxsw7Am4xxqpq+akPXYUGW6pgplSkPUSSV2ydKra/7shT0DTsJVOlD2B8sT2opDdf2y9XAVPqUHubVkeBuIegimWqyiXVCJEz1UaMJAldHzWzn/N6o5DqE0XXEukkdeotbDAxq1LIn+KZskeKSha9Ebmo3Ckood60LaqcGZV4hPWK/sXeRTSry5rTZhazxSMSg0HL8BAod0hmBjRw6hzI6L+7QQkeABK+cGxgw8xS+/80bMbUDAVD9s6o3Aca26lDAm3emcDWq2dmEbVf7QgHG7VxwCuE590swXMzAjlVH8e1FZ6HY6ZMEgDyY9bdTVPoWp921jmoKAIu1na+lSyvbnD6LGhied8arUSpeEbiV/fh+Vax0QXKN4yOfHQX5fDM+u07AGoZhMGDRlQ0JUydQ/AK56FLAVTiUMM2GCwejaWTcF3fERkn5L+T64v1YThfUholh+Dhneg83nHzlnjJdNT/TRdHpR3XyEnoYMm2EQVGAOoXUYxHc5db3iC1mceFMKrBi0j58oWe6zK5aUuATuWz9CzY0LnEWpWPWX7vR+GQ8IFZXWvfjecmPamvU4+nqOXBoVeTxGbDmMbScVM7GuIHZL7C7y+1t3ftEqATol2lvXe6cy/jZE2wuaFSw3pIi7nhRsolgokjHX1LdHMId2h/cxIgAxdnCOdk4qbCHYRVQ0ju8MHaZWjd3gTustoDamVwiAHK1nPtFpDN69gTAJwfzU86CeEHYudbjRnhM4e9Ics7cHtZL+GKPkOcO/CbjURAaFWOuj9eYY/PMcw3fCxo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(41300700001)(2616005)(66476007)(4326008)(36756003)(2906002)(6486002)(8676002)(38100700002)(186003)(31686004)(53546011)(6512007)(6506007)(8936002)(4744005)(26005)(86362001)(66946007)(66556008)(5660300002)(31696002)(478600001)(7416002)(54906003)(316002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHh2Z2RnZ0Njdnk0UnFqVWRFQlpjMUF0aiswVE1tVDBHUkI5cU9OeUVNQ2U3?=
 =?utf-8?B?MDRvcUdwV0QyVEE5MmZZTHQ1MGw4Q09STjkxZVZGcXNKT0NLdmxaV0VsWnBN?=
 =?utf-8?B?VHFlNlp3UnZScUUyLzMwM0NaLytjbWl4aEhSenlTUlpEeVRYN3hQZ1BoNFpT?=
 =?utf-8?B?THZjN0VxbFFqY2pDdTJUbEVybnVtSSs0bWFid01DQ3cwbHhCVHlSNWFTS3ds?=
 =?utf-8?B?R1ViYm8rM3RoTnFwaGowakJUbWN1dmQrdWE1Y3NjcW5UTUd2VnZBYXNKVVpl?=
 =?utf-8?B?U1NXVjVOdmNwQVJRY3BRSkpzS01Oc01PUWRZaVE5bTNEU2hVTjFnQnE2VElp?=
 =?utf-8?B?UE05K0RKQUk2QkFFbWpBN0NMWE5JditLTjRja1hZTkkySVBidkFsRWpWaDh5?=
 =?utf-8?B?U2pvOWFMdzhCK2xmMkdFQW43N3Y4TTRab1lKOUpBNlV4N3A0MmhpMkxOelNJ?=
 =?utf-8?B?Y29QekFuZmVPY2Z3K0s1SUlJZ2QySGJ0VEQreXJsTmFtVXJycXRaWTJ6UzRD?=
 =?utf-8?B?bU1uNlhJeFpCcFlNMHlhZ3hPYWRvRGlLdXFZTm5HQndXMU4vMEhpZHhRWG0z?=
 =?utf-8?B?WEErRHd5M3pxeDFDUHBpVzVZTUgydDloMk5iajUzWXhGUlBQcitEOXVLTG1t?=
 =?utf-8?B?UVhmVERtL2s4N0J6M3pRYWdjRUNXZisrZ2dmUzRNdWhJbzlCY1hMMUQ2d0hX?=
 =?utf-8?B?NVFnQ1gyRWYwVHVFaGdMemJQU0tGd1VUeFpKcEtKZ2lINmdqUnlkcnlEOTFj?=
 =?utf-8?B?VGFrUE5RU1pabHp4czNhcHpZc1A4WDhTTVNyNTFuYVorWUt5dnFGeEY2ZzFi?=
 =?utf-8?B?SFkxeURNSHYvdEZRM2hGUlNkQU9va2F4a3lKWGJQdWFpWThWd01wWDNaYWRr?=
 =?utf-8?B?MGR3WDlzT29ZaE9ZOXdWR0NIaDhaT0NvYmY4Z0hBOWt3eFFOa1FTeGk3dWtZ?=
 =?utf-8?B?TU9IZVpReVNiSzBtS2N0b0VxdWNhYUd2NW9nSjRqUU1RZGt3YXk4SWdLY0pn?=
 =?utf-8?B?bDFMTXQ0cWVuR2x0L0xGOUtzaHY3clJBb01yRy9Bbm5TU0hhSzU3N3RIQ0Vk?=
 =?utf-8?B?R3M5Q0Y3MlExOWd4YndKaElUQi9uWVZ1SndjbzRGUVhIaDRzNmRjMXJKb2Nl?=
 =?utf-8?B?VitRSTlza05Mb1RZS0U0Zk1SVkJPMFRZbnpDUGlDY2cyMmJFQVdqZVJ0RDZP?=
 =?utf-8?B?NzRNbGd2a0Z0b0NFcngwM3VaekMxMUc2QVZtaERkNzhtczJZeUdidlEvMzBm?=
 =?utf-8?B?Z2IvZ0pNMlBIbVFaemp0bEcyclF3dTg1VlZ4NzQ4MUFlRTN5SFEyWEwra0dC?=
 =?utf-8?B?TzZyb3JxZVhpOFkrS0hSZldRK3J4bk1XWmRlaHl6WDdSU0pHbXR3STJzOG5V?=
 =?utf-8?B?YjcxWlRpWlYvS20reG5zU1VaV0xYSFhZdUdEejZpamVZMkxGY3JTdGc1L3Jn?=
 =?utf-8?B?WjFRZWFsc1FhUlZDZTkyRm5HbGswaUc3ZElCTHZ1NG02Rk50NnJ2N1g1NkIv?=
 =?utf-8?B?YXV0bWlvTDMxckZYeHhhNGRma2ZvRXg4d2Y3VzZEejc5eGhhZ2h3YnpzY1dS?=
 =?utf-8?B?L0RhS3RrTTBTc0tZa2R4MFlZSUxiQndSQ0t3NU1uMmZucFRZV1VCQnprQUo2?=
 =?utf-8?B?dm9XOHFwZ2RldFVKN09NMW0ra2hoK0xBUkNMWm1nWVpKd1ZTRkhQV0RuNDFi?=
 =?utf-8?B?ZjZNZWJZKzF0dmtpa2RLL3JmTnpCSW9IOTI5K1BpaVhpTUlpS2JrRDBsS3Uz?=
 =?utf-8?B?SlZqVmZLWW1aOWRrbEZXamNhMXFXbGl2dDdyZk5wZHBUa3FqaGpPRzExb1dW?=
 =?utf-8?B?QkV3bm91Y2xsTzhIOVZqcFdQdEtQbHZYdXM1OWVmS2w1dTMydkFkS0pveEVr?=
 =?utf-8?B?VU1zUmt4MmpiZ1ozOU1UT3B5MklQaG9kdGtla1lBL1BXdlJKOFZOblRhbDdJ?=
 =?utf-8?B?UEp0bzEzRXo2TURmMTVVdmw5VUM2UHprY1ljRG5QMFduZkVGejB4Z0NvNlZZ?=
 =?utf-8?B?L0tvQ3VUSGdRQWNRbG5oalBlNmtYU0R5U3ZUZUpPZld5dVRoZWdNVzRmbklR?=
 =?utf-8?B?UENCQURGTTVFa1cvZmJIaDVvUHRxOUpiRVR0RFkzSVJhZjFpczI3RkE4LytX?=
 =?utf-8?Q?GomH2GuK+6rgeEVOYxsL3ZGGw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea10d29a-c539-43de-f89a-08da5acb0031
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 19:01:55.6043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: krVu5kwn0wlnZ7DSC+7RBtGnQ+ij7kaTfGxAPzgGyiM3mSVYkAbpbo9d7L0RuxQdYNJpNKIiQrM40bMHf0QBYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5088
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 06:49, Peter Xu wrote:
> Looks good to me, I'd tune a bit to make it less ambiguous on a few places:
> 
> 		/*
> 		 * FAULT_FLAG_INTERRUPTIBLE is opt-in. GUP callers must set
> 		 * FOLL_INTERRUPTIBLE to enable FAULT_FLAG_INTERRUPTIBLE.
> 		 * That's because some callers may not be prepared to
> 		 * handle early exits caused by non-fatal signals.
> 		 */
> 
> Would that be okay to you?
> 

Yes, looks good. With that change, please feel free to add:

Reviewed-by: John Hubbard <jhubbard@nvidia.com>



thanks,
-- 
John Hubbard
NVIDIA
