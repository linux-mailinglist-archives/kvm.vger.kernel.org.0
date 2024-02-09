Return-Path: <kvm+bounces-8450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 562D684F973
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:17:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B66961F23015
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3985762F7;
	Fri,  9 Feb 2024 16:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f+7ldkhB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481A4D112;
	Fri,  9 Feb 2024 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707495421; cv=fail; b=IdRc48qanAM+c2lDx9V7utCzWBlDFcfxS5u4lfry8eMn94j+tl4Jwoya6y8IcFH0CUd+3xzeZt0A5lR3ybzD23BsO1ZhZ+WINYhGHP+SV7xZayyfLyFVBulfvh0G8PLC+WWmUf9VURRyyJOVbZCPwVwaLzP/2S5Wu3PeMXYW63g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707495421; c=relaxed/simple;
	bh=cwv5yXgguS7SqqzvuyXN2kFBJCoXYGJjO0hjU0nJ8xg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m81kSR6IfHB/eIQ7ROu+Q0EOsAFTLN5O6pdCpJMDRNFrddWPQaFRihm7xvTDvOTVvSlzstOK8MLUiWfbE7w1UZ0bacBD6J9NeH8mhzZg0A/2v3N2HTCij715J0vFbJzUTOpf1wdeXinAvxmYhRmYF8EyxQwQNViTSPpC5KDXJt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f+7ldkhB; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707495420; x=1739031420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cwv5yXgguS7SqqzvuyXN2kFBJCoXYGJjO0hjU0nJ8xg=;
  b=f+7ldkhBAQpk3eAjutUvaZhMfOEGF6+0nLA8KWnT1L3EEHa4PU9nBCCf
   /AuTq1+pPORj2SlN1k8yoqxi1QiKrE/MpxDMUPXTHdxZWqumm+3lVnoek
   rOss3V0AKTypVCcSyNg5bk2mjvDJFu9b+YN1zirjOT418fQXi7f3wjv7P
   f4smm2C5asyTYh0o2QGtkVJ/GkjeQ/5w3yHf4LAezlVJd7b/M1VUoLTe1
   ZILPGvOeOyyCX8IB5QyIuZXUBcEFzWysy9J4ITdYhZHQSdz/mNDK6Cy+k
   0aT8q3qqr61bL3SC00OGZVqKk0AnSUqoxDkDz+yr6+CWaWYFCu9D/X4wI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="5307182"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="5307182"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 08:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10979"; a="825176676"
X-IronPort-AV: E=Sophos;i="6.05,257,1701158400"; 
   d="scan'208";a="825176676"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Feb 2024 08:16:58 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 9 Feb 2024 08:16:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 9 Feb 2024 08:16:57 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 9 Feb 2024 08:16:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 9 Feb 2024 08:16:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H80Yklihx66wcABmrUp9ASbkQTepZDwdzGdPg7FgJ7wlrrrToZEcw5GDOmXLIRUSUZ+x4pKzk/nv0i8XmVa/L4KPiCKD0s8UgLWZbMsfPysV9J9p2uGm6tT6t2UQv/esEfYDmzBunEKqKeTGPa2nrDq/Ktl9XhCtwO8fliJWN8EaTLFZBRUCtu6VesGlKZiaLjpowinC3wtat+Bph2Kxj8f52CMzXVQyd1Kb9LU9l2jiBMe332KZ1u1G2qx3BEDIcz5rHKwLPFIslxSwWU/bw/TxmTdWLEamgCmJulB6SLHS2gW7KKbBZFa7iJFf+iWsqhIgHjLAer7zrOOWv9/0PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mInWJHm2+NTlXmdpXUSfEB6PYYO7+UYyxSfSv7splJ4=;
 b=EAciQVxlWsJuVXIsqfbpqUC67Gv2NwIH/iX4Qe0Cc8FFYP8uknBMJE5eFsh8QaXDgSXbT/wOD3LmTSCNVtpxDhs9pRR3YviZ6n6LDBkvSOXoh5wxvv3hrymwlbOfljZPIwlDoeCapDCfr2Ugu3LeOEIKGC0G+tC80vB5P3out3NbzYvjzNqi5OD9FrEEAxmUz09pe17XVnrH38BjnYou0v52ZzR9KmqYW2+Y6mvNJnavQvioqxbpQSXBQsHXuenArJX8zxN6YBKahXMtiPFK0AZK9ZmxjSaWlFIlAD9vT4TZQ0EhsdANrXl1NWPm4HsrQaOC9FjKA0+NxIl7y6mdkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5502.namprd11.prod.outlook.com (2603:10b6:5:39e::23)
 by SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Fri, 9 Feb
 2024 16:16:55 +0000
