Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BE763FFF1
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 06:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiLBFoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 00:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiLBFop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 00:44:45 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80452D291D
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 21:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669959882; x=1701495882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CzLEat/O08ybCXtrejZTkhQwCin0XdV/tif4g2soqfE=;
  b=D2Kc2Si1WFBJPJwy/Lb7mmMG7JRGUhFXc76CIV+yGDAelu3IniPVcHyy
   wt+fJHlXn4+wFOnhTxgEddLtieW9FNNOWE9EgRBUgiCX0PMlsrS+SLovE
   4aqRnoPRrLUbTFSvxsxS7hiqYTSHdfGYf46zN65YveMEE63V8OuyWG0Ss
   hXp1+Ub4kJRbXlx7d4lV3VbX04nHdEXBN+vQdfySnl6VR+Rap/mmF9fs1
   i7AyEEpGLetWb7tLFcf8cYoYLvu8txsBp8Gv5cHyCknehcN/CLShbPAQO
   MWOumXJvGH8rM0B9/OIvDgbnIAjeIOr1tQDhDeQ+GkiaQWWXfisxMmWU1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="295574691"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="295574691"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 21:44:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="787168804"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="787168804"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 01 Dec 2022 21:44:41 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:44:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 1 Dec 2022 21:44:40 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 1 Dec 2022 21:44:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 1 Dec 2022 21:44:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVLe3+eGeKDFhHNq7hYHKYGUWa/MR56zfuowaHA39rT73ZJ6HqGzr3BcWVOjT1jIGr8QRSJCpuB2gexGmWaTAotpPDIo/x5UV9McP12FKrm/ZN0QiOHuSatasmxrJbBY24N3+cXgoIXoA99joq571Wq3ndIauN6JDj9z3yOJN2b/Y5Y5W7FYD1adt+rQ4NvxI4dCdbkhQFOnh4wGbagbbXRHYeJsLAAmpgIiH++jSD1qBLWYI+9vjsxXqWfw0daw6Gh/bvHS6S2Ra3lnYMEO8z6GFSod4S08hEAx88Fn8gZzxEryo0JPKxQtAfC+1nGg4/U77luc46xG5Hd0I+yhzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CzLEat/O08ybCXtrejZTkhQwCin0XdV/tif4g2soqfE=;
 b=ON8WwPnsJy/ZCocHunfJ/fF5lClVHmf98dJPcITGLRB7wTEQ2PkWys2+7sH3Bbnhgo7MHW55BqCKM6IyGBh97OuteeqxyUzFJgR/bXH0JgeeFYHePIkVBgTAF0/rGHMwAWeZddgiMybQW6v9TVanHeRhhGHnAe0kK1pkop4QjvlvMCmi3sqtRbq1R7Ar4kE5cTRcTx3a1RyuF8Eac921d/WKgYXmSdDw7BgRiZtzluBdchFhGcdQ6p69bHzYZB0uTvPzGhazjuqIRlt+3TKXEyh9hnmjMjmsP2nRWOHpnHlTjNQtEEVnv90EuUgaMRMA0ZurFHv0PB9ogINjEVzaMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4949.namprd11.prod.outlook.com (2603:10b6:510:31::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 05:44:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 05:44:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH 06/10] vfio: Move device open/close code to be helpfers
Thread-Topic: [PATCH 06/10] vfio: Move device open/close code to be helpfers
Thread-Index: AQHZBZUOhMRfTQthY0mUmtG+RVh+S65aFMSA
Date:   Fri, 2 Dec 2022 05:44:33 +0000
Message-ID: <BN9PR11MB52768BAD331C3733CD0D91978C179@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20221201145535.589687-1-yi.l.liu@intel.com>
 <20221201145535.589687-7-yi.l.liu@intel.com>
