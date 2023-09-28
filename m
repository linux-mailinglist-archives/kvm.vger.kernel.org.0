Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3150F7B1312
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 08:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjI1Gdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 02:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbjI1Gdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 02:33:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A501BF;
        Wed, 27 Sep 2023 23:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695882802; x=1727418802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pRuUUTEuhJxmj2p8xLxzZKOBnfJZlEKwjzdymxffezM=;
  b=NXyo/c+8UPnfeazOsaFbjPpZPozeWmBekgzKICKQRlrkoMwqlL5MKv83
   OTbwwc1PdKRDn8vUlIgrrzFclROGuJQRAvrJFUnKGnXykzn3PMDV27GKV
   SFshl6x87nCZVgprnrMd8OK91ytanp1M+hJwFLNNb+QGDSlPWVr2Wxma8
   MsazyfVtpj3UZmwPpec3AlawG1WA8K7VEd7AZAud+WqDLQqTSo64Zl5cC
   RKo0dnWxVnGxxfl27hnH0/v8M77JWcYoU0/89W7YH19zOfODMzpyxPk/Y
   8LpP3vYk99y3pxnZZFMvSzYn2gCciikv/uX9D6JiP8AaEYVksEkOeponV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="379270436"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="379270436"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2023 23:33:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="752854316"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="752854316"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Sep 2023 23:33:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 23:33:20 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 27 Sep 2023 23:33:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 27 Sep 2023 23:33:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 27 Sep 2023 23:33:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpvw2lJP+5ono1GHWiXSDLmVhidTTblqMdI6MSdrZVRLNNz/eU5XHQ8klpO9v6yhZoPggs2puUCmzjDRHNCcn5Fw1vKltIhHH8SGLfVg9CsLLYy1I0fdxnEFLHKPYktLnQAUE83ppeotlYT4+RUxgnyUqAl6DlFDR5JzotsAY0iPbXwLJh/ysHAwHOz25ikLexojlFfViPbEf1rZ8zs5z7Y2Y98oRVTyHdz5f5yxlgYnnmgsqd2hhIcO8HbTyel02BCndfPp4335dYNVBWPKk9B3R1UpxxahlDwRgmGtRk7zXqXbCAOSkEgV282iCsdQCfygnE/WwAESNY4D9NYaVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o3GgndGPtE8hV/jYbsx7SMa1M9MaobIxfnx9DtavlGA=;
 b=CwMhyxL2Yrhex4WpKHvR1A9X027W9pozdWE4ZpMuOkb63QfT8MXzJrpwHIADrDtdMjdVrHQ+/FSAg4t/WF25BtSECHMYdO77NzJfidLYmXyqP0x3jmaeHLIZg5eivdxRNdoliz5PNa3aVaBQ4Z4rI342f/WdsWxZkR1XSnWnOufGDfWTgFBXf0WAQrurVDtYKke0La/l4qp7/Qc9DtAoq01vVTrMld2kSn455rtl8lBm4Ij7UPOlPll99pohlKUtBe+Oh3QIv7SNGVugm9Lo/fxu2hG+91cgAOJOOv0EChoW+lZXL5KCBD+r+z2QtJLZ1DFtVmo6gwoZj59JmK+UaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6182.namprd11.prod.outlook.com (2603:10b6:208:3c6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.24; Thu, 28 Sep
 2023 06:33:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1bfc:7af0:dc68:839d%4]) with mapi id 15.20.6813.017; Thu, 28 Sep 2023
 06:33:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
