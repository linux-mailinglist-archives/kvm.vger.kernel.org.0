Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922C671715B
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 01:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbjE3XJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 19:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjE3XJ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 19:09:26 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3A9E40;
        Tue, 30 May 2023 16:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zf2fKBLLMVDIs5s/zKv0Q4jj//X9xHBXmXtHFFaShRXtHkbdvXq/fhoRFm70FpniPhsXRld4hGXcCluU742Yzu64NFGYYW5qvW3VSTqmg+50pETr9ThKHHIJrVHcUOm+VfZBL3hEhiv9rdDXSV+HucBktRSgpJNdSgDDO3dLoagZgxzSr0jnMEcZGonEgzpoek0isYOT4bHst6Gpabqp3+d/ze0hfIA781SWSSzPd7qIcl4TDN3Z5cpCaS2IwnCvJkHMp/25gLXW5lhY/Yd//qxbS4UUghKf8EPMSEWJXHvz+4C8Qs2YFAr70HVcvWxwtU3Bk8vnrZcRkfpuwyNYqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkEpCMnplkamyuzNhxonUXQG179JAgHI39L8b+nE8b8=;
 b=OQVqRw+wugzHD+jTD0omF5/3SgXSuwsaiId1xzrkwnHPPsY+oLe7tcw2/BjAWAVFtIB2fJrKlkAW+Q44+F7/eoflEFrrRB8KSJ9AyfaAVm7NiEZ7YuanlJBEVyPE1/L8xYuNsQ0++DJFWM9Qr7Kgu4CedKAMTFCPlCDgFiFt3iRoc9EumPQEmqJebf3R9L1DQsVmN0+V6DpeelhgQ/jV3vyjvyrmFcucLB6pxYM5+ND8wHMPjXPtrlf7ccjvwepGxjO2DKmyAkND4nnQKzqfsE85cMSUM7EF7XFXxTxGuQJxlGwp9pYtNV1JXHdWWqkOvPP/WM+0D16II8TVBl42iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkEpCMnplkamyuzNhxonUXQG179JAgHI39L8b+nE8b8=;
 b=pB1rZvS5frb4YS4wJRvjMs8K0hknBufCeGJGmXcoBDucKedE5nikhHdkIZQCBq/N0mgw+qv+pKfbiqnyI6Cffy8q/oI+ta6VIDJBLI8sAQIMAEtMvaG/ICJiq6FLynSU2O5AOJ3LZJbVm1GMQ5hNxW1Tofa8VIdQwcael9tpsq45hAwNvbRV5ilazuHIi4ywjhbH4YMc1iRnANfhsyqBLrJb9CEMwnAlrvnsMUvafDRyvjb7fOdZhCKHyVCH4fNFzEh+ywYraHwNBwHZHumXWTXDFIpDMxBAPrqXv1X9UZVG9O09OTBFRwOULvTfXF3uWq+fgAJnO9nH/QBv1+SZbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 23:08:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Tue, 30 May 2023
 23:08:50 +0000
Date:   Tue, 30 May 2023 20:08:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alistair Popple <apopple@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, nicolinc@nvidia.com,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        John Hubbard <jhubbard@nvidia.com>, zhi.wang.linux@gmail.com
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHaCAJI+OgIfDWSx@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
 <ZHKaBQt8623s9+VK@nvidia.com>
 <87pm6ii6qi.fsf@nvidia.com>
 <ZHXj/6Bjraxqk4YR@nvidia.com>
 <d2e591c1-eb43-377b-d396-8335f77acef6@arm.com>
 <ZHXxkUe4IZXUc1PV@nvidia.com>
 <89dba89c-cb49-f917-31e4-3eafd484f4b2@arm.com>
 <ZHYCygONW53/Byp3@nvidia.com>
 <ZHZuSDp6ioPqI272@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZuSDp6ioPqI272@google.com>
