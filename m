Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBB8650837
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 08:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLSHyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 02:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiLSHyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 02:54:15 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B90B4A5
        for <kvm@vger.kernel.org>; Sun, 18 Dec 2022 23:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671436455; x=1702972455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OczrRRTylOSLRadbNC2fK1ajOBPsnRGstQ4i64pgOmY=;
  b=YYjs/Hzoz36YQ661wWOYA7Mo7xKNppfDDYQ5+tiaWrDXzD6/gCo0A4gV
   k6KSHCMyUo6QO+v6jErWJupCs647okFcbKVjkqBRHnLXjciJ9CfmBPFx9
   /CAS3kb5gaHRdUBIIWuMSMjghxiTN4o7nmqJjSdljdJ1uKE4lMH0o6rPP
   1xUiDiQMZstBun7l1ctkX1alx4jIsNXDi2WYHZ4K4HqOVcuCfQxJJXJXa
   M/KaLP99VP8AEL/vgafo2CKSbKXyEgvq6ovesV0RpT5+76f5IcXm18hCZ
   3eQpyqSz+Vk9qYOgP+J8IYpDxSE9ifLlaVMBRn2BDxCE70wu0MEASOhot
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="405542511"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="405542511"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2022 23:54:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="739241274"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="739241274"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Dec 2022 23:54:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:54:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 18 Dec 2022 23:54:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 18 Dec 2022 23:54:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 18 Dec 2022 23:54:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTZG0FYbzGN1t3XuvDOsIwmja7QvntCuXT9srS4leJKA5kNjbH0evLC7nWgdP3diRPTdFakqHIeorWTR4j0fuxurIu/xzGtn1qQB1q6l2uOEnoJiGNBhVsUMj9vR9ZMtwU8goPxLibYfK2QUeXGISVJCQNygCYY+qEjP6nnjpUusYiN5r1U02EmdsKghcGN4hO5bczayJ7SJrH5YPoLaBpspayy0WNWBi1CjsuPA08n00Zq7X0c7Aq/XHoPGCf2BVPzVDS6CMrulG8CnozAMCs4lkE3Yl2UpaBqDgDCA/xkGB4NsNwzP6sEUZ4LrcJ0SZ0/VwXeDdfa3U+Z+7vtq/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZTXIMsL7WrvUJ1SuGS8P+Jy/SLKxHOgTMRyk60KgCE=;
 b=KTq2XL/Z01aQ9OTnDeEUHD7ln0mC1qrvdYdYn2wYlgP/4qhyLlVxf0yC9nwTGf+kdEUunCUhej7VUZiL0MGmC2QWgN0sHQ1Dry3l4h5sJsCBn8j51RlCYc28DbDojUFKZIAg7YYuRD33nkIZEtsTpZGLVmVSR71ZKsehSteG2MfWqmQp9fRekKJz7ObO/h+mL/BcK+sfYBhcZ1VKuAvNyTXTjpaWEEJdAgotvr13leuCYldCp8/qh6LTCQ/cNSfUeunKNyQDyQsvNopU5hAUJVh407xK7y2sfNea3TqGHo1Scod4aaQ8cnkmfHyOlFFvGdRIfwVWFmU/a2G47eXD/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB7641.namprd11.prod.outlook.com (2603:10b6:510:27b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 07:54:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8032:d755:9eed:e809%4]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 07:54:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Steve Sistare <steven.sistare@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH V6 4/7] vfio/type1: restore locked_vm
Thread-Topic: [PATCH V6 4/7] vfio/type1: restore locked_vm
Thread-Index: AQHZEX9VymN27/XEDEm4ziszwb/rQ6502n6A
Date:   Mon, 19 Dec 2022 07:54:11 +0000
Message-ID: <BN9PR11MB527628D49A2D1F3E51D6D6888CE59@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <1671216640-157935-1-git-send-email-steven.sistare@oracle.com>
 <1671216640-157935-5-git-send-email-steven.sistare@oracle.com>
