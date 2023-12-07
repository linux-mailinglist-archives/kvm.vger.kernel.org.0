Return-Path: <kvm+bounces-3819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E449808207
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:39:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 492F8283141
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0831A29D;
	Thu,  7 Dec 2023 07:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OcYvH9RL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDD7137;
	Wed,  6 Dec 2023 23:39:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701934760; x=1733470760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z8RdrovrqOwyxQU5Db+axbMO8jCi4igaUyV0et496rk=;
  b=OcYvH9RLsbzVOnnfyytmArXdDyNycf29UBZ6PYH50sFHHuyUv6Me5Z6+
   arqEbOKjMCB2TWTtXFk/5bIUIrS1QBYwHCIM/Mgv8D+Av8CR6rUXHeGx5
   gijQSw3Mz7w7BCgTyIamZR3oLbIUTWCQK9WFkCotpVnNaIn1Z3flGXdXF
   o8lLvP0brMbFhVdCSqZ/5gccoEj5udjS5g9JfMAFLOUmoOkMW8rPAudFH
   p446chBixvuFWJ7MlWapHERrObL0GoTHiQGuyklNQMJm5jXicAB7AKflv
   SS+tl+wZdef3RvoUI1Tv1EYPQauAFxYTTAlskFxUfeK5zxRwN+MQc5q/H
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="393928005"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="393928005"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:39:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="889653497"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="889653497"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 23:39:19 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 23:39:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 23:39:18 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 23:39:18 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 23:39:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKzOiYZSFvdQPkyEn+7BmBhApZ1MEQUgNffgt7zvSJvDbQ5gxf3ZKeFW7UDphSAKtu6HQUoD2RyrKRJP8FB5mBZMBxrPhPgwqcg4I5037X0eaFhdg//UiSBYCU7WnkRuGqeyUAvOpBfo10/6LNEym1ttKjvkAwCMQfIdqxmQnyBGcnCXPJn3h3fe2isMzkDRMULHUjuxKQRs+DwaGzNCY7oP9ooA03eLeT/Zce41P/hZ/3abHdzPp/XvDDSHfQORJl8HUuvBY5Kd16pPlQuyqrpggPKL8lj7qCQnhZtz9n2rTx4JUB1uM64IHcWboV68KvTEioKLUAU+SDUkGzzG4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ejve5QWGHf2W7fzqYv4VRrUxTK0fgz2M786qIWmYECI=;
 b=MuC2D20V5vjHnQFkK8uKez8TcuVKdGGTASxe+nypRbhl7gUa5tRNRIhAqWQCyADiJt3Ot2iECsPS9Um/ouqc95kUb7aJSBiibTrC8DMeAKmCnlmRjT1QSu+fiEvrLTb05xp6QPXwiwqMroLMluJgMY9uF2YWBIQa9kzxS354l16EVJFcOv9E+yaZ3GgEjO6FQlHtPyKH/z+PCaEKbTp968uhZXg4ePE54D1mFyUTQq2OKFuiQ8hVBrZOyNuaZVWdUR3BZJ/IKa3alOTrpoawmd5DeNPJQx7gJA1WOMZbK4YzKl+NOazYsZewTFwBw1Nxp63KfSOMrtroiaseS83xCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB8261.namprd11.prod.outlook.com (2603:10b6:806:26f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 07:39:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 07:39:15 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Cao, Yahui" <yahui.cao@intel.com>, "intel-wired-lan@lists.osuosl.org"
	<intel-wired-lan@lists.osuosl.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Liu, Lingyu" <lingyu.liu@intel.com>, "Chittim,
 Madhu" <madhu.chittim@intel.com>, "Samudrala, Sridhar"
	<sridhar.samudrala@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "brett.creeley@amd.com"
	<brett.creeley@amd.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH iwl-next v4 06/12] ice: Add device state save/load
 function for migration
Thread-Topic: [PATCH iwl-next v4 06/12] ice: Add device state save/load
 function for migration
