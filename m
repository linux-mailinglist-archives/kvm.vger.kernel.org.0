Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF72C6F5F58
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 21:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjECTm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 15:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjECTm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 15:42:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8525883DD;
        Wed,  3 May 2023 12:42:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofyua9kZEYSEVLlfjYUMw2EZeWLO6QUSdWhU9WmBANT6ZRarK7dsHFj9jmwzllbHE3THBgJ/Vyghcgt9YdnU5v6PG51zc72NctsOkUpsA/iPcyJHgcgn4I1aK/82XXmdqolo+E9oIulkIySt+4FXCEXgINYmRUHXISjJNY+G+SxCdEV2FDYwLn8K7kA1cICnFVq5M57XGtMPFA7ACJpGL54tVXPDMMmmWWWxL28dpMDE4ZYy+GsYruGaqthOmdR/dc9AEKfsGIbFpq+zxBOzYjkFMxl2cob0DaulmXRm7vYt0vc2MpkN2cxr76+hXVKrhgzSXpto0lhPU4mLEp1bXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2PdG9Ad+v7Zcl9tGZN2uqmOHaIoaDnB4hv5HJP5QKM=;
 b=fw0oEcloWR98fnwOmnyaeQs+Vwy0JgDMFPAeQ1IvotcXq8lgCv5zKROB/g24V95KmJM8okvNnGqP64ReuBZAxBsMiZRdhu6kvPy3ois0VIM6R25RPt0x+6fhOqe9rbdBglsVOcDM8IyYV/12TudO+67h0ZP8NTZNmNvzuR8qinuaTHPbSE8OPnAACy0++EKQ3rzTPOfHPXTrAEsHf6sEn14wcc0zlgUFL3loK5QWZMHeqwJ3Fo09Grb88+Lz09NjW79REY4FRligcFvaHpfpKhwcONtT8+UqLqJR0SeAZF7a8Qjb+AmHtqERNYSaKgRtFndcEZ3BnV8QpWb7F7eYpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2PdG9Ad+v7Zcl9tGZN2uqmOHaIoaDnB4hv5HJP5QKM=;
 b=dXkIPP7PWfCtzIQ3f5CQmwCAwG4RHacLPgNovF3EZPr4CamIgP06Cfn4UWen77+7vLIvNnsNrMelbRHz5ugbP8oKfFP4QUjCjQkDHm5iPmKtrxgrJhLKRg5Zo8lqyFUHnKiCFCtM2o6A4dP//qiRnrQMpgUqmi5Kj6DKIKJCRKbtt44B6ogP+Iw1AdoWof+Ap9pZKTf6KvvnCcZVLvRa2itS++gEiOKZwPMTRFmEWTSXxPvUFj0/1MHHL8fIqcRuBtpwk8dzcjy362gD5dVDu8bgm1oPMqOnh42Fxx0ybKs0ddPrwqtfPFhkS6i0GsjNlu8+Pdt05FP8nbVKOC/yjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6370.namprd12.prod.outlook.com (2603:10b6:930:20::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Wed, 3 May
 2023 19:42:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 19:42:17 +0000
