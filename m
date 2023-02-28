Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA06A597E
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjB1Mw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1Mw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:52:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546FE59E0;
        Tue, 28 Feb 2023 04:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecag+espptCeKm8K6+b4PMz3eh3HT9ZsOoHTrw3v6qrEeC324e/GbnIp2j8e8NBpPlVA3eXRu63dqA663j8oYAx+wOyZAoslLRbCr9EMYuHU92Nvg72XdO6l+Y4CrgqrsvYoffvajTwXpngio7HhkdQEdcpAGlKqNiRq/GSQctZyPzXGDWiC5+zXk11+vrTFrgVJbStMYZ0KToWPenOH/lpgr0JLupja9OWRurANXwSvlMo8drFUw87fCxuq1zkpN5N8Yo696S89O3ekqjssazva9DeGvr/0TRHXW88Jk77FZNzE/GSWp1O7vIzv6iG/td1rbGLaS9oAVNTncTlh8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+by7ezZT5Rl6l6D6BMdGb/O8JaHy1a868piEBXCHvE=;
 b=Wuv8OsWJuCbOZWYCMtQLFWauuPfvtMG1wmNBUQtkyVo8ZVau/p9ARULzcqEt05Bz9bLOcS8zGOvv27O61+8e6AwpXif88JJtVvrr0TJP1pSyqJ46563KnyVxMJivjo1Ike6pvlJaGrdtNs69uWh1GyzSEjkZaXtftbTWnJ2GWiv+Vl9WhzNlLF04S6Dnw1oWJkyy8wsmyQ8ILMajCHYqIXr7sGHqvkKcRuGShyk5WN8GNhNuR+lBZgxManAFCyNl5s7yC2bxD6urKCpseNZkZE2nw6kAilOfHU6CW5PDSqBjVDJNds7qyNhg7g4Sll7Dz7xWqKW0w0Q0hUhBzf7esA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+by7ezZT5Rl6l6D6BMdGb/O8JaHy1a868piEBXCHvE=;
 b=goLFzcXwMOZXXcOB5piZZH7n9sBIBxXeBS4enJAA8iNk1UsztNeX8XwrOquzfj944SiOfqOyifx9AKj9XortezkyJgV2pEFQLF5q/lliRjnbedKUobFWhlwSOgrjXttyed1I4GKZCLkSf4Kq2E6dsDtre7Mg4wW+pIB4KruI+ZaQVcn/c/CnQS1f0RF/WmY/tWlF99YqUJ3UPCBl80hOZzxGtXqT4lXHgsi2TpBc9FtQN1Z33e/nMDyBiH519IAiQyEsChj5PtKKjvFw8F2Dj9YCTOhY7ez/onxbei2YcAzCzx0l51Pwv1LZQQsvIIav1BBspDgb2Lpt5ltXvfI03Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB5006.namprd12.prod.outlook.com (2603:10b6:5:1b8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 12:52:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Tue, 28 Feb 2023
 12:52:51 +0000
Date:   Tue, 28 Feb 2023 08:52:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Message-ID: <Y/35ItebTPdaXQdU@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com>
 <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/3zw/F0AN74CYs0@nvidia.com>
 <DS0PR11MB75296F3B01E872C5E13763BEC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB75296F3B01E872C5E13763BEC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB5006:EE_
X-MS-Office365-Filtering-Correlation-Id: 6550a9fb-3eaa-448f-8305-08db198ab3cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JWC3kUXC77ID+WrJDaIMVvghtr7rGYnfwyE7JARCNMvmAyeVDfucwJfBm66BQSIfD5RXkPyti2ko+88QoAydaTbeAkaU2bhy1Xni0GalbZGC17UKHhLdOZIi6IQblhV7fXIJfe/RIjnUIqlNkyPKHLrFU8nl3ufjT9Jw+wfahSeTkDmAXmskVcePd4K7DU+KTH95/ZA5sphuEjQmy+v+nB7r8O2GzcRisVF9ttIFIbl/zSfkCAHdAO3Dp0s3MR15afQuCpBVbKBCM/TvC800HdXjwuzLnJbOeEn90okvymnTnOCm3fsd2vXKMz/ttNIgmrttywRKa3wa0Nh7g1k1CD4dCvs2/Xssyd1Gz7b2zkGXJKAFcKMUXM31Bz1uVN6KWYiSkhsDVjVkyAaWoA8Mt9XnhcP74kbUuRA1PAOYUrmI1VNuR+crDVAUoLcCha33Pc9XNJbXn7YYwJlvE5lQHdPwZKBjRhrdRMjelP/QswEB4Tp+ehYoiI+tH90FNWZ/s/oQtjnvtPJpZ0bk99lLiXwA5P/NejvHUyU5YY7dnq6Bi9C5a4I+fdY3814y6Hn9fYZm8W626pcdO3LMiZ/jWgLBtDtbX6yvuscVDdQV4TSRQI90xTIsoQg7GSgWiSO5xREahsDcfD9iJhTJvc9PFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(36756003)(8676002)(4326008)(41300700001)(86362001)(66476007)(66946007)(66556008)(5660300002)(7416002)(6916009)(8936002)(2906002)(38100700002)(6486002)(478600001)(54906003)(316002)(83380400001)(26005)(2616005)(186003)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGFPdzhtcjVJTWpkWmQycUNCOU1LRitHNlBQdTR3OElUNXJ1NlU4UXpKZFUy?=
 =?utf-8?B?Mm5ldDd2eU1uQTN2ZG5hWDN6SUhJYXJmUk5KOFVJK2daeWkveE9uQXU1SEdp?=
 =?utf-8?B?WXh2NDV6VVFWcUxxQmFGOVRUNzJYYi9JZmRJVGZJenhvLzdCR2FBWGZHdVpk?=
 =?utf-8?B?UjFyYmFBellKUlkvTDNlVkp1eDVCaHhyYUt4OGFvV211NkIwTVJyUUhiSnZW?=
 =?utf-8?B?cEZ2N2xVTFg2dGRXK0cxSVJySHpoWk9qMHBRK3BsM2xaSGZSNVBtcEgwNGlV?=
 =?utf-8?B?cU1wU0QzdUtPMmczTHJ0K2hya01oWXd5Z0ZxZ3QrcjU4NU1rZndkM0NJWlN3?=
 =?utf-8?B?T2VTbXU0T0h0TUk5SFJ3U2laaC80QS9TSTVaUk1TMHVwSUhDVVJxdUhsaWhT?=
 =?utf-8?B?SnA3Z09UNXg1UDZhckUyeVZucEpYWUh4NXdwTWdrdFdvRnUvTGxDN3Arc2Rp?=
 =?utf-8?B?Z0hVZzdmUE9nb3BqZDAwRTZCUE8zVjBnekE2ZXlGaitzMnBmekRpd3hZRWJI?=
 =?utf-8?B?TkhaT05KM1FOSDFyVzFoZ3RBWHp4c0Fnb3lwbjRvVGhNYk9kaG5MeWFYQVJj?=
 =?utf-8?B?blhNaHl0bTRqSXdFV0tZd1dpdStvaW1jWkRNY0xLZ3VJRTdvQk12L3hXVWpD?=
 =?utf-8?B?ek0rek5kcEF5UEpmZWRSaktRc01MOUNEQytRQUh5ZGk0RCtLb29KZThQUEgr?=
 =?utf-8?B?N3Q1S3NFS3VFTEMvd2F4TXN6RnJYd0NZc3VuT1REeGp6dFpLcUkzS3VTZ3Fk?=
 =?utf-8?B?VHFqYzNQTGNVSk8xVmVBQkdnd0FNUmY3cHZUZFR5YXNuaWNvNlRMY25BR01U?=
 =?utf-8?B?Q01NUnI0dnd3Ri94dnQ4anUybG1jcmhOcmZCdWs5QUpYcFp5NGZpMTlZeWJX?=
 =?utf-8?B?SWtybVNBMG1lRDNkT24xQ0JrZlBXUU5NMnl3MDdTS2RzTWlQUXZXRnBlYXEy?=
 =?utf-8?B?VlpYZnRTTkhFYVRVcGU1dnhkRy94dnRkei9pc3MxYlc2eFRxMnlISEVpZ2lR?=
 =?utf-8?B?UUNmL0ZiK0h6SVplRnppL0RnRFBjbmlrbCtCRVZFTFE5ZjZ4cEIydnRIOFlq?=
 =?utf-8?B?WDJpcEY5L2oxT05NWnZ2QTB4WmNuNmdLYXlpRzROdTNtOCtDZHNyanRnaDdV?=
 =?utf-8?B?MUtnZEFFTE1xU2crd29ZV0ptenhiUzdCaUpWNkNvYUtZNEF4N2ZGaE1rZkJL?=
 =?utf-8?B?NWQzMWI5U1ZJdStaMER4M3cxWjdlOThRY0ZGZXdRZXNNaW5FaFZtUHJWT1Fp?=
 =?utf-8?B?SDk1QXpYZkRTZzQ0S1ZuN3FTWU9GemlDVXpXYUhVRUNXWkliNHlXSXY3am9y?=
 =?utf-8?B?YTdxcmp4Rkduek1wNVZ2SzF0dmsyckRXbGJvbkVmSFliSlRQcmEyeVJEbFFV?=
 =?utf-8?B?VVVLdTVCaFFETW9nNWFEWUsyOWFpN0RnUE9KZ0NsVGpVNkZaV0pUY21GTVQ2?=
 =?utf-8?B?SmhvaDRsSEtpcmtqYkp0VjQvM1dwZ0dHRlhXY1RMYnpKNEFtZGRTcUI2Vlky?=
 =?utf-8?B?ODNobTdiWVZBU3JpNWRsK1pXK0dYaGNuTi9BZjl2KzdmTThHN0R6WFpUS1Jq?=
 =?utf-8?B?c2hLYWFybld6NUNSdmZNUlppcUxhbHhSNW9oN0dHcWNQSW5FaENhK0JjMGdD?=
 =?utf-8?B?TGF0Y1lIMytyZk5kSHlnUDhJc3FpMFNmSVVxMkpCaTNtUUw1Wi9VUjNSQ0xE?=
 =?utf-8?B?YUZSdGN1RzNlc3pFRjRMREI5dEcvZ3pRYUZqeXpzd3BaSFZ3QitKcEZKQk9D?=
 =?utf-8?B?OXdKRklhc2NTdjRQaXh6TGl5UWFFdkRpN0dBQWdQR1QzRmIxWU93NytWTHQ5?=
 =?utf-8?B?MU1seTA5TDgyM0Mvb1N2UDd3U2xsNkFzb2pOVU83M2tUMjdva1lmLzRPdW1t?=
 =?utf-8?B?d1RyZlRKRDVYckVKdG1ha2RCVU03QnVibEQrWXJnNUFuVk1WMEdCTUdZajRW?=
 =?utf-8?B?ajBJNEF2NlA1enphQ2YzODYvWWRmbThTWHVTbHd0dnAwTVE4Z0lJZjhWRU5C?=
 =?utf-8?B?eGp3dS9PY1JTTGZUNGpZdDhPY0IydVFvaWU4Yzh3Y3FzclF2RkMxTWRiMmV2?=
 =?utf-8?B?aG1INEsraXJ2aHNzYUVSYWJiYVdRU3V6bFVoUHlOakVOdzMvTFBtbGczV0Z4?=
 =?utf-8?Q?yTOqZEY2sAGe9Nq28RX0zYQLv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6550a9fb-3eaa-448f-8305-08db198ab3cd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 12:52:51.8015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cEcX1EMuMNw/05kcCH/ySwa4UINI1tPLCHHOSste1LywnWTKZ0Pj+rGawV18W4B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5006
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 12:48:23PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, February 28, 2023 8:30 PM
> > 
> > On Tue, Feb 28, 2023 at 02:35:25AM +0000, Liu, Yi L wrote:
> > 
> > > > And the commit message is sort of out of sync with the patch, more like:
> > > >
> > > > vfio: Pass the pt_id as an argument to vfio_iommufd_bind()
> > > >
> > > > To support binding the cdev the pt_id must come from userspace
> > instead
> > > > of being forced to the compat_ioas_id.
> > > >
> > >
> > > Got it. not only pt_id, also dev_id. 😊
> > 
> > Maybe dev_id should be read back from the iommufd_device pointer in
> > the vfio_device. It is trivially stored in that memory already
> 
> Yes. this somehow gives me a doubt. Why iommufd_device_bind() returns
> both iommufd_device pointer and the id back as id is already stored in the
> iommufd_device. Is it?

Yes, it was done this way to avoid another API to get the ID, but
perhaps that is more conveient for vfio anyhow. We could get rid of
the id return pointer as well

Jason
