Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FA74F916D
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 11:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbiDHJKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 05:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiDHJKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 05:10:33 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CE71DEC2B
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 02:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649408908; x=1680944908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ugfBedNkqh9YJZgelL/ocqdgqURIHO5nqSVh0ycWhgM=;
  b=VbRASR6f2ySMUThrflOufEfY1ZfKDbhM50q5/l4b5A8yijzqnjRHCNeW
   BgqDD9oWDfRiuN4wjYGqv9ZR8M3ORdaZ7YPQcIQebF1avSWTjZPccpnXL
   jMhKgiRKSjCl+Qzb4BamzW5r0ZZa6u2WOSj0J243/NwTNab+aOuHZXqGt
   IJORG1PxnA8R5NrpOj/A1yhfjMWojXqUuYaBZuLcUJFafQN0F/lUSlHMR
   voLhsgMaTtvBPUHV9DrpNBswCMe2L66EpjJGE9h+OGGo0JzWuQXwoZBV+
   zhC6Y3nGOYdhnEdDhbw8gLGcZqogK79x1Mn0aUbGgtLz6ItK6M/tN48Tx
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="261726422"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="261726422"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 02:08:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="659418433"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga004.jf.intel.com with ESMTP; 08 Apr 2022 02:08:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 02:08:22 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 8 Apr 2022 02:08:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 8 Apr 2022 02:08:21 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 8 Apr 2022 02:08:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9SSKiXZJfuN/LXdIC/AI3CvHAVgl5k/cGA7YPFRvkxSAs0lO/6y9tu5Z9saXLfKFEJRb4gJUBt4xwM9mqVuoy1YW9hCdfObd72tShoZEs5dEBRR9rS5vxzrwfup6kCxag+s44dxdF7KwuPstn+SMPam1ogHkqV8rMz+HxN+Vi/hqEGSzVnUaJ/+jnpIaE/uKf7QSee/lMJyT+pt+owvbpSLMrtqKbstcftc/u9+W6oCvZWJI2wu+gaRglABb3SPmMMW69ypAUsUzfcKwcT050CUxdU61Lhzj5oOFQQe8QARd+xX3zyikQhkUr9C+crDs9xQQMLp5e+nGmGjkMl/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UX9orDa4OOQz5MAN6KlPTh+wVlNJ/z6+vG9gQvoKMrU=;
 b=eSS2qh2REeDOn07WapfoUzov2MJSAh7D/tGOVHPyUtDV8UPp/bSomquPx++WZ4OiIHdRyVNqFUFiluP96sn4xrILOLz+TohrOrUBtDDamwDy2Q3ao0AMh0TIl3j/qcbxMsdfU9NFzoRA9To+0ZtVyelxcrg46UXpLd1vizw0VXmTKQIc4RqcVnvDvGpHbuB1FtAV1dknpU4ph+yeQuWUYYrh+MOd58tXgKsbIKdmPd84Bqs4/5Dixdb+2ySTlwe7YJVtPQ89/SoBV/qzg7q4Wrhsr5ncZ/aaG/PxlB1afm+Qoem//3R6viElYDOJuYRFratxIMVDMo/F57xGI1ZMaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BYAPR11MB3062.namprd11.prod.outlook.com (2603:10b6:a03:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Fri, 8 Apr
 2022 09:08:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%9]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 09:08:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, "Christoph Hellwig" <hch@lst.de>
Subject: RE: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Thread-Topic: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Thread-Index: AQHYSpOFxZ/QKUg0ZEGhoQEsmfFbSqzkrbGAgAALHwCAAAU0gIAAEooAgADpbQA=
Date:   Fri, 8 Apr 2022 09:08:18 +0000
Message-ID: <BN9PR11MB527648540AA714E988AE92608CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
 <20220407190824.GS2120790@nvidia.com>
