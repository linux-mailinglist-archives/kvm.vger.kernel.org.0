Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6F7247C6
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbjFFPc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 11:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbjFFPcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 11:32:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C9B10DB;
        Tue,  6 Jun 2023 08:32:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjg5iLlWc+ycgalxNLcA2zBaIQyGEy1JDLdQ8Go4goVXd78HnOE3Ct6TBBcVji02+0f+5i4djDbA0jdtCoGOCYxtmJ2zdFdmdwhqOxeU5OadfitEbjo0E2CUXIDApHewfZ/GzM7YpqJkgJv7RuKc3pIqTomXFo+bdoKEOklL/tLobXUIwg8mY7wfocI5jMDmrpfc6y5jJpIAfgpuvveFv4zmfrwNP2fvQyw6r/iOXfep9UzuzmJ4MfH3UtB5nZ8TOr1cB8TC/LPdXSPSMxkaEkYbkQfY3edtxnKLbewheMl8uhZhg/m3MKbPAVwGR3A2i9CpnH6oH0oKhZArV9I+Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F4N5UbCSecdcrUCejXtvdZq8xZ0sb0K8TSX5FALqKQ=;
 b=Eun649e/XRVDZP40gssEEhxNEmGcKlM0qdpjbWKTHL/WjpWjnWOYJYKko64Dr1j2QSvlscLhuPustK102qeYtycR74yJRHK6/FWb3glT6b0l0b8g5HGdiBw9pF7jx1QhDjRVE/JtcSMQx6kFvBpJ5rcqEbhBh7MFE8LOcl5N9gDsNSGd4vajLWQ3sCmUWOEOgWDp+DdGXqMqayEATwHoNNAoH9EDRsx6cBXvZWowQOYxW/QMBta1JvF2E9/X7H23IbV1yypAvyulq3c7x8b0X3MC9diarYmtwWr54BwEPqvvUmorIAN0DMI68p4OvyeAEk6jQviyRSHtJ52nF0PeUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F4N5UbCSecdcrUCejXtvdZq8xZ0sb0K8TSX5FALqKQ=;
 b=VaDqnk3cvdwOyyXn1S3D3A0U40PJYjhmLeFMJuLBrr9y3kBj81hMQtRf7nUmP9RccNoAHoB2lm/VPRHZVfOCAok+FAll/JJCgA5VJ8GBZuwNG3n6HdZYxl4i4xUZGsKLSpj23okxT3cnkbvTVchHFFXWmLA5nrU1Cc1n8bGEKwwc52QsAULlqrmr+XrmFe79/x4siyvyqEgnhVeCWRMv/ycj7X/LGxZhDOj9EkVkFZPK/8MKNj6VL9uIJmdrT3JqePJp1U1344ecNhOlyAbZXkgJ8k6NSb4AMjPUUsvJArU3qYvW8gUkjyD3mj5Z9qC7jEjxchK55Ri3gzDPJENv5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4214.namprd12.prod.outlook.com (2603:10b6:610:aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 15:32:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 15:32:16 +0000
Date:   Tue, 6 Jun 2023 12:32:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZH9RfXhbuED2IUgJ@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
 <20230606083238.48ea50e9.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606083238.48ea50e9.alex.williamson@redhat.com>
X-ClientProxiedBy: BY3PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4214:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b3c0a9e-6352-474f-1e52-08db66a33552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGQhO8bZNyPGwfJtei3zL3fhw2O0Af954/TI5tXJvX6dkAybr7IEITq71AqqTZ2BstY0+nVXus6U8vME8h/7H0xyhaEQhuPCcqofMw6BOT+Gh3gf2ynAWnLm2VuK4VYvoGgxYDVulwo4sCghlOr0fyjQ1acA8AcOJDZugQUfOKDarrwcEV+Bz7Hf7IEr8ap2TerzB0hQIEfsZ04Zxc4Iv9y3uSDFsEhkthWJOYWsAG4d+iu/4O2jfsj0JIiQfcF6an5l74INsdq+4Q0hnNGK0aQ5wkqzxNsDk6gqmDeQTOJzvY7ArWN22+WfWggY56JWv3kZk4uTtLJeqJxo8+6FOKYcHLYqllfI5DvJ4zYl4EqSoTO75buM3xV0/6uhP1DO9MdXr2MqSZC5GVU9TrXci4GGB6LX1fQgOZlj4ajUul8BHJaN2rXth8LM1+v326Nr0HmcNu/0iWBLQwTJmvWP1YIwFZU1L/tnoc3eUjyOiIL+vS5NqD+U0EJDLLM+BvB/VwICFGFRicHwrxAwM5bZvkAQlCt8zxSIVR70Uj5o02NQhyRjBsJUMaJ/2VvZ6oVG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199021)(478600001)(2906002)(6486002)(36756003)(6666004)(83380400001)(2616005)(86362001)(6506007)(26005)(186003)(38100700002)(6512007)(5660300002)(316002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(6916009)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cHh8baFXYFB0OyqbGHR9J/qPLGQD5AYbUENXFNx9AsywasMF4aXOV768qY8V?=
 =?us-ascii?Q?TpD6fvu4WKcvx4ZZPn0LQYXp1p2rQPW9PL3VEN5QXCpnZ9pVwutzhyxqRYfL?=
 =?us-ascii?Q?PbMMTRsuKmhyMi9pKyHDezgWL/JeGqwZGIsNzb7TloMko2ckbvQCvzizHQzG?=
 =?us-ascii?Q?XuIc8FUcTyewtwYyRMkazXpwde4BPhobaGxW7uv5ppHNWvAniu8B/db8m5Ps?=
 =?us-ascii?Q?QmEsdSP0ZS8JyYknKTimh85qAUwjRev7xEC8XCnH3c7sl6XEdEvWATLGFdsM?=
 =?us-ascii?Q?6fJihr6J3eapbLFv3IDjqzXIEDrb7RTMmzSeEoQCF3B3TpuhBNrBUhYf2Li2?=
 =?us-ascii?Q?o6e0f3LrfHdvSj6JloAYRukuEuXkH1ZXt2vwLtXd6PBZRGo2Vp9yCTB3862+?=
 =?us-ascii?Q?hhlWDgTHL8qqmvPZjeNHSy0Qbwl98s2bvOMISSrSg4tFbTYLfvz0UTgGbfnT?=
 =?us-ascii?Q?4/3jaBgC5EA9z4Be0uiL3hMwI1Kg+na9e2I4Onk04ycSt86BLmy8geIDoVgN?=
 =?us-ascii?Q?m9zTOr2Um+DXX+j18N1FpOvImmOz6CjnwI+BAA9jYAStmmdQH4QLNiyNJrE0?=
 =?us-ascii?Q?OSF8BgsuMxUsb+ZLNEt65XLiHPfZu5WCEjDRPdDIIDgFuAbaV0T8ajiNFrSq?=
 =?us-ascii?Q?F636HFLcRfb+Xwpqr2Fc8QMut7Mw2s4uP47IvTCXFdpVVfaXVYC23/VK43Zd?=
 =?us-ascii?Q?rsLIWhcyeFOQs3tHIu/xhW30eo+gWvumF7QSIyECPOwDfzG9kglISo2a38Tu?=
 =?us-ascii?Q?+pGGXDr8c3OYxZMDbduezy0yF2G0YutweC5rONlgOhVf7cDGNxlq7dFUf9Z7?=
 =?us-ascii?Q?eQVUDp3WthRfAiKTqZv/jOiIe0HDYdA7RuaYhk2rRu+PNm0VWA8qfhsHruew?=
 =?us-ascii?Q?KdYaWRWPfoyTxY4WoJ7QztQPXwaSNGhCR3xISXbcwwYvnq2aHOPdi92FOfJd?=
 =?us-ascii?Q?eNDVR2Q5waaV89DlkF8ehWaHgMGT3Ol4eyCu0s4mHXWLmZj0KFpDKOV2mn0/?=
 =?us-ascii?Q?PaD1sEMlIoqGnyZSRMh7U+mAvNdI3KS/l9BZu5bNISRZykgTQ4nYtVU764sG?=
 =?us-ascii?Q?RiFx1cLYzvbue4iX+xjefKd+iVbpg7UpJe3/tsCxWtf4bijMNRnDpbhigrVL?=
 =?us-ascii?Q?5WBRMRti2gJMSZefVsvea4sftBlDFKIHuOkvc2QDCviiCDn29KxtSJxAmqBo?=
 =?us-ascii?Q?tVM5gJAZBofQea/F7yPqJkJoyyLrzNdUzf3ml9lxe6Jh2RlCExZq+3+iaBX7?=
 =?us-ascii?Q?XzlM/Tnz6k14NZmZTyvUhxCRJSV64aI0KF7LZZlY+87PZVF+eRnIW00HXuLc?=
 =?us-ascii?Q?OCnezft60x49YXpOyexOlpjd/aj162Wuc6oN47qEUp9lU7MGmVz0fca76xxT?=
 =?us-ascii?Q?ePMCtOv7zgGqRMVu6OJiqmyg7ca3fhZzP5HMW+u2g9klSKlQPQ0L4AgmUfGE?=
 =?us-ascii?Q?jn1CjUw7Jgdv8JSRM/td1ch+557iFvZ6qzbDwYmHlGe7gVdgGc9zBnlQ6UfL?=
 =?us-ascii?Q?ZguzQXUaCsA3zfvGgTkBAqbqNc4so1T7SS1tH7Sk4fiwzujeUWlXeysq7RR0?=
 =?us-ascii?Q?mxwlY6aroEnSlSYRsztpIhnC8mPQZIM/j7vWdfVT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3c0a9e-6352-474f-1e52-08db66a33552
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:32:16.5140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6kSqj4tlGWbzThwzgNTy06PiPTjJbPzW9JQHJFNymF7f0xmSbiYB/khlCrdAooIM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 08:32:38AM -0600, Alex Williamson wrote:
> On Mon, 5 Jun 2023 19:53:20 -0700
> <ankita@nvidia.com> wrote:
> 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > for the on-chip GPU that is the logical OS representation of the
> > internal proprietary cache coherent interconnect.
> > 
> > This representation has a number of limitations compared to a real PCI
> > device, in particular, it does not model the coherent GPU memory
> > aperture as a PCI config space BAR, and PCI doesn't know anything
> > about cacheable memory types.
> > 
> > Provide a VFIO PCI variant driver that adapts the unique PCI
> > representation into a more standard PCI representation facing
> > userspace. The GPU memory aperture is obtained from ACPI using
> > device_property_read_u64(), according to the FW specification,
> > and exported to userspace as a separate VFIO_REGION. Since the device
> > implements only one 64-bit BAR (BAR0), the GPU memory aperture is mapped
> > to the next available PCI BAR (BAR2). Qemu will then naturally generate a
> > PCI device in the VM with two 64-bit BARs (where the cacheable aperture
> > reported in BAR2).
> > 
> > Since this memory region is actually cache coherent with the CPU, the
> > VFIO variant driver will mmap it into VMA using a cacheable mapping. The
> > mapping is done using remap_pfn_range().
> > 
> > PCI BAR are aligned to the power-of-2, but the actual memory on the
> > device may not. The physical address from the last device PFN up to the
> > next power-of-2 aligned PA thus is mapped to a dummy PFN through
> > vm_operations fault.
> 
> As noted in the QEMU series, this all suggests to me that we should
> simply expose a device specific region for this coherent memory which
> QEMU can then choose to expose to the VM as a BAR, or not.  

It doesn't expose as a BAR on bare metal due to a HW limitation. When
we look toward VFIO CXL devices I would expect them to have proper
BARs and not this ACPI hack.

So the approach is to compartmentalize the hack to the bare metal
kernel driver and let the ABI and qemu parts be closer to what CXL
will eventually need.

> It's clearly not a BAR on bare metal, so if we need to go to all the
> trouble to create ACPI tables to further define the coherent memory
> space,

The ACPI tables shouldn't relate to the "BAR", they are needed to
overcome the NUMA problems in the kernel in the same way real device
FW does.

> what's the benefit of pretending that it's a PCI BAR?  ie. Why should a
> VM view this as a BAR rather than follow the same semantics as bare
> metal?

Primarily it is a heck of a lot simpler in qemu and better aligned
with where things are going.

> We can then have a discussion whether this even needs to be a variant
> driver versus a vfio-pci quirk if this device specific region is the
> only feature provided (ie. is migration in the future for this
> driver?).  

There is alot more here, go back to the original v1 posting to see it
all. This is way too much to be just a quirk.

Jason
