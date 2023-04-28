Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3809C6F11CE
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 08:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345348AbjD1Gfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 02:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjD1Gfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 02:35:39 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15D2735;
        Thu, 27 Apr 2023 23:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682663738; x=1714199738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eVmJypiFc85vLwizJvJ8tslWj7OzxDF7DndPrejRUmU=;
  b=QSu1aB+YolIGXRcTNKTbd+4+VNLZ8RJ2cseoXPCCB8Po6xdnSv9DzmUm
   /TAADDzhSTPgWhkdy7bGXF7H1jMrHteWxGLPUdQ362RryhMWQW2zhieZY
   2FjNXcI1arV7qGjmFE15THtad8ZpbWBHPkMqwV12Gg3dGHAEEVmzfHQ4d
   jNCoMPKt4RK5MQcEZ341Ry1MLj/VDabEan4Qy5++lvhmDGOT1qrFhMwpk
   t+HNNzNhrdNuLS7BMiaTl+hI1KaBI7BbYTV2pZt9sRal6V6a/uYJ4l0xK
   8GgetU2uOskmqm+y44Pe3VSiNI8EBfVgarkv/vU7VeHC+EiSQQb9+bl8b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="347690068"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="347690068"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2023 23:35:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="644995178"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="644995178"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 27 Apr 2023 23:35:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:35:37 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 23:35:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 27 Apr 2023 23:35:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 27 Apr 2023 23:35:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4jPR7FZ33qGK7d1/VysOTsQTYlK6cZ5iburp7KyYEQ4Wg6yOE6ilh4zOeL3y+sk89v3Id3cA2+xJmz8mte5ymYCPK/VNsLCjwExtYyhW+roiSUqx2Yf3JFVar/VHFzkuMY+Y6gT27Qflf0dTrti6ns/yVQX3sVT95pTiQyW56CVpUUhkUQKydWabutQp9jKYluGNKC8JRvw63xiQVp68yu1hSNWS/PSMQ3WEOw1CvIQ/z+eVd2C9HEOr36P3UgwayqnAnH+VsiPdts6pNwZihHv7HxbcjAerKXYZeOP4Hd9k+yTz9WOsqQMEKYjTleugxWUiUk0/2FmPJFLK8c7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eVmJypiFc85vLwizJvJ8tslWj7OzxDF7DndPrejRUmU=;
 b=GshkxYwKCHLj3nEhIIQyuICOifkXQgi9WR5w4fTTrSA9OS7qGLZs5/rUatuFnED/YWxnT6NJTBiBUEcmEEHhZHavCPeF4MFCxXjwLxoIl+oeZg6zp8HLGO42mwaftk8s0XRmbNrbZfH+E5+OlxbKrAY1ZBZWnXZTTz1BHza4LQ3Nauii7XF1axTsLEWYuvGZbS7TZvSj3+7UvT2PL3S7PO4YEaUrbTui7P8aic9rnxxD4lfsqJPVz1erYdaJqqUH1L8jOlJkA0Ermnia5GTDuUckM6oDozYssW1rPcUSg5nkWUuiLhe5Mnq7h5fzGrWReoQZsKldh2fRxmOxs3iszQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8376.namprd11.prod.outlook.com (2603:10b6:806:389::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 06:35:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 06:35:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Chatre, Reinette" <reinette.chatre@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V4 05/11] vfio/pci: Use xarray for interrupt context
 storage
Thread-Topic: [PATCH V4 05/11] vfio/pci: Use xarray for interrupt context
 storage
Thread-Index: AQHZeS7LwVOBrXfz6ECqvY6p4pG9Mq9ARM7A
Date:   Fri, 28 Apr 2023 06:35:29 +0000
Message-ID: <BN9PR11MB5276870C3A3CBE601A68838B8C6B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1682615447.git.reinette.chatre@intel.com>
 <78182c9cd770885b6d354f114ba157c7024c8b39.1682615447.git.reinette.chatre@intel.com>
In-Reply-To: <78182c9cd770885b6d354f114ba157c7024c8b39.1682615447.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8376:EE_
x-ms-office365-filtering-correlation-id: 58bef5b6-3184-4841-f21f-08db47b2c2b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LcJLc+bQDMKuGg3MH64RczgSkCJcYdT0PF1qFB2ehxt538EvEjXZYBwLDbm/4XfP8cTV4SR99OXL7uY1LglBrDXcxshsMDkIumCoN9rG0JPE52/AEn6pZM9zjhHIciZaaui2j6Pmt3N1HMlHmy9xuiN+1WhMnHj/qvVoT4Kb4wOSfPomJ/cQp35BjOt0dEkVucrWFyvHRCYssEjKro+v4S4QM3WYZ5SjIzv5FtkDjA/YCXQCsYd1SsMMuPxjNLwZ2eY6lL+OSS1yL9ryj9sOxGcyKPUZ9TMVvkLseI5HC6u8p0JGxQMr0JBSC1b/XwjHvbseY9rRCE8iVeMY4la/fMFe8Aa5jiOUgstNP+lCkwacUhFq7WlKGZSKQOFGrdooC00C4qDJuN744+ZSmYGOYZZU+1zWXl6attpPZKAw3jj+jcgCtrA9+j4Io2AqTX+SYjSNJmFfLIeQQhyihcjEcxZB2DrqF2O/4UgTaN1Rr6Sn+9UvrOUye8SZocO/3tNLIRqVokh1FJpjcW6/+/2Qn22Dd2NTxQtSaFix/e3gKr3UvINERfmujotlsNl7Rlyi8JSUqw+exMGPaANDWdzMY6tNud69a1WYO2dicRgp92LjtAhL/osOcRHf0slBlnCk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(38100700002)(82960400001)(71200400001)(478600001)(83380400001)(54906003)(110136005)(7696005)(186003)(66946007)(76116006)(66556008)(66476007)(64756008)(316002)(66446008)(4326008)(41300700001)(6506007)(26005)(9686003)(86362001)(8936002)(33656002)(122000001)(8676002)(38070700005)(55016003)(52536014)(5660300002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FCIOCbsTxNILXcYBxNEHamFjf9iV52F5ibZQ9oKbHxHHK+RDglhKn53EaTEt?=
 =?us-ascii?Q?Gv3jr43JXaxpZuUoqLk8X+smrinGgChfCyP/MvaEX6kS1kUi4h+VHBbQIILV?=
 =?us-ascii?Q?bDV2P6pkPJu3i20CsPJdpykVFgewMFpmgN6LAFA4NZA7S+ezTwt/H/w7p4Sx?=
 =?us-ascii?Q?X/a6stW74hID2xMNMLmhlGwXt6Evy/+wtynIzZ5hRl8SwU04M+8Gk25qniXn?=
 =?us-ascii?Q?uqjy6tCFxWSa2BYjqzU8xyk7/v6Qxt/Btu0+MjW25fhEpInuI+MRxqN6Ez8m?=
 =?us-ascii?Q?X1Svm41W4GbD9SeCvM5ntFqNUT5mpH9NEagugk0YHUbebAHl0RYZpe5trlBX?=
 =?us-ascii?Q?4nsgE1NvsNUN4yrtavpamyjyrDHKyfXcOkRGA2bJJZHrqavLb8kz9Q3idmAy?=
 =?us-ascii?Q?eoVqqFNjPFHdZ+oni7S/rRM3ol3Mbls5+lQMHagJYk+ob7/2aGIRtoKoZtlB?=
 =?us-ascii?Q?oNbgugKNhUt1AHVLaHr/z1QUZG9srcOaK8VPr/e2b0MG+aZ7JXGxG/v8+t4n?=
 =?us-ascii?Q?YPEzUaVk3bXsUHGsbnZS8hsZnqbDYpTaA1w2pxYz0P1W5jY36hCTBYB3aL5B?=
 =?us-ascii?Q?P6BlYoa7m0kdJf7mEadpw/r2URVnWVfdyylr361l/a8KnGeAyjUgMglWQkhz?=
 =?us-ascii?Q?SVJIZ7d74xj/MNUGmfEheRC9cQQufFtCwTg/tXSuI5pPUNLpYu5mcVOX6d6I?=
 =?us-ascii?Q?4F1T0D9oSNbMRhiXzXuPFaob1AVFZAhJxnQ+flNrew/Y6JUDFjslGzY4zo6U?=
 =?us-ascii?Q?Y2QzE89p1OyLJuSZyg5GxAvj3QJMICn1Uj6TEak5nFKY0tf/4G0kIUManphB?=
 =?us-ascii?Q?vfXD6mFLVNYlTN033KpN75Q2zq2awtPHvdHkPTwmjl40wfSjZc5KWhkvBZi6?=
 =?us-ascii?Q?zNPIxo1FvBgnzsuRyXq3qZ0lXOuUzghq/Yv4vdl3Htrrsj4n++M3snVMZpZG?=
 =?us-ascii?Q?CxEymJjgZzo3VBzUjT6CSHaC1utqn4HV5iDydELnv5b/PUS1KekCJMA5nnbv?=
 =?us-ascii?Q?FD1Til3jSS41IebmnOYgM81SywzA2SFmy8mjMytOZEkpz1vCePPqjEUsAiuC?=
 =?us-ascii?Q?e7G8VyDjUA/tY62nxlLaO1nynMnAnDadhXhvI1LbSHGW/3OM9fLC4VbTaGdj?=
 =?us-ascii?Q?yKrhA2Q3yxfJEFCmygt57LsrqueVl+GnmdUeNNwvxGdJgoUt+3ms9xjr1d6G?=
 =?us-ascii?Q?W+PUm+8I4H2s+J97W9tgorKz3GTIiNBETGmhvd7EsRhgyfxAKYx7fRureur4?=
 =?us-ascii?Q?8pLYUy7226zORVEebG45l1F3nqXn1zQnWtS7tE6rT7+MoOGC13Txizu3IEOM?=
 =?us-ascii?Q?9kLZGlAbhKATfjwpy8UbB/wrTqTgjRt+YYcsZ+bNn6UEFuyIV56vF/77tk7p?=
 =?us-ascii?Q?KOA+eG97DqDlucyilSjzi2Qxif9pNGFFwl9WLvYCenUlOxSKK9+7WkNZtXVY?=
 =?us-ascii?Q?ei3mUR6AO7sxkBLF9bWC7eb8wDBufJG15vVaa7zEreWIPcb9mz1UMDRMRaAs?=
 =?us-ascii?Q?DQ+de20Za84EJOdpB10pzm5YnjzVIlleN0hhzY2AaNCVPrr96XQW6V7Yz/dZ?=
 =?us-ascii?Q?EfGTM82tnq3VHOq+dKfDgfkuMSStYoWyJOCVWvmw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bef5b6-3184-4841-f21f-08db47b2c2b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 06:35:29.8795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NffMaFqDwNcsXm9CW6qNohzhAhaPxtkBNhXcNNZfKazFxwlqdvIHd0dGzEDYusAxrlpP5CA0Ywexiw5SRX/Y7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8376
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Chatre, Reinette <reinette.chatre@intel.com>
> Sent: Friday, April 28, 2023 1:36 AM
>=20
> Interrupt context is statically allocated at the time interrupts
> are allocated. Following allocation, the context is managed by
> directly accessing the elements of the array using the vector
> as index. The storage is released when interrupts are disabled.
>=20
> It is possible to dynamically allocate a single MSI-X interrupt
> after MSI-X is enabled. A dynamic storage for interrupt context
> is needed to support this. Replace the interrupt context array with an
> xarray (similar to what the core uses as store for MSI descriptors)
> that can support the dynamic expansion while maintaining the
> custom that uses the vector as index.
>=20
> With a dynamic storage it is no longer required to pre-allocate
> interrupt contexts at the time the interrupts are allocated.
> MSI and MSI-X interrupt contexts are only used when interrupts are
> enabled. Their allocation can thus be delayed until interrupt enabling.
> Only enabled interrupts will have associated interrupt contexts.
> Whether an interrupt has been allocated (a Linux irq number exists
> for it) becomes the criteria for whether an interrupt can be enabled.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
