Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21DB25AA48D
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 02:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiIBAmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiIBAmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 20:42:31 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9777EA1A75
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 17:42:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUX86xIwq+9ph8hwGRrpcN9ZqBKwwBp+Elj27bhZhZwm52TQ//Phtxd5b9oAo+PJfCtLgOwEs7LfWXop2EvO77tDdeE/r0pq9yFPMJXX4ZzdfOGJVPPCAHnnprdcBq0kPQkQhTyo4xxZy3Grxu76imTvExRfXvJry4rdnGkJVrJBmt/KcJ5YjvQFYINRXPjX4MlucqH59nftcTEsLTYzXeVFbZrYpNYCjZ6syeCT52ctEmAkNVr085Rb/t0ruVReljfs4UCjvgms/515sqVqFkf+8OG09BQHLi3po3NMb1OHetcZrHT5QoKXVpHrxsnOsWjj0QZHkpF/x/GJQMAlrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT/HUGvmZ4ObADtSjRAnZK5BRASJOV7eqK7OENjhaD8=;
 b=fdE2ERHmLLsnrXsfi1FbvdY3xiKWmEquFo/kgSpn2HyhY+IMhJqoh8+8hLvGanAUMwkzDRjt1Mys91ep0qM7bgiYeMakg0Xqqh1H9n1GHjuqIy/dMyuFKgpdL3d/AdwPMUOGFvyb1n8V0jQ7Xol7nIEFSDCshmuD0+YcPuzP6WDBpAQriN5m/t1Hl5P4clM5S6jPO6wknYrIhlhhGRQVW7bcTtoSrEFkFzxLYquxnko04/Vp+B0asyvjvNFkd7L9jQ0iDeZwfT+44bE4b/Ro5GYHPiYgiKyrQZFpv+hljjsSIDa2MA6XWFFWf6LJsHDLjVd8f0ICpqJ8MhpmYE3QGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT/HUGvmZ4ObADtSjRAnZK5BRASJOV7eqK7OENjhaD8=;
 b=BGjZ6ONOb/dhQQomm74cxnirr//5w7Rm2Bmu635yV5VU6BBlr/CJ/VUgZsqfezfrCD/w9WqvHnFRSIeH2lxIXjMmWgmxzRY8UIMd6nZNHMktRJoCxIYSiry64k96necYp7bL4oE/mFtf7KBX7wNxbiSkwptq4PRE+DodjUiHUmCqgOUKt4S7VbixMC3dm4ZFn/K5J0S+xX6AZ3AFw62PcMggs+6Vnp9Mmzq0qoAZ09niycVARbvteWsybnEAKFVSlQplT6VSh5Fj1CVbgEex2idow5RiiWgMS+6R596fqY/P2M8VZLApOwr0va2WxMmv1A3otl15d61GO/d2RdepqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH8PR12MB7302.namprd12.prod.outlook.com (2603:10b6:510:221::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 2 Sep
 2022 00:42:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 00:42:29 +0000
Date:   Thu, 1 Sep 2022 21:42:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/8] vfio: Split the container logic into
 vfio_container_attach_group()
Message-ID: <YxFRdBmIzn8St8aN@nvidia.com>
References: <0-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <3-v1-a805b607f1fb+17b-vfio_container_split_jgg@nvidia.com>
 <BN9PR11MB5276E01A558BFC2397D8AFCC8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E01A558BFC2397D8AFCC8C789@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9ecc956-551b-496c-3eb0-08da8c7c0397
