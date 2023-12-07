Return-Path: <kvm+bounces-3817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A328D808201
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 08:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5981C283170
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 07:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690D719BA6;
	Thu,  7 Dec 2023 07:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmUGAYHC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59655137;
	Wed,  6 Dec 2023 23:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701934409; x=1733470409;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0wOsbgOIjHKvH4j5ffOv0uEoEk8d4SlIzigy+JmFa7s=;
  b=PmUGAYHCe+NvCM7gNPCVmel5F6C5e1TANvzas8fg1DwwafFXgCFjFSlV
   kBVMprVi1R8JrBurlAyYKNIZ27iv6mryKv8GbMNltpYsruiNnRy5LyqUp
   B5w90BSTzIbU5s21c5oht3wo3Jr0J+9FvVDCEUvEqMiLF6tTckbrhijcD
   kfejr/Rx7hzBqyGd4x9+8TI3XAYk0cuBRJ3gm8HkMS2BUakTzogT3bPMd
   1gnPOgORIk0qsH7atalDg67w4WGe4O0hLntpju5EVvdi9tbfau6KHChYb
   eIwoSisl17sKDD0P0O1NWdkROqKigETmKgQbxSTmz4IFB8mN6WMu5zruq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1261982"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1261982"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 23:33:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="1103114800"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="1103114800"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2023 23:33:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Dec 2023 23:33:27 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Dec 2023 23:33:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Dec 2023 23:33:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4OX01SKwORtM7orhDT0MsQDGFeFnKbQ7usV/wTjXEjhcNG2wf225UljtpPvnfMTz/vHZNRpnSSkyrmEzetFRzYAc7q/FZmf0qNcvplwHsmX1tNnzLeVmjNYFfQLdDEX/8rQ+uW0OM4OxCw1ysm3AgNxaO3W3E1MKt2tPhDg7+GITR7ju/WEPYRAz7NkqyZRdg3rHexOSapVqUcvFa99Ey5/L/9DSz/J3JHUxYSgfNCQO02MfA46FfP5RgXUgoPWTrxsSQp1WZASHtNH/7r0QmnGQdwGZ9ZY3lFB96lnVONPOH/CceuZWVrIhut+5hAUeDbXWSq9wMEfoundCD4DLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r9hoYd432xSK+lO4BPnfay6MdBGuSNWzr/UzK5TOfbY=;
 b=WhBlS/DsVr3VFoV9rCV7NZxPjkhFnEMQWf5oTwNjqqw8PkvHDwXhH27y/F0+J5vF/iw7z1kjV3Z2hdo+d9WA+vTNCN41oWKuxEF4egPazEJy9mWbCEzrhfjFsDPN3hHCy1PmOs7pp5eREkSCQ2f9ar64BlNlAUqiJyzNvLdtzmvMAva/PXExcTE+DLdmLsTQPg9rS5zbZTqOF3oB4m/5K6GotiTLVvIwDkYpUnoN5ujwuw8Ku/ppXHUIiVzV0a4iFxHKeXj/IWd0tNO0k9sQ84CfIb0Uc3coJcnyl8OUED3J8BMFvCeKdytoYOyI+5HRYhGWaBWYmCUReUIoIoMccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Thu, 7 Dec
 2023 07:33:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7068.025; Thu, 7 Dec 2023
 07:33:25 +0000
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
Subject: RE: [PATCH iwl-next v4 05/12] ice: Log virtual channel messages in PF
Thread-Topic: [PATCH iwl-next v4 05/12] ice: Log virtual channel messages in
 PF
