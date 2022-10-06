Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553765F7144
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 00:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbiJFWmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 18:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiJFWmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 18:42:42 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2674F252F
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 15:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT9wb/yFCh2/UU0b85a70QbWLY9l9tcJJaDoDptU3vt8HmDakZZp+B7B4XSvPcch9K2aStZR/G1vVVLTbJa1DeMnPDWqCwJ2a3yI+vjhxh8wzaUxt1+630aWTfZdgJ/MLw1PZOOs2H18GUpoGt52Xwt9mbaFvseI51SHKdFONIvclcGKaeq2V8muL6VuRYwfFZnugHW/sdNTbTClGo5PHYlzSHairhm9+lCPye/peo1mQ3HMAh/VLI249NmDjl3V/boQ5msya44sV5B8V4t7lHXuYO229+cPK47fdq5hw6JUO2pVOzHrjbQvXRfFr/xEDa8qpBk0H1RRvvC54UKTvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JgUSZMZRCAHo84CL5pjlGxrxYv8zG5vjBf6XyVk5Kr4=;
 b=mWrRIMCSDoL3Y5cWsOB+aAs+14i2In00HCXRd2Qsa/52yHrVkJpfsNq0O5bNMJe86i8PK0JKDJmaO2g6Ske3CqfH0P6OWNhIFELK4dLoFjnDgo+El155kx8cOwnUOhH5+YwH16wBMiDyqBoMNOhQvJi622FGVULWhxcM99xgCTE82VVXsAA62OdMYxHTBPldeD94auO8cvSn63Xoj5NRpfa7Abz4hLOdtlSCKqXHae7e44340BqD8MEY6Y4e2nDc9K2w7pCMCKt5Kij4QQwRZMjKPdkud0EDTnwsZ8+FMKjzkMgexzQng0i7hy2/1cei4ntMN/PGRTCZK5jsE6Qa9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JgUSZMZRCAHo84CL5pjlGxrxYv8zG5vjBf6XyVk5Kr4=;
 b=axh1KSdn/6q0E6eZfAB7EOThq3vU4yQCOJSD1Y2JiiWL1noCEjMbeakM5zBegI+MgPrwOdSuo5XT5mFEaAPwHc766t1QgnfLcj3Q8xY0tQBWNGnD+TAnY/MCQaslt0Uw4NJNDMgcj+LhN6uWERmFYJm8I1uArbyirgyXe6bUgVnyhh5GCPc1Y0EF0Ky0jJ8PcU+JFKgQPsa7pk0agSa7bjkxW/u6eF5lCnae9bfm9o3Dl+ytTxZTvunTCj+p+pRgK+C0RnRrXsni+O5LDqB/55jbH4BmoTAYlfbSn4H1K/C1tKFMC9C+ammBAvF9D5sB/QIPw0LglellVDzGizZw9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6968.namprd12.prod.outlook.com (2603:10b6:a03:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 22:42:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 22:42:39 +0000
Date:   Thu, 6 Oct 2022 19:42:38 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Message-ID: <Yz9Z3um1HQHnEGVv@nvidia.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006135315.3270b735.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0052.namprd03.prod.outlook.com
 (2603:10b6:208:32d::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: 046f01ee-cd74-45d9-9693-08daa7ec12b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/G/7KQRGOZcbyaF8Jjc6dEDV5GQEkZoa2117ZJpT3jQdGG6unhJYAwaAjg6e4DnUUnGW95R+0XzHi6aWu6GPYuKa91YxoiPvy8yuo1r3ORlhaa/yPK0pCZxnSJYdXgYro3OWGFmH9BicRKCkimxgoZhEh8IPy6J+8bli52b2M9gynWfjB6v4wBGFrY1e0pBTRWQ9LHyGm1mnlOW8da2cQW4HtoRPF8iTfUooxoZpYs5a7KqcxuDtlS6VQHeKTHSRhqDvtX9PXib/gC4JFYZNE9ep7AfR6KxLKIgNtlIUEeUVcmYuztPy2PSE3Ya71BQg4vBagwlMrbhMFKMIiV60Vol0l8KeUKQutZBCdUSFeP6Hd/7WbTFOtvZu9ev99n43JV1IraCJiBX4xj3H6p8+pMlSb/HfAdeTu62BNJRDis9FyMinOd/3Z75MQjmQbM+NUl5D2ygw9nqtfia3Mw7G/a8M8hxDZZYP8znGv4odUKWBhwD23+QneCkDpAufBogsC0K8BCWCy+9Q+ZT6Uv33lHVaQjnfQDDGSO7NlrpziS+6ryy1xKtQ5yHB6DtqahS+V4m3Nzxc60qwbGlMT9Ud02M0BEMV0gS6X441K+nS6SfTWuIIRmJXO8hFDBnRWQCs7277ei4+B21rEGkx39LSwc0k06mRH6SweqJdMMMNAxAd0z9pxSfmDCTOy0Dx+Ww2GK7ON7c9ErCQYCT7s+n8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(6512007)(26005)(316002)(6916009)(66556008)(54906003)(6486002)(38100700002)(36756003)(86362001)(83380400001)(2616005)(6506007)(66476007)(478600001)(66946007)(8676002)(7416002)(8936002)(5660300002)(186003)(4326008)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8DVa0rd1MTk2ZTFhvP5gTFthqU3w611FKyXShTwgnMoHQ5WH4cNyX66SPRGT?=
 =?us-ascii?Q?VQTEyUZ51N2l3YE/kaZLvcvSWC0IlSDoVlMN3dYOpQJH6E3R4k4pwlBsQ+9s?=
 =?us-ascii?Q?iBOpr0KSL4CfSAi3dloUL13HP0EJPMu6HNyMvUgxyskdLaxg38kxuGgJaOcj?=
 =?us-ascii?Q?6dMoxUXAvfJFhjkSRqdAKfzySLoiEI5+CRoZhDFSoPxUZ5Lkt9SzVo16eCNP?=
 =?us-ascii?Q?mPIBmkWtkw/Xot5nw0OGUsaJJw4C1Q+YFZbmplhT/gNfvc1E6x1HB9IPvusH?=
 =?us-ascii?Q?uppPalZ56U4kU32XfcESk/1qujI/9IftFZEBUq1ZUow+Ht5YdG1Kbs/KC0Xc?=
 =?us-ascii?Q?D9N4QgXbIW9cYy1PmK2M+teXCct1ZauKhpVNQCac5XMo6KlBLN2ovTtlk4HS?=
 =?us-ascii?Q?poe5hzy5i2nnRId9sIw5SY+8PxQgjSTSWxvd+g3iv10y4pLEmhzCsXBEUr0P?=
 =?us-ascii?Q?CpjkR781havimLQD67SMWeItrL2PXoteJlM0kP74FN7s1Axx6j29soyjfDXz?=
 =?us-ascii?Q?U0N6sTZKFIN/K7NITrhsvZRGxzdq8oGAHCAejyIKtpn2FmNc6LJzCSbaBKqv?=
 =?us-ascii?Q?XmbFFHdTGBkbBOtTUyvFoha1WZWqAV8wBvplzeJBZe0m8rtuMwKIB187XIEp?=
 =?us-ascii?Q?/ydJAijOWhKI7PrSuh6m/zui+CIXsxgWqyH75bRRW58QOxskqOUgXk8i+cVD?=
 =?us-ascii?Q?xDFnf3vy2U7sIC/6MVMsYJXdtPlqQwsU8DMw5ZJW/I4Lq5+H/PC1JWMGJIHT?=
 =?us-ascii?Q?UsT+7G6qM1lY0d4faJAAChKgVHWFiiR9TwqAACU/TMcxUNt+0QTbQ7ZtTTNR?=
 =?us-ascii?Q?R7YzTSYJMip+Jm8WbO9BfJ8YkcuzeCXOgNFxpMIpJZnagukVfFjFZezebW8i?=
 =?us-ascii?Q?EwFdyRws1kyDMy7kzuwTNSftLXVdkBs226byjZpFLUN2FKIK04akZINsv2BU?=
 =?us-ascii?Q?CuPDtVU8yWDkoZaBAu5TDHEcSYVboQJREjQ9kfrKRjbTl2RoXDYRQAKxEq8i?=
 =?us-ascii?Q?fZh12BjEO3U1MhoQq2encAhgK3AntofLaWyV4/irycWUnn7pRZEciUmVExM/?=
 =?us-ascii?Q?fgKRhBj4p+v1VCMFIf36PP0goOUQmuBfK+GHMbLp6D3qHAQV62DfOvLTn/As?=
 =?us-ascii?Q?0+T72CaTpcceg1CSHE2VzwJTMX7QjV5BOMLQhZWmsMI8fjZeqt7yj5T2PZZR?=
 =?us-ascii?Q?YhEDuC7yq5OtVt8kY+LJwSbN6yHKvRt8lYVVw6VD3V+7fm/+OdgOdcRfQ8Kh?=
 =?us-ascii?Q?4RXrs5wP/LX49GvjVojhtzZiT5CCbDzYq9GXEu3gswUC31eUhXEnbuDCgboW?=
 =?us-ascii?Q?riDn5LuqT3K05eAFKcz5z6aQJk1r/Gqe754yG0PRY62nHgt7mmKSxHisGCzg?=
 =?us-ascii?Q?DY3lG0ms4q/lt4AjJLtb4VulZrEad0OlOMH243Lzo7B0wfZpUEF33QsHGlp9?=
 =?us-ascii?Q?A047RCLqfJ/FPUY8rBDZUrEbEYGcT8itP+yaAQQCHZ6+Sc9KwaOdjleFZMCm?=
 =?us-ascii?Q?ZNIJVOobTEWFdEzfAgLvvNU//zFGmGToAg57F8sfPK5QhxE8dDwhtcdj3se2?=
 =?us-ascii?Q?xO9+lugN9ZBfh4WeSwY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046f01ee-cd74-45d9-9693-08daa7ec12b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 22:42:39.5647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7gxT1aznLKh+wK6L9+kWkt8YiuxnqAo4qM83de00lkWk4su0LRo+bt4NVU7X5zX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6968
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 06, 2022 at 01:53:15PM -0600, Alex Williamson wrote:
> On Thu,  6 Oct 2022 09:40:35 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Testing has shown that virtnodedevd will leave the group FD open for long
> > periods, even after all the cdevs have been destroyed. This blocks
> > destruction of the VFIO device and is undesirable.
> > 
> > That approach was selected to accomodate SPAPR which has an broken
> > lifecyle model for the iommu_group. However, we can accomodate SPAPR by
> > realizing that it doesn't use the iommu core at all, so rules about
> > iommu_group lifetime do not apply to it.
> > 
> > Giving the KVM code its own kref on the iommu_group allows the VFIO core
> > code to release its iommu_group reference earlier and we can remove the
> > sleep that only existed for SPAPR.
> > 
> > Jason Gunthorpe (3):
> >   vfio: Add vfio_file_is_group()
> >   vfio: Hold a reference to the iommu_group in kvm for SPAPR
> >   vfio: Make the group FD disassociate from the iommu_group
> > 
> >  drivers/vfio/pci/vfio_pci_core.c |  2 +-
> >  drivers/vfio/vfio.h              |  1 -
> >  drivers/vfio/vfio_main.c         | 90 +++++++++++++++++++++-----------
> >  include/linux/vfio.h             |  1 +
> >  virt/kvm/vfio.c                  | 45 +++++++++++-----
> >  5 files changed, 94 insertions(+), 45 deletions(-)
> 
> Containers aren't getting cleaned up with this series, starting and
> shutting down a libvirt managed VM with vfio-pci devices, an mtty mdev
> device, and making use of hugepages, /proc/meminfo shows the hugepages
> are not released on VM shutdown and I'm unable to subsequently restart
> the VM. Thanks,

Oh, I'm surprised the s390 testing didn't hit this!!

This hunk should remain since not all cases are closures due to device
hot unplug

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f9cb734d3991b3..62aba3a128fb8d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -954,6 +954,13 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	filep->private_data = NULL;
 
 	mutex_lock(&group->group_lock);
+	/*
+	 * Device FDs hold a group file reference, therefore the group release
+	 * is only called when there are no open devices.
+	 */
+	WARN_ON(group->notifier.head);
+	if (group->container)
+		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	mutex_unlock(&group->group_lock);
 	return 0;
