Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A543260FA3A
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 16:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbiJ0OOH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 10:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiJ0OOF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 10:14:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E9188137;
        Thu, 27 Oct 2022 07:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666880044; x=1698416044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9w53dvW50ZymKKR7o9mUQ5ngh/DrtmnBGTEdkc1UGXk=;
  b=F9KFVWqWww9UKhr80128yVMqFEBQLgc+1nYhVieGzVOcF5TZgTHH26t/
   DgnHd+pZ1iKdMoyMm6CZRYB8IjtRvApD7q/87gJkOffV7nuqmARjHxy8D
   NhbWJ802b0Slnfvacj9fUyEfOWn3MLTIIb+dkS+Ajee8St35QZYQ/e2Wh
   nUuh6nzj15POIehGbsV+LU1oHTtmNnbu5Z3632j0hFY1uBCBS+qGVeSVw
   yYK1fe82a8TNQQxsRc04Gkmv975vWh2/ACU589YjYxy515KhLz/e9eNQC
   YRkNLRiYEPbtrIHNrEOYU9fVLHCarMVBKp7ItQJ4w19nRwVhfiMMWVsik
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="309927239"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="309927239"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:14:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="632417435"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="632417435"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2022 07:14:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:14:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:14:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 07:14:03 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 07:14:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bV88WBQMYB1ghHDDV/BYKyAZnwR3FNPiJJ2dOcO5TsYV7JplKpCs1AdQvB24CyPuzz1xza2Qfc2M9kBfte+WiUBoc/QosaqnwhlYFehrfKhyVn3xPXVBK1IFtBbv6mFVPgVGxTKMfEWsdenj/vH6+XnCzYXInCLg6CTgbHbYSoYXAcYhNBncGC8GQSD5R8l1iZwJNGY7PvT9/JzI9zl+gtiV7XX0uPMHu6t80juxVHwtdSLoU0AJ9UHGrOY0sGMS4ECZF7rexS3tkT+x83aeeZeBgrECPaPrMSoKB/XWYWBs7DcwKtcaush21NJdN0Ckz4XRTsYu6diI8vKBOmOLmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xOpbC4mMgLJ/zTEd3kx6NM/lDYExtDSE3LeQ2yUMXyM=;
 b=axrsGoijGvvQi3aeKJUDE3bXUdEfWcfQohJtVntTwg88bphljbnPdz4hFTGnlOtXvs4gUfZRTagfqdhjkaKO9jP/HpkonfmDPjdogDlDLOtSxkCq6bR0pAS1y3lHUDIxqaZO1IUAa8IjIZ0QYsBLMIw5cXyJVzfHkBnUKByWZmmUsz+ePnNmgmk/u6Exy/dJc2Tln9spSCbZ3q3oPJNMr+OvcNn4WF95nlElANL/t9cvJSQsWAiO2yAFnjuEV5riwlXCHhvKmgRv+ZM2bC6785ZMKMcY5re7YHDMxLfR/iOLSeWmsnKKN8nbcz7XaT92n7L/qmJpf3GeZ4q7Y4FU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 CY8PR11MB7241.namprd11.prod.outlook.com (2603:10b6:930:94::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.28; Thu, 27 Oct 2022 14:14:00 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%6]) with mapi id 15.20.5746.021; Thu, 27 Oct 2022
 14:14:00 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ikalvarado@google.com" <ikalvarado@google.com>
Subject: RE: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code
 consolidation and cleanup
Thread-Topic: [PATCH v1 05/18] KVM: selftests/hardware_disable_test: code
 consolidation and cleanup
