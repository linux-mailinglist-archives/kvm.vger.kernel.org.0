Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EDE7C7C43
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 05:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjJMDoC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 23:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjJMDoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 23:44:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D035B7;
        Thu, 12 Oct 2023 20:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697168638; x=1728704638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RXjLzYeDNEKJlUvZlwvGnAJ8M19vacY0KXR43ZF4VBo=;
  b=f9lHalG0lXbMwscusWD64jh+7sW+5TF99mvtro9XlhDwopc1nIyaRapc
   HosQ/vOzfs14TTL1bvFnPMjwjpZtBsycXC5K3FxazBdhzdVf6wNl4BvHN
   RsA95+Hsno97ZKENjdkivXCBq+BziAQe3R1US2IUKYb7xa61nEHrkfQmS
   wBDdrlfXQihAtBD5PDQDg+E+Q9N//qfh2MWiQRlvqcSLv6cjzp6V9XvcE
   Dozxp4v4HLZ2s9SEEZui+SHGZSDcvlqQunULC4wZ/cxaQ/P3D6h/gzMnS
   HBP+5+z8ruffIlgC3lFmPPYwbQrIasWzFzqsFdOBAimpadpM/JlPcmjGo
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="364463803"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="364463803"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2023 20:43:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="820420549"
X-IronPort-AV: E=Sophos;i="6.03,219,1694761200"; 
   d="scan'208";a="820420549"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Oct 2023 20:43:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 12 Oct 2023 20:43:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 12 Oct 2023 20:43:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 12 Oct 2023 20:43:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 12 Oct 2023 20:43:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMNLdRjAUrIhYEP6sywIDrP1nlRgO9fR6axo/xaTJzjxJn/yKauL3AW1zq1iDP8UZV5LcsXq74knOJmrjgppkrCn1btqWZepI/C2g2Nz5HzT4Tr2lUlbrDW3ZEPrP3hNdkEvy8Ky6xxeaCfaNFpsBCvppGqpszm6xq6Yh5e9FmVexsyyXtcr9Ihc2l9jRpIj+TDlK1Pm5D+ZIZdqjvYD2oz+jTZSaNzyqoOMzuIpFZAMkb3BHww/6VOobJIckT7kWNHq0ce8uED49L9pGIxuVKb4vnnwveHlfxR8ZV2/LVYkHA7lt/liswp6eMHnFvWe1V7JHbEjr0UHflBg3NH59w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXjLzYeDNEKJlUvZlwvGnAJ8M19vacY0KXR43ZF4VBo=;
 b=AKW+ZJvDxqfdYYyNBwufg3HabzpbW3g2op3SxsJoNqSdGX6EyL2zV7fm08uDObwytMJz/AnPw/vHRCDeNWJC69xzSGZxCfhfgwnjMcdGwE8Z0AzZ2ikyE1rL4n0BTFX/mEBAXaxfDjvrIxKnVXEL0eQJOPyAsfIKdiFlZBNOCkhfl8BBAJiFD+CcqAtmvyK7SeuMNLE2aSkWVG1fv8dJh5rLJnRThrY3YZijv3jmqiqMm5k0JoGu0YBqAM1nO0SRekopQbS3+uK5YB692GJ8odQBIFXbslWyxJhtaByBFecPx5lNylPbtjZakf4k2NeJzgZ9HMhQp+R5KqCZBxvm3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7842.namprd11.prod.outlook.com (2603:10b6:610:128::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Fri, 13 Oct
 2023 03:43:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::7116:9866:8367:95b4%3]) with mapi id 15.20.6863.043; Fri, 13 Oct 2023
 03:43:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "ankita@nvidia.com" <ankita@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "aniketa@nvidia.com" <aniketa@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "targupta@nvidia.com" <targupta@nvidia.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Currid, Andy" <acurrid@nvidia.com>,
        "apopple@nvidia.com" <apopple@nvidia.com>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "danw@nvidia.com" <danw@nvidia.com>,
        "anuaggarwal@nvidia.com" <anuaggarwal@nvidia.com>,
        "dnigam@nvidia.com" <dnigam@nvidia.com>,
        "udhoke@nvidia.com" <udhoke@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Thread-Topic: [PATCH v11 1/1] vfio/nvgpu: Add vfio pci variant module for
 grace hopper
