Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A9457BDEB
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 20:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiGTShy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 14:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiGTShw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 14:37:52 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577072ECE;
        Wed, 20 Jul 2022 11:37:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRu2wCOadK2qnpeO87Wpes15xcqNnzD7fv8tWQRChkZp5GuBoY2eT8kk2g9F0irvufUITgnZiHLjdsVq3G+2S1d4wMYgLE6UB9pxVSUff2txu/giFdsEhylHiLugWbwUCGMeZCV9Vo0JDkPamhdxCsM6xWp1/IxQZnMaeoBFrd+aPgDUcGjKOqndHhzdWRPid7YqQBTcV1+9C0PKChImI2ffWFdMXjWvZkg2kR0igu09TtNE/newm4F7lPORkZkEPSKt9LtfQA/AHLmSwli7Xt/H7Y3n0MwmiIpvOL3xpxADRi6IzKXXPqcYiNl/c+Kk29rSXBUfzmyIm+CTlBR0yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKrhFJW5u3N+jbmuZuAjel1hzViDvbmyweUId4fxPbc=;
 b=bgbEu3J3RPrCkAPvR6gGpjKAHOhpTKqeVd6N7Qa01RrLi/ipS8i9GS6HCiUv0ylplspJe+7e4KD/k6n5PUNdwQ2WJM6CRsb3vKOcqQ9Q+yz88xZKeIEXWawbfS8pd0BTbGVZLNPz/vPBV/hMT/zLwOmvaVMp75YjJ6CTKaFB4EdZNHzzRBFFuo0HXQxKGBJgubnvGlSSok31Nfy4x2V4hoU4jTAsqEfY3w/5ZoYiynF5Pz7T6L3Ggi+D4jj5eMQ1z6Cb99K0KXm6jS0AmmguCNpl06YZZy/5aAVMBJk95zBScDgMtpINE3sZAdtsGSQr43weo/R7SUd4zoA9daMnMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKrhFJW5u3N+jbmuZuAjel1hzViDvbmyweUId4fxPbc=;
 b=Vh+M6wCaIz03rsaupnloIK08CEnzTS6owJYNcWAqMEWoGJRjvRDuVDvrKL1Gqi3My6etRGdw9WPruYCEIioJg+3+4zOU641dPaR8NbdcRNX7VxaU22vqhLv+QqQsRd1+DgRgU8SSaRgXhZ1E6fLkbOmkB9clEfETU6wvTkZ54xRfo1AoxTcckBcTkw3HEOhy21FjeApA7T50LrNoFqdcBFdrh4UKDF6oBlhKpnBNN3j2x5VZlMy4/3uMmlxUDHjS1k8wCyA/R3nhqTbZ6tXuvVHSNEKVCv875n7tdUWA/dQsXB5VTjMbUl4axTPXOVVztKyCaViZTTmLHPGf67ITqw==
Received: from DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16)
 by MN2PR12MB4566.namprd12.prod.outlook.com (2603:10b6:208:26a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 18:37:46 +0000
Received: from DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54]) by DM6PR12MB3500.namprd12.prod.outlook.com
 ([fe80::9479:3bdd:517e:1d54%5]) with mapi id 15.20.5438.023; Wed, 20 Jul 2022
 18:37:46 +0000
From:   Kechen Lu <kechenl@nvidia.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v4 3/7] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Thread-Topic: [RFC PATCH v4 3/7] KVM: x86: Reject disabling of MWAIT
 interception when not allowed
