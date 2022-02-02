Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E24D4A7151
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 14:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbiBBNOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 08:14:53 -0500
Received: from mail-mw2nam12on2089.outbound.protection.outlook.com ([40.107.244.89]:2017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229563AbiBBNOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 08:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOfERpf3wDj0lKHWtglukQ+O1rZ2cqJYGh2cOjjWVxZyCBrSBMDyPo+cwzb1wSYtNt2xawjLI8lCtt/kfFczkRffTyDYyqFSPUGZ3kKXLkO6Q0cSKMhDIRHPV61PQm5VHAgUMynprBKKFAmtmKrQMIdmopoatCgSqtFcfa/ZtQKEvrlwL0r1X8idsxGcAZb64T4u1TB2wXMg+vKAtMYFnxgjkpfuSmUN/xJLj8ycmr+ao/I78KJQYBq0/q1Mq8LZHaYC4/kg/gUapKMsJFKHlAxsuKnCG4bYnUyqL9AHaQG5bQFf7A5h3rJb6H4ScQGXIpvGzeagHn5wZ48tCsQJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDZ61WY7Q7kXIvhJmC0cIuAPO12SO4i3kW9NkqlDSpI=;
 b=W99lTzWPoseJrnAHrtd0ZLNFEh9Gt5lXhyj343sWwVKs3uzdRcGJUm5/C+cJyaqLj6584tTAGfAQ7s2x1ouK31ppSp685eQgozeRVvRfqDyz3arA91qcc8zin1IMCwGHDIJUQNCpXkFQX/piYHiG17Lxtxt+c9bGrfauCujecn43vvYbbca8U648CYOr/uS+LKsqJEF6iX3h9zhtu3fkVJeaiwe6x7ITs2dJqERJPjXNTzz08k1EI0eHJUjMgh+WmVwHH9mdgKwzCpLuMFs5cpC9WciFjJs7gxtrwLaseJHFY9GgGJmW+MuKsuyJVj5F0S0cn4gcvo5MvwQ0ey8xtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDZ61WY7Q7kXIvhJmC0cIuAPO12SO4i3kW9NkqlDSpI=;
 b=VvJ03PpUE88cdfbV/W/12LaIjnc3AInXOyojdjEQuqBdgwRcUYG/ewRl310QnUxup+5Pz8OVAitXWTMMUEFUwV2nt2gHwZu/JEkbAwXInIz5d+/rYSqlmqK1RFmLXb75ct2Jg1MHvvOc4SZi6ZqTiN7vY21MFx8aP0lOB888S7eqxYRFwgbrNIuJZ4uGyoAuNGQnZHN4qYeo0KOLocDvdNsVgyGukqKA+oksOLf7wUExXZliE4uW0YoSXab+5GEUCK1S0+cLxg79Qz5ZMLQm1YHsI747E/sZ6mLVNtJzNBS2euHu1SmB8bd68ZXUsEzAmpyC0KR9MC5agkrYdPF+hA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1854.namprd12.prod.outlook.com (2603:10b6:300:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 13:14:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 13:14:49 +0000
Date:   Wed, 2 Feb 2022 09:14:48 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, alex.williamson@redhat.com,
        mgurtovoy@nvidia.com, linuxarm@huawei.com, liulongfang@huawei.com,
        prime.zeng@hisilicon.com, yuzenghui@huawei.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202131448.GA2538420@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: BL1PR13CA0177.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f427b0e2-8f75-43e0-4f88-08d9e64dfda2
X-MS-TrafficTypeDiagnostic: MWHPR12MB1854:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB185445D554E08DCE44EC768EC2279@MWHPR12MB1854.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5JjgVb2sJsme39CUmCC25q5Pv0u6pM/bg/rIPS2wxZW/58QE+WLmX5cI6g8xurxk2epdAGoU1QVr84wIjVcLpWENxS1vtbSdGyoPHqrwvHSRP7RjX9T1jOATb3h9fJFjhZZlO8lt8o6YFqEiBO6pnpUBOahFa5PRACSnwYFeBWCUapSsC5tg9BPlmH+91eurL46X6xNyMerQksYX/52wfnBaRAoLrwwIPdZxiyvk+VWMqohgnP7An6xJTLUeU13FlgYjiq8umVqAwmc3XC7thcSdIs8hNfWs0EEZ9IwhLSdJ1wdQpp86aGV8HT6ZuZXGc/N7dmwwZz0opTIw1/hTGE1M955unOlFPFM8b1z26mUvLRZkFuOExuik1YtT7MnLq68Djyk+sibYbh/8VO9HHNelRN+SJa8JvdRGCu8MQeiw68yMRK9TBmYvG2xDGkH/hV8PlTOGSk52TbLGbgxCwU0g507m9UPNSrN0BczyaIYPHFa9b5wyjLkY90t7Unplx9m1mHOyGdzZNHcLUv+h7Zwr905/GAmJbQE4pmRSPSuqtJCLeV/P+mKFdQXy7auMZucshVnSxkzdJ4bcnq5MJ5t4b1gC9Js3oQbTLDosBdEgXcmPh4Fg9LXpJ5Qlf+KWTOQ8QPGQQG9eUnJoQcViHsWCu5jghX3sX+67ZrJ4dnRd4iUSQ+suA/bA3kNZH5zqX3RKsUGQlYpKwAicp7ridQXqXyeAT0X/tX9yGDd1k7E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8936002)(8676002)(316002)(2906002)(6916009)(186003)(966005)(33656002)(66476007)(508600001)(6486002)(26005)(66946007)(6512007)(7416002)(5660300002)(66556008)(6506007)(83380400001)(86362001)(2616005)(1076003)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rDb3Mmj/WLBs3716Af7LSgbSCwpAFCJC24J41/kf+ozMPoIZignxn7Ikykgp?=
 =?us-ascii?Q?DpNKHmhJCiYKTH7PNLUT1j/0gK/X9Pe/0HXRbPLyL87bH4F+CI+b4QRLScRE?=
 =?us-ascii?Q?zRZWyATh/MMcq/kg5ieobHVDrJNmGxAAGdUdae0cmqZ1WZf8EfqGe6MHDzRJ?=
 =?us-ascii?Q?QAS0OafxQM2mXJPXv8J1vkDjOYnCmW1tbE0ZQWj12uRHoRHMf0mFCQLPHxbc?=
 =?us-ascii?Q?7LZ95uL7UQwnml6RQIxmN7E5Z+wU2NwsnCHv4K01mMH5f3w19nz/MS3o+BPP?=
 =?us-ascii?Q?30f2nWjksCZCIU+9z9lfRrMZ0CePXEhvqgQCEBGS87dNoi2V3ko8Q2UHJgHl?=
 =?us-ascii?Q?2R88pCzTC666+GvpdvpL2n/COBb+koGJuD8NCtb9WnyCvsrlzWH49k+Nrttq?=
 =?us-ascii?Q?kRbkqbRjw3qGBqwWqkn/uN8T5qGVSm83r7S5KxAr+1HHmjBgfkyF9TWwrrv7?=
 =?us-ascii?Q?LdWzMzvRP4aLdSPTmcLZTfaoVVpXJnfSQkCjXlO9PqFPL+ttKWIevvWXpP4L?=
 =?us-ascii?Q?bXMYD5FRcmS2iZGqX98NsUciIiTEr7H4c6oUv4qgxPz0PoKXUFmY6Gz4w8d5?=
 =?us-ascii?Q?SQxaExWHu7BocYCUvIsGcPxPtqfWIym4eCAUPPBdIXlJR4RxuYfZ10haEmPr?=
 =?us-ascii?Q?gEYylezmmQ2mhrKF/n63skg5uah5r8YGkmlZ6aaq7SZ0HNISsxvSAGQ6nnUI?=
 =?us-ascii?Q?ri0MgZvbc95XA4BiFPP6NCK/BQLmUmYWaSh1knNeqySmUZH9/HdDMyfXru5O?=
 =?us-ascii?Q?GV6Njyi3KEYIaFvuI9tZjHld4/oAbO+f3Qdpa+pqvrY3swtr5fab+e/oQ++8?=
 =?us-ascii?Q?mHikJ50YXpXcrdSqegKh15fnDgA0KDeNjJoZ5+885hZwZ9ObNYfdgzEPktNg?=
 =?us-ascii?Q?PVl0tFYrehRCM9ZjA3WLJH3qbKlhxTDC0Gm3Ow4OKvjCyaky4Pa8NgAsQjm3?=
 =?us-ascii?Q?yhdQ0bB2nydEBK7Jf1ZWW6goVpscCm9IU5oSN20T0czlJIuRk5hCWNlC3fBh?=
 =?us-ascii?Q?YfaOOHUToLCWq54Q7NGnuAuBQD0ko3h9JR+Jk4WqQ1/37cBJDvdVKtORQTpA?=
 =?us-ascii?Q?zXpoNY59c88v9wDaY15Cgnr1dToCm6WmDPmWkWQRIqDdhkH++n1x/wHkSllo?=
 =?us-ascii?Q?xaHjYOsX0xLE2sV6n6S159Zu49SoKQOHLCThkFqWQfP9IouFMb0ex4oUZr0C?=
 =?us-ascii?Q?AZbkAG37jsDnST+X5jiqJ4WlAMqR26aIBykAPegvTiztbO6Gdel4oKpi2G/I?=
 =?us-ascii?Q?xz2klWMG6kF7grUgJo/sc6t9pUGS50NxDCbzxrnKwPyjITCwTBVv9RvAq1C5?=
 =?us-ascii?Q?F57Mthbr7mpi24NCNpzH1+cFkMvXjiSMvFfDLgAdg9YQtEPeaFNHueC6wCem?=
 =?us-ascii?Q?ATe7wr3HWDlM07Ol9llE3TyuJA5pL87u1JB9+kYTaUAPBFlbyXkUJavHvWId?=
 =?us-ascii?Q?Gsl3GWmJFV1RXPgDWVw11UOGYaEy3P+KwC27FLWT8OMpzLJA/lQqPi6VjZsi?=
 =?us-ascii?Q?xLkOazh03yCZ9lUxq3eGEgaFJF5lc3OtgheEUWaknWOaFSr9xgzYjWL9KANN?=
 =?us-ascii?Q?Z7whSOOJe/V7lzhXbDE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f427b0e2-8f75-43e0-4f88-08d9e64dfda2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 13:14:49.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RIPOzEHZ1D9C3nMi0ztgDsLEbaXDRig2jlChRkK/qL/SvZ3TtxlSxXtijB+FY8Vp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1854
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 02, 2021 at 10:58:45AM +0100, Shameer Kolothum wrote:
> This series attempts to add vfio live migration support for
> HiSilicon ACC VF devices. HiSilicon ACC VF device MMIO space
> includes both the functional register space and migration 
> control register space. As discussed in RFCv1[0], this may create
> security issues as these regions get shared between the Guest
> driver and the migration driver. Based on the feedback, we tried
> to address those concerns in this version. 
> 
> This is now based on the new vfio-pci-core framework proposal[1].
> Understand that the framework proposal is still under discussion,
> but really appreciate any feedback on the approach taken here
> to mitigate the security risks.

Hi, can you look at the v6 proposal for the mlx5 implementation of the
migration API and see if it meets hisilicon acc's needs as well?

https://lore.kernel.org/all/20220130160826.32449-1-yishaih@nvidia.com/

There are few topics to consider:
 - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
   sense for this driver?

   I see pf_qm_state_pre_save() but didn't understand why it wanted to
   send the first 32 bytes in the PRECOPY mode? It is fine, but it
   will add some complexity to continue to do this.

 - I think we discussed the P2P implementation and decided it would
   work for this device? Can you re-read and confirm?

 - Are the arcs we defined going to work here as well? The current
   implementation in hisi_acc_vf_set_device_state() is very far away
   from what the v1 protocol is, so I'm having a hard time guessing,
   but..

      RESUMING -> STOP
        Probably vf_qm_state_resume()

      RUNNING -> STOP
        vf_qm_fun_restart() - that is oddly named..

      STOP -> RESUMING
        Seems to be a nop (likely a bug)

      STOP -> RUNNING
         Not implemented currenty? (also a bug)

      STOP -> STOP_COPY
         pf_qm_state_pre_save / vf_qm_state_save

      STOP_COPY -> STOP
         NOP

   And the modification for the P2P/NO DMA is presumably just
   fun_restart too since stopping the device and stopping DMA are
   going to be the same thing here?

The mlx5 implementation linked above is a full example you can cut and
paste from for how to implement the state function and the how to do
the data transfer. The f_ops read/write implementation for acc looks
trivial as it only streams the fixed size and pre-allocated 'struct
acc_vf_data'

It looks like it would be a short path to implement our v2 proposal
and remove a lot of driver code, as we saw in mlx5.

Thanks,
Jason
