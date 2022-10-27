Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7808860F73C
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiJ0M3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 08:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235730AbiJ0M24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 08:28:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA292132240;
        Thu, 27 Oct 2022 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666873715; x=1698409715;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q2IcdsyP8S87jcl88a3KdcuYIcWmmzjOMkhpxHSYmPU=;
  b=Sh69Gk6Q7schj1deGkipBInUv3HnmqUkQRe6rVivuQDSJK2kcrTEVNwx
   ShBeeKswFkLXCMFWZrngOL5Bl3OhYCFhwgOyXdwYPMxocbBo40rxciuiF
   omxX5yF0x0nz0Ct4u7z6LNHhrSvORAPRnvf33L6TCEpOL0SDEMTLA3bN3
   mllcRKuIoMoy8D05mwFw4MrTXcKLYH29Re9fw1vitO9DB06SYj8h8omso
   KTPXthr92Vj9XnfM+JpqJHF23usndIm3jUjPTO6/q/2X9UO3G+tIYjj7H
   rfEBvfz+7qErW8W8dhcIGOMD9GY5D1DkcSYhX0RsWXfAoLP2Tf8wgwTUG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="372421106"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="372421106"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:28:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="695786738"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="695786738"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 27 Oct 2022 05:28:34 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 05:28:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 05:28:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 05:28:34 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 05:28:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtWLvp+c13BP7HbwJzQ4uK/rDmtDG8z/6Kd5ChP/kd8jFGWqi+nCbPKp1tLj7LNCtZgwL7E1HwcPJfRHR2m1GBj7pNzJHMU01txY/DYDGqW3hSDvtfLubgNfZjt74+A0UzVmLqs6FFM2SlKqLH3Sdf+LyS8ZCJwelV+yQ6Fuo3TgxpDTs0uAq6ZMaiXMAik4viU3GhWmLkRr5gQOHxRE+2uYTTY5XdVlZaqEtTzKhPhSeiMYw96UlH2t9mfRPprv6yB78cpPrYPatP8ZLdwkbqI7h7NL6LmosxUNlDn5GOAkBjI9+u/uPH98gq8C75ZWjnpEsscrFl/zylXaLuxwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAolB/QG5UWfBC+WKeNPo/ICs4kYv99/j51rhixtttM=;
 b=Qjnql3znV6tnQEECMDVCTyEioFtihMsVFx8mRliNCYCJxCj8GooqP9LcB/sS8bGtUuwWp8M4drSBH+7h9Rilg5JeZHoS4KrHEAnazNFjaiqgmXTl4hclsvdTzP4vd5XXlFtATl1xDBry3TU1S1Quv/2peuPG2SxYKVjDs8CRYkgiUAw7AEiKKmhEnZikHrQDv2/5c2SfP2KEOoak2Zy5KFiqfUKrnsk899yOsMEvxID7DceijGiLpDLSNpU0Js13A932QnkMG34Xsymaf5yy5S+qLyp38Nldpx+d5LdLW1Wn1hCagKNSccSemcGNarRvuhDuw+eWIrJzZ6NDDltCDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH0PR11MB7471.namprd11.prod.outlook.com (2603:10b6:510:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Thu, 27 Oct
 2022 12:28:31 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 12:28:31 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Thread-Topic: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers
 to maintain vcpus in kvm_vm
Thread-Index: AQHY55ylKGIU2b/Czky3MagHOAXjm64hW4iAgAB9rdA=
Date:   Thu, 27 Oct 2022 12:28:31 +0000
Message-ID: <DS0PR11MB6373E471C1378CBEEBD40A82DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-2-wei.w.wang@intel.com> <Y1nHL5BUoWPqUtt9@google.com>
In-Reply-To: <Y1nHL5BUoWPqUtt9@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH0PR11MB7471:EE_
x-ms-office365-filtering-correlation-id: edc025f7-e201-4631-5eea-08dab816c217
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PpEjveLH+ahoSEaBStPpCXoSEjXIPn3r4MvsrKZuY5OtNlAbJMVowNjpaWSd2Rd2slo/4Np7HD+RAXsjNb0r/Pfd3LoD7fKETXcUs4DBptGo3gJjz3Rh9c3/AoZVS7BEAnHavwplVBKbsBIwWVbCXLzlwFscRiepoxf7XmDxXdXOmls/feCzl7a747tCAqW7wNpEKIA9Jhwk72VIrWOTVvO96WTp0U2G9hMbr/sfXEd81quVNe0nkuWBCkqNhxkvh1pmndNROS4m7j8QO0iTAHfYVMsuMkUmDqOqdaEWNsxpU1A/QVD81xWPFi0pqiHdKFBFJp2fcjIg+wPsk1gu9779AY4iBXx62ETTf/Caf5dQJGNSaRn/BHlug0woupgBWriClPU/qYuwHqCVANu+U4bT3U+906noBV6z3B5AvrRxZaJlgOR+9a/B7KUFk0VoS56XJv1xL2hKRCRNcMEOYKeFSBi3KWLW6G5GhI0Jx/IVWYMbjKiof4afT2a+PUgAbNtmeDKA+jZ+GuhC4ego5+xMoMeQ2rcKKox9m8kSmU2FtDwuKrl6LnCTXLAxneLpCb8rlE98A8OsK9tk+yNSqjVogGpImkQ8CMOK72eLzyWOPd2v8gk67vpbVRZjgBqC6lgDIROo2HgwqBAJhT4EKlgDNz9/35l6AwgJcrRapXdb5GvwZjlWT8X1yyLxY6sNVP812E4c6NKOEpSwGfiXA28P1ZIH2Yh7pQ8qglWdYNo1oqfDwVWRydvQYKxm0CgVIzbnobemtS0WfPyqujU1og==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199015)(478600001)(82960400001)(2906002)(186003)(71200400001)(38100700002)(66476007)(66556008)(76116006)(66446008)(4326008)(8676002)(66946007)(64756008)(41300700001)(38070700005)(53546011)(54906003)(6506007)(6916009)(7696005)(122000001)(26005)(8936002)(5660300002)(316002)(52536014)(9686003)(33656002)(86362001)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t08JEqmEbolPYgaVG2GI4yiEPeQQ1GeXefo/sNwr9B56jCM5yDaPTnqARO0b?=
 =?us-ascii?Q?kqHPFM/BVcjsStH/lq5X5SzWIL+ZoEKDKiGzka7io0S+onodIUqz6t3E7FD0?=
 =?us-ascii?Q?1xpyVNnpxVr1JOmXBrzc16FgeTAX+59oqu3t5yogKn54dUq5P7M7CSR4tARY?=
 =?us-ascii?Q?v8qR3B4/LLntI5H8XP52AYhHFfPGH6BhI7qCdRkWTfJjMS9AsXqn0El4/ptx?=
 =?us-ascii?Q?OxTW86WLiCwOvCwgG+0IcRbUqQwZKx67Uu5UuSvc5nQELmMPFSQXNy4xYxVk?=
 =?us-ascii?Q?HFUI9Ofis+IwTw69SspVNCU/I1oMnaha/itLyUI/ArGdajy6muq8Juqz9K3M?=
 =?us-ascii?Q?TLPjqSQdHc4nfEFsf+YLiiZ6Xu0Zxd/IXGy+0QIUvGchC5+KxWFrSitLeFma?=
 =?us-ascii?Q?9c5udobHQnb3ZH17dOo7gt6ytGXt/5jwpa0UJ+gBdk80Zo7X75ZvXDaRAvLi?=
 =?us-ascii?Q?n9CbXOUHZ3Pe9CeD+b8s6XBQ7iuXzMvH4tfp76LHHpdXUEGkG3XWbrP4ZpGC?=
 =?us-ascii?Q?PWMbwfZh73hHmf6FyKfxcNwnwnJnSiPrqF7tXDkjupbH0YtX7dmgNALzQyUP?=
 =?us-ascii?Q?KfDQMwYwlQlEtunATGgkPr0mGrtsY/MsoJ/G23vBqXQYQS/KIIRxmpWwUIoe?=
 =?us-ascii?Q?dhv/D2kopXorsvvFO0EGciDOOAeSt+1v/0YstQmGbz7Pk1Xa16aiVs2tFMMt?=
 =?us-ascii?Q?XLaD0Gkyp9aJHoUpilvPK3ws8BdP69paP+Bn7EWDWgRAeN3fTICB7k9jeyiP?=
 =?us-ascii?Q?x42zGUks9cLX+mEjYv8Irz9FDEZlstamvmDQ1Zj1DSTaWlV9qeOsMVLpeQ+P?=
 =?us-ascii?Q?ggF4t1TXBww5d5hlxhasFbFhAitS3qS0zAUcz+DQ/X1MblQnyiqtDWP+i6sf?=
 =?us-ascii?Q?L8ElX8Vf0StWzMvsx8P6cN8MPTtNEAMRcu1lfkXbdbE0e6/D2ll4rg+w+Mh0?=
 =?us-ascii?Q?RCVcZFFsCqrQrZNeRnT4Y1POLdtayRboSUqiT6JZCcAAnvC6spPISDRK1OxW?=
 =?us-ascii?Q?HFZOd939qR4oELVD1InnUvrzToZlRXkfAvyEX0urOdp6aPt0i8A6RxUKzdG1?=
 =?us-ascii?Q?YRs3daqowSzzhhMSsa68648kbrg7p7JYwbDLVlRMuF6Py++GbJu2jy1GYXm5?=
 =?us-ascii?Q?oiAPYjyJfy65eIOye6UWr2Aty29o63RpYtF/edxLSWAZlcwOfTTKtq8nNz0N?=
 =?us-ascii?Q?BjQVQIM2K1jjxloZiFpT0NElvOSNmWCSryNF5IjZvyPm4F27h6ta466KjcNd?=
 =?us-ascii?Q?zjHzAWD4NIkR3rwubMPAs59lnI/rw1V7fYlN2IUvb5DNur8jnc1GMQqOkEUf?=
 =?us-ascii?Q?WhLx5IwVjRfXoaxM5yaBJp2P4XRX4TMEv352b5V1XiMqy6FFpiwAdLfky6Ev?=
 =?us-ascii?Q?pL2CGZV82DxO5SvQ73jdbprd58+c7IXvCN/oea65L3qdebCfQPeHmYZQFfR7?=
 =?us-ascii?Q?ag1ugRJOsI157LDu2lQSCygUVy/fwVk/q45tRFOg3qXJjg+HlSu81yOMQ0iU?=
 =?us-ascii?Q?n6TmsY9/k6/j2HG4MnMSyPZ2ouTBpfYepGFIKoKFBVwRf4mZkOwBEjiLckoI?=
 =?us-ascii?Q?XspB3AntxhqDRZFAgRWgoSZlozBH3V1KzxbDyHNy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edc025f7-e201-4631-5eea-08dab816c217
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 12:28:31.0979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g3xXbLiVWLh5sR8uRnNSm+UxX7ey9xWY1klxnFzXOsbbGDYiH2RY9UHSxWewPetp3YUWDC5wMy4jD8zRwrYNBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7471
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 27, 2022 7:48 AM, Sean Christopherson wrote:
> > +	for (i =3D 0, vcpu =3D vm->vcpus[0];				\
> > +		vcpu && i < KVM_MAX_VCPUS; vcpu =3D vm->vcpus[++i])
>=20
> I hate pointer arithmetic more than most people, but in this case it avoi=
ds the
> need to pass in 'i', which in turn cuts down on boilerplate and churn.