In-Reply-To: <20220407190824.GS2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63e3b56a-2b34-4a7d-8f59-08da193f52eb
x-ms-traffictypediagnostic: BYAPR11MB3062:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3062580931226AED14FB974B8CE99@BYAPR11MB3062.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6xgnG2O1Hp2pmaOEmqJ/XOUUvSh3Te8PqkhQXR1ELpL0zu8YSSKVAUAb1GGL52yefP+xahicWzIKttiJhynIvACeKQdtHnH11pq4VpT9t+I9YY0rcfyGMgKdHuEqE2PspDRv/tULVd/4tsfNGSoTxex/x8hRhrVq4LP8QDYMPsnrFf+VD9KorySLnZKe/I4tCs/GwFWIVGPUEsgxqkm3qVnhWWKvWWtlTJpeZO+fHNqchP6rBentAM6OyvgjJ+hMLHj9DXUzrAr8srOAxa5J0gdUMOzvdG8J2ctIIWJJLiNqY50+MkWvxUblWAGanDM57o8XiruudkegCpFtVY5Yc9yz6XVSZo8S9lIjvBsa75HUYS8/KKj59cnSqlpKFPYQxyecaS+GYm9ncBxOOzv0+vKnw+YTEl6sJDclu/SMbfT9yFuxsNBSxWUJNGhHy84sOgps+k9ZgQTkS94Rm6weFnAtwSxyTq+w3K+2gZX+lZmIbUbE4IVevO2ZE7k2lMEGRuvxDWQmmyOPlkrIQddauIoVSdphDrrihaU+T+1jfY1tTiFQXU8xTYWppZ48XJBt0nECkzU8TMhlqRNYokDi+SfD1Kptm/9pGBvOYjP1+zyMwLG9cWRxnromRwMsCCmuN3ppS8w89wLkmZO/NTTMO23vj+N84xPwVEeJR4XFen0wtrZfC3l5xm7ObzvQfVPlAxGl0jBfZYBnGWxFNisbGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(26005)(186003)(5660300002)(38070700005)(6506007)(508600001)(9686003)(71200400001)(7696005)(54906003)(53546011)(110136005)(55016003)(33656002)(2906002)(38100700002)(76116006)(66476007)(66556008)(4326008)(8676002)(86362001)(64756008)(82960400001)(8936002)(66946007)(66446008)(122000001)(7416002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xej3Cf8vgCdIG7+wZ2ybbLqwWJrHua8B0sZFLbY8wn0oErRzX2aCxQM9FrTc?=
 =?us-ascii?Q?28IDSQovrI/TQm8EiL97RvFzSxlgN8N8/9cHwC4nvIglYAzxgRtprCqhzpfj?=
 =?us-ascii?Q?I7Nr1ogTokpiLEHm8y4VgUg4uycRvB8Vct4fBiBTjUCyRfhnH4qYinPDOT9l?=
 =?us-ascii?Q?RxoExCXWPdCWfk0ESho3XQOx90KN6/30wd5Obr9nLvORv+sK9ElvCyBljk2G?=
 =?us-ascii?Q?wfBOO36V0tEtYUnJGVSWmLIp6cYlNn20FYZk+TKcGot5z9B14EFnoWjoI+6i?=
 =?us-ascii?Q?XGe607TiyeAjUtEq2um4Wb6nWSY2JRHxnNeJRcHAJ1YMo3GlzyhBHOYVm/NW?=
 =?us-ascii?Q?E8OgEGj1cIjr+qTHeVp1hQyYm0AQWJe07si0hcG6Le4HK+hg0B9fPPYkxa4g?=
 =?us-ascii?Q?SROsVg8ZV2UF+z99YsG2FGqyZWep8YFxgyd0mawP/MOgqm1L2Yt8xXTxvyQr?=
 =?us-ascii?Q?ohyHnTJhJo4pXOmIviaPDnRLiyhD1fZ8HlGP2mTJrxmmEJLIkrJXoTy3IW0t?=
 =?us-ascii?Q?HIYwyg9aqZAxsaWno9lopEPsKf/2/NkrsypqdGnQLA0bXOBLUOMfaD03cSQt?=
 =?us-ascii?Q?jaYU3VKwagSfHuJjwyl0VukV0rLRbK5Mi+N87Mvz1FlLZOidLGpi31SfUNBd?=
 =?us-ascii?Q?cTqiQ8bJLoxQWskQohm9ORPSfJxXjM1nZMQgAz+PphZ8ve3rpj8cHGsu5XFe?=
 =?us-ascii?Q?9KCULMBpONZX5vAK07h2/f73CNfcgvKFKI4NCd5S4A5k917Hn6mzjC8+rIbn?=
 =?us-ascii?Q?LEgU/apLpsxhzjnmok5eGPyliTIE6JShrlxnSmGzP15Hzb/I47VsVKMVoHkY?=
 =?us-ascii?Q?vNGV0deE3g1GDXjeAGNw5xOwbtizqOx2OOfSM2bafLd36JuVHLVHZpQVS+bp?=
 =?us-ascii?Q?fShBT0re9H3pWdL4OH8pbDJlXcFeQls42gwdU4krSfxHPHuygaKbB9/P/aey?=
 =?us-ascii?Q?XxKX5/o0/G4Or4sALw6r9vWwxcHdaw+qrIst6zF+RsJCCYDm4RjIFRj+bcgj?=
 =?us-ascii?Q?xTqJwbW3tt0YpbBkdqjt25pjUBC1QJEL8QPiR1sc/GDXZwQotA4igFzGhWWS?=
 =?us-ascii?Q?s6sniE16gCt9Kopp/ZkZmPpRd/8y1vYtZ2LEF/SnTQpZYBoKt7CbyEq39ktJ?=
 =?us-ascii?Q?U4fxu40NIUJ8DO03gwrTHubTRI1cmT9TG+tiwJpKP9SUP0UyI+13fHKIzgO8?=
 =?us-ascii?Q?2oQHRaTxbWZkpHLm/I4rHUiHXq8C4oCwOdJhi7MLvXvVhVpAh7yqY7igzHYJ?=
 =?us-ascii?Q?GfxxCYPFWHBwgIs8ixBggr572NEIzWcGfxfLDFaetTvzM8dzYRMusVc/Y22p?=
 =?us-ascii?Q?55rHBNjSt+o/QpkenWAR1shfIabg1kp+0uPX83lzSTQquBq9+bKlHZ7fLiZd?=
 =?us-ascii?Q?VTMsO0MwfRHcazu9JkF0EqRStKOtQuQe7bUvPLzPc6k+OdzJNsn9QeEswV2Z?=
 =?us-ascii?Q?77H4QzJ6EpGm1JvbJsIWswABlGvuyAaSaJ6ZErxsOe+ZAPoKYQCOUxCCrsqC?=
 =?us-ascii?Q?t2e9NC58dNqzla/ZVOUgfsHTYl5Ev5wz/CYUKBKp6+TWMIFDy+7JUqYxMQoU?=
 =?us-ascii?Q?Ts7xAdPrx7y/iIwM1kUVfMG5Mtgp66ZIBYf+sT1AlU9eTXodq6vCG/SnqmoK?=
 =?us-ascii?Q?27GS05LwrMCZd6N7a3qM+wH0/LOoBYUxrzr1//tcM8jsoWZGQuCB44RkcBhH?=
 =?us-ascii?Q?3QULHIr/PhsbaIzlErVgHnjDFf+MBZdFLM2jzi0wp8eCu6q/BTwFUjQh9hWU?=
 =?us-ascii?Q?fZFHb9Y8fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63e3b56a-2b34-4a7d-8f59-08da193f52eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 09:08:18.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +k3TT5NZSbWDy/ODRykeQzFL2r3nx8S6BoDzSqRtq88rOkIN5PfSzRMohPxVOT/kruI61ccYXRkXQDDYO82ldg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 8, 2022 3:08 AM
> On Thu, Apr 07, 2022 at 07:02:03PM +0100, Robin Murphy wrote:
> > On 2022-04-07 18:43, Jason Gunthorpe wrote:
> > > On Thu, Apr 07, 2022 at 06:03:37PM +0100, Robin Murphy wrote:
> > > > At a glance, this all looks about the right shape to me now, thanks=
!
> > >
> > > Thanks!
> > >
> > > > Ideally I'd hope patch #4 could go straight to device_iommu_capable=
()
> from
> > > > my Thunderbolt series, but we can figure that out in a couple of we=
eks
> once
> > >
> > > Yes, this does helps that because now the only iommu_capable call is
> > > in a context where a device is available :)
> >
> > Derp, of course I have *two* VFIO patches waiting, the other one touchi=
ng
> > the iommu_capable() calls (there's still IOMMU_CAP_INTR_REMAP, which,
> much
> > as I hate it and would love to boot all that stuff over to
> > drivers/irqchip,
>=20
> Oh me too...
>=20
> > it's not in my way so I'm leaving it be for now). I'll have to rebase t=
hat
> > anyway, so merging this as-is is absolutely fine!
>=20
> This might help your effort - after this series and this below there
> are no 'bus' users of iommu_capable left at all.
>=20

Out of curiosity, while iommu_capable is being moved to a per-device
interface what about irq_domain_check_msi_remap() below (which
is also a global check)?

> +static int vfio_iommu_device_ok(void *iommu_data, struct device *device)
> +{
> +	bool msi_remap;
> +
> +	msi_remap =3D irq_domain_check_msi_remap() ||
> +		    iommu_capable(device->bus, IOMMU_CAP_INTR_REMAP);
> +

