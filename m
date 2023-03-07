Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0CE6AD701
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 06:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCGFzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 00:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCGFzF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 00:55:05 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C303B64A;
        Mon,  6 Mar 2023 21:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678168491; x=1709704491;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iNOxTmXJxy+niwGuU7QDLq4maQmaGHqMcJv3qS318J4=;
  b=Blzt4w+HT1vHK+H3sFj2oshrDIYGNsAFQ4oy1DYXJbp9JdZOWXabZFB9
   9el1Eeg56qrUvt1Nyw9WwbH7pesnD+fAM7fHTKhrXT39ImtTTQUWwOkw0
   YO4pmQkbjyggFGbqSrt/4TZI1oqatmKGRsIesfdGyzfMn621DtFLT88Nr
   sfMEuWRvxo6PejNuc09LeFNYyY5EBZXmPD3+2JCtgTch8fi62Qpq43xHd
   mnUcnYHScQ1YTD0qcC94W1vGc4pn6gDpNLXihodGESrh+GE15irsDPHQj
   RUnbwrsT8CNuf7M0kdtFBLUfMsTP+iM4VyGHZ7tVFEzEcJ94mtCShUzcP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="324075759"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="324075759"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 21:54:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="922213771"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="922213771"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 06 Mar 2023 21:54:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 21:54:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 21:54:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 21:54:49 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 21:54:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0xkjfaGalBhP4wqmegK30XSbadqI4bCIbqOvYyw3jmyqYf+F+WphKhBiA0bbwLI6OBk44SouXU2ibgM9euEwny18/x+PE/chKvfr1iydW1vwTKPC4rwvRl/cKsSoLhqbWPHx+Of1e6nEwTQIbbwUK6NxNbAGHAnVgj624M5ihiVTdWUSJOVcLWtBXqrNexX90RBgl2JH0Whp8XOUMPFdI4wmlSh3j7v9JsbYJkOdlcwIFrQSSsNVwNlyHbIw+qNSQu3ydj+Sn1jlafZzZdAJglrNF0E/x42NWvlKQzJHM8/NTUicMd98pXFa+z7bfqeuEMxRi0VUoTSykPNpKKFEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vO/xh33wf0NmywCeTRcAIy1IIDmdg1D+Qo0P057R1gA=;
 b=l+EJVrnv66Gffl0XzFZRNUpIe6BbY3VRJWTRodfn33VszfBJn7wDsY34UOL4AXasnSO5gxrqEWDq7OYhQX0WTxtKVyXNPxWNQknXzalDWpJrEa+KCXTsu69tAXOyEPk6/MVcNzVJ/VjVfhP4I8w0S2VaZl8AMrnYTJuR9k6YjMu1DH971QVy85vCh6Wh014zaudBo3OVGoGdznZ2f/WTSAUWayqnsqJN4cKSAl7STW0WQflpavOYJbyB0hq2aiOJVJeo7jLlImg8QxeaB/cgA1VX5awCE6IhpnuJ/Z3RVvsUmuBJt0PGpY3ZOcv9xe1Yuqm84vQDWS+P/GZHs6Je5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8349.namprd11.prod.outlook.com (2603:10b6:806:383::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 05:54:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 05:54:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "K V P, Satyanarayana" <satyanarayana.k.v.p@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Topic: [PATCH] vfio/pci: Add DVSEC PCI Extended Config Capability to
 user visible list.
Thread-Index: AQHZTZTPYSblfLFSOUeGl9RPc4dsUa7tzAoAgAEJKbA=
Date:   Tue, 7 Mar 2023 05:54:46 +0000
Message-ID: <BN9PR11MB52764ABF8381FCDB8CE0FFF78CB79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230303055426.2299006-1-satyanarayana.k.v.p@intel.com>
 <ZAXxTiWU489dDssW@ziepe.ca>
In-Reply-To: <ZAXxTiWU489dDssW@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8349:EE_
x-ms-office365-filtering-correlation-id: c8f12ff4-8582-4772-b435-08db1ed074f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGaMiCHRQxZGFkmU+8y1rksROveLRm7ohzK5XqBnOqe1WHhFUP/qwZnGnVD7T0O39wv/vIxbZCDIdJvVnkD8jjGldpUpgzqUo/pP2M+i0rHF8GXD8LF1KlxHtTnZDXl71HEtcJg0SQMNeT1dnGgKb5IQOiUS734oiQ5BWAO4PhoWeGlBvFEU0iQA4wSnYBUNmVTeCzrOanSOOD8HReq+m1MGvMN2RiJqvjHZ3uBcWSCsFMHbt3/7/vtQTBKPkeXmpEyPnVMw0hU3Fky77AJdCAE0yLSqr9n8a4xYFrbDqNkWOMBSGjc3d75KGZ6jzOY98Uh4SW1CP1NULZBQ2bOKwihyvBymjb8fzPPCFvSMKEc98D8OEzb4NxXsXb8gHufiysOyHoMJ8yNyBXPy39bTziG3SZzedxILYFnsxMNuci21ATrUg2LxjVO+H9M6gaUr82XWPjPXchh/zW8ZEEblFUa3QldwYwjgNlG0Daf4Mq90EqpjzWBgAstm0P/+0H4hHbcctr2mbkvfchPOCyFzb9V1sYpONWOpWskfsrHRQTB3g9gXiN/Yta+1SE2FdJbb1GnZ5YTI4wMooWlEfKDYVg95u5sEWuZE80zzkvoMpHfDRb+y5mXKBamm55WEXvSXsMaEVaHBkd7TELVCu9wvf4+3e9gadgVevMEj1e7KGwbbHRwpHwMew7MB8sG+t1C8j9I8IwAh+vylk5lDWU6v2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199018)(6636002)(54906003)(316002)(6506007)(55016003)(122000001)(86362001)(38070700005)(71200400001)(82960400001)(38100700002)(478600001)(110136005)(7696005)(26005)(33656002)(9686003)(186003)(5660300002)(41300700001)(52536014)(8936002)(64756008)(2906002)(66446008)(66946007)(76116006)(66476007)(4326008)(8676002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u4p0Y0Tkwbq8zGhjt1JwKv82IBE7jMDzeul1GAEXL+QYud7gVKHpxIMY6piQ?=
 =?us-ascii?Q?kM/HiUwRV9zetmo68vb7P1je6CYRhpHRr/e9GQjqzMEaztvK5GEvA2qErFam?=
 =?us-ascii?Q?81hFkhDd6sWA7ELFI4gjmsfySziM8MeL0fgecqiWK+X7STSrWiks9Zs05Cly?=
 =?us-ascii?Q?KoCiCV7olYAv9VXalB1MQhJWMBKzPTAQY+MJ35HEckgDaa3EL3YJEzycc0JR?=
 =?us-ascii?Q?+bcLesPW/S+e+xBjqjrK/+WoUolVHEOrFnofAcrlJc7g7xiQH86/CJUfR/8f?=
 =?us-ascii?Q?r0b5KxAuOTLtIi6wmv+O8QtzHOOCn6/Agm59rG5jBD/Jibivv7OnZzKKrjWZ?=
 =?us-ascii?Q?wtNaQpqZH+Fu6FbYvV+z1Yva+j/tDmAoDShvMcFVzdVH0jJdCp2WzlWy3l/R?=
 =?us-ascii?Q?Hk79iCbG83LZuj9h1soifMIayRWDGLpEaORqYAETZPUtYubqyO7LSPjATr7n?=
 =?us-ascii?Q?2wZZh4STSxvNdhZLmaUrjA0OroKHSvJDTEVSsV+j2ZzgI8oOkkP83qjHt1sb?=
 =?us-ascii?Q?/DaxzKlU6h6bT4oHurFZS8xf+N9xBGPRraVePANJUgxHCsstpotM2CefbYGb?=
 =?us-ascii?Q?fesy1CoNuAvJEfRWLZjrvjCDOp1PwD0XrIJqIeVofVrOvr2m/56JsZ46nAJi?=
 =?us-ascii?Q?VmfVPTJDct4sbDwA+GqTEBT89o9cdrsXRZofMdkm3+xml0n/+GwoU36HwoK/?=
 =?us-ascii?Q?5XrnxdsrEV3cOsf23kgNHdsiTeIuXoZFoCzqsU8p38405F8FuuXuArVgTrHQ?=
 =?us-ascii?Q?dt2OiRuxTk3R2WHW68IhdOaUKFCUgkpFYH7glfTvWQgFpmMitMHKym0Xki4f?=
 =?us-ascii?Q?YLiYF9V/XfgrYrfLtmUs2m9Qb+vUFx6ks6XIjRXlg+R5QnpRe6PqKziaRx4f?=
 =?us-ascii?Q?AlFDJ/s/8r3jX2DpCtTdg3w965cF0nNUIEgqutAIdb5iaa2KREagHWtoFvKg?=
 =?us-ascii?Q?3SjSXYIZX0wFI7tceWos4qVBTZNLUfY/Hjas/zCvv5oWZX6XZ5xIScXXZbpD?=
 =?us-ascii?Q?htbTKLr3zzZSKvJrn0N5oCZEn7N1xccT5qvKmX5j8YCdnaquknlitZOEj5Mv?=
 =?us-ascii?Q?IFKuSEGXl+s4Te+FdvUS46sSYbYoV41rR0FfCUwKd4Mvys532+f+p0xMTmiT?=
 =?us-ascii?Q?AtTK1qVoBf4BIO/cZTjeI+8b+htQ//+2kVI9jhJP5sT+MHbj1JhlclzXUeVo?=
 =?us-ascii?Q?3buCVRDVy5wi1kjbYHE63ijLD53pECg2DShrlsAup2fIJTVLUVLfUgbXUkO3?=
 =?us-ascii?Q?lJqp9k8fWAVz+F2Ba7mhBz0fd1gfQlJMm9w1wu8eg51k7aefLUJiO/+nHDeE?=
 =?us-ascii?Q?lTl2qIqD1a1TKvhn7cYan4nI+m/R4vApxerqLwS1dU8vlv8LQ7NeuhhfI0rP?=
 =?us-ascii?Q?XSyKrKgff6HE1Jud4W7HvCNjSzrq3kC4+kFk0rFbo/L2dnjrLWCnWmMAxA/g?=
 =?us-ascii?Q?/FjNncabHCyXSFCznc8tn7+2XpZE7da4nv3BDWX6BcBowEPTVi7OJKaIfMCk?=
 =?us-ascii?Q?Cf03XUe3JUX1c3nhPwtR2y0vVLVL8MGt8GQeow5Vr/KSuRfh9fYxLmxg1v4N?=
 =?us-ascii?Q?eYB6iMES91uDSkWqKGFiwRix5d3yUT6MG1Y2VQIY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f12ff4-8582-4772-b435-08db1ed074f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 05:54:46.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OgX0fEmKvyq7XkkZJwf8KzzwFndkTJpVb4w1gcqMQiqL2LaURkbQdawrUudo3E3RUC1JSux6L1Xd3ySGMyLl8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, March 6, 2023 9:58 PM
>=20
> On Fri, Mar 03, 2023 at 05:54:26AM +0000, K V P, Satyanarayana wrote:
> > Intel Platform Monitoring Technology (PMT) support is indicated by
> presence
> > of an Intel defined PCIe Designated Vendor Specific Extended Capabiliti=
es
> > (DVSEC) structure with a PMT specific ID.However DVSEC structures may
> also
> > be used by Intel to indicate support for other features. The Out Of Ban=
d
> Management
> > Services Module (OOBMSM) uses DVSEC to enumerate several features,
> including PMT.
> >
> > The current VFIO driver does not pass DVSEC capabilities to virtual mac=
hine
> (VM)
> > which makes intel_vsec driver not to work in the VM. This series adds
> DVSEC
> > capability to user visible list to allow its use with VFIO.
> >
> > Signed-off-by: K V P Satyanarayana <satyanarayana.k.v.p@intel.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_config.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
>=20
> Wasn't the IDXD/SIOV team proposing to use the fact that DVSEC doesn't
> propogate to indicate that IMS doesn't work?
>=20
> Did this plan get abandoned? It seems at odds with this patch.

No. Guest IMS will be indicated via hypercall/vIR as planned.=20

>=20
> Why would you use a "Platform Monitoring Technology" device with VFIO
> anyhow?

Ack. I guess it's a monitoring capability per PCI device to form a
platform-level monitoring technology. But w/o all those background
and usage description it's really strange to pass a 'platform' capability
into a guest.

>=20
> Honestly I'm a bit reluctant to allow arbitary config space, some of
> the stuff people put there can be dangerous.
>=20

Probably an allowed list to manage which DVSEC ID can be exposed
to userspace via vfio-pci, e.g. if the PMT ID in this patch is proved
to be safe for a meaningful usage?
