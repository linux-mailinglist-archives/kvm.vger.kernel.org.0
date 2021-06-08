Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCAA3A0746
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 00:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhFHWrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 18:47:15 -0400
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:3744
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231186AbhFHWrO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 18:47:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgyqjCvdWcaFtqs1EIZg0ALgHVdvVzfZ2dDRlqGTBtyZSkrtzFq5fgdw1HYWsSaSJ2J81XIoVRDVXztWKhEDIBcDwPr6Y9lhYbSz4skI2hy2yorABv5AZsPCdQXdX8FN45nasvcpgYGNbOBovDRKZ0wvNVs613YMHXHjOU43fF+3gIHdpy1CTdNVFlZ5QKII34khkKMVRdaHRgEfJ+aSrTPXL7ozjQBifAmysJ442jEgp7PvPlyocpsc9nN6PT6dOpV0de2Ta0baRG1h5SDOG1OxU35q8SdHvcaBPjoZpM/Upov+Z3NkXxKw2c6xVxm7UXmNUEmFgecXQZklc+m75g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9+yvx5gC5n0yJdscWmk7LSzDcN44i9S38l3c5jEWKs=;
 b=HJ0xsmg+jM5bdXw9pdW2OU16JUMB8T01fWG6WMHd08h1aQqF03MyqG064X/Cb1cL3BPpmZMBjEp5jYYr40pPmgujJQKa28lUWkazVO3+/Q9TL67IW6bjlm6Wlw+4BEPW12pH4xHYLljlOiPr1/XlZoafj0j9+qCIatzhnJmWoCRWLutEmY4sXah1XQbpTBriXeN6cdXERH+O/j7oqLezDZrPLbKFCjri+aotUh3bqNULEYwQjfPV66uTLQ+vKRlB88r581sbiXtwCAzGfVwrgAiTneRznh/iPxux+lCKQ0qEOqLmACxD4D9oXh8bFgUUXUcDdLJMNOqwhwcjhWDnQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9+yvx5gC5n0yJdscWmk7LSzDcN44i9S38l3c5jEWKs=;
 b=btvbjMlDN2B6t0E22C3pQzAsKNvq+o3Koq/KF/Cxj4GV0SzUaty8+CqDI985+5/SxFIt2zK8YOEK8kCXJ77damu4EiQlD3Vyxuc2eI9t4DAbyPB+3oyAQ4dCSBxHXbgE9IkyQ/vCgs3lzvK/8IrY7seYedrVjRU8ayQQAr8egClUkWS5rLL3B04Urk1djqwW6EpZhps51gcwSVTtiWlLALMvi+yb0u8T/XKySco8exb6ajSE7pF4Pz/tkwRs//JMU+cgGnJHRBtiT+zYC8WZX7deiddwTDEmv2wkGhQqmqmHV0TTbDHBj1NATdyDhKoFMYPn1L/iF5OsiKTe0qRgVg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20; Tue, 8 Jun
 2021 22:45:19 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 22:45:19 +0000
