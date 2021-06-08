Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0C239FD83
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 19:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFHRYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 13:24:21 -0400
Received: from mail-bn7nam10on2052.outbound.protection.outlook.com ([40.107.92.52]:16704
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231493AbhFHRYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 13:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfLY7gj+73DJqExx11wTJP5HOzJlXdyB+VqG1Ut7bcurQu+D2HVUeJe20615GcN/1aE9gReYjGz0CLulnUFFG1Wx/VtUCxzP+Mo6Mj82CvFLh/uFttBXuZP5n6L8rahf4t2yIBt/sJS5h8ZDhxUPRKPaY0dZQL0mKnB9GVxFRpkbnGl4pR3EYKGnibu4ZkolBQPeFtAqWcYN5F2qpGiRJLRtH8DAs6BmBO9TQMHmIi/CyAeZueCYcd6m/WYxo6nUd4L5LTp6weT7Xds9jounsoKzXRAe3dHu6u+IegYBzMTuaS/ns5HesS10EabZ+uW43aYt92EJtr+jg/slhvU2Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVQI6VVQXYV5ICzWAMXT8DHHqoTypyFbTPHgaoHbmNU=;
 b=VXSa9uSVt2eeuid/pno1kjt2YvXHWqbyX9NAUbbuqFDk2CdPYn8PnsfZguS7uO+r2p6YyfuaGOzkOZCkOdGXJps9xegv/xdZwCHBII6+3n4S5BKY7U2uGX+KS1xnK4jPglALDgpzdfAAR8G4cMNyPh/V8sUF2q1hvcYpdbbYhnN45VVJcq/GRsRv7u/PI3m6xFLy0eXunK5giO0lBJHIR7sK+yFuolIhQRMzwruDRNykiHEJhqucHEmxX0WSUyEW7D+uRvKWzxf0Wy1XnLHteJ8ycM5NiZObOVGZs5eG8TIPOJz++RnJlXlfAtthQWuAqxEK4alJdXyin03Df85rVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVQI6VVQXYV5ICzWAMXT8DHHqoTypyFbTPHgaoHbmNU=;
 b=KJ8l6xjxegfNl4AhOkuvxrvoTuWjGlAIla+nAV7O0tVQ4kbCpDbAK2LUdQfdRLNaJMb+eDW4ezBpFcp6FEd2DvogRx21f/D8oWyKhC8buztg43gN6PiaX5DRwpTUzaNOfysxj/zRGE9rhlAXr53sMVzp5pHkWvRAePgTfFxVlukFTqzgvIseMgIU91xbZrNfk7phwoLlIW+janF+6gzimEc0CHMXRriTKN1Lun993hlnwmeXIM266KEFBZHox0XlqYdm8lPxK3PLdVS0LXe8gMPOaJ4Y7ymMJFMdmn9RIRXvzLR9KQ4XvqkCK4JubYz/oo6yG52c6XaEWZCJEZoCbg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5335.namprd12.prod.outlook.com (2603:10b6:208:317::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Tue, 8 Jun
 2021 17:22:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 17:22:20 +0000
Date:   Tue, 8 Jun 2021 14:22:18 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, alex.williamson@redhat.com,
        kwankhede@nvidia.com, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
Message-ID: <20210608172218.GK1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
 <87pmx73tfw.ffs@nanos.tec.linutronix.de>
 <febc19ac-4105-fb83-709a-5d1fa5871b7e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <febc19ac-4105-fb83-709a-5d1fa5871b7e@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR01CA0010.prod.exchangelabs.com (2603:10b6:208:10c::23)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR01CA0010.prod.exchangelabs.com (2603:10b6:208:10c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Tue, 8 Jun 2021 17:22:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqfQg-003vRb-MF; Tue, 08 Jun 2021 14:22:18 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d085ed6c-38ee-480b-7d75-08d92aa1f893
X-MS-TrafficTypeDiagnostic: BL1PR12MB5335:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5335228D9BE278CE59C9CFA5C2379@BL1PR12MB5335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rngTSAmSd5UMAEY+Hv4vcSuXMR9K4dQCG9imqe6WfxugZWMxtspGWlRiZipoZCOZQGu/7OJoR0xWTJI5/0VstN8flIBV00hxlP7eR5tLIkIYlDi23tOxbvyX/qg/P1xHYPhKcGapVcRp5bKFV7ECnigzT6dBct/1ncw64TZ84s8FTh6OkfHGph5/DSAUq91M5/HOrpwhuISzFujXf39iqHXdBaErUT3VOCoU504KGFBGkQZesf7d6I5ML3w5xDuElujfbeYSj/pY3gEX5h1rDFfMJ4tvW3hOm0j+RnTRLT7KQc9yDLWaUcS11CAk7Y3D2Q1B4r1nC7DrhHEFl8ynpV/nB1/aa5k2CxS912RS1YQYz4HvDi4D/Di4D6Yh8B+HU6guSi26sLrcJ/ug7yDfiboQ/lRpoMvSrckEVI1aZw9F2qbB7guSTF/V3HYQMd7rSOft3Y/E3S0S/+ctiaSAhWSUsPFPAqaCDZPrnoFjBca2W+dTZev+vpWYRFylch0bSO01s1MPUAAl+KaZXOcll4J22TEQYDPfUXK7KvbJOIH1ckJeh9lBIcWAWtYXwBJL8SB/pfKDqZt6RtxLMPjX7iaSug8Rf4uMGHLNgoPa77w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(33656002)(5660300002)(4326008)(66946007)(6916009)(7416002)(8676002)(2616005)(38100700002)(26005)(8936002)(9786002)(9746002)(186003)(478600001)(36756003)(316002)(83380400001)(426003)(66476007)(1076003)(66556008)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWJTUUl5S1FHNXM4d2JPelIxK3pFWXQ5alJVSzdRWHNOMms0cmk0djJUbkY2?=
 =?utf-8?B?ZVpkbk00dVQxTXpiZVN0cHhHY1dFNUxPR244ancwdE5VZmdEUzlBa3c0Zysx?=
 =?utf-8?B?M3pEZnZQazM5aWxFSHBmUnNScjB4TzlzK3dYMEtaajRKQk1aK1pRM3FHb0dH?=
 =?utf-8?B?QmZmZnFEak50RTBPWnJFem9CZXJ2RW83Z1hUZGFsTm5lRWtqMG8ramZMQnlq?=
 =?utf-8?B?VE93U3dRb25WL0luZm85dE05QjcvVnUxQlhlMjhUL0VvZUNzb20vd1I5WkEz?=
 =?utf-8?B?RWEzQTRJNU5aZTdnMWIzWDNBQ0RrcTRjWGRBcDVLY2hsSTR3VVd3R3YxY0pP?=
 =?utf-8?B?OVZJRlY3KzU1MzM4WVRDV29aWXYzczBTQXZzamFJMm5vNEtlYUlpSUdSZ3FX?=
 =?utf-8?B?UFRteXl3RkptcDhSQTlPUHZEbnFrWnozRklRTnAzY1dLY3lsNk94SitqOURZ?=
 =?utf-8?B?Zjg1TmplYTBJeXQzR1J0REwyWmZXeVZSV2FWUXJYOWNWUDhYKyt0Zm5USHNF?=
 =?utf-8?B?T1FsNjdjWk45eS9rMkJHcUpYTyszVnMxZmIvSDBjdFRxT1dDaEY4UDA0b093?=
 =?utf-8?B?dXBweVNxY1hlSXhNM1JmRW1tR2VWMTQwaUt2VTJzVVdCZ1ZhRkdib1AyRndo?=
 =?utf-8?B?NGt5eGZwaTlrQnVtRzh2L3NLbEJ3bFJlN1dHeWZMK3RiN2xGTkZwQ2tPdi9q?=
 =?utf-8?B?bkhyZlVJVFFhOC8zMUN0eUpqQ2ZBdVpkai9LQ0xBbzR1MzlleUc3OFRUSU1P?=
 =?utf-8?B?dithZUR1enNmUEUzME8zY1M4cTBFOU0vM0YxT21xUGxHZWFJY1pkOW5SdE9u?=
 =?utf-8?B?d1lUQ3d6QmJhMDI3VmlmbzhWTTd2SWdmeHFSR0FRNzMwdldqdXB3TFVNMFRB?=
 =?utf-8?B?clRPcTV1L0NMNVprbVZ1aW5TK1I3S0VCY0NpcWhzYlFWOHR4VU9RbXJSVHIr?=
 =?utf-8?B?cnV4bVpLK0phSElKOGs3aFRkanAvNjd1NkhoZDNoSjFxVEU2SXR6Um83eE9s?=
 =?utf-8?B?dmllRjVCKzAyN3VpK3FxZThmdnQ3aTRkZkNwbFQwUGEvSkpSaWMrN094YW1X?=
 =?utf-8?B?a0Zrbm0xSnc1MkhPUmJKUUxIWFZBc240R3NVendrN3A3WlhzOS9pR0ZyblhV?=
 =?utf-8?B?alhBT2FNTWpUazV1TVZQSkhKVVl0R3NtY084TVEycyt1YkVWVWJoNEdJMURh?=
 =?utf-8?B?cys1TlQ0Z1JiYndPb1MxaEUrV01xaDNpbmRENFVQbWFNS3ZQSWRNa2k1eWlv?=
 =?utf-8?B?QXpjUDZRMlZOcEtRRnZzQU9ubWV5WFZoRDJOUUUrTnQ3YktJblQ3NEVvNHF5?=
 =?utf-8?B?anNJNkM3Y1hXWXBxVGpDU2ZhemVuY0VaWkc4VjA0SHgzMG81L253Vk9rNDAr?=
 =?utf-8?B?QS80ckszbGc3eVVSMVRWdi9lMXNFLzlJcEMzY003M1EzUEJ4MlIyYTRoWXFL?=
 =?utf-8?B?RndqVytncHR4d2g5dXo2dEZodFEzNnZZaFl6RTd6WEJXaU9ZME5DVUZtQW13?=
 =?utf-8?B?cExVU1pwNGx5dVVQZTJ6Snhhb0pCSjVPUDJyMjZZbjN5RkxwWUVFRWl4dkYw?=
 =?utf-8?B?SXVRSERudUdNY1ZnTVVXcE1iNEZrQmdkd2xwL2I5UnBIcVdLUEVYZVVtc3px?=
 =?utf-8?B?K1Q5MnlSN0t2SXl1RHN2d1VDKzRmeWk4QnQzc1ZqVmdPbEQ1YjVNb1dUYXlK?=
 =?utf-8?B?RFhHcDJmN3JiT0VqYng1OW1XSkhFTzZWQWNtVHNEYmlmUU8xM05jSVEyQjBx?=
 =?utf-8?Q?rFC9KxFHhQY6VSABti8MjnkmqxY7XdYiKP+UYto?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d085ed6c-38ee-480b-7d75-08d92aa1f893
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 17:22:19.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RxEFHJ3e1wTmP2OdCgya25Zn/+MeLIXBhWSQvZZmLlJIbEZBmSxrx8xD/gwYHqOJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5335
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 08:57:35AM -0700, Dave Jiang wrote:

> In order to ensure unprivileged software doesn’t use a handle that
> doesn’t belong to it, DSA provides a facility for system software to
> associate a PASID with an interrupt handle, and DSA will ensure the
> entity submitting the work is authorized to generate interrupt via
> this interrupt handle (PASID stored in IMS array should match PASID
> in descriptor).

How does a SVA userspace allocate interrupt handles and make them
affine to the proper CPU(s)?

IIRC interrupts are quite limited per-CPU due to the x86 IDT,
generally I would expect a kernel driver to allocate at most one IRQ
per CPU.

However here you say each process using SVA needs a unique interrupt
handle with its PASID encoded in it. Since the IMS irqchip you are
using can't share IRQs between interrupt handles does this mean that
every time userspace creates a SVA it triggers consumption of an IMS
and IDT entry on some CPU? How is this secure against DOS of limited
kernel resources?

> driver does this by having the guest driver fill the virtual MSIX
> permission table (device specific), which contains a PASID entry for
> each of the MSIX vectors when SVA is turned on. The MMIO write to
> the guest vMSIXPERM table allows the host driver MMIO emulation code
> to retrieve the guest PASID and attempt to match that with the host
> PASID. That host PASID is programmed to the IMS entry that is
> backing the guest MSIX vector. This cannot be done via the common
> path and therefore requires the auxdata helper function to program
> the IMS PASID fields.

So a VM guest gets a SW emulated vMSIXPERM table along side MSI-X, but
the physical driver went down this IMS adventure?

And you had to do this because, as discussed earlier, true IMS is not
usable in the guest due to other platform problems?

Jason
