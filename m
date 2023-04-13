Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEC66E1029
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 16:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjDMOlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 10:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDMOlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 10:41:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF43C4C3C;
        Thu, 13 Apr 2023 07:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F83QjN+ml18A0Xw3KUNep10IfPyljuuLn50pwoC0w+aWrrApw0GZ1SMC4OaQCH96jMgvzgvKdAbjHPJnL54r3rz1VeDB33OoX/pT0McPxhqqnvEeFEF+hFEViwN8qyNC1BCeNsrcnxHI1luvZxmv03qaIiY5/svsxZxBomImHP/vFW1Wu15oOReK57WqWFLejpGAJOsfOlDW+VBd2TCMBgFk2liV8vhbCfCBSMEjOSclfAnIEJSfjKo6JU5HbojyNPIdx586Al1rxUhBq3PYM1eqaZ/LSd5TS1auy4FHLg7CGiLFpTY102WRsGV78out/lzU5W75bBqfB5VU6LQAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yas+VSEVEY4nXjIXrmiKT6e9u3dl/PH+kkISUUvRMmA=;
 b=LwFzfR9xlSLiM6Vqbf1NiRSr0YtC9R1T8xsit+IqYr+Gt9hxGRj5Qbdpjyg8RyCRawFzHGnAgNaghvpOw0zrERJRewazysn73kVhdVs+x64fSGhd2LrBq0DJKUX8VtLbs9EXppEXkJLI4npS42jJin8JbDI50qnULz25x8O1+WCrz1tB/GFn8kU7/HC0kfaDenCDFSNYchsYhQrHCkH2S6UIH84g/hesBVyb7vlpjDOJa9sJm1c54pzmVahzQ9Vo9sTcJHGd/JTeW94TeQaJwqVzCFb0CjWD9JPcUU0ym5wBj7wSEDEts4NL2+897OAosQ3txSx50ndizLibyGosCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yas+VSEVEY4nXjIXrmiKT6e9u3dl/PH+kkISUUvRMmA=;
 b=fyZQDm0Yy3ggKh1JSwLImdGQnZbHcPP9WHTQigXm3ppMfSS0TtCNPt7ZNxN/UdSn/GzdUu1ci149PwYrxi4JivSYy6JkLz6R34ht24zJvlSluNzL2bFeMxovMB21bLVu/vlzzF+TX0BHoJdZeYlE0TNeoynwtuijXUn+l/QvI5SQYPPi78lDclDaY2c+paBv7EzQYOe+RChMB298omZw/4LYGDanXJfmZoo7Ww9EFP6lIeUwxs1btubwBmnGv5KdGu1h0HhWdlN4XLssmpziR3n47SUoNITX6l8RZtXzHmZ6puYqjFR40i6SQamTB2IPH7httZGHMhAAy3BVgPPLbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Thu, 13 Apr
 2023 14:41:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 14:41:07 +0000