CC:     "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v10 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ53/9zWvTaIde6US2fOptfhuD4LAv1HCA
Date:   Thu, 28 Sep 2023 06:33:09 +0000
Message-ID: <BN9PR11MB52761E49534852AE98C25B458CC1A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230915025415.6762-1-ankita@nvidia.com>
In-Reply-To: <20230915025415.6762-1-ankita@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6182:EE_
x-ms-office365-filtering-correlation-id: d965f157-2a93-4cc2-1e3f-08dbbfecc865
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WAWL0unuua3t5r8ZBkYnVZh6Ra+RZcmmt/Nw5DBvd+1r5o6uaUlah60aMv7+Pyarp+2d3GpDWiRYDNyD2Zae4eBzqS6RYN9JvB9E53IgWsRbjGSZWT2O1ydGQkjF3RKUfFOZLysP7z/NoH69VC6jQjrLFxTS/KQcZf1UasjwHtzqqxqk0bZE+jkZppjGJbsRDV+Xu+xQifbCnq5HRxtgpiz8ZKUEYjM0oebfMuxIVBxuVxjL5zy0H3m2q8/f6ZX/UmBqPw3w3bsw2voRuRXVtRYHy69Be1YJMqHN12qpPVHX1EwoMV5A9lcakd7v4qDStL6SOSq4JuXCkhrpExLcVQ52l0cK0K4UD5U3qJrdE1Gt0BfIMHFLfDB6UOIFVF73vmemdmf8mleCtz5zfoPKzy/eV90R78vT4r2IDs7DaGTVOeqTiZ4/6rO0EnBZp3dT8w9y3W0HuciV6GUdvDshApfkZlBSZ8S1187NKOn+CZuG2V6H8V3eJVaaqPC73mZvEOWas//LgGU5Xl/Tjk7/cTxEMepk6aHi+i1nsUznWLz99ArjAZbnzK2VsQ7T+e4khaRvYp3NyRKzumqEowcgY9PPk3CCOJETYDFp659YDeqOi6mQCmJPjYE8wryr2O+V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(366004)(136003)(396003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(9686003)(7696005)(6506007)(71200400001)(83380400001)(82960400001)(122000001)(86362001)(33656002)(38100700002)(38070700005)(55016003)(26005)(52536014)(2906002)(5660300002)(316002)(41300700001)(7416002)(66476007)(66556008)(66446008)(66946007)(54906003)(64756008)(76116006)(110136005)(8936002)(478600001)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uLtwpuXUlTGjdYJQhNe+bPDeujpUe33tnJF4Xs7IgJiTnCeEGnBVPPwIzOc9?=
 =?us-ascii?Q?H9FhAWTGkORzvzUoEUBjvjGDkCecS927EMDgPMfn0R50uYr4SW5UVHdVmBeD?=
 =?us-ascii?Q?BVlCbW2Qvbr3DkWPT8/WlxOz2nrGdyCIpJ3eVMWw4ug/RoHYRQfc2o99Ok9O?=
 =?us-ascii?Q?SgxCmF3mjzCe5r7koV2GKjX1rc5J2+B2qkYXxy6synU460HTTtFEhJfWvBxQ?=
 =?us-ascii?Q?S0oJe32UheeRZv3M/xe5buD2SBEL3R9Jf5mw+mtVJuZXbiZ1VVDd8IdxUm1S?=
 =?us-ascii?Q?oaj/uk29rdANDHuwcETTXf2xONTsvLpFFt1RMvMfvJulDGUfVS3irbnm5pSa?=
 =?us-ascii?Q?HpMlDFCsxEX1EcdOx20mwkhiZ6KAXfUz3Ak7oHQ3ATPJzggU6RFLLqFM8ICn?=
 =?us-ascii?Q?eGwWvA5XDhYBZfOGHI1UEFj4xNm8gdqCxSXXJ6QE/nS4dEcU3Ql8944IhOlC?=
 =?us-ascii?Q?uCKTEGNXONKeG6at9E9VNQTna1AL52mrgtudLxgh/SgHcwUWgsUyjVma61Wd?=
 =?us-ascii?Q?dSX49nM70K9p+V99w9zaAe02Ljy7q5Roh7E1mu3UoE44T6ii76rSWUVLyexM?=
 =?us-ascii?Q?DUGGoALGopM3knaiIxe9hUkSLREvvzTdDJsBUtiW0xDf0wr2hH4PnttorIgQ?=
 =?us-ascii?Q?8PCcBVZfkd9+fsV2kV63MFFZ17l+UqEBcDQjwUl00L9loWjeoj/6+ZQA9OdD?=
 =?us-ascii?Q?EGdvUmy7WwzYKqb+jwQHaobxDi0M6+kZWnBR4vstc/tdBaWs64H7egrM7pC3?=
 =?us-ascii?Q?IpP2tdyaeXoOv5Yvt5ePQSaaf47Z5TqN59f2m7sCxM2RgMY7w4okxpoKgQof?=
 =?us-ascii?Q?5ZapiZhaMAbKr+ThuuBee/YHIt+VUfbMwvRW3c3MBQw2hKJkhsWGl71r8Yus?=
 =?us-ascii?Q?IwGYWNIforIV91HfocBRZgbElOJfjat/v/KRnvPjuh8MrNkoMXzPCdoAeI1m?=
 =?us-ascii?Q?hVMMJX61JXfNDWnReVjT31i/QBOvc8MukDBCBkGIuVTrb69G/avVAwwXdM9f?=
 =?us-ascii?Q?aSfMsh0fmGUapOeNqb/gaVTeGnUNSW0IcG5shFjJ6qOWrc5OVnP758KZAP+4?=
 =?us-ascii?Q?txr+F1TcNJ9vr8GmLMvIbXeM1kOQ/oiaeok4+iL5vtJldwe7CSS+LnZUgXaz?=
 =?us-ascii?Q?V6dUkBupgmUkLmiYWN7O1jnp21F1Pt6lhsaywPG0TmUDDRW8N7Bx1YfgxQVE?=
 =?us-ascii?Q?s7SEq2qHCBPrBRxA52R8epqRvAqLBfdXvJ5P0VPrQs0/Sp8x+ycO2tkfwjvv?=
 =?us-ascii?Q?m9cwzo+FRmgfw8VbZZrAOVplxaHZnNQERzbDZiG92KFopF0VnzhM9oewI84c?=
 =?us-ascii?Q?HnpQZBejquRbiI25HSDzUAG3CjQ9zX9xJ0lrHO5lbGLPojnnaZCRi4AdzhD8?=
 =?us-ascii?Q?71ejmQ8z9adhrJCqdyMYPEK9arofkQOIFPnVAdmz8b7poSXMtVG6PDdOfMhp?=
 =?us-ascii?Q?EFt3hu9cAmgT7qWDJlArk4WhCOJSLVc2W1WgDMm9l7uh9Yym/3vfkVoUkA3q?=
 =?us-ascii?Q?k0X4REK8T0XMIegr4ODYj2Bawu/GIzQvNwrwovXcdivqVI6BGjcSCLjvON4x?=
 =?us-ascii?Q?v/nAoPp3hyE5ik2m1qg/LzvEz4DGkQBqQ21tTGUs?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d965f157-2a93-4cc2-1e3f-08dbbfecc865
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2023 06:33:09.7904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3B5K3b6ln6k3vxZasKlq9/48CHY7Ugay3VRseuChlQrDlNVcFZ60xqr/N0zBCJ6eyCi2XjuhV2PZdykL/uaD1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6182
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: ankita@nvidia.com <ankita@nvidia.com>
> Sent: Friday, September 15, 2023 10:54 AM
>=20
> PCI BAR are aligned to the power-of-2, but the actual memory on the
> device may not. A read or write access to the physical address from the
> last device PFN up to the next power-of-2 aligned physical address
> results in reading ~0 and dropped writes.

