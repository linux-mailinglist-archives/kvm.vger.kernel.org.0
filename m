Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579B16C7B40
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 10:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjCXJZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 05:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjCXJZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 05:25:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA9544B8;
        Fri, 24 Mar 2023 02:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679649921; x=1711185921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eaadq96YxO3Q1MP8QKhbBRa6NEihZeoanf+IJxtrxZY=;
  b=FqaBE1yD4T2Czj4w5tH7WGMH5PRBEoTwkcAkcqWlu3+NDZTOa8+9uJFs
   bPOgoSVyPNXfhdsNDdhc7EqIzYW6EtL/gvlIrtSRXznBTwToYB3+9dLJB
   OVRmt1ZcXmWjWsuiXdL6B5Z83tWkK5NNrWYV2ldwDnovDUGWEbGjVEV6N
   7V5tCxm+0nSRfNX1iDUygYCS82E7mLiif5rN+9uo/j/z8lhwCeL74we0P
   hYSpNLim2B+KMcT2S0q2enLehsoqHZ5rQmnfERwSEdNWlBB2uMRbK2uE8
   1mJpncqZxMEEEIysJFlRURC9LoevvtB0wkoT4SBxMqn9to9rOVUhohItX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="404654093"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="404654093"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2023 02:25:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10658"; a="1012191776"