Received: from DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3987:8caa:986e:6103]) by DM4PR11MB5502.namprd11.prod.outlook.com
 ([fe80::3987:8caa:986e:6103%3]) with mapi id 15.20.7249.038; Fri, 9 Feb 2024
 16:16:55 +0000
From: "Zeng, Xin" <xin.zeng@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
Subject: RE: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Topic: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Thread-Index: AQHaVSVFJ9K0TVMQD0C9btTtb+JmirD92LoAgAOwfQA=
Date: Fri, 9 Feb 2024 16:16:54 +0000
Message-ID: <DM4PR11MB5502F171A3CC886E78DD9496884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
	<20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206141446.3547e4a9.alex.williamson@redhat.com>
In-Reply-To: <20240206141446.3547e4a9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB5502:EE_|SA1PR11MB6735:EE_
x-ms-office365-filtering-correlation-id: dbb2b264-e2ff-4f4d-bc3f-08dc298a8866
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Py4aPwkfnphkxN/vczoW6UmLuLxCFEQk6PuWRhcOh6OIrz/f+gVs7IYGFZOU/UzMRc3tW9qX96eTmEssAOQY/xYh9fJxywVan50Z429a2vDjxTlL5aswEx3MQxllfck/agZk1qW4WDnhlmhJY8kWl60T5HlGyfA4I62cfgFay0nJ12GdcMFn6UWN+wnAuMR/lpPsLoyGBFhirTWhvjjVSzMyFMuofLfl4n6eJjUcOQzhuZFzFuwzWzF7GUoZuy6IBfPGEyTw27Vz6NTYpUldYKEMFZ+rr03qM6S0hcVj7WjYCmSi8/Mxvap8NAcW6l3N0QYPCJ2QuYSiRsNaFYsG/cEa/TgRuI0fC4t5xzM2FLziIS7zSyVwiJ/jZrjEE74VGZStDgXX2knzHC/UDLQRfUMafsNdrRQafsXt/p0Y6PTWgvWLAUSggNomuQEqvptyUjfwux01FmiFOwDmT2oA3w5r0FwCbkJpiOVSBJhe5aNKfU1dKF143pBC2aGXGjdexNKBhXozLyWn+JvWtSHtDp1hCk0un8sWk7bNZDItRopDGfAIvAXkjjln1trPri0dEILwWuUvsMyDm7lkp3vttvc/y38wnZ98YedDgS7gLQJDd7OJ+YpHNWlbceg4J2k0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5502.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(39860400002)(366004)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(2906002)(4326008)(52536014)(8676002)(8936002)(5660300002)(54906003)(83380400001)(107886003)(26005)(38100700002)(33656002)(122000001)(82960400001)(86362001)(38070700009)(6916009)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(316002)(6506007)(7696005)(53546011)(71200400001)(9686003)(478600001)(55016003)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RPP2dLu7Z2rYTEWh9s24dZf0syn6WTF3QFXmvskvq0zow6WVgt4m44NxdPae?=
 =?us-ascii?Q?gosbXCHnQ7yqdySYb5sIF592PkrI0N/ABVUPwgfDjwKd5JY639/zQtsja2wc?=
 =?us-ascii?Q?n1r7rfrSdcQvokwaTAxLQH679qX71vSiX/yarFLvHKkfuz3IQzfEHsEHj+v3?=
 =?us-ascii?Q?6uy5hFXea3VjKHWI/PxcEjX/q5HTf0JB8TKiTT1qDw/hFZWDTap6AkxsLoPP?=
 =?us-ascii?Q?qgtIAPoLdraK3nUBcYgbFHbMxMClIr8tMJ6K1wNpPOylAfcgJsHX4UA9079x?=
 =?us-ascii?Q?xqU+po9jKzE00YOmqBXOSWSbnsoxH/bpwY1BM56DG7OlAIHa0gMV+zLAvZ9q?=
 =?us-ascii?Q?KTtGUV7QxFOmrGo4gaSy1trG7INpIWAO+jaW1+wbjZhqSf+QRLr6+isUQWyN?=
 =?us-ascii?Q?BNu0T1EEh2Da2gM5cwWHuEewsfo5oxoBOc2qFuGPfMvEylAOb8RAxtZSMQKW?=
 =?us-ascii?Q?eu1ROtTLzC5j7svUhGJBu3kiA8RJDBFkiM5l2cx5fp5FxlOwaEu6F9EroJEq?=
 =?us-ascii?Q?rUNew9VheAWmtH4V+51MKzb6XImT3njauyaZrZrTBIijcfnc75GTldslzkeh?=
 =?us-ascii?Q?32q/2/8uSbA2uy7LVYVCg72u8ev0ucDZz8U5kZBDspz2i2gmjr6s1lp/UFpI?=
 =?us-ascii?Q?9EnOGph77vsya4xwbZ73DqFA9jj8cnvFXWrlLlXb931i2mxkQ6MN2s6ILvDJ?=
 =?us-ascii?Q?ORHZd4nVLC3+Mv7cigiMJWleIyUC1FgzlIZZLf+/3moMkWBdx7zqm3tWHPPN?=
 =?us-ascii?Q?xeRREvM5QjMZJXrLwJOqpQEg4Yp1SrTPsrm69eercM6Lr2IHL+NNDbgp2xzH?=
 =?us-ascii?Q?nD2DLB04zyr9UDJBejH5jWF/gSUPuyb7cwJySSSGXiW3PilW0nEQ43kBdcq3?=
 =?us-ascii?Q?8RLio8Li/xUq5Tjpev0tw7jk2zYOw37CNu9BSZ/oyuUBEzob49jSQh4lArSd?=
 =?us-ascii?Q?4thgI7/PB5BFXJgCRzvUZHH4SmVhOv1G/+sI9zOaFsdZm4p5MBrP8uNwYpWj?=
 =?us-ascii?Q?gQqbvYIOYYKix+nIuBEDjpmRujJKi1/1KXvqIifzKrPyn3z/PxLhviJ/v9TD?=
 =?us-ascii?Q?hrgWCJdzgID6xB+PidNGOSAhSWLFT5QuuwQep6iaKPP0kFbVMtG0MaII3Tk6?=
 =?us-ascii?Q?ei759tVvFu0InCs1wmRhSTa6Y6jcv4UBIWEuHoFEJlp0FU1UZNldOwVBP8gl?=
 =?us-ascii?Q?63VrgLk7ISqPYuzc6LcqGQCmsPGHKglWDDsP+g2Viha60sXK01FAlcta7JyU?=
 =?us-ascii?Q?vJ9jWLrWSMyWv3eg8KbV8EOQhNKhpJKibL7poPVizcdmutEIVV59laoT42Ik?=
 =?us-ascii?Q?3OmMkTLWaxfye7JAvCpuJejtagK8EuiytxHeRGR22BvOIAG5UT1Ce0/FOmQk?=
 =?us-ascii?Q?e4vJBlCsmwQsv03QbchvGKyqzZ9ZQMbsK5i0k3wyBdt2DNYYjSNlxAOkEC64?=
 =?us-ascii?Q?BXApN10BBxLw/sZcLT1Jonscoj7PZ7aoGYXVDdpcZ4/qFiFQ9LaljOjlXNqy?=
 =?us-ascii?Q?IWwv+ZDCU4SPcaRBhLuO/P6qE7pns3izIWUefgTmA3CpdH5gh3jw84jj4Y02?=
 =?us-ascii?Q?sf3Bu0t9lNrdOk6/NhDkyVGkQDSinEOFvar57yK2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5502.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb2b264-e2ff-4f4d-bc3f-08dc298a8866
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2024 16:16:55.0054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P6ZwFUeUcBSG6fXXZ1JeaelN745NHtFjrbu1uTUgdhzNBt4IJ8hEKG3lN8xNnLuoJi9cdH3rKMvWxeQ3udR3Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com

