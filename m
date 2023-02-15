Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AD16988E3
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 00:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBOXsY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 18:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBOXsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 18:48:23 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9762E820
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 15:48:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4KdipDalWzJubUyegC5Tmn51lzwD3KINtW3HleXe5BP4tk6JrYU90UnH1TxCvqCXtCfHZ3Fh0Tj7T4jao/Z2mNarRn9/R1oqvcr2XsOMqEfC1RdSCdbwYkkjGJfzewJhjH3oMY5CYjqjHW5DiXfRH3GwlKO1o55zg5gnp87oVJFiuw15BDSg0FJhOZsQNgXQhHi0xGNlL0K3ZeA9SAyNQkxUC24FDXXVdHy36IpPYszdLY5yDs68vkXHgqPJVxdwrGb5vn/0oskSqPLOcXsonp8jZrG3Tqvdsnw3Rg99OHK5sfw4qgJFhw9MXR/c1GIf6SD6b7SWPDxzI9057/0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Y4RMMfsESY1z/Qz3DjPBFtmd+/AmOumVCpxQtbQ9tk=;
 b=ejC82l/m9lkA0AosAZWO2VcsS0ZhmzVRolyICj9XOxFsUn4p8+dc0nGzLISFaM2WYWUOljfemUPyphl0fGgRqf5NUHaCF8QmdxQxnqgE0KP9iVANUhucYCmL7t6YJ9NVBsoKa07bldUF1W2BiXT414xcM0u33Wv+SI25OUGuD41U6a6FTs7AuPdIXcWNHrv1BXBhkE9el4FIvpu1f53TPdA+3SOn4QvEs+Lomqg0DGccql8tI2OzFbWMtBOjxrM5rI+iWsmgb+VAVcMjH6lqBkFQMYYMz/HC2Ri/AAPNhTcIffMdNw51exu4Yl46AF8+6Y1eJYxKQeAaGCK3tsY/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Y4RMMfsESY1z/Qz3DjPBFtmd+/AmOumVCpxQtbQ9tk=;
 b=jX4CTcWOqcF4XeXTJDDPpRIumN3B73F8O/74sPU2RfWAMVJDJES1938vaW43PX/2FvnGVdLUYPqPz+pv6ik15ChIINBgaGZPSQoVQkA3Q8K51/E0oUR58xH0Xyps8QFtICqL7u0+I5lqqGr5mXfXDN3lNfeoDqlYPujnm0U8W7HsGTsIAYvEAAwQx34Fp2oUcInJmbDhxXtTxA/ccTbtSVR6IKaHKnFraV1uk6uADVhfwSrcbbZzIGBJbseCxaKZvCdON+/a7Tw/pgLwxu893zs1cGG8EHRSs09ERsThWcTobyc1M4T4xI3TnVDljXVA84KpCUVIw/76nnkbJ+24rw==
Received: from BN9PR03CA0098.namprd03.prod.outlook.com (2603:10b6:408:fd::13)
 by SA1PR12MB6918.namprd12.prod.outlook.com (2603:10b6:806:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 23:48:20 +0000
Received: from BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::c0) by BN9PR03CA0098.outlook.office365.com
 (2603:10b6:408:fd::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 23:48:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT024.mail.protection.outlook.com (10.13.177.38) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 23:48:19 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 15:48:10 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 15:48:10 -0800
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36 via Frontend
 Transport; Wed, 15 Feb 2023 15:48:08 -0800
Date:   Wed, 15 Feb 2023 15:48:06 -0800
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>
CC:     <eric.auger.pro@gmail.com>, <yi.l.liu@intel.com>,
        <yi.y.sun@intel.com>, <alex.williamson@redhat.com>,
        <clg@redhat.com>, <qemu-devel@nongnu.org>,
        <david@gibson.dropbear.id.au>, <thuth@redhat.com>,
        <farman@linux.ibm.com>, <mjrosato@linux.ibm.com>,
        <akrowiak@linux.ibm.com>, <pasic@linux.ibm.com>,
        <jjherne@linux.ibm.com>, <jasowang@redhat.com>,
        <kvm@vger.kernel.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <chao.p.peng@intel.com>, <peterx@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>, <zhangfei.gao@linaro.org>,
        <berrange@redhat.com>, <apopple@nvidia.com>,
        <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC v3 14/18] backends/iommufd: Introduce the iommufd object
