Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28FE60F9FD
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 16:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbiJ0OCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235652AbiJ0OCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 10:02:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCE8186D58;
        Thu, 27 Oct 2022 07:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666879361; x=1698415361;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g7vAvCQI+dlHLdacDewklzH+9ZyikwLFCX5g1t/ZRIk=;
  b=G+JTxPnEiQfE1cvAE0gN2yg7dRP6qYr8MuUY5v0NRlRtIVqsKVARinYH
   ELXaE65Xu49ZJ4ozjJwQ2eNnJkRxVwhrGGpBhNMK9105BM2OovdRJF9pf
   ZQBh/jFiXHTe68DpVOYSmBey/+MtINpTsynVX4Sh/84Qp5ji6MtzggSdl
   p87FDUPY7ZIqmSEQsridZsset3wYsdhuU0u0RiS7EobZBla2OkZYOhj0c
   CnSStTT1NhR7C3j3T3GzN2gU6JPy1Qy6YCkhLRvtloE0sedxaPlSYCo7G
   bDzA9m7pIAVDvjSWXpxe7rk/bBokgMOn+6RvBIixJGLdW4O1AC0qhESpK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309317431"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="309317431"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:02:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737690920"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="737690920"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 07:02:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:02:39 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:02:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 07:02:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 07:02:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ck1ZPuHRdjtIWwC0ZPoX/EDBn00CxAZNWVy3qZB9SMaXcZdGLUrOD9TrLIk6EoaOj/3DY0fl+3gF8LWOgfFrMGddkoRT1aF5N9SEEB3kW73rp25YioOVY2bhr9NUlLorEcgFU3cUa+I9twV0MuXGZc9I2IvpV8ywfR8aPnRJOsFeGaNQd9WbwiwU9sknaXFih3UuXJLfIKB2rnP1RMzQxXom9azrVyHgTn43O0e4IdDQ9lqSz0egbQcbC1e6Dv3DyW1UO2ZqNq2Uu1NSZy5gXTTKaAc16wShIzqTNsMIxaE1LF9betOs/DNdh4F8V58HXDPq01KuUIw/AIuJfm6RUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBVLV+lLL6QnhA+5UVvAz9DRbtdwIN29E9KLRRqFkJk=;
 b=TBOBahVyMqx1lybf8Wblzp5WzwcUIGlPvQCt1hL3Pc+00GMx7IA7AHvBL4afiJtM2koMRbudzJqOf6c5x9/uyAQrY1IlJymJp6ZWI6EAuxfNPrWMKHGecJZJqvKpGKYSOQhfH6x2sDmP/t9UMSXuSlkgL97ZmKYUpOIHoUNh8RjNIkrrnVu+2UNVj68XCVBcrlRwx/HlFECGxi8+uU1jxlHCIZFMcDqYSpBRbDS0wBNRcNLZOmxyTZAJcwYbluxUsJv7Wp4mriX/jbAn6xVlznduAFwJDDxGXsC8Zu/WL77amY+mx20inzvoE754F5xlS3k/lokXJNHZby+vZbMMPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB6008.namprd11.prod.outlook.com (2603:10b6:510:1d0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 14:02:29 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 14:02:29 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 03/18] KVM: selftests/kvm_util: helper functions for
 vcpus and threads
Thread-Topic: [PATCH v1 03/18] KVM: selftests/kvm_util: helper functions for
 vcpus and threads
