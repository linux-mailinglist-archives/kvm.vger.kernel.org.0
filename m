Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440D272496C
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 18:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbjFFQnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 12:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbjFFQno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 12:43:44 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF710EC;
        Tue,  6 Jun 2023 09:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XY1/aCpjy0zCqtFUfrBUhnvtKGlorIdsVcjk4r1s1/Emf+xQ6T1Uswr39L4F9bZSbVZuDAzqDL1NcLst0uDUdymnxfWU1sgT/GmoZvLAEKrCxAAvidiK0SKQYCUK4xQbHtr1l3gqrO0n1VRlkUdnk20aCTSYxHvcURewE17R+VIL9HU3rB15933mEVQe+skqsRxNLHdWzbupVYGMS61qsKiBOHSnQiiB8onlWRFqso36NujXcn6amU6jiHqWeM3qDgm8bXE3fbGn/nnMzjBa0u/3YG9uL7qQVURK9+cyGoxsilCqKRmfyUdz1m5v9/b9JAuMnHRVK7hsqldzGUdFXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7h4sST+Glcyb9qBGFCy1C/62yJiIMu+HOXDIAf0AyQ4=;
 b=ZEZ2WJlc626cvpia64n6W2uCD91Mt0po2V8+It0R7TOrMckVqGhoJOCqhrmI8He+JYGfUXWGmaor7TtnPzO0oHS6DudBO4PKvcAkY9xAgQ7KF2SQdsnD6iBIckE30KjesqGb7MvYn6bJoIWKk14lC8OLtkqiqNfhnF+M9fCRv9NT+abUghltf5Yvhj9QOKZqYJIYCxUKSYfxDPeqdD4WQqjnrdexhald5InrO0CzqYisUki29mOpoxALFCPAMPhIKkMtEpk4SijOSg7CqC3be8/LUYXtUvp3J9wAQppkIEvjqP3t7RnpRTCtSFCNvGwJHjPSbNPaDh2BbcAwKnKpmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7h4sST+Glcyb9qBGFCy1C/62yJiIMu+HOXDIAf0AyQ4=;
 b=mu0U9xxnLwIIhS63Aca/heuyFpnOWaDcLQPnEXDwc6gXHUl3K+dQqVaNvENmUfufDhbyJLotLyGthjLf9M55sGmeccEZ9NQ9ZSvw5Jb/qkMc8NOOMLh8apwM3janWkc+TLsZyAhVS1p77VBgrUlg2Lz9afNR30hg92FVoTwfT8doB0h9d3BZKEBetvVY+HENfyZWX4+4DW1LIf3UAKGGWrQaU3TWhiFFSsFE9CW/vVYMldt0E/GGtdGHcyAJXaMCpTgWJYzh3lxTDZfLyhhwm+xrdc6iTmj1tW4Tr9TEeIJYwdqR0z4ww3GRlX3oyIlM5I72N3nDWoDMDbXUmWvouw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4917.namprd12.prod.outlook.com (2603:10b6:a03:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 16:43:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 16:43:35 +0000
Date:   Tue, 6 Jun 2023 13:43:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 0/3] KVM: x86: Use "standard" mmu_notifier hook for APIC
 page
