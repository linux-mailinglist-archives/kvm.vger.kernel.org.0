Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84C763A2C7
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 09:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiK1IWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 03:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiK1IWK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 03:22:10 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DD91705E
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 00:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669623728; x=1701159728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8svbkZa8N5ZBMw8vW0yfj3FGCs7ntPyaHAFAfVKBNqc=;
  b=WU+/Am4qHmHepmSCDZRoTK3/WEYlAuictotTZx1PBOkFtYGFBu/yL0LA
   MPo/cDeah3GhyZaDxWjILClWk+raZMUXnpfbhu2gGzxPUuNB/IsqKB1hz
   9wannRBME+Z+FDxQ4XxuuLtd0O0ZUFoZotWcgzZzPZAepEumS/S6K/R6s
   7Ww0132N/rXmu8P265a41VovbNlo6UCRiRyMEBlvimdh4As2Dd6MQ+cTI
   9lTe0qrWtVACrnctkA2fsAXjSLHFfrVe36iW8Gt26o6uQRRPKXsBro5J+
   fgwSyxsQg3ZHCV3JCJuAF95IdLIWspR+Q+WGYh2kSKdhDSin9Y06HpKwU
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="401065357"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="401065357"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 00:21:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="888326270"
X-IronPort-AV: E=Sophos;i="5.96,199,1665471600"; 
   d="scan'208";a="888326270"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 00:21:59 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:21:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 00:21:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 00:21:58 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 00:21:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4Q09jpaFAYXt951/xmBrvSi28f9zm7I0/E+d7j2KNTILGNmbNndudDA0641NiwAHJrPOOKc7QSDG3ua9UxmnA4JL55sdqXaB68nsqwEbiAC4Ns5dTaXJ8Rvp0rtiZTwxLHPlJ8S+oR8KibySiXXIOd0fE5nxAMx7/QJEnPSSj+Z7hyXAeF40JFrpq3JWbfkihVghl+pwFif33JT+L0w8emqUe+WRQ0XpwkrtysUs/V5JtfPqyO5yqVT+6xT6HeAIIkzQTyBLyt5em3A7rbJA6vub8nos02nQ6mwPU5eoiPXE6QJVHNa/BupOEdtoN10JKq73wNDt81I0qG9fG9cQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3e+cXtYyfheZUepaxoPdtrgv8R5aCpbit6JOYKSlhY=;
 b=SvWHHi7cezFhCrVx5UcYrbhcBifvVnDv6QRMRHWdYoyQCmnHF0nRuotvI0K7zzhMEsBxe5JOCzKPMJZZ6pWej/70blUSN2yURIu+2IMC2rYmeRnVhc0FAoyDyALCWnNinI1Cvsck66V1Kgz3lICcHxJrOD6ouhVhwOwiL9Fdhc0X/+MSEA4JjKbx4mzCow4QFgs+n3xtAhM0lNwaq0OReRXcBXZlPrIVEdxwTIUbYEdp7nt+5j4prybOG4/QpJKCrraMJKZbxHC/m+MHrrukE219BFvPQ+cmMcYlrKOCTLkAQMG+3oDmMzOUvt6p0WhZrm0YuLxfojmcx+DkA+XaeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6501.namprd11.prod.outlook.com (2603:10b6:8:88::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21; Mon, 28 Nov 2022 08:21:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%9]) with mapi id 15.20.5857.021; Mon, 28 Nov 2022
 08:21:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC v2 06/11] vfio: Move device open/close code to be helpfers
