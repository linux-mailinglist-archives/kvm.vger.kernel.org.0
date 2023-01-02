Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E997D65B5A3
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 18:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbjABRKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 12:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbjABRKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 12:10:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C06964DB
        for <kvm@vger.kernel.org>; Mon,  2 Jan 2023 09:10:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/mahugCSB6sJTjyqWsB7YuouO/iKQSubVw4UWjZr5IWtgQubTOzmASLaRC73iXE/Z19RriZ4qM1ntrmAu4tdt+nwN887bcqg0uviBzST1TCERwU9DEz+PVaoOVqfWGLmfuD7ojKH3mVbOU9wtuwWhy7pVdd0A+a/BYLpZgIkqlJ6sGcNachtIu3vXmL8PsKt2wVG6i5zMSqCQLGRUIr0b1Yo55HYCbbigPTw63hhErj9JGKrDBGDzL7fxpeWDKdGf7u0bnjSu2HrSJXetFr2LtgW/j+Ek6qxMNYVgNF6s+MtMTNhatetVo9jjv4w5/jJymC5zHT1cEFyRBGWPNnlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+gFI3JFo2Vk5SAmBNvOofn0CqJeEFmUe38m8GdNt50=;
 b=oV2SyR3Msq440ke8wljKmJaSNF1wRCtjSmUD3Daa57xj+tGq+KtABivyTygLlYIFJwyJn5y+t+nEjoowaIbPJpJGPf+UUXyy7gs3wc4QuwswVWLiNJNhz2zR7vAPGxRVDQc3IAORogA4ORVqF5gDcMZcavek1E92l3Ws8DGSzYWt95vbkZN8nTfNR/DYkXfXyAo8uSLryvDLhUB7ln2OGFU+K04dauU+FLwkguMaIA/1jWL2Q5KsyqezoutOxcMIQjlSue7ao6myeYXoPAeR7Cw2jzynIEie3uF/xit0avQUQhn9oAG/52cPSJ/khN9cbgzkvMe0AAUq0Z+ltY7oaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J+gFI3JFo2Vk5SAmBNvOofn0CqJeEFmUe38m8GdNt50=;
 b=jiJJ8OKeGwmRWF9khkRU532ddvpIzHwaFLPYsgglXODH5ZK4/C9HBBdjosAPWo32JhMUwUOvX+xmzW+aDkJvUu96oA/XTyM7mbJp4Du979SyRtEs2TDgN5QFVetfA5Jps/YO3AG8eHfvA+Tev4ktfjK6MMYqXBOmm5eGkX3/bZehvY2gHYDaOhjfkFjizMkTqxrLHExKmAIjGXPIPn3IJ9rT0l9+JA5EtS0Jg7B84FTMJEonJbjEO2FHeVR/foK6OdXBT9MhcKNNt3yIfxOkKlojP6ORxXeRMVH6sAAhL3m4c8TS0Iz2sVeWj2P+Kd1t4NxOtMG+a4hWAZedXA1IMw==
Received: from BN9PR03CA0196.namprd03.prod.outlook.com (2603:10b6:408:f9::21)
 by CH2PR12MB4216.namprd12.prod.outlook.com (2603:10b6:610:a8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Mon, 2 Jan
 2023 17:10:31 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::ef) by BN9PR03CA0196.outlook.office365.com
 (2603:10b6:408:f9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.19 via Frontend
 Transport; Mon, 2 Jan 2023 17:10:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Mon, 2 Jan 2023 17:10:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 2 Jan 2023
 09:10:19 -0800
Received: from [172.27.1.1] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 2 Jan 2023
 09:10:15 -0800
Message-ID: <31874e00-f64c-77a9-f9d9-6d7ee19eedf9@nvidia.com>
Date:   Mon, 2 Jan 2023 19:10:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH vfio 2/6] vfio/mlx5: Allow loading of larger images than
 512 MB
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        kernel test robot <lkp@intel.com>
CC:     <oe-kbuild-all@lists.linux.dev>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <diana.craciun@oss.nxp.com>,
        <eric.auger@redhat.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
References: <20221229100734.224388-3-yishaih@nvidia.com>
 <202301010742.GBe0XEkG-lkp@intel.com>
