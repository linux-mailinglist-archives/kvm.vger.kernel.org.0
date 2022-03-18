Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7610E4DDACC
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiCRNrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 09:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiCRNrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 09:47:49 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27F3316F07C;
        Fri, 18 Mar 2022 06:46:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mYWHUXw2exQHuNBn0Jfxpy9hd4gIRh6QzeRopdT2td8k9xW1iPDVO2aSkC6sXtiZPkKl3NyFsSwdYvxNoBE/bq1GesNe1BfYsskSbCACRKq5SijTyDyDpzQ8tJsbPxBG/P60KQw4wJdYvfK7CjHJ5TOjFJqLXVUn9oA1Vf4fzlpVNgiLE8dlMbIV2iRm71g6zpSO/pV7hSz+/I64mYqYD9EIYx+fEytEyHByXN0WjrmIVeXiEstmSobreZ3nQSy/geK2RIjhikCtR2wUUpepoRqkq58znaZU1jVrrtQgFPyh7ZR5mJeSAs0Lv5DOvq2+aHJ+5sZbtXF7urvEttdiMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5viTYeqlMtfxGK9lQLkuQIKonF0Q1fJSPW1xlNpPGTk=;
 b=Dl/rd1XYFg4705U0rsFcjuNH076L1D48tAkO+RsPM5sPU6zL1wMtrjhR+5Bb98IzQbixQaoHspLpkLyQH08W/L3D+MeeAgL8vqbiF+TPyaFP9YxdwnfOveItH5aNMiViqVGOHtNwhDwRa5bvixRVNU8poRXJOT/hDxHqhYkXlnfwR+cAOkOz+4gAkFez5tZl3Ad9l9k43tWxxbIK2O5mbOs0DX4nsyPjtpIvKG2sAmIff47nTPWZCJA3LTXze1Xkwrf/Ga1J5X832dMj/Cc9ND/VnkD+LzUrM8maZA0WXpQl4oTYVntKq922ArVio1tLxxyrz/CdcP87JRa1Y7BQMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5viTYeqlMtfxGK9lQLkuQIKonF0Q1fJSPW1xlNpPGTk=;
 b=iMuyz1W8m+REl3RcR+T0AkQE6q8OpmXBST8xHG6YD3eJ5OK5vKmDj4eeO4cWSiKJ77aoiuB1tu07qZ5jpwWRO2mrgdVWt/2ZSTKloWwmGjUaPsn+Ogs+3YfUtWrCEn4MpMX2+p/ixFDbsquE4RM6ppyRtd43UDORU5qG2FNXWosGNQ+AGyFAT42HCtPwfpyje8xfefL2gDBGT5rjfjocQ88PedtJGBv8YxFhSFVH+yYvieaM9cgEVoUkZtDUah6NYDyqQsXldq0uE497l60EpsRJfQF1cC49YuNU5/4l/+fHlnwnp8NGy6dQGKyxRL/qV82FwR/r4Mb5TwPhk7TG7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MW2PR12MB2346.namprd12.prod.outlook.com (2603:10b6:907:4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 13:46:29 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 13:46:29 +0000
Date:   Fri, 18 Mar 2022 10:46:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Message-ID: <20220318134627.GJ11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
 <9618afae-2a91-6e4e-e8c3-cb83e2f5c3d9@linux.ibm.com>
 <20220315145520.GZ11336@nvidia.com>
 <BN9PR11MB52762F1B395D27B1F82BBF0F8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762F1B395D27B1F82BBF0F8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0061.namprd20.prod.outlook.com
 (2603:10b6:208:235::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dda2a039-7b86-48a9-d2a4-08da08e5b440
X-MS-TrafficTypeDiagnostic: MW2PR12MB2346:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB23463A91749C7D9C6AA534AEC2139@MW2PR12MB2346.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4wGkcDACjpfCrxV8varEJAkwtAEt4QXHaLZsqcC1mu2qCDZ4kGmlwryWHUYTuE24zPTbxN5ICwY4+SCrsymGA3USe0xprrvSowgD1RSY1rc725U5qXOhNFQkxDLeFU/OmJRd0801Kb1HzzI5cw+mQV5XFO+kIz42pQPkyxZNpZLSZunPebCv3BlwgoKN/U4JLyTiV6LJVce93SNsjVGanP3WF7Tlsm+0hoRkdpgGE1UcnPRTRa2SnB/hLbg8YP4fB4eQ6AXNCStmt/vF4ZNxKj5QrdiFKhtLxGcLeTN1/IzJm1OjvRtEoFS+fxa6cDD4rsfoTCYmo9PaXkfNDlbeATC+vhbfw16QlUYAmKSZoJqwtEBa/S8udwBA8bV4V0+nAPp4zwURunCZul+ViNJdyoOtarLdpV2M35SCHKGTGDfy4QC1ACvsjwYCqw0E9Zb1vMAy5O61Dd9CbNeDbM9Ww0fx7PAQXGXmgmMsUGfSF8Ynsnfv1VSwf4Na+i5eZB3hggObKYrUhJPLpAgDS+DeloLIEkPpXsjXfIBfUmDH0meppzs0lEi9agUlCiua9J2XGH5J34M4hcS67IdS3WlkPIqHyehC0/fGaZnQsc7piK1wJslnysi8PKYXAZgJsEhPLdA4m2U8dVL838vYtlHyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(508600001)(66476007)(66946007)(66556008)(54906003)(6916009)(6486002)(36756003)(86362001)(8676002)(33656002)(2616005)(6506007)(6512007)(316002)(83380400001)(38100700002)(26005)(186003)(1076003)(8936002)(5660300002)(7406005)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?35w+/wan11LIdR77wGBdUx4OqJJ0MvcwJfMDgjjOXbvaETvpNsPVQ1TiCebp?=
 =?us-ascii?Q?XO13rLcAZulVpz58qHLSj+p+Nt1t99F3eavJzPZSF6mG8tqt6JDAsrNn1Ywg?=
 =?us-ascii?Q?l3WzvZkOcJs346OzlvBNc4GDI15CoLn9iAfE4k6kBAJMkhUTxwVWs4mKsZXN?=
 =?us-ascii?Q?FS08ESCX/8gHUw5hEVBWcTmIhaCG80qZ9fibrUfV+Mm4ajZoIe4lq/kl7FkX?=
 =?us-ascii?Q?XpK+Z3P5h3ouyIcNXy9TvwlqHoBBooUYqR8WAW+NSXvSMcxyEcz0ZoUrJsgd?=
 =?us-ascii?Q?siETj/4oxSF2ywKwOW+V98RmkIoj++moYVRxTvGmEUdBB/JDManFB1pxBxZV?=
 =?us-ascii?Q?Gx1CPJBdkvyrRA2igMdAOxk4rApLkYTo9fcvdi/OGGv7y/7SAyk5zw5g1doq?=
 =?us-ascii?Q?k5XLOG7lm/48SDlA8s3A5Y6gpKfjl1XMAFmCU4xNV5HR+vXFCloEsFeNj22V?=
 =?us-ascii?Q?z7so4+YeQ/Z1lQcfGPMKzgJGIt/6X+voSybk/f6gzkLQ+EY/Hsaj/dQ90Z4H?=
 =?us-ascii?Q?7jKbEuaYBGTzIT5apSCqnXztmx3W/P7tWs9UNCECUelizVPcWjkWL5IKe+Nu?=
 =?us-ascii?Q?NqSdgQCyDwHyH/sLwqnE1dmIseVHm16rjiNeY3vJuUDD1T4At0JbIh/RoVsM?=
 =?us-ascii?Q?LuctDzz/3JhahgyX4PwNlLvus0X4ixZKVDis+Acpcj/dxDEYF5iA84pPYGS5?=
 =?us-ascii?Q?jFBLYpmlH0MO6osVCtSUUoUrY5q4TS7EV7Ri2lBP2VjbAN6LXCjapnNfoSXl?=
 =?us-ascii?Q?WJi/O9sZhSyIWIdVfnTsM4dDy/rwBr0hT7HonXfa46Tk+dyz24OwZjf22OV7?=
 =?us-ascii?Q?FaamQJYmtXbK3zhzYUrtK5vA8D0wW2vs/fscbyF03YTiYFLHUp3SOs2o0c9P?=
 =?us-ascii?Q?f06RGy9zwVXwKukxq+lZZcu9O6QA76zC82E81XEHYNOoz31ZcLAQDQGViz38?=
 =?us-ascii?Q?FmqfWX0zMOdUXJyq94P4iIbY2IjKtQIfPD0R4a3OGWqC2x/0MGG0hzJ4RrLc?=
 =?us-ascii?Q?xveQ53v7uI4u+TQe6aUuBi61qFHybxaF3h6SwJ4PGesJQQay0qVhnD2JIqSY?=
 =?us-ascii?Q?GFDBoQqwg51vSmKqfCCs/+/ubzj3uZYPwTs4lbj0D140j8f55XLUymn5/HhT?=
 =?us-ascii?Q?m1BuMm9IlT60/hupDNNUvaYqh2Pvhep43jthXTTrzDor9aQI/Ip7YQwIxtCN?=
 =?us-ascii?Q?2Hv6BAOuTWSMyen+EfFDgw78Gsx5JG1seXk+PxkGLQmfeQ8WY2JE57ej6dhz?=
 =?us-ascii?Q?WIY3ATjlOe8wDXHWFE4Yh4GVLJrlt5O0aVc7PEMvycg06dwd2EgdqbGAf2LE?=
 =?us-ascii?Q?roLyhomMWc3Ne/RlEY9W4WhEfVq3Qt2y9CfGs0dRPmISu4UfSpJZjNz+Sbpj?=
 =?us-ascii?Q?l4x+FKnAgxdoV1nfrI5ehhck6Tmw2xpWvNq5XiNaTWTKUFtfLAaiCR+g3maZ?=
 =?us-ascii?Q?Yi+7ifoi3gIhJsOZTCwel4TIGn5ocAzv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda2a039-7b86-48a9-d2a4-08da08e5b440
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 13:46:29.2432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3UBRPqb/CZVKVBau3hsRN0L+/hK9TAy9NNrRhuLCD9sco6r7+82pJX5pEuckr2j+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2346
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 07:01:19AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, March 15, 2022 10:55 PM
> > 
> > The first level iommu_domain has the 'type1' map and unmap and pins
> > the pages. This is the 1:1 map with the GPA and ends up pinning all
> > guest memory because the point is you don't want to take a memory pin
> > on your performance path
> > 
> > The second level iommu_domain points to a single IO page table in GPA
> > and is created/destroyed whenever the guest traps to the hypervisor to
> > manipulate the anchor (ie the GPA of the guest IO page table).
> > 
> 
> Can we use consistent terms as used in iommufd and hardware, i.e.
> with first-level/stage-1 referring to the child (GIOVA->GPA) which is
> further nested on second-level/stage-2 as the parent (GPA->HPA)?

Honestly I don't like injecting terms that only make sense for
virtualization into iommu/vfio land.

That area is intended to be general. If you use what it exposes for
virtualization, then great.

This is why I prefer to use 'user page table' when talking about the
GIOVA->GPA or Stage 1 map because it is a phrase independent of
virtualization or HW and clearly conveys what it is to the kernel and
its inherent order in the translation scheme.

The S1/S2 is gets confusing because the HW people choose those names
so that S1 is the first translation a TLP sees and S2 is the second.

But from a software model, the S2 is the first domain created and the
first level of the translation tree, while the S1 is the second domain
created and the second level of the translation tree. ie the natural
SW numbers are backwards.

And I know Matthew isn't working on HW that has the S1/S2 HW naming :)

But yes, should try harder to have good names. Maybe it will be
clearer with code.

Jason
