Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51AA2605F09
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 13:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJTLhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 07:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJTLh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 07:37:29 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871141DC824;
        Thu, 20 Oct 2022 04:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666265844; x=1697801844;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FSbILJ0Q5Rt3SfE9NYBirr/7ZrgEOCAF5YA2r4qVst4=;
  b=gzvZLvQRQ1KfkHIB6I3OR3nlbyovvbmLlyvPDMpfB9jmbpYOEJm34xpB
   D5MEilvsqySMxxKyY1LnJV0oRqd0LTmoP8nF9O/ycUa3GXL7ET/1nGOvh
   PVyr1VnU41d5e8qQIKd7hAdREHj2gAwG+Wj8o5Ng8JWVbbSQ8eFyMOTvD
   odwwH1facdGdQ7dV6CaO55FV6gVEvx8cNHE+TxIEpizg97ZBWXpKjkKe0
   u3349ObEeGRo3KGqFXm4b37Kfu2J/CxmhW9r1xIGyNg39idzaEwqIz3N8
   kDFmFkM0CS0ShReibgASNk4BuWrzAVAeXzqHO6qNLtu+7JqBZHDvx2xFd
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="392985470"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="392985470"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 04:37:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="734780601"
X-IronPort-AV: E=Sophos;i="5.95,198,1661842800"; 
   d="scan'208";a="734780601"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 20 Oct 2022 04:37:24 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 04:37:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 04:37:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 04:37:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 04:37:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQNIhnpu0egIT41X7pliBcGe8Cg5SpTst1JerkBD0mMKKrjud+eyncE6sgsTg0qSp8d1MShxxqeXKTnWoKKGOh4tK/AGMN3ZaXYmAHpwiKsCeL0PPO5zKo0b33/nn9uB0zg4NMQiFx3M2U5gSwk8TlcwhFi0jeEwKBsgFkjoFL2fGwowO4Co5l/kJ6vy8HBq1tY8+hcrSzCyltg5iG/28VOB4ue8v+npKweLvsUTfpZp7qwpq/F56ICFgKSBaSYdjzjYpUVw3LB1vziizu4awF6ROarmm4wDtewDJpgwhscaZfB+awwtNai3sFRrwLhNb/9bL0R/r0TiLoU2kPs86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou2xlBApVDqtUuQnIevbWUyQoPhXXNzKMsyavgOZX2E=;
 b=TgpiLXKtaBrP9l2t/fQvOUv5sGjN1mvPhOoXuoDsJH/5473K4LwHxK/F1Du54hoPH0wEgssD0Zhc/LA5tKPbBWUPKlZtUMNZPqZyQT9zb7uOoIp9oAPfzbT94qw1uFeUiZFlWTojW3tlyh6+fe59Fdv5r2xRBmEFVED1uMqqbx47RKdY86sJN+PG2zzPMAVxI4AFoltNgUY5eAucKXG2kMV0efranncN77acazNi4kdvM6siXakN67X/R2UVyDFEqtdbd0HAfKu+XzCSZAScGo9ZAuZ/ncMmz/3LYXee8mhfwqz6pu4YJPDHKVPqIIdO05c9VI62n2xwAsTXewaRfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 BL1PR11MB5431.namprd11.prod.outlook.com (2603:10b6:208:315::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Thu, 20 Oct
 2022 11:37:19 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::4625:d63e:1152:1246%7]) with mapi id 15.20.5723.032; Thu, 20 Oct 2022
 11:37:19 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     David Matlack <dmatlack@google.com>
CC:     "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "vipinsh@google.com" <vipinsh@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: selftests: name the threads
Thread-Topic: [PATCH v1] KVM: selftests: name the threads
Thread-Index: AQHY4kUEXwKyHG3+pEa5Gek2S9rL/a4V/BSAgACZBjA=
Date:   Thu, 20 Oct 2022 11:37:19 +0000
Message-ID: <DS0PR11MB6373943463AEA7C3617CAE30DC2A9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221017162448.257173-1-wei.w.wang@intel.com>
 <Y1Az6y1X4reOp2n6@google.com>