X-IronPort-AV: E=Sophos;i="5.98,287,1673942400"; 
   d="scan'208";a="1012191776"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 24 Mar 2023 02:25:20 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 02:25:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 24 Mar 2023 02:25:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 24 Mar 2023 02:25:19 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 24 Mar 2023 02:25:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EaTRJPQN1KD+o+43m4yXRQkESIYdnn4prI7rghmbLFM0hdEVvNqf31CofdYhwqTo45QRVI0sEfsrl7HyszZiMM95VGnjDn1W3OU8N5gUSuHiudJP399xDr0cf7bUJnHtt/bQ6uzYYHpf0QxLktgi6YKjhbuWGmnTMk2V/PFi8deSdWZBMKOrCIZ/llUOLQcnUWdzdZ5wKcJLYlyUeE0IOJwv5AmK3voHkaZawxEbmKGMTHa8euCVRP2GlS3YWzRusEaA82GMJtfYOfrxJhMc7fW5wcCJNYJbEH+/20/J/VjxkuNDL4s4jWutEMUzw53eiOUkeBChfHEZB+kMXsmwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2a7vMOnPEn9wsTQ1iFccXudVkqB8k/E6zhTw08bmNA=;
 b=HN136RUopQjYxGhP6qDkO7Tgx8o2J+l2fyK6BpUpnJVFAbJOp6rFfj7hwdS/hWneoCXtxSMXIhd9Dh/X4gqplTCJvblu0OGtifkjnAk1JsNmB0+YrVE3hiVa4I4DANnyVxh+v7x37+RvhAyatfCU3DaL+DPM1Hn0JyfW4s3NsQj5PlGbhZVY6Jtet3jG4UfMD+Majq74lgPedWKRnr0+ic9s26ERl7lZNWU0ImHzYhJD6A/lHASTMCk0mxJS5mVGagyBh5Ybrhq2UZ7X1o3IJPaHLgv0uscFEaQKNmSALcvwSztyughoPSeTsvW3vrdLf1hLdHPSwdW3yK2sfJGHYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BY1PR11MB8079.namprd11.prod.outlook.com (2603:10b6:a03:52e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 09:25:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 09:25:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZW095081R6kW/70aeRy5pC5KSt68ERp6AgAANFoCAAV3gAIAABT4AgACOijCAAHSzgIAAD3jAgAAIX4CAABLsgIABYx8AgAFjh7A=
Date:   Fri, 24 Mar 2023 09:25:12 +0000
Message-ID: <DS0PR11MB7529AAB4FD8739C615227D7BC3849@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <ZBiUiEC8Xj9sOphr@nvidia.com>
 <20230320165217.5b1019a4.alex.williamson@redhat.com>
 <ZBjum1wQ1L2AIfhB@nvidia.com>
 <20230321143122.632f7e63.alex.williamson@redhat.com>
 <ZBoYgNq60eDpV9Un@nvidia.com>
 <DS0PR11MB7529B8A8712F737274298381C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBrx98kqNZs3jeWO@nvidia.com>
 <DS0PR11MB7529E4C6196C8581CD39A7C7C3869@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBsF950laMs2ldFc@nvidia.com>
 <DS0PR11MB7529E2DEEB1CBBC9413A0480C3879@DS0PR11MB7529.namprd11.prod.outlook.com>
 <ZBw/vL9JyueByMv9@nvidia.com>
In-Reply-To: <ZBw/vL9JyueByMv9@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|BY1PR11MB8079:EE_
x-ms-office365-filtering-correlation-id: c4065c8b-11fa-4064-b4fd-08db2c49ab5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ipg1/MAbsO/1VL60JSa5EK+lbGPNITu0gou+rgPaEOJw+noVYeHt0wnC/GqBg0pfIh2lhzl/2gbD5YUxzo0N7e71zn6mrlFxJa1YW7wElylPQrYbIBbgWMoKfjAyzkZKhUsqGBsmsd/kNKCl3FUFa/VMys2WWQ+44raZMw+Hvx/OWi/zdgA6evTShnzLTkNKs4Bq5yEwdepq7KAIaW5n/tB6AfCrZlas96F0y1izE5nYEYYxJ6s21LMUeH8sa3IsSIqsSFRMfvpCEItWJC02IMt+lXOxDkvnn7+1m6z5qX42FX/05BVRBSBE1zPu0kxdJUHdVdC8ClHqIrpHThSZDL6bij5UO1FwtuGkQ5gPaXJu0R5ZKRd51w6Ppfm8kj84W/N0Gy4wz18aFsjTkX0FY5cVMv+v8q4pLpZa4Cgr3MdMKE0nbqS5t0pAh4RAULZUMwVBLHDAVD80Jg91TLw4ujD2Y68C6eWGyTjUiYBQrereIq/cez30yBNF+40E4uNTkYFkejPcky2uDREFOTG7sZ+aqQJsWJJyR/o/W/9wWxw1iWJ+0BlSbOo8+tiL8KLeTeaM1C+UlbL/Qu3QkzVFdLQaYctZ/ED5jHs9x+gGndQOQYZvmJaxI0XR7diICtmH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(346002)(136003)(366004)(396003)(451199018)(26005)(478600001)(7696005)(38100700002)(6506007)(122000001)(9686003)(186003)(8936002)(71200400001)(38070700005)(5660300002)(86362001)(53546011)(52536014)(7416002)(55016003)(2906002)(6916009)(66476007)(66446008)(4326008)(76116006)(66946007)(33656002)(66556008)(64756008)(8676002)(82960400001)(41300700001)(54906003)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XaamGhLDRr/fEHtTQqyeeVX96rfnpWRxpEviu7Ul/jmX6hy5zrwjKZ2piCc3?=
 =?us-ascii?Q?LwgC8e3xn8q4Pk7KzgFjyBP8+Wg9jNeyF4Rh/FKmfQHH4JpMyaB36XmKSPcH?=
 =?us-ascii?Q?E22CiCS31xO88M1hmJfRFwM5UyWoPeGLbpaXO1V8qT8A1yOtbLIU+7gf4hSp?=
 =?us-ascii?Q?fV2s3PCtU4dpswMBHPbd0N5pZojq49yhCi90NVFstl9BWRdFIeErqRL1w7lS?=
 =?us-ascii?Q?rf3vIl6A5I2gSxxvB5zWo325tzORKWhEUS1Te+LZ0asrqR7DYIGs5Z2tUB7q?=
 =?us-ascii?Q?fV35pCsFrm40mqOOCIQOx8NEDbs4oURx/wcwGGPqm8lCWMfBvgxsNqFR3u0U?=
 =?us-ascii?Q?c4o3XR4ojrGB3j6XNQs7V7d+BgCi75Wd0J46je0GqEKnNE/icKG4UB/GMS4Y?=
 =?us-ascii?Q?MrccsV1IhcjkABhNU44LvlwKZmemN+xmfV8fDuJZcGzdf1eb2T2CByN1pPju?=
 =?us-ascii?Q?O599S/6ntCDFGoGOnsobcWSDVaMzLdba+ARmrkzmn6SdasAqf9FNHEjfBBMP?=
 =?us-ascii?Q?EW2OZrXgN4ZwFLSvXANHdrQAJV/YnFlNKsjRg1QcTkn/qSdLdtQ2gCK9u1F1?=
 =?us-ascii?Q?5CuHRpZ/hn3dXXeIsVWkWJ5IZG0TiNT5WyD7iXmlyeS931qqoFw+2DEHUahL?=
 =?us-ascii?Q?2yo6lv1MViPcyISMDauM5wrxJO2hBWXgTzEBegj4GsmV6p4PDu4qerYUJCvv?=
 =?us-ascii?Q?aZFusTwz7ayJgYDH0Erltq9/CmwH+m9gxYHs+1LA4Vg9YBNwah+2aLKSnE87?=
 =?us-ascii?Q?vlOTadDpeZvbmmuJ6h1hcOrEfgTwFI3trjXTjYzoCLPKC06mIhx0GVcpNp5z?=
 =?us-ascii?Q?0OaB+lwfEARRZHFOkF3+B2onB6Z+Ine8qQVVbX+W44bUhtX8Bdl28lmArLbS?=
 =?us-ascii?Q?G0fe4EELoJl95WH+vUwRnyZZTzzefNF0gNbGEeFFpxKaeLqaEtI5kATLI/3S?=
 =?us-ascii?Q?LWkr9mgp8SNuWhi6hjPkP8dNzeH2j1IT38kk2Pz6/pRE7vXYGW3o6J9dzX+V?=
 =?us-ascii?Q?1Un8HtmwOb3XmYNl7YRVb1mzvnUWQa2b6bKiRJfRnBZI2fmPT5tpjX/lczLk?=
 =?us-ascii?Q?Tow+C3ycMwAuzQli1ILUVIfqcyTPPWhEFRxiVEADzD0ovZZlm7cxwumGUG3s?=
 =?us-ascii?Q?ke9vqDdmJ+gzh3r2wovd6CbuClAicNYnoEA/AT9jwwM+3HSx+2tNp24V5gWD?=
 =?us-ascii?Q?leab+6Y0ZW1tugmCQMbuLuJjJJUgDTclur4jzRsL7m8t56eKqNU1/UEXXi5n?=
 =?us-ascii?Q?YEDTp6cetOrBKbG5aqFJoXe9Hx741Y5dqDdbTCaIOHpbIAmqXz4xRTLLZqKC?=
 =?us-ascii?Q?rjfNU61o/Jpw7uAPW8VySAhAzHWBpf6258f6CElqlVHj44Jr0bf56rUWanHd?=
 =?us-ascii?Q?FFhF1lX/QFxA0rMvPmPaqlu7ygcC2HICfdt7ceRv+PTIVrRbiSq+spfvOBg+?=
 =?us-ascii?Q?aylmuFk/ZDqY+5hJWpV2xl4N8ht/3vTDjFNQV10CYztYyNkNj6Y+3mJGoXt7?=
 =?us-ascii?Q?ZJoQ4Jku6SQmnvtWj/PPu1afKoviKDe8MwMSvVQq3cZiUMOUsS7AlOMENgj6?=
 =?us-ascii?Q?8OJhD/lytPaM45+lj3VIB80d56HgIuzV6xie8AwU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4065c8b-11fa-4064-b4fd-08db2c49ab5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 09:25:12.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PX7ObB9hXHkLRFdfUYjjzvYlL7fprw2MEo6SHiYpcLb5TpCRXxQNALQDnHitGIQPSchOCxowLqEWiDCGeNVc6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8079
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 23, 2023 8:02 PM
>=20
> On Thu, Mar 23, 2023 at 03:15:20AM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, March 22, 2023 9:43 PM
> > >
> > > On Wed, Mar 22, 2023 at 01:33:09PM +0000, Liu, Yi L wrote:
> > >
> > > > Thanks. So this new _INFO only reports a limited scope instead of
> > > > the full list of affected devices. Also, it is not static scope sin=
ce device
> > > > may be opened just after the _INFO returns.
> > >
> > > Yes, it would be simplest for qemu to do the query after it gains a
> > > new dev_id and then it can add the new dev_id with the correct reset
> > > group.
> >
> > I see. QEMU can decide. For now, it seems like QEMU doesn't store
> > such the info return by the existing _INFO ioctl. It is used in the hot
> > reset helper and freed before it returns. Though, I'm not sure whether
> > QEMU will store the dev_id info returned by the new _INFO. Perhaps
> > Alex can give some guidance.
>=20
> That seems a bit confusing, qemu should take the reset group
> information and encode it so that the guest can know it as well.
>=20
> If all it does is blindly invoke the hot_reset with the right
> parameters then what was the point of all this discussion?
>=20
> > btw.  Another question about this new _INFO ioctl. If there are affecte=
d
> > devices that have not been bound to vfio driver yet, should this new _I=
NFO
> > ioctl fail all the same with EPERM?
>=20
> Yeah, it should EPERM the same as the normal hot reset if it can't
> marshal the device list.

Hi Jason, Alex,

I got a draft patch to add the new _INFO? It checks if all the affected dev=
ices
are in the dev_set, and then gets the dev_id of all the opened devices with=
in
the dev_set. There is still one thing not quite clear. It is the noiommu mo=
de.
In this mode, there is no iommufd bind, so no dev_id. For now, I just fail =
this
new _INFO ioctl if there is no iommufd_device. Hence, this new _INFO is not
available for users that operating in noiommu mode. Is this acceptable?

From e763474e255ff9805b1fb76d6b6b9ccedb61058f Mon Sep 17 00:00:00 2001
From: Yi Liu <yi.l.liu@intel.com>
Date: Fri, 24 Mar 2023 00:54:08 -0700
Subject: [PATCH 06/10] vfio/pci: Add VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_IN=
FO

to report the affected devices for a given device's hot reset. It is a
list of iommufd dev_id that is opened by the user. If there is device
that is not bound to vfio driver or opened by another user, this shall
fail with -EPERM. For the noiommu mode in the vfio device cdev path,
this shall fail as no dev_id would be generated.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 98 ++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h        | 28 +++++++++
 2 files changed, 126 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_c=
ore.c
index b68fcba67a4b..5789933a64ae 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1181,6 +1181,102 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_cor=
e_device *vdev,
 	return ret;
 }
