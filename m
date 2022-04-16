Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D698503455
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiDPCGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 22:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiDPCFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 22:05:46 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2075.outbound.protection.outlook.com [40.107.102.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16155E0B0
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 18:55:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Js41ovJUpPBuYFRl8rRwXPFutnY6WyB8qe8ZJP9cxHTy2yHdX4qB/dMlmterTu7V0NoCVAJYZ1xCJKIW4JWwTHAMvh0wfSVM71DzNoAiFXaX+D1r1w8nF2KFgHceZTkyf/rD2EolU3+qne1tDs/aSsbMTsrdWNVbihn8aU1gvnz/inBsQtMO70beDWeLYTnH4YSqNHmcWyDO1Gnvbe08OtJRLKx5ICg9AIL3S8Ex+6UNZVgGg1q2/JNGdKVnz/nEsm+0O8CMfkNcI/SPkyvY/z3aWY+5XrwuMI/gKR47akaHmBfoOknZAWe0htt1X7mo6eG8fVbQj2vDFS5BwOdhtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9Xc2DZrDD4JfkFCkqifhrad+rSiYB43DvzbXIws7O4=;
 b=SmUfNowY0pN3YksPEhKtSDtc3gyfvwcFAgDSv7LvT2Klx1avEI/iNAFGlvox5Z+crkFKO8n7N6XWT08Rs9cw3RsjMBZgnrecYHZHPDgkx8s1G6tbKdCbm+kcIIPFFjt9BuZBzfaHJiEOCUXPTJQAL10H6swyhxEdPf4F7hUbpkP/Y3T0l3NL/fvBGBX35A3yfY0moWtpVeVsm8EuMlMOcPARdOS0lDJ58RzpBPjutXDYxjSDbLbyH9+AEhtgK0IsTLCTqx2dMkpcD218pyQiQ83n0Bkx7KYuiqYvX92ysHaXH8TMNzjlMkt4kVzWmmfab7x/oqV3dUTfs51+RdI9xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9Xc2DZrDD4JfkFCkqifhrad+rSiYB43DvzbXIws7O4=;
 b=Gs4wYYyf3ngF9ezlJk/rpscX1pOHsm+GjR42qNMg3TuPoSdLUF1n3LC3U94n5OK43Z8KxNVExLyg12+kohm6D8Owtroppdb+G0/1vKrOCvHbPQ/OAdc8nyxURSafV1TwIID0Kuty7zdxc4FAc6KKyO9St4x9gW18nGykEeFskdEhD5H/1pEnEdLYvtj+nn3HeC4zwjMGvjeDYwPAWWWnAvpLF3SBpHwIndwAAlUeJwxXqB0LRuqknOnLttjntOBaOW+ebqVH9njaPvjxX0TIa5p1Z9/1GfqBq6wMa7S0ysFa0H1aH6ttZqmycqR44TmfdyVeBSSzz4wyFBc0MJlRtQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1840.namprd12.prod.outlook.com (2603:10b6:300:114::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sat, 16 Apr
 2022 01:34:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 01:34:16 +0000
Date:   Fri, 15 Apr 2022 22:34:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Message-ID: <20220416013415.GQ2120790@nvidia.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215604.GN2120790@nvidia.com>
 <BN9PR11MB5276894C5E020B8925BB6C238CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276894C5E020B8925BB6C238CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0063.namprd19.prod.outlook.com
 (2603:10b6:208:19b::40) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2836e81d-3fa4-4100-36ad-08da1f49382a
X-MS-TrafficTypeDiagnostic: MWHPR12MB1840:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1840523366745582148AB7A7C2F19@MWHPR12MB1840.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nvt3yPU7zAYY4ByWC1+1mUt6E2j1CqPW4HSi/CDMPmOB53Yt9Qr8ADJXzvgZB3VpgW658Sj3KUcdqn6oLhK6/1jw9AFRq6Wf4GkEJ2qIs+tIB4j5RJdMdIuEIV2XG3ro9z221GId2AiBQt6FYtnytq0v1w7ceFM1c5e22ldJXPRaHAfG7tVGfe43zQOFHXpzxY8ekDdefJqtrvCh/FMxieDrbdKR+9gUteuuVpnI/rbFVfCrrx+Vk212Oip85ZuWQCA66F/Fc8udOTfgeyL17NcYAeZu4+DQ7nuNAQ908Lr9EgG5K4aO8BZMFfikqVJkpq3aNV3JsujyHbOXyBSsK6VFrSTzPqHL++HKRg1fVRRPQ6fs0g61cqdJEu6cjG7CvWUyQRkKYDlNwqO8KUJXq7k9G1GM50v8t6dyGyCfi3yWnm+PQTAyisl7QEkxqfjLiGqvmKxZOcWDnTwYIVX7cF/r/Qqu4+uMGsgnQFRMBXULdBv3PrfZ/bUPX+e/i2xYQifYhIOlj4kUWveel/fL3hdckJ7G8Z8pw9SvD/H9eo2N5oO55FOkQDkKFxK7EloNZxHZtbwE8JAUWdYY7cofP1Py9QQ4sIqQXo1E+vFf6/sOxAUKoZbdkhprD5CNayQMoOk3o0WuCEcWtOFmU/wBjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(66476007)(6512007)(38100700002)(86362001)(6506007)(54906003)(66946007)(2906002)(6916009)(316002)(4326008)(8676002)(66556008)(4744005)(26005)(8936002)(1076003)(2616005)(5660300002)(36756003)(6486002)(508600001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZBcQsJieCHH/4YCi2ufYhEB+peIT3pzVWmaRE9mBnjxpyeQgl9QbQedxWlJl?=
 =?us-ascii?Q?36RR7D3px4I5FRK0QGAiP7VnQ1C07WzkBgUFMufVi+PUD7CK7aP08KsfPPKL?=
 =?us-ascii?Q?pLngVxwpKgEXrbA/v5m6NyRvgK0+IxG9NaZeb2nRCpb70JyGQROT0yt+yzQv?=
 =?us-ascii?Q?cOotwLBfYnGRZkQ8EkBhRVmBzPDKnel2XkqvR3JvIpZ3QLjYgnoJk+S4dWL5?=
 =?us-ascii?Q?IXVNuXZIzGuXvLiJGBoaKoF1B15Jw9vdipK2qBxJY63v89HlyvkT3VOSbqEX?=
 =?us-ascii?Q?me9FCiAhbGlRt5ufixn0bvZS6N35Zh+ORoXaJiqlkp3FZbc/Nj9GQcPdf1nE?=
 =?us-ascii?Q?XetLiyTaH2ZkpBV7TulyRRlPKEOPQQrBWULX1TGLsYbcOAufYAAJjbohOWsH?=
 =?us-ascii?Q?Eq8jDIfHE03jKbw34h35y6lBtyKhlK/O0DBePITKcUi7jzzEzg2ziM/Vt7eg?=
 =?us-ascii?Q?ezeNyme15cTG0nBB7VQTmnDcCy61WP3gCX7Q6iqtT6PCg1VJZflddzC/yzhO?=
 =?us-ascii?Q?QG4BhB6BqZi0iPd7mMCNAIakbxdGRRFLXaKvy79pH5C34cKPyTBtSkRgPPVj?=
 =?us-ascii?Q?vuAWCIRpxh01i3Ho8xKtkS5MqQQTfXmmyybzhiSD3eYHsWPOG6KvmYWHuneK?=
 =?us-ascii?Q?6rZvIILP8gGgyYMQZWvEg3FaKnM6QLr3x936VHUDgEeotpoVP9QobgwDzCQg?=
 =?us-ascii?Q?v9bXpnGo7Si9CvjoEpcNqpI0kA7lJJrKpW/2mWfH3OQSTXChybbFOnogUCzE?=
 =?us-ascii?Q?S00v/zvfzMAWrs955VSm1aGlLjIKaMeSBS6C3A6WVrPTk4bWBpEE5tzg/Lnt?=
 =?us-ascii?Q?fbmLs93MELUJsm77HeQ6z58NOigmzmqW09ARjxs8ido8T3E36tmFzWQ9rb+o?=
 =?us-ascii?Q?FgIRlb26VkJGjFS/pU+3XIrTeGQHrCLTue/wQvjhOMqYtXz2eZx+FEPq+UZ4?=
 =?us-ascii?Q?YDDN0TPjx5V6wyhnz7Wup++sXdyBaG7t6QdxVvoyfeu/sPIAfdOcS80uU7Xq?=
 =?us-ascii?Q?Gzf+KIFYYlAQ9TYPjgMyuCzsCBZG7ZLVHQVGQfBTEVaOKnnUO1jzP0ygInuf?=
 =?us-ascii?Q?A5qTGOdo/YrwTuNhSnyPKbtv3XObnIkLi04zjbj8nA9x5AvbHDtqjmL1Gm66?=
 =?us-ascii?Q?QEeWY0JOwtGcPd7Tu3yxmL9KVvU6pgtbW3jXctDhSbMJWQHxInyoWUoyJegz?=
 =?us-ascii?Q?UjCyOjMMdvubAYUBTdZrd0C75d3pmdzrHSHTTPtYdkwAl5oJlZFR4Bs8+MHU?=
 =?us-ascii?Q?aPHbk/UchGEcigUkP2D8TtyfAPmSGALO2/uE74kW1f9QSTtxi2xB+xLYVBMF?=
 =?us-ascii?Q?soyuKTp+hJma3z8iECpQ2upYYKX2e5RUe0/PEazJ549NbJ8/4Z8R1m3KBbc+?=
 =?us-ascii?Q?Cj8jf0Tq9XAzj3ysziQp9NAh++EezplwbIY3z3uDpgjujRrOIWbmDf7u7uQH?=
 =?us-ascii?Q?PLfRv+R0HIaLSNVShB1fAx/oHuGkVyUvLaFVjYxa5PD/k2KvVF3DZOYdeyxs?=
 =?us-ascii?Q?0r77z9u2Ii2DmBqTYZZOOUMSOoOnIFi3aKpDiXHA24u4mmrD17fLqw9uLHKG?=
 =?us-ascii?Q?1TPY10cM+waJaOLeFl1Whl4ZrkiOs30IJAH44sBrN6a7kz+P2+dQjJ42NJzF?=
 =?us-ascii?Q?XXESNyxF7PVshoi/H6IkzFVoSuSy3zugsYPcLL+GzhvW/QpKMIvDd/yuDH4O?=
 =?us-ascii?Q?SRAIurYWp4efzVDMTqk+Mehdfpa6irOK/VuaUhLs9cHnzN4CHHYKXQ4uIftK?=
 =?us-ascii?Q?I9UymUk/tw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2836e81d-3fa4-4100-36ad-08da1f49382a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2022 01:34:16.2491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bHqVy3rXItqCFDHoAfU6w5gRjhvyV4N0lkxzU+uSwMnn55bKlmFbcWbfGTd0KkD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1840
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 16, 2022 at 12:42:50AM +0000, Tian, Kevin wrote:

> Then what about PPC? w/o holding a reference to container is there
> any impact on spapr_tce_table which is attached to the group? 
> I don't know the relationship between this table and vfio container
> and whether there is a lifetime dependency in between. 

table seems to have its own FD so it should be refcounted
independently and not indirectly rely on the vfio container. It seemed
like there was enough protection there..

Jason
