Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3656DF638
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbjDLMzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbjDLMyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 08:54:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E202F8A71;
        Wed, 12 Apr 2023 05:54:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nSlNecoXI/WowgG4YBq71dNHKMUxQM7XLFfvv19Yk9kU8GYgdiSbyIP8oxbn/77FR/xAEwb2qjMwRbIdBn/wiQxlH++ytuDQ1b3VNCnCPvpct7349HRlXsJlpR2Iq6GY3PIXZzE40/hPWnlf6GoFPDMH0zb5VuAKwS7DjBu4i1pORwGGgVgAblgnYhNVmtVu4HTTciDAFqYmAXeRVEGsIR1h4zyAmqzF8KPGYglk2pNs6u4uZJbT/LUSyHdoeCqh27JXdpXCT6N7CkIO0QtDSVttdGLx4+CjRVnOm9NYxj1iNxG+4LE1y+Sg6LhH877QKWWrfx5/17MLWa3gbytUeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IA9dzXY8yZVGKLz7a2fFdNnUWvvoc4CIN7pStBU26Vg=;
 b=I8S8VkV16Um+bHS2El6IjtHnx+Uu5SLa3nzjji6BIGtr4X4YVHGWJ3eZr7pnyOvxlGM/BU6vhH9NoReolleg65aeuZxIfbNpGTceuRlBU63AoGjh5WAtse2I/JHfdyXYi0AUgHX2Gc88g8MKzEG3uPuYGHkUoHzdV7ccDfl6RNC+iesTTdke6QuzMDWfiY7FGrMSnoZaWaKZXZUXaJW4QGQJ349/TxVKyGL/gcwruSo8DWcLJrjQXZS5hnBw7aMuNtzbn6/04f344M3MQ+44oHH2Vd2jonE9wK3j8gEciK/9lUKpK5wxxTpLGZVdc3JYOCUh5Oh5JCmvzrhHfZNunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IA9dzXY8yZVGKLz7a2fFdNnUWvvoc4CIN7pStBU26Vg=;
 b=iB6VHwYsSscXq7BmKXkdEAjTMqX7utlIUedAmAgtkwNSad4pNs33vfXrBKI5vz1eQ81Ba7JwarQGEn2+7C61cd9lM0sFKyJDYoV34JfXdAZSM7S3Q62nMOLuWGuqULPIcTkJMTMrvhcELkiu/YZRxj0GV3tAIdogDFFqAkyjHaiBo+/69/qWQa1XFVOM/TshXk5WLwmOKXZaXAS89/ha0Yty3G7wOY3kfdgFI0EPupQJsmWqDDQVl3ar6VBOOQAx9/rRD0iR/wLXxiqqGHfhaUpyOyfyl9ridgn4QTglJFF6o7VADNOMLbu38zklExc3TpTZSOdTA+yae3ggIovtNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6358.namprd12.prod.outlook.com (2603:10b6:8:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:53:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 12:53:10 +0000
Date:   Wed, 12 Apr 2023 09:53:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     ankita@nvidia.com, alex.williamson@redhat.com,
        naoya.horiguchi@nec.com, oliver.upton@linux.dev,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] Expose GPU memory as coherently CPU accessible
Message-ID: <ZDapsz2QOdjhcBHJ@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
 <86sfd5l1yf.wl-maz@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sfd5l1yf.wl-maz@kernel.org>
