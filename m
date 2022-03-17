Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC434DC7ED
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 14:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiCQNyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 09:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiCQNyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 09:54:15 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754E3C07;
        Thu, 17 Mar 2022 06:52:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2/XVpwvwpeiLNarmywdyiF+wgq9YPtIMaDNWG8c+Xi1K8/+tzM80YQzddmr4n72mr/S2Vrh/xzHqiKNGbtfl867iNwTmYYYk6hf/0Jp17ArBvibvYZ/3MmNX8g5cdPLFv68bdxfvpAsXLMHu1YFaO9j+vWCjL3WwZwTroojQCG24NZIQrnojsvyY7cCG1WjJWl4wzsLR5HGooqmxTrwCTpCw7/7IT2CPWn3gQ8SxoxAWJZwJMGJCE4iwhu5+Bi4p1av38dtsbLI/GhjXR3qJzk6o41hol+1zE/tQlU+SoO6QUE6a/Bk4K3CRzkhm4oPuu79NyA9EJU5GVyghTbHcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSEMzNUdjMMqw/xD0BOrGE04iPBZJC0/QLx8daWzblQ=;
 b=Z09kdMqiiLm5N33GR992x1YBYlU0ICwCZ1CpbpJLeH8Lg5Hl/CyM2YfTJPDNMpykTXqKWWIzn7QXPmCZ5PrCetLPvxkhNV6YTnYrpE8lwMqNO5FURszKcFferRBG6m39AfHZRUXFZXvD4iuB7DebDyOY0tkGotW4al9Cwsc7nn5myVzZdqjLcqCJzOXf+dHyL81aStn2uqmhSIHvmRYN5tTFCaUOfE2kSzltbstmsQA8T8W9WHFnqaiAiFebhxcGO61DoS6WV3HA/Q/wOQoisSQUxrsLStDvpI+qHCk3Un9EIH+U3NO+eV7HZlyj6klYGOCOG2uxch4WWaWkBNcMFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSEMzNUdjMMqw/xD0BOrGE04iPBZJC0/QLx8daWzblQ=;
 b=SI0TMU45NmmdfeuwdWzFOTrCN702/83K7NjvMJ0oUA4hJC2FHuj/2Uqx4vcsrRq8WbpAsooQLUy+sBDFvBI5RKFFpnOtw1d0X2XbFgeSynRSZ5x4j6qFkCsd91x/KAqZc4YKfPv8ZcIesaeM5CikcqgfjAkiRUuaPr1T1BhiPrY+WVakD5FoY7Sii1H+CD9h8AqNsMz0bTVWoO/btlSjnHxtDoNq6zYEW3ncMEyCX+Tcgq9uAteYgb8pJDC+0PuRHR522T9Vgugr6w0glhNH+MdZzmY9NuBwXN+lT3SSIuLkc4TLLplm75NmHTrqJbXnKU27GBr+x6R7uX8rqLD/Aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5873.namprd12.prod.outlook.com (2603:10b6:208:395::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Thu, 17 Mar
 2022 13:52:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 13:52:55 +0000
Date:   Thu, 17 Mar 2022 10:52:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "will@kernel.org" <will@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Message-ID: <20220317135254.GZ11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
 <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
 <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB5276360F6DBDC3A238F3E41A8C129@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR02CA0030.namprd02.prod.outlook.com
 (2603:10b6:208:fc::43) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4eae4042-1a28-4fae-8771-08da081d7021
X-MS-TrafficTypeDiagnostic: BL1PR12MB5873:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5873BB79843C7C82FE636ACDC2129@BL1PR12MB5873.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRg0zCGoDDZ5Aj+QpdYfZUoXKxBRlywHfkWjiYvQxpBp7cS1bJBgFRGBTQ1NgesKM8p9isBc7/KY+n3hzACxnuYGOTwco0ZWx7iZkwwVpHtc13NP/9zqJYZAUY8qUoKODuQLoG2NPcBlx9+9AVuKCZmV/YnZSt+P7r1QZUiIoB7hmhpYMiOlyicgWjUgqbXgqYsoalW1evIaerKW6L7NHSG1GANhnQSYz38kESe/FmipX3cJ0uiXKiD2jqN6xPAIBw+17N1lQ6Z5IxwESpl4kTMCBO9gGKGZUbbZ0EP59GdT6kCFqHuaWWrAakyg1U97TQ5cYUe+5sdvrq94QA8+3dj1CSlaY5KmlbaZiiFSjXDrFATzOVE1FZBX1iW8iij8D7dqp6LgSdUrqInv3m5lOmfL5eqVShymmEH3Yj5F8KX1q5qt26z0DvVf13njbl51H3Tz3HVW0WUGs44Ggm3DnqzDP45QKaJ7TWpP8dV8yfd/ohlBSCCyut9wsmp2OEw2eurkHiNYTmbF2rqagx/KBNpIpqbesYcojGx+Tz8NkwVzjBW16aIDYjRIeak4eGLZunmQFtVCjevB16m/IcmM7v3TNZ0WGLblRSzwMe54zwSeewEOICpiHO140mTgU/DEcaEqun/9ORVb0dnaWd65og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6506007)(54906003)(6916009)(33656002)(8936002)(7406005)(5660300002)(7416002)(6512007)(36756003)(53546011)(66946007)(8676002)(66556008)(66476007)(86362001)(2616005)(26005)(1076003)(186003)(508600001)(38100700002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mmhid21MaEZLTHd1bnd2UmxjQ1YxdUN3MG9RTzlDNlFBc0xKUjY2dk1Na29R?=
 =?utf-8?B?UmlHUC9BNm1YZ29nRjN5RE43aEJuNTcvYitGZVVtVnF3WUV6WVBmNE5lcE9p?=
 =?utf-8?B?M25SVjNPUmprTDk0V1I4OGtBVmJhU1JOS2dLK3ZLVFpGakxBV3hpQWxSQk10?=
 =?utf-8?B?cTRXcVZDTHR4MHVYeThJaFF3ZjZlT3VaS2VJdmFuZXN2ZmpRdFh5SEhLKzZK?=
 =?utf-8?B?V3R1eGpnVXdEZTU0Ti8wR1hubWlpSG95a3V5STZ2Vm4wZnNORFgyZFpXNWRY?=
 =?utf-8?B?U3dQME5qWC9WRU5NdmpYSlc4S2J3SnJLWDNYTEtRL01CYmFrQSsySkdxYURj?=
 =?utf-8?B?M3J1SjZvczdwMXl4L0M3ck9teEMreEh0Vmcycy9VN01jSzVPNmVqYXZCNXo1?=
 =?utf-8?B?R0cvaThJdk1rQi9tNmtMcTNFWW9yemthdVpEdmZzaHhvUTBVSFcrZXA3Um9H?=
 =?utf-8?B?b2hTWFk3dmk2bDNUcUl2dlB3MTBIQUVUdWRNYlhTd3EwZzNnSFZwZXQrWEJ1?=
 =?utf-8?B?TUwrMGZQUGFZeFQ2V291WXBwNHExVEpKem5JSXdVSGFhRDhsQUdJR3daOTVv?=
 =?utf-8?B?L2JnTFdYcWgwci9sNDE2RFgwS3p6NXQ4SWpsWTJJK1UyS0g5RHJCSlgwZU00?=
 =?utf-8?B?eDFKeG9ZeklySkdaOTc5NE5YZXRwaEJ4NHYvU0haVTk0T1Rmb1pZelpQOFlK?=
 =?utf-8?B?VDVqMEJpRWZZZDYzOXpLQ3JKazNYeWhYbnJQM3RDVk1FMy80RFgyZ254MWtF?=
 =?utf-8?B?ZkxNV0NqMHBpTjk5U01OMzB6eGFwTFNvRy9ydkJReTAyQVo1L3lwZ0xQNWF0?=
 =?utf-8?B?SWNLb2FzNUFValhZWE1qMStMMC9qTFNKSHl5Q3hrTEI0azdUT2RsaGlsQWdW?=
 =?utf-8?B?M0EydHNxMFM3b3ErOFJabXVVMHBPdjJ3N2REUWpQS1UyUUxlbTUyMDJFWDA5?=
 =?utf-8?B?VGRacTVxMWRBZTdHY1AxeHFSLzBEYTlzYW4wMWpPVFJqdXdyTHlrUmFnaHRP?=
 =?utf-8?B?M0tYZTlLM3JQa2ErZW9uckM2cE1oVVdoM1RFV0s2WnRqalpRMWViTlZZWVU4?=
 =?utf-8?B?dm50bW1VV2RWQ0Z1Z1ZBOWFiZitnK3cwaFI2aEtCVzdEa0VaTEErWVdXYm5N?=
 =?utf-8?B?L1AvRTR4Y0FmdVkwc1psNENheEtWZ29yTU1TUTNReGJab2xYZUJkYldDQ3Vk?=
 =?utf-8?B?bi9nRnZlZHVnTG9LZUVDTGh0QmlPa0lwa25OcTNock1DS2YwaFFjQmRiOStu?=
 =?utf-8?B?Ri9PRHN0MnRnRFVZdk9vTUEySndPczZiYzZEZlVpcm9GaWZvUkxPZHNONE1I?=
 =?utf-8?B?WmIxZHQvcFBsU1VFQ2QrYjQ2U2pUOThRdS9vZHJXS21IOXhuV0JjWDEyV2lV?=
 =?utf-8?B?WXJiUHg4NlpUK1dBbEcvYXhHK1RsbTVseTN3RzliTStPMDdOaDB4eDlERlhT?=
 =?utf-8?B?T2NleStoN2IwN2d6bDF1NjlTaCtLSjZHTHB0WS9zbGRma1U5ZTNOMk1udCtT?=
 =?utf-8?B?YWlZeDZTRkVXSXROSDdJUURyeW5VVHhhU0YrbnVGelA5NlBjZXlxWXJkV0po?=
 =?utf-8?B?d3R0Z2FOeVBzcXAvdWFqYkJub3lsdE80V3ZBK25YS3k0K3B3d3hlMkhpN2hT?=
 =?utf-8?B?Kzl0SE93cHdZVzJoYnV3UmVNbHBBK051c1NlZWRhanBjbE4rOTlWSVFBSWg5?=
 =?utf-8?B?eGNabVhEYThFdTh0OHM4c1lLWTNBWkQ5MG1Xek1pME9OY3laWmVTUnZhbVQ3?=
 =?utf-8?B?WGhCOWxZdGZGVWJXcURMelpkWE9kT1cweTBQMWt0YlpCR0FTejduVEdLVDds?=
 =?utf-8?B?VkY3U2FNTHRJdXd3RFBCQnkzUWpsc1hLQVhieHpHRjhWRDZYanYrcWI0bVFq?=
 =?utf-8?B?eEFkSGJwM0lrTDNWeThENzB0ZVFOT2k4Q01FUk56ZkNDamhpeWlDRGdEZC9x?=
 =?utf-8?Q?LSly1cl/jnuGYNYxZqnxBqyo76Bs1wuF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eae4042-1a28-4fae-8771-08da081d7021
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 13:52:55.6384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rt4o0qv36qTL9vBSqwNyZnonYn5aDGEDEB/upsxvSmtlOJQPzXnmdSShweSI184k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5873
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 17, 2022 at 05:47:36AM +0000, Tian, Kevin wrote:
> > From: Robin Murphy
> > Sent: Tuesday, March 15, 2022 6:49 PM
> > 
> > On 2022-03-14 19:44, Matthew Rosato wrote:
> > > s390x will introduce an additional domain type that is used for
> > > managing IOMMU owned by KVM.  Define the type here and add an
> > > interface for allocating a specified type vs the default type.
> > 
> > I'm also not a huge fan of adding a new domain_alloc interface like
> > this, however if it is justifiable, then please make it take struct
> > device rather than struct bus_type as an argument.
> > 
> > It also sounds like there may be a degree of conceptual overlap here
> > with what Jean-Philippe is working on for sharing pagetables between KVM
> > and SMMU for Android pKVM, so it's probably worth some thought over
> > whether there's any scope for common interfaces in terms of actual
> > implementation.
> 
> Same here. Yan Zhao is working on page table sharing between KVM
> and VT-d. This is one important usage to build atop iommufd and
> a set of common interfaces are definitely necessary here. 😊

I always thought 'page table sharing with KVM' is SVA - ie it requires
PRI in the IOMMU driver as the KVM page table is fully unpinned and
dynamic. This S390 case is not doing SVA/PRI

Are people working on teaching KVM to DMA pin every page and avoid
having a dynamic page table? I'm surprised, a lot of stuff won't work,
eg write protect..

Jason
