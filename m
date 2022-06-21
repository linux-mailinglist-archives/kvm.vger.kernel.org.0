Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FD2552B61
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 08:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346346AbiFUG7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 02:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344994AbiFUG7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 02:59:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B4B1E3F4;
        Mon, 20 Jun 2022 23:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655794772; x=1687330772;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JXYD4UNVaJhVBJehE6qxl26Mp88l9jbLSn23lvQXGp4=;
  b=ffY5Akb0tB7h6YsaNMdGW1jc+7Y+g4YQevSBIIMzgDdeh+hLbR1ekWqP
   DIw2YeaIhek0A88ny7TgYwgnS5LmqvEIMlXFMJl4TeVk9S9Ybh/jdthIG
   qudaNTbcO6Nh0hFhT1FCUEwLmnReHtW1jcEQmci/t1yencBwVV+CS8Y2v
   VnGGG/BDmt1ZiD4fbutnx03a3Uacwth4Zp+Ge4nNUvH/+NZvqKx+1lckd
   VvlDSwXunEpxXwDjsCtSzfhEG/Cbey2sKojXxTjmKFj/pIGiYK33g2jbJ
   1CHJVsJsBGefXqPQ/goK4ZGAz3KnsjOMll5M5L+GnRCRVlZ4VjV2eM8K3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="278815119"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="278815119"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 23:59:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="729709150"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jun 2022 23:59:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 23:59:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 23:59:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 23:59:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 23:59:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULYi3OyrSfmxzv1JP7J8e/vtI7uCkHmp9NSwQ7jlIVaebZa/JewXlIvgeoZzJC+krRpVa56VVwwcxTRHFBVHIRAPTG51PWUrkzXfJKlRik39+HohZpsLRCE9ltWBL0pceqSavr3R2rSbMPX/yllqlMddRzSk96npYSv+5+e/4NCJxgmqdmuaZTuJ0tMnmK/HBhkElLiRUFkdfe6PG/UP1xvBdgzuoP6JYzcGGZkHgM+Y7Ubd7iHxVUob7rHykKCtgSHpQEbPmYXYklCTnGN31jepUrGDKWnUd4sQn4LQkhPMyBG7VFSS8Pnc7eOlXKBd9fcpRCerBsTCHiLej66gEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWHFcHFrEi27xGuG886+uRCE7LLSBpDBIKzHS4Elu80=;
 b=ccwgcbkw/2lQ/uQHuO7/lWLp2xEaD57htNxSrFVSdVLMhqGGDJ53N4IQoPWyASDHg/dfQHHkF8auYa0cwpoxSLD/WfE9M/Wq1X3wXJgjA1JcVZNVT3+vGaHfnaX2TnoLsXjpxU6q+Tlz7T7WuYJTCbr9OGFhJheIYrUr1QYhaB6r2GC/4t1Wn/FVNF5P8PZDNUisG2FvzTs0GNTdR40urOBrYWZhv2Q/SbjgVcntrOnlnQ7X6wc/QkpYZ/IW+bDaPE0feVs6xCJWAlxnl1S8AcfuvduSbVqc3haua623MWEwL18hOBZiboeYDX95aQOmv1vvup7/QJ/h+aYic77Sww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL0PR11MB3457.namprd11.prod.outlook.com (2603:10b6:208:64::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Tue, 21 Jun
 2022 06:59:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 06:59:10 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Gao, Chao" <chao.gao@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Gao, Chao" <chao.gao@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [PATCH] KVM: x86/vmx: Suppress posted interrupt notification when
 CPU is in host
Thread-Topic: [PATCH] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Thread-Index: AQHYgm/62kpN9oGxw0yhLPM2iySOfK1ZZ8IA
Date:   Tue, 21 Jun 2022 06:59:10 +0000
Message-ID: <BN9PR11MB52766B74ADFBAEC0AA205E298CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220617114641.146243-1-chao.gao@intel.com>
In-Reply-To: <20220617114641.146243-1-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f28e8b0d-42da-4153-8e68-08da53538ab7
x-ms-traffictypediagnostic: BL0PR11MB3457:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BL0PR11MB34578D700C4D7B8ED2176C658CB39@BL0PR11MB3457.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YOz/f+I51bzZa39HBjqcXCxJPKqSLvViv9+ZtSVMweI9Zkcb456d7gawyaO0hebfHPk2XtsVE/kMHWUrEgehvR6jX7aEiqWAtycs0V2nRDe1rj6kGspocXdiY7ymPBrssqBR1Z/DzaykaiRNzg7pvb3LsGqpUUF/rFYqT8fhMzIgNQ9CqW/ekm9kQ31hFT+iiMnOJsnFJ2DWDU4lC/oEZbuZC4dogeT/swhsaLDqMvQPZJTwceQ3it5p5pkqpoUS/q0gYdmEVnxi55leG3kqRPDpAewmxysHGobDrw69VoBGgdHBVblZhUBE75UslJ75k0L4AiHJxw8bxP4WR3twRkIoRo6A95QHg4DLltLt7xVEgqtA3DiPmGGmenjxyLhiK49G3XFw5QaEODOYxvgQDVGiB+gWAVG/kVFMb3K8iZpee6SGgDrZ8uzgH8juSam4b+ukgY5SgM1Q8Ea09QBsiVwSNo4ZkfxaDaRBPugOmuVIl7BdWUE2o/P6pWDXYcpNlkKWdihj+wRrPKTrrvlq7ROB89Gegk6m7YUhBH6FnWrQ4SIO9wmUAHHOFmSeFkmwXUTByfiGx+bcYEtv1d2ziS+4Gpb63xw1EBJBzMwFiqfsXJpwOFxwgk3mFnct3xfv/nAN+A5DZ9vlW9N9pmHxKK/VyfmniZ0NlA0Llvcun/xdp2Rim4EaUMcXt/QafgcHbnGOV9wnV3/18rVCn7Ib3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(39860400002)(376002)(346002)(7416002)(186003)(7696005)(83380400001)(82960400001)(55016003)(38070700005)(52536014)(6506007)(122000001)(38100700002)(15650500001)(8936002)(71200400001)(4326008)(110136005)(66946007)(9686003)(2906002)(54906003)(316002)(478600001)(41300700001)(66556008)(76116006)(8676002)(66446008)(66476007)(86362001)(5660300002)(33656002)(26005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Erfy/d/8FM417VQ8x1RlHcLRkQ02Xyry8hjCrXqZnu0YfsAwqsJE5krlWWNH?=
 =?us-ascii?Q?R8jfeg6qnVDaPEHRqUHGNZjcYCml4FT+r9B8vBsvaIwmhvVFZQm53guyeZpC?=
 =?us-ascii?Q?spkVx1Ud7BI4S3FYpjfC27OsDzaLOghrzaPw1nXjfjNAnc1DVdukGlhBiv72?=
 =?us-ascii?Q?b8dshejuhqFeJ3RV9GudjfmGH7UKDJfRPvyVftcJHRF8kmBPt2y7/FacqLR1?=
 =?us-ascii?Q?nB4zTovZK/egXzs4QsSQ6rtDUlOdv3ALgnbfVciR5jXX0vCy2LrK1fKIcOUr?=
 =?us-ascii?Q?1ZXbqfnFrvaRYnclJlUds60IH/2P7wXrf6Dt5BEAPBXTJiZ3+DUcea0gk/E8?=
 =?us-ascii?Q?1ULsxenteAmmdouZKzgceBgdwA1nUvE2BKCvSRyBf4uGQiNqKQ231XsKTmV/?=
 =?us-ascii?Q?p5jxni4dsI3I1QVJyn/oRp0k3vKcUuod9PcF/A8V/uid3zJ7nDymdd6F9+lW?=
 =?us-ascii?Q?rB12Jeuj4y49KR3+8VDVmvC2g1ajBecn3pKLBz0ANk5GPNAB2D9vS7fcsv+z?=
 =?us-ascii?Q?wyBVkLbNACV9k3M9K9Beu/3kJG1G6uPORNyKJ9Fk1XF9HPcuUN5gROauAcef?=
 =?us-ascii?Q?ULdI4SkIZg87AX0GBAktlCSAt2gou9TON9R4de23ZoNhishl1wIbBm5JV1gg?=
 =?us-ascii?Q?xRMp/GbcPavPgMe4CxCh6yCOFL5PSTSWHKe2w3UYt2up1K+amG+bbpdYSo8U?=
 =?us-ascii?Q?cfW9hSyb4C8zsMkeLypf9uRAHksaNEJhEXCfDKbaPvZ6mLydhUw1zPTu9E3S?=
 =?us-ascii?Q?FwaI7fGaplTPlArw2uBhdKzEur5fzRM9CSg5mQn8dNT+IZ7cqoQraYJHpBqv?=
 =?us-ascii?Q?ua+c3DY7UmWCyQ+EKj89w3mLGTjMmO9uxLLfpfOaKR8DJX+4uFFjBHybCQnM?=
 =?us-ascii?Q?ZaDqYQ7FkLgQxldmEMQhj7cM5+WvfxWc0UYeJAwbhVCa5CzsPx8DX/W95OlP?=
 =?us-ascii?Q?nEzMz7pqUPeyn2wXxMn476rs+lVd4m8oc7GoKYY6akVH/9/ym00HOOEP1ioK?=
 =?us-ascii?Q?GrW3Eiu5/cXP09sNlge1lKK0Qs9PgbIEn5MEnKPVdLdP8KQLBS4b7mW8UOYK?=
 =?us-ascii?Q?ugf8SkU4l8GxdJfU9np/XbmUNlc4fQ+9rLGrcH1tBjkb2snF9hVztNj4/jhJ?=
 =?us-ascii?Q?d1pbAf1Q6svwZ0q5oLGwTjSulWTDtpQhAvZI3x1hFANJzRCeu58hq+iJkaTE?=
 =?us-ascii?Q?VOkkXNQnhxwGtYRbQWIRz4ZOJIyPqFY1LDJobSBdWFehXIfG9olB/jqDv3QZ?=
 =?us-ascii?Q?ktxuix1hOlX+V8ciE9yIrx9QssuZhkgMnWUpoAzRm907eg9JqE8Noa6A923K?=
 =?us-ascii?Q?yA1R2zmZv4n/VD0L2ZZqkwjJOYfJx1GYL37cUYjIWJayBoP6UMuIF3ZNURCX?=
 =?us-ascii?Q?M1bigFIcPXQw2hKFzLGOVrSshiOGvFpk1qVllGGOs8fFOq/CKhYvE/67/wUC?=
 =?us-ascii?Q?FEUln3OhTAqMjvugQy8GSoyoMOd0ysHFZO3OQVOfgG+YoHwgpx7qJfs5V7rr?=
 =?us-ascii?Q?+rm7SL4a0vfE8lKdTgLO2JhAyy90z5WeIkPyGf8t8LTSdtvBW07d6T8OMO+F?=
 =?us-ascii?Q?h4dFM4/781Cvd4IzPmRzbALndMtAHW/csqHJsjtYOO9iykIb3UVw3DauK+xd?=
 =?us-ascii?Q?H5pXBEnAxQMa4XBk3ommJKiecaYfT0v+7O/9Q/JO3fnSE4/ugkfPPyadiHEr?=
 =?us-ascii?Q?9jwlLVIVc5KfbZd13vQNE4bwkMTV8ehjZszLjEuXl9j9VwFxsAqUhLXaorVU?=
 =?us-ascii?Q?lJZnvrIlcg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f28e8b0d-42da-4153-8e68-08da53538ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 06:59:10.0866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+AOLJcd+AXllqYfw2yudJ6afhLvnLPkY88VRG0WLbuxoWk4UZc4fh2vncDYYkHWEpbg85gKkMSfbus6jscFXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3457
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chao Gao <chao.gao@intel.com>
> Sent: Friday, June 17, 2022 7:47 PM
>=20
> PIN (Posted interrupt notification) is useless to host as KVM always sync=
s
> pending guest interrupts in PID to guest's vAPIC before each VM entry. In
> fact, Sending PINs to a CPU running in host will lead to additional
> overhead due to interrupt handling.
>=20
> Currently, software path, vmx_deliver_posted_interrupt(), is optimized to
> issue PINs only if target vCPU is in IN_GUEST_MODE. But hardware paths
> (VT-d and Intel IPI virtualization) aren't optimized.
>=20
> Set PID.SN right after VM exits and clear it before VM entry to minimize
> the chance of hardware issuing PINs to a CPU when it's in host.
>=20
> Also honour PID.SN bit in vmx_deliver_posted_interrupt().
>=20
> When IPI virtualization is enabled, this patch increases "perf bench" [*]
> by 4% from 8.12 us/ops to 7.80 us/ops.
>=20
> [*] test cmd: perf bench sched pipe -T. Note that we change the source
> code to pin two threads to two different vCPUs so that it can reproduce
> stable results.
>=20
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/vmx/posted_intr.c | 28 ++--------------------------
>  arch/x86/kvm/vmx/vmx.c         | 24 +++++++++++++++++++++++-
>  2 files changed, 25 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/posted_intr.c
> b/arch/x86/kvm/vmx/posted_intr.c
> index 237a1f40f939..a0458f72df99 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -70,12 +70,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
> cpu)
>  	 * needs to be changed.
>  	 */
>  	if (pi_desc->nv !=3D POSTED_INTR_WAKEUP_VECTOR && vcpu->cpu =3D=3D
> cpu) {
> -		/*
> -		 * Clear SN if it was set due to being preempted.  Again, do
> -		 * this even if there is no assigned device for simplicity.
> -		 */
> -		if (pi_test_and_clear_sn(pi_desc))
> -			goto after_clear_sn;
>  		return;
>  	}
>=20
> @@ -99,12 +93,8 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
> cpu)
>  	do {
>  		old.control =3D new.control =3D READ_ONCE(pi_desc->control);
>=20
> -		/*
> -		 * Clear SN (as above) and refresh the destination APIC ID to
> -		 * handle task migration (@cpu !=3D vcpu->cpu).
> -		 */
>  		new.ndst =3D dest;
> -		new.sn =3D 0;
> +		new.sn =3D 1;

A comment is appreciated.

>=20
>  		/*
>  		 * Restore the notification vector; in the blocking case, the
> @@ -114,19 +104,6 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int
> cpu)
>  	} while (pi_try_set_control(pi_desc, old.control, new.control));
>=20
>  	local_irq_restore(flags);
> -
> -after_clear_sn:
> -
> -	/*
> -	 * Clear SN before reading the bitmap.  The VT-d firmware
> -	 * writes the bitmap and reads SN atomically (5.2.3 in the
> -	 * spec), so it doesn't really have a memory barrier that
> -	 * pairs with this, but we cannot do that and we need one.
> -	 */
> -	smp_mb__after_atomic();
> -
> -	if (!pi_is_pir_empty(pi_desc))
> -		pi_set_on(pi_desc);
>  }
>=20
>  static bool vmx_can_use_vtd_pi(struct kvm *kvm)
> @@ -154,13 +131,12 @@ static void pi_enable_wakeup_handler(struct
> kvm_vcpu *vcpu)
>  		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>  	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu-
> >cpu));
>=20
> -	WARN(pi_desc->sn, "PI descriptor SN field set before blocking");
> -
>  	do {
>  		old.control =3D new.control =3D READ_ONCE(pi_desc->control);
>=20
>  		/* set 'NV' to 'wakeup vector' */
>  		new.nv =3D POSTED_INTR_WAKEUP_VECTOR;
> +		new.sn =3D 0;
>  	} while (pi_try_set_control(pi_desc, old.control, new.control));
>=20

