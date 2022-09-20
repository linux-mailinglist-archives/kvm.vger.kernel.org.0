Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719D75BEE11
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiITT4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiITT4r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:56:47 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33024E62C
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:56:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2dTgf6hNJMzJ7KyII4Q/z6mHlpDO+lUAzxL3xA01E+GzjsRAY7t0oXdcgtJrU4qM0+mN2pCVoPDZqsYNWxeBidPTiDC/rOZWdeOEXH3I7EhW8/COSTEY+uqnyxnw0QBHDWJ7ahjBmZbtEIMNzcBjVQcJTgYovI/hkflXzewWdBOlJhnmjAKOYV7M2tNdWw2F20CREq33sxyOOfatskDsbYu959gmM3NsLJOTUK6F+nBAQF8IGS2+hj9vM2yoI9ZIa5pe5tBSYVL34vEpWOv0tx6GAKCdsCkXJQo0ME/B5hdGx9W3rPjGSotqL5yvTl/xVKWUFZ7YgkNfrZCMss2QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/B+Y5CVTEcdani/Oe0ru2Ax5ln2lqiuQ6k4fKYwPYjw=;
 b=VTAiIQxKVQUJLuMxW8uWiREPKuTKzmd+jaPxRIoXZD2OTxxI2E0LM6brAU6VO2/zcAwWhOxkgE8lgZuKmJtpU2xazvajFpRmW+3y5rbT2VxGEPQJOA9uyw/STxrNKhOUfTZM7+1+RrfXFI0cD6klU2Nd3ACROJ0+TOgoqixiqy5YkAw1nycVvtEC01Wz7F3Qh3BcIJN6HWO8B2hUCfVs6Q0DAeMeoM4tF9ZpC9UISXgmybyL3ZQoI0PkKmqJ3N6CzBe8BhGqBHWo2gg2Do9QzkbEzJrN2+2vtgUNRTUABbd7CZ12HE2PF6g0dT0uTtuFQx7casDtZTpjzpHH49hfMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/B+Y5CVTEcdani/Oe0ru2Ax5ln2lqiuQ6k4fKYwPYjw=;
 b=GmhDyskOqgKHWeiDPwwGgKE2dCC7rWQK8LB+lDOyJxeWvlJ+BTDKFJXQluvLeK7uOCDgyDT13xXMnIfnma3Jt71YalwqPTlGbN8pVbqxN1XRZmcHJSpHUAMVVIIfZLZfJbrpgSvoiH20FlnBCUbH1x8QdYwI50SmJI4KA3yrUkFuGHT31hmriRPgVj2GlqscMumuk+cJuZGMXNaM6k0Wls4zFVaFOHRJ0YT1F8lJ8kflSlR7Z7JLvb82IvbYCF32jKQ7Mu7UGs+q3qIxLjJLFYQcwqFIy8srSHUVoAw/JzwrYUwhwxFFdiAegvg9IT5C7co+ULP1WC5w9cNsgrri9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4314.namprd12.prod.outlook.com (2603:10b6:5:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.14; Tue, 20 Sep
 2022 19:56:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 19:56:44 +0000
Date:   Tue, 20 Sep 2022 16:56:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
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
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <Yyoa+kAJi2+/YTYn@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
X-ClientProxiedBy: MN2PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:23a::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM6PR12MB4314:EE_
X-MS-Office365-Filtering-Correlation-Id: 279d35d8-329e-473e-7bdf-08da9b423e3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y9swpPEgTxknTCs0ulC4EU+1n0P8uqSd/4LfTvBCibggcw/YdipRnQfKl7K6u6s8A0mi60CnDu+foaAIqish/rf2X1lVdyKOtBXpDsLpWuAFsbXAAJgBF9xxYvCAwry5ViIZmMLGBks9oGA/RQVt+8t11DFmJbXlaFEyjHwpUhTnivQA7vE/ig0KZU02OjKXbCS74z2gN7tawC0Nb+soiZf0bPFBHUEAUTcEAQ/YWB/1OlVR5QyLCfwlMlFHVLfUzS/L+NcyErTd45xzz7rdaERfj/z9GuMBmiPSQ0uBvczKfWMD11C4ayxE4fteY3aBoYiGbaPrPUvlzjviTwz+PwsnMcIIqEmI4+e9Yqvofab+0wXVgd51jZ3Fl4Uh2xU4DsC50xuz4wGzIu6yc5jThB8+Xrzy0VoNZaVN7kEsFRbldnbaN8zd+vvhaRKfgHplCuV65riL0Ot18tyVyCqRxV/xg2UjscsQHbLJb3ufMIHr8sjr7yitP1YrX3QibP136OqaPUfTw4Zxu4z1yp5/ZlMnxPFaM7B1ndiQf1LclHHtFU/hJgZ4hfLzVvOJMvzVo7upHQmilH8Lg518hp0kLXEQryyn+41TLH22wurEfBdZstfVktR5xnvlhHQILHAvdGZIjMmxmYvavRlP2OOkaP4V86al127dTHBB6e3YmPF+3mMC9UGLoEfPUaNryP61TISoNQEVPnDxht1a/q17/Dd+eQ89DTPNIP/aqhS3m3nmlME0ctItYvzbqMtwOzrv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(478600001)(36756003)(41300700001)(6486002)(66946007)(86362001)(7416002)(5660300002)(8676002)(4326008)(66556008)(66476007)(8936002)(6916009)(2906002)(38100700002)(316002)(54906003)(186003)(2616005)(26005)(6512007)(83380400001)(6506007)(53546011)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bf2bN58rxJDEbmmLIGGhG9OUtoGeTgn4xCBgg6yBnnsbeG3PqPOa1yoQCGam?=
 =?us-ascii?Q?FiAOBKbjAifE+Srr3TkJ0CbrVxQKrtH5lHoKaE5HJfIEh6/w878Y9U2/vjAR?=
 =?us-ascii?Q?4QCXgYjnApLpv0eRmJGl85AZdQQqo4G7cPtis0JuHIiWtntO08Y0ee0/3TqO?=
 =?us-ascii?Q?MuUlMkIAddyV+kRiozDKPYVZkNCGsj35l6TFGgKP2JMPmr0FPnAEXv2WKfyC?=
 =?us-ascii?Q?xapSMtZcEhLQNYGU9GUmq+UuNrhkMM+RodspYVPA4zRqokK8tdDTCjMJVCi2?=
 =?us-ascii?Q?uIRMGmheO0RStvOx+BS903YhaN1qCAMKeGPirnCDWeVC0O7ScNROdDP7m2yx?=
 =?us-ascii?Q?eMqRgZdz/87W/zgZIIgr9LY5jwMgKTF6cMaox+IqPxX+7MT5DVK4aOapAfjz?=
 =?us-ascii?Q?aT0zIU3oYiUOTArqRsyBprL7/tKNRxR+8G44SwkSbQPyOiOHElsvJaP895L8?=
 =?us-ascii?Q?yGncNQRn9iMtrzCe6uyQT0urq+9/yJI6T3fMrS4UCDSaXtOjumByUxjHTMdu?=
 =?us-ascii?Q?nPveeL5ivOQjb+5Jp+ICJBS5CKGTpGdRN0800409l+rohtt44n/2DGJaJcOT?=
 =?us-ascii?Q?psZnH0qt3Tzmqfj3gOhoM0SYTRA4fuY31TN4SHdlPTiN6TpzPJ/+yapodfjy?=
 =?us-ascii?Q?Yj5ZqwJhzha6I4lL/56OX5Fh9bZJ0tkSTEDWRjeYzx/k4mBF5t3ftwJwnd2b?=
 =?us-ascii?Q?hQHbpikrsHbnGQ1o2y1oVp6/tpnSbK15ThRsKd/R3pMU7CeCxcTX90aQf7ht?=
 =?us-ascii?Q?DtjSlhxIOnleT2cQumKX85wLCAp9Nu9Aehee55gWU9rRVKzXybMYGIVK+IA5?=
 =?us-ascii?Q?yKwDfFLa0yHDX1iQeuo/OdxOeXWTAqF05AGIiPqe3cb2q1hQ4od2S9R0EilQ?=
 =?us-ascii?Q?9YCiXL9Ly+ZZWJh0VUDb/x7uV4GsJHQiQO0nEWVNiXefv9mGRcwxgeawFwc6?=
 =?us-ascii?Q?1OnrS5R0PuvmGMeZjV8dUPZsQzOBFVmCE+/Pd1yUopmNN9EjUnRhdloHTPU9?=
 =?us-ascii?Q?AtdqbleJhpvovaNxYOSYv/Deini59et6WwdgELcH8rMuLltPpWFP7gpv+dii?=
 =?us-ascii?Q?+zk3RfooX8IrsLclG0CSYWqHUruBcey8x5WZx+PIrgt3Bhm6BwS+eeXVo+HW?=
 =?us-ascii?Q?J0vv+GLXBxnaWXcp9sxWhXkURVI/zNkBKMDBIdjPA9S6Mq/X3ep1sfVaZ56n?=
 =?us-ascii?Q?jbZ9S3r/4fWJY9d1cuCq84rndEtH+TVJ0QAZcdVyyivQkCZdLV7o0w/OMo+W?=
 =?us-ascii?Q?RZcx7ChFwjqD7KZabCGToRo1aq8/0iCF7bNdFmv1dheHVvgMHT2JArdwbqAw?=
 =?us-ascii?Q?ecAV28XfmW7tip9ZX1zKYo/lZ7h6DyElshPmPOXgv5zu5nQWyWEh//p4cHtj?=
 =?us-ascii?Q?65No7WV7wBI3hD+CSZdQxNFCKFjwmZ9kB6dgBZPUkFnegrmiVQlNLynJmysD?=
 =?us-ascii?Q?yVnB/j8MzxVkJonsBOtHB28mjLcN2mE9NEZWDSunnKX3VtN9ZpcIu44svqfp?=
 =?us-ascii?Q?kGnEsOxkllw4dKM3pxUqZw/3sC3SHH0yj67We4VJZxrcwyVadKLiq24qPOyj?=
 =?us-ascii?Q?SMJfcgx900f8wkZ6I7XZjY21Tfp63BjakCX9dp14?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 279d35d8-329e-473e-7bdf-08da9b423e3c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 19:56:44.3287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxMIpuv0y6U4I3PnPfIKX0sKW0Tz4B7ErPEeiySVzjXj64zDCA15en20tvjCVxCj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4314
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 13, 2022 at 09:28:18AM +0200, Eric Auger wrote:
> Hi,
> 
> On 9/13/22 03:55, Tian, Kevin wrote:
> > We didn't close the open of how to get this merged in LPC due to the
> > audio issue. Then let's use mails.
> >
> > Overall there are three options on the table:
> >
> > 1) Require vfio-compat to be 100% compatible with vfio-type1
> >
> >    Probably not a good choice given the amount of work to fix the remaining
> >    gaps. And this will block support of new IOMMU features for a longer time.
> >
> > 2) Leave vfio-compat as what it is in this series
> >
> >    Treat it as a vehicle to validate the iommufd logic instead of immediately
> >    replacing vfio-type1. Functionally most vfio applications can work w/o
> >    change if putting aside the difference on locked mm accounting, p2p, etc.
> >
> >    Then work on new features and 100% vfio-type1 compat. in parallel.
> >
> > 3) Focus on iommufd native uAPI first
> >
> >    Require vfio_device cdev and adoption in Qemu. Only for new vfio app.
> >
> >    Then work on new features and vfio-compat in parallel.
> >
> > I'm fine with either 2) or 3). Per a quick chat with Alex he prefers to 3).
> 
> I am also inclined to pursue 3) as this was the initial Jason's guidance
> and pre-requisite to integrate new features. In the past we concluded
> vfio-compat would mostly be used for testing purpose. Our QEMU
> integration fully is based on device based API.

