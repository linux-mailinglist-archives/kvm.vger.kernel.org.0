Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6121B4D8EEA
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiCNViN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 17:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245422AbiCNViL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 17:38:11 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980D3E0D7;
        Mon, 14 Mar 2022 14:36:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwuFUdPqoClDFAFh+2fOktyfLru8evFg09atgb2U27uJbhsB9mFCAtdrpJ13FO27nHZYuXXPZMetw/z2vSqldzghgY8PiIndLJH2DkbEopfRCDUgNAlVp+ifXrLeFMdrbjKrFfZcYbvLa4vWwOhaXUWOGj5WvTN8dqNq504f5CdOYr1suLdPyVAnNDccGxEW3pfSLAecB1ls1I07+S8/h9saJ5zLnB/VA5JU1DCmwMj7wunNNdbsIqgH7Wr3j5TO9mYzRNZwDj/dDYyy9XpMj9PX1jNzCNiIewXsPItiASwlI1LhLUIpzNtYtjNKltDQ8fyTIOrcmabp0R0DvYCn9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zoZjdsQM5EUxTwQICO2RzIRGKB0KqFp/hjtyUcXhKA0=;
 b=IEOMBAE2JZqn1cNREAhPY0wLwe15jsP0B+K5vwKtPL1MtyNS0A0G2orxXcXDzqlUfhEatvFvgfUwT0yGJPiCtpP0e+3TUtLO+sTGCcTEs4Pt8KyLTHoJsh8AJmVBq1AurIAy5LPk8sk30gt91FmCFhjewn7fq+PP7Ho2VVbeSr78KQfNqczo+lDME38wQrsQT7mWwzL8TbtqDjsDhFmHewYYTdy2hwc3UTH31JuuYrcEck0GP2L5wRDb28Nkr80RraUrJyyWWKh/Fypx4CJPiSkJhxc5rArqElxM211qAdysyamYki4VEEpXcJM+hpdql4TUPeFgFBmWqzaOgZRbMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zoZjdsQM5EUxTwQICO2RzIRGKB0KqFp/hjtyUcXhKA0=;
 b=kCHicBkMi0sL7j5XD0huoSYcEq+HE0CeJT1i2e3Xl6CFzJixW+2GACKCuV60dH1jmb1Tg7Ypuey+eeHQJeE4SteUCbVtITjTS9QwARQA3rHo33p7uF5g6MtPUxCOw/YwpD6gPGK8HiV0p08hGmfLr8gTLfH41CrvANHJFK1BU8Oa2T8LAamAWIl22uoXJ+JIT0lGUqsT3ANKaxHRlrIoV6pXrOncaErwDSoPWoWwwXkmpDBiZhwlBSfUvEDxXTFS1ye5i0jtSM9GlRC1ODklYPGQN+FXgPenfTeB5sNI+Tn7aUPN5TrD8PcqE9IQzgZVoH4nu4g1KRsdwO4p425IpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25; Mon, 14 Mar
 2022 21:36:56 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 21:36:56 +0000
Date:   Mon, 14 Mar 2022 18:36:55 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and
 the KVM type
