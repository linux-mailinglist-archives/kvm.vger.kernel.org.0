Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388A8571F4B
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 17:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbiGLPcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 11:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiGLPcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 11:32:39 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2070.outbound.protection.outlook.com [40.107.96.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A837A238D;
        Tue, 12 Jul 2022 08:32:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoXZ2hsgqXhuc89N0Wi+3O5ySod5Hmync784DJpPF5/OBs1VstJHatYc/qPK+gOqBGrEDf2aRY6XFiSIUcaD3pTF0m4Rre4IvEOeomyhyq9bDCyaPIHLO7b8RvpC8ep1Q0Rkqo7UGKOY9EBRQ2uvO9qXShJVPSDWS72e2maPtx2f72vMonGPuEJ/tpJ5W0HoXl9BTvCLHAze4GMRBzExVprwj/Vj3uAwjJh8odsUHM7D7tS+o6DdcDkTUe7oxa5AqgUKotyfcwZWwOingY7EJRN+Hyfoa36WzWHw7ckB2FPFcKkPGe81hPP06MMiJH+eWfuGE+1tv4XWyKAXU63eFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6SAJcUejAR3+XBiYQ8yeqZOGKDlOAqsrZcbSZeEdHw=;
 b=LObsnJhYoUxkaEhkzMoV+Cs1YE6Uv9cz7UYbSWpiT/Ss4Rhq5VKMWFjbGKqYBIR96ujw0EIsxWp7+ikhKxF9iOUqxBFXRBd6YkjHDCnKdK0CWzKw5IGgUxRVVMapH0koT+Er0cAvYUgA3IhWuldBz+rEE3+vQZEefVsfKiN7MPNe+cUJpDYHtSXfh9rXwYOBJKesD0IbnCRNHhnofFBNybK19ttzOibi/sxa8DOffF3pIuHYczupbZZD4QIOEMwp3gPwqTmSyHZRDBLI0F3MO0p2zJrmHpSRRXgbHc79Noop/VPsAN91y5s8wsbtuUDqzRxIwKKVTOUJ43wA/5NjRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u6SAJcUejAR3+XBiYQ8yeqZOGKDlOAqsrZcbSZeEdHw=;
 b=12ePR3t9wZICSn5gquxBk8WoSUX1ImZ3G6w/h5sMY1dvfqYhGkFRLjPf3iPshzrqH7VpOqAJYphcevrTw7QXusntsYFfgpMaafwYapUT/lsd8VzA2suxUutg58EWwxYIZpnvsBd1QQ9S9o6q+kNYeDlMOkg5WAEOH97u7TJdZHg=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN9PR12MB5162.namprd12.prod.outlook.com (2603:10b6:408:11b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Tue, 12 Jul
 2022 15:32:35 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:32:35 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "slp@redhat.com" <slp@redhat.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>, "bp@alien8.de" <bp@alien8.de>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>
Subject: RE: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
Thread-Topic: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP
 nested page fault
Thread-Index: AQHYleutwTAHf5pCYUKVmbAjuCvxWa16rpoAgAAA74CAAC1pMA==
Date:   Tue, 12 Jul 2022 15:32:34 +0000
Message-ID: <SN6PR12MB27676993AE36B0A4ECB662548E869@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <d7decd3cb48d962da086afb65feb94a124e5c537.1655761627.git.ashish.kalra@amd.com>
 <Ys1qNQNqek5MdG3v@kernel.org> <Ys1s1kyfOu/FXjXr@kernel.org>
 <Ys1tn7w0E/0cOud8@kernel.org>
In-Reply-To: <Ys1tn7w0E/0cOud8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-12T15:31:03Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=3af0ef82-bb06-43b6-9267-c7c37ece67d2;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-12T15:32:33Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 9da967bb-9100-45f8-8600-f4d207e1c2a8
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e38aa84-8c79-47c4-a15f-08da641bbe7a
x-ms-traffictypediagnostic: BN9PR12MB5162:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7qmY/yhnhRaxKk7x1b16mNOXKzMVgZYEtLCAJcl22BvVFV3OO+QhsImn9wo6a86YLGIjIJTa1hJian4p/H0FHBhVkxvebeR4p0wwLQ5wb/0dbtSZ+o+cSXV8DpAHH/0jMp3yEHodyCwJfeyI8lpPGGU7JRjMY50avW4qX3UYTGrAQWatFb2KRNY/LkTtZn2z2ASJbaDKnJ9hBHws5DAgEfWvqWB6ukxXH32zsxGiqFQnyXHXCBk8LB5ZOD5HzTFOpCo58NYTr+AGeEGzix2rNoaB9ME0Tm544zvJIVAJ+BxaxyBbnUsJrmUlZrmqy1HPCtRM6kniQXnWVWxGyfqCmMzBQvlnGWBHJaI6/Zit5+ciS76HI20pGzcpJ62gByNCiGPhwuuaTK134erjwkPWT34KLynGeAwTUb+tPdzotoFdgw45PwC04KG6JNKDC/qlnGCc7e7Kes1AxHypO0J4BtkwSCZnbW8kLwfaUEMo4hukMsBfbKfz5NGxfwUHikYUlfTSqTWF1DscCT7XrlgqZvM/ieQ+XrcDyzJZR1FggOUjvxdTwEmsozuYi8o8VlhDR73+1QjHu8+8hqCcJZKlO3AdzYETI8SVcIM3irAhje/9XV3jVfbEOXPBNkBR1ccuCEU+Pya6boSgShgJHnEh/7+AmJEPcUC6RRgmfmjjqw19ous2fHW2o4GeXlHkxWTujH/OinCrQ8hj0/J0Am9Qfw7G17UPzu/4wc00TKFXgTlsvnslV5/p/QGRkCFWxJg1NA5Mv0cJZ3VZFuMCX6868+HdMwa1cb9cBlZnk/P08+Q3c60PEWhjCfAQsTWgwtFU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(7416002)(8936002)(55016003)(2906002)(7406005)(52536014)(83380400001)(38070700005)(5660300002)(7696005)(33656002)(6916009)(41300700001)(71200400001)(66476007)(122000001)(54906003)(478600001)(66946007)(66446008)(38100700002)(186003)(86362001)(8676002)(316002)(76116006)(64756008)(26005)(53546011)(9686003)(6506007)(66556008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ktl4rzNKBkjzfTXoIp/NuEgaDBIF4yYKJE+cjbKMrxeYc3GHZWm+qd5Wlrvv?=
 =?us-ascii?Q?UKY4uV7BnEqBHipw7ah2ddq2s9U95Kf/XawjE0/kbBMnFV7T29DuQzSax2Nq?=
 =?us-ascii?Q?9LrajgnkvSjgM5jMAJqv2d4NCZDJEv5HDY2zPwNN/O/2MbWj6C3ZY779IzEh?=
 =?us-ascii?Q?TpA9xpV+4Y3YWz+F/F0G0fkib09YV+i5MYPA3TuWD10q+pEZi2QsMlKL+ids?=
 =?us-ascii?Q?tJtlOKE8KE/5lBK/xbVNPcML3+4t7drwkoCCiPINsX9uBvy+LujZur/cCk6R?=
 =?us-ascii?Q?Z2ioQnSnTehzqfaMa0+kL3IAyCdAY4gyRddD2vK2Fd4W77m4+JrAle3+nQYj?=
 =?us-ascii?Q?QYK2ULoTsVYx2JpAFvcHo1agrTrJ8LVcsOpeZQVR1A5JjKume4GNZAvYmh1m?=
 =?us-ascii?Q?3fBKwm058XL1l5ujrpvYMvw88Wyf7wlRN4Emgt6XR55KpcHszs4V0cK8SlyT?=
 =?us-ascii?Q?CzuhIZtjhZWPQ/V5DvHjjBVMtXwCESAvDj92YijGNSLzJPkURFGQW457s4co?=
 =?us-ascii?Q?zUpddm1ov48CffWFosg8qAGnF8TlK+JNIc+/IXK5VuYSv7NfLdf3NTJue6A0?=
 =?us-ascii?Q?t/agnIg45bhp8dPduUjV3VJtRCn1xenpI2sGZxB8CCcEkAKktoEhRHHAlnWC?=
 =?us-ascii?Q?ysJqXIWo+7k+wv28ThLZJIfV7b1rSqUeQkWOJQJ3VylPIqXdm+7H96Xd58Qj?=
 =?us-ascii?Q?chK75nQvOnI6Ls5YMVBV63EDta2RbfAd/+Bi5CtFZ4Ued0zJTOWBugd6sHL6?=
 =?us-ascii?Q?Th41W5WJLZ6kP46YdBd9yAHgOJteFseXUKxLunQvGnvfzXnK9ZIe8iLWwvs8?=
 =?us-ascii?Q?Awly90ujLkN02ke3Q9sxNQBxuHK/c0Hy5o7ZauEbSWjoeTNf+BEwiOM1dvLn?=
 =?us-ascii?Q?yQMK1RN/tKc5kDNCPkE5yfs1OBL5YvAuQR07BCBpdRS+hNOAYxC7aH6vdNEc?=
 =?us-ascii?Q?roO1XTrQSZ5n6GCRSjJjA6LoqNrfadtdHTL3q1yIjui6DfU32DIRXKaNT9hr?=
 =?us-ascii?Q?AGQemm27Z0CcdRFb3KEaGwHvy+odecL6SOvBJRfZr7HcFQtkAN9w1swrRypb?=
 =?us-ascii?Q?outKrji/BVh5/Js+yJwgJgKs0XjykFrG/RckdBCPHIxgEFtk34oiV7oZIYuk?=
 =?us-ascii?Q?mooxEqhWbUJTJWPxJLCc8r4J/A80kchrQYFyxciraG8dGXMt4MocaC+UK50W?=
 =?us-ascii?Q?GRX+QRbKJhbLrnc0RP3mnztbmlG6wQGLHX/ZR9Mf7SI/2cz+p6JT8Ca6L4bT?=
 =?us-ascii?Q?C0wts6AlbNwdetaNNgqA1DzgarODZS6S+XQ3VEcWo+spm8A+pAnyk/WF7NwW?=
 =?us-ascii?Q?OgRqLnG9E0bPnNwO5aeMoQv9M4wryoWNx/nFVP64G2xhmhmkwhRZ/cKKU1pZ?=
 =?us-ascii?Q?GLcGiZ1P8ukKWEUTh+xJDjsjauvb25fqZE8AST2AksVQpMWJiji/ivwqn7NB?=
 =?us-ascii?Q?YBqcsrPNE3BrTsB5+EDBChPJ4dZxfbORd8u181l/HzydGuui6JQCQQw46shI?=
 =?us-ascii?Q?bNpHJZYcDqpy+w6SXPmpUItrs7YFQPPzFNqIip91vO6jMBAVvy0EFNloCswe?=
 =?us-ascii?Q?w1MarA/BqrK8UaCXRF0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e38aa84-8c79-47c4-a15f-08da641bbe7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2022 15:32:34.8792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G6GrMadWS4IvCvIN6NTmpjxA++ndv6UxcgIV1gIGbxU7pEw2u3n478qmzCwYnsbWDzvZnEQVH273dAXi8uFhtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5162
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Yes, this is fixed in 5.19 rebase.

Thanks,
Ashish

-----Original Message-----
From: Jarkko Sakkinen <jarkko@kernel.org>=20
Sent: Tuesday, July 12, 2022 7:49 AM
To: Kalra, Ashish <Ashish.Kalra@amd.com>
Cc: x86@kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org; linu=
x-coco@lists.linux.dev; linux-mm@kvack.org; linux-crypto@vger.kernel.org; t=
glx@linutronix.de; mingo@redhat.com; jroedel@suse.de; Lendacky, Thomas <Tho=
mas.Lendacky@amd.com>; hpa@zytor.com; ardb@kernel.org; pbonzini@redhat.com;=
 seanjc@google.com; vkuznets@redhat.com; jmattson@google.com; luto@kernel.o=
rg; dave.hansen@linux.intel.com; slp@redhat.com; pgonda@google.com; peterz@=
infradead.org; srinivas.pandruvada@linux.intel.com; rientjes@google.com; do=
vmurik@linux.ibm.com; tobin@ibm.com; bp@alien8.de; Roth, Michael <Michael.R=
oth@amd.com>; vbabka@suse.cz; kirill@shutemov.name; ak@linux.intel.com; ton=
y.luck@intel.com; marcorr@google.com; sathyanarayanan.kuppuswamy@linux.inte=
l.com; alpergun@google.com; dgilbert@redhat.com
Subject: Re: [PATCH Part2 v6 41/49] KVM: SVM: Add support to handle the RMP=
 nested page fault

On Tue, Jul 12, 2022 at 03:45:13PM +0300, Jarkko Sakkinen wrote:
> On Tue, Jul 12, 2022 at 03:34:00PM +0300, Jarkko Sakkinen wrote:
> > On Mon, Jun 20, 2022 at 11:13:03PM +0000, Ashish Kalra wrote:
> > > From: Brijesh Singh <brijesh.singh@amd.com>
> > >=20
> > > When SEV-SNP is enabled in the guest, the hardware places=20
> > > restrictions on all memory accesses based on the contents of the=20
> > > RMP table. When hardware encounters RMP check failure caused by=20
> > > the guest memory access it raises the #NPF. The error code=20
> > > contains additional information on the access type. See the APM volum=
e 2 for additional information.
> > >=20
> > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > ---
> > >  arch/x86/kvm/svm/sev.c | 76=20
> > > ++++++++++++++++++++++++++++++++++++++++++
> > >  arch/x86/kvm/svm/svm.c | 14 +++++---
> > >  2 files changed, 86 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c index=20
> > > 4ed90331bca0..7fc0fad87054 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -4009,3 +4009,79 @@ void sev_post_unmap_gfn(struct kvm *kvm,=20
> > > gfn_t gfn, kvm_pfn_t pfn)
> > > =20
> > >  	spin_unlock(&sev->psc_lock);
> > >  }
> > > +
> > > +void handle_rmp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64=20
> > > +error_code) {
> > > +	int rmp_level, npt_level, rc, assigned;
> > > +	struct kvm *kvm =3D vcpu->kvm;
> > > +	gfn_t gfn =3D gpa_to_gfn(gpa);
> > > +	bool need_psc =3D false;
> > > +	enum psc_op psc_op;
> > > +	kvm_pfn_t pfn;
> > > +	bool private;
> > > +
> > > +	write_lock(&kvm->mmu_lock);
> > > +
> > > +	if (unlikely(!kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn,=20
> > > +&npt_level)))
> >=20
> > This function does not exist. Should it be kvm_mmu_get_tdp_page?
>=20
> Ugh, ignore that.
>=20
> This the actual issue:
>=20
> $ git grep  kvm_mmu_get_tdp_walk
> arch/x86/kvm/mmu/mmu.c:bool kvm_mmu_get_tdp_walk(struct kvm_vcpu=20
> *vcpu, gpa_t gpa, kvm_pfn_t *pfn, int *level) arch/x86/kvm/mmu/mmu.c:EXPO=
RT_SYMBOL_GPL(kvm_mmu_get_tdp_walk);
> arch/x86/kvm/svm/sev.c:         rc =3D kvm_mmu_get_tdp_walk(vcpu, gpa, &p=
fn, &npt_level);
>=20
> It's not declared in any header.

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h index 0e1f4d92b89b..33=
267f619e61 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -164,6 +164,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vc=
pu)  kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
                               u32 error_code, int max_level);

+bool kvm_mmu_get_tdp_walk(struct kvm_vcpu *vcpu, gpa_t gpa, kvm_pfn_t *pfn=
, int *level):
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of=
 a
  * page fault error code pfec) causes a permission fault with the given PT=
E


BTW, kvm_mmu_map_tdp_page() ought to be in single line since it's less than
100 characters.

BR, Jarkko
