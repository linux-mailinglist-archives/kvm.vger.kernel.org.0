Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7E47A5139
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjIRRra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjIRRr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:47:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444E6101;
        Mon, 18 Sep 2023 10:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9456PpYnVLfuxHaeCzCliKeHAsqdFxM0m0R9bofGcI9iqQIkhu/Oc53Bs3BKp8lhXCM3y2vAIf423py0SVqIut4zcIBsPZGlZ99eJ1vcnG/xn2S5nyRJtURdBPM/WMorKrkmaFZtKdnJjUkJhMMgfIU4fBcooamUd7/lXZhmMDV+bwR0dvy3I2Ulf8LudYfjPem5hQmDdjZWXqh4CUcU2a40FOjMBXKM7B1xuABN8VyFmMc4giNkjQdKBrZZJLAuwFTYjiDy3E7q0TGCBp4KJFz1dbCzmaITpnVEU8GBSmporEeLD6ITaqG6XnfThebAZ4VLo7d/FgBhGGhwdJfpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6EOln1EzZbW3BGlMWt6IAo7m7yuVn16URHt8lo7DGA=;
 b=h+WcuVVmLezAwQ61/M2y433mUx1uNKvHjGbmjlgu5ZZMOS1/VVJcdo7o76hIOghv9peZeuuheQViBQgIWibf+YwD+qmr+2dySoDn2nlsTietsynEt+2f36cj+DYeZXiJ9VvKQDrTo97BHtbIjkfTYddv7QFrn8SnDN2jfbIkSHlSmTPPT2sm+pvM6IlmW34jXM0MMWtdqCWDAMgwSScpEFLPe7dj3zkbuBsW/R6edLudQMGkl4qVJ4+LAcBVAJrJc/Nn/7t+OvwQZJdRyCTqk+5wfdH0gmbWg99PYCsdSPzjHsIEre9HLeWGkg8beRnnnuxM5bcsJ6rsloTViV/2BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6EOln1EzZbW3BGlMWt6IAo7m7yuVn16URHt8lo7DGA=;
 b=EOWahcWEgQHL35rTJ3XDEugsAmRlsrXG6AwV0IiJ0AnE8Ta1qnd0lX+CCmVm7Sez0EPBzPZlTY+wt3cdneUJ3o/oUVwaGw48U4G/PSJgY+K23QzydAP25zE9ly8vIAw0bTN7Fw8a5hyFQxqhrxoK7jlUaassYJldnVNrl/pAsGDOs6gU7+FGQwWneBJc2yi3BToA9BLeEzYlutz4dZFYGnfOWc5lu2lOGUzjMDmuwcjr2UsdrpxjCbyv0dm146iWq/qBypnkHMbSA6bULS26FLPdVIdq5x6DbEZc3D2yYBz8vb7D70BLVsEqsnVUOWCcCmVC69t+kNlvj2V09tHBTA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7114.namprd12.prod.outlook.com (2603:10b6:510:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Mon, 18 Sep
 2023 17:47:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 17:47:18 +0000
Date:   Mon, 18 Sep 2023 14:47:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        anuaggarwal@nvidia.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Message-ID: <20230918174716.GL13733@nvidia.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
 <20230915082430.11096aa3.alex.williamson@redhat.com>
 <20230918130256.GE13733@nvidia.com>
 <20230918082748.631e9fd9.alex.williamson@redhat.com>
 <20230918144923.GH13733@nvidia.com>
 <20230918111949.1d6c8482.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230918111949.1d6c8482.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0065.prod.exchangelabs.com
 (2603:10b6:208:25::42) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7114:EE_
X-MS-Office365-Filtering-Correlation-Id: 56e6d9b9-5ea0-41a3-6c76-08dbb86f4d1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: skdM2M+2NBXjtQe5gPsCS+cx5Li7Q2/fztyl/9iMDSqHHaRS+Ulf0saGl06WMXc9y4H049nOWgmarXPX6pifsjnu4x6Kz7SJdXbBrRKfhooQVwWSHsk1xgLK3fnMdNiJ8WWAhkixS3hMhryk0iANvmUHxkZvn5JAHvc1aG0DXLceZRikET0qM9ie7y+b7B5rpAffDyaYAzI/xZ1KphFAOOccMtm11BMcF0bjps9Ag4Xyk49lDMMzMM4WnlsSCnq7HYQblYP8syUDFURfhgxmpuPYTFYOvQtDXDKLXfFFO5zp17xi9OCUb/SB5PspZHqOA5bGLxo4/MMyZz/fk7YEPnWPGlwNo1SM5Bg3PpUM6l9Hvc74ybySxnZjpshguTbfJifU9e790xhW1/gZ/6A5EQCqrQz65Mk3YRC+9kDMSi+zi31T4TNyuNENDw2kESuod1uGNtIAhVp19iuyAkzjvjLqhgzdA7cJfOhZlEPvmZBDAHx7pRF70wlKid59lfTrUH9jBIMaw7KOYUWue33QSWpPBNN0gSsW/EHkpERaCwnQECCqvwpARczIXzHSHCtwTi9F7QnSKkppQe582/7Kjvvt21weijAqe1UINQ9dIKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(376002)(136003)(396003)(1800799009)(451199024)(186009)(66946007)(66476007)(316002)(6916009)(8936002)(8676002)(4326008)(41300700001)(6486002)(6506007)(6512007)(478600001)(966005)(83380400001)(2616005)(26005)(1076003)(86362001)(33656002)(2906002)(38100700002)(5660300002)(36756003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FSsmhXY3JFVb8RFIeydVS6ny5TggAOTjbCMYVWk6H1TGu1D4N7xqqXE/1giV?=
 =?us-ascii?Q?aJly8r2nh78YjaZN/BUxwx4zFnWvS0q0a9CQLICY5U34qYXKU0VurKWqjj1Q?=
 =?us-ascii?Q?GbOAlHQlZl3baFdaAeyLFfDYPhqCWmIoScby6kIKpVEZNOkOJ7TQOXz5Atn8?=
 =?us-ascii?Q?JaDEmpFX9DuLvpny3nd9DPJHZrKEGeZj//jadcFreAiLmTJ7TMIrTSticQuw?=
 =?us-ascii?Q?d29JFu+T911HBpvTjd8EnZH7IzlYHOE8Iz9kjMxcQpebQk/3Cw1yrSyif1p0?=
 =?us-ascii?Q?05gPutFHgf4OnAL1fE55tSPSUA/7PqyvHGoLOl7f3TYWPYA/NMbadq2eIRyg?=
 =?us-ascii?Q?fP1PL7fH56MfyqJN9t9w9Hvu4HgNZR0yGWeH3Y3780OmvXVuLLOtTeTZJIFy?=
 =?us-ascii?Q?LQCvb+EXErrZ9siMEs6v/IfX96OctxUdnCfCKaKpGvAVwgBW0uAa7zTuHkMq?=
 =?us-ascii?Q?xVW4ZfhDUtwR1PrWdS6xghgf/cGEtasctuL7Idu2seYSWaNxKGlaQaZHWKD/?=
 =?us-ascii?Q?lHZ3F92UwjGcO6Uz8nI0IUiD70i7D8/ldX67ZW9qcqDq3v0LnbL1MWiT7ofo?=
 =?us-ascii?Q?kE+uo64AKPdjZFgotleb+i1ugK0Cs35LF0y37/VKUo96OC6XTn/RzcNNEmJi?=
 =?us-ascii?Q?fvJdmaFu4wQNyaGjUmTkhdviMgrGrRgr2bM3WgqxWz671e77NwDYXIpBhI5w?=
 =?us-ascii?Q?9yJO/JTwFEGwsBeaj18YoveozH5XNl3QQWduNTbVHDYcySezulr1OtBDZkZA?=
 =?us-ascii?Q?7DI0d3d68UA0qjykvCD9Run7QndKS539OeA9Oe9fPq7hNGOhXn/LfGSF7fzN?=
 =?us-ascii?Q?JPvT2g36osaFHP4tKz1xPeUiaYIrz0AMnqlsha6WnGhsd8APcXui1AQRhl6h?=
 =?us-ascii?Q?vfBZRz0/3Jn/JpadE2UGY/Mxvxo7TQ9+fjl7XDaiHxez3aEedA5pSKYa8O0E?=
 =?us-ascii?Q?DCa3psF4OI27b9IpQBFA9ScIrQJr6XYjWqpItllYeWgO1FNcHJLcS7bIg6a9?=
 =?us-ascii?Q?OrqQdslJDq7zwqHdazlkA4btfLxxJhUdu2ZTg0Us+F2hDYFIjJp19QHhD0oi?=
 =?us-ascii?Q?DN5Negd7By6RRxJSoylbNnSETG34KtNJgPivhjU5SOn3IJrGdtPKboOzzZwX?=
 =?us-ascii?Q?L+84IHrg88mAWhFWko2xUYnemLkUKvw1e+EmroLRZDyZkMAlSh1HkvLw2ob0?=
 =?us-ascii?Q?ED9Gpnr7LtlcxgQoonsHH3E3XykmT3CxeLs6GER9+s9AkfEfH/TJdoznYy7Z?=
 =?us-ascii?Q?9KGWXe58j27ZmiTfLfq5zIJZ5SlLa8vXdP/tlQ21uA000m+Oc7ulE57nnEzt?=
 =?us-ascii?Q?t6yQ0Lx511s2psURxit7tE1/7gl2gcl7VIw7CizLcsPO0DK8sEMAdIHROQv7?=
 =?us-ascii?Q?XPuxP7Txo2ZSVZpsP9iBTZyJajjh7fBdJKTdQdLCiL7milikXSOWHofzvRr0?=
 =?us-ascii?Q?+yj/f9XSeWPnkqyx99FuoygmaXOZRpj6nDyHy+xugTf2/fPcTgA/TBa6bnIU?=
 =?us-ascii?Q?v9KKysmqA6mgZyGauV2oqJ0OvXmnyGDig331S+/N2A/zKGCLlc7XPxJkWWTa?=
 =?us-ascii?Q?nammkiy5+rtsEHY58Dvs7OyIH4+8KOYu0v30HRnP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e6d9b9-5ea0-41a3-6c76-08dbb86f4d1e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 17:47:18.6288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a6sZM0Yak2+HnWHhtqzoTvGrGjdyQCq5180iHDTN6lqowYxkU8utOq8tr4VLP0aj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7114
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 11:19:49AM -0600, Alex Williamson wrote:

> > > And the VMM usage is self inflicted because we insist on
> > > masquerading the coherent memory as a nondescript PCI BAR rather
> > > than providing a device specific region to enlighten the VMM to this
> > > unique feature.  
> > 
> > I see it as two completely seperate things.
> > 
> > 1) VFIO and qemu creating a vPCI device. Here we don't need this
> >    information.
> > 
> > 2) This ACPI pxm stuff to emulate the bare metal FW.
> >    Including a proposal for auto-detection what kind of bare metal FW
> >    is being used.
> > 
> > This being a poor idea for #2 doesn't jump to problems with #1, it
> > just says more work is needed on the ACPI PXM stuff.
> 
> But I don't think we've justified why it's a good idea for #1.  Does
> the composed vPCI device with coherent memory masqueraded as BAR2 have
> a stand alone use case without #2?

