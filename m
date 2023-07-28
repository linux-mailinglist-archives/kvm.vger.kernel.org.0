Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B228C766333
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 06:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjG1EgL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 00:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjG1EgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 00:36:09 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC6A2119;
        Thu, 27 Jul 2023 21:36:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZlU0Mq4VaNYA5Fl6aRihEa7ZZolOxaDiFz+W0dcjHVwxPMfwYupaccUqXtA3lkKPsyD12Ua1ZRGxc13OUum0LNLO5ZQj6+LpeSb87jIGNr9hMcssmcGX9J7CCBuM0Y2W8aR54w908YTOYLXApgOAvX3dREf5mk2KuPxknqdjoD7BPNoKA1LbQqacFuq24cgMiv2GJmp8QFTBRyOArfxPqv+GQnWiNpE9f9CnKzApDrPnZPI/th68LUhvc9aGYsx6fFa9POSO4dhnnF66a8T4Wr6jytGPyZZS9CKAItEIRnd9yX0mRMHxfB+roauPcgrwX4RrhmSNuH79uYbJ+vqWZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQGB3dZ5lsEgfqWAY4NIt+sU9ZB5vK9fZjPF+PaKOd8=;
 b=WsU5n5CN6Gixe3V5Vg7HDBfO92xzJH0YdDdqsdqT6d80nJrXWDsk7jAJvM6suHOA3OQBZe6MdzXrm1c8ALXC6SfuAa2o9fWVOmbh8sBH9fmZaeLldqW2/fvss5Tcb7H4DuCxUntR8HcR+T7DF/lvRE9W27BSnIV8IBazKioyc+yXwGDzX4SABqqszFOzv9qrmx00I0XR8SDKRGhcwUwwo6pJkIcHNcK/9w7OwNNocZlhV7i3KvFw7CDlqApsgzOliexZ3YeTfbexX0m/EkDtr/zj+VxSynVThMsc4FK7VSEtMCB1iMnwTOqlXkC0h5p8hZSaroq3vUBxC3zaeyyRGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fQGB3dZ5lsEgfqWAY4NIt+sU9ZB5vK9fZjPF+PaKOd8=;
 b=qwpfYq6s+eXczq3aVXxF/uqUNs2CsAbL7ekLbMLJcous9JUFh6Un8VUZt6qj745LSsOAJqUx6T3ud6mSqLjdlNh/+eE4ZYW4za8JA47/4NvnGdaWuF0OZy8X3T2ZjDlvTp8iIgJl+YA8ihfdjXcUBmy2TS/JxgJCagBYVqoaoTvT7ZH0pMQtEt6ixI1wzZOL1BUaCygNB3h1GtMrVf+3q6muX/yqYfHG/EdjBvfg5GBofpaSJfSuz+Ysb+GvIyE0VH2FOQ88vEz3PheBa76kyzBuJZWV2bLwwlUibJoJmegA2+BUdS1T23aA9cw0D/WxTN9AUx2DhDql+XkVGJ9R7g==
Received: from BY5PR12MB3763.namprd12.prod.outlook.com (2603:10b6:a03:1a8::24)
 by CYYPR12MB8702.namprd12.prod.outlook.com (2603:10b6:930:c8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Fri, 28 Jul
 2023 04:36:06 +0000
Received: from BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::f4eb:dffb:214a:7862]) by BY5PR12MB3763.namprd12.prod.outlook.com
 ([fe80::f4eb:dffb:214a:7862%4]) with mapi id 15.20.6631.026; Fri, 28 Jul 2023
 04:36:05 +0000
From:   Ankit Agrawal <ankita@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Aniket Agashe <aniketa@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        Andy Currid <acurrid@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Dan Williams <danw@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v5 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Index: AQHZuA0UNBO/J73IH0aqgxgx4YgKL6/OIgWAgACFKcc=
Date:   Fri, 28 Jul 2023 04:36:05 +0000
Message-ID: <BY5PR12MB3763F22DF104E2B3BC65C628B006A@BY5PR12MB3763.namprd12.prod.outlook.com>
References: <20230716174333.8221-1-ankita@nvidia.com>
 <20230727142937.536e7259.alex.williamson@redhat.com>