Thanks for your comments, Alex.
On Wednesday, February 7, 2024 5:15 AM, Alex Williamson <alex.williamson@re=
dhat.com> wrote:
> > diff --git a/drivers/vfio/pci/intel/qat/Kconfig
> b/drivers/vfio/pci/intel/qat/Kconfig
> > new file mode 100644
> > index 000000000000..71b28ac0bf6a
> > --- /dev/null
> > +++ b/drivers/vfio/pci/intel/qat/Kconfig
> > @@ -0,0 +1,13 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +config QAT_VFIO_PCI
> > +	tristate "VFIO support for QAT VF PCI devices"
> > +	select VFIO_PCI_CORE
> > +	depends on CRYPTO_DEV_QAT
> > +	depends on CRYPTO_DEV_QAT_4XXX
>=20
> CRYPTO_DEV_QAT_4XXX selects CRYPTO_DEV_QAT, is it necessary to depend
> on CRYPTO_DEV_QAT here?

You are right, we don't need it, will update it in next version.

>=20
> > +	help
> > +	  This provides migration support for Intel(R) QAT Virtual Function
> > +	  using the VFIO framework.
> > +
> > +	  To compile this as a module, choose M here: the module
> > +	  will be called qat_vfio_pci. If you don't know what to do here,
> > +	  say N.
> > diff --git a/drivers/vfio/pci/intel/qat/Makefile
> b/drivers/vfio/pci/intel/qat/Makefile
> > new file mode 100644
> > index 000000000000..9289ae4c51bf
> > --- /dev/null
> > +++ b/drivers/vfio/pci/intel/qat/Makefile
> > @@ -0,0 +1,4 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +obj-$(CONFIG_QAT_VFIO_PCI) +=3D qat_vfio_pci.o
> > +qat_vfio_pci-y :=3D main.o
> > +
>=20
> Blank line at end of file.

