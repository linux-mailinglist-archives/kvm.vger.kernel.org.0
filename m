Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C32704C0695
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 02:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236534AbiBWBDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 20:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236515AbiBWBDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 20:03:34 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B200C33A2F;
        Tue, 22 Feb 2022 17:03:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BunfNMfSd6L9t1cNMmIrDPp1Yg0/C1+5mb+4VFY7a4DO9sPyuxsjQOzjDyNnGafUEui8oynXcyyMATb7XiVYjPZqAKi0Xu28S2D7OVhQLXDBMFlgwWlzyuz47/I2QISJtfP4o3a00QazgPLEC4o0c+X6g1330SfMzpAUznc805m6j6OWXztkv6/ILqjmECSo+Zdpek2eTFDSNtQ9Ki2kS7zTd9e4Om57KVLTLlKPjOIggNebWfwgpuLHuyFClH7NO15hDK5s5SGQF/FDq76qQAm7wNRKGo1PemwXgdXAl47J9O4dtyh6P8gYl8A6vFg2XuiM3PDxsNQfJMqf6OeSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epOvCchQGRJubkSJ9CdCJkq9EegHUkv+c+zfomCj2Js=;
 b=Hl2RiTr2kVdaMHjqzR1gqw8tEZce8XQw6qJycldIiqHxg/GNU69VpwjDlXT8nbLB1lelfBx0URPAaN/SHq9pYsbabJi+VYOvrl5m9LhtSY2A154fUqf3ClwyeQVB1Wnh0oWJ2SIZSYwfMxrC0CMZL2XLV7WS6FUGUVwJVHfsKqxfcdpfc6c77VgHWFede1Q1swtO0CGwZlywfWRcBTU0qP9g6qkuYrRLE5aWkTzsjg1YUCbE4shFKzkUzH1dMK3Zf+9WQw4QJ4nzUh/+aPivR69g8UGGpcqwGIZ6Q3SpVcldaSlCagbMsb5HcwMdRCWWTDSLLlniikoPBU4165UKAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epOvCchQGRJubkSJ9CdCJkq9EegHUkv+c+zfomCj2Js=;
 b=Aug8fjUfoMuAk45uHNr8JZyLSvkmIdyW5XS4HX8GLwxCh/aFlY6tjKUSLy/mmUNYraPcJGAew+H0HJvr9/PW+ysI7F0ogAc+fPUZbC7DXcpbiOkhwIyp8XGBUbG50kwipMt6Ye6M4PhXk/ZQWikncmNbNpFFJXZItBHvuq191bGmuWagygy6UuSGYCA4yN+DgQvg4Ml1c8qcSLO0seBjSUeUJS5lRVYfigMxpXZjemViIcGP1DmKrm/VdgRslmi/1kyC6Lg5tEeuAboJeo1Iq/hv2UfSRb/OxIPoXER9WwufbguC7/veUCUYppJbGl4Q4pHeCxIKMGN0e3nbhZ1VFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2904.namprd12.prod.outlook.com (2603:10b6:a03:137::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 01:03:05 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 01:03:05 +0000
Date:   Tue, 22 Feb 2022 21:03:03 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220223010303.GK10061@nvidia.com>
References: <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
 <20220212000117.GS4160@nvidia.com>
 <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
X-ClientProxiedBy: MN2PR20CA0001.namprd20.prod.outlook.com
 (2603:10b6:208:e8::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8632a4c-cc56-46bf-5f74-08d9f6683f42
X-MS-TrafficTypeDiagnostic: BYAPR12MB2904:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2904225A8C152836928E2E8DC23C9@BYAPR12MB2904.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4olhYGD8VXYN4cbRhYStywTyrIPcCWf6eV0hTsgsN+UNR6UwlD4cNfN8umDat+MVsPMXOP52TavZ4pbAFj6FI5rZMtW9brRKUgzIdDK+7Qn1btWYxIVIU4bsZB7LoXlRt3r5fU56G4kqEj0xng8lclPPA/xTdmqP2X3snkyzb8QDkJet671ngxwzP+1EQ8Q+ogH4WpP5ckdP2KKpY1GogNBOer0gNJhPDLq7fYQpKcvEf8QFHM6MJdB0ikYVT6/a5eE/2gky/GawL1PKmUQAinAeC04GO5xxf1CU4qr8ItUdbl4dlK0yL1auv/8PZTV0vKFb9/AMgry25CsPagw2crGk/1Xd5ZKhPDBrRFG6qrTPDXUg4vXH/AzNWT+7cMk5mIcHGd2UR2vrUQzUEI32gk5YoGk0L394fLXbj1NFwRyfi5pDJuGctiqH91VhKR+7jk1Fdcxazya8yii+iGFvIh0Gw3ReG3zpuLqNZCBiKEyyKFMxvreu68Nv/rmaMToDSFOzOFGS9TVDGeZpqoefP9sI0WIGIxPNgtZap0STgMrM6fR2Zsi1hakGvhHRdYTjckWUQ0MZrNkLCW2h90K0onoTGpJxesWhC7NCd2eAGBeUZ62IlhWEVB5rkjs87pQRe6nzK0RAHXn/pFGtALNKEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(38100700002)(83380400001)(7416002)(36756003)(5660300002)(8936002)(2906002)(33656002)(6506007)(2616005)(6486002)(186003)(26005)(66556008)(66946007)(6512007)(54906003)(1076003)(86362001)(316002)(8676002)(66476007)(508600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gty2HuzRHeOkWcHqFy3sBj58X+OpElytlVlX6iKUrjUCYi4uNaTnMaIftFza?=
 =?us-ascii?Q?anfjJTq1YOwJgJLPx5zLtqUh2DE68r9lWWuE/zUfkGjsnawRjsgNcR3Y7eu/?=
 =?us-ascii?Q?XJNcOHPa0iYHllfNnV9ijKRpif0vjhGS0LzMunDS6yiweKdDsR9vlgTOf1YA?=
 =?us-ascii?Q?ojVp4qEBoCSP3rOV3Z1bBvWeUgrQsJnBXxfN6npD7XSwNWOIBnr+lH3FijJu?=
 =?us-ascii?Q?oh1A6jTHQnLgyKhni+kMogd11LHd+XIbn1wBNICCUx1MA2bbxSYHI2LI+nZo?=
 =?us-ascii?Q?qUO/nEaeeNQinqS+x8b4pQ/sg+HG/JVrXsS3uw5shAUkR94GaOwhgwPMg88m?=
 =?us-ascii?Q?l0+dzSQnZX0ccr+zfr3r4ZqOwfaFLPLinBanfSZDb22Nz4DCtW8EemURRs+B?=
 =?us-ascii?Q?R8rs3HXxWjtD2fzoLnj+dKN8n9f2F7+5a+THxFnseMYsxLjlY4Y6ODZAB5mF?=
 =?us-ascii?Q?d0m7R5VXh8pRDlSWZLqqg0OTeOxg+V3lfN56X0LsoepJmhdhHHInEGM9BUW2?=
 =?us-ascii?Q?kH05Li5N6mT4fPa9KgwKOEYSz3g5c9VuQmejqpkQ13qMNnMbbwyEtD7cEJVr?=
 =?us-ascii?Q?PUa30Y3mslxp/MxN2/W9dYqJmShPD/J5w8S9HL3ysyL0qxD7D8d8npC9Gv6J?=
 =?us-ascii?Q?5XpA+ndfGkkBpvaCMFy05rsK9M/cyLL5J30N3U2olmVgZcECAaNhjvaxOzXf?=
 =?us-ascii?Q?3ihfbOPCwS8Tn3zI2wosmwgB4OSwDC2X7CcaQ7I12+twG9OjyoM/r+/wHGvf?=
 =?us-ascii?Q?g4ghaEc/jOUoemwpcbg/iAOjMYJPjph22M2sYETPPc/FSc0t2CjGnF+OaYbZ?=
 =?us-ascii?Q?qVHrh1L082bCApRg6qulmcx41uFVQd8zZ1LVRBr+inIwH8n7nxgm6WfYiT6K?=
 =?us-ascii?Q?lQv9xa+tkg9AxQbfZ+PA2iKlRF3RADZ6KZ3lu0NafzLdYQOB017r5sbAB9oZ?=
 =?us-ascii?Q?ut3vU3995gPui67nRksmg8HYN0m3lADcLZbC4RrhDNvV7YycZPhDshXcBN71?=
 =?us-ascii?Q?+q1LWaVGVtDBvLMTQihowWxt3BNHMg8Q9mDaLVyxMAQgbq2NaIPp+z4lqxDb?=
 =?us-ascii?Q?khfaHcTki+VwiSTqzENIB6XwrVO9GRzFKktoZ9XmpZWPLNGtw3aCm/tbRWRN?=
 =?us-ascii?Q?NnAQ+xPb3S5XhEySnlJ61toMX5GuTnJnmpL48XTPew3hPkhY7eykCregeR6A?=
 =?us-ascii?Q?k2Lzbg/uqD2NX7Xp9oMPITdAfJNHOJc92CDjIMciIELFa7juHdWbsLx9TXVK?=
 =?us-ascii?Q?a8f3vYS9nPDxu1tiMASzeN/VfALt+YKJBaevsfw5/7rREliDaGbpV/KGmuKZ?=
 =?us-ascii?Q?INkil2EavQNOtOea45vnCeK7stI/PsgtDDR+ZORCU8lNG9PZf89LcQaM9yBi?=
 =?us-ascii?Q?G+Zw90akGP6ukgZatIHkE3vg56Sn/IN2fHxitoRyvHoiCpoa6CoyUHvzsESr?=
 =?us-ascii?Q?48Q6ix1YQs46K+X7x27PBvt5FsQIuKOEydyG3mIg77v20lN2ZDQz34dwJf7i?=
 =?us-ascii?Q?jDv1ZzuCpMEW7KWJ8V+rk0xkirt2Bf6nFpYUlufjK2y4z/qb6B4eAoXHlLeQ?=
 =?us-ascii?Q?S/ITrfujaC2faaG06Mo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8632a4c-cc56-46bf-5f74-08d9f6683f42
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 01:03:05.0325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7R/z/XGR8c/mwldEPCgZ5InJyLXefcOPYhf/0OcNxaqMhk57SLkuICR4Cnf9XaqS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2904
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:

> > If people are dead-set against doing iommufd, then lets abandon the
> > idea and go back to hacking up vfio.
> >  
> Heh, I was under the impression everybody was investing so much *because*
> that direction was set onto iommufd direction.

Such is the hope :)

> >> If by conclusion you mean the whole thing to be merged, how can the work be
> >> broken up to pieces if we busy-waiting on the new subsystem? Or maybe you meant
> >> in terms of direction...
> > 
> > I think go ahead and build it on top of iommufd, start working out the
> > API details, etc. I think once the direction is concluded the new APIs
> > will go forward.
> >
> /me nods, will do. Looking at your repository it is looking good.

I would like to come with some plan for dirty tracking on iommufd and
combine that with a plan for dirty tracking inside the new migration
drivers.

> Oh yes -- I am definitely aware. IOMMU/Device Dirty tracking is useless
> if we can't do the device part first. But if quiescing DMA and saving
> state are two hard requirements that are mandatory for a live migrateable
> VF, having dirty tracking in the devices I suspect might be more
> rare.

So far all but one of the live migration devices I know about can do
dirty tracking internally..

> So perhaps people will look at IOMMUs as a commodity-workaround to avoid
> a whole bunch of hardware logic for dirty tracking, even bearing what it
> entails for DMA performance (hisilicon might be an example).

I do expect this will be true.

> > At the very least we must decide what to do with device-provided dirty
> > tracking before the VFIO type1 stuff can be altered to use the system
> > IOMMU.
> 
> I, too, have been wondering what that is going to look like -- and how do we
> convey the setup of dirty tracking versus the steering of it.

What I suggested was to just split them.

Some ioctl toward IOMMUFD will turn on the system iommu tracker - this
would be on a per-domain basis, not on the ioas.

Some ioctl toward the vfio device will turn on the device's tracker.

Userspace has to iterate and query each enabled tracker. This is not
so bad because the time to make the system call is going to be tiny
compared to the time to marshal XXGB of dirty bits.

This makes qemu more complicated because it has to decide what
trackers to turn on, but that is also the point because we do want
userspace to be able to decide.

The other idea that has some possible interest is to allow the
trackers to dump their dirty bits into the existing kvm tracker, then
userspace just does a single kvm centric dirty pass.

Jason