Thread-Index: AQHaHCV3cVjavNpjrkOBq6KcuNaSx7CdiISA
Date: Thu, 7 Dec 2023 07:39:15 +0000
Message-ID: <BN9PR11MB52766670994F9AD205F16B278C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-7-yahui.cao@intel.com>
In-Reply-To: <20231121025111.257597-7-yahui.cao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB8261:EE_
x-ms-office365-filtering-correlation-id: 570e89db-ece5-4967-202b-08dbf6f79d14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jnD3ocwrDKj/lXcnPsIbUx8lJEQRvlv2p12JSC+IlXl5ZGdaj3m2jle6i+2g9ItCdBir9OjwhbKZylIqyyOylwMdBxc4HkemedZB8TO0uiEq5+9TMgmlq+1mcB2F8/iUkej2I3vaciZMpOIY0jCfcahwje0tmsUOajKUjIc+3gMs7YS/RJj3XHZott2ZdAnBEfoGyGSne/F6YB/VTxG7L7dIAt46H4aQkzghE0Rp6xemm9KvTvqLjjlJOzUU88QUw++1c1StQHuej2LZdpY57UZKspErYG/CWl0T2He52mLLl/gP3ioy3yW5qWr/xgB1k+I6WFklG+dkYpOin6OccTF92urr6m0BOaYdiI83n18iAAf3qSMXEqfo+eupz0QPrgfJbdS75kTI9jIFHSSMl1lFgUvWtCarGPugWStSSd8/TQVFo0HODjkDrLdfLE5EftidYoTH79HjyFAd82l/0cc94H2Rxp6gilTCyMgidaw4Rufcnb1KEY0Fw4RTL7zNC4TOacHX+oZNEGYFS56zL/LziTwC4ZWeYfkjrnKnsHNYwYiRmnwGfoctWMZboWQOsEPCui+QWxGN9SwNYVkEvkeG8K48d1omJn+pO+vmo0xyCWtrQzKr8IYMl6AL9WYo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(396003)(136003)(366004)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(4744005)(7416002)(33656002)(2906002)(64756008)(316002)(110136005)(66556008)(54906003)(66476007)(66446008)(76116006)(66946007)(38070700009)(4326008)(8676002)(86362001)(55016003)(52536014)(8936002)(41300700001)(5660300002)(122000001)(38100700002)(82960400001)(83380400001)(478600001)(26005)(71200400001)(7696005)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sIp+VpYSyA26eWu9aofO/SUpdJ6i/wvSYeJwHkZWVTdYMrZHuovaWVNXf0ML?=
 =?us-ascii?Q?kGj8NjCQ82LrxeFp3Jd164SmLCtWBrtsHC1gViizgMOMQxkX/OPEEMybXwc9?=
 =?us-ascii?Q?M5j+deA7Nydvvbk/LTJaykVKvqq2HDRK7Qgthnr4ga5/5oy8NvaEBoN0bxEb?=
 =?us-ascii?Q?G9RapggNTcvcXarJ2CZnE+cBsHP6CADcSewRKV4fLHW2WS36TXEZ8Qj6CJd2?=
 =?us-ascii?Q?sXJHocpYg+JTYSx4Q/zbc2bf2HLhqyhtl0umhJ+Ow9j0NwqOLdIidojMPhoy?=
 =?us-ascii?Q?fY23eZW/XKYZHVmqLMEcu96jsyFerYMWUlyGULc7nlxuQ4oOet8yNYQwNhUf?=
 =?us-ascii?Q?qI/W6tsjAsduwmSncGEk5ooS3I5PrX9gdN1jNsjeAN83dMgK6I9g56GMpu/W?=
 =?us-ascii?Q?4U6fqMmrfMEgYT5laK797XaF9bYDbWzPydohzeihoBTUQ0aDruy9lgfxyTAK?=
 =?us-ascii?Q?p9od3SmhT04uMQOb4mNVRN9Ri1DpHK+kyhHpfpneVDgbOXkYZYzrkJcEqbYu?=
 =?us-ascii?Q?uJ44cC3sEzzAOZ6SKBO+tuaNiPGWH8pYRPdLisM2k+vIVmR+s4NjkJrHdysb?=
 =?us-ascii?Q?IGA3XY4KiBW0OfuyyucyIeHOxB/m2nRzumMy0LI/1bA4nm7OjXcd11jbwkts?=
 =?us-ascii?Q?N2jGmpzhIWZN5C9zAa+C9pOD60ezigSFcDZR5VQ7qI6OPuDbsHmTX6hRu2pC?=
 =?us-ascii?Q?CobYULUuxAxQ1NcRmGS8aNZ7sq1przqujQ++xa4/KZyRwBSbNrBudkl+AnRo?=
 =?us-ascii?Q?+hENwdUCfycU6LInHuB4yuKL+0OdjtzFlq4JWtuGtTdv+NiocD/U6AGLxYAx?=
 =?us-ascii?Q?eJf9G/hPrM8K90OA8PxudJ0YNk1QIjVuJ88yYTGXzvOIF/jPyFAvI8remzj3?=
 =?us-ascii?Q?C6x6NYOGcU+SbyB20WiqjQY2jCD+ewiD2cFiMb08dI3q8rn69CJDjo0/S7Am?=
 =?us-ascii?Q?CFIxiUDkY2EwptmOBbMZF/pAmfS63G+MsriSUssq6qulFKfgxORZgMeoJF8s?=
 =?us-ascii?Q?If7p1oIs2LnPJcdF+eja8hnr/y9MYVEO3yIMUX+JjnOcuUa/eKSdhlWifDaN?=
 =?us-ascii?Q?L8MIS7PFya29yLDIM9yrD7sEPxjJ/cOra5gXmxfPE4OBVm5lhf/YWf52sMCo?=
 =?us-ascii?Q?VWhRtOHJpum95JUY9sVAxLPjSr5Fgg555cw0+9bxmc3FTH+EYdosAEI1Svyd?=
 =?us-ascii?Q?7CMUnj2ntN6kbtHSeIWYxn2W75twTA35ssIE//1L4ypJUO4S8QyVHd9hXA3G?=
 =?us-ascii?Q?SNTms6PxSNTIt9usObHGYZHxW6qXYG7zUoDROf9cbMZ7AB9gUiDnx2I060sp?=
 =?us-ascii?Q?AgRVB0LHBQ6utG9c7lOEr2j2R8a0eYXVcxT7R6x1en9ckWDm2SJrCjUFYPHJ?=
 =?us-ascii?Q?VBs78X/9HyTLJHaGbYnjZg3QAn6KnACLPZ73rSebr68yu4aJzZvT11C2DBna?=
 =?us-ascii?Q?MDkKQA6dNkmrK9tXrSKGlIRhIiMKM/iTtje0u17JuC1irJjaJtJ2LaB+RWOI?=
 =?us-ascii?Q?NvBx4mtGcDeuMIfk+ksYPZGHPASRnU/G3fsimFplTiTpJVPjnNoJ6WdyFJc3?=
 =?us-ascii?Q?820RD9g88z6UcE+Mg0LYVrQVEOCkFCnoUi43EmIS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570e89db-ece5-4967-202b-08dbf6f79d14
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 07:39:15.5465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZA3UYUd0ht3oGnqsGPTBFSKriXlpZ0AiExw15YdrEasmsgqUc+WUyaunXxtKGP6TOLg0VmvidoUblLNSiT+67Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8261
X-OriginatorOrg: intel.com

