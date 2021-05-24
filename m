Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E89C38DE52
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 02:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhEXAE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 20:04:29 -0400
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:4448
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232021AbhEXAE2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 20:04:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hA4ajtQN/wZKYflU+dia/hfcuCJIDuyS+f5+KbpKo0pbrYo2pOY03KnlNlSTys1nmHgtj+2SoyEMIUBe9yr6d9bl4fDIb7IyekylDkbc/gfS6mLpfxCqhNy2ZnyGdEFPxKjf8W2UOOUee9uzc3ftLAWYopeP1HzGyfGV/MWDMb6yr8g/h3vtVycc67fs5H95jSBLcSyP9f4xR8LxvNSwyzcyDhxXEktDos4EjVzMK/+J8kAECoAkS1RTU6NnGvk9beDtc0W9qdgGwOzBiali8NdFJJkiUv5TmBDUFMUxN/nU8jWGUtpvgXiWrY4DEx0fKAcBJ3B5tZH+VIhIl4vUtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+0VE5h818Xf4PJxsPZJIBPCn33GrUuTo7f78jOcxTk=;
 b=a4yJ3n4aQUgzP5Z71Kyk8s1NoSieQdtkpAyNJDNw9wItY/bldlrNkop7VeKHDFvRnUOKLAouEo45AgajgiBriLfqGuM/MG0I7V2PM+ZXi//lhROGFKVNy+JhqswV3cwrnKWiGubtdM9Cfcd70dNi8alpvrhJprQAAOKHQwYARCR5gm5Mtg7VSPyj23N3zZIWqcdoGWp8p/ecqQGmJxG6+Y0FtQnj3IQz8tlzk4QAHpn+6dqUrE8LbtER36EWlW4YooWwlgvcaDP9G26xHDADpGiMdhAopylOu1KSE4sjQifD6FD5Fq1TrCKZFws9gJG0uaWNgUrl3n8kI91O+WG9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+0VE5h818Xf4PJxsPZJIBPCn33GrUuTo7f78jOcxTk=;
 b=E0SCZMhpNomvGFkTxWapsIH72Nnu7YRPUFdJ8ZEgnaW4EKpOQVr/C8DOFuC0mDoSr4eOzcd3HL9du6UNGOy5saJfdZWuAxvuw4QKlDdKyGCYjjnQQ3C9PyMht/CXmCnFSdEmV+biaTTU1sHRkwM/kFwn1BFS8/98Or4CAgDXyjS44GraHmDxZZW9/sDDseqOTNmrGl4OyxnC6TpgfRD3vdrR+2osG1KQy6r48uWgvPuFg7yg+Hkqouupy9Vrx0Gbw3sROJ6kdphFDHg/HDLV3IKt0zi/M2oJRfBX+UjZoicZUops0cTXYDnEWcX+3s3OZArIAq5tuGhKElFoLkUg3w==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5192.namprd12.prod.outlook.com (2603:10b6:208:311::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Mon, 24 May
 2021 00:02:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 00:02:59 +0000
Date:   Sun, 23 May 2021 21:02:57 -0300
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
Subject: Re: [PATCH v6 05/20] vfio: mdev: common lib code for setting up
 Interrupt Message Store
Message-ID: <20210524000257.GN1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164277624.261970.7989190254803052804.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YT1PR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::15) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0046.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Mon, 24 May 2021 00:02:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lky3d-00DVD9-Fe; Sun, 23 May 2021 21:02:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c47c253c-5a74-4cff-ca9f-08d91e474aa0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5192:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5192E1776EF7C54EEF0BB13FC2269@BL1PR12MB5192.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smbX2Oh87JS19M6aMAZKhoXhoPmug7jtZuH5sM0FrDBrfTpW2PBBFfY0fyHfeY+kHcskYGcEF6UkEssvJjdbJcfUuMnL7hfWn8gRKfnNaq80TjrOTN4+MSHeejvd0dTaNkVe8JASqEuxgF6aK3KBUaSnH34/ybCScJiAmXKKrUiqq0ieu/ND0hKGGb9Qt9g7GW71MW2sYb1GBTIGtEZG6qhyVu2ObsZkVliyvZ6K99f/nzGupLj9ZuOaeT1MeQN4qeOF5y4YGYxJWpWT5/qkUFJR/SC6CWTn9AYZ8u+Yn21qT28hzrdZm0hX3EHiznVYQ3kPpOIgxt/ToQ71Uhqw1BccFINnuG8x5/kLDXn/6r4XuSUiX7HXUImOuVpxxeDRW6yhEU9fQ0/QdO31oTcyC2hOLyxpfb62kL9JOdtKAUH0LnHI200eA5hDHLDLsOP+VxAwEInolsFNI/5IKLnZsdHNIcJIqunfRZddheubu9r/dNCdlFFwM0chGawSou9f0gVimC7cU3nrr84p8DILIYPsD//raowvd/ALjr+8mAU/6PKOUS98B7WiDtVcVDPN4GGhMTEFN/2YgZwwZ6hkhsj8R//GnVRyF9x6AH9hT14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(9746002)(66556008)(33656002)(26005)(9786002)(38100700002)(66946007)(316002)(66476007)(2906002)(6916009)(7416002)(2616005)(478600001)(86362001)(426003)(186003)(8936002)(4326008)(36756003)(8676002)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HVCEEWkvkmyocSySuzust5l+Imp8krjZECD9HJQ9C+DAST1kRczBX+7mTsDu?=
 =?us-ascii?Q?qFNt4qepMhNlkKhszdmUPDyBEnj2m2rW04YBMZQozfTQz4uSXbIFbeH+Xq3S?=
 =?us-ascii?Q?xwyRZ0mD5/y+B0JNkrhFn9yX03WKqMYe6yW5kYbj4UIkIswT5HWYCduF6xs9?=
 =?us-ascii?Q?JdcxgEjl6WWROYWajVvbm341MahK9D05e2SXRynYPuyr25QhyY6RaQeJizwO?=
 =?us-ascii?Q?O2k973eMm2KkoMP9Rc5eTjAclT5AN592gb11DT/yUQ3mxFDyU3pqspcXs06G?=
 =?us-ascii?Q?u74HxTsWan+9SjKBTPxvWKVv49+lB8xcA/UIn12OIUd2Q0syEy4MyMr9jZk0?=
 =?us-ascii?Q?pi/pUIc1TnFKRVuH6kLBNLziRcNlJd//MNssoLeP+8sC+3aLbT6Cp73WV/da?=
 =?us-ascii?Q?BwAyhJVD7dJK59v7SaJwJhMXXpGC0/l4DtFas7ggwjYMMFp+CtCHHEkg3Xfb?=
 =?us-ascii?Q?raSMeh64hsBcmegGNjy58oRscbDYOWKsOvzBfIMX/kPLL4qa9+SxgmKUnNJ5?=
 =?us-ascii?Q?tCH6gfKOKQ9ADQwjuY4YWnGxkPUHSQjVJr/IwdKuq0Q8QMfyfc3G5KmfGc0n?=
 =?us-ascii?Q?1wZrYPvcyxuusy65ey8MCHwqLgdRWU0mYj6j6DHBY7qjX8K2l2a1mfmd4p73?=
 =?us-ascii?Q?42o7O8TbxC0BpghpfPFEVaWQiyGAN5H8HxIwSDhv1+jy0JznrzjqQeAI/vaw?=
 =?us-ascii?Q?vqkcWp+M2xkbrDKQKiC3fQz5B3SikHBGcstHfJ46Pl42O3qqyMztJNBwd1DB?=
 =?us-ascii?Q?eCOwJj3OHVCaaG3Rnx77srnomiwyRb3xgJeIUOlBog75rOtEqmq3I9/u3Fm+?=
 =?us-ascii?Q?xRJSZlk6GN3uM/Jj2aVhhtnz+ggaUIW3YAw9ocQ/oCTsAM0RJNRVdnwgsxDD?=
 =?us-ascii?Q?asU7JBOtrxepXRVlPNUV21JtRqn5Kg3jEQ9yyqAp0pqYoonM/XidZ02Um2Vs?=
 =?us-ascii?Q?2C6+SZl4/O58m2wylgPY1yD4E/yYEKDoJ1d1TlEWkp0wbBZe1fOU2w16NKpg?=
 =?us-ascii?Q?cqbMzPqk6Obh08zjNyF/AIW3V4q+ezPfMfHx6AUAF3Em1ES59bX0gjO4AJvK?=
 =?us-ascii?Q?jy29TVQ/sbuBRn4IJz4FO+l6VqO/eyMcdZtVEqTOI9+YRhP6C70MW/fahgyD?=
 =?us-ascii?Q?PSYLAKWi764y8Tklo0vYWUvvgZdEP2CZmqCPNiMYDz8whJNipiCm5KDH0rNl?=
 =?us-ascii?Q?Wj1iddHGLjrg0WI1z8c0e9EwyDquPxLC938lsUmGkGekL7Pb/8FQD4XH//zq?=
 =?us-ascii?Q?Gcjyo4zvfhyEeq+jIGH82xE/Bu9t/hVd+/EVKp//bLy2iqOyzhAjD9FUi2Vi?=
 =?us-ascii?Q?NOi0JyEnzkvs6dnswNgLvUzQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c47c253c-5a74-4cff-ca9f-08d91e474aa0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 00:02:59.4961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UuzuKVIFXKBVLNT2g+BHfxIedEWhoG4tFdvh+5BJAyQ5oKwQFHbpKtJIsiL4/0/B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5192
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:19:36PM -0700, Dave Jiang wrote:
> Add common helper code to setup IMS once the MSI domain has been
> setup by the device driver. The main helper function is
> mdev_ims_set_msix_trigger() that is called by the VFIO ioctl
> VFIO_DEVICE_SET_IRQS. The function deals with the setup and
> teardown of emulated and IMS backed eventfd that gets exported
> to the guest kernel via VFIO as MSIX vectors.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/vfio/mdev/Kconfig     |   12 ++
>  drivers/vfio/mdev/Makefile    |    3 
>  drivers/vfio/mdev/mdev_irqs.c |  318 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mdev.h          |   51 +++++++
>  4 files changed, 384 insertions(+)
>  create mode 100644 drivers/vfio/mdev/mdev_irqs.c