there is a problem a few lines downwards:

	/*
	 * Send a wakeup IPI to this CPU if an interrupt may have been posted
	 * before the notification vector was updated, in which case the IRQ
	 * will arrive on the non-wakeup vector.  An IPI is needed as calling
	 * try_to_wake_up() from ->sched_out() isn't allowed (IRQs are not
	 * enabled until it is safe to call try_to_wake_up() on the task being
	 * scheduled out).
	 */
	if (pi_test_on(&new))
		apic->send_IPI_self(POSTED_INTR_WAKEUP_VECTOR);

'on' is not set when SN is set. This is different from original assumption
which has SN cleared in above window. In this case pi_test_on()
should be replaced with pi_is_pir_empty().

There is another simplification possible in vmx_vcpu_pi_put():

	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
		pi_enable_wakeup_handler(vcpu);

	/*
	 * Set SN when the vCPU is preempted.  Note, the vCPU can both be seen
	 * as blocking and preempted, e.g. if it's preempted between setting
	 * its wait state and manually scheduling out.
	 */
	if (vcpu->preempted)
		pi_set_sn(pi_desc);

With this patch 'sn' is already set when a runnable vcpu is preempted
hence above is required only for a blocking vcpu. And in the
blocking case if the notification is anyway suppressed it's pointless to
further change the notification vector. Then it could be simplified as:

	if (!vcpu->preempted && kvm_vcpu_is_blocking(vcpu) &&
		!vmx_interrupt_blocked(vcpu))
		pi_enable_wakeup_handler(vcpu);

