Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8244B520A
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354575AbiBNNoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:44:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354561AbiBNNoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:44:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A782242EE5;
        Mon, 14 Feb 2022 05:43:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Azp4wlD2BfD1h34TOreFNjRJdcIJ/Ee7dDb+A784nbjMTc7dVPEkhowgkG3sGDfveILFsVXeAjX/FM4cfJLRK3LEswM22W/QgPpbbO5ua6WrP876UPzhM3mN2WlzGx+uLdovZRZSv6Rptk8aHQNWKHoX5AmBgU+Mqyp6rKfPClzv7J87AWe20lI2Rcxt+F4O2GHT0px/HJKOAZ0Uu1Gr6Mfzg5ypHyvKM5Qyps2/GqkQqldChEHOdS3qlV/1JXs73IoYYD9JZgTJ/Xymx7re+jdYPNiXxhLJi2A2+yzUx8eNXLR/Ps1rpYmAPVmJT10c/DUWDKWU8SP/bHRbaDRZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O03nopTDZ/+eLEMXCm7PD+KUdCQvg1nId9Pcks46iCY=;
 b=JfHTBds/2lruEiFwMAzeJOkXUe2uhx5fEewKj1bpalKcRw+BGC8J/2S0csAINDwNMU49cyq6RCTnGZuq5NLcfYLUr2iWftB5xg0xkA6iNOMbAw1z6SWkCeiYLVX/1vjR98HLqFSYdshJKiePqH3GcAJduEuWL//8WQBV5zC+mEwrMCWOvD92wohm0LESdHCnynYOUxgRO+3cvLLZSPu6ihAVEITv/mmDASJKZfyy71Bb8Wr2gV8oXfSwkCm9d876hc+KfDWiX7qnY06Arpc/Y/V6pL/jMeC7oQnwpY/Sk+e53EiWjHHl/7Kq0dnbtC4tKpifZ9mhc97cXnaIi8ZmJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O03nopTDZ/+eLEMXCm7PD+KUdCQvg1nId9Pcks46iCY=;
 b=HiHXdSDlDXM6uRVEd13AdVQ3sryNOaWtFEPL8SEdhaLhvzDENKKmauGtUkTjLOQ/LSIv0+ZKycIC+Oavmpqt9lpK6qBWgbNzsDzN+dDOTFy82QdM5vDDO2Vb2paXRqSUDUr36aiacUAx2ylbSxQYf8SxA9ro622kuYNNOJAo3Fnu/LRzRnp34j82QlsIIzHGX3Ks5u0qayaid7PxEEwIkLlK5RzozoETGJSyJnafXV25gWbTU9jvA9yZBeH+hwEBss0TUn55bWgt7tvmiSb2irytsLyP/E6tBMeDdcSUKIu+rChtlGohc/2KRY2P2tLlpdZ1YNMjjwqLaeNGHqY/Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1357.namprd12.prod.outlook.com (2603:10b6:300:b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 13:43:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 13:43:58 +0000
Date:   Mon, 14 Feb 2022 09:43:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <20220214134356.GB929467@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <Ygoo/lCt/G6tWDz9@kroah.com>
 <20220214123842.GT4160@nvidia.com>
 <YgpQOmBA7QJJu+2E@kroah.com>
 <20220214131117.GW4160@nvidia.com>
 <YgpbhlPOZsLFm4It@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgpbhlPOZsLFm4It@kroah.com>
X-ClientProxiedBy: MN2PR01CA0063.prod.exchangelabs.com (2603:10b6:208:23f::32)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 096c36bc-dcf4-4139-b93e-08d9efc00ce7
X-MS-TrafficTypeDiagnostic: MWHPR12MB1357:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1357895DA011590F9F0FB133C2339@MWHPR12MB1357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /a4oBX3J/cr8xIbGoOdZf/T/XAeK0tzzHvW/CNi8LRrWnqzqndvWPeMd9yfgdmeySLiO4OA81zacfXgCbHRpE9xDQOiuLbh7CWMSfJgWVQuc2P8PLiYIXn2g9krK3QMMvnGiUeLs+ksFyVsmgqguCs/645Sz3rHNeketcWm6GvMXgqIz0WcKaHB7RZse3Z3uW00Vl78BcIypOrZXO5vxukW3EKvXfUwF0Vi9US5lzUU0js3bJDZlA2yNaNE4CDKeUNAt8Kmo/ET0A6P6/QsVfnY9hlRCQdpTsucWunN7/1M0gcKEQiubjIHnFUdSl5mK5bhLpuO0PmHYEz8FXDwiKKcXqAyg41rGFksB/wO+AN0u+FlKCb2JRclkDLC3+2TghT1jPSBneAXaa+M1LONH2WQOliMHzqn3du/oVF7dOhAzVhYiFNVWWZ77/2gW5H+f0dwHPuzXxtyaREDXWgffZygX+Qcd2p/EQqz9QU6IS1urwotUBgQ4/alHLbzttZVBGnk5+AvM58O+MJuB93MyU1IkXURtlSXwM2wsV79bVSU3pH3ER53Lc9wOm0xgWekQ59htaaAO0rcU7nfOO0Bg2TVAqShIUUvd0P1FkP8eLHxxMGlnmVKDqwvdRANFQT38LlrT/+xfyUirE0RWqtRaL1DZsqPakXb70nIKIKBnyLgveP+vafJ+fvrOPiUjbVua
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6916009)(8936002)(54906003)(8676002)(316002)(36756003)(186003)(4326008)(508600001)(6506007)(1076003)(2616005)(6486002)(26005)(6512007)(4744005)(5660300002)(7416002)(38100700002)(33656002)(66946007)(66556008)(66476007)(86362001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DIXKOr7w9ZSMZo3oLl5sLw+lEkBd212dVinRgQZ9cjmy+ezDftrR8mttCXCr?=
 =?us-ascii?Q?3LAUmM/cQiht18sA+4KvsxcrRHCRaWiHcyU1tHc+Vhy2MAkHweGWREXkzXVV?=
 =?us-ascii?Q?LFhp2gnf1d/OMFw/rlPL0qC8Na/JZIszj/2i4rGj+2XQKRc19L7qdr471jlb?=
 =?us-ascii?Q?GhNLMgLP8aI/W2FrP1r/tIVMOwL/Tcs7FkfYyE7NNjklN8PX2ZHJSFz4jfvD?=
 =?us-ascii?Q?ovvLTZvQ9eWh066N6hcyyvQCgn1SHA+DTtlJTtCITDEZ4yMBxUyKUl/CyW2M?=
 =?us-ascii?Q?Q7c9zjyY0NUCdY0T4m+Ezwr7ga97lDPPJrPc39emdOWizckq5dooAEFdspuG?=
 =?us-ascii?Q?D+4yUYNRsq65JwkacmLYgknsjzRJX4yBzEoEfmF3ttQ5nFa/S1ZRWN5nX/ri?=
 =?us-ascii?Q?ckh1vQ98qOg4tequHfekG1ahgszeGpewtmk6HDbydKHdGohrOETGxK9BzBKi?=
 =?us-ascii?Q?thvVRSS+TfumUg5tYnolIaye8GwhxesQFngmbZeCIBSAWOA/c7p34C8PFLXX?=
 =?us-ascii?Q?tsUXX2ZOzytOkaR33NCXxmv0Q4AKx1FPgxpXBpZdU/WNEBJgOFkKGVs0K21h?=
 =?us-ascii?Q?8nVntdgRamMOFkp8X8OC4EGzF+k1WQB5zGNE3+7b6ZPRiCVQxabPoO9Pgfxc?=
 =?us-ascii?Q?+mo6Lny1XVXfnKDmDTMMWltHkqYCoAPc9qh1/TgXamHMHmDyEGr8lrSCztr2?=
 =?us-ascii?Q?y8xWYTOwaf3NEDjDvNIiQ9FYtPYBnYlXpf0BErTvgsXj3jRwgjJdn2aOpqYr?=
 =?us-ascii?Q?y8WzcgxMApsfVLB92iSLEygPd46DbMIgPlzR6rUcpD9W7xfG9oOdHwVCR0RY?=
 =?us-ascii?Q?MyQbZcxSXFSiMMWdjbk/5DAvdVx4BQkxzn2g7T3nSF+UheoABFf2ZIdC6jgq?=
 =?us-ascii?Q?435ktiUIR/buCvYgPJhAcxLgFQU+j0/JA8r3XEv0mERdBYWBsUS5PcyWhKY/?=
 =?us-ascii?Q?y/vv69EjcbBGcs6Z+b+zm5x39qq9qDnXJmRlEBgmLHI0uyHyFYDko7BeaGJs?=
 =?us-ascii?Q?VXobgDbkBbeDyePD0aklNQNcZWew7pn21CXTUcjgGDM8vvvlWiABzq8Jo38M?=
 =?us-ascii?Q?9eEG0X/9i15u+Mc0+ZyPnqxSFJMZ2tj70oCcQA5rfS8pzzBvERSH+Plnh8Kz?=
 =?us-ascii?Q?xCZbt7BkAMESlhPbB2yU5vZOUpvbPXThYbIus2A/bIAkF8qie/CC+5pWrdE0?=
 =?us-ascii?Q?IgOYXhEpnx3AAD/0zFI2rk87yNYD8B2Ed3UC0rw/yPXAI3HM91EexKdklNAB?=
 =?us-ascii?Q?V4KYkyZj5edJxcLqGMoMDZ7Wl2izBE5ENRLoqk3CFHD9c63ZDB527E6F+d2H?=
 =?us-ascii?Q?62ZTjWW58+1Lo22d80JZva6VEaIZM6aHJCxu3lh1XhHsSEsJaMm0Bpytl0E/?=
 =?us-ascii?Q?EhmXsJSgQTpNORbdvVYqP+7UInKYfDQN2SGd1vK9OCx3lLGOYEDojtMH0kYb?=
 =?us-ascii?Q?5UOPAr25PXPdvT4FrMyyFKbZkZ8y0upwVkuewTjNkjVZEXImflqCv1jxihaq?=
 =?us-ascii?Q?C3zO7HsrPPuCvO7SiveWdcPa8kIwfsJe7pH5upWVPzCaIhFjIdYZBluVJpeL?=
 =?us-ascii?Q?Ao3ayKEJ+2VN/UBF2w4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 096c36bc-dcf4-4139-b93e-08d9efc00ce7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 13:43:58.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VXUKJ1U5oX6CVceQ19H5RHmurYZQlkI6xAsHD0tOlyHpDQ9AN3+/cIDQ8itehc5J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1357
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 02:39:18PM +0100, Greg Kroah-Hartman wrote:

> > A driver that sets this flag can still decide to enable the dma API on
> > its own. eg tegra drivers do this.
> 
> So you are just forcing the driver to manage this all on their own, so
> how about, "driver_managed_dma", or even shorter "managed_dma"?

Yeah, I like "driver_managed_dma" alot, it captures the entire idea

Thanks,
Jason
