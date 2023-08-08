Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A711773BC9
	for <lists+kvm@lfdr.de>; Tue,  8 Aug 2023 17:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjHHPzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 11:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjHHPxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 11:53:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB1A55BE;
        Tue,  8 Aug 2023 08:43:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hB8PSHaB5A6xRRnhVO8B4JQF3PuOZOJK6DMUSelwNC/3yJ45yRBum4BiJw4FUKreo+bO/43H6FuVxYOnFTlXWV8nLEcLGYg2LjX/igrf/+b86HfBPom91Jk7XNP3Y1ijt1VtqdB12qR3RX+N25AnOEoCbNYJkmFZw6xsBIp7NxxYjybMWQvlkpyoeWQPEOi7ZKh4S2/OEsNQsksqCutTW9tebUoDv+ZQjxlotCg0mXZYFI5KwqP5pjtdBMUWJzFNVb5/aRIBX2NCecBSKO7K2r116JNHeG8fTeJDeX6iugkNmSOlzIxZ0S+fKvx5WJlRqCMo0WdBuhCQRfwVbZcReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFzyXZJT/T6b6ZEaA8oF6iEJwkxvpZtTl03/yrL7qGc=;
 b=JyptVpz3Rz4h3lJmN4JTFKdu+SdX16h6oSBEBCSkWnvQxaZL31vV34+uSk92gXNiSZLa56zrgCbw/Zyrm+dQEd6WVqtc8bM+hOgQGQHmD1LWMBc7g6yQJ8jQpFSCwf0NbtWR4xdkQNPFeKylGqLt+YHLXQqClQQ3XXQMeXwxSem2udj2z01OUdhjPGH2gbDZWe0iUesoCnZdUpCp4bJbGi9len829e2+yTR6EJHZAKAmvskIgRRzPd6WxyLAW0herkX79oYfGd4rmLDvc0Rm1EEBQN4lVyMOIR/jPfFfCUFAqXaZPYG5c0Iu9/4mYI/CTwUDr6Zj0wTAbDfxlYbmhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFzyXZJT/T6b6ZEaA8oF6iEJwkxvpZtTl03/yrL7qGc=;
 b=cBvBUhvgQyW+Nb9UV7YRzPuE8DMB5dc61W+i8oNzV046tYE+LEO6Uv2C5cEyhaYh3bM2Pb9Rh73UIED6k1IZTcrzFCvw5XzwDMYb7Hkl5zJggO4pxZ9a/kwOnZ+QvpAjgkgWMzPnG1bAcxfONzhMi3b+JmgoAG/r9iav5Q6mKnLOjkWNKltrN43FowcPVEQRBvUi+igcfUEjizox8i97VPcwt51wIYrUvBTxvxUjUJLLDuiZVG5+9uZouho1OS0OzoeHx03UQT1F7vzqtWcMVI0+EpFf2D81dg6d3+0EyH9QPaJsS9/vBZY7oM0QwaiLEImSfJ7TeA8ED28RSlzrLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 14:32:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 14:32:38 +0000
Date:   Tue, 8 Aug 2023 11:32:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, mike.kravetz@oracle.com, apopple@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com
Subject: Re: [RFC PATCH 3/3] KVM: x86/mmu: skip zap maybe-dma-pinned pages
 for NUMA migration
Message-ID: <ZNJSBS9w+6cS5eRM@nvidia.com>
References: <20230808071329.19995-1-yan.y.zhao@intel.com>
 <20230808071702.20269-1-yan.y.zhao@intel.com>
 <ZNI14eN4bFV5eO4W@nvidia.com>
 <ZNJQf1/jzEeyKaIi@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNJQf1/jzEeyKaIi@google.com>