=20
+static struct pci_dev *
+vfio_pci_dev_set_resettable(struct vfio_device_set *dev_set);
+
+static int vfio_pci_ioctl_get_pci_hot_reset_group_info(
+	struct vfio_pci_core_device *vdev,
+	struct vfio_pci_hot_reset_group_info __user *arg)
+{
+	unsigned long minsz =3D
+		offsetofend(struct vfio_pci_hot_reset_group_info, count);
+	struct vfio_pci_hot_reset_group_info hdr;
+	struct iommufd_ctx *iommufd, *cur_iommufd;
+	u32 count =3D 0, index =3D 0, *devices =3D NULL;
+	struct vfio_pci_core_device *cur;
+	bool slot =3D false;
+	int ret =3D 0;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz)
+		return -EINVAL;
+
+	hdr.flags =3D 0;
+
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot =3D true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
+
+	mutex_lock(&vdev->vdev.dev_set->lock);
+	if (!vfio_pci_dev_set_resettable(vdev->vdev.dev_set)) {
+		ret =3D -EPERM;
+		goto out_unlock;
+	}
+
+	iommufd =3D vfio_iommufd_physical_ictx(&vdev->vdev);
+	if (!iommufd) {
+		ret =3D -EPERM;
+		goto out_unlock;
+	}
+
+	/* How many devices are affected? */
+	ret =3D vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
+					    &count, slot);
+	if (ret)
+		goto out_unlock;
+
+	WARN_ON(!count); /* Should always be at least one */
+
+	/*
+	 * If there's enough space, fill it now, otherwise return -ENOSPC and
+	 * the number of devices affected.
+	 */
+	if (hdr.argsz < sizeof(hdr) + (count * sizeof(*devices))) {
+		ret =3D -ENOSPC;
+		hdr.count =3D count;
+		goto reset_info_exit;
+	}
+
+	devices =3D kcalloc(count, sizeof(*devices), GFP_KERNEL);
+	if (!devices) {
+		ret =3D -ENOMEM;
+		goto reset_info_exit;
+	}
+
+	list_for_each_entry(cur, &vdev->vdev.dev_set->device_list, vdev.dev_set_l=
ist) {
+		cur_iommufd =3D vfio_iommufd_physical_ictx(&cur->vdev);
+		if (cur->vdev.open_count) {
+			if (cur_iommufd !=3D iommufd) {
+				ret =3D -EPERM;
+				break;
+			}
+			ret =3D vfio_iommufd_physical_devid(&cur->vdev, &devices[index]);
+			if (ret)
+				break;
+			index++;
+		}
+	}
+
+reset_info_exit:
+	if (copy_to_user(arg, &hdr, minsz))
+		ret =3D -EFAULT;
+
+	if (!ret) {
+		if (copy_to_user(&arg->devices, devices,
+				 hdr.count * sizeof(*devices)))
+			ret =3D -EFAULT;
+	}
+
+	kfree(devices);
+out_unlock:
+	mutex_unlock(&vdev->vdev.dev_set->lock);
+	return ret;
+}
+
 static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	struct vfio_pci_core_device *vdev,
 	struct vfio_pci_hot_reset_info __user *arg)
