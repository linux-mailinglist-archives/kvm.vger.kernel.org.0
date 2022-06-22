Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83085552FA
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 20:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376674AbiFVSIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 14:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiFVSIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 14:08:12 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79B426AC5;
        Wed, 22 Jun 2022 11:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl+ZsbplXRWMkQlfnIReQhWhinDzZ7QkuF6jN7W2wL3rWp4OygMlLuSGC/scRaS9UJhRx2gjJlCvMDqNPF4sVpWGn3V5soFpRcuMZWwx/PqfI2JjK4E9LdZfPdTaDYrVS6iDUaZI8MyGJXTyodlJnI5KHDbbdadtFKOwe7WuH2x0nvohrFupCZT2eCvHrxZeA4tj23R1Kic+Z0J0vXN0GcR4H5UKbJOcKqRwjwdj84aouwvZ5qpsDjEht2+xN85UpcaXK28k52/sjnZXnlrTDOCqS+hWT1MTz/pc7WiGnSkM6XH/n5d96I+tW57Hw+pLEleQ5t24DpFIdApsWmlyaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+jYQMUVXwOIp9FCv9YJXs2E9CD/TN6Ui6FxwWjhnnU=;
 b=GPxeiCcyN/TFxrDQtqhN+OaTxiZglau4zHbXcknXPW23/bAKu18lyu4R0GNl7+F1TqNCfyxa9gNcgqHU/a6IL/M7FH8ERtApT92WMfp7/KcW9+i4QaEHkbMyaQXb8l4XvV7OVWbgfcmEBsl23JtFXh3NgRiofMtrsBFrRPsdQMom7DDOxTDwwVmGv8xqC+Puf0oP0DsRrLRMMCVk6dw92bBfCYNFS4P5BPz7WsiMvbHU32OE9ZfAqdZixqSSF4sFAcps+874ZCmGOzlm3bf8aLqp6OVZnR+HjZaV9NNeDJMbAzAJ4txoWsrjfx4hP71x0zx3MuCeauXjsUaCocw5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+jYQMUVXwOIp9FCv9YJXs2E9CD/TN6Ui6FxwWjhnnU=;
 b=PunzT3d597V5EO30AUQHDasprK0PSApkOohSxj2WKqEc9mOForns743y4uUtz6srMkQ5IqAb3/9AdD2V5mxxTga+E9lys4GvqvNK6FpeFD/9kKIBBeEKu30KPesh4QZ9TdOzY1wH5C8AwiFAPyWIdZ+hEVKQAawXgfQfIyAh3c4=
Received: from BYAPR12MB2759.namprd12.prod.outlook.com (2603:10b6:a03:61::32)
 by MW2PR12MB2425.namprd12.prod.outlook.com (2603:10b6:907:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Wed, 22 Jun
 2022 18:08:09 +0000
Received: from BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588]) by BYAPR12MB2759.namprd12.prod.outlook.com
 ([fe80::a0be:c49b:ef2c:e588%5]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 18:08:09 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
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
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 10/49] x86/fault: Add support to dump RMP entry
 on fault
Thread-Topic: [PATCH Part2 v6 10/49] x86/fault: Add support to dump RMP entry
 on fault
Thread-Index: AQHYhkUIRxuRLC4SHEWBhbT9juvAcq1bgCGAgAA4rWA=
Date:   Wed, 22 Jun 2022 18:08:09 +0000
Message-ID: <BYAPR12MB2759B7A03F9E68CE6CF6782A8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <af381cc88410c0e2c48fda5732741edd0d7609ac.1655761627.git.ashish.kalra@amd.com>
 <YrMoIOv3U+vehi/D@jpiotrowski-Surface-Book-3>
 <YrMqZUfZl1b5I/ud@jpiotrowski-Surface-Book-3>