In-Reply-To: <Y1Az6y1X4reOp2n6@google.com>
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
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|BL1PR11MB5431:EE_
x-ms-office365-filtering-correlation-id: f040ecb7-c4bc-4cb2-defa-08dab28f7281
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sz6MQBz00lt8roxWfg6MwjDRdGkpvRFRIbSbTvUh9jdFrX1S/k3Hps9OncO8Spj9cqqILH3YkU7q6gL0BcreHAkAaaNJPhmTFqsi3ojVrs6UTX3b+ABtmIeT9oxm5OYlm6Het+yj3mgO4dPeT3cNRf8rUup6AJqfUXVcssgCPpvvTh2cQ357Xfb+IgC//KGmS7IW3R4rumAsdp/p9OC/dhhZ222XTr534noAzL5QKWBuczMeO1/sFJjgSDyIBR4xR6c+yHCc7Np9TK1pX5143IGaJKptxPFUkB2ho88uEtdW4azF7NZyy+QDzHamtA4lxzu/lOBSd/YGIyhTo5fQZ/8yEMf0BK85EYjBigbqj1l3OXIvyw1v79kP10xJ+cR2gjDQlVNmi/PTz/IkBZKqzaDH0cuo1MDzNbMgXrPQajAGD2OtoXHFGtNnzPtSUbp2MVJUDHhuV46ORBX7EZMafbXqX5nfE2fn70G53GdAkTIhqKaRb28sQUaKr0DhwYzYCdAJrI6PzOsAcakzIfdJJReXhR/STOKfzrYA9OEBKpgTDXil/uPs6LGvKjgG/Q7NdDQH3NI6YGTD4z+otc1OJJ5AM1coN2DKj8j5icG3SXCJGQusUZpbzBbRSOgcqYwtprSmymAG6ZxR+DWKAHOqQlBQWbNdiYH4R+hjpwdSNv9plIRVJFF83nmMQhsYL0M2D/yK7vId/eFH+3WDwauoZ2oL3SL2goe+DOudDdBqYCPcsKXsBXJZSrzxfwn9hmwt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199015)(38070700005)(38100700002)(122000001)(478600001)(82960400001)(6506007)(7696005)(4326008)(54906003)(316002)(9686003)(76116006)(86362001)(6916009)(33656002)(8676002)(66946007)(66556008)(66446008)(64756008)(186003)(55016003)(5660300002)(66476007)(71200400001)(26005)(53546011)(2906002)(52536014)(8936002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O0Ny3LpRRGsEAlkbBr+BnmhGRjCJqef4LkguDdB2Q3o1utWjX0zHnEFFEBro?=
 =?us-ascii?Q?+XfxltseW3uTC8qhW5bljnQIKie69nt8VBWaNaAZNh7npOGvXvHtS8WfJuRg?=
 =?us-ascii?Q?eTC3WOlAuH6S1+5H3iFbhwCv5GE9qVF2va+rLpZJt0lRcJswwvDjMd1acASk?=
 =?us-ascii?Q?nn0GUAjIRBh1ZLD7Qj5LmBmkH5SNWvTQ2/h1ruOT4YuNZ3fKT6DqofKQqIE8?=
 =?us-ascii?Q?D10puUqV9pIvmy2Ey1GPcFMCMJOuaxXmB8F18f1/y8hZMKhJi44VzdQYkcI8?=
 =?us-ascii?Q?vUQxeMw3gykdDIW9uZeQKStPIJtYx1q7OD2HW/7VkTLJj0R+VNwVx0A5Iv3Q?=
 =?us-ascii?Q?Aak9uJP3WnesiZwJY3f6FV4LYEqOdQmpd2fwX4sQco2B4U7G/g0VxsnkFxdC?=
 =?us-ascii?Q?AFC5B9fLerNNZwJb98r5dGR7gTm1YBqo5GvEBcZ88SMfa2L2Dk92tkGehgnn?=
 =?us-ascii?Q?RS08sdrV4AkFG8RyVbnFaleD56ysoebsvJcpXt9o/kPuZRfmnIwYHBId22hY?=
 =?us-ascii?Q?2wuZzJLbw1IlB+Eh7lUlG4YqKOxwc+rdpfu36eUQMbuSXrQeBuDloA28Ch/W?=
 =?us-ascii?Q?aynVXjStXYSOrh7cphjvQEnbapMFO8AC75UECoM3Ad6nerMSSUZ8tUClDnZ7?=
 =?us-ascii?Q?G0ZbzlVXEFru9PkLcIdnavjAx5ncpMNF7k76OB6DeHsRZLoXk/YCAW5ANMpz?=
 =?us-ascii?Q?RfhUt1mvPUlCKOfa2owj6inVqkOfw9k+5lHye68oOCNer+kLfRfgkZFA5Nxw?=
 =?us-ascii?Q?5NX7sMPKGDoZPnHS3dYsmKs6pfTqY0359SHmzgye2anC3KkPKsd0GDioNIaL?=
 =?us-ascii?Q?+JkaE5szeYOoCe/JsIHQZ2WO5O/gWY0WAYWtgSUJDhXedZk+GFf7ttPPPwT6?=
 =?us-ascii?Q?r/ozX958uM+VwWN4CAk3HQF0MYpUhqvKVTkAH2CgKLpGq1txg+zAjaniogrE?=
 =?us-ascii?Q?QP0h8ZqvFzzrOd4750EmurmbfT5ridNIQduCv2o0XtroyCsOtR6GBmHjOHQw?=
 =?us-ascii?Q?vLwU3Jq/rC674uszwQedHOn0emxuZvHO+oqtgjQdbe+JO65cZwiDJY6/qvvP?=
 =?us-ascii?Q?2doJGcMgBkwTdivXA9Ln0WYyDG7uvva0AEWeFWKghEOyiIw9uwex3QGJSGRa?=
 =?us-ascii?Q?eBPcQ1tCIi7f0iV0OnNDzZTZLNW9p4sWMWQf8Qj5uCTS7iswe2AfcJUbKfsC?=
 =?us-ascii?Q?YnpTz8EKph4n9YnSHQnPFYf8z5vtQx3P3mXCeWKgOh4iWvkvZ+Js0BOuenIc?=
 =?us-ascii?Q?V2TF8R+XBV9pLLEnm4DDu2Jv7HQIXwN+G+B1K/3H1QArAnNnNGNflG2c6/nI?=
 =?us-ascii?Q?pUjICPzL3A5x4by5djISvSk+6OOh0JA7/kxwVMYCFEuVbZ3QOU2UH6hpK3CF?=
 =?us-ascii?Q?butRwXjTczXlu2kkaguuKB1YDgAgdrXLmpDk2//ee9GVn220ibdmD3yKbXgJ?=
 =?us-ascii?Q?F+//s1HksopqLzzjbD6kznP4xi9s89JHQjzo0Whwvqx7LzLcLVGxNf3lJevc?=
 =?us-ascii?Q?T7oCXKahxypTCzeKQo6ojkF0SvqpBaaxgnnWqLCDExZXcFk3Ld0NZORuwfFm?=
 =?us-ascii?Q?7qBHxMsX887DPVz1QcMv/SNXqrxm3YIdwZUQ2aNg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f040ecb7-c4bc-4cb2-defa-08dab28f7281
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 11:37:19.7058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XI50yDgZK73Rb+fATaTU/93UIAvC7NBw6yYyEbUtXmDOr1f8yuyu/Oz+16aiYdwdbEtcQvFACjuekVnA6Q81Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5431
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, October 20, 2022 1:29 AM, David Matlack wrote:
> > +/*
> > + * Create a named thread
> > + *
> > + * Input Args:
>=20
> thread is missing here

It's an output, I think.

>=20
> > + *   attr - the attributes for the new thread
> > + *   start_routine - the routine to run in the thread context
> > + *   arg - the argument passed to start_routine
> > + *   vcpu_id - the id of the vcpu
> > + *
> > + * Output Args:
> > + *   thread - the thread to be created
> > + *
> > + * Create a vcpu thread with the name in "vcpu##id" format.
> > + */
> > +void kvm_create_vcpu_thread(pthread_t *thread, const pthread_attr_t
> > +*attr,
>=20
> If I'm reading the patch correctly, attr is always NULL for vCPU threads,=
 so just
> drop it until we need it?

Yeah, sounds good.

>=20
> > +			void *(*start_routine)(void *), void *arg, int vcpu_id)
>=20
> I think it would be helpful to tie the vcpu_id to something real, rather =
than
> leaving it up to the caller. How about passing in the struct kvm_vcpu her=
e and
> using vcpu->id in the thread name?

Yes, with the cleanup you mentioned below, it would be better.

>=20
> Another cleanup we could do on top of this series would be to stash the v=
CPU
> pthread_t into struct kvm_vcpu,=20

Yes, I also thought about this when I made this patch. I have other optimiz=
ations along
with this change, and this will have a lot more changes, but we will get mu=
ch better code
consolidation. Let me post them together in v2 to discuss.

> which would eliminate another parameter here
> and make this API super clean:
>=20
> void vcpu_create_thread(struct kvm_vcpu *vcpu, void *(*fn)(void *), void =
*arg) {
> 	...
> }
> > +{
> > +	char vcpu_name[6];
> > +
> > +	sprintf(vcpu_name, "%s%d", "vcpu", vcpu_id);
>=20
> There's no need to dynamically insert "vcpu". Also, could we include a da=
sh to
> make the name slightly easier to parse? Putting it together...

Right ;)
Thanks!