In-Reply-To: <1671216640-157935-5-git-send-email-steven.sistare@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB7641:EE_
x-ms-office365-filtering-correlation-id: bdc8f349-4e99-44ff-85d2-08dae196378d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xUetXCu6bXvCfpDE5a5IaoQ7ZpvLwKcdX5DiC83DFFVsUE5pd8SYO+JwzKpgQrCXcP15oXzK0MY9YUX2r41ci/V1eQPaJ8TB4ZgWhxQ7F8JhK7Lvv+Goa54jfHubELXxonJWGWMeRKJa8mJuMw3w3Yu3hjxmT5jV8diAATjbT1p3o/PLh/QkPoZx8XJ9oS0TFeQmH72xJ+Vdm1PGEK+aoHdojsy873LAWLOlIyKnmasBJ7sCVW3U4Fe8PIfchZpkAvwUIkJ3J3qiw2VCzYfuL0PdnANWAVOWyCueqGFc+A8eJasZUDDjZc0VWy8apSWUZD/WKjs9o1em+qcsj4eehIR9S+5YiPU4LrjqKeMcJ6oohaVZN4QRFkrk6xa/K72aBcu3VzrD2kaADaSjfn3XT5IkJ2LpJGn2FTsakQnNKU0lZmmy7b0anQYRwge+meTObbSjSScsV+ijNM4gqp7YN8E48dsihfuHcsybx05jRZr2gby47LGfYtgc9qHwv/rKgzMoJg79ZFA7yqBiVCsyas9f1zmgXB2qSMN5Y80+QZCXiCRsnIBg8D0Tp2/vQtGDCQRoTJ9pO5rcZt/mng0uCNbDR1BnQDMBlkpcELsM+/ieTFDyeNgXWlQudzPyo18k4Y/0YPwefS6DnHurHKJcxIdAPlz+E8Uim2TZb3ycWbwAnGtsqxnaGBLbQ9gRzjAa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199015)(9686003)(186003)(26005)(478600001)(7696005)(6506007)(66476007)(66556008)(8676002)(64756008)(66446008)(66946007)(4326008)(52536014)(41300700001)(8936002)(5660300002)(2906002)(4744005)(76116006)(55016003)(33656002)(110136005)(38100700002)(122000001)(86362001)(71200400001)(316002)(54906003)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?v91/UVRuWP1vpQ3I8MsLSumDcloQE7SWIvCnVQ7MCvfNGDJqePHijT2kqaei?=
 =?us-ascii?Q?HwOVeMKWZXSeK21zN+/07htPp3ZqFXtzMe4THvHog4FiKbkFZTHKHq6GbEGR?=
 =?us-ascii?Q?G92jHqIxybCbmqptf+bdo9fP8iheUFI1LGv/XbPCcFz0WqC660PuD/SpXyQ8?=
 =?us-ascii?Q?kQNpswhQHLyHNiaeWh+o8hc0mOXUun7TuEi0o3NT42AmVQgjFKu5nI9gF2ua?=
 =?us-ascii?Q?uEefa/xZ4RQ0ruu5qmB6Cse/Vrks4e1YgMnpYo0efHkhdwP3PAypLpsb5rsa?=
 =?us-ascii?Q?xJ01pqFP+sCtrCJ4v9aZJ1Opzwzetf+M2csXJH5Cvwr5iDdzNj8HrbPNv88h?=
 =?us-ascii?Q?ZK8dTj2dTBbrVNW17iD2u21Jh9ArH8ix6zurUrwtDszjbjejl2ACNnxaHWj6?=
 =?us-ascii?Q?hR4Rwy6qpLnpWq+qQfSpFEWhPiShItYNRFPifjNnkCi0Y7L8PPrNKswGBNCQ?=
 =?us-ascii?Q?N+VnWnhFaPXBuRIlkKrDM6qMPCmnurJoxy/ojkJrGkeGktwnP8wE3l2hn3vw?=
 =?us-ascii?Q?T3DE/Fs0XTo2KimZIfjQMx6HnJvnCRgQvYWOpA7I9x9OFiDl0zE5dyjROVQs?=
 =?us-ascii?Q?3qXVpIACv0UpmKMbXmjzpSnBgsKpjys0vrBtM3POi1bVDNeca4Hn50Xy1bkY?=
 =?us-ascii?Q?JE+pP+CH7xwMTI/dXkEyXVhBt23pEL4QW3HLsrglFr/v6/nHsmpSZndyAiDG?=
 =?us-ascii?Q?oVfPMECzvQ1CSfLsG/i7lT0Z0aV8VmxpbvQUH4D3R1xYAK8EP9uEmUuUe1g6?=
 =?us-ascii?Q?iL4Sp9EIRLiqZSG1rBBbfWWS/QQg1MVXFFgE9AvRz5O7In9UXFFvMZAcvvAM?=
 =?us-ascii?Q?2gR8kPEs1RVQshmlo6ENYFa0TeHCMFwVLMx+WTUyluOEtyu+UzHaKq2Hf4Dw?=
 =?us-ascii?Q?LFnl0jSJwSZn5uXPwj8MsR1dWEEc1crtVM2e1NiVh9FcAcjWV7ZN/guscQwn?=
 =?us-ascii?Q?kzNt7R5Ceb38nuWgXngpuzXlsjlA6SiydQF18uPMDrcGCdAKJt8zkL3DpADv?=
 =?us-ascii?Q?wkyyEZaA8rCybfXqNXua14MmLAwYvXk3/VWaRkJ8ZnqwauPDSCtc78fyz2wW?=
 =?us-ascii?Q?6QELJXynO6njmpNRScZucHPVpad05sUEDMHm5OfL6PUVlLMR1LwTRRP6t+AE?=
 =?us-ascii?Q?2Pckj7zUt0tLjFYGXflj7bE6B3tVz/Y4D5qXkx8YhdPe4Bf4Vrhhv8jX3AWP?=
 =?us-ascii?Q?RLrzATdnsKJ44WJ4mxOd5MbHIea+zNonLicB5ieGAWm1QJ7pfWtZLSYecbaa?=
 =?us-ascii?Q?RZ9+7j/tX7+JI1HzXPJ72JjD9x94sNI8qzGIh1QaWfnR+ASiYTI9YsAz1CQw?=
 =?us-ascii?Q?KZh5k+nd/NRD+wVRuX9PjKJYe6/TrIuDvpLlkCcWJ67siA/s/+u4BSz1git2?=
 =?us-ascii?Q?rzag945lR6iWEcXfTdV2LIowPryINZtGH8zv563LlISwBGiJBmcXLNaAeSpt?=
 =?us-ascii?Q?Fnl8YyV/Xnts6krademNJegRBUfXkM+EpzBAnhROeuRAqWu7IN9CbF/uI/Rv?=
 =?us-ascii?Q?3+L+AiOrqkFRdhnO1nq6e92nPYt77/BqKYJ6XeU3r3WA4zyw5nulKPmwNTeN?=
 =?us-ascii?Q?KiZ0CfmB1Lbp4PtFj2WfAzXY1H+dWFiKNRzMo5ek?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc8f349-4e99-44ff-85d2-08dae196378d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2022 07:54:11.9399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hcr021uxVOJpQg+HS+NDiCsuGiiq5kLPjbNpv3EqAg+LVUiF9+n7EgdF/mS3gKRSqXVEXo5/IF1995UpYG6scg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7641
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Steve Sistare <steven.sistare@oracle.com>
> Sent: Saturday, December 17, 2022 2:51 AM
>=20
> +static int vfio_change_dma_owner(struct vfio_dma *dma)
> +{
> +	int ret =3D 0;
> +	struct task_struct *task =3D current->group_leader;
> +	struct mm_struct *mm =3D current->mm;
> +
> +	if (task->mm !=3D dma->mm) {

	if (mm !=3D dma->mm) {
		...

with that fixed:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