In-Reply-To: <YrMqZUfZl1b5I/ud@jpiotrowski-Surface-Book-3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-22T18:05:37Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=3e764b49-3169-49ae-a5a4-0b42991a9fdb;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-22T18:08:07Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 6eb5c564-f687-4af8-8005-7f941bd1a9d1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 538e3826-1385-49dd-6e34-08da547a2a0b
x-ms-traffictypediagnostic: MW2PR12MB2425:EE_
x-microsoft-antispam-prvs: <MW2PR12MB2425BFACD00B7620C760CB268EB29@MW2PR12MB2425.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ue5rwGOPcgz3dBm3eSeVq1nFEQGLnJMcdmqytXwwa7Y2LVRGYZZaF7zDPFxTMIoitO9BCql9XgCS/8k8bX3Nxj0x7GO+s9Frkw8GyOTCmMI4YQ4GZc7wY+jd4TVTLuYILKij/iSPilexNBhJAaXqAoX3KlaunXK+805cLw4a1zp9GqNZcCWhiiDyt0mIXTGzGlhQjKLdUcmDWi63YdVgZFBwePWsNMzdLbhr2o2trC3RzzwYcUq0U2QGf70myeyd/p+aBEV9uer76t86OgV/7TSirsaUTd7pDkbHWczV3CVF3gmVse52Hhpb0oLch9mqCc0oS01RM39AT/Nc5OuMqeWvEwvbhZhRZ582035c7Jeao/1XmUq5aOkLH9SKJVhBEIfn7ZDjeWiIlSpVWen0aqRg18DGzYPrlDVHQX+hfjNk65ViHWQyOjAZ0Uofm8slRxcYmAMEyzQvJTRxbmxaa/8TRrxJii5FB6+qKmG6hZgXjwajZeuJI7FikAgQUGepmAsX6+y7r1e47rZvsKj4VNUgomtmaHTxI6+TFMHWNAlMlpvPo/kwHhrOc3WxLLWdZdSbxnlVAAQpglG/G3n5v9ZIIb0ttiadZfIEcMM6q8g4hk+k+xLkZYuhNnuRtsLBFg/m3SwlNcXH0zN4PSvRIvK1DTg0kgWyLj64p9fFETPHXIKhadsJv7h0/p9VzykA65542QXQz/x/44wLay22auKLDaIVB1xYZE5rFDOogDe3u0E+8hxjcSS0CGsN8GiiOKFRWk9Cg701wezXiBtOhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(4326008)(7406005)(478600001)(33656002)(64756008)(76116006)(2906002)(8936002)(55016003)(5660300002)(66476007)(4744005)(38070700005)(186003)(7416002)(66556008)(52536014)(66946007)(6916009)(41300700001)(71200400001)(316002)(66446008)(8676002)(6506007)(7696005)(26005)(38100700002)(122000001)(54906003)(86362001)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mdrWC199A8lguqCflho2krnLEIkkCEvAyqFh+3zKo4aKvDJ7N0Xt7JDcwcIm?=
 =?us-ascii?Q?DPIFJ9lrk9yBzCX3/z/6kQstQ5LhF5BSdAkv0Tbq5TKEiLfyCU2gsQGd3QIo?=
 =?us-ascii?Q?jNAukSWYtCVKeDuKZ1Y2crDnJhridDadT5L51ZSkoHaQmkXTducSTZsZK6tZ?=
 =?us-ascii?Q?A0pmw37xNK+qmOLGbSKTrqohpu6ryLTz6i5zdi9W0uLeVXS0suVos/VGHYTP?=
 =?us-ascii?Q?3OzDXV5VxGMVHa64xR2C0i6rheQw79lWzICiOje+6GLkhOPr+2ehnDZBY6Gs?=
 =?us-ascii?Q?6+WarZThW0Mi+fjPv4uNUiwkfoQ72iRv/IWJeAekmn8ifUVTAwUxctx7bnDv?=
 =?us-ascii?Q?O3CvfZOZHJZpTg4pIdp4/KP2KR1h9wU1Htw56KwIYgfibP0KJNKiwoZ7FXiL?=
 =?us-ascii?Q?h0ShKu21Gwl+9VZzW/CtaVQBUAlXolLtckXxqDXViM4TfsIbtSsN6ZEPhtGE?=
 =?us-ascii?Q?r55SvOvajgLewGf+7IMcEGMe3AfJDvV5R5XGqx49E6Dhf1kojguIhbzb30Ch?=
 =?us-ascii?Q?pucPqrJpAw7b4YNGm0opsFmi6BHqA7+oT51H4y0T/X2U0pFrjQiuGHnIYVgG?=
 =?us-ascii?Q?rrkFPd1RLVyz2X5ixyD1QJX9BRPhmKJgYJk2WlhVN6wYYJ/JVxuQWVq54ops?=
 =?us-ascii?Q?CsNXJa3uui4r88Aqa/kniWMYTgbWNJDss/QKuYtm1dfL2pT082SiJdZBaB0V?=
 =?us-ascii?Q?yCDXHnaxWb75ipq4zAc07IQCCV5OSEv15+CNFb9W826UfbyWzBNOvjCB8gwF?=
 =?us-ascii?Q?lho5LU6FR7P+UMWWjIFpZtFhASfluu2CJnknKiEy/NTT6KUBJyApGXtCYeCw?=
 =?us-ascii?Q?NetwPc0oOcp2AOHUg6E9NgtmQhLLdZTTnaTNspC6if/z2eIyYGwisHmQU7/G?=
 =?us-ascii?Q?VKW+gQw6F9lZOMkNM7wTAtoTuV3J/poPOj7HNQ6exRaYh2gTh833U9ihJCvj?=
 =?us-ascii?Q?nr1XXqBD/gji5wY8VC6MkSk9WbMDEPzsgIRicrkYdbZmm8VVqJE9tRRiZMbN?=
 =?us-ascii?Q?YNfIqNEwIe5Lh7lb3JLlJjYdf3kSxAdyzzH+uzimHJdGAH0LBxDicPG7aEkt?=
 =?us-ascii?Q?Ufu+7UC3M/kIbNmn/gkeHuepHp1v5aLXoWEABbm3ImTT8ZNSa8EkppAOV+AC?=
 =?us-ascii?Q?8JZv7TBFklJJuUpUXt/D8EmgqPQyeXs+mhgWKc47lMj+WM+BhEKrzw5FUGyd?=
 =?us-ascii?Q?04Dq/KhwxwCj1/0RPs6YNON89xAyK/K1/L+b0lbyhirdkRizuKGo/uPT8D7G?=
 =?us-ascii?Q?fZ9m+jy11IosK7QNRAysfghuwYRZB9MbzJPZ6zaPE7eOcN8p+A+2Ke69YuEI?=
 =?us-ascii?Q?fJXDsArBBhuOS+XRvQC5dL0A9mjfj/cHXZ5+5CLsiYda9UDa8WWxxNa35gZt?=
 =?us-ascii?Q?3ivkG21GliplE8S4XemM4jdfqvXry/Ad76CmO9Gkd/y+5M86bYA4XE6uBlBW?=
 =?us-ascii?Q?//9fSXakrhOyk71d0YYSN5+X5+HQJXF66pheB70OYhMTNNvJcSi6opNwjaII?=
 =?us-ascii?Q?ibmFMLbxm/WO1r+IftdWs9+gEUrdalDAnpoy4ZnINBznG6riRj+A/FuArmr8?=
 =?us-ascii?Q?ocdS2DvCgvih5HOd68yzrxqOpFQomezRJYDAw2xdScgUaf+7V7nx0y/p5d/H?=
 =?us-ascii?Q?9N5Mh5E+K8dDtEWf1NCX6plohJHtQcIhH370IJpvyHFLGdF3x84Ky44l36VL?=
 =?us-ascii?Q?LpF+D/ZgNThUJpkHzvAushu539ofCaTTxv7tbv0oKDQhsHHS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538e3826-1385-49dd-6e34-08da547a2a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 18:08:09.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvC9Xy1jWTFl3/exkABijRnBx3bnEV0/6HqaEk1r5vG0GORa47GPsU91oFABraGWm2bmuiuVEFOFfrStt2pHVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2425
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

>> > +void dump_rmpentry(u64 pfn)
>> > +{
>> > +	unsigned long pfn_end;
>> > +	struct rmpentry *e;
>> > +	int level;
>> > +
>> > +	e =3D __snp_lookup_rmpentry(pfn, &level);
>> > +	if (!e) {
>>=20
>> __snp_lookup_rmpentry may return -errno so this should be:
>>=20
>>   if (e !=3D 1)

>Sorry, actually it should be:

>  if (IS_ERR_OR_NULL(e)) {

I will fix this accordingly.
=20
>> > +
>> > +	while (pfn < pfn_end) {
>> > +		e =3D __snp_lookup_rmpentry(pfn, &level);
>> > +		if (!e)
>>=20
>>   if (e !=3D 1)
>>=20

>and this too:

>  if (IS_ERR_OR_NULL(e))

Same here.

Thanks,
Ashish=20