X-ClientProxiedBy: YT4P288CA0044.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a365f0-4847-4786-1884-08db6162d412
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ap65RPt2o0vP1HdtuM2OLU0CKaRC7rGPM4L6BhLQcVZcbgaSBR16sStm2ZdKMA9yO83aGGKeJIF+/dujG2CyUP4x/W4okX8oJEoAoDjfOayjT9MNocixpAEAicFjkTRLjvYpAmQ++sf6xpJlTViiFE7o15p6p5v0XKJ8CWf/9dlVyEuhKqztnZKUo3RjN/4sQWiUWRPGZKeuVtZdYaRUpq7cp2WABdjr9zhsnvKmouvj3i8RFDDx8RjRz4jpdqOC5KT0aEYR6NxwFvLJkSxUEEIQxCO6s275vkt8k0I/qh/zGb3Ub+umg7aN8mrCJh4hJVZ7Bqclaxll7EsKvCGUazgrmc05o2Nw+Wbltz02fRtdW9DtFfEgHvHiYj2uPGsoihTxUoj59fp94GIfQJdQsNPIYwadkd0xgRHSnNAhNWNAWw4Sf3mL2LLIFWvwc1NqueRkslgqHzZh+Kh1pGIW6/BGg2E3UtEdH0wyiXpqBLpOeNWhZJdnewIBv8KWVhOl++nlwe24C7g/qMdVRlAzCbckR2svJtKOoqnRgLsShQubQaP7i76n0ohweuUTzA22SjGmmDXNB9GvEQicme2+1ntYvivAnm7pQPo5MOtwNP8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199021)(54906003)(316002)(186003)(6486002)(86362001)(41300700001)(83380400001)(478600001)(2616005)(2906002)(7416002)(26005)(66556008)(66476007)(66946007)(6916009)(5660300002)(6506007)(6512007)(36756003)(8936002)(8676002)(38100700002)(4326008)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AfkqfgZPcugXGeH3O8JEqQqngSYeP1omBoY4QJZ4mN99/R0F7lLV3+MLmv68?=
 =?us-ascii?Q?AgEgxoNwbkJIWcfEd54XB/Z6Kc9qvfto9mn6CB1jDtOGlaDz5mrEhSAruzDV?=
 =?us-ascii?Q?rceldf2TpFCP6MG5s1nW/EVs0Sf7vpLeGzRDfXZ/Jj0retpPo8U19eNjV7HS?=
 =?us-ascii?Q?kmYr9FSCJAuqpDqfEawYFrWM4w68xOVmxsueAC7Amd5KtAi4BhINMpq8WK3y?=
 =?us-ascii?Q?fDRVXbfwFNPlC6Nt3SPQjYcPs1c83Q7lN0PFHUtpJaE5pP8YFvn5YVDdlkng?=
 =?us-ascii?Q?BZgW7TGpj8SX8mU+sZCDfN6nuYLrpYiVBZ87OoKC3tFm4CSmwPQhkrGdBnOL?=
 =?us-ascii?Q?svZ6dAOSs79M5arDbvQiQqMyPKOAZPXwXH8iFdLnILOgRyYyjZFeq2gzk4jI?=
 =?us-ascii?Q?5dkeAnIjXEdlkr+3U/ULVLi+GO2geyGw9FX9U7vlhTkADZWoHbdPqlupBpCU?=
 =?us-ascii?Q?srcf/Jf5HuvNn+bc4yfEm0GEp/77eH0Qay3xbI3sdBOqdRKaUwH+DjmmbHea?=
 =?us-ascii?Q?oQNPW1xxupCjX5L6WDwzcfLIRdtRQgow2RWFC5nyxpVXYEWHX/0IO/dVrqAq?=
 =?us-ascii?Q?5m8yYzZRTxg5r/cDogGbfcZdtan2OT0sJ+GZKeEiBiY8KQ07+v/jmgwqMRsy?=
 =?us-ascii?Q?vt+O3tHtbfy2LQuEsUWoK3cBv/ememTn3MkY/e6L50F9qSklBumeX0Y0/6J5?=
 =?us-ascii?Q?6d/+k5YZfhTKIbF5+HdUfV2MmzyR8tjw+FF/FiQPwZsIJbIRW9bUTwM7sRwT?=
 =?us-ascii?Q?wdMBr4/Sfu+qRbQVJPIO04b8Qxp+UOBfOfSjwmWckNPnLSkVd4D3fAw/aqB0?=
 =?us-ascii?Q?JPZZ5JVarH6fTMVDxFE9pDPwhoNvhFZPUKY8pPn08Ve2x4nyr8hwsQ9bZ8EV?=
 =?us-ascii?Q?G330Aylld0kcVb9Ock75B7K6TyMlt9qbyRLzinVMBAiR1AfxX8giowDOpCzN?=
 =?us-ascii?Q?5JhnwiYNKcR5VLZnTom8ukjAnuuTQb5pK5kxap0azOVO4KuZH7EI7N4e5GgX?=
 =?us-ascii?Q?Jm/lmzHluavjgw1/CAaL6Ekc1ADjg6rnEmxal/nmqMUMqEV279nWLLXUvL+u?=
 =?us-ascii?Q?ATxaMn0DTnKZNUqUBN5SGhwQJO0ZW/85uNWIodST1f4252ORk/eFInzRJSp8?=
 =?us-ascii?Q?BUe38WhxdhcYY5rYIMsMWWaBKRVXX0jBkOh2vcEfC0jCGpi9tdeTco59tZyc?=
 =?us-ascii?Q?uyB4PG3fZX5QwrB7DcMRIV1V5Yy66tOT8lIgd9Fy8znihtS2eHvZXMUQ1CiV?=
 =?us-ascii?Q?+jZQlkCt9rmiK/Gi+7kKGXHTULVDvk2h8CekBTL2LNFnG+GR6ODuj/cNpOL/?=
 =?us-ascii?Q?1qjfgbL1DvQTe4XZ1feqhnvOk8mToeFc0wxolZA8O/gKpMvuew5Ta+TukDyN?=
 =?us-ascii?Q?J9tcttLJDXoeD6KJlUK8CwxLKn5Nt2dkvzzUlnbwuhzio7y/1Q9q80OXTIPH?=
 =?us-ascii?Q?IBS2CMUDSqUGrHPe+Z3iaaSN6KciwKz5fFzyMtOpq/9S/KtMIHftEW4HKO9j?=
 =?us-ascii?Q?tunNZbJ/bdH19pnofFT4VNNATR4uVKXDIVtbwTGK1kD+GssyPS89KXD/VIfC?=
 =?us-ascii?Q?I+lucZ884IVNyJqvOPbNf7qCiRR6rzmGHMmqz3IS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a365f0-4847-4786-1884-08db6162d412
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 23:08:49.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XdZiMdUugG+50vtafqeKqTv8j1tZo4jIULfuNwXupQ5+KUBsLUel4DyyBx6Nljc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
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

