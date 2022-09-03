Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BCF5AC008
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 19:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbiICRah (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 13:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiICRag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 13:30:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2066.outbound.protection.outlook.com [40.107.93.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA2531EEB;
        Sat,  3 Sep 2022 10:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWHAXLPMj7o9mHracTjWWBLfofZ+8bwnEHUOzgGOgHh21jn40cQg86T39KafU1AUxx4NQZHtUK9fjJ9EeB1lCP+fN3RgnVZH+AGiCpAFFXLfJNEshPf5c0z3iQB7jFdpx5duZpqwxcRtiNgf7XN+ojHxX0rdQzesyDsUeO0UOS+PdgolJ89HacV0ur+I8VWNk/vrusTnHkUfpDZj7C8pQKJITltEJzJDMZEsly7hT9CzcETsR+9UQwbHmeRqm+KS3MJ0zz2LB3W+yTXOqC6vu4CLXNwwUzoMO1heXMJBTt1nmoh38BHQSVrpzv8Wqnpl5wdYGU5t3kgzXNEllN5AuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Xh05dJeo7B98jmVpvi9Gwy8SoG0WfI02IRMBG1sJzg=;
 b=RpubF5DKNed5p2bKpbASwULxbLch9NmoARufI0NWsVS4sL7+37NG6k1Z1uxQTRXNDRmfBW7TssGL0v45yW7V1jplFrowPa/dckdg0dVQkj0o15UdRqtiWiVfcn6FDmHHjQtyJNjr5sfTJTbCeyVJbgiBsjIophPH0uoSGwXaqiTAPSI9PQj8jZ8JwIa162+Z5f+vcvFoOwfyzxA6y5b766zBr0+XcVdMsy5Sv8wmZNX3RbOngXVOMvr864wd1B0oE7RVX/Sh7lKh9mRc/7VlyqPruAdQRjbo1giAG/Zibtm8v17JfrlkesLsj6n8nj29i06eOawMhKapWt/aXGm4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Xh05dJeo7B98jmVpvi9Gwy8SoG0WfI02IRMBG1sJzg=;
 b=KkWjKEFI92UXVpCdR4qDdPnaZWtYykzGSXxUntWB+V5zkqjYKwel2fuQZMrFptqG0UHAYB+hHZGDADCqiHIl8bWTlVSkiCGUyMxMkeKFA+YY4STHEcQEJT3rG1Qzh5T15EhPJ+ab6Ppcqj0qcJ/qcZyjeaCgX27Sklu69WfxsL8=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MW4PR12MB7240.namprd12.prod.outlook.com (2603:10b6:303:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Sat, 3 Sep
 2022 17:30:31 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::e47d:1a95:23d5:922c%7]) with mapi id 15.20.5588.018; Sat, 3 Sep 2022
 17:30:28 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Boris Petkov <bp@alien8.de>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "slp@redhat.com" <slp@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "alpergun@google.com" <alpergun@google.com>,
        "jroedel@suse.de" <jroedel@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "srinivas.pandruvada@linux.intel.com" 
        <srinivas.pandruvada@linux.intel.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "dovmurik@linux.ibm.com" <dovmurik@linux.ibm.com>,
        "tobin@ibm.com" <tobin@ibm.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "marcorr@google.com" <marcorr@google.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>
Subject: RE: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Topic: [PATCH Part2 v6 09/49] x86/fault: Add support to handle the RMP
 fault for user address
Thread-Index: AQHYrBDc30zm/ve2UUW13wSedLDd3a2nIMnggADB+gCAAMFX8IAieiDAgAC6pgCAAI/o0IAA2YMAgAAD/sCAACPGEIAAHNeAgAA8pvA=
Date:   Sat, 3 Sep 2022 17:30:28 +0000
Message-ID: <SN6PR12MB2767C4C296281D25306885A78E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <0ecb0a4781be933fcadeb56a85070818ef3566e7.1655761627.git.ashish.kalra@amd.com>
 <YvKRjxgipxLSNCLe@zn.tnic>
 <SN6PR12MB2767322F8C573EDFA1C20AD78E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YvN9bKQ0XtUVJE7z@zn.tnic>
 <SN6PR12MB2767A87F12B8E704EB80CC458E659@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB27672B74D1A6A6E920F364A78E7B9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxGoBzOFT+sfwr4w@nazgul.tnic>
 <SN6PR12MB2767E95BA3A99A6263F1F9AE8E7A9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <YxLXJk36EKxldC1S@nazgul.tnic>
 <SN6PR12MB276767FDF3528BC1849EEA0A8E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <SN6PR12MB2767074DEB38477356A3C0F98E7D9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <BC747219-7808-4C39-A17C-A76B35DD6CB3@alien8.de>
In-Reply-To: <BC747219-7808-4C39-A17C-A76B35DD6CB3@alien8.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-09-03T12:08:13Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=7d30add9-3e3c-44aa-aa19-89b3473c601d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-09-03T17:30:24Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 5f670178-6a28-4d47-b50b-eb56b0d07026
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25a21d77-68d3-4587-f1aa-08da8dd1fea6
x-ms-traffictypediagnostic: MW4PR12MB7240:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N6ESqPVUxX3TBx+GzS4eYpE0hG+tELCPViLtRbo49TBfMbY+0PwFR2GcMl5URWDKuLP3sP0vIv5GG1Ot/Q6PboUSY7/UkVYC4ZaV0jRGE6nc0Hy3G6eP9xPLi/ooDHs5pp9P4kb4AuZAcyXDtcTVmrilMPuUQ5kJQm8owQNQcWJS/SES/GYC31zsPANdq3eg2c8LNR9S2PkR48iT0C3UcPN9mt6s6Ba51y/SSRb5E+4LqTihOhM6KISBxg5x156ZEEOd7eBEUKPEV4qepUQGpUg21yLRDCKrUFfCKiQ9CA12mNVCsnhwl1ub6K9zXllXZdHaboCDlJCcrZlABTTBlFX/oFSomaPw050XK/9XJb5xJ4/3J1Xp3DbTPlmDOevDV2lN2RUiyhdzmRfBAjmqbL4YIqEy7MjMyidX0n9txmsNgV5N3mussRA6TIj6bDmRrhjcnd8saomiFidfWB7zhPYkzREQ1HzdA1oNmrXYMfTBeTS0/1I45Ip8rd2fSHjD7cCODfULFTVSFSoynKjD4u0iaMJtILP2uG2+w1JgO1JnPcaHMHkc+HIG9gjodh5izZJrK8lyZQhI8jeFXRAktwRytjwJH7zl+CaDL8CXAPeCUoLjVtQymeLZ2zDyBteFp56LEXWR005Pw95SSGsyh5rxRekt3YRZNbfEByu+PaUPsoDVmUujFffnsCYL77deNF3BL+rrOgVc2n0Oql9nTpKipKHjiSgHMdgbOczPYDnatDC60WCUU8PhEATpazl8EHH2xQ0Z/eUbhrsWNfjVtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(7416002)(66446008)(54906003)(52536014)(316002)(64756008)(5660300002)(66946007)(66476007)(66556008)(76116006)(4326008)(8676002)(71200400001)(86362001)(8936002)(478600001)(38070700005)(7406005)(41300700001)(6916009)(26005)(7696005)(38100700002)(6506007)(122000001)(9686003)(2906002)(55016003)(33656002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEhxM0N6OHg5QTJ2ekpLQThickdmTEFDUFB5VThGdkNkeDMzOWw3ZWcvbDMx?=
 =?utf-8?B?aDhGdTVCQmMwUUNmd0NLQVZVcG91UWI0NzYvZDZNNW5sREdzUUFJem9Bbmw5?=
 =?utf-8?B?VEF6VCtsa0VrSjJacHlLSVdEMlkxVEp0ZTh0TXdDd3RzZ3pzTGpmTEZzM3hR?=
 =?utf-8?B?Mzl4MXhxQ1BETjc2RFVOazMrb2pocXhFUDN5Mm96VnRIUUp6dzJjcklwNlZC?=
 =?utf-8?B?b0lDNjRsM01XT0h3OUFlenRzWTVtaTRTb3N6bzFWZVpUdXQzUE5HMXdENWkr?=
 =?utf-8?B?eFlqNTJPOElBdU9kZkxnU2hHamdtendnenJrK1luRXlqVUNxaEJZUCsvb2Zp?=
 =?utf-8?B?Y0ZBMDAySjZvWkQ3NU8reW0vWVpDcjdzZmd0bG8vODRFWEtEbEdrYWc4WFpp?=
 =?utf-8?B?aCtJbEFra09lZmJnVkNjejJGbVRIeDFzbFViWHVIajBTUHJsRFN5eEtrQTcy?=
 =?utf-8?B?RlRLUDlta1V2UkEyLy9UcXJHUGNNNW4ySHc4TSswajZ1VmxHVCt3UEdBbFN2?=
 =?utf-8?B?RFZ1M2lqcmNSd1ByNzNvcE5GNUp4QWVXUkdoK2J3WGU2cm1MR0I5dzg3c3F6?=
 =?utf-8?B?dHpoa3RHYWkyakp4MllEelRmcXk4MVNjY2J4TGtlM2lyaTJpb2tIUFlGcS8y?=
 =?utf-8?B?Wkx0dGRHQ1c1N0ZyeVhoMUdIK2ZXQW93SitETlptMHMyVmlNM2FmWndjZnBS?=
 =?utf-8?B?OEFqdkowTGFoYmlDbDRRWXM2Vlc0S2o3NmxiUC9BTVU2dnR1R2I2clMzQ1c3?=
 =?utf-8?B?bUlFd0ZuSmQzdG5pd1ZPdnY4UlJnU3FYZGVZR3pueVI5L0FFN0FicDVYRmJ3?=
 =?utf-8?B?ZUJjYmNFTmtVdzE4Rk1semJIdjRRUVlia1dhYkU2OVV6OWdLZldkdkNwRXMx?=
 =?utf-8?B?QzVNWlVIYS8wME5BUVJXV2tMWUhPcjlOL2RvWVdTbmtBNWhjRmpaWXQ0cFZR?=
 =?utf-8?B?TWo4Qk1zcmhaSzBWUGJrTU0zZTRocmlqVzJMMndpdXJMMzNKeTlxL3VDMmNO?=
 =?utf-8?B?clVRdjZkSVRFYlpZQzhnSFF6L0NyaEphcmNHMm4xc0VQSllVajlsNFY2QnpZ?=
 =?utf-8?B?bk9IakVNQ3U3Z3c3dit3NjlraExIc21DWEVlQjZEcHZUdjZKYWU3cW0vcHZC?=
 =?utf-8?B?VGZMR0w2NUVVdFR5TklSd0JmYUJzOUNIaS9Ia1ZZd3lqU2JqUU40OFF5OUV2?=
 =?utf-8?B?SVVxU2QvRUFsUEtWWlhIdW9kMUdLdjM1UUFCZmJnL3drY2xYbklsTjdTcmFw?=
 =?utf-8?B?OE10S3prN2kzU0ZaQzdLZGkyb1lNK2x1OVpBOEEzQSs3dHVlV3JHbjY3ZXB5?=
 =?utf-8?B?MXJvcXBET01ka3hGTk9hT2pvNjJ5OFYwSzd0R2NVQ3NkMEN6dUw2WTQrb3Az?=
 =?utf-8?B?WFlPTEJEd1RtS1VCR3JNZTRzbTIyZGR3c3BuR0lzbW1GOFc0dlRGRXV3SVpE?=
 =?utf-8?B?NDFybURZWFF3eVFwNWl4TjZQNGVpM0hCTWkycU5zMmRtUzl6akZicWJFMDVm?=
 =?utf-8?B?c3M2eWNSUzBtempLS0wrNWZrQjhjYzdWVjlYV0s1SWN3dFZoWjVOY3RCdit3?=
 =?utf-8?B?UHJzVEdpb09sUUc2SnR2ejIrblR6WFBFNVhiLzBob045MlN0Y1AyR2hrSWhX?=
 =?utf-8?B?dHd0VStpZ0xLTERXV3NoSktjaC9KSEp4NWRoVnZMMGpYWGZYMTdhZXRsQTVs?=
 =?utf-8?B?Yjd3OFhOU2lGUXNHRXRkVUN0VVJZSVVuQzlmUzlISEI5NmVoNWtyWHlIQzdx?=
 =?utf-8?B?eFY3TUJzdUt2TzhqWUliZ2QvcHhVVEhXd0NjR2d4SGtFaG5aWGdteVA2c1pi?=
 =?utf-8?B?TTlXbnpUa3ltQnhnTGhYdGZadmorV1JkblEwYkVta0l3Y0Z5bWZDTlNjOWJW?=
 =?utf-8?B?cXdqeGNFakh5dlBCR0dhVGgzdW1RMjBJQldscTdXVGRmNWN2V1NuVTBmd1Qy?=
 =?utf-8?B?ZjJwT2pWSkczNEx5TENOVnhQVFBtNU02R29RT0F2c254aFdQSllWaU56cTND?=
 =?utf-8?B?WFZqaFd6TXQ1Qm44UjVOYmZVdC9zWEJGZUZhbXdCNXFoZ0lEaDNTdUhwcTAy?=
 =?utf-8?B?NjdKb0xXSGh3VFROSlUxdUpnSFlxL3Y2U01UMytPTnlsbElKMVVOeFJ3NzhS?=
 =?utf-8?Q?Hwbg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25a21d77-68d3-4587-f1aa-08da8dd1fea6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2022 17:30:28.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mp9SAJo/4CUrmaU4JpLgp7XTzA3q7cfGM97Y95rp5y4+16HlD02XDskUDeyEtg1SmIWURqeqSpw6BhS90wSQtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7240
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIEJvcmlzLA0KDQo+PlNv
IGVzc2VudGlhbGx5IHdlIHdhbnQgdG8gbWFwIHRoZSBmYXVsdGluZyBhZGRyZXNzIHRvIGEgUk1Q
IGVudHJ5LCANCj4+Y29uc2lkZXJpbmcgdGhlIGZhY3QgdGhhdCBhIDJNIGhvc3QgaHVnZXBhZ2Ug
Y2FuIGJlIG1hcHBlZCBhcyA0SyBSTVAgdGFibGUgZW50cmllcyBhbmQgMUcgaG9zdCBodWdlcGFn
ZSBjYW4gYmUgbWFwcGVkIGFzIDJNIFJNUCB0YWJsZSBlbnRyaWVzLg0KDQo+U28gc29tZXRoaW5n
J3Mgc2VyaW91c2x5IGNvbmZ1c2luZyBvciBtaXNzaW5nIGhlcmUgYmVjYXVzZSBpZiB5b3UgZmF1
bHQgb24gYSAyTSBob3N0IHBhZ2UgYW5kIHRoZSB1bmRlcmx5aW5nIFJNUCBlbnRyaWVzIGFyZSA0
SyB0aGVuIHlvdSBjYW4gdXNlIHB0ZV9pbmRleCgpLg0KDQo+SWYgdGhlIGhvc3QgcGFnZSBpcyAx
RyBhbmQgdGhlIHVuZGVybHlpbmcgUk1QIGVudHJpZXMgYXJlIDJNLCBwbWRfaW5kZXgoKSBzaG91
bGQgd29yayBoZXJlIHRvby4NCg0KPkJ1dCB0aGlzIHBpZWNlbWVhbCBiYWNrJ24nZm9ydGggZG9l
c24ndCBzZWVtIHRvIHJlc29sdmUgdGhpcyBzbyBJJ2QgbGlrZSB0byBhc2sgeW91IHBscyB0byBz
aXQgZG93biwgdGFrZSB5b3VyIHRpbWUgYW5kIGdpdmUgYSBkZXRhaWxlZCBleGFtcGxlIG9mIHRo
ZSB0d28gcG9zc2libGUgY2FzZXMgYW5kIHdoYXQgdGhlIGRpZmZlcmVuY2UgaXMgYmV0d2VlbiBw
dGVfL3BtZF9pbmRleCBhbmQgeW91ciB3YXkuIEZlZWwgZnJlZSB0byA+YWRkIGFjdHVhbCBkZWJ1
ZyBvdXRwdXQgYW5kIHBhc3RlIGl0IGhlcmUuDQoNClRoZXJlIGlzIDEgNjQtYml0IFJNUCBlbnRy
eSBmb3IgZXZlcnkgcGh5c2ljYWwgNGsgcGFnZSBvZiBEUkFNLCBzbyBlc3NlbnRpYWxseSBldmVy
eSA0SyBwYWdlIG9mIERSQU0gaXMgcmVwcmVzZW50ZWQgYnkgYSBSTVAgZW50cnkuDQoNClNvIGV2
ZW4gaWYgaG9zdCBwYWdlIGlzIDFHIGFuZCB1bmRlcmx5aW5nIChzbWFzaGVkL3NwbGl0KSBSTVAg
ZW50cmllcyBhcmUgMk0sIHRoZSBSTVAgdGFibGUgZW50cnkgaGFzIHRvIGJlIGluZGV4ZWQgdG8g
YSA0SyBlbnRyeQ0KY29ycmVzcG9uZGluZyB0byB0aGF0Lg0KDQpJZiBpdCB3YXMgc2ltcGx5IGEg
Mk0gZW50cnkgaW4gdGhlIFJNUCB0YWJsZSwgdGhlbiBwbWRfaW5kZXgoKSB3aWxsIHdvcmsgY29y
cmVjdGx5Lg0KDQpDb25zaWRlcmluZyB0aGUgZm9sbG93aW5nIGV4YW1wbGU6IA0KDQphZGRyZXNz
ID0gMHg0MDIwMDAwMDsgDQpsZXZlbCA9IFBHX0xFVkVMXzFHOw0KcGZuICA9IDB4NDAwMDA7DQpw
Zm4gfD0gcG1kX2luZGV4KGFkZHJlc3MpOw0KVGhpcyB3aWxsIGdpdmUgdGhlIFJNUCB0YWJsZSBp
bmRleCBhcyAweDQwMDAxLg0KQW5kIGl0IHdpbGwgd29yayBpZiB0aGUgUk1QIHRhYmxlIGVudHJ5
IHdhcyBzaW1wbHkgYSAyTUIgZW50cnksIGJ1dCB3ZSBuZWVkIHRvIG1hcCB0aGlzIGZ1cnRoZXIg
dG8gaXRzIGNvcnJlc3BvbmRpbmcgNEsgZW50cnkuDQoNCldpdGggdGhlIHNhbWUgZXhhbXBsZSBh
cyBhYm92ZTogDQpsZXZlbCA9IFBHX0xFVkVMXzFHOw0KbWFzayA9IHBhZ2VzX3Blcl9ocGFnZShs
ZXZlbCkgLSBwYWdlc19wZXJfaHBhZ2UobGV2ZWwgLSAxKTsNCnBmbiB8PSAoYWRkcmVzcyA+PiBQ
QUdFX1NISUZUKSAmIG1hc2s7DQpUaGlzIHdpbGwgZ2l2ZSB0aGUgUk1QIHRhYmxlIGluZGV4IGFz
IDB4NDAyMDAuICAgICAgIA0KV2hpY2ggaXMgdGhlIGNvcnJlY3QgUk1QIHRhYmxlIGVudHJ5IGZv
ciBhIDJNQiBzbWFzaGVkL3NwbGl0IDFHIHBhZ2UgbWFwcGVkIGZ1cnRoZXIgdG8gaXRzIGNvcnJl
c3BvbmRpbmcgNEsgZW50cnkuDQoNCkhvcGVmdWxseSB0aGlzIGNsYXJpZmllcyB3aHkgcG1kX2lu
ZGV4KCkgY2FuJ3QgYmUgdXNlZCBoZXJlLg0KDQpUaGFua3MsDQpBc2hpc2ggICAgICAgIA0KICAg
ICAgICAgICAgICAgDQoNCg0K
