Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDE238DE0F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhEWXdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:33:55 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:47010
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231989AbhEWXdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:33:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQnZJx1noGgBdb5bdzDg8laVx4zSxoyRKwc/CK6P52Z8x2RxxLEiEmfDWNjLPKGSmsgJiU0/cgQrifkJAue48nVchmdreDxxpSRSH9TmjH4Yi2gyLyhy84rXBIMZBRYAEGTWzQwokXlwW1yudlD7igeAggb+50JqMQP0ppbgGYQneUrRO46EYyKJj/UPT3uh35wnXm01sk6AMfZh3w2YM1bdG2KQHCxxsUTZDlpUrZDhDGPOxxrCeLyRwWmwAstMvBkwbieNekBqs3SmziJl9WVSrZCZz1nhcfIjzqUK8kNMPQRT40d0icCaK/vvOTKrf1BnpymvhlrNkCLmJzwY2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cpPx5S5gSqcnb3ygGSL7T4l5va2HB4ynCs/Xp1deMk=;
 b=dowosoEC/optHxrVJ0YiRz4Qmp6xAZFBKqLc60eiWKfo6AmrmEZnhjll1OMmlzH1y2OER7HBGkjn5e5y5yX3emmqmtqWssPHdXIcwAt+bGfTARNTG9NE8/MX/Qd1pc4v1cTrTmX/Fs68UW+kYYadnuJZ1Lu+T2V17qwjVGwjRNGNAg/e0sSuT5urA8XhVuAfHHroMNc1VwkE6DQiGsblSxAZj/HeOgf3n7oAq9+S7/O6O6yk3XdV5lK6DOoZeqc4uk6hA8nzaGSYPMhzWgOJi0TCmPQ8ZSOb0sBZanJ8+5X9dySlyr47DE04IL40llCed5U3FmPqOAoNQm8mha8QKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4cpPx5S5gSqcnb3ygGSL7T4l5va2HB4ynCs/Xp1deMk=;
 b=r0OEA+/qsRoGAOIFyebih/FvYzW/2oFspQfY7eU+q3gNcJTFJXAOWIWs0vCbfDBdvtLMNXT9T0/W8w3FtKcN6dt/xp+Uu60U8fe1m7aWG4/pj63+hMMNOJVewxR1ncIwtvH3FnOc5XfXQ3MHba3e2n2zf8A2U6RicdxjDgpN/XzQJOU7nRYZfueFMmcF/g+mU6TegWoXmEwdwK9d91fU3GTPhIP2GddAZy9dCr/gaR5cl0N1PkkXTjaVUjzaDJqcAp1DASvcc2SePPuFj8ktRFA9Iyw6vS0TyS9PZ/CRwnW2UYZDakQRWPxzNHzii5Oikt2UnNfZeq2o7UeF0XV//g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Sun, 23 May
 2021 23:32:25 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:32:25 +0000
Date:   Sun, 23 May 2021 20:32:23 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 13/20] vfio/mdev: idxd: add mdev driver registration
 and helper functions
