Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AC759F03C
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 02:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiHXAiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 20:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXAiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 20:38:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B63B7F107
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 17:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnUm3aRmU856xd+b02AkJtaECn8PcgtVGJCfSPe6a2SXwTXTQRJEXDZVhgDxfaj7s1SEkRHF5taRaAwqIaeVg30xV5z+fKeY1BMEkRxWEVOX5jtAZSXWow3oLEfQrczSUdQJxT5zo53HzVi/TG4Kcb4QRSZgGicn6FK5a/Tfd70cISVNPNqVPAyu+cHG+VqZfxTn7KHZGRrui8aw7HhcfZqs/uyuOwS0gOxD4ZdzzK9DjR57Saoo+GJA/tdCSAl6zgOSU7vDf0FHJcfdmudyIH803UfjD3FNxlW4a29WrdnbH9FE8qzS7/R7jnkcl5F3RoenJkRdgrTwoGIa5XpUcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPXH8DeIp+CLxJejbcI//mwAZoV5TqbHns7ZRT4wJ0w=;
 b=lVUhmgEEYdrr6RSehU2cnodFedUwqmUZINj0LB6x/bVZXvfN1akZqtZ5YIU5KVsUtNs9Y3AEsun78dtwY2Y+iav+gNlAsqB6uGbLbohrLPTTLtY9cNSPVQScJo4p2HoD6p0Np2VQXeyCw1mhMMcZXkgQUtC8LqowapLKb2FFrKVu9mVIhvTzs0Z6dycWS53wsqM4yuzdBvqrlpa/4mI+I0/TTA5ooZHCO2mIfoh76xY2EwBbf9HS6gO1Vxmws92Hxy0BUehWd80egWYGWNUn0omWgQvBq2wNBNhFoEgUKgxdG2gLSB82VJdLncvxIuyI7oBjVB++SHEWabXApmKn0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPXH8DeIp+CLxJejbcI//mwAZoV5TqbHns7ZRT4wJ0w=;
 b=YUDu5dOMjUq2nmERpux9UtFYazTIL3AUFVCZd09pRP99aTgctMu5JNrf4HoTj7IBcG2/6V9KmIV6YXnTdbleNZ6L4Sb4MsN+kFFBF7JtoRS9m4LczvZ5J4Qzxo1P6eqTrU8Q3eF0ecwPVGwAAzaWZqOaniwdlq1RALkMUS8YESUi5T2CoxFZJDq5NuPL4AW3C1NxJlKAyzjrxOVXUhweGitdMQkyx5xEEzXxLClenmigsTfKOi83faFFdL9ns0Ctt14LXMLOSlPcU+150p+P1Nzv2qkTi6Z5pFUAcPtJ0JPML3kIGaAHpN9ASnxnXSwockGhfjp/mndjLlSSWY42Bg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.14; Wed, 24 Aug 2022 00:38:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 00:38:11 +0000
Date:   Tue, 23 Aug 2022 21:38:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <20220824003808.GE4090@nvidia.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
 <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: YQBPR0101CA0259.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 484fb70c-1943-4487-467c-08da8568ec59
