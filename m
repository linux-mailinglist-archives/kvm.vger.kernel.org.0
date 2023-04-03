Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6575A6D4D4C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 18:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjDCQMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 12:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjDCQMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 12:12:43 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D58BE6;
        Mon,  3 Apr 2023 09:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwouQLCCwWSt5I1aRNIigtAuqG6q1qumaJ+Vtyk//2+OXs02bRWKitVmdCdHKFJp2NlEVWbubvFBLjtw+5rDwm2w4roclcFKhCwsG0YtKddur97Ajou61c90pJS6Zw8xtDFJWX31Cj8GcpHv+b61tYUZ/mkkFvbTLb9BRLWFnrjYiHk8XshrV9F08VFINF5bVRHlyLRwk87rxfKvBnQxpDwkidGfHxjw0GjTUz8mgbqN+z+/CjibPpXYn93uddpUMtArfezfJmHd8MPtG6dGGZxmEvJ/kQ8Jh3DCxsr3Vl68b+xWbU2paY3Co1P6mV8p/JMrrr33pj5Z0nhL6i9k+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tMdHQu+68+AGzyqov7eWBPcUXZQGM/PD2j0MB5+OC+8=;
 b=Y6pjQpDN2mKsf1Q4oTX8UIps5xIg2SQN7rURwUVbRHs52SF3uf3V7WqJPr4FW0uNJAsA32gA1GjZw2rrYfAw0s1xQngyARWTXeU98xItDyEm1np/byjTePE3zVbKDlsE/FyiZSD86Y3CnzjYH8wq6cG5pJ6Y72lmaeYP35AtEi+he7z7mlecc7L3YxfryhGh0DIFAwlULA6qe0pVphfjCdXFGKnzH1JqPisOu5BBj451FBfaZ1hQp8UkiU5T25iEnbAkR1UTeSLMe7fdR0YWq/LCiJk+XCQ1tr/HKGPclLnHklh5Dvjt1qfi+xjm/2+bFgGVjIOTpiQ8rXtpkxhMUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tMdHQu+68+AGzyqov7eWBPcUXZQGM/PD2j0MB5+OC+8=;
 b=uhwx/2+McmFDYvbM1PQm4JuU2BOaIIIE9da5n6IzjTy74TSiNoTFKXKiL4GiaQ3rBw2RJ5IFt3HcOlkPy8C047QBTGAS+6dqXjv/eZommxIwuX7pujCnOLNgTYdDdE2eucsMcoiSJZuU7fpfjbM1ygD6Wr1Vqj2LW7jxe9NkECnEITotJ/Q0Pat768PKarNNFOYX1oihetlb9s1QbkKgMh462gayCZRYOHvc73g/9JPoUHP5cijwlIhXQfX2u2AbHMBscN+OfOuJV54Uc0y1FfJ18T7SndaA3Jy3o4tcLBi8NxcmGmSJiEX/aDxDSeA+Qv3bdZ3VJUeVNt09kFcIsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 16:12:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 3 Apr 2023
 16:12:39 +0000
