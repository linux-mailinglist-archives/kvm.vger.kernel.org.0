Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC29399186
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 19:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhFBRXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 13:23:52 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:23931
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231515AbhFBRXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 13:23:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Voyae/w4hfdRUtXu5cHLpGk6BsbTGScJAdVnujgqRjrrrQbhbIM4SxhAKcsdrWytzrGbEQeTCO0Fub0NBY0tioFaLnkmv3ZbXWvmrBPAQfYgEh6lBgRMTE1QUf987fGRfMEklglIDte3HOGG5IbGZY1Ix+h03O56LURhUNVBFCttUMlfJvPL9Pghwz2H+X/R8ZU+rLuDA5MQ5SyhHoVfUzweTRmT//ukEhw1XBoOJQFtmTktTA6m0xtU8fXZ+pXgSCEaQ09QCc5fhO25rA+VvP8s23uaQLBVxXxwcIDISn5QtD6wZlFIHLOkgN8JhpzYhb4G6NEBsTvzDsfTrm4koQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAFOBvu/BHMIz42D60r0XvW0IDdMrJjol+tMYgaINCA=;
 b=HeQDQ20LMF4ZJyQi7TrgLDhHAovjlHA+l0GNmxgHo2OWEhNDnk5CMR8chPlAnFhZHSi5UPRCQbN4ABxjcRXynpIIJzHwzBFio1yDIKd6e7Ehyp5HwkyxFfMyMRZt6bAuARPrrDGqySHBk5X7cZwB6u8F4xi5setQx3qVC5Zq90JlWQMiUfITIg0q2FFtguruCuI3SRZG579c0pUnEjbQMxtwSMF+8OCqQJVewPEnLPi4S16juhGqWc5cYKZyIOJ+t5LIZN/WAQtFI99xLEmrvN4Y9JwR1wio2PTDNVbfabbjiyU38u7VbbkyyP/SaYmetuH35v+217IqPVWYyZJGbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EAFOBvu/BHMIz42D60r0XvW0IDdMrJjol+tMYgaINCA=;
 b=M/hYcWdHlsYpf1wNESp5i1CfCoBVKba7MWtZpou57qqWq2ESLBs239r7bVDv8hQ2kZZF50eXTvP1Am9mIA5wF1hF1KpANpdl3UBx1qjbfV1GA1JJ0o1Z3Yr7qzEVZ+EvV6fUCrzfPCXAhtwt5591wvdqlb/Sp6O1sFRIJ97pdN0vAYOkKQW3JZxNmXWr5b2N2WidNB/U3169TvjZcZi6bsPf07e3goztcooFqqki8PAfTp4dMLazWPsaKUsSrNRpBDqwlvxoRoplPHZWYmDLqunBBnQueba6WbEhRmLurWNOKPTAaJzLJFp7mC81X4sY6/aSyQxiHiUAqsC1f1X1WQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 17:21:56 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 17:21:55 +0000
Date:   Wed, 2 Jun 2021 14:21:54 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Liu Yi L <yi.l.liu@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)\"\"" 
        <alex.williamson@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210602172154.GC1002214@nvidia.com>
