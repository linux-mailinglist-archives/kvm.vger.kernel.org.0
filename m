Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B776506294
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 05:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346601AbiDSD3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Apr 2022 23:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiDSD3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Apr 2022 23:29:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2D7289A1
        for <kvm@vger.kernel.org>; Mon, 18 Apr 2022 20:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZqeQgba+i8kBUk+JHPbiaNAPGBuowr1cSd99f4NgwLkVHR1BmRWxMlo25A6eFzdeTbhSjZkN4387FUjdmB6cXZASCQSwm8kXnKrdink4e+RtLqWX1/+gJTtgSKa09PcxDLzAxr8s91Wkfl0GOPH9aex8VbkhOjWZ9OFL8KSoS3OQGjZKZAEAPO1LTZBHjzIW5HlZC8cFi0XdcuVv1/TB4lIoENHcg2SpC3EGXSsLUDF1fHGl/Z2YcKPF193d5zcYfTHYL1bm5RMgXeOrUAFUsrl2dUuoUMyNkHp6ZxiPiuB+2UX3B4ASS8xBj/5qAhgANIyuIxPRClWXU9+hGAbrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wyOd7fHWQNXHnx5BPmTEm7hqE3UeqBwbEsIU/knSStk=;
 b=H0UcmsoNe9E+T5ovwE76MA4wJm4u4MgT9oRq0VdCLs0yKWtnMRqza2OAUpx4Sr+bFXdouqjYDKkYJM5H/Ts+umvPDNG5ryvLLQp6ho1WnrsfFvHQbIsSzNwPZNb+QJzUlG8Rk9ytXygji+OJNB7YYncV9UXTVpTdSveFH3BtbT4f2q0rcF0L5iy/jEiT7fQCXz1sC8Q4Awlu+RS7HAkzRBHJG4dYGa4+BHtU2DiBrn5c7li+E3ywgdVnJ/EZmU8am2XWLgVO+CvpmNtbqOVJ2Vr5ROZBc936O4Dx6qGatr7sxTtcBZiwjBdowxB5jq7UOZGpW5TfdkW8zAhfJKQJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gibson.dropbear.id.au
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyOd7fHWQNXHnx5BPmTEm7hqE3UeqBwbEsIU/knSStk=;
 b=XwBetCG78kKL105vmjQXSRXCZnk5aiXmI0xCi8d7Nhw/pehsgAlXGxSJgibQsz+1Q9rVoI+k2NNsC9c7ApcacZ1KS2dW0fXSN7Uq8sz4BkM+d8wkehM1MAbuxp4PO4Iqe1/u7bBmLen9HBzI/1B8LNWKEEz6sVZ/9XxL0DaWGzOc7dddy0Oo3bOTL22sWlpItAJwxxfD6roIcz+/1+jUVEHIcP1TwQ0SaIxWVSA1l+OpgzBt6PtS9xKha0+BKstRaNDbC78DHAaBgM8Z2U8qVYwdNpOm+8XHUeobMyn8jXiLpQ7wjyQIgqKs508ncvbTarx1cN8wsBMK5HcU0/xmcA==
