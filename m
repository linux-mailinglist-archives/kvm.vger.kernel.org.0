Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8D05E7BDC
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 15:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbiIWNaL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 09:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiIWN3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 09:29:46 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B151DF21
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 06:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTj26Jp2kUDkOMHbOopKdi13/4GUuHVxve575NQ5WNPQt1vwL/jRJezSCUxVO8izkptpCcTqbhf4ikhisTin+Vb0oduZMbHnNvm2mHFjViXNJQNG1jUO/iQ3IUkXDYD+tz69WZupbXnDb4VKdPSxK/DxYUwuiQzCDP2sgtfrcTXuUVl7+cHJMourBRBrDvSKQfef92757GU506lurrkRJdZi4agPLSdNPVhLnyMQJBgQ1Ksgo2m93Zd0XgzYdMz8XIyMeZTLcTE7qPWylGfGobs4KzRb9sY1Dykl2v7acls5OWk77o0d2AQjgkg/cTiAkVcUiuEZzCpdBSWbDo+KbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s1nvjRPm181wna7LoWF4FVOMFmzD2V+4Yml4y/NV8fI=;
 b=NQpfcm8hsLGJsePeVkq4hR2SaFzG0eDfsZ//PdOsVLE8aMaxplvQwFxNwox9i2pqykHw8WnMHpIFz58Gewm2eYCSfq2Yp5PDnIbnYzy+J7oiiAJLcRusS3tJ+MAjPrPhp0rZ6OfRLWMhhYoRPjUW761Q8QfyzpzfiyM1ifPNumpZMWi/fSZHjCfrj8/vp0CwdlZblm92GnCkvVaQwSwjSizlNkDecFLRIs5qH1qoXw7WqO2kACUUoWFSGYxpb54YbzQQ9iz1BLbjCn2s2PKbXKvttoZRcaXZyk7++Q9tguMitv7V353s6Yl411DVxsS8FzPSiKrdxlaaNk6JoJ18SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1nvjRPm181wna7LoWF4FVOMFmzD2V+4Yml4y/NV8fI=;
 b=MyvyeJfSa0Fy/qEJ8MG9IoCvnQ7qdZ+Y380EwBVopfXPtX7uUTYtwzXaUrC+Up5A2QSkPqLlj0pYbczXPak7VyNaVfhuoe7+M2l0eliNAnO+WQmUcWS5ocju/27wid638k0vfH+QUXBUJ2Cnl2cX5bp2jX/qtmviAcdoIY4kcznnzWnmMr+mw1vCsVrHEFHsFx2ciJh5W0c1qCzzCirP795yehZC2d97KXMocpOkhy3BcYKvr4CjNv+EnvhygGabzkKUbNB9FMEVWcuujNjggMw0Id28jqulg4JoUbjVTbb7tfi/w0xT1vfUlnf0aUPY6k+PYjcOHJ52VszeBjg5cw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN0PR12MB6127.namprd12.prod.outlook.com (2603:10b6:208:3c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 13:29:42 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 13:29:42 +0000
Date:   Fri, 23 Sep 2022 10:29:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yy20xURdYLzf0ikS@nvidia.com>
References: <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <YyxFEpAOC2V1SZwk@redhat.com>
 <YyxsV5SH85YcwKum@nvidia.com>
 <Yyx13kXCF4ovsxZg@redhat.com>
 <Yyx2ijVjKOkhcPQR@nvidia.com>
 <Yyx4cEU1n0l6sP7X@redhat.com>
 <Yyx/yDQ/nDVOTKSD@nvidia.com>
 <Yy10WIgQK3Q74nBm@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yy10WIgQK3Q74nBm@redhat.com>
X-ClientProxiedBy: MN2PR01CA0053.prod.exchangelabs.com (2603:10b6:208:23f::22)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|MN0PR12MB6127:EE_
X-MS-Office365-Filtering-Correlation-Id: e84ad9aa-5228-41a3-053f-08da9d67abf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuPsDrsBj0V0eh3FZOZn8X1tMDQ/3a/4+25GouKCIm5Tu2MeTs0AmVUahnSdP1v4OW+LBMMWYu1b6R4dmZZjf0xT3rHX3SThlXAsoxRiop4u4Js/yyCZl3nYy0KcSxutm1NYGCr6WkZS2t8uw8fbW0Lp3b9MFQzkBu/XQu+sFoFhrk0KI5H4Mh17Rr8f5TXHLGhk656xrO1qahHMhOtXSbGjqhMoMhhh1+RQ4go4dnwVORSYbUQnvq/VuDEOheTFHh05PFyoAhE4A9njAC2uq3DcAx05Hoy2C0qzudJMkqf+ic+sbVB0TyQRyY7Ji91RyPDhA1gGpcfzq798izmRRHDj5AjhTYYwmBwyPQAU3+GJEADa695KpjHBiDz/cDAG3lfqNIJAamW+/pe/O3kB5vFExbttWLRHl/SuDDAUB1sfqJYbdLzcHBdmKSrxU5BhsW2abtD1zoFrctDD6PyAjDkbpvL80RCPPJR7xWiNPpD0Aj/aDzFqu2L9X775XUMiXeXkeXJizRfC3jGCIvd798Tfc0uJGhpUW9cIPqtsfB3WzjHi3rwUaJAPtX/kv8x0iqL40fNsBwb7O/7/WD8MZBfGo4zSgfjtuJ8jAmz+6HvF6R/Ax1XAW2NuoBLcy2YrlCpINeNZEapFi8wYHCUcoIR3M0V/ZTwZxx92KT39LgrfW1g2u4XNoxTQ+85CFveGTnYvwEMpgqRXTy9gIUQciO3pY6q2g4u5EwABiEWQsKKSJo9hAhIUqqo2ZyoeBFeN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199015)(7416002)(558084003)(6486002)(6916009)(36756003)(478600001)(316002)(41300700001)(86362001)(4326008)(6512007)(6506007)(8676002)(66946007)(66556008)(66476007)(54906003)(26005)(8936002)(38100700002)(5660300002)(186003)(2616005)(2906002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkUyM3RJSEZrT1FYR1kxN01xamtZVHdzZnFKNDE3ZFlCZktGSU1mVENtcFYx?=
 =?utf-8?B?THVvOUNkWURJT3VJYzRFeVA1TWY1dWV6VEdINWgzak96Nm5lUlZ4V0ZCR3Vq?=
 =?utf-8?B?dmVTbkpQcUJKTkZVZFFOaDhqelVwV05hdm1udlBYMXc0ZVVHU0c0b01rVCto?=
 =?utf-8?B?S3M5UStSRTVGVVphbWZXNG96WDQ5Sm85Y3phU0VQNGwyUllCQmR4S2Z2bnAw?=
 =?utf-8?B?Y2dqWU94S2NTeUd3RVpoZVZ5VWx6MEFzN2oycEFnU1FYQnR3WDNXTm4zYkhI?=
 =?utf-8?B?dmZmNjNMN2FBMXMyVlg3SHllZmF0ZS9sRlg1MmQ1bTc2VVViWktPb1NwYUsz?=
 =?utf-8?B?aXVGMHFBTGpKV2ZZV0dsdzJxZ3JXT0E4Zm13d1Zsb0ZTUWdkUXo2bG9yN3pm?=
 =?utf-8?B?UnBVU3JVc21uU1hwcWFHUXBZWTNiMk1aT0tEQ1lQbjNjRHBmU2p3SzlIN3VD?=
 =?utf-8?B?SHdCRmdnNmpEMzRQZ0N5M1ZISVJ3NktNdVl3TTdldHhEYTdXTjZqaGxaUnZF?=
 =?utf-8?B?aVRrcjh2SjVUVUpFZDNPbU5DSzJqRVJ3Q0xkNUxUa24wbW5OY242L0VJdjJ2?=
 =?utf-8?B?dWE5bXRBMmNKWkxqcGRGT3N5ZW9VZDgvVHUrNTh5K09IK3pHSUhONEJzZ3N1?=
 =?utf-8?B?dU14dm5qOGZtRXBiU2ZmU28rME1jMzZBd0lQdWlSYmtvWXprRGZ6QklCMUlw?=
 =?utf-8?B?a3AwTlVZMUNuNEpRYjhCR2U4RWw0SlFiTDh1Y1Znbk9rMUkwbjdSM3Q3eW4x?=
 =?utf-8?B?bkYvVndJM3h5RHJxbFRGdmRyd3kvQVVGaHZvTUFabnZ6UHZqakpDU3NZcWZu?=
 =?utf-8?B?N3pUUG9vQVhRS1poK0ZhWDBSUGswSk9QZ2lGNUQ5MTBCcXk1UjdmMWZSYnlQ?=
 =?utf-8?B?Q240Q2xJNGVETU9TbytjNCt0VlZybGFvcTdlUDFTWEUxZlBBbnlkMUVzMU5W?=
 =?utf-8?B?SGRQQlI4VlVWaWdGdllTSGlTK1BaY2pxRkxjSWl3T3BiSm5oLzl0clJNSjV0?=
 =?utf-8?B?Qy9XWEFrbGVaRVZrTjBwc1VVQ3FOUUdmQ1prTFhpc1hsRnRhR3RwZVdEaWRO?=
 =?utf-8?B?R2QyV3M5cW1rUSszb2lzbFhLczdKYWk2ZE0xeFgvQWVRSHkvdHdGN05vbVhI?=
 =?utf-8?B?NG5xbFlaZ0xrcTQ4SW41RnM4VUM5VDJKWXBwdHRZMU1aenRINGFqakJaZGhQ?=
 =?utf-8?B?T2hyVkM2TEhpNU56dHBlblJrNTJ1T212RnVMdXdLZG5jRHhkSnl2a29OZW9S?=
 =?utf-8?B?MElDZTlxRUJITDVFczNDMXhCUmhKSzcvSkhSdWlVRDNncWJaUHBlazUrY1Ez?=
 =?utf-8?B?OWJPZElXNU1mK1RtR21tQXFhdWtodERlREpKb1h4bkd6bW1lTmNNN2x0Z3Zu?=
 =?utf-8?B?ditMbU9NeTZhWExON2t5THRuK2NQckVuWXNPcUE1RjJ6aElBL0FzcVMvS1BD?=
 =?utf-8?B?Y2xxcE1qNm04akJ5QkZnYjlwMEN6MHRUbldhRTlJS1YyUWdvcGU2TWJRRHQ1?=
 =?utf-8?B?QjNoREZGV2ZoUWw4dlFQRi9aczVibllyUng1MVVTQVFoTXl5d1l2VTZhTWlx?=
 =?utf-8?B?eXZDazdGekVWdTBpVUtSZlRTK0FWZFhhblQ5dVRaOW5uVEdaTlRHQzdybWNR?=
 =?utf-8?B?RXVBM0tNRWRtTE5YWndrd2pGbnVMb0t2U0hCUTI4Z1J0b1NhWUFLT2l6K2pt?=
 =?utf-8?B?a2JDVnZxMWt5WUdwanY5YzE5cm1hbS93WjBra3JOMlorbjVSUDF3YjN3ZkJP?=
 =?utf-8?B?UGl5RGFqaXhPVVhHeUIzb2psaVlZTXpab0oveWVrbDk5NGNKL1dxbGpVd2F4?=
 =?utf-8?B?eFNVeDBjNldTcWRHK2w1dUpjTnJhMDFZaGpKdTdlSFpUV2pGU2NHdG85dHZJ?=
 =?utf-8?B?TmJBWE5jbHluUjdNaWkzVUZ5TmlrMCtmcE9FbTgyeU5iRG1DTDM5eXF5eStQ?=
 =?utf-8?B?MG5NVGdrQ2ZvczkxVWQ2NS9ENmtxTytsdjJzQUZtYlB1aFVPczM0SGVYZnhN?=
 =?utf-8?B?QXhIbS83OFU2aXFJWGRFYWoyYTFmYU5VQkJUdFlGdEVhVmhvM2tCaWlucnRu?=
 =?utf-8?B?Ry9tTWd4cmV2dmtOWGRnS0VHOHNmWis3WjdETlhMRmZtdkxtcUZndHNhNzRw?=
 =?utf-8?Q?sWfk4yJdNiTkNnZLZaXlo+ltL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84ad9aa-5228-41a3-053f-08da9d67abf7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 13:29:42.1300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZk+U6a458pulnQzek+a3wDGwa2IPo+ZM/CuBdvaWPp0hS2FtQn7y9pMfC56eAfw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6127
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 09:54:48AM +0100, Daniel P. Berrangé wrote:

> Yes, we use cgroups extensively already.

Ok, I will try to see about this

Can you also tell me if the selinux/seccomp will prevent qemu from
opening more than one /dev/vfio/vfio ? I suppose the answer is no?

Thanks,
Jason
