Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C9A39BCFD
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 18:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhFDQXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 12:23:53 -0400
Received: from mail-mw2nam12on2066.outbound.protection.outlook.com ([40.107.244.66]:14560
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231435AbhFDQXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 12:23:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OM87wg96pX3HYhy79916tX6U3Va//ndbTlhFxyVQEGNtpH7HeeHJCrENC+TNPLelsHI7tZyjsiF9iuSxOFv2YAbH/0eaR4W+WzvNNXk0YSClwgBxxmQNaW2iwTJ61esxZCftxHLG6yKQEBQ0ytPKtbXjmJcwqxIe3jasVPoj7mPA1Gw6cki/y0XaBkhRlF8KqspWL5zlGynFYNfwt/RJQOyaCNr0jMMa8AY+a9LVBf/EzsIReI4YA4PmSugzgdLcaZw42ntTaMiyri7Lby/10tpEtkza7B1E4Z2Hiyd5skzhjfJnKGMvIVXuvlOiPTlIvwLQQqMKOx45RDb5RLT24Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXvrsT7NEXTPaNfq1NhAo2T1ImtgwQLu5twOJd6mOkI=;
 b=bmovn+0vICGxrA8/CQ1CVRbuO+0LrsfeuQQ3R7jC/wF9RXbOM0b1xsH20c5boWL3QyDDfE8AjcnWD/ln73k92UmpiXs9nMVDcoYO5rSrhCpQho2tJ21YDymeRnJo4dRnVrJpEeW+62stRxGEjmS1aOmj2Guys4wZ6/NWLuxJ9skQWnTvUlJHY2ReLgaV2zmNfKVkVYi7bVOAb9+FKavwpEpZXmzx2I/fHc+Ozinys4wIUFc97Q9OBA/aVv8vti3CvRE9HPZnF8qX7pqKiAuczUhcEIs/8sKPf9XMJpKn+AHysgFxbrsf3Mz1BrhmeT1wOSMrwuR5hmL/LSSoUVZtDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXvrsT7NEXTPaNfq1NhAo2T1ImtgwQLu5twOJd6mOkI=;
 b=hUZGOjrW+4KELOQHIkQS8mILN4fy+PudKuyHNNmX0RTqCPBgsGn1K8/HD39ILnT3tl/G67/ZowdgZZSaH+HvEb83PJMvdyYwchq2cFfPmZ2v6s75mIo2b0VEYG7bqUXc+qY1OxSLkSDIjiMxRFtVvuJFLJNZp6sIYI9ArUM+7gdRUIuKNdofPRZ4C/ZVVc0pSWoug6qhum7NkwyH+jmfL9VGyvhqvl2dWj+qy4VFFu67aO44GPUfuk5GuIpKwikMrKveE+4xUZRwpK7Qu92jc9s48AzN6waKl9nfai+1Xg2pgc5agCNJfCbx9WBr30SJogZWy63eZO32PnBfmuHrgA==
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 16:22:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 16:22:01 +0000
Date:   Fri, 4 Jun 2021 13:22:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210604162200.GA415775@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <c9c066ae-2a25-0799-51a7-0ca47fff41a1@huawei.com>
 <aa1624bf-e472-2b66-1d20-54ca23c19fd2@linux.intel.com>
 <ed4f6e57-4847-3ed2-75de-cea80b2fbdb8@huawei.com>
 <01fe5034-42c8-6923-32f1-e287cc36bccc@linux.intel.com>
 <20210601173323.GN1002214@nvidia.com>
 <23a482f9-b88a-da98-3800-f3fd9ea85fbd@huawei.com>
 <20210603111914.653c4f61@jacob-builder>
 <1175ebd5-9d8e-2000-6d05-baa93e960915@redhat.com>
 <20210604092243.245bd0f4@jacob-builder>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210604092243.245bd0f4@jacob-builder>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR0102CA0003.prod.exchangelabs.com
 (2603:10b6:207:18::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR0102CA0003.prod.exchangelabs.com (2603:10b6:207:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Fri, 4 Jun 2021 16:22:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lpCa8-001kBE-0O; Fri, 04 Jun 2021 13:22:00 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04a94f8b-7e5b-4d88-8e4d-08d92774e1c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5111733A352B90D66A1A4376C23B9@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVC6tp3/pGH63a5kLumwVUp+GJqVWirS+ecTG934AIxsJkir3ZBtbyrhdecjEz+zzt6mMhgxgkXwO9kqTIMNEAg3tob7H22rByhFWhohlcsdP2GrKiZHjJvuFVa2JoqfYhzg37t9buDy1FYSsmDEvskVRJY3ulv1BMrtBF8eUf4bbuSWI4aC1LLSkCWt417Gxg9zjY8Ovhg1rrdmu5V4Fu1vhWSsR8MVOj52ss8wdT/U3f4YSqc4wskTMBxHRD2xo/mPbhlhsiHtPTgwEiGGuRzXrdrvIy5dDUZ/M68+QcvJWrjU1qURFhdg0o6+PhHkzMAXwnHkSMep6Yq4JOVadyq1lUsoFt2O4uo0uS7lOl57DG8InUFra89v0NqnDynLYl7Ok9UrphuisXUEF3BkYPBDSsdq8wUID+lwz3LQp5u8wLP/9LU/9fKqPG0LsS3kR1qjc4hJ0cOke+NNtTUVGZursO6k9vNXBgAxgA4WZkVk5ubXAQtM1gz3W9yK+o6qD62HVB+8xOcRpvmMTtCaHGh1vOpTu52O0a/t1i5N6wgD3VoamFxtF6XH7hneC8WpSTtgILaKiWJAU+zdRNTRGrjosUte8TFuM2L8G+aa9u9ZPAGV1LXQjeNmTRjeX/BSU0QerMwm1ZDsaEih1VemWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39850400004)(366004)(136003)(36756003)(316002)(83380400001)(9746002)(6916009)(5660300002)(1076003)(2906002)(33656002)(7416002)(9786002)(8936002)(478600001)(53546011)(54906003)(66556008)(66476007)(2616005)(38100700002)(66946007)(86362001)(8676002)(426003)(4326008)(26005)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UVVsaGZPQXVYdzRsOWFjWVBodEZyRE4zQ0hFcjlKWFRvTHVqakljdW1xTkdR?=
 =?utf-8?B?bkZxZ1crc1EzWDZFYjR3aURaRHpuaDlRbE9adTR3NkZYNXdabk5HWGRjUnUz?=
 =?utf-8?B?N0VyNUdzU2ZaWENYb0JJN3RpMmU3eWxCYThOR0JObjM0Rm92NStpd1dJSi9W?=
 =?utf-8?B?R01lUGRYTGFJcHp3TER6Qm9ybCs2eHRRRDBFTC9FZ2ZFWFRjOWlKWlFQR3Iw?=
 =?utf-8?B?Um5kcURHQnpxOEFGOUVQWVhkRDJlbDFHNzdpL29acVd3UUxZb3laQWx5RXVr?=
 =?utf-8?B?VUVTS01BdnFDRDIxUTduR2puTytTSEdvb1ZXL1Exay9rV3VzVjdJWHRLV1No?=
 =?utf-8?B?Sk8wOGg4dk9OMlJkVjlmcG1wU0xqcVpEMStJc0o3djJmeGJ6YWNVait5RDc2?=
 =?utf-8?B?WnZJUGgreHUvTE03MjJCR1BaTUVFeEtxSitTVk93Mm5vQWpzY1A1YjZ6a0h0?=
 =?utf-8?B?RmNmSVVnODlrWUZxcHJSc2tGdkZyNDVSdHlkb1B5ZStxVlBObUtmbnl4UW1J?=
 =?utf-8?B?cFRHR2E4a0liaFgxNlNqYzM2UllkWXNuK09TK0xMY0pRa0tqYnV1Y1F6WjZI?=
 =?utf-8?B?bTd2K1ovVDhPOTgvNFczV0dqVFF0VzFmRGttTlBDcDVrMGpibTVESXVlbTcx?=
 =?utf-8?B?aUFxdWVxYzN5R2MyeFkvR0hHWWJZZ2FSb3lDUExMQTZrK2FmWThJNW9adkpB?=
 =?utf-8?B?UnNxckxDVDNXY2xFSDB0K1BvSDF4MUloWU5zYXdpSVowT1RsQS9jTlRSMlFN?=
 =?utf-8?B?Z1NhaUY2emlVNjcveE9ERHFQa1lIdnNydkR0NnFsdXRXd2ROOEpHMW92Mnk4?=
 =?utf-8?B?bGZkUlRWdWZUNklNM3JqUWV4NGlzM2xWcXNxcng2K0F6NlBqMGJDV2hsZEk1?=
 =?utf-8?B?YjJOMHIwVnJuVkZMMDhJUHFDUmpSdXN4cm1PY3BKUmZLdktISTRjUmdxcEF0?=
 =?utf-8?B?WXhjOWxCTWU4NzVhaVR6TmNJaTVtREFMZWNyR3NvcE5wZEVEQnZkZDJrdTJT?=
 =?utf-8?B?ajV2ZEpFazRwVzZJaGtnU0hiR1JjSERSUkNrYXVXZmFoZVptSkJnSXIyWWY3?=
 =?utf-8?B?TWtJQ1FQaEVnMWM3MEtwOWlOemF0bjA3MTY3YlpsSFo2Wmg2WnhjZVBXRjVB?=
 =?utf-8?B?UTVqYUZiUVdaTzNIUHBScUdLQVFJcFVvTzVFMUs0aDBKSUp2b1kva21LYzh6?=
 =?utf-8?B?OWxvQmFVTnZpaDRkRW1VTjVJYUxid2swM3BTM3pyeld1cTFFZ2h3OGt1VFVE?=
 =?utf-8?B?aDQrWnNhU211dGowRkZ0citFMG9hSHo4U254ZDVIL1JhbnNvaUtZUHl0czFQ?=
 =?utf-8?B?Y0VvTXh4N0VVZFc3anUrYW4zZjA4VGhUQ09rTmRlS1NUeVlmODhmU2dHNUpj?=
 =?utf-8?B?REczUGdOUTBwdFlKSzVYL2FIQUg5dXRRa3REdldtMElUQnNpeUpNYlhxVFdD?=
 =?utf-8?B?MXBueXZCQjZCd0dINDRlVHJBb2cwR1F5NHZGbXQ4WHBCM0hIK0d3RkQxQ2x1?=
 =?utf-8?B?YzFUQmhUbTV0bHd3dGlBNTlSS3JGbmF1d0RLZDh1cXNlbEZneUZGR01oQy9m?=
 =?utf-8?B?SFkvU05qeVQ1bTNCakluakZCaXQ1NkpSdTczLzF5WkxVSWRzeUtqZnFxV2cr?=
 =?utf-8?B?QnpyRW9TZVpIa1VSRDdHbEJKdW1qRnFlV3BUeW81Q215emM4VVZ5NjkwUzdv?=
 =?utf-8?B?bnkzRlVKZ0oweTB5bFY0cXlXVmJuOG1yUTdvL2FTVmUwUjRmMEZ3SUlRRmFa?=
 =?utf-8?Q?wXHz/O0wGQjhhJDwcCY9QTomcLzEo+ofkaUVv3Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a94f8b-7e5b-4d88-8e4d-08d92774e1c3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 16:22:00.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVbx8KP1EhEEIQy8/xjptmY5qrilNjEv4rzjt8eLLY1H4cZuLYCRFui+vhM8K1pq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 09:22:43AM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Fri, 4 Jun 2021 09:30:37 +0800, Jason Wang <jasowang@redhat.com> wrote:
> 
> > 在 2021/6/4 上午2:19, Jacob Pan 写道:
> > > Hi Shenming,
> > >
> > > On Wed, 2 Jun 2021 12:50:26 +0800, Shenming Lu <lushenming@huawei.com>
> > > wrote:
> > >  
> > >> On 2021/6/2 1:33, Jason Gunthorpe wrote:  
> > >>> On Tue, Jun 01, 2021 at 08:30:35PM +0800, Lu Baolu wrote:
> > >>>      
> > >>>> The drivers register per page table fault handlers to /dev/ioasid
> > >>>> which will then register itself to iommu core to listen and route
> > >>>> the per- device I/O page faults.  
> > >>> I'm still confused why drivers need fault handlers at all?  
> > >> Essentially it is the userspace that needs the fault handlers,
> > >> one case is to deliver the faults to the vIOMMU, and another
> > >> case is to enable IOPF on the GPA address space for on-demand
> > >> paging, it seems that both could be specified in/through the
> > >> IOASID_ALLOC ioctl?
> > >>  
> > > I would think IOASID_BIND_PGTABLE is where fault handler should be
> > > registered. There wouldn't be any IO page fault without the binding
> > > anyway.
> > >
> > > I also don't understand why device drivers should register the fault
> > > handler, the fault is detected by the pIOMMU and injected to the
> > > vIOMMU. So I think it should be the IOASID itself register the handler.
> > >  
> > 
> > 
> > As discussed in another thread.
> > 
> > I think the reason is that ATS doesn't forbid the #PF to be reported via 
> > a device specific way.
> 
> Yes, in that case we should support both. Give the device driver a chance
> to handle the IOPF if it can.

Huh?

The device driver does not "handle the IOPF" the device driver might
inject the IOPF.

Jason
