Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5491A5E5346
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIUSob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 14:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiIUSo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 14:44:28 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A2A89809
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 11:44:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1hE56dbZ9HgAYvt2Lrz130LYTITYpcV61vJaI6RhtIXdQvsQedz245MX2PjgnxIRxwfshMkDhfHtbNo7yiAtCPDicBxTQXZcrfCuaZNUn2dOFLiXTLUQurivTY984LfzawiLpJsaLpr0YTfTkBwE8ih3MnZVxvt3yjPtodJoLtkTAakr6oHf9gGheAI5BfMDfGvOKmEwM8koztPxsti90Wiq3doKTTKvPM9aA+Sz468d3n0+uO4w7W8uIScsZVAiSYI7PgG3kOUb+WKYSYr3Sr5/4qtYVjjna3pA59+2G/lCv2sSfhYi/wYksPjHLiHkIwK0gzALJNsgS9r89Tfbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7vaDLefKCIfBUbij2WD5rtc2YKhgm4k+GXD36zPG+M=;
 b=SAnlhdm0X+V0fKawrRkn5SYnshIVkIFtMJfYwX2QowRNOoSRuQ+nO99hEjWbaNxAfbOpi4fbzG9YS2vCUg2VLxPP/iJTkIqC3a/1ZprySe+rTHfoD9o/HXfLifEGyN/T570yLYMX1fjMONUTZ47yMoe7i+F0ORvBPVmjKlb9/k+39nN+ptxJDeaV9JYqbGyrly1IgioIajI5SXJZVt87AmgAga+Ch379LjHROLOOZtM0z7sapScQqyQZ2zoeKVoH6wphFJsRtJ0vxRpnCqDnrZb8DcYPsXCd/ipqVa035AwewpAEl0ehQvQMA0zwvgT9T9YPPTKHw8MG9g/SdlrtPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7vaDLefKCIfBUbij2WD5rtc2YKhgm4k+GXD36zPG+M=;
 b=BbIhLzqiNGSDK2dOybfkc8X5eb8WMp736A3YCrNMLWCDJpJwxl3P7yn8TkJSHy8nEQ00+uzLjb507RIuq8QavX7e8g+wlbnvndkYNiGAFPJSPPhUo9m/kPJnnuBjRs/cOU/eYJxTcClaiHCEckF474OxDY2W5NsLaTWFx2TJ0QLI94mJIbdaLt9GATRurfxd78HyoxfE3eDkx8nQ9+jYspuTGXnYT05MPw6oWnfMSFgkX6ByQM1mhVAwPX/qwqghrz1w936AGkhZgUzlFSG8DNMtMSi30OAVbFGNqP091Z4IFBxzGzL9G4EBBUOcHIjK3Dk+CIfbalugRxNkklI4vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5237.namprd12.prod.outlook.com (2603:10b6:208:30b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Wed, 21 Sep
 2022 18:44:25 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 18:44:25 +0000
Date:   Wed, 21 Sep 2022 15:44:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
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
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <YytbiCx3CxCnP6fr@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
 <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220921120649.5d2ff778.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:208:fc::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BL1PR12MB5237:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7e50ef-8cfd-4d79-8b0a-08da9c014e9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Lv8kHWtSQ8gtL/Mwa7UUv5F51XI3jo5a0yfrIE4AOVz4qBxrKL+4Rzgjc25+9tLTksTvvZFNzB6mXBhhxKIdSoCu8labWkRN30CVMC6NjJDvPEG4kcTlRRAuFWj1bxCU5Yz0cyJHQdMOltWaTJHqw67oT2f1QNQBs+SE6PGvfgQQhSHkWSQWszcZGgss1ZxPmJgVJTM3DAtlhni4FX0V8JnAe/s9DEx/5vbp7E2/hykblAV9PzV7mF/UCTsRIodI4dljvt4bkiLcCQXt48rtJXTKBUUE3KskhQcH6tcDHTNVMABc1LQ5H8LHMx2nspT9qb8Z3ak+2ycFc/gQUaZijZ5lCuFNs90lS8yRwiLvyGTqfqQ9tw0Wi2/sU77xItWIZdLe0ZwZ/U6eMFUwL0F7y1ghTbeQsbVfvrz5++bFiK5YtfxJoeclSCKzU68fE/X3ix7mSVyxO5O327i9kKho/qrvxzTR+SZ4uC1wHKqQ63l9mP+HNDhUG0nmoSb+kNCzJ66F09Qjktn5asn884dKB+nUJKGlawfT74EeKxHYshragWNd56FUqeMUEUAwnvvkTTiK6th8jzJW7GofPQGUK178Eox8yLuZG2VFShtshx3kpGExRvgsMIdTNHDebExW7LHTcFggSjVi8o3uiMoAADlO6ngWn7JrCSNJ/gFVim85j0/bSIeZQe6AAEwS3EHFNe8bHS+tuLXAV+Ad/1mR9lKH8rrz+wwHMlGkY1q8HgIgpRyZa9foL9bi0pgNa/v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(451199015)(5660300002)(8936002)(478600001)(6486002)(2906002)(6506007)(36756003)(83380400001)(86362001)(26005)(6512007)(38100700002)(41300700001)(7416002)(316002)(6916009)(54906003)(2616005)(186003)(66556008)(66476007)(8676002)(66946007)(4326008)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aecdpG2aD0kHOgjOP2SsV3Qxf/4NYeTGGIZoFKXYhQ1/3wUYqRg5qlR/v/4I?=
 =?us-ascii?Q?mJ7KK6QkuS57VlluqwrT0JA5DWQ6abOTNXcOLbmFd9x6S+i4Epaj0KX4EZOI?=
 =?us-ascii?Q?kuC7J/mtui8uZrC4tT3L9r+5SGPaW9MxOCafvKz63ByWNM7NB/y80qzluZIM?=
 =?us-ascii?Q?FyvlhO33zwr9Lbg07nKziVajXIxIUbdLuFsf9A9yX65HLVphrwZhU1n1bzR/?=
 =?us-ascii?Q?k0J5XF7iehuKPZZyRyW8vu3RLNoM2vx0+6tXjD94a0oehNbyAX4gef0W7Yxk?=
 =?us-ascii?Q?bZ3HlFKN2ACd11tb7lmQoennfgCpVL267+CllWDDCXt+rpyUbndfLsP3Fchv?=
 =?us-ascii?Q?EBdT1ehiPc7Ss1Rca0VAi6GlJujvCagwu8KZFZVGLnAxbysCb21U8LKYNLOU?=
 =?us-ascii?Q?1mtj5/suDs8O6DpeTABqsxL5Gyqt5uz4jhLBXduGdGm0HuuynnljBrhCN59G?=
 =?us-ascii?Q?Ek9K3pgQ6oQtIDzmmhpA+lPbLfPvdqkOappy8HnPGuZ4cmrNXWX7oB9cpgLD?=
 =?us-ascii?Q?OU1AWY89XUaMRQB64S1DW3utd4U0gJN7u7Wx2ckWGF8VrixklWSJ5DP0a5MT?=
 =?us-ascii?Q?MSkp0cDHsvIN5JC8UfKUxHzfFwRRCXtkkCa/vM+8nHcj1wigm6MP5AA+YQRM?=
 =?us-ascii?Q?Q0wng7wGkP5sZy4BNOJUE6iG8pKIrS9CY32bKfqRcx1QehwsJVAsb4mduKAw?=
 =?us-ascii?Q?qQ1YAETXUGr8ze3UCPvf/Yju38JEGORxBVCsk0L/RBJWCa7/kiTadrJ1yJ2W?=
 =?us-ascii?Q?P27I0j0wFszu1c+8mHsqPQ/X9mNhce0QwfhxbLoMLdfs+GwDW9Vza73a3adb?=
 =?us-ascii?Q?lfDqnWJ0K+qZX2dJzPAZAku2rcm48nhWe7+iOcDasWq6Gi89JfFAXD8AQd4C?=
 =?us-ascii?Q?RgLHMd74BocNVVCN8GJMhwF/kqWM/K1CCc63f5eC7W9ldwhQNveFIs/Opq9Q?=
 =?us-ascii?Q?KFCMesUp4YPzhsDZB5F4AbsXzFjnPyrRYYUzdru/P9e4M+u4Y4lHn53FERPv?=
 =?us-ascii?Q?PWkTcnxgK/R+jES1zcxXCsL0R3Y07jJ6/3H0ozHFwrWuRTUoDo2dErPC2sP5?=
 =?us-ascii?Q?VVSoqoZqHrBkV+YJUA7cl/oKMN31zX49LYCTGCgzdnkGaD0zn/m0MUbRTjip?=
 =?us-ascii?Q?8Og7qB8OZM3bBsYmfQSkt0IMMH8d9/MIwNAoqtwlzWprlzmRSf5phXf8foGP?=
 =?us-ascii?Q?QAN60VB1xNCqvCZjz0ImMBL98HVFGbKhKfExyNMlTqMHFZABv5zwbtNUMPUZ?=
 =?us-ascii?Q?0boMIYjM/aT37uojy6cXrF5QtG2N5GEZo9qsKbaixkKYl4t0SqavXXqOHKkY?=
 =?us-ascii?Q?zQ0KAs00dVR+lxNZTKtppgKzh8ULWF/Ty68gfi17CABylbAqvckv9Ztpg/XB?=
 =?us-ascii?Q?IeDFUgXnrVXpiRF4a7cvTcQj6QR0u6WGmPb68LKWgZoO2zI31JmgzyviTecv?=
 =?us-ascii?Q?WRqsWqVcbuoMtpD1FpBNyKShDPI3gE28E3LwcNWwGBy58AujXOiqbWkw358R?=
 =?us-ascii?Q?D0njFzz9RBGKYV9YNZ4ff4eA3OigEVxs6aPe5BL3DQ9U6JJ9wcrxDrVi77qp?=
 =?us-ascii?Q?n6zPdz+Tsia9WkjOW5IX/8QbGMlhbNcAM6jQ9BV7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7e50ef-8cfd-4d79-8b0a-08da9c014e9a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 18:44:25.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fnVL5Jnw/4KICZk2QoDunN3DGsQgpwKghx3/6U5dH42yFF/yFIUboKa3LX/0RcwN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 12:06:49PM -0600, Alex Williamson wrote:

> > I still think the compat gaps are small. I've realized that
> > VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and since it
> > can deadlock the kernel I propose we purge it completely.
> 
> Steve won't be happy to hear that, QEMU support exists but isn't yet
> merged.

If Steve wants to keep it then someone needs to fix the deadlock in
the vfio implementation before any userspace starts to appear. 

I can fix the deadlock in iommufd in a terrible expensive way, but
would rather we design a better interface if nobody is using it yet. I
advocate for passing the memfd to the kernel and use that as the page
provider, not a mm_struct.

> The issue is where we account these pinned pages, where accounting is
> necessary such that a user cannot lock an arbitrary number of pages
> into RAM to generate a DoS attack.  

It is worth pointing out that preventing a DOS attack doesn't actually
work because a *task* limit is trivially bypassed by just spawning
more tasks. So, as a security feature, this is already very
questionable.

What we've done here is make the security feature work to actually
prevent DOS attacks, which then gives you this problem:

> This obviously has implications.  AFAICT, any management tool that
> doesn't instantiate assigned device VMs under separate users are
> essentially untenable.

Because now that the security feature works properly it detects the
DOS created by spawning multiple tasks :(

Somehow I was under the impression there was not user sharing in the
common cases, but I guess I don't know that for sure.

> > So, I still like 2 because it yields the smallest next step before we
> > can bring all the parallel work onto the list, and it makes testing
> > and converting non-qemu stuff easier even going forward.
> 
> If a vfio compatible interface isn't transparently compatible, then I
> have a hard time understanding its value.  Please correct my above
> description and implications, but I suspect these are not just
> theoretical ABI compat issues.  Thanks,

Because it is just fine for everything that doesn't use the ulimit
feature, which is still a lot of use cases!

Remember, at this point we are not replacing /dev/vfio/vfio, this is
just providing the general compat in a form that has to be opted
into. I think if you open the /dev/iommu device node then you should
get secured accounting.

If /dev/vfio/vfio is provided by iommufd it may well have to trigger a
different ulimit tracking - if that is the only sticking point it
seems minor and should be addressed in some later series that adds
/dev/vfio/vfio support to iommufd..

Jason
