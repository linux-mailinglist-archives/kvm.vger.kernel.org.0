Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620B56FD2F7
	for <lists+kvm@lfdr.de>; Wed, 10 May 2023 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjEIXNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 19:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjEIXNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 19:13:14 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2057.outbound.protection.outlook.com [40.107.95.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667F830C2;
        Tue,  9 May 2023 16:13:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FtxTyzWDINPFhXQACXnjLdnkLVMzpS4ow4A4nG10Wo6G0rVPAjI61IMGG66MJmNh7ETP+WnbUKHuzCPAUlPnwTQjmePNBX7jAMDNBMpNwIGgZiwhmFzTJyBrpRrCyutP6JcrboLrqegpC05FvN3m+BUVOhNezFg5nOtPU1ZeXfMqWsRdeKTlBHYcT6ayZAAhlw8kKzj39OSn8J8urZWiItddqMOIQikQKR0YVx0gidLeRabFJ1mE3XJ+5N4VPLSTc+Qp68ag8GS1dN7UB8tuciF2hLOW6NtCGQzsdUHtREqbnJOSEvP8vJLFFo5SWuM2SnB/h4kIWcgtB39TjK1Lew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfiPrTjXNzB6bqmMDmF74e8FnV62pFvDXBJZQkUQe+A=;
 b=ZMa6/zrpys7qqIO0Te1AqRmiv6W6N6fv8LAFCnXC/rMQDQDhLrVid1NIwZcs3yqnCX5ksMPlv7R3FNOW4JQyiNsavOdjq7JzUEYcGDVuyObvg8McgMdZwjeMQuNfyKcpFK1029DFxnnQuW1fmrNGlmOxLby+80MBYeWrIo2nLS+7LWiVwx0oPQ03SCmckprneL9S0LQ0tWciegRo4Nk1EaeyvUxbYJuoi56PWs+j5iqoD7EgE4967naMtruH6WO+El0JAiZaOfW3Jl+Z7d/Vs62iXJ6ZgJSvHqogyRSeJK6E0ke2TrgsK2e5uSAWjZ4K7gR84ISIpTyxQQOlbDC1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfiPrTjXNzB6bqmMDmF74e8FnV62pFvDXBJZQkUQe+A=;
 b=On1QQNwR+LwAs1K7fhF9UCxUUSQaPoawPw77RiasntnqYZCUZJIL6XTR14UAomdwoHguI1yIV7h0Lx+LcE2hNQ4ay5UYcR4ngPBpCsJOuOY4NTjyLrYFkys8NA3BtT4fTpYH3MoQF8l/HHAhOClVjHp7TumDPDHPDz2LYJoumpBWre3jb4NRb7aNYplDOuSjLVvhrSabBECHY2tqNv2okPLaKPPax4UQeSSCL4HIPcruLtBrofMPEQ7TI/yExfRIv/bBvNfqwDQTJoThaB2BbYJqNY83yqmkcMKWdmt2S0pNIHeDHz1lKGvSpuIPkP+9Z2QBQOi6qns8sYjEmWr9aQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6111.namprd12.prod.outlook.com (2603:10b6:8:ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 23:13:11 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 23:13:11 +0000
Date:   Tue, 9 May 2023 20:13:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: vPASID capability for VF
Message-ID: <ZFrThMhUnsYOE3WP@nvidia.com>
References: <BN9PR11MB52764BE569672A02FE2A8CCA8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZFrMneCMKuCtu7JF@nvidia.com>
 <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527627F407BB2942ADFF800E8C769@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6111:EE_
X-MS-Office365-Filtering-Correlation-Id: 726237ef-2787-4078-6e4d-08db50e2f55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0d/M1g2dqc9PrIs4l/fJjURgkMdPN7p+H3d26gp5Z4A0t8gJvHMRu/IYK8Oqeq7ugK/ArFAut9gkXtHFBiegY3Up/E73DJxRLRA4fl4apflPGB19hw807O8yts9kyEwHbOLApBlvQOgBdiIX+XKbaUO5yOGltHLrquxYCK1GKttDqC762zp4Zg1q4tPmbI7wW061dmmnNA+xilSSonL1+joNVcItKsmjmZKTvdevD7Uh2GReOoiOx0nF2KpFWWcTZ0mtkN/gGKfZ8npy8Oxav6bFarKGAp2ONtJ4ZYYnaBl6tuVuifgUUEfjNKbxgM+rCpA1zUd8OqTSCR9VwjZQL5229BEEXOy2YLETPa25MLvink7R701fAR2ABY4rUzUcwxmQ9aj7ZbE4VfxE9UQNyc4wEQRfw5ZwbLOehFJW9OSOyhMwuDGIxviXykW6X/GpqjALDC9aLpCJIX50seqcZI3iS401jj0gpiyvqQcWnEobWqKyUAI3TGi/JDcYKXhw48G7jlrQ3FYl2YJujotv3zlqJV0CmZiFJLlMmbW04XBCHyZWzfWZ0PUWto3QP+q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(86362001)(6486002)(36756003)(6666004)(316002)(54906003)(4326008)(66946007)(66476007)(6916009)(478600001)(66556008)(5660300002)(8676002)(186003)(8936002)(41300700001)(2906002)(3480700007)(38100700002)(26005)(2616005)(6506007)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aWy6ZMwEDhdwQvTfWgyVEbvNBMdLJA/CzCPRovIQN4ueDl3LFxgkLrwqewRZ?=
 =?us-ascii?Q?NC0TrIDQfwX94ZiGhTvm5l763SLf/TqpJByY09JubciL+BFvpK/bwVhPDlfk?=
 =?us-ascii?Q?YlzgHg4KJ5bUwNKx/Q0k55Rln/hTutQtgIGsCPOzSKihb8eizLyehZRVl/n1?=
 =?us-ascii?Q?j6LZqg8ND4Ca7MZUSutQXzl0FcWkVVM+rjBNz0R4T20zheQ5qUxhUOTrz/8X?=
 =?us-ascii?Q?va3eSc3z215SSDVRQWS9nf6WJbD1AiRSxiEVFny35rVd7iQTCKNu+xb2ls/2?=
 =?us-ascii?Q?yOPN5WKggUGyk7KMHWbvdY6I7l+R8S/gNV0r/qrTet29VbxI7zCImKAhu42l?=
 =?us-ascii?Q?67c6fzgXsPDqxELdkWJKPZbQqTL79KZfsEjVhR1gfAdGo3lnfhnSy6wUJVJA?=
 =?us-ascii?Q?cNVzyMOy3oTyDKyqg+JwFev2hdpAV0lk0W4K4sraXktdFlQDlnZrl4pW/wBY?=
 =?us-ascii?Q?AW13r5LQ5NhtacdFAgRLGo+kNdKt1oMRyqFNusF6WQrVCKM6WujngF5nA5P6?=
 =?us-ascii?Q?jkJl+0a49n4an78jV4cq+OrHevl+Zcl+jzSl4uIC+WoJ7uIZXuDBU7en46ak?=
 =?us-ascii?Q?vkmAtJJHmWpz4uRefBasUhlqzBmyx4htMUwhUyVHmlh2hy0jTCbsh5UsUiPo?=
 =?us-ascii?Q?bZRT5vdeLycYoYvkWQktqg7PA5jDPdkvUH2TDSb6brZYZ7iTUIz2LUZS0NP0?=
 =?us-ascii?Q?So4fU+Kr9aYlWrbO2RAGpOfRyc5rWaP80S3l2oXJW+H0Myd8UprXavtLA5Uj?=
 =?us-ascii?Q?pCYlOv18wrNIza+hda2IrfmMh3JHhD3duHRMDTvj7li/6uAjze+vdbsKGhml?=
 =?us-ascii?Q?CyFO5J8O2vHllwMXRtemQ3YRAlCWbXCxyBZPYCzU2ZuIbXuk8rvLHCh/CO+A?=
 =?us-ascii?Q?2f68Ts9vpaU7ptYQghZeKuIJkElKVpZEmxoewVBUFC0Cs/lObPltP9D8gqW+?=
 =?us-ascii?Q?PKuPBgKkTTdrV1ExcMWGg3lnI+zr9nH9fNt4y/QNPeVWTu1z3JzlB0vyupJN?=
 =?us-ascii?Q?/oETUwMYCaxnyd+UJPeTrRMB3OeAR5OGVTI7gRVbhl9nC4uxFZgBfArdHV24?=
 =?us-ascii?Q?xIIQk0IG08NMXNmlhsJXSApZn/fmI+ZFaBYZMaUGnIjaAIfEfNq8EINwlRgs?=
 =?us-ascii?Q?DqpMTHmc5FtLWGm3x6aLr9cKgng05OjggnMAY1XY0FWFO3bFhjr4yR/9khCd?=
 =?us-ascii?Q?H31+0BdkZlm3nkjLhwFfHSCU3JEXfSS66F3gch5aNk5hYHFAMT/Gh0IeVgt5?=
 =?us-ascii?Q?ZMhA32h/TN9pKwrGeyDb5Ujr3k3xe1884Bhz3zh4ZPpW59YPoMdmccnaeti3?=
 =?us-ascii?Q?PuhdMyAC8EEg5NswtM6gqmUsBWVBSwBs3n1kJaQaSBDxpFk/87wGYow+Rppx?=
 =?us-ascii?Q?WPndir2RQ8TUpn6QugZfUqhiQ3e+Vp8keNdBTE07fhIxSv7u3DBxXWZmnxHc?=
 =?us-ascii?Q?+Xsk1hZC9LuJbu+jTR9e18CIuzAR7Ab6pDIjUqvokznsMEru+aevtHM5yG2j?=
 =?us-ascii?Q?Li+sqENK5U+qRg8jDf53O2/JTGr7q+wcONWR4C6XTm+uKq7SFKIq0ttXMKTv?=
 =?us-ascii?Q?r63n+rsv6Hok/tA0Cd0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726237ef-2787-4078-6e4d-08db50e2f55f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 23:13:11.3892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3nOXBH4xjOg8BW+U/XHTLXJgRsBleS+fRN+OE2M4S1pJGs9KwcGCYB1PNheZ7ao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6111
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 09, 2023 at 10:57:04PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, May 10, 2023 6:44 AM
> > 
> > On Tue, May 09, 2023 at 08:34:53AM +0000, Tian, Kevin wrote:
> > > According to PCIe spec (7.8.9 PASID Extended Capability Structure):
> > >
> > >   The PASID configuration of the single non-VF Function representing
> > >   the device is also used by all VFs in the device. A PF is permitted
> > >   to implement the PASID capability, but VFs must not implement it.
> > >
> > > To enable PASID on VF then one open is where to locate the PASID
> > > capability in VF's vconfig space. vfio-pci doesn't know which offset
> > > may contain VF specific config registers. Finding such offset must
> > > come from a device specific knowledge.
> > 
> > Why? Can't vfio probe the cap tree and just find a gap to insert a new
> > cap? We already mangle the cap list, I'm not sure I see what
> > the problem is?
> > 
> 
> PCI config space includes not only caps, but also device specific
> defined fields. e.g. Intel IGD defines offset 0xfc as a pointer to
> OpRegion. I'm sure Alex can give many other examples.

Do we even expose those over VIFO? I thought in general we blocked of
various parts of the config space. I keep seeing patches to unblock
parts of config space?

I'd do the reverse and say devices that want to pass parts of their
config space should have a special hook to do it and otherwise we
should sanitize and block?

eg we already have a hook to pass the opregion

> So it's easy to find the gap between caps, but not easy to know
> whether that gap is actually free to use.

Because, let's face it, this is a horrible thing to do, and the
opregion stuff is just ugly as s sin.

Jason