Message-ID: <Y+1vNgoGJJw40+9C@Asurada-Nvidia>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-15-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230131205305.2726330-15-eric.auger@redhat.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT024:EE_|SA1PR12MB6918:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a117678-221c-41a4-0cf8-08db0faf1e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7vTprzX53ANReBB0e7gLcvHrHNkCym4MMjugSF2rXLT6DnAlKcLUzStMLVgR+e8O9/AR8qa7y2VngmMzPp/sACaFsCB7wjL1wliIOEA2q20unZVygIFzoep4Xm2hX9kGiwgb7k2T/zHBeSMsI4eEjPK5+iKJ7FohycgoT6AvLIY8J2W6IqRp2+4/+Nv3j/OYTYmEQ9lYzaTk4QCsBowlkpj79nw+emJDTIKFvnI7ZJNoa813td5ZxU33N023C6tnrXGTRMFPq48xB1gAuThZ850pTcEZ5LzUdXwDKMzXrc78BAXpFcbb6LZBu/DSuIgrYvCH7qt2VE/pFImjRhlU1Nl0gYwYPhTgIN1JBzIc8nVnUy5NsgdIonz3CFhffMZkVj6CClIazYz6uPSuMtEgxvZAsCiafp7eb2a/MeKY8UdRJRAQm8XoQh8QnkDKJS1BHSniw12vS4ZomhacFsM7VMxbif0yNQHBZYCRjDS2Npw8J7f0Zpq6diOTNgdUPH03xpJWB47qdcv5P9AH8RzA6nWuaVLuxD+ptA+/VXVT7wvSt9tbzjKsy9drWtsrE6veedpQU50+wZfy6mykgeVIYWlRUPe+8xkBJ10XcUBSooS8o0CKdzw6RhDd5FWfYEEnAj/WFn5o7itTNVGMhjHFi4imZbQPLIu8U0lgJLr/+YHhpRafsmj7a1vezqDGf5H45afDmov8GT1T22K0QZpV7Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199018)(40470700004)(36840700001)(46966006)(33716001)(336012)(82310400005)(2906002)(478600001)(9686003)(186003)(4326008)(41300700001)(83380400001)(26005)(6916009)(356005)(426003)(86362001)(40480700001)(55016003)(36860700001)(316002)(47076005)(40460700003)(8676002)(8936002)(5660300002)(7416002)(70586007)(7636003)(82740400003)(70206006)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 23:48:19.8563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a117678-221c-41a4-0cf8-08db0faf1e08
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT024.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6918
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Tue, Jan 31, 2023 at 09:53:01PM +0100, Eric Auger wrote:

> diff --git a/include/sysemu/iommufd.h b/include/sysemu/iommufd.h
> new file mode 100644
> index 0000000000..06a866d1bd
> --- /dev/null
> +++ b/include/sysemu/iommufd.h
> @@ -0,0 +1,47 @@
> +#ifndef SYSEMU_IOMMUFD_H
> +#define SYSEMU_IOMMUFD_H
> +
> +#include "qom/object.h"
> +#include "qemu/thread.h"
> +#include "exec/hwaddr.h"
> +#include "exec/ram_addr.h"

After rebasing nesting patches on top of this, I see a build error:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[47/876] Compiling C object libcommon.fa.p/hw_arm_smmu-common.c.o
FAILED: libcommon.fa.p/hw_arm_smmu-common.c.o=20
cc -Ilibcommon.fa.p -I../src/3rdparty/qemu/dtc/libfdt -I/usr/include/pixman=
-1 -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/glib-2.0 -I/=
usr/lib/aarch64-linux-gnu/glib-2.0/include -I/usr/include/gio-unix-2.0 -fdi=
agnostics-color=3Dauto -Wall -Winvalid-pch -std=3Dgnu11 -O2 -g -isystem /sr=
c/3rdparty/qemu/linux-headers -isystem linux-headers -iquote . -iquote /src=
/3rdparty/qemu -iquote /src/3rdparty/qemu/include -iquote /src/3rdparty/qem=
u/tcg/aarch64 -pthread -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=3D2 -D_GNU_SOURC=
E -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE -fno-strict-aliasing -fno-co=
mmon -fwrapv -Wundef -Wwrite-strings -Wmissing-prototypes -Wstrict-prototyp=
es -Wredundant-decls -Wold-style-declaration -Wold-style-definition -Wtype-=
limits -Wformat-security -Wformat-y2k -Winit-self -Wignored-qualifiers -Wem=
pty-body -Wnested-externs -Wendif-labels -Wexpansion-to-defined -Wimplicit-=
fallthrough=3D2 -Wmissing-format-attribute -Wno-missing-include-dirs -Wno-s=
hift-negative-value -Wno-psabi -fstack-protector-strong -fPIE -MD -MQ libco=
mmon.fa.p/hw_arm_smmu-common.c.o -MF libcommon.fa.p/hw_arm_smmu-common.c.o.=
d -o libcommon.fa.p/hw_arm_smmu-common.c.o -c ../src/3rdparty/qemu/hw/arm/s=
mmu-common.c
In file included from /src/3rdparty/qemu/include/sysemu/iommufd.h:7,
                 from ../src/3rdparty/qemu/hw/arm/smmu-common.c:29:
/src/3rdparty/qemu/include/exec/ram_addr.h:23:10: fatal error: cpu.h: No su=
ch file or directory
   23 | #include "cpu.h"
      |          ^~~~~~~
compilation terminated.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I guess it's resulted from the module inter-dependency. Though our
nesting patches aren't finalized yet, the possibility of including
iommufd.h is still there. Meanwhile, the ram_addr.h here is added
for "ram_addr_t" type, I think. So, could we include "cpu-common.h"
instead, where the "ram_addr_t" type is actually defined?

The build error is gone after this replacement:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/include/sysemu/iommufd.h b/include/sysemu/iommufd.h
index 45540de63986..86d370c221b3 100644
--- a/include/sysemu/iommufd.h
+++ b/include/sysemu/iommufd.h
@@ -4,7 +4,7 @@
 #include "qom/object.h"
 #include "qemu/thread.h"
 #include "exec/hwaddr.h"
-#include "exec/ram_addr.h"
+#include "exec/cpu-common.h"
 #include <linux/iommufd.h>
=20
 #define TYPE_IOMMUFD_BACKEND "iommufd"
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks
Nic
