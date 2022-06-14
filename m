Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC8354AE59
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355490AbiFNK3Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242650AbiFNK3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:29:14 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0C2396AA;
        Tue, 14 Jun 2022 03:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655202553; x=1686738553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b9V6jDi8EqMeWdkqcJHxOZ+LNoMADkMVMOKn5hYjzw0=;
  b=jrOCimA9h1DFXc5z8YXZzMJE6YBAkBS/Esp5WfJkf0YBOagCdqWGgcQb
   TWX3zrh7wo3RzMgnTqt0Ob/mgKv5h999AKXOR8qf2ZpTqOYGCpI7aNjIY
   BLvKi6/ChZwiPjngn+4AkHY+FURJaEXiwx74X3ENLqejR0FrUEBnDxFuO
   oIcn/dCNivQ2rs5LFclpa99/RGQZ4xNrg328/j8xZ1ZvhL+FgN2SIKhiD
   RmPJX1PO21dn2ohXhgUPp+QFiXCiZlqit5jWCd+f3YCSdY5W0vdiYguTL
   k1cqS+Y9dPF6/mcMJlvceRAmsB+R6XLhSxILoIGjhVFn8i+FlgKs0weoX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="276117596"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="276117596"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 03:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640289761"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 14 Jun 2022 03:29:13 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:29:13 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:29:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 03:29:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 03:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLzHPVUizV0g7R5QRIbJ+N8z8PJGhTjQpvBVVKMriKnuKDeyEkeVRuRoSrP9VFTG+umYTPhQ780kYXU/K+DUMaNxZs64to/d4sF7qJe0tk50BSuEVBILv/c8Yd+5PLLyTWLnB34CefutwBejuaNSOtHsRqVSrJaeveeJxUN8MxrYahtx+qFVmkrG57cJ2PGHbMKnpMb/J9Zd9GmhJdrCFAbfp79lxbnCuFRb1SL5Oiwv1q1ECckdqaN+EWq9wextfZ8I8VrlquJ86TcCjNb48ZhxUWZj/LI+aoj9cfEzEyVIHRt1i3f2z01HP07BfGl8mV0BaSX9jKQ3ADvAKicSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b9V6jDi8EqMeWdkqcJHxOZ+LNoMADkMVMOKn5hYjzw0=;
 b=I/HrkzxxZNeEJXFbGJeD4ZV7eKNDzawcSZqWw/cfUBTYk58M98Ibk8bvQRbSgNhB//7550R5AQrI83uBChDvKwBhbPq/Ik/2mngo7OHZ3VurVVUzDtFnJTI0JVNzGxwgFsHizYJC5Sj0QvsThH+GWGH3r3B4xMu/tNPiqANuiYTD7vWWCt8dAH0EVYEUoh/Dl/calLba4yEX77xxb3wQnrTkq6Q5gEwjPv3vmh+f0n0xd+lXvb4Jj6czDHlQUzdr1xgkmjzXJvZwopwph8ZvuCB051W7/ArhMTSW+ShP6CHzwvw3zI4AHrllK44xf9uvwR1fMufJQrU8/byv35U6Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB2683.namprd11.prod.outlook.com (2603:10b6:5:c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.14; Tue, 14 Jun
 2022 10:29:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:29:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Eric Farman" <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 11/13] vfio/mdev: consolidate all the available_instance
 sysfs into the core code
Thread-Topic: [PATCH 11/13] vfio/mdev: consolidate all the available_instance
 sysfs into the core code
Thread-Index: AQHYf6r9GCN8Bm6jaE2Jy6P5KBbbia1Or2YwgAAD5LA=
Date:   Tue, 14 Jun 2022 10:29:10 +0000
Message-ID: <BN9PR11MB52768CBCBC9EA35970CF90408CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-12-hch@lst.de>
 <BN9PR11MB5276F45F5B2E93CF455E49548CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276F45F5B2E93CF455E49548CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dee1bce8-881d-4b1c-e533-08da4df0b84c
