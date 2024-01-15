Return-Path: <kvm+bounces-6253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B51482DC7A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 16:41:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CAA73B20C2E
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 15:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82F7C1775A;
	Mon, 15 Jan 2024 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n6g2FipM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D37EECE;
	Mon, 15 Jan 2024 15:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705333267; x=1736869267;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SUyOrN0EfqzyGvVe/udsYuLoYMLVhvN3XLRJrW2J+bY=;
  b=n6g2FipMsQCqTA7kfOYFAyinJmDSulNY4jwngGgKDlYJVHz85qLzPuux
   NMDN1G2DV6vhiX3Zd0zatHueArpfLXb1v7P/vsVs4CNb68AGy5eNWES/K
   vILWNitnIwcWfZ3xaP9cvxj2H0buvCbNPYniA2ryQhEl/8aKhDBvwcJJ8
   hK8tbw50nltO5jEEX7kYv9JNwS5ck8ThbkYhEjBsHHsiQ17opPsEcA1oU
   bC7/QUom/Rd/QDX3Z5A5KcedY0oYwdihs58HXPLbypptCWw7Ji0LaWXSN
   HpJMKc67UbEIgzrkQgBUkECoYveijc9oNJB3Xv+7UeCz0T7h9ilpK+ZBH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="463929614"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="463929614"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 07:41:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10954"; a="817862063"
X-IronPort-AV: E=Sophos;i="6.04,196,1695711600"; 
   d="scan'208";a="817862063"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2024 07:41:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Jan 2024 07:41:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Jan 2024 07:41:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Jan 2024 07:41:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUi2qCcIlbxmKFaFzCAjrxowEs8yZgJ+HtPBgbqVZtlSIr3efHEzYjx9Fto9YKdwQ9sgdo4mCNz5rQCdRa++94yeyGlcAtJvzrxopE6cIeRfUGkFYjCTWufGvHZAHBWzyK2ZyZWPVEHaFLEJPrlBLLcGbmeUFMSQsye0BoygY0wrAxbeW94mNrjJcW7wJJ1aH795EJYELaReSTrBpNfkSYKqaktiZgDTjep9BHqhWRurqAsc+Mqc631ZoIhNDP6ro8Dchz4thY/Cm9sdJAUXNQajgN/TGoaxH62a+qvFBzaKt5FF7/JCZlQSnMOLEcf8QleQsukE/VKhQeGwr9J1Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/+NmdW1OATbJGpU9wxvVsEyGmsgnTrPxGTmpKPJBA4=;
 b=iw0cbZ84ewA+88YAYsbXqOmQKtUnAiNKGoccn4nLIHldOioe8axbO7jGTHTONrXDoTnl3vEKX1WqtD9ZGN85VF6asjGcGHhEI4XO7K+FW1aknrKyhgwp+SpDU6LlJ6uSgFCzsueuN/74IUC5GMy3fsZdA+B6CsqXUKrnZNI1cX2TJ/h92db7A3fNIoanvKp/R1HuTsl3+fF8ZBhtLm0elS+Z1q/dUAZqzFoXDr4hSdf6HFgkw0F7CTK+MQ4PSiYjtrE11zcXHh33PQaiw/BzTE1RxuBsUXafYEsg4cEHPJ9NXEhEblvQ9nXj8SXoXxc587KatrkEnmD8pk+2ST+tgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 MW4PR11MB6691.namprd11.prod.outlook.com (2603:10b6:303:20f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.23; Mon, 15 Jan
 2024 15:41:02 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::9ce6:c8d3:248e:448a%5]) with mapi id 15.20.7181.019; Mon, 15 Jan 2024
 15:41:02 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Kunwu Chan <chentao@kylinos.cn>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Thread-Topic: [PATCH v2] vfio: Use WARN_ON for low-probability allocation
 failure issue in vfio_pci_bus_notifier