In-Reply-To: <20221201145535.589687-7-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4949:EE_
x-ms-office365-filtering-correlation-id: 50dd6269-94e5-4e01-f9b8-08dad4284a39
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cosZrfmtARXAYjwtnbWx8+NkoGGc3bqBfBbjger7MI/uudG8T4mAW4V6ydNg9TduYv6CaFQLdTSunHL0tsp2AE2Ci4EnXDbC0PqyJRyy54kktRR+UMuolzYCpXoUZl9Jjkafa2f9AHQdEaeqxnsq30MIESB99XVSYMCjgFVb+Kp6VRfl5z6byVz48bH9BnLE8iqndxzvXJmXqhoa9PLvtvogt2xWqqFKBfMY4T1Utfs9LIOtfOnDwdRHIGEGxivSe/bdE8pSbl4CY6dbptlVxnfzSEYFn++pVS17FI56F0RSuOe4EAE4KFZ/NrTakiIkyPqi1H7sypHJKKx4vFf9q5ltmqbPHwTTcmDBcnW1JJxRUlT5K1hRxldEXI2UJnnGHeKnHuWCzOxHtFIo0hr6qHQ/t/0Ia4np3bUtRXrRVCJ9BsmxiC1qHwDLRnDXDr/HmMi2/5RAp+AVO80zej8ThPl2RKm1U3TQ7XPbccpoYh6exiNilgS4EHf4Gdh5FL46oEGmd9Ojm3xq3/v3TZmmbbyKvHBfskxA+xMOF3OM3NRnFybk2lnQly9UaufEK5UCCDqVOs/FiZcdq1vpSfAG56zFRAnzUdjdk79lRVXHf60LQtUAV4MQb4FHLQZ6PoLGYTLJQ5e1TfqTMdhErWsjQ7kco4s7uCFvjjt0SUu7l5KHbqueFsVGsL1bGXhhm/IyilsRmJq1sGvp/XYIY+f/9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199015)(33656002)(7696005)(86362001)(9686003)(6506007)(478600001)(110136005)(71200400001)(55016003)(38070700005)(186003)(83380400001)(122000001)(82960400001)(41300700001)(52536014)(5660300002)(26005)(38100700002)(4744005)(8676002)(64756008)(66446008)(66556008)(66946007)(76116006)(8936002)(66476007)(316002)(4326008)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ig6bXgUcQGxqpZhHCYe6sFrKXR0VDWqIfKWcSw+v0upypm3XD/3k7kidGW5c?=
 =?us-ascii?Q?hH3tSPBHmWol6wv4rrHxgoNJVQQytnEcZ6IvFIgXnvWCHfA/Sd/fPINzPZEW?=
 =?us-ascii?Q?YwdERhBfc3zt97epiE4otoSreR1L+nTZ/9uebBshIOrEWWaNdcJORwJQo7s6?=
 =?us-ascii?Q?XgXwum4xGuwBcl0TpQsf9tjMm14k8gZJq5b2IaOA/6YUwIP+WrGkPxRjZnzh?=
 =?us-ascii?Q?nd4fYuBd01gIIPYuRVKmcQGYu4zkvtLoVitLZhZm5vGpnyhtmEht99UAtMPq?=
 =?us-ascii?Q?HRVryJiDg5VO2RDDw1DQRL9zNIkeDWVKTRGRG6QD/ycriQYBGw8vWc+2IwoZ?=
 =?us-ascii?Q?VzR8b59EX5d70AT4RYd8fJFlZOR7JkZMq0+FjPj33FImWgkiRrrS6oXPv15O?=
 =?us-ascii?Q?oFiC376/q2ChAWu3QhnAMKT+WhYyLD+EKX48THYSpvxNXaIR9jLo7PSkIsoX?=
 =?us-ascii?Q?Y28JGR/YFZ2RRXB3DxCPSu2Yk9TD2L0ZgNmYwSSXoxSVSR/WZnCpCKW7aADb?=
 =?us-ascii?Q?I2s77M8d1YujaEgSkwmJAEorC66znHKFnP9R97PioTF7A/dIoS0h1/6U1CJQ?=
 =?us-ascii?Q?d+/q8F2p33bPZ4LlhUrWM06lYQfyPzQO5ZuB4Z7+cZPeoVqH0S/fIBsGnWDR?=
 =?us-ascii?Q?LMenGYRWwlcUivz0GMZI+zlRYSsH5eWjSVH28QCqWXRi3xNvHTVjs7bm6WuL?=
 =?us-ascii?Q?9VNKfodlVUnm9kjIXXed0xalbXR6n6EUw9wF6y2HzaebeG/PrsS//JyRo+0U?=
 =?us-ascii?Q?jJ64mZex3+Q08HhRWg8Unzn5ePXAx5VbQpcWORab+TZVCy0TYARC052I6Spa?=
 =?us-ascii?Q?btutQsqb4FNA0Pqs65PqDZ+tOeiXIz1mYRH7KSPusOMbS/NAcl1oDeTMKKpM?=
 =?us-ascii?Q?j02scQ1sIRZNxjvMZW8Kkms5DQFt8QOOf/FFHvPfvGtq5kuJgU2qU/60gPtG?=
 =?us-ascii?Q?wgjmG85MycP9LQzTlZUHSgc9XlzTb2nLX1ULzbEDTqSkWVqZqeIpKjehSTE1?=
 =?us-ascii?Q?4BVIZ7nWSyGQ2Dj7awLGz0StfsytBReVpnGQzpWGNhKQzQxrPOqBGL91KEYi?=
 =?us-ascii?Q?FGReL7o6ltxY+xpgDg2JSUdza0d+2NJp6werWnqap1abzyhc7a/cE96fR1vI?=
 =?us-ascii?Q?DEFeAi/QMX0SrBstF0sAiY/fcPW/K7kadcT+AHml7OdWBicueonTcC2gHZhT?=
 =?us-ascii?Q?eby/o6mXLc68exSQ++EMzsyNfADqpo6iOCGvD8x4dkJP5juxn81+h3TuLxAr?=
 =?us-ascii?Q?MWMvRsVf1KafgDyHqmnjM10i6wMBy/psqhy+Vdx7SBs73cJrKhbFTr4yjeDs?=
 =?us-ascii?Q?CDLakL1/iB7NIGeNenR1m9QqQsOdtAgGCmbwv0kvIcAy+EIJeUZV5ZksOtlU?=
 =?us-ascii?Q?/rjaIikB0t3PgqLkaWgjp5Jr6T+tRXNxXzm8nCrW/zhBsoBYcICG0IBqXpvQ?=
 =?us-ascii?Q?GsXrsr5TD6Nt/u5LAy7fWR79bC6LOR+SX358xgBIR6aJkN/00kKZIFeLdty+?=
 =?us-ascii?Q?67iHHzZDwn276KaM6yYevTbYRtPMJuJffnvzWs6otoayYLDJZYEn4Z+FLI13?=
 =?us-ascii?Q?5fqWZL/usRWKUXshkimP0nA4GEadRmEialOKChdC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50dd6269-94e5-4e01-f9b8-08dad4284a39
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 05:44:33.4815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7lzehqEplebrJ6Hh1nbjM49SJyxiacGGw/soIT652dRp3HkEdLKwr6nBOF1ZToQpd9qJ+mEMzyx4AK+lf7GCTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4949
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Thursday, December 1, 2022 10:56 PM

subject: 'helpfers' -> 'helpers'

>=20
> This makes vfio_device_open/close() to be the top level helpers for devic=
e
> open and close. It handles the open_count, and vfio_device_first_open()
> vfio_device_last_close() do the container/iommufd use/unuse and the
> device
> open.
>=20
> Current vfio_device_open() handles the device open and the device file
> open which is group specific. After this change, the group specific code
> is in the vfio_device_open_file() which would be moved to separate group
> source code in future.

It's clearer as below:
--
vfio: Make vfio_device_open() truly device specific

Then move group related logic into vfio_device_open_file(). Accordingly
introduce a vfio_device_close() to pair up.
--

With above:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