x-ms-traffictypediagnostic: DM6PR11MB2683:EE_
x-microsoft-antispam-prvs: <DM6PR11MB26835BBA229F7B4A5FE099A38CAA9@DM6PR11MB2683.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QR9NYLnHwrDci9TxTqOr6NdC6oBgwQ0SVfU+E5gjabb3Rs7R4xadKL/UnN5XeUz3qarT0KfLbNxvbEYUer37N1boDa48Mvx8Uf+Y3t3TBggEv5bOE8w0dDmXzn6OA5KR8aIVEsyVud6g3KWgj0apWVOMi1vspu2RYw765o1EN+n+n767zVQdZWSnutctYho7DX6W99BavGG/9Im9o+W3ImRmyW+52r3KgI4JqMXRYks0vkYhmTSQhV/WiHHEnp5K0fxqo7mzKVZCRkdxJNYxatxi7Tzvpq1lPkN2kcWRUF6uWQjDx4Mz/rEsghNzmzmN+6k0r3fIm4nmKGtvLzEAGPA5mWW/PK8j+CViRCBERTWur/O/gjfbfHeqSPsFH2bxBMxavITXz23bva51pdrgiw/Jy+uzLU+rVSs3LjTprXaECXksHmGFT+xOwQeOqjsUUc3FIFyOmpSe0+Lr45wyP7f3KVl86OeoAtgUrzp3tueovQLeQzhBpeBkVo60u4Y691f1xCa75O4ND5JerXMIeyhdBsyRG/aDc+akXl13Yrj9P4ksVNqW1tvndnVTFwMNHNHe8xYYX0JAdxI0Iih8B2/kz8ZVm361Ph06JP1+5u39oXHGdy0LTgE5aLujxQqk//CsA17i93G4VpGXRd41PamF/Htj1CfWCEInyQCB1/k9O7fk/NyFO5e4BcORy3MhV69bcT2WmoT2ULuVqDAclwoMXq6MXbVbdwcuMkDpmhg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(64756008)(33656002)(4326008)(8676002)(55016003)(5660300002)(38100700002)(7416002)(8936002)(52536014)(4744005)(71200400001)(508600001)(66556008)(54906003)(66946007)(76116006)(2906002)(316002)(66446008)(66476007)(110136005)(26005)(6506007)(2940100002)(9686003)(7696005)(921005)(86362001)(186003)(38070700005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QZyLYgywH8H9SLtUFLGeLkvhNk6tAvNTtUZlNLXmmVnrPMxeUrbDWULnKTeZ?=
 =?us-ascii?Q?uqd5n12z0/t19wClpoeq52lm5SUETX4DqVg35BRLh+cyG38C0WmhE4feik0M?=
 =?us-ascii?Q?JKhiQYre0GOrYHljmniei+kk2dAu6yEq4pMpJ0azuhn90LKuZ1Hv09HDFAER?=
 =?us-ascii?Q?g7t5chWmyVaHaB5Wsm7pSDCRjildXPJ6ipCeNIX1IpVp5FdfgyNMM6wau76v?=
 =?us-ascii?Q?bSuRsdNMEp2YqlEHZnn8ZIx94Hh9KxF2dM9RkLBkpxeJ3p9zdfB3d21+9FC8?=
 =?us-ascii?Q?e9P1dyvzZPnrjQ4e58zW9fMAPfLPSAYCDddIonlmFaRVEgMHJYFrkIz6cMpa?=
 =?us-ascii?Q?VQJoCGnMp6XvWgkae86pry/ixcPfAb0s5feWJmHS32kATllnVwlr/APPXU8W?=
 =?us-ascii?Q?vn0K9UgxcGPKuJp2tFuNNBFn2bB/iXx19zLdWxYYeMZyqPCoTOvdc+R1+aCg?=
 =?us-ascii?Q?Wx7Pdw2sqcD9l6x8OoAUhf1L0G0wn99m64etdyR+6+ewzBWwi9ce0bLKPaTA?=
 =?us-ascii?Q?tPx3yBDoQzfVmNr0JKqU766BTLoRSSRBCyJTv0+Nh6pI2qNPN6Kt8brrDHLf?=
 =?us-ascii?Q?bueVTo3mrFCSOg2DyfKNpf5RPdpwtNteMcaKp5/621afQ8THgL2FVSF+uclD?=
 =?us-ascii?Q?hVjW0RIZySY8tg+dYGV2sA3ztbmQ8hCHVNIb/W7L3L0xw2MhCHhL/ZjE5h1n?=
 =?us-ascii?Q?azaV4s5pDjyRpY0t14PYTH4Q5eroPItSiQu3pj8YdDoKotDlTIXtWXT97CIX?=
 =?us-ascii?Q?bjlVyBT3KVh4FWxp/Zxkg/ImIvyR/gGVcNSq3/aIGJE1zMQkrcdfvRIAUc2A?=
 =?us-ascii?Q?hQlsQiVkf0kE4Mu6WovZ3j55/iPWZWJj8cc6zOlQV36hAzr6203395oWoTjz?=
 =?us-ascii?Q?5nmTZ8SrIN9rC2nPVGBLayPCJTcx+PWz3FIwX76Mw+InNymSy/o9pjL2yYNm?=
 =?us-ascii?Q?b9L7TEK+wvGrccZBGZuVKqzCpsooq/H4lB8LAtugIPD16FWpAe/rUHcy6gbJ?=
 =?us-ascii?Q?aI2w37tQCf7eu/q1suOtTO7V+WDAY2aEA1ADvfF2uljHnbdf32TuDZhFw+lZ?=
 =?us-ascii?Q?RZTqVMbQgFgvfwyfg16mSONA38xA8UXcC/Ui7FZ4Un2Rs57TREGRmKS2q2oH?=
 =?us-ascii?Q?MD6OKgSUX/4IIIaS7+Tn+rgBcN8bpunWfNTk8PdkkEktG98undqSwLWCpjQU?=
 =?us-ascii?Q?o0dE9CAUjNx2Fo9EN/pzEi+IUAQ8UECGk9VNzklokA+9ozOlSy5Xnyjdagqa?=
 =?us-ascii?Q?nARqS558KRsDZeyexkoz8SJLnTe98uOAM69ZdmtaQ7A8dhh7XhNqpT332z1i?=
 =?us-ascii?Q?ESBElHYVZJRae6hLs1G7cHnlAgLojVky8S1dQ/aMObcAH0OJa+TewtTMQ38n?=
 =?us-ascii?Q?e+EWE3oYxCwaX/Ilty9HjFCkv9zH7iuEIGf1h4TPiBDpOJeOa5qeNU/7pnoO?=
 =?us-ascii?Q?n/zFfyv17CAxK1VZIYe5FONB86CT7P5400PXP7dk4aPjZDwVyldL2o5R37IO?=
 =?us-ascii?Q?lg2psPO+jl1Fh/Z24iqqRwcTVr4pi99WkZEoPmB0ufYA/QJJ7ojjIpUxqP4w?=
 =?us-ascii?Q?rSFQ0SyLfz7nSfJXpw3UbvsfPYWMu8kn07AWkQHcGilIjb21tH9vOQltE3NN?=
 =?us-ascii?Q?N1U/91tdwdQVBMUR+qYCCKlMg+OyTX6tszhxKIfQxNxJUzXPcfw2rY5yGwxK?=
 =?us-ascii?Q?uA23IkR7spAwhw7wLtx8tCEcmc1pXRhDDAwSU2lSQggO3GHAagbPc8o2Tf8X?=
 =?us-ascii?Q?ZT0g84e79g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dee1bce8-881d-4b1c-e533-08da4df0b84c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 10:29:10.5570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OHz15dJx23ARXboTD6SmUyJ6bM168NnHI90PpvXkPidTKoiMbOnMS1RKSzG4nF7mO+3iCAoNZ9qYCp+fHubsDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2683
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Tuesday, June 14, 2022 6:14 PM
>=20
> > From: Christoph Hellwig
> > Sent: Tuesday, June 14, 2022 12:54 PM
> >
> > Every driver just print a number, simply add a method to the mdev_drive=
r
> > to return it and provide a standard sysfs show function.
>=20
> I didn't get why not simply adding a field to mdev_type?

Please ignore this comment. It's a dumb fact that available instances
is dynamic especially when shared resources may exist between
different types which cannot be generalized in the core.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