Date:   Thu, 13 Apr 2023 11:41:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDgUgVKtqoaXRIZr@nvidia.com>
References: <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
 <ZDcPTTPlni/Mi6p3@nvidia.com>
 <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZDfslVwqk6JtPpyD@nvidia.com>
 <DS0PR11MB7529AEB1CA7528C6FD51CBD6C3989@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529AEB1CA7528C6FD51CBD6C3989@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:a03:54::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 508667f9-6b90-4830-616b-08db3c2d1dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjptNaJ4inA5FuBicOb5A7/Zk4AktBZFmHl5Y8I0+KrUyWd4Dpd0gInHKItWYhxWYCupq08EZuU8c1CwNaP7StBtavvWhtBMD50HhhOoTBdPdkFKtr7SDNYcEBUlUBlahXVkdd3BxUFjHg9vvDVBgZfT0CUCU0tBFVzkhdvSNSTa3R24XfrwJGb4gBZRC9Irs8x5WxCX7HfF1UfAsTReDbSzrR4ApNRtd9gq3RZ8PLJRnJiwRmv3yzX/ERFpxEctKFWA4UNaAavcqkShOMpYxR9WnxfNTqRKDptlXfRxqKEpxfVl9DVEK2crSTsmSq0C+q6gf0RuvfC42E8P3qu5EyxRcxn1te32PVQoRnO8D3yex+zfXtB+1ranNJT/nhv3qVs4wXeJH4qrQXGmFZlP7M8GValHjJ13sNggasaBfJf7IR9BRFIg/wSpY9JV2i94nC6IWKHFFl8GUKR+P94caFAH4BmzNGWWkz7W+c6O5kw0ElxoK30sT9XyeF6Wten+2ORZbtbNZT+uqBNwld4iO4Is+ep6KgLwuvNdwKOSQuz4YEDfLnA6+2yOP9+SBbrZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(36756003)(41300700001)(66476007)(54906003)(66946007)(478600001)(8676002)(6486002)(4326008)(6916009)(66556008)(316002)(86362001)(2616005)(6506007)(6512007)(26005)(4744005)(7416002)(2906002)(5660300002)(8936002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Zwe2/RkgZA+I/+P3bELZ5JPTfQwvEXtLYxTTeIVEMFlF2fSwxmesXQ+dX80m?=
 =?us-ascii?Q?EYRP+c2Sch0vUVJkw5SdenlxrbwvlJQUbcmnkkKbubxgpl1N8/NzK8rBrWb8?=
 =?us-ascii?Q?lYd5Tq2nHfNefM35lKuQo5PuTFSkVBk4DL2vQiiJeubLjv7GxvibAndjx83S?=
 =?us-ascii?Q?UfuqyyBjY/BECrdrhFyp0cmTjc8qLz2b1MPRlohecX5P/em7t40ajdmiOJJB?=
 =?us-ascii?Q?YfkVP4OA9MOLr0k1md2Wx5QeckR1vqobpmikvvUeAzhSNIp+qY/DqijDhoWP?=
 =?us-ascii?Q?styaXxSYvqxHW9UEt4pyP4FnJgGtqUiN8Ae3EzRu/MIBwtyDv2koYkg1MWID?=
 =?us-ascii?Q?wKZtMPLm+yJ2/RBorL5RmAlHzmvqubr055vJWhjl6CDpPNqSkw29JhfV4Fre?=
 =?us-ascii?Q?wA9drwHRox1yOfYQfwp0aD3ds0PZKcluhPwLYAOhpKEHQUXQ4pRMApAVTXKO?=
 =?us-ascii?Q?fbPdJbigSXfwsiipvEMHlEF6MlLHNTVaSGGHFtBylJCcBGPMmSlVa1QCfeck?=
 =?us-ascii?Q?yFBiSt9fhCxuJF6WYNkrW346PSEr52ZfIIRr0MTja2pm+IEeomGtriAasLH/?=
 =?us-ascii?Q?bmHVkYPPoE0LbBq7LhaYRuZW4S1Z9BEn+W5Swvd2Jn88CAuwACXtnVeHdYjM?=
 =?us-ascii?Q?5NMOPOYlY9PrdUMQx9BGai5x1iIai7HDB06D/oeVhdXMjds7YJvyUpsP8djm?=
 =?us-ascii?Q?kemNsAVPwJk40fJJ8p1/8Uu6eioEUSkxD8k83GbRM0ekGwcQGoTaRBCFARui?=
 =?us-ascii?Q?5nxvXHp24apeHM6H6XtJnByjuMQjvgCVqtNMuycMtIiRwIg9mte5kEPYy1ua?=
 =?us-ascii?Q?hUoNxpFdDVlHH9V7/ehMIgjZ+i5dG9gIYQqOyP8qoT3HK4+mqRdpmj6Lcipd?=
 =?us-ascii?Q?dVih6meo6clB4jx4yKeSJQBAhys6+yLKfB2gdzXC24OjQ8Is9iqTEfOnivbl?=
 =?us-ascii?Q?bR50a9Xnf9/6FU0LIWY8iUJJL5+664RriMhhUyOm5uye/3atraw9YIPz6eRe?=
 =?us-ascii?Q?8JoxSE6Wx2vpf4aXMMwiRJRDCCmfQvFWpiF+plFTAfYhtdDHB5lYVF1gYSRx?=
 =?us-ascii?Q?LJ4LXjY7iY1T0Se1jR2nhJVgvqmKK0H3I/aAlaPd0Nt0y6bUj698+gZ9P9nF?=
 =?us-ascii?Q?pza1CdCPVPKyuxvoiRSjjM8T5qERwY8eVWBf6HoU/zE79FQddodeM2PqIpMh?=
 =?us-ascii?Q?M06xVVjxNnAMwaOOgSy38qL28ivmMBp08rcfyhpHsBSLU9mUomoYdee73o1b?=
 =?us-ascii?Q?tNK1/Bm5QNHHAdcoK0xe5N2zYn5Veg8ZHqziyMbWwtv/Bf1RhRBeNJJGZ19R?=
 =?us-ascii?Q?zMaSalbnN6hjMIHz3NRhNeu/NnvpS+8/zs4RiHNGManVlBVYXPpFQZ0YolVP?=
 =?us-ascii?Q?D8FMpyBmLRI4xAMxx87bLttquaq1RUTcERuIGLMiJHrZOgLV9WzNIgMDT6d9?=
 =?us-ascii?Q?jESJl3U1b2rWLusF2/SNpYrA+9I0xBK7YYmAya4XkTwY/BPYzcuvH5w3KWfz?=
 =?us-ascii?Q?uJCBCzuSsbEAkYXmssS213iDsA3pO/+bQAm2H6NQH68ZMZ/a1vvfxAwqUFpj?=
 =?us-ascii?Q?IEb4mmgeG8+NWAwpO1NtSBxGfHtbk160PRnlUBfk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508667f9-6b90-4830-616b-08db3c2d1dfb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 14:41:07.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1bZ8XT/ANAMKTW/1wuuMEmlJHVtSAqvTIKlWZlzC8OUCZ9/3H+8h0ELScDaptWL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 13, 2023 at 02:35:57PM +0000, Liu, Yi L wrote:

> Today, at least QEMU will not go to do hot-reset if _INFO fails. I think
> this check may need to be relaxed if want _INFO work when there is
> no VFIO_GROUP (also no fake iommu_group).

Current qemu does not work if there is no VFIO_GROUP, so it doesn't
matter.

In cdev mode qemu should work differently, we can make the kernel
return -1 for group_id and qemu can ignore group_id for the debug
print, or we can just make it fail.

Given qemu doesn't, and can't, support no-iommu this is pretty fringe
stuff.

Jason
