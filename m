Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4E54D32B
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiFOU6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349720AbiFOU6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:58:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCBECE13;
        Wed, 15 Jun 2022 13:58:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsS8aZCMsrYUA/O995Rv+0x8O1YBDIniBj9LSZ9MMGXzkeUcro72WfHc1+bwlsZhDV6CowZaMwATHX1ir/Xr5KTVM8vAls/liwdTPGC4ynGJ2JlWJ0DSP/CvBVIefcipdoQg6kN9c/KCp8BHByCzB1/z0td6XRKU+Aeh8GVvTbzaX/20WirqCFNfeU8cnYQ7sLl9Z09LJ/HYkgK81Da7yfFgXEpiiJaNLalewZfSMP/IdQuXbjcA28xsPktSbZKMK3NW/By93yF2sZTKCi9jaaz+RO/lcCeZ/SLEEdUHpFPMH+ioUwxi0Wd36qbNUO4krROQI5Zi8lscKxoulrdMOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yOKjiEmfwH2B9oJHMMbxEYS8J5nnGN09QQdXBjAcu9c=;
 b=SBeFjhtpA/jZc9orRA5l7yl9jLidNkG4FhRvhMNfrveyg1ilKUAIEFm0hvJPy3XhThJTq4ZYP6TXI+Tr7cod20uQmpnZF+WTTBi8ogSxeTzdl4ByWeJiyZwegOImvjR9FHyVLZju1qPWJ3PgLwI+5m3EsemNh2UV0nEQTwueDAfvdyiq8TLd9IoQ9DYCnPgeCrRmFmT7sX8zGGlhCzO6qpQAK0CDd9o/2FCguZr87m9M6CAYZCtHM+tIrv3CKgrhLSyGTEa/nA6aF22hytFQCdNoc2zRywzopxpGwMYqdtcWZySpe8mqPpcf1nnZ2BXee3xVIY0XCbM3i5vFTa7G+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOKjiEmfwH2B9oJHMMbxEYS8J5nnGN09QQdXBjAcu9c=;
 b=FdQ+D+ifLdtWW26NT/0f3+GHZda/jo3wVd21X13i+eS5WZ+mmZRGMqRss5z6RtUEOZKYkLM7x10cfgUtmvK+0y0b8c3cz0ayJqD0z+HxO6U+JpO9Etzl4hEWS2zY+y7GIFjJbohLKd3MpanSSdr8kHPmO+gy9LwVSnqv2vAGi74iGap7wm1xD1LMM/ceYraHghSqibGLvgFyoikEUvGsI9eef+9Kq+zHvCRQR6I7N7UjCuC90eCCCAMfuy3/UHtTB+X6yOyFOM6ORz9ejp+WZDGONdfxDYbTcGi+UEMNimxkkvG8nG0XsFm5jG4wumHKt3L254DjsK4jAJaGCihncA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by SN6PR12MB2687.namprd12.prod.outlook.com (2603:10b6:805:73::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Wed, 15 Jun
 2022 20:58:04 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:58:04 +0000
Message-ID: <e747730e-ffa0-4573-985f-a444e14040a6@nvidia.com>
Date:   Thu, 16 Jun 2022 02:27:51 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 01/10] vfio/ccw: Remove UUID from s390 debug log
Content-Language: en-US
To:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Michael Kawano <mkawano@linux.ibm.com>,
        Neo Jia <cjia@nvidia.com>, Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220615203318.3830778-1-farman@linux.ibm.com>
 <20220615203318.3830778-2-farman@linux.ibm.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220615203318.3830778-2-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0019.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::35) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8471659a-ed8a-4b0e-d8bf-08da4f11bda8
