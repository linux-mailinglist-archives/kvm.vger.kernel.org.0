Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D22419E0E
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 20:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236036AbhI0SYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 14:24:06 -0400
Received: from mail-bn1nam07on2063.outbound.protection.outlook.com ([40.107.212.63]:22247
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235950AbhI0SYF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 14:24:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MaojQz/kodTcTKaErn0XmEIHCdVkxMhmdKhfDWpbbduXkyrYoUSdcDb5bZlebpsoBVKUQlVf2gTeO2yChz814kXW9V+gECU0ZTpSqrlXcuG3ClEjF0ofxPnrMskN8it046uptiDEq0EXZ+OVtZLbOv2z46RcSWbtZ9bov90GI6GcM9qkhb3uCP+eJ/6rkwrQYxH6WovG2mvBbdL3aVpE+FlfBmHjezGJlWR0Rg4VV6jE0bIsGV97rL3FijqupDOViGGKLb4Yiq/4mKxBve/gnbB3Q7DLMafC/YrKCXjgHxvx+ulwK4Lsn2VtgGpQEyD7x16rIQAg/g0E07yBWmTmvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hsLxpVSTdaFaYkAq34E2ZyJbTFSAmUvzR4Z8ie+Ewz4=;
 b=lIoUgK62pvrnWxrEMeZBbjbTmjRXo+eFCbdRudDhxMNtWgTdMHvBJhtppWwnuoUIYrY5eu3lUhGbrB9sUq48hRfsu2aEEimMlPYm0J9zy2AKHab7NtdmcL+md/LYuEP69IpZ5UOfckg3+dA8o3g+OUa3Ao/ShB7S2/DtAQaYe4gMKCaPUKW6Wk5M4tQXNmtzY7NTS6fiWEOfjnrvBM53aOo4K6K7B4qVp38yIM14sc6SUZXgfFdFHe05FrN3bWHayXMUIoqS3OBsV/pji5yFxG8FVO4S8jGZuv+XQMqdT0Y+ftHedptbvaAKpMqY77xj/pktrOvjL7v07sYuZB81Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsLxpVSTdaFaYkAq34E2ZyJbTFSAmUvzR4Z8ie+Ewz4=;
 b=lPDQjTJZDTEUmV36rusO4fG549e1zgZiRVZmy/W6u/jK2g6GFGVGiJjbNpPYnkoDJbfbN+e3Vin44EN353FgzzfRZwmlo4YJqRO8h3f72Z4Lbnd655KgE5qSZUjkbICO9kBeNobXFe0z9D4SGqOjCkS7Ge1/KswnXHiVXx3FeKKWt4mpuN+fUGTXULzx3zh1QSFIV8bc1lNV/LG1vj9X4IXlx7zqsYKnL7vREzRyGxjXqGbCqbmDGPjSKlzfsvcKmm6KmOcPAy4Al2Q5jq9CymW6x66Ydffc/OITdSYtja6LOgaUn0RJbj5oiHAUxQI9VNk0TKZpEWmKY+fKrblpTw==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5288.namprd12.prod.outlook.com (2603:10b6:208:314::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 18:22:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 18:22:26 +0000
Date:   Mon, 27 Sep 2021 15:22:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 6/6] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20210927182224.GA1575668@nvidia.com>
References: <20210915095037.1149-1-shameerali.kolothum.thodi@huawei.com>
 <20210915095037.1149-7-shameerali.kolothum.thodi@huawei.com>
 <20210915130742.GJ4065468@nvidia.com>
 <fe5d6659e28244da82b7028b403e11ae@huawei.com>
 <20210916135833.GB327412@nvidia.com>
 <a440256250c14182b9eefc77d5d399b8@huawei.com>
 <20210927150119.GB964074@nvidia.com>
 <YVHqlzyIX3099Gtz@unreal>
 <20210927160627.GC964074@nvidia.com>
 <YVIKr48e8G1wSxYX@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVIKr48e8G1wSxYX@unreal>
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0019.namprd03.prod.outlook.com (2603:10b6:208:32b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 18:22:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mUvGi-006bwc-99; Mon, 27 Sep 2021 15:22:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b44ad60-9cf9-4f85-e839-08d981e3c204
X-MS-TrafficTypeDiagnostic: BL1PR12MB5288:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5288F90AF88B90B389FE7AE3C2A79@BL1PR12MB5288.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2NKa7emTU1RqrHzCkX/JXdis6X7YwtQUWJPVEEbAsgZCSAQH4LPKRTWACakGfcZVl2hlGU4hTgbDnUuM92EeXkHJqxnH3MAZVCiOVfolk3jrOhnxVl1F0w8F6YvGmHwgVNR8KuxrtfKzjqfb1zttc/2pzOPsOhjl/aSoXV7TWbFN8AHnedvyllz7Rhwleg9kdpgPpZR5g/RmlrQiA0mJ/Z+6rQX4Qmw0xzyO+n8R5WEa1m08wEkgoR18k0oZb2dgyJ63Y/3jtcGnxg8ESMxusmquT2KZhNGzpjijkbvgk8nbz4EcwRl8BrEXGAnWUL33oDV/3mQTUmC3w1fsyMXVu5m9aqcmaCfEsyVjG1MUulkxprOQZRqjR7e+OpIXtgeOy32dXSm6h6F7dyTXo3j368XnAeeYBDQw4jPRx6KiXpewYo6QRNG+uUnLGiCbeHLgPPuST2QinfZTMmQBxi369mV0ZG9JmkT9WWQ80Alpq/pN1TQBeWm7etSrLZBZjOVWswq9nJkl3ZwXF76iithPfzIyxofpqmduDdbbyIyyf2+EJ0X6qHoEuQZY2H5e+EC5D2J9R+KMHy1xWRtMaC719uY2nq7MF3Cf2SSQz+MY/5OeT7Ip5uI+URAuwBYoJhNHJw5pIleldw+n9+Vyt/TRMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(38100700002)(66946007)(66556008)(426003)(66476007)(508600001)(2616005)(26005)(33656002)(4326008)(186003)(36756003)(83380400001)(6636002)(6862004)(86362001)(54906003)(4744005)(316002)(37006003)(9746002)(9786002)(8676002)(5660300002)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gvkt+RSR0kpchVFscfv4I1inblvDbuspfZc/t8AG+45tlbiDhA9c+bpowwqa?=
 =?us-ascii?Q?5ZT2lQfVJa7pciDY4e6m6O3ZoHXiBfyH6XhIWdXm4q+sw/4Bk1ZZnq3UQUGk?=
 =?us-ascii?Q?PFUgiz8AByK3IOxY0y92tzh9aTaJPSR5rWidPikHpQ8HULlW9eUskaaf0bf5?=
 =?us-ascii?Q?o3BVcnJNWctAD2LZqhleVb4veitv+5MlekJj+psCQak7t7ovdFgoBzU4tTmE?=
 =?us-ascii?Q?IbDcbEJRvQ0ZGyyMFk3H1ve7EJ5m4/BXowkoWo9eqND6cmFmdfbPee6CI+X5?=
 =?us-ascii?Q?GjJSMmc6kylnDtgkmbr2YxGommFtwWGNcAFISH5QAcLMzY1ql07A0y8zcNWo?=
 =?us-ascii?Q?7kEK13t4HuSGt0h+oH0RZehTgJdemQxaHYGRXv8s9jNGWMyLUCLN7lphS7qY?=
 =?us-ascii?Q?6+gBfQDXlcnaWFQrsxAHOeMB5V8zZk511zF16UppLNTivYxGo9b8LRVISFtE?=
 =?us-ascii?Q?koaeXnMm6RP3St0H4Mn938oFG4r7MhOueUElkypNLzBgObaImZzGXNfLjDZ1?=
 =?us-ascii?Q?cfnzqxQk3oEgaRorn7FFdsMDRFpOK4CfQ3VQRCvtfd5uccoercxooyLYnobd?=
 =?us-ascii?Q?UpbpLPxSeQ4osHKY/nFjJ511hne272cg0kMuOdV2kcBMT1BmEH9lnU60Ol4k?=
 =?us-ascii?Q?xQteR1OkU4/9SvryEQKE+bYQ5JpZfjLTI9xruTZtU1Ql+dWi+UPkolBAdj/K?=
 =?us-ascii?Q?ZC9rjaaV1t9fefyBSLCW3H2fRcwbNrwpz3roiuZeTR7jm8yZfzvup3d7JiOC?=
 =?us-ascii?Q?TeN7SYdvrAp6V5zipyyqvfWh60b+oCCc20x4ud0lfw6SgK3v6qp84+gZQ8HS?=
 =?us-ascii?Q?zf0BH+wSW/v87ak9MtQtGbNo+xPKgTuf5fAK6Glq1pc3970Ua8q3qm15vX35?=
 =?us-ascii?Q?rkY9j81MAlTtAwXeWn7rJ4EvTaF/ciFJ6v/vw18tQyMQIu7Rd3Eh7e2dgDPK?=
 =?us-ascii?Q?FUT/g4zBv7soplMf6/cIcRyjR9A8LEVf46m3TFjD8VrhOkEYwMNVGg+O0FJN?=
 =?us-ascii?Q?+bV2RgeTO7F3krcGCtvSFUDyKEPG8+uwUzUUFn4NYnDU2w3YnxL5ujzqg/6C?=
 =?us-ascii?Q?H/KHYp5NbMK1cAmZ4JDr5W6f1y5e8sfTPXdujodEY+ALneFNB2SZjuGEHdKo?=
 =?us-ascii?Q?ae063GQdU9iTRPO4jAdhN9po0/63sW0ptr5Mnj43EPjeLZU7eak2IKzNcm/p?=
 =?us-ascii?Q?VXUd/fraP/ZLIsws8iUWv2YE/PmUcW0zNwZiJSo9xwz4UgjPuuI0awgsEJmV?=
 =?us-ascii?Q?grctSZyGz7xyCCAYUbc7s/hZSB6dOHXe7DFBdAomFiRcpNmT+QmrUquTD2TE?=
 =?us-ascii?Q?z0gM2u96Rh5RPCXavmTWi3/H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b44ad60-9cf9-4f85-e839-08d981e3c204
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 18:22:26.3899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUgn8YUMnDagTp7JtDebh7e+Q1FxRmF0M9T/+FqdEEk6Owq7eDyUsFyHxR4+MQhK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5288
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 27, 2021 at 09:17:19PM +0300, Leon Romanovsky wrote:

> > The point is to all out a different locking regime that relies on the
> > sriov enable/disable removing the VF struct devices
> 
> You can't avoid trylock, because this pci_get_sriov_pf_devdata() will be
> called in VF where it already holds lock, so attempt to take PF lock
> will cause to deadlock.

My whole point is we cannot use the device_lock *at all* and a
pci_get_sriov_pf_devdata() would not have it.

Instead it would have some test to confirm that the 'current' struct
device is a VF of the 'target' struct device and thus the drvdata
must be valid so long as the 'current' struct device hasn't completed
remove.

It is a completely different locking scheme than device lock. It also
relies on the PF driver placing the sriov enable/disable 'locks' in
the correct place relative to their drvdata's.

Jason