References: <20210601113152.6d09e47b@yiliu-dev>
 <164ee532-17b0-e180-81d3-12d49b82ac9f@redhat.com>
 <64898584-a482-e6ac-fd71-23549368c508@linux.intel.com>
 <429d9c2f-3597-eb29-7764-fad3ec9a934f@redhat.com>
 <MWHPR11MB1886FC7A46837588254794048C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <05d7f790-870d-5551-1ced-86926a0aa1a6@redhat.com>
 <MWHPR11MB1886269E2B3DE471F1A9A7618C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <42a71462-1abc-0404-156c-60a7ee1ad333@redhat.com>
 <20210601173138.GM1002214@nvidia.com>
 <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f69137e3-0f60-4f73-a0ff-8e57c79675d5@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0210.namprd13.prod.outlook.com
 (2603:10b6:208:2be::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0210.namprd13.prod.outlook.com (2603:10b6:208:2be::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.12 via Frontend Transport; Wed, 2 Jun 2021 17:21:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loUZ0-000IRj-OY; Wed, 02 Jun 2021 14:21:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77dad0c1-b9c7-46dd-b9ca-08d925eaeb9b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5144:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5144040F20A049DFB80B9F32C23D9@BL1PR12MB5144.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KrjKq+sKueuQNPTHuS8C7Cub7yla+fleEvyVGbv5v+ifSnIFsRW/lwqUgdwktPk87nxdcJW6nYVwhPzGPaDDSMdkhGhcqkSF55I1IA0TbLEpPxcq3AqVSBJBf7p0YGjvTpxU3bV7B/nR2WKF0Js673BiF7ecI6Ioh5I5vahb4LsstG23Cwc8xiK2UwVWWhDak6QHvqklPgzbQWlD1gd4lSHJ05qXbxFJ9++gVRqHvQDjljq2Z0Wb7g/cpm5diLisNkXGfp0hInDFjuRYXqsk7UshgxRlmfxz5EKNYt6t2LhjuNXQzyjY+SkkWLk2+hNJfY5qcOp3z8dCDHMUxkoTxmKXb6KNwHyuYFh34vDHqL04kQl7WB5/YBCJkkO+jpdGICTuIhCSb9jvjswR/MRxitKsJ6YgD/SXcqm5mN7CklvQbwgYyZbZO+NyO+X1SI5/PHfJhF71oQs5hkhY+qfgfxla+5FVT4ZtdppOC+eyZXKXxxBuRQGDdzbUPRvs0FhaUTDGIy/67/XGlEQqanhDsYYE3DwHkpJsGyQj+AEnshOO6ignArA3ldIOQHhPgMNsKC4MujokGcrLQwyXvK1aqIPKegjQuBG7RwEAJIzd8co=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(36756003)(478600001)(2906002)(4326008)(7416002)(5660300002)(8936002)(9746002)(66476007)(66946007)(38100700002)(26005)(8676002)(2616005)(9786002)(426003)(66556008)(316002)(186003)(54906003)(1076003)(33656002)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGk2d2ZQVTZnS0oyeXhuMmR4b2NBUEdyd3o4SjkrZ0d3cThtdXNKWXRrc0FF?=
 =?utf-8?B?cFRlcGpPbDlrdmZ2RCtZcnkvV3c2MmNJYVUrdHRXMkREclB2R3BZSngva3Zp?=
 =?utf-8?B?RGpsQmtXZElpMGJEMVZxVnowNnlCZUtOWEJFOWo4ZytpaUhadk1RdnVGU1RY?=
 =?utf-8?B?VS96OVFCalVzY2pBaTNLWHlCclJtdnpIblN2cHU3T29yM0dHZG9QOW9nMDZx?=
 =?utf-8?B?c2Rkd1luV3VMWCszWkRrYld0eVpzM0kwMGoreDJrekhobFVnSHZIRFd3ajc5?=
 =?utf-8?B?TitBcHBVSmpNalVSOFlMcUdvaHZ1K3dYQWwxYTZ0dWszQnRQMXFjM0ZWUFZi?=
 =?utf-8?B?ZFZrYmQ4MzBmcjgrSGtSYjkwQVdPVEkwbU5TeisxVlBJQzZHeU13dGF3blc4?=
 =?utf-8?B?bHRhT01rdTZjWmZ1VE4wUjh6VTI5L2VQUzREUnZDS0ZkazJ1TjJhQ0hmWXdy?=
 =?utf-8?B?Q0pCVWhGMmpFUEVLcE9kRXFyb1hSRDd3VEdOL0RLSTF4ODMvOWRrMVM4cE9p?=
 =?utf-8?B?eUtzWXo3K0FXWXU2dmQza0hpSUpod1J2K1hEN2o4Z3piTVJNdnIybnQrWlV2?=
 =?utf-8?B?Y2F1b1hidXN4bHJHVEtUU2tKUjhiRkUxSlFyVnl4ck84YjRJaWJ4T2Y0WCtJ?=
 =?utf-8?B?d3VERmNhYmp6YzFWVW80RmRLVE9hSURqMmpMYml6MmdjRWxBN1pmMVhuSTFh?=
 =?utf-8?B?QnAyZkFFdTJod0UrMWJQTCsvNHlMVjd1Qi92dFU1RXlHcDg3M2U4N3FjdFBD?=
 =?utf-8?B?T1NDYjdIZWVMREpZZ2FVSkhkRGtSSUhEdFF1d1BSbEpZWE96Nk8wVkR3QmRa?=
 =?utf-8?B?L2NLNytFOU91N0U2NG9WV1cwVFlHVTUrRTFRakV3STR3dHVjRENEbGdMQkl6?=
 =?utf-8?B?VzRUZElOU0g2NGlYbXN0NVBQM1lLYlovMnZ1VWRNRTdZQXdZd1JlTUxjNDdJ?=
 =?utf-8?B?clBlbENsRFViS3dmQVNGQ1hXUWdsMGFhaS9KZStmcjdWaXVTNENFRUVQM2lP?=
 =?utf-8?B?aXpzcjVwRXV5Tm1xSndGTjVRcVJHcmZyajNzR1lwQnROZEYva2lYSDA5a2N0?=
 =?utf-8?B?MXZ5eXBLL2IxRUIyckhzY0xiT0s0MVpQamJ6c2JkQUZFYW1zM0ZjbkNkdU1p?=
 =?utf-8?B?NForYlVhZDY0NG4wM2grSitGRlhENE91VS9tWHBSWTRCR0pES1lueGxydWZo?=
 =?utf-8?B?MXVVQ2ptdkowQ1AyWUl2RGd3NG1TMHE0N1NWVkZ0akNIb1lxMExZZG1FalJN?=
 =?utf-8?B?N24vRFJtVXpyd2RkcVZMRzZNTEVhbnhKY0xCTVNXclc0N2hKMWxBdW1SRjFF?=
 =?utf-8?B?ckd3UzlzMG9obk1Fckt1UXV2TTA5dXA0aTRFdmhaeG1RQmpBWWRwb2FCMHFl?=
 =?utf-8?B?TXYxUXNwWmZ1S2JITFRMd09IazQrYWRTenVSSnFSRmtnc243SzBlMUdvdlI1?=
 =?utf-8?B?TlVPS3Ira0Q3TVZ0N0pBaDR5T0x0bUhjSk1oY1B1czM4VFV5c1BjUEdObjAz?=
 =?utf-8?B?R0RIaEhHc3g1aGVLTisrWVJMWC9SNlZmc1prejhLMnJwNmdJM1YySWdSdm5C?=
 =?utf-8?B?clZWU1JUVHZRQjNlSmdCeWoyeHRPTzFVc2ZvcFRyKzF4UzNRZXNVbmdtNStU?=
 =?utf-8?B?YlZkc2hYckVUOFAwNjBRSHhoYmU0NXpvcHozdVlOK0ZwRGxIMVd5WVluQjNP?=
 =?utf-8?B?YU54ektHeDZLdTNDNE9WdjlTakR3bkRLdHhHaWxBK0lkakR2M3dtM2tUWHIx?=
 =?utf-8?Q?SbQhp+x3Pgjq2P3gMi3fGmbJqvjIdR3VWp7UmQt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77dad0c1-b9c7-46dd-b9ca-08d925eaeb9b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 17:21:55.6067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zp5LsK5rD8jI9zrYrH/zKc4lYzm5pDr/sNq3I3WAGJmQxnpoNDhCNFfKQjClrfjF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 04:54:26PM +0800, Jason Wang wrote:
> 
> 在 2021/6/2 上午1:31, Jason Gunthorpe 写道:
> > On Tue, Jun 01, 2021 at 04:47:15PM +0800, Jason Wang wrote:
> > > We can open up to ~0U file descriptors, I don't see why we need to restrict
> > > it in uAPI.
> > There are significant problems with such large file descriptor
> > tables. High FD numbers man things like select don't work at all
> > anymore and IIRC there are more complications.
> 
> 
> I don't see how much difference for IOASID and other type of fds. People can
> choose to use poll or epoll.

Not really, once one thing in an applicate uses a large number FDs the
entire application is effected. If any open() can return 'very big
number' then nothing in the process is allowed to ever use select.

It is not a trivial thing to ask for

> And with the current proposal, (assuming there's a N:1 ioasid to ioasid). I
> wonder how select can work for the specific ioasid.

pagefault events are one thing that comes to mind. Bundling them all
together into a single ring buffer is going to be necessary. Multifds
just complicate this too

Jason