Good catch, will update it in next version.

>=20
> > diff --git a/drivers/vfio/pci/intel/qat/main.c
> b/drivers/vfio/pci/intel/qat/main.c
> > new file mode 100644
> > index 000000000000..85d0ed701397
> > --- /dev/null
> > +++ b/drivers/vfio/pci/intel/qat/main.c
> > @@ -0,0 +1,572 @@
> ...
> > +static int qat_vf_pci_init_dev(struct vfio_device *core_vdev)
> > +{
> > +	struct qat_vf_core_device *qat_vdev =3D container_of(core_vdev,
> > +			struct qat_vf_core_device, core_device.vdev);
> > +	struct qat_migdev_ops *ops;
> > +	struct qat_mig_dev *mdev;
> > +	struct pci_dev *parent;
> > +	int ret, vf_id;
> > +
> > +	core_vdev->migration_flags =3D VFIO_MIGRATION_STOP_COPY |
> VFIO_MIGRATION_P2P;
>=20
> AFAICT it's always good practice to support VFIO_MIGRATION_PRE_COPY,
> even if only to leave yourself an option to mark an incompatible ABI
> change in the data stream that can be checked before the stop-copy
> phase of migration.  See for example the mtty sample driver.  Thanks,
> Alex

If the good practice is to check migration stream compatibility, then
we do incorporate additional information as part of device state for ABI
compatibility testing such as magic,  version and device capability in stop
copy phase. Can we ignore the optional VFIO_MIGRATION_PRE_COPY support?
Thanks,
Xin


