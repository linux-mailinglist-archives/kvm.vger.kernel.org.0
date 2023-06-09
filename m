Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF39728DA2
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 04:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbjFICKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 22:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbjFICK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 22:10:28 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C290C35B6;
        Thu,  8 Jun 2023 19:10:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8E2amV0Tdb1r8P9K86kfG9QnjbEsRDTz3NmCLx/gbLccO2EQb05RsU2CRHFGlWAWQNt4yACwrxnFes/+FhJYcmWUrbE/EqRd9VLWwVELTC/p4t4rSLJDEoPkpHEUmlNRGApMfAQHjW0r0U1SlHBzotgcwIrJzx9IrMxLSykKa6nYSRtqyoRwoIixihdciyEM2wyEq2CWEQ6ZES4hsJHezPnSVTQx9oC3uLKc9cBqY7T83V1ayRPf5PO+/v5IHlmXDNKYMBA4Jn0eH/ahdf0yHGmJA591Mv9jJk/Ehr/DVN/HDNEkNzFoNvL3MDuQGHH4CJOpYW+CNPrsvxrAzIqoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sNM/FZhikB4QFTPGCSRzChg0WIisPX1Ct1FJv9PTC2U=;
 b=V81t18Atu96qJlR5qhFTBG4+l2vVU1OlTcLUjTszCaJuB6h9O9BMAm4CIXlto/WMCB4di+goaZgiW3dXqL4Bb3PJFa8ki+xAnFVFKwg6DakABX9src/jSO6sWpe+MlilNOfK05gbdZwzbdFXGJlgG+teF5vKy9riTaIxXhkbIp0MyyVC5sFkxgjwQ1KABIyy5XmwSiuO9mvF9QfnOuI4iB9V86W2vNz95HBol9gZiDlIaN4DojCb4p1HqYgocYli6rgPr+6oECMvVlcmiNt9OXAWoDQdpC8Nvp6cWqNkeBG3fGgQSAt26Ca/Jh1O0C5Wb5KqbDbMWAgXHi14mJfnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNM/FZhikB4QFTPGCSRzChg0WIisPX1Ct1FJv9PTC2U=;
 b=CGeXBBE7/gsydCNhS3ciRKsnS+aSdRNnCn2R/5IzKjRmm0EvuHD3TY4HOr4isWDtPcyZciY214uZFi8i2V+9tyJIMB/zcEE+szYKWke/uOdOsUqOemQ8Fwm/eT1idV4XoB+zoVI/1fuMcf0j2eFb9sPmIcfd39vj+tGIs+DBzqJo4FkIa4L9OThNCUvf9/tTUZ7FPPXoceAD8Lh/YSeE7wfSsh82nVqMMbvlG0PowVUEmSBFhaOVO/pTAHNg0UAT2OQoXYTBWf88kxy3n20zKzOmajUlniJa6iVXI8fLekCYodDjSo+bPl3krSUO3zIgzjRdketwoMRJOR9T4acPFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 02:09:42 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4854:668:e67e:b61d%3]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 02:09:42 +0000
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com> <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com> <ZHZuSDp6ioPqI272@google.com>
 <ZHaCAJI+OgIfDWSx@nvidia.com> <87v8g9qr2z.fsf@nvidia.com>
 <31cdd164783fefad4c9ef4a6d33c1e0094405d0f03added523a82dd9febdf15f@mu.id>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Date:   Fri, 09 Jun 2023 12:06:49 +1000
