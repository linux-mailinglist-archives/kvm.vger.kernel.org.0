Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBF466D983
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 10:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbjAQJOX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 04:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbjAQJNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 04:13:14 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA030B22;
        Tue, 17 Jan 2023 01:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673946384; x=1705482384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h1Of50d8Yu0OzWbDE4ng7esHgtW5geQ7YBDKkySnS9s=;
  b=fUZK8b6tiJiahX+twGiGKPn+6CNe79T02qDzYFjDO49UrhAWgjEk3FQI
   RJFZ1ZiI80b1LIUJPlpFM1HszEE3QQjodZcoO6B5Yy0wkeNPvSXIPuZol
   ISifXkfrRlQLfIxGxDBGEsIkfwey8ysN5dM1yMMqC7OCMjM8UOGBGGWo+
   bMMubIc/oUgjNiuu4NsrxEhtJO3CPDyxEaAThlyXl4cYNIyWwPo99abTl
   sZh6ecYeLcj3ErkBfJMfG/RITr1r/v8cBaFX/MrLmEMZXBa5Zd2/y30Cg
   JUh8OwzYN8IC6x+QaQNq5Q+9pgfWGNrnQcscoVT38LZT3R1LuQzB2aPgS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="322335705"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="322335705"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 01:05:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="691512680"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="691512680"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 17 Jan 2023 01:05:45 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:05:44 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:05:44 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:05:44 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 01:05:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9w6oyZI/4K4PGmdYiKPSy9wbyTuBaQX+fsjK8YXdKiFalDOXYW85Igo4Quvbq5Z1mUQWQY0UhYWXHSOpKc+V1gOt5RTz+/ya9sDujHMDHrfohD3qokxBrQxSBvJTDz6j9wT+KHZmUoeQZvtXyTFJ3eZL6Na/3fI0THEVdzFIGI9nggjfnxfREIuhzkm05vCNyXRvmtPKrFZF4lrd3WMkFWhkIxvaz1fueUgl6KIKQEBoDWS6it6enqimjjqkp7bHQSVTiykN3tnhtrCLNcvMH0KgrZMzJzWLW7Cdm+w/HMNxD54CPn0DURIn8wd/8H1l8HZOoU46PO9nUbFEB2tyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ulKtGX03fhrSml/ORl5KKXkicwMLrC6F2a5wc/j8UrI=;
 b=XKIMaSewY8keS9/auBdf34VXVKEmx/Io+xHFk0RgwWNHnUTB/e8rX8pQYOO0QvNvYgzO0ZaW7Fat+yTUsSd/ErNSSDj26OrMMz1Er8ugdx9eVql5wjtSABY+CctuLfPCNeo3TZ02nNNseacrtLFTrq7DAQOHihT++b/PweM4qXnl+TSn6vwG6XPq0IyQ2WdLE1da/Ox/kXexIbtZOSsFDLIXQPbll3MIojf5GYmtTtQeUwwQMumix+pPdsR91UqSGjFp528IIacgYm/KM3ZmZFAhgOaP5UJHCkBVtyVpr5pn7fbSp7dbsvpZDapKHuQXPZFTMvn4pcvQAddRjVxM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB7089.namprd11.prod.outlook.com (2603:10b6:806:298::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 09:05:41 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:05:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Topic: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Thread-Index: AQHZJ6vANRoQ9x2rxUaXBLM6X5ngE66iVZeQ
Date:   Tue, 17 Jan 2023 09:05:40 +0000
Message-ID: <BN9PR11MB52761554526A0278B13CB2B18CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
In-Reply-To: <20230114000351.115444-1-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SN7PR11MB7089:EE_
x-ms-office365-filtering-correlation-id: 5fb3d0f3-8df5-4dfa-e352-08daf86a0204
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rk20/YXzW1VPzoCsktmEQgpOn+s/HaqYojEczST7ssbBkjJxTBOgN8j8DjSnCal1TvqYEPr89uTEi14yrccVI4j26I2bAh/mn/qj0K9va1k9r7im+E0+3qfL+xD4kjBRIdbRhj8kAb/P9OUDCXM3FgEtmsLSwDTTfK80iyyODogdw5tSv7v+/Uqbul1+RNYSesqR/IMPde0duUMHKS5si9QmANbC8AZYpuc5cI6F+TVWZU8ydne68Wz/j9j/wEaPpIfriMu1adcXKAhWCfd1DtKE7buR7ZPzGZ+2tvPSedoa+GNBsmzoXT+kgS3GlW4clm2o7zRXJoSP7iRBeusTQWpk5kadEmfM4Lqs+TlVNHtv3epEG0OlveX8Xt2mnhq/MMXlZhmbAs5k/Byjl3ugnfPKdIUf3HzNqEypRKmFUfKhoYrMthkLr8e6vZ9yBswfATxzF616wCRKJvHaksFsL/wS11jEvy8+LEodRypvmklfEkCEEtwSvJRvUMiWTFurnJn063SVx4JyeZmi9oLOws13tuNA1PtvHK7Q6JhqekDv3pV1cJG9UDHDQE0ciL8TqQc3tWZAjO33SFiQGNW91XplEfLkSrwjb0n5dYNM02Z6XQx8sG33QSyLqpcxxX64Lz+XX3A7UiIXgR0GHfnG+x95J0LzTJ9dq+qzQby94WY+bg5SIRWpL07mEKXIv7AOs7GODUVFshDkTIufeFzd2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199015)(66946007)(110136005)(64756008)(76116006)(8676002)(66476007)(66556008)(66446008)(41300700001)(316002)(4326008)(82960400001)(55016003)(4744005)(38070700005)(8936002)(122000001)(83380400001)(33656002)(54906003)(52536014)(38100700002)(86362001)(5660300002)(7416002)(2906002)(71200400001)(6506007)(26005)(7696005)(478600001)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rzoo8yFm1BbYcB4ASEHHrXC26nH3uY0EIgk1KxJCNZMye4678BSJaqp4pARO?=
 =?us-ascii?Q?7DgTge1PjBUOf283YwKljEFmqIZWTxM+7/q1NAaey4LidyKfNQYIJUtfNxqr?=
 =?us-ascii?Q?ycyDv1a+pWOgmdl0M1Kp0WZmd3LoHCOwtTQupWUUJTKiEffIyak9xkshaIsv?=
 =?us-ascii?Q?rovJrXW/fpyLTHsPfySGGlK5rsRwSO/ZtGcNN5sk40x9/F8Gf/W8E5CsMZTm?=
 =?us-ascii?Q?slSEas6M+7Pf7rEDNJurc32LGHis+uP2OFAapt84QB/WlgLlmtWI824SdCfe?=
 =?us-ascii?Q?E+7UK6OZm+d3RfKZLh703KXFa8GxNF/dwe/aKKAXoBF9abmc/cn2TqwFbkcB?=
 =?us-ascii?Q?CKuYfrjYJW7Zj9tGv7WH6bixDOtpr/KyjUPMPl3vuYCm4UZwu0ZqwWWsEAlA?=
 =?us-ascii?Q?YSE8dtRt4XKQ//C0hQNDrVlPPBXv41wKPc5eGW2SE1LiUnSMHCNqHwz2q8AE?=
 =?us-ascii?Q?DAqfdPo95ugHu2j0AiRwNJUWQX5hLJpxnpiHWrg8Zo+VVkqQoXde1i/9+Wdl?=
 =?us-ascii?Q?trn2FcEdfRQJyT1OdXY7xRrfya8sX5DeO0DdjMN5o0vdHG6ghSqFPtwcbbnI?=
 =?us-ascii?Q?iM9BeZSck4mEyeU6wVWVns/cZqrYqBZNajJoVIkJgypmjP6LYO2q0/iJiu9t?=
 =?us-ascii?Q?i3BJe6QhFcu5vig+l1KZHHOfKlDbnLzIag0e7Qda4Ybn8I5wskVVtj1aCOr/?=
 =?us-ascii?Q?0gzUWwer7r6+Kvm4Gk2F2tQFu0KgDZ5rEnWi0LwdfYNJDn25iDO2b7TsjT0y?=
 =?us-ascii?Q?K9DPjVegBD+vMPuKXzs8LhI5YfL22AFlyWoy5ipNvvD1SlqfXggX1TsjK1Q0?=
 =?us-ascii?Q?+uUO8IRlp/FiSFDUjMWrkSbKfz+LSsFGcmQ+/47fsEf8VRkcRqRC9nbbCVq6?=
 =?us-ascii?Q?DyO/07UVFDGZWXWBEfZazgHQ9s41e/sHBm9m+ZFxxvvLglAIK6osX5ZSBobt?=
 =?us-ascii?Q?bIQXXo1Im4yohpwPLdh0dVcuDN3u+aXDZsHdYaFKGVVc35xCdfYgvzSRIJBH?=
 =?us-ascii?Q?Q79C+ptqRRqUYNfcBaMYFiedsohGbWD2NYHSv7JtYPhola358+hE9kSCRxxz?=
 =?us-ascii?Q?k/z9AdrfKuLhr+B7hoZ5LyOgxIRdvl+mQVXMr6H4BmydSid7PHhDYuOTu+x4?=
 =?us-ascii?Q?f+58v7omSUNIPH1v7uZywiWBR+rrSQfpj/LHni9oiBWoNfvzrB97zlA5uj4T?=
 =?us-ascii?Q?hsPD9hPWR40grd2J33tuYWhdWdpynfH93YlIZTHWeKEXpKIUQ9r4U9sE5HVv?=
 =?us-ascii?Q?4wvgIgpjdOusZywTNw3tkVagoN2g5BAAPgcljVcPV9XPCFd0YdQnlN/KTKuy?=
 =?us-ascii?Q?ZNomDguLeM74vmlrmeNbWrrfoJZmybxI2boS3KdaQbsXbRbyh9wM8EL4QxOY?=
 =?us-ascii?Q?PrWX3gUQ+XhMx9Qk/uy+8RjGTAY6t3tt87Ua50otCrupjWfsUAgmAqzfBE3g?=
 =?us-ascii?Q?q4mPBDGj2zmH7+6XqwVvn7ndz9jWQwJpw3V1NReLS000cFRzuODyrL6z5hBN?=
 =?us-ascii?Q?HbhZuwpD3tuWVzWzjP/gRP0Yg9bNe3vs7iirCKeveRG+nkFfuE+pu2/mV7KA?=
 =?us-ascii?Q?s3WNvrl6MltTXcyd8/zX3dfK8ZhZbJEkqWtJRWLn?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fb3d0f3-8df5-4dfa-e352-08daf86a0204
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 09:05:41.0286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3StiB8+Z989hVN2++amwhbNWQuy6B4Wg9ZJSF5D0J5e2WliDjUC5eW29nN8cC6MlF9IZfX0V7SSPr8CSLu4qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Saturday, January 14, 2023 8:04 AM
>
>  void vfio_device_group_close(struct vfio_device *device)
>  {
> +	void (*put_kvm)(struct kvm *kvm);
> +	struct kvm *kvm;
> +
>  	mutex_lock(&device->group->group_lock);
> +	kvm =3D device->kvm;
> +	put_kvm =3D device->put_kvm;
>  	vfio_device_close(device, device->group->iommufd);
> +	if (kvm =3D=3D device->kvm)
> +		kvm =3D NULL;

Add a simple comment that this check is to detect the last close

> +void vfio_kvm_put_kvm(void (*put)(struct kvm *kvm), struct kvm *kvm)
> +{
> +	if (WARN_ON(!put))
> +		return;

also WARN_ON(!kvm)?

otherwise this looks good to me:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