@@ -1404,6 +1500,8 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vde=
v, unsigned int cmd,
 		return vfio_pci_ioctl_get_irq_info(vdev, uarg);
 	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
 		return vfio_pci_ioctl_get_pci_hot_reset_info(vdev, uarg);
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO:
+		return vfio_pci_ioctl_get_pci_hot_reset_group_info(vdev, uarg);
 	case VFIO_DEVICE_GET_REGION_INFO:
 		return vfio_pci_ioctl_get_region_info(vdev, uarg);
 	case VFIO_DEVICE_IOEVENTFD:
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 17aa5d09db41..572497cda3ca 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -669,6 +669,43 @@ struct vfio_pci_hot_reset_info {
=20
 #define VFIO_DEVICE_GET_PCI_HOT_RESET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
=20
+/**
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO - _IOWR(VFIO_TYPE, VFIO_BASE +=
 12,
+ *						    struct vfio_pci_hot_reset_group_info)
+ *
+ * This is used in the vfio device cdev mode.  It returns the list of
+ * affected devices (represented by iommufd dev_id) when hot reset is
+ * issued on the current device with which this ioctl is invoked.  It
+ * only includes the devices that are opened by the current user in the
+ * time of this command is invoked.  So user should re-invoke it when
+ * it has opened new devices.  This information gives user a scope of
+ * affected devices that is opened by it.  This is helpful for user to
+ * decide whether VFIO_DEVICE_PCI_HOT_RESET can be issued.  However,
+ * even user can do hot reset per the info got via this ioctl, hot reset
+ * can fail since the not-opened affected device can be opened by other
+ * users in the window between the two ioctls.  Detail can check the
+ * description of VFIO_DEVICE_PCI_HOT_RESET.
+ *
+ * Return: 0 on success, -errno on failure:
+ *	-enospc =3D insufficient buffer;
+ *	-enodev =3D unsupported for device;
+ *	-eperm =3D no permission for device, this error comes:
+ *		 - when there are affected devices that are opened but
+ *		   not bound to the same iommufd with the current device
+ *		   with which this ioctl is invoked,
+ *		 - there are affected devices that are not bound to vfio
+ *		   driver yet.
+ *		 - no valid iommufd is bound (e.g. noiommu mode)
+ */
+struct vfio_pci_hot_reset_group_info {
+	__u32	argsz;
+	__u32	flags;
+	__u32	count;
+	__u32	devices[];
+};
+
+#define VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO	_IO(VFIO_TYPE, VFIO_BASE =
+ 18)
+
 /**
  * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
  *				    struct vfio_pci_hot_reset)
--=20
2.34.1

