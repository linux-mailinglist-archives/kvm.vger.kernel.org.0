Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9735351507B
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 18:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378486AbiD2QO6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 12:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbiD2QO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 12:14:56 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4D266FB2
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 09:11:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEnNApeqQd3EsL8ne5k11909YOnX9ITeQvXgNnR4Uo7a6+9DV2axerf0SJTsOIkAE8sLNIu06EhLaRJrctegAVbdnRTeK0PTU9cyA1Lws6uOxZpDrJyfdDnnNEtCJzeaBBlWzMjV8et2yfdaUPK9gLK+X1R/RYpnV0CQBaf92KAYg7EZlhPVwLH2JNuJmr38Rn29we8HXPEktis7hK5mIYds8Z2vwwlzcs3z3f2Dd39Lq7koBHB9ZqInzDfgF8CCU/QmMCkTuVydNUAieywxtCiASYEPRvUv32E1kIS//gESvhmhimCPw1zC2v3v8WLDZctxKBdhVq2H+2EDhh/uSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhBtk3si4KM1BaXNGuZwgBzn1bx8oq8nH+HkEZH3w8g=;
 b=Tr44d+TbWSnBNYaCWH0e35Bm2GVgW+GqWAC2Kzm5P7WyhQsc+63gNd3A942zsb6muJY+fVx4Mcr1OPpPTJqmE/6PHyKXCgceiLq6gFaOrOZ53tDyavJ7RY5Qsu3agJH+UGK+DjWKUU2gA6Pqv3VngdAglbvUjiM7slghy20+02V3yiHzGSX7RBYp6YBHj9kDvKMNI+9uIUrrJR1XAfqSJGARfAWKgtKYD6sZsaSyeeudQ3heB5FWXPe+LLdmhWrOwr2+giwxGVS+AC6xAnUGjbukXSU0VWODPM8tOeB6tlvMy6sg2p+oO1rmbK7Yk7ZnAq+mDXw+6c6tfCoWp5K68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhBtk3si4KM1BaXNGuZwgBzn1bx8oq8nH+HkEZH3w8g=;
 b=rKhsITECebvnPs61pt96QQ4uuQLeATsGrrj9ePbc77ZGBQQntBHVmnN7QzygNIqz5rmn/6l3ZBrPkbDkPP1ZbsVFrU9JTW1qPE9n4ZZgjqRpn/4JdWS4xpZ6yIDmrPE47tqgYokHu1c9bi9vUedxNjGoVCNAO2ZOTJj0j6/4401yrR3HnHIv2h2eu5ocIBHFMh2aaxYF8IVpxJx6e4WDl04WmfKKBgQAIh2zP1UyKWthIn8Mj2MxiP/+Vqh6dUQFfexAF1cSY7F63cvWuteP4kExT1vhRbPbzxNUekEP78q+0xlHA7zJduh3L8d59rpW5HFJYgwbe4AXeqqbpe0NdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB4632.namprd12.prod.outlook.com (2603:10b6:a03:110::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 29 Apr
 2022 16:11:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 16:11:36 +0000
Date:   Fri, 29 Apr 2022 13:11:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH RFC 15/19] iommu/arm-smmu-v3: Add
 set_dirty_tracking_range() support
Message-ID: <20220429161134.GB8364@nvidia.com>
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-16-joao.m.martins@oracle.com>
 <BN9PR11MB5276AEDA199F2BC7F13035B98CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f37924f3-ee44-4579-e4e2-251bb0557bfc@oracle.com>
 <a0331f20-9cf4-708e-a30d-6198dadd1b23@arm.com>
 <e1c92dad-c672-51c6-5acc-1a50218347ff@oracle.com>
 <20220429122352.GU8364@nvidia.com>
 <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bed35e91-3b47-f312-4555-428bb8a7bd89@oracle.com>
