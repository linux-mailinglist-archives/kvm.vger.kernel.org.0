Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A49F8558B5B
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 00:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiFWWnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 18:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiFWWnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 18:43:43 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5AB31DEA;
        Thu, 23 Jun 2022 15:43:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9Rk+IXqIBu83xsPgo+gl42+crg0kapx/VnGc4I+Q23Tk7/qstsX3RJ51ylNOkSLfXZbUhvcKOHxm33a4RYKhttHhiuq+16KFwJ5iO9bhLKViA0vg6TBt4Y1e36ROh8tIMUu3GI4GgeSy60JOvl6xXB9CEGOr2rsjcefInK6+rZiswhjXfMfUyYrLzMDMFK/B6V4tnVJiKC+vG5AXMd+M6BBXS1jWv8A3jXCehrypoBKORiGSqcmY1phrj9/6WfvfTJBTHhYnqGoiQ6A+hdDLY2h7jAndKukQESBLJHMhjVXe/aZ9nAm5p0Qq3YrfnaRH+Hj0lSdhhA/3NNma70YYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmWTbC0XMAjcwz41kPAqWhcTQibAnsZakzkk9hsOPVQ=;
 b=kkXIjR1YxCqCbx2WVsmpfNwnu/w34c/lrgC1LJOd4HYG6r/Uwv6SV87aLitqlrcIQ2MxMpQHvcEizki9IwloEd0D+zmR5eouR0t7erHHhUZf5KMJ2O1MSZyR8rjhN7A7+ii1mvJjK9q452sP1QzQ2umWBIUjBNywGroLmM53GRC2RfRRmVxEruxFF3EXnaufQmSKCIcsVAvEP7qRN8UMPX81o7wRruvIO0XoWH+apMIoKWpHiVKenYjmOtAPyOYuAKpOXx6qaJEXgkFvSylXEREwPBZwOYB9CXGNUjSN4HJFyhDwHYPHhyKdUDJQ3L5L4Sw/bidkPO8Br64OrX4WYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmWTbC0XMAjcwz41kPAqWhcTQibAnsZakzkk9hsOPVQ=;
 b=etl/yJEcPtfKicuAXhWly0Rde/X1JlOkbRjZ4QnGYaREIYifOzsoV3STxZLXcmf3ENzHrtnAxqXP3gXCtvsbHfJ7CBFhBkrg4ZvmSkjL9rdt41ObOXXxn98GP5RmCppSho9bG/ybFPgcL4/4Hhbcap39APhw4sp2qqR7Iyyivm8=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM5PR12MB1337.namprd12.prod.outlook.com (2603:10b6:3:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 22:43:40 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::8953:6baa:97bb:a15d%7]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 22:43:40 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dave Hansen <dave.hansen@intel.com>,
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
Subject: RE: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Topic: [PATCH Part2 v6 05/49] x86/sev: Add RMP entry lookup helpers
Thread-Index: AQHYhkJMEjVRVcpx502HVSPCQUlAqK1bejcAgAACPYCAAD2E8IAAAkWAgAAEHtCAAALbAIAAEKeAgAACGACAAAZmMIABummAgAABGvA=
Date:   Thu, 23 Jun 2022 22:43:40 +0000
Message-ID: <SN6PR12MB276743CBEAD5AFE9033AFE558EB59@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <cc0c6bd1-a1e3-82ee-8148-040be21cad5c@intel.com>
 <BYAPR12MB2759A8F48D6D68EE879EEF648EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <25be3068-be13-a451-86d4-ff4cc12ddb23@intel.com>
 <BYAPR12MB27599BCEA9F692E173911C3B8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <681e4e45-eff1-600c-9b81-1fa9bdf24232@intel.com>
 <BYAPR12MB27595CF4328B15F0F9573D188EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <99d72d58-a9bb-d75c-93af-79d497dfe176@intel.com>
 <BYAPR12MB275984F14B1E103935A103D98EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <5db37cc2-4fb1-7a73-c39a-3531260414d0@intel.com>
 <BYAPR12MB2759AA368C8B6A5F1C31642F8EB29@BYAPR12MB2759.namprd12.prod.outlook.com>
 <YrTq3WfOeA6ehsk6@google.com>
