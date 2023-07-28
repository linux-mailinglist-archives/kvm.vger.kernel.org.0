Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95266766EB0
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 15:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbjG1NsQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 09:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjG1NsP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 09:48:15 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2262B26BC;
        Fri, 28 Jul 2023 06:48:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FFlh5jIvRqXRHPZgRfrUxnrjR8XwQzvu7lph7wZlAHrB4z17shlecKkaDk8lVw8h91qGIWNCVZFJoipEsl5CNUb/8JOqpY+d7uSxJaGXm3dTqojnL9jS1vDWrNnGPod9HkWHUM/2sXmFYADrWZ4GikX7R+t8p2mXNqmpFBgUOSurnxoTKkBSj0JqiafMZ/ZkeRN9JYxKG2tMjcMsoBIxvjG2gC9Ido+/ROWj1GXC+2LcQLNT6OF2cIU23+VWveFoM/iaLiXkAvzSeOUPAUMVL2iUKwpzKqnia3qdp+LBjxRE8xUOq+7iTxFux9d5MDZBHfdfmfPDp2VRPyakfS6b+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TM6L6VrNVCyn7jSNkQoW26eRxHBDodfHCk9Sz8PtiVs=;
 b=VQ0KGm8TWA/nBDZIZVPyNt1m6CyL4MNGpom3NvgT3aFFcJ7tNyHhfTUfWC5JFLrmGECvqeUUJ8STwAP9C7MBT8k0nR2m12bhJ2XZ4rp9Lk8akYP2QmLBBpf2kqvudQq9mNdqoJnI4KLy7QYLXyWArYa12Si4y5eky4CD7x2SE3h6HEo8TI1gqH4km6TiYTJ8XEqJ+fsMaORrsk6yoLslG1sq0lpyU5aQ0y/WF+ntY8Y5geRLkqLcHnbENVtLD3pTDJ0p7xK5oFbo5aMgRZ9amL/iTqJlGmhIM97kibx/BF30TU9lYZc2Fd3Ssv59+OeTDFjfE2YUDAq5eIH4Np9DAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TM6L6VrNVCyn7jSNkQoW26eRxHBDodfHCk9Sz8PtiVs=;
 b=S4SIFS+x8wMc5rUL+2TiJfm302e0R2jfiPxRL0xoyKCDVcSgtSB2KVyU97s3O+rh9iq8GD4kqosBnID5gSbcgQ53v6QRqMXPa5dOTUtOU4uGofe4oHsrQkASeePC3Yx4YhQJh5U8dZdzAYRrbkw+IgFquYK/84ky+Phku5yHE77n2N/AEqCASqpfzjaRSEr+SbLlECQl4zT08zbqj1+Erl8PNUwsn2GaUZEIFRUaL8U53KVjAVIKC/+y64QAXjdP4RQypHyEoXFJ/UrqgRe5ApruewMf4vr8ELWk5HRqcallj6AlGWGl2rHlkPRta2ax6nQTJKeZUGX+8/O63NMlBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Fri, 28 Jul
 2023 13:48:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.034; Fri, 28 Jul 2023
 13:48:12 +0000
