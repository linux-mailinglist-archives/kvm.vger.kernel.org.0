Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8193F232F
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhHSWg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:36:57 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:53185
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232906AbhHSWg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:36:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8JcRiwzylrfPTzTcjfPLQM7xVF/8pL073EVwCnziusdKPD0AMWCs6Wabk34Q4wlLAZCy5gTf6Aso5e4zWtz1mtny8zDiGH/625PRUf/c5Smct1I/86tLGTwLDiJUQepLuqEUT1L3haRYhrqGZSukbehIAMkeVX97He7IhavrDSLWMVMVoR5D+gcw4nBFgDL1iscOWNTdkAmXFskNWrtLYhaTzxiXNc4kBqEkAUcFyruBkgbVkecjFJ+bKIJhnhOpVamOzEIKtgZ6GhVsBVH68NkrCDaKpVHWgrxKd4XUJdB8e1dEA4jUcjmgchX5VOTp9zqfNrcUU96i7i978Agdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2oR0B9KzwkBpKcRUBbpobu2/tLd+SRgGAf2ZuPvxJM=;
 b=QIP+6KvXHpIyUNVS4LUkV2uaJGBhteN+p3KD/mlih/vk35QTEAJn/3DcAOgxNNl8+3L+tX4wSQ3ixSWXG2cx5jjxuR74COjxH0bh8eYWf6QQNSr3SLf9E1Fgm60oLWAWk69P1vAo60BDeBJZF5dOzUaXoXSl4+t6MmjF//bQcH9gwY+OzRA2pUQqJ0Euo8QEJpbk39GKSOutZX38tlCL5QHe9ERfsSwVqCvAnoScUt+SN+ViaqlktITtq2uiwrN+ONT8sQINrhsqo45Ef52dD8uzQQE+R2UQa5lsqjaKRzCi4UEPm4eLgWV5eQwGs+b9v3AOp64nabXZlC4xEK1JBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2oR0B9KzwkBpKcRUBbpobu2/tLd+SRgGAf2ZuPvxJM=;
 b=lef7V7QLRxgXl8zwy2qjrz+1YkPNG4UJRCGXDCGRFEVVUY3pHdeP9gF86F+U1R71ik7HDzVay5xIViCH5m2womYoeoaYiMda2tgsnxZwI1+vhGeHntSY5dVPY0q6MaR8OkNV3uLuPGroI1PjWxewgnJq2rSQIu4rRJWRzEqxfXaBLN+ORYcM5pTnrGc+jmKM3sj5sN+LMJpHRCP2sWskgaDFhhHIcW+Cr3EsSfh1kM19dL1UlM5PWr4P5zbbgVbZqeXbhFNslhNGRzEHr9Eu/KAzoWYq66Fidn1HTo4hO1IRT4L0rCjErS/eFGY5P5/RiBiKgUfVXxP+J6R+jEshOg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Thu, 19 Aug
 2021 22:36:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 22:36:16 +0000
Date:   Thu, 19 Aug 2021 19:36:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH V2 06/12] vfio/pci: Split the pci_driver code out of
 vfio_pci_core.c
