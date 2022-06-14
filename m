Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78FA54ADEE
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241977AbiFNKGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 06:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242607AbiFNKGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 06:06:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B8428E12;
        Tue, 14 Jun 2022 03:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655201181; x=1686737181;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ea+gZlgyd7F97bl8RibPFK6IWHPiLRq6xVphdhR2Vuw=;
  b=nLMuV9Cg0GpeexR8AL3xBeayJ4O6fCh7Po5t7Mgn6y7SgfvbAfsFoGM3
   wbq6ZxO7vfkSp7kR7VQ164Ik7mGWX06oienqpwgMyrC8eAu9PsYYynMjq
   LuBVS/7Og7+nz+jdoiuSS1YjmGGojGwPtISaHM9kixrh3yp+pBBBw0cqm
   Om1Mao27siD9oBr3KEG5OPH24IaEP2EiynQ/h7Qo8Asufb9gwYjWcgLus
   tIQjDmCEikWXGq0QXqXKqgCBSu6YOV/OnWNeKPb1qt3ZO+KxTuJatW/ro
   UaYpMUWNUtxanajEfei9Bi92sIWmybcaEw+jnMqQepzc7V4r01tkfgGZL
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10377"; a="342536878"
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="342536878"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 03:06:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,299,1647327600"; 
   d="scan'208";a="612165014"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2022 03:06:20 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:06:20 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 14 Jun 2022 03:06:19 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 14 Jun 2022 03:06:19 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 14 Jun 2022 03:06:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFBxJOYX4YRa/fdloGeiGqO4zRpGfg/zxZwcJR5PieAzVuoFQ3yzPQ1821Vqgu6ChdDY3MMYHweAUaxDF2X5uRFwkd6ZWsemumagFdMs8/jqzdo1EhCG9AyVoqkans/9wyFdDj/CEFKkWwJ0LClveW7v+75J+zKnXeELBwsms2iqxiD6daesC1PeG0tI1Et0B50vGD1xqgXTw7aDvScQBCpjH1vrNkiS3t6F4b3r54TLRbDXYVrly+cQFtQG7qRxksCeBt5hqB0o1O5+myOYslSuW6mP/ljg0DQNdfx15LNK00IEaGwsIs+CxfULki5X+I2ivRKii9+8yH+vzyMrEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2pcRj6TwSs4xC093TuHhWKXUfYwCvxIR4t0vDWo32sk=;
 b=mKI9IsA1WBoBi+G3wWaPsJXaR4XUW3rMjYVmEfgMwCBoF5ZFLwb3bG1EgwWF7rQPtksCUsGkD8oi3n9lhqJyvS7Ioc5xACz+1eUGe48JtBJjBm1k0fjjMIgT23zLz3FJsTm2Igink0O0hUPKE05X7hwKMYmfWfRW+Dmw5vWzvFiU2nqZ/O32G2fLAgmVJUd/FeoWgYv7pKNuFhn58UWo2mzHOkCR0d6BNpbqL4IUqgaayTtRg6WmKFbwSVp3jmR5QHKxfQp00IwvFQ6oUNg5qn5MH2jQWhRl8JEgbSqIM7ihG41hqCjsjxfeDIPdUNdrvAY728RBK76aHJPiHYc1MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1522.namprd11.prod.outlook.com (2603:10b6:405:b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Tue, 14 Jun
 2022 10:06:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 10:06:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Thread-Topic: [PATCH 03/13] vfio/mdev: simplify mdev_type handling
Thread-Index: AQHYf6rrtQD9LJOfckCCzJyJEdkBlK1OrGfg
Date:   Tue, 14 Jun 2022 10:06:16 +0000
Message-ID: <BN9PR11MB5276A3DCE429292860FD85F58CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-4-hch@lst.de>
In-Reply-To: <20220614045428.278494-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7dab3c2d-aa4e-458c-a129-08da4ded8525
x-ms-traffictypediagnostic: BN6PR11MB1522:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1522540D251EBB26F3B6D1C28CAA9@BN6PR11MB1522.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8B46V/Zmh+YyGE5Ja8qDIvUoQ2LAiHIfI8LzFU+nxEcK+J31R68ob/7i4p9v4YLpqhg5PIKGhM6FNweN7nbvbYPFcR3nJ/4/Z/fbBFUY7Gc0hy08onQU9jE4ifIimlktSuyTTnWlkbExDO5eUI9DUYymWvL4A5k9jgGB6MTncQShpZ4riueS2d32N3g/CA4HmqxQXTPKXum3pg/9toXu++cUY/OTE6EsQ6e3mEg8JAEQHk/tn/rQffuPFJZyKy8F6F40LCIP1LBM/2UoVdgIwJGR/WXkBkWndB5aNRn5vgalndPAHDw6qwVcV9RjxobokOYEJO2Wk7MFZct4S4DKxQNdvmS6Ui3HKrV9xyiyFRO8xYoJi8f8w8moHUiuDIeTGQeyjkfV8ljjn17nen9SflDhSbxbp31Vyb4POhU4X8wvVJhizyIg+G17xpK2eaaLqmA14a1ukIYpFOxg9F0i+JdVIBAHwEK4DvdhatOD7QLCt4RmOK6FgeE2Iyqyg+f9XyaaOv4tgu3g3VIFNri5syq9WZgnJ0OHDWz/AadcuTn6/rpPduNSL/v9G8VpcXRp4Z9OLxLi7D1Yh1PnG4WPAV1iP+MzKWW8THKVGPF1mm9/XLEVKEsR2kUE0JSf9/JvutAsOb66P8ocp4RBmL3lzjBI6kbYv+T0jsEPlqA1u17q6bC7nIsfHKeokiSmCvrvfqgXeySoK3j29wsDmmATY1VmZzbFqM24vnBsEkOlBCA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38100700002)(6506007)(38070700005)(55016003)(33656002)(7696005)(71200400001)(316002)(86362001)(122000001)(921005)(2906002)(110136005)(54906003)(508600001)(4326008)(82960400001)(76116006)(52536014)(8676002)(66556008)(66946007)(64756008)(66446008)(26005)(66476007)(9686003)(7416002)(4744005)(186003)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UnBzrM60xIQcdaa3e8ctVL6duCM3E6lI5n3zNlozVfuOA3SQW2o1KyQPGdTW?=
 =?us-ascii?Q?CXVk/DhB2FBrPsef8UPICGZNwYkvKdNJkNQEWlgYQ8401wuFWVOO/u6e+RXV?=
 =?us-ascii?Q?9mAuftpSf4vfYeO5VZKOad3QmI4H62ymqD5+DrfiNv0+sdl+MtpG3GhqHbH3?=
 =?us-ascii?Q?TUMxeBq4VMMW7Hp4j9165tggMOnbWCkLtW8P30d9azDiIGw9aPEsT3BwYowe?=
 =?us-ascii?Q?zXbRcgnhHTye7sQhn2VIxpi2KA1lOiZrtnnMtzy4uiZ0zabjmSu4nz3JyJnH?=
 =?us-ascii?Q?rzYpUPGNTTE1YIh6BHwi0bGpUi5AneN/GGsi226U9X9tQpuYxLLc1Vd7iW69?=
 =?us-ascii?Q?jaaI/QcHN8AAuQ02YbYA6OsSQ9v1B9qfYuDiuYUtuxvNwp4huGWTpv9T7QpT?=
 =?us-ascii?Q?IjvnNEHkLamMEz8IqUfMMZsN0duktQmucUFXMBmEdGFcJWtGM9hXTgYCG7IT?=
 =?us-ascii?Q?2SDL+iXmf2y1RfNEiN0wqSSSxlqO+DrdvJYnOShFgzDlSkWBAN6XVv7nWfjz?=
 =?us-ascii?Q?sJoU3qxZdGNAaTOt3XFGqVsrgw2lnLarZoBt5ZgZ7vMoeDTVkf5CPGaP+W82?=
 =?us-ascii?Q?PeumB+GOhfrSthk2wbDagsQmGGhav7pLI0doH6eFOj491q0YS/gvhd3PaWP4?=
 =?us-ascii?Q?JP9eplirT2x5EL99VL/9NYI5nTBof/PUYePp94oRUx976XLH6g8W466B3i6N?=
 =?us-ascii?Q?WsMbgGWs2WeN5vcmhot45iVMpvzezBenpx9q4l8qftv8J/tDVoPj5WOcqMo8?=
 =?us-ascii?Q?ZxgCw143j87cU1flY4rnkhCMduAbu0xsYQr1qPPICZW1lhmTpHrxenmX5MNl?=
 =?us-ascii?Q?4j6jBnRsUhvu8oszR8KXYGlOV3HWh/BMltsTdkBTDWKo73XJ9GupqsjOBVBk?=
 =?us-ascii?Q?v7y/BrU+wZP6qEdaasquExGCqUHbuP1q12QEKNHCpLIefaF6oRz2EZJ0wAKJ?=
 =?us-ascii?Q?T4KPT6C5ABpbIEb3FZtOLwSehyz1v56lGUsOYnEYjaMu2mnBZzB9JPNUvpe0?=
 =?us-ascii?Q?97fhLyEjpu3Ut1RQhakWz8BEFomgysgZYL/HB766aszQZXgLUPYCKlJFzxjX?=
 =?us-ascii?Q?OEMvAa2PaXZAlK9rNWd0iFRpVOwKMMKr6GPUhvr16uuZfqFJLSBX2UpZWWAY?=
 =?us-ascii?Q?+7eKzoWEkiO5PMbwhvyr9+AAHQGJUpic3gLaRQfXsj4GOOPLTygTwnReMORI?=
 =?us-ascii?Q?9PIBAO2N3oBcaHPUcZ53B/lLU+5PsbieBzXgAS8qSoVWlo41MfmvbM3zNxtU?=
 =?us-ascii?Q?5hZ3gRdrkjOEix55seHaOtl6ujb3g9Va8GRQZT7M8PD/i9HfWMY/kvKsAb+0?=
 =?us-ascii?Q?RLKwnttLeWoAzmtBcjc3ZkdRuxADHVAb9rFGzL8aC1uNiCUC5Ke/4wpMt+4G?=
 =?us-ascii?Q?QAaekkYrjlCtmuBbjQSMhOR/sV1bUwViZMZG7sKt03KjODYD2E9s1POmLLX5?=
 =?us-ascii?Q?dQ3kji47EdqQciOI1B+NQb5RyLe1XvX2a6RsYu2faC8+pBWX+xn+RoEqdU9e?=
 =?us-ascii?Q?IV8rRetBAme7eZZpc2Wq+Q4qpH3G3yTtaZODoPn6nSdLJf/S/sz01sfDwacF?=
 =?us-ascii?Q?b3R3wRLo0ZgEzzwRB638C8rudcvEycaW8KH4FUXb2Q+bGMJc3wTm5JgnFkx9?=
 =?us-ascii?Q?+RnnQ5ANJZhKq2rahcdAnyPk1yWDQI+WEDni/vrBEZ36kwBoavcdtVjlAYJr?=
 =?us-ascii?Q?chzdXqdbwpIx/FVzD2DWjBorwm1VbeGSfe/ASSOiFWTWqyUApApQ5gK+efSa?=
 =?us-ascii?Q?kZTJXj/zEQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dab3c2d-aa4e-458c-a129-08da4ded8525
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 10:06:16.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +sk2qrq+VglvJ29rPjKJg/ExP+DQA+iHRXkVMQVhVkHA53f1TfMG9nyFSR/h6MFiWkOuujTySXgIjEecVCRbvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1522
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Tuesday, June 14, 2022 12:54 PM
> @@ -131,6 +131,13 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt)
>  	if (!gvt->types)
>  		return -ENOMEM;
>=20
> +	gvt->mdev_types =3D kcalloc(num_types, sizeof(*gvt->mdev_types),
> +			     GFP_KERNEL);
> +	if (!gvt->mdev_types) {
> +		kfree(gvt->types);
> +		return -ENOMEM;
> +	}
> +
>  	min_low =3D MB_TO_BYTES(32);
>  	for (i =3D 0; i < num_types; ++i) {
>  		if (low_avail / vgpu_types[i].low_mm =3D=3D 0)
> @@ -150,19 +157,21 @@ int intel_gvt_init_vgpu_types(struct intel_gvt *gvt=
)
>  						   high_avail /
> vgpu_types[i].high_mm);

there is a memory leak a few lines above:

if (vgpu_types[i].weight < 1 ||
	vgpu_types[i].weight > VGPU_MAX_WEIGHT)
	return -EINVAL;

both old code and this patch forgot to free the buffers upon error.
