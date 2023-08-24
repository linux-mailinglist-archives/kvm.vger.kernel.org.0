Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2424678684A
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 09:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbjHXH3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 03:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbjHXH25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 03:28:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3110C8;
        Thu, 24 Aug 2023 00:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692862135; x=1724398135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QoyTpSB24ZJU0DkfR0qFLL1PKWg/pKXoEBRvAaHgOdk=;
  b=C/r+H+eJUXTqbxc2xABvSb+zWjcdwEtkSYcrdIJ8bhwlFycn4S/KW+4l
   6L+VZdA30WatznbQj2Lr1lGfY84Lu1fCgwAVXIRM3XMHPpKu8WFSWDxay
   V448zLc+Bfd7wuzCYRkAGvXFysI0Rm3Uimrdze/vrrlubUrzH3WiF5htZ
   4Q0t4anv6Zq1WyJ4i+H0P/8oD3ZYKq+PYkdTlLH0gFruDCgP48UgFZEZo
   ACpCy80DYwY4R9K1NvNpEunS+TcAo2BlClZgvrunTXFmK8oDKQtF83TW9
   IM7rRIgjHe5BwncKl0UyVAGrH2Gd2lkZ0Or9QFy3ZrRbou223e9ojWSBi
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="378122095"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="378122095"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2023 00:28:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10811"; a="827025155"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="827025155"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Aug 2023 00:28:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:28:53 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 24 Aug 2023 00:28:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 24 Aug 2023 00:28:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 24 Aug 2023 00:28:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrcWe0lIF4Kd+gPpm4jYM8oEoQmi03Dg4I7yPmJZWv2j6GU39f+vARktEh4PIbkSKaZ/l6RkAUe/WDp3f9ybTGwqbkNpmTc60SCNDe0aYH/JDHorYZIb1zVd33Kxr3aPDauKP8zAG6QivMzS3c6FCWT60C8CsfEbs5GwwaydMBoCZbJ4+fhj+ZDU0C01wsme5iCHA2RAnuRGQbXp0VPOIHg2O4D8ywMKcMZ7S5/A/PgBqqJIoPekaYjAa0oBTqgBOEXwRwuLs1darl2T7XE7thurrUz91ZLz1v7ndMpW0LsqRuPRCLgK/lkOqGQcofmW/5LyLhrW5NHylS/m75bLOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaFaBTXwAKC0cvSnfIf09WzB+DK45gtqRtS/u8LZuWc=;
 b=Mbwfxh5eP0K5a68zYW5gwwGwS6eoBQtQRBCq7XxI1oKXkK/jtSBZJKXr80RniAKngNH6gu3faSwP7yOT5LUKVQOBrREnabvhjjND7SXKL+0B0RLAQ9k//Y5pZRYYB6ZftrNpPLSknFiCVARn8z0XEKbP0Qp6enWqIZGxP9bm7C2HcwQVAlnA23Lv2atFHGYHY4MeuxmY2PJ4WwApVyp4RsyA9ofpOVQYelph4frHPmsqNskaZ9QubPypYVwNu+3xrDV8RwX+aFDZP63teFnV4nwQxEXFpcfIz1Wqm+2tgCDX6cQY1ZQ2LfVl2/AVsWJxkA7brRlUSOBiBxIJO0efvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Thu, 24 Aug
 2023 07:28:51 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::889e:2c90:67be:2005%4]) with mapi id 15.20.6699.026; Thu, 24 Aug 2023
 07:28:51 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "Wan, Siming" <siming.wan@intel.com>
Subject: RE: [RFC 4/5] crypto: qat - implement interface for live migration
Thread-Topic: [RFC 4/5] crypto: qat - implement interface for live migration
Thread-Index: AQHZq1VetnXY4Sloz02PBTnKeVdtKK/Z+3+AgB5bZrA=
Date:   Thu, 24 Aug 2023 07:28:51 +0000
Message-ID: <DM4PR11MB5502ABCE829D0286388FDAB4881DA@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20230630131304.64243-1-xin.zeng@intel.com>
 <20230630131304.64243-5-xin.zeng@intel.com>
 <BN9PR11MB52768334F696E7009E8D80008C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52768334F696E7009E8D80008C09A@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|IA1PR11MB6490:EE_