Thread-Index: AQHZ+VwgDWGk0VCFcUeltplt5s48drBCtrFAgAAx5oCAAPC30IAAqQQAgAKZLmA=
Date:   Fri, 13 Oct 2023 03:43:54 +0000
Message-ID: <BN9PR11MB52760535A35EB5EE710625B78CD2A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231007202254.30385-1-ankita@nvidia.com>
 <BN9PR11MB52762EE10CBBDF8AB98A53788CCDA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231010113357.GG3952@nvidia.com>
 <BN9PR11MB5276ECF96BAC7F59C93B5E4A8CCCA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231011120026.GU3952@nvidia.com>
In-Reply-To: <20231011120026.GU3952@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7842:EE_
x-ms-office365-filtering-correlation-id: 130c0867-b33b-4be2-daad-08dbcb9e9fc8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZN1y3kp1cmsvTWyP5hO3QL3YQFMmf6pYONpYHOoBTKLCXKekfaqePEQt36ETI2y5f7lu2Kg1zV6bagUdUjcsGS8OFZDsP2VWteveucmpE2jozf83Uit1DYQ2FtPEHHplH5QsWw0CUWJHejkKGziO4VF6g5GQ33l5kg5mPDpxsKpDUjuSqeaFXGW2RZK1PORrPgRbwiRv8ApKf1s8jbjswvpCP0hDVmh4XNFBZ6SXaQCmHpw987kV5e1ko8ZX1qCc9Rtg7rIiXmB1E6MSeYejeY0mH2IFWl5YKPt8CfYTsiOTJHSQ6CQRVxhDU2wdbVAsxR+i/RM0hqSZbU/398zaTiTOLK/2HdjF3dPzLiYInAiPwfERRxEIoEzUIUod8+QmLdqMAdrudFMp4kg7hlnDXELeWydzZoE+38r+72eKnKy5bBYBJmSFBQa4DItNDDmgl6nbymjlnEZgnlAvzeq3q2W0Yn1nOX4ZATYIxUfKhU/gWMdBy0x7FMRUNjxeDv9hl8SQON8/Q5lctCh6enoijAyIUSpiQZkmqgJXUXw45qQRkghguYk1vK/BFM9YNUxXY6KOqoDmFyEubvfIl1qbPAjXjYoksjGIwZ7yRFA29twJ2z1UXFeHQHRTDK9LdIh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(33656002)(26005)(5660300002)(82960400001)(52536014)(8936002)(8676002)(4326008)(9686003)(7696005)(38070700005)(38100700002)(6506007)(122000001)(83380400001)(478600001)(71200400001)(55016003)(316002)(6916009)(54906003)(64756008)(66446008)(76116006)(66476007)(66556008)(66946007)(7416002)(86362001)(2906002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0mC1kJS6bJmJI1J5iCsBF1tHTogIxWr/Z/8tI9SlNledeZ5BjB7mxd4EvPFK?=
 =?us-ascii?Q?KJ5MU0Q9286KblPeC1mOlAXY9yrNcQjLdFO8jMfrQ5yC+Hr+pWBPwG2ABaXH?=
 =?us-ascii?Q?qetoib+Z86esy12a/vKIYEb/Sk98XddUX8TJjV6WWwgja1K3mQaa226RiObO?=
 =?us-ascii?Q?EsGbqqziwnzLNUrPHSFgA8iqBPjZ4zFl1Td7ioCTD5TUknaQ8k0cHOr7r39g?=
 =?us-ascii?Q?RlluJm5sMp4P2kmHnU9aVvx44CDkBV9hAEVEXnwKWk8zrp2f1N4Ph9yMfMRE?=
 =?us-ascii?Q?WPJZnkJ6UB+he5vTPh9QfGyl2f858Wk31PQ/UJjnDN//dsRkl9svpw7d2RGY?=
 =?us-ascii?Q?S/S1Sqw6a6gZlp8Vm7BayimX036yBWnC0GXtLvGfr32M73Sbr1SFLb6Lzt5F?=
 =?us-ascii?Q?Dsty+FU+wPQjv+IybOtmLK1osgWodUcr6Q9cOFnuRCxS9MeRa/dKfWaVyJdm?=
 =?us-ascii?Q?796dt6waf7epFBkljTtacwC/N3T/jVViLdJDwS5h1KS7q6cEHtja4Q4olr5H?=
 =?us-ascii?Q?w0oBIkPuoAoCaCStrAvyLfuHN6YtLvlV7fRmyJ2//sB5c+yWbBgYW3qm9B+H?=
 =?us-ascii?Q?H53KKO27LlgP/JrqOhN3sgIRU68+PiSvrA1BT7jIb5ekLP4E2chSqJ3VQmxe?=
 =?us-ascii?Q?ueaHwQWSnoVfJHjnwiBU4w2qOH7wPxIMhCtrTwX7f99jihEk9b5kGqQWmVp+?=
 =?us-ascii?Q?PuGCUfZx4yMnIB+zhtulMFnfEiHAcv/+fRGSIg270Bl43j4whAaNPclQDrWE?=
 =?us-ascii?Q?7yTR8tkNUCmvxsA+CvLjKxJfoP2ju2inSkSJ96HUGgbrXpIIzo8xpF/OzrPo?=
 =?us-ascii?Q?0oHxU5X/MI1L7cILslMQV4AKw2YizcpK9lrZB3lAR/jHpToPFU4GAXEdrP2z?=
 =?us-ascii?Q?9LBqG2SyliN3GPiZz/HAKAzUxeePhWGkRoOt19SOO4zJMLTWE+iLwtnelaKr?=
 =?us-ascii?Q?Wrvv7alzcUHjKjLI2z2wrt52CnSKAhIbHJXYyKivWyudbOgrW9ngw7gttXvR?=
 =?us-ascii?Q?axPhvDcR16BhOuC4Jz02TKWb6VGPLxtpoe9zUzuHudsB5bzZsQhq5S3BBAha?=
 =?us-ascii?Q?jJqPHNG1Y5DhdHbiTmPjZ9bz3ZIpmQYKHZYIyln9bJmfDwYylMAZ/iBg2gEe?=
 =?us-ascii?Q?ck/F2S/8rrlW8shtyTqSrNJ3USZfkVSR00b8ZHO3UOJOCCC2XZSlE8U0fFJo?=
 =?us-ascii?Q?VmwZ/HVRs2HMwHETRfhCVlxrM/0yvIe3aZtQNphRvd4yczZ8xZBtwmIgVECr?=
 =?us-ascii?Q?iLIK3BQzxj7GQTzvxCP5jMes/dBMCsJOHYIEzB7R4Fp3F3m/sIpX1BMeJO0c?=
 =?us-ascii?Q?spmiYeebS+dA/s2+nmfzwtqx/DQdN9fEXS9Ol4Y3nMLnSqQLbX7gVhPgNdXA?=
 =?us-ascii?Q?3+8e62+iyimsp1iIP8ol9vwd7QhGL68SLCZ1Og+odcZygmIi31395AYLXr1V?=
 =?us-ascii?Q?q/z8mV7JGcYwY3gqUC3NITw9iuSaDa/bxfUYKL2UkKkytDXpFvfolAb5RKdF?=
 =?us-ascii?Q?cgecUCA36q9pZWrnoZKKRZek386Yn6dVW2yt/XzSy3uUkeUBidM78j+vA+2D?=
 =?us-ascii?Q?f+iG7rTZDvVjtB2qMk5Yg9+vHKKlO/E6KoqyBaFZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130c0867-b33b-4be2-daad-08dbcb9e9fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2023 03:43:54.8592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s/K9wXx4+g3TUvf91vRh/ydxL/OWUsBrpybiumnzba3RZ/oNjPdnIjR7o1P6SI7LGh9RCYAyNB+Dyi0luVFHlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7842
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, October 11, 2023 8:00 PM
>=20
> On Wed, Oct 11, 2023 at 02:00:30AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, October 10, 2023 7:34 PM
> > >
> > > On Tue, Oct 10, 2023 at 08:42:13AM +0000, Tian, Kevin wrote:
> > > > > From: ankita@nvidia.com <ankita@nvidia.com>
> > > > > Sent: Sunday, October 8, 2023 4:23 AM
> > > > >
> > > > > PCI BAR are aligned to the power-of-2, but the actual memory on t=
he
> > > > > device may not. A read or write access to the physical address fr=
om
> the
> > > > > last device PFN up to the next power-of-2 aligned physical addres=
s
> > > > > results in reading ~0 and dropped writes.
> > > > >
> > > >
> > > > my question to v10 was not answered. posted again:
> > >
> > > The device FW knows and tells the VM.
> > >
> >
> > This driver reads the size info from ACPI and records it as
> > nvdev->memlength.
>=20
> Yes, the ACPI tables have a copy of the size.

So the ACPI copy is mainly introduced for the use of VFIO given the
real device driver can already retrieve it from device FW?

>=20
> > But nvdev->memlength is not exposed to the userspace. How does the
> virtual
> > FW acquires this knowledge and then report it to the VM?
>=20
> It isn't virtual FW, I said device FW. The device itself knows how it
> is configured and it can report details about the the memory
> space. The VM just DMA's a RPC and asks it.
>=20

Interesting. Perhaps this message should be included in the commit
message to help compose a clear picture.

With that,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
