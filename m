Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4D45A502C
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 17:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiH2P2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 11:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiH2P2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 11:28:12 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9278F7642
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 08:28:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCM/1efBEIbRu5Gkt2fSXhRJAtxNBlZ2qYAKuedzym9tv75pjH5nYtXysVI+yGpwA8t41fOky7JX8mqUyuZhyTELpF6gQs4o+eK6fxmqE6h87ZloCb/S3MUY7b2zj/S9Ub9SoMxD9n1yHM1K7Jap5GXz8TXkjFfTMrtKlRu22e2zDTRyPzwhrZJnLz6dCp3dovlAPpGukeatpW3JOjwJ9OnOzRWF4bAQVUgK3/2yOaoarShlJb/n+YXWbJoRHa2rI6bs5st7fRbrUybSc1dov4WiKA+/ponG4MfFVuiN7L2wFJKTJIAn5bjxs3j+xt/iHkeHFfIt7HAEYHH+2VBwYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=25H4UfrFaXOMo2c/qEP2G3KxMrZuu2NR9ZzgYFF+/k8=;
 b=I7uc5pOllJ6iv5dssn6S71ptLEf5Hva9t1R7Q+ip3ND7r5PssAqMU8gwkS+Ns77OeftWYToMZWFHBJ6axK5zT4uv0mtCNXJezcxJC8JSNcCTQfQk1urBPGMHMFbP97n+VNYPSAYtR3PmaPouJ4p90BKs3P7WWNw0TurpRjy2EHQqbIPxbGJb7QosNpHQtu3oAfrouVkPgA1tlrbyswIHxvitSei4VQn7qk7qjGryGvxyK8R72r3BcWefYacbP5/ecWe9xr5FfHtqcoPWjXeQ7lRZPbWtnX9xttjDW5FKQjKzMsSngNd6vxlsExx7V+MEBTXdl87goH/g8fROt1+Uqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25H4UfrFaXOMo2c/qEP2G3KxMrZuu2NR9ZzgYFF+/k8=;
 b=SGb28/4V8J8P8S4AC2UO1kp4U/k2HLBmJ4p1Awj1c1yH/vUl8o4jaSWubYW4/5E4eBV55K4v4fU9RHES2+aHIN2aj+wLe9rPRlPS86ZzaPpMwEd0Sy8iGmlet48yA9xyTxwwjMSbXrbzDc/pFvqfXDfRbwwATdtcSKasfJpSXDniTWIPdMcSmzOwFqEq39WxtnO5lfBXMaHOLNwyF7eqE13lt7SrZe0wwsT2SFKGE/BCTzC2q7snMmugR0JcnzCCdAmI8+qspDldAmXAY1f2z4uR5AHS5z/aVI+zjgE1qAKVD5MT2v7jF8frP7Fml4jSOiOKJCjr9+5EZ6upSQRZzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW3PR12MB4444.namprd12.prod.outlook.com (2603:10b6:303:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Mon, 29 Aug
 2022 15:28:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 15:28:08 +0000
Date:   Mon, 29 Aug 2022 12:28:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: Re: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Message-ID: <YwzbB5NZGOqOsOVK@nvidia.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:208:236::31) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31c058b7-427d-42ec-14bb-08da89d3137b
X-MS-TrafficTypeDiagnostic: MW3PR12MB4444:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PTRBi/H8MlSpWHvfJdRGu5f+gY8y/QUjTximG4/eF6kW1txhNm449W8OtOiwsHsb3G2SOZCUSog3+ev/jlMZdU1tJYcYMA3ccslY2P3L7H5rTrNVv3+m3MCZsTs3YbWkBncHmJBO9lrh+RzJHNfYgwMfmxURoYEGPLUv+qZw6Hjl/XDy7pkVtLPc4vaL8+BtC9rKeazKJ2XP/COf8TqbjWm9cnLOhiclDGSqMH3+FtclIaOB5vwZrcQXvHCT4gD92Mn9WCjcwBkc/pb5EB0Xy04Gv/gqAEd2Z49VUMN1eRCvGUAkkbewHIa7zPFfoGxKA86YIQQpGOWeKIWFHfmMSK5oB7vym/0PhbdRWl2hZHiCfa8FbvQHs5cJ9B916hpmNNXeRbSHH425X5CbOsq0PjFOokfdNHKN8KNU/6TZgo4HNnrKiFg/RZQc7AIbNvUQbuYE3M/iw9C5XiJDXbOssInf+/xYOpn7hU7ZhrXOdFF+Oa0vs0ptRKGD3j3bk2zK5gDIvxXrLJnsbkpeq4bAdKa6hUXSZYGwIKmlyIypI26vhRABpsW1JZVDAmtUgxD9f4vrCoUrnOdPdi3eOiqbRKaIdVeY6JYMdfaHKMU/618HOKSyvzjgrQBwlfpy0pSKlDCcGtlASavY2EXngrERaVtdbLg3ToG2VTH8F+L9tmZBE9I84MXMgEjxGKe2yUY8VsBvyEGM82Pgez4bPfVRRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(26005)(6512007)(6486002)(478600001)(86362001)(6506007)(41300700001)(186003)(38100700002)(2616005)(66476007)(6916009)(66946007)(5660300002)(66556008)(8676002)(8936002)(4326008)(316002)(54906003)(2906002)(36756003)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?itX/6ZYqlp09kV7PI3A83Q4ReauxVd6765nwPEHH4wzGsIT+o51DlixRk9qv?=
 =?us-ascii?Q?RC6UmzSzI6lTDBM1FQhYjq8uwrrzMj/ywaH6O+M1UstxB2MzK37XV++YMUDV?=
 =?us-ascii?Q?A2Ygo2mz6y0jGWi5biEeyV2TId3SYXnyYgkVUkiu0oKo3trrTIH4UdhlMhKs?=
 =?us-ascii?Q?vs3dfjVLW+xO3YxvsAJSHvh3KgvgFecdgfLK1gkuHYEuiHUSA7pCCEn1vOk1?=
 =?us-ascii?Q?uER5hBV8iohRrCoTBBE1W8ak+n2kJEJS78qKXd0GKV1JGl9OS/++h99yUhP+?=
 =?us-ascii?Q?N8idO3KvkQ9LhgxXEsY/9SRdm58s8WHflK+kZMoCen94wLWAp/8We07jP1xu?=
 =?us-ascii?Q?JCfsfZ2HsznUVjh9C4a/48J0TBxVlT1/r0q0R+XzfVuKPsuYgRHqEt7Wmu0Y?=
 =?us-ascii?Q?XZjMex9h9B9XDS/waP2BqbufV9m1x54SQE82viGcoTeykvGmHLpEHidm9aBU?=
 =?us-ascii?Q?EGubVy9ydKMYizRh2K6+xEkah7fVmbVmGO0hk9LV68FxDLKsXezXtYe97/Ll?=
 =?us-ascii?Q?p5tJ+WdKSDkThfFE3Lc7iMMCUKum9H8sFG50wNIEBKQu3G0hzqu+wKav2GnT?=
 =?us-ascii?Q?+uBllZlyAXjHjaAkf39kPski/EFWNSq9tUJXCyO8D8SVjFTMjAOhPxq+derV?=
 =?us-ascii?Q?cNErmJYUnRwhc7uKPoHaTh9Rg6l8ex6x5xFoJNBagizUbEdrMIBoRNrQfRcM?=
 =?us-ascii?Q?qKLnSqp2GT/nWSQzT9Sb4nACmwWmC1fZQVYf+t3pj+zGHQTai1FM3j9zOY82?=
 =?us-ascii?Q?Oehx8MnnjfuoGD45itOB0p0jvy2Rm60cqhMHFgxT8ivt671VK7gAIQg1GvS0?=
 =?us-ascii?Q?+6qp1Zmvs8BtDXhoGH9wsMFEvMnwgzBkHb5YRKuJXw6fw+R4WaIP40hdhK+J?=
 =?us-ascii?Q?wi+HTuWaIKg0iGs/1w1Rl0SlWt/51691Lh6UijaoQL/eRwGoBmJzCaaOYgsv?=
 =?us-ascii?Q?a81o2TDaX0UN9mxVAs0ogMQ1ycuYN6uXEbpCjUjc5FU6poHu2edqRPEIKrAy?=
 =?us-ascii?Q?blOlbrX7HveQSnlZ3HZ9Y0fo9INlAqZNpodamCA1YAHTVbTq1Yb8I8P/35AB?=
 =?us-ascii?Q?0c46XefKzNVJwNlkK2tNp++evSG6kLUN2rqp6RcOF+amKe19nwn8BxtVOG7K?=
 =?us-ascii?Q?Ub9/c0F1Tudf5XiO2DlKLsv6B5ra5E0viwVnbz1kJm6wuZgPn2DQr8N/KO7X?=
 =?us-ascii?Q?cH2NqsAeRRnimxTKKNsobrIdYK3EDqWbaaMEXYkf9ZhATvqAfrKFGrtG7oMR?=
 =?us-ascii?Q?ZICm/hWzC+o5fzW0aHEzmg0pC9glQumU+fVW9UUh8fcABrZ0Wc8zqZfJHUhN?=
 =?us-ascii?Q?8C6ZRvb4on4q0C6m9t+iDW+QzvdVw52P3lCJ06uPi8bEPQzmgdmOiyJ7n2CO?=
 =?us-ascii?Q?2gfpUFN0dbKHzeHU0AlDNGs3ynQej1JMSjVWnTkDcqtEJ0GRVivKW61SKedl?=
 =?us-ascii?Q?3xF1nXrbCRx9WoqtYKxFTSCI+Xfci4aA/nvzmxRnFjDj+CAXQcIpWWjXqZkO?=
 =?us-ascii?Q?A+aLpT1SHSpbXlTBlsttUE9Y5U+gkO/HAKdn5iXYv1HOJTMeDgS+PSJ50TgN?=
 =?us-ascii?Q?tlPPtFo7hyIfZz2ul35ZDvUa5cwVmfxzqrambdmB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c058b7-427d-42ec-14bb-08da89d3137b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 15:28:08.5846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fw3nXdLvDQqYMhkX4ZmRqaKgw6s5XSmFDs1YM03Tnap1QAdp2Aeu/9kVpL/b0IcT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4444
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022 at 12:41:30AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, August 18, 2022 12:07 AM
> > 
> > Make it clear that this is the body of the ioctl - keep the mutex outside
> > the function since this function doesn't have and wouldn't benefit from
> > error unwind.
> 
> but doing so make unset_container() unpair with set_container() and
> be the only one doing additional things in main ioctl body.
> 
> I'd prefer to moving mutex inside unset_container() for better readability.

Yes, I tried both ways and ended up here since adding the goto unwind
was kind of ungainly for this function. Don't mind either way

The functions are not intended as strict pairs, they are ioctl
dispatch functions.

Jason