> From: Cao, Yahui <yahui.cao@intel.com>
> Sent: Tuesday, November 21, 2023 10:51 AM
> +
> +	while (msg_slot->opcode !=3D VIRTCHNL_OP_UNKNOWN) {
> +		struct ice_rq_event_info event;
> +		u64 slot_sz;
> +
> +		slot_sz =3D struct_size(msg_slot, msg_buffer, msg_slot-
> >msg_len);
> +		dev_dbg(dev, "VF %d replay virtchnl message op code: %d,
> msg len: %d\n",
> +			vf->vf_id, msg_slot->opcode, msg_slot->msg_len);
> +		event.desc.cookie_high =3D cpu_to_le32(msg_slot->opcode);
> +		event.msg_len =3D msg_slot->msg_len;
> +		event.desc.retval =3D cpu_to_le16(vf->vf_id);
> +		event.msg_buf =3D (unsigned char *)msg_slot->msg_buffer;
> +		ret =3D ice_vc_process_vf_msg(vf->pf, &event, NULL);
> +		if (ret) {
> +			dev_err(dev, "VF %d failed to replay virtchnl message
> op code: %d\n",
> +				vf->vf_id, msg_slot->opcode);
> +			goto out_clear_replay;
> +		}
> +		event.msg_buf =3D NULL;

this line is unnecessary.

