Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1D7558AC1
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiFWVae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 17:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiFWVad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 17:30:33 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235605251E;
        Thu, 23 Jun 2022 14:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjVE6jqEtN9/lhY2znDG/j/v6DAb/67Ld4y4pKIgUYkLma6HSmqNiWqIUOJD0SalVMW/BIp2zF68yQgFdpyN+r6K/fIMYX+xGzVcdQAN8mKKTJT3FOEmnOX8KQIx3Bynze7YXGb6GnUsYjlQOosg36M5JwDiMluZIOPfTmjxP2wjm5SvSuCeBI8oWZ9phd53P6nmx4cavlhOdd7alzta8W3pQ/IjVJGHpuFpS8ZiWHX1HJoYRCUW519OVkqCJsbGrt8URkMqKalAWCLAAFt/SdVLnIXn2IlmfefPuebN4sCSRBkZuUN0Qg0RUwIB2uNrnXd7zFgKpTsHc3IsMXyJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PxVUN1oKgbmnwDUwhrrFCnHEvQTbm8wvsRbRyylNFPo=;
 b=FKE3hFSa0RMO5qIZkhdsn0MWdmnaWotAUwAlKoJrLZlraTLZ1XKOaI+Mia0nJzKUVc+OCgP0JshS0oodxNuRQOrykiZ5wYhAzyk4xtgNebv7kPJppcIjRZuprsjrl7+MUXTPw7bX8u/ebmhnjDFjs8xyd+UMRelWXqk23q7TEORHCzngqmNo9CjGnDwu7EVdaJXGKULWBzXi66k3xrp36B4X6mrpxug3wyO+5gf+P0tArWfI/18X9BJkjPOsrxKk0wpvjLAUi6hBjkjii+zV5E0B8SJShaUKI8x6GAg5iDsELTlE2dqTd1a7AiAWaswC5KtCygU13Q5vrthuW+nb1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxVUN1oKgbmnwDUwhrrFCnHEvQTbm8wvsRbRyylNFPo=;
 b=ouiN31LkwDATeha/KyY2rSQFaHV0c98IUizeYNaFUecdrvFjM+UP3a7mUhcQN8X4cd/0HIBvJPPCNKcizmR78cGjMWMQY124MYqR3M2USakmOHacMo3H9Ws6Af2MUpZHHOW2baivHGRcZOP2DoroUMV40/Xyena89+6H/B4XN/DKLfgZv1jmpzSUr/QyL8DhRehwcIOI2hqzOv8Q1d8Fbdjk8XTXslFetr0HOHoNDISfpBsr/ODm2tcYULPL6pdRwflVB9zxJUEyJzCIfGET9c0Y8yj1MPdvMhEE7+mmjl6vQwcP2P6eNrHDdseo5phh+2xMubBLFzxQMNYrEWihPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN7PR12MB2802.namprd12.prod.outlook.com (2603:10b6:408:25::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 21:30:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Thu, 23 Jun 2022
 21:30:31 +0000
Date:   Thu, 23 Jun 2022 18:30:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org
Subject: Re: [PATCH 9/13] vfio/mdev: consolidate all the device_api sysfs
 into the core code
Message-ID: <20220623213030.GD38911@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-10-hch@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614045428.278494-10-hch@lst.de>
X-ClientProxiedBy: BL0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:91::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ceeddc6e-dd81-4b28-1ace-08da555f9961
X-MS-TrafficTypeDiagnostic: BN7PR12MB2802:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkSwdKN6Zzo0AWiX0yPiO7YXjR3lmt4a5n1U+hK75wpBE7yasTSJnmoxXX1ysOwjvKq6WLMYNEP7oTwj/HsgCpAUxB05l6ZSevSDyNrZDivGsi/w5N1JsGKO+BkFczbUJwoEcrcfFl/nTpR9Ah8lxnlJu8D/+3BBx6Y6PbnaK3XZOVSCMd0KWmi/tOadmS3CWZrBiAcCy1GPZoapNfG7lkYoj4JFOlwLDXwTasMoRb1FCY8NDMuB5rXLswqKutfZTRa4chH3ztHhrG9uC846FcE11xNdCXqkk1H/Yb48GPcSeCioRqMaSbZAQnb6r5XTCoUO3WMTjeuSJtfndEWICdRvNra/UD/elzJMcnTHYFleljQQqxsT8myhQCsvsgO+O6IxysH5iNwzVCOpR4dmeOLL7TWyAM8lY9OrzrhAr8ltWbhFpBGs8OUi2IwyICSKj3bOqi6z8acLG0zuO2+2Zn71aky5lTzW3iijoukb1leZ/lFVmfYcrQELIaKr2PrUksxWalDtDecgAm1shf7mx0gpbXM+r3GJ84v50U1MPoPJxPWX+/zwhwfwHEfccx2fichxbuy/SXMiPdcx1iWEcmgLgMXopxTQhRsxdHifl8oxFdCF25kOY3vP+Dl9hN+1mnm7RnyR5+TNjKXEg7yQwJBeYgorUiNWInPMfS7lo5NK7wUtg0Bwy/eEDkOphZ3wcFo9xgJ9Dd4WO/V2WF41ZYb8AF4JSPpbUUVu9C+cwXxcxml28u5xYWEpTThlPini
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(478600001)(26005)(1076003)(6512007)(5660300002)(2616005)(6486002)(41300700001)(86362001)(186003)(8936002)(4744005)(2906002)(7416002)(33656002)(38100700002)(8676002)(66556008)(316002)(4326008)(66476007)(66946007)(6916009)(6506007)(36756003)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nLOTki3457Yh292302uCuERdG0yyu/7trP4pjDVjOOSYCdaGwwLtHFr3RMSs?=
 =?us-ascii?Q?rjlrn6bOS4X4JiTY9VQWMidEz1gqDjuLjZohtizvSQo9NlQ5KxCFidCfs8x6?=
 =?us-ascii?Q?2mVRRy5/Zqc9UL38R1Z8RQfrsZr+xV9u/jPOjn1cBGGGk/ay40o7RK593oRD?=
 =?us-ascii?Q?fBtLH467CxbuOdjK9PYEkRGPGQEOanaWzSLQU5sIhchWZ5lCONbFlDWfxhfl?=
 =?us-ascii?Q?HfUYrZl2GLnVw1MR26uhBTgyBaxB/YNu/Z872StDgMiMP3mEg3d7rpz5gbnt?=
 =?us-ascii?Q?mXF+l6Yc9Zc7gm/TmoGfy3qThXcyHH2QDh7rZslqN1L+/fEE0RCy2qpP9qpT?=
 =?us-ascii?Q?riAbSU2nkOpvFlfdjQaCP0J5nW+t3bn676Xjee2tF0k2/cCcag2mJgWJHso3?=
 =?us-ascii?Q?mhcTyoQ9dUZTsvdCYrPM8DjTciARNL6TnnDo19SCTJV4M8HcGmRlMRyNDPnM?=
 =?us-ascii?Q?uWoUdJaTl25LO5PX6SYc3nlaNS1Hn1vfd7z02o5xgeDF60S5ju1FWo2J/ES3?=
 =?us-ascii?Q?xnikkujtcejhiBhWVBvWZmhsJ5VeAkSr4giwrVyFPf+ec0vd5c2cC0MFzfmR?=
 =?us-ascii?Q?ZMEFKY9BnH0oLtP9Us9qtZNHbZ3pQPlmqBEiNO6btginUcOghz7u3mifbAuw?=
 =?us-ascii?Q?TuKZ/52gg5lEg963EV/9342xGtxP4aiAAbOK2cVPt3CHTFp3FbJH1wv5yjUq?=
 =?us-ascii?Q?Yp3P3NXrqKg7RzcoTSgvDj0dj2U9CQpg7mnK4RItdXddW+t0C67Ygx83tOVA?=
 =?us-ascii?Q?UwQ9Ju9sDXyJhbNNhoEbKfd30cW/aaZDu5WereWtCh8SpBc4qI3TsHtgeewO?=
 =?us-ascii?Q?9i44/sA7HE8MGO/kvnIxyZZY/hpndWaygI9V02Tp536Xb2wH+sKQI+V7aHS3?=
 =?us-ascii?Q?hqJLROF/Dirwb+TlT/Uckr0PNm6DJfS0p1srYTQacqMNCtTnKTSfDrZhiXCm?=
 =?us-ascii?Q?4O2lF9WUhkMFyVC/xOdZa/sK+GUsn7/HxuEQfe+kos5J62XRcy2tWy5gwoui?=
 =?us-ascii?Q?obQPFkv3bVF/EsywIhScqGiDDdmhP+vI1SQ9ocvzJYsKzmagIZLGDhJWFD8R?=
 =?us-ascii?Q?Keu5vLh5Ya9NOlj9MISVwX5l+dDS58boj4QD9oYbKyLrOtI98iCmJWTUyKm6?=
 =?us-ascii?Q?yHTG750/HrMFIQ4J/n3IlZaUOoGD3CCBLfBUSBjFXcsd/8L+qlT5oMCeO2Aq?=
 =?us-ascii?Q?XW3Vxi/UgUs5mfkYcnWNYbEJUTqgLgQp3CeLU/YQbPnukGgs75qHhgMzgty2?=
 =?us-ascii?Q?1Qu00BPD03SipaSWKedkqJUe82Cggp/V2leVP3OpZRZ2EX2hDJ1MkmIXdz9a?=
 =?us-ascii?Q?57LFHWgxoEXiz/9wE7zxf0icNW7njgLgqg2BqP21evhivlYKrrI61ihGoQaG?=
 =?us-ascii?Q?HvMvOx4gYeY8W7dTIzuPT+pPkhuNZLd5/c1VMPd6Mr5bEJjV0mqOox1VLq5Q?=
 =?us-ascii?Q?l1JDNiuyDSQIAvhGK+nHpGwcz5jxRsN31WUuT50p0XswFthQBMDFI5P45rLE?=
 =?us-ascii?Q?xq/ek0Byudle1yLLd6mxatkt6NhS/QO2460Ptx4QoHBDeFd79PhM0DV2DQ+2?=
 =?us-ascii?Q?Nd6mt/bzK3WCWY3laxUWzuQdzpN6S5PuAfWGztbk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceeddc6e-dd81-4b28-1ace-08da555f9961
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 21:30:31.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SSt5RoeCouQiZ9ri9lNp+5ph5aQRzBZ0gElEZacD9uNqiUsw3Uz+MO3DIajVwJK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2802
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022 at 06:54:24AM +0200, Christoph Hellwig wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:
                                               ^^^^^^^^^^^^^^^^

Script error?

Jason
