Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E140C6D059A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjC3M7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjC3M7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:59:42 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E663A244;
        Thu, 30 Mar 2023 05:59:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf4gHKofzDtXkaNlaESGxh9CtvVrKwNaSA1NK4J04zvaG3FJOcsCZ6X18b3SRmQcoPA9U3WJOAQulJY7bsqlU/EhFSeX9dRuEic1aSjKPiZK562tpUwEJ8ZwyaL63FWW0A/aUAEOS46gf7U1/xA/ul1hZvD4ye1IY6A0tDYuuslvEhsMjqHl0qwtXq5XrlWdgCntgYKC44oKfyQhXW7/15KS7zvWnwoNQAvZML278aRovWk+QlmZ4GLtHplkHjvTxWYJ3RbJQBEcEkWW+haCAhy/HuXvWZye5H9aiF6I8p4OA/FqLMYJxl+Q/B8tzC48cAr4HK3EMKe+ZyJ0jhxiaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2sS/CjeVYEPGi1z991Xigr32idHxB0qyTSalMZXfl/8=;
 b=Fk8BwZnkagjIvvZZCBNqPqR6oCSNLTtSZMXuwSynoR7g5HcJlfY2IUATMubHnOYuEY8vCTK4lhtLIKZ4X12LzoWa1bpM7rNo17j5LAbTDOnuA7SGiwYfk+aflxtAf+SKwc9rxYTHIq0YYpVcSSanJ3ZPZfOLQ6EjAohY3KXatwbKPJUBx4UoO8OZ4M+/NAbyIXrh5OmUkYBNKjXn9hCN9R+keNsOBnLz9qgsGM2JG7UfDk9XVmp8wintZSTQEncXx7hy/zeBYm86iLebUru0SFfxpvjV+s82USE5OfzYfIn2v8kCs4d+qnZv5AzyZozT02716raQZQa7yCUM6Vi0UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sS/CjeVYEPGi1z991Xigr32idHxB0qyTSalMZXfl/8=;
 b=n2aBYBpMcnIhkexfgDo2Fnk6bhEAl4KRGjxKNL97cDPj/xGiwVShaPFRnkvhFJD7KpTuvxwKiq6Ye800TWPt3VGyhqRMowKZaIkKMDWxn0o0fvFUHOZTcjrtYsSsYSvE7VlXa7tsHb6IEBu3ydjN5we9Y0mXbbLIzDO3Hh2mVqGeE5+yNP9XQNpE8BTm7rM8TqSXSGeDJlsWvqhjwkXaQZmrHp1jSTVs650lgiUEdroiKzxSq4+45bFK8kvs9KbtG+qXtrV1Nq45vb1cD1+1FVAKN5SZBmseF3Sd+Nc0r3NlNrUIDogVtUCm4EJjkIpOcJwUDPksnLI9sVd5bDJnRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7786.namprd12.prod.outlook.com (2603:10b6:806:349::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 12:59:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 12:59:38 +0000
Date:   Thu, 30 Mar 2023 09:59:37 -0300
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v8 21/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <ZCWHufuxjxvGsWFa@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-22-yi.l.liu@intel.com>
 <20230329150055.3dee2476.alex.williamson@redhat.com>
 <ZCTIJScfgbWWguD5@nvidia.com>
 <DS0PR11MB7529B03CED8FE7BCA284F789C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B03CED8FE7BCA284F789C38E9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 0add40bb-fdb8-4fce-e1af-08db311e9eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xlwjmnazt5MDAvBcqe/nqAz3Y1V8d4n8Oza5+ogrmet5qZAdXmuBze09KlRILLYZkcqsEglnNwYSuAlq14qW8XvKHzverLXoRwze0kbFOvDHx2ti7EgCW5mJnOvaxIrGkDOWi0ZR2PB5we5Ukzu7/VHqaGM0XKsTHLzUhv4AkFaUhgZ968GSaK1iyOAAX3BKzv+sNjHS1lT+yoe0W9KdtlzIKz9s7M1UXLSA9TmJYejMSmuzY4GEh7sdp+wTiXrV34XXW8xpfCSgtWLEcuFwTc9Da/vygh2969tV9TJ55hSVbHqis/9cwtfC8pVnep7Y3lhAdcpkDRkOl+SLStKPD8IB/0qMLiBrABRtnyVmGqxXt4REF4Ay8Chc3UqIK424kFNx5JW6UqKrhQp6ndARzXP/WmsJUpNn98+CcXHayXk8PZysX4tbP+lhpIfaQcytt4lbpBLdeYj63b9TB8WOTFijjMya/7oviOcbX4rArTWB37qz/UXRB+hR+9CcTT4sCXh+Np3Y7IJb+1o1558EvntoQsC2+bXgOhEGsUaXLYHeb30KcQxb+y2a5dWkJ5Ty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(39860400002)(346002)(396003)(451199021)(38100700002)(36756003)(6916009)(4744005)(5660300002)(8936002)(7416002)(4326008)(86362001)(66946007)(41300700001)(66556008)(66476007)(8676002)(6486002)(54906003)(2616005)(6512007)(6506007)(2906002)(26005)(478600001)(186003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IVQRc3c4XUtZo/kuOzUZEDphFL+TuUDauJKwxMPNiaEixmB5s/kyUODikif4?=
 =?us-ascii?Q?upD8OqolGdWh5j4q+RyRH4POhK974e1teE+VzyABFjAVupbXULYgHMXK8eyV?=
 =?us-ascii?Q?Q1cN/U9SW7umHZxqD6rLLYsZxOht6L+0PE+t0+JchGtWtuG83KrBw5nzhaC/?=
 =?us-ascii?Q?z6Q15Ik3cSlsjgKMdQzEcEziDG0yYYDmVg8TW9WfYQb+uFL1WOiTBOvvcH2L?=
 =?us-ascii?Q?868kDsAnlGnc1svdVNScIekj+pbkPmkbsd+scWzkDUYG4IWYojar4brLLF67?=
 =?us-ascii?Q?nzgL1KfJpwSRSJyIK6ESsla0/OEgz5LxCRbAiGbhbNbTEllo1bkL7+Wq7cqO?=
 =?us-ascii?Q?/9+frCvTQr7Mm5BisMUndW+x7+Zyl1vVNcMnE/ADjBIuuv7ihlqJVqhiV3Sv?=
 =?us-ascii?Q?J75HXIaFJOTUExwsxQ9Lo6wHCjQZYWBNaAUJbcsurOjuWjuizrTPXOss9LU2?=
 =?us-ascii?Q?RTIaVABH2X5x2L/LU32PBev+ORcHeaPcIfecZ4R1ixqrOLPPswT9tkPmQcx7?=
 =?us-ascii?Q?FtS+q6wuKDas1Faeyqu7zPWp/Ubvf/BiF9s+v/TSTHuBsaOuunOQ/LLZf4WW?=
 =?us-ascii?Q?sJgPDw2pqTbM34nH/NUj7nW6+Z36KD0FhmA60Eq106TSulLzfESz6YXvnWBs?=
 =?us-ascii?Q?kWNcCXcY+SOpTCkLEaqMRtRKqpa2Dj2N3ZjscxwaXC1Ccgs6mII9Do/PEFyJ?=
 =?us-ascii?Q?Fy+XXdCEhcnH+jbkX9sxy8P+jK8pqcMBpjMkNu0Y3v4U19PCzVc3PmHbocze?=
 =?us-ascii?Q?V6BR60j/2Ws2uPpgXoSiQ4TB8Xf8v1Mln9A66Owcn6p5HmbsXubFcgRZVzPI?=
 =?us-ascii?Q?rHpfc40HO8b6v31OqPpWcKxvv14dIl4Kohx8Anjxl7L6Vl5+Tg7Vpt+z7c1U?=
 =?us-ascii?Q?+tFIso5GnjMl/z5Y6mKZOvd4O8dndoi4n+TiHCLfceKXCEfl0WuqbJY16fax?=
 =?us-ascii?Q?9W3e1KtVloFD2NJ9onU7f0/dlyoGmg2lZ76Ky9qdSnv4Ti/NyTSABhprrCkr?=
 =?us-ascii?Q?bcgAcUZuztZxF9/FWqyEFyI20dKzH0T7bJoui4kDWzGsRNy9oo0F0YGzXkrZ?=
 =?us-ascii?Q?sk1OhA1o9IE7C8sI7bCruUcRT2WibNY4NLFMx3eT4eVpSvITBNyeAu4TrGK2?=
 =?us-ascii?Q?2gNRgZ/0zzTwecEpoTRK4pjOXp757ALHs4+8mdM43X00AvO5N6EdjtJCiilO?=
 =?us-ascii?Q?444W5+pcNOqCCaGnRpI68eaOB3GG12RNqsfwsvWB5dTLe1u+UeT4WnCeQQUP?=
 =?us-ascii?Q?hf+aGatiRFy8+aXvdsw2Ffoi41jFIHzj1vGbycsSvKmURpV+9lo9w5VfW+44?=
 =?us-ascii?Q?qfiJKfBmjzCcFsl29O8OPSdbPq9xYxeeXc6u8JN7+QE4VM926r4QnOGiw9cw?=
 =?us-ascii?Q?3quzmOV0N8mX88HoIce4CYHoR0YVaV7yoPjVzE7ikgPSEmkWkbptbEUDNWVq?=
 =?us-ascii?Q?wKv3F2Btze768hyJkRWL3Vus7cesiLyhpqocn4hmIz8jnirCVizjagAQZrnF?=
 =?us-ascii?Q?ACG/VHv/5gqNL6MA5ESbiZvHh3EYstcjZE6ms2ia9olemAFGJNf/kjO2C60Y?=
 =?us-ascii?Q?Hm/itG3lERcNhLIkBKK2pnD+L+qeIP+IVa1FYaiG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0add40bb-fdb8-4fce-e1af-08db311e9eae
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 12:59:38.5816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wkhzifwZ1JENcKMeQC8ETDd6hnCYKSVV05JzK/gfAze+jqhv+2pwRR2+50DQ7UL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7786
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 30, 2023 at 12:52:39PM +0000, Liu, Yi L wrote:

> > > "Use a negative value for no-iommu, where supported", or better, should
> > > we define this explicitly as -1, or why not use a flag bit to specify
> > > no-iommu?  Maybe minsz is only through flags for the noiommu use case.
> > 
> > I was happy enough for this to be defined as -1. We could give it a
> > formal sounding constant too
> 
> are you suggesting having something like "#define VFIO_NOIOMMU_FD	-1"?

Yeah something like that

Jason
