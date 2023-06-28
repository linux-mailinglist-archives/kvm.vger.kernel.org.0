Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE31374135E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjF1OGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 10:06:13 -0400
Received: from mail-dm6nam11on2046.outbound.protection.outlook.com ([40.107.223.46]:2656
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232324AbjF1OEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 10:04:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2P2kmIzrnJ7X/0aJzQX2/pNeNQVTh9RL7FkhIRunt7qISRHhoegL5M/Ju2UQprT1twpGpAPn8SAxT0QWt5xZCCDYrks2LxtBZfl62fX5nhfsqaZqC0VYeOzgTIiPAguXp9U1Qid+b1l5MQS+sn+sdVQxoE3FQU4AY9NWpunyH9oANfhUfUK0iOoK+r+ptqgkN/IikgD/4dk/oZ7H+9C4zMIC3PTn6tRXtOajcUkVLc5lg0csDNBm/yUQrLCmoYdnOGwolR1+00Fwan7oCvg3jrSNboAn2tqbWIn3XpHEZHoDr7EmbpRFpKF6HxawZVSt27orvptlWskGkV7iLQp0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IucQlX55L67vBzNdhMn18T0uBLztL20FhgV2dGpiCVM=;
 b=KIMvLyGgzkHUcnOgpmBzNltdLdPiXd/tq/pnmNPQSU5CmBdNGahtpRbUPGqECCVBnOWGN6suVry60WtvFegasv25HyHVfPViYViYqFYeFjwucTLVWq0XzKIzlcLbf3VztBIT5wj0WMWKK8j/A99/eLwgos4S9sosUrHMBwDQCJ9Fr4S/QeGN/+Y8YLeLdlWZPHAtSeVZZoupJC4xajbq/55hZrp28xwTzBad/ygmH5KaRmdlUobq9KaQSaVygn05W0AJ8eEYivZx/eYJ+AzXn+rdBsKWkfUVpgVr65rUTvn3wGSBJ5bfzUwnh5Ipg5glVGXr9YnHrolr3/DRuA8HKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IucQlX55L67vBzNdhMn18T0uBLztL20FhgV2dGpiCVM=;
 b=MKPiFvWDYvzZJ3vSNauwlovk5dkv5EVAj6TIdgltruV9ym9OLqiQ8dX93y/+obN2KTS80rJ2IBdPfnRPU1gqBQ7l5gOCNWP197w+1dtddFJjrC6B4+5qQSO6CXAR/1AXGMHnpOW+HbOZ3vYeLxc8O6cPI7ESblUaEi2AG7Hjf1cmMWbKFo4NRFfnEHTTsutLdrXBcM85i51MJq6kKDuCucMRYPpsmopth5U5Q6vKEnFsF/vv+M6LPEHU1hlDQF7WMq8Hb5v6C/fsKqNZOxmZqrdjfVJeMWk4zbp5+fYbHp7T8sg3YW6LO5BtC644R26YMjgCh7yEkiYcUdlzxwvrPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB8091.namprd12.prod.outlook.com (2603:10b6:a03:4d5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.45; Wed, 28 Jun
 2023 14:04:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Wed, 28 Jun 2023
 14:04:22 +0000
Date:   Wed, 28 Jun 2023 11:04:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Subject: [GIT PULL] Please pull IOMMUFD subsystem changes
Message-ID: <ZJw95Knh/UEL6vQh@nvidia.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fBa45IcIvgw6RvFK"
Content-Disposition: inline
X-ClientProxiedBy: BL0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:91::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB8091:EE_
X-MS-Office365-Filtering-Correlation-Id: 0746e171-695b-413d-89c6-08db77e092c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRkOm0v0zkvBu9RAPF+mEK6MyyUpT3pHcCkLBVngFWmku7Er+zoTCf91hNUZX91viUT3c/ccesFTfii5GAeHfHzxD69di29OAUMSwtLOHfs7BvMSmjnKT9QMprfpmATa2woD5JuvJejDqE1dd1ij5zB74XL+J/Pj6yUT92PhsgqQM/I4bKIn0muFkZFl0nGpLg8Sz83bzJXgDb6X83CcWQNJgjCKPjcFsrs60XImaG4FkHLluUGghLSTzzbYRePE0idbzV0ghLMIIuHBS40Nq3NKk7V8ZthsXKmQzftTcKcpIk5IbjItH+NNGXhZhXfKponb/SIj6Qae0K/J5p0MDrC0GB/7ikv3wCN6SdOw4IReeCn1wS0jZWL8bAVdslwMsT+XPaSpzdrvA+MmUKbgUzx/1XMrFA6WXAPphEzsDTicoh1TlbvlMBjNGpXRNa5irLJ5swWkQRWGsllaP0uiD6vPWwmVkTA6CKgc4YJFB5DLC7U0bhFCvnQx+MapHXCy44ts/+ljHIsXJebnB0Id590HtsYHqAfLRfnY6JKQclkJH3dWCvxFKkY7ZcVRvOErS67q4uAnfHqf565eLmdK2PFtGiPMWAxta5uoVoI8QfmdgsuQSLtpmJ0f9JEPb0DY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(451199021)(66476007)(66946007)(66556008)(36756003)(478600001)(2906002)(316002)(8936002)(4326008)(6916009)(8676002)(5660300002)(26005)(86362001)(38100700002)(41300700001)(6486002)(186003)(6506007)(6512007)(21480400003)(83380400001)(2616005)(44144004)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tLvoGKZl1AZAf0vM/+V94RT+cjXzp1pKaqh5+puc2ZTO8g7AHGbCEdvPUZUq?=
 =?us-ascii?Q?8jXcL/fKiUJbXKnBc7WlrnotIVZtjcSqZXUaPtWCMqFRqURPo3HhjvfgTcJ2?=
 =?us-ascii?Q?rEW0NHRt3OOjFMXNAKjVuujuNgizRTl8+jkILEGD0YBSLAQ8anVwLwoIpBri?=
 =?us-ascii?Q?VG1jHCJxmVLauHUTiNXxS43EjbneIr48pgikMOzgov0d2P+VE2CqdnhEm4Ud?=
 =?us-ascii?Q?mZeMPJnOraB5LbTNdIWenkXucxoHZZGpDDQglXKfEpTlWujPSfqmb8iJJdrk?=
 =?us-ascii?Q?/QgnZxF31YBRY3uiD+UoHN43VRJgVqEzLAoECFrs7FnM6VT4oPQ0VIee3iJ9?=
 =?us-ascii?Q?Givu62R7aIEpAt5FdIhLY7xXk3AijNKqbXjmVJIV0oWBOQUUrDMZK1nIXeN0?=
 =?us-ascii?Q?QT4Gu1lubDwv83aUPK0PplxbASsfnfWlYjVENtU49tR588M/k70fpmn02/+a?=
 =?us-ascii?Q?1noxQ2K9VAa5m8Yvi/OlLI1BEGNJhX7LoX4hg1boHQrniWwHQ4IKD11/acEe?=
 =?us-ascii?Q?08TDFABINnoutBoqDm+VJPFm0y3q+9K7u//gGv7pRCfAC9mNnrWAV32hp8mQ?=
 =?us-ascii?Q?SZKFxl0xDnAKtvYyFy11XscyFtCq77Nl4cRg/XDzMWkNow4wM9RMHBB8PyZv?=
 =?us-ascii?Q?lugsQW9hcdz0oFNkl96k8/+W62pjw29CIdJDmAEZVZpkeAC7hktJ/VH7HXmO?=
 =?us-ascii?Q?1q0Jc/lXjUowELxcx8OrEw5GMY/he2rlg5T+HjBLHrTNdPlKPhtTIOzqftBT?=
 =?us-ascii?Q?s5/Wu3QQ5WBvejfTfLIeoa7SNUpq0ymXX6fFq688PtYPA0bdV1+Lo8Hlqr/Z?=
 =?us-ascii?Q?rt+TW/OmBcBTo4mZ3cgm29jzrY/YZrdwA/nrWi78SQ6lHIdoLW9ozVtHEXs4?=
 =?us-ascii?Q?hoPSOVJuGcaXrnCnEq+DJWif/FvMXf6iZTjv3+BCUYAF5Sd620JUVVqr4R8u?=
 =?us-ascii?Q?9ioEi/xC54OpVyHkGNK1uz/Dk3Cq91jkXU6nk5/3xjPLa79vcR0Q5Ukb6r3b?=
 =?us-ascii?Q?xSm71Wa8DNmxJp3ErOgt5tx5yRpqN45k6EfQCgUyZm7BM3FxwN0B+V2GmLNj?=
 =?us-ascii?Q?vxa7lZMjAIF0cBMbd0hHi4GePfTSmXjmv/Bo/jc/Sh+xUqdgWdWueR/Q9R+2?=
 =?us-ascii?Q?hCUVVNeUsqPJtv/GaR1uMUqEWo5NwIE02+BLBUdVGKiWR/+sjtL374OJ1AzL?=
 =?us-ascii?Q?GJYH3D49jH/r2NGmYGkEVwsPSmpp2JGZJYZp/p7uIixpgmfWDIyBkYIlN7Da?=
 =?us-ascii?Q?Rx36Wbosm3Nb/gYh45Eka9pInSdfIpdVkg+Goi6JU/wJdx4oRP6qbpbpQj13?=
 =?us-ascii?Q?q0aRkTmwCqSVmnqnSAnAflzr0BbDKp3+tqa3AigVAWCAi3zxfxHGwuS2XbIl?=
 =?us-ascii?Q?XXqB39VesmCsIZlZcAmWPD8v0CBhN7DunsDsFrwIqC0mg2QF/46sHMDXnmV/?=
 =?us-ascii?Q?lPJq8kikOm1ySodn0/bys+UlozwC5yCFgM88oyhTnpGoKMkCR98+uttUCVd/?=
 =?us-ascii?Q?qRT69fG/NwODG/pc9yZpmfOnP+3IB0VuA0WD8eagKUUSwpYqCpJ3PFt4SoyB?=
 =?us-ascii?Q?cCoyYFVjBnxCSkVOfr4iCERTZNEMSlEjPEG6TH2y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0746e171-695b-413d-89c6-08db77e092c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2023 14:04:22.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 53QB7hLTlT1/7xBISYWo/LDf+f9+zLtUQV7YVJVwoqgvWUDlwWWJNYcQVhnWCxnu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--fBa45IcIvgw6RvFK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Just two rc syzkaller fixes for this merge window. It looks like the
vfio changes are now done so we should see progress next cycle.

Thanks,
Jason

The following changes since commit 6995e2de6891c724bfeb2db33d7b87775f913ad1:

  Linux 6.4 (2023-06-25 16:29:58 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

for you to fetch changes up to dbe245cdf5189e88d680379ed13901356628b650:

  iommufd: Call iopt_area_contig_done() under the lock (2023-06-26 09:00:23 -0300)

----------------------------------------------------------------
iommufd for 6.5

Just two RC syzkaller fixes, both for the same basic issue, using the area
pointer during an access forced unmap while the locks protecting it were
let go.

----------------------------------------------------------------
Jason Gunthorpe (2):
      iommufd: Do not access the area pointer after unlocking
      iommufd: Call iopt_area_contig_done() under the lock

 drivers/iommu/iommufd/device.c       |  2 +-
 drivers/iommu/iommufd/io_pagetable.c | 14 +++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

--fBa45IcIvgw6RvFK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRRRCHOFoQz/8F5bUaFwuHvBreFYQUCZJw94wAKCRCFwuHvBreF
YdxxAQDgT2+DHJWw75aXC14icZTTqRoDECu1QBJzU3MCe4p1WAEAkPATNrM4iRhn
PQ4sz4WIEKzrAaEa5E86mThblvLRwQc=
=H2MS
-----END PGP SIGNATURE-----

--fBa45IcIvgw6RvFK--