Message-ID: <20220314213655.GH11336@nvidia.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314194451.58266-15-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:208:329::11) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c33b55f9-9a30-4926-c6ee-08da0602c35e
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB5805A2AAF5246DA8E9DA8166C20F9@PH7PR12MB5805.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/O93nSJSHOY41LsTLVwz5jKhnzI5XfzwvO+lkcgibsiBt+cqR4U0rBG1yk42nSPqq5lnoxK5YVr6Lh964h2Yero+BYizBa1Rc+d+B7vdqpq9GJgSU0DgWakWrU4JE3JNAMQLUKOnizf3OM6hQM6+gqUDESPtXfrLPJ42rbvGRvFAftIIZ6pK3Z7Okfap152/2L/9Sp/0lj2lRcp9r63pJnwrRX3AY3IUbUhh8pyPJyIDZTiCh6ReBgKEbg8Sc3FnqXKWsLM+JaNB2pkMgi0hcbrIQvipo96/nCh0YZnMJONbAknaCG9NeGATffHY8zm1qp4abjk4KJZcytpLLSwSRPhQDW0eeO+80TJZYzdasHxE5UoQbidVMASGoyr1Jp5GHNBYBswLK8xlbOd4F1yL91TX5XHiJ5Q/YYefvTq79Pe2rOWTr1z9kGK+a5ksj+3BbgtUJLlykdPNFE7Vl9+QVvfec558CWrlAqJKklAfCGGPXaBinGtruamWVKlbfI4ga9FseRRhxTg/L1ykCL2abNot2+WH1Io0UXMbIXPk9SHIFRmmlOy8OULK4cH1ReTrxMUBT6SSwDkUp0dsu4uy/gx13RPOv9hRht+ZyMISYRGzB+WRgM8u/xlQN9nHW+zlCz9FdcqEkFkZrKyZ0iwrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(33656002)(6506007)(86362001)(6486002)(6512007)(66476007)(66556008)(66946007)(4326008)(8676002)(316002)(36756003)(4744005)(38100700002)(7416002)(6916009)(2906002)(5660300002)(508600001)(26005)(2616005)(1076003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9LAWV3LDIOSoEzp3obm4XfZyrhwwu8hsLAh/F6QRC2UZZ+7wyd3AFWDxxTBI?=
 =?us-ascii?Q?0oF8O3FYNSEgbRjZdlKfD986HoOBQNKVE5ZS6atQT/wvztqtv17TWAxwkDvp?=
 =?us-ascii?Q?FyZGjb0sznO2fzK2HYJWQS1gJMHRuGCL62c0o9HBRt31dTcdaLU3S+DSBMT8?=
 =?us-ascii?Q?Ud8fxLQCLIAjplxDrslbmgchvS8OOZrYTZNJWUGdabIHWbxN3JjJifwaA/Yx?=
 =?us-ascii?Q?GuAJiy/SYxaIdhVeihhsTBlGoo/vb/fhABFRWneYti5QPyfvRd01ZAab2wOs?=
 =?us-ascii?Q?mE5e58JCFhMmw1iJYUgPqJjcqhEZ1A/m7Y/xTxY+l0oxCtbtdS4I/11LVOUc?=
 =?us-ascii?Q?L8oigVmqMjPkJg1n7vpH5RxS+7Tx55xtBF1jdIF0tlwhAtCvFozBP42s8ImJ?=
 =?us-ascii?Q?S4rT18umQ5YRsRGojR+f6rwRf+xeBDohlUi4BYC2LmgLaBhy3KgEs6A6Lr9U?=
 =?us-ascii?Q?ccUvyUsTQ9mj9OXOhp9cAR2rC3MPhhD4FQVRxotlK1kj7+alV8zzdvvYV4yJ?=
 =?us-ascii?Q?LKHwBUh1LO8MsC7jGZyv7F4+/pemTih8QH6uQnWPSqqN6o+kdcL4k+3lPFTr?=
 =?us-ascii?Q?PYV14AEFGvxcYeSNotIbZ5M3CInHNW8mPNv8b2QKeNK+YmzW7dlqzvsY0zbn?=
 =?us-ascii?Q?5C19DZhqAhLjfHVFGGG9TTWv66AwPiBySlrhidEpHb3gj4nB0ZCtkO79uBZG?=
 =?us-ascii?Q?25HOD+M82PFeyxyay3zXT+M4NOuLB3a0duFSBOESifje2dV3tvW0X9ZkmwRL?=
 =?us-ascii?Q?nl80UmmrbsxeZOyDKFRATW/TbeeFrlNiU2X6JwF8jW6Pu4Y+os0JwYUFW/Yd?=
 =?us-ascii?Q?muk4CG4w3A30DrWoYdwlWA0YPecyVL81BVZVaBFP1L+4S4Nsrz5QHdHZBA5U?=
 =?us-ascii?Q?eqLA0R4GsecCSZWqrOFSj31tUau8TmuKya93LsgwXooagZS70Mt8jX7C4brX?=
 =?us-ascii?Q?3wE4mNXa80UmhFJDkMQNFXYcZDYWI+152Ykez4NRSawPPy0WrdhpnhakXIhW?=
 =?us-ascii?Q?bt35qPW6+zeTiVLGfLeLEoL4sOnxZyf1RhaEBn4zUf2T9ImbTsu5b9Ei+lPT?=
 =?us-ascii?Q?Hpa6gWioq37fBMv4cLiaXmOrgnSqI9VU8bS3UuKWMG7jpjlVaWVlGwSMXTH0?=
 =?us-ascii?Q?DaKoO2F0rHYZhrb+AYf6T2snEjPzF78M0N6jGKWiV5RTxl5vmuajClhVRe+l?=
 =?us-ascii?Q?niIPfKSEu03qu6MxKM+CcC+89Ua5YFFqgjihFP2M9jSM1jq2kBr8W3cZTYZt?=
 =?us-ascii?Q?CbSG53wGnrTdFtMvKGhCH2azJI07DztiTi8mxa008Xg+BuSVGIfOVLjwLIfL?=
 =?us-ascii?Q?ifvfAcA9R2c6DrTFMYbWiFAfX1FRtKo7EcEED97myP8mZqPdgteRVQ9CJu1w?=
 =?us-ascii?Q?LnwkC9FJ3lpBa9e9HM0q0luhrExbs7TvxVjia9/c1uzgOtzUNKr3xLHLPkOQ?=
 =?us-ascii?Q?D4PMHYKS1pbKiABj/D9W/K6oGYjS9/hu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c33b55f9-9a30-4926-c6ee-08da0602c35e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 21:36:56.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUDLicngyasqJDvTnBjUE6XqZ91FSysnA73zOMKl1mq4kdoaY2uYv0yUeoIvfiak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 03:44:33PM -0400, Matthew Rosato wrote:
> s390x will introduce an additional domain type that is used for
> managing IOMMU owned by KVM.  Define the type here and add an
> interface for allocating a specified type vs the default type.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  drivers/iommu/iommu.c |  7 +++++++
>  include/linux/iommu.h | 12 ++++++++++++
>  2 files changed, 19 insertions(+)

I think the general idea is right, but I'm not keen on this as an
interface at all.

We are trying to build in iommufd a generic interface for an IOMMU
driver to expose IOMMU-device-specific domains such as this in a
general purpose way so all the platforms can get what they need.

Jason
