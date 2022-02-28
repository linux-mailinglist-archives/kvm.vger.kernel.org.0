Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070A84C779E
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 19:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiB1SZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 13:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240130AbiB1SZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 13:25:36 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9CDDA879;
        Mon, 28 Feb 2022 10:05:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F857ygX9bbLymKiUxWsquj3Uckvjd+J5WlIFEdsfIXsUZmVQTyHZ93HqK465uEqkvjzEoNn4I6n4j5k6QghdpvvrR14EXTxM0tgQozL31VXKTnh/EC3/t5+laYqg2Pxu9tDzSkAeawTy+ZpGfxlOrj11a/OMUbr4xexgbpDbPcPRs+snYSBt/xY/7HKwFqrgvyUk0RTSwtpdcWIcFhmydOtY6DdbiRtzP2QIKU21jz8QdtwtDegezge7sQ+H7cF+K/5x7j5PDmlaFwkunet77RbJX94Hb+gn1p7U27/weAL26Ozfs7JB4ppewOkomtQ6lalaLnee8imp+F1+JOx8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0PX5HDbqrYAlSRcjXOYZdDNMqc1e0l3aLCngmufz6Bo=;
 b=cOKbnOC67yZMhBmbQNvByjyTdWjVwqsa36A3bsJLw2MtKoDm6sJ+VALYdE6vl9Jr1ubi9sQilqQ9IGbIbRNqXjdtJWGyh4jtRsHS4CaAv/V5SGYiUZ1w88USB1+M+R25cCuQ5JO11x0C1GVaOKy1RtBwCRbUwqG5F0dreIcG1BqcLu7XB+ZpAXXk349ES22cUGKj75Y5A+dwzFN4zzdJ9xhil8ZAvK1VFH6+dqCY7Pl0yoRqK2f+txYqzpFQbUZjqdLTXQK97JdtGN3C/1pqhbJbZ4rGrocez0XbhyHdus463R9JhTIHPoJW4cgHlpAmGbBj/cUbr7MSO5AixOL7jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0PX5HDbqrYAlSRcjXOYZdDNMqc1e0l3aLCngmufz6Bo=;
 b=D1d/wyDCdJBx8YLCz/4ik0PrZPF2A0gxiuasz2xPHbTy/sxy0wfxJ9fmY49TkZdobkxMWsKML8o4+/7lLRS3xIVdBAOnPn6sNhlyOM19qVIWgvQ9lKmbhclIGsiAODGCHBUZg/Omw+lRsqOVPXuv8aD687C8I5NJ7F4omRuG1mcHcgWOtNP6LrOlnPaOCzavtThGF9uTQ+wS6stb9vjk6wS+8gRfYVZHPOZPhGuBjET0f3al5IpWarW1a2griDQAJvhGDO/7R+7v6WGDE/wXQwhIhZwCjGsoMnRzMpykfEH3FO90X45AuXHkDZLgVuMq6F8PkFt7e8Vy+slgW7xxsA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1312.namprd12.prod.outlook.com (2603:10b6:300:11::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 18:05:21 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:05:21 +0000
Date:   Mon, 28 Feb 2022 14:05:20 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [PATCH v6 09/10] hisi_acc_vfio_pci: Add support for VFIO live
 migration
Message-ID: <20220228180520.GO219866@nvidia.com>
References: <20220228090121.1903-1-shameerali.kolothum.thodi@huawei.com>
 <20220228090121.1903-10-shameerali.kolothum.thodi@huawei.com>
 <20220228145731.GH219866@nvidia.com>
 <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58fa5572e8e44c91a77bd293b2ec6e33@huawei.com>
X-ClientProxiedBy: BL0PR02CA0085.namprd02.prod.outlook.com
 (2603:10b6:208:51::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5aa06e1-1b88-43ed-f822-08d9fae4e2cb
X-MS-TrafficTypeDiagnostic: MWHPR12MB1312:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB13121F3104D503D52D620AEAC2019@MWHPR12MB1312.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cv0sYChCdbszhqLnmXX2nDeM15opCeFI+NJs3B03KwZpDIGy58FFmyT8HR3DtG9noV7IRk2ni63CFybGClhdFb/9uMCr2FBlW1l9UBr6+GjDIwtiju5q8fUJBWqInlxUdSH0s/jY3MkiAtWRILZlxHjbm4sqeZG63IuYLkJPAHiuoKVeSfVodUuLYP9ahkOjoYIQ2bbAnVYknhR/2sBYe9OB8FQQr3bmf40ZWdL7FrO/1KhyrT639pTthgzSPI0Zki6RyFWpy0p5pFjtyNc5nvVZ/3RzNx6UKuFWp2uwsPnl2X0QArfbJvZgjBgvam3i+rjoGLUTR7s/Xe95Cb/OiXRYQ5ivgjbQZ/+GbC6lefKl0oKbQpFXQn6d3KxTO9Hj9IIUt8rVS/SnqPL+35TwGLLsN2rEWbPgoW43jc550GcHEC8FgaouQQa27kKagZom+7btfID6Pj1qKldwfDVrs82Jv9zBjut/5cYZyoBg1PueWGoTkLhBodUeIPdEhwy6o1wuJNJ47LT+2BX1J37Zk2hIveoRymAOxFyTX1onJARN4ZeBYtn/2oF7SdthTObRjTPndZNnXRXdVCd9rmzNPWS6A+zMI6jwTHBRMx/VMpJVQi3aYFhU7v9LnZ+qIC0BCHBtafiiOwbMESQyV4IH9JAKlF4G4LDX+M/Mo4iPt407HBAF9wk3b7m+QhR9cdl38QMD1HLeGjf1/YK7DGsD6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(8936002)(33656002)(54906003)(6916009)(508600001)(316002)(4326008)(66476007)(66946007)(66556008)(8676002)(26005)(186003)(38100700002)(1076003)(6506007)(6512007)(5660300002)(7416002)(83380400001)(2906002)(2616005)(36756003)(6486002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gai1EBk4WceuhnhKcG7dDbBXuD5V3Z+kzBZhktDRZWCXl2fA9AeJ4z0CGzII?=
 =?us-ascii?Q?huaygep7Or/KlVzVSOdraAyWU0cCwNifWfjYzsw5QhFC+dGshQS34GBRpWQH?=
 =?us-ascii?Q?OB+rBHZUf9LWog7fWz9d1mw63j7o+ax3r+fJ0UZn0C8h7/LfjHLneTTSv4Ga?=
 =?us-ascii?Q?R8lzI0c62u2EyMr95yatwm/tgqW+o2da8W32FlmwOAsK2aI+3qOf7/EKi1XA?=
 =?us-ascii?Q?GyrkkwLq+VCh7lojS5s8P7ZpOjCoaUQDs/nT4KzjmLe1E0FsNFBv1XlbDRsO?=
 =?us-ascii?Q?wX3ZmK1BSIg7+SIl4SJXIlo7PllATNsfUF6Z6IH2zJhldopBmnIzr4+JZsno?=
 =?us-ascii?Q?yYchllfj7VPQnPWb3PuLiIQdDPg6T87L1DPVZraXMDph73pkzs9SE0DXUqNJ?=
 =?us-ascii?Q?NIBi8NxVxRmsjy7q9buoo6Yc6Gf3fGcucpYyZHrKcaAuCQ5xrHMdu7yiEzoE?=
 =?us-ascii?Q?hsPLCi0stiBwhGs5YUpAVzckj07MLqub1Urmjf2AmM6rAKqzDe7giMRyse7o?=
 =?us-ascii?Q?iY/MJkA4gFFJAkRrqq74zGVghdHcblIXhOa/+P1xuZzi52U74PutKQBOENNX?=
 =?us-ascii?Q?P8/X0PC6s7RMgxbMcqpWjPNagL2npizMdkCKyWqkfOzZGyH2ZkpAMV1lXqAh?=
 =?us-ascii?Q?+4vV3M2Flqd+/lB+34MCOR1Ty6hRhtX8clMbAUQNmlUZP6pqLEOTzT0753px?=
 =?us-ascii?Q?X31prS6CsrvzZ755MZKg3UJDbQi2PGEp3mVfm8+rVrXOAAN4OI7vgYYpFIj1?=
 =?us-ascii?Q?4fIFtYw9fndYTUqMhQBGghg6icMA2VL3CKSItfUglba4O9jjl1i6YKYOMhf7?=
 =?us-ascii?Q?i8qGEtkCZE+55ISLTZDVc4bSUwMHQsoj6MNsDPBAKhPMeg8eN3qW5Q/a5+vL?=
 =?us-ascii?Q?r9UAfPU/Hu32VFweO1TFlWjk5oWcuGTGtE7amhMr7LYetCip5YWd1Sk6Apu1?=
 =?us-ascii?Q?xYD9ucHrr0F8Fb981odohYB6hISGhvGDqOqaMGu0+91kCgMZs9eh45RyAT20?=
 =?us-ascii?Q?A5n3f+9eXrzIPBS9y+7P5/ZPHaJQ4M4Ix+7PoBGcsZnAIasNMA7/8AET7VJh?=
 =?us-ascii?Q?BHq8X4FbVhpb4BSjAjYA14Xm3i7vdSL326JfDGEKFxB17Vdz1MKgTKgZcm3f?=
 =?us-ascii?Q?4gOPQJiRr92zzDa46pT1erjvEuahZofvc7kJ3h9j7MZf/moIUrTg7SPRIvua?=
 =?us-ascii?Q?YH1gFPCG6PMpgPflzJOLwEKnB3KJc2+i724jOd3FI51SiIgyMVtEKrSswe8G?=
 =?us-ascii?Q?VmPmYaenYBHRpcPr4bxByhFDFS6MpFe9mJmoHNSUbwFG/PA/Fy7mT4pwtYEB?=
 =?us-ascii?Q?UNWGn4gyU+ik+1BTe7ne0ixUVRPcLctV2alJbFDONJPVNOXKEsfgklIRjeUP?=
 =?us-ascii?Q?LKCT1FJmxqde8lDyUe5HkfEUEwUrnmh0V7z77nAwoXQvJ8AwlYRBMGI+HAaz?=
 =?us-ascii?Q?A1A3MEg4ektJWYULw6OXnV4rZ2cCP2cJ2bbDQHFabA29rrt19rc0iz+wceTY?=
 =?us-ascii?Q?30wT7BieKnoP+cPj9dC/CsXYdkHY+qBYLD1fCKIw4S81NatlU3Pm4Jr18GKz?=
 =?us-ascii?Q?5DApeli0fGbvY1zfqcI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5aa06e1-1b88-43ed-f822-08d9fae4e2cb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 18:05:21.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljf4hIHxB26baJryNM0lpIWE+10Ksc2+Yo/LuLUxuc3eo2bIO10Q1ai+qvYbYIpT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1312
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 06:01:44PM +0000, Shameerali Kolothum Thodi wrote:

> +static long hisi_acc_vf_save_unl_ioctl(struct file *filp,
> +                                      unsigned int cmd, unsigned long arg)
> +{
> +       struct hisi_acc_vf_migration_file *migf = filp->private_data;
> +       loff_t *pos = &filp->f_pos;
> +       struct vfio_device_mig_precopy precopy;
> +       unsigned long minsz;
> +
> +       if (cmd != VFIO_DEVICE_MIG_PRECOPY)
> +               return -EINVAL;

ENOTTY

> +
> +       minsz = offsetofend(struct vfio_device_mig_precopy, dirty_bytes);
> +
> +       if (copy_from_user(&precopy, (void __user *)arg, minsz))
> +               return -EFAULT;
> +       if (precopy.argsz < minsz)
> +               return -EINVAL;
> +
> +       mutex_lock(&migf->lock);
> +       if (*pos > migf->total_length) {
> +               mutex_unlock(&migf->lock);
> +               return -EINVAL;
> +       }
> +
> +       precopy.dirty_bytes = 0;
> +       precopy.initial_bytes = migf->total_length - *pos;
> +       mutex_unlock(&migf->lock);
> +       return copy_to_user((void __user *)arg, &precopy, minsz) ? -EFAULT : 0;
> +}

Yes

And I noticed this didn't include the ENOMSG handling, read() should
return ENOMSG when it reaches EOS for the pre-copy:

+ * During pre-copy the migration data FD has a temporary "end of stream" that is
+ * reached when both initial_bytes and dirty_byte are zero. For instance, this
+ * may indicate that the device is idle and not currently dirtying any internal
+ * state. When read() is done on this temporary end of stream the kernel driver
+ * should return ENOMSG from read(). Userspace can wait for more data (which may
+ * never come) by using poll.

Jason