X-MS-TrafficTypeDiagnostic: SN6PR12MB2687:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB2687C2CDADF96E61C4C4C5A4DCAD9@SN6PR12MB2687.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /FM7JvczfUPPkWEPwQwTCfb/7pr2u1Oh2UxNrBDPJljGr7QrBWXk5wmYBaFMSdp/pTl5LzungYQPlAPcyz0phRO+YMSe2qpUvE2UyiET73LxL4MQvtgWUhiRxOrzENjxhoDaYUxS4er3VB3xmnG0FvXogaUQcLzarHx2UmGAQMhZlUN9gWxtVDNrwadOj5qhduULrBInblX3gsnCHvIr/f0F725f42OnRXvZH9WeyURhRjXlseIfhkhjENsYtUzOfecmZQrn2WxSSLNpBV23vMxHvKGCcMPbz8oDyFIb8TwUrzUSEl4Sp9OUVPaYLK3jPHZa/wMH+KrbL3/8ZrFJ/X0wixOrNJQdtx/Os6V0KVPhHwOfoOwZgl7kbFWC6FM50VUZxDI+RUfJwCiUUSwP/QrXu9yxMTFqVkpXqTgP0E8fPJ1j6OmC45+kCz36CneKjCCOEXJCBW1ykG46s6tJzLsX11pUuaJeheYiPkemJVeaeomrkJB31FvT7QSwtI6zu1Cbl+uLXKrANHL3QhHNW258AiBFAdvsIQEUcp+oOPMxsi48rYQ/rUYN9sgPHiVaplZBk5aqBDkGThFMsMU/ifXSa9+p0QXe/KDTtT5y5umjMY8JM6rKwusQrnlhB5gxkF0urXHVnASxjeJjjo1aYctcJpYZHlkyG4Sj1q1CVxVdXqp7h2nAkilTrZOQZ+hQFgCM9eUS430zPhHsIzU45qouWvLM6lfiuZUUNHsQWA8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(2906002)(8676002)(86362001)(31696002)(66556008)(55236004)(31686004)(53546011)(66946007)(316002)(6506007)(66476007)(110136005)(54906003)(38100700002)(6666004)(8936002)(2616005)(186003)(36756003)(83380400001)(508600001)(6512007)(26005)(6486002)(4326008)(107886003)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVNwRWxSeGZndGMxbm96YjY1YUhmS1NhZmF1VmZCVVZZVHlQdTFrQUVyVURU?=
 =?utf-8?B?VjFMVUdHSUlhRFFHdnZraTFrWnhRZGlHSW5LUnFBeTRZQmhaV2F1dXViUElU?=
 =?utf-8?B?eE1CdUNBZFk4SUdrcFNwU1BPV0FoUEJab2NpaDY5a25aUUNBc1BNYWw2OFUw?=
 =?utf-8?B?UmJSQTJ0QkEyN2tQS2lCeEE0aENiMW9QNC92RFlRUkJhNGx2a1VBUTJnSmli?=
 =?utf-8?B?MVp5L0gxLzRjOGZCQ1R1YVN1Q0N0OXJlcnk0bXp2OFVWb05yRVhtdklQYkZq?=
 =?utf-8?B?VjdMZDZiWjVaUWNPZHRNcEFjcEtLODNIbHhLTEVNS1VFcWJsaC9nOWxBYkNl?=
 =?utf-8?B?ZkwyK2ZqeHN5Q3lVcEVHUGFTTytEUnBoNWpIaU1VSEViUXZPQWlLM0JrZDE1?=
 =?utf-8?B?N0V0ZHphRG5BR0sxOUFVM09tZUVRZ1JidUFETkw4UUk5QVZ0OGR6cnhJREtr?=
 =?utf-8?B?QWhqUnM4Ty9Zb0paMzMyQklnSDdFdExYT0NZYjFGRWxKK05pbkUyMVIyR2Y1?=
 =?utf-8?B?ZGJPQkhaYmthZTBad01zZEpUVWs1WGVhb3ZaMmo1RWFKbWdxWGxuUDh0YjJQ?=
 =?utf-8?B?TnFRblFPV0NhVXBNWm9ZbUdLUDJlTjRDUUc3K2NML0NLdEdaRGhuTzNncWcw?=
 =?utf-8?B?Nmc1UlRuZThueDkrejQ2c1V2bXZZNGVjbytERys5OXZNT3Z2Yk51ZlA5bCtv?=
 =?utf-8?B?bjBtZ2xzcUN2MElyeFdmYWlHb0s3c0p6SWdKSnplOVQxMlBkdWx4Ykdjb09i?=
 =?utf-8?B?Y1pIL1JuOE5NaEF6dVpHc2ZoMnJFUkRESlFRUThoZ1lkYmJISjhFK1MzNHRO?=
 =?utf-8?B?SndVRWsxcGlLQ3p2WUU5dlNocHBaUVQ0THpkQ0tZK0hBKzlEMU53b28rVERn?=
 =?utf-8?B?VElEeUxBalk5bG95NFBCdmg5WkU5ZmpIWnZSYlBJcHdtdHI4bm5xTThsZTQ0?=
 =?utf-8?B?Tlk3NmY3UlRpQXdGeTllNks3dFEza3NmYUwwZjZRMnUyQlZZT2lFWW9peG9a?=
 =?utf-8?B?dkM4YjM3TjkybTZIOXJTdWYxQlNMYzJsSjNQcXczaFJyR0RVejNmSnBDalhT?=
 =?utf-8?B?TUFZeTBmbE5MdlI2MUdIaXZMVFpqNlMwYmk1c1ZCZ2xVUGdpdmVOYjUxQTBz?=
 =?utf-8?B?eTJjQzY2bWhKelVuUXZvUCtwOUd2bjRMWlJqNnVoWStpbzZPY3RzWjNydUdq?=
 =?utf-8?B?NjVNNW5SVlZlUXkrUHE3bktxOGVha1JjRW1EWDFyUllRc2NOUVI1Nmw1d1JU?=
 =?utf-8?B?TStzTkVYM1NCYzhNKzVqdERKd2NZcjhMOUoxTGxUbGxVZTFsNVVOQmNYOUlj?=
 =?utf-8?B?SnVIMEVlNGNjUXcxcFhPRVlWMlU2Mng2VWRzZ0Y4bWdFUzl0ZVhLR1FteTkx?=
 =?utf-8?B?elRVZUIrVnlRKy9EbmVjQ01rUytuZ3RtcEQvM3dVQ2pGYlN6Sy82OVU2Q1R0?=
 =?utf-8?B?MGF3V2ZmeUtYYjVtR2tmQS90RVUxSUF2cm84K2dJY0k0YTJKLzhvRXdXd2ln?=
 =?utf-8?B?RHFkN1p1aHNIT0dLYjFySEtwd3pZaHFwbUdaSVlKanM5NWhuUmZBb0tzaHVv?=
 =?utf-8?B?Sk5QREFWUndlNUlkRnBoSm1jVHMvUDBFQ1lML05NUnZzVHRPa2VSVjlNK0VB?=
 =?utf-8?B?azdFa0kzSTd6b280eGJ5bituYlYwMjM1UU1wUDlMUjRzL2g3cjhVZWJrTEE4?=
 =?utf-8?B?em9LeERTd2pqMGFWNDA2dWw4WkJvOXJsQmwvVXdXbDFYZk04ZkphQ1JUWEpz?=
 =?utf-8?B?eTZydTQwTWdDWStHcitlTE9YNk9BN2g4NWd1VzF2cGVKZDdKd1NPT0QrdkdU?=
 =?utf-8?B?bEJmT3FlV3VGUCsvUUl4Q0dMdVBHYVAvOFZSR2dZY3NKdTNDVVprVUtxSjU5?=
 =?utf-8?B?dFFoU2ZCMEFJTzVzajBqSFlCOGdyQytUTVN6MmNTODJwWlpSQi9yNGtneWhN?=
 =?utf-8?B?dlJlRVNSemRtcEVhQWlhdWR3bFBIYjU2K0M2WXIzdFliaHAzOG1jMFpQeW1P?=
 =?utf-8?B?SkFvZ3Z4Y2RreEtBeFVIS0pwRFlvMEp1cWZjNnBUSC9wSHBTZHRPOE5DbW9W?=
 =?utf-8?B?bzFZbnBHaHh2N3MvdEV4eWM4ZHF6RGQ3d1NKcnhZQWhPdlUzY2FxU0p6YTVM?=
 =?utf-8?B?cDBIZWhRRnF6TnpnZTIyQWJRbmtFeFMzdVBlYVNGeVR4YUtlUHVkc1VPOURW?=
 =?utf-8?B?SlNJL0trMXIxZFBwOFUrQjJGU1F5U3ZXZUR2UGNkOE1zdmg5RmhGYW9odWo0?=
 =?utf-8?B?Q1E0dVViTEE0VXpocHI1SnJqNE1ZbjZpaG9QaFNuY2tFSW9veEhUdTloTGdT?=
 =?utf-8?B?TDgvWUR6UjB5U3ZmeHdKUWU2Q0g3bm1zOWlHc3UwMUZ3VHJ3ZmgyVlFnT2oy?=
 =?utf-8?Q?oU/ujrfLvSn5HH6g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8471659a-ed8a-4b0e-d8bf-08da4f11bda8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:58:04.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cWZfcIlDoesJiEvmqoBPIgXBzeyM+NMrPg3XoOuzVDISqoRiaLXPtvhG+c3Ubr4j9ny1bwrEb3rlpg03ob1WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2687
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/16/2022 2:03 AM, Eric Farman wrote:
> From: Michael Kawano <mkawano@linux.ibm.com>
> 
> As vfio-ccw devices are created/destroyed, the uuid of the associated
> mdevs that are recorded in $S390DBF/vfio_ccw_msg/sprintf get lost.
> This is because a pointer to the UUID is stored instead of the UUID
> itself, and that memory may have been repurposed if/when the logs are
> examined. The result is usually garbage UUID data in the logs, though
> there is an outside chance of an oops happening here.
> 
> Simply remove the UUID from the traces, as the subchannel number will
> provide useful configuration information for problem determination,
> and is stored directly into the log instead of a pointer.
> 
> As we were the only consumer of mdev_uuid(), remove that too.
> 
> Cc: Kirti Wankhede <kwankhede@nvidia.com>
> Signed-off-by: Michael Kawano <mkawano@linux.ibm.com>
> Fixes: 60e05d1cf0875 ("vfio-ccw: add some logging")
> Fixes: b7701dfbf9832 ("vfio-ccw: Register a chp_event callback for vfio-ccw")
> [farman: reworded commit message, added Fixes: tags]
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

