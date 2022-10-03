Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DFC5F3210
	for <lists+kvm@lfdr.de>; Mon,  3 Oct 2022 16:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJCOis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Oct 2022 10:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJCOip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Oct 2022 10:38:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A524E615;
        Mon,  3 Oct 2022 07:38:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCDSLrTomzhoIPYI5Qz9p86sy2QvCQh5RGGw3REWEHJKBkakSXHmdUWinUjfAd7gAR5dBh1NUWley/8D2oHRVTrhiXBptc8X7rJURDbIodyRbhE3N4aHVzR0VjQZkL5cVtvg51ney4SVB7ycB1gBdjL63BqgT6E+nc9c+0xcVHATr7aJTmukl/sEosWDK/KOj2OfVwM4ziZkvYfBOcKwW21kiyfnSg6SxMCH12AsJsE7maav/V9SP5BU0nZYRW8W/YlW1hqO8Fph/5/e65FSPnJEIsz5ydwAIYFX3e1k2+y/c5qLAQie99GgnX9UOEvc5DyspS/2RGvF12pp2gfbvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRq3sLCvZw9hJNxdmXtsh0wRhJIztjSxDaNJRkomM5k=;
 b=XjsAsbvsHnY/+KjNfjW5gCZO/G+r9P7WA9IMm8j2RZicBBhnj7zVpA7s4ec2YGgMs3C/hrRlJZW/kkviX0hFCnG8hgNwcAfCEWNvPPuA3bRq7HzwPgeo2tfu/L8Vil205bw76YgJ4OkASS51pNF5+1B51DZsJSTMuhtGhImACC3SsAUDq2bj0BRc2bS3zPmF9uMo9/N8QaealsEBSUX8+wBIQR/CP4jVc+kCb41v16TyjdhYRrl4puCoylZ8c0A42Vh5u7A6uyAwqsTjRCMovok8fEjM8mUTLuaUQ8jkpwa9QanCIH9P01IeXoWCv3ApAjuXML/Q/RVvla2x1ej5aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRq3sLCvZw9hJNxdmXtsh0wRhJIztjSxDaNJRkomM5k=;
 b=SBH/ifRuI128FGoXXUc2JuFmw6ICaKsb74zj4+Z4w44Vc+tkh35aSQvqOTkkEE2dEmWeNcDnORzfSz6D/EelQzrMQHiPAIYkeeuIRFWRabp9h8dLRwfmPo4JCKMqSAZnSztMQsZso6ca5JycJprLWfAaElmGSR5u29TS+J5xtF4=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by IA1PR12MB7495.namprd12.prod.outlook.com (2603:10b6:208:419::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 3 Oct
 2022 14:38:42 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8588:d2f4:2eb9:7021%4]) with mapi id 15.20.5676.024; Mon, 3 Oct 2022
 14:38:42 +0000
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
Subject: RE: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Topic: [PATCH Part2 v6 13/49] crypto:ccp: Provide APIs to issue SEV-SNP
 commands
Thread-Index: AQHY1dLd4Juks83jB0yfjCsoLH1Lj638u9DQ
Date:   Mon, 3 Oct 2022 14:38:41 +0000
Message-ID: <SN6PR12MB2767062CAD241C0BAFB7FAD98E5B9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <a63de5e687c530849312099ee02007089b67e92f.1655761627.git.ashish.kalra@amd.com>
 <YzigaOHddWU706H5@zn.tnic>
