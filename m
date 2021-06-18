Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254103AC00E
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 02:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhFRAWJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 20:22:09 -0400
Received: from mail-bn1nam07on2047.outbound.protection.outlook.com ([40.107.212.47]:44935
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231431AbhFRAWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 20:22:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8bbjNL8racN5KM1snBy0E2GznUZboK93igH6vYbA/Ke1n1FDjPwP8huGqV4PcjikMbv63Ta/7Ks1a0SAz1HFtWVEMzY2Qc+TzqObTrbIQzVTg8lQrHuTEB5PnJHXAHUBSCw1GKnn12bAp+B4z/ewTp/G/mLfUdvi0YrGqET42lOV3jStVxzZ/OcXadF2Rk5I+JjaRLSEsiratZEz6j95jn9e8874BxbMsoHGqzSPmCj/zLIUpIx7qwmaByFvAZd565YGrtLBTLV2m7OoRKUmAu7GcRbrPVsjwshCrwJJU3BESKHdbzB7RukbxKU07RHtI4fjamEBRlqROsILNYzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dFrqORrN86ibA9ejUmCAge6/5QVSNH8eRVkmO3sGvA=;
 b=ntKNWmjeAIhPOycDRnsfewbqVgjugDAU7nFpMeWomTybR62eY+oYgtmSq32g4RI154owo4tg6OFrb28RoWjjJpu0WA+8gIoflbQZfLmfEi32sW5mfrl/Yu1Kygo7rmnzZL9Q0y8qWjWQjYC0jJd5RCZOjV8y6Vfmx8z6dwWu4Mf433C9C5mGyDeENJ6aOqKR0vIWBs7/+uoBLQXBX56r2bIhVw6Infchyvn3lWYNkQzYgC6aO86PsSczsqXBKTJUMd4k/ZW2iVaD2DFc2emX0rZhXV8fyfqeouum4sSah/B3YHvMw63FnZRzVib8KM9PRudSAiHqeQ9jpgUzURZnRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dFrqORrN86ibA9ejUmCAge6/5QVSNH8eRVkmO3sGvA=;
 b=FzEdI3I/5OPrrSMsyN5vL+YYj17kxhud4NlqxMyLuL2TAllU+lNmyBYExVcGx/X8IIn+nD4DozrjgW9Wl6Z8Iu/P3aYmKkvNNDc3t6wL4GxVafXXqbLqBBxddGgfSWUIJO9hqcnZ0i7EyFm1byQiN75dGMjQ3TbCvnszradfPtdDla0Mm45k0Cr8PBqq/LLT9FnifzK8UbXttjOpXqjQ/HlakRGBSZVVpCkaUqe3Pra6dnDkEIV6OCU4ySE3Cu8/6me38ZGZfU6z5jjgssfV9G+3yZD/qHhlxpR8on95uAOeEmwoeb2KmTZkmaxS6SACreIHXG0vIjKSuMS4aBwxKQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5285.namprd12.prod.outlook.com (2603:10b6:208:31f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Fri, 18 Jun
 2021 00:19:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 00:19:58 +0000
Date:   Thu, 17 Jun 2021 21:19:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210618001956.GA1987166@nvidia.com>
References: <20210612012846.GC1002214@nvidia.com>
 <20210612105711.7ac68c83.alex.williamson@redhat.com>
 <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617151452.08beadae.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:208:257::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0033.namprd13.prod.outlook.com (2603:10b6:208:257::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend Transport; Fri, 18 Jun 2021 00:19:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lu2Em-008L97-QN; Thu, 17 Jun 2021 21:19:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f527789a-4e10-4eeb-8dfa-08d931eece34
X-MS-TrafficTypeDiagnostic: BL1PR12MB5285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5285299784C39EF7164574DFC20D9@BL1PR12MB5285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fNuvUNMLRR2O8aak1Q5Y3XZBYLFw65vdjTXc69WKGwY5Taft/vMuf9SlExeouHJp6aKqDM8KQ8ZZBX/O3SwMHueEAwAmQ1ezZTDZzIqyZn3sGV/7NMJfaoleEDszv5ZmkkE+NhBGlDjYUG6xD1bpPd4EBAht6zkf5ymHxe9eMUsSV2AmlXKxVYhzlHOzNL2qejIVHyobns0OF0nqmF2smaWQi46odeN0lDSUvuAOLk0iUH+Fikpnwjtd8kq3sMylk9dwL8CXV23t/B+uQUmmF7BJcsuDvfcAxLgmZQyv5pHsyKbdd8kJWrzDGYS5AnGTKbMdRTa8eK/MwBUkNnydJweO2pmvy3qhz0YBjJJOMEzRoTt8kc8i/5GL7EfpNGSyW4WyNfryKfXC8os2ZbfP7njgJ9XNSZ0bE70EpHYjZoygZ0Pct+05tb3tKaKPfICPfa65mYGUmIisZwWxKIAKjJ7YKPE0H39CgUGhyvIxI5oMbNGKl3GbZwc4ECxWQ78GeHpyqL54eS0WxUMM3uxj5rXNPVnsDFz99c9k3DW+nFYoQ3BG5Kiv5Kui3Cho2ZAiAwdW3tWYTJva6Z26RaTrqSpuoPjoRviogs0hbzSeDZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(36756003)(9786002)(8676002)(26005)(478600001)(86362001)(8936002)(1076003)(6916009)(426003)(38100700002)(5660300002)(7416002)(2616005)(66476007)(4326008)(83380400001)(2906002)(186003)(316002)(66946007)(9746002)(66556008)(54906003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9e9Ed6EhYQg01SovOahgG3fBaWlpzTO5NguwEefVtaQTOvoeI2ySdWC36eR3?=
 =?us-ascii?Q?FJdaF8bVCcid/PiT9sE5I7bMiz32JFJop08EwTxL08GLT+zF0bWsgtZg59Nl?=
 =?us-ascii?Q?8FyM+LCpWjPoNgBYICjMOGaojkWY3Rp1L8h3YFWRUmMkuinhIXvDzr295Oif?=
 =?us-ascii?Q?A0xkUzyjgrEjZLfC92Olz+3OVyU9EO3vdqMFK1Tl+hYDIQT0BOf9mRNxAijs?=
 =?us-ascii?Q?lqt3gpfVoJUlkxf+/upngs08N0pNJNLoigYYq5JUTKbKnNoLj1+6nJlKsy/5?=
 =?us-ascii?Q?YHAlFN3+/aCfE7n8NrjQ12niiRLTIAIDduUc/YTs8+2+BX2qe44VIpeGLoHm?=
 =?us-ascii?Q?ZSjR6Msey+JqHWbn3gq5oMF2yNG+pdYBxWZxvSueXIhcH0ubmxfS7Bogqlbj?=
 =?us-ascii?Q?en+fSTNtxOiYsw5PDG1zmLd84xe8Dy47YphVWCwqYUs3YqnT9OM/zVRGNlUn?=
 =?us-ascii?Q?YOpQG9S/oleDUiI7ne0dbSIjUXkok5sQp8+TUlg6TVFV3pOHyspbEpHIWu2t?=
 =?us-ascii?Q?bUYK3edxfjhIsTZed2jK8dSONY5bA/Bmhsb2Tv5w/4swVWhhb1aINSGvo06W?=
 =?us-ascii?Q?Gs+4Yz/Lqvr8iVgOEYyioza2sn7UtoWB+WmHKz6rZe+HXdbt/Qm/bvwUFWnS?=
 =?us-ascii?Q?NbsV8IOJUlLamxP98AAeTXH8xtiQL/7q3teoASuoqhv2PL/9RrPEZtmjb+eH?=
 =?us-ascii?Q?GQTPdBsK4isVQRIxO9pUA8RXgoIoyrLL3xgRdYMrJYMOsUXOhgs7QIOjdHN0?=
 =?us-ascii?Q?UwDqe6xfr+qCN036S5mtO8CRwgzJvMO2VGDHYXE4PQwUsKQCuNbQi9yVTK2o?=
 =?us-ascii?Q?yEVC+ZamGUkCwji80H7SeOX/gZtuwHqjbD84tzA+D4Y26/dxMjq0/Chho3K2?=
 =?us-ascii?Q?X5wduz3UeVvsW6LDxIu+U4+1PAkv+/ooJp6R9e1C8JQlmC56Y7F2EK0CE9x+?=
 =?us-ascii?Q?sF43F9CdF9MlDRxLD5sEJrPVlI0cXoWArFLfJHz7PECCDhXmZxw8JGcwhOT8?=
 =?us-ascii?Q?ZdlBQ0O6qCgRoaVSdxIJeYW4HPZsNsrSmXU4+f2aKLG3+tPsrvZ2dp2glcJN?=
 =?us-ascii?Q?3suF2pvd9yM2eUBLAON66s8zJ1pi9UjYc93X8Ar+nGQIqKH7KoNcvb7kKRwT?=
 =?us-ascii?Q?8odmqihlPpxRZWniJWC3WS3sXfehCMz/Og9ZkpP5mf/psfQlnLvIpzYDKw59?=
 =?us-ascii?Q?C1CW6//jEyT/lkxTQ38ekxnWa5/nWbYudDmAcB1HNaAmAnwv64yvjTAO/jmC?=
 =?us-ascii?Q?B3VHD66JnlNGCvZebHkyC9FIFcOBOjN0ZGPqSKxZI6Gm61/gU1PYHkzeuTM2?=
 =?us-ascii?Q?5/ydGjftvlwbajafUigzi10k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f527789a-4e10-4eeb-8dfa-08d931eece34
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 00:19:58.3792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FizKbP80GQDRvp+uGV2Q2HdRuc/aoGUOf4WhUOrhcNTuDGCEqZyQPmyozOAsXH/6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5285
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:

> I've referred to this as a limitation of type1, that we can't put
> devices within the same group into different address spaces, such as
> behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
> As isolation support improves we see fewer multi-device groups, this
> scenario becomes the exception.  Buy better hardware to use the devices
> independently.

This is basically my thinking too, but my conclusion is that we should
not continue to make groups central to the API.

As I've explained to David this is actually causing functional
problems and mess - and I don't see a clean way to keep groups central
but still have the device in control of what is happening. We need
this device <-> iommu connection to be direct to robustly model all
the things that are in the RFC.

To keep groups central someone needs to sketch out how to solve
today's mdev SW page table and mdev PASID issues in a clean
way. Device centric is my suggestion on how to make it clean, but I
haven't heard an alternative??

So, I view the purpose of this discussion to scope out what a
device-centric world looks like and then if we can securely fit in the
legacy non-isolated world on top of that clean future oriented
API. Then decide if it is work worth doing or not.

To my mind it looks like it is not so bad, granted not every detail is
clear, and no code has be sketched, but I don't see a big scary
blocker emerging. An extra ioctl or two, some special logic that
activates for >1 device groups that looks a lot like VFIO's current
logic..

At some level I would be perfectly fine if we made the group FD part
of the API for >1 device groups - except that complexifies every user
space implementation to deal with that. It doesn't feel like a good
trade off.

Jason

(I've been off this week so I didn't try to read/answer absolutely
everything, just a few things - though it looks like this is settling
down into 'kevin make a specific proposal' kind of situation..)
