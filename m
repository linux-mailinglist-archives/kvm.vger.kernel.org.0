Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6EA53BE4D
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiFBTCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiFBTCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:02:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094E3113B;
        Thu,  2 Jun 2022 12:02:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pgh30/1URmC57shw42PN+kE3E2Ik6WRjBaU8m9YxRdBxmu1Bt+4Gu9Maeraed+ciVILi/qTxmrRp6j2v8VBhLRjsfE7H8Ji7K9/zgcF9MiHRIGfnk66c4W5XdsLAwqi8lIdFgWA0NE1wZCOmdSbhDqjVntmoiILB9njqhSbbF0byZOFdQwE7KaHlP2GXDbvwGvtzBEACyR4LB8L2H7JejsqS5N7EO2MC3cM4WnWcbMy83lg9E2jWxp6IPgSGfhMwUjJxQIA91AFa7FgJ230jduYyI1JSlw7ESlmsWiLiczqytmMMVLszZ+mH3mIPNpLqAHBbNMTmsyXIxuIt8OjAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edPFFIWwoz7HRa0kw7mOt/Bq70cVVoX9Z0pbu4AjQns=;
 b=lp1s9CWNukTz3YKu+bHq+ysbdpV9H3HDuaiegXWMxQwee/WPZvyOXavTXkDAAQb+FcdmBEFn05HvV90559g29Zvzl9TW7AINQfZE962+QUKHvklxX+lJ/SK9apZknG4ue83OQmn0jRqdGUgFWZL8skdWJ4CoO0inO26NP7P3+NdD1gfqC4j1Pq/lHv2QQXNPKQ9JeebxG8VrgazxgkPtQWC3JoQ4Ol8c9hNqGPcHayTDlg2HiWfvhVoZDxzcbL2fEuKZ9ZjumZIfwJn6uiCv9KSMPclr8cRs4hOIETeDOJfKVyMXxotPdsal6cBDEwimzrDxyfvUDhIpyfmcMMJMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edPFFIWwoz7HRa0kw7mOt/Bq70cVVoX9Z0pbu4AjQns=;
 b=kbBsMIWJ/F8jyZZsuJmJE3SNAUgxUkuSIfeAwClzR1GACmIuCaHLfbVzBUT93PjpkanlvYPr+8Cvj00IwHuYkFyVe8BUMt+g3DlB+PxO3Hx2xrBOaCoGALU2x+sw7Eb4SC1tu5/gKfmw4p1uXvwGkOQfpzibI+N0HRPa85z56bO3puXBie392OsYmcW36RywW6N2bANcFFfzpVlWB1hsk/gkZSDy1gNBfZjiq2+IXPJ6Fmy0qYeJ5azN8RtPzxQM7s7wUGdLsVzqEFaSyoYQlUrJYe+1BhxpJ2CACvkJllsQC5zkVbG65TuC22NZz4wHAqq5GAZgOUH4iwcVdQptrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2662.namprd12.prod.outlook.com (2603:10b6:a03:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.15; Thu, 2 Jun
 2022 19:02:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:02:35 +0000
Date:   Thu, 2 Jun 2022 16:02:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 05/18] vfio/ccw: Remove private->mdev
Message-ID: <20220602190234.GB3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-6-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-6-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0192.namprd13.prod.outlook.com
 (2603:10b6:208:2be::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27bcef7b-761d-4933-4988-08da44ca74a5
X-MS-TrafficTypeDiagnostic: BYAPR12MB2662:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2662C141D87D97792D2E992FC2DE9@BYAPR12MB2662.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: so/4mFYrju9Oewp1DnH3tYYhjlyJHDzWDgJl7qk3BcyKVGf2p12Yw3Z4NZ/Qyzff0BmMY6NHM0nXzI3lIkbdFNbfu9kP+WXHA4foCPN/x8SUpbkKyt9/NM8kPiAa8NN7xKENhXD0Px5f8TWeH/E7Di8Ue7nCudns3J4dpYqVfGOhjU6tOFC6TnuAQEt65vlbeeeqcAuPpusXckEgNk2qqzTi8Z6tJdxv0fvMRCf79aKYoUkvOUjvGrmctTblmX4WFSsMVKv7Q7FglZ/zfRqQwbtpkxjEVTa0sqevdJrAFjR//VtkwdgI1VDgqyvF0nKn4SfNqgcrJLFHU8NV3cQHgCnCmui2OgvlOsIGhK4v1hLYyy3N7OoiNvmuoPyNIEa/POM/E0lhrgATt3afj0wKSX9TQ0XaL9y2l1xI/d/Kfl4UAVQ7PjdR50cgbi4Mi+ZtIus9YmA+slxipAr1hIjg0BZ+9cy2cj3pxb456bEhgAj51Ay0rT65GMLzHEmraQ1gUNIBff2WPXr9JzjSLM5ZcM+2VSS32Qo5zorNU5HoEs6PzAsJwNoGS3eX2BV+R2mi0mVKVxexMAVDxm7/PUR4sIlu19zf+tvt5+VS5GaR60umsjaIwNtN0Nlwa6B/Xp/JIb6+c45MDaNQUFvIJ8ZDHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(54906003)(6916009)(26005)(86362001)(4326008)(66556008)(33656002)(4744005)(316002)(2906002)(5660300002)(83380400001)(66476007)(66946007)(38100700002)(1076003)(8936002)(186003)(508600001)(36756003)(6486002)(6506007)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pznc7h3ZqgehXI2iTpizqtlaKtajFN2x8h+LO4pFm2WWfHug829QMllFzc/X?=
 =?us-ascii?Q?jL2bOjeHOuNUmzcTjp9LFCnv4jqDsFCpGCJFEQyYUsjhBDILQbY0O9Xy+jlf?=
 =?us-ascii?Q?YnybNZi0LUcsOnZ6o4qsYALCyWQvM/gjUr2W8iwVj//rVDXlY5Aod/R8vFor?=
 =?us-ascii?Q?yNjlnadsL3MLoEeydEWglvcEuvqTmC6ekNoYEdrmYM+Gj9pOLsxc79vH0X5V?=
 =?us-ascii?Q?hP4FBPr37Od5yC1A9QMdUpiKszotvGydCetWi3LfTaTxmTfujdMn2PkzyyrN?=
 =?us-ascii?Q?1CGBSL8yFbnllmdbSxR/bSIbN194Xt3s5o1sFVR7AvfanyboPSJU1nRoHhvV?=
 =?us-ascii?Q?pQh37azP+f9Y4zJn5D1y1Bc2f2Qe1XZqakkHPWXEtHVD598NCxmiVqRCrwMu?=
 =?us-ascii?Q?pyfeLFNPFKyhnWGS6n6WCsA4Jvd1Ren97zHA5v1vIwqrt04s1dUMEB6nKE95?=
 =?us-ascii?Q?KH/QSyL0Y1HXHP9zOxGGKTcvyGfs0l80V4F7ewlCeEmoqKDp3k6i+E7SJ8Li?=
 =?us-ascii?Q?JRdmuMj7gIpxhrZJmVa02WMzMZChR8RNtMmzNjZofad0yzp3Jj4v9tNYJ2xy?=
 =?us-ascii?Q?IXEJmgtR4qhl/BboOa/pZo+dLjcYX4qQOcvN8S4hlKO9JztowjvEUnFSHrd/?=
 =?us-ascii?Q?xHrcf0XJszR2AdnsfcXAurPN1yeH858s90MDgnGByEwS8AePBGN9tPQwprkT?=
 =?us-ascii?Q?jd9+GiyBUcb+IY75yqKRaLyA0Qse9eirwsFkkuKKUquImkylGhAGBWIBK+w8?=
 =?us-ascii?Q?0Vz2GAvvMpnHcf3TbZNueLumDdzrDpxFLjoUagCI3eGrD4G+5rb2B3taPQ4I?=
 =?us-ascii?Q?EbgjUiUiuM+SmOEghoDKXFRP4iHBSuAtvvX8/f+MVFQF8T4TExVAWMEcTxFM?=
 =?us-ascii?Q?q1U9fjEjjZl2j9kwoEIUHoCa8q82ZADLrxBoQBYxvs2OJYT2AR1YPIt8ZPTb?=
 =?us-ascii?Q?ktq+a9Ao+0Q26BvbXiELCxtXyeNeCIBmT17ga2KqR4QrgEsYZWkPinheJvc+?=
 =?us-ascii?Q?zA5sWMfihQNASArvtnX/Da04F/wO2rCHLBUYW/ZspjHy6NIQi+EQOgp1CfkB?=
 =?us-ascii?Q?aLq9K4lakGJ2TxV7C1RB60BSxj+6R3r/ArrVZVm8T8wzdU7NsOQwyd9Qh/PZ?=
 =?us-ascii?Q?oTn2Lzpt9LVzUMOsp6tP9P8G9NPwUBxUvRav9i6a44PIwWcftOor0H5SywK3?=
 =?us-ascii?Q?VuNRmp5t9z1e1eeoyBNsyHZkkSdVBma2rzD8AbtwUMF7uISIOsLQIDmdKzVg?=
 =?us-ascii?Q?D9KEmiqdOschsEmU00ad9NVzo/8BjkEdb5jlhU/yH8M6RDrs4mU63dt9f639?=
 =?us-ascii?Q?HMzsV52r3q4taeQi2WG09KsdWUnXtzp6oABmkXz82OtxDUEUDQZkEOl/tP9h?=
 =?us-ascii?Q?6kNdcRSbuTmyPSjWxouor7FWzkjWYpz3W2vGBwSozkb6avRhn4bYJbcTS9gN?=
 =?us-ascii?Q?gEXk34pHrncZMPdzjGG5/wvMsbDQqTD/fWn5XE7y72ooIxTc16mGaqi2Mz/M?=
 =?us-ascii?Q?hdg+jhAocXyiyGZBkozJ+nH3/q9CpKPIU5jzX0yulnIt+pPRAb0N5PcFbIEk?=
 =?us-ascii?Q?HVU8LRiKNwAGGbHZ2yXkGbPAZZDG5BScvWRAb3C5Z6+4AT/H0eDYmCbKizWq?=
 =?us-ascii?Q?fWgGShMxnb7VsuLVba3KBeWVl1YOKNEAR3IzYzbGCAuwrl2fLj8yd+hwgdop?=
 =?us-ascii?Q?ULsmBfgEQb7jBPzNfdcLkI6wX45zkTO7cR52+wSD0gqS4lY5YljZeeTVdaLQ?=
 =?us-ascii?Q?KSL3hMTXmQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bcef7b-761d-4933-4988-08da44ca74a5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:02:35.8511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBopK5SDiEO8EZAjXAH7DzjoUvJxoaqXjk28pkMcT8kXjTvXs74g/qx6GzxDD4x+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2662
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:35PM +0200, Eric Farman wrote:
> @@ -262,7 +260,7 @@ static void fsm_io_request(struct vfio_ccw_private *private,
>  			errstr = "transport mode";
>  			goto err_out;
>  		}
> -		io_region->ret_code = cp_init(&private->cp, mdev_dev(mdev),
> +		io_region->ret_code = cp_init(&private->cp, private->vdev.dev,
>  					      orb);

You'll need to rebase this series, I already did this hunk in v5.19:

commit 0a58795647cd4300470788ffdbff6b29b5f00632
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Wed May 11 13:12:59 2022 -0600

    vfio/ccw: Remove mdev from struct channel_program

Jason