Date:   Fri, 28 Jul 2023 10:48:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZMPHGPLDXK46QF+K@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="df26bB5sa7yRDGke"
Content-Disposition: inline
X-ClientProxiedBy: BYAPR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:a03:40::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4153:EE_
X-MS-Office365-Filtering-Correlation-Id: e92029fe-5271-4d95-91fa-08db8f7148e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KBgC/01R6+PLeGOmbQW+GxbgR0zpqaF42/fwjnSIjIlP8sCTgyVWhGHNy5aw9Ml42s1bJymJKGxqoPAs+/b2xPl5wjIQ7OJiQOzskbzQ9gQyocYw9EU3VbqVVRhiEiJciHRYyMOqVhSaLubNFcO3QroNkFKJO6JKhGTdzmknLyeYa7JV5tFqkwtbdxSX25mBZD+X8MXzpep96K+GiXFHw8cLdnIIaUYPLt7DhYO91UQWp7rccdHb67eIwKVzxkTgGD7FLXu3YVfafMTXYwJ6u+Z+XhsQj+VhO5LOspM3rE4ItaUoQ+3UiMZgVprjm6BTOvI+ZeN5pgq3iHYAcOjvWnJ+hACemZ/TMar4T22O/mR+w7is7heBE3htV1ZKavbn9ntBND0ItIvUEwX9OJ5W/M0xDcoz1npWj7KPG0F0YBuGLKqrVoqArfpKK5yZcHoEn29W/IPK5WiQbMs0o2lW8jJtWlciavVVv5GilcID4teLjA7uPN8cv/E+wFq2+hn8gId/xTZcSbFHXhOmvM/DBvIZUeX9Dj6VF5ROg/UAUQ6xa8Yj4y87L5xNnsQezMAUUBGercbC+1J7/1xbWNPR09Rpd6vn8/rndsKQyy7LUL2R9wEPtAgPsg7rEePauzDitmPqp2Ei/d5grGnN8qCWkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(451199021)(186003)(26005)(6916009)(2906002)(4326008)(33656002)(316002)(6506007)(83380400001)(36756003)(41300700001)(5660300002)(8676002)(8936002)(21480400003)(2616005)(44144004)(38100700002)(6486002)(6666004)(6512007)(86362001)(478600001)(66556008)(66476007)(66946007)(2700100001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e2qgzkApgE+B5IcJUc80TPSN/9drEIKVBzMKRtLKMHylmBCFZ32gL6qZWN9R?=
 =?us-ascii?Q?NSoXL7A3f2O95nr55zPpbLL+hNzrEN/rPk5SnXWXSeMnVIksDdkWNK5PNu8b?=
 =?us-ascii?Q?WmmfbhaBbXKZIpOJrRv2y0xUcHUmHDHqk6KLWU7uDSZXsDZXpzyF99G+N5Yz?=
 =?us-ascii?Q?otpddlZKnUMVcqJxTif4UrzQITRQSCT+YkgkqkH8g6ezYG72ylM3O1isg6je?=
 =?us-ascii?Q?xMvC58d7SZXJQvaYoNGT/Q7zNio6245U9DPnLLy9n3tdKEOPAP//eibypA3t?=
 =?us-ascii?Q?g/2lf0qzuAuy08U68IHfeJj37ISbHy2+bFk57P/P0gXmlOrhmfS4wHGgaRUo?=
 =?us-ascii?Q?GnavLJOMVZprTN3DxHjlXkoblhQI+GgWB4xKeVWzXc/ck7V4Adw4UuUSTB24?=
 =?us-ascii?Q?mqsmw+XoeZBL4A2WTcXz5z5zqLaTX1976sBiAUsdj4KwYPEHHxYFA649BEc6?=
 =?us-ascii?Q?0n/rdld9+PVFPKYqiqScVLUFdwQz3BcHXs+qtLrzpzjAYCa/j98M9mLQltaP?=
 =?us-ascii?Q?QNyMK3GIXb0EE4+eDuuLGMxKZlvnHwNBdm0VG+oyL2Ec1wL1o+s0/mESoLj5?=
 =?us-ascii?Q?lXFCVNbfctnLn2G/j5Y0XwQJ9Uit62jTkO6uOx5Q1OZrjBm36auz2DHsPqaa?=
 =?us-ascii?Q?CbjmEfved52/yma761AFjYa9xT6rYETvhC9VzQKubRySJztGG0atVIWjK94g?=
 =?us-ascii?Q?I+AofYAA8kprg5A40ORMyTYGipMBZqvBVqseR39IJFgj+FS9WVa7VNI0Oc2k?=
 =?us-ascii?Q?EKokRqUQ5Navr2v0JCu0s4GW8JVMK7ct+yunrsANjBFKIJbAs9sxJCR/nFUa?=
 =?us-ascii?Q?/0ET+/DZBphdHcPrOBiFG87EvfH6FdC981+P0GMPUmGSpPyLL2m4hFIJUuij?=
 =?us-ascii?Q?RoYiaQstkKrcx6O9NasDLc3v9JzVDvMJMSDis4tTk1/WkKNU4kanfn9xHSKI?=
 =?us-ascii?Q?RmZLS5p38WsuAJ8b6CxxRE6pLbwiwpPVLHVEfq1PId8fUJRWoQzbLO4J7vPu?=
 =?us-ascii?Q?qlixm3jRsTrNB2bhB68tUzID+HkBF77N1/JILNo1D60eS4Ivuekgs7SxhX3V?=
 =?us-ascii?Q?1DbCaRw8t1IfNWD88v8RV0bu/cpHyLgqIq6E3XWgrjacdDmCQmNWoI4ishgF?=
 =?us-ascii?Q?ageHNe8oAZO0sjD9sZzB6U6bXuyE9+krzWiTrWx98sYWX+4FhcTTacMb7cFV?=
 =?us-ascii?Q?MSA4I/wiQLfwAfjTgTwU0j8xH6CUgjpdEzUrB3YstTCQCaNI8kObETkvQ84+?=
 =?us-ascii?Q?tiJ83YN9GfioqMnOKXKwhGzKyfgKcZnm+9CFmuwnofGPjGecKt2sYlL5vdPH?=
 =?us-ascii?Q?QWdXkttw3eeMK6EiyT28Bwia3YD0ze9wCUq7VrCaM6LYyrLL7Pt3Va39UAvk?=
 =?us-ascii?Q?NG9df2fZASoraYitqw2g44U5l8g8gZ60yi9q9tcxLWLKNDyjoMk8408GM3f8?=
 =?us-ascii?Q?dVDr+ZlQ+BkiNm2x3MvrYgog46O+0BAL5yGrLjMDIM397R5qTScnKbEULU/L?=
 =?us-ascii?Q?1cOIVKIAybXDhmtuhQmZDUtOGKW42d/mM/e9x+CQ5oSAkucU2QvA1mOryQrP?=
 =?us-ascii?Q?wVkss09br8udZjKv2eSLGAi0WJWmcG/66jvkV+co?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92029fe-5271-4d95-91fa-08db8f7148e4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2023 13:48:12.2758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQzirxTjBB6DQPz+rbhgLroQSGL0KPrKTeihCC3UJAqIDP9BbfLMzm0aj2I54N3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
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

--df26bB5sa7yRDGke
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Small rc update for some recently found bugs

Thanks,
Jason

The following changes since commit 6eaae198076080886b9e7d57f4ae06fa782f90ef:

  Linux 6.5-rc3 (2023-07-23 15:24:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to b7c822fa6b7701b17e139f1c562fc24135880ed4:

  iommufd: Set end correctly when doing batch carry (2023-07-27 11:27:20 -0300)

----------------------------------------------------------------
iommufd for 6.5 rc

Two user triggerable problems:

- Syzkaller found a way to trigger a WARN_ON and leak memory by racing
  destroy with other actions

- There is still a bug in the "batch carry" stuff that gets invoked for
  complex cases with accesses and unmapping of huge pages. The test suite
  found this (triggers rarely)

----------------------------------------------------------------
Jason Gunthorpe (2):
      iommufd: IOMMUFD_DESTROY should not increase the refcount
      iommufd: Set end correctly when doing batch carry

 drivers/iommu/iommufd/device.c          | 12 ++---
 drivers/iommu/iommufd/iommufd_private.h | 15 ++++++-
 drivers/iommu/iommufd/main.c            | 78 +++++++++++++++++++++++++--------
 drivers/iommu/iommufd/pages.c           |  2 +-
 4 files changed, 76 insertions(+), 31 deletions(-)

--df26bB5sa7yRDGke
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZMPHFwAKCRCFwuHvBreF
YZ+IAQDERMYTrGDBzfSLqCJDcqvXRf9ZnJu9zEP7cAUSmEgASwD/XtcklA+dp7ZN
X+zuZv1QL0W75q5C91B+gJ1KN9MBKQ8=
=5aIs
-----END PGP SIGNATURE-----

--df26bB5sa7yRDGke--
