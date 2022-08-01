Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2F58746E
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 01:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiHAXc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiHAXcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 19:32:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E40B19C36;
        Mon,  1 Aug 2022 16:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvaVlhNI23q652jgSMJeHzW201T8J9klfdkrAKE19gkBfl4XCRbgy6Pyuy8fDsaBw5JarFylDznsRxaNjc49/LHR9zUJh52M1JxAvafvxjBJyx4XBLTNjZKG8+kfhRf9eqEmGnD1JDEhzXoXUzbzAYzwf5sHJ8RqlSFqSFjx/YiTazTBdamlEJD3r77o5vg+8c43S+Iq3tFcxcNr8ErlN/CiTGLXsWLCeibdd8R46I4fwFhyhJvZPa7C0JqR48KgC2gIhegjtzG/6e0bC/FxdhIGq4JAh2iPM2ft6/zq2O1w9YIlj/phO6W9m/hOuOKxx8tBzKHIesSQJbd2nbyZag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x97jYX09GMm2fFtnlsSLcw4+87ADl0RHnuYCzrNF0MA=;
 b=eVPro1FdPh2CpfSH+V/qoPC9pb3EUYaoM816SsOLDcFGLTsBandIP8NKtQf/82okrS61CJ5ClDSlYfok3dN+wFmp0lbuxfvpV30rvpbwT3fsg64/qwu9Y9gC3xufGG5CbPxPpOI7Cao8ULBdhoEV8OrxDt5F5NSbsssHqY+UBDDo4HXDyXUv6LW0PUMz5xNkMl+WzJDWu29BkU22vmCJMhx71cHXy3K5YSW+88wfAF0pVJVEsPMm1Z9zlr94RocitsLSsDS2imuVq3FFXiog8oq6UcifwSD18IkKd8SIoYemBFvrn+uR0jK2NpfObzDPqe0U+HvvBqAZFQQZasL0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x97jYX09GMm2fFtnlsSLcw4+87ADl0RHnuYCzrNF0MA=;
 b=FNLMQTwcLGIFKPN8OZjjGzrQPscrW8cEyObkZ+qjZMxDrD4iSWAapenb8wVLcDy6355N+Jy2pQVMs3fyVW38yldoFeDu90fq3an8mzZyDn1ZvjdGEK7lqSJgXUMFnrS6pVAFSyJNVRASUPWLSuodrN+ONHlGHR/5ZQ59VuS52FU=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BN6PR1201MB2497.namprd12.prod.outlook.com (2603:10b6:404:b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Mon, 1 Aug
 2022 23:32:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:32:21 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
CC:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
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
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Topic: [PATCH Part2 v6 06/49] x86/sev: Add helper functions for
 RMPUPDATE and PSMASH instruction
Thread-Index: AQHYhY2kulHh/HmbIUq97K70l/FApa1aH19QgAGdtQCACPGfgIAAdLzQgColNICAC5vpkA==
Date:   Mon, 1 Aug 2022 23:32:21 +0000
Message-ID: <SN6PR12MB2767FDC22657E683F7467F9A8E9A9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <e4643e9d37fcb025d0aec9080feefaae5e9245d5.1655761627.git.ashish.kalra@amd.com>
 <YrH0ca3Sam7Ru11c@work-vm>
 <SN6PR12MB2767FBF0848B906B9F0284D28EB39@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BYAPR12MB2759910E715C69D1027CCE678EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <Yrrc/6x70wa14c5t@work-vm>
 <SN6PR12MB27677062FBBF9D62C7BF41D88EB89@SN6PR12MB2767.namprd12.prod.outlook.com>
 <Yt6ZjzCSqPv6BKfH@zn.tnic>
In-Reply-To: <Yt6ZjzCSqPv6BKfH@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-08-01T22:41:23Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=88693479-d9ef-4fab-80f2-c062524904ea;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-08-01T23:32:19Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: eb744f6c-e0e1-4b62-b6d4-5e666300a06d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bae5de0-179c-44ec-159a-08da741614d2
x-ms-traffictypediagnostic: BN6PR1201MB2497:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9XbwKnaCv3qxxzqwHttfd1+30w12Q0RQ/C/FwR8lpUcO0PrZT6IjaRTovlMrCGSbiWOVZ4t56TUirJTg2SRbrCym3IroxhV5s+6LG5mvPV6MWIqL2ac/Y61t0NwSWUbKW9wZQswjX3u5iehhno32PhnZheHrHZ4Y8e8JwHnNe2dGdekW3UED8n5xQWeju5wMmPfCS1FytcaQldUoHdVU02F9cr4RkUGUQyKsbmiZol6rjdGclUWT1upqwY3zMcCPfjzZ/8v9bz+aCTRjYCDbG9wZBejOg0R3+wshueaP3r3BJI92rPWCn8FCaW+M/SnxOnwBGBtHZbK5RPSxLSWdP3uykcf1mJje82YCAlnqmjMJw88Y1ogyB8ehZBOzI5J21PqQv84qGk2dQbOOAtiX6P/dFa/gBgFnMeIkA9Bo36TLdZCoMG35KFBxC+33RKX75e8F0mX5p+qBqhqEj0dsNeOpjhI+D6Sel5jjpJxiGs7tf1wQig1Z7vLb/K37lYs965pV0b2dsu8a7Aeay1LlwYWgf8S59a8Lt6+l3K9up+VAK+VHc/0cXAB9P9ZvdFSqHJGMFBNXhLA/Dg0E2BlH+IUaZHKSIr3kM521vQIVw5irSGshWQojPSXTM/Uhwl3ElhlXDo1GuCvec8u4ppsFBWZIWHgxEhIDS/weNhx2o2WGLGcVZIIBkCVzlhw6ATtwWGKPg/TzGdrBNQyxOMJcz6R/aToUvvW1GwSwAWmd/DUG6ezKR91cP/e77cBqTnDmqK7hfole6zXhjC8VxeYFCogEc8a5NwoZn0fclbS2krOQv0Twzbbro+iAUEE53gk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(122000001)(9686003)(6506007)(186003)(38070700005)(26005)(7696005)(38100700002)(83380400001)(5660300002)(8936002)(52536014)(7406005)(66556008)(4744005)(7416002)(66476007)(66446008)(64756008)(4326008)(66946007)(55016003)(2906002)(41300700001)(71200400001)(478600001)(76116006)(8676002)(316002)(54906003)(86362001)(6916009)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bg/g4XX9Du0a3AwugR1e69UwskboJ5vXfSH6Najoco+rV6K0whfJrjNmI1K+?=
 =?us-ascii?Q?x/X62L4v7ZHQQcrX2OcKb/CPw6tSkF6eHoE8T8oZm06SwB1Jg9pWJCBw+QZt?=
 =?us-ascii?Q?vTzv50lvMijNvXdriQPbnR2yvBPzi/WKZBimGLARGXVJlVqGGMfZZ/1y626+?=
 =?us-ascii?Q?qcmNAICMtvE43X8YkNpLeN2ae1V3/32acPW7nuwgFk4ROM5G5vROA/z0sMyx?=
 =?us-ascii?Q?D9x1AIU4PC0JrEhCnPx4Khncvxl1qwPf/vJWErSN5JuFy5nLu0XI9cYFEBha?=
 =?us-ascii?Q?MBbGfCjj/q9W7mfUWVRmMXXAdymgqg7NHjkwdMw/Lba5Mwf6aR6l3nesraRR?=
 =?us-ascii?Q?WmBz/MSrOJUzWXAx6pnkRz45SfXBF0FIOBfBIM1YvhBl1373oZNkOeaMvuj6?=
 =?us-ascii?Q?Qo6rx0s3sXb+53O7pSSB8mn54H+AW++1mq+qi1Qp/FzaIA0jnFeMxdnJYjVv?=
 =?us-ascii?Q?llm3gX5VXwH97zFmSFShetznuB8KClQiE3KtJ5qEdyVCAae5TbHfRxFnkjcx?=
 =?us-ascii?Q?WVanr1awpCAx8eAI1DBnZCGOG4ZG7dtKjBRM9m0v1TQCnS9Cmqr8ngDuEEaw?=
 =?us-ascii?Q?oJ9zJ2AhBZE0wZq1ZceXa9gxOkq7iaS/CjVarJL4fympqm7JedZiOKYNKwah?=
 =?us-ascii?Q?XS/eYo8xy/V+0oB1dmXg5OZ1/qVrJAJ4GzfrMuWwPvEOU0s6JodMe/cqZ5WV?=
 =?us-ascii?Q?LO6u2pHA5B+6FRDQsAJ8+SLC4nxkO9HTK14CaafIMd9uElrkLfRLg235Pcpq?=
 =?us-ascii?Q?5wdzrLh0mOkolOoYA4rWOozL1Yaltb7oVEnCYKSgoVA6Sl1wVaGg7prDQw0v?=
 =?us-ascii?Q?HCityzdIVLBdhi+6jTsAtGPW0SOwMN203pjgyP3cvhSz1GwOUgTcA4b2h+uW?=
 =?us-ascii?Q?YgsmcIU9C3w080eMRz69jgshSnjvPJKlX4nrPgxRM/Gz5TltDB5mmS59t+yS?=
 =?us-ascii?Q?rr+dA25eoMfcJ5C2Fet0B0TcruwGL88lbBGippE9omtU+DwUdWFYBTwyia4X?=
 =?us-ascii?Q?iyge6M74Tvep0EaQqyShv5q06fgyGaS2uyk/PTikWhaR168KvMCZp/SxVP6+?=
 =?us-ascii?Q?B20K3+zyjTtId07xniGHDr6Ofuge35kxP9+R/39L+8lqCnRdt6MJNqu7pAai?=
 =?us-ascii?Q?WUClYFEE/hcBrc99OsIrY0eVsQqGJAoGT9+PdQnvFQGVBsIVhLKFawm+m04v?=
 =?us-ascii?Q?kzPqj3pDTP7QwZEO9cjNLn+fHMrUL5LDe411TbeqPQNDvH9B12hxUCbKmbCn?=
 =?us-ascii?Q?A6i85TEEpZcyV0ru0MdE2zbLF7/6/OGa2al+WrEmTVkepbaiMw47sT7TNe06?=
 =?us-ascii?Q?2t05uwf60QjP6vs3Bq0+oJzhxdhaXCu/hjBKBTanDrT+Qy5xjtl/eRShPa4I?=
 =?us-ascii?Q?IxhQZtgJ1KPApmXPMtU2d0GLQNLk78Vk/mDI2eahgHZBnMP/urUXU2oybf1o?=
 =?us-ascii?Q?u46DDS24tmi66hSO5QLlDpTEr4m9JxFevcQh/kiDCqBioQi+Hl9zZUbW1Q//?=
 =?us-ascii?Q?lCfjHqWQu0X84AkNygtwDDFy3ZEtGZ9hJz718VCevYK+D4S7F8s0ACJllt0Y?=
 =?us-ascii?Q?iqTJODteuH3a6CEQ8zY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bae5de0-179c-44ec-159a-08da741614d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 23:32:21.3448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QUHW0uipwDxv4zF56YH8q6SWHPZ2ve9veri/AoOSCPhUJ4oHp6x2ffVDEABzUWBSXD/GhcV7Yl+ChPr2y49QdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[AMD Official Use Only - General]

Hello Boris,

>> Yes, I will be adding a check for CPU family/model as following :

>Why if the PPR is already kinda spelling the already architectural pieces =
of the RMP entry?

>"In order to assist software" it says.

The PPR specifies select portions of the RMP entry format for a specific co=
re/platform.=20

Therefore, the complete struct rmpentry definition is non-architectural.=20

As per PPR, software should not rely on any field definitions not specified=
=20
in this table and the format of an RMP entry may change in future processor=
s.

>So you call the specified ones by their name and the rest is __rsvd.

>No need for model checks at all.

>Right?

But we can't use this struct on a core/platform which has a different layou=
t, so aren't
the model checks required ?

Thanks,
Ashish
