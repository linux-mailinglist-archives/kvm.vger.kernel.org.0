Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D0771F42E
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 22:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjFAUsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 16:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjFAUsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 16:48:40 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D37C189
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 13:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CcUKaElSr+j0JC2VaLL5C80uBT7+XJnZmt0b9bHhT1+1NoVSUsmjAotQCiByDI509/+NUUfVfE1ZisRJVeZFsmPptzTQh9vTnZISmBugtE9rWboGkwJr6wxiQz9hTu0WazZW+La52n9oPufIOieYmfgWql33ahMl908K4ka+o7mznO/9bpStAam5Oee68J5uPlnab/7OKttmb8aV2jKnZ+wKuYxl7xaxnIRgadiNYsA6Z3ceaJRXFz+uX1hUIBW7yKdvGCF5IoUxgf4eM9UHnxZZsgP/KXDxjcdEzkEmdc5ritfrsR0TjCz727J8VtXIOL/4XkHYx4NkQP0YLdeFKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7FnTqIaC5rPEtGlMnvlVMxUwuEJV5I3AnwxBEaturc=;
 b=UPGPdU/J7CRMWs/8orFHXqIMpiPGMAqZ1oVHFQ2t2qcZkfk7EwfoJctHoMlGYX7Nc/R4g/PZfJ63Is0rSTX02LrDzqZhsVKUP06FCvDCs7ourX/X3nhruf+Bzstmhz1D+wxRgPDELW9/CBe2te7zo6cJvGVM+KICT7WAakzjCzOfqD1nJRjyRHfwqnQaoplWXyNZCvX7es5xkbzsYN5Ez6YB8wmQG3FhCtBxKu3BGS5oYeji0PAFG08FZvqqtbK7SU+zAYIX4b19FSAxNK5QFFm4hXQ65QSjyQRgTwGQdAlexhK6uCcTQov9I0+0Tvvjy4Ev/AHBKbAvaOG7Q1HeVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7FnTqIaC5rPEtGlMnvlVMxUwuEJV5I3AnwxBEaturc=;
 b=ot5V9Bb0y2yFXAVj2YI7D2Z7hDrH/u1s5sdP7kA2Gc6jH3A3OTQwbNZtw+z0oJKdlLwe9MUVFBXxPLb00ejlu7rbOJ3eXIgPWwjnofqxReDlojE62fVp+uoY3SU9ZP6slDuGGq2kpF8bD9ltq0wdsHrSin5D/WEEaCLI0E9/H1n6ELNZDZ5yvV6YfTLwIi1tYsJLiacUvr6mTz2m1as5F+p0a1v6Fktcc7k3Ri4ZNI5iyK56NekEjV8vtVRuEufZ9zvDlEx+GqStJA0PWdrwpQMqXEJ+cIxnu3t3zNdNzu9AfY2mt9vs006zn7XxeSz0wjgig4dN6bMzpqYB+vyPag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5877.namprd12.prod.outlook.com (2603:10b6:510:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 1 Jun
 2023 20:48:29 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 20:48:29 +0000
Date:   Thu, 1 Jun 2023 17:48:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio: Fixup kconfig ordering for VFIO_PCI_CORE
Message-ID: <ZHkEG28EFVDKVb/Z@nvidia.com>
References: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
 <20230601144238.77c2ad29.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601144238.77c2ad29.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0151.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: ed29d077-cea7-4775-518f-08db62e18dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zuvwTySV0lzUB1VrCKVSsW46UJJ3NTKHKhhcVmc7A7k8bOcSVNmQ/CtvsdbQhdmnRttgkKFku9j9DTH3cLW+j30IWPHOokJVe3JnbsMaOAHN0YtDOy1kH/l1D0sjCLWAju23VDyHX1mdl3DccBjEL+pukprwLH/MsNLr7eL/pxN+Pt3IUSNn0cSzdkMCgtRZhkFq5r5laQpLaMrqCOT9gci0f8Jn10UcCgaU7jWDYg03f52H5apsFz9lDiRfD42pCOFTQyUKtGKyVgBPxieGsRHIBE+oKK8CcG64DTHXrKJGYYcl99MIfZN7cxHX8eESwa/p5xcUucUpTlzdVQBFxVcI1qc6BqocFz+SqjNjVzGGNGiiQE6xbSWXggkM+Wmom8tR2k6viVJZHHzgQLb+sIPlefZVUfR06hRrXJZY8Pj4fNVaSeiB56wLdG7FZmnD1YyfqfM47X+8r8XJp+ihqzaBrvtwW2Cduepd7dL6RPp9H93+Hsj+EdB54/EIxBK4DZtDrHVXWtMznvSySPoJNrd6vWftjYqKaD01c4ReulJrTZbKSiR6JRLbJXBkNvWR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(36756003)(54906003)(86362001)(66476007)(66946007)(66556008)(316002)(478600001)(6916009)(4326008)(8936002)(6486002)(5660300002)(41300700001)(26005)(8676002)(38100700002)(186003)(107886003)(6512007)(6506007)(83380400001)(2616005)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mn3gxzd0AsM9uutMWhEB+ZufYcRvdOWugLscPV36fc+saippWg8fwRl+K7NZ?=
 =?us-ascii?Q?ZoD54vcTWoPydyG9a3c6pyjsqZsZp7wUikugGZz0YE1JHGLEQcOzjADOZvDZ?=
 =?us-ascii?Q?ab4JjPrxg9WYTYqI1J9MX1RtQ+hS4Vrqbw+kreLiTxXWfcMWcf21eCdai//b?=
 =?us-ascii?Q?NJns1bAzdE0TW7mkoaouBjp3/D/Se07GivGWWOdEFkZgJTZkv5hLWdeVbYNd?=
 =?us-ascii?Q?HHFs/k1yv9M7Y1Ln71pK9k+bWassT4eB1KfL1GIWhMTa3NXOgdCQFccvC0f/?=
 =?us-ascii?Q?T76Dd6I4eSg7NpGzGR9E4JINhp7a541S7qWNSrUe8SFXPAafAgHuR64Ekadc?=
 =?us-ascii?Q?dGsfVSURkDRgJszKshrCOjn+MgFU4P+ltYWrsrsg/ag74oTkPpM1ywMkvKzX?=
 =?us-ascii?Q?px0kdiWh+h9MeT1ISZUmJh+CkezKLUCI9b0Ml7LrUASI2kYAdRS+/jqnsoNh?=
 =?us-ascii?Q?r0r10CDSmzqTKx1YV452PU3d4Ze/jFJvY486Qa7A/AoexmzZQiRjEBA0x1a3?=
 =?us-ascii?Q?YWGqq/9APvQEeOfWGJHFjQE4DgKZqqEuzva8G1WFVQWyyrh7xhD25ApDU3Ni?=
 =?us-ascii?Q?mPF87nvNQ4qB17tebiYukZQjN8N+Jp84PzWRdqcJZ7AMzkUR6f6h5FldSinM?=
 =?us-ascii?Q?HSUeZYjLGcwzoOm7w+TTtYBi0j0LEbiETpYcc+m7VbuR99B33QLiQmiNHr9h?=
 =?us-ascii?Q?6cwjKg63ScJoOg3FlIl0FpGc+B+ajKyznwBVmACqFf5IolAV4GREuKh0gEp4?=
 =?us-ascii?Q?8c12Wm/vq68eiN54hbnmwvKoPmC82B6hHdxkHLsW9QAec/+L2OkuRmCMP0o0?=
 =?us-ascii?Q?75MLrO33yALAgPMRW943rPKdS0oOVXgameQmIlyIMMrM6MQ3y1JnF4/eQ42S?=
 =?us-ascii?Q?8NUg99Fd/a/f1yZgZlv6cS/68e5LFhFvhOvrAbpaKV0q56HtHhmw4UoySEj9?=
 =?us-ascii?Q?Ox54KupvueEU7j9hOQJ1yFpkYbv6kjMZ67DMm+uccl60VVybeWmEPt9Ksg2q?=
 =?us-ascii?Q?yw/2QUmWBnkrNsalsHrJuveOgyPYdxAdLufOSl8ToVXDF6D0Sq/QjVsw5pz1?=
 =?us-ascii?Q?2ZMCQXaSsXdw7FW8ZmeoDOdcWR4Jam1r5XzvRnoK0zIY3LgLl5jJa3Y81rvZ?=
 =?us-ascii?Q?RQOYVCwSCHRnTXbaRRGCmRwFwDh61GBBhL6Xh8q1snTRHA44fzJrV0ZYmfOa?=
 =?us-ascii?Q?WoHnzEJ0O4aNgfZ71+KjnexRGAe7CyvZDNPtZls7B9Jn/+PqBzl0DN+8tp1/?=
 =?us-ascii?Q?tHP+MAa/1gFGqZYj+B5Y4/ZUO1MnIQb1LfQ0IYoiWfO9ZCGNTs6PQFQyErMV?=
 =?us-ascii?Q?spLqFIyiEQ7yJPwVPxGWy+thdo4vHdCba5GYH681iCcqDQM53kpNYY8js/H8?=
 =?us-ascii?Q?/hDLfdIcxPopOFPp1Djcd3tf0VqD4VD6Id/taUnb+kImLSYNUhkd+QIxr7ld?=
 =?us-ascii?Q?NQ/er4qhhO8wKq2f7ZFguR3VjJXvHJm+JMxz4tFGNmngeRsOymzJPUkgL+e3?=
 =?us-ascii?Q?AHULah9GcsjHRYLu1KzRJK/cZLq6puQ+XKupjPBrPQrrwDRlf14iFlJSkmj6?=
 =?us-ascii?Q?LHgHKlgEiXCsjtjkCCpRNRTW/bLC3JiWeNtqHJFw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed29d077-cea7-4775-518f-08db62e18dda
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 20:48:29.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfKG9Orgp927saTNl7GQO/oUySv6i3v7pNthgtnmRIE+QgJ7/HMJ4wVrdaG91PSu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5877
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 02:42:38PM -0600, Alex Williamson wrote:
> On Mon, 29 May 2023 14:47:59 -0300
> > +config VFIO_PCI_CORE
> > +	tristate "VFIO support for PCI devices"
> > +	select VFIO_VIRQFD
> > +	select IRQ_BYPASS_MANAGER
> > +	help
> > +	  Base support for VFIO drivers that support PCI devices. At least one
> > +	  of the implementation drivers must be selected.
> 
> As enforced by what?

Doesn't need to be enforced. Probably should have said "should"

> This is just adding one more layer of dependencies in order to select
> the actual endpoint driver that is actually what anyone cares about.

This is making the kconfig more logical and the menu structure better
organized. We eliminate the need for the drivers to set special
depends because the if covers them all.

> I don't see why we wouldn't just make each of the variant drivers
> select VFIO_PCI_CORE.  Thanks,

It can be done, but it seems more fragile.

Jason