x-ms-office365-filtering-correlation-id: 6c3bc48e-901c-4d43-bcc5-08dba473c382
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6Iit/sq1dRTYZwh7SIpGdjmPZW6QXyR+qdM9e/iKUy+72RxjWX3zfLLebR0t4zHDd2wpVti9KNA1ZKQyLjgZMXxyaap7fDHglPccLOPyw4BarKVYEISUwF/07UhV4hLGSVd6NHYeYZXQ59YEjd3HUyi99v0uWRz6zv/HfuXuk/J+HAB7z07dOHklDchM7TC1EE91lhruEBVbiERd7gTm1LnNEWAtRaxa3x/F/ztNMio+NKwxWJgz3PfexXkPpO5nW4mECblDW0mBlKlgjbVPmpn9vtWsj9F9x5wbhqi451DNX6SRbTF7F1p+ZWDuVcMcx1fR+HwSH66iOWNc0z8csnqhwGPwk8EyQ8YUk619fty4zP/jy+L9rBIR6vTpavgtoXnuFS+BEuv9bjbnq/G3zOsRv0vbD/QGZY0bHJGbjtpAGDdD7H1RgJdST3YgbXPighthP81R6YEDyl3mxkLMuX5jNVOrO0r+Df2yNJWh5RLcti/1pTC4quPOATzRIYD1sDZIxsGZ4iOg97zYkp2xe8M7DfdBJe/C2ATOO08mndDyF/rKeddj+vIX5Ge9G5/MbVsSpsECTPu1tkDOxgw+KdQ0pFLZOZV6gzLxbMd3uWkGDalIJArOfbk1tilkxIqe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199024)(186009)(1800799009)(54906003)(66446008)(64756008)(66556008)(66946007)(66476007)(76116006)(316002)(82960400001)(122000001)(478600001)(110136005)(55016003)(26005)(38100700002)(38070700005)(71200400001)(41300700001)(7696005)(86362001)(6506007)(2906002)(9686003)(4326008)(8676002)(8936002)(52536014)(5660300002)(83380400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UJPwOfKBNKVbMTbpXBwoIoB6B9E0i/BzsOkgu2jHkxhfgHlOkdqxtJFbpfAq?=
 =?us-ascii?Q?AA5rXF1zH9CtNxzS5RBbN015YD+VKVaMRZiNTiSt38CS7irQj10nv7kholPT?=
 =?us-ascii?Q?BND/N3Snryy8toAJttJQOr8epaX3mu0rlfdJV6/31DR+taBXfMLp8bt5ZPwF?=
 =?us-ascii?Q?ZJt6eYlqBlKBrOMy1ZTdW5yYLQTRV9l05C4Ewq2of9JRViO3qZa9KMkrWpLO?=
 =?us-ascii?Q?Fs24u16xj3FBD6Lm71+jWwHEqabbRFB36E1uCaKlpa1+PBN3NxMXOyoo6mLW?=
 =?us-ascii?Q?+eeEfEuSxNPh55OJ4AnQ8tgOrn02qRDMabeZtdY+MnJWJBXZCByT4bg+tuDc?=
 =?us-ascii?Q?zGATrtdbetflpEBTWGDZVOxN6qK9Cq8xon3P9HFw2jdV+SdAUXui7+nRYI8k?=
 =?us-ascii?Q?GRCv27lZOH3TQUfo5BALsvoMLPE69adTTEtWNaP9jRNZMSLzVUsMMMZUfR4P?=
 =?us-ascii?Q?UYtCIfVAoGjvbBBfWiLh4VF8ppfjWSxiyultm3Xk+jdU4uHMIwfWp9RFAQ2M?=
 =?us-ascii?Q?TaZwrf49d7VUqk0roCZGe7aNu8TU0PK+CEooDmCYHlHgDqLS6lF0sNZQEJzZ?=
 =?us-ascii?Q?kN/5BTKCCAnKGmrGaKfE6xRLS+P7VwMASf+r+lVw/56wbuq1ySMZq7Ls8Rw8?=
 =?us-ascii?Q?BAtNBXs09namqFV3/WV2FYROw8DifrZbti7DOIFkzJLmsRcq2J4pm8tleTOx?=
 =?us-ascii?Q?l9xjwqlegSfSNczAgUpW5gwNDTxqqQ1tg3RgkL7uZjQ0YsuI6q/yPL5fpJcO?=
 =?us-ascii?Q?+VPYpXAL0753mdsCRu1dSx29XesC9vATrSQHvBRKe3Drwmf16njqGFKPP1CZ?=
 =?us-ascii?Q?6wxxhEtS8iChNtG8JXA2+IaxD0xmam86chVmsOuTy0BK7pndfzdP3M4l/RP8?=
 =?us-ascii?Q?ZlpiNkU/IZFpvhXIfgIU/MX4eqBzuUjwbcNGt6XCtPov2oSyKjJeOyskx610?=
 =?us-ascii?Q?RggBMcZtNoYUhX+iwuGGfXzJyiuGJVMJZErHw6sYOLIym0laUmiKk7zgglde?=
 =?us-ascii?Q?btmeqfF0mpy8/Dex6ih66GEWoIwRg0lWVlMKFqKyREM3aYk96Wu5JzLX5wN1?=
 =?us-ascii?Q?uH65D+ADSflUT6gypPHQ9/F2I5LbXpk4jON7SaxqEPGhYLFHi0E2G86g/CWy?=
 =?us-ascii?Q?+fWS1B/OdJ+gNxNNIbJrSMj42QuKVa2qP1ixTkgioA0SFLEwCEsnoLktL0Tl?=
 =?us-ascii?Q?RIlxflAKcgHmWSSaQcHuatppca2ZpU8y+mWPAvq4Z1r5SL8EKA2xvmD2QMv5?=
 =?us-ascii?Q?MIAMSln34ktgz1GHcoHVT+gMLJceXAwjVMrLbx+Sg+XDrFhDaUF4q0qcL6MU?=
 =?us-ascii?Q?gMli+RUaLHdUvzP/EzhRtPHmpcVO5ONLnxuyplJb/ajdfB/VijC3+/RgVtxA?=
 =?us-ascii?Q?ZN0yHQUihdmiJSHsb4SoV4AAkhZZAXXmbOQG5564C2I8VnPA9bNnz06oL7h5?=
 =?us-ascii?Q?58sk6CioOG1BvqaE6wC+LYbRhXZ4eI5v39gE7Hofdchdim6ZbqgHseh+CGTs?=
 =?us-ascii?Q?FuBk+Iq2M3Ulw5Ywk9hIIi1VPidoC8C2QGGFv1NV/JmsEzPoJAJCkysSZiPd?=
 =?us-ascii?Q?XxD9xqk+dllCIvVk0PfPZI8hEQvZ7rhnUPMvMb2R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c3bc48e-901c-4d43-bcc5-08dba473c382
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2023 07:28:51.0988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nRJ1GsQDH7Cv2M5YaDiMU8c6nU9VmlKfTaAYQ3yq3iCNUUERHostkxlBHAtM0T4N/iMKSwTziIF7uf93E8KxTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Friday, August 4, 2023 3:56 PM,  Tian, Kevin Kevin <kevin.tian@intel.com=
> Wrote:
> To: Zeng, Xin <xin.zeng@intel.com>; linux-crypto@vger.kernel.org;
> kvm@vger.kernel.org
> Cc: Cabiddu, Giovanni <giovanni.cabiddu@intel.com>;
> andriy.shevchenko@linux.intel.com; Zeng, Xin <xin.zeng@intel.com>; Wan,
> Siming <siming.wan@intel.com>
> Subject: RE: [RFC 4/5] crypto: qat - implement interface for live migrati=
on
>=20
> > From: Xin Zeng <xin.zeng@intel.com>
> > Sent: Friday, June 30, 2023 9:13 PM
> >
> > Add logic to implement interface for live migration for QAT GEN4 Virtua=
l
> > Functions (VFs).
> > This introduces a migration data manager which is used to hold the
> > device state during migration.
> >
> > The VF state is organized in a section hierarchy, as reported below:
> >     preamble | general state section | leaf state
> >              | MISC bar state section| leaf state
> >              | ETR bar state section | bank0 state section | leaf state
> >                                      | bank1 state section | leaf state
> >                                      | bank2 state section | leaf state
> >                                      | bank3 state section | leaf state
> >
> > Co-developed-by: Siming Wan <siming.wan@intel.com>
> > Signed-off-by: Siming Wan <siming.wan@intel.com>
> > Signed-off-by: Xin Zeng <xin.zeng@intel.com>
>=20
> this is a big patch. Need reviewed-by from qat/crypto maintainers.

Sure, would do that for next version.

