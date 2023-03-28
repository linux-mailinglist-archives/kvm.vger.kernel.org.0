Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50916CC7F4
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232694AbjC1QaE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjC1Q3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:29:30 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971BDCDEB;
        Tue, 28 Mar 2023 09:29:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZOx9Dc4B/7k3QvyPOhc01RcO7uDuagwjDf/5N51OSt3LGseYMytX78Yn18qROi5IXoUtOWaa4E0pdr2tpZbZxT8JJDheTW0ZGwpIIVvP6yqoMX1YqzPtZItcf/oppmf/wNbHMNMjM5R2mwPYR3CTbY9qGHTf8RsXDIDzInd4u8tAiz/w88BgjKvH+BaM+fmGse/yFDulN/mPoPsAxYMe0nqThJxGqnfzUXg8PRpo2V7gnQ+djU8C2iN08D7PBQCdhOAy5wjbG1glv+Mft4qnH1kbTNVFMxnn6+PrEDrk9mhFVnt2Dd4/LGREN8Bh21gr4Buip0oqrkTB1JM9XOUgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/x9Wl1RPLpHdB2R65mSzWhi6itZcz2YzOFYETOsPUOs=;
 b=PLyWgwWCByx3OXjOAiswQh7wZJyzKWTHNpWXXd4QKqvLfKpBBgGQfjgvZvaININU2YW2u/K5eRma7Z7WPNvs0YYL0pqXm5KESk95SxqQ005QsEr71hQ8PrsiTyqleoK4hCzOfeW/VYn7euXySLB8QhBvVYzuY+oaJQ8u87DtxeKu4uTDFKnivovZjNcyQ57F0fMnhPvHkA6aglHMCBWz2AvljpZqCP1R5tHzfn1kRhBRu7sybcaPl8RthH+br3vJfqqbEVFAkqooMYynG71pcbzTQrugwVc+QsWodj45aHl/rxIbsgX0b3PryCXryzYxdeyd4YZVV/8NBvXX/mLIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/x9Wl1RPLpHdB2R65mSzWhi6itZcz2YzOFYETOsPUOs=;
 b=dZ0BSua5zAsDDMdFoiGovC6GI1/kUs2vQyg13X+x+5kYgM19hgAQiRqNBqxYjtrqmXInfMAyHm5Way4oWyNxpWCRsn/wx4HuXAmbO/uqnqZmLNfGNaMJHoISivHtGC1vk/QICi5eeCxQ+E3U2fhcnlLsT85SNAs/exIkvOsZutIqMp4lceN5qBPx37fvowoZ5Co55uxOt4B4N7GPNISBBZeLq9gHQ6DodeiAYPLxPWCxHzHaccv9HBOGh6eeGn2KMA5ibgnUi+RUt1PM3XC+AHiR67R/dDzzdAt6+57fW3oopG8JD7nwofoda0eIofSkJOP5GigRPKHVbtakiYA3OA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB8475.namprd12.prod.outlook.com (2603:10b6:8:190::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 16:29:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 28 Mar 2023
 16:29:26 +0000
Date:   Tue, 28 Mar 2023 13:29:23 -0300
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
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCMV4zMhpVJJCIKN@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-11-yi.l.liu@intel.com>
 <20230327132619.5ab15440.alex.williamson@redhat.com>
 <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328091801.13de042a.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB8475:EE_
X-MS-Office365-Filtering-Correlation-Id: 148cfcd4-d18d-4e21-f8b7-08db2fa998b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eyiyV1Cl2gPJRjo5GwfZPNnilxEvUBaCBfa0ZNXCgeCoVTMnTuVkIFEfhqBBUKnsV5rCDxls+Ufwz96NVwD+7T06CpaIpEvTUtZrudexY0h04kruODCSVVNzmC1wqOVuuSAQ2RNqapNRFLF4QR116KLczxqbqWBa1j7sjVuuTUNliarviPDxinDmASmCKFv6n+BLKc29TtE/LZipnBjlN7kMro0xE4TzdVSf3/+4X1oDJ06BW2n9LEZ++yC3Gbj6czQoMBxXtqJXMJVwVw8N3VGXsWbGOtv/pG34kz/x1fgZOuc3yVZjGgZ/Ft26gzEdsnJvI7yUP/trRFZMSueDZmym1k2zPoogdKLXS/CmjPTHFtH7G/H2G7o0jgWrukCQ2tbZux+aa5LgrK0HkfTQ03gn9jc9IibOuTlRMLbuvP/vO3rbZtxdjgxAIwAOQRqY/8GUJBO5VSyTdWX4d0wqarj3RXhc7b7leLbKAFjHO2XwOgznrfqtDI/MNxYpv9T7yQougMoluUOWW1Hgc3xTYwhB0DwFrYOnBfK9Mob5NIeAuwksavYNRN2SzF4gURjv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(2906002)(7416002)(5660300002)(8936002)(41300700001)(66476007)(66556008)(66946007)(4326008)(6916009)(8676002)(54906003)(316002)(478600001)(36756003)(6666004)(26005)(186003)(6512007)(6506007)(2616005)(6486002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0lczhrOzb4P8dJSoui/aVxdbins207FWo4KMpm/0gpu9iw3asVhQ5VMZB+Lm?=
 =?us-ascii?Q?aFEd3iKiamJYxIHfEnu4GdCYoLUPzNJV1nmNaSXJDJDmzjr4u1/rFiFp8XVT?=
 =?us-ascii?Q?rQPyhoHW+XuqV+zJL1mYXcq0yT4HALZtdQ6L1MZwQ5avuYpgJ6ILOAlE+qL3?=
 =?us-ascii?Q?BHRHVwu6fPKTDe5k8EwK2eBPKrUGafKu89/xoZTeGrn1yk3S4B4tTAIdmUKz?=
 =?us-ascii?Q?XZpL0OAz+xxK4sUJ/pVApumOzIlyCL07gN+5gZXkBtGKCXLE+tOcOyFVqaGt?=
 =?us-ascii?Q?/HGQu9Dz5FtX4TvV3jvA78j+ZfJj4eQRgiE6eKpVRbvIgmv3KZkh2CJkWSRp?=
 =?us-ascii?Q?wvDVJU4oRSVnR0t9AsPftMXfvgXdHm8TMMGLG7NINC/YHBsm2KVBwt839hlq?=
 =?us-ascii?Q?Gi8ituz4CFdkLBM+LMSeKLw1yENO9Q0TlrihAHpha3G5I7WfNaOqG7ltQ9Sj?=
 =?us-ascii?Q?jDhsDavXNdkLFOZpln/AD/znIbAlZOjMrIU+zKSDSXMKsMOKoenCmr0Z2yex?=
 =?us-ascii?Q?xt3FscoxKikZ4/wRYkmEsaWkEDO+ZRyWWef27CqfH/jhtBQB0D3EIlDhSgmq?=
 =?us-ascii?Q?KV3TVLCi/6Ivcx6qpbJBYThme2GoZ7e4f+WVJhzOPPT93rgwnygBGhEH8iUO?=
 =?us-ascii?Q?h5jSX6QbOySjrOoyQ2mVU45BEgVdT9pME8WBmdVKmEBok8+m3iZPx+VijFeT?=
 =?us-ascii?Q?ktdd3rtAXP2J1euPd8UB115GYit3QYT90Gyv0xZMjyXBQyULcChLKsnXHFTE?=
 =?us-ascii?Q?Fobc1vspsK/8kukKgAo1nbFWlie1LMGT1VYFSSmcTX8C1ExdrlecOQZefi16?=
 =?us-ascii?Q?2nldBpjAU2b/urPMvN6F4jdV7CDhjeuSxalqcvMVwlxqWCgBf9KNmVFg4Fsm?=
 =?us-ascii?Q?X1R+pPPKQ019f7atQMyf6am22SEaPKahoZOK0vgvi/5DgVz0hzjJnW3zmjIl?=
 =?us-ascii?Q?pHJEpewKdZKTpU0kM3EQMupFthfrrvnJSUV6WRsmOzkZlCp0jqjVn5/3Lys5?=
 =?us-ascii?Q?VhhQURt60VUmybXT2o4aGwBPCWf/hMmqgQcBhmScADWA23Slvg3l+zqDCpph?=
 =?us-ascii?Q?oeQAXGFuBc/iLKmGlUuuDDbqP9PO8C75k+YK2rEOYu7hijNNe+adXfL3cean?=
 =?us-ascii?Q?/2V/36/aNCxR6qMQU7hLuhzFwmffpkDi1N0xDzl6OqtVG94iihQ+Vqm0jv7P?=
 =?us-ascii?Q?mAhGxNrNkqTiEr12bOe9vJTCoA4PuJkgoK6+bQ0oxxIvDIcEWoi8wqzmycMp?=
 =?us-ascii?Q?YGhaCqWsq23MdZf73MiDINZICNeVC3xeId4UwkMZ7ht1xjjHEycvzfqc0bE8?=
 =?us-ascii?Q?ktBK/ixxPoKbsdyLylcjtW41o0iLI2n8jt7wIT8Q2cMynaDnQEl4zYkQN39e?=
 =?us-ascii?Q?CtzAD6ZLO+jgSFdMu/TK7INP9k3/H+CGA1GqjR0W/AxxWNdHy2yszOMN5DRS?=
 =?us-ascii?Q?ufNSnQIJ6p1cGkJm+gk+mOeT2pD9s/6J5NRCP0OFJJLXsGdE/YYcsrr7rbPk?=
 =?us-ascii?Q?S4vNUbLnR4akQGiC84FNvznluH7ttOtimGCPQ0E72azMCYtOqviOoDoe+PJj?=
 =?us-ascii?Q?Q6dCFXpAexBO8kz81L4GyyiWUIfBKpXc98oc5CvB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 148cfcd4-d18d-4e21-f8b7-08db2fa998b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 16:29:26.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJ1dAsvNkiv0oN8CP7DsY5LcJZW61uZ2uvGFwNcyMQ8SzoxwXlObXjdJ5wlLY3ub
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8475
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 09:18:01AM -0600, Alex Williamson wrote:

> It's a niche case, but I think it needs to be allowed.  We'd still
> report the bdf for those devices, but make use of the invalid/null
> dev-id.

IDK, it makes the whole implementation much more complicated. Instead
of just copying the current dev_set to the output and calling
vfio_pci_dev_set_resettable() we need to do something more complex..

Keeping the current ioctl as-is means this IOCTL can be used to do any
debugging by getting the actual BDF list.

It means we can make the a new ioctl simple and just return the dev_id
array without these edge complications. I don't think merging two
different ioctls is helping make things simple..

It seems like it does what qemu wants: call the new IOCTL, if it
fails, call the old IOCTL and print out the BDF list to help debug and
then exit.

On success use the data in the new ioctl to generate the machine
configuration to pass the reset grouping into the VM.

When reset actually comes in just trigger it.

Jason