In-Reply-To: <YrTq3WfOeA6ehsk6@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-06-23T22:40:10Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=5def7f6e-6548-47d6-9076-0224b55af496;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-06-23T22:43:38Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: fc99d3ee-b6fb-4b19-8b25-948f2aef7f76
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ae229b8-9ade-4605-21da-08da5569d18a
x-ms-traffictypediagnostic: DM5PR12MB1337:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXSIj1/bxNnVPiAFMiMSZq2JUs6G40bmdEU5wpBXqGAij6Bw1tGiPXkTnkB7PRE/9bTp6INMyfcAwfldTW7eNLkc+vn6mXOpq0paRzKLR3vWbR4KwJMEcTRogLwzEipuGqpnOURU0FeBbXRlmeZnrEsrksAsKfrVaBzgEs7sM903kCC5OOQRCl4/g0516GjcKV6DxdYMXjWVuAIF3CdLefRhyRsNuwDJnEyCctp6tPOhHXkAL2pR3Mtmmr1I57uXVFmxZccWT0efUBqusgP4QKqlbtGZIjo3snKRJUQXsfVLlz5hQyw+6Crl0/93sHpz7NjuiWUlsZFlaY7V3SLZOMNTAKh6W5xohXJniCL2qyBjnHFpTfD7aFiQopgMfPnVQsb0bkbW6hSr4HXWRXLVj0m7eZt4p/AjMuYtolDUhFoCQU7yXc2yCVzr9VKr8U7VtWVJu7QNdsVLGbqHnh2OIHAmmC5dhc63PNhSC2Gx9oLndiSWj+5BbLMj6YAFEBGFI3KD2CVL77/f3/dhscTsVynXMK3omOyGIQM74E4DGcnshnqGmU9RyRHs6VRHxn/Npi7Ahzau1BXh21iONT9hEgnL4LG+JrAJlo6OYxqvMV9xVBCt/Iauedn8+W9kEDTpkUX5BxNRpJG0KPevE35olKqy3Vp7HBDcAHgKQ8SicOBHoB86D5l+SN5HcM8gTAOBmiqtbMy5/2HoG7prsBrV9GsoHbbe3scIUHuWdnFfss3kf4JnNTRcKjVdqZjOLytY+DZy5suONfZ8bET4gk0fCiW0XjY0b2RQLlc16E6ks4Xc/Ex0Vz5hMmpsZRSj+WNy9rQj0gc3FhyBEHv0JQ74gw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(83380400001)(54906003)(26005)(9686003)(122000001)(316002)(38070700005)(86362001)(6506007)(186003)(38100700002)(478600001)(52536014)(8936002)(7416002)(2906002)(53546011)(4326008)(66446008)(66556008)(7406005)(7696005)(71200400001)(5660300002)(41300700001)(6916009)(8676002)(76116006)(45080400002)(966005)(66946007)(66476007)(64756008)(55016003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gZUIazP8sN2UXoqA1vAld9NbvTh/zZva1BXBPdrQwcHBVPYIqayscXrJumii?=
 =?us-ascii?Q?VN9feh7UH05om1PuuhRA09zJFzVUiiiGKdCx6w69Y47hhuari9c79RdaRuun?=
 =?us-ascii?Q?mSXbgB70qYkciCmCVmiSWxRB6XjlVtqsGCfVsHSl7bIva/z3VlqM+3KhYcIQ?=
 =?us-ascii?Q?YkyI6huIma+ZEFIkXqPKibxd4Qz8ImIldhddqvnI0Bt3mB48FT8ngUKTwHmG?=
 =?us-ascii?Q?y0cL3+aFAVzzK1u61ujSrOeuuWgx8lP7eVkr5Hig2pdvHBxplUlL1rr5ufwh?=
 =?us-ascii?Q?sWiTrtv+CUvZCzm/aub7QGfVxO9li6RteOFXvHPYFimC68KtwAdsTpe6X+ZB?=
 =?us-ascii?Q?hKegkcrFqhnMR+3OTys0MXyuNQNzlUSiS+k580y3nNpwIhUzEAcTVw30rd2I?=
 =?us-ascii?Q?5HXGrBAd2C6Z1QMKTLJd8fkfhDXcY97Eb4ZWJx/tfAcU1m/ovib3P6OnQRhx?=
 =?us-ascii?Q?qMiz3EiwXCom8530y00NDmD3H/rjWVEBfOt6hS5JatyD4eEIzMQDBRi7Cf1P?=
 =?us-ascii?Q?gEddvTBn4NKxsfLXVIlfvAeLn+sm3HJo4FcmF4vU+8KXAe6egoqSfrCvsqNZ?=
 =?us-ascii?Q?so5gRmGwBfQVNZpVxFye/ThGfSbmqDGE9WW+dPfyPG66zs2N0FXVtLGglGAi?=
 =?us-ascii?Q?dVqejfD6vvaP3eH9dbXWDlxyHe3P5O5sqh/oWAkBrlJ0IoSB1YGxIqmbqsyG?=
 =?us-ascii?Q?HgEz4gdwO9Z6sD//HVeK0xxgtu9wQXwcdw5gaRTNcH5Wa6VSxYzCGePWJaN7?=
 =?us-ascii?Q?Sdjy+l9j8ZRaD+si5aKHIysb3taZCKAi1/utXjZsjYt8moPcS0VT7dQPw2Dy?=
 =?us-ascii?Q?WK/KPrEgB/Gcht4EcSw9rBhYXaGjXvLxy9vqVlTCojBzVmmwtvKg6UDeyO1j?=
 =?us-ascii?Q?NDSxcS9fUup50yBycHr+I+HP9pRG6qRGYiDRNSRGBMD0gV0A9qSM60BudIJi?=
 =?us-ascii?Q?G0G9HsJfSfB5AHvtm/wvYxvqCCIzqg9EIcYN63+kRBYxMhWaggE9VEEZrziR?=
 =?us-ascii?Q?eajJ19ec28J90UDlqyxVf4BeAZF46nPHS7DrsmV8dESywBMnxln+0Ty5DV47?=
 =?us-ascii?Q?WSzvHgbgZOS/HhaJ4/TZgoVNsTe0mL14zTKcy4N9R42g5FEB0dnZmBVieCys?=
 =?us-ascii?Q?u4pq+nnXwSll9+b/eCIzNhWKS5lokQzwKKX1N2LTH71TfdsVkHMR2gyZzpCX?=
 =?us-ascii?Q?LswG8cdlzhNhTjNLXzeT/HkE9qapPfIz5R5JTiiVC123pABXlr3dxaQrlb1X?=
 =?us-ascii?Q?2Mnt+X+xlo/Bf9k2+fNH6F4a/UhEU5SE60vsass/aGcZw7mqSn5x2d+UBz1n?=
 =?us-ascii?Q?g/c3oUAzzIm2huIb0sGwBBOOnqNHzT8DDiuOTetIXnn5Pb1tdbu2cyconfnt?=
 =?us-ascii?Q?nRZxlKs/i3i40oiILzeJ1VOUZ9N43jN/wY/Ow+TjZ7umYU3hn4Ct8ZBbw639?=
 =?us-ascii?Q?moGV+S02TAAqN6JcuTjBnx4e/5Dk7bbHWQGUqKPtvQNeIEcXKQ95jAkpIRvE?=
 =?us-ascii?Q?jzFFeaKhvqwPLJr/KBdYK/vplG5m7kOH7bPvzh1Sp0gILTbxQn6n/gzzwQwE?=
 =?us-ascii?Q?r8mFnUJPUifJobxEXDs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ae229b8-9ade-4605-21da-08da5569d18a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 22:43:40.1608
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYjUSq3i0qIJldeq0pfrR4jv8nloZ2AvMZBiwt+QsvoBh3j4N7BUbUtT3alo8UaHtIvpTPGoqx9KEGpN0Ujm/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1337
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

>> On 6/22/22 12:43, Kalra, Ashish wrote:
>> >>> I think that needs to be fixed.  It should be as simple as a=20
>> >>> model/family check, though.  If someone (for example) attempts to=20
>> >>> use SNP (and thus snp_lookup_rmpentry() and dump_rmpentry()) code=20
>> >>> on a newer CPU, the kernel should refuse.
>> >> More specifically I am thinking of adding RMP entry field accessors=20
>> >> so that they can do this cpu model/family check and return the=20
>> >> correct field as per processor architecture.
>>=20
>> >That will be helpful down the road when there's more than one format. =
=20
>> >But, the real issue is that the kernel doesn't *support* a different RM=
P format.
>> >So, the SNP support should be disabled when encountering a=20
>> >model/family other than the known good one.
>>=20
>> Yes, that makes sense, will add an additional check in snp_rmptable_init=
().

>And as I suggested in v5[*], bury the microarchitectural struct in sev.c s=
o that nothing outside of the few bits of SNP code that absolutely need to =
know the layout of the struct should even be aware that there's a struct ov=
erlay for RMP entries.

Yes, that's a nice way to hide it from the rest of the kernel which does no=
t require access to this structure anyway, in essence, it becomes a private=
 structure.

Thanks,
Ashish

>[*] https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flo=
re.kernel.org%2Fall%2FYPCAZaROOHNskGlO%40google.com&amp;data=3D05%7C01%7CAs=
hish.Kalra%40amd.com%7Ce210ec383f654556348c08da5568ca81%>7C3dd8961fe4884e60=
8e11a82d994e183d%7C0%7C0%7C637916205851843411%7CUnknown%7CTWFpbGZsb3d8eyJWI=
joiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%=
7C&amp;sdata=3D6TOpchjhgFg%>2F5JTa%2FqSviiTuehNoZgvTVBuZv6JxsXc%3D&amp;rese=
rved=3D0