Message-ID: <20210523233223.GI1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164282601.261970.10405911922092921185.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164282601.261970.10405911922092921185.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:610:4f::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR18CA0004.namprd18.prod.outlook.com (2603:10b6:610:4f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sun, 23 May 2021 23:32:24 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxa3-00DUkT-GS; Sun, 23 May 2021 20:32:23 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b4f70e8-3f38-48f2-d848-08d91e430532
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5174C3EE56E4A4ED0A623184C2279@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SIorXz94dCKDA0cNrIMFdj72FykwYcDXvN8N6dT9plG9BhbTqQj7sxaSstdYev5VeNQH8bDbqAxE1YVwMPbXhQu8mp+5EfFepH539dwzfN6H42qez09v3LQ5gumw9rvkc/gthD2B6ZHmIz95HCa3RzVrCI7pqRLwghkqCM5p7HxrB2jY0ipUsMSkl+dGiIZq8sAgdRXkVOGs66sDHZsPXh1E/7R8jKkiY5G8Axc3uO1W+msxrD3+bq45evUjNFc4Z9bMG8s6w6sS6yNtFOMAE7rA8y2GG1TFcfVuzsSenP4m21ByH8INmiJhotLcQ8NoCvVSzE/UW4lPgF7ewkw+KuZv0ITH6UFxmAP32f0TsxQ0edrtfb/DeS3doCFkV/kUC+jeACCvO5yIg+MzF2p6ZPIiNrXUaz7ktEfbOjCCVZbyaquRWdJE9zlhQ4lKOdiTfgHTYLVnlvC3pMuB++cra18Cvc1cBiY9awPB2MoCnUTDkXl75apIZ6WclRq9ciVyDcWgew4EpbuyPe3cdMuValiLUJKPxYTvXhJPImu0Vwb/DhPaLR+YIwqDAdHKTxx0d73OMQNczVQkblJXlK8WXQS1xn1rwjN/YiIg5tTjiCc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(38100700002)(36756003)(2616005)(1076003)(2906002)(6916009)(8936002)(186003)(426003)(9746002)(83380400001)(9786002)(4326008)(66476007)(66946007)(7416002)(5660300002)(8676002)(66556008)(316002)(478600001)(86362001)(33656002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D3n1uK85ChuJjFzo22ubqhZlP183Y1zk+6LLua+mGlXZmhig3l4GlzMDNyBb?=
 =?us-ascii?Q?61cffx7ka4BAJ5IYyjw/sy1Fx9qpyWYj0spT8g3GA4r8hMts7Rk1sQXkYZMN?=
 =?us-ascii?Q?csMVXP/tszeL4eI5J+GsmD6P/uCkXqpeCXuwz3d4wt3TKU0tnMQ7t3C0/19V?=
 =?us-ascii?Q?mum6wDiFC8E90g7YiyhzyzXniN3vs0NbFASmzAcYY32Y8emqoVkEjcAH4saH?=
 =?us-ascii?Q?c0ADZ5nwN8atn18pMRRdUEjF1A5JMaKLIO+OjuonB2xiDJvsQunY0prlr1O8?=
 =?us-ascii?Q?FyaRTWPuHCk8eXxuKJ/RFCk3DfTFHWzoFHu7mEDo4fTmPe6oMmOjKoRNTL60?=
 =?us-ascii?Q?N3c9/z5fIbuioJppe62vsFE6fJwQM26zq39aia1zFf7GaVGvEhmJyMHTbsbP?=
 =?us-ascii?Q?Ilt6VI2OeJdHPd8xU+lZCUgMpdLAHgaEzxqoSveushKaN7SiemRdoL08ajs0?=
 =?us-ascii?Q?wtMB0hJ8g7VReh8wIobOIB83rYQAGY4VgjC+23uOEzARqeMPnzmc1GvDkUDl?=
 =?us-ascii?Q?XCMTWCKnkylEzpCHpe/cUB7CVvaPc7OkoLrSHewSbPw2g3xfIyDcFk5KMzoX?=
 =?us-ascii?Q?vymTeg05S6LNTD3+mMYkLCvbYndexatr6HN5aCnREs+0lTxNE94svx6SSx4p?=
 =?us-ascii?Q?XJ5VhvosGOvSNQSlFi+/8tVOq5ZPmFSpaDNWa+PKtbS7x0WSrsZi2eKumCMV?=
 =?us-ascii?Q?KxkC/FzGAyWFOgtQcK6ZztqvE5FHoKqIzdCzmaKWQOMhYVMX2sNRaMCjk9Re?=
 =?us-ascii?Q?5Rv6R0iyWE/utxCONFHAikpBRiR/hX6uEkURv6T60ekO3i1tEfb74GPCD+BV?=
 =?us-ascii?Q?VLArZQVAg/lX3fnLW3b2GqWCZRgexF20ZQc31402FheahKb4zcrpv0FXGQZg?=
 =?us-ascii?Q?MQ52eNuLFEP/nWLpggWL5SKnIyIrMhGG7o13Rpb+OgvMjbm7eSuVkq+uqa+d?=
 =?us-ascii?Q?lF8sVhuUIF9GWZ7YamfHgOIEDIu7u+Ji7mEZRRpMdI/C3JIApcGGfXtjFvs1?=
 =?us-ascii?Q?wRrPreAOi7kyNrZ4PC9j2Vp8by1NXDxJw2HfRfFJp+HMBtK9PqTGTiQOLBwe?=
 =?us-ascii?Q?V+aGGyfX9kcw8JM7qEjnlAMpvt4kYbUwY/lMGZIqWxcAXHM4ju3x4ZU3tORn?=
 =?us-ascii?Q?0Gw+LfBu6uvdLeC7+DZqeT9xeQMCHpXmYRg4GJF3pdroIY85MF/lXpKxaqgw?=
 =?us-ascii?Q?6vengbCOaGN37lQQGfzqhAkaSeyx9etp95GPzAjO8IIjuzKJJFLR6eAMBn/J?=
 =?us-ascii?Q?u9ibEaNbePANhUJ+EE/h1ME/n2z9yVOTd9KD7hyRbXM2ELN/3FZUCqQ04hsP?=
 =?us-ascii?Q?d9k5tSEsrs11ieyL9lJ72CNU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b4f70e8-3f38-48f2-d848-08d91e430532
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:32:25.0158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSRF7Oq/zU176AmyCJkuPWtRQ+Oa1zrOkRTe9DG8axCb/egqncVUry00aSo0YLfF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:26PM -0700, Dave Jiang wrote:
> +static int idxd_vdcm_mmap(struct vfio_device *vdev, struct vm_area_struct *vma)
> +{
> +	unsigned int wq_idx;
> +	unsigned long req_size, pgoff = 0, offset;
> +	pgprot_t pg_prot;
> +	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
> +	struct idxd_wq *wq = vidxd->wq;
> +	struct idxd_device *idxd = vidxd->idxd;
> +	enum idxd_portal_prot virt_portal, phys_portal;
> +	phys_addr_t base = pci_resource_start(idxd->pdev, IDXD_WQ_BAR);
> +	struct device *dev = vdev->dev;
> +
> +	if (!(vma->vm_flags & VM_SHARED))
> +		return -EINVAL;
> +
> +	pg_prot = vma->vm_page_prot;
> +	req_size = vma->vm_end - vma->vm_start;
> +	if (req_size > PAGE_SIZE)
> +		return -EINVAL;
> +
> +	vma->vm_flags |= VM_DONTCOPY;
> +
> +	offset = (vma->vm_pgoff << PAGE_SHIFT) &
> +		 ((1ULL << VFIO_PCI_OFFSET_SHIFT) - 1);
> +
> +	wq_idx = offset >> (PAGE_SHIFT + 2);
> +	if (wq_idx >= 1) {
> +		dev_err(dev, "mapping invalid wq %d off %lx\n",
> +			wq_idx, offset);
> +		return -EINVAL;
> +	}

This is a really wonky and leaky way to say that the vm_pgoff can only
be one of two values? It is uAPI, be thorough.

> +static long idxd_vdcm_ioctl(struct vfio_device *vdev, unsigned int cmd, unsigned long arg)
> +{
> +	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
> +	unsigned long minsz;
> +	int rc = -EINVAL;
> +	struct device *dev = vdev->dev;
> +
> +	dev_dbg(dev, "vidxd %p ioctl, cmd: %d\n", vidxd, cmd);
> +
> +	mutex_lock(&vidxd->dev_lock);
> +	if (cmd == VFIO_DEVICE_GET_INFO) {

Sigh.. This ioctl stuff really needs splitting into proper functions
called by the core code instead of cut&pasting all of this

>  static int idxd_mdev_drv_probe(struct device *dev)
> diff --git a/drivers/vfio/mdev/idxd/mdev.h b/drivers/vfio/mdev/idxd/mdev.h
> index f696fe38e374..dd4290bce772 100644
> +++ b/drivers/vfio/mdev/idxd/mdev.h
> @@ -30,11 +30,26 @@
>  #define VIDXD_MAX_MSIX_ENTRIES		VIDXD_MAX_MSIX_VECS
>  #define VIDXD_MAX_WQS			1
>  
> +#define IDXD_MDEV_NAME_LEN		64

This is never used. Check everything..

Jason