Hmm, indeed, this can be improved, how about this one:

+#define vm_iterate_over_vcpus(vm, vcpu)                         \
+       for (vcpu =3D vm->vcpus[0]; vcpu; vcpu =3D vm->vcpus[vcpu->id + 1])=
 \


>=20
> >  #endif /* SELFTEST_KVM_UTIL_H */
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index e42a09cd24a0..c90a9609b853 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -45,7 +45,6 @@ struct userspace_mem_region {  };
> >
> >  struct kvm_vcpu {
> > -	struct list_head list;
> >  	uint32_t id;
> >  	int fd;
> >  	struct kvm_vm *vm;
> > @@ -75,7 +74,6 @@ struct kvm_vm {
> >  	unsigned int pa_bits;
> >  	unsigned int va_bits;
> >  	uint64_t max_gfn;
> > -	struct list_head vcpus;
> >  	struct userspace_mem_regions regions;
> >  	struct sparsebit *vpages_valid;
> >  	struct sparsebit *vpages_mapped;
> > @@ -92,6 +90,7 @@ struct kvm_vm {
> >  	int stats_fd;
> >  	struct kvm_stats_header stats_header;
> >  	struct kvm_stats_desc *stats_desc;
> > +	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>=20
> We can dynamically allocate the array without too much trouble, though I'=
m not
> sure it's worth shaving the few KiB of memory.  For __vm_create(), the nu=
mber
> of vCPUs is known when the VM is created.  For vm_create_barebones(), we
> could do the simple thing of allocating KVM_MAX_VCPU.

The issue with dynamic allocation is that some users start with __vm_create=
(nr_vcpus), and later
could add more cpus with vm_vcpu_add (e.g. x86_64/xapic_ipi_test.c). To sup=
port this we may
need to re-allocate the array for later vm_vcpu_add(), and also need to add=
 nr_vcpus to indicate
the size.
It's userspace memory, and not a problem to use a bit larger virtual memory=
 (memory are not really
allocated until we have that many vcpus to touch the array entries), I thin=
k.

>=20
> > @@ -534,6 +533,10 @@ __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
> > static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)  {
> >  	int ret;
> > +	uint32_t vcpu_id =3D vcpu->id;
> > +
> > +	TEST_ASSERT(!!vm->vcpus[vcpu_id], "vCPU%d wasn't added\n", vcpu_id);
>=20
> This is unecessary, there's one caller and it's iterating over the array =
of vCPUs.

That's right, thanks.