Date:   Wed, 3 May 2023 16:42:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <ZFK5F+JJiSG/hzsr@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <ZEu3Ga9cIQAykBGf@nvidia.com>
 <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
 <ZFFSff0cV/eC7IZ2@nvidia.com>
 <DS0PR11MB7529DCEF617AD24D62E33C2DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529DCEF617AD24D62E33C2DC36C9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: DM6PR06CA0091.namprd06.prod.outlook.com
 (2603:10b6:5:336::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6370:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e82eeb-f317-4a15-2af5-08db4c0e8091
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UATqIv5ONf5mRRBheivEPbz/ga7vmKFTWg2Vk4xjHBf/yoZaJ0iTJYjV37Tq0FFClJP/siG7Ggyrc7sjbu6CBjVmlnM1tZT6aS9BoFWy3MXGW86MTDOJnVzrXC75YBewDckAObDBplLpHpYJe5Vy18AEFAnIajykVO+0QMELABc1l9X+08+yxrdoH2vOYZyD84Dagq1rGVP5ONd1/Jr8XD/sQBYuRrfJWgk6MjaLAXbPoreHwrzMYYh6Bdm0G58iRULCFnnQN5LsIulgU7hlBziTKusyoEapjgQ0Tmmy4fJ7lIQFqchbm3hJ+fMocDwkFNFjt+AXLmHCCCHhFKki8xvSh4SKGNFdTu4sEsHy6W1GqEE0jquQW5A6TAxaHExQ3ouT6r5pYK3hlKKBR9YiBXogspBj7IpDOZMkxXMsjuSPGVUKqDPk7JRtMJIcw2+duJSfnxvWBXxaeebaoQOepPBcgDkFeoeT9XBw08/2+dOARclprHkwMUn704RJGMsVvOTXk9sAmSzd7OhAKbxdQnqFKhM1UyQmwZyc97odE3w+1Xn7WmvCYojHPhQqkqYC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(86362001)(5660300002)(7416002)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(41300700001)(316002)(38100700002)(4744005)(6916009)(2906002)(186003)(6512007)(6506007)(26005)(6486002)(36756003)(54906003)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68RMtoL1G6KaykyOmU01L38SIpKOTcLDT5UANYS+ZbvQYfLQ9ekzppE062g9?=
 =?us-ascii?Q?hyM5I5zXzpF2PnZCDX9YRF56YHozl95wBivBSBjgyEAMUG5IUC+sANiLTIp8?=
 =?us-ascii?Q?0HWpe/Kz6WA3Vlm6G+cj7z1ALnkNjQ3JI60r91j0A9KvYoFXO8gfJTqpSzyF?=
 =?us-ascii?Q?0jMS4Bg9Cm0DCCQkuIF5zmPtnzujZlcaLRx8fLlwfqPoEExKc8Gn5+yGAygJ?=
 =?us-ascii?Q?37SETxUxob8IcixCKO4u3IBQGAtr7AXVTDgTyKIYgpgrs+aQ5gGYR9Mnt721?=
 =?us-ascii?Q?WCeEv80p5i4EIH3IhsmjBkTa/vVlhpbnGo2pzXuJmMExa+91ch7WT8C95LKz?=
 =?us-ascii?Q?Mfvo6IQ2iXzfucOMT2m2StWW/jhvL8gx2flyNfGEigxpHQdIbi8gK47d/YmT?=
 =?us-ascii?Q?yNsR3nY91Rg2f0mLMlH4nIbXlP6gt2e/blHGw8jdYt6Hzb9glp18bz2MT+jC?=
 =?us-ascii?Q?g31b28rPweQsJh8zuvgRq9fklaP5FmRlvL3zxfh85yHPwd4acnOKrGSmcgEB?=
 =?us-ascii?Q?Bpbl2BHcTiVWXUyproJQKr7ckvVaejLKUYVj0FXsd6Js7cZqz5Z2MHYX4Xs3?=
 =?us-ascii?Q?nzHsqMHAkyDg53HXxSJ2wi/3NGpGcI/NRTaU10KA04CVo4Fixcact459cnzZ?=
 =?us-ascii?Q?GcqWUD/D0ex+AwvXopVC8JZi8Vw/saZ5KtW3aWOuZRMuz1nJeu6I+my5SPo1?=
 =?us-ascii?Q?80MRqriiL2CIF4YTohT+P7EMGKvacGqsY1mlp9OcdJX3xc9Ss5kp8gB7HxzP?=
 =?us-ascii?Q?IPbGCrFPkUeDP10tr7qrW2Dlk9HTCsESU0VPwe0uhl1s9WCD5M+jtjws3E4U?=
 =?us-ascii?Q?qKh76cf97sAPnLqDKPq6dcq4YabbYDDFBOHGNiyH2KrKmMlzzNRU2GfFxuKk?=
 =?us-ascii?Q?RJ5Ve6QT6qLsktSPUM00xLJPC4Mm+SQLPvdcj3/Syeyr/HRxaAmEJAaCCCvT?=
 =?us-ascii?Q?8S6x+CTMQVVEiXNWw24AiDnTisEnfH2oGxMu5WxmmNZEnNiaEof3ex/nNi1W?=
 =?us-ascii?Q?ybX98YAFA2+3g2ylMOm+rgh+7o2xW/Qw1ZXsRueCY36V2argRSpkpVzfPjWT?=
 =?us-ascii?Q?+HaptlMDd+DfisLmYZUnPa7P9WEWzXljaQp+zS5FYFzMmmVqQSOENgN47cL9?=
 =?us-ascii?Q?snAoSdCBmMKEYEHHDapfX2b/CsT83OU8ErIWcadf9v1pLpPjG+cFIc4ZKr7/?=
 =?us-ascii?Q?2F7MnRPecL8dsf3Dd1NKG4W+nf1Sb/cb9EdbzajXQqe9DfsRenZjGlxv6IYf?=
 =?us-ascii?Q?vY/MpntsVCIgTlqzvrHqnloFfUpfxRgC5Tunz+qXZlsil9qMNH7agEP5NKZx?=
 =?us-ascii?Q?evhSjw75E1zMpxsrXNxucNIB8c5ru/Hg2FmsurSPR7mpZyAcXbFj3g1uHdjp?=
 =?us-ascii?Q?VdFeOXBSYD5u+l545KYd40rOYhLH41J6SHwDHeRaODa9FRFxR9SaJ/sWD+uf?=
 =?us-ascii?Q?KuMlZF1KZXVTvhn8mjlcidRkDJbJGM/8tcoWtR2kjguRC3I5ATyxb72CHghg?=
 =?us-ascii?Q?O3r6hfMdubjJLTBL22jqnvgd/K52LalSc624dc7lk9EK6b2/cYj6W4mScQJb?=
 =?us-ascii?Q?/4nHNbhEeH5OQn3FRPY6Sv6XMfFTS/7BLRK/K30e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e82eeb-f317-4a15-2af5-08db4c0e8091
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 19:42:17.5562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oHRNduJbbqFk7KJNV+LyerPeGU30fqfpF9DA9RDFVyoloG80O+3ZySTTIOA+wXN5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6370
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023 at 09:48:36AM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 3, 2023 2:12 AM
> > 
> > On Sat, Apr 29, 2023 at 12:07:24AM +0800, Yi Liu wrote:
> > > > The emulated stuff is for mdev only, it should not be confused with
> > > > no-iommu
> > >
> > > hmmm. I guess the confusion is due to the reuse of
> > > vfio_iommufd_emulated_bind().
> > 
> > This is probabl y not a good direction
> 
> I see. But if not reusing, then there may be a few code duplications.
> I'm fine to add separate _bind/unbind() functions for noiommu devices
> if Alex and you prefer it.

I think you will find there is minimal duplication

Jason