In-Reply-To: <20230727142937.536e7259.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR12MB3763:EE_|CYYPR12MB8702:EE_
x-ms-office365-filtering-correlation-id: 5ae572f4-960f-4e30-8033-08db8f2427c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2HhvYqwWoupV3td7uxHCZPz6F3tPYojuVfWqidZ/sxNljBN672kge5t42cRDgs48GnMs5aPtM8xNnU5fQfHlPvEkqUe0+mwcWv2KaPTwoQPWU42CIAzax80Hnr2hDnKa6UdmxBeV5/m2M6EZD8V3FJhWXuQdclQPDJ7e+4kZCDzvkl3pakh01bT92EwpnnbCLkEi6skcdMbu74LcKlKSXnRGIACrOve2kMoNYnUHR94L9Xu/6EF86VsxwMCz1yzWRGpcv0LZFZgk1nIWRqFr+x6JHMDrrHvUTBCtDwyh4dTfCKJ4HXz5PiHTU0XuB0576aWrSDaJ+mXYXPaxmv35G6QGY72vnkxujCO25o32fnTObOt066wsCORkvej6qDpQYehCvtbm5ZdNMCbjuKTIfTvKczz1MOdic0VtyVXpjFFX8wtXyU5k2OE8dncvht+7cfZA8/y1r5ekYnOKQD5Sm8ikgjPu3cd6xN77KE+7jlckdm5JvW2ppq0QenbkjyTbe/EjknKR+uUiCJaiv3M2+kaUFYiSgHNWaVJksQJhGu/vt+vPMjuS11feLueOkOm05nJkUR8SPl9p8z6yMrCtMtfABGw7nbLEDi+qHNh40kXPvZOUrRa3FqNsW1GUAq7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(451199021)(186003)(6506007)(26005)(76116006)(55016003)(83380400001)(71200400001)(33656002)(478600001)(122000001)(54906003)(86362001)(7696005)(66446008)(316002)(38070700005)(91956017)(6916009)(64756008)(8676002)(2906002)(4326008)(66556008)(66476007)(5660300002)(66946007)(38100700002)(8936002)(41300700001)(52536014)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DJ4HQ5nAzCaZkTGydMXAQ2QtJrpdSKWmN3pKxUdzmR/MtTjStHkXhaariC?=
 =?iso-8859-1?Q?feuVcoBh55C6xav4ypOgxl59LlzLxrOg9lQ5eCweBndSR891PN1UrDafR2?=
 =?iso-8859-1?Q?SGgHANbAVDwZu+ay0TuUQ2AAmVDaetwrSFEyJ9UPcmDZd4zbpVyMrDqoln?=
 =?iso-8859-1?Q?VZg9QbD6I41aWLggzec99YYAOyCkRZ2cr7s947zebQoOE1uYH4fJHYU43C?=
 =?iso-8859-1?Q?oa3cahzP1Y04aL8NeIFZRajiMvPK0Gh3xR2kOYcqhESBSFcYF3/T2I7JKz?=
 =?iso-8859-1?Q?xE4ghsHsLfSov8XRAO6h/1DyrHMkn6Yll8RZAfG8D/rdfV6eHTXpelO3Jb?=
 =?iso-8859-1?Q?AhJGuG858NpbBG1Yj5Ku0+6RkxZjWk5dP677hWdsyozbkaKsNmEHzCRdJs?=
 =?iso-8859-1?Q?/zG2jWGc/WG69bNdfuEjzePloLJBGvbfSBKXz5wZSZcZJnB1wXfTKqu2cy?=
 =?iso-8859-1?Q?XLI3//5od7CHLFLMAe1v+PUkfXn2iAL711kh29RiEkddxZc0E2z3m1N31q?=
 =?iso-8859-1?Q?+u7s7cObVuMPxCaJe4Lizf1CW4pDstBJfsf6y2uMZukY0eTVFmnYsUZJ2W?=
 =?iso-8859-1?Q?eRRoL+HtaabhQUmTZQt3RKogwODGE9QUxIVfsd01xphoj5yI+TbsQOUkAm?=
 =?iso-8859-1?Q?ddzyWM0Eiw6JU51Sg7blumomviQEjB0iZ1rH8tcpdc1T1pFuaU8MPnQxxV?=
 =?iso-8859-1?Q?Z4Q9w76Dr8FvrfiWEq6KP04Gx3expmB6vPDg3T0JA8hHhDesvYnK1FAiZr?=
 =?iso-8859-1?Q?sj+2YbJ4i9hL8VYicvO32q69RON8T3T66l/yJtL1awx4ZD2vu947vMjKiA?=
 =?iso-8859-1?Q?VaLBaNhCJ7mVr7A2rP7sghxmRJJ8UseWQKyFC1E9OMlziTeAe7jK+bfKDJ?=
 =?iso-8859-1?Q?zxmqzRIeqi8lVNy73HGnqq40DaUZaFyyZU8/mBBVdt2ScugHmLfeyRwpuQ?=
 =?iso-8859-1?Q?SoZekTbBFVRsNjZoYeXDbg42i6132CJmU0YbKXRZCCES6yZUSWB4Ea8LFV?=
 =?iso-8859-1?Q?OcyQ+jWfIbu/1OYAQFh3AS/VshlnaRO6gCb1d/tlowHjdFHyThshfwaL3o?=
 =?iso-8859-1?Q?YYKNmK5QLaazg+a56A2Ejp8eEE6uRnizSDSyr+pTQv42wahg2iEhKkpBgs?=
 =?iso-8859-1?Q?2BaY2hETv2pk3MxCQ7ww8gMi6cv+m0iuWThvHXmu19TA17TsqhqnpUo4Fd?=
 =?iso-8859-1?Q?DPxvarSpsuH90MzB/juIYfcGVWrevApV/65OBRkXQsnUHTkQ3rnRXBDJen?=
 =?iso-8859-1?Q?pXxPMDXocERy8i+Msc48V1qvS9pPZsh7Qt4No6ssygn1zCDvG40EIYFGAJ?=
 =?iso-8859-1?Q?zgu0zNccFugtLmrNA1tbwGPHGwGDYRbKLYlGfYO6Q+0E/pXn68DHq1NHXT?=
 =?iso-8859-1?Q?C6sO+Aic3PfChaeIjdHEDE1zcH6k2QLUSp1FpqgVio/HF0RCHTK6QMVZtM?=
 =?iso-8859-1?Q?YZlgLQt7Fd91SK+OIAAuv5CKxeCihVlvb2VnYLEunCVOgsnXlZ4HZ5pP5q?=
 =?iso-8859-1?Q?zphPPkXkXjyRF9lafDNkktxZTQXnglwTHqo7QLLQcBjv2VSfKPTgp026De?=
 =?iso-8859-1?Q?X//tQGfaDkntQJ2Oq08pt74pbe/QRQAGzRKG1arAqqY4sGA6mKgbNPbv7v?=
 =?iso-8859-1?Q?SoglF9+H1PNHw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae572f4-960f-4e30-8033-08db8f2427c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2023 04:36:05.1262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oK4QUoQfaSy0Nd4vn21/nj4ISewLaBsZgKyqvBPMoKT2q1RgBoqDANMelc6G0vRTJaXkEY6Q4Thkn2zcnGpK5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8702
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

