Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D46D9859
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 15:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbjDFNev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 09:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237561AbjDFNep (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 09:34:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F18128;
        Thu,  6 Apr 2023 06:34:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gtdj5LpLNdjzVdwqUkH9PXKG+nm5lnDIXqnVnXZx6UL09zAsxYkbeaViWqRRrBY26AvWaaAgo9YSGQ/YKe3fbJqbbrxdFFmTI/fU5PgtFqv06H8L2iC4khFax/d5sl08iCjNgr4qadxp7Ii2h3jFq/9i8MboQTpcit09sRk1axk4lNYi5XlmybOx5H0KMCdqP+pmAPy6ZbnIqmQzhHtHVuz5ot1K9c1362h/O0Bgd3Jyx3uxfOqQ1i5pMaSotVOOu3VIZAgiUH4dBVFVnjVUgftbN7sbFW180R4E5pNU9YJZlGONF4UPj0wRshoLf4V8Tgp3N3HZBnDxkLt9jumSCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71+S1cL3otDgbevTF9NLIuU741odK7pZrN5kbrXfx9I=;
 b=MUhch7GM/LpotM4Z7mPH7f8Mycc6dLB6NDbPWt837RnBHxYXF5NLtdNNCk0JjBRbGFZ1ZqrZ5Rf0Fc9NWrZU7mArZ39vPWHp8RQ4aRHsIXAyyniULZlqkx9dmIIguKdEKqguGDFEzGDWzl1pU8Zk9v+uavQKLK5Iqd6LUdFIr6sBX4iip8YA8sqdrcebCXRaYq39mjv1XklcDdzaLTajl6Crvw4CpbaHFY7Bvqu6+KU0rsD+qF7R4Lvu6QuVp2DpEaidXC5W62tF07yBET9UkQREjQYrNp+rxOubeDGIuwZsHLqPEKzQh5/nasbtWk/YSPKoh+JN0N85gJgiK4h23Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71+S1cL3otDgbevTF9NLIuU741odK7pZrN5kbrXfx9I=;
 b=hcYmziCKUbBkT/CHr4amm7yAyFzBry+mFqFwdWCnoJLHzjkupV0WfIHpawwJKUplHpaNOMEQCdKxw9ONeRqv+X/AQ7ZsWkEbmGUo8AE5WJik8iWKQJwp8XjY8xoWtypENMHZL4JqH70gGocErkEMNTI4/OKvXaSpLLXHkTM1iqD/LWuhVrWqfj5HqvdXfasCQrEBmLfIM+bW3KA6A78az0jI0bpAtlQQfLOCr1XDrRVK9Lfxlyy/NtemT+4KUmbTYj/1Mi1SjVrMwbHMzwpKJ+cYpuiH96dK6HO0whi3kR9nnTvPUzh/fenPYOtayRoQBZnhidxTv0tbTse+OJpqrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7266.namprd12.prod.outlook.com (2603:10b6:930:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Thu, 6 Apr
 2023 13:34:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 13:34:41 +0000
Date:   Thu, 6 Apr 2023 10:34:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZC7Kb3WmjvooWtLE@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VZkN8gI43+DHuB20"
Content-Disposition: inline
X-ClientProxiedBy: MN2PR19CA0010.namprd19.prod.outlook.com
 (2603:10b6:208:178::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fa73777-ccab-4c38-540b-08db36a3acd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vZ950Xkoi1y2+hk/VplxEJmbg6Bb51M5em6IetY7Ky/RoGIYSJ+P80YqJzcvhdTglU/y4t4TKAcH+b54Fu/DiZmJtFKjGxNwYh98HsS/S7FBdgagd/+4JFxaJnq4V/RYJ3kusWSUeESwFyqwv2jFjJtpBuSXfAk7hmA8QkRy5OPROhTmqMYazAz7mSEoFzvQaZ0aBtC27P6Qv6RNp2UHvhZZCqWRLNeXUzYkTKHbxK7PQA8dnpQ29Eux79owlb3pQfZzs7CHmKx12rxKWmIIfZzBQ3eiKqUIpnyJT5J7Xect9ckuSzGCqMMf2SMt49EXENz/jKF4DIIDJshNu2l0qvt4+mMXmQRMxPqN9DUvWcMKnGVF/AIavHdis6l9eCaMVW2Lw1m6Ax9usN9h3TLIypN72nAGwckWvE19mx+lj6CvKw9n4jLOw+hfW6bBWs5IPvOz0abbBQawSRTjL7CaZBW5h5rY69TEmukOBrLW62+wTeuxRQSUnXK9M78PQ01h1z0GMJ/ZdckbRSbOSwtLQ8DhhfTmSLGe8wJz+3d2F/D3v2oReiOD8CFR1u971VNbixrPdEw7XUNP9y20G9OSHJkc3FK9juFUxOo6Jo2EeaaQS51bN3+H2ztGyIPp+Gc4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(451199021)(2906002)(36756003)(86362001)(6512007)(2616005)(83380400001)(6486002)(186003)(26005)(6506007)(4326008)(66556008)(66476007)(8676002)(6916009)(21480400003)(44144004)(66946007)(316002)(38100700002)(41300700001)(478600001)(5660300002)(8936002)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YUidpTbvyAffv68LFq59Lb65Likd8FoAhyTPmlM75H9digIMhjU9ooLWynB5?=
 =?us-ascii?Q?3sAQcM34pmA4mKLaXItdmLNE5ZyOuEmoDjZO9qaU1zYqdrfgeGkGUZVblQ9W?=
 =?us-ascii?Q?PRD3P1Gk/6VD5nqqwVDbBqSgRkxXaYHOZZBFGrRihpMKK9K4iew1AqOHjM3d?=
 =?us-ascii?Q?MjiLmQk6eZR9z1icJIn6HMBA+AK19qt3Nn+l/CebCqhrsIC9uz/a1OhF+Wv7?=
 =?us-ascii?Q?za7Hw5BxQpHdEGLIEEtXV82tzmWDXkZ6A4XM0W316ZOY5RwVxV4c6+Q0PTQb?=
 =?us-ascii?Q?NNdpnqtaYSOkctRq0pQKaYY4ThHMPq2M3dr5ip6CdDLwR+P7zNS05WSk0yva?=
 =?us-ascii?Q?+ETwZRPDzXZMTGNPDMfmz2RUjJsq0rN4/0mlPqs6g4KvH+sJ6vfi0Nd52wQk?=
 =?us-ascii?Q?5EDoqDONZZATiTSkIePhYV7v69lhEnoK0vEMqvJ1zuLmJOztqzhClQd5xj0G?=
 =?us-ascii?Q?zU8/ZUYgeCqndeEmAAFvJLX5LYM6Dtf+LnMS1lSnIFtnHAdghK0h5gNQA/jc?=
 =?us-ascii?Q?T+tg+C4gPnXMfvz85BXxVPw4f2eX7naMyD5uInlq3ryyD7UxxEQq7FbDjZK1?=
 =?us-ascii?Q?QY6UMwVxubfw9V4S8SuJZFIlsV/GSgupkpFBxV3c1UjLoLBSw4nLsyLGGiYW?=
 =?us-ascii?Q?s16z+JVa22uDvZLYrSxAwiI9PPadNN+CPHcaNEoyk+RH/eB6McEUgA+KDXWo?=
 =?us-ascii?Q?2ly+cClz5ButkmobKsPqPiBmVFjlEMStw5z17g4XCFNptxnLsoauzj7FbTtj?=
 =?us-ascii?Q?ZQYQh78fbiN3UjAn3YZiv7dqR1rG38AW4Bt1VgOPrlxL8s/qeCl0G7N3qR6c?=
 =?us-ascii?Q?Danh8SX1+Wn/jYlczBBXReKmcyHsdPraOtKC5T/txezvu62906xvncVEsw/k?=
 =?us-ascii?Q?K4mvFnzMxxHRKssM4xQQc381uEHl5oIZeUcjxCRKNrFv4B+ykflQYp81ApOW?=
 =?us-ascii?Q?23c83pyaFHs2vt4p3lDWQUmQX3e49puD9Qg3GJgDj/f80ra7LcvkCcZEvO4w?=
 =?us-ascii?Q?H34nn6tH06jQdutC+pwQJiffh71MQTHSY34di6K9vD9j9eMIujj/k5gsol82?=
 =?us-ascii?Q?4f86aP6OpKgrVdhTtWlIK5fP/ISY6Gd/baG+xpS7YUzvWkzPSuL6mR/I+OS1?=
 =?us-ascii?Q?m6RmPLIOd1HvkDsxb4VAQaR+zvT5w35uvD2Bhpb1D1/DT4a2XXZjCwXCvHbu?=
 =?us-ascii?Q?izUGgLj5yuVZQa2rRREo9ygKyxITobHD55eJ1TXaONw6Fk87c9HN8TPkg4cu?=
 =?us-ascii?Q?vTrG5jmVuys7kHg/njre1GgiqniM/f0YeY5F6oDm6HGOTZomX6oIytwz9f1D?=
 =?us-ascii?Q?Ekb+ise3eXJmcAoC2Txst4nvUmDVy9LC3RAFURWlb+gHrQpZffwfYMQwVdex?=
 =?us-ascii?Q?9xsXV7K9a+/GG3+eWP4v4apRjiNmkiSq/xwFgYoBOBlM7fVvsFYSyAil+cxA?=
 =?us-ascii?Q?ByesKaXD9zQf011YQ/ZO4pIE6Rl4bZSGrdLKweeLOVVoC0Juy53ze/LljUda?=
 =?us-ascii?Q?Ep1UHcI3a6spIH5WMATJWVmy5F6Wcb7M0bjijZRxFk6tOaowNFgtoBELULYy?=
 =?us-ascii?Q?ws+vIhUclKtmK8vr5b8J0jHLtTe9EsF/eIbc/eUG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fa73777-ccab-4c38-540b-08db36a3acd8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 13:34:41.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BkOGs6yJhXYDuNsbY9yxO+hcTiwm+eQKBWoekT+LwhOWnCwq8AXcFGrjkXl8bax
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7266
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--VZkN8gI43+DHuB20
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Three bug fixes that a syzkaller instance found in iommufd. We added
some selftest coverage for this, but it will come in the merge window
as it depends on some other selftest changes.

I'm pretty happy with this as it shows the selftest setup is allowing
syzkaller into code paths that would normally be only reached by
in-kernel VFIO mdev drivers. These are bugs that the normal vGVT and
S390 vfio-mdev test suites didn't find.

Thanks,
Jason

The following changes since commit 7e364e56293bb98cae1b55fd835f5991c4e96e7d:

  Linux 6.3-rc5 (2023-04-02 14:29:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to 13a0d1ae7ee6b438f5537711a8c60cba00554943:

  iommufd: Do not corrupt the pfn list when doing batch carry (2023-04-04 09:10:55 -0300)

----------------------------------------------------------------
iommufd for 6.3 rc

Three bugs found by syzkaller:

 - An invalid VA range can be be put in a pages and eventually trigger
   WARN_ON, reject it early

 - Use of the wrong start index value when doing the complex batch carry
   scheme

 - Wrong store ordering resulting in corrupting data used in a later
   calculation that corrupted the batch structure during carry

----------------------------------------------------------------
Jason Gunthorpe (3):
      iommufd: Check for uptr overflow
      iommufd: Fix unpinning of pages when an access is present
      iommufd: Do not corrupt the pfn list when doing batch carry

 drivers/iommu/iommufd/pages.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--VZkN8gI43+DHuB20
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZC7KbgAKCRCFwuHvBreF
YW1WAP4iX4G1fZ3EziekDYV2arIi8yW0gYllXeiQrryzYAqKbgEAhskduhzWbV7K
D2Dri10YxHMgImBg0m08Ix4DYGiEWAI=
=0NN2
-----END PGP SIGNATURE-----

--VZkN8gI43+DHuB20--
