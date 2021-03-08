Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FD7331B17
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 00:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCHXoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 18:44:13 -0500
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:32908
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231890AbhCHXn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 18:43:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQk6S/g1TtAM+iYCtF3dL1nCCvoxgkcfOMC+kxdk04ldaZBAt8rzh7zF+T6UhernPZikrdaYHLQHFR8TSDVMFo1bkukfnW+r3PiixSgkqLI48lFu3xoDqL3c2Sb1ftaRwnyN9FEjOoZ1J8cn4LUeOkJbgrNjMMrHIlROiozOUqt//w7LUi2ek1ykV2kra0gq2Tuj1dbNIbN1WftPJQEt5xQQGQIQlH70X4MHCQcOJi1bvk21KOu2t1xJaj2cUUP6v7vMjz0p/78B2WmRLBptGbXJ7fGJtA2qA82MrSvN7fmHEpeTJNiJxsBY50H2hX7FzLoKG7+dcagxJJJPfbN7XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zp5mvbfcSUd3F+SmOAs+VgtjVP/yYB6dfkgipGLivkQ=;
 b=Du8INTPDh0JLhz+CbcJ9EiFXslxRBrLV4RddUr/L5GMILWAwcKmkGWUE6kVYs8I5dnUP/AKUSbKMQfWZCdYOku3GhkUQqlNGcNPm4uuOFagq9b2zRiuA4FsPxOfC/sX/mnAWbfCOCAlGYwu/0gJElUXYlXkn5vLFrTLpBko/5sTzb1rzd8LEmKw0L8ik6MBNWbyJCDvktF/7p9TNGIbKjDl8YTmU7YIFmHIKgdnfZuSvQn1sNXhxRkDLmMVOylhYJB2r2qbQBzWGhNOt74NUXO2yCCnktZiZ7yE+9yaAFPihs7wC5Yb1ybDe8JHX0z3GD4NN/kb6m7R1XK21VrtU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zp5mvbfcSUd3F+SmOAs+VgtjVP/yYB6dfkgipGLivkQ=;
 b=xIdXNew44VXQeBh2KxktXU2tfyTAP+FaVKa40Nvj2uI8k57ryYzF2uW1CbIDkkiyjAwm35bbWAR1dbVPSGX3e2kLLZlZ5QvW5ZDxI6G4qL52624BsBgaAapW5gEzscJXgciOlHZ8jq0+OXiotAp1uEXOW+OA4DJOuSWPfw5m3y0=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1340.namprd12.prod.outlook.com (2603:10b6:3:76::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 8 Mar
 2021 23:43:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Mon, 8 Mar 2021
 23:43:55 +0000
Date:   Mon, 8 Mar 2021 19:43:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Zeng Tao <prime.zeng@hisilicon.com>, linuxarm@huawei.com,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/pci: make the vfio_pci_mmap_fault reentrant
Message-ID: <20210308234353.GB4247@nvidia.com>
References: <1615201890-887-1-git-send-email-prime.zeng@hisilicon.com>
 <20210308132106.49da42e2@omen.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308132106.49da42e2@omen.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BLAPR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:208:329::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BLAPR03CA0068.namprd03.prod.outlook.com (2603:10b6:208:329::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 23:43:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJPXV-009rih-JU; Mon, 08 Mar 2021 19:43:53 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e82dd155-79fa-4d04-3e3a-08d8e28c091d
X-MS-TrafficTypeDiagnostic: DM5PR12MB1340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13404FB235682A54CA8B7C80C2939@DM5PR12MB1340.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1zqKW3T8/AkFxMG2MNyaPxQNwpUx8a9LtZuUEkKy74VyC5hqOxp4AUiLFbfc1nJP3R9XYLxqwZCFnIG3J54JmbRdenXQpXrwxl5TItbtBGMptIsGPPDgqkweuHvfZ7fshTql82X1IkBE2lgnIb7s7PwkxqcHxVxRUaTt9Au1PLo6A3ivoLURfLRwr98w+dt4BmMb56ehP0iV07hnWPdJ6pAlR7ZBHhTv7Bs4lBL2b+Gb1tbdWqiVxnderNJywr2Ia1CTHDuPiD0VTg03WZD91NCgzhe3XiFMkCf6jhnN1eMBRP/xiBUl3WPnFqD0mxMmoOfHsiCBomnciOdbC3TBzB5LMrAWfgrlpB9aNQdH4zyH0ACbB4eEaZ5ZO9Kt4ON0c9xxRCgQPoLuStGSwREWqUu8S/hx532VWRV+OGhHfVPRMfMlqnOvMdcCOl9j+LMQmc8RUiwe6Y7RGFojaLpgNsVJOLI1EapOM1g/srsg4fZbBRV8SEQKqRNFOyetC4ve/nv7yImb6b6/T7AJoc3/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(1076003)(86362001)(426003)(8936002)(2616005)(478600001)(83380400001)(8676002)(26005)(186003)(9786002)(9746002)(4326008)(6916009)(54906003)(7416002)(316002)(33656002)(2906002)(5660300002)(36756003)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4+8gqGpIw8b4H4FALzq65dhKvRv4GcHICoSctk6yBBQSZKO8VIB4EBwysUwk?=
 =?us-ascii?Q?gb+tp5PdPw+zkHKjPxczXqwlkMEDjwHt9Q5zFjFt0B+CvYGGusPvet+2XfvY?=
 =?us-ascii?Q?TkZxV1yO82sHAxPaXZWNnCqDip0zOmSymRpgigafsiXqmHAfpTtyHTi7vZ4e?=
 =?us-ascii?Q?2LLQ/+8IwNP5m0KA85W+DCLn2hZ6Cy5NrHeC03Muq8/XP6anxZiMYeH+Eye4?=
 =?us-ascii?Q?vwBkHL2xvbupPoGwCxQnhjfe+HZsywL9XHGepLYTYwOU1IzQDkptPmflHiRX?=
 =?us-ascii?Q?U6El7LRaGeM8iDVLWlJ82LL7dilIt5x98QEALdq0zUh/T3swXlrcWqbQUz3u?=
 =?us-ascii?Q?SKUwDONByWlByYp6Z563rJTTKC/13vBsrAIsn5osdLFYvX0E8lRcOglcKj4B?=
 =?us-ascii?Q?u5pVh0Scr7RSrissBNDWOfj1J1fjfLlmgfGA5Op/cibu6vFaE1eTa6X78pao?=
 =?us-ascii?Q?aW83QMrBL4WZZTxfrqgbIQrvIBRGAzs1aSQ5f3wNEIqx1YQTRQRffnrwnHNA?=
 =?us-ascii?Q?UALKjbuUju12y1TH+3rB0+OzFOif83YdgzrVi5vbosgM1UGDdACUBMICUmaG?=
 =?us-ascii?Q?wuU3VesBAwSG54MTeb/ASS53Gd5g8Y3ZY75NX+dDDQb+r2hRBqSwEs7UGE1R?=
 =?us-ascii?Q?WKNOZCYudZlrY1EtkgoE5ae7NY8yZnEyJ4wFW0f9B3fvz4yCDqXrNl1TcVNM?=
 =?us-ascii?Q?POAiUPY+PKQbYZn6o/cYwZJkvIst0fviEBu/ER8U3iezRdSa+6WzGqfEcMxd?=
 =?us-ascii?Q?Rma5BsSWJQOTjDhmEzqnesN0Pu8j7FV8G+JYvjOYk01LqYJpdPUtvROJ9aK3?=
 =?us-ascii?Q?3tSuWkoUpqvWL+mIX897gmCvZzLkvtmCD1sX2GUXSUSX7JhIcJkt4dnEdKwg?=
 =?us-ascii?Q?H86Icqss/RL9Z2YWYhUpIWISNscB+1ZJ7CE9aFkTGNG4hGRutf9QlXmKh4o0?=
 =?us-ascii?Q?2hjggpRrqdAU1Lt3LTdQUyHFU6y5Z3sLrlRfEefglGlvJWjQb0Lb9Ml73XmC?=
 =?us-ascii?Q?XP49oLB0MOqZlxaJ9rZFJgwC/DZvLdIgp6dg+mC1S26Lry+t/ul7gsAqZokw?=
 =?us-ascii?Q?04f7iJ6InIUS+CAtHU2UmRG5d5ZKj3pRfOTWlA3kBWL9i1kBKSY/VuMq0ExV?=
 =?us-ascii?Q?P6UqPap3/OyA6mZ3WeuXoa/eep01Q4c8+h+rdsK6bnd/1O26oU9RrsEj5pXY?=
 =?us-ascii?Q?qb6o/kw6vnR+Z15pbTdIEokqHiafLSmJbxoqbQLAfz+/qicGEA3ILQg0ZmOM?=
 =?us-ascii?Q?6aN6CFeILJtfSFj3JBrXUuDM3Au9choq9EngBB/yyn0JyfssubcAFY6nyF4L?=
 =?us-ascii?Q?ykCPEo1YkroAFMmxrbkUHFkvsNIAL91BhU+L+s+0JBmzTA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82dd155-79fa-4d04-3e3a-08d8e28c091d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 23:43:55.4532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRfs6C8hMj+6Z8piAJOBnWLI89MSrdpqUcLGRoF5uBdOfR8xZyaJjAhJLIl7yGgE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1340
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 01:21:06PM -0700, Alex Williamson wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 65e7e6b..6928c37 100644
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -1613,6 +1613,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  	struct vm_area_struct *vma = vmf->vma;
> >  	struct vfio_pci_device *vdev = vma->vm_private_data;
> >  	vm_fault_t ret = VM_FAULT_NOPAGE;
> > +	unsigned long pfn;
> >  
> >  	mutex_lock(&vdev->vma_lock);
> >  	down_read(&vdev->memory_lock);
> > @@ -1623,18 +1624,23 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> >  		goto up_out;
> >  	}
> >  
> > -	if (__vfio_pci_add_vma(vdev, vma)) {
> > -		ret = VM_FAULT_OOM;
> > +	if (!follow_pfn(vma, vma->vm_start, &pfn)) {
> >  		mutex_unlock(&vdev->vma_lock);
> >  		goto up_out;

Gah, no new follow_pfn users please we are trying to delete this
stuff..

I believe the right fix is to change the fault handler to use
vmf_insert_pfn_prot() which has all the right locking/etc

The 
> I'm surprised that it's left to the fault handler to provide this
> serialization, is this because we're filling the entire vma rather than
> only the faulting page?

I think it is because remap_pfn is not intended to be called from a
fault handler. The fault handler APIs seem to be named vmf_* ..

If you want to use remap API it has to be done and managed outside the
fault handler. Ie when the MMIO transitions from valid->invalid vfio-pci
wipes the address space, when it transitions from invalid->valid it
calls remap_pfn. vfio-pci provides its own locking to protect these
state transitions. fault simply always triggers sigbus

I recall we discussed this design when you made the original patches
but I don't completely recall why it ended this way, however I think
the reason might disappear after the address_space conversion in your
other series.

Jason