Though the variant driver emulates the access to the offset beyond
the available memory size, how does the userspace driver or the guest
learn to know the actual size and avoid using the invalid hole to hold
valid data?

> +config NVGRACE_GPU_VFIO_PCI
> +	tristate "VFIO support for the GPU in the NVIDIA Grace Hopper
> Superchip"
> +	depends on ARM64 || (COMPILE_TEST && 64BIT)
> +	select VFIO_PCI_CORE
> +	help
> +	  VFIO support for the GPU in the NVIDIA Grace Hopper Superchip is
> +	  required to assign the GPU device to a VM using KVM/qemu/etc.

VFIO driver is not only for VM.

> +
> +static int nvgrace_gpu_vfio_pci_mmap(struct vfio_device *core_vdev,
> +				      struct vm_area_struct *vma)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> core_device.vdev);
> +
> +	unsigned long start_pfn;
> +	unsigned int index;
> +	u64 req_len, pgoff, end;
> +	int ret =3D 0;
> +
> +	index =3D vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	if (index !=3D VFIO_PCI_BAR2_REGION_INDEX)
> +		return vfio_pci_core_mmap(core_vdev, vma);
> +
> +	/*
> +	 * Request to mmap the BAR. Map to the CPU accessible memory on
> the
> +	 * GPU using the memory information gathered from the system ACPI
> +	 * tables.
> +	 */
> +	pgoff =3D vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> +		check_add_overflow(PHYS_PFN(nvdev->memphys), pgoff,
> &start_pfn) ||
> +		check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
> +		return -EOVERFLOW;
> +
> +	/*
> +	 * Check that the mapping request does not go beyond available
> device
> +	 * memory size
> +	 */
> +	if (end > nvdev->memlength)
> +		return -EINVAL;
> +
> +	/*
> +	 * Perform a PFN map to the memory and back the device BAR by the
> +	 * GPU memory.
> +	 *
> +	 * The available GPU memory size may not be power-of-2 aligned.
> Given
> +	 * that the memory is exposed as a BAR, the mapping request is of
> the
> +	 * power-of-2 aligned size. Map only up to the size of the GPU

why is the mapping request in power-of-2? The caller should follow the
sparse mapping to raise the request. Otherwise the check on 'end' right
above will always fail.

> +
> +/*
> + * Read count bytes from the device memory at an offset. The actual devi=
ce
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space dri=
ver.
> + *
> + * Read request beyond the actual device size is filled with ~0, while
> + * those beyond the actual reported size is skipped.
> + *
> + * A read from a negative or a reported+ offset, a negative count are

it's hard to understand 'reported+'. Please update it with a descriptive
word.

> + * considered error conditions and returned with an -EINVAL.
> + */
> +ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppo=
s,
> +			      struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t mem_count, i, bar_size =3D roundup_pow_of_two(nvdev-
> >memlength);
> +	u8 val =3D 0xFF;
> +
> +	if (offset >=3D bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count =3D min(count, bar_size - (size_t)offset);
> +
> +	/*
> +	 * Determine how many bytes to be actually read from the device
> memory.
> +	 * Do not read from the offset beyond available size.
> +	 */
> +	if (offset >=3D nvdev->memlength)
> +		return 0;

This violates the comment:

* Read request beyond the actual device size is filled with ~0, while
* those beyond the actual reported size is skipped.

> +
> +	mem_count =3D min(count, nvdev->memlength - (size_t)offset);
> +
> +	/*
> +	 * Handle read on the BAR2 region. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	if (copy_to_user(buf, (u8 *)nvdev->memmap + offset, mem_count))
> +		return -EFAULT;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped,
> which may
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Fill

Why is a read to BAR2 region implies an out-of-scope access?=20

> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,
> +					  char __user *buf, size_t count, loff_t
> *ppos)
> +{
> +	unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device,
> core_device.vdev);
> +
> +	if (index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) {
> +		mutex_lock(&nvdev->memmap_lock);
> +		if (!nvdev->memmap) {
> +			nvdev->memmap =3D memremap(nvdev->memphys,
> nvdev->memlength, MEMREMAP_WB);
> +			if (!nvdev->memmap) {
> +				mutex_unlock(&nvdev->memmap_lock);
> +				return -ENOMEM;
> +			}
> +		}
> +		mutex_unlock(&nvdev->memmap_lock);

move above to a helper and share with the write fn.

> +ssize_t nvgrace_gpu_write_mem(size_t count, loff_t *ppos, const void
> __user *buf,
> +			       struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;
> +	size_t mem_count, bar_size =3D roundup_pow_of_two(nvdev-
> >memlength);
> +
> +	if (offset >=3D bar_size)
> +		return -EINVAL;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	count =3D min(count, bar_size - (size_t)offset);

s/read/write/

> +
> +	/*
> +	 * Determine how many bytes to be actually written to the device
> memory.
> +	 * Do not write to the offset beyond available size.
> +	 */
> +	if (offset >=3D nvdev->memlength)
> +		return 0;

still need return count as no-write is still a success emulation of write.

ditto for the read fn.

> +
> +	mem_count =3D min(count, nvdev->memlength - (size_t)offset);
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped,
> which may
> +	 * not be power-of-2 aligned. A write to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Drop
> +	 * those write requests.
> +	 */
> +	if (copy_from_user((u8 *)nvdev->memmap + offset, buf,
> mem_count))
> +		return -EFAULT;
> +
> +	return count;

*ppos is not adjusted. ditto for the read fn.

> +
> +static ssize_t coherent_mem_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct vfio_pci_core_device *core_device =3D dev_get_drvdata(dev);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev
> +		=3D container_of(core_device, struct
> nvgrace_gpu_vfio_pci_core_device,
> +			       core_device);
> +
> +	return sprintf(buf, "%u\n", nvdev->memlength ? 1 : 0);

if nvdev->memlength is 0 then probe will fail.

So here can always return 1.