Today there is no SW that can operate that configuration. But that is
a purely SW in the VM problem.

Jonathan got it right here:

https://lore.kernel.org/all/20230915153740.00006185@Huawei.com/

If Linux in the VM wants to use certain Linux kernel APIs then the FW
must provision these empty nodes. Universally. It is a CXL problem as
well.

For instance I could hack up Linux and force it to create extra nodes
regardless of ACPI and then everything would be fine with #1 alone.

When/if Linux learns to dynmically create these things without relying
on FW then we don't need #2.

It is ugly, it is hack, but it is copying what real FW decided to do.

> My understanding based on these series is that the guest driver somehow
> carves up the coherent memory among a set of memory-less NUMA nodes
> (how to know how many?) created by the VMM and reported via the _DSD for
> the device.  If this sort of configuration is a requirement for making
> use of the coherent memory, then what exactly becomes easier by the fact
> that it's exposed as a PCI BAR?

It is keeping two concerns seperate. The vPCI layer doesn't care about
any of this because it is a Linux problem. A coherent BAR is fine and
results in the least amount of special code everywhere.

The ACPI layer has to learn how to make this hack to support Linux.

I don't think we should dramatically warp the modeling of the VFIO
regions just to support auto detecting an ACPI hack.

> In fact, if it weren't a BAR I'd probably suggest that the whole
> configuration of this device should be centered around a new
> nvidia-gpu-mem object.  That object could reference the ID of a
> vfio-pci device providing the coherent memory via a device specific
> region and be provided with a range of memory-less nodes created for
> its use.  The object would insert the coherent memory range into the VM
> address space and provide the device properties to make use of it in
> the same way as done on bare metal.

How does that give auto configuration? The other thread mentions that
many other things need this too, like CXL and imagined coherent
virtio stuff?

Can we do the API you imagine more generically with any VFIO region
(even a normal BAR) providing the memory object?

> It seems to me that the PCI BAR representation of coherent memory is
> largely just a shortcut to getting it into the VM address space, but
> it's also leading us down these paths where the "pxm stuff" is invoked
> based on the device attached to the VM, which is getting a lot of
> resistance.  

I don't like the idea of a dedicated memory region type, I think we
will have more of these than just one.

Some kind of flag on the vfio device indicating that PXM nodes (and
how many) should be auto created would be fine.

But if there is resistance to auto configuration I don't see how that
goes away just because we shift around the indicator to trigger
auto configuration??

Jason