X-MS-TrafficTypeDiagnostic: PH8PR12MB7302:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UU00Niyr7NoTO3cjwWo2NsempcHtUTcG9/lcJPINwtxYdIVbyTJAcGZOy6MIKWDkCwlPoAphx3TfTO+DcSKL8qotQnckLyRqvxTyskgwM8jd1GVamM/6Vqy/pFZRM/fJxliYZzcNbFvuB1T3DQu1tMI2zQxy9XX9X+S9x3ON4B5/K81GX9x5l0IobrceUZUxoN/yNtc34DbfO4XbpAMZU3H5B/tNH6MhYL1QG94XRRj67s3HfhLN4EjcpkzltNochm9ORCNKe5Oa8km4hMMMIeoh4OCsIyX7+1OtBYEebZJApF4htSj22MUFmSZW4mCo67U1rIX4QcU87/OpGS4B395fIBzo1IP5i1XBQ4viHVA7fA38vE9JZnWV7X8TCv5gbV8K4nNy1xB8HTlYlw4bBFI7mwr3itUd9eheh1BXtNvVeIyuosmMpBYSWGOPuyt1mJO2mrXLZNAf3H0mOEXr71OwAQ93j+xLX3SlsySwn01jS/Z6FRGLWUizj0yfVwZPl/bHdue2koYUWXQ0ZB6VxhH3mXT7LTgMqZvi0/2hEo+8MN72dj/WBsufAX/G/77YsXZrKG9hunTSpjHNxTQwhF9H/xAWkE9kmNslW9+C0bYVo+2aRFbpN85TcQRCGzvPzcCh8SM//dEwJINU6Tfj61sYcSGvMkM0C7tarNgCz/FydTzk9NRot6WOT6iiquUKzHNWx/pCac9rIdcXDAU93w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(6916009)(54906003)(478600001)(66946007)(66556008)(186003)(8676002)(4326008)(66476007)(316002)(6486002)(5660300002)(36756003)(8936002)(86362001)(41300700001)(2616005)(38100700002)(2906002)(6506007)(4744005)(26005)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bfa1ZKADUSuwrw2X98etQL4iw05fBOTGxPdaI3HMv0l1GjtcXQ2jy4vPFfeW?=
 =?us-ascii?Q?w+TD5bEgXIFQOxNb5rrw+DgAJZsrya8QI/ddVlDKTZ9/K7QzYwE+7zcXgrxJ?=
 =?us-ascii?Q?B1BFMEIa8W5IM6On15mRdlV3+oJfvfAVxxrzUAa7IzbxYVcZGOpdKZOHBOh0?=
 =?us-ascii?Q?SQ0Nl9BbebMeKIcmiOO0yuDCov0uRPCQcvJEoVNgUbUESWdqGpiw61tmJKIC?=
 =?us-ascii?Q?rNMlaMYgnuh5lQl8lp+/3SHpKT8ASRAl0NdYwpOwt8Y+Pgx1VsxX1xvJrHVx?=
 =?us-ascii?Q?7b4zgK0DJ2Rs8sL9boO97gpfKXT2Qb36dKg9WXeOhX2FTXGgal5bV8awMXBv?=
 =?us-ascii?Q?pdHoM5jv42NpmJmiIVgkMleCnvxKgyIZITA7TJXmXeb8FgY0Gqlzp9TbpgqL?=
 =?us-ascii?Q?Ey31W2+i/nOsqOoR2NzZyxwpuXpW+elhCDutnf4UhOLNoJk/ZeeNPyuhMK6E?=
 =?us-ascii?Q?qvPLFpd47RL3wIJUBdrn41wvbEttoRMTH6K0SHM74lHgXcRNyoy3z24x4fX2?=
 =?us-ascii?Q?h9xjdU62YsQlw6/voSliYu7o8ZG4nkWd5lM5AK8w1jmq/B0owQgvR4x9Ae6n?=
 =?us-ascii?Q?puER+eDLY7So7TglJgqKEFoXJ37rirD2SpQmESx9fSY85Jy8hJPMNOtJqUAz?=
 =?us-ascii?Q?r+gZA4NsxBU7Xq0Kq5KQHsv2PmjdiKz+Ike9j8/6RZPlaUZuqRLuNcvcvBzM?=
 =?us-ascii?Q?WfzoUh1byqzftecis83eWRpJNinf57ZO7YT9WVkaaF8IjaEFFJnKn6Xcb++h?=
 =?us-ascii?Q?hKm8MNDn5opWrz2BvK0fL+hODcTfH5GczFlAl55VONhTjmMLdskpI0eo1iqt?=
 =?us-ascii?Q?iPeIC4iz3OVCgz5dtJEjalwjOymu6OoFjkxzHLhRPXa5qi8+ZtNHyZ54/1HZ?=
 =?us-ascii?Q?fWuK122tANop1S5wW4PEEGTsbKvgwZ0xKYd6zaTSrdpqKxWxlix5xcxoRbAd?=
 =?us-ascii?Q?eO0o4XGXe72ht89ysc/Zo+mX3XnW8VUT3UahzwQjAVOoOixttlZxea7hXV6L?=
 =?us-ascii?Q?xaZmtnTx07rE5u/TL63Tq32ynuIfEHYVO0EqeJPOmsMEOtpcZ/WFxNnLu8SJ?=
 =?us-ascii?Q?04GnqqzEx9ppRdHIebGRxNcH+mvH6rYEpOpVb5pi6Jz2Q7MsRzg7V1jfh4ii?=
 =?us-ascii?Q?hPyXUjR0vzOVCn+vA3e1h4U2K0vFgwRkAqtNUB8EFIO250Of7ltZP0vpjqPx?=
 =?us-ascii?Q?SQIjkoBYdi7NwowVNv0Vl1WgVPVbzCG+cBU06duvxMrKIM8F3sABNkVKOnDh?=
 =?us-ascii?Q?ij5qzVKVnINhF413BXehmKUSeqOogZd4/atg2yR4pp1wvawjr1hR/tyVM16P?=
 =?us-ascii?Q?bshu6h4Yy8EXcGPWWrDEOosh6Wi/jP3ZoMOi1RQOOBG0ujrBGUZoEEfiBF52?=
 =?us-ascii?Q?EtFSoRxqOgoZd258K645KbuJAXZOzUWCGShQJjnEs/6lO+4jBv8Zajvu8sbH?=
 =?us-ascii?Q?8dZN8O8b8gzieNBLZwpCbCnUs8v5PrTkqGiWVk7PX3WL36ddPG7n69SGbkRx?=
 =?us-ascii?Q?XztW5E0XgeLiU/YyKQKsOuDzgsGC+XrPktt2F15flb41NvMpkMFvDDegDhD0?=
 =?us-ascii?Q?oufSsAcZFdrNgGSzzyy20cmfIlaLuuXzIbWr6Yqr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ecc956-551b-496c-3eb0-08da8c7c0397
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 00:42:29.1985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/CRrLIxWncdnzlrqO4zi30ZpECRWCHgV45G0F5KBnrOZ7i7qZf9NgZhN+kw3xIl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7302
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 08:47:46AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 31, 2022 9:02 AM
> > 
> > +static int vfio_container_attach_group(struct vfio_group *group,
> > +				       struct vfio_container *container)
> 
> exchange the order of parameters.
> 
> Otherwise,
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Done, thanks

Jason
