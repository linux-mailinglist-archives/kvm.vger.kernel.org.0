Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B01A477DD1
	for <lists+kvm@lfdr.de>; Thu, 16 Dec 2021 21:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241455AbhLPUsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Dec 2021 15:48:40 -0500
Received: from mail-dm6nam10on2044.outbound.protection.outlook.com ([40.107.93.44]:10337
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229591AbhLPUsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Dec 2021 15:48:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StzdYPhfGG/88e1+wQiUcrKoDiuNictxGNvl74W8sdAAE0BpSNoub2f1UFTOXc21aAZq9osJAAmt7XJhTbQqEcl/WZ9wAV5hnbKAf55Y4PFaWIC37Iw34mT5wIAEiTzKWIDAwbERA1N5Pu8GmIvRtoYQGiBkOUiNUc8SjsNVv6ohKjyOJu+rBmc6AlC3BlFFMbS1OLiLenV+1uVaaGOpqfgnNJz1l2pDD3IGkJ8bruNjWU9OBUAi92HGB4SQjFW6AJuqErvyC7iY50S0xYnK+r60H5CqqHkc69NVCZRAhNUXS8bxbkS97Pq0J6j23HAezgZHeG1pfpHOGsyWzO7skQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7K2nLVUQQ9Hu0qy0aoAOQUCeKqqE+Wr5eBqEZTaOqM=;
 b=oa2iNvxwzuRn6TwMr3e7n3Rfu44Dfz6RB0VvBZ/RZJ3FsUmY4lpn3HOFaCD33g83gQWqJP4T1u9WtQeJJGqRlJPCtdFZgTGRixG5gjOix5+UF/nK+1zdrYL3dew4uvlsXja8xn6L/Gdw1FAXUilXI+bdsMbulHorIbkhY4Q3I4jpll2t+gNi54e0ylfslT5wk05Xtoesfv+F6b+a4j9bkT1Mf+3hsBYdGUyK0F1bSJ7vCx23SuHfQWUN3zqiLeWoMZcmJKopLctx80Kegj5iuuAfSI1MOLqW2kcoYcG+++Js1f6u/T6qgQXm9HBVB8xZQIePo6MTJBCbpQ2d3ZAM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b7K2nLVUQQ9Hu0qy0aoAOQUCeKqqE+Wr5eBqEZTaOqM=;
 b=UYuni7eQ/Fmk2whCgrTRhn+CfK65rJxh7muAh3mn0x0l1KiYR52+rpHax5UM0fgsvl7KsuVgg0nqSBgyQtw4IC8DUlybR2rb/fNMKHrPo+eTatahfciiJNrnCXoTGTwoq7mIv14ekieSRd5EI0yaTcnG2dEMaYP4PL1adtkv5NDHtsUp/NCaejbVRFS5hEGmyd4y25o3HQSekJhBgFQhyaNCMzDzI0og8+uQxM252S8b6pJ9rZXe+DlNQY4g1VcbGRTCs2VRwVPppmuOoZ6I7ENUFrWt2IpMuul7y61Bo5T2vigddHdrgglphhZAyg7qS7GxpFjpdinOtArha/vajw==
Received: from DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22)
 by DM8PR12MB5432.namprd12.prod.outlook.com (2603:10b6:8:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 16 Dec
 2021 20:48:34 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.21; Thu, 16 Dec 2021 20:48:33 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::218e:ede8:15a4:f00d%4]) with mapi id 15.20.4801.014; Thu, 16 Dec 2021
 20:48:33 +0000
