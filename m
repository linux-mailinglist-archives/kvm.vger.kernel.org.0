Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9F43E2061
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 03:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbhHFBCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 21:02:06 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:61889
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243060AbhHFBCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 21:02:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sn5wdr1mv6Il+6Xf4vK+QOZOFEG/hzAUjJoCR6p+YtEhaUwjJQaMhuOv+q38B0pGxikCjmNMAUu61Dn+t7lgnedZWfcUkfkHLjvBKUSeOeusJmgfEa5EgzHz6R986M9ncJATjWCqT3bx7y6T03LZXuYVsP2tWH3/zyNqckqF/fAqKOjA/rYoeqdr7iarl0E/VkW4bpJ6I8gaPWxMmzvC0jdUom8BBp2G6LzohbRnl6wi+tqDLigWdkPW68PF3GNsJlWTKv/aUQEp+0Y/4urDwVlo6T4XPr6nXKL+aQFXX+xzq/TPB3QE7OieeOJCOT9hx5kvpV0kTlUKYh24WfKmeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G7vqfYTRiCfaywpahzicReePSEqc+ooOFOF8Ic5R4Q=;
 b=a02yl5EPmYdHgmMMg142P7E+N9QNalTFK1/UlJCSaijznf0QvDAg+IkSzgRytCwu90aP+gHBYlLReIttVH8+x9f5D3rxJRlBT/vbZ+9o9rrOEoXMrgGiNincpxx4OYBj6ZRe3xpha9dYtjbdWGPXfTO9NPrjnWZEYRsgNaJV2ut51KnIota0sj9IO2YCNo/X0Ii8BJEL85uun99AHuaQPAYnf93XLNLDxLi/zEsr+tY0cQwtxv69g4nPYqD6DtWtHepjq6XF003+VWfXfXhOtTj7NURChUeqaU8BdHc3QfYK8XWG9bARHY7uIpesnaBtN/hqS+4HWyrBaKw3GEQrpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G7vqfYTRiCfaywpahzicReePSEqc+ooOFOF8Ic5R4Q=;
 b=hl7CFQBSJwecPULI+Y7Bi/wVhDnAYjViMb7eGAxQ0zLgF++Z3GedNaHfLn+GNlc7K14iDvHM8L3LcaXQbbpaXzEYhqTPax43ONdv/EwtAPeckZHcz6ZvSrWQ+DynorzWp3m1ou5HxcnLfJjWPPnpYSIQ0EmllkmuYpg/Y6dTJ2uA5H4RdJD1M+952K0ARWrs+JWkRDXu4AxPx7Qdr8rtYI9qkfOZgu+TmAOQ4hroD1t/G3kjHbbGVOs6b3ZJTn0vQlUB7VU5G+oZc2VGeKhfA4uwGINoEfMEDKUsmmuzXK4aSJKegAYbdyZBLm/zT9naVlYdaPSYddfzVuJ7Q4gE4A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5269.namprd12.prod.outlook.com (2603:10b6:208:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 6 Aug
 2021 01:01:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 01:01:49 +0000
Date:   Thu, 5 Aug 2021 22:01:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 4/7] vfio,vfio-pci: Add vma to pfn callback
Message-ID: <20210806010146.GE1672295@nvidia.com>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818326742.1511194.1366505678218237973.stgit@omen>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818326742.1511194.1366505678218237973.stgit@omen>
X-ClientProxiedBy: MN2PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:23a::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:23a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 01:01:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mBoF8-00DnlF-Un; Thu, 05 Aug 2021 22:01:46 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdc416c5-359f-4e3f-53c8-08d95875c4bd
X-MS-TrafficTypeDiagnostic: BL1PR12MB5269:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52692F857C0044095CB178BAC2F39@BL1PR12MB5269.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1yzQepKBCZFvjbSwf8/dTA5SR0R87TjVSf+H6Kutdz821HtujHUs0LI5NpOf4VWYNklv/9nrBYjF6eoS7GeJRgCHKsgYSvsDBJYciF9FJXKUY9V8ezQGV8qn1es74m12wxfSCtN02T2a6ZfOSw+c+iR30CRgj58e7VjGTENwd5GkCk3rIDhKgTe/dqp51sFeJvKjYG8gWCW7jrA+89QhPmRhh9X2jk+f2FpxO28/LzndaktkLTiAeKSovMlA9I5X41rGMj+JqcCo6H0JSAw2ehG7LT+MOJIJ2laFhZX8iyrWm/Y2ayyeH4YYmksU83p3QJeLu9CDq0qtWL3BGXVwWvjsK4aiI3ECiRttgw1OV9+yX6wUQGWDNJSlHDU2IFW+eTg17ljU2PCDN1rucq/ft/gQCkFIrraw6Da+r+DDE4jG5sgi2Hlv2xhghJ2PhafcgN0EWLSNIDgLj5katN26pLFbQBES2jfZX4fueqe3LcS6F17cOAIlo9FrLSFHWUDDbvzQZaVU7oHzsse3tWLeGc44A0cS+sx2H1I3JK7grNz1Nv6bDPIZpBwQao9hBAjqvvbP6i+On0hCKLdk4Npe0450OFMiSPhBI7gq0we3/EiCC6oFJX5uftZuOTSm/DWusMeAveGMITHv+WEvAZRuqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(6916009)(2906002)(9746002)(4744005)(83380400001)(86362001)(33656002)(9786002)(38100700002)(478600001)(8936002)(1076003)(426003)(2616005)(66946007)(26005)(186003)(36756003)(8676002)(66556008)(66476007)(316002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hIDLGqmGd/Ze8snKj5xXvVIg4QNLionIVcKei4hRnVoNLPFd5qrDFTiIdZCF?=
 =?us-ascii?Q?B4hEiptRtFnSCztoCj2a48rdX+TN7epPBbT6JxaL7PDZpFvrDNRtTnsSCYb6?=
 =?us-ascii?Q?R0J8LvmUiJzgUzWnF5cSOZZheB58vslBbbRAligvMLNjW3a/t5JVMyGy+ajx?=
 =?us-ascii?Q?pa8uWtj/VyrEoyx1K1NtoZ+eNBi6vtxm8p2y1Oq5FDN/Il389miGOS7OL41J?=
 =?us-ascii?Q?Xh6nFzzJYglUyIZdzzD015eI5UddzBHOwyMQNL5xH/cS7wv/RgiRDTuySo5h?=
 =?us-ascii?Q?L9ds/57IOzE5KhD6qm1VLmxeCuJaD2tNYsTHF9nVa747Olrbfsf6/O7JmNwL?=
 =?us-ascii?Q?yPSuMSqeHHibJhdIdrVYxBr3rGi8AxZTssPeXz70BA9OhnCnemSLPRygJuFt?=
 =?us-ascii?Q?JWtP86i9Cxs3yFRfBHkLYzdfIix/fwPccydHxthXO4dtxAdvO1FeS3/HZRe7?=
 =?us-ascii?Q?4YeMuT87aV2EnwtZQU2Hr5+oP04EcTGO7InB3WU7EE0KTeRMtZ9ACQWxphZk?=
 =?us-ascii?Q?5S2Dx5nloY6MiT+J7cbU52YIadLH2OVnR5rN2/84g/EsQYAtr0b7kZLb61cC?=
 =?us-ascii?Q?aeZ271jypNiAsudIdAUnxUSeoNvimDn57hpiwdtVFZ+G6DEtdAjJ1qRxVP0R?=
 =?us-ascii?Q?KrkeskKI74V6tYX42ntrVAGt1fVACUoC2ybDwoJQO5NCUux4xV62WUnI2fib?=
 =?us-ascii?Q?IOjV1tbr1E0WCjgQTXOnZR9KY8sUtfVaFoJNmIB48cY4BoGwu+qsEd5hip72?=
 =?us-ascii?Q?eHRxJW3X9FUwURocqlAx5hhj6keKklGCt4tTFfAdTskOZ3cAHzD+ZnEzsbWA?=
 =?us-ascii?Q?cMzZMCWavcuSvtOxaMG2IeMLLMG5sbM9XfuPedtfMba+LHmkibqbhdTFssuw?=
 =?us-ascii?Q?QRNZRVnen7LCo9arl41bzSDRXz9RgXDJDcIPL+NIW0y1d6ggpR0w4WUUdV6C?=
 =?us-ascii?Q?kzgiHrt3oD/sfUqa2tEd7vmQCRkZsfzf9jDWpbyzGmHjK9C7qhmRfQie3aYx?=
 =?us-ascii?Q?h0XXy8jNQ150zTsmuOXYnOgvdUbcv2QgegdhJJ9IvDB/ELr8FeX4edYET7dj?=
 =?us-ascii?Q?p/lC5lzq3EIUG+Nb9Dc6629IgbTuYW1T6J+wrUhnvDmUTNtGVaveNRhQoeYQ?=
 =?us-ascii?Q?s/1s9SucX/3qGCvctL5luqBpF3k90rISDPHMYKojTM517AN9RnAobsF+1maE?=
 =?us-ascii?Q?tXVNgleUFHLVCEsDR0Bf2npDi05y4OSPGIiyz+pjWRNWPyXRHt0QRV0e/3EE?=
 =?us-ascii?Q?kNaBDBmD63fZEuJPKn5ou7xpiygf04GMT2JKfrFYmx5JmKWbfKapjsABauzL?=
 =?us-ascii?Q?Ab01RKJtbCHp6iUrd9caXWfg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc416c5-359f-4e3f-53c8-08d95875c4bd
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 01:01:48.8987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPvOmTJbL644bQThoSRUhqSsvN7sVTjfEsPAMtMHdtaNxO2M55OioWgW3iBDMdew
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5269
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:07:47AM -0600, Alex Williamson wrote:
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 1e4fc69fee7d..42ca93be152a 100644
> +++ b/drivers/vfio/vfio.c
> @@ -875,6 +875,22 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
>  
> +static const struct file_operations vfio_device_fops;
> +
> +int vfio_device_vma_to_pfn(struct vfio_device *device,
> +			   struct vm_area_struct *vma, unsigned long *pfn)

A comment here describing the locking conditions the caller must meet
would be a good addition.. It looks like this can only work under the
i_mmap_lock and the returned pfn can only be taken outside that lock
if it is placed in a VMA

Maybe this is not a great API then? Should it be 'populate vma' and
call io_remap_pfn_range under the op?

Jason