Content-Language: en-US
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <202301010742.GBe0XEkG-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT063:EE_|CH2PR12MB4216:EE_
X-MS-Office365-Filtering-Correlation-Id: ae049cc2-0e7d-47ed-940d-08daece440e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPEfpvv3NeS9Q2fYv+Y6N72uwn1Ssx4/Sy1/PpmxWvhdljkXbo91scvtp7fwL6XsO+1j5S5v4GA25SED99wIs5I8pl6mIKacqN+MIbm3c5OywsTXjtJ/ETQrnUrYGmaFwD0gfBG8qvMiGVk0vF1raIVAFga/KafZDTxsL0Y7O18I56TvE3whPSe0QdvTddwYcSKkam8BH1IY35Hf9swjpOZUEuFBeVoemMjRbOiYsnTyqyxFxWNIMgc4XvFR7wao4cogt3nx+8drncmu/zxoNBVyBvC+mILvkjJEOZiZQ6XPagACU9U1ZfX3mRz8bTw8je17Oz8EnnFZ/osgiorKr6AZCN6Gn45BiPFmg1tZGv3gx06B+HYOVahPVe99zKUJderR3yfdrTi7uVgIucbFF79UUWtz2rG1cRvDh6i6KF7DtRYQvCdvfGfLb8MWAZGIYgt0H/eWOLrJqpMr2+xVMWG8wHcUAH9Ed4MyYC5lm5zC5f+lfbTFHAb6pTcvZsSqfbUDoenlTUAo1DXHR6gdPwFwhxGfrJuksW3dyC+pc4xXvCGHzpEItWgG8FidOF5TcVldliy94k6D/9J3kqKxXFnr/R5Ubi2iZrJIHbA7J5pjoG/YVbehPG6AB3lXnW337P+MJh3SjxgNlTxU85kT66zCRT/9jdHr3scOboT4bTwBrqpG9u/s2tHUTpX/LmYPlJRoimVfBwedWfzyOWdKm5ubMQq/7Poe7JR8jmriEyypm0HO8fqhx4J2n26BW1O3hsmGSPHyNi2TTnysaCiL1EPWBOC09HY987z4laaxQDveCN1H2DHmAtR8Cv1TsytQFyRlL4L8uHccGZBVRhkOeIEjAPuV0lxIcBD8ZUUb58b+0VHGDsMQ7NodWk3PJWtz
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(316002)(16576012)(83380400001)(356005)(2616005)(31696002)(40480700001)(16526019)(186003)(26005)(478600001)(426003)(40460700003)(47076005)(36756003)(110136005)(54906003)(2906002)(53546011)(966005)(336012)(82310400005)(82740400003)(41300700001)(31686004)(70206006)(7636003)(70586007)(4326008)(7416002)(5660300002)(86362001)(8676002)(8936002)(36860700001)(22166006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2023 17:10:30.9932
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae049cc2-0e7d-47ed-940d-08daece440e7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4216
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/01/2023 1:39, kernel test robot wrote:
> Hi Yishai,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on v6.2-rc1 next-20221226]
> [cannot apply to awilliam-vfio/next awilliam-vfio/for-linus]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yishai-Hadas/vfio-mlx5-Fix-UBSAN-note/20221229-181908
> patch link:    https://lore.kernel.org/r/20221229100734.224388-3-yishaih%40nvidia.com
> patch subject: [PATCH vfio 2/6] vfio/mlx5: Allow loading of larger images than 512 MB
> config: csky-allyesconfig
> compiler: csky-linux-gcc (GCC) 12.1.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/88b79e8face73c38db6ca0d13fd1c22a0fb4a818
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Yishai-Hadas/vfio-mlx5-Fix-UBSAN-note/20221229-181908
>          git checkout 88b79e8face73c38db6ca0d13fd1c22a0fb4a818
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=csky SHELL=/bin/bash drivers/block/rnbd/ drivers/vfio/pci/mlx5/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>     In file included from include/linux/bits.h:6,
>                      from include/linux/ratelimit_types.h:5,
>                      from include/linux/ratelimit.h:5,
>                      from include/linux/dev_printk.h:16,
>                      from include/linux/device.h:15,
>                      from drivers/vfio/pci/mlx5/main.c:6:
>     drivers/vfio/pci/mlx5/main.c: In function 'mlx5vf_resume_read_image_no_header':
>>> include/vdso/bits.h:7:40: warning: left shift count >= width of type [-Wshift-count-overflow]
>         7 | #define BIT(nr)                 (UL(1) << (nr))
>           |                                        ^~
>     drivers/vfio/pci/mlx5/main.c:25:24: note: in expansion of macro 'BIT'
>        25 | #define MAX_LOAD_SIZE (BIT(__mlx5_bit_sz(load_vhca_state_in, size)) - 1)
>           |                        ^~~
>     drivers/vfio/pci/mlx5/main.c:568:32: note: in expansion of macro 'MAX_LOAD_SIZE'
>       568 |         if (requested_length > MAX_LOAD_SIZE)
>           |                                ^~~~~~~~~~~~~
>     drivers/vfio/pci/mlx5/main.c: In function 'mlx5vf_resume_read_header':
>>> include/vdso/bits.h:7:40: warning: left shift count >= width of type [-Wshift-count-overflow]
>         7 | #define BIT(nr)                 (UL(1) << (nr))
>           |                                        ^~
>     drivers/vfio/pci/mlx5/main.c:25:24: note: in expansion of macro 'BIT'
>        25 | #define MAX_LOAD_SIZE (BIT(__mlx5_bit_sz(load_vhca_state_in, size)) - 1)
>           |                        ^~~
>     drivers/vfio/pci/mlx5/main.c:652:51: note: in expansion of macro 'MAX_LOAD_SIZE'
>       652 |                 if (vhca_buf->header_image_size > MAX_LOAD_SIZE) {
>           |                                                   ^~~~~~~~~~~~~
>
>
> vim +7 include/vdso/bits.h
>
> 3945ff37d2f48d Vincenzo Frascino 2020-03-20  6
> 3945ff37d2f48d Vincenzo Frascino 2020-03-20 @7  #define BIT(nr)			(UL(1) << (nr))
> 3945ff37d2f48d Vincenzo Frascino 2020-03-20  8
>
I'll fix as part of V1 to use BIT_ULL instead of BIT.

In the meantime, I run some extra testing over 6.2 RC2 but I get wired 
OOPs once the GFP_KERNEL_ACCOUNT is used over alloc_pages_bulk_array() 
as part of this patch.

Maybe some issue that came from the merge window in the SG area, still 
not sure about the root cause.

Alex,

This wasn't the case over your vfio/next which is yet over 6.1.

So, let's hold on here, once I'll have a working series over 6.2 may 
re-post V1.

Thanks,
Yishai