Thread-Index: AQHaR3z9FIdL+jn8c0+6wUQa6PWyULDa+5Eg
Date: Mon, 15 Jan 2024 15:41:02 +0000
Message-ID: <DS0PR11MB6373BAF9CFEC4D67DEAAB1F7DC6C2@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240115063434.20278-1-chentao@kylinos.cn>
In-Reply-To: <20240115063434.20278-1-chentao@kylinos.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|MW4PR11MB6691:EE_
x-ms-office365-filtering-correlation-id: e9466f3e-2e0d-4772-2672-08dc15e060ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xNfo1DTp4cPf37yvfBrO0yytnUHbBW903z6dxaaV+jquGNxtVTlFYluQcL9x9mcMmeyFnFBZSHgqjAioXZ9ICesnU0Q0MG3vSqZqE6NuQXvyNs0jlPDqDqMXr0JvvWaQZ0vQzKZ+L9NED2wUE9+gO+0MObw2BC0HD8P8A3V8fcLiBDazl5U7nJ6S4xzTdQDPqqNwyKlA2jcMFoMlV+l1S4jurgPBVmS8BnxkW91cT29oxxGtuyYAhMxfJ80aO9vdGqUWkJHp9+l+neP5oJAocPgG0iO6Kcs9mq5kIzRMAlQtw+CEBL5pIHaZVYNzD7SQp5R6uAFgl2QzA0QhilBU71L2GzYlxacvTj8ExdEC09oyOV5flKwsuKvI4lG4Tny65l5mlKySnlHZ/J0pmBLwrOW20gbm4gkFMY2bi4HmXuTxZLF3l8Dd7Ch5MWZoQNaV/ZfFOq5OGbObmId2T17pcndre3pkMV4SzLKtsCK3KK/PpSGyMLRSktt7FPyrXsuU5tgAB9O+mIB9DUw92H5YC74gblG4eQJM4sVsrtWbHoOxOoF7+gtbK33uEaOcfROdrmzDojgyKy1sjegiXgTJHe5ncXjmqenHNHqgtrEEkUQoo+fakttC0+K77tA3wo5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(39860400002)(376002)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(9686003)(53546011)(6506007)(7696005)(33656002)(478600001)(26005)(71200400001)(52536014)(316002)(38100700002)(8936002)(8676002)(64756008)(54906003)(66556008)(66946007)(76116006)(66476007)(4326008)(66446008)(86362001)(122000001)(83380400001)(82960400001)(38070700009)(5660300002)(2906002)(110136005)(55016003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sAO7L8xVlkc56eviVOBaBKMq7nDQ6zH6e9ARX/FWnbmjQ2bH8hYc3SDRf2Re?=
 =?us-ascii?Q?+c+SRvAE9d8evTJ1ezjwJhPSWvq1Jw9Zm7gZo2mwL2ReXL3vjXlYlC0Ixhl5?=
 =?us-ascii?Q?Tzi1WVvDJyqPuFN7NNi6y+ZDMpZRgla5kc0Zva4br+PR3dYdIJZUPK/udqoW?=
 =?us-ascii?Q?QMnjh/q2InBe6OsQ0Drw9VRTy3jk0uoJa9A/OJIxExNGNR4vzVlvS6nVPBS3?=
 =?us-ascii?Q?sc4OmuKe3fP7XL29yBEbnRRi/sw+lvmniMMxpSdrwsOGTNBpiX+AXCDDb7Vh?=
 =?us-ascii?Q?kRMUI4Yz7r9Me22JYoPLP9kKzflzPcLm35XGUgnabhJdKFadAYSY8/hh0ako?=
 =?us-ascii?Q?zbiZozlAA9cTc6Jc86UnJ6zkz6mSOCKek6+N8GKfgKaE5Lvl/KwenOW3SDX9?=
 =?us-ascii?Q?X/1mK1hYaKfPQFm/hbZ04sYfoI7Z1+1rOQgv9XF6j6woBjee/JGZcQlzpK4n?=
 =?us-ascii?Q?9GvBcsltvhwOjLUzb5N6SawKikol2BjbhAU5ahfkiau8k3xMhla/KokME/5E?=
 =?us-ascii?Q?WCtdY1DNK+iMNlxtkY2pPkOkOb7OPX0si/cnge7hC0PUXxQ9c80US1ubLJBC?=
 =?us-ascii?Q?0vCbPLnNd3oywali3wbUm8fOIMw4G1NYfGmMtTDKEUQr6t7ryMUKeuBRqxks?=
 =?us-ascii?Q?xd7d0AvNWfof3HIcXH6zHfp24bU9iZfetH/N7RtXh+0KekJQcgJMDsoBKdYp?=
 =?us-ascii?Q?es8EIfOqzb9ZY0GIk0kHhAP8BV82b8s4QQkDAYp2cmI4ikdfow/Da3qO498Q?=
 =?us-ascii?Q?gSxpIKXgd3xO18FgIN0HUgtqDBYB6StT2zspx//UFxkSHzV5OQf7Qb1gG4nK?=
 =?us-ascii?Q?Iv1Dj9iZm/7fl0HDcF01ZVENRuDhnoFdGIo3JQAzhaItKRjVZAA6yNtfznLE?=
 =?us-ascii?Q?pIO14CyJNX8piMSYRbiF4tynLXBbWoxkP1k+xbpXpJFzHFbGxwkINqwvkRle?=
 =?us-ascii?Q?EdaQMhybiiFvIcQqBokSCE0E+XQcmqLQUfgEHn9UuT0CbfC0TZ72oAXpiKF5?=
 =?us-ascii?Q?HCu9EpV3JSpu709SVvRavCdGXTF4I8MdtBV9PnDXkXNZBqBv+jIRa6GGiLB/?=
 =?us-ascii?Q?bHxvg6TlRMGZKpP9o/1IH6OA7mXfSYM5159QXvuOtWq+RpQAqpfY3AvhcfWf?=
 =?us-ascii?Q?XgRbRBI/EKLFjXba32cU7gQ6mbSaZgIhkfCM/HZYD8GjtPLrQWlVAe2jMdvv?=
 =?us-ascii?Q?Pa9NSDkk26+z8miseXs5yYuiHualw5KzCpajp49cS6xApyNc9QAhHNnjVg+O?=
 =?us-ascii?Q?qnAPkoWUboyTUYk8MMPWFvymXthEQdVUn55n4oGwwUnu+bajRNqohLaTDEh4?=
 =?us-ascii?Q?Z1tYADaxkveHOCEhlO003KREVz9Jmq7XehxMsFCkwBr5kXMlOUfxoC74W6zw?=
 =?us-ascii?Q?wgxv+SXbK7CKW6mFC+StVecCdxjCDuDsMmNRwDuvz+1fInHsw2WldMpW2wMb?=
 =?us-ascii?Q?332baKsD/Qop+/v3+K230GceuTuwz6yzTwjr4Yuf1stwLzONp+XxpnkQa4iZ?=
 =?us-ascii?Q?/GABpyqsA0wsnJr0sgHY9FxXYI0Mh75bVolrpYFCHFnR/3uvO/qw/gGBXsjv?=
 =?us-ascii?Q?xk86+UmxL+IK8faNMCEsM66RJLueETWOWHrtwfZG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9466f3e-2e0d-4772-2672-08dc15e060ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2024 15:41:02.2342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8CduKHMDn9lKKF3iQkRZ/DpxHtfuzj04aAkmLuxg8jjJd1OQ4EzSXwFhWNp/IGHh8o5IZ0l47PaHPcL0nWBSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6691
X-OriginatorOrg: intel.com

On Monday, January 15, 2024 2:35 PM, Kunwu Chan wrote:
> kasprintf() returns a pointer to dynamically allocated memory which can b=
e
> NULL upon failure.
>=20
> This is a blocking notifier callback, so errno isn't a proper return valu=
e. Use
> WARN_ON to small allocation failures.
>=20
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
> v2: Use WARN_ON instead of return errno
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index 1cbc990d42e0..61aa19666050 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2047,6 +2047,7 @@ static int vfio_pci_bus_notifier(struct notifier_bl=
ock
> *nb,
>  			 pci_name(pdev));
>  		pdev->driver_override =3D kasprintf(GFP_KERNEL, "%s",
>  						  vdev->vdev.ops->name);
> +		WARN_ON(!pdev->driver_override);

Saw Alex's comments on v1. Curious why not return "NOTIFY_BAD" on errors th=
ough
less likely? Similar examples could be found in kvm_pm_notifier_call, kasan=
_mem_notifier etc.

