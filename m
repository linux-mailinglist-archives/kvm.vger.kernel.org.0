Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A5E6DDC34
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjDKNeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 09:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjDKNef (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 09:34:35 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C843435BB;
        Tue, 11 Apr 2023 06:34:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFMZ7Kkcb2aCAuglextED0OFTuT3GcpYaAiEmvJORRp79zoCckr6exX1gPuL8v6XpktpDp2soOOA7LlWAZ50lSa55qTqDyw1T+Vh+HbsPEF8vYoQS5MuF4fJ0jzy1me88f+NCseRU8c2IYtn3OP0v+mXV6UCQnDa4z5rtyUdEhrRv9453A9ybbXhuru1vK1VpRdLoET2woir1dXPHQUnoBBWIsmOkHZzYVF1x0LV/W52e0n7MLkI8PZz6zM67ZZNjXfacBcVjyj8bE2sOeRR+LSyx/3jpFRv/YxYNbIG07Q8QfBEttz9rxtFQPtd5Ix1qV3eG1EodwQmznaiy7VWOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhh+mNLqMQpmz2XjPkPa5L/2G9iTLyBn9Xyh9A1BHVI=;
 b=WKnkAxLxCZoDZ90wxql8S43ysF4fJTuyJBdn96HqaYDd8Wzrec1Ht96FlWhQtBmTLlV6RLXFoLJPH7F/ANM/WkBG74NkNn9XPirlsRTSEBBD+X8Ty8Y76QWGR1AACYipmE1AkDuA9OtJ5rx90csi/O4Jg0B3ja8Q4tsIewcA1Er2q57Yg7e7Dh3ag0rz6ByOC1JAIjp4aQVxDk7NkB7RR4vVBQGj+k4dfuN5eLdumjfgn9hhVL+oEaTABoGjI0fhUKnLBf1S2l6i6mPmgcmtASgAREyeKBHG5mIExjmalfu8tGAwaUHqjhoft3LN01Btkx/BhFVMxaOn8C487tEr/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhh+mNLqMQpmz2XjPkPa5L/2G9iTLyBn9Xyh9A1BHVI=;
 b=HBFignIG3tUACz0unQPNkigDZ9O32MM4VknTC9KNEAfhLR/tdCnJUlDeqG1UOsirjlydspkaKNcA2VMIxSD1SCjvBMFq0YKhgYI0XLFP/1SKuVMJbp/hO+JJ6MzwlDqHzirKl9Rmt/bUE/NmbFblskoWN6tEbtPhiarO1XURsMHVzDYSULlrFu18tQssAJJM6hqxmqor5DbsbNakdxVaVMoWuG5nMTMUfTDIZ1n4/9/UgS0+WloR2gKen6i2mETMtITwzmkr4n4SEPG5vIrzwmpdnC4i5MksfdJY+4slDX4vRqdX4HbnjxZLt+Kw8uI4jPWJ4PphMIgS9R/mW+EbDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5268.namprd12.prod.outlook.com (2603:10b6:610:d3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 13:34:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 13:34:31 +0000
Date:   Tue, 11 Apr 2023 10:34:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <ZDVh5oktaZw6jI5F@nvidia.com>
References: <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407075155.3ad4c804.alex.williamson@redhat.com>
 <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407091401.1c847419.alex.williamson@redhat.com>
 <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230407150721.395eabc4.alex.williamson@redhat.com>
 <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
 <20230408082018.04dcd1e3.alex.williamson@redhat.com>
 <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
 <20230409072951.629af3a7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230409072951.629af3a7.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:208:23d::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: e2038e91-2ff7-45ed-363d-08db3a917b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qftsaAz9bQDXg49FFrVa3MD5hSpbYdj7O8JryXsvNlwgLkHFgK0/36796DOf8PMgDvIjYnyfIQOheABypv+6Kif80gdnpjJxSWVxQik9ZUykBDUBIJL1RWRg/dEP/Zb7VpRrd+nQPcBIyVWeFeDHSu8xE2Xvw8EochgCcVQwcDNdCaY5/w8t9aN0IyYEYhI3jTN2q2lXNeMBsRnNulaTKaUXBVVWp06V0oTkfZyX6l8OaPt+cLvQBr/ZNxIFhwnV/LtQPKRL/DEFmwgJuSDS8rks7kNXtwcv2SM53TQi1jhOzDECu+oDpHOnHnQnmTY5ExeeqyNj5/wsc4Z0dxGpjLYYgWzHQS5gUM5MzI7xBKN7R6YASX5nRl0IqL4AQOjiuL2qzI6hhB/TuLxM5BfaC24Y2mashBHqqcjw9tN10wpB8UWvFIJPFmV1jSjAMf6EkaFMqoX9/DZR2Okk3mjO7PeIkJ+LGGAaGcHHLVEbA4h4SVoJ9FjQUCVwq3eMls7pT70dPjb2UzlauCYYxrJh3BWmZpe03E1Q0Jf3X7B3aBGeoJwFjAgcFZzcZNguX9U0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199021)(36756003)(86362001)(41300700001)(316002)(478600001)(6486002)(4326008)(66556008)(66946007)(8676002)(6916009)(54906003)(66476007)(5660300002)(7416002)(2906002)(8936002)(4744005)(38100700002)(186003)(26005)(6512007)(6506007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pSHiTPdB4VGNVQtBVZmOjvYMHvl/Q2o15KAPeU8Gwu/Y2fHnEtZXCxa7btF1?=
 =?us-ascii?Q?LgENh5qyVHEE8WU/ogbtnGozL/iCQT1YmPuadwp6xMxxUsWxJ4xSxj8cF/2u?=
 =?us-ascii?Q?flzlkre9+8jk3ERReq60WRPsmGTqUUFS6Q26DPcLAdeW1r9jlYtElWkRFzQa?=
 =?us-ascii?Q?eXJvKfyyUQLz0PRkeRNO6EC7MYCmORoYtY/kZXSr45X/ZQdvKgll+l9cIFFh?=
 =?us-ascii?Q?tBuSsGYcxof8yF4q39yXrJ9hGVUD+8vgVVX2HRZENJtdu7YMww5QuK0Fej20?=
 =?us-ascii?Q?VXGvIeRiSiysd2o51GUJ/SOzZC8vdMgs7xuRDqUACi6AsvzTfViHrT103CN1?=
 =?us-ascii?Q?nm3VuPgQKup6taBLEqu1bKy6+RKjenRn5PgUy4kpzSkZphCckPJsM8TRMUdZ?=
 =?us-ascii?Q?MB+l5QbycBxMk5NmleWCjHaSK/06d+wStgt7MUpSB8j3W5p+jBr704/RHmCc?=
 =?us-ascii?Q?98aUMfuvSkcr2k1tXnZ87x2rJ4tHnyHRSBEQH0K3hoGd14bt+2Djmxk33nsv?=
 =?us-ascii?Q?V4G3AeuZoTbdkhpwKGOPEcua/2fra+dylBo881wgsntWu/ZAJJ0M91FEUFuI?=
 =?us-ascii?Q?7Z2nJM12YCm2Qzroi0gP2QMEoqr+timz/64s4uIcPX2xeTBGIue2R+0YbkTl?=
 =?us-ascii?Q?1lG2rnCqFIPXJBu+TAynwZa+Ak0aQtFJYkTp40VI3BD/89ROxEb5rir5OHeh?=
 =?us-ascii?Q?tSC6pv5mCdn4xZYidjD479Iyzp0o3fYvimoBFBD6uV98w3tGP8NIOSIrJVtA?=
 =?us-ascii?Q?KgW6A5CPFf/pjt/0h1401RyYbZHh1waaW/eN8qbDYyW2Ba3Ep1jI+/WEByg/?=
 =?us-ascii?Q?vPc9nl0W+RUbID4titrIHOOaaZ3Mif1reADwf7c7MUBPw8xD0N8k67ZUabHf?=
 =?us-ascii?Q?UJ6RhJkXdSIHaRa1i7UaWGm2IJ1VJx8ZzFpTVJy8NkLEWJpJYq29ltAusdXk?=
 =?us-ascii?Q?ajyPTr0nmq4taTzTDbwoQ7biqUyuqzQwSjIpTVG02mI9GLzhCI2fun8QiOTe?=
 =?us-ascii?Q?bpVR1v0tlK/bAgRD/DjvDN8IJ4IBGUMyY52R8HTTO7RIoVbUwB2L2YirZXuL?=
 =?us-ascii?Q?hOaF9bTNUBB3zvZNRZ5BbRfOyjyJ1NKgU1OkMjvbrRwebUDaCSq6j+xxr3fg?=
 =?us-ascii?Q?KkMZZPB1MFsbldJ/xiLtuHUlCfyySauCvYyRCR795lnGA5PKJJtip1seQOks?=
 =?us-ascii?Q?bo1AwlUC99F+KYOFqSvGwKrvrgSCRq+79KnAx7dhVDaKeVSxTxoWZjqpRofY?=
 =?us-ascii?Q?+u/jhAAB6Azal7bySRdUP9tqPQ7adXly3x+M7gDuKY3YvBnSzfV81exqK0yM?=
 =?us-ascii?Q?zbxcy+eW3p2fABkbYVfCoxE8EuIVGY3wm7SUY0Ispz6jUcTwadSnrrW6Yw3e?=
 =?us-ascii?Q?cR3JDFb6W1lKNdG9yUZAm2gVQ25VGTdPKF8ZHf7qT0IditNml1hnJh3YIJaT?=
 =?us-ascii?Q?ctnaZ+y8s2DtqO5rKzdQdl0U5F/p+Dpw4sOsWiz5bofCmSe+fNyBb5PpRtav?=
 =?us-ascii?Q?+1eIJ9JNO38pmsP0iaRFIqPY9+aezCHZm9gk5S8phEXu8lDBsP5xJAmqN+G8?=
 =?us-ascii?Q?19H0eJ3XczQ5Ai3/ru1rq71wumMNPdGS52U8JYq1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2038e91-2ff7-45ed-363d-08db3a917b23
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 13:34:31.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwSR9ynz8lv/p4Qy8G5cN4SXwER2QtlNIICtlQOlMWjbdliEnbL4G16GAxF+kcE/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5268
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 09, 2023 at 07:29:51AM -0600, Alex Williamson wrote:

> > struct vfio_device_info_cap_pci_bdf {
> >          struct vfio_info_cap_header header;
> >          __u32   group_id;
> >          __u16   segment;
> >          __u8    bus;
> >          __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
> > };
> > 
> 
> Group-id and bdf should be separate capabilities, all device should
> report a group-id capability and only PCI devices a bdf capability.

Group should be reported by iommufd using a generic ioctl, and not be
part of VFIO.

This should report BDF only and only work for PCI.

Jason