X-MS-TrafficTypeDiagnostic: DM4PR12MB5963:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PTuRAr6Axp4A1jwTdSewmCpfWslGZEZKAOwDb5iQnkIAHv+jXx/Vcvra6ARUtS5yTY2qUfjuclCJFwk0Axgr+u3eaZ5H65fzqw7p16/oAp51TF1iTCVe/hNPuThmbmj6syMVDyChtxmrgdAxdl7a423w5++hJYODXQrRKvdrwUoVl4hZCuALWlOxBIIzuEncjyXc4048R7smdBKb04YIGW+1fuB2O+xd+Tt8N/F8I/R/t5ZS80nN698c+VTuAsMLCr+XPwoCfHejeInecA424a2UVzKDX7OLZ2hsWAWTsb4yS42oiRvJZU9OkO9Bb4+gGCVa+8xYukNsDtfr4Q+yFndo8uPT3o2J239JwDpTnmLPhE/Jxla/FT1MSP36mUH2uSnydx1VbWJKNbEBJwPdTaZ0IvvvTYgsw05+Q2B2bpV4f2qeZ+/0wbB0KelAz/OezMFFv1XbsOCp7qGwMROgZTBlz9LRQB9YzIya364naZ66FsF3XVAa4oQnmuIJMV8wQ+lBCgK0BAJ6SHZ/scPTzuV7FY9D8LUoVj8ik3V+mvVYE4kt6toVJ74KxlW4YkJkSrZzC84c+sccfuOjjd7rd4Fb/NLFO7ojbugertHRsR10/UdkNMwsFDQrWRj9A1Zzi3VGZ7SbVvaIcQt99KYJVeoASS3DsqkUMQckg3aEBlRXjRIBMLkJDoNWMzCWV8VEMcyZqIBvGy01ZYVKaP/cpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(346002)(136003)(376002)(83380400001)(26005)(6512007)(1076003)(186003)(6506007)(2616005)(2906002)(33656002)(86362001)(38100700002)(5660300002)(8936002)(41300700001)(316002)(36756003)(66946007)(66556008)(478600001)(66476007)(6486002)(54906003)(8676002)(6916009)(6666004)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BgZHRdQvsNhjY8WvlAGXY2SOrL6Aq0cfFM2L1JPqtVFsFDJ4OaP/7EKJbAUO?=
 =?us-ascii?Q?vMQoXiMvTjyUR2Zy2AaLsD3juXT8QnBC5pHZULNRMQ1jl2EKqjVcZf+SlCKW?=
 =?us-ascii?Q?M58yLhBIuK5W+/PN5yFdFyN0FKe78sTnhETCN+8tj6ObdasTTPn9PMqxotBN?=
 =?us-ascii?Q?kT1SpklFxdVgduUsrhr94DjZ5caMEoY7ZvMtGKQw8J6L4aCjk/hBoYp8krcN?=
 =?us-ascii?Q?Pemzc+JTikJ9HlShBpw8jDEwTFDJxhME2IBA2utxHpDjwirKtliQsE2ijwIE?=
 =?us-ascii?Q?zwf3LvNBLqpd89Q60XDOJ0+NPq8txkwH8VMEXOTb/vQ6kDlID8CvMA9t113s?=
 =?us-ascii?Q?XwTZ5m/lwt3/Elybt5czOjtMVBkwguRQy+coQYbNR5aJJt61QoX58ZrBPffI?=
 =?us-ascii?Q?LVxbK9XoHd+pNg1RX1eJQCSLmXL9xCy2OjjS1mMzzVNjkcqMDmt6jatJob0e?=
 =?us-ascii?Q?fNdPbQQ7Fd7JHTqQy+Jn4PDHsnGJhsWnJ1iwQD+DsjfjaJuwauDI0pZqb87W?=
 =?us-ascii?Q?W2TMyQB7poxMQ1ybVf6i0NEQslLrkHLN0mSk0BsSoEl+gckJO0Dq3E1K7l3p?=
 =?us-ascii?Q?hoWYHwxXdeiFFekndZJ1RfnK5dEf7RBBh2M+E5GCjv9T466NDw0YioeC90fR?=
 =?us-ascii?Q?x5VS1aba+ZK7GEfTlFIT0VqUDh5l8Wg6oTHuuqw/rEG8gXN/I7XeWVTDMisU?=
 =?us-ascii?Q?ZiGR0aP9JNmxydcqWTEtHXgSai3vE6sVjixkmxq3DJECysz62TYIOz9qj4QC?=
 =?us-ascii?Q?L4uaj44Hl/LoNmzkyz1CfnFxdMJxLAq018o8eZzj61dXJ1UQROkSl5PA5tKG?=
 =?us-ascii?Q?GJt+283bmtQSsmy96Z3lwwo5RLH5DQHqOEzFv+NQ1Z0S1njTc9npvJUDvTb5?=
 =?us-ascii?Q?DRkIw6gaCGu8LdRyEF4RQCDvjgaamhnj7L/V/sEKeWz6v269/AuHU+JKG7F7?=
 =?us-ascii?Q?l7TAwxewdeSqu3+d7Kbc7BFt8SVyzaQzyNVlYonzbpyDQ9cH7KmXDuG4Iliw?=
 =?us-ascii?Q?lZRxj4cJ7uhKVJJNXwjFHR565+ywasC8bO2peMvI61fP9HK9+oLedympm03v?=
 =?us-ascii?Q?4GUTAA/RG7W0pws3CzT7Y+rN6N3bgEPjzMnp5op260Txna3lMcwVKZl3kZtQ?=
 =?us-ascii?Q?3t40O/GBGCTxvBtcVEwd+Gz6q4Hw5JHwwk8+83JxdoCHkomj7eHkaWWDOFMp?=
 =?us-ascii?Q?6pNQWiSF2gQvHX//XdlqLZ2VPH6fBjMbIeDnm18mOEQDpAirNvLo0THDU8ij?=
 =?us-ascii?Q?mbbDphOaFxImgz3kq2NKqZNABwVr/xt/xNXC24sz5dc+0D0y4RzzvHEBcD+1?=
 =?us-ascii?Q?u0FmRC8WHph8a295pyCh7lrGQ0pVeI12dPXU1miVM1+og33PXXHChhqxpKyH?=
 =?us-ascii?Q?RYxp6OU1zvbfushj+YCNxNQSDB+Slo73cUE+JlA8zqS0vT/5ENvPDwUQKipA?=
 =?us-ascii?Q?OJw8l6rsqs40fKhSeUJ9qOBY4Ib5B/VDWvQ35TaoykSBv0irjF2lZ0p3lRkM?=
 =?us-ascii?Q?/6v0AAaDzClFrucdC/I5kOBGgPhFVi5Ld/a2HbK/o4rNFhKOw2DS0Hr0cOUU?=
 =?us-ascii?Q?UgYEtAeYl6JGt04RRFlBLF5Kjq628WhSFRIvQjUo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484fb70c-1943-4487-467c-08da8568ec59
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 00:38:11.5963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulTA8niXcPATOuQonK7GPQdiIcnwEt+NJDM6t2gnNpEii3bOnNVlwxdZSnZaHdNW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 23, 2022 at 01:31:11AM +0000, Tian, Kevin wrote:

> > In fact I do recall such discussions.  An IOMMU backed mdev (defunct)
> > or vfio-pci variant driver could gratuitously pin pages in order to
> > limit the dirty page scope.  We don't have anything in-tree that relies
> > on this.  It also seems we're heading more in the direction of device
> > level DMA dirty tracking as Yishai proposes in the series for mlx5.
> > These interfaces are far more efficient for this use case, but perhaps
> > you have another use case in mind where we couldn't use the dma_rw
> > interface?
> 
> One potential scenario is when I/O page fault is supported VFIO can
> enable on-demand paging in stage-2 mappings. In case a device cannot
> tolerate faults in all paths then a variant driver could use this interface
> to pin down structures which don't expect faults.

If this need arises, and I've had discussions about such things in the
past, it makes more sense to have a proper API to inhibit faulting of
a sub-range in what would have otherwise be a faultable iommu_domain.

Inhibiting faulting might be the same underlying code as pinning, but
I would prefer we don't co-mingle these very different concepts at the
device driver level.

> IMHO if functionally this function only works for emulated case then we
> should add code to detect and fail if it's called otherwise.

Today it only works correctly for the emulated case because only the
emulated case will be guarenteed to have a singleton group.

It *might* work for other cases, but not generally. In the general
case a physical device driver may be faced with multi-device groups
and it shouldn't fail.

So, I would prefer to comment it like this and if someone comes with a
driver that wants to use it in some other way they have to address
these problems so it works generally and correctly. I don't want to
write more code to protect against something that auditing tells us
doesn't happen today.

The whole thing should naturally become fixed fairly soon, as once we
have Yishai and Joao's changes there will be no use for the dirty
tracking code in type1 that is causing this problem.

Jason
