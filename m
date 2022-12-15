Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C568064D5FA
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 05:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLOEwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 23:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOEwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 23:52:12 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DEA537ED
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 20:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671079929; x=1702615929;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJuUrkVfIPQt9I32cyH9Q24imz3gcB1oNS0wlxBjHjg=;
  b=lkWh6tUqjC7DyfYICCusBsY4QYqicaeMGVG2OTCxJHbi8rsiCzerkv7h
   Ff+fRXT4b4px1Foi0ditWdp/qNqVOvRsmnKQGl5HLQSpq9SgLZCT5WqnD
   sm2+fE8+52i9w626WO9dv32F/ocTiA2XuvYbQqsnO/TmnA0euhmhNp8qF
   JigrxAfFolhy0lTQSEE3cY6LPv62PywRRIrrg8pgXIXfkU8GTKxPYsZxg
   kdcZ5V3MDoVeiE1LahqDySO/Tzf5AjMvIlK1qaG51/FDddjKgeVzm0dUS
   JoXdNCdhG0Mgct289v7AuMojK19FmY4P96JXtUUA5elw+AalpYzF/BP9d
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="318631866"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="318631866"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 20:52:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="756209658"
X-IronPort-AV: E=Sophos;i="5.96,246,1665471600"; 
   d="scan'208";a="756209658"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 14 Dec 2022 20:52:09 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 20:52:08 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 14 Dec 2022 20:52:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 14 Dec 2022 20:52:08 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 14 Dec 2022 20:52:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HobQhw7AmJTBGMpH6wNTJCEWiwmWVmOkGRHTGWetpP4XHXWOHEtHNAvs1U0mFaE2SoQGPENzaTVCZ8s0I4JgAmM6c3KSBbYH408VmkpilVQy4u3VXi+3MFD/eSMosyiE3/OU3hfuRtKiMMBEbKoOVArlMnwD65ZcK/LfZO8+asIBlRh4vCnBvjVViB67HptniKRCet7eyIeyEL5gm1LEt8vOwK1SKod7p2uDUXoJnO1DzNqM1D/Kv1EZd+hbuDvky4bHs8cwjIIDRG1JHsM3wYFeuSmBY2dCS7axhr5LNqQ9hlKoBAPO7ub+Hg9tYNNoJRHK5iZg4W9r0FbOlmWTow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OWf4uBEqdC5SbE5xjs9Tmp7wp4IAmuWKbInODStbjs=;
 b=i3wFvHMccW8YE8IgwK85zoDviU7KHe9yRt27JjR85i5i8z43CZ82RmnbWEXPvL9qCDGlmg1Npg1eFbCOx4sp9VCsKHtRgw2LQWG6MPTnK4xekcmQk3CyWaHpLXRbKesI7a4TGqRg8TuQXYKFAxjbauImJJDurE+wZj/ziZVSPobSSqTqYQXpybdexuJ/+O6jYOjf2MuThtQ8Mr4igabveqi/FojiV4Rp63hcaZb1ejcJpO3TrYCsEFmAdYiMbzvyTYKOzm6NMzxgl1mbiALBfAWoNd4njR+oB67tgtGlX9nX2Aignoo/HaZDw+I4iWMyC+6GgfrVm+ERHKDdtX8J1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7383.namprd11.prod.outlook.com (2603:10b6:8:134::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 04:52:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c9ee:bc36:6cf4:c6fb%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 04:52:02 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Thread-Topic: [PATCH V4 2/5] vfio/type1: prevent locked_vm underflow
Thread-Index: AQHZEAKcLLezjDIW/EqZorryCB1UtK5uXR/g
Date:   Thu, 15 Dec 2022 04:52:01 +0000
Message-ID: <BN9PR11MB5276AAB95CB64CB1B48123288CE19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671053097-138498-1-git-send-email-steven.sistare@oracle.com>
 <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671053097-138498-3-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7383:EE_
x-ms-office365-filtering-correlation-id: f9ab663a-cc88-4d34-3d6f-08dade581b23
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rtSEq3Oe7t5zMgUVCpse9ZFEh488L1nrU0Rl3y7sa4r0ZPFwjx+t++tyY2CVRDBsaRq8Ah/oXqgoo3XD6TgNEV+moCz7EDqTqF2MvesEwyXpD/ccgFz4Q06ct4AMaQyYwzzoxwtTK9x1R/xRVCgOMtP+C+9ap3jKMBCEfkuec5BX1ybOqSOfwxkwlrKI9nwaPCBm9QzCYSbHj8TsCG+tZ1LS9TiATLLwvDe/iVjhjjY9fdyWyg0JtY+06JUWL+6bYkDL+wNlRKnLXA5sTOMNKDgCVT+x5qzdjZtPnrlQtbDCPRNi2rwKG8HVAJZtBSB2vvdoG0NRquBjkjlBpwjFWsuzsh9mkNfmBMbkA+4E63efeVOakFCuYmtb+6Bc1w+zXlcqHvAaULvoX0K/Pyqhla8vnVAFD+dmwWmKjAMiOUJx1ZgJopF1EqSoPG7tPFHqHp+L7s5R3wQky5JidB5MhPgHqjBRd2WO/SBfSmF5ifqusTCAw97/c6ctSHZS8bZn1v1Ww0oNKWwTZ+ffYiYApiHtm4deNa5rUxPXyll2cd962Y7uGEFrFvHn3843JRCOSrqXT6WlEfTIiYWvMXpWkuH7IgGTRk7e+PzMHAeabidZs4shTK+Vt6r0kEO2/xNbe1xtZUXiERlSGSayqymeBwgRv2rIxCn8uQdj/i6V1SwYMNtmzm8I8rtNqCWym+Yd9kmlj/niIrotkj2uMkRM/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(346002)(136003)(366004)(451199015)(316002)(33656002)(55016003)(122000001)(2906002)(54906003)(110136005)(83380400001)(8936002)(52536014)(478600001)(38100700002)(7696005)(6506007)(71200400001)(82960400001)(38070700005)(5660300002)(186003)(4326008)(76116006)(66556008)(64756008)(8676002)(66946007)(41300700001)(86362001)(66476007)(9686003)(66446008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?10jhDivatEEJgz8Ju29yYqqm/ujP9vL1mA7qA2uB2YQPKwcwZ9LHMv5iaHiT?=
 =?us-ascii?Q?eCDxW7tdVSRM1ZwA3l0BvD01Vbd3P8/2N9O89rVGnT2aPuD1M0ApRYHObNqu?=
 =?us-ascii?Q?Cnr0npcwUY9oXzlAjQHYNFu5hktgSN2ZlUEJZuxV4qRra+qzhGXVet7XV+lP?=
 =?us-ascii?Q?PiInwFQ6FnIMBAuBLenf+n4oxg/h2mCAKR4RNqyzuJe8/Gi/p7lPcJe5JKzm?=
 =?us-ascii?Q?gN6YcBzRWVJLJ9OEItSkn8fmzjpyys0Mu/VbOFf0nSKTgvM6/ClaFJETGtMG?=
 =?us-ascii?Q?eSpzHgvMDl4A4owQqFlD/Jui6yQMaM9HY7RlkFtsoUhgAtVAh1xI4YVnoaZY?=
 =?us-ascii?Q?auaOnAw3JRV06Yk1LV+SRD2ZIgs6j0doHvVylN+R46Fu5CgI6HPTr9CDdxIV?=
 =?us-ascii?Q?LudBGMevZCCp4SU4gERUnWL/T4RM/0vf8PIrcxrORgdduVA3Hnsk+Y+KRy9Q?=
 =?us-ascii?Q?CAAfgEgCbDxcbZJCAT++OeAxvr2+Qo21+1kdVSWCtSDbRyr5Z4m6ZxxyK8fE?=
 =?us-ascii?Q?bk0B3g1dNUJ9+fA/RhxWMmZMKGm8FRi7xrBEuVPSMOzVNg0QhI77Jh1Pibbn?=
 =?us-ascii?Q?l/ruyGegMelYaOYm046cL/gNiEHRM2qklLh4Kp/aMtH57K3uv5J1WPGbmNYl?=
 =?us-ascii?Q?MbNlZ0Q+tZg95zDYxeAW/hXDHGLIpuirjSaMI6/bhJmu8U579N2haUosPdex?=
 =?us-ascii?Q?c8UOrPhhnu+VAZgglMLLHTY//sQh8L86hbcdp5pXCp55m19CV7dGm+hdbUF/?=
 =?us-ascii?Q?8lT597ok0RrqKIkvAosbz1AcLB9kTa3n7YyeBeqOFxeGX5HA8AUEFzpnMbtO?=
 =?us-ascii?Q?doqakph9j0HutWjSKIjr7May7/+rP8nim4WuNASvYPXZudUG3MK8x4H1QcPX?=
 =?us-ascii?Q?jZkVzajWiWAnAMhZY+QP4DyiKJdAWPmZHBH85Ok08aHn+YFNF25n41UEKbG6?=
 =?us-ascii?Q?BRpnIEEvusbSq4vWsfC9JYHbxOprPSkJOmXQqGk7GcFAPSkRcOozI0jBVEnn?=
 =?us-ascii?Q?NsuFF2Ob+JXK8C6lqZcyzNP/arBI3lF7RJy7hCktviRqYI/1+qrfrCKavoS+?=
 =?us-ascii?Q?fe774jK6DanGNKEkI29p87KXmh0Bd16DMi7JO1LQlxPWzu7EgEOGdrWWz8gv?=
 =?us-ascii?Q?Dw6z9FU/9G1df62pT1C1Nwbmn28TfiWg9riq9VX6xg03YGMMPCSweX0YBAaU?=
 =?us-ascii?Q?JwCoFu6B8L0yyH+OiNwtzrPZAGiCOGRCNHS2zIcW6yKGxP327JKS8MH0+qIm?=
 =?us-ascii?Q?1tGyH79dECMOLFiU60mpa9btTxBA+FRVMYTo5aV7hz6yuEDRgWroeqFxZk7r?=
 =?us-ascii?Q?5NIhYnSVC3n1q27BuaHd5+SAqpYpQ/juAHJzTAuY7YZdTKpLjTVAaMQY6iFN?=
 =?us-ascii?Q?jMXde+JnI00FbDINHaYL1SFiYsqkXVTa4eQh9uIcFIgdU15KlhDGolFUZt4W?=
 =?us-ascii?Q?EyR4XjTd0DW6ASYBPrEJhfqw3iNn5cmAvNurW1K6VXLm62wEIieGAquQOzTw?=
 =?us-ascii?Q?vdMeNCDhF743HEDIp118QJq48sYizMTUd25yPUmHSzR4BJYGI9QCBkKQQA92?=
 =?us-ascii?Q?7NLeAt1Wo1SPZJ8/6djJ7Ts5EJuGP1pW3D4bOS62?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ab663a-cc88-4d34-3d6f-08dade581b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 04:52:01.9213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r87LMowUeoX43/M+/c4Tt3dj1Drhc0PDKq1CKmrQiqvQOnAqDCOVXOvdqmd7uUHdmi+tUYyze7Ie6Y/EUEGQMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7383
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Thursday, December 15, 2022 5:25 AM
>=20
> When a vfio container is preserved across exec using the
> VFIO_UPDATE_VADDR
> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps =
a
> dma mapping, locked_vm underflows to a large unsigned value, and a
> subsequent dma map request fails with ENOMEM in __account_locked_vm.

Isn't it the problem more than underflow? w/o copying locked_vm to the
new mm it means rlimit of the new mm could be exceeded since only
newly pinned pages after exec are counted.

> @@ -424,6 +425,10 @@ static int vfio_lock_acct(struct vfio_dma *dma, long
> npage, bool async)
>  	if (!mm)
>  		return -ESRCH; /* process exited */
>=20
> +	/* Avoid locked_vm underflow */
> +	if (dma->mm !=3D mm && npage < 0)
> +		goto out;
> +

the comment is unclear why the condition will lead to underflow.

It's also unclear why the guard is only for exec case but not fork-exec.

According to this patch locked_vm was not copied to the new mm in
both cases before this fix. Then why would underflow only happen
in one but not in the other?

Anyway more explanation is appreciated here.

> +static int vfio_change_dma_owner(struct vfio_dma *dma)
> +{
> +	int ret =3D 0;
> +	struct mm_struct *mm =3D get_task_mm(dma->task);

should this be current->group_leader? otherwise in fork-exec case
dma->mm is still equal to dma->task->mm.

> +
> +	if (dma->mm !=3D mm) {
> +		long npage =3D dma->size >> PAGE_SHIFT;
> +		bool new_lock_cap =3D capable(CAP_IPC_LOCK);
> +		struct task_struct *new_task =3D current->group_leader;
> +
> +		ret =3D mmap_write_lock_killable(new_task->mm);
> +		if (ret)
> +			goto out;
> +
> +		ret =3D __account_locked_vm(new_task->mm, npage, true,
> +					  new_task, new_lock_cap);
> +		mmap_write_unlock(new_task->mm);
> +		if (ret)
> +			goto out;
> +
> +		if (dma->task !=3D new_task) {
> +			vfio_lock_acct(dma, -npage, 0);

Presumably this should be always done on the old mm, even in exec case.