Thread-Index: AQHY55yr6OJeN0JwmkSYAvicw+5R864hYZQAgACENiA=
Date:   Thu, 27 Oct 2022 14:02:29 +0000
Message-ID: <DS0PR11MB6373FBC16E8515174E444692DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-4-wei.w.wang@intel.com> <Y1nMQp11RKTDX7HX@google.com>
In-Reply-To: <Y1nMQp11RKTDX7HX@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB6008:EE_
x-ms-office365-filtering-correlation-id: 4d0034a4-6ac6-4dc5-53ee-08dab823e2c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qVcIPiWewxlEj1miafAjDnYL6PU4L3Mks1OjKVTjNRSNC4KHKgzEs9HrUfJ7tWRGd9PfQ8ZCwnFqAZxMqfaqckTFobFmOQB83kAaF2W2UXk3gkEZkvVhuZGClHeQwTc0I913wq9CjlBwP4+mxKkfWoGCYMjFa6ZKuwu2IshzSegJ4vYaJFW7Rx+Wup+WHZc8EzhHWQRkF7KJrAJiw2WgKaHwpCETM68YnMOLgUg8bLlFGQgttijReC4IMoTPswnkLNW5cEsPI0lqpoweF6uJoCx/xvl4U0CNZrIJGZTxY60M1vbFHROfCGkwHUFKPLpW0gkeDRlcyfZ0WGXZTK5WLb8lzy52IkujDAgIOrT9gGudvRBFyOiun/0bfUa43bEIH/SCDYaw3ITc49GBlQqNXZ1SeD4GdYSW13+xie9WeTbOcwVDzjlorY8LlN7HcqbY6/Vy2XRM5I7s1EK2a/jOhoVg7muS8M3q2UO43ZBF+AunEyPGFwT0m1V0LhIKjAPBtT0fC/7IQZudynsPDUtY2tf9ylCXikqm/8DBl8T5dSCGTAa+mQ6p43sN7fWEIDT6XJ/iP/ZGeZDBll9mEgGAFQyfp0HM4Q0yOwzK6kzYOvOsv3rGWRhC14efBySWfwMsZqBft+PZWUyrYopxlrftNT9Nebh/pvyvgBH2ARAGs6MUJ2ZvqECsAITaqfyb9ujTsITcnBEp7uBNIsmH2QbIWqhNaxjQXBj19kMOngH8pzaxcrehqJXaZihw+5GnDOF1kvbyBhLGF4VKug+vbBuReg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199015)(66946007)(8936002)(2906002)(5660300002)(316002)(41300700001)(4326008)(71200400001)(66476007)(76116006)(9686003)(66446008)(478600001)(52536014)(33656002)(55016003)(54906003)(64756008)(38070700005)(8676002)(7696005)(38100700002)(82960400001)(66556008)(122000001)(53546011)(6506007)(26005)(6916009)(86362001)(186003)(66899015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sVEl3k4xfscWteXArdc5m86peybHc19hR3FLKJZag0XLkWDRMi3LzD40Ybvh?=
 =?us-ascii?Q?D9kfimjQH5RJ+kkGR93v6aiRXlN3izpu92UR+OphqOsmlnqKlyDrJIge6pHn?=
 =?us-ascii?Q?s+54wz6e/6wriHkubxogVgNg51u7YvHVbquK1r4AzHgnOeF74v7Oa25OPcI5?=
 =?us-ascii?Q?83IEOOHqbmK2vJf4ugYzujoIUosUEAzcZOjNnxxtV2XGqW0a7hr2X94fIPOz?=
 =?us-ascii?Q?V8RvpsXwRs84PRUWPxfTXzECJe2zWiPdsb8cTgoXLD8SLnMoQfAJJncVo/mq?=
 =?us-ascii?Q?wZM7n973fvuuquJV+Jv9ePtQH7pjFVQOjTOt7YluccDtRaw/hdLbKZ71YUQP?=
 =?us-ascii?Q?1/LCVOx+Pa5F221CRqFKBzxH33LCsaNgwcF5C2Zjc3dYekU5wMImisaVTYgL?=
 =?us-ascii?Q?P2YUMwOiKMrk3+U0lTm5rXMcuK6X0cLUMZMMjK0AenxSvIqPAJ4eDC3xSxUy?=
 =?us-ascii?Q?coLuE4GPyoAU/mt1xd1z8ChYeV/PrvkJhDHCWLXRT1LzJE2tW+U94MGcazlw?=
 =?us-ascii?Q?sI2+lhflp6MdERcJf4ElropIHFHa0VpWPIeFp1FFzJeRzEklGgC3Og5lTs/9?=
 =?us-ascii?Q?KSSH8DnUoUM3OHn9uuYHdHIGC7bnM9iVWZsxAKjarMUyIQXeGjgJzJB5Wcug?=
 =?us-ascii?Q?HrTKHviG/jQ41AtVgWW6cZbOnFMeJu2VdIeW0c4fJadPxCqVUKogJcvYvpTH?=
 =?us-ascii?Q?yc3YQ1J33dv+42lW+qgS/CMT9fPXUyMiFehqbBxE8f8L7niS7UPLcArQB6y4?=
 =?us-ascii?Q?8KkqQzqxQ+ZHLJepaC+CcRKIh94seQzVKa7vtOruvip2UoRzVuwEDF+bKBuE?=
 =?us-ascii?Q?4iUYdVIIhtTKQS3qF/lQVE9sI6amaDEsHBX8G+3H7/PjHWYZGa8gCTlnghOm?=
 =?us-ascii?Q?i1mccU/FTZq70/bbhQUpX3LECfv7wkdMEbSIjlvR5LL3HJdzQrFC/ZZm488J?=
 =?us-ascii?Q?wzOJtlFqpIjis+6vScA7P3k9WUOMbnd2UB0655dYdq0jg9QrP/tOQpL/44Mc?=
 =?us-ascii?Q?cN/1nTyGP3Mz/4k4Ypf4++evNI2qEW72vmWou3P6QC1tiTDa0Fl6tjXKv8Qf?=
 =?us-ascii?Q?y+sWjSPRq9ANsSar9g91BZeIhzKk7LuiqoL1daeBaVfD8KGaIzFgHMiWF4D4?=
 =?us-ascii?Q?u3nF5huijmM6oomITCiwn5XTN5y0+mVLuTxf01jhUvkrWFByOziWHqFlyBI/?=
 =?us-ascii?Q?S8JUfVOyb7Hn+aez0LtD3evsosiRAs284wSOAuza1SmAYBcMsSLNWVvDwyOC?=
 =?us-ascii?Q?y55QSfUqFq/lPYYkmrF7q58RJEsbRP7eWEIFUXH+QZYGyMJ4RPwY6zOMl9xo?=
 =?us-ascii?Q?4UQcWL4yQF7MygFlBlIuSOrb/LsrXEuWTKnSBS73AL9trMzCN60hrr2zH7kD?=
 =?us-ascii?Q?hSY+F2B1bTcD+6/Fo1Ae8IkDCHgnYUNphx3iWD2yN2TvmNren/3SiMdCa3kH?=
 =?us-ascii?Q?q/b56pjmPYuggdma0hrIF4DIZy49i4O6Eac4lIizO7VOi7IoNgGmDMcmCUsb?=
 =?us-ascii?Q?TKF5Niao+HvlKtMjb0/QYyShtLJbSnVxZ/DXgaorBKhim/GAUFLXmGOC3acr?=
 =?us-ascii?Q?EZ5aXZ5n8oSDShcEx6V5iWejzuMszrtOnA6o+aXN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d0034a4-6ac6-4dc5-53ee-08dab823e2c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 14:02:29.3408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +fL2QJbEvwo/NtM7AZprj+hRBKlWW1vRjGF0Ac9k2jPft2R/qxeeVkPdoxXFSLmi1CgUUmLJW6Q4xL1iiZcQvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6008
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 27, 2022 8:10 AM, Sean Christopherson wrote:
> On Mon, Oct 24, 2022, Wei Wang wrote:
> > @@ -14,4 +15,23 @@
> >  	for (i =3D 0, vcpu =3D vm->vcpus[0];				\
> >  		vcpu && i < KVM_MAX_VCPUS; vcpu =3D vm->vcpus[++i])
> >
> > +void __pthread_create_with_name(pthread_t *thread, const
> > +pthread_attr_t *attr,
>=20
> Can these return pthread_t instead of taking them as a param and have a "=
void"
> return?  I'm pretty sure pthread_t is an integer type in most implementat=
ions,
> i.e. can be cheaply copied by value.

Yes, sounds good.

>=20
> > +			void *(*start_routine)(void *), void *arg, char *name);
>=20
> Add a typedef for the payload, both to make it harder to screw up, and to=
 make
> the code more readable.  Does pthread really not provide one already?

You meant typedef for start_routine? I searched throughout pthread.h, and d=
idn't find it.
Maybe we could create one here.

> > +void vm_vcpu_threads_create(struct kvm_vm *vm,
> > +		void *(*start_routine)(void *), uint32_t private_data_size)
>=20
> I vote (very strongly) to not deal with allocating private data.  The pri=
vate data
> isn't strictly related to threads, and the vast majority of callers don't=
 need private
> data, i.e. the param is dead weight in most cases.
>=20
> And unless I'm missing something, it's trivial to move to a separate help=
er,
> though honestly even that seems like overkill.
>=20
> Wait, looking further, it already is a separate helper...  Forcing a bunc=
h of
> callers to specify '0' just to eliminate one function call in a handful o=
f cases is not
> a good tradeoff.

The intention was to do the allocation within one vm_for_each_vcpu()
iteration when possible. Just a micro-optimization, but no problem, we can =
keep
them separate if that looks better (simpler).