Thread-Index: AQHaHCV4Qw4B69T6ykGDP51FdVc+97Cdhj6A
Date: Thu, 7 Dec 2023 07:33:23 +0000
Message-ID: <BN9PR11MB527679098836023AE0C981228C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-6-yahui.cao@intel.com>
In-Reply-To: <20231121025111.257597-6-yahui.cao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY5PR11MB6390:EE_
x-ms-office365-filtering-correlation-id: 7e9dab06-994f-4d35-1c50-08dbf6f6cb65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxRdLOBy1piyM2WwxVyr9hSfvOAXS7J/yn5frhO39MdGjyt5hJV03hsL4gzFHjB6LFRPIQs2FUbRr5p2/uTL2IbcSnCx7A4SkGO8xC4MJSGECMUzaw9ukUgawD63cSXotKvwpJ44qQrnW1SeCOG/O190ioqMPDToeM1IMFgcb/MX3JbDJ85daGBNCFywdHDsHyuUkun0or5+hQFH1NxfFa17l1/K8m+T9wYxa6crRjtF5GVp9jecUF3eEUdoF3sC79Y24Slm7BEqeiiJUC+RwjnnyC5/8gR/I9VSCevEcJ98dvgqJA0ytNtIFCJZcJBy1CBTRuM5wAl20ZfXa3+UlEvCQPzuNC7Z04iBWLwQqlwJeWNf3agwIomWYPQSu9TZ4C8rUdKtjdqP96jEa2YYTnNDNaOsBlgYKRWoN4pWa+SLA6DZLL5CBaAX1aRywOj+9lhmysxeLWFLgbiqPgWowf2RQaVNVEZl/n7+p451iCGPXy2mBt0sTIhqGgFx94SNPHuw8Eqr9juGbY4KW2c878IseQ7K4sdDVTNMNZvSmPU8m0nc5h1qR+iKX/OpZL4Difr+5Rm7HiCVEX+viqEwkPnBRoUkOa7QoTIdRdSO+vA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(39860400002)(346002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(9686003)(6506007)(7696005)(38070700009)(86362001)(122000001)(38100700002)(82960400001)(33656002)(41300700001)(26005)(7416002)(83380400001)(5660300002)(110136005)(4326008)(15650500001)(54906003)(316002)(52536014)(8936002)(2906002)(66946007)(55016003)(76116006)(66476007)(66556008)(64756008)(66446008)(478600001)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LIwAlh8D+UxZDMkOFEBMPZSVp67KOtT4wy3WJSMsLXfO6bga5JNlmS9r5kOx?=
 =?us-ascii?Q?+wdp+AElwMFbRTa2UNnJP8X4rE5Itx5TCxE14MkoLPEqpHVtB6FL/cO3KWwb?=
 =?us-ascii?Q?9lrY4DTEQcAhkHmM1hbUOZgiIHQXyS5KmLiSxubVCdex8sOvZY+na31vABsx?=
 =?us-ascii?Q?f0TCDDMO8vBI1Tl+37xbNwoMEfFtl09X36L7J6q3953tHkhr8R8W96TIDOjP?=
 =?us-ascii?Q?80Iis2BPZbVSLa1Er6rhxVKkQ7nzTi9EIMv3Eqo4UOLLEsrjjh+dQ3760+R0?=
 =?us-ascii?Q?VJnqvbKzY6rVO6ybP2NtNRiEqKknz6+17RJpMZTie0jgQCk4nUsBnLDkU28k?=
 =?us-ascii?Q?S9sBV5TcgtxjN3y5eyAkUaTxM+1Vq2gJIUn0WVIVmkeMMJdyzjcfncm+4WUK?=
 =?us-ascii?Q?c45kF3luxsSCsDLSUEyLo02bAoom7GZazCgEiJsUlbD7DraALD3UWEbEoQbL?=
 =?us-ascii?Q?gIODCSjnAmZqtrV6gQTNeUa1awbUbfRq0SW0Gt4/poG2GPsKNZ7Utejl6Irq?=
 =?us-ascii?Q?vAxHz5bJOvppZEabTyL4+BmvDEBRQ4eHrB3HYgX/93p20lqHxz8XBrZn87RV?=
 =?us-ascii?Q?QudcpEC0pbA7WZmyyusYSlxYcW6g4P1/PjBpszZ2JWueCfI7HqLe5r0NO61B?=
 =?us-ascii?Q?Fqqgx5aYli+cztU91vm1wiW75wSmE3LVRcHDnxiAT0SJ8k9lKpZvPQUsIAlv?=
 =?us-ascii?Q?8ifTUEp36UTC0s7Z7sPm3J6WyJG7KzU6YXA8ZRC3LTNGxhvNbB33bzUu4d+W?=
 =?us-ascii?Q?PObPNzdj67IvnRIGhWYnj39Tpts25PDFBGLOV1ozm2v6K8dma2QQQ8kkA43Q?=
 =?us-ascii?Q?YWXvw4dlDj+CKtHnYaw28aIll48G6nqaAMDrFvjCcaLs+kewAXikMpun1E3e?=
 =?us-ascii?Q?vx0dNXHaf6Q0OQrSVb46paFZcwnfGNqNycQqoOnluDtydmTvttfJdALamqSI?=
 =?us-ascii?Q?sC5zXP026/e6IvhdeWZaR3ApN2Pi/gty4Jc1NFDbc8FR6cx3a4Zmu6dsmLQU?=
 =?us-ascii?Q?V7Ps4JjTKDaIGj+QvxYFmnzfryHn5AMKrvOGBOASebO896k7iGKHowRe5KVy?=
 =?us-ascii?Q?uocrZdW42MhfQo+h4ycYP8cLkVf7gJfggtdXKseBh0ehSZtA8lC+zXk0pUzJ?=
 =?us-ascii?Q?E/6zEwjBWEj2lTZjSJKgMfOAtDTQECYEjv92Fqx7H2LtC2mXldorlCkUI7Ye?=
 =?us-ascii?Q?uWa91qsp1FftFPKrwOdCtxigUCZMZ/1ckH8W+f/Ri5KoeAVcr9ZsKlMA8wFf?=
 =?us-ascii?Q?8fBM7syPjJMRsgikqoo6Lmbuaid4vQ5G8qy1RNOKYgCBwRV7kNsb1/0ESoPQ?=
 =?us-ascii?Q?KYH2FPFARKwC2m1t7OfTw/99HGEgMNbrs1bIVteePEK0yCCxfDzFvZ/DL5n1?=
 =?us-ascii?Q?HqhMbyNHMBWmWxBrMiUymX4YP5UVraC2M6q/Plt+6TUe51y5yJErfquZjaGW?=
 =?us-ascii?Q?J1El8LtJgb/AYrZRAdt/Xu+48O0E0Cr23wyzSWifCv6g4KZI/+n2f1GvCRrN?=
 =?us-ascii?Q?YONGIVs0v34/Z+/ZSPswyw+a2V7KGi56gg/v4owXu52h3++6c4v/wlGEr2Pb?=
 =?us-ascii?Q?R4cePEnqs89cZrVMu/xwMYg+U5ockHjqe+UByztz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9dab06-994f-4d35-1c50-08dbf6f6cb65
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2023 07:33:23.7826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D76KBpT9754FwdyQoFAHlLLc9HptwcP/gntToJ892ViMxtjZxCKJKPzPmy9Eo4722Og5hBKBEeKHIY1FpjTn8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com

> From: Cao, Yahui <yahui.cao@intel.com>
> Sent: Tuesday, November 21, 2023 10:51 AM
> @@ -4037,6 +4045,17 @@ void ice_vc_process_vf_msg(struct ice_pf *pf,
> struct ice_rq_event_info *event,
>  		goto finish;
>  	}
>=20
> +	if (vf->migration_enabled) {
> +		if (ice_migration_log_vf_msg(vf, event)) {
> +			u32 status_code =3D
> VIRTCHNL_STATUS_ERR_NO_MEMORY;
> +
> +			err =3D ice_vc_respond_to_vf(vf, v_opcode,
> +						   status_code,
> +						   NULL, 0);
> +			goto finish;
> +		}
> +	}
> +

I'm not sure it's a good thing to fail guest just because the message
cannot be logged for migration purpose.

It's more reasonable to block migration in this case while letting the
guest run as normal...

>=20
> +	/* All of the loggable virtual channel messages are logged by
> +	 * ice_migration_unlog_vf_msg() before they are processed.
> +	 *
> +	 * Two kinds of error may happen, virtual channel message's result
> +	 * is failure after processed by PF or message is not sent to VF
> +	 * successfully. If error happened, fallback here by reverting logged
> +	 * messages.
> +	 */
> +	if (vf->migration_enabled &&
> +	    (vf->virtchnl_retval !=3D VIRTCHNL_STATUS_SUCCESS || err))
> +		ice_migration_unlog_vf_msg(vf, v_opcode);
> +

... and here unlog is not required. Just place log at this point.