Received: from BN9PR03CA0959.namprd03.prod.outlook.com (2603:10b6:408:108::34)
 by CH0PR12MB5092.namprd12.prod.outlook.com (2603:10b6:610:bf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 03:26:26 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::66) by BN9PR03CA0959.outlook.office365.com
 (2603:10b6:408:108::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Tue, 19 Apr 2022 03:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Tue, 19 Apr 2022 03:26:25 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Apr
 2022 03:26:24 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 18 Apr
 2022 20:26:23 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Mon, 18 Apr 2022 20:26:22 -0700
Date:   Mon, 18 Apr 2022 20:26:20 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
CC:     Yi Liu <yi.l.liu@intel.com>, <alex.williamson@redhat.com>,
        <cohuck@redhat.com>, <qemu-devel@nongnu.org>,
        <david@gibson.dropbear.id.au>, <thuth@redhat.com>,
        <farman@linux.ibm.com>, <mjrosato@linux.ibm.com>,
        <akrowiak@linux.ibm.com>, <pasic@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <jgg@nvidia.com>,
        <eric.auger.pro@gmail.com>, <kevin.tian@intel.com>,
        <chao.p.peng@intel.com>, <yi.y.sun@intel.com>, <peterx@redhat.com>
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <Yl4r3Ok61wxCc2zd@Asurada-Nvidia>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <Ylku1VVsbYiAEALZ@Asurada-Nvidia>
 <16ea3601-a3dd-ba9b-a5bc-420f4ac20611@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <16ea3601-a3dd-ba9b-a5bc-420f4ac20611@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60b59b91-5797-48f5-5938-08da21b46270
X-MS-TrafficTypeDiagnostic: CH0PR12MB5092:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB509282BF6FF3EB8A73F7BCCCABF29@CH0PR12MB5092.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaZli78FTI1LBh+JQkQKk07SdttlUlBvl+5YzZQTeUvlUubOpE1FHKo+PwXiqc9ExuEXjgcuZdr4mB2A9veMZXcAIoHxGreylWICJ5Tht0q1jBRZWL/uBi4pcmrgj5sUw+UYwmDT75/ILa1PqWvMd1YSVAjordJ6qOyxanu3GnhW1Bs6k4sSLlhJr4EDwIhlsY7395iDuMs9p3OsHZHCVYBr4T7ds2zAP8LzfHmWE+D02/WKgGlPsinNQfPmrx+AGe1pUiY8bnKDbFEl2hNiJTvR8n7tIWVZeg3v1g26mtCWidNugjzb0kaeqnjqKw0DTA95e7qXe5BpgypkijF+jvLTWQFngjEaqipytSG0MwjW6fwA18R6yAUKuJ65C0t4GQq3hcoGJLlGR1qqMbYZjm+o+HUdztgB5YLQ3JGuXP256sgbvtLDhpKaQer4F9A/7py+VBRtyLqe/ox4mxjRbklySltIBzqeaNOusnxN9Nj1hApmgbcdPH5ed3/VfyMiJX86dc3eLqEh3y//DS9Md3OQfxS3ILK8p70GpSdgJ6fr8nV0lmVFa9angjzItZlE0Hl0AaHE8J418D/JtWuu7j1gl3UgUpLyHJIrfY5LXqFkoqzMmCSUO1COhMAhR5AUSVKeeDfqkOeHPMBjC1wPcss5XBLkVcHJKDoWlVmOw5oJYTBLwmt9uCZjOUWk/o1kpFfasqtA6QciDl79r+vnuQIGu3L510a/0/xFaYeJbtIVn0srkOkmF/UDMU8lW8fMy8LWCM3zmHJ+ZJ5GJ9FZArUZKJKnWyWKkhjTM1oq7eo=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(2906002)(36860700001)(83380400001)(508600001)(356005)(8676002)(82310400005)(86362001)(966005)(9686003)(26005)(40460700003)(186003)(70586007)(70206006)(4326008)(33716001)(81166007)(47076005)(7416002)(5660300002)(426003)(55016003)(336012)(316002)(6916009)(8936002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 03:26:25.3831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b59b91-5797-48f5-5938-08da21b46270
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5092
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Apr 17, 2022 at 12:30:40PM +0200, Eric Auger wrote:

> >> - More tests
> > I did a quick test on my ARM64 platform, using "iommu=smmuv3"
> > string. The behaviors are different between using default and
> > using legacy "iommufd=off".
> >
> > The legacy pathway exits the VM with:
> >     vfio 0002:01:00.0:
> >     failed to setup container for group 1:
> >     memory listener initialization failed:
> >     Region smmuv3-iommu-memory-region-16-0:
> >     device 00.02.0 requires iommu MAP notifier which is not currently supported
> >
> > while the iommufd pathway started the VM but reported errors
> > from host kernel about address translation failures, probably
> > because of accessing unmapped addresses.
> >
> > I found iommufd pathway also calls error_propagate_prepend()
> > to add to errp for not supporting IOMMU_NOTIFIER_MAP, but it
> > doesn't get a chance to print errp out. Perhaps there should
> > be a final error check somewhere to exit?
> 
> thank you for giving it a try.
> 
> vsmmuv3 + vfio is not supported as we miss the HW nested stage support
> and SMMU does not support cache mode. If you want to test viommu on ARM
> you shall test virtio-iommu+vfio. This should work but this is not yet
> tested.

I tried "-device virtio-iommu" and "-device virtio-iommu-pci"
separately with vfio-pci, but neither seems to work. The host
SMMU driver reports Translation Faults.

Do you know what commands I should use to run QEMU for that
combination?

> I pushed a fix for the error notification issue:
> qemu-for-5.17-rc6-vm-rfcv2-rc0 on my git https://github.com/eauger/qemu.git

Yes. This fixes the problem. Thanks!