In-Reply-To: <YzigaOHddWU706H5@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-10-03T14:23:40Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=6c9d99ab-8204-458e-b6ae-f52dc09a2107;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-10-03T14:38:39Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 2f4894f9-e22c-41f3-923d-52071c9dd7a4
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR12MB2767:EE_|IA1PR12MB7495:EE_
x-ms-office365-filtering-correlation-id: debf990d-b16e-483f-d3a4-08daa54cf7db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XFyyvnnxmgBE1MGIAEh9TrzckZXV7Fut5B2ZztzYgRV3q5bRXpTeoWUQRodlivmkWdpkIYbhedzBX+XMHIRO9/2oaUyKlQLbSfnhW+KLxDlH2RxrWWglGp7cUZZgbFwsRFvbLbFpVbtvZvOFk3QVT/Ihp997mYAmEA9/N0IltCSGuT5/EG8TijdG7BPyvD+gavszLma8qyOUMYgQMhIOiLTjIxG7V8ZlZ3z+GO/ybvhEXs/G75nZtfyFssbwR+jLBsUof7vRvvQIUoxOEBlDqSFmPkgB9RsxgVf2hY+1oUDaHC2+5Uya5zYTZO0clKJraDPshqq/28n3W53taeG2FO9xMA4dCr897lDzgigzedKtgRGfjs+2rniGXcpW8rg8JLb4UZtwzV20U3OV/VORu7STd8OfpO4bOqJR17k4AyaE0l5ZL7rXaA2UmU2i36SV9QpT0SXgxwb14MHwo7CZqYOpI6Uxv/qZwar8Dff5WxkN6N+5ElHttAuzsws1Xxxo/h5LFBzEc79fmGN9+VeqIhF2qaKP/aa3+vkL/A1RvaJRF6nmMXJzuoNXsRKA/EUk7Eva55XcoT2PLGfhNNAuhETWBuduBkWIlDbRT2EA8b7UVXbQUPqhf8n0D8IXRunNKHnqKcee4jfpUviwJf9FwQ0K+fuh026gndUUl9f1oYUMcphk8swH9higykqwlB3ysSPIL3UDEIEQHXvIMCy7yR9gbKjFrpPWAWbiX7mJX/TK1g5NXqVBtcnF2MyWIjpvi0EjaJU+6H5oHWbh/J7cUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(451199015)(66946007)(33656002)(5660300002)(66556008)(83380400001)(52536014)(38100700002)(66476007)(7406005)(38070700005)(2906002)(122000001)(86362001)(26005)(478600001)(186003)(41300700001)(64756008)(6506007)(9686003)(4326008)(7416002)(76116006)(7696005)(66446008)(71200400001)(316002)(8676002)(55016003)(6916009)(54906003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?crf7EkXiTgFbX2KtyqY2CMirIBQgcr96YmHxfNJM/8UVC4aQ7AgB4H9Zak6v?=
 =?us-ascii?Q?Ch4vgSQbpkwpjhluAe5mqncD2DVM1eEKrHaqPggTu1chtqsnnaG/7OfVSNA1?=
 =?us-ascii?Q?3TfVvZH1kF1rY127Xj8OXOG/v7+Vgmj0jqW1O9Z6VsmoXABuoCrTxA2Bgiuy?=
 =?us-ascii?Q?gNteCRNJCwc5Mr44EJLjsXXsR6Sbu3uvHIwFMkiMikoRYNF8zOj+/WwVuHVB?=
 =?us-ascii?Q?k4TI57OUCVCG8aw9oa6TR5b3MGx3egf0oSb9d1g4TnH1Ti2mrvzDA1HslXu+?=
 =?us-ascii?Q?7+984bBYlXoA8Gc4Vc7xFO4pu9aUwFZSJK6LlpOiSAqlFFzMADRJAYQrAADi?=
 =?us-ascii?Q?MXGxwKyrHD62bJYyjhek9U5LXRRJ8BYUbc+R9P+toZKsUQoLhQeJ2ZYKqnXc?=
 =?us-ascii?Q?dtjOty8nhPFQ/Ny+LqO6//1Nkg3bWfLwXOEOi/3VRUBr05tE02sLDVzf4FO0?=
 =?us-ascii?Q?zegobpmsWV1twFjRF5ltYahAYgso57w/a++HGpzt+E2bPqORiWEuWy3c/16Z?=
 =?us-ascii?Q?mAwwkFnoS8HMT/2H3nu55IrKtP0H49jN8r+uwTXniS3sdB884eB9QNk9Tlbo?=
 =?us-ascii?Q?mjvDoQQxwsFdLlAGFPDOiX6V5mnAiLtDkP71dJuiyrEjKphVVqNRW1pLxs+1?=
 =?us-ascii?Q?vtg6tnV5A+sGoEKJc6dq0AAaQ1L3EzzH0TZ/8nWvxiOAGOSQL229oCYpp5Qc?=
 =?us-ascii?Q?iBoaDatIQf9VWlDEewn7BuyUJtzffTYN0uSINlScX49u41r7JPWFGd+n1AeL?=
 =?us-ascii?Q?UX5BJQPhyTDbr31b8jOr5qFrmAGT1FO70gnlrDMEGSFGl4TBPSDHKqGyJ0mB?=
 =?us-ascii?Q?aPG6pkTiP4PT9MJDb+5EmRO+T42OUqnIH0I970U4h0ouyMge4IiUyVeZKgAQ?=
 =?us-ascii?Q?0DZrhnbpkYKs019ra+Px2H+BmkktubKVOcysDgCDYB5nfTWnTAcu7slwlaWi?=
 =?us-ascii?Q?fh+t4o82YwYj/K9XT7bRCdJnyMTErUytGQ5k9wevhGRy8Ncz5lym7vgB82BR?=
 =?us-ascii?Q?dUTSznQjkhp8dcpETvwe28D4OTMzEuYYZeCsmZnyq5JAKHfA5nSTLqSHX0Gv?=
 =?us-ascii?Q?BmeMVTotn5HNyb5bp/TszINuM5yvlQcTOrb4TBAHzq0InHajTBJTxIK6PJ9h?=
 =?us-ascii?Q?bbqVLTXvnJDoe+VRGCqIHpmDIaBLrC+see/4Zip+f/CSBk5aUIN0PbOzLLH+?=
 =?us-ascii?Q?DIeHy1BefgaGfkeZ/LtDLEITnLxH675+JsANHLo2cB0UWMU9D9hTFiLF6d4i?=
 =?us-ascii?Q?PCzw1R/DTKXa9bKz0xQ1Ee3qr+k/u+vInkuIujbxYN3Ie5EpfJDE5t2Nm6Cy?=
 =?us-ascii?Q?vzKYCI68UNfaSDLT0Ivpc0bTfHOu3qF8WncPtP2IK9frJkaxfreAT7qFDLyx?=
 =?us-ascii?Q?Vej+EweaheUCBvH09H80iim+0zGvFu0KF5sS3ZWLZzd/WjYobIMg/m2y0Oqc?=
 =?us-ascii?Q?3cvT6/xbdeulHTfaMsFt4WZmXx4RnjJjqeosrZlldaD7raVvUM9dft14/waA?=
 =?us-ascii?Q?7FDC3xUyGlWNa5IQcnSR8Syijr6eJXTS6Ysj2BndUNfj8cWRHZeoQfeAC0p1?=
 =?us-ascii?Q?2Csc8xkaJrx4wfYfwNg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: debf990d-b16e-483f-d3a4-08daa54cf7db
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 14:38:42.0354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taqll9eGHzbMKcHUBsQ1smMa2yRwIes1TdcwnFGyTZb20FP32YHXU8ZHKiL1RTpEwuGaq1pAQqHjmkY4XwelQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7495
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

>> +int snp_guest_decommission(struct sev_data_snp_decommission *data,=20
>> +int *error) {
>> +	return sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, data, error); }=20
>> +EXPORT_SYMBOL_GPL(snp_guest_decommission);
>> +
>> +int snp_guest_df_flush(int *error)
>> +{
>> +	return sev_do_cmd(SEV_CMD_SNP_DF_FLUSH, NULL, error); }=20
>> +EXPORT_SYMBOL_GPL(snp_guest_df_flush);
>> +
>> +int snp_guest_page_reclaim(struct sev_data_snp_page_reclaim *data,=20
>> +int *error) {
>> +	return sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, data, error); }=20
>> +EXPORT_SYMBOL_GPL(snp_guest_page_reclaim);
>> +
>> +int snp_guest_dbg_decrypt(struct sev_data_snp_dbg *data, int *error)=20
>> +{
>> +	return sev_do_cmd(SEV_CMD_SNP_DBG_DECRYPT, data, error); }=20
>> +EXPORT_SYMBOL_GPL(snp_guest_dbg_decrypt);

>So this mindless repetition is getting annoying. I see ~70 SEV commands.
>Adding ~70 functions which parrot all the same call to sev_do_cmd() is jus=
t insane.

>I think you should simply export sev_do_cmd() and call it instead.

>Yes, when it turns out that a command and the preparation to issue it befo=
re it starts repeating pretty often, you could do a helper. But adding thos=
e silly wrappers doesn't bring anything besides confusion and code bloat.

There are actually only 8 functions in total which are simply calling sev_d=
o_cmd(), all other functions calling sev_do_cmd() have a lot of other speci=
fic functionality in them.

Those are the earlier - sev_platform_status(), sev_guest_deactivate(), sev_=
guest_decomission() and sev_guest_df_flush().

And the 4 functions added in this patch - snp_guest_decomission(), snp_gues=
t_df_flush(), snp_guest_page_reclaim(), and snp_guest_dbg_decrypt().=20

Thanks,
Ashish