Date:   Thu, 16 Dec 2021 16:48:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
Message-ID: <20211216204831.GD6385@nvidia.com>
References: <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
 <YbDpZ0pf7XeZcc7z@myrica>
 <20211208183102.GD6385@nvidia.com>
 <BN9PR11MB527624080CB9302481B74C7A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <BN9PR11MB5276D3B4B181F73A1D62361C8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211209160803.GR6385@nvidia.com>
 <BN9PR11MB527612D1B4E0DC85A442D87D8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20211210132313.GG6385@nvidia.com>
 <BN9PR11MB527694446B401EF9761529738C729@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527694446B401EF9761529738C729@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0054.prod.exchangelabs.com (2603:10b6:208:23f::23)
 To DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0a952d1-0d78-48f9-0685-08d9c0d56c85
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:EE_|DM8PR12MB5432:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5072F0AE12F1BF0082EE126CC2779@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP2CPa1Ms+WnG/nouYGz8OT4RoNOAQjF3InwSgS4ENfpXNZxkmbQsUmkuPojoOoWLLazloyiuBE2TRGJ4YHPztNX+35VURGX4L8TLFMAwhEVUewABmFcWzoe+oxU+6GdsAbTQgegh93kV/iIk7rFyrHrfgHz6mV3jp1l2niF6UaTsPOCuvn4U+hEHEbP5BR/H9WLkxwc39sM1Dw8/ofUQSqcemJlZCypAO05WYsUU+tSNn68f8MxipP9V1kvnrsKUxvuzNX8BZPIKxV+oNaF6DRtO/9/7w8ea73bR2lpS7+Ern2zMNytFik3yofoM/c841DmgW17bvaYEU8mvxtuzlzNruwDmPUb+9KPaIeI2+1YKk8ML5IrEn+AjSQs+J7dkFCyziJgmrjF7/yvhaNZd77dOKuWmPk2tNG/S85/Z6hlFI+yKJ4hiJKY23XP3GqBhPQ/tzg6M/sQvA0xtMdx2I/OIOTDLsERXUQW1oGPAjBXtbdZAmnz+3Km9PSM3n2hO6FURShkQMqmSVNsPCrXOUHEDs4CusiFGL8E9GyvL7jrFft8SC10K5FxEuxgq//SfY1Ea41RdAGlCfYJlxMtW0kwXFx6hXn5trOWW8dAVVSAugOjElFJDp2NOcT352UoKBJYM5qYJbgyGVqteA5slQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(2906002)(6916009)(186003)(66476007)(7416002)(36756003)(8676002)(2616005)(54906003)(5660300002)(6506007)(4326008)(8936002)(38100700002)(6512007)(316002)(6486002)(66556008)(86362001)(26005)(1076003)(508600001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3voI1HRBmlTQsO30KWHIWul2hN4moFw13nGWtXDL8vFPv/TR/lvr/XMvyhr+?=
 =?us-ascii?Q?cEX6zvi1Rc5E8BNoqB3SbRl5YvxU3+8Kf6gUBBnN63lGdH39+0Nv2tsyIxcr?=
 =?us-ascii?Q?VBpNjRq/lXkrBx4N2MC72wcRTx7gmRYF3HQNztTNrc4EtrvUCgGjCYAiqFrm?=
 =?us-ascii?Q?IuCfWahdMg2r9qX6Mh3xXARrM8CdyH/F4AqB7dYohRtqEWbOt+iXXmNWHGhO?=
 =?us-ascii?Q?Z2ZlnrdEgA3Wx/a1XTWtZI6z5ZBR2b6/FinDzAgyVY7Mspx59/epZKkH4Lv6?=
 =?us-ascii?Q?UwTFZQcbut84S/9jbJlb6IerASyX+QTcf6csyuqF0co1yBngN5cvGB5uOprG?=
 =?us-ascii?Q?KfTG3L20ffbW7llD+jHOpHqxloO5CJ69gae99hXdx/IyyMX0k3bBKxEx+dGv?=
 =?us-ascii?Q?VjwPQWrsV5vpALNkm1ITEFlqELWa1iS/qAKjOfaYEJy3ezB53pLYKppxX6kD?=
 =?us-ascii?Q?FpmU4EM85VyRSfaGBlFE4UFAzm/pBqgSsqC6hvgZEnbRH8tQlba5n/wkWpXl?=
 =?us-ascii?Q?xzDIJfByONiyPHU+133oDsBjqIhxLhPfxNwoBLHEF4U6GSykIg0t8xtc/6k4?=
 =?us-ascii?Q?Jebyt5v1c23CWuUc/fFQvmA3myBva/gGJ2zlbVUeIJhaEnjFiLcZwSlECuvF?=
 =?us-ascii?Q?8JzSQnaTaXpk7Z3JrGvwWGzJPjXEoGLypYSl7x5A2Tz06hf91j6NclG2waik?=
 =?us-ascii?Q?+lF2MwvGt0HFfCeBvzJAcdP1ITU0/fw8ImpLvHnQmDHCjVcvORyvD3pGcQiw?=
 =?us-ascii?Q?hFGopSWJ3WSzGW7IR/2iFoM9DhUVrjlkKn6j0ABfMWKOak82+IVWnQjSLpq0?=
 =?us-ascii?Q?eZrrjYs4j2g223kW/LYkpsC0UVAUj10MU8tue84DaBiFPmC8oE8A8m0MyUBA?=
 =?us-ascii?Q?2plpzamnHsRPJGaw83HyUUmxw8yNAGmjVjVv7f0+ptrQGFyHca5esJLK9BaA?=
 =?us-ascii?Q?4FfyrMkOnC/WYexaEcBRLSNpu4Uf9yNXkw3zgJEJiguZW1s7i2axEz2NcVSZ?=
 =?us-ascii?Q?JRypjxOPPpLyur0NuhKIKl4ptxPjyL+zUDBjC2mG8PzBqFQI1GoUJ/5VJ92J?=
 =?us-ascii?Q?0EdDR81/9OSoktOmI/KTSkNUc6FMdBmCt4LZLUoF6QHQVo3TH9mYPSKtQUgh?=
 =?us-ascii?Q?rVkEr5mp+2D/TEBPYL6xJp1wZauOepIIKdRF3m3+3F7/g9rDSOn2g9Y7hwYb?=
 =?us-ascii?Q?Kr0vL4xKTpSrtZ1aeE7gmJ0tbS31ZoLs+oihpSPC290xaAgW3R5HQpqioqNK?=
 =?us-ascii?Q?hoDy8WEZnzPcFfFcSVtDhrNyQoQmrqQa2qKVnm9wI70FcO1DxgnmkJ+eC08Q?=
 =?us-ascii?Q?uLEGe0uJwZwpgvM0eKPQzjP7LKI99+aIWfSQClcMNU2yW9M3Aebwg+nOJbNh?=
 =?us-ascii?Q?0jw5vMgM1aE/Zfcb8k1hcpBLEzRT/Z0EmFFg9SU8J/6AOb+J/QgqPUcvOTrz?=
 =?us-ascii?Q?NQmSkd0lknUH5ttPaZk3slt8cOwVUXS7xvYebA51nfGAszcLjHvRbRdx78av?=
 =?us-ascii?Q?UhjyDLuiOkXY2eDZG7cRliSWCzA0r80zhBz72ZF/HS7UuW+H6SN9DhLp7RHi?=
 =?us-ascii?Q?y9J/GLCWRXJ9uP/9B8o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a952d1-0d78-48f9-0685-08d9c0d56c85
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 20:48:33.5234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ulnCX6J1pbW5U6AFXjR74SLAp16OzPGJoA5nNsBIBNflhbXSLYtReI6vg6kY5UNy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5432
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021 at 03:57:45AM +0000, Tian, Kevin wrote:

> This might be the only open as I still didn't see why we need an
> explicit flag to claim a 'full device' thing. From kernel p.o.v the
> ARM case is no different from Intel that both allows an user
> page table attached to vRID, just with different format and
> addr width (Intel is 64bit, ARM is 84bit where PASID can be
> considered a sub-handle in the 84bit address space and not
> the kernel's business).

I think the difference is intention.

In one case the kernel is saying 'attach a RID and I intend to use
PASID' in which case the kernel user can call the PASID APIs.

The second case is saying 'I will not use PASID'.

They are different things and I think it is a surprising API if the
kernel user attaches a domain, intends to use PASID and then finds out
it can't, eg because an ARM user page table was hooked up.

If you imagine the flag as 'I intend to use PASID' I think it makes a
fair amount of sense from an API design too.

We could probably do without it, at least for VFIO and qemu cases, but
it seems a little bit peculiar to me.

Jason