Thread-Topic: [RFC v2 06/11] vfio: Move device open/close code to be helpfers
Thread-Index: AQHZAAAZzf0hQRTrk0qVZATW2c/0k65UBJVQ
Date:   Mon, 28 Nov 2022 08:21:56 +0000
Message-ID: <BN9PR11MB527600CC442882CD40563FAC8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-7-yi.l.liu@intel.com>
In-Reply-To: <20221124122702.26507-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6501:EE_
x-ms-office365-filtering-correlation-id: e9f40c12-6b29-4708-641f-08dad1199d23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kdzVrBtOKqxLTKNl/xeshh4cpDgOkrDxtfY0tI9aEnDaGLn+YAh+/8HL+MhkmW2fhq+8spuqhLCaNxagJnRgifFMBK59Fsj+1W/rgirRCIVD4ba9mh/pMPq0vonXRRtsF81GJA/0sBceO/JnrIoaRMtZPsZehWtnXgjgTER7gaAKUTRL6q5afnuueSNpGfwa1PFNjcQyS/uZKNwpXffzmaXA6qCwmrXmqZBS+pkLHLKG9mo2QOOQfnpaSl+uPQ8yR6FMJfma28jM0I+lQZZEs5qyPc5AumQYc3GPXtxaSohVC64JyfrgiRF9hJjOtcKttEHqqhcSXWs2crfyXszYQTQE1XTK+DmxSfeGgsCTG/MYgR4jBnWyHLFudjb1cdi2T40hOriDFakPSqqOhHdBohM0roxy5B8MmbnrPmn0JQYBn5c1JcbyrvOZZocG8vx71zt80AtgFwtSnKQRRuJYlYOt/VG6ke/zlBF6EVcZd/xhz52G+dbDOj2MJnGgBlfUHBMeeOl4kSaMA71dBAGQjSZJ44Lx9wBf04cx+9KwKNCCt1WrucxeX/EMXchR1iA1TqFSGk/GzT2uNo60k99wnlhITeXOl8AAivbEtCAQMJZKsfpmRTn+MhhWmRGceJxhKcSv+b2wGmr4Qpe1zIstQPhRoOJNX8fqE8KpH6vD4DUG2D+XlLgFGg/pT3qH8p0X8n/6xJjwu3/+qVMJ0Utdkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(39860400002)(366004)(451199015)(9686003)(7696005)(83380400001)(26005)(2906002)(6506007)(478600001)(86362001)(38100700002)(52536014)(5660300002)(54906003)(110136005)(316002)(122000001)(71200400001)(82960400001)(186003)(66556008)(64756008)(4744005)(66946007)(66446008)(8936002)(66476007)(76116006)(8676002)(41300700001)(4326008)(55016003)(33656002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qYnih+8sYNH9JNb16tMkhGHF0H1dzobamAB706+MPtH1zAlT8wG8y7BtJlOn?=
 =?us-ascii?Q?UnY2Fr1RVDPg+aAMNjdRndYyd3y4A0OxeqG99HTWhbcFz73YSSYnlnaQTdV3?=
 =?us-ascii?Q?JCjsU6Hx6wP5A/y3XARz12SBEMoyFuIFASVEX9VmsKx5U5yeMan54p63u+Lm?=
 =?us-ascii?Q?kxoak6Xba//Vz/WLV4nooe7/iL04Iid/k5zdK5HdtUJyRKc7WHOm05xeLXjL?=
 =?us-ascii?Q?LpI44ZUATJPoyAjH+L+AS3m0hFuB/ODSvkEEcx6yKJbR+0miB9soHq3fcRjr?=
 =?us-ascii?Q?dzlwU0dkIgovLuKPcAoL54Yv3iSe724+WsbvsmNKgZO+uAatAxaXEJOkNL8z?=
 =?us-ascii?Q?dByUwHKO/eJLKEtOWM0qZ3FZE+Is8clHTt5eQ0LagWNayb5iA9JYW6T6teLX?=
 =?us-ascii?Q?DmawY2kDCA8IsX41sOsWWVXMYKgs60V5QRNXvoG5nNzXc9SFg1UJ7Zi8fTuv?=
 =?us-ascii?Q?jOmqG4MsUsClqxHJ9DrBsjO4SOO3Ee5SBQX1FDPK2Nial7ZgpwRZHAhDYJTY?=
 =?us-ascii?Q?xJevdbB6tqEopNUObZgTigxlCIpPBTlw02GxXsMVbjcFjTrR//3In4NQUysc?=
 =?us-ascii?Q?XlUyoutK2heceVv4yQAnUHD88WGuQyhkxSXdk78xHJnvpLeKaK6iCa2pY3oN?=
 =?us-ascii?Q?YBBUe6tmsDh4C0QEHdcdOih52lfKfssfocnG9wDqxtgtNVwUy8qslO/3VkPa?=
 =?us-ascii?Q?eXCqOER9OnCe3jshGPzcwqOeNgIP6dFd3aHaOFEGah6XbWOezhPoyXK3kN7+?=
 =?us-ascii?Q?wKc9kgEYepO1fVdb6pD4HPgKreld7KwxJUlnU0uQSCoOxjlyTztVbZ3b9p/O?=
 =?us-ascii?Q?JE2RUrRRIhmySzIsk/tFqqKFYZJX80vRKbwMcApIPskcDeSjoEXlMwxAmzCl?=
 =?us-ascii?Q?ktRfkvXdhaxPC0Xg+j7vfgc/twq/Soe6JYR9CXQ4pXrbMfg9IfYGESwigfr6?=
 =?us-ascii?Q?ZfuyjO2if2HH0uw1Xb43laksTZp7J+tZOcI6Dsjzi+Jp3a5q7fwsgPkMeU2C?=
 =?us-ascii?Q?0mB8A1djsQ25QzHFnEzc2agy3SC3oNTgSGXHGQMScd6OAPY9xJx2X7IuW6B5?=
 =?us-ascii?Q?2+FACTcJfTwHpGmRaw0Pb/kxk7d07Hj1ZNfJMwQbFRKETqtH8njLya4MSyzD?=
 =?us-ascii?Q?v4l9FH8p24xXWSKcWT3uEW52YJfgAyuRWZFXi8XtUKrooxEIPKZPE3Kh3izg?=
 =?us-ascii?Q?BkSgcH5hOGiVOCnJf/pe3cT6PJSaKizGKfdrKJikVhyCPY02RUy/lDG7qDYH?=
 =?us-ascii?Q?+PXFLay0j7L3g/X41IY7SGg5qLzWol/R5VeElwHiP1gfsoWPS4PdCbAIgDnT?=
 =?us-ascii?Q?2SJRPGbzJVtOzNwG9JWd5DacMxM+X3frnZIA5vgQkjh0sSZTa+0K9ZJJBBU8?=
 =?us-ascii?Q?5XKevi0wSO0E4+seQRDovz2YVYJS/9+m5MxE+9MbPbnYkQ9uCn/Jp5aL29yJ?=
 =?us-ascii?Q?Of6fFWcNUVoCxh5iHI4EXdO3MtzSB3KoLzX17FR0aiEdQmdhn7GdcwWy5XSj?=
 =?us-ascii?Q?1rkpQqxYLtMab4wHIgiy1bzj+tzL+tqESGguKvgA9kvncIvbdT7Ryk+EPGiu?=
 =?us-ascii?Q?aoEzYrgUzyJpJVvvhyPGnLl/qMRBTSSe09hgj6L9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9f40c12-6b29-4708-641f-08dad1199d23
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 08:21:56.6451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RfC5W4b0G2R0Gbn/fStbgzAKIrfSKv0oXDoR2YzN1BqYLCFHcgrDCFQx1UmK9vDd1ZAEWggo3Y6cTabsCj5ONQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6501
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, November 24, 2022 8:27 PM
>=20
> This makes the device open and close be in paired helpers.
>=20
> vfio_device_open(), and vfio_device_close() handles the open_count, and
> calls vfio_device_first_open(), and vfio_device_last_close() when
> open_count condition is met. This also helps to avoid open code for devic=
e
> in the vfio_group_ioctl_get_device_fd(), and prepares for further moving

I didn't get which 'open code' is referred to here:

> @@ -918,7 +935,7 @@ static int vfio_group_ioctl_get_device_fd(struct
> vfio_group *group,
>  		goto err_put_device;
>  	}
>=20
> -	filep =3D vfio_device_open(device);
> +	filep =3D vfio_device_open_file(device);

it's simply a replacement of function calls.