>  	/*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a3c5504601a8..fa915b1680eb 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4036,6 +4036,9 @@ static int vmx_deliver_posted_interrupt(struct
> kvm_vcpu *vcpu, int vector)
>  	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
>  		return 0;
>=20
> +	if (pi_test_sn(&vmx->pi_desc))
> +		return 0;
> +
>  	/* If a previous notification has sent the IPI, nothing to do.  */
>  	if (pi_test_and_set_on(&vmx->pi_desc))
>  		return 0;
> @@ -6520,8 +6523,17 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu
> *vcpu)
>  	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
>  		return -EIO;
>=20
> -	if (pi_test_on(&vmx->pi_desc)) {
> +	if (pi_test_on(&vmx->pi_desc) || pi_test_sn(&vmx->pi_desc)) {

this has potential side-effect in vmexit/vmentry path where pi_desc is
always scanned now. While reducing interrupts help the IPC test case,
do you observe any impact on other scenarios where interrupts are not
the main cause of vmexits?

>  		pi_clear_on(&vmx->pi_desc);
> +
> +		/*
> +		 * IN_GUEST_MODE means we are about to enter vCPU.
> Allow
> +		 * PIN (posted interrupt notification) to deliver is key
> +		 * to interrupt posting. Clear PID.SN.
> +		 */
> +		if (vcpu->mode =3D=3D IN_GUEST_MODE)
> +			pi_clear_sn(&vmx->pi_desc);

I wonder whether it makes more sense to have 'sn' closely sync-ed
with vcpu->mode, e.g. having a kvm_x86_set_vcpu_mode() ops
to translate vcpu->mode into vmx/svm specific hardware bits like
'sn' here. Then call it in common place when vcpu->mode is changed.=20

> +
>  		/*
>  		 * IOMMU can write to PID.ON, so the barrier matters even
> on UP.
>  		 * But on x86 this is just a compiler barrier anyway.
> @@ -6976,6 +6988,16 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu
> *vcpu)
>  	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
>  	vmx_vcpu_enter_exit(vcpu, vmx);
>=20
> +	/*
> +	 * Suppress notification right after VM exits to minimize the
> +	 * window where VT-d or remote CPU may send a useless notification
> +	 * when posting interrupts to a VM. Note that the notification is
> +	 * useless because KVM syncs pending interrupts in PID.IRR to vAPIC
> +	 * IRR before VM entry.
> +	 */
> +	if (kvm_vcpu_apicv_active(vcpu))
> +		pi_set_sn(&vmx->pi_desc);
> +
>  	/*
>  	 * We do not use IBRS in the kernel. If this vCPU has used the
>  	 * SPEC_CTRL MSR it may have left it on; save the value and
> --
> 2.25.1