Message-ID: <20210819223615.GD1721383@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
 <20210818151606.202815-7-yishaih@nvidia.com>
 <20210819151235.6fe61269.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819151235.6fe61269.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:208:256::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:208:256::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.14 via Frontend Transport; Thu, 19 Aug 2021 22:36:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mGqdz-001cs3-CH; Thu, 19 Aug 2021 19:36:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a35e013-230b-4475-677f-08d96361c1a5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5208AAC218BEBEF0CC066EFBC2C09@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMg/DlKqLOPJLkA+iHufNHr+sUnMzDj2DVbD+U2ISSL+UFm6l0i2y7bSFs77JlQmkEDX7ii3MCUDR3+72nhXJ6z6H9p74x7E5hg7D2RAZNicJRgB9icDO108VqM03bSUpQRH9BGHuX259c0Re5kPm/xLMEIdu2PcNWkyJr5YlgLoHxPGuQYmQSBTSOgftXvPS/+fIeN4HeIOmb2vPhpHoNF9Y97Re597549Pt8enOphkMCz8DfdpwpTuMYNDVkRGK6Y+PwAxcB/PThyZn2oOwFBMz+BCD6G2Qfxb3GuFLx+C7FauoMAxpLc1z/3urux5z01r2KOG1gFMMoDFHAzoVpJU47XQfDo2x2WcRMew+hsxmGvdu5tmign8S/yaOFy1A9ifSiaDTzX8FMXDyVruSTHgw9IuZgqaMbpCKvOMh8ZCf0EXVgj/tfPsz9F1mSXaPzHU3pCXZC7ThH83ti/F0r/W5+KciW/G2Dqhz66ljXRWYnrkVQN8CkoGyFHE9nUdBhpcXc1F+XFTEPpeLeH5mmydfQWY+kG/eb4UTOCMIt8tLk0sqw+LJYlOMZgxY6LwimompolA6t3MlLJtvi58acb1dNfAUmuIzaKI7J+ad72F0QVLfPQSXnliynv+egDKkcFANpzQ2bTOzzNJZp7rmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(316002)(6916009)(478600001)(1076003)(5660300002)(107886003)(186003)(66556008)(26005)(7416002)(33656002)(4326008)(36756003)(2616005)(66946007)(66476007)(8676002)(8936002)(2906002)(86362001)(38100700002)(9746002)(9786002)(83380400001)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gsm9vh2bkz+7nqfjulvcX2yGzEBrqQP8oW9M8UxToo7LlPOVxX8q6PG0uNn1?=
 =?us-ascii?Q?M8QT5cNsAQYstQiZlhhMiqWYIydKoQbenUNPD5E7FHepncXhaH68Bx4Vj47k?=
 =?us-ascii?Q?W2Q2b78KYWhWcx3IZjKgEEy5DhON0xd1BoIqgurihXf1+VI/tlZ3083WAfkl?=
 =?us-ascii?Q?QHejqkJe4jATJXqcyiln0DqqITaRl9t8EdmuSXLhgTTWJhRs1uyYinaeneQq?=
 =?us-ascii?Q?zJem7sJkB92oxZs7sBgKEACEhRQSMUWgqGZSzfjIMPKbOYIgzyi63Nqe8HDE?=
 =?us-ascii?Q?9bsUWFTz92moX+958MIF+WHQ1nXcU+PXLFZJ/fn00WzsoExTijHkqu0F/kbz?=
 =?us-ascii?Q?Z29RMM0RttjTazqtGtngtVFd7Ovs23Jq/AxsPm2STmnsvy3/kVFOaDqc7zb6?=
 =?us-ascii?Q?YM168JhLu+3frPNjb2uiTFgXK6QLLA4vOUnsdEvB06i9Twv11d4LowqA2YxA?=
 =?us-ascii?Q?i/LjZrEiVmRpplb/jWqccAElVPYPRWGMyrOSuBKBAkh+lD7nztuQSN/GVuW4?=
 =?us-ascii?Q?lBzJHClSA6FR/U+8O5XneYKS2NjKwaELjJqqeBZeEn+TWCfWDqq8nyPp8saE?=
 =?us-ascii?Q?wflVu3rb0bLY+CXq7wAkBldlM37FAO5CPzlC5rKBHQg9LBYMGuugAoa8YheA?=
 =?us-ascii?Q?sqztXy0lSCf5zOQAotkKdbdsz+ThYsHPKySdz4U1Cs1jFfJtRypdTcymhuJd?=
 =?us-ascii?Q?SP0yv1A3mUMsn7rfKtwcIAi1P7yVxm/ZrPvOMRMsm1zKDnVYBuuAz5uR6xUj?=
 =?us-ascii?Q?oUdakHnZDaHplXz0gzwKq7Aj67a+WPWxBg7fPIp44GfdOOIv1jTVVXXoE3DO?=
 =?us-ascii?Q?qHB6+3TK8XK5rSvEjPgzkFc+qobND3/TTzSRN78EIaUmdY0wKum3bFmKIvdJ?=
 =?us-ascii?Q?/CJStoGoaNQb2gMdzTvxP0pb37HBraRlkHm9glRUnjzImn18yD6u2IKHSfgD?=
 =?us-ascii?Q?dWtUGLlYDYhrbcyyqDkmS1Dybya/lhlr9TQpzVNwkeqYiShHxAZSaO0tQt8s?=
 =?us-ascii?Q?r3VDHCcduwRMHWN4zkITaIwewDPiKFPVxqEQCcuXvwyHfPxjlDr4jhWB2gH+?=
 =?us-ascii?Q?RL3+6Om6SZO9ESlwuFHhHNKmdf9T/FVK/8iOTaF6OAXTcwfSD7KWN1zfLTge?=
 =?us-ascii?Q?SZxSrWQ06/1Kt1tyW7nK3T0KSITHF/QHzH5bwqsr3WZ0OKFVRSqh/vLdAP6M?=
 =?us-ascii?Q?WYX/jJCkAgjVkB6mEatdbDvy6ur+IHPQkkBR9iV4WTXtFwtoc9pdKPVVPyKg?=
 =?us-ascii?Q?DjTdy4LcPJZSRHLc588OM/qh3kVNwYy2+Br/YHyydaasbldy774PQXxgIvwe?=
 =?us-ascii?Q?6ayo7hjQRBiFBeGSxXiwy3hA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a35e013-230b-4475-677f-08d96361c1a5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 22:36:16.4223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1Nq710z3XtiJB9Kpl+xdhWKoNQQYdXvfrSNbRvNMlC7FCdVAzwTvLP2dzVzSTmW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 03:12:35PM -0600, Alex Williamson wrote:
> On Wed, 18 Aug 2021 18:16:00 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > +
> > +static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
> > +{
> > +	might_sleep();
> 
> vfio_pci_core_sriov_configure() retained the might_sleep(), it
> shouldn't be needed here.
> 
> > +
> > +	if (!enable_sriov)
> > +		return -ENOENT;
> > +
> > +	return vfio_pci_core_sriov_configure(pdev, nr_virtfn);
> > +}
> ...
> > @@ -509,7 +449,7 @@ static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vde
> >  	if (!pf_dev)
> >  		return NULL;
> >  
> > -	if (pci_dev_driver(physfn) != &vfio_pci_driver) {
> > +	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
> 
> I think this means that the PF and VF must use the same vfio-pci
> "variant" driver, it's too bad we're not enabling vfio-pci to own the
> PF while vfio-vendor-foo-pci owns the VF since our SR-IOV security
> model remains in the core.  We can work on that later though, no loss
> of functionality here.

Yes, there are still a few of these references that want to go away..

For this one we probably need to introduce a 'class' notion to the
vfio_device_ops to confirm that the container_of cast is OK.

It was something on my list to look at after this is settled since it
is pretty minor

> "vfio-pci" is hardcoded in this comment.  There are a few other user
> visible instances of this in vfio-pci-core.c as well:
> 
> MODULE_PARM_DESC(disable_vga, "Disable VGA resource access through vfio-pci");

This module_param is on vfio_pci - ideally we'd lift the the VGA code
out of vfio_pci_core into vfio_pci since it really shouldn't apply to
device specific drivers anyhow.

Jason