Message-ID: <ZH9iNAPRBESPVmPA@nvidia.com>
References: <20230602011518.787006-1-seanjc@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602011518.787006-1-seanjc@google.com>
X-ClientProxiedBy: SJ0PR13CA0034.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4917:EE_
X-MS-Office365-Filtering-Correlation-Id: 6799e05d-4858-4545-9259-08db66ad2bcd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RHqAj9V77KUG72eo3ynzlQE41X4RKTJKXWULy8TwsydudqrIBVizLjlaVFq9ezX7xbys10tsZ/bGikPHYcc5+/pgqvfdslD4Uv4AuF9LjiYJAjWAmwiZGY8tnJ3HKZarUtihjs/ewAW/UZW0h8yEcdc1YTSPUkMDNFmG6Rfi3OFICE5DLkGEowh09/f3L1BeVY2m+ArL9Ge31hDIutUg4Ut9bWXtQtsX8WO1YhbmmPguqmpFuryMgdlrDtWdOfD9ED8F0GvW6wWfl5W3Pigx5TWLKOM1ircUdeVxroksPbnqV5+43+tfNmOWEfvYg9xXv47Fz4IL+S7HRcgkHhpnSgA/EOZ3fLT73/XxDyKkkraP2/0Vm1jk4Xo5NUJcPtrZSGMESAbg4DLib0g7eMEN9eBExzHw7v9qnSvFESIsq+H5h+1Y4khV4Yl9+5iEY97+nkNkMlk4UDRtoy9h+TwVT2T8B26o9iHrXoNR1+JulsM5yNUB8+DONodGZ4sok0zP7cyz/cV+QhGYTxaiMM5UuTSOTkrt61R+5C1z/XsNWcctz8lva2C/wooaLGvqXzdv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(451199021)(41300700001)(316002)(478600001)(4744005)(2906002)(36756003)(66476007)(66946007)(8936002)(66556008)(8676002)(86362001)(5660300002)(6916009)(38100700002)(4326008)(54906003)(6486002)(6666004)(186003)(83380400001)(2616005)(6512007)(26005)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hGpmJhniPYvjvR1I9br1+hulroONaHjIORDNumeNYIhcGRc/3SwsTYran9xJ?=
 =?us-ascii?Q?roYhwAGIf97zy4D6Z61yxENH3CJBvnkpoC2RliPyZU6YO+fL3a5PjFdExUem?=
 =?us-ascii?Q?hx2TKJlYWuWRwPYK4BXkhC55GKDI8g8XF0D9lJIB2KB1cMaiAYAALmdlkI5F?=
 =?us-ascii?Q?3axOBdf1YHiUbBlT880n5Ic3s0LlEOlyANjX91WQVildQDqR15CTqIDnSQB8?=
 =?us-ascii?Q?DmiO9bsQG0KVCQjCvxDatJrQG/j67Jy0AJjt0tGC/YdeA38JBFoM7i/Lykqi?=
 =?us-ascii?Q?WKGEHq/BwMXW8g01Ayoo8ILIdDM9UTWPZ7XBEXLwQ5lp8hOp+UKvAEn5LYcP?=
 =?us-ascii?Q?sMF0nQWhQHxbuSyVA3m2QaEw5vsqQ6bJsLj5PN3nT8ztasUdrIE1Wo6uUR5K?=
 =?us-ascii?Q?MDtQ1pnAB3pHhQafi7YYVHAGtu/BHYADKfg36wXYeme0RKpFYUslpTHzFROt?=
 =?us-ascii?Q?L5UlKjHQMPC7Wiwov9ifUaBcePWhM9jVv+iGbxLsyKObA+SQMHMmkAEcVby/?=
 =?us-ascii?Q?Wjhds2GQTFch3E8X6/iUsJRFy58IH6YeZqDy3MoeNvemmCBT7YAYirkpCzoZ?=
 =?us-ascii?Q?bHZBbygYDnYy0ZuACmpEDjt5nVI5mPhzZeKlHec59irQx9LuToSRGsemoJ/R?=
 =?us-ascii?Q?Nre3PDEySNOP/u36m8/+w2l6YAI8TqwvAxa785es8ySlAS/sqBf2ZvRHyjx6?=
 =?us-ascii?Q?tgSVhn4qxXb2sRnZc6Ky3hZFb8C0uDieoFRt9pXWC9dvrctTi95eZyFEXXAz?=
 =?us-ascii?Q?1HaVbdh2SDBP+EM0EtSbSFg0mBsIyxoWWxQTwLnbCpoKRAG/IFCwtaPoyxYj?=
 =?us-ascii?Q?B2QwNScho6WiuwkRONIOe4laU1YDso5+2PX6WrojstANjb8G33nAV6GVi5CE?=
 =?us-ascii?Q?gfsrbLWkrziHExbPcjyBHp6ADBDeVhP3IE9rXAcqn6hQoQegn23KGIdEKpDQ?=
 =?us-ascii?Q?R/QZGFeAtB50p9KMDxCOCKYnCSq9PRY3MvdOexp00jZliyDdSXmYISI28+LJ?=
 =?us-ascii?Q?1lalzpsksJXz3uPD/45uX1gtZwBh5H3HidjAVAcTeL6MIvk09wp+9dOGBDBE?=
 =?us-ascii?Q?n0ZYpdgH5z3H40RaTK+dTYIAHaT4bb/BG74YhAQyjSvOTOwMhSOhZ8iHKYnU?=
 =?us-ascii?Q?j7fcxcSKKgFDijqt0+xwiDv2Ba9t9Kz5j0YfqVBxgCnW5+ecinbCpsvQnWze?=
 =?us-ascii?Q?xhxoBP7zyEzlAnebydNX6MXtNmEuOhNyEl7FQ3dC/fZfin+qCad86e9ur3Jr?=
 =?us-ascii?Q?D1k3Qp4N4/YupFeHqkRCX8tCAPYYstn26jx0CZ2KzyV0iJU5RzIQnlT6r0TP?=
 =?us-ascii?Q?t6ZB2EJyPckeUmsAeXFVCc1JPX0HdMjvc8RWE1yYkjvINsDAn7Z8HISPQt7x?=
 =?us-ascii?Q?wbZPBVlsXUKLz5BWNzd20cGLcd0Rf0uH6C6rIPzE4EYiI7dTkKYS3mFw15da?=
 =?us-ascii?Q?+P//i6nLoxRufmUVQ0y3XWpmH1v/SLfPCSP0usdwefbOK8ut7vWCqeyMbmvP?=
 =?us-ascii?Q?iXtpZh2AGmvb1k41GLUBHqZ9o05G2KLBVvgQsrW+wdVgBQBWyT9vD5GjZVjd?=
 =?us-ascii?Q?k/ixtjXOVRBBDXkprMh1MfUJN7eDMZpTlcutBP4Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6799e05d-4858-4545-9259-08db66ad2bcd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 16:43:35.4556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aT765da7iCtu9U0Y0lvhheTolc8Y6LIRjC0OKtsMvcqRYVe2vHiAp7tQyWf6dPHR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4917
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

On Thu, Jun 01, 2023 at 06:15:15PM -0700, Sean Christopherson wrote:
> Convert VMX's handling of mmu_notifier invalidations of the APIC-access page
> from invalidate_range() to KVM's standard invalidate_range_{start,end}().
> 
> KVM (ab)uses invalidate_range() to fudge around not stalling vCPUs until
> relevant in-flight invalidations complete.  Abusing invalidate_range() works,
> but it requires one-off code in KVM, sets a bad precedent in KVM, and is
> blocking improvements to mmu_notifier's definition of invalidate_range()
> due to KVM's usage diverging wildly from the original intent of notifying
> IOMMUs of changes to shared page tables.
> 
> Clean up the mess by hooking x86's implementation of kvm_unmap_gfn_range()
> and stalling vCPUs by re-requesting KVM_REQ_APIC_PAGE_RELOAD until the
> invalidation completes.

I don't know much about kvm, but this looks like what I had in mind
and is a good way to use mmu notifiers

Thanks,
Jason
