Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458ED6600FF
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 14:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbjAFNML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 08:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjAFNMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 08:12:09 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3917345654;
        Fri,  6 Jan 2023 05:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RxT1ksdP3Q29Qb8mTboH2p2yYXHCS+CeVe1g85eRZ9TXRxERm5Mf3Fo5OqikaGyYlXnUvNOxr0nxDrhg5SwUDz5bm2xnpC9uXuy5ecHro75fNkd8X/5/MKKb2k1lOw55dHYG8BqzUoWyd7zaIC5XgtrZxasgPVhYZO4MadPPyA85O2PLssdoyiz59dOxaOZ4JmZeYCC6bAfuk/QbM6QDE8/yQUnYi88+4HQYlNPgml7T8axEg75fjE3j11+Gv53MFAKl0DA0mX5y8mzrhQnSuJQFiCCODZyuBI7dJ+IdGtY/pDmBWkBywUVBeRP1EKkrRARCFSI8wDttIdJuSZZ8Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zc6GnGFa0gOyDVyqAmAMBz3ZttIQAodM4Y94COEaUM4=;
 b=WOt25AWJwYk4Mg8CAFqX+JCBHiMgQqmyuwdQglddoZX2eJuu282OW4IUBcJBPn8bYui+1XZtZA1IZDO7xYqjtliRKYRe2PJlUa5U7meEQwlC9htp/wv8UseSIns2sW6VgrXJNxDg2eQh2kSZ/vT9AxlmD8DhlcTa+2A+KY4pfH2toTJ5AZscLGk+AjRwhexrJHQajDH3BIigE4OxveRu1E6i1Nq1gMAC2oQntYTYaPyqCwOVBzuocYORXWDL5oq3UAZTefSt5aCVXgE9fktKcW9kLVBIRZ3i5UYgLMumFmTeG+iwcKfPaZAyrm221KPUnM/vtJb+DkwIya5/6L2SNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zc6GnGFa0gOyDVyqAmAMBz3ZttIQAodM4Y94COEaUM4=;
 b=iWH1XQSZRV0iipAADyWOF+9zL1wuPSrbWZEyFcu9wb0pFUkQNV4iC+5ESjmw1sAT1COLFjEDB3EBQiDJ/y09FNF307e4V9KtCjTBFaXzF6Dm8j3E0D/7y/gD2JYbiINJUp5zpEE/FCgXZq6vdhmYvBuli/hcXWMZTKxbLr0icXdDw4TN1GPcRU14eIF+dDqdYN68h5/SD1vulkD0iVWJTwQ6aIzkLMv2TAILVBfmrqZulFp9a7JIiq+cZqT/L+Y0x1JfGtY/TfgKBamMPs5vfIhcaMxCvrArFjPcRTupMJUFwgDID5w+xtuF5LCRlHBphaQZS1ZgwmccTj4d9qI9oQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7239.namprd12.prod.outlook.com (2603:10b6:303:228::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 13:12:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 13:12:06 +0000
Date:   Fri, 6 Jan 2023 09:12:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
Message-ID: <Y7geJZkCdXmgaD8V@nvidia.com>
References: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
 <2c12143b-eaa9-2f6b-d367-e55d6f1e180d@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c12143b-eaa9-2f6b-d367-e55d6f1e180d@linux.intel.com>
X-ClientProxiedBy: MN2PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:208:fc::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7239:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b80529-7c4e-4f61-c3fe-08daefe79bf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DvRWaGhiu+xbeLScFQwPLYbfFUzWq79k4v53D5IGRo7XjxuLicEHqsicQ0uuKRCbqRWFGdroo/slNvbUgcPeKHZo8V59PJMHTsGTKUnqYgd55K8XfpnS54i2LdYniNfFdEdRh5gGppxozMFbK0cgn2kR6MBTiJkTZ/+T2yLXXyUjuwpN1qT2hEl2frQjWhMoMbuzuHcmUWxPMSZOL0HYo1uMzEIvFn/tMvBFAts+JSujJOFly0Gf+qinIo03z64YWj0/krvBK4TWWa9S2LP+BIRcw7c0ruxsAmkfBapO/iBCtL3CF5Vh+HW18GAwXTCi0r/C5kPg5oED0ugbWjwy82QKzaPqSsnDxQxG3AD0P2uCtKA1A1TduTGA0cHu1Wra47JOYUzJZSqPVY69ymnNV5gD3p1WXnuvmtbEfcLzcz54s/j5LNQ8VZB9OVKO/iStE+wMazjmTYHcpq/wwdFEdsrNANI7PRhb4PYNemKzbTsC6nZFHFalCRfA0pQRWOJlBOz2jUTeSOEgy2eLhtAqmsBYGY88viZDGbdRLSy+T6fsCLFZu7uEBYrZa+5Z4KPVva2zTWVmIX6W8f8Q771updUPPIUTe3B+BI4SJwwXzXnH/zNfH64NwqwbKC2ScWwa+9DZS0I8MAkmzmLtwW96tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(451199015)(6506007)(2616005)(26005)(6512007)(186003)(478600001)(36756003)(2906002)(54906003)(6486002)(6916009)(316002)(38100700002)(41300700001)(4326008)(66556008)(7416002)(8676002)(66946007)(4744005)(5660300002)(66476007)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LGe31whD+9kKEkoPWYksEksZjXH41TTeq5Dnf0zg6IpUhMKqs24maUca3ju3?=
 =?us-ascii?Q?ioghpC7iiaR8sC3XhkS29mGGa3/9ZOYEVZPaZNmLe2c7BfmYhbngNXB9InJ0?=
 =?us-ascii?Q?CXQEdCLhC+OKnttL2t7pkvC2+QMHbB8mdnRckwyjVT7PMWL5473XAnp+IhE4?=
 =?us-ascii?Q?60PeYoVFsohGd9ECgkjDzV2ixtPbowPSETUgUYrE8mVfHXVqvB+ke5wqaMmK?=
 =?us-ascii?Q?R+wB7UGBnWJhiT7D0eWzhDzv0VVsYrik1VnmsRyi7d2+TNwywTauRxoLq5ZY?=
 =?us-ascii?Q?hWAJ8rm6LfCL/A9HmJq/8p1Th96tHKG5pZ4aZnYrTe24lnCXmABWawuH3Wv+?=
 =?us-ascii?Q?uicXBTHKKkyNegmM7Uyqe0kv7aa/dKjMo5Kj7oGOl38dffHDZywUDhtii0cL?=
 =?us-ascii?Q?ltgZSUyZfwr4K+EFppEWPdl7MM+YeiJ0XFEqQTuKwlH/9p+uE0lVTQIfjNLk?=
 =?us-ascii?Q?PcxrY3zTkXdfqJg0YliLcqFA22RO5s2zOE8SYBpgYpdofFALHNTGFOWbSr2+?=
 =?us-ascii?Q?gATOIAP958lmnZrKOXRUtfKy1eWGuw72KOwmiRtmdv2Wv6Vm2fMBsJEIeBj4?=
 =?us-ascii?Q?DtAOcfn1Ja7yDZBeZiJMtfni6zY79FZdLnz17JDcrch1iAG1ro16YHuzTZDl?=
 =?us-ascii?Q?7fBF/+UUD9TodpLRRSMWU8SsVPvLNjyRNwyUi9ykUs+uIs6AU82fOwW4mLgl?=
 =?us-ascii?Q?Z0W7cF00l8A+EqHfvCC5DRRtNdmpshL56/woy+RitNvpLELEIuIf2ZwnXyL3?=
 =?us-ascii?Q?2845WmyrNV+yxgnNG7asmYy6lOpCw26Hhh4Lkk9EojE4rPbzqsy0m4KsK5Rz?=
 =?us-ascii?Q?z9W6IIhai+EsZL1oHzrDMGOMHsf9N9lkBKDoSfFBPwav1jh3p7U6qaM5RFaY?=
 =?us-ascii?Q?+SrRpFbY8zjc2nfuvir6tJVi6vFV8fOrWqcSOUfjx4fhRkHfoI9xwSqO9lZA?=
 =?us-ascii?Q?ub65yyiiRNhkba28KEgT5ZYYCaFc6HWX2b37Ut79aH+PcjdVWzgQlqZQGdGe?=
 =?us-ascii?Q?JJD27aNHy0pJ1mIMEg0mik5x+0FRXG1Oh1oJB0FfI5rCsAIcSp+BNKvujPBJ?=
 =?us-ascii?Q?GSI3b+HLvE1lpsZEAy6SyeMmT2jnw1NJtafU9+qSTmDoKhJLRShVZtz7+It5?=
 =?us-ascii?Q?QGIE5Gd7ZfFiuRt0/Q5p4Ri2VKFYmyCxtx2UdzJd6u4wXYt6/DtJSIGHGqCt?=
 =?us-ascii?Q?Urvz3AMX6/py6p2zeRxeTXkeMg9xC2noMaT9TuZT5A2SRf4cDl+jFh/bwn7T?=
 =?us-ascii?Q?eGwixcGzb1rmOC6Vq9SDOwdPITXLtVl/0yt2z433fM9PmsMGdGtiZBgiMyZy?=
 =?us-ascii?Q?PLIL3JoQkP/pRzWGY4fO6BLRfSsa0Be8Jrc38lJ2mynO1qCA7G70t07nLos+?=
 =?us-ascii?Q?fvBSiay98fleW//k7ujTpGPfBrdF+7Ni628vJionL0ADduj8AQmz20wAoKM5?=
 =?us-ascii?Q?7rzAOnvIpxQh3F/wBDisXOiYHQ5epRVntN3VtqugHcz/BHJKBxma3htlntdW?=
 =?us-ascii?Q?p+ctm5S/BOLHutmloK8C1KsHGa0umMs32g//PNdybwgo7fBdKFdAbsopJm+b?=
 =?us-ascii?Q?LgJoo48MFPegbbk22BKt2C3y9nqeGlmyN2z6ZNpH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b80529-7c4e-4f61-c3fe-08daefe79bf9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 13:12:06.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EYSgVbGxpvuEbTih7ZsgodafGN6QFPmAghMesUuG/rzjX/hXV8ofSYR+2AzBbmG8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7239
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 06, 2023 at 07:28:46PM +0800, Baolu Lu wrote:

> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 46e1347bfa2286..9b7a9fa5ad28d3 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -455,6 +455,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
> >   extern int bus_iommu_probe(struct bus_type *bus);
> >   extern bool iommu_present(struct bus_type *bus);
> >   extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
> > +extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
> 
> This lacks a static inline definition when CONFIG_IOMMU_API is false?

It is not needed, the call sites are all compilation protected by
CONFIG_IOMMU_API already.

Thanks,
Jason