Date:   Mon, 3 Apr 2023 13:12:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZCr69WIdIW6Ai+L8@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-13-yi.l.liu@intel.com>
 <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230403090151.4cb2158c.alex.williamson@redhat.com>
 <DS0PR11MB7529A380EF7E3F33C5DCEE3EC3929@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230403093218.04e79d32.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403093218.04e79d32.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0030.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 65ead01d-4724-44da-bef1-08db345e3ede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFvbAjdpOs4aDz0aePpMej9OStseV7xWoEMaVx1aBWPHL5rHHJZqUgiTrGgeYXlzQmX3maU6plSZlZXjiBN6blx+PP7kcDoJnt22hNAFB8vfoGXiI9j56d1XOWUCzZOo217YLI8BuMvXnXNzuzWBEfQQgkahh9JQiAQgZxWR4LEn1UIUGRceUYScEXgzTg9p5kz+a+t8Rw+d2t7kiBxse/Z+zz+KtiZikoJSsBkC1eo0CNEaI3IYAs1XdPyMr2BgHi+2bKlApkWmi//t1jDPc6P5wfXzxxZASwctfpytyQMnEGBA0MQ+dfsdNuWGPgG34/LJ5fP+A+L14bqUNbwHSU5bebrxp0Uc0khz3JE4hyVIpbJDQzpv9t2dezup0tVfahu9CIihZVF3XH19PZ7z1eBXlmCiG241YlLmvAhGZS63PKuyvmM4OY2rA0XI7fNZoPFZdu4h0NGGAfgm2Qw2NEMGx9z2b0bxXmm/T5XNFVMvrFGyq2kCSnqBX1XJn5bsAH5xKYn1Me32/cEvldrX6abLG36W3Y9N+CdUhQYfBQiQooGuo4+VvSTnM/7rgKSwkv+ze/ITJtmZmsEyN3OU4HCdOa/1o8Hcsdf7aEbKc3IyKiEnN4t0QsnI+Pzp1pJ8SUPWsop5oQD+YoB5K6PVh7JdZS4nwU7m1QRLGQePnUDgmLjLu+HXo0HvNqgCIHU2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199021)(36756003)(86362001)(316002)(66556008)(66946007)(66476007)(41300700001)(966005)(6486002)(6916009)(4326008)(54906003)(7416002)(8676002)(4744005)(2906002)(8936002)(478600001)(5660300002)(38100700002)(186003)(6512007)(6506007)(26005)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVZTcE5JN2IxWjA2b1o1Y2dKczMxOWcxZ3VYaWlpZ1dwWmFxdG4ybjNWUWhW?=
 =?utf-8?B?UnZ0b25NRGJGeTJvRTUwVDFGeEQzcDRCRlVQUXZhc05ZRTNvaUlNaUhkbzFl?=
 =?utf-8?B?ZXh6QmtGV3ZwSllWemJnQ3hqRkdSZVE5RkFZR3V4bXc3UXpMUEd5YTBTQitQ?=
 =?utf-8?B?S3dkeWRJdmtydkQzeHNYSDFGY25kN25DN0dySXRxOGJJUmVOQnZOMHJoZ1Fw?=
 =?utf-8?B?Uit3dzBkVmJRSkNOSlpkOEdadjJrdkFCRHY4UGJ0NnJnU2JmMkNnRjl6UXcv?=
 =?utf-8?B?NG1rREFyTTdGMjUySkx5ME9UaGtWaFU2NWpid3l0Y09pN1JLbThMY0xqYWp3?=
 =?utf-8?B?cnBScDZTbFVWd0srUU5HNjlBZjRNc2JJWGFkOHBqL29WekNWNVJqVE9xVjY2?=
 =?utf-8?B?ZElYM21XamFUN1pXZldUMEdUYTJjOHVFS0ZCb1h3aHlvTEhaUGNSODIxV0kr?=
 =?utf-8?B?RXZVYW5PVHhudVR3TkQ4ZXVlWllnV0YydXlpVkJ4UEhMMWVHUGk3M3I3dWJB?=
 =?utf-8?B?cVU5Z0xZd1hUNVpNOXFLMGpGcFlwUEVjUytpd2JJa09kZkpqeGlwQjVwVU40?=
 =?utf-8?B?RmdzbitDOXljYThxMzBnT0tHWmxydnhHMWZ4WjB5RXBKYWx6ekRUdFNCb3pK?=
 =?utf-8?B?NXB5UnNscGIxQkI2RXVUWDVMUzZXdG01N3VpS20rWDZHYzNTd21vcU5JOGxt?=
 =?utf-8?B?RGVpUjA5eEIrVEFVa1ZFSW5aWkxSZU9KU2haNUsvS0xaNnVIMGJldUtSL3NF?=
 =?utf-8?B?ejgyd1dtdHYxK3YySCtpWE9nVDB2K2xpNmhMSTZEZEx3UCs0Z0I3N1h4VEpU?=
 =?utf-8?B?NVViTTB1bjVwODJ2Z3BOS2VaZVlkUjUrNkR4dmtuMktFRjdPclAwZk8reHUy?=
 =?utf-8?B?eWJsVHQ2R1lnL2NUTTlmNytyVzBUWWxlNWhMbWlDWTlwbFJ4S2FSbkI2Mktq?=
 =?utf-8?B?VkV3RGR4NURTTzRwY3N0c1RaWkpIK0lQdzZyeTE1eG1Jd2lZSFU5cVJucU4v?=
 =?utf-8?B?ZEVMWi9NMmgyZDYzeDROdjB5U3RjL1JNTUtDYlk4eGt0b3ZiU3hqV2EyZUor?=
 =?utf-8?B?Y1BOSnN3bGFEVHd4c1NaTm5qMTg2Q08zbW1lY2pmWnlCbjd1R3RFK05sdE96?=
 =?utf-8?B?OUNNWll6Y0IxVHVaUHl0NUV0WXAxUUZRd2Eyc2Y4LytEMWdqWjBMQWY2WEdX?=
 =?utf-8?B?WndxaHQwb2dSQ3Zpd3ZoMW9hY3V1bS9JVU9DVWVqTi9ZcUtVWGtPM0dQT1BJ?=
 =?utf-8?B?dkFtTXoyVVlNbllMMk51ZTB2VVoyRFRWQk9LbUUxL25RTTFudzJnOXZLTE8x?=
 =?utf-8?B?TExtYTd1Mi9uNzdEVjlJVklIaEFkcFNlOEZMVmU1RnlZUlF0VGtkSVMwMXMv?=
 =?utf-8?B?WHJNTmd5blRlWVlYZ2tFUXFhMmRHQUJMbTVTTWlGU05IcnovWm5qVEhZK3pZ?=
 =?utf-8?B?R2FPUHRUN2NFZjFEY3JycGlVOFpIUVV5a2xpSUZuZXJvNytmU2tUM0VoY3g4?=
 =?utf-8?B?YkhFSnYzRkJTWnk1RWh4SEhEdjRmSHA4Z25iZlAvYUhweVFEM04waGF5Q05y?=
 =?utf-8?B?aURneE0rQzVqQno3a1BQNmlXZUFsTlFlQU82YmZFREsvb0JuUWZPNDF2UVFD?=
 =?utf-8?B?RGVnb050Y2c2MmdycytlblZTUlVQd2FJaXBpR0xWNTk0bkE5MVpGd1dVZUhi?=
 =?utf-8?B?R051Z2pmWlBZUjc0MnZkNG1GWkp2eUYzTk4zcE54WE5XczVXQVNZNDBSTklh?=
 =?utf-8?B?RjAzc1hpck5pQ05qcWpldFJwZHAwcDFWdWxaWUUzQVRYK1VTZ3BteHkyM08y?=
 =?utf-8?B?TUJMVzdXSWhGSVd6cFVMcFJBK0U5T3RzZnNrdHlkOURva3QwYll4NnR4L2Vm?=
 =?utf-8?B?RndORlZQaEUvZGV0SUlYRi9RdXFaaWxPY0p0SS9VSEFyUjdYVHp2RUwxUDdu?=
 =?utf-8?B?MSszdWhJZjUvTm5Cd09HSzNNZHBmeEJ6NlJ0cTZ6TjlZSEp3M0FnYzVYVlRy?=
 =?utf-8?B?Q0FsRURXVkRCRjlYTVZZOFZ6NE5BMnlwRFlFd3pRVnNiVFp2SUZ6QVFGQlFI?=
 =?utf-8?B?UWZRMXdwTGxRUEdudHRxc1JwNW1jY0RwOG9HQ1p0VXMwcGR4TStCWTF3aGVO?=
 =?utf-8?Q?Fn1E=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ead01d-4724-44da-bef1-08db345e3ede
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:12:39.1912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E7mKoOEABkx8y5xi7lxuSFHA49n5/lN8hPTuYNXt7SZRkoISCvh72zfr6K3miN4S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 09:32:18AM -0600, Alex Williamson wrote:
> > yes, this series is applied on [1]. I put the [1], this series and cdev series
> > in https://github.com/yiliu1765/iommufd/commits/vfio_device_cdev_v9.
> > 
> > Jason has taken [1] in the below branch. It is based on rc1. So I hesitated
> > to apply this series and cdev series on top of it. Maybe I should have done
> > it to make life easier. 😊
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next
> 
> Seems like it must be in the vfio_mdev_ops branch which has not been
> pushed aside from the merge back to for-next.  Jason?  Thanks,

Yeah, I didn't think we'd need it until we got to the cdev series, let
me do the steps..

Jason