X-ClientProxiedBy: BL1PR13CA0324.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c88b71-3835-4539-e686-08db981c50af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vArgtkYEbP0ganP2ArDnoPd4uxH1U2iE24diLZc8QOrOUlZQ9fWmKKTjC7xOqRw0XpYLnBn3QmasPffCgFRcArx0YaiJ/E2CjwGGasWVWtf5CHlLltkQDlFE3jtu2JyMlpv5MGW/tMFANG/Y9GpkTAwMGMSo1xqBHlCcGxkbj/MonEgPzFSCF/rc8NbUTE03iVXJPVMEnHuFvHmIDE/9On0pMUOSwSPqv28WRNcqb/cSK/XoGp1MnZifMdqzBldlQXTC6Yra8F+xzS/dqIvcRoj8kLhNc8XLiQmsQaKAYDyQVLHoEa4byIdlaB7+Z8fQZUYCROzkVx7/MWO0yJ7uT1ZHmpyszUoUqV5gyKd3N+ryWzO0Bkp4C9eBifMJRw/4cp27VaSP+IVhnNZY/rfa9PTuZvDKG21NwJLTnol6RsIkBFs7ezJjHFiqXPZEnAewHsnIcrCFn8YSudoUb9eEngyD+r+quiVyTMy5xNCYCFjgzYOpkUJcqrprVbFkdOi2A/J4Dd32DIHbkXsPrNa6QCsgCiwRzh6iP5STQXLuFuKl4iv5TPd5t+Ak7E1a9AM8ipfHQGtLLWzl+We9516q0SPW7lVzXFO2CoWFmg2UfyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199021)(186006)(1800799003)(7416002)(8676002)(8936002)(5660300002)(6916009)(4326008)(41300700001)(316002)(83380400001)(86362001)(2906002)(6486002)(6512007)(2616005)(6506007)(26005)(36756003)(66476007)(66556008)(66946007)(478600001)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KHAFThN7W5ozOdBPCXXLWprjTWKZa+JOmV0jw7RAewBHSg5pXBkt8eCAgg5R?=
 =?us-ascii?Q?sLcHpQV57sjV9sfUyYErwNORNX8B9oG+XFarnJ4gB+jgmecwKxyWxqliiSqj?=
 =?us-ascii?Q?LGbJ6BUULeFLj513J6ONHOUVitKIsgHsUHNovhNbtr0xu3a2LAlTGsU3xyL5?=
 =?us-ascii?Q?E1DfOwXfP6wTSJfQLnfMYEAm/Rfcm3MWftw+bS3sQP2RV1jGGGz341UMTcwj?=
 =?us-ascii?Q?/IzjJKcXCw+kq2NOAEwwMJmxA5qI1OOlIcl1ACMbT8G6gkPw6L5GzOcsaXEF?=
 =?us-ascii?Q?F6X7ei7YmHyZ/uXJr8TDRfeBV5Ws8DJ58tRFPGnF6+DSIWZRuif1jtzL92T4?=
 =?us-ascii?Q?R1nKsjsfkQX+msTllJPkqdmtC4LJYAnGm5xKkpGyqqb6ucVJLnky9XiCJlsM?=
 =?us-ascii?Q?bjHXVgjLjmw2W3Wnd7ZgCVRtu95ml4BD7C+Mzj5ub8Q98pxfXpmaE5xL/G8w?=
 =?us-ascii?Q?TVCmOeWRjuJTh4iksbSqDqxU8Aakr4ynDZZDLrx/dj7MawNk/Eo4IkO/jqXR?=
 =?us-ascii?Q?ZC7N8WbCrRHljcft+52NvBzNacE1n8jc5dNgwdwliRh5/mGjRAXhIcmtTUeo?=
 =?us-ascii?Q?qUTDliKcb33bCLlt0271IWTrVrGlFINa0Bf8+Hk+nnfbLGlCFWNbxPfPvILK?=
 =?us-ascii?Q?SO1XAZiL3hTK5ImiD3ZiTmz/2AEzqjmaq9SZsWABnbHzPMp1lNxius2NhCkQ?=
 =?us-ascii?Q?0qZZGtg8cKFBVMjNZ7gazJCY06H05Vu+uj8PEIOfv5KiY8J+aKvLlZWYU1Ht?=
 =?us-ascii?Q?F5yMA4QRnLI7oRZ+qAyuQIgUg+I36eOnZdeoOzNGQVJmUQEkgvHlEudWFf51?=
 =?us-ascii?Q?cCqkBN7h00hDlTD5YzvZfOPPdRx1tNFuJceToRhcEcW0GzPXWV9t3XVsuT5g?=
 =?us-ascii?Q?B5kIHS78TgbTCfgr6/GkXc+bjCxW6MmDlWvtSB8lZ/LXl8Q3VwI99XeooG3i?=
 =?us-ascii?Q?a4joHkBvZ8affJy8+RGdy85mjqhClldNnG2XDfEoXDpBnvrdJm1y1txc/7p0?=
 =?us-ascii?Q?EY1EQQ4ULwxjE6ulcTbZwx79lidXiPgh13I5jyv7LVfaYBfjb0M5+YmSrabT?=
 =?us-ascii?Q?dT4lyLIYYMQSYF+wLhAG+mTHbpvyBPKMeELpxmi3R6ysqKfj93LCfmCMIjPk?=
 =?us-ascii?Q?OzZvJDmAsecs13Lw5gCiH0PAv7qxxVAcLiJXn3f7PxUMDAIiWPb4v7YyRDQr?=
 =?us-ascii?Q?IAZZ02+Zj4RgtHCDIcLlV7aTSzsRqzmsPfdYW4Uk6HC1dc5+6HhLGWLjKHyk?=
 =?us-ascii?Q?iBHpzyHRd/aynNIhyE7v70gB3bNicutZ+HZBTzvToqQ5topnU/fXikPW6ZpP?=
 =?us-ascii?Q?U0MhT2IQ6yeTiKMenvnWrl7hn0z5Zv9Gf3Hka5SebbjHGPlpCJNSCY00ww67?=
 =?us-ascii?Q?L5gohrLG72LG2WStcs8WLRCLy0rfpLCmyuTvzQHEyU6fXx7xLEvRfW8N1hQV?=
 =?us-ascii?Q?qKSzcxgr20OtGzgC8jXEUrd/DHpksh5h2BLauJV1Me0+C7Z50wRkkkV/gs5U?=
 =?us-ascii?Q?UWnL4g8dUebkDGQ7z/iliP+bRXmmv22klsLzvbtVSZGSCGBNTkgZCGzEj8Hl?=
 =?us-ascii?Q?2c/aFGhsUly+2dx0GTPAPceHKh3G4J3dyMoyTCF9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c88b71-3835-4539-e686-08db981c50af
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 14:32:38.5016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2L2j9vE8Lu+/obyxPBsmapsGJijWem5todYvdUNU+jwk4/v8YuJ+C3WCWTr3kLE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 08, 2023 at 07:26:07AM -0700, Sean Christopherson wrote:
> On Tue, Aug 08, 2023, Jason Gunthorpe wrote:
> > On Tue, Aug 08, 2023 at 03:17:02PM +0800, Yan Zhao wrote:
> > > @@ -859,6 +860,21 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
> > >  		    !is_last_spte(iter.old_spte, iter.level))
> > >  			continue;
> > >  
> > > +		if (skip_pinned) {
> > > +			kvm_pfn_t pfn = spte_to_pfn(iter.old_spte);
> > > +			struct page *page = kvm_pfn_to_refcounted_page(pfn);
> > > +			struct folio *folio;
> > > +
> > > +			if (!page)
> > > +				continue;
> > > +
> > > +			folio = page_folio(page);
> > > +
> > > +			if (folio_test_anon(folio) && PageAnonExclusive(&folio->page) &&
> > > +			    folio_maybe_dma_pinned(folio))
> > > +				continue;
> > > +		}
> > > +
> > 
> > I don't get it..
> > 
> > The last patch made it so that the NUMA balancing code doesn't change
> > page_maybe_dma_pinned() pages to PROT_NONE
> > 
> > So why doesn't KVM just check if the current and new SPTE are the same
> > and refrain from invalidating if nothing changed?
> 
> Because KVM doesn't have visibility into the current and new PTEs when the zapping
> occurs.  The contract for invalidate_range_start() requires that KVM drop all
> references before returning, and so the zapping occurs before change_pte_range()
> or change_huge_pmd() have done antyhing.
> 
> > Duplicating the checks here seems very frail to me.
> 
> Yes, this is approach gets a hard NAK from me.  IIUC, folio_maybe_dma_pinned()
> can yield different results purely based on refcounts, i.e. KVM could skip pages
> that the primary MMU does not, and thus violate the mmu_notifier contract.  And
> in general, I am steadfastedly against adding any kind of heuristic to KVM's
> zapping logic.
> 
> This really needs to be fixed in the primary MMU and not require any direct
> involvement from secondary MMUs, e.g. the mmu_notifier invalidation itself needs
> to be skipped.

This likely has the same issue you just described, we don't know if it
can be skipped until we iterate over the PTEs and by then it is too
late to invoke the notifier. Maybe some kind of abort and restart
scheme could work?

Jason