On Tue, May 30, 2023 at 02:44:40PM -0700, Sean Christopherson wrote:
> > KVM already has locking for invalidate_start/end - it has to check
> > mmu_notifier_retry_cache() with the sequence numbers/etc around when
> > it does does hva_to_pfn()
> > 
> > The bug is that the kvm_vcpu_reload_apic_access_page() path is
> > ignoring this locking so it ignores in-progress range
> > invalidations. It should spin until the invalidation clears like other
> > places in KVM.
> > 
> > The comment is kind of misleading because drivers shouldn't be abusing
> > the iommu centric invalidate_range() thing to fix missing locking in
> > start/end users. :\
> > 
> > So if KVM could be fixed up we could make invalidate_range defined to
> > be an arch specific callback to synchronize the iommu TLB.
> 
> And maybe rename invalidate_range() and/or invalidate_range_{start,end}() to make
> it super obvious that they are intended for two different purposes?  E.g. instead
> of invalidate_range(), something like invalidate_secondary_tlbs().

Yeah, I think I would call it invalidate_arch_secondary_tlb() and
document it as being an arch specific set of invalidations that match
the architected TLB maintenance requrements. And maybe we can check it
more carefully to make it be called in less places. Like I'm not sure
it is right to call it from invalidate_range_end under this new
definition..

> FWIW, PPC's OpenCAPI support (drivers/misc/ocxl/link.c) also uses invalidate_range().
> Though IIUC, the use case is the same as a "traditional" IOMMU, where a device can
> share the CPU's page tables, so maybe the devices can be considered IOMMUs in practice,
> if not in name?

OpenCAPI is an IOMMU HW for sure. PPC just doesn't have integration
with the drivers/iommu infrastructure.

> I have patches coded up.  Assuming testing goes well, I'll post them regardless
> of the OCXL side of things.  I've disliked KVM's one-off use of invalidate_range()
> for a long time, this is a good excuse to get rid of it before KVM gains more usage.

Nice!

Thanks,
Jason
