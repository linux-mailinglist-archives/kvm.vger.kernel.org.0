Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF28B579893
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 13:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237252AbiGSLfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 07:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiGSLfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 07:35:02 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B93A1EADB;
        Tue, 19 Jul 2022 04:35:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+/AJdKPiiLhK7WkCykZLEYuCgTpIaufhUPDxoi1WLtUZzgJVAXyRq3+DweE/tKZVq2GnJCeia2UTRNmPQCAcZiqtgGj85lTb1/hqx+woxpzHmmYWJDxAZm/U25EQpOTgLYSESJPJSouk75HqgAsAhFUpjwHUS9tmREph/RaBCBpWNdNPD6DQlJx1Gp+2GUBT/WZsH6gjXqZ0GI/JSkM26D6nu/QN4Rg/1EcXsgujsdoripBLUVkYGdLUYBSFdPhPIEmqKJ/I45qccp0HjXk82j/hwmhTWdnw5HuBmOTax+PjdoV+f3Pl6WkYobqwI0oSPK2KBHihX3q07Xy+LIRkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V9gdmaiJV9xqIAFH+FwAMQbqzTcERRLe8bUe4lRqrkA=;
 b=VkTUU2cXQcs9z3J8U7dq+p7HldtmyZ0LKL2hVSUy6S8zpqT0EEQWNkGuZVxBJDPnwmVZeGuckrjHkl5XPo0l6dUecgx+AjJ1tNbVdtQymx33a2QKtp1Lop58CT7C7JTy+vF6ZZMZyGjcx4HZy4zLqnM8OqP63FC7egXJtel1znCrwXTrl1beu32tP8vLEtdE4wWF+csxEqnx3XUJVPIL460T9oNIcM+lR+C9QQQlLBQQN0vys842SbPJPPbdXr8aXn3I7+Ps2oeXeP6Pv78ifryQvtjqHaYbZ2UixzDn9MVarT/wQ/Udl9eQ4KvXbjNka2JdnixiIPG/KS3XDgnqpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V9gdmaiJV9xqIAFH+FwAMQbqzTcERRLe8bUe4lRqrkA=;
 b=2DBqaTlJrSXmXmOqVogqm4sJ2s1bKs8X54yq0KqpBIrVWXNejJN0NubUhWlvAL1r40torqULMQYl40xWYxBZUZFpYPiDU5uqZJpvSCmgaw++7Ah3+KEhhdNlgAdp1XnbpjJBs447I/IqYr+oWH+Ymh4oE6cGS/ljjkwtJZ+sUx8=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4702.namprd12.prod.outlook.com (2603:10b6:805:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Tue, 19 Jul
 2022 11:34:58 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 11:34:58 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Borislav Petkov <bp@alien8.de>
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
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Topic: [PATCH Part2 v6 03/49] x86/sev: Add the host SEV-SNP
 initialization support
Thread-Index: AQHYmcRAcxQqbwBTdUCpGH+ovKgAp62Ei1rQgADW2wCAADAUMA==
Date:   Tue, 19 Jul 2022 11:34:57 +0000
Message-ID: <SN6PR12MB2767FA7BBC983E63C2A0F0CA8E8F9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <8f4eef289aba5067582d0d3535299c22a4e5c4c4.1655761627.git.ashish.kalra@amd.com>
 <YtPeF0r69UbwNTMJ@zn.tnic>
 <SN6PR12MB27674548A8C8ACF5E53C0DB78E8F9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YtZtcHYGFLC4i9dn@zn.tnic>
In-Reply-To: <YtZtcHYGFLC4i9dn@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-07-19T11:30:13Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=a271e787-877a-4a4c-a4ac-c55a3dd4f952;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-07-19T11:34:56Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: b313ba1b-6480-43ce-aea1-60d2d502a84f
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb57b2bb-5f7e-45c3-ac46-08da697ab58f
x-ms-traffictypediagnostic: SN6PR12MB4702:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +RDY1oaE44oJ3K/7+57FCQcqpj4xLu2+EGWl+l4JekrfEd/0AyNzQNTsw6hwsUcdNxF05UkASGLvEbDY6zyia3QFbQ+7iJ2mB1KGf67spVXqDD18uSwQs/NBWPisp5NMtqNL5PZ7+oB9FrwJdoHT2MQp+V07ZzzSpbNUs5T5ZQVqVRi2jqL9TdwTSKVazaaEWLRfQKw8hz/zFrw+9InvIcsl6YGwwjYlkpsmkbuMGh9atWsjOOgHbR5qSm+arZ5mC3NeRa9Occ1mzRKZsjZig1KZ/zxzdieoWLKncu8CAxuNX/Wu94FwKhpN7xMOjYsGRgIjEZFzmqy6RRKQ29abBXMURvvjpXquo49jYwKbQIzuP9dAxbARnkkOeVlMs4j1FRIB0JvVpJ0yrPGVgfhpCUiFsfX8v0ODKRdHiIVctbACdBnniGCyhLXwzaH4cwbe2mVewZaEpdMxhNE0ZRVjYq1qr7MklZG8FXq91hbkZhC23AcR/opnHBhLWxc2oqxtOTl15Up1Hf5eS62gorVlP2xraJF6BZKCirbqFMSN5Pelq6y8D0B7Hp/43GHEfcIHwiYg4BWS/qQgnjEX7FKlwbdM/eEBSoqc2N1TTuh/fZz38qB0rdUbqA+J2LOUm29x2HpeYd7zun3qOmnA7YklDl3tMnv4+bva+Qo9mZRfPoM/CKcyjCn26fWJAyZdhsG1RmaQwMFwCMLZQy+zcS4fVWoj83IA0Z/ns6FIeL57CbPzhy/zJEjMd9+HURwfe6Eo3rW7WUuSPOBxUa9fa4jV9vxUjbcNrs64JhD3znJpu27wH9onDxwRJF1hzJD7A/iB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(366004)(396003)(136003)(71200400001)(54906003)(478600001)(38070700005)(33656002)(38100700002)(6506007)(7696005)(26005)(41300700001)(9686003)(6916009)(316002)(186003)(55016003)(8936002)(52536014)(5660300002)(7416002)(7406005)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(86362001)(2906002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lNe9dlvryTo9FqDaHwryK7bO2DqYqlAQW5yjVfa7UkRKZZR+NN64i+8sRTmZ?=
 =?us-ascii?Q?qaD8zyjKSBOAFNRgHlP/croSJ5/02Cpe1V65XrP93x7n3YxaYXeAn/qiX0cr?=
 =?us-ascii?Q?c+80J7FmWBdwCXjq7ouHXHzyTbS3fPtG2dc0IBY9kFm3fnu1Z4fUo9WCiIfI?=
 =?us-ascii?Q?TT/sIC8IgcP2b8t9lrthcZOMlVE2K6tnqWApfVioI1JI6kvPm9OC0skyYAfi?=
 =?us-ascii?Q?5ipTS6WnS8frIrruH2KsATSnSN9YXbmHBbnxd4JMkMjuBxQ55dSZqzkoGCzc?=
 =?us-ascii?Q?6m4pGHf3YrqelORPGdTEvpzgQNzVv6teWkI3e9/iiL83SHbDNPc3RQ/oXK7o?=
 =?us-ascii?Q?/zzU0IEJsd4YImxa5SwxY6IMNXOlBwBwYSec3wCdy9gnsVYoGnh2MIH2DUqJ?=
 =?us-ascii?Q?qhSVd3uQamQPdmCqtC/VnJElulhH8PU7F/zPwvo7MV6UI7AIBIddsq6BwKV8?=
 =?us-ascii?Q?2ZJdRiYtljyIk3MYuy3vvTw1n6tNdgDEjR1uL982j8END2QWO+LwcIv63l1K?=
 =?us-ascii?Q?Md0aiBYyzkr6L/Fo/2nTo/sDS5b8yNpaf4nlbsI1UNHmJ2L+V+cOUz8nF5PT?=
 =?us-ascii?Q?rguCqiMFwgYqMT8Zles8Iv9041yVmTJwvYXBdUrgRw1wXdmGqNrK8oWd0088?=
 =?us-ascii?Q?oOO32BWhV29Grv9q3nfo/N0Gv5Y2m9rOd0MdgUcC8Te6TNU7ggfdLRh+YsMm?=
 =?us-ascii?Q?ihwHCHXwl5UK0Z/BhZvLGrmQjDWQUFRs69wOnWPH/F3iQqmJERZ16wkk1RV3?=
 =?us-ascii?Q?k45iOYPtqjCdVA26YWTnacac3yLgkYKCvHfLtjsik1y/JwhrkkyK7Uvwx39o?=
 =?us-ascii?Q?91GjyX7dTMVrZVl2BhnBWe4NWrCdVb/OOvDRn7SBPF4H4CHdJPnUXklrRHTR?=
 =?us-ascii?Q?/cluk5f1ePmBSbmDlSErbhA2vp65MT8nzt2f1AoLvdQOew85iDDf2yDbLlwX?=
 =?us-ascii?Q?PmrkHeglv9Gd19dfTaQJB7aavUsE5jeJCgg+FHFl7+SPJPqnzUA13p0FPPDr?=
 =?us-ascii?Q?F2IlWFH2YuPhtqS73ESxDpKE4Pc9ZpFM8TW1Gydoc+QAp8p/dZQsVhqhJbwU?=
 =?us-ascii?Q?XE/YfxqaWMzcSRRGnwz1OlTFw1Suo+myKYzUdEVViS8QVsaUt01R0TAqIUA6?=
 =?us-ascii?Q?m56I6em196SZzVHBL7KK3tKX32ahVPsIkJ1o5oINyQgJ6iNPFfzXyp+ClX7A?=
 =?us-ascii?Q?rs3xxvb9hPmqOGOutKxj/G2RGFF8DPt94Z0FrTlgS1sixm2/gVAVZDMYBT7y?=
 =?us-ascii?Q?Py8FQze6sESVwq9cwOtR7/Ct9ibQPVbKjHZAG6eUCDWYNdesTa/qGLnVX9tm?=
 =?us-ascii?Q?RoxgKpAeNK3n3ven7qzfJGCVyyIZmuqWUQogptj4tkqkQzf1/mMYp8Ettk4R?=
 =?us-ascii?Q?rRv+owOKQJLWhSc8AzMCJMRFgOEOOQtuHuJXqxT//QI071mS5OLWWUKs+prt?=
 =?us-ascii?Q?or2KEtKx0EkUK2quK8BoGw2BHEvZsq/F6MaieqcdYeW47DqJsqR0se2pX04P?=
 =?us-ascii?Q?AcegmtDKqHXvNDr4i1m/f1uSks5LjlTrKAHz/riE8ckqzhRT4VoVAO7fpk8a?=
 =?us-ascii?Q?rhwJUqNkS+3FpRyQlpQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb57b2bb-5f7e-45c3-ac46-08da697ab58f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 11:34:57.8739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oiDvXDrSZTvQs030r06rD9eSEVbQaZxfON5YnPZ4WgTwBKj5CF1MLsQrv5A+qQl28nn6WXAEFN0ZnBsQ3EyjjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4702
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

>> > That section number will change over time - if you want to refer to=20
>> > some section just use its title so that people can at least grep for=20
>> > the relevant text.
>>
>> This will all go into sev.c, instead of the header file, as this is=20
>> non-architectural and per-processor and the structure won't be exposed=20
>> to the rest of the kernel. The above PPR reference and potentially in=20
>> future an architectural method of reading the RMP table entries will=20
>> be moved into it.

>I fail to see how this addresses my comment... All I'm saying is, the "sec=
tion 2.1.4.2" number will change so don't quote it in the text but quote th=
e section *name* instead.

Yes I agree with your comments, all I am saying is that these comments will=
 move into sev.c instead of the header file.

>> I believe that with kexec and after issuing the shutdown command, the=20
>> RMP table needs to be fully initialized, so we should be=20
>> re-initializing the RMP table to zero here.

>And yet you're doing:

 >       /*
 >        * Check if SEV-SNP is already enabled, this can happen if we are =
coming from
 >        * kexec boot.
 >        */
 >       rdmsrl(MSR_AMD64_SYSCFG, val);
 >       if (val & MSR_AMD64_SYSCFG_SNP_EN)
 >               goto skip_enable;		<-------- skip zeroing

>So which is it?

Again what I meant is that this will be fixed to reset the RMP table for ke=
xec boot too.

>> Yes, IOMMU is enforced for SNP to ensure that HV cannot program DMA=20
>> directly into guest private memory. In case of SNP, the IOMMU makes=20
>> sure that the page(s) used for DMA are HV owned.

>>Yes, now put that in the comment above the

>	fs_initcall(snp_rmptable_init);

>line.

Yes.

Thanks,
Ashish
