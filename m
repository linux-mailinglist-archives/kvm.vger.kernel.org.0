Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0754833E1DC
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCPXFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 19:05:10 -0400
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:18656
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229494AbhCPXEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 19:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgkB6V2unSgm3xgJLEohiHO7BqNm6zZ2Amw3XQQ6+pWORKRm5sPGDIoDmkXbGkyyjQUGXPF/nVfRkJC5Ec8ktC6AFH4LUYfl/DGZmordheKHBJRD35E5uSnj71ekPmhFpdjuxVitFRY216+xhJIsECAL4+ZZWXduHRHoBeXVur7FTSuHhgpqToEvrUkZbcDwSB18mPNtTUBcWs8rfWz7w2ODsadi9NaadyVKgDOuNakTK41ScQ4nNk8bs4AH026QX2eyUu0Y22itnHCdmYFCAUBYHgcmAhN+nYAMoxO6Iv9avN+eoCtfsjJwtiPUW2ZUfHBVhqKNvpFWpYX9ZH3Wpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZxGOd+xkGkruworzlLcZV53Q0KE7Xs8Tg0+zNT/sDY=;
 b=XcZr2baXLc7qAL6IlNUkUn7lxQDkfF7wo2OgYbnGAabSK0kR0Dg7piSTzNz8uSK1Mo+ciI0JUOsfIczgb8ryniDA6g440ivxCwQLi4LNh7tNDIUmV4N8k/7VMlI8dUD4H0qosVUvBta3uJMPx6FLme8CtzWIQN92BW4PvbI2cohp1D3R+PYDr4HydPlsXXUIkvRzfIQNnGIs5l9fUr+pXCsLV5EXidd8ferhE0wkyBtNrWIue69Pz5GCXhkhs/fV08LORCMhgUfBo1438+WtZbXlP2Ofl1pL+wv/jRMkKacd5b2rqRHnkS43BqjS00sQqsHwrKNbCr48vBceGjcsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZxGOd+xkGkruworzlLcZV53Q0KE7Xs8Tg0+zNT/sDY=;
 b=WjM6zTf5ou8QbfgQ5dSBOxlDlV8D4DuIMcO7aEOID/EK1jPuOVSpIOgFceb2bKy7mYm0CH3OT5Vu9PjWjN/SG6pIjF3sCBcWanjK+SgW4QoqBbvUtzA72cuq/XyKPZilBz0pxgkJbAOXZUM3OWzLzHnNZJbFdyvvHmrTKtsTm12dPXtfRH5it53NA6zSHWh1rEMfJkdnYrTuPga7ybGfThFEPFCHJVuImpxlO1yhrm+f6S0KT2qij7C6GpBw8/repuI7niufJDeqXuPMcz/IVcoVPjlTA7/4DgD6ew9i0irCJ7V7QNZBXXYiLktDHSr7KimTmF8wlO5Wh1MlWUkikg==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4618.namprd12.prod.outlook.com (2603:10b6:5:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 23:04:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.033; Tue, 16 Mar 2021
 23:04:39 +0000
Date:   Tue, 16 Mar 2021 20:04:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Message-ID: <20210316230437.GA3799225@nvidia.com>
References: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <22954556-633c-004b-4512-262206c9bd3a@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22954556-633c-004b-4512-262206c9bd3a@nvidia.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:207:3c::32) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0019.namprd02.prod.outlook.com (2603:10b6:207:3c::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 23:04:39 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lMIjt-00FwWm-Mg; Tue, 16 Mar 2021 20:04:37 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5053492f-e0a3-4006-0b85-08d8e8cfe03d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4618:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB46181994587E6E9B1445ED86C26B9@DM6PR12MB4618.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aLcXbyebYKhTjc94ju5awh76HtimFnOxLFJrsrKZPu+7u76NoDr8ahUBYKvgtgrGRB5Bsy6RgG9mrX8p2Nfj48iNe8M8IeAf7rR/3klQoDTj3NQzpaigtYQSVIEfj5qDwv+YzAeW67MNiDj5dqaylITZ5Snbzdpl2zpDfz9xh7T16Pf6JRMGjbhE27n/GXxfDrvnprJfE7Gylx6DumypMIgxP1mVyRfZsnZtO3cknS8frjtpo/nLM6cO26HEzkeA2cRnVfFNYJXeHOo2AgN5uSLsLgK6glnqMKzCnNNuWPSlt8mdq9GZla26XqrHfYTDo41V8pZjdpGF1zm52qfXo/CJXucGg1TT+X3RPqUVXsTXytkuHmW6FEy1FYCMMpiwi9bIlwWAsnj/GvY4cVCPiEmz8BVkEEVs0aNKYcV8sPOsaOKNwbd0i/M0ppXZ2RRKcvsPoEul9SJ9q9GLDKenWCy+R1j8k9WeRNRgGXJ9NSbDhjGHKkP/58mAoGz/OLDN1mFN0yLM4NnKqRzjvcnWXskAumHVpFUlINkjNkn184H+iXpInpfZ7iQwPrr270F7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(33656002)(54906003)(107886003)(83380400001)(1076003)(8936002)(9786002)(316002)(2906002)(9746002)(5660300002)(36756003)(8676002)(26005)(186003)(86362001)(2616005)(6862004)(426003)(66556008)(6636002)(37006003)(66946007)(478600001)(53546011)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?H6gvSBpGp+wfEUfpE8Lklt/ZXE7vTRjU7p27K2fNh7fm5d/mNqB60XnZG8hn?=
 =?us-ascii?Q?vPCxT0OyuIVcZaLuyiMfzgXzQDnJLSUoah59tb4jKoer0FH9cI7JUI8mnO8/?=
 =?us-ascii?Q?Tkq3gHSIW3Txee37EYsk1VX65htFVW9W8YWxJYXyWNtIdX7ib8ShPAFwVmH3?=
 =?us-ascii?Q?vbdTshrUhb57iRnOzly18lHawC0IDkDUjnQ5aHZoF16ow4bT6p3/EJE+Mxho?=
 =?us-ascii?Q?RkqlL1QeCvMFcoMa7TMChwTjgjWrMGI11gn9iKhixOmAOBCvOpXwu1XA0Zmq?=
 =?us-ascii?Q?FIhPI/JpoEELO3/4cpUTQLeTPLZrZNYlsXrAC+pmtIMZ2QuVE7IxSr/O4KLJ?=
 =?us-ascii?Q?2RcFU9NL9Hm1V5eMnJ8fcjLP6LlKpAOumbTG9oXiAjeUeKozorFMR9jC+HC9?=
 =?us-ascii?Q?ZxCm9RYdDtNcnKlpbYwwlFg8fAA50bpmpgnidtQC2+KHFIPf3sW4C6F/pFbQ?=
 =?us-ascii?Q?1rzKlbFF7C86lwVDkRfTxyZs0hpMJgWtRAShRUEdRcajbHRsjNIZltU8kBCq?=
 =?us-ascii?Q?XUefyQ3v1ZnKS8vZjqGGb9yXoIMx9KNYI3KslXLFXJYTC4Gpyyp/c2Fdv/bK?=
 =?us-ascii?Q?MLSCoFvnaRPzaQruLQZLWUQUMxhWn7HIaI6imU/EH3hO41sQo6e64M5d16wY?=
 =?us-ascii?Q?j6sM8/2+9vOHOwZ+aHHDQDbJVhHlxKFGog/MFCt9vbHhTnQ+Yd1QX02wTBbK?=
 =?us-ascii?Q?v54z3PRTqX//M0PJFYeIsLNvgfD9n5iDD59hy6ftGx4KBzgaoi8bbrMHXzed?=
 =?us-ascii?Q?O+ttLxKXuaYhgr6oRrKRu1WX1JhSFB+GXPILKGfCF61raaaILwVplpX+WuuI?=
 =?us-ascii?Q?2gycd4mYLfSuxTWSuiHWKVVrmJvgK3Fa/j1OVTE/sC/QZEHEKjrZTXzvgIG4?=
 =?us-ascii?Q?IhKs5cnxMCKx7haiFfTf3ZztYm7SuGhahom3VOA3EAxW0CvuZqLOk0zkEBMz?=
 =?us-ascii?Q?zV1dN4hrkdrnYNyu5/RzroSToRuKAMkwBxrdIJ+7cbESFuzGMFFEF1hFKpEh?=
 =?us-ascii?Q?vGFJCcfwRjxFuObbLiykUpskgGEZC9UV/90oh58N1fY6r/RlEv3hezyMB9Q4?=
 =?us-ascii?Q?5sbR1uiVrNRsK4GLVQ1Ip4l1mpRxmgx5qeYrxvvexZAGgFuVKUbBOVpvqDs2?=
 =?us-ascii?Q?UtAWvAoWLqPmOCMyWsAdBcw6OMD2dOyZ3JdCEtgS62r7QBUjCDR0b0p9/zg8?=
 =?us-ascii?Q?ybe0n18DXxLjEwNVqeZeWhdgaa9ArlcLBjgWpvjYHKpyDDMZKBA3Um1fUpUE?=
 =?us-ascii?Q?U+JqYYOAzm0g3i4fMZdIzWx3Z6ef5DFCopKwJn4tuzr2/88Q9RZ5cU39+t2K?=
 =?us-ascii?Q?57+MoUq+iQX65o3akOYyvciC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5053492f-e0a3-4006-0b85-08d8e8cfe03d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 23:04:39.4734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1U33vIIy+q+G4/OlZuXeqkx0k8kCqon4cYJEbCaCIWdRHVyrvSNMaguGH1AIvfSQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4618
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 03:02:40PM +0200, Max Gurtovoy wrote:
> 
> On 3/13/2021 2:55 AM, Jason Gunthorpe wrote:
> > vfio_pci_probe() is quite complicated, with optional VF and VGA sub
> > components. Move these into clear init/uninit functions and have a linear
> > flow in probe/remove.
> > 
> > This fixes a few little buglets:
> >   - vfio_pci_remove() is in the wrong order, vga_client_register() removes
> >     a notifier and is after kfree(vdev), but the notifier refers to vdev,
> >     so it can use after free in a race.
> >   - vga_client_register() can fail but was ignored
> > 
> > Organize things so destruction order is the reverse of creation order.
> > 
> > Fixes: ecaa1f6a0154 ("vfio-pci: Add VGA arbiter client")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >   drivers/vfio/pci/vfio_pci.c | 116 +++++++++++++++++++++++-------------
> >   1 file changed, 74 insertions(+), 42 deletions(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 65e7e6b44578c2..f95b58376156a0 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1922,6 +1922,68 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
> >   	return 0;
> >   }
> > +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> > +{
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	int ret;
> > +
> > +	if (!pdev->is_physfn)
> > +		return 0;
> > +
> > +	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> > +	if (!vdev->vf_token)
> > +		return -ENOMEM;
> > +
> > +	mutex_init(&vdev->vf_token->lock);
> > +	uuid_gen(&vdev->vf_token->uuid);
> > +
> > +	vdev->nb.notifier_call = vfio_pci_bus_notifier;
> > +	ret = bus_register_notifier(&pci_bus_type, &vdev->nb);
> > +	if (ret) {
> > +		kfree(vdev->vf_token);
> 
> you can consider "mutex_destroy(&vdev->vf_token->lock);" like you use in the
> uninit function.

The value in doing mutex_destroy is that it triggers a useful
debugging check that the mutex is not locked while being destructed.

In this case it is impossible for the mutex to be locked because the
pointer hasn't left the local stack

Thanks,
Jason