=0A=
>> +static ssize_t nvgrace_gpu_vfio_pci_read(struct vfio_device *core_vdev,=
=0A=
>> +             char __user *buf, size_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +     unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +     struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D container_of(=
=0A=
>> +             core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_d=
evice.vdev);=0A=
>> +     u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +     u8 val =3D 0xFF;=0A=
>> +     size_t i;=0A=
>> +=0A=
>> +     /*=0A=
>> +      * Only the device memory present on the hardware is mapped, which=
 may=0A=
>> +      * not be power-of-2 aligned. A read to the BAR2 region implies an=
=0A=
>> +      * access outside the available device memory on the hardware.=0A=
>> +      */=0A=
>=0A=
> This is not true, userspace has no requirement to only access BAR2 via=0A=
> mmap.  This should support reads from within the coherent memory area.=0A=
=0A=
Just to confirm, the ask is to just update the comment to reflect the behav=
ior,=0A=
right? (I missed to do that in this posting). Because we do redirect the ca=
ll to=0A=
vfio_pci_core_read() here which will perform the read that is within the de=
vice=0A=
region. The read response to synthesize -1 is only for the range that is ou=
tside=0A=
the device memory region.=0A=
=0A=
>> +     if ((index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) &&=0A=
>> +             (offset >=3D nvdev->mem_length)) {=0A=
>> +             for (i =3D 0; i < count; i++)=0A=
>> +                     if (copy_to_user(buf + i, &val, 1))=0A=
>> +                             return -EFAULT;=0A=
>> +             return count;=0A=
>> +     }=0A=
>> +=0A=
>> +     return vfio_pci_core_read(core_vdev, buf, count, ppos);=0A=
>> +=0A=
>> +}=0A=
>> +=0A=
>> +static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev=
,=0A=
>> +             const char __user *buf, size_t count, loff_t *ppos)=0A=
>> +{=0A=
>> +     unsigned int index =3D VFIO_PCI_OFFSET_TO_INDEX(*ppos);=0A=
>> +     struct nvgrace_gpu_vfio_pci_core_device *nvdev =3D container_of(=
=0A=
>> +             core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_d=
evice.vdev);=0A=
>> +     u64 offset =3D *ppos & VFIO_PCI_OFFSET_MASK;=0A=
>> +=0A=
>> +     /*=0A=
>> +      * Only the device memory present on the hardware is mapped, which=
 may=0A=
>> +      * not be power-of-2 aligned. A write to the BAR2 region implies a=
n=0A=
>> +      * access outside the available device memory on the hardware.=0A=
>> +      */=0A=
>=0A=
> Likewise this should support writes within the coherent memory area.=0A=
> Disabling mmap support in QEMU is useful for tracing device accesses.=0A=
> Thanks,=0A=
>=0A=
> Alex=0A=
=0A=
Same comment as above.=0A=
=0A=
> +     if ((index =3D=3D VFIO_PCI_BAR2_REGION_INDEX) &&=0A=
> +             (offset >=3D nvdev->mem_length))=0A=
> +             return count;=0A=
> +=0A=
> +     return vfio_pci_core_write(core_vdev, buf, count, ppos);=0A=
> +}=0A=