X-ClientProxiedBy: BL0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:91::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 310b21e4-e826-47c5-120e-08da29faef66
X-MS-TrafficTypeDiagnostic: BYAPR12MB4632:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4632FCD72D0A9DCD6505F46AC2FC9@BYAPR12MB4632.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdTPfsSVIgch4Eu3VG56i+FzIKlq0TFfdNGzezRjCIzLU4LHirclBy1tgvLntYBcrONmgOcL/KH0dHoHSrzc17nuIruJYHQGYr/cHH+bGdGYNdIY2j3HsJNsTVf8uvUywKIJ86JMeHEnryOxUx+xk1RD9UQzDOJmDwB/1je507vOYtFNyLqdNEKi/fL0QJ6PTIK67PNxdMdjF7OR/bU4vwvaoguCjHvNAhuJIg4I6kf8GO5o5iwyLWIPAnLCqAxWmBMufrjqhrJJ9TVu2nCF/6HbbKP6qL+4CQAlkrNxRI0LGz/qYBw+uP7XmP70PcdxZJdFbzjsh6+wXDuVU+BaEbYzQml8vDEnLvjXhC0g9ow8CWTxwpS1gOugCr5Tug2MSlvjH73jze9HWGFTmDmTzYbtbHvhMT2VDH4riOVFGteIQwUWha1GTdRGZcIk6ynRUWnInSkRNtJdMbLhcr4kEObjyDDCYUH6deIr5FKKMFjTBveyj2QA1dp9BgXH8BS1Vud9sKzb7nh/xTNHE7d2Pgm4MMG2+gjiPUTXleYOXjaSfbLnYgHFKACFfXJUoLUBIZAga7YJoFWUBSzSVw9MMVrx07Q9jPU7+BPJFgGvw2EMU7BV8vXroTbNBOB+yht029A9wm4/ebzIiIlp4CdTIOFI5ogEFxTGgrJ8mnJuJcs8/uewCP4pxR8xHwzJ6pLxwojhisn6JjMfMatUZqikCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(33656002)(86362001)(316002)(2616005)(1076003)(26005)(186003)(54906003)(6916009)(8936002)(508600001)(4326008)(8676002)(7416002)(6486002)(38100700002)(6506007)(53546011)(6512007)(36756003)(66556008)(66476007)(66946007)(5660300002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?noF5JqR67/Hlo4VaHYdHpFPn4Losp7hwU8DKuBMwGeMxuhrVpBpuyDCgppkw?=
 =?us-ascii?Q?gLnzMXysKeK4NyLG6jk8XTMnTf/zTnPMN4+pGXGvGv7Iqx2yF5KFTaNEXzUr?=
 =?us-ascii?Q?AygAyp4PtK6sa7DxRb4gEo5qDAuzBD3eASYDwvrSmz3W2Rsg4d/7Jw8WiQfs?=
 =?us-ascii?Q?+QGLFPrwjcudTAS8+PzO74Dg7JqdAP9M5qJCdWVEDCMXWUtw0pdzg9XfrVZM?=
 =?us-ascii?Q?IKsx0NXqsoFemRWksbQaLk23TedzrtLvr04/00jrpGfc97Fzb/239gzGGcFF?=
 =?us-ascii?Q?zBcQs3i+5JVkw/XlyYUmF9EKHl6/qBIBeRQT0nH8qvhZNcu0uUD38oN4LSGB?=
 =?us-ascii?Q?4xfXZB4uL2PHfcS0ypf+6+AlCjpkZOBrE3Ra8ATf1Sp+T7YCwCsSE9YFiqmV?=
 =?us-ascii?Q?Bl0DLbW490zDnRDq8gTLSFlMgDScHl7YICr8gnTfTDk69FLv0PrqX9gIYocO?=
 =?us-ascii?Q?/F26oYDmpuT8srkyAWiViEYODjrb6bGhgY13xG12q82HkuWyVW7IxlekK+gB?=
 =?us-ascii?Q?fKTPZYgtc9J4uv0dGZ5yH7Ahif/v8jNimMRqjACjsnc1VZIPhT/08zccr693?=
 =?us-ascii?Q?ANnNLnp5+1uzaO7KBUdJZgu4mEAQrQTyS4TfhwuY9IbCxDmC626qetZVlXIq?=
 =?us-ascii?Q?SmGFEOpvKFrPtRkIH3qhwTXd0Z+IgaCq9NaSUzEZfJmbF36NJ5Rhz7hn1C/6?=
 =?us-ascii?Q?ycWcRXnmRqNfUI5a5+Z5pbQGbtxXFQqd2SYjj3BZkMojCvjf+LffrKNwL3T/?=
 =?us-ascii?Q?r3saV5ik9wFcBjxOodRRv4NPfnaFjz1TgUauWEMVTuVXU5kK8fUBCu67c9xX?=
 =?us-ascii?Q?9qNCq654Ox0e40LKJtDs5Ev584/pfBAbX7VvmlGvBsPzaCFlVDCcGJRMqLmk?=
 =?us-ascii?Q?WKzirp4u+2HJ6yATE71bdYp4Gu2EYUmOs0AtMXafsfU3nxmcpLgMRnj4UO2L?=
 =?us-ascii?Q?IaFcGcY5sijFq6Ep9P+9VrY5M62WoKK6QBg/tdd1IbodAStqv1+Gxflx3Jma?=
 =?us-ascii?Q?nHh7BPk6b2srVrX0T+vu4UvfpAptpA12nBe+j5KRqXmMWusdP/XhR4kkGPFb?=
 =?us-ascii?Q?Qycw/+ZQL74RV7YytuhxC1p0Yu4JqPa+vXELRPa061xWg0nxuwG/hqqwXPXz?=
 =?us-ascii?Q?MCxR0wYMHNQFBMYXJTAcInCm+xIZkM0l7HHuXe9o0QXSi5BCZqubm4yQ0jDk?=
 =?us-ascii?Q?fOOajO6SxZBb7vDXrrQPkhnQ2i1TzvWLkzfmjCOO2f2TmKUUMUwrxay6pPO6?=
 =?us-ascii?Q?wIRpllX6FiJu9IZ4TB4yXwLfGKBVxD0LT5SBk0evCmhmE1ian+dAwpH+gOQ3?=
 =?us-ascii?Q?UNM1Aw4jmA7+unZdZZe2yINC2lVxuHGnweSM4h6RZciYoVRtAkc0zLiUWvGE?=
 =?us-ascii?Q?k0fDmcpf6yvAF8gHo4pWkGEGOOSwg1CrWawNwH61Cz3l9V745zlvYuwwD9RD?=
 =?us-ascii?Q?8MHdT6rgsFHl1+J+Qnn0CTI+shZIGp7A/EjWQIkTMrFIjk/0uNiQ//T6Gqxk?=
 =?us-ascii?Q?iA+hDK8GavHrdHK1H/YMeItyn2W23t7xWbdoxh2mtEYqY61OIPlbnlLi0oac?=
 =?us-ascii?Q?VtTlC99ES0Q3ddHfN43zn9xABY+E7tKi7lxMd8b8FDu9XdhXjMc2Dx2mMH7f?=
 =?us-ascii?Q?2kkWs2VVU8Nzlbe0bb6lA5x9L0gbcn/XTNlL+SoD9viFkKrnSwbRYtOztiBj?=
 =?us-ascii?Q?tJaiRUIlHB0260eKeI6OObb7Bt3T/FFeBCP/EIDj/sSAttxg65NfgIFaueL2?=
 =?us-ascii?Q?Q66PMUTM2w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 310b21e4-e826-47c5-120e-08da29faef66
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 16:11:36.3540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4CsF3Lg8Fi12KFYHHDhyjs6Y5Oy8Wv+GGKhZrJ3BfxT8KcBU62zsp7sH6pSa+3O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4632
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 03:45:23PM +0100, Joao Martins wrote:
> On 4/29/22 13:23, Jason Gunthorpe wrote:
> > On Fri, Apr 29, 2022 at 01:06:06PM +0100, Joao Martins wrote:
> > 
> >>> TBH I'd be inclined to just enable DBM unconditionally in 
> >>> arm_smmu_domain_finalise() if the SMMU supports it. Trying to toggle it 
> >>> dynamically (especially on a live domain) seems more trouble that it's 
> >>> worth.
> >>
> >> Hmmm, but then it would strip userland/VMM from any sort of control (contrary
> >> to what we can do on the CPU/KVM side). e.g. the first time you do
> >> GET_DIRTY_IOVA it would return all dirtied IOVAs since the beginning
> >> of guest time, as opposed to those only after you enabled dirty-tracking.
> > 
> > It just means that on SMMU the start tracking op clears all the dirty
> > bits.
> > 
> Hmm, OK. But aren't really picking a poison here? On ARM it's the difference
> from switching the setting the DBM bit and put the IOPTE as writeable-clean (which
> is clearing another bit) versus read-and-clear-when-dirty-track-start which means
> we need to re-walk the pagetables to clear one bit.

Yes, I don't think a iopte walk is avoidable?

> It's walking over ranges regardless.

Also, keep in mind start should always come up in a 0 dirties state on
all platforms. So all implementations need to do something to wipe the
dirty state, either explicitly during start or restoring all clean
during stop.

A common use model might be to just destroy the iommu_domain without
doing stop so prefering the clearing io page table at stop might be a
better overall design.

Jason