Thread-Index: AQHY55yuIXKRns508k+BGhcyAkdsga4hY2oAgADNh4A=
Date:   Thu, 27 Oct 2022 14:14:00 +0000
Message-ID: <DS0PR11MB6373F09A7A51FBF417876449DC339@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-6-wei.w.wang@intel.com> <Y1nNzO2tC+DCyKWI@google.com>
In-Reply-To: <Y1nNzO2tC+DCyKWI@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|CY8PR11MB7241:EE_
x-ms-office365-filtering-correlation-id: 667be059-edce-43f7-6c0a-08dab8257eb8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPUsNWxbNYcAraqCS6M655Ce+CaC3wNYLaaz8UbiOGjL5EdwUVOxPeUs819athjWCactPkKI0aa3ms0CUTMh6ecxMjrHtw0nZPp3cFdwbkMc1YfStP/jRhgZaaLg547XVs8qhiFgPd4gHui4Wo+8DjamWwKrIovu/7x4bkJHitohuKhMQ3JDzIZCEdLF4RgvZ9TB5Sor2Y48NBkkpZe0XikKUrs8kWxFbBadPOsoZd82ngzED8f0BgScBioiB3IlyJMi3V4ADiDlgu9wiG8BP4gXbRAcjRrc2e5ED/8To3bdLhD4fQ1MYMccivXUlA+0180OL1rsKgNdvbdMn1emmhsfB7zj/VaUZi5RXILC/mZnC82QoUnckY/V3YCuHR8FmvNwgpDSaJpTw18yHuX3g84blVPTHInTg5arIa0TM1hTpCP70BwOphDyViSlfrZN4qBsuAQPpXZ+Oi8WjBVBntlDMudHtx3dNT1sN6NoSe2As+B1DMgsXbmrAQZQS/UIm4eAUYLddkkY1/ATMNsPR2OgDCUtm9kJ0BkvQMvI/tZwD+a3g27+glvKMJbG2rvwDGzF+RgymhOLWO3e/ux8BFqw0noGp+nRaTcDg52ejhpoJkfpIJ5sBfYga7oo0BiRW8Mzeow7FNoD3QtUp1q6HVani7NwPd4mlm6bEr3sEYRoKAdFbtTHffzX8Zw79tapHY5rbFTIOe3ZcZBLHd8y3+PYObmTpB9QQebppPf9QE56oeBP95I9OCqGOW+BymTZp+My/xKM/Rl6is4NIz3slg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(86362001)(38070700005)(82960400001)(6506007)(55016003)(38100700002)(71200400001)(83380400001)(2906002)(478600001)(66556008)(8676002)(4326008)(66446008)(52536014)(66946007)(76116006)(316002)(6916009)(8936002)(66476007)(5660300002)(64756008)(41300700001)(122000001)(54906003)(7696005)(9686003)(53546011)(33656002)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P+viY/5dNBOURVCidr28/8wEffo3XsjGV3FWmVGthLt168woTnRuwL8oLtGQ?=
 =?us-ascii?Q?hD1SAR63N0GQxnyct99RtPQ3NvTSt+zSFDwmkshLbTABViaC4iHe6NLTCnib?=
 =?us-ascii?Q?qixfg9LZXkpdUSUsdqsrZDv98te6ldUolV8q4TRlgXHY/KRTOanodbLYyiQl?=
 =?us-ascii?Q?tOtL/E7Zg4pbtz7/TewsCcxEkMH3kkocGtx7IAPzXuXqTevMXXI8k/aLZC2D?=
 =?us-ascii?Q?rNQAwPeVorq5/1wktllYeR9FFguRpI57Sj2q5I4+wPLzNuKSA6XEV/Ixl/cj?=
 =?us-ascii?Q?yWTxF+glRk1z4egeGDNiTtekK4VO+Y2vj9tMwZddtJmoR1pJzCS7ku+HcBHL?=
 =?us-ascii?Q?wgYtlp6DFSmB34unwVoQesn6js8G0S3YnUQV4SOTtQxNcWuEzUeCHmI4bdgJ?=
 =?us-ascii?Q?Msnrtlq/nYVn3H+dKDA8qFmB/vG6/8r2wnzSP9U5vGUAQSDqZEfNQYZkIv6l?=
 =?us-ascii?Q?2EK/GKaK2kZ+Cn0myiqnOIKorSoiaaLX6gi9IKqw/6Zu1cKVQC7D43pdL338?=
 =?us-ascii?Q?57zXauo2NJVijltE3aaZH8hoqJQjzkHaGtbKiRRj4X/fLoHmB5XBPZbKAbn8?=
 =?us-ascii?Q?cA/axamJjE6hAdkceIdp+bGKOYZVq8jQIwXCcw+ydViVNYqB8DYaaH+NlL8w?=
 =?us-ascii?Q?Pz7smAqqRCKbUZldBZLI/x69eJntU14fSr1rt6u2hrowu5zEQIJ6D8yNyvb5?=
 =?us-ascii?Q?+YouHVAShMm5JpAYy/2iPc5ze68QrKjQsMNb0/ETtUn32WvSCGAVE1hjhsbi?=
 =?us-ascii?Q?a+7xxreNwKBnyWAkQdcxN87KQQ9sf2yOZvZ4LdUWasl4TPZyWcqgAAoRGKJG?=
 =?us-ascii?Q?zmfbZDQlBBNUAdKuVUygMx8Hm2X2StD5aby835B3HbGQKOENiolOESYuBZ/7?=
 =?us-ascii?Q?Qa1+ymPfVtAtLYYa6LdkblbNqDeCtCMK5QOI6Q3XYvkH5V1N/ipunuaQ8JkB?=
 =?us-ascii?Q?yCEnrOKuT1MH8RZ6uuR1hMRwBxffmKgvNYj9Wk/41a9kCyWr2zOLRbGWeKhm?=
 =?us-ascii?Q?LygW48890jPhnf8jdJCet1rXg/PToNdwH7BiUYBxjjSUqCS8OoBN1QjZIvw6?=
 =?us-ascii?Q?kGQvVo17S+jDOQ1HzyEnaR5nPaWRGfsQFE1wOhBXlRfXyw1mywYGxhM0VzXL?=
 =?us-ascii?Q?2+p+r0X7Jgwy15Kga0PLsy8GEk4LeIsrbeRByAILxKb0oaRHzMt+QSjRnh7j?=
 =?us-ascii?Q?SlMHmkY5jupBgKimpuYjtjIOL3UkYPQOTbY9oyDEL18WR9klFe4eUQZDo5bH?=
 =?us-ascii?Q?EXsrs3y1ankVdZUIwaVbpVR0+rpDtIsQ0qNYbr5hg9i0jms6R5DXUz1sLYaA?=
 =?us-ascii?Q?JfqPHxlNg75G4xEQn+Bv6jKzbDh4imcw4xUIFRqzZJ1Ofh+OCq9QmWmAzLoZ?=
 =?us-ascii?Q?0S2C9Gc7EQlFKR4Ra5legjxPJZy8nsMBh233SYq4Nvo+b4Jj6Co0JYlVRtKJ?=
 =?us-ascii?Q?cS4tmTcwdDJhrWrx2DpCdDnJwoSk0pyMYo6D6CGRMP+A+iUtqC8oVF7ntGld?=
 =?us-ascii?Q?uvXzsmZVXKrYfLQrRctwomY426safYW+wcZ9EBXE3xuj6pX3FqSEJqEHHcnV?=
 =?us-ascii?Q?cuRA8kabr7qbGfl1iYxI+rolcfapM51veKF/nvwj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 667be059-edce-43f7-6c0a-08dab8257eb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 14:14:00.5193
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T/qUrS/kT/KM3OcRzjZK5//ao1pZL+akk9uozsRbYxF79LcCvjQZc6tR34zmYG1X28pfxV87N4wrzyNYk/UxAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7241
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 27, 2022 8:16 AM, Sean Christopherson wrote:
> > diff --git a/tools/testing/selftests/kvm/hardware_disable_test.c
> >  static void run_test(uint32_t run)
> >  {
> >  	struct kvm_vcpu *vcpu;
> >  	struct kvm_vm *vm;
> >  	cpu_set_t cpu_set;
> > -	pthread_t threads[VCPU_NUM];
> >  	pthread_t throw_away;
> > -	void *b;
> > +	pthread_attr_t attr;
> >  	uint32_t i, j;
> > +	int r;
> >
> >  	CPU_ZERO(&cpu_set);
> >  	for (i =3D 0; i < VCPU_NUM; i++)
> >  		CPU_SET(i, &cpu_set);
>=20
> Uh, what is this test doing?  I assume the intent is to avoid spamming al=
l
> pCPUs in the system, but I don't get the benefit of doing so.

IIUIC, it is to test if the condition race between the 2 paths:
#1 kvm_arch_hardware_disable->drop_user_return_notifiers() and
#2 fire_user_return_notifiers->kvm_on_user_return
has been solved by disabling interrupts in kvm_on_user_return.

To stress the tests, it creates a bunch of threads (continuously making sys=
calls
to trigger #2 above) to be scheduled on the same pCPU that runs a vCPU, and
then VM is killed, which triggers #1 above.=20
They fork to test 512 times hoping there is chance #1 and #2 above can happ=
en
at the same time without an issue.

+ Ignacio to confirm if possible.