Thread-Index: AQHYhdK25QGQTvu5mEmoX9lZZPTRaK2Ht6YAgAALZPA=
Date:   Wed, 20 Jul 2022 18:37:46 +0000
Message-ID: <DM6PR12MB3500B287FDB67273470985EECA8E9@DM6PR12MB3500.namprd12.prod.outlook.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-4-kechenl@nvidia.com> <YthBJsKOhgHfVs1u@google.com>
In-Reply-To: <YthBJsKOhgHfVs1u@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3558ad7-cb51-47f3-ab51-08da6a7ef0cf
x-ms-traffictypediagnostic: MN2PR12MB4566:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A6bUgUxMszN/iGpMGwm8oK0ttgmGjBpS2t1bB5k9NVcSXca/0BhhcDzkQnC6IBcC+2QGUh57e0LKvsqjLBwVW3WEy8BGbaWwiAJ7F6yvQpl37LsGkZhYOHyOEbp8hFdr3ZVRDcCjpkA3StNt7sRs09lgrkGiTVRCFIq3pLwoZVfiDitfBCtlKXgBW0sAice99VEZ0PFm6Oi0vY7Eb0CTWv3cTZxIkRgKEBqhI72kbOP+9XZIJ1fkn15wAbSCJrBSByw09QT5keZA4hAz1fCWW3eE45U3ppO4ZHPE7bWYDQIfrdXJ4dNtppcIm6Z2YcEXf3BXlv7T3Ho5yDuZmtz9nnR4vPYLMKtBa25bZhJyKb9bdZXS4gjk12SCyJajHjLMLjbCFQpcC7ip2tl/iCeuxELOuIEVEI094jqN5Gb1VusdaBJOfcPiVfHmjNQ/P2CdQhxPCCiAIdtyKr3q5GESQlRjx/QlLneL/BJoasYcJUshtDT/o9U40NWt3Kayby2EKiM1c58sBX7iC9JPgU4EXXz+DDL3O8SuMKLLlZUVfinkhf+BGSRwNbU1J5RmZ0f6lRXLnJByiKuE5Qt+JKInVTfQ7PPiLG2G6139AFDhIywXn1GeazfCheyfRA/4mdGDwug5ysKHHLsaxT916WkS1iMIM+oOgQcD5tgdYX6WAQxzI/TtfezCqYTu+jNGWFKB1NEZun/5aQpR13aueM9QUFqj87XSCK9c/jEKhf8MGkUiifn2I1K9VselF50zB6VHNuSE2cEy5RooHfzX0h69YfJbbBDm0nh71yStaZ+ayCjv1Z2uxCQqJqoSCAnkgSTpOYwYRoWdMqFUkLRfTwNwuz2an670ifmcZ+YE0tB0AMbpft7xyaXtJa3YzO0y5nHkR8oJFhDGHeVZwUCzw8EqsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(376002)(39860400002)(396003)(346002)(186003)(122000001)(83380400001)(66946007)(55016003)(38100700002)(38070700005)(76116006)(8936002)(478600001)(64756008)(9686003)(71200400001)(966005)(8676002)(316002)(4326008)(53546011)(6916009)(86362001)(2906002)(66556008)(54906003)(26005)(66476007)(7696005)(33656002)(5660300002)(66446008)(52536014)(6506007)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yeom2rggzQ98l3emYY4ZSLwYPsiX5EOnrcspUB4x5MUpieEkMC583FvYjn25?=
 =?us-ascii?Q?CmnbsZN9nzU/8tovQEyFB4ZXwB3eWhHerTndErqHJwAZAXBXTXOJoecf0oYt?=
 =?us-ascii?Q?n4pnSLJD7vHNdAghV3/fLbNrZfHNtDhsR2PncKuhLc3Yelh+fSGsTr/jEuGD?=
 =?us-ascii?Q?HC/miErygOaAsLXzKrvzdbkareHW8NnxksZFrF3zH53RBE3WlIqwGRDAGwmK?=
 =?us-ascii?Q?wY9Us29OYciewQneDtEDsqR/gqbxGlpenp7i8mwK2vkwEdNfJnCtn6/B9D5R?=
 =?us-ascii?Q?GsXHJXRdBz0DXTjvx2IuM9Y/9lERAZZ2PD37G9Av7EUgYzRvO0Ciwu+A2Wex?=
 =?us-ascii?Q?1gPB/2tHcwVhxGAgFxvCo1Dud1uCyLa5CIQ8TKWdPtabww31WVHyJ9pNVaEc?=
 =?us-ascii?Q?ZP5hosC9NKfmqPWYS7w+1WH2fz+SjTOvUOSAbK+x447C6cwSu2w8Tz3A/Fs1?=
 =?us-ascii?Q?AiKTRnDOCVedhrO1iLJOVc201NBCPAn8JrZX+SpBIWQyfiywAqduCThzwLLr?=
 =?us-ascii?Q?jjKPUQENWN8Umr4mLHtE4qQvVsMHRKcwN3PDjqi4nNokticI4jfPzCpaWRve?=
 =?us-ascii?Q?emPmHXFcVv0sXVGQ5xDrSkJ+TZgIfDa14lnSV8MnMAljeztAElhU1TOAMgJU?=
 =?us-ascii?Q?3Y50nyj15VR3GzjyvabDA+r/z1Jmysx7Np7DgRoxCkRH5gIYk7cUEOKk9sgT?=
 =?us-ascii?Q?3W7jDvMty1QmxJvmn9VE/oTcSUxt1lpiETv78A6F3w6HodVzRHSIJa1TbkPk?=
 =?us-ascii?Q?aYE0l07rF+iWZYYrFDMrzYhpPWEZ4X/lEhwElhfbaSrb3t0n9A+oYShzE/ln?=
 =?us-ascii?Q?PC3FzFajMhTxYQEd6GI6uj9AVS2BXWLhj3EtvTZD0xa9HOkRHhxS/n/xfZoR?=
 =?us-ascii?Q?0zp0/FNTZQpEGwFOVTTCYu43h0Wdy188rKlOhqphDFsA1GPrwDJWVnke9AG8?=
 =?us-ascii?Q?DWxD/NHS5BgtqypvQh5ucqakqRPFrhywOa9CsUZW5Xd+nDZSN2EqkxSQ1nHR?=
 =?us-ascii?Q?i+tFGakzCDOxxVqrVkLF1DX8j0ywgE0E4JoXOGWaMFiIQhcHfHKWY1KWIXB8?=
 =?us-ascii?Q?qlksUoy/Bk05xfq9JJJzMHDOwpOk0fcJD0mD5vjN43KEtvgg6olxEUn836Fz?=
 =?us-ascii?Q?J0+RtUaMJPdE5ro0Ucp/pSSeB7rper1MD+qphbS2bagoGUHfIXJMfRA4hbQ1?=
 =?us-ascii?Q?ztrFtuV8xPAYVaPWIpz7pjZEL3Zrp+DhRilZ4tfZC2NXtxF2aUWhUK28wUc+?=
 =?us-ascii?Q?AR0A0sRt3OkcjUIn0FGznUDJJhUmlt6snp9AAQQfuNahN7jfiK5/PtlMySKD?=
 =?us-ascii?Q?q+PNWWtXDCl8dUzDnWxGU3pxRhS/Stt2gT+Zrs+zOGtAYDcaXYSgbN8g0NMl?=
 =?us-ascii?Q?Td+MHf6+JaUL56kZTVtrWd9r/LhXYULaa86o+HgzbaYqgS2gLK3t/77Az3fs?=
 =?us-ascii?Q?PqTmroGTof96qn4pB/0Eod2jZCIxl7sOwGd8O3ZmtJQ/ElTYpzZMaxNuTh2V?=
 =?us-ascii?Q?kUzC9TCykgBDKUv6Fz02G9KELlNO7+Yzz9oaYNLsHYsKboPP1cEY4oEhSBTY?=
 =?us-ascii?Q?mboUiqJ7Z672rmf9YpKWiTm7aL1MuzfIxBCRtH1N?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3558ad7-cb51-47f3-ab51-08da6a7ef0cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2022 18:37:46.4599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iki0J6DZ4ZfSZvGDWyJxFhPtCViOTNYtMs6+mIuY/ddBsSgx5YVjxNJvVg9DW2+S6IGQWxhhim4FifOOTKWtVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4566
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Sean Christopherson <seanjc@google.com>
> Sent: Wednesday, July 20, 2022 10:54 AM
> To: Kechen Lu <kechenl@nvidia.com>
> Cc: kvm@vger.kernel.org; pbonzini@redhat.com; chao.gao@intel.com;
> vkuznets@redhat.com; Somdutta Roy <somduttar@nvidia.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [RFC PATCH v4 3/7] KVM: x86: Reject disabling of MWAIT
> interception when not allowed
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, Jun 21, 2022, Kechen Lu wrote:
> > From: Sean Christopherson <seanjc@google.com>
> >
> > Reject KVM_CAP_X86_DISABLE_EXITS if userspace attempts to disable
> > MWAIT exits and KVM previously reported (via KVM_CHECK_EXTENSION)
> that
> > MWAIT is not allowed in guest, e.g. because it's not supported or the
> > CPU doesn't have an aways-running APIC timer.
> >
> > Fixes: 4d5422cea3b6 ("KVM: X86: Provide a capability to disable MWAIT
> > intercepts")
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Co-developed-by: Kechen Lu <kechenl@nvidia.com>
>=20
> Needs your SOB.
>
=20
Ack!

> > Suggested-by: Chao Gao <chao.gao@intel.com>
>=20
> For code review feedback of this nature, adding Suggested-by isn't
> appropriate.
> Suggested-by is for when the idea of the patch itself was suggested by
> someone, where as Chao's feedback was a purely mechanical change.
>=20

Sure I see.

> > ---
> >  arch/x86/kvm/x86.c | 20 +++++++++++++-------
> >  1 file changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > b419b258ed90..6ec01362a7d8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -4199,6 +4199,16 @@ static inline bool
> kvm_can_mwait_in_guest(void)
> >               boot_cpu_has(X86_FEATURE_ARAT);  }
> >
> > +static u64 kvm_get_allowed_disable_exits(void)
> > +{
> > +     u64 r =3D KVM_X86_DISABLE_VALID_EXITS;
>=20
> In v3 I "voted" to keep the switch to KVM_X86_DISABLE_VALID_EXITS in the
> next patch[*], but seeing the result I 100% agree it's better to handle i=
t here
> since the "enable" patch previously used KVM_X86_DISABLE_VALID_EXITS.
>=20

Yes, I agree, handling here makes sense.

> [*] https://lore.kernel.org/all/Ytg428sleo7uMRQt@google.com
>=20
> > +
> > +     if(!kvm_can_mwait_in_guest())
>=20
> Space after the "if".

Ack!