There are some poor chicken and egg problems here.

I had some assumptions:
 a - the vfio cdev model is going to be iommufd only
 b - any uAPI we add as we go along should be generally useful going
     forward
 c - we should try to minimize the 'minimally viable iommufd' series

The compat as it stands now (eg #2) is threading this needle. Since it
can exist without cdev it means (c) is made smaller, to two series.

Since we add something useful to some use cases, eg DPDK is deployable
that way, (b) is OK.

If we focus on a strict path with 3, and avoid adding non-useful code,
then we have to have two more (unwritten!) series beyond where we are
now - vfio group compartmentalization, and cdev integration, and the
initial (c) will increase.

3 also has us merging something that currently has no usable
userspace, which I also do dislike alot.

I still think the compat gaps are small. I've realized that
VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and since it
can deadlock the kernel I propose we purge it completely.

P2P is ongoing.

That really just leaves the accounting, and I'm still not convinced at
this must be a critical thing. Linus's latest remarks reported in lwn
at the maintainer summit on tracepoints/BPF as ABI seem to support
this. Let's see an actual deployed production configuration that would
be impacted, and we won't find that unless we move forward.

So, I still like 2 because it yields the smallest next step before we
can bring all the parallel work onto the list, and it makes testing
and converting non-qemu stuff easier even going forward.

Jason