Date:   Tue, 8 Jun 2021 19:45:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aviadye@nvidia.com, oren@nvidia.com, shahafs@nvidia.com,
        parav@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        kevin.tian@intel.com, hch@infradead.org, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210608224517.GQ1002214@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608152643.2d3400c1.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:208:23c::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR18CA0027.namprd18.prod.outlook.com (2603:10b6:208:23c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 8 Jun 2021 22:45:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqkTF-004Cv7-Pk; Tue, 08 Jun 2021 19:45:17 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 012e4452-a0dd-4f4c-797f-08d92acf179a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336C6F99348D38CABCF9D38C2379@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vnhadgW3Z65wDOXxZZu/WYSYJl8Vyh0gcRsCw6yuqW3YOPklNqtGiFjES1Clgvp1AVdrFrJgutyAiX+IxOhDhQ58VLonRUlB52dK7TpeD3HKfdDXPeszwZ4k774mmc+uxvua+Hqw4Paob15LPa0pmdHFyGWRvkBBfnNESODi//ueL/lmcYt3WwJMM7yz2D+32QCZMsPF+kUTXSvMsEXBDxYmBDnxkiuAC8rYFcl9ZvhMVS8eB7CQrnLcLiN9bYfPBwhen8+yMKs6vgBPCrT/YbAqeEzFO1iLLvTtWadnOpo5vF5AelbOB9TeIia8CzhutoXF7fhOmWADuTeqxFVd8nZlCr+z+2SevrR21++S/s9Gxy7fj7+RW/MiifOJ1aY2gk/sgErtGjoLBcPH3xHAeEceGiq2hYCTPq5xbcD6CbiFt5Li/AGLA0oD++dqJssdrA8BamM64bl1QGo0l1VJGLhsDbwA3qgIIwU4zQaO+rMKXvyQnTmf+7IQONn5DhIwwX9rSKSE4d3HSB8mvTg8zWfeBGVJEPZS8Of+DILdrQJMKWOUBniph3le5rSShK4fYcZYOhUDH6vwEkMywGMoCnPm6ajva6hbx9hVzk2yaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(1076003)(426003)(8936002)(36756003)(33656002)(5660300002)(9746002)(9786002)(2616005)(316002)(6916009)(2906002)(478600001)(26005)(66556008)(186003)(38100700002)(83380400001)(4326008)(66476007)(86362001)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d+JwpeLBIaDfcvquyO+N5s9CP7HhQ+DZtsEghjecl3dM95CI55fk7pNvA7k2?=
 =?us-ascii?Q?j3ZkclziCpUA4NjpANyucY5VNjO2n/PcEPq4q0mhPPYeO6moJmau0hC6MtSx?=
 =?us-ascii?Q?KiLv86f1PNhrg5bpBzWjoweGAq7X3v941smpn5XiWMsw5i3mWQH8kOC5Yyrs?=
 =?us-ascii?Q?p4h51jMH2Q2JPSZ7LX0ufgt7IuQNeKfTad6S29smeRrC5t6Dwx2RbJAVElh4?=
 =?us-ascii?Q?V/1rurGevVLv6QnwmJ7ToXN35+ve6+2STQO8BlawHjBnf2UuEulCXg8IBy3b?=
 =?us-ascii?Q?QoRwmxi4+sG2dRTYqu6t0+bb5DnvYLRgdVkK3Ftmm9b3gLDZHl/TzBBUjvoV?=
 =?us-ascii?Q?S857mjBLEnTFws9w4CNZqZkO0czkcSA3toa2WhjlBvqwjGlve7t79I7n43mQ?=
 =?us-ascii?Q?vyMCovM4fFNJcf4VFqrFssaO0xtayPLGmevCZmkkg+19j87TU8Uh79L4I+8g?=
 =?us-ascii?Q?OTOzkFcs2t2pjqhQtbjIMwts6v2uZE6wUJRGEO2IyC5yeyAQHc26cyVfOppQ?=
 =?us-ascii?Q?6KqP5Zj2ONDc876XqCl3E/i0bQ2uXfrU/ZjDvp44uptoTkBA/842AEDdXTrl?=
 =?us-ascii?Q?985aBMegdexe39FcV/KYqMBKb8ZNG/HALisIghAD2kZHU84zl7Urg1ROld/9?=
 =?us-ascii?Q?5Y1uomEu7+gqFf8ARKhnkl/GDaho84Tq3CT3BSznHSireh7qc4EJg2zx9L12?=
 =?us-ascii?Q?5jzf2KRviFZ0+G96P/nKuSAKgL9AGuUY2yneEpva2i/V/6pBuYZa179I7Yrw?=
 =?us-ascii?Q?7xMhdL1EXKgB5M2H1/ROvESzOigJwSm+zWuuIhUwXi4ypzNAWW5spstEGUcw?=
 =?us-ascii?Q?KqL6MNbH7vzyoscw4l1rHy4mHPp1gMn7UUxNy+YgzBUQMveGtNyTpLhRe9S6?=
 =?us-ascii?Q?A9q5AZLE0PzGiP2AxyXMD0ozQmSUKN9MkbDDfpMvsyhTyMu2e0MBxn+JyJQ9?=
 =?us-ascii?Q?w6x4oIoaTWI7GGDc+37vdPPVqDTi5EjpsTeCuxC0fI2xv5CzX++/PyCfG074?=
 =?us-ascii?Q?IVnkP+k7ZGObf/W7nQUPgws6+ceYXbde2E7SyvQSBHSjRmjXHRxpehRSM/bU?=
 =?us-ascii?Q?B+KvgjuLet2FU1iIFUBIN9oONZuzgoY956LFPiz+mTPecZN8pyX4TvlrzYNb?=
 =?us-ascii?Q?nNN9nTPkC4U0K2RsD8hn53RJEdTawoWcMYCxWQRiuIdjz8jRo+4wVsebRupt?=
 =?us-ascii?Q?iP6Ubm3aJG/Ld0FKllNsG+lh7yomCJcDVFHokaAYjIZy9oUwsjZxPmFpzapW?=
 =?us-ascii?Q?uw2k1TKZpYAOaHosYNc9rutoPYh6PoDX6gyT0GY2OJ2S0ZgYJXvaHZP4WTpm?=
 =?us-ascii?Q?VpQc3ShOmQHfbv/pTg2TMcFq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012e4452-a0dd-4f4c-797f-08d92acf179a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 22:45:19.4333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9evslFtOHmyHvsTIFzlqjpRGkQcgytPE/5Z6JN7ZNirpks/fmhqYskgtlRA2XR+p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021 at 03:26:43PM -0600, Alex Williamson wrote:
> > drivers that specifically opt into this feature and the driver now has
> > the opportunity to provide a proper match table that indicates what HW
> > it can properly support. vfio-pci continues to support everything.
> 
> In doing so, this also breaks the new_id method for vfio-pci.  

Does it? How? The driver_override flag is per match entry not for the
entire device so new_id added things will work the same as before as
their new match entry's flags will be zero.

> Sorry, with so many userspace regressions, crippling the
> driver_override interface with an assumption of such a narrow focus,
> creating a vfio specific match flag, I don't see where this can go.
> Thanks,

On the other hand it overcomes all the objections from the last go
round: how userspace figures out which driver to use with
driver_override and integrating the universal driver into the scheme.

pci_stub could be delt with by marking it for driver_override like
vfio_pci.

But driverctl as a general tool working with any module is not really
addressable.

Is the only issue the blocking of the arbitary binding? That is not a
critical peice of this, IIRC

Jason