In-reply-to: <31cdd164783fefad4c9ef4a6d33c1e0094405d0f03added523a82dd9febdf15f@mu.id>
Message-ID: <87pm65wfmk.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a03:505::14) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: e1f358fd-c4e6-4fda-ca62-08db688e963f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfBctvFrZJ2zRHcn2E0dPI441Q5aS3IzBNPz8km/jumH05kMeKH2DMJRBmgCMtfduluZAlkhhOSj33MSSQnTCOMXOfIDR6BMb961zBWy1AEdHbZGd5k8YKnZsoO40J2SOUVTqAwlnyvzWxJ+w0WUUswHfO/y+THz308zFKloWzg2YctM9dJOu6l5NwUpdtHn/z0YwWR0WgRNqoPZ2ZYvtb2KEXVN3ZiJtv5ST8TtGyhhhB9W4XI02/826fcHNfTnvo3gvLBmL9vhFcrludYTsQMqTSxBAhBR763xWatZczYQiLvbWpEfS/QmlAwcbcVFul3JXDdrN5kXTKUqqGFR+uECfSuK7kwGhVCk3i0I1Cw9x/q65HOP3Smd/8302isQ2dODJlLdiKZMv9kVKQYMnWBZMuAXxTz58SI6j9WtsVLqxPG+Vvg5katp3SPtuAS2LfxiIA33fMXcXsqgb7N9qnPVsnAOT2+FOnswNmJC1EjPXFf0vNTDiV9/pJGIn9rRQJFpm6CMMZvekDxUBmLz0AMQLGlfrMc/alKHDZMdjS7pP43J2UflAJEBLQG9fXr4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199021)(2616005)(86362001)(36756003)(2906002)(7416002)(186003)(83380400001)(6512007)(6506007)(26005)(478600001)(6486002)(54906003)(37006003)(316002)(66556008)(38100700002)(66476007)(66946007)(6636002)(4326008)(41300700001)(8936002)(5660300002)(6862004)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MTu2OQYFaizCg5eJ3jdZgD1MiSdExrEGgdBW+ez5QmUg0/nvxzmfH/NeZmsN?=
 =?us-ascii?Q?yhgN97Gw9S8a5POLM/frwZ+EQHXmmPlbTCRxAUwbiI+u1Oou3bSgCxQowdSB?=
 =?us-ascii?Q?OFjfG/fTNKXPOkbJXiBUxGJPFIHJ0jtjM7cSsXa2fld3L9EKofTWl+POtNae?=
 =?us-ascii?Q?Uh95s90guQBfiwyUejvkelejyQl/1QRo0kf9jE5uIPLlsavTTqI5PNZEWz/n?=
 =?us-ascii?Q?yXNpsgNu4keO+OAA0iZ4y9vEFhFT6iSInwLDy3VocSNjhxXxwdvEo0icCmIX?=
 =?us-ascii?Q?qZjEPIvEalsgNJNeKcrj/kYkVz0hGqKZ+huVHl9p7x6kml1btw7xZT4KMPfA?=
 =?us-ascii?Q?g7g+dQ21nBHXgkYKq1MHfyPjvjS2IP8ZyBh338J3Hu4VP1fY4GXE7dKGRJHc?=
 =?us-ascii?Q?rlCx2eUNjPV9MMEbBl+DOP5PI2edlgj8P3H7tq8HXCxfShcFZcCxume3XKvQ?=
 =?us-ascii?Q?JmtC4KXnmTmKagORMywqsPRG07QBTdFB01YiApBzazwqU9/6Hq9VpLerKQCW?=
 =?us-ascii?Q?JRNeM6V4WdMf1FfcBYkWVuXwD3/X/klfwDJ1Bxo69QXVYEc+3GLWcJ/oO8ym?=
 =?us-ascii?Q?KaCjcQ6VOTlsALv4UbeLHA3CO0Xfn8730hU9cBSCWB/ZxLMpUxbcMHj97s/x?=
 =?us-ascii?Q?0DQYB81ZPJbsv3u04vmNrjkISCEXJGAm0lx8ONCZb1oWCXY8vwx1zoxlbsu9?=
 =?us-ascii?Q?Cm93wAbcjitBYExpElPo+YqjOm42j67ik3VV6jCHyVDhlPAYLBPiyTaSboLk?=
 =?us-ascii?Q?2NsLiTpSR1ihLqySl4DDhwef1M+WF6qMkUrhMbEv3Rd/l0FVp9k/TpW46vSJ?=
 =?us-ascii?Q?PfHG0FzEfSgt4YTcfCmB0gDaq/RCUlqn6UMbsEy8GcBON57BcCHjYALLOiuC?=
 =?us-ascii?Q?Iavqm7wrkLEMg6xklHOK6SpiWcCOUlHsSihAckp1n6WIbwBmQqX0TbC+aXwF?=
 =?us-ascii?Q?gW72PIXXrE+QbiZa37Dtf3p34zXOU5HkkNRb4YFNDaG7w2FDxvWTubfeTRJP?=
 =?us-ascii?Q?BqJJzwDkeBRyu1/t3Nd56kNEg+V9jRXtFi0zSCX3cd4XHpX7XXuc/DyQuhqy?=
 =?us-ascii?Q?iid/JWwuqLPKh5VqCqvVH2/ipgMhupl1P1nVnUmya/4VWUgmctvGiyo1o4Tn?=
 =?us-ascii?Q?iukhX/0PlLnW2nw2NLuI7T58mbafYY5PVctfOaHeS/gzBXtHaRQ/kZEZK2Ni?=
 =?us-ascii?Q?NFi8TiwRmCdEZ+FxpGfdMdQOKybtbLXbu1f1MoFueB29saIKCD6H2L1M0ES2?=
 =?us-ascii?Q?0ZLVOrp7Ogm+U3IOXdAiIRnp27Ddjdiw+MI/9upBkAdtVf09D+CyQLaTgrTZ?=
 =?us-ascii?Q?VxvWo7lVdUV1AFaW6G5T4doZXnJ1lMqk+osXFCTr05pz2ZgxGRZ2zi67f2Xf?=
 =?us-ascii?Q?EeNedZf6tLZ9bCMYeJFOPce9Ht1qoWWPKmJ0fr0N5fjP+G2CorUg0zraAGk+?=
 =?us-ascii?Q?fCtSAOe6/BVBpxiIzdFq81GB8z+yaVNzL5pFEqF0pfyZrqUsDnmGqfivQOa/?=
 =?us-ascii?Q?vVDzEfIenPfcuuy5jA+bJzbwn0D/3jX1KM2W0mvY9xqG0k88Si3IRUxWOyxl?=
 =?us-ascii?Q?lcF6HTwz79E5H4Dvz7IC3Urmf2JOztmoQbnxY6wC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f358fd-c4e6-4fda-ca62-08db688e963f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 02:09:42.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfodkxfABQHgrC0UuiZIHTeVk6lOqKtevQzirar5gXdHuLB5TuKPiY10lM1rcyjuWZgbEYPIpCdsC3RwiCeZDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Alistair Popple <apopple@nvidia.com> writes:

> Alistair Popple <apopple@nvidia.com> writes:
>
>>> On Tue, May 30, 2023 at 02:44:40PM -0700, Sean Christopherson wrote:
>>>> > KVM already has locking for invalidate_start/end - it has to check
>>>> > mmu_notifier_retry_cache() with the sequence numbers/etc around when
>>>> > it does does hva_to_pfn()
>>>> > 
>>>> > The bug is that the kvm_vcpu_reload_apic_access_page() path is
>>>> > ignoring this locking so it ignores in-progress range
>>>> > invalidations. It should spin until the invalidation clears like other
>>>> > places in KVM.
>>>> > 
>>>> > The comment is kind of misleading because drivers shouldn't be abusing
>>>> > the iommu centric invalidate_range() thing to fix missing locking in
>>>> > start/end users. :\
>>>> > 
>>>> > So if KVM could be fixed up we could make invalidate_range defined to
>>>> > be an arch specific callback to synchronize the iommu TLB.
>>>> 
>>>> And maybe rename invalidate_range() and/or invalidate_range_{start,end}() to make
>>>> it super obvious that they are intended for two different purposes?  E.g. instead
>>>> of invalidate_range(), something like invalidate_secondary_tlbs().
>>>
>>> Yeah, I think I would call it invalidate_arch_secondary_tlb() and
>>> document it as being an arch specific set of invalidations that match
>>> the architected TLB maintenance requrements. And maybe we can check it
>>> more carefully to make it be called in less places. Like I'm not sure
>>> it is right to call it from invalidate_range_end under this new
>>> definition..
>>
>> I'd be happy to look at that, although it sounds like Sean already is.

Thanks Sean for getting the KVM fix posted so quickly. I'm looking into
doing the rename now.

Do we want to do more than a simple rename and tidy up of callers
though? What I'm thinking is introducing something like an IOMMU/TLB
specific variant of notifiers (eg. struct tlb_notifier) which has the
invalidate_secondary_tlbs() callback in say struct tlb_notifier_ops
rather than leaving that in the mmu_notifier_ops.

Implementation wise we'd reuse most of the mmu_notifier code, but it
would help make the two different uses of notifiers clearer. Thoughts?

 - Alistair