X-ClientProxiedBy: BYAPR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:a03:114::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1b5f76-a9fa-424e-3c8d-08db3b54de2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubXN1MGGnNYHiNUdQ3wEzt+ks1u6QG/l70Ibc/4vw3bPOB0M4LkdGjRKIS/ckRfeAXcKNAlQonz4hWtZd+0T3qlJjKxWrbfD93FjWhIEOxYRQ9qQnDqukHF2ZNntF/XxG1vEern7exZtEA03oqsCGXy+2TojDS5siJFymAf10/nGMjq94aXSS9DQ40GE9LCfgYP+jW+OGLpeDZLO1um6t0E6InTT5V2FtL/hzkXCZzF8FK1xBeSGABQ/wy0FAZqx/kAOuvuvRyhh5RD8GnAVdAX1sh1TpCz5uhXZmBKW5P0rBJdFeRqlRLo+PkvkvffK4schFsBLyWZe0iRxg6GR38NsYkXN8v8Cor52XLGblzxXLrCijO7Jd3WOyl0RhwQS/7BsIhDA35AnDvXpFxgoXLKbwxoNLCLn8lyyNW+O3ckLL3cNq5AiiFZOJgmgRAP9ttZ+XsSBjKbwQgCpJtOeyIc37aTzKspo+3rXdHV7qdsfbjQ57fe7RqRu3VPehb0EjRpMOGoRBw8Cxv+Y5KFl+oPZKt8IW+8aC4eAKscYaUvGExkpzfXmiw4Y2NqZuCCu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(39860400002)(366004)(346002)(376002)(451199021)(478600001)(6486002)(86362001)(2616005)(8936002)(5660300002)(83380400001)(66556008)(6916009)(8676002)(66476007)(4326008)(66946007)(2906002)(36756003)(26005)(186003)(6506007)(38100700002)(316002)(6512007)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tVFBLgiG+lvmFapjqAz+uB9XiEw4pzrcJg6+V9V/rcAJ7glTzkwpotMMMXUi?=
 =?us-ascii?Q?Lp4BpM3r2Qqo+/yTc8jjndUY1THgJLf9gBRd854UZOZ187W6iNLSCzcICeS9?=
 =?us-ascii?Q?7VUV5Ii9UwqYHB1Dkkny9J4UlINNCdanLX5Y8KnxnSg09bGYI0LUWCrFBiyr?=
 =?us-ascii?Q?uofNAdN1eWldYCj9JFog6T/8aU8M3O4Bn7L6Ux5MMoH2GGFM6DI/ru6QLh07?=
 =?us-ascii?Q?BvR4oAv7BgCjvF1DYH7U8bgNjcCoqAsCYm513fyh8RmjiOk2mv+VkE1H36JR?=
 =?us-ascii?Q?hBldtc0/8FcanG0baKSZxOVQ55ueHvs75my2W4uskyEPxq2+s6Sem495RSol?=
 =?us-ascii?Q?ozRRZ+vgnnipu3HMBOkQOAxpl9x24Y0rQkNBVeedmOsiIAj4eORUBrKySA4n?=
 =?us-ascii?Q?a5VZODCbz6eKLu4gCwd+YxDsxjsEFF4MoZFOqLt888qAQoUQYlLbkyWi3o1A?=
 =?us-ascii?Q?JDhEKr1hHAgbUkn4iRtNIwkjqQ1+dbVxfGN24mo0OY1CdI1v9YpiY985yjTR?=
 =?us-ascii?Q?soj57QU7B4i3YIpglTjbFxXez/CylDYlmbpC0CFx8WaxonEJ4oHb6DddZYOY?=
 =?us-ascii?Q?ugrFy5zCuo9ZXscbW7FlkvqFiX2ff+RuHmP045/QpbhYlUZAM9bUHP3E+7Iy?=
 =?us-ascii?Q?RgUCvXFiKieaKLOsqLqXNoGoWizPcGydWQOk//WFVRpxflA1bNvUki9CupJ0?=
 =?us-ascii?Q?5M0SGXBDB4AgdyUQjkxiIDSGdHxDadKh0YrgIIHfqfNbTUMLcIxa2Bu2p9yG?=
 =?us-ascii?Q?Z/Zhx5qD0oQZ4H11m3RgZffrJz2y8Q/FV1Y62SwLmv4NRGuuZ1CcqXfQUgy7?=
 =?us-ascii?Q?An5OKSnO0U2Kz1WsTO6J0JPS6GfrD7XssCYvx035uY9rAtWq9TzrJnVF2mef?=
 =?us-ascii?Q?sQ1e5XDFRFEhldM/O7DrW5XXuxh22/UNIOAjLz4zjhTeHQUog0uMr6DQiDiD?=
 =?us-ascii?Q?b93Ad/AfLDpC4jiKKRisf1Hp7Nd8SoEKojaRr7aBy8uvBBdGAXaNfShaxhqX?=
 =?us-ascii?Q?nHW0MsNq45zszH3g9bMzzeHF5KE1Grrar+xMgiJYFCAUzDU4QHJZ+3NOPm28?=
 =?us-ascii?Q?tVZSL8D5B9Ma54MFI3gV/XZdf844amgccm5e7zUoShqxcUXJY/en9DYdE8JH?=
 =?us-ascii?Q?vXMMPtxEhSKZka6gyBQG9m1z+3XNSQmuMd6wWhRgb+K5Ios7eCl56xA9O/RH?=
 =?us-ascii?Q?3MKPEsXOcix8i2HmuxoVK5qVnmHbLYRk29MXw5sN9gdW3bUQMBsD71n0/r1b?=
 =?us-ascii?Q?h9TdVNBU5WC+yapnm94ezyU3LEjWFn1ZxTGB3R8iUeUXKEm5K+VHFHSK4A1Y?=
 =?us-ascii?Q?5Dm/IdeJKoH6ka2AU3dLSsEPtczVoqtLQNIliW7p7OrNZDlB94NGwAtbUFOq?=
 =?us-ascii?Q?CR9QUwvKtn2J5Q6dtN1tz9hYaTTSlzu11XIueinN5xbmjUPvFngEffcliIUj?=
 =?us-ascii?Q?OT3dGBTipX4ctDBgDRGPeWt3QaQduWgdGDDC3Iv2noVQo7kdxRDzzyYDkZV4?=
 =?us-ascii?Q?n+L8NvUXqMvrLKvGy39Zoi9QvgPejgxV5brobIgMMf3KeQKg7Rh6M0Nk/sta?=
 =?us-ascii?Q?BfWPyDYUO3ZkKy24dw/mkNrdJdJQgKK/+Zurq7CS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1b5f76-a9fa-424e-3c8d-08db3b54de2c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:53:10.0266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alhKhjJu/CHy0D3IzFiaKYhAyd9JYjtRfFzWN6irXkKMlmpPcBVTaOoS3c1DG92a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 01:28:08PM +0100, Marc Zyngier wrote:
> On Wed, 05 Apr 2023 19:01:28 +0100,
> <ankita@nvidia.com> wrote:
> > 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > NVIDIA's upcoming Grace Hopper Superchip provides a PCI-like device
> > for the on-chip GPU that is the logical OS representation of the
> > internal propritary cache coherent interconnect.
> > 
> > This representation has a number of limitations compared to a real PCI
> > device, in particular, it does not model the coherent GPU memory
> > aperture as a PCI config space BAR, and PCI doesn't know anything
> > about cacheable memory types.
> > 
> > Provide a VFIO PCI variant driver that adapts the unique PCI
> > representation into a more standard PCI representation facing
> > userspace. The GPU memory aperture is obtained from ACPI, according to
> > the FW specification, and exported to userspace as the VFIO_REGION
> > that covers the first PCI BAR. qemu will naturally generate a PCI
> > device in the VM where the cacheable aperture is reported in BAR1.
> > 
> > Since this memory region is actually cache coherent with the CPU, the
> > VFIO variant driver will mmap it into VMA using a cacheable mapping.
> > 
> > As this is the first time an ARM environment has placed cacheable
> > non-struct page backed memory (eg from remap_pfn_range) into a KVM
> > page table, fix a bug in ARM KVM where it does not copy the cacheable
> > memory attributes from non-struct page backed PTEs to ensure the guest
> > also gets a cacheable mapping.
> 
> This is not a bug, but a conscious design decision. As you pointed out
> above, nothing needed this until now, and a device mapping is the only
> safe thing to do as we know exactly *nothing* about the memory that
> gets mapped.

IMHO, from the mm perspective, the bug is using pfn_is_map_memory() to
determine the cachability or device memory status of a PFN in a
VMA. That is not what that API is for.

The cachability should be determined by the pgprot bits in the VMA.

VM_IO is the flag that says the VMA maps memory with side-effects.

I understand in ARM KVM it is not allowed for the VM and host to have
different cachability, so mis-detecting host cachable memory and
making it forced non-cachable in the VM is not a safe thing to do?

Jason