IMS is not mdev specific, do not entangle it with mdev code. This
should be generic VFIO stuff.

> +static int mdev_msix_set_vector_signal(struct mdev_irq *mdev_irq, int vector, int fd)
> +{
> +	int rc, irq;
> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> +	struct mdev_irq_entry *entry;
> +	struct device *dev = &mdev->dev;
> +	struct eventfd_ctx *trigger;
> +	char *name;
> +	bool pasid_en;
> +	u32 auxval;
> +
> +	if (vector < 0 || vector >= mdev_irq->num)
> +		return -EINVAL;
> +
> +	entry = &mdev_irq->irq_entries[vector];
> +
> +	if (entry->ims)
> +		irq = dev_msi_irq_vector(dev, entry->ims_id);
> +	else
> +		irq = 0;
> +
> +	pasid_en = mdev_irq->pasid != INVALID_IOASID ? true : false;
> +
> +	/* IMS and invalid pasid is not a valid configuration */
> +	if (entry->ims && !pasid_en)
> +		return -EINVAL;
> +
> +	if (entry->trigger) {
> +		if (irq) {
> +			irq_bypass_unregister_producer(&entry->producer);
> +			free_irq(irq, entry->trigger);
> +			if (pasid_en) {
> +				auxval = ims_ctrl_pasid_aux(0, false);
> +				irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +			}
> +		}
> +		kfree(entry->name);
> +		eventfd_ctx_put(entry->trigger);
> +		entry->trigger = NULL;
> +	}
> +
> +	if (fd < 0)
> +		return 0;
> +
> +	name = kasprintf(GFP_KERNEL, "vfio-mdev-irq[%d](%s)", vector, dev_name(dev));
> +	if (!name)
> +		return -ENOMEM;
> +
> +	trigger = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(trigger)) {
> +		kfree(name);
> +		return PTR_ERR(trigger);
> +	}
> +
> +	entry->name = name;
> +	entry->trigger = trigger;
> +
> +	if (!irq)
> +		return 0;
> +
> +	if (pasid_en) {
> +		auxval = ims_ctrl_pasid_aux(mdev_irq->pasid, true);
> +		rc = irq_set_auxdata(irq, IMS_AUXDATA_CONTROL_WORD, auxval);
> +		if (rc < 0)
> +			goto err;

Why is anything to do with PASID here? Something has gone wrong with
the layers I suspect..

Oh yes. drivers/irqchip/irq-ims-msi.c is dxd specific and shouldn't be
pretending to be common code.

The protocol to stuff the pasid and other stuff into the auxdata is
also compeltely idxd specific and is just a hacky way to communicate
from this code to the IDXD irq-chip.

So this doesn't belong here either. Pass in the auxdata from the idxd
code and I'd rename the irq-ims-msi to irq-ims-idxd

> +static int mdev_msix_enable(struct mdev_irq *mdev_irq, int nvec)
> +{
> +	struct mdev_device *mdev = irq_to_mdev(mdev_irq);
> +	struct device *dev;
> +	int rc;
> +
> +	if (nvec != mdev_irq->num)
> +		return -EINVAL;
> +
> +	if (mdev_irq->ims_num) {
> +		dev = &mdev->dev;
> +		rc = msi_domain_alloc_irqs(dev_get_msi_domain(dev), dev, mdev_irq->ims_num);

Huh? The PCI device should be the only device touching IRQ stuff. I'm
nervous to see you mix in the mdev struct device into this function.

Isn't the msi_domain just idxd->ims_domain?

Jason
